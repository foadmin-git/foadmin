<!--src/views/central/org/user/index.vue-->
<template>
  <div class="space-y-3">
    <!-- 搜索区 -->
    <el-card>
      <div class="grid grid-cols-1 md:grid-cols-5 gap-3 items-center">
        <el-input
          v-model="q.kw"
          placeholder="搜索：用户名/昵称"
          clearable
          @keyup.enter="doSearch"
        />
        <el-tree-select
          v-model="q.dept_id"
          :data="orgOptions"
          check-strictly
          :render-after-expand="false"
          :props="{ label:'name', children:'children', value:'id' }"
          placeholder="所属组织"
          clearable
        />
        <el-select v-model="q.level_id" placeholder="层级" clearable>
          <el-option v-for="lv in levelOptions" :key="lv.id" :label="lv.name" :value="lv.id" />
        </el-select>
        <el-select v-model="q.status" placeholder="状态" clearable>
          <el-option :value="1" label="启用" />
          <el-option :value="0" label="停用" />
        </el-select>
        <div class="flex items-center gap-2">
          <el-checkbox v-model="q.include_child" :true-label="1" :false-label="0">含子级</el-checkbox>
          <el-button type="primary" @click="doSearch">搜索</el-button>
          <el-button @click="resetSearch">重置</el-button>
          <el-button type="success" @click="openEdit()">新增</el-button>
        </div>
      </div>
    </el-card>

    <!-- 表格 -->
    <el-table :data="rows" border>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="username" label="用户名" />
      <el-table-column prop="nick_name" label="昵称" />
      <el-table-column prop="role_names" label="角色" />
      <el-table-column prop="dept_name" label="组织" />
      <el-table-column prop="level_name" label="层级" />
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.status ? 'success':'info'">{{ row.status ? '启用' : '停用' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="320">
        <template #default="{ row }">
          <el-button size="small" @click="openEdit(row)">编辑</el-button>
          <el-button size="small" @click="openRoles(row)">角色</el-button>
          <el-popconfirm title="确认删除？" @confirm="onDel(row)">
            <template #reference><el-button size="small" type="danger">删除</el-button></template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>

    <div class="flex justify-end">
      <el-pagination background layout="prev, pager, next, total"
        :page-size="size" :current-page="page" :total="total"
        @current-change="(p)=>{page=p; load()}"/>
    </div>

    <!-- 编辑弹窗 -->
    <el-dialog v-model="showEdit" :title="edit.id?'编辑用户':'新增用户'">
      <el-form :model="edit" label-width="90">
        <el-form-item label="用户名" v-if="!edit.id">
          <el-input v-model="edit.username"/>
        </el-form-item>
        <el-form-item label="昵称">
          <el-input v-model="edit.nick_name"/>
        </el-form-item>
        <el-form-item label="密码">
          <el-input v-model="edit.password" type="password" placeholder="不改可留空" />
        </el-form-item>

        <el-form-item label="组织">
          <el-tree-select
            v-model="edit.dept_id"
            :data="orgOptions"
            check-strictly
            :render-after-expand="false"
            :props="{ label:'name', children:'children', value:'id' }"
            class="w-full"
            placeholder="选择组织"
            clearable
          />
        </el-form-item>

        <el-form-item label="层级">
          <el-select v-model="edit.level_id" class="w-full" placeholder="选择层级" clearable>
            <el-option v-for="lv in levelOptions" :key="lv.id" :label="lv.name" :value="lv.id" />
          </el-select>
        </el-form-item>

        <el-form-item label="状态">
          <el-switch v-model="edit.status" :active-value="1" :inactive-value="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showEdit=false">取消</el-button>
        <el-button type="primary" @click="saveEdit">保存</el-button>
      </template>
    </el-dialog>

    <!-- 角色绑定 -->
    <el-dialog v-model="showRoles" title="用户角色">
      <div class="w-full">
        <el-checkbox-group v-model="selectedRoles">
          <el-checkbox v-for="r in allRoles" :key="r.id" :label="r.id">{{ r.name }} ({{ r.code }})</el-checkbox>
        </el-checkbox-group>
      </div>
      <template #footer>
        <el-button @click="showRoles=false">取消</el-button>
        <el-button type="primary" @click="saveRoles">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import {
  listUsers, createUser, updateUser, deleteUser,
  getUserRoles, bindUserRoles,
  listLevels, orgTree
} from '@/api/users'
import { listRoles } from '@/api/roles'

/* 搜索与分页 */
const q = reactive({ kw:'', dept_id: null, include_child: 1, level_id: null, status: null })
const page = ref(1)
const size = ref(10)
const total = ref(0)
const rows = ref([])
const allRoles = ref([]) // 移到这里，确保在load函数前定义

let timer = null
function debounce(fn, wait=100){
  return (...args) => {
    clearTimeout(timer)
    timer = setTimeout(() => fn(...args), wait)
  }
}

async function load() {
  const { items, total: t } = await listUsers({
    kw: q.kw || undefined,
    dept_id: q.dept_id || undefined,
    include_child: q.dept_id ? q.include_child : undefined,
    level_id: q.level_id || undefined,
    status: (q.status === 0 || q.status === 1) ? q.status : undefined,
    page: page.value,
    size: size.value
  })
  
  // 为每个用户获取角色信息
  for (const user of items) {
    try {
      const { selected } = await getUserRoles(user.id)
      user.role_names = selected.map(roleId => {
        const role = allRoles.value.find(r => r.id === roleId)
        return role ? role.name : ''
      }).filter(Boolean).join('，')
    } catch (error) {
      console.error(`获取用户 ${user.username} 角色信息失败:`, error)
      user.role_names = ''
    }
  }
  
  rows.value = items; total.value = t
}

const doSearch = debounce(() => { page.value = 1; load() }, 100)
function resetSearch(){
  Object.assign(q, { kw:'', dept_id:null, include_child:1, level_id:null, status:null })
  page.value = 1
  load()
}

onMounted(load)

/* 组织与层级选项 */
const orgOptions = ref([])
const levelOptions = ref([])

async function loadOptions(){
  const [orgRes, lvRes, rolesRes] = await Promise.all([orgTree(), listLevels(), listRoles()])
  orgOptions.value = orgRes.items || []
  levelOptions.value = lvRes.items || []
  allRoles.value = rolesRes.items || [] // 预先加载所有角色
}
onMounted(loadOptions)

/* 编辑弹窗 */
const showEdit = ref(false)
const edit = reactive({ id:null, username:'', nick_name:'', password:'', dept_id:null, level_id:null, status:1 })
function openEdit(row){
  if(row){
    Object.assign(edit, {
      id: row.id, username: row.username, nick_name: row.nick_name,
      password:'', dept_id: row.dept_id, level_id: row.level_id, status: row.status
    })
  }else{
    Object.assign(edit, { id:null, username:'', nick_name:'', password:'', dept_id:null, level_id:null, status:1 })
  }
  showEdit.value = true
}
async function saveEdit(){
  const payload = {
    nick_name: edit.nick_name,
    password: edit.password || undefined,
    dept_id: edit.dept_id || null,
    level_id: edit.level_id || null,
    status: edit.status
  }
  if(edit.id) await updateUser(edit.id, payload)
  else await createUser({ ...payload, username: edit.username })
  showEdit.value=false; load()
}
async function onDel(row){ await deleteUser(row.id); load() }

/* 角色绑定 */
const showRoles = ref(false)
const selectedRoles = ref([]); const currentUserId = ref(null)
async function openRoles(row){
  currentUserId.value = row.id
  const { selected } = await getUserRoles(row.id)
  selectedRoles.value = selected
  showRoles.value = true
}
async function saveRoles(){ await bindUserRoles(currentUserId.value, selectedRoles.value); showRoles.value = false }
</script>
