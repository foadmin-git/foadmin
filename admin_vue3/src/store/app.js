// 全局 App 级状态：用于标记“动态路由已注入”src\store\app.js
import { reactive } from 'vue'
export const appStore = reactive({
  routesReady: false
})

