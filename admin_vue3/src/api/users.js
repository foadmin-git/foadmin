//src\api\users.js
import http from './http'
export const listUsers = (params) => http.get('/api/admin/system/users', { params }).then(r=>r.data)
export const createUser = (data) => http.post('/api/admin/system/users', data).then(r=>r.data)
export const updateUser = (id, data) => http.put(`/api/admin/system/users/${id}`, data).then(r=>r.data)
export const deleteUser = (id) => http.delete(`/api/admin/system/users/${id}`).then(r=>r.data)
export const getUserRoles = (id) => http.get(`/api/admin/system/users/${id}/roles`).then(r=>r.data)
export const bindUserRoles = (id, role_ids) => http.put(`/api/admin/system/users/${id}/roles`, { role_ids }).then(r=>r.data)

// 复用已有
export const listLevels = () => http.get('/api/admin/system/levels').then(r=>r.data)
export const orgTree    = () => http.get('/api/admin/system/orgs/tree').then(r=>r.data)
