// src/api/auth.js
import http from './http'
export const loginApi = (data) => http.post('/api/common/login', data).then(r=>r.data)
export const meApi    = () => http.get('/api/common/me').then(r=>r.data)

// 获取验证码
export const getCaptchaApi = () => http.get('/api/common/captcha').then(r=>r.data)

// 刷新访问令牌
export const refreshApi = () => http.post('/api/common/refresh').then(r=>r.data)