//src\api\roles.js
import http from './http'
export const listRoles = () => http.get('/api/admin/system/roles').then(r=>r.data)
export const createRole = (data) => http.post('/api/admin/system/roles', data).then(r=>r.data)
export const updateRole = (id, data) => http.put(`/api/admin/system/roles/${id}`, data).then(r=>r.data)
export const deleteRole = (id) => http.delete(`/api/admin/system/roles/${id}`).then(r=>r.data)
export const getRolePerms = (id) => http.get(`/api/admin/system/roles/${id}/perms`).then(r=>r.data)
export const bindRolePerms = (id, perm_ids) => http.put(`/api/admin/system/roles/${id}/perms`, { perm_ids }).then(r=>r.data)
