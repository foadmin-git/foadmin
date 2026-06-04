// src/main.js
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import perm from './directives/perm'
import demoDisable from './directives/demoDisable'

// Tailwind
import './assets/css/tailwind.css'
// Import dark theme overrides.  When the `<html>` element has a class
// of `dark`, the styles in this file will apply to provide a dark mode.
import './assets/css/dark.css'

// Element Plus
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

// 全量引入 Element Plus Icons
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

// 注册媒体选择器插件
import MediaPickerPlugin from './plugins/mediaPicker'

// 初始化主题系统
import { initTheme } from './utils/theme'
initTheme()

// 全局隐藏滚动条 - 在应用启动前强制设置
const hideScrollbarStyle = document.createElement('style')
hideScrollbarStyle.id = 'global-hide-scrollbar'
hideScrollbarStyle.textContent = `
  *, *::before, *::after {
    scrollbar-width: none !important;
    -ms-overflow-style: none !important;
  }
  *::-webkit-scrollbar {
    width: 0px !important;
    height: 0px !important;
    display: none !important;
    -webkit-appearance: none !important;
  }
  *::-webkit-scrollbar-thumb,
  *::-webkit-scrollbar-track,
  *::-webkit-scrollbar-button,
  *::-webkit-scrollbar-corner {
    display: none !important;
    -webkit-appearance: none !important;
  }
  html, body {
    overflow: auto !important;
  }
`
document.head.appendChild(hideScrollbarStyle)

const app = createApp(App)
app.use(ElementPlus)
Object.entries(ElementPlusIconsVue).forEach(([name, component]) => {
  app.component(name, component)
})

app.directive('perm', perm)
app.directive('demo-disable', demoDisable)  // 演示账号禁用指令
app.use(router)
app.use(MediaPickerPlugin) // ← 全局安装，一行代码随处调用

app.mount('#app')
