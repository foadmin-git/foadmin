// src/api/job.js
// 定时任务管理API
import http from './http'

// ==================== 任务管理 ====================

/**
 * 获取任务列表（分页）
 * @param {Object} params { page, size, name, job_type, status }
 */
export const getJobListApi = (params) => 
  http.get('/api/admin/system/job/list', { params }).then(r => r.data)

/**
 * 创建任务
 * @param {Object} data 任务数据
 */
export const createJobApi = (data) => 
  http.post('/api/admin/system/job/create', data).then(r => r.data)

/**
 * 更新任务
 * @param {Number} id - 任务ID
 * @param {Object} data - 更新数据
 */
export const updateJobApi = (id, data) => 
  http.put(`/api/admin/system/job/update/${id}`, data).then(r => r.data)

/**
 * 删除任务
 * @param {Number} id - 任务ID
 */
export const deleteJobApi = (id) => 
  http.delete(`/api/admin/system/job/delete/${id}`).then(r => r.data)

/**
 * 暂停任务
 * @param {Number} id - 任务ID
 */
export const pauseJobApi = (id) => 
  http.post(`/api/admin/system/job/pause/${id}`).then(r => r.data)

/**
 * 恢复任务
 * @param {Number} id - 任务ID
 */
export const resumeJobApi = (id) => 
  http.post(`/api/admin/system/job/resume/${id}`).then(r => r.data)

/**
 * 立即执行任务
 * @param {Number} id - 任务ID
 */
export const runJobApi = (id) => 
  http.post(`/api/admin/system/job/run/${id}`).then(r => r.data)


// ==================== 任务日志 ====================

/**
 * 获取任务日志列表（分页）
 * @param {Object} params { page, size, job_id, status }
 */
export const getJobLogsApi = (params) => 
  http.get('/api/admin/system/job/logs', { params }).then(r => r.data)

/**
 * 清理旧日志
 * @param {Number} days - 清理多少天前的日志
 */
export const clearJobLogsApi = (days = 30) => 
  http.delete('/api/admin/system/job/logs/clear', { params: { days } }).then(r => r.data)
