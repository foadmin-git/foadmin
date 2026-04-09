<!--src\views\central\org\level\index.vue-->
<template>
    <div class="space-y-3">
      <el-button type="primary" @click="openEdit()">新增层级</el-button>
      <el-table :data="rows" border>
        <el-table-column prop="id" label="ID" width="80"/>
        <el-table-column prop="name" label="名称"/>
        <el-table-column prop="code" label="编码"/>
        <el-table-column prop="weight" label="权重" width="120"/>
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" @click="openEdit(row)">编辑</el-button>
            <el-popconfirm title="确认删除？" @confirm="onDel(row)"><template #reference><el-button size="small" type="danger">删除</el-button></template></el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
  
      <el-dialog v-model="showEdit" :title="edit.id?'编辑层级':'新增层级'">
        <el-form :model="edit" label-width="80">
          <el-form-item label="名称"><el-input v-model="edit.name"/></el-form-item>
          <el-form-item label="编码"><el-input v-model="edit.code"/></el-form-item>
          <el-form-item label="权重"><el-input-number v-model="edit.weight" :min="0"/></el-form-item>
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
  import { listLevels, createLevel, updateLevel, deleteLevel } from '@/api/levels'
  
  const rows = ref([])
  async function load(){ const { items } = await listLevels(); rows.value = items }
  onMounted(load)
  
  const showEdit = ref(false)
  const edit = reactive({ id:null, name:'', code:'', weight:0 })
  function openEdit(row){ row ? Object.assign(edit, row) : Object.assign(edit, { id:null, name:'', code:'', weight:0 }); showEdit.value=true }
  async function saveEdit(){ if(edit.id) await updateLevel(edit.id, edit); else await createLevel(edit); showEdit.value=false; load() }
  async function onDel(row){ await deleteLevel(row.id); load() }
  </script>
  