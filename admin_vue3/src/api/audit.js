// src/api/audit.js
import http from './http'

/**
 * 审计日志 - 列表查询
 * @param {Object} params
 * page,size, kw, level, status, method, action, resource_type, resource_id,
 * actor_id, http_status, ip, trace_id, start, end (ISO 或 YYYY-MM-DD HH:mm:ss)
 */
export const listAuditLogs = (params) =>
  http.get('/api/admin/audit/logs', { params }).then(r => r.data)

/** 审计日志 - 详情 */
export const getAuditLog = (id) =>
  http.get(`/api/admin/audit/logs/${id}`).then(r => r.data)

/**
 * 审计日志 - 导出（CSV）
 * 同查询参数
 */
export const exportAuditLogs = async (params = {}) => {
  const res = await http.get('/api/admin/audit/export', {
    params,
    responseType: 'blob',
    autoSuccess: false, // 导出不弹“操作成功”
  })
  return res.data
}

/**
 * 审计日志 - 清理
 * @param {Object} params
 * - before: ISO 或 'YYYY-MM-DD HH:mm:ss'，清理该时间点之前的数据
 * - days: 按天清理，如 days=30 表示清30天前
 */
export const purgeAuditLogs = (params) =>
  http.delete('/api/admin/audit/logs', { params }).then(r => r.data)
