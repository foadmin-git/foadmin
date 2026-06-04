// src/utils/theme.js

// 预设主题配置
export const presetThemes = [
  {
    id: 'default-blue',
    name: '默认蓝',
    primary: '#0031ff',
    primaryLight: '#0093ff',
    primaryDark: '#0028d8',
    description: '经典商务蓝'
  },
  {
    id: 'elegant-purple',
    name: '优雅紫',
    primary: '#722ed1',
    primaryLight: '#b37feb',
    primaryDark: '#531dab',
    description: '神秘优雅紫'
  },
  {
    id: 'fresh-green',
    name: '清新绿',
    primary: '#52c41a',
    primaryLight: '#95de64',
    primaryDark: '#389e0d',
    description: '自然清新绿'
  },
  {
    id: 'passion-red',
    name: '热情红',
    primary: '#f5222d',
    primaryLight: '#ff7875',
    primaryDark: '#cf1322',
    description: '活力热情红'
  },
  {
    id: 'vibrant-orange',
    name: '活力橙',
    primary: '#fa8c16',
    primaryLight: '#ffc069',
    primaryDark: '#d46b08',
    description: '温暖活力橙'
  },
  {
    id: 'tech-cyan',
    name: '科技青',
    primary: '#13c2c2',
    primaryLight: '#5cdbd3',
    primaryDark: '#08979c',
    description: '科技清新青'
  },
  {
    id: 'geek-black',
    name: '极客黑',
    primary: '#262626',
    primaryLight: '#595959',
    primaryDark: '#141414',
    description: '极简极客黑'
  },
  {
    id: 'rose-pink',
    name: '玫瑰粉',
    primary: '#eb2f96',
    primaryLight: '#ff85c0',
    primaryDark: '#c41d7f',
    description: '浪漫玫瑰粉'
  }
]

// 从 HEX 颜色生成 RGB 值
export function hexToRgb(hex) {
  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
  return result ? {
    r: parseInt(result[1], 16),
    g: parseInt(result[2], 16),
    b: parseInt(result[3], 16)
  } : { r: 0, g: 0, b: 0 }
}

// 应用主题到 CSS 变量
export function applyTheme(theme) {
  const root = document.documentElement
  const rgb = hexToRgb(theme.primary)
  const rgbLight = hexToRgb(theme.primaryLight)
  const rgbDark = hexToRgb(theme.primaryDark)
  
  // 设置主题 CSS 变量
  root.style.setProperty('--theme-primary', theme.primary)
  root.style.setProperty('--theme-primary-light', theme.primaryLight)
  root.style.setProperty('--theme-primary-dark', theme.primaryDark)
  
  // 设置 RGB 版本（用于透明度）
  root.style.setProperty('--theme-primary-rgb', `${rgb.r}, ${rgb.g}, ${rgb.b}`)
  root.style.setProperty('--theme-primary-light-rgb', `${rgbLight.r}, ${rgbLight.g}, ${rgbLight.b}`)
  root.style.setProperty('--theme-primary-dark-rgb', `${rgbDark.r}, ${rgbDark.g}, ${rgbDark.b}`)
  
  // 直接设置 Element Plus 主题色（关键修复）
  root.style.setProperty('--el-color-primary', theme.primary)
  root.style.setProperty('--el-color-primary-light-1', theme.primaryLight)
  root.style.setProperty('--el-color-primary-light-2', theme.primaryLight)
  root.style.setProperty('--el-color-primary-light-3', theme.primaryLight)
  root.style.setProperty('--el-color-primary-dark-1', theme.primaryDark)
  
  // 设置侧边栏高亮色
  root.style.setProperty('--nav-highlight-color', theme.primary)
  
  console.log('🎨 主题已应用:', theme.name, theme.primary)
  
  // 保存到 localStorage
  localStorage.setItem('theme-config', JSON.stringify({
    id: theme.id,
    name: theme.name,
    primary: theme.primary,
    primaryLight: theme.primaryLight,
    primaryDark: theme.primaryDark,
    isCustom: theme.isCustom || false
  }))
}

// 加载保存的主题
export function loadSavedTheme() {
  try {
    const saved = localStorage.getItem('theme-config')
    if (saved) {
      return JSON.parse(saved)
    }
  } catch (e) {
    console.error('加载主题失败:', e)
  }
  return null
}

// 初始化主题
export function initTheme() {
  const savedTheme = loadSavedTheme()
  if (savedTheme) {
    applyTheme(savedTheme)
    return savedTheme
  }
  
  // 默认使用第一个预设主题
  const defaultTheme = presetThemes[0]
  applyTheme(defaultTheme)
  return defaultTheme
}
