// src/api/loginlog.js
import http from './http'

export const listLoginLogs = (params) =>
  http.get('/api/admin/logs/login', { params }).then(r => r.data)

export const getLoginLog = (id) =>
  http.get(`/api/admin/logs/login/${id}`).then(r => r.data)

export const exportLoginLogs = async (params = {}) => {
  const res = await http.get('/api/admin/logs/login/export', {
    params,
    responseType: 'blob',
    autoSuccess: false,
  })
  return res.data
}

export const purgeLoginLogs = (params) =>
  http.delete('/api/admin/logs/login', { params }).then(r => r.data)
