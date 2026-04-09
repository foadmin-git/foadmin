<template>
    <div class="email-management">
      <el-card class="mb-4">
        <template #header>
          <div class="flex items-center justify-between">
            <span class="text-lg font-semibold">📧 邮件服务管理</span>
            <el-tag type="info">开源安全 · 配置热更新</el-tag>
          </div>
        </template>
  
        <el-tabs v-model="activeTab" type="border-card">
          <!-- 测试连接标签 -->
          <el-tab-pane label="测试连接" name="test">
            <div class="test-connection-panel">
              <el-alert
                title="测试SMTP服务器连接"
                type="info"
                description="在发送邮件前，建议先测试SMTP连接是否正常。"
                :closable="false"
                class="mb-4"
              />
  
              <el-form :model="smtpConfig" label-width="140px" label-position="left">
                <el-form-item label="SMTP服务器">
                  <el-input v-model="smtpConfig.smtp_host" disabled>
                    <template #append>
                      <el-button @click="goToConfig">前往配置</el-button>
                    </template>
                  </el-input>
                </el-form-item>
                <el-form-item label="SMTP端口">
                  <el-input v-model="smtpConfig.smtp_port" disabled />
                </el-form-item>
                <el-form-item label="SMTP用户名">
                  <el-input v-model="smtpConfig.smtp_user" disabled />
                </el-form-item>
                <el-form-item label="启用SSL">
                  <el-tag :type="isSslEnabled ? 'success' : 'info'">
                    {{ isSslEnabled ? '已启用' : '未启用' }}
                  </el-tag>
                </el-form-item>
              </el-form>
  
              <div class="text-center mt-6">
                <el-button type="primary" size="large" @click="testConnection" :loading="testing">
                  <el-icon class="mr-2"><Connection /></el-icon>
                  测试连接
                </el-button>
              </div>
  
              <!-- 测试结果 -->
              <div v-if="testResult" class="mt-6">
                <el-alert
                  :title="testResult.success ? '连接测试成功 ✓' : '连接测试失败 ✗'"
                  :type="testResult.success ? 'success' : 'error'"
                  :closable="false"
                >
                  <div class="test-result-details">
                    <p class="mb-2">{{ testResult.message }}</p>
                    <div v-if="testResult.details" class="text-sm">
                      <p>服务器: {{ testResult.details.host }}</p>
                      <p>端口: {{ testResult.details.port }}</p>
                      <p>用户: {{ testResult.details.user }}</p>
                      <p>SSL: {{ testResult.details.ssl ? '启用' : '未启用' }}</p>
                    </div>
                  </div>
                </el-alert>
              </div>
            </div>
          </el-tab-pane>
  
          <!-- 发送测试邮件标签 -->
          <el-tab-pane label="发送测试" name="send">
            <div class="send-test-panel">
              <el-alert
                title="发送测试邮件"
                type="warning"
                description="发送一封测试邮件到指定邮箱，验证邮件服务配置是否正确。"
                :closable="false"
                class="mb-4"
              />
  
              <el-form :model="testEmailForm" :rules="testEmailRules" ref="testEmailFormRef" label-width="140px">
                <el-form-item label="收件人邮箱" prop="test_email">
                  <el-input
                    v-model="testEmailForm.test_email"
                    placeholder="请输入测试邮箱地址"
                    clearable
                  >
                    <template #prepend>
                      <el-icon><Message /></el-icon>
                    </template>
                  </el-input>
                </el-form-item>
              </el-form>
  
              <div class="text-center mt-6">
                <el-button type="success" size="large" @click="sendTestEmail" :loading="sending">
                  <el-icon class="mr-2"><Promotion /></el-icon>
                  发送测试邮件
                </el-button>
              </div>
  
              <!-- 发送成功提示 -->
              <div v-if="sendSuccess" class="mt-6">
                <el-result icon="success" title="测试邮件发送成功" :sub-title="`已发送到 ${testEmailForm.test_email}`">
                  <template #extra>
                    <el-alert
                      title="请检查收件箱"
                      type="info"
                      description="如果没有收到邮件，请检查垃圾邮件箱。"
                      :closable="false"
                    />
                  </template>
                </el-result>
              </div>
            </div>
          </el-tab-pane>
  
          <!-- 邮件模板标签 -->
          <el-tab-pane label="邮件模板" name="templates">
            <div class="templates-panel">
              <el-alert
                title="系统内置邮件模板"
                type="success"
                description="以下模板可以在代码中直接调用，也可以通过API接口使用。"
                :closable="false"
                class="mb-4"
              />
  
              <el-table :data="templates" stripe border>
                <el-table-column prop="type" label="模板类型" width="180">
                  <template #default="{ row }">
                    <el-tag>{{ row.type }}</el-tag>
                  </template>
                </el-table-column>
                <el-table-column prop="name" label="模板名称" width="150" />
                <el-table-column prop="description" label="说明" />
                <el-table-column label="必需参数" width="300">
                  <template #default="{ row }">
                    <el-tag
                      v-for="param in row.required_context"
                      :key="param"
                      size="small"
                      class="mr-1 mb-1"
                      type="info"
                    >
                      {{ param }}
                    </el-tag>
                  </template>
                </el-table-column>
              </el-table>
            </div>
          </el-tab-pane>
  
          <!-- 使用文档标签 -->
          <el-tab-pane label="使用文档" name="docs">
            <div class="docs-panel">
              <el-scrollbar height="600px">
                <div class="markdown-body p-6">
                  <h2>📧 邮件服务使用文档</h2>
  
                  <h3>🚀 快速开始</h3>
                  <el-alert type="info" :closable="false" class="my-4">
                    <p><strong>第一步：配置SMTP参数</strong></p>
                    <p>在 <el-link type="primary" @click="goToConfig">系统配置</el-link> 中设置邮件服务器信息</p>
                  </el-alert>
  
                  <h3>⚙️ SMTP配置项</h3>
                  <el-table :data="configItems" stripe border class="my-4">
                    <el-table-column prop="key" label="配置键名" width="200" />
                    <el-table-column prop="name" label="配置名称" width="150" />
                    <el-table-column prop="required" label="必填" width="80">
                      <template #default="{ row }">
                        <el-tag :type="row.required ? 'danger' : 'info'" size="small">
                          {{ row.required ? '✅' : '⭕' }}
                        </el-tag>
                      </template>
                    </el-table-column>
                    <el-table-column prop="description" label="说明" />
                  </el-table>
  
                  <h3>📮 常见邮箱配置</h3>
                  <el-collapse class="my-4">
                    <el-collapse-item title="QQ邮箱" name="qq">
                      <div class="config-example">
                        <p><strong>SMTP服务器:</strong> smtp.qq.com</p>
                        <p><strong>端口:</strong> 465 (SSL) 或 587 (TLS)</p>
                        <p><strong>密码:</strong> 需使用授权码，而非QQ密码</p>
                        <el-alert type="warning" :closable="false" class="mt-2">
                          <p>获取授权码：登录QQ邮箱 → 设置 → 账户 → 生成授权码</p>
                        </el-alert>
                      </div>
                    </el-collapse-item>
                    <el-collapse-item title="163邮箱" name="163">
                      <div class="config-example">
                        <p><strong>SMTP服务器:</strong> smtp.163.com</p>
                        <p><strong>端口:</strong> 465 (SSL) 或 25 (非加密)</p>
                        <p><strong>密码:</strong> 需使用授权码</p>
                      </div>
                    </el-collapse-item>
                    <el-collapse-item title="Gmail" name="gmail">
                      <div class="config-example">
                        <p><strong>SMTP服务器:</strong> smtp.gmail.com</p>
                        <p><strong>端口:</strong> 465 (SSL) 或 587 (TLS)</p>
                        <p><strong>密码:</strong> 需使用应用专用密码</p>
                      </div>
                    </el-collapse-item>
                    <el-collapse-item title="企业邮箱（阿里云）" name="aliyun">
                      <div class="config-example">
                        <p><strong>SMTP服务器:</strong> smtp.mxhichina.com</p>
                        <p><strong>端口:</strong> 465 (SSL)</p>
                        <p><strong>密码:</strong> 邮箱密码</p>
                      </div>
                    </el-collapse-item>
                  </el-collapse>
  
                  <h3>💡 代码使用示例</h3>
                  <el-tabs class="my-4">
                    <el-tab-pane label="Python - 简单发送">
                      <pre><code>from app.services.email_service import send_email
  
  # 发送简单邮件
  send_email(
      to_email="user@example.com",
      subject="测试邮件",
      content="&lt;h1&gt;这是一封测试邮件&lt;/h1&gt;",
      db=db
  )</code></pre>
                    </el-tab-pane>
                    <el-tab-pane label="Python - 模板发送">
                      <pre><code>from app.services.email_service import send_template_email
  
  # 发送欢迎邮件
  send_template_email(
      to_email="user@example.com",
      template_type="welcome",
      context={
          'username': '张三',
          'email': 'user@example.com',
          'login_url': 'https://yourdomain.com/login'
      },
      db=db
  )</code></pre>
                    </el-tab-pane>
                    <el-tab-pane label="Python - 重置密码">
                      <pre><code>from app.services.email_service import send_template_email
  
  # 发送重置密码邮件
  send_template_email(
      to_email="user@example.com",
      template_type="reset_password",
      context={
          'username': '张三',
          'reset_url': 'https://yourdomain.com/reset?token=xxx',
          'expire_hours': 24
      },
      db=db
  )</code></pre>
                    </el-tab-pane>
                  </el-tabs>
  
                  <h3>🔐 安全特性</h3>
                  <el-row :gutter="16" class="my-4">
                    <el-col :span="12">
                      <el-card shadow="hover">
                        <template #header>
                          <el-icon><Lock /></el-icon> 速率限制
                        </template>
                        <p>同一邮箱1小时内最多发送10封邮件，防止滥用</p>
                      </el-card>
                    </el-col>
                    <el-col :span="12">
                      <el-card shadow="hover">
                        <template #header>
                          <el-icon><View /></el-icon> 格式验证
                        </template>
                        <p>严格的邮箱地址格式检查，确保有效性</p>
                      </el-card>
                    </el-col>
                    <el-col :span="12" class="mt-4">
                      <el-card shadow="hover">
                        <template #header>
                          <el-icon><Key /></el-icon> 权限控制
                        </template>
                        <p>需要管理员权限才能操作邮件功能</p>
                      </el-card>
                    </el-col>
                    <el-col :span="12" class="mt-4">
                      <el-card shadow="hover">
                        <template #header>
                          <el-icon><Document /></el-icon> 日志记录
                        </template>
                        <p>详细记录发送情况，便于排查问题</p>
                      </el-card>
                    </el-col>
                  </el-row>
  
                  <h3>⚠️ 常见问题</h3>
                  <el-collapse accordion class="my-4">
                    <el-collapse-item title="Q: 发送邮件失败，提示'SMTP认证失败'" name="q1">
                      <el-alert type="error" :closable="false">
                        <p><strong>解决方案：</strong></p>
                        <ol>
                          <li>检查用户名和密码是否正确</li>
                          <li>某些邮箱（如QQ、163）需要使用授权码而非邮箱密码</li>
                          <li>确认邮箱服务商是否开启了SMTP服务</li>
                        </ol>
                      </el-alert>
                    </el-collapse-item>
                    <el-collapse-item title="Q: 邮件发送成功但收不到" name="q2">
                      <el-alert type="warning" :closable="false">
                        <p><strong>解决方案：</strong></p>
                        <ol>
                          <li>检查垃圾邮件箱</li>
                          <li>确认发件人邮箱是否被标记为垃圾邮件</li>
                          <li>查看邮件服务器日志</li>
                        </ol>
                      </el-alert>
                    </el-collapse-item>
                    <el-collapse-item title="Q: SSL连接失败" name="q3">
                      <el-alert type="info" :closable="false">
                        <p><strong>解决方案：</strong></p>
                        <ol>
                          <li>尝试使用TLS端口（587）替代SSL端口（465）</li>
                          <li>确认服务器网络环境允许连接SMTP端口</li>
                          <li>检查防火墙设置</li>
                        </ol>
                      </el-alert>
                    </el-collapse-item>
                  </el-collapse>
  
                  <h3>📚 API接口</h3>
                  <el-table :data="apiList" stripe border class="my-4">
                    <el-table-column prop="path" label="接口路径" width="300" />
                    <el-table-column prop="method" label="方法" width="80">
                      <template #default="{ row }">
                        <el-tag :type="row.method === 'POST' ? 'success' : 'info'" size="small">
                          {{ row.method }}
                        </el-tag>
                      </template>
                    </el-table-column>
                    <el-table-column prop="permission" label="权限" width="180" />
                    <el-table-column prop="description" label="说明" />
                  </el-table>
  
                  <el-divider />
  
                  <div class="text-center">
                    <el-tag type="success" size="large">开源项目 · 安全可靠 ✅</el-tag>
                    <p class="mt-4 text-gray-500">更新时间: 2025-10-21 · 版本: v1.0.0</p>
                  </div>
                </div>
              </el-scrollbar>
            </div>
          </el-tab-pane>
        </el-tabs>
      </el-card>
    </div>
  </template>
  
  <script setup>
  import { ref, reactive, computed, onMounted } from 'vue'
  import { ElMessage, ElMessageBox } from 'element-plus'
  import { Connection, Message, Promotion, Lock, View, Key, Document } from '@element-plus/icons-vue'
  import http from '@/api/http'
  import { useRouter } from 'vue-router'
  
  const router = useRouter()
  const activeTab = ref('test')
  const testing = ref(false)
  const sending = ref(false)
  const sendSuccess = ref(false)
  const testResult = ref(null)
  const testEmailFormRef = ref(null)
  
  // SMTP配置
  const smtpConfig = reactive({
    smtp_host: '',
    smtp_port: '',
    smtp_user: '',
    smtp_password: '******',
    smtp_from: '',
    smtp_ssl: ''
  })
  
  // 计算属性：判断SSL是否启用（兼容多种格式）
  const isSslEnabled = computed(() => {
    const value = smtpConfig.smtp_ssl
    // 兼容多种格式: '1', 1, 'true', true, '是', 'yes'
    return value === '1' || 
           value === 1 || 
           value === 'true' || 
           value === true || 
           value === '是' || 
           value?.toLowerCase() === 'yes'
  })
  
  // 测试邮件表单
  const testEmailForm = reactive({
    test_email: ''
  })
  
  // 表单验证规则
  const testEmailRules = {
    test_email: [
      { required: true, message: '请输入邮箱地址', trigger: 'blur' },
      { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
    ]
  }
  
  // 邮件模板列表
  const templates = ref([])
  
  // 配置项说明
  const configItems = [
    { key: 'smtp_host', name: 'SMTP服务器', required: true, description: 'SMTP服务器地址，如 smtp.qq.com' },
    { key: 'smtp_port', name: 'SMTP端口', required: true, description: '通常为 465(SSL) 或 587(TLS)' },
    { key: 'smtp_user', name: 'SMTP用户名', required: true, description: '发送邮件的邮箱账号' },
    { key: 'smtp_password', name: 'SMTP密码', required: true, description: '邮箱密码或授权码' },
    { key: 'smtp_from', name: '发件人邮箱', required: false, description: '显示的发件人地址（可选）' },
    { key: 'smtp_ssl', name: '启用SSL', required: false, description: '是否使用SSL加密连接' }
  ]
  
  // API列表
  const apiList = [
    { path: '/api/admin/email/test-connection', method: 'POST', permission: 'system:config:edit', description: '测试SMTP连接' },
    { path: '/api/admin/email/test-send', method: 'POST', permission: 'system:config:edit', description: '发送测试邮件' },
    { path: '/api/admin/email/send', method: 'POST', permission: 'system:email:send', description: '发送自定义邮件' },
    { path: '/api/admin/email/send-template', method: 'POST', permission: 'system:email:send', description: '发送模板邮件' },
    { path: '/api/admin/email/templates', method: 'GET', permission: '无需权限', description: '获取模板列表' }
  ]
  
  // 加载SMTP配置
  const loadSmtpConfig = async () => {
    try {
      const response = await http.get('/api/admin/system/config')
      console.log('📩 原始响应:', response)
      
      // http.js 的响应拦截器返回的是 res，需要取 res.data 或直接使用 res
      let data = response.data || response
      console.log('📦 解析后的数据:', data)
      
      // 后端返回的是 { grouped: { category1: [...], category2: [...] } } 格式
      let configs = []
      
      if (data && typeof data === 'object') {
        // 如果有 grouped 属性，这是新的分组格式
        if (data.grouped) {
          console.log('🗂️  检测到分组格式，grouped:', data.grouped)
          // 提取 email 分类的配置
          if (data.grouped.email && Array.isArray(data.grouped.email)) {
            configs = data.grouped.email
            console.log('✅ 找到 email 分类配置:', configs)
          } else {
            console.warn('⚠️  未找到 email 分类配置，可用分类:', Object.keys(data.grouped))
            ElMessage.warning('未找到邮件配置，请先在系统配置中添加邮件相关设置')
            return
          }
        }
        // 兼容旧的数组格式
        else if (Array.isArray(data)) {
          console.log('📋 检测到数组格式')
          configs = data.filter(config => config.category === 'email')
        }
        // 兼容嵌套的 data 属性
        else if (data.data) {
          console.log('🔄 检测到嵌套的 data 属性')
          data = data.data
          if (data.grouped && data.grouped.email) {
            configs = data.grouped.email
          } else if (Array.isArray(data)) {
            configs = data.filter(config => config.category === 'email')
          }
        }
      }
      
      if (!Array.isArray(configs) || configs.length === 0) {
        console.error('❌ 配置数据格式错误或为空，期望数组，实际:', configs)
        ElMessage.warning('未找到邮件配置，请先在系统配置中设置SMTP参数')
        return
      }
      
      console.log('📋 最终配置列表:', configs)
      
      // 提取邮件相关配置
      let configCount = 0
      configs.forEach(config => {
        if (smtpConfig.hasOwnProperty(config.key)) {
          smtpConfig[config.key] = config.value
          configCount++
          console.log(`✅ 设置配置 ${config.key} = ${config.value}`)
        }
      })
      
      console.log(`🎉 成功加载 ${configCount} 个配置项`)
      console.log('📧 最终SMTP配置:', smtpConfig)
      
      if (configCount === 0) {
        ElMessage.warning('未找到有效的邮件配置，请先在系统配置中设置SMTP参数')
      }
    } catch (error) {
      console.error('❌ 加载SMTP配置失败:', error)
      ElMessage.error('加载SMTP配置失败，请检查网络连接')
    }
  }
  
  // 加载邮件模板
  const loadTemplates = async () => {
    try {
      const response = await http.get('/api/admin/email/templates')
      const data = response.data || response
      templates.value = data.templates || []
    } catch (error) {
      console.error('加载邮件模板失败:', error)
      ElMessage.error('加载邮件模板失败')
    }
  }
  
  // 测试SMTP连接
  const testConnection = async () => {
    // 检查配置是否完整
    if (!smtpConfig.smtp_host || !smtpConfig.smtp_user) {
      ElMessage.warning('请先在系统配置中设置SMTP参数')
      return
    }
  
    testing.value = true
    testResult.value = null
    
    try {
      const response = await http.post('/api/admin/email/test-connection')
      const data = response.data || response
      testResult.value = data
      
      if (data.success) {
        ElMessage.success('SMTP连接测试成功')
      } else {
        ElMessage.error(data.message || 'SMTP连接测试失败')
      }
    } catch (error) {
      testResult.value = {
        success: false,
        message: error.response?.data?.detail || error.message || '测试失败',
        details: null
      }
      ElMessage.error('测试连接失败')
    } finally {
      testing.value = false
    }
  }
  
  // 发送测试邮件
  const sendTestEmail = async () => {
    // 表单验证
    const valid = await testEmailFormRef.value.validate().catch(() => false)
    if (!valid) return
  
    sending.value = true
    sendSuccess.value = false
    
    try {
      const response = await http.post('/api/admin/email/test-send', {
        test_email: testEmailForm.test_email
      })
      const data = response.data || response
      
      if (data.ok) {
        sendSuccess.value = true
        ElMessage.success(data.message || '测试邮件发送成功')
      } else {
        ElMessage.error('发送测试邮件失败')
      }
    } catch (error) {
      ElMessage.error(error.response?.data?.detail || '发送测试邮件失败')
    } finally {
      sending.value = false
    }
  }
  
  // 前往系统配置
  const goToConfig = () => {
    router.push('/central/auth/config/system')
  }
  
  // 页面加载时获取配置和模板
  onMounted(async () => {
    console.log('邮件管理页面加载...')
    await loadSmtpConfig()
    await loadTemplates()
    console.log('页面加载完成')
  })
  </script>
  
  <style scoped>
  .email-management {
    padding: 0px;
  }
  
  .test-connection-panel,
  .send-test-panel,
  .templates-panel,
  .docs-panel {
    padding: 20px;
  }
  
  .test-result-details p {
    margin: 4px 0;
  }
  
  .config-example p {
    margin: 8px 0;
    line-height: 1.8;
  }
  
  .markdown-body {
    line-height: 1.8;
  }
  
  .markdown-body h2 {
    color: #409EFF;
    margin-top: 20px;
    margin-bottom: 16px;
    font-size: 24px;
    border-bottom: 2px solid #409EFF;
    padding-bottom: 8px;
  }
  
  .markdown-body h3 {
    color: #303133;
    margin-top: 24px;
    margin-bottom: 12px;
    font-size: 18px;
  }
  
  .markdown-body pre {
    background-color: #f5f7fa;
    padding: 16px;
    border-radius: 4px;
    overflow-x: auto;
    margin: 12px 0;
  }
  
  .markdown-body code {
    font-family: 'Courier New', Courier, monospace;
    font-size: 14px;
    line-height: 1.6;
    color: #e83e8c;
  }
  
  .markdown-body pre code {
    color: #303133;
  }
  
  .markdown-body ol,
  .markdown-body ul {
    padding-left: 24px;
    margin: 8px 0;
  }
  
  .markdown-body li {
    margin: 4px 0;
  }
  
  .mb-4 {
    margin-bottom: 16px;
  }
  
  .mt-2 {
    margin-top: 8px;
  }
  
  .mt-4 {
    margin-top: 16px;
  }
  
  .mt-6 {
    margin-top: 24px;
  }
  
  .my-4 {
    margin-top: 16px;
    margin-bottom: 16px;
  }
  
  .mr-1 {
    margin-right: 4px;
  }
  
  .mr-2 {
    margin-right: 8px;
  }
  
  .mb-1 {
    margin-bottom: 4px;
  }
  
  .mb-2 {
    margin-bottom: 8px;
  }
  
  .text-center {
    text-align: center;
  }
  
  .text-sm {
    font-size: 14px;
  }
  
  .text-gray-500 {
    color: #909399;
  }
  
  .p-6 {
    padding: 24px;
  }
  </style>
  