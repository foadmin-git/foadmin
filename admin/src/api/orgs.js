//src\api\orgs.js
import http from './http'
export const orgTree = () => http.get('/api/admin/system/orgs/tree').then(r=>r.data)
export const createOrg = (data) => http.post('/api/admin/system/orgs', data).then(r=>r.data)
export const updateOrg = (id, data) => http.put(`/api/admin/system/orgs/${id}`, data).then(r=>r.data)
export const deleteOrg = (id) => http.delete(`/api/admin/system/orgs/${id}`).then(r=>r.data)
