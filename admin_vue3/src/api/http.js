// src/api/http.js
import axios from 'axios'
import { ElMessage } from 'element-plus'
import { userStore } from '@/store/user'

const http = axios.create({
  baseURL: import.meta.env.VITE_API_BASE || 'https://你的服务端域名',
  timeout: 15000
})

// 请求拦截：加 token
http.interceptors.request.use(cfg => {
  if (userStore.token) cfg.headers.Authorization = `Bearer ${userStore.token}`
  return cfg
})

// 响应拦截：统一成功/失败提示
http.interceptors.response.use(
  (res) => {
    // ---------- 统一成功提示 ----------
    // 约定：
    // 1) 非 GET 请求默认弹“操作成功”，除非：
    //    - 后端返回 data.message，则用它；或
    //    - 配置了 config.successMsg 覆盖；或
    //    - 显式关闭 config.autoSuccess=false
    // 2) GET 默认不弹；需要可传 successMsg 或 autoSuccess=true
    const method = (res.config.method || '').toLowerCase()
    const auto = res.config.autoSuccess ?? (method !== 'get') // GET 默认 false，其他默认 true
    if (auto) {
      const msg =
        res.config.successMsg ||
        res.data?.message ||
        (res.data?.ok ? '操作成功' : null)
      if (msg) ElMessage.success(msg)
    }
    return res
  },
  (err) => {
    // ---------- 统一失败提示 ----------
    const status = err.response?.status

    // 401：清理并跳转登录
    if (status === 401) {
      userStore.clear()
      window.location.href = '/login'
      return Promise.reject(err)
    }

    // Pydantic 的 detail 可能是数组，也可能是字符串
    const detail = err.response?.data?.detail
    let msg
    if (Array.isArray(detail)) {
      // 优先 msg/message，退化 loc/type
      msg = detail
        .map(d =>
          d?.msg || d?.message ||
          (d?.loc ? `[${(d.loc||[]).join('.')}]` : '') ||
          d?.type || ''
        )
        .filter(Boolean)
        .join('；')
    } else {
      msg =
        detail ||
        err.response?.data?.message ||
        err.message ||
        '请求失败'
    }

    // 允许局部关闭错误提示：config.silent=true
    const silent = err.config?.silent
    if (!silent) ElMessage.error(msg)

    return Promise.reject(err)
  }
)

export default http
