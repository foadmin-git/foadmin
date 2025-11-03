<!--src\views\central\org\catalog\index.vue-->
<template>
  <div class="space-y-3">
    <div class="flex gap-2">
      <el-button type="primary" @click="openEdit()">新增权限</el-button>
      <el-tag type="info">仅展示 platform=admin</el-tag>
    </div>

    <el-tree
      :data="tree"
      node-key="id"
      :props="{ label:'name', children:'children' }"
      default-expand-all
      highlight-current
    >
      <template #default="{ data }">
        <div class="flex items-center gap-3">
          <span>[{{ data.type }}]</span>
          <span>{{ data.name }}</span>
          <span v-if="data.code" class="text-gray-400">({{ data.code }})</span>

          <!-- 图标预览（仅菜单显示） -->
          <span v-if="data.type==='menu' && data.icon" class="inline-flex items-center text-gray-500">
            <component :is="Icons[data.icon]" style="width:16px;height:16px" />
            <span class="ml-1 text-xs">{{ data.icon }}</span>
          </span>

          <el-button size="small" @click.stop="openEdit(data)">编辑</el-button>
          <el-popconfirm title="确认删除？" @confirm.stop="onDel(data)">
            <template #reference>
              <el-button size="small" type="danger">删除</el-button>
            </template>
          </el-popconfirm>
        </div>
      </template>
    </el-tree>

    <el-dialog v-model="showEdit" :title="edit.id ? '编辑权限' : '新增权限'" width="720px" @open="onDialogOpen">
      <el-form :model="edit" label-width="140">
        <el-form-item label="类型">
          <el-select v-model="edit.type" class="w-full">
            <el-option label="menu" value="menu"/>
            <el-option label="button" value="button"/>
            <el-option label="api" value="api"/>
          </el-select>
        </el-form-item>

        <el-form-item label="平台">
          <el-select v-model="edit.platform" class="w-full">
            <el-option label="admin" value="admin"/>
            <el-option label="front" value="front"/>
          </el-select>
        </el-form-item>

        <el-form-item label="名称">
          <el-input v-model="edit.name"/>
        </el-form-item>

        <el-form-item label="编码（按钮/菜单）">
          <el-input v-model="edit.code"/>
        </el-form-item>

        <!-- 父级改为树选择 -->
        <el-form-item label="父级">
          <el-tree-select
            v-model="edit.parent_id"
            :data="parentTree"
            :props="treeSelectProps"
            placeholder="选择父级（可搜索）"
            check-strictly
            filterable
            clearable
            class="w-full"
          />
        </el-form-item>

        <!-- 图标：可输入 + 选择；仅在菜单时显示 -->
        <el-form-item v-if="edit.type==='menu'" label="图标（菜单）">
          <div class="flex items-center gap-2 w-full">
            <el-input v-model="edit.icon" placeholder="可直接输入图标名，如 HomeFilled" class="flex-1"/>
            <el-button @click="iconPickerVisible = true">选择图标</el-button>
            <span class="inline-flex items-center text-gray-500" v-if="edit.icon && Icons[edit.icon]">
              <component :is="Icons[edit.icon]" style="width:18px;height:18px" />
            </span>
          </div>
        </el-form-item>

        <el-form-item v-if="edit.type==='menu'" label="路由名（菜单）">
          <el-input v-model="edit.route_name"/>
        </el-form-item>

        <el-form-item v-if="edit.type==='menu'" label="路由路径（菜单）">
          <el-input v-model="edit.route_path"/>
        </el-form-item>

        <el-form-item v-if="edit.type==='menu'" label="组件路径（菜单）">
          <el-input v-model="edit.route_component"/>
        </el-form-item>

        <el-form-item v-if="edit.type==='api'" label="HTTP方法（API）">
          <el-input v-model="edit.method"/>
        </el-form-item>

        <el-form-item v-if="edit.type==='api'" label="API路径（API）">
          <el-input v-model="edit.path"/>
        </el-form-item>

        <el-form-item label="排序">
          <el-input-number v-model="edit.sort" :min="0"/>
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="showEdit=false">取消</el-button>
        <el-button type="primary" @click="save">保存</el-button>
      </template>
    </el-dialog>

    <!-- 图标选择弹窗 -->
    <el-dialog v-model="iconPickerVisible" title="选择图标" width="720px">
      <div class="mb-3">
        <el-input v-model="iconKeyword" placeholder="搜索图标名…" clearable/>
      </div>
      <div class="grid" style="grid-template-columns: repeat(8,minmax(0,1fr)); gap: 10px;">
        <div
          v-for="name in filteredIconNames"
          :key="name"
          class="border rounded-md p-2 cursor-pointer hover:shadow flex flex-col items-center justify-center"
          @click="pickIcon(name)"
        >
          <component :is="Icons[name]" style="width:24px;height:24px" />
          <div class="text-xs mt-1 text-center truncate w-full" :title="name">{{ name }}</div>
        </div>
      </div>
      <template #footer>
        <el-button @click="iconPickerVisible=false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { listPerms, createPerm, updatePerm, deletePerm } from '@/api/perms'
import * as Icons from '@element-plus/icons-vue'

/** ------- 数据与工具 ------- **/
const tree = ref([])

/** 扁平化 & 树构建 */
function toTree(items){
  const mp = {}; items.forEach(p=> mp[p.id] = { ...p, children:[] })
  const roots = []
  items.forEach(p=>{
    if (p.parent_id && mp[p.parent_id]) mp[p.parent_id].children.push(mp[p.id])
    else roots.push(mp[p.id])
  })
  const sortRec = ns => { ns.sort((a,b)=> (a.sort-b.sort) || (a.id-b.id)); ns.forEach(n=> sortRec(n.children)) }
  sortRec(roots)
  return roots
}

function flat(items){
  const out = []
  const walk = (ns) => ns.forEach(n=>{ out.push(n); if(n.children?.length) walk(n.children) })
  walk(items); return out
}

async function load(){
  const { items } = await listPerms({ platform:'admin' })
  const roots = toTree(items)
  tree.value = roots
}

/** ------- 父级选择（TreeSelect） ------- **/
const treeSelectProps = { label:'name', children:'children', value:'id' }
const parentTree = ref([])

/** 计算禁用：当前节点及其子孙不可选 */
function buildParentTreeForCurrent(){
  const roots = JSON.parse(JSON.stringify(tree.value || []))
  if (!edit.id) { parentTree.value = roots; return }

  const ban = new Set([edit.id])
  // 找出当前节点的所有子孙 id
  const findNode = (ns, id) => {
    for (const n of ns) {
      if (n.id === id) return n
      if (n.children?.length){
        const r = findNode(n.children, id)
        if (r) return r
      }
    }
    return null
  }
  const cur = findNode(roots, edit.id)
  const collect = (n)=>{ n.children?.forEach(c=>{ ban.add(c.id); collect(c) }) }
  if (cur) collect(cur)

  const markDisabled = (ns)=>{
    ns.forEach(n=>{
      if (ban.has(n.id)) n.disabled = true
      if (n.children?.length) markDisabled(n.children)
    })
  }
  markDisabled(roots)
  parentTree.value = roots
}

/** ------- 图标选择 ------- **/
const iconPickerVisible = ref(false)
const iconKeyword = ref('')
const iconNames = Object.keys(Icons).sort()
const filteredIconNames = computed(() => {
  const kw = iconKeyword.value.trim().toLowerCase()
  if (!kw) return iconNames
  return iconNames.filter(n => n.toLowerCase().includes(kw))
})
function pickIcon(name){
  edit.icon = name
  iconPickerVisible.value = false
}

/** ------- 编辑弹窗 ------- **/
const showEdit = ref(false)
const emptyForm = () => ({
  id:null, type:'menu', platform:'admin', name:'', code:'',
  parent_id:null, icon:'', route_name:'', route_path:'', route_component:'',
  method:'', path:'', sort:0
})
const edit = reactive(emptyForm())

function resetEdit(){
  Object.assign(edit, emptyForm())
}

function openEdit(row){
  if (row) {
    // 深拷贝防止双向绑定污染
    const cloned = JSON.parse(JSON.stringify(row))
    Object.assign(edit, cloned)
  } else {
    resetEdit()
  }
  // 根据当前记录重建父级树，禁用自身与子孙
  buildParentTreeForCurrent()
  showEdit.value = true
}

function onDialogOpen(){
  // 确保每次打开时父级树为最新
  buildParentTreeForCurrent()
}

async function save(){
  const payload = { ...edit }
  if (!payload.id) {
    const { id } = await createPerm(payload)
    edit.id = id
  } else {
    await updatePerm(edit.id, payload)
  }
  showEdit.value = false
  await load()
  // 关闭后清空，避免残留
  resetEdit()
}

async function onDel(row){
  await deletePerm(row.id)
  await load()
}

onMounted(load)

/** 暴露图标库用于动态组件 */
const IconsExpose = Icons
// 为模板使用一致命名
const IconsRef = ref(IconsExpose)
const IconsProxy = new Proxy(IconsRef, {
  get(_, p){ return IconsExpose[p] }
})
const IconsComp = IconsExpose
// 供模板 :is 使用
const IconsMap = IconsExpose

// 映射给模板（有些构建环境需要显式导出）
const IconsExport = Icons
</script>

<script>
// 这里简单导出到全局（仅本文件作用域）
export default {
  computed: {
    Icons(){ return require('@element-plus/icons-vue') }
  }
}
</script>

<style scoped>
/* 辅助样式，可按需调整 */
.grid { display: grid; }
</style>
