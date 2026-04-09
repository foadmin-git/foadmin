<template>
    <div class="dict-container">
      <!-- 页面标题和说明 -->
      <div class="mb-6">
        <h2 class="text-2xl font-bold mb-2">数据字典管理</h2>
        <el-alert type="info" :closable="false" class="mb-4">
          <template #title>
            <div class="text-sm">
              <p><strong>功能说明：</strong>数据字典用于维护系统中的下拉选项、状态码等固定配置数据。</p>
              <p><strong>操作指南：</strong>左侧管理字典类型（分类），右侧管理具体字典项（键值对）。</p>
            </div>
          </template>
        </el-alert>
      </div>
  
      <div class="flex gap-4">
        <!-- 左侧：字典类型列表 -->
        <div class="dict-types w-1/3 bg-white p-4 rounded shadow">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-semibold">字典类型</h3>
            <el-button type="primary" size="small" @click="handleAddType" v-perm="'dict:type:add'">
              <el-icon><Plus /></el-icon> 新增类型
            </el-button>
          </div>
  
          <!-- 搜索 -->
          <div class="mb-4">
            <el-input v-model="typeSearch" placeholder="搜索类型名称或编码" clearable @clear="loadTypes" @keyup.enter="loadTypes">
              <template #prefix><el-icon><Search /></el-icon></template>
            </el-input>
          </div>
  
          <!-- 类型列表 -->
          <div class="type-list" v-loading="typeLoading">
            <div 
              v-for="item in typeList" 
              :key="item.id"
              class="type-item p-3 mb-2 rounded cursor-pointer transition"
              :class="{ 'bg-blue-50 border-blue-400': currentType?.id === item.id, 'border border-gray-200 hover:bg-gray-50': currentType?.id !== item.id }"
              @click="selectType(item)"
            >
              <div class="flex justify-between items-start">
                <div class="flex-1">
                  <div class="font-medium">{{ item.name }}</div>
                  <div class="text-xs text-gray-500 mt-1">编码: {{ item.code }}</div>
                  <div class="text-xs text-gray-400 mt-1" v-if="item.description">{{ item.description }}</div>
                </div>
                <div class="flex gap-1">
                  <el-tag :type="item.status === 1 ? 'success' : 'danger'" size="small">
                    {{ item.status === 1 ? '启用' : '禁用' }}
                  </el-tag>
                </div>
              </div>
              <div class="flex gap-2 mt-2" @click.stop>
                <el-button size="small" text @click="handleEditType(item)" v-perm="'dict:type:edit'">编辑</el-button>
                <el-button size="small" text type="danger" @click="handleDeleteType(item)" v-perm="'dict:type:delete'">删除</el-button>
              </div>
            </div>
  
            <!-- 分页 -->
            <el-pagination
              v-if="typeTotal > typePageSize"
              small
              background
              layout="prev, pager, next"
              :total="typeTotal"
              :page-size="typePageSize"
              v-model:current-page="typePage"
              @current-change="loadTypes"
              class="mt-4"
            />
          </div>
        </div>
  
        <!-- 右侧：字典数据列表 -->
        <div class="dict-data flex-1 bg-white p-4 rounded shadow">
          <div v-if="!currentType" class="text-center text-gray-400 py-20">
            <el-icon :size="60"><FolderOpened /></el-icon>
            <p class="mt-4">请先选择左侧字典类型</p>
          </div>
  
          <div v-else>
            <div class="flex justify-between items-center mb-4">
              <h3 class="text-lg font-semibold">字典数据 - {{ currentType.name }}</h3>
              <el-button type="primary" size="small" @click="handleAddData" v-perm="'dict:data:add'">
                <el-icon><Plus /></el-icon> 新增数据
              </el-button>
            </div>
  
            <!-- 搜索 -->
            <div class="mb-4 flex gap-2">
              <el-input v-model="dataSearch" placeholder="搜索标签" clearable @clear="loadData" @keyup.enter="loadData" style="width: 200px">
                <template #prefix><el-icon><Search /></el-icon></template>
              </el-input>
              <el-select v-model="dataStatusFilter" placeholder="状态" clearable @change="loadData" style="width: 120px">
                <el-option label="全部" :value="null" />
                <el-option label="启用" :value="1" />
                <el-option label="禁用" :value="0" />
              </el-select>
            </div>
  
            <!-- 数据表格 -->
            <el-table :data="dataList" v-loading="dataLoading" border>
              <el-table-column prop="sort" label="排序" width="80" />
              <el-table-column prop="label" label="标签" min-width="120">
                <template #default="{ row }">
                  <el-tag :type="row.tag_type || 'info'">{{ row.label }}</el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="value" label="键值" min-width="120" />
              <el-table-column prop="remark" label="备注" min-width="150" show-overflow-tooltip />
              <el-table-column prop="status" label="状态" width="80">
                <template #default="{ row }">
                  <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small">
                    {{ row.status === 1 ? '启用' : '禁用' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="180" fixed="right">
                <template #default="{ row }">
                  <el-button size="small" text @click="handleEditData(row)" v-perm="'dict:data:edit'">编辑</el-button>
                  <el-button size="small" text type="danger" @click="handleDeleteData(row)" v-perm="'dict:data:delete'">删除</el-button>
                </template>
              </el-table-column>
            </el-table>
  
            <!-- 分页 -->
            <el-pagination
              v-if="dataTotal > dataPageSize"
              background
              layout="total, prev, pager, next, sizes"
              :total="dataTotal"
              :page-size="dataPageSize"
              :page-sizes="[20, 50, 100]"
              v-model:current-page="dataPage"
              v-model:page-size="dataPageSize"
              @current-change="loadData"
              @size-change="loadData"
              class="mt-4"
            />
          </div>
        </div>
      </div>
  
      <!-- 字典类型编辑对话框 -->
      <el-dialog 
        v-model="typeDialogVisible" 
        :title="typeForm.id ? '编辑字典类型' : '新增字典类型'"
        width="500px"
      >
        <el-form :model="typeForm" :rules="typeRules" ref="typeFormRef" label-width="100px">
          <el-form-item label="类型名称" prop="name">
            <el-input v-model="typeForm.name" placeholder="请输入类型名称" />
          </el-form-item>
          <el-form-item label="类型编码" prop="code">
            <el-input v-model="typeForm.code" placeholder="请输入类型编码（唯一）" :disabled="!!typeForm.id" />
            <div class="text-xs text-gray-400 mt-1">编码创建后不可修改，建议使用英文下划线格式，如: sys_user_sex</div>
          </el-form-item>
          <el-form-item label="描述" prop="description">
            <el-input v-model="typeForm.description" type="textarea" :rows="3" placeholder="请输入描述" />
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-radio-group v-model="typeForm.status">
              <el-radio :label="1">启用</el-radio>
              <el-radio :label="0">禁用</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="排序" prop="sort">
            <el-input-number v-model="typeForm.sort" :min="0" />
          </el-form-item>
        </el-form>
        <template #footer>
          <el-button @click="typeDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitTypeForm" :loading="typeSubmitting">确定</el-button>
        </template>
      </el-dialog>
  
      <!-- 字典数据编辑对话框 -->
      <el-dialog 
        v-model="dataDialogVisible" 
        :title="dataForm.id ? '编辑字典数据' : '新增字典数据'"
        width="500px"
      >
        <el-form :model="dataForm" :rules="dataRules" ref="dataFormRef" label-width="100px">
          <el-form-item label="标签" prop="label">
            <el-input v-model="dataForm.label" placeholder="请输入显示标签" />
          </el-form-item>
          <el-form-item label="键值" prop="value">
            <el-input v-model="dataForm.value" placeholder="请输入实际值" />
            <div class="text-xs text-gray-400 mt-1">程序中使用的值</div>
          </el-form-item>
          <el-form-item label="标签样式" prop="tag_type">
            <el-select v-model="dataForm.tag_type" placeholder="请选择标签样式" clearable>
              <el-option label="默认" value="info" />
              <el-option label="成功" value="success" />
              <el-option label="警告" value="warning" />
              <el-option label="危险" value="danger" />
              <el-option label="主要" value="primary" />
            </el-select>
          </el-form-item>
          <el-form-item label="CSS类" prop="css_class">
            <el-input v-model="dataForm.css_class" placeholder="自定义CSS类（可选）" />
          </el-form-item>
          <el-form-item label="备注" prop="remark">
            <el-input v-model="dataForm.remark" type="textarea" :rows="2" placeholder="请输入备注" />
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-radio-group v-model="dataForm.status">
              <el-radio :label="1">启用</el-radio>
              <el-radio :label="0">禁用</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="排序" prop="sort">
            <el-input-number v-model="dataForm.sort" :min="0" />
          </el-form-item>
        </el-form>
        <template #footer>
          <el-button @click="dataDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitDataForm" :loading="dataSubmitting">确定</el-button>
        </template>
      </el-dialog>
    </div>
  </template>
  
  <script setup>
  import { ref, reactive, onMounted } from 'vue'
  import { ElMessage, ElMessageBox } from 'element-plus'
  import { Plus, Search, FolderOpened } from '@element-plus/icons-vue'
  import {
    getDictTypesApi,
    createDictTypeApi,
    updateDictTypeApi,
    deleteDictTypeApi,
    getDictDataApi,
    createDictDataApi,
    updateDictDataApi,
    deleteDictDataApi
  } from '@/api/dict'
  
  // ==================== 字典类型相关 ====================
  const typeList = ref([])
  const typeLoading = ref(false)
  const typePage = ref(1)
  const typePageSize = ref(20)
  const typeTotal = ref(0)
  const typeSearch = ref('')
  const currentType = ref(null)
  
  const typeDialogVisible = ref(false)
  const typeSubmitting = ref(false)
  const typeFormRef = ref(null)
  const typeForm = reactive({
    id: null,
    name: '',
    code: '',
    description: '',
    status: 1,
    sort: 0
  })
  
  const typeRules = {
    name: [{ required: true, message: '请输入类型名称', trigger: 'blur' }],
    code: [
      { required: true, message: '请输入类型编码', trigger: 'blur' },
      { pattern: /^[a-zA-Z_][a-zA-Z0-9_]*$/, message: '编码只能包含字母、数字、下划线，且以字母或下划线开头', trigger: 'blur' }
    ]
  }
  
  // 加载字典类型列表
  const loadTypes = async () => {
    typeLoading.value = true
    try {
      const res = await getDictTypesApi({
        page: typePage.value,
        size: typePageSize.value,
        name: typeSearch.value || undefined,
        code: typeSearch.value || undefined
      })
      typeList.value = res.items
      typeTotal.value = res.total
      
      // 自动选中第一个
      if (typeList.value.length > 0 && !currentType.value) {
        selectType(typeList.value[0])
      }
    } catch (error) {
      ElMessage.error(error.response?.data?.detail || '加载失败')
    } finally {
      typeLoading.value = false
    }
  }
  
  // 选择字典类型
  const selectType = (item) => {
    currentType.value = item
    dataPage.value = 1
    loadData()
  }
  
  // 新增字典类型
  const handleAddType = () => {
    Object.assign(typeForm, {
      id: null,
      name: '',
      code: '',
      description: '',
      status: 1,
      sort: 0
    })
    typeDialogVisible.value = true
  }
  
  // 编辑字典类型
  const handleEditType = (item) => {
    Object.assign(typeForm, { ...item })
    typeDialogVisible.value = true
  }
  
  // 提交字典类型表单
  const submitTypeForm = async () => {
    try {
      await typeFormRef.value.validate()
      typeSubmitting.value = true
      
      if (typeForm.id) {
        await updateDictTypeApi(typeForm.id, typeForm)
        ElMessage.success('更新成功')
      } else {
        await createDictTypeApi(typeForm)
        ElMessage.success('创建成功')
      }
      
      typeDialogVisible.value = false
      loadTypes()
    } catch (error) {
      if (error?.response) {
        ElMessage.error(error.response.data?.detail || '操作失败')
      }
    } finally {
      typeSubmitting.value = false
    }
  }
  
  // 删除字典类型
  const handleDeleteType = async (item) => {
    try {
      await ElMessageBox.confirm(
        `确定要删除字典类型"${item.name}"吗？该操作会同时删除所有关联的字典数据！`,
        '警告',
        { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }
      )
      
      await deleteDictTypeApi(item.id)
      ElMessage.success('删除成功')
      
      if (currentType.value?.id === item.id) {
        currentType.value = null
      }
      loadTypes()
    } catch (error) {
      if (error !== 'cancel') {
        ElMessage.error(error.response?.data?.detail || '删除失败')
      }
    }
  }
  
  // ==================== 字典数据相关 ====================
  const dataList = ref([])
  const dataLoading = ref(false)
  const dataPage = ref(1)
  const dataPageSize = ref(20)
  const dataTotal = ref(0)
  const dataSearch = ref('')
  const dataStatusFilter = ref(null)
  
  const dataDialogVisible = ref(false)
  const dataSubmitting = ref(false)
  const dataFormRef = ref(null)
  const dataForm = reactive({
    id: null,
    type_code: '',
    label: '',
    value: '',
    tag_type: 'info',
    css_class: '',
    remark: '',
    status: 1,
    sort: 0
  })
  
  const dataRules = {
    label: [{ required: true, message: '请输入标签', trigger: 'blur' }],
    value: [{ required: true, message: '请输入键值', trigger: 'blur' }]
  }
  
  // 加载字典数据列表
  const loadData = async () => {
    if (!currentType.value) return
    
    dataLoading.value = true
    try {
      const res = await getDictDataApi({
        type_code: currentType.value.code,
        page: dataPage.value,
        size: dataPageSize.value,
        label: dataSearch.value || undefined,
        status: dataStatusFilter.value
      })
      dataList.value = res.items
      dataTotal.value = res.total
    } catch (error) {
      ElMessage.error(error.response?.data?.detail || '加载失败')
    } finally {
      dataLoading.value = false
    }
  }
  
  // 新增字典数据
  const handleAddData = () => {
    Object.assign(dataForm, {
      id: null,
      type_code: currentType.value.code,
      label: '',
      value: '',
      tag_type: 'info',
      css_class: '',
      remark: '',
      status: 1,
      sort: 0
    })
    dataDialogVisible.value = true
  }
  
  // 编辑字典数据
  const handleEditData = (item) => {
    Object.assign(dataForm, { ...item })
    dataDialogVisible.value = true
  }
  
  // 提交字典数据表单
  const submitDataForm = async () => {
    try {
      await dataFormRef.value.validate()
      dataSubmitting.value = true
      
      if (dataForm.id) {
        await updateDictDataApi(dataForm.id, dataForm)
        ElMessage.success('更新成功')
      } else {
        await createDictDataApi(dataForm)
        ElMessage.success('创建成功')
      }
      
      dataDialogVisible.value = false
      loadData()
    } catch (error) {
      if (error?.response) {
        ElMessage.error(error.response.data?.detail || '操作失败')
      }
    } finally {
      dataSubmitting.value = false
    }
  }
  
  // 删除字典数据
  const handleDeleteData = async (item) => {
    try {
      await ElMessageBox.confirm(
        `确定要删除字典数据"${item.label}"吗？`,
        '警告',
        { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }
      )
      
      await deleteDictDataApi(item.id)
      ElMessage.success('删除成功')
      loadData()
    } catch (error) {
      if (error !== 'cancel') {
        ElMessage.error(error.response?.data?.detail || '删除失败')
      }
    }
  }
  
  // ==================== 初始化 ====================
  onMounted(() => {
    loadTypes()
  })
  </script>
  
  <style scoped>
  .dict-container {
    background: #f5f7fa;
    min-height: calc(100vh - 120px);
  }
  
  .type-item {
    transition: all 0.2s;
  }
  
  .type-list {
    max-height: calc(100vh - 400px);
    overflow-y: auto;
  }
  </style>
  