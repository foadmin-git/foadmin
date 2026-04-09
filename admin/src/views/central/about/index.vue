<!-- src/views/central/about/index.vue -->
<template>
  <div class="p-4 bg-white rounded shadow-sm">
    <h1 class="text-2xl font-bold mb-6">系统信息</h1>
    
    <!-- 项目基本信息 -->
    <el-card class="mb-6">
      <template #header>
        <div class="flex items-center">
          <el-icon class="mr-2"><InfoFilled /></el-icon>
          <span>项目基本信息</span>
        </div>
      </template>
      <el-descriptions :column="1" border>
        <el-descriptions-item label="项目名称">Foadmin 后台管理系统</el-descriptions-item>
        <el-descriptions-item label="项目描述">基于Vue3 + FastAPI的企业级后台管理系统</el-descriptions-item>
        <el-descriptions-item label="官方网站">
          <el-link href="https://www.foadmin.com" target="_blank">https://www.foadmin.com</el-link>
        </el-descriptions-item>
        <el-descriptions-item label="文档地址">
          <el-link href="https://www.foadmin.com/docs" target="_blank">https://www.foadmin.com/docs</el-link>
        </el-descriptions-item>
        <el-descriptions-item label="版权信息">© 2025 厦门市知序技术服务工作室</el-descriptions-item>
      </el-descriptions>
    </el-card>
    
    <!-- 版本信息 -->
    <el-card class="mb-6">
      <template #header>
        <div class="flex items-center">
          <el-icon class="mr-2"><Collection /></el-icon>
          <span>版本信息</span>
        </div>
      </template>
      <el-descriptions :column="1" border>
        <el-descriptions-item label="当前版本">
          <div class="flex items-center">
            <span>{{ systemInfo.current_version }}</span>
            <el-button 
              type="primary" 
              size="small" 
              class="ml-4"
              @click="checkVersion"
              :loading="checkingVersion"
            >
              {{ checkingVersion ? '检查中...' : '检查更新' }}
            </el-button>
          </div>
        </el-descriptions-item>
        <el-descriptions-item label="最新版本">{{ systemInfo.latest_version }}</el-descriptions-item>
        <el-descriptions-item label="构建时间">{{ systemInfo.build_time }}</el-descriptions-item>
      </el-descriptions>
      
      <!-- 版本更新提示 -->
      <div v-if="showUpdateAlert" class="mt-4">
        <el-alert
          title="发现新版本"
          type="warning"
          show-icon
          :closable="false"
        >
          <p>当前版本: {{ systemInfo.current_version }}</p>
          <p>最新版本: {{ systemInfo.latest_version }}</p>
          <p class="mt-2">更新内容:</p>
          <ul class="list-disc pl-5 mt-1">
            <li v-for="(item, index) in systemInfo.release_notes" :key="index">{{ item }}</li>
          </ul>
          <div class="mt-3">
            <el-button type="primary" @click="goToDownload">前往下载</el-button>
            <el-button @click="dismissUpdate">稍后提醒</el-button>
          </div>
        </el-alert>
      </div>
    </el-card>
    
    <!-- 技术栈信息 -->
    <el-card>
      <template #header>
        <div class="flex items-center">
          <el-icon class="mr-2"><Setting /></el-icon>
          <span>技术栈信息</span>
        </div>
      </template>
      <el-tabs type="border-card">
        <el-tab-pane label="前端技术栈">
          <el-descriptions :column="1" border>
            <el-descriptions-item label="框架">Vue 3 Composition API</el-descriptions-item>
            <el-descriptions-item label="构建工具">Vite 7.x</el-descriptions-item>
            <el-descriptions-item label="UI框架">Element Plus</el-descriptions-item>
            <el-descriptions-item label="样式框架">Tailwind CSS</el-descriptions-item>
            <el-descriptions-item label="HTTP客户端">Axios</el-descriptions-item>
            <el-descriptions-item label="状态管理">Pinia</el-descriptions-item>
            <el-descriptions-item label="路由">Vue Router 4</el-descriptions-item>
          </el-descriptions>
        </el-tab-pane>
        <el-tab-pane label="后端技术栈">
          <el-descriptions :column="1" border>
            <el-descriptions-item label="框架">FastAPI</el-descriptions-item>
            <el-descriptions-item label="ORM">SQLAlchemy 2.0</el-descriptions-item>
            <el-descriptions-item label="数据库">MySQL 8.0+</el-descriptions-item>
            <el-descriptions-item label="数据验证">Pydantic 2.8</el-descriptions-item>
            <el-descriptions-item label="Web服务器">Uvicorn</el-descriptions-item>
            <el-descriptions-item label="JWT认证">PyJWT</el-descriptions-item>
          </el-descriptions>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { InfoFilled, Collection, Setting } from '@element-plus/icons-vue'
import { getVersionInfoApi, checkForUpdatesApi } from '@/api/system'

// 系统信息
const systemInfo = ref({
  current_version: 'v1.0.0',
  latest_version: 'v1.0.0',
  build_time: '',
  release_notes: []
})

// 版本检查相关
const checkingVersion = ref(false)
const showUpdateAlert = ref(false)

// 获取系统信息
const fetchSystemInfo = async () => {
  try {
    const res = await getVersionInfoApi()
    systemInfo.value = res.data
  } catch (err) {
    ElMessage.error('获取系统信息失败')
  }
}

// 检查版本更新
const checkVersion = async () => {
  checkingVersion.value = true
  try {
    const res = await checkForUpdatesApi()
    const data = res.data
    
    systemInfo.value.latest_version = data.latest_version
    systemInfo.value.release_notes = data.release_notes
    
    if (data.has_update) {
      showUpdateAlert.value = true
      ElMessage.success('检查完成，发现新版本！')
    } else {
      ElMessage.info('当前已是最新版本')
    }
  } catch (err) {
    ElMessage.error('检查失败，请稍后重试')
  } finally {
    checkingVersion.value = false
  }
}

// 前往下载
const goToDownload = () => {
  window.open(data.download_url || 'https://github.com/foadmin/foadmin/releases', '_blank')
}

// 忽略更新
const dismissUpdate = () => {
  showUpdateAlert.value = false
  ElMessage.info('已忽略此次更新提醒')
}

// 初始化
onMounted(() => {
  fetchSystemInfo()
})
</script>

<style scoped>
:deep(.el-descriptions__label) {
  width: 120px !important;
}
</style>