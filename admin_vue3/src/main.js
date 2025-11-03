// src/main.js
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import perm from './directives/perm'

// Tailwind
import './assets/css/tailwind.css'

// Element Plus
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

// 全量引入 Element Plus Icons
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

// 注册媒体选择器插件
import MediaPickerPlugin from './plugins/mediaPicker'

const app = createApp(App)
app.use(ElementPlus)
Object.entries(ElementPlusIconsVue).forEach(([name, component]) => {
  app.component(name, component)
})

app.directive('perm', perm)
app.use(router)
app.use(MediaPickerPlugin) // ← 全局安装，一行代码随处调用

app.mount('#app')
