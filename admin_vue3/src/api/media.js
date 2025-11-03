// src/api/media.js
import http from './http'
import { userStore } from '@/store/user'

export const mediaDirs = {
  list: () => http.get('/api/admin/media/dirs').then(r => r.data),
  create: (data) => http.post('/api/admin/media/dirs', data).then(r => r.data),
  update: (id, data) => http.put(`/api/admin/media/dirs/${id}`, data).then(r => r.data),
  remove: (id) => http.delete(`/api/admin/media/dirs/${id}`).then(r => r.data),
}

export const mediaTags = {
  list: () => http.get('/api/admin/media/tags').then(r => r.data),
}

export const mediaFiles = {
  list: (params) => http.get('/api/admin/media/list', { params }).then(r => r.data),
  rename: (id, name) => http.put(`/api/admin/media/${id}/rename`, { name }).then(r => r.data),
  softDelete: (id) => http.delete(`/api/admin/media/${id}`).then(r => r.data),
  hardDelete: (id) => http.delete(`/api/admin/media/${id}/permanent`).then(r => r.data),
  restore: (id) => http.put(`/api/admin/media/${id}/restore`).then(r => r.data),
  setTags: (id, tags) => http.put(`/api/admin/media/${id}/tags`, { tags }).then(r => r.data),
  // 使用 SHA256 哈希值访问，防止通过遍历ID批量下载（SHA256已足够安全，无需签名）
  downloadUrl: (sha256) => {
    const base = http.defaults.baseURL?.replace(/\/$/, '') || ''
    return `${base}/api/admin/media/download/${sha256}`
  },
  previewUrl: (sha256) => {
    const base = http.defaults.baseURL?.replace(/\/$/, '') || ''
    return `${base}/api/admin/media/preview/${sha256}`
  }
}

// 自定义上传（配合 el-upload）
export async function uploadMedia({ file, data }){
  const fd = new FormData()
  fd.append('file', file)
  Object.entries(data || {}).forEach(([k,v]) => v!=null && fd.append(k, v))
  const res = await http.post('/api/admin/media/upload', fd, { headers: { 'Content-Type': 'multipart/form-data' } })
  return res.data
}

