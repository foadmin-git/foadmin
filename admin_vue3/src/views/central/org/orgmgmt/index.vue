<!--src\views\central\org\orgmgmt\index.vue-->
<template>
    <div class="flex gap-4">
      <el-card class="w-96">
        <template #header>
          <div class="flex justify-between items-center">
            <span>组织树</span>
            <el-button type="primary" size="small" @click="openEdit()">新增根组织</el-button>
          </div>
        </template>
        <el-tree
          :data="tree"
          node-key="id"
          :props="{ label:'name', children:'children' }"
          highlight-current
          @node-click="onNodeClick"
          default-expand-all
        >
          <template #default="{ data }">
            <div class="flex items-center gap-2">
              <span>{{ data.name }}</span>
              <el-button size="small" @click.stop="openEdit(data)">新增子级</el-button>
              <el-button size="small" @click.stop="openEdit(data, true)">编辑</el-button>
              <el-popconfirm title="确认删除？" @confirm.stop="onDel(data)"><template #reference><el-button size="small" type="danger">删</el-button></template></el-popconfirm>
            </div>
          </template>
        </el-tree>
      </el-card>
  
      <el-card class="flex-1">
        <template #header>组织信息</template>
        <div v-if="current">
          <div class="text-sm text-gray-500 mb-2">ID: {{ current.id }}</div>
          <div class="space-y-2">
            <div>名称：{{ current.name }}</div>
            <div>编码：{{ current.code || '-' }}</div>
            <div>父ID：{{ current.parent_id || '-' }}</div>
            <div>排序：{{ current.sort }}</div>
            <div>状态：{{ current.status ? '启用' : '停用' }}</div>
          </div>
        </div>
        <div v-else class="text-gray-400">请选择左侧节点</div>
      </el-card>
  
      <el-dialog v-model="showEdit" :title="edit.isUpdate ? '编辑组织' : '新增组织'">
        <el-form :model="edit" label-width="80">
          <el-form-item label="父ID"><el-input v-model.number="edit.parent_id" :disabled="edit.isUpdate"/></el-form-item>
          <el-form-item label="名称"><el-input v-model="edit.name"/></el-form-item>
          <el-form-item label="编码"><el-input v-model="edit.code"/></el-form-item>
          <el-form-item label="排序"><el-input-number v-model="edit.sort" :min="0"/></el-form-item>
          <el-form-item label="状态">
            <el-select v-model="edit.status" class="w-full"><el-option :value="1" label="启用"/><el-option :value="0" label="停用"/></el-select>
          </el-form-item>
        </el-form>
        <template #footer>
          <el-button @click="showEdit=false">取消</el-button>
          <el-button type="primary" @click="saveEdit">保存</el-button>
        </template>
      </el-dialog>
    </div>
  </template>
  
  <script setup>
  import { ref, reactive, onMounted } from 'vue'
  import { orgTree, createOrg, updateOrg, deleteOrg } from '@/api/orgs'
  
  const tree = ref([])
  const current = ref(null)
  
  function pickFirst(nodes){ if(!nodes?.length) return null; return nodes[0] }
  async function load(){
    const { items } = await orgTree()
    tree.value = items || []
    current.value = pickFirst(tree.value)
  }
  onMounted(load)
  
  function onNodeClick(data){ current.value = data }
  
  const showEdit = ref(false)
  const edit = reactive({ isUpdate:false, id:null, parent_id:null, name:'', code:'', sort:0, status:1 })
  function openEdit(node, isUpdate=false){
    if(isUpdate){
      Object.assign(edit, { isUpdate:true, id: node.id, parent_id: node.parent_id, name: node.name, code: node.code, sort: node.sort, status: node.status })
    }else{
      const pid = node?.id ?? null
      Object.assign(edit, { isUpdate:false, id:null, parent_id: pid, name:'', code:'', sort:0, status:1 })
    }
    showEdit.value = true
  }
  async function saveEdit(){
    if(edit.isUpdate) await updateOrg(edit.id, edit)
    else await createOrg(edit)
    showEdit.value=false; load()
  }
  async function onDel(node){ await deleteOrg(node.id); load() }
  </script>
  