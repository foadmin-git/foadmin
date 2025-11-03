// src/plugins/mediaPicker.js
import { createVNode, render } from 'vue'
import MediaPicker from '@/components/MediaPicker/index.vue'

export default {
  install(app){
    const open = (options = {}) => {
      return new Promise((resolve, reject) => {
        const container = document.createElement('div')

        const vnode = createVNode(MediaPicker, {
          modelValue: true,
          ...options,
          'onUpdate:modelValue': (v) => {
            if (!v) { render(null, container); container.remove() }
          },
          onConfirm: (list) => { resolve(list); render(null, container); container.remove() },
          onCancel: () => { reject(new Error('cancel')); render(null, container); container.remove() },
        })

        // ★ 关键：把全局 app 上下文传给 vnode，这样全局指令/组件/插件可用（包含 v-perm）
        vnode.appContext = app._context

        render(vnode, container)
        document.body.appendChild(container)
      })
    }

    app.config.globalProperties.$pickMedia = open
  }
}
