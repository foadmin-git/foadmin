// src/directives/perm.js
import { userStore } from '@/store/user'
export default {
  mounted(el, binding){
    const need = binding.value
    if (!need) return
    if (!userStore.perms.includes(need)) {
      el.parentNode && el.parentNode.removeChild(el)
    }
  }
}
