// src/api/config.js
import http from './http'

export const configApi = {
  // 获取配置列表（分组）
  list: (params) => http.get('/api/admin/system/config', { params }).then(r => r.data),
  
  // 获取公开配置（无需登录）
  getPublic: () => http.get('/api/admin/system/config/public').then(r => r.data),
  
  // 根据key获取单个配置
  getByKey: (key) => http.get(`/api/admin/system/config/${key}`).then(r => r.data),
  
  // 新增配置
  create: (data) => http.post('/api/admin/system/config', data).then(r => r.data),
  
  // 更新配置
  update: (id, data) => http.put(`/api/admin/system/config/${id}`, data).then(r => r.data),
  
  // 删除配置
  delete: (id) => http.delete(`/api/admin/system/config/${id}`).then(r => r.data),
  
  // 批量更新配置值
  batchUpdate: (configs) => http.post('/api/admin/system/config/batch', { configs }).then(r => r.data),
}
