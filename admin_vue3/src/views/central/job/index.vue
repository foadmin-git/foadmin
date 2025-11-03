<template>
    <div class="job-container">
      <!-- 页面标题和说明 -->
      <div class="mb-6">
        <h2 class="text-2xl font-bold mb-2">定时任务管理</h2>
        <el-alert type="info" :closable="false" class="mb-4">
          <template #title>
            <div class="text-sm space-y-1">
              <p><strong>功能说明：</strong>基于APScheduler实现的定时任务调度系统，支持cron、interval、date三种调度方式。</p>
              <p><strong>操作指南：</strong>
                <span class="text-blue-600">Cron</span>: 类似Linux crontab，如"0 2 * * *"每天2点执行；
                <span class="text-green-600">Interval</span>: 固定间隔执行；
                <span class="text-orange-600">Date</span>: 单次定时执行
              </p>
              <p><strong>使用示例：</strong>
                清理日志: <code class="bg-gray-100 px-1">0 2 * * *</code>（每天凌晨2点）｜
                发送报告: <code class="bg-gray-100 px-1">0 9 * * 1-5</code>（工作日9点）｜
                定期备份: <code class="bg-gray-100 px-1">0 3 * * 0</code>（每周日3点）
              </p>
            </div>
          </template>
        </el-alert>
      </div>
  
      <!-- Tab切换 -->
      <el-tabs v-model="activeTab" @tab-change="handleTabChange">
        <!-- 任务列表 -->
        <el-tab-pane label="任务列表" name="jobs">
          <div class="bg-white p-4 rounded shadow">
            <!-- 搜索和操作栏 -->
            <div class="flex justify-between items-center mb-4">
              <div class="flex gap-2">
                <el-input v-model="searchForm.name" placeholder="搜索任务名称" clearable @clear="loadJobs" @keyup.enter="loadJobs" style="width: 200px">
                  <template #prefix><el-icon><Search /></el-icon></template>
                </el-input>
                <el-select v-model="searchForm.job_type" placeholder="任务类型" clearable @change="loadJobs" style="width: 120px">
                  <el-option label="全部" :value="null" />
                  <el-option label="Cron" value="cron" />
                  <el-option label="Interval" value="interval" />
                  <el-option label="Date" value="date" />
                </el-select>
                <el-select v-model="searchForm.status" placeholder="状态" clearable @change="loadJobs" style="width: 120px">
                  <el-option label="全部" :value="null" />
                  <el-option label="启用" :value="1" />
                  <el-option label="暂停" :value="0" />
                </el-select>
                <el-button @click="loadJobs"><el-icon><Refresh /></el-icon> 刷新</el-button>
              </div>
              <el-button type="primary" @click="handleAdd" v-perm="'job:add'">
                <el-icon><Plus /></el-icon> 新增任务
              </el-button>
            </div>
  
            <!-- 任务表格 -->
            <el-table :data="jobList" v-loading="loading" border stripe>
              <el-table-column prop="id" label="ID" width="70" />
              <el-table-column prop="name" label="任务名称" min-width="150" />
              <el-table-column prop="job_id" label="任务标识" min-width="120" />
              <el-table-column prop="job_type" label="类型" width="100">
                <template #default="{ row }">
                  <el-tag v-if="row.job_type === 'cron'" type="primary">Cron</el-tag>
                  <el-tag v-else-if="row.job_type === 'interval'" type="success">Interval</el-tag>
                  <el-tag v-else type="warning">Date</el-tag>
                </template>
              </el-table-column>
              <el-table-column label="调度配置" min-width="150">
                <template #default="{ row }">
                  <span v-if="row.job_type === 'cron'">{{ row.cron_expression }}</span>
                  <span v-else-if="row.job_type === 'interval'">每{{ row.interval_seconds }}秒</span>
                  <span v-else>{{ row.run_date }}</span>
                </template>
              </el-table-column>
              <el-table-column prop="func_name" label="执行函数" min-width="200" show-overflow-tooltip />
              <el-table-column label="执行统计" width="120">
                <template #default="{ row }">
                  <div class="text-xs">
                    <div>成功: <span class="text-green-600">{{ row.run_count - row.fail_count }}</span></div>
                    <div>失败: <span class="text-red-600">{{ row.fail_count }}</span></div>
                  </div>
                </template>
              </el-table-column>
              <el-table-column prop="next_run_time" label="下次执行" width="160">
                <template #default="{ row }">
                  <span v-if="row.next_run_time" class="text-xs">{{ formatTime(row.next_run_time) }}</span>
                  <span v-else class="text-gray-400">-</span>
                </template>
              </el-table-column>
              <el-table-column prop="status" label="状态" width="80">
                <template #default="{ row }">
                  <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small">
                    {{ row.status === 1 ? '启用' : '暂停' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="280" fixed="right">
                <template #default="{ row }">
                  <el-button size="small" text @click="handleRun(row)" v-perm="'job:run'">
                    <el-icon><VideoPlay /></el-icon> 执行
                  </el-button>
                  <el-button size="small" text @click="handleToggleStatus(row)" v-perm="'job:edit'">
                    <el-icon v-if="row.status === 1"><VideoPause /></el-icon>
                    <el-icon v-else><VideoPlay /></el-icon>
                    {{ row.status === 1 ? '暂停' : '恢复' }}
                  </el-button>
                  <el-button size="small" text @click="handleEdit(row)" v-perm="'job:edit'">编辑</el-button>
                  <el-button size="small" text type="danger" @click="handleDelete(row)" v-perm="'job:delete'">删除</el-button>
                </template>
              </el-table-column>
            </el-table>
  
            <!-- 分页 -->
            <el-pagination
              v-if="total > pageSize"
              background
              layout="total, prev, pager, next, sizes"
              :total="total"
              :page-size="pageSize"
              :page-sizes="[20, 50, 100]"
              v-model:current-page="page"
              v-model:page-size="pageSize"
              @current-change="loadJobs"
              @size-change="loadJobs"
              class="mt-4"
            />
          </div>
        </el-tab-pane>
  
        <!-- 执行日志 -->
        <el-tab-pane label="执行日志" name="logs">
          <div class="bg-white p-4 rounded shadow">
            <!-- 搜索和操作栏 -->
            <div class="flex justify-between items-center mb-4">
              <div class="flex gap-2">
                <el-input v-model="logSearchForm.job_id" placeholder="任务标识" clearable @clear="loadLogs" @keyup.enter="loadLogs" style="width: 200px">
                  <template #prefix><el-icon><Search /></el-icon></template>
                </el-input>
                <el-select v-model="logSearchForm.status" placeholder="状态" clearable @change="loadLogs" style="width: 120px">
                  <el-option label="全部" :value="null" />
                  <el-option label="成功" :value="1" />
                  <el-option label="失败" :value="0" />
                </el-select>
                <el-button @click="loadLogs"><el-icon><Refresh /></el-icon> 刷新</el-button>
              </div>
              <el-button type="danger" @click="handleClearLogs" v-perm="'job:log:delete'">
                <el-icon><Delete /></el-icon> 清理日志
              </el-button>
            </div>
  
            <!-- 日志表格 -->
            <el-table :data="logList" v-loading="logLoading" border stripe>
              <el-table-column prop="id" label="ID" width="80" />
              <el-table-column prop="job_name" label="任务名称" min-width="150" />
              <el-table-column prop="job_id" label="任务标识" min-width="120" />
              <el-table-column prop="start_time" label="开始时间" width="160">
                <template #default="{ row }">
                  <span class="text-xs">{{ formatTime(row.start_time) }}</span>
                </template>
              </el-table-column>
              <el-table-column prop="duration" label="耗时" width="100">
                <template #default="{ row }">
                  <span v-if="row.duration">{{ row.duration }}ms</span>
                  <span v-else class="text-gray-400">-</span>
                </template>
              </el-table-column>
              <el-table-column prop="status" label="状态" width="80">
                <template #default="{ row }">
                  <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small">
                    {{ row.status === 1 ? '成功' : '失败' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="result" label="执行结果" min-width="200" show-overflow-tooltip />
              <el-table-column label="操作" width="100">
                <template #default="{ row }">
                  <el-button size="small" text @click="handleViewLog(row)">详情</el-button>
                </template>
              </el-table-column>
            </el-table>
  
            <!-- 分页 -->
            <el-pagination
              v-if="logTotal > logPageSize"
              background
              layout="total, prev, pager, next, sizes"
              :total="logTotal"
              :page-size="logPageSize"
              :page-sizes="[50, 100, 200]"
              v-model:current-page="logPage"
              v-model:page-size="logPageSize"
              @current-change="loadLogs"
              @size-change="loadLogs"
              class="mt-4"
            />
          </div>
        </el-tab-pane>
      </el-tabs>
  
      <!-- 任务编辑对话框 -->
      <el-dialog 
        v-model="dialogVisible" 
        :title="form.id ? '编辑任务' : '新增任务'"
        width="700px"
        @close="resetForm"
      >
        <el-form :model="form" :rules="rules" ref="formRef" label-width="120px">
          <el-form-item label="任务名称" prop="name">
            <el-input v-model="form.name" placeholder="请输入任务名称" />
          </el-form-item>
          <el-form-item label="任务标识" prop="job_id">
            <el-input v-model="form.job_id" placeholder="唯一标识，如：hello_task" :disabled="!!form.id" />
            <div class="text-xs text-gray-400 mt-1">创建后不可修改，建议使用英文下划线格式</div>
          </el-form-item>
          <el-form-item label="任务类型" prop="job_type">
            <el-radio-group v-model="form.job_type">
              <el-radio label="cron">Cron表达式</el-radio>
              <el-radio label="interval">固定间隔</el-radio>
              <el-radio label="date">单次执行</el-radio>
            </el-radio-group>
          </el-form-item>
  
          <!-- Cron配置 -->
          <el-form-item label="Cron表达式" prop="cron_expression" v-if="form.job_type === 'cron'">
            <el-input v-model="form.cron_expression" placeholder="如：0 2 * * * 表示每天2点">
              <template #append>
                <el-button @click="showCronHelp = !showCronHelp">帮助</el-button>
              </template>
            </el-input>
            <div v-if="showCronHelp" class="text-xs text-gray-600 mt-2 p-2 bg-gray-50 rounded">
              <p>格式：<code>分 时 日 月 周</code> 或 <code>秒 分 时 日 月 周</code></p>
              <p>示例：<code>0 2 * * *</code> = 每天2点 | <code>*/10 * * * *</code> = 每10分钟 | <code>0 9 * * 1-5</code> = 工作日9点</p>
            </div>
          </el-form-item>
  
          <!-- Interval配置 -->
          <el-form-item label="间隔秒数" prop="interval_seconds" v-if="form.job_type === 'interval'">
            <el-input-number v-model="form.interval_seconds" :min="1" placeholder="秒数" />
            <span class="ml-2 text-xs text-gray-400">
              ({{ form.interval_seconds ? `${Math.floor(form.interval_seconds / 60)}分${form.interval_seconds % 60}秒` : '' }})
            </span>
          </el-form-item>
  
          <!-- Date配置 -->
          <el-form-item label="执行时间" prop="run_date" v-if="form.job_type === 'date'">
            <el-date-picker 
              v-model="form.run_date" 
              type="datetime" 
              placeholder="选择执行时间"
              value-format="YYYY-MM-DD HH:mm:ss"
            />
          </el-form-item>
  
          <el-form-item label="执行函数" prop="func_name">
            <el-input v-model="form.func_name" placeholder="如：app.tasks.demo.hello_task" />
            <div class="text-xs text-gray-400 mt-1">完整的Python函数路径</div>
          </el-form-item>
          <el-form-item label="函数参数" prop="func_args">
            <el-input v-model="form.func_args" type="textarea" :rows="2" placeholder='JSON数组格式，如：["参数1", "参数2"]' />
          </el-form-item>
          <el-form-item label="关键字参数" prop="func_kwargs">
            <el-input v-model="form.func_kwargs" type="textarea" :rows="2" placeholder='JSON对象格式，如：{"name": "value"}' />
          </el-form-item>
          <el-form-item label="任务描述" prop="description">
            <el-input v-model="form.description" type="textarea" :rows="2" placeholder="任务用途说明" />
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-radio-group v-model="form.status">
              <el-radio :label="1">启用</el-radio>
              <el-radio :label="0">暂停</el-radio>
            </el-radio-group>
            <div class="text-xs text-gray-400 mt-1">暂停状态的任务不会被调度执行</div>
          </el-form-item>
        </el-form>
        <template #footer>
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitForm" :loading="submitting">确定</el-button>
        </template>
      </el-dialog>
  
      <!-- 日志详情对话框 -->
      <el-dialog v-model="logDetailVisible" title="执行日志详情" width="800px">
        <div v-if="currentLog" class="space-y-4">
          <el-descriptions :column="2" border>
            <el-descriptions-item label="任务名称">{{ currentLog.job_name }}</el-descriptions-item>
            <el-descriptions-item label="任务标识">{{ currentLog.job_id }}</el-descriptions-item>
            <el-descriptions-item label="开始时间">{{ formatTime(currentLog.start_time) }}</el-descriptions-item>
            <el-descriptions-item label="结束时间">{{ currentLog.end_time ? formatTime(currentLog.end_time) : '-' }}</el-descriptions-item>
            <el-descriptions-item label="耗时">{{ currentLog.duration }}ms</el-descriptions-item>
            <el-descriptions-item label="状态">
              <el-tag :type="currentLog.status === 1 ? 'success' : 'danger'">
                {{ currentLog.status === 1 ? '成功' : '失败' }}
              </el-tag>
            </el-descriptions-item>
          </el-descriptions>
          
          <div v-if="currentLog.result">
            <h4 class="font-semibold mb-2">执行结果：</h4>
            <pre class="bg-gray-50 p-3 rounded text-xs overflow-auto max-h-40">{{ currentLog.result }}</pre>
          </div>
          
          <div v-if="currentLog.error">
            <h4 class="font-semibold mb-2 text-red-600">错误信息：</h4>
            <pre class="bg-red-50 p-3 rounded text-xs overflow-auto max-h-40 text-red-700">{{ currentLog.error }}</pre>
          </div>
          
          <div v-if="currentLog.traceback">
            <h4 class="font-semibold mb-2 text-red-600">异常堆栈：</h4>
            <pre class="bg-red-50 p-3 rounded text-xs overflow-auto max-h-60 text-red-700">{{ currentLog.traceback }}</pre>
          </div>
        </div>
      </el-dialog>
    </div>
  </template>
  
  <script setup>
  import { ref, reactive, onMounted } from 'vue'
  import { ElMessage, ElMessageBox } from 'element-plus'
  import { 
    Search, Refresh, Plus, VideoPlay, VideoPause, Delete 
  } from '@element-plus/icons-vue'
  import {
    getJobListApi,
    createJobApi,
    updateJobApi,
    deleteJobApi,
    pauseJobApi,
    resumeJobApi,
    runJobApi,
    getJobLogsApi,
    clearJobLogsApi
  } from '@/api/job'
  
  // Tab切换
  const activeTab = ref('jobs')
  
  // 任务列表
  const loading = ref(false)
  const jobList = ref([])
  const page = ref(1)
  const pageSize = ref(20)
  const total = ref(0)
  const searchForm = reactive({
    name: '',
    job_type: null,
    status: null
  })
  
  // 日志列表
  const logLoading = ref(false)
  const logList = ref([])
  const logPage = ref(1)
  const logPageSize = ref(50)
  const logTotal = ref(0)
  const logSearchForm = reactive({
    job_id: '',
    status: null
  })
  
  // 表单
  const dialogVisible = ref(false)
  const formRef = ref(null)
  const submitting = ref(false)
  const showCronHelp = ref(false)
  const form = reactive({
    id: null,
    name: '',
    job_id: '',
    job_type: 'cron',
    func_name: '',
    func_args: '[]',
    func_kwargs: '{}',
    cron_expression: '',
    interval_seconds: 60,
    run_date: null,
    status: 1,
    description: '',
    remark: ''
  })
  
  const rules = {
    name: [{ required: true, message: '请输入任务名称', trigger: 'blur' }],
    job_id: [{ required: true, message: '请输入任务标识', trigger: 'blur' }],
    job_type: [{ required: true, message: '请选择任务类型', trigger: 'change' }],
    func_name: [{ required: true, message: '请输入执行函数', trigger: 'blur' }],
    cron_expression: [{ required: true, message: '请输入Cron表达式', trigger: 'blur' }],
    interval_seconds: [{ required: true, message: '请输入间隔秒数', trigger: 'blur' }],
    run_date: [{ required: true, message: '请选择执行时间', trigger: 'change' }]
  }
  
  // 日志详情
  const logDetailVisible = ref(false)
  const currentLog = ref(null)
  
  // 加载任务列表
  const loadJobs = async () => {
    loading.value = true
    try {
      const res = await getJobListApi({
        page: page.value,
        size: pageSize.value,
        ...searchForm
      })
      jobList.value = res.items
      total.value = res.total
    } catch (err) {
      ElMessage.error('加载任务列表失败')
    } finally {
      loading.value = false
    }
  }
  
  // 加载日志列表
  const loadLogs = async () => {
    logLoading.value = true
    try {
      const res = await getJobLogsApi({
        page: logPage.value,
        size: logPageSize.value,
        ...logSearchForm
      })
      logList.value = res.items
      logTotal.value = res.total
    } catch (err) {
      ElMessage.error('加载日志失败')
    } finally {
      logLoading.value = false
    }
  }
  
  // Tab切换
  const handleTabChange = (tab) => {
    if (tab === 'logs') {
      loadLogs()
    }
  }
  
  // 新增任务
  const handleAdd = () => {
    resetForm()
    dialogVisible.value = true
  }
  
  // 编辑任务
  const handleEdit = (row) => {
    Object.assign(form, row)
    dialogVisible.value = true
  }
  
  // 提交表单
  const submitForm = async () => {
    await formRef.value.validate()
    
    submitting.value = true
    try {
      if (form.id) {
        await updateJobApi(form.id, form)
        ElMessage.success('更新成功')
      } else {
        await createJobApi(form)
        ElMessage.success('创建成功')
      }
      dialogVisible.value = false
      loadJobs()
    } catch (err) {
      ElMessage.error(err.response?.data?.detail || '操作失败')
    } finally {
      submitting.value = false
    }
  }
  
  // 重置表单
  const resetForm = () => {
    formRef.value?.resetFields()
    form.id = null
    form.name = ''
    form.job_id = ''
    form.job_type = 'cron'
    form.func_name = ''
    form.func_args = '[]'
    form.func_kwargs = '{}'
    form.cron_expression = ''
    form.interval_seconds = 60
    form.run_date = null
    form.status = 1
    form.description = ''
    showCronHelp.value = false
  }
  
  // 删除任务
  const handleDelete = async (row) => {
    try {
      await ElMessageBox.confirm(`确定删除任务"${row.name}"吗？`, '提示', { type: 'warning' })
      await deleteJobApi(row.id)
      ElMessage.success('删除成功')
      loadJobs()
    } catch (err) {
      if (err !== 'cancel') {
        ElMessage.error('删除失败')
      }
    }
  }
  
  // 切换任务状态
  const handleToggleStatus = async (row) => {
    try {
      if (row.status === 1) {
        await pauseJobApi(row.id)
        ElMessage.success('任务已暂停')
      } else {
        await resumeJobApi(row.id)
        ElMessage.success('任务已恢复')
      }
      loadJobs()
    } catch (err) {
      ElMessage.error(err.response?.data?.detail || '操作失败')
    }
  }
  
  // 立即执行
  const handleRun = async (row) => {
    try {
      await runJobApi(row.id)
      ElMessage.success('任务已提交执行，请查看日志')
    } catch (err) {
      ElMessage.error(err.response?.data?.detail || '执行失败')
    }
  }
  
  // 查看日志详情
  const handleViewLog = (row) => {
    currentLog.value = row
    logDetailVisible.value = true
  }
  
  // 清理日志
  const handleClearLogs = async () => {
    try {
      const { value } = await ElMessageBox.prompt('清理多少天前的日志？', '清理日志', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPattern: /^\d+$/,
        inputErrorMessage: '请输入有效天数',
        inputValue: '30'
      })
      
      await clearJobLogsApi(parseInt(value))
      ElMessage.success('日志清理成功')
      loadLogs()
    } catch (err) {
      if (err !== 'cancel') {
        ElMessage.error('清理失败')
      }
    }
  }
  
  // 时间格式化
  const formatTime = (time) => {
    if (!time) return '-'
    return new Date(time).toLocaleString('zh-CN', { 
      year: 'numeric', 
      month: '2-digit', 
      day: '2-digit', 
      hour: '2-digit', 
      minute: '2-digit',
      second: '2-digit'
    })
  }
  
  onMounted(() => {
    loadJobs()
  })
  </script>
  
  <style scoped>
  .job-container {
    max-width: 1600px;
    margin: 0 auto;
  }
  
  code {
    font-family: 'Courier New', monospace;
    font-size: 0.9em;
  }
  
  pre {
    white-space: pre-wrap;
    word-wrap: break-word;
  }
  
  :deep(.el-tab-pane) {
    min-height: 400px;
  }
  </style>
  