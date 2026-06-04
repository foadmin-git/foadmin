<!-- src/components/ThemePicker/index.vue -->
<template>
  <el-drawer
    v-model="visible"
    title="主题设置"
    direction="rtl"
    size="520px"
    :with-header="true"
    :show-close="true"
  >
    <!-- 当前主题 Banner -->
    <div class="current-theme-banner" :style="{ background: currentThemeGradient }">
      <div class="banner-content">
        <div class="banner-info">
          <div class="banner-label">当前主题</div>
          <div class="banner-name">{{ currentTheme?.name || '默认蓝' }}</div>
        </div>
        <div class="banner-colors">
          <div class="color-dot" :style="{ background: currentTheme?.primary }"></div>
          <div class="color-dot" :style="{ background: currentTheme?.primaryLight }"></div>
          <div class="color-dot" :style="{ background: currentTheme?.primaryDark }"></div>
        </div>
      </div>
    </div>

    <div class="theme-drawer-content">
      <div class="theme-settings">
      <!-- 预设主题 -->
      <div class="section">
        <h3 class="section-title">预设主题</h3>
        <div class="theme-grid">
          <div
            v-for="theme in presetThemes"
            :key="theme.id"
            class="theme-card"
            :class="{ active: currentTheme?.id === theme.id }"
            @click="selectTheme(theme)"
          >
            <div class="theme-preview">
              <div class="color-block primary" :style="{ background: theme.primary }"></div>
              <div class="color-block light" :style="{ background: theme.primaryLight }"></div>
              <div class="color-block dark" :style="{ background: theme.primaryDark }"></div>
            </div>
            <div class="theme-info">
              <div class="theme-name">{{ theme.name }}</div>
              <div class="theme-desc">{{ theme.description }}</div>
            </div>
            <el-icon v-if="currentTheme?.id === theme.id" class="check-icon" color="#52c41a" :size="20">
              <CircleCheckFilled />
            </el-icon>
          </div>
        </div>
      </div>

      <!-- 自定义主题 -->
      <div class="section">
        <h3 class="section-title">自定义主题</h3>
        <div class="custom-theme">
          <div class="color-picker-group">
            <div class="picker-item">
              <label>主色调</label>
              <el-color-picker v-model="customColors.primary" @change="applyCustomTheme" />
              <span class="color-value">{{ customColors.primary }}</span>
            </div>
            <div class="picker-item">
              <label>浅色变体</label>
              <el-color-picker v-model="customColors.primaryLight" @change="applyCustomTheme" />
              <span class="color-value">{{ customColors.primaryLight }}</span>
            </div>
            <div class="picker-item">
              <label>深色变体</label>
              <el-color-picker v-model="customColors.primaryDark" @change="applyCustomTheme" />
              <span class="color-value">{{ customColors.primaryDark }}</span>
            </div>
          </div>
          
          <div class="preview-section">
            <div class="preview-title">
              <svg class="preview-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z" fill="currentColor"/>
              </svg>
              预览效果
            </div>
            <div class="preview-bar" :style="{ background: customColors.primary }">
              主色调
            </div>
            <div class="preview-buttons">
              <el-button :style="{ background: customColors.primaryLight, borderColor: customColors.primaryLight, color: '#fff' }">
                浅色按钮
              </el-button>
              <el-button :style="{ background: customColors.primary, borderColor: customColors.primary, color: '#fff' }">
                主色按钮
              </el-button>
              <el-button :style="{ background: customColors.primaryDark, borderColor: customColors.primaryDark, color: '#fff' }">
                深色按钮
              </el-button>
            </div>
          </div>

          <el-button type="primary" @click="saveCustomTheme" class="save-btn">
            保存自定义主题
          </el-button>
        </div>
      </div>
    </div>
  </div>
  </el-drawer>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { CircleCheckFilled } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { presetThemes, applyTheme, loadSavedTheme } from '@/utils/theme'

const props = defineProps({
  modelValue: Boolean
})

const emit = defineEmits(['update:modelValue'])

const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

const currentTheme = ref(loadSavedTheme())
const customColors = ref({
  primary: '#0031ff',
  primaryLight: '#0093ff',
  primaryDark: '#0028d8'
})

// 当前主题的渐变背景
const currentThemeGradient = computed(() => {
  if (!currentTheme.value) return 'linear-gradient(135deg, #0031ff 0%, #0093ff 100%)'
  const { primary, primaryLight } = currentTheme.value
  return `linear-gradient(135deg, ${primary} 0%, ${primaryLight} 100%)`
})

function selectTheme(theme) {
  console.log('👆 选择主题:', theme.name, theme.primary)
  currentTheme.value = theme
  applyTheme(theme)
  console.log('✅ 主题切换完成')
  ElMessage.success(`已切换到"${theme.name}"主题`)
}

function applyCustomTheme() {
  // 实时预览在模板中通过 style 绑定实现
}

function saveCustomTheme() {
  const customTheme = {
    id: 'custom',
    name: '自定义主题',
    primary: customColors.value.primary,
    primaryLight: customColors.value.primaryLight,
    primaryDark: customColors.value.primaryDark,
    isCustom: true,
    description: '用户自定义'
  }
  
  currentTheme.value = customTheme
  applyTheme(customTheme)
  ElMessage.success('自定义主题已保存并应用')
}

watch(visible, (val) => {
  if (val && currentTheme.value) {
    customColors.value = {
      primary: currentTheme.value.primary,
      primaryLight: currentTheme.value.primaryLight || currentTheme.value.primary,
      primaryDark: currentTheme.value.primaryDark || currentTheme.value.primary
    }
  }
})
</script>

<style scoped>
/* 隐藏整个抽屉的滚动条 - 包括浏览器默认滚动条 */
:deep(.el-drawer) {
  overflow: hidden !important;
}

:deep(.el-drawer__body) {
  padding: 0 !important;
  overflow: hidden !important;
}

:deep(.el-drawer__body)::-webkit-scrollbar {
  width: 0 !important;
  height: 0 !important;
  display: none !important;
}

:deep(.el-drawer__body) {
  scrollbar-width: none !important;
  -ms-overflow-style: none !important;
}

/* 主题设置容器 - 可滚动区域 */
.theme-drawer-content {
  height: 100%;
  overflow-y: auto;
  overflow-x: hidden;
}

.theme-drawer-content::-webkit-scrollbar {
  width: 0 !important;
  height: 0 !important;
  display: none !important;
}

.theme-drawer-content {
  scrollbar-width: none !important;
  -ms-overflow-style: none !important;
}

/* 当前主题 Banner */
.current-theme-banner {
  padding: 18px 20px 16px;
  margin-bottom: 0;
  border-radius: 0;
  position: relative;
  overflow: hidden;
}

.current-theme-banner::before {
  content: '';
  position: absolute;
  top: -40%;
  right: -15%;
  width: 160px;
  height: 160px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
}

.current-theme-banner::after {
  content: '';
  position: absolute;
  bottom: -25%;
  left: -8%;
  width: 120px;
  height: 120px;
  background: rgba(255, 255, 255, 0.08);
  border-radius: 50%;
}

.banner-content {
  position: relative;
  z-index: 1;
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #fff;
}

.banner-info {
  flex: 1;
}

.banner-label {
  font-size: 11px;
  opacity: 0.9;
  margin-bottom: 3px;
  letter-spacing: 0.5px;
  font-weight: 500;
}

.banner-name {
  font-size: 18px;
  font-weight: 700;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.banner-colors {
  display: flex;
  gap: 6px;
  align-items: center;
}

.color-dot {
  width: 26px;
  height: 26px;
  border-radius: 50%;
  border: 2px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
  transition: transform 0.2s;
}

.color-dot:hover {
  transform: scale(1.1);
}

.theme-settings {
  padding: 18px 20px 20px;
}

.section {
  margin-bottom: 24px;
}

.section:last-child {
  margin-bottom: 0;
}

.section-title {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 14px;
  padding-bottom: 10px;
  border-bottom: 2px solid #e4e7ed;
  position: relative;
}

.section-title::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 50px;
  height: 2px;
  background: var(--el-color-primary);
}

.theme-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
}

.theme-card {
  position: relative;
  border: 2px solid #e4e7ed;
  border-radius: 8px;
  padding: 12px;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  background: #fff;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.theme-card:hover {
  border-color: var(--el-color-primary);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.theme-card.active {
  border-color: var(--el-color-primary);
  background: linear-gradient(135deg, rgba(var(--el-color-primary-rgb), 0.05) 0%, rgba(var(--el-color-primary-rgb), 0.02) 100%);
  box-shadow: 0 3px 10px rgba(var(--el-color-primary-rgb), 0.12);
}

.check-icon {
  position: absolute;
  top: 6px;
  right: 6px;
  color: var(--el-color-primary) !important;
}

.theme-preview {
  display: flex;
  gap: 5px;
  height: 40px;
}

.color-block {
  flex: 1;
  border-radius: 4px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
  transition: transform 0.2s;
}

.theme-card:hover .color-block {
  transform: scale(1.03);
}

.theme-info {
  text-align: center;
}

.theme-name {
  font-size: 13px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 3px;
}

.theme-desc {
  font-size: 11px;
  color: #909399;
  line-height: 1.3;
}

.custom-theme {
  background: linear-gradient(135deg, #f5f7fa 0%, #fafbfc 100%);
  padding: 18px;
  border-radius: 8px;
  border: 1px solid #e4e7ed;
}

.color-picker-group {
  display: grid;
  grid-template-columns: 1fr;
  gap: 14px;
  margin-bottom: 18px;
}

.picker-item {
  display: flex;
  align-items: center;
  gap: 10px;
  background: #fff;
  padding: 10px 14px;
  border-radius: 6px;
  border: 1px solid #e4e7ed;
  transition: all 0.25s;
}

.picker-item:hover {
  border-color: var(--el-color-primary);
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.04);
}

.picker-item label {
  font-size: 13px;
  color: #606266;
  font-weight: 500;
  min-width: 65px;
}

.color-value {
  font-size: 12px;
  color: #909399;
  font-family: 'Courier New', monospace;
  margin-left: auto;
  background: #f5f7fa;
  padding: 3px 6px;
  border-radius: 3px;
}

.preview-section {
  background: #fff;
  padding: 16px;
  border-radius: 6px;
  margin-bottom: 16px;
  border: 1px solid #e4e7ed;
}

.preview-title {
  font-size: 13px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 12px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.preview-icon {
  width: 16px;
  height: 16px;
  color: var(--el-color-primary);
  flex-shrink: 0;
}

.preview-bar {
  padding: 10px;
  color: #fff;
  font-weight: 600;
  border-radius: 4px;
  margin-bottom: 12px;
  text-align: center;
  font-size: 13px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
  transition: all 0.3s;
}

.preview-buttons {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.preview-buttons .el-button {
  padding: 6px 12px;
  font-size: 12px;
  height: auto;
}

.save-btn {
  width: 100%;
  margin-top: 6px;
  height: 34px;
  font-size: 13px;
  font-weight: 500;
}

/* 抽屉样式优化 */
:deep(.el-drawer__header) {
  margin-bottom: 0;
  padding: 14px 20px 12px;
  border-bottom: none;
}

:deep(.el-drawer__title) {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

:deep(.el-drawer__close-btn) {
  font-size: 18px;
  color: #909399;
}
</style>
