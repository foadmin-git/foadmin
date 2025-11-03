<!--src\views\central\org\role\index.vue-->
<template>
  <div class="space-y-3">
    <div class="flex items-center gap-2">
      <el-button type="primary" @click="openEdit()">新增角色</el-button>
    </div>

    <el-table :data="rows" border>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="code" label="编码" />
      <el-table-column prop="name" label="名称" />
      <el-table-column prop="sort" label="排序" width="100" />
      <el-table-column label="操作" width="260">
        <template #default="{ row }">
          <el-button size="small" @click="openEdit(row)">编辑</el-button>
          <el-button size="small" @click="openPerms(row)">权限</el-button>
          <el-popconfirm title="确认删除？" @confirm="onDel(row)">
            <template #reference><el-button size="small" type="danger">删除</el-button></template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>

    <!-- 编辑角色 -->
    <el-dialog v-model="showEdit" :title="edit.id?'编辑角色':'新增角色'">
      <el-form :model="edit" label-width="80">
        <el-form-item label="编码"><el-input v-model="edit.code" :disabled="!!edit.id"/></el-form-item>
        <el-form-item label="名称"><el-input v-model="edit.name"/></el-form-item>
        <el-form-item label="排序"><el-input-number v-model="edit.sort" :min="0"/></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showEdit=false">取消</el-button>
        <el-button type="primary" @click="saveEdit">保存</el-button>
      </template>
    </el-dialog>

    <!-- 权限绑定（树） -->
    <el-dialog v-model="showPerms" title="角色权限" width="820px">
      <div class="flex items-center gap-2 mb-2">
        <el-input v-model="permKeyword" placeholder="搜索权限名称/编码" clearable @input="onFilter" class="w-80" />
        <el-checkbox v-model="checkStrictly">父子不关联</el-checkbox>
      </div>

      <el-scrollbar height="60vh">
        <el-tree
          ref="treeRef"
          :data="permTree"
          node-key="id"
          show-checkbox
          :default-checked-keys="selectedPerms"
          :props="treeProps"
          :check-strictly="checkStrictly"
          :expand-on-click-node="false"
          default-expand-all
          highlight-current
          :filter-node-method="filterNode"
        >
          <template #default="{ data }">
            <div class="flex items-center gap-2">
              <el-tag size="small" :type="typeTagType(data.type)" effect="plain">{{ data.type }}</el-tag>
              <span>{{ data.name }}</span>
              <span v-if="data.code" class="text-gray-400 text-xs">({{ data.code }})</span>
            </div>
          </template>
        </el-tree>
      </el-scrollbar>

      <template #footer>
        <el-button @click="showPerms=false">取消</el-button>
        <el-button type="primary" @click="savePerms">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, nextTick } from 'vue'
import { listRoles, createRole, updateRole, deleteRole, getRolePerms, bindRolePerms } from '@/api/roles'

/* 列表 */
const rows = ref([])
async function load(){ const { items } = await listRoles(); rows.value = items }
onMounted(load)

/* 编辑 */
const showEdit = ref(false)
const edit = reactive({ id:null, code:'', name:'', sort:0 })
function openEdit(row){
  row ? Object.assign(edit, row) : Object.assign(edit, { id:null, code:'', name:'', sort:0 })
  showEdit.value = true
}
async function saveEdit(){
  if(edit.id) await updateRole(edit.id, { code: edit.code, name: edit.name, sort: edit.sort })
  else await createRole({ code: edit.code, name: edit.name, sort: edit.sort })
  showEdit.value=false; load()
}
async function onDel(row){ await deleteRole(row.id); load() }

/* 权限绑定（树） */
const showPerms = ref(false)
const currentRoleId = ref(null)
const allPermsFlat = ref([])     // 平铺数据（后端返回）
const permTree = ref([])         // 树数据
const selectedPerms = ref([])    // 已选 keys
const treeRef = ref()
const permKeyword = ref('')
const checkStrictly = ref(true) // false=父子级联；true=不级联
const treeProps = { label: 'name', children: 'children' }

function typeTagType(t){
  if(t === 'menu') return 'success'
  if(t === 'button') return 'warning'
  if(t === 'api') return 'info'
  return ''
}

/** 按 parent_id 组树：根为 parent_id 为空/0/不存在的节点 */
function toTree(items){
  const mp = {}
  items.forEach(p => { mp[p.id] = { ...p, children: [] } })
  const roots = []
  items.forEach(p => {
    const pid = p.parent_id ?? 0
    if (pid && mp[pid]) {
      mp[pid].children.push(mp[p.id])
    } else {
      roots.push(mp[p.id])
    }
  })
  const sortRec = ns => { ns.sort((a,b)=> (a.sort||0)-(b.sort||0) || a.id-b.id); ns.forEach(n=> sortRec(n.children)) }
  sortRec(roots)
  return roots
}

function filterNode(value, data){
  if(!value) return true
  const v = value.toLowerCase()
  return (data.name && data.name.toLowerCase().includes(v)) ||
         (data.code && String(data.code).toLowerCase().includes(v))
}
function onFilter(){
  treeRef.value?.filter(permKeyword.value)
}

async function openPerms(row){
  currentRoleId.value = row.id
  const { all, selected } = await getRolePerms(row.id)
  // 直接用后端给的 all 组树（不再按 platform 过滤）
  allPermsFlat.value = Array.isArray(all) ? all : []
  permTree.value = toTree(allPermsFlat.value)
  selectedPerms.value = Array.isArray(selected) ? selected : []
  showPerms.value = true

  // 等树渲染完再设置默认选中，避免 setCheckedKeys 时节点未挂载
  await nextTick()
  treeRef.value?.setCheckedKeys(selectedPerms.value, false)
}

async function savePerms(){
  if(!treeRef.value) return
  // 选中 + 半选一并提交，保证父菜单也有
  const checked = treeRef.value.getCheckedKeys(false)
  const half = treeRef.value.getHalfCheckedKeys()
  const ids = Array.from(new Set([...(checked||[]), ...(half||[])]))
  await bindRolePerms(currentRoleId.value, ids)
  showPerms.value = false
}
</script>
