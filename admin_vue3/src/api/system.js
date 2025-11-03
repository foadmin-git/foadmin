// src/api/system.js
import http from './http'

// 获取系统版本信息
export const getVersionInfoApi = () => http.get('/api/admin/system/info/version').then(r => r.data)

// 检查系统更新
export const checkForUpdatesApi = () => http.get('/api/admin/system/info/check-update').then(r => r.data)