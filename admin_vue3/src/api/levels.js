//src\api\levels.js
import http from './http'
export const listLevels = () => http.get('/api/admin/system/levels').then(r=>r.data)
export const createLevel = (data) => http.post('/api/admin/system/levels', data).then(r=>r.data)
export const updateLevel = (id, data) => http.put(`/api/admin/system/levels/${id}`, data).then(r=>r.data)
export const deleteLevel = (id) => http.delete(`/api/admin/system/levels/${id}`).then(r=>r.data)
