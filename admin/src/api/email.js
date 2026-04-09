// admin/src/api/email.js
// 邮件服务API接口

import http from './http'

/**
 * 测试SMTP连接
 */
export function testConnection() {
  return http.post('/api/admin/email/test-connection')
}

/**
 * 发送测试邮件
 * @param {string} testEmail - 测试邮箱地址
 */
export function sendTestEmail(testEmail) {
  return http.post('/api/admin/email/test-send', {
    test_email: testEmail
  })
}

/**
 * 发送自定义邮件
 * @param {Object} data - 邮件数据
 * @param {string|Array} data.to_email - 收件人邮箱
 * @param {string} data.subject - 邮件主题
 * @param {string} data.content - 邮件内容
 * @param {string} data.content_type - 内容类型 (html/plain)
 * @param {Array} data.cc - 抄送列表
 * @param {Array} data.bcc - 密送列表
 */
export function sendEmail(data) {
  return http.post('/api/admin/email/send', data)
}

/**
 * 使用模板发送邮件
 * @param {Object} data - 邮件数据
 * @param {string|Array} data.to_email - 收件人邮箱
 * @param {string} data.template_type - 模板类型
 * @param {Object} data.context - 模板变量
 */
export function sendTemplateEmail(data) {
  return http.post('/api/admin/email/send-template', data)
}

/**
 * 获取邮件模板列表
 */
export function getEmailTemplates() {
  return http.get('/api/admin/email/templates')
}
