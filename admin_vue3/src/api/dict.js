// src/api/dict.js
// 数据字典管理API
import http from './http'

// ==================== 字典类型 ====================

/**
 * 获取字典类型列表（分页）
 * @param {Object} params { page, size, name, code, status }
 */
export const getDictTypesApi = (params) => 
  http.get('/api/admin/system/dict/types', { params }).then(r => r.data)

/**
 * 创建字典类型
 * @param {Object} data { name, code, description, status, sort }
 */
export const createDictTypeApi = (data) => 
  http.post('/api/admin/system/dict/types', data).then(r => r.data)

/**
 * 更新字典类型
 * @param {Number} id - 字典类型ID
 * @param {Object} data - 更新数据
 */
export const updateDictTypeApi = (id, data) => 
  http.put(`/api/admin/system/dict/types/${id}`, data).then(r => r.data)

/**
 * 删除字典类型
 * @param {Number} id - 字典类型ID
 */
export const deleteDictTypeApi = (id) => 
  http.delete(`/api/admin/system/dict/types/${id}`).then(r => r.data)


// ==================== 字典数据 ====================

/**
 * 获取字典数据列表（分页）
 * @param {Object} params { type_code, page, size, label, status }
 */
export const getDictDataApi = (params) => 
  http.get('/api/admin/system/dict/data', { params }).then(r => r.data)

/**
 * 根据字典类型编码获取所有启用的字典数据（供下拉框使用）
 * @param {String} typeCode - 字典类型编码
 */
export const getDictByCodeApi = (typeCode) => 
  http.get(`/api/admin/system/dict/data/by-code/${typeCode}`).then(r => r.data)

/**
 * 创建字典数据
 * @param {Object} data { type_code, label, value, tag_type, css_class, remark, status, sort }
 */
export const createDictDataApi = (data) => 
  http.post('/api/admin/system/dict/data', data).then(r => r.data)

/**
 * 更新字典数据
 * @param {Number} id - 字典数据ID
 * @param {Object} data - 更新数据
 */
export const updateDictDataApi = (id, data) => 
  http.put(`/api/admin/system/dict/data/${id}`, data).then(r => r.data)

/**
 * 删除字典数据
 * @param {Number} id - 字典数据ID
 */
export const deleteDictDataApi = (id) => 
  http.delete(`/api/admin/system/dict/data/${id}`).then(r => r.data)
