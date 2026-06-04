<!--src\components\MediaPicker\index.vue-->
<template>
  <el-dialog
    v-model="visible"
    title="选择媒体"
    width="80vw"
    top="5vh"
    append-to-body
    destroy-on-close
  >
    <div class="flex gap-3">
      <!-- 左侧目录 -->
      <el-card class="w-72">
        <template #header>
          <div class="flex items-center justify-between">
            <span>目录</span>
            <el-button size="small" @click="openDirEdit" v-perm="'media:dir'">新增</el-button>
          </div>
        </template>
        <el-input
          v-model="dirKw"
          placeholder="搜索目录"
          size="small"
          clearable
          class="mb-2"
        />
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
                <el-button link size="small" @click.stop="openDirEdit(data)">改</el-button>
                <el-button link size="small" type="danger" @click.stop="delDir(data)">删</el-button>
              </div>
            </div>
          </template>
        </el-tree>
      </el-card>

      <!-- 右侧文件 -->
      <div class="flex-1 min-w-0">
        <div class="flex items-center gap-2 mb-2">
          <el-input
            v-model="kw"
            placeholder="搜索文件名"
            clearable
            class="w-80"
            @keyup.enter="loadFiles"
          />
          <el-select v-model="withDeleted" class="w-40" @change="loadFiles">
            <el-option :value="0" label="只显示未删除" />
            <el-option :value="1" label="包含已删除" />
          </el-select>

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

          <el-button type="primary" v-perm="'media:upload'" :disabled="uploading" class="hidden">
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
          
          <!-- 批量操作按钮 -->
          <template v-if="selectedFiles.length > 0">
            <el-tag type="info" class="ml-2" size="small">已选择 {{ selectedFiles.length }} 项</el-tag>
            <el-button size="small" @click="handleConfirm" type="primary">
              确认选择({{ selectedFiles.length }})
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
            class="flex items-center justify-between px-3 py-2 bg-gray-100 rounded-t-lg border border-gray-300 cursor-pointer hover:bg-gray-200 transition-colors"
            @click="showUploadArea = !showUploadArea"
          >
            <div class="flex items-center gap-2">
              <el-icon :size="14" color="#6b7280">
                <component :is="showUploadArea ? 'ArrowDown' : 'ArrowRight'" />
              </el-icon>
              <span class="text-xs font-medium text-gray-700">上传文件</span>
            </div>
            <el-icon :size="14" color="#6b7280">
              <component :is="showUploadArea ? 'ArrowUp' : 'ArrowDown'" />
            </el-icon>
          </div>
          
          <div v-show="showUploadArea" class="border border-gray-300 border-t-0 rounded-b-lg">
            <div 
              class="p-6 border-2 border-dashed border-gray-300 m-2 rounded-lg text-center bg-gray-50 hover:bg-blue-50 hover:border-blue-400 transition-colors cursor-pointer"
              @click="triggerFileInput"
              @dragover.prevent
              @drop.prevent="handleDropOnArea"
            >
              <el-icon :size="40" color="#9ca3af" class="mb-2"><upload-filled /></el-icon>
              <p class="text-gray-600 text-sm font-medium">拖拽文件到此处上传</p>
              <p class="text-gray-400 text-xs mt-1">或点击选择文件</p>
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
          ref="fileTable"
          :data="rows"
          border
          @selection-change="handleSelectionChange"
          :row-class-name="rowClassName"
        >
          <el-table-column
            type="selection"
            width="55"
            :selectable="row => !row.deleted_at"
          />
          
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
                    <el-button size="small" type="warning" v-perm="'media:delete'">软删</el-button>
                  </template>
                </el-popconfirm>
                
                <el-popconfirm 
                  title="确认硬删除？（删除数据库和文件，不可恢复！）" 
                  @confirm="hardDelFile(row)"
                >
                  <template #reference>
                    <el-button size="small" type="danger" v-perm="'media:delete'">硬删</el-button>
                  </template>
                </el-popconfirm>
              </template>
              
              <!-- 已删除文件：显示恢复和硬删除 -->
              <template v-else>
                <el-button size="small" type="success" @click="restore(row)" v-perm="'media:delete'">还原</el-button>
                <el-popconfirm 
                  title="确认永久删除？（不可恢复！）" 
                  @confirm="hardDelFile(row)"
                >
                  <template #reference>
                    <el-button size="small" type="danger" v-perm="'media:delete'">永久删除</el-button>
                  </template>
                </el-popconfirm>
              </template>
              
              <el-button size="small" @click="rename(row)" v-perm="'media:rename'">重命名</el-button>
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
          <el-button type="primary" @click="saveDir">保存</el-button>
        </template>
      </el-dialog>

      <!-- 重命名弹窗 -->
      <el-dialog v-model="showRename" title="重命名">
        <el-input v-model="renameText" />
        <template #footer>
          <el-button @click="showRename = false">取消</el-button>
          <el-button type="primary" @click="doRename">保存</el-button>
        </template>
      </el-dialog>
    </div>

    <template #footer>
      <el-button @click="handleCancel">取消</el-button>
      <el-button type="primary" @click="handleConfirm">确认</el-button>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, reactive, onMounted, watchEffect, nextTick, computed } from 'vue'
import { mediaDirs, mediaFiles, uploadMedia, mediaTags } from '@/api/media'
import dayjs from 'dayjs'
import { Folder, UploadFilled } from '@element-plus/icons-vue'

// Props定义
const props = defineProps({
  modelValue: Boolean,
  selectMode: {
    type: String,
    default: 'single'
  },
  selected: {
    type: Array,
    default: () => []
  }
})

// Emits定义
const emit = defineEmits([
  'update:modelValue',
  'confirm',
  'cancel'
])

// 弹窗显示控制
const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

// 文件输入引用
const fileInputRef = ref()

// 目录相关
const dirTreeRef = ref()
const dirTree = ref([])
const dirKw = ref('')
const currentDirId = ref(null)

// 文件列表相关
const kw = ref('')
const withDeleted = ref(0)
const rows = ref([])
const total = ref(0)
const page = ref(1)
const size = ref(10)
const fileTable = ref()

// 标签相关
const allTags = ref([])
const filterTagNames = ref([])
const uploadTagsInput = ref('')

// 上传进度
const uploading = ref(false)
const uploadPercent = ref(0)

// 选择相关
const selectedFiles = ref([])

// 拖拽上传区域显示控制
const showUploadArea = ref(true) // 默认展开

// 目录编辑相关
const showDirEdit = ref(false)
const dirForm = reactive({ id: null, name: '', parent_id: null, sort: 0 })

// 重命名相关
const showRename = ref(false)
const renameRow = ref(null)
const renameText = ref('')

// 目录过滤方法
function dirFilter(val, data) {
  if (!val) return true
  return data.name?.toLowerCase().includes(val.toLowerCase())
}

// 监听目录搜索关键字变化
watchEffect(() => dirTreeRef.value?.filter(dirKw.value))

// 加载目录树
async function loadDirs() {
  const { items } = await mediaDirs.list()
  dirTree.value = items || []
}

// 加载标签
async function loadTags() {
  const { items } = await mediaTags.list()
  allTags.value = items || []
}

// 目录点击事件
function onDirClick(node) { 
  currentDirId.value = node.id
  page.value = 1
  loadFiles()
}

// 加载文件列表
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
  
  // 初始化选中状态
  nextTick(() => {
    if (props.selected.length) {
      rows.value.forEach(row => {
        if (props.selected.some(f => f.id === row.id)) {
          fileTable.value.toggleRowSelection(row, true)
        }
      })
    }
  })
}

// 格式化文件大小
function prettySize(n) {
  if (n == null) return '-'
  const u = ['B', 'KB', 'MB', 'GB', 'TB']
  let i = 0
  let v = n
  while (v >= 1024 && i < u.length - 1) { v /= 1024; i++ }
  return `${v.toFixed(i ? 1 : 0)} ${u[i]}`
}

// 格式化时间
function formatTime(t) { return t ? dayjs(t).format('YYYY-MM-DD HH:mm') : '-' }

// 获取预览URL（使用SHA256）
function preview(row) {
  return mediaFiles.previewUrl(row.sha256)
}

// 上传文件
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

// 触发文件选择
function triggerFileInput() {
  fileInputRef.value?.click()
}

// 处理文件选择
async function handleFileSelect(e) {
  const files = Array.from(e.target.files)
  if (files.length === 0) return
  
  // 清空input值，允许重复选择同一文件
  e.target.value = ''
  
  await uploadFiles(files)
}

// 处理拖拽到区域
async function handleDropOnArea(e) {
  const files = Array.from(e.dataTransfer.files)
  if (files.length === 0) return
  
  await uploadFiles(files)
}

// 上传文件列表
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
    loadFiles()
    loadTags()
  } catch (error) {
    console.error('上传失败：', error)
  } finally {
    uploading.value = false
    uploadPercent.value = 0
  }
}

// 下载文件（使用SHA256）
function download(row) {
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

// 恢复文件
async function restore(row) {
  await mediaFiles.restore(row.id)
  loadFiles()
}

// 打开目录编辑
function openDirEdit(row) {
  if (row) {
    Object.assign(dirForm, { id: row.id, name: row.name, parent_id: row.parent_id ?? null, sort: row.sort ?? 0 })
  } else {
    Object.assign(dirForm, { id: null, name: '', parent_id: currentDirId.value ?? null, sort: 0 })
  }
  showDirEdit.value = true
}

// 保存目录
async function saveDir() {
  if (dirForm.id) await mediaDirs.update(dirForm.id, dirForm)
  else await mediaDirs.create(dirForm)
  showDirEdit.value = false
  await loadDirs()
}

// 删除目录
async function delDir(row) {
  await mediaDirs.remove(row.id)
  await loadDirs()
}

// 重命名
function rename(row) { 
  renameRow.value = row
  renameText.value = row.filename
  showRename.value = true 
}

// 执行重命名
async function doRename() {
  await mediaFiles.rename(renameRow.value.id, renameText.value)
  showRename.value = false
  loadFiles()
}

// 处理选择变化
function handleSelectionChange(val) {
  selectedFiles.value = val
}

// 确认选择
function handleConfirm() {
  emit('confirm', selectedFiles.value)
  visible.value = false
}

// 取消选择
function handleCancel() {
  emit('cancel')
  visible.value = false
}

// 行样式 - 禁用已删除的行
function rowClassName({ row }) {
  return row.deleted_at ? 'row-disabled' : ''
}

// 初始化加载
onMounted(async () => {
  await loadDirs()
  await loadTags()
  await loadFiles()
})
</script>

<style scoped>
/* 禁用行样式 */
:deep(.row-disabled) {
  opacity: 0.6;
  cursor: not-allowed;
}

/* 上传进度条 - 直角无圆角 */
:deep(.upload-progress .el-progress-bar__outer) {
  border-radius: 0;
}
:deep(.upload-progress .el-progress-bar__inner) {
  border-radius: 0;
}
</style>