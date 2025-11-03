//src\api\perms.js
import http from './http'
export const listPerms = (params) => http.get('/api/admin/system/perms', { params }).then(r=>r.data)
export const createPerm = (data) => http.post('/api/admin/system/perms', data).then(r=>r.data)
export const updatePerm = (id, data) => http.put(`/api/admin/system/perms/${id}`, data).then(r=>r.data)
export const deletePerm = (id) => http.delete(`/api/admin/system/perms/${id}`).then(r=>r.data)
