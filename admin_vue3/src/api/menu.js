// src/api/menu.js
import http from './http'
export const adminMenusApi = () => http.get('/api/admin/menus').then(r=>r.data)