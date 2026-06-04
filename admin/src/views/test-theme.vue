<!-- 测试主题功能的简单页面 -->
<template>
  <div class="p-8">
    <h1 class="text-2xl font-bold mb-4">主题测试页面</h1>
    
    <div class="mb-4">
      <p class="mb-2">当前主题色：<code class="bg-gray-100 px-2 py-1 rounded">{{ currentColor }}</code></p>
      <button 
        class="px-4 py-2 text-white rounded"
        :style="{ backgroundColor: 'var(--el-color-primary)' }"
      >
        使用 CSS 变量的按钮
      </button>
    </div>

    <div class="space-y-4">
      <el-button type="primary">Element Plus Primary 按钮</el-button>
      <el-button type="success">Success 按钮</el-button>
      <el-button type="warning">Warning 按钮</el-button>
      
      <div class="mt-4">
        <p>直接在元素上应用主题色：</p>
        <div 
          class="inline-block px-6 py-3 text-white rounded font-bold"
          :style="{ backgroundColor: themeColor }"
        >
          动态主题色按钮 ({{ themeColor }})
        </div>
      </div>
    </div>

    <div class="mt-8 p-4 bg-gray-50 rounded">
      <h2 class="font-bold mb-2">调试信息：</h2>
      <pre class="text-xs">{{ debugInfo }}</pre>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { loadSavedTheme } from '@/utils/theme'

const currentColor = ref('')
const themeColor = ref('#0031ff')
const debugInfo = ref('')

onMounted(() => {
  const savedTheme = loadSavedTheme()
  if (savedTheme) {
    themeColor.value = savedTheme.primary
    currentColor.value = savedTheme.primary
  }
  
  // 读取实际应用的 CSS 变量
  const root = document.documentElement
  const elPrimary = getComputedStyle(root).getPropertyValue('--el-color-primary')
  const themePrimary = getComputedStyle(root).getPropertyValue('--theme-primary')
  
  debugInfo.value = JSON.stringify({
    savedTheme,
    'CSS --el-color-primary': elPrimary.trim(),
    'CSS --theme-primary': themePrimary.trim(),
    '当前 themeColor': themeColor.value
  }, null, 2)
})
</script>
