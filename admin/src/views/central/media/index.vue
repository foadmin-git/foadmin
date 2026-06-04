<!-- src/views/central/media/index.vue -->
<template>
  <div class="h-full flex gap-3">
    <!-- 左侧目录 -->
    <el-card class="w-72">
      <template #header>
        <div class="flex items-center justify-between">
          <span>目录</span>
          <div class="flex gap-1" v-perm="'media:dir'">
            <el-button size="small" @click="openDirEdit()" v-demo-disable>新增</el-button>
          </div>
        </div>
      </template>
      <el-input v-model="dirKw" placeholder="搜索目录" size="small" class="mb-2" clearable />
      <el-tree
        ref="dirTreeRef"
        :data="dirTree"
        node-key="id"
        :props="{ label: 'name', children: 'children' }"
        default-expand-all
        highlight-current
        :filter-node-method="dirFilter"
        @node-click="onDirClick"
      >
        <template #default="{ data }">
          <div class="flex items-center w-full">
            <el-icon class="mr-2" :size="20">
              <folder />
            </el-icon>
            <span class="flex-1">{{ data.name }}</span>
            <div class="flex gap-1" v-perm="'media:dir'">
              <el-button link size="small" @click.stop="openDirEdit(data)" v-demo-disable>改</el-button>
              <el-button link size="small" type="danger" @click.stop="delDir(data)" v-demo-disable>删</el-button>
            </div>
          </div>
        </template>
      </el-tree>
    </el-card>

    <!-- 右侧文件 -->
    <div class="flex-1 flex flex-col min-w-0">
      <div class="flex items-center gap-2 mb-2">
        <el-input v-model="kw" placeholder="搜索文件名" clearable class="w-80" @keyup.enter.native="loadFiles" />
        <el-select v-model="withDeleted" class="w-40" @change="loadFiles">
          <el-option :value="0" label="只显示未删除" />
          <el-option :value="1" label="包含已删除" />
        </el-select>

        <!-- 标签筛选（多选 任意匹配） -->
        <el-select
          v-model="filterTagNames"
          multiple
          clearable
          collapse-tags
          placeholder="按标签筛选"
          class="min-w-64"
          @change="loadFiles"
        >
          <el-option
            v-for="t in allTags"
            :key="t.id"
            :label="`${t.name} (${t.count})`"
            :value="t.name"
          />
        </el-select>

        <el-button type="primary" v-perm="'media:upload'" v-demo-disable :disabled="uploading" class="hidden">
          <el-upload
            :show-file-list="false"
            :http-request="onUpload"
            :data="{ dir_id: currentDirId, tags: uploadTagsInput || undefined }"
            :disabled="uploading"
            multiple
          >
            上传
          </el-upload>
        </el-button>
        <el-input v-model="uploadTagsInput" placeholder="上传标签，逗号分隔" class="w-56" clearable />
        <el-button @click="loadFiles">刷新</el-button>
        <el-button @click="showTagManager = true" v-demo-disable>标签管理</el-button>
        
        <!-- 批量操作按钮 -->
        <template v-if="selectedIds.length > 0">
          <el-tag type="info" class="ml-2">已选择 {{ selectedIds.length }} 项</el-tag>
          <el-button size="small" type="warning" @click="batchSoftDelete" v-perm="'media:delete'" v-demo-disable>
            批量软删
          </el-button>
          <el-button size="small" type="danger" @click="batchHardDelete" v-perm="'media:delete'" v-demo-disable>
            批量硬删
          </el-button>
          <el-button size="small" type="success" @click="batchRestore" v-perm="'media:delete'" v-demo-disable>
            批量还原
          </el-button>
          <el-button size="small" @click="showMoveDialog" v-perm="'media:upload'" v-demo-disable>
            批量移动
          </el-button>
        </template>
      </div>

      <!-- 上传进度条 -->
      <div v-show="uploading" class="mb-2">
        <el-progress
          :percentage="uploadPercent"
          :stroke-width="4"
          :show-text="true"
          class="upload-progress"
        />
      </div>

      <!-- 拖拽上传区域（可收起/展开） -->
      <div class="mb-3">
        <div 
          class="flex items-center justify-between px-4 py-2 bg-gray-100 rounded-t-lg border border-gray-300 cursor-pointer hover:bg-gray-200 transition-colors"
          @click="showUploadArea = !showUploadArea"
        >
          <div class="flex items-center gap-2">
            <el-icon :size="16" color="#6b7280">
              <component :is="showUploadArea ? 'ArrowDown' : 'ArrowRight'" />
            </el-icon>
            <span class="text-sm font-medium text-gray-700">上传文件</span>
          </div>
          <el-icon :size="16" color="#6b7280">
            <component :is="showUploadArea ? 'ArrowUp' : 'ArrowDown'" />
          </el-icon>
        </div>
        
        <div v-show="showUploadArea" class="border border-gray-300 border-t-0 rounded-b-lg">
          <div 
            class="p-8 border-2 border-dashed border-gray-300 m-3 rounded-lg text-center bg-gray-50 hover:bg-blue-50 hover:border-blue-400 transition-colors cursor-pointer"
            @click="triggerFileInput"
            @dragover.prevent
            @drop.prevent="handleDropOnArea"
          >
            <el-icon :size="48" color="#9ca3af" class="mb-2"><upload-filled /></el-icon>
            <p class="text-gray-600 text-base font-medium">拖拽文件到此处上传</p>
            <p class="text-gray-400 text-sm mt-1">或点击选择文件，支持批量上传</p>
            <input 
              ref="fileInputRef"
              type="file" 
              multiple 
              class="hidden"
              @change="handleFileSelect"
            />
          </div>
        </div>
      </div>

      <el-table 
        :data="rows" 
        border 
        @selection-change="handleSelectionChange"
        ref="tableRef"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column label="预览" width="120">
          <template #default="{ row }">
            <template v-if="row.mime?.startsWith('image/')">
              <el-image
                :src="preview(row)"
                :preview-src-list="[preview(row)]"
                fit="cover"
                style="width: 64px; height: 64px; border-radius: 6px;"
                preview-teleported
              />
            </template>
            <template v-else-if="row.mime?.startsWith('video/')">
              <video :src="preview(row)" style="width: 96px; height: 64px; object-fit: cover;" controls />
            </template>
            <template v-else>
              <el-tag type="info">{{ row.ext?.toUpperCase() || 'FILE' }}</el-tag>
            </template>
          </template>
        </el-table-column>
        <el-table-column prop="filename" label="文件名" min-width="200" />
        <el-table-column prop="mime" label="类型" width="160" />
        <el-table-column label="大小" width="120">
          <template #default="{ row }">{{ prettySize(row.size) }}</template>
        </el-table-column>
        <el-table-column prop="created_at" label="上传时间" width="180">
          <template #default="{ row }">{{ formatTime(row.created_at) }}</template>
        </el-table-column>
        <el-table-column label="标签" min-width="220">
          <template #default="{ row }">
            <template v-if="row.tags?.length">
              <el-space wrap>
                <el-tag
                  v-for="(tg, idx) in row.tags"
                  :key="idx"
                  type="success"
                  size="small"
                >{{ tg }}</el-tag>
              </el-space>
            </template>
            <template v-else>
              <el-text type="info">-</el-text>
            </template>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="360">
          <template #default="{ row }">
            <el-button size="small" @click="download(row)">下载</el-button>
            
            <!-- 未删除文件：显示软删除和硬删除 -->
            <template v-if="!row.deleted_at">
              <el-popconfirm 
                title="确认软删除？（仅标记删除，可恢复）" 
                @confirm="softDelFile(row)"
              >
                <template #reference>
                  <el-button size="small" type="warning" v-perm="'media:delete'" v-demo-disable>软删</el-button>
                </template>
              </el-popconfirm>
              
              <el-popconfirm 
                title="确认硬删除？（删除数据库和文件，不可恢复！）" 
                @confirm="hardDelFile(row)"
              >
                <template #reference>
                  <el-button size="small" type="danger" v-perm="'media:delete'" v-demo-disable>硬删</el-button>
                </template>
              </el-popconfirm>
            </template>
            
            <!-- 已删除文件：显示恢复和硬删除 -->
            <template v-else>
              <el-button size="small" type="success" @click="restore(row)" v-perm="'media:delete'" v-demo-disable>还原</el-button>
              <el-popconfirm 
                title="确认永久删除？（不可恢复！）" 
                @confirm="hardDelFile(row)"
              >
                <template #reference>
                  <el-button size="small" type="danger" v-perm="'media:delete'" v-demo-disable>永久删除</el-button>
                </template>
              </el-popconfirm>
            </template>
            
            <el-button size="small" @click="rename(row)" v-perm="'media:rename'" v-demo-disable>重命名</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="mt-2 flex justify-end">
        <el-pagination
          background
          layout="prev, pager, next, jumper, total"
          :total="total"
          v-model:current-page="page"
          v-model:page-size="size"
          @current-change="loadFiles"
          @size-change="loadFiles"
        />
      </div>
    </div>

    <!-- 目录编辑弹窗 -->
    <el-dialog v-model="showDirEdit" :title="dirForm.id ? '编辑目录' : '新增目录'">
      <el-form :model="dirForm" label-width="80">
        <el-form-item label="名称"><el-input v-model="dirForm.name" /></el-form-item>
        <el-form-item label="上级">
          <el-tree-select
            v-model="dirForm.parent_id"
            :data="dirTree"
            node-key="id"
            :props="{ label: 'name', children: 'children' }"
            check-strictly
            clearable
            placeholder="（顶级）"
            class="w-full"
          />
        </el-form-item>
        <el-form-item label="排序"><el-input-number v-model="dirForm.sort" :min="0" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showDirEdit = false">取消</el-button>
        <el-button type="primary" @click="saveDir" v-demo-disable>保存</el-button>
      </template>
    </el-dialog>

    <!-- 重命名弹窗 -->
    <el-dialog v-model="showRename" title="重命名">
      <el-input v-model="renameText" />
      <template #footer>
        <el-button @click="showRename = false">取消</el-button>
        <el-button type="primary" @click="doRename" v-demo-disable>保存</el-button>
      </template>
    </el-dialog>

    <!-- 批量移动弹窗 -->
    <el-dialog v-model="showMove" title="批量移动" width="500px">
      <el-form>
        <el-form-item label="目标目录">
          <el-tree-select
            v-model="moveDirId"
            :data="dirTree"
            node-key="id"
            :props="{ label: 'name', children: 'children' }"
            check-strictly
            clearable
            placeholder="（移动到顶级）"
            class="w-full"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showMove = false">取消</el-button>
        <el-button type="primary" @click="doBatchMove" v-demo-disable>确定移动</el-button>
      </template>
    </el-dialog>

    <!-- 标签管理弹窗 -->
    <el-dialog v-model="showTagManager" title="标签管理" width="600px">
      <div class="mb-4">
        <el-button type="primary" size="small" @click="showAddTag = true">新增标签</el-button>
        <el-button size="small" @click="loadTags">刷新</el-button>
      </div>
      <el-table :data="allTags" border size="small">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="标签名" />
        <el-table-column prop="count" label="文件数" width="100" />
        <el-table-column label="操作" width="100">
          <template #default="{ row }">
            <el-button 
              size="small" 
              type="danger" 
              @click="deleteTag(row)"
              :disabled="row.count > 0"
              v-demo-disable
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <!-- 新增标签 -->
      <el-dialog v-model="showAddTag" title="新增标签" width="400px" append-to-body>
        <el-input v-model="newTagName" placeholder="请输入标签名称" />
        <template #footer>
          <el-button @click="showAddTag = false">取消</el-button>
          <el-button type="primary" @click="createTag" v-demo-disable>创建</el-button>
        </template>
      </el-dialog>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, watchEffect, onUnmounted } from 'vue'
import { mediaDirs, mediaFiles, uploadMedia, mediaTags } from '@/api/media'
import { ElMessage, ElMessageBox } from 'element-plus'
import dayjs from 'dayjs'

// 使用 SHA256 防止 ID 遍历攻击
const preview = (row) => mediaFiles.previewUrl(row.sha256)
const dirTreeRef = ref()
const tableRef = ref()
const fileInputRef = ref()
const dirTree = ref([])
const dirKw = ref('')

const currentDirId = ref(null)

const kw = ref('')
const withDeleted = ref(0)
const rows = ref([])
const total = ref(0)
const page = ref(1)
const size = ref(10)

const allTags = ref([])            // [{id,name,count}]
const filterTagNames = ref([])     // 多选筛选
const uploadTagsInput = ref('')    // 上传时附带标签

// 上传进度
const uploading = ref(false)
const uploadPercent = ref(0)

// 批量选择
const selectedIds = ref([])
const selectedRows = ref([])

// 拖拽上传区域显示控制
const showUploadArea = ref(true) // 默认展开

// 批量移动
const showMove = ref(false)
const moveDirId = ref(null)

// 标签管理
const showTagManager = ref(false)
const showAddTag = ref(false)
const newTagName = ref('')

function dirFilter(val, data){
  if (!val) return true
  return data.name?.toLowerCase().includes(val.toLowerCase())
}

watchEffect(() => dirTreeRef.value?.filter(dirKw.value))

async function loadDirs() {
  const { items } = await mediaDirs.list()
  dirTree.value = items || []
}

async function loadTags() {
  const { items } = await mediaTags.list()
  allTags.value = items || []
}

function onDirClick(node) { currentDirId.value = node.id; page.value = 1; loadFiles() }

async function loadFiles() {
  const params = {
    kw: kw.value || undefined,
    dir_id: currentDirId.value || undefined,
    page: page.value,
    size: size.value,
    with_deleted: withDeleted.value
  }
  if (filterTagNames.value?.length) {
    params.tags = filterTagNames.value.join(',')
  }
  const { items, total: t } = await mediaFiles.list(params)
  rows.value = items
  total.value = t
}

function prettySize(n) {
  if (n == null) return '-'
  const u = ['B', 'KB', 'MB', 'GB', 'TB']
  let i = 0
  let v = n
  while (v >= 1024 && i < u.length - 1) { v /= 1024; i++ }
  return `${v.toFixed(i ? 1 : 0)} ${u[i]}`
}

function formatTime(t) { return t ? dayjs(t).format('YYYY-MM-DD HH:mm') : '-' }

async function onUpload({ file, data }) {
  uploading.value = true
  uploadPercent.value = 0
  try {
    await uploadMedia({
      file,
      data,
      onProgress: (p) => { uploadPercent.value = p }
    })
    loadFiles()
    loadTags()
  } finally {
    uploading.value = false
  }
}

function download(row) {
  // 使用 SHA256 防止 ID 遍历攻击
  window.open(mediaFiles.downloadUrl(row.sha256), '_blank')
}

// 软删除文件（仅标记删除，可恢复）
async function softDelFile(row) {
  await mediaFiles.softDelete(row.id)
  loadFiles()
}

// 硬删除文件（删除数据库和物理文件，不可恢复）
async function hardDelFile(row) {
  await mediaFiles.hardDelete(row.id)
  loadFiles()
}

async function restore(row) {
  await mediaFiles.restore(row.id)
  loadFiles()
}

/* 目录编辑 */
const showDirEdit = ref(false)
const dirForm = reactive({ id: null, name: '', parent_id: null, sort: 0 })
function openDirEdit(row) {
  if (row) {
    Object.assign(dirForm, { id: row.id, name: row.name, parent_id: row.parent_id ?? null, sort: row.sort ?? 0 })
  }
  else {
    Object.assign(dirForm, { id: null, name: '', parent_id: currentDirId.value ?? null, sort: 0 })
  }
  showDirEdit.value = true
}

async function saveDir() {
  if (dirForm.id) await mediaDirs.update(dirForm.id, dirForm)
  else await mediaDirs.create(dirForm)
  showDirEdit.value = false
  await loadDirs()
}

async function delDir(row) {
  await mediaDirs.remove(row.id)
  await loadDirs()
}

/* 重命名 */
const showRename = ref(false)
const renameRow = ref(null)
const renameText = ref('')
function rename(row) { renameRow.value = row; renameText.value = row.filename; showRename.value = true }
async function doRename() {
  await mediaFiles.rename(renameRow.value.id, renameText.value)
  showRename.value = false
  loadFiles()
}

/* 批量操作 */
function handleSelectionChange(selection) {
  selectedRows.value = selection
  selectedIds.value = selection.map(row => row.id)
}

async function batchSoftDelete() {
  if (selectedIds.value.length === 0) return
  await ElMessageBox.confirm(`确认软删除选中的 ${selectedIds.value.length} 个文件？`, '提示', {
    type: 'warning'
  })
  await mediaFiles.batchSoftDelete(selectedIds.value)
  ElMessage.success('批量软删除成功')
  tableRef.value?.clearSelection()
  loadFiles()
}

async function batchHardDelete() {
  if (selectedIds.value.length === 0) return
  await ElMessageBox.confirm(`确认硬删除选中的 ${selectedIds.value.length} 个文件？此操作不可恢复！`, '警告', {
    type: 'error'
  })
  await mediaFiles.batchHardDelete(selectedIds.value)
  ElMessage.success('批量硬删除成功')
  tableRef.value?.clearSelection()
  loadFiles()
}

async function batchRestore() {
  if (selectedIds.value.length === 0) return
  await mediaFiles.batchRestore(selectedIds.value)
  ElMessage.success('批量还原成功')
  tableRef.value?.clearSelection()
  loadFiles()
}

function showMoveDialog() {
  if (selectedIds.value.length === 0) return
  moveDirId.value = null
  showMove.value = true
}

async function doBatchMove() {
  await mediaFiles.batchMove(selectedIds.value, moveDirId.value)
  ElMessage.success(`成功移动 ${selectedIds.value.length} 个文件`)
  showMove.value = false
  tableRef.value?.clearSelection()
  loadFiles()
}

/* 标签管理 */
async function createTag() {
  if (!newTagName.value.trim()) {
    ElMessage.warning('标签名不能为空')
    return
  }
  await mediaTags.create(newTagName.value)
  ElMessage.success('标签创建成功')
  showAddTag.value = false
  newTagName.value = ''
  await loadTags()
}

async function deleteTag(row) {
  if (row.count > 0) {
    ElMessage.warning('该标签正在被文件使用，无法删除')
    return
  }
  await ElMessageBox.confirm(`确认删除标签"${row.name}"？`, '提示', {
    type: 'warning'
  })
  await mediaTags.remove(row.id)
  ElMessage.success('标签删除成功')
  await loadTags()
}

/* 拖拽上传 */
function triggerFileInput() {
  fileInputRef.value?.click()
}

async function handleFileSelect(e) {
  const files = Array.from(e.target.files)
  if (files.length === 0) return
  
  // 清空input值，允许重复选择同一文件
  e.target.value = ''
  
  await uploadFiles(files)
}

async function handleDropOnArea(e) {
  const files = Array.from(e.dataTransfer.files)
  if (files.length === 0) return
  
  await uploadFiles(files)
}

async function uploadFiles(files) {
  uploading.value = true
  uploadPercent.value = 0
  
  try {
    for (let i = 0; i < files.length; i++) {
      const file = files[i]
      await uploadMedia({
        file,
        data: { dir_id: currentDirId.value, tags: uploadTagsInput.value || undefined },
        onProgress: (p) => { 
          // 计算总体进度
          uploadPercent.value = Math.round(((i + p / 100) / files.length) * 100)
        }
      })
    }
    ElMessage.success(`成功上传 ${files.length} 个文件`)
    loadFiles()
    loadTags()
  } catch (error) {
    ElMessage.error('上传失败：' + (error.message || '未知错误'))
  } finally {
    uploading.value = false
    uploadPercent.value = 0
  }
}

// 挂载和卸载拖拽事件
onMounted(async () => {
  await loadDirs()
  await loadTags()
  await loadFiles()
})

onUnmounted(() => {
  // 清理工作（如果需要）
})
</script>

<style scoped>
/* 上传进度条 - 直角无圆角 */
:deep(.upload-progress .el-progress-bar__outer) {
  border-radius: 0;
}
:deep(.upload-progress .el-progress-bar__inner) {
  border-radius: 0;
}
</style>

