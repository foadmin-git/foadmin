// src/directives/demoDisable.js
// 演示账号禁用指令
// 用法: v-demo-disable 或 v-demo-disable="true" (禁用按钮) / v-demo-disable="'hide'" (隐藏按钮)
import { userStore } from '@/store/user'

export default {
  mounted(el, binding) {
    // 如果不是演示账号，不做任何处理
    if (!userStore.is_demo) return
    
    const mode = binding.value || 'disable'  // 默认禁用模式
    
    if (mode === 'hide') {
      // 隐藏模式：直接移除元素
      el.parentNode && el.parentNode.removeChild(el)
    } else {
      // 禁用模式：添加禁用属性和样式
      el.disabled = true
      el.classList.add('is-disabled', 'demo-disabled')
      // 添加提示
      el.setAttribute('title', '演示账号无操作权限')
      // 阻止点击事件
      el.style.pointerEvents = 'none'
      el.style.opacity = '0.5'
      el.style.cursor = 'not-allowed'
    }
  },
  updated(el, binding) {
    // 响应状态变化
    if (!userStore.is_demo) {
      // 如果不再是演示账号，恢复元素
      el.disabled = false
      el.classList.remove('is-disabled', 'demo-disabled')
      el.removeAttribute('title')
      el.style.pointerEvents = ''
      el.style.opacity = ''
      el.style.cursor = ''
      return
    }
    
    const mode = binding.value || 'disable'
    if (mode === 'hide') {
      el.parentNode && el.parentNode.removeChild(el)
    } else {
      el.disabled = true
      el.classList.add('is-disabled', 'demo-disabled')
      el.setAttribute('title', '演示账号无操作权限')
      el.style.pointerEvents = 'none'
      el.style.opacity = '0.5'
      el.style.cursor = 'not-allowed'
    }
  }
}
