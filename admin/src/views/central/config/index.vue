<!-- src/views/central/config/index.vue -->
<template>
    <div class="config-manager">
      <el-card shadow="never">
        <template #header>
          <div class="flex justify-between items-center">
            <h3 class="text-lg font-bold">系统配置管理</h3>
            <div class="flex gap-2">
              <el-input
                v-model="keyword"
                placeholder="搜索配置项"
                clearable
                style="width: 200px"
                @input="loadConfigs"
              />
              <el-button type="primary" @click="showAddDialog">新增配置</el-button>
            </div>
          </div>
        </template>
  
        <!-- 分类标签页 -->
        <el-tabs v-model="activeCategory" @tab-change="handleCategoryChange">
          <el-tab-pane
            v-for="(configs, category) in groupedConfigs"
            :key="category"
            :label="getCategoryLabel(category)"
            :name="category"
          >
            <el-form ref="formRef" :model="formData" label-width="180px" class="mt-4">
              <el-row :gutter="20">
                <el-col
                  v-for="config in configs"
                  :key="config.id"
                  :span="12"
                >
                  <el-card shadow="hover" class="config-item-card mb-4">
                    <el-form-item :label="config.name" class="mb-2">
                      <template #label>
                        <div class="flex items-center gap-2">
                          <span class="font-medium">{{ config.name }}</span>
                          <el-tooltip v-if="config.description" :content="config.description">
                            <el-icon class="text-gray-400 cursor-help"><QuestionFilled /></el-icon>
                          </el-tooltip>
                        </div>
                      </template>
  
                    <!-- 字符串类型 -->
                    <el-input
                      v-if="config.value_type === 'string'"
                      v-model="formData[config.key]"
                      :placeholder="config.default_value || '请输入'"
                    />
  
                    <!-- 数字类型 -->
                    <el-input-number
                      v-else-if="config.value_type === 'number'"
                      v-model="formData[config.key]"
                      :placeholder="config.default_value || '0'"
                      style="width: 100%"
                    />
  
                    <!-- 布尔类型 -->
                    <el-switch
                      v-else-if="config.value_type === 'boolean'"
                      v-model="formData[config.key]"
                      active-text="启用"
                      inactive-text="禁用"
                    />
  
                    <!-- 下拉选择 -->
                    <el-select
                      v-else-if="config.value_type === 'select' && config.options"
                      v-model="formData[config.key]"
                      style="width: 100%"
                    >
                      <el-option
                        v-for="opt in parseOptions(config.options)"
                        :key="opt.value"
                        :label="opt.label"
                        :value="opt.value"
                      />
                    </el-select>
  
                    <!-- 文本域 -->
                    <el-input
                      v-else-if="config.value_type === 'textarea'"
                      v-model="formData[config.key]"
                      type="textarea"
                      :rows="3"
                      :placeholder="config.default_value || '请输入'"
                    />
  
                    <!-- JSON编辑器 -->
                    <el-input
                      v-else-if="config.value_type === 'json'"
                      v-model="formData[config.key]"
                      type="textarea"
                      :rows="5"
                      placeholder='{"key": "value"}'
                    />
  
                    <!-- 文件上传 -->
                    <div v-else-if="config.value_type === 'file'">
                      <div class="flex gap-2">
                        <el-input v-model="formData[config.key]" placeholder="点击选择按钮打开媒体库" readonly />
                        <el-button type="primary" @click="openMediaPicker(config.key)">
                          <el-icon class="mr-1"><Picture /></el-icon>
                          选择文件
                        </el-button>
                      </div>
                      <!-- 图片预览 -->
                      <div v-if="formData[config.key] && isImageFile(formData[config.key])" class="mt-2">
                        <el-image
                          :src="formData[config.key]"
                          fit="cover"
                          style="width: 100px; height: 100px; border-radius: 4px"
                          :preview-src-list="[formData[config.key]]"
                        />
                      </div>
                    </div>
  
                    <!-- 默认文本 -->
                    <el-input v-else v-model="formData[config.key]" />
                    </el-form-item>
  
                    <!-- 操作按钮区域 -->
                    <div class="border-t pt-3 mt-3 flex gap-2 justify-end bg-gray-50 -mx-4 -mb-4 px-4 pb-4 rounded-b">
                      <el-button size="small" @click="editConfig(config)">
                        <el-icon class="mr-1"><Edit /></el-icon>
                        编辑
                      </el-button>
                      <el-button
                        size="small"
                        type="danger"
                        @click="deleteConfig(config.id)"
                      >
                        <el-icon class="mr-1"><Delete /></el-icon>
                        删除
                      </el-button>
                    </div>
                  </el-card>
                </el-col>
              </el-row>
            </el-form>
  
            <!-- 保存按钮 -->
            <div class="mt-6 flex justify-center">
              <el-button type="primary" size="large" @click="saveConfigs">
                保存配置
              </el-button>
            </div>
          </el-tab-pane>
        </el-tabs>
      </el-card>
  
      <!-- 新增/编辑配置对话框 -->
      <el-dialog
        v-model="dialogVisible"
        :title="dialogMode === 'add' ? '新增配置' : '编辑配置'"
        width="600px"
      >
        <el-form :model="dialogForm" label-width="120px">
          <el-form-item label="配置分类">
            <el-select v-model="dialogForm.category" placeholder="请选择" style="width: 100%">
              <el-option label="系统配置" value="system" />
              <el-option label="上传配置" value="upload" />
              <el-option label="安全配置" value="security" />
              <el-option label="邮件配置" value="email" />
              <el-option label="支付配置" value="payment" />
              <el-option label="其他" value="other" />
            </el-select>
          </el-form-item>
          <el-form-item label="配置键名">
            <el-input v-model="dialogForm.key" placeholder="site_name" :disabled="dialogMode === 'edit'" />
          </el-form-item>
          <el-form-item label="配置名称">
            <el-input v-model="dialogForm.name" placeholder="网站名称" />
          </el-form-item>
          <el-form-item label="值类型">
            <el-select v-model="dialogForm.value_type" style="width: 100%">
              <el-option label="字符串" value="string" />
              <el-option label="数字" value="number" />
              <el-option label="布尔" value="boolean" />
              <el-option label="下拉选择" value="select" />
              <el-option label="文本域" value="textarea" />
              <el-option label="JSON" value="json" />
              <el-option label="文件" value="file" />
            </el-select>
          </el-form-item>
          <el-form-item label="配置值">
            <el-input v-model="dialogForm.value" placeholder="请输入默认值" />
          </el-form-item>
          <el-form-item label="默认值">
            <el-input v-model="dialogForm.default_value" placeholder="空值时的默认值" />
          </el-form-item>
          <el-form-item label="可选项" v-if="dialogForm.value_type === 'select'">
            <el-input
              v-model="dialogForm.options"
              type="textarea"
              :rows="3"
              placeholder='[{"label":"选项1","value":"1"}]'
            />
          </el-form-item>
          <el-form-item label="配置说明">
            <el-input v-model="dialogForm.description" type="textarea" :rows="2" />
          </el-form-item>
          <el-form-item label="是否公开">
            <el-switch v-model="dialogForm.is_public" :active-value="1" :inactive-value="0" />
            <span class="ml-2 text-sm text-gray-500">公开后前端可直接读取</span>
          </el-form-item>
          <el-form-item label="排序">
            <el-input-number v-model="dialogForm.sort" :min="0" />
          </el-form-item>
        </el-form>
        <template #footer>
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitDialog">确定</el-button>
        </template>
      </el-dialog>
    </div>
  </template>
  
  <script setup>
  import { ref, reactive, onMounted, getCurrentInstance } from 'vue'
  import { configApi } from '@/api/config'
  import { ElMessage, ElMessageBox } from 'element-plus'
  import { QuestionFilled, Edit, Delete, Picture } from '@element-plus/icons-vue'
  import { mediaFiles } from '@/api/media'
  
  const { proxy } = getCurrentInstance()
  
  const keyword = ref('')
  const activeCategory = ref('system')
  const groupedConfigs = ref({})
  const formData = reactive({})
  const dialogVisible = ref(false)
  const dialogMode = ref('add') // 'add' | 'edit'
  const dialogForm = reactive({
    id: null,
    category: 'system',
    key: '',
    value: '',
    value_type: 'string',
    name: '',
    description: '',
    options: '',
    default_value: '',
    is_public: 0,
    sort: 0
  })
  
  // 加载配置列表
  const loadConfigs = async () => {
    try {
      const data = await configApi.list({ kw: keyword.value })
      groupedConfigs.value = data.grouped || {}
      
      // 初始化表单数据
      Object.values(groupedConfigs.value).forEach(configs => {
        configs.forEach(cfg => {
          formData[cfg.key] = parseValue(cfg.value, cfg.value_type)
        })
      })
  
      // 默认选中第一个分类
      if (!activeCategory.value && Object.keys(groupedConfigs.value).length > 0) {
        activeCategory.value = Object.keys(groupedConfigs.value)[0]
      }
    } catch (e) {
      ElMessage.error('加载配置失败')
    }
  }
  
  // 解析配置值
  const parseValue = (value, type) => {
    if (!value) return type === 'boolean' ? false : ''
    if (type === 'boolean') return value === 'true' || value === '1'
    if (type === 'number') return Number(value)
    return value
  }
  
  // 解析选项（JSON数组）
  const parseOptions = (options) => {
    try {
      return JSON.parse(options)
    } catch {
      return []
    }
  }
  
  // 获取分类标签
  const getCategoryLabel = (cat) => {
    const map = {
      system: '系统配置',
      upload: '上传配置',
      security: '安全配置',
      email: '邮件配置',
      payment: '支付配置',
      other: '其他配置'
    }
    return map[cat] || cat
  }
  
  // 保存配置
  const saveConfigs = async () => {
    try {
      const currentConfigs = groupedConfigs.value[activeCategory.value] || []
      const updates = currentConfigs.map(cfg => ({
        key: cfg.key,
        value: String(formData[cfg.key] || '')
      }))
      
      await configApi.batchUpdate(updates)
      ElMessage.success('保存成功')
      loadConfigs()
    } catch (e) {
      ElMessage.error('保存失败')
    }
  }
  
  // 打开新增对话框
  const showAddDialog = () => {
    dialogMode.value = 'add'
    Object.assign(dialogForm, {
      id: null,
      category: activeCategory.value,
      key: '',
      value: '',
      value_type: 'string',
      name: '',
      description: '',
      options: '',
      default_value: '',
      is_public: 0,
      sort: 0
    })
    dialogVisible.value = true
  }
  
  // 编辑配置
  const editConfig = (config) => {
    dialogMode.value = 'edit'
    Object.assign(dialogForm, {
      id: config.id,
      category: config.category,
      key: config.key,
      value: config.value,
      value_type: config.value_type,
      name: config.name,
      description: config.description,
      options: config.options,
      default_value: config.default_value,
      is_public: config.is_public,
      sort: config.sort
    })
    dialogVisible.value = true
  }
  
  // 提交对话框
  const submitDialog = async () => {
    try {
      if (dialogMode.value === 'add') {
        await configApi.create(dialogForm)
        ElMessage.success('新增成功')
      } else {
        await configApi.update(dialogForm.id, dialogForm)
        ElMessage.success('更新成功')
      }
      dialogVisible.value = false
      loadConfigs()
    } catch (e) {
      ElMessage.error(e.response?.data?.detail || '操作失败')
    }
  }
  
  // 删除配置
  const deleteConfig = async (id) => {
    try {
      await ElMessageBox.confirm('确定删除该配置项？', '警告', { type: 'warning' })
      await configApi.delete(id)
      ElMessage.success('删除成功')
      loadConfigs()
    } catch (e) {
      if (e !== 'cancel') ElMessage.error('删除失败')
    }
  }
  
  // 打开媒体选择器
  const openMediaPicker = async (key) => {
    const pickMedia = proxy.$pickMedia
    if (!pickMedia) {
      ElMessage.error('媒体库未初始化，请检查插件配置')
      return
    }
    
    try {
      const files = await pickMedia({ selectMode: 'single' })
      if (files && files.length > 0) {
        const file = files[0]
        // 使用 SHA256 防止 ID 遍历攻击
        const fileUrl = file.sha256 ? mediaFiles.previewUrl(file.sha256) : (file.url || file.path || '')
        formData[key] = fileUrl
        ElMessage.success('文件选择成功')
      }
    } catch (e) {
      // 用户取消选择，不显示错误
    }
  }
  
  // 判断是否为图片文件
  const isImageFile = (url) => {
    if (!url) return false
    const imageExts = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.svg']
    return imageExts.some(ext => url.toLowerCase().includes(ext))
  }
  
  const handleCategoryChange = () => {
    // 切换分类时无需操作
  }
  
  onMounted(() => {
    loadConfigs()
  })
  </script>
  
  <style scoped>
  .config-manager :deep(.el-tabs__nav-wrap::after) {
    background-color: transparent;
  }
  
  /* 配置项卡片样式 */
  .config-item-card {
    transition: all 0.3s ease;
  }
  
  .config-item-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  }
  
  /* 表单项标签样式 */
  .config-item-card :deep(.el-form-item__label) {
    font-weight: 500;
    color: #303133;
  }
  
  /* 图片预览样式 */
  .config-item-card :deep(.el-image) {
    border: 1px solid #dcdfe6;
  }
  </style>
  