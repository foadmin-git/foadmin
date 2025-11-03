<template>
  <div class="dashboard-container">
    <!-- 顶部标题和刷新按钮 -->
    <div class="dashboard-header">
      <div class="header-left">
        <h1 class="dashboard-title">运营数据大屏</h1>
        <div class="dashboard-subtitle">实时监控 · 数据分析 · 决策支持</div>
      </div>
      <div class="header-right">
        <div class="time-display">{{ currentTime }}</div>
        <el-button type="primary" size="large" @click="fetchAllData">
          <el-icon class="refresh-icon"><Refresh /></el-icon>
          数据刷新
        </el-button>
      </div>
    </div>

    <!-- 关键指标卡片 -->
    <div class="kpi-container">
      <el-card v-for="card in kpis" :key="card.title" class="kpi-card" shadow="hover">
        <div class="card-content">
          <div class="card-icon" :style="{ backgroundColor: card.color }">
            <el-icon><component :is="card.icon" /></el-icon>
          </div>
          <div class="card-text">
            <div class="card-title">{{ card.title }}</div>
            <div class="card-value">{{ card.value }}</div>
            <div class="card-trend" :class="getTrendClass(card.subtitle)">
              <el-icon v-if="card.subtitle.includes('↑')"><Top /></el-icon>
              <el-icon v-else-if="card.subtitle.includes('↓')"><Bottom /></el-icon>
              {{ card.subtitle }}
            </div>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 图表区域 -->
    <div class="chart-area">
      <!-- 第一行图表 -->
      <div class="chart-row">
        <el-card class="chart-card" shadow="hover">
          <div class="chart-header">
            <div class="chart-title">销售趋势</div>
            <el-select v-model="salesTrendRange" size="small" style="width: 120px">
              <el-option label="近7天" value="7" />
              <el-option label="近30天" value="30" />
            </el-select>
          </div>
          <VChart :option="salesTrendOption" class="chart-content" />
        </el-card>
        
        <el-card class="chart-card" shadow="hover">
          <div class="chart-header">
            <div class="chart-title">区域订单分布</div>
            <el-select v-model="regionOrderType" size="small" style="width: 120px">
              <el-option label="订单量" value="count" />
              <el-option label="销售额" value="amount" />
            </el-select>
          </div>
          <VChart :option="regionOrderOption" class="chart-content" />
        </el-card>
      </div>
      
      <!-- 第二行图表 -->
      <div class="chart-row">
        <el-card class="chart-card" shadow="hover">
          <div class="chart-header">
            <div class="chart-title">产品类别占比</div>
            <el-radio-group v-model="categoryViewType" size="small">
              <el-radio-button label="pie">饼图</el-radio-button>
              <el-radio-button label="bar">柱图</el-radio-button>
            </el-radio-group>
          </div>
          <VChart v-if="categoryViewType === 'pie'" :option="categoryPieOption" class="chart-content" />
          <VChart v-else :option="categoryBarOption" class="chart-content" />
        </el-card>
        
        <el-card class="chart-card" shadow="hover">
          <div class="chart-header">
            <div class="chart-title">订单状态分布</div>
            <el-date-picker
              v-model="statusDateRange"
              type="daterange"
              size="small"
              range-separator="-"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              style="width: 240px"
            />
          </div>
          <VChart :option="statusBarOption" class="chart-content" />
        </el-card>
      </div>
    </div>

    <!-- 最近订单表格 -->
    <el-card class="order-table-card" shadow="hover">
      <div class="table-header">
        <div class="table-title">最近订单</div>
        <div class="table-actions">
          <el-input
            v-model="orderSearch"
            placeholder="搜索订单号/客户"
            size="small"
            style="width: 200px; margin-right: 10px"
            clearable
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
          <el-button type="success" size="small" @click="viewAllOrders">
            <el-icon><View /></el-icon>
            查看全部
          </el-button>
          <el-button type="primary" size="small" @click="exportOrders">
            <el-icon><Download /></el-icon>
            导出数据
          </el-button>
        </div>
      </div>
      <el-table
        :data="filteredOrders"
        stripe
        border
        size="medium"
        style="width: 100%"
        class="order-table"
        height="300"
      >
        <el-table-column prop="orderId" label="订单号" width="200" sortable />
        <el-table-column prop="customer" label="客户" width="150" />
        <el-table-column prop="amount" label="金额(¥)" width="120" sortable>
          <template #default="{ row }">
            {{ row.amount.toLocaleString() }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="120">
          <template #default="{ row }">
            <el-tag :type="statusType(row.status)" effect="dark" round>
              {{ row.status }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="date" label="日期" width="200" sortable />
        <el-table-column label="操作" width="120">
          <template #default="{ row }">
            <el-button size="small" @click="viewOrderDetail(row)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="table-footer">
        <el-pagination
          small
          layout="prev, pager, next"
          :total="recentOrders.length"
          :page-size="5"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { 
  UserFilled, 
  Ticket, 
  Money, 
  User, 
  Refresh,
  Top,
  Bottom,
  Search,
  View,
  Download
} from '@element-plus/icons-vue'
import * as echarts from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { LineChart, BarChart, PieChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
} from 'echarts/components'
import VChart from 'vue-echarts'

// 注册 ECharts 模块
echarts.use([
  CanvasRenderer,
  LineChart,
  BarChart,
  PieChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
])

// 当前时间
const currentTime = ref('')
const updateTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false
  })
}

// 获取最近 N 天的标签
function getLastDaysLabels(n) {
  const labels = []
  for (let i = n - 1; i >= 0; i--) {
    const d = new Date()
    d.setDate(d.getDate() - i)
    labels.push(`${d.getMonth() + 1}-${d.getDate()}`)
  }
  return labels
}

// 图表控制变量
const salesTrendRange = ref('7')
const regionOrderType = ref('count')
const categoryViewType = ref('pie')
const statusDateRange = ref([])
const orderSearch = ref('')

// 关键指标
const kpis = ref([
  { 
    title: '用户总数', 
    value: '—', 
    subtitle: '—', 
    icon: UserFilled,
    color: '#36a2eb'
  },
  { 
    title: '当日订单', 
    value: '—', 
    subtitle: '—', 
    icon: Ticket,
    color: '#ff6384'
  },
  { 
    title: '累计销售额', 
    value: '—', 
    subtitle: '—', 
    icon: Money,
    color: '#4bc0c0'
  },
  { 
    title: '活跃访客', 
    value: '—', 
    subtitle: '—', 
    icon: User,
    color: '#ff9f40'
  }
])

// 最近订单列表
const recentOrders = ref([])

// 过滤后的订单
const filteredOrders = computed(() => {
  if (!orderSearch.value) return recentOrders.value
  const search = orderSearch.value.toLowerCase()
  return recentOrders.value.filter(
    order => 
      order.orderId.toLowerCase().includes(search) || 
      order.customer.toLowerCase().includes(search)
  )
})

// ECharts 配置对象
const salesTrendOption = ref({
  backgroundColor: '#fff',
  tooltip: { 
    trigger: 'axis',
    axisPointer: { type: 'shadow' }
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: { 
    type: 'category',
    data: getLastDaysLabels(7),
    axisLine: { lineStyle: { color: '#eee' } },
    axisLabel: { color: '#666' }
  },
  yAxis: { 
    type: 'value',
    axisLine: { show: false },
    axisLabel: { color: '#666' },
    splitLine: { lineStyle: { color: '#f5f5f5' } }
  },
  series: [{ 
    name: '销售额',
    type: 'line',
    smooth: true,
    data: [],
    itemStyle: { color: '#36a2eb' },
    areaStyle: {
      color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
        { offset: 0, color: 'rgba(54, 162, 235, 0.5)' },
        { offset: 1, color: 'rgba(54, 162, 235, 0.1)' }
      ])
    }
  }]
})

const regionOrderOption = ref({
  backgroundColor: '#fff',
  tooltip: { 
    trigger: 'axis',
    axisPointer: { type: 'shadow' }
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: { 
    type: 'category',
    data: ['北京','上海','广州','深圳','杭州','成都','武汉'],
    axisLine: { lineStyle: { color: '#eee' } },
    axisLabel: { 
      color: '#666',
      interval: 0,
      rotate: 0
    }
  },
  yAxis: { 
    type: 'value',
    axisLine: { show: false },
    axisLabel: { color: '#666' },
    splitLine: { lineStyle: { color: '#f5f5f5' } }
  },
  series: [{ 
    name: '订单量',
    type: 'bar',
    data: [],
    itemStyle: { 
      color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
        { offset: 0, color: '#83bff6' },
        { offset: 0.5, color: '#188df0' },
        { offset: 1, color: '#188df0' }
      ])
    },
    emphasis: {
      itemStyle: {
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: '#2378f7' },
          { offset: 0.7, color: '#2378f7' },
          { offset: 1, color: '#83bff6' }
        ])
      }
    }
  }]
})

const categoryPieOption = ref({
  backgroundColor: '#fff',
  tooltip: { 
    trigger: 'item',
    formatter: '{a} <br/>{b}: {c} ({d}%)'
  },
  legend: { 
    bottom: 10,
    left: 'center',
    textStyle: { color: '#666' }
  },
  series: [
    {
      name: '类别占比',
      type: 'pie',
      radius: ['40%', '70%'],
      avoidLabelOverlap: false,
      itemStyle: {
        borderRadius: 10,
        borderColor: '#fff',
        borderWidth: 2
      },
      label: {
        show: false,
        position: 'center'
      },
      emphasis: {
        label: {
          show: true,
          fontSize: '18',
          fontWeight: 'bold',
          color: '#333'
        }
      },
      labelLine: {
        show: false
      },
      data: [
        { value: 0, name: '字体', itemStyle: { color: '#36a2eb' } },
        { value: 0, name: '模板', itemStyle: { color: '#ff6384' } },
        { value: 0, name: '插件', itemStyle: { color: '#4bc0c0' } },
        { value: 0, name: '主题', itemStyle: { color: '#ff9f40' } },
        { value: 0, name: '素材', itemStyle: { color: '#9966ff' } }
      ]
    }
  ]
})

// 新增柱图配置
const categoryBarOption = ref({
  backgroundColor: '#fff',
  tooltip: { 
    trigger: 'axis',
    axisPointer: { type: 'shadow' }
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: { 
    type: 'category',
    data: ['字体','模板','插件','主题','素材'],
    axisLine: { lineStyle: { color: '#eee' } },
    axisLabel: { color: '#666' }
  },
  yAxis: { 
    type: 'value',
    axisLine: { show: false },
    axisLabel: { color: '#666' },
    splitLine: { lineStyle: { color: '#f5f5f5' } }
  },
  series: [
    {
      name: '销量',
      type: 'bar',
      data: [
        { value: 0, itemStyle: { color: '#36a2eb' } },
        { value: 0, itemStyle: { color: '#ff6384' } },
        { value: 0, itemStyle: { color: '#4bc0c0' } },
        { value: 0, itemStyle: { color: '#ff9f40' } },
        { value: 0, itemStyle: { color: '#9966ff' } }
      ],
      barWidth: '40%',
      label: {
        show: true,
        position: 'top'
      }
    }
  ]
})

const statusBarOption = ref({
  backgroundColor: '#fff',
  tooltip: { 
    trigger: 'axis',
    axisPointer: { type: 'shadow' }
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: { 
    type: 'category',
    data: ['完成','待发货','取消','退货','退款'],
    axisLine: { lineStyle: { color: '#eee' } },
    axisLabel: { color: '#666' }
  },
  yAxis: { 
    type: 'value',
    axisLine: { show: false },
    axisLabel: { color: '#666' },
    splitLine: { lineStyle: { color: '#f5f5f5' } }
  },
  series: [
    {
      name: '订单数',
      type: 'bar',
      stack: 'total',
      data: [],
      itemStyle: { color: '#4bc0c0' }
    },
    {
      name: '异常订单',
      type: 'bar',
      stack: 'total',
      data: [],
      itemStyle: { color: '#ff6384' }
    }
  ]
})

// 根据状态返回 Tag 类型
function statusType(status) {
  switch (status) {
    case '完成': return 'success'
    case '待发货': return 'warning'
    case '取消': return 'danger'
    case '退货': return 'info'
    case '退款': return ''
    default: return ''
  }
}

// 获取趋势类
function getTrendClass(subtitle) {
  if (subtitle.includes('↑')) return 'up-trend'
  if (subtitle.includes('↓')) return 'down-trend'
  return ''
}

// 辅助函数：根据类别名称获取颜色
function getCategoryColor(name) {
  const colors = {
    '字体': '#36a2eb',
    '模板': '#ff6384',
    '插件': '#4bc0c0',
    '主题': '#ff9f40',
    '素材': '#9966ff'
  }
  return colors[name] || '#36a2eb'
}

// 模拟数据生成函数
function fetchAllData() {
  // 更新 KPI
  kpis.value = kpis.value.map(card => {
    const num = Math.floor(Math.random() * 1000 + 100)
    const change = Math.floor(Math.random() * 21) - 10
    const trend = change >= 0 ? `↑${change}%` : `↓${Math.abs(change)}%`
    const sub = `较昨日 ${trend}`
    const val = card.title === '累计销售额' ? `¥${(num * 100).toLocaleString()}` : num.toLocaleString()
    return { ...card, value: val, subtitle: sub }
  })

  // 更新图表数据
  salesTrendOption.value.series[0].data = getLastDaysLabels(7).map(() => Math.floor(Math.random() * 2000 + 500))
  regionOrderOption.value.series[0].data = regionOrderOption.value.xAxis.data.map(() => Math.floor(Math.random() * 300 + 50))
  
  // 更新饼图和柱图数据
  const categoryData = [
    { value: Math.floor(Math.random() * 500 + 100), name: '字体' },
    { value: Math.floor(Math.random() * 500 + 100), name: '模板' },
    { value: Math.floor(Math.random() * 500 + 100), name: '插件' },
    { value: Math.floor(Math.random() * 500 + 100), name: '主题' },
    { value: Math.floor(Math.random() * 500 + 100), name: '素材' }
  ]
  
  categoryPieOption.value.series[0].data = categoryData.map(item => ({
    ...item,
    itemStyle: { color: getCategoryColor(item.name) }
  }))
  
  categoryBarOption.value.series[0].data = categoryData.map(item => ({
    value: item.value,
    itemStyle: { color: getCategoryColor(item.name) }
  }))
  
  statusBarOption.value.series[0].data = statusBarOption.value.xAxis.data.map(() => Math.floor(Math.random() * 100 + 10))
  statusBarOption.value.series[1].data = statusBarOption.value.xAxis.data.map(() => Math.floor(Math.random() * 30 + 5))

  // 更新最近订单
  recentOrders.value = Array.from({ length: 20 }).map((_, i) => {
    const now = new Date()
    now.setDate(now.getDate() - Math.floor(Math.random() * 30))
    now.setHours(Math.floor(Math.random() * 24))
    now.setMinutes(Math.floor(Math.random() * 60))
    const dateStr = `${now.getFullYear()}-${String(now.getMonth()+1).padStart(2,'0')}-${String(now.getDate()).padStart(2,'0')} ${String(now.getHours()).padStart(2,'0')}:${String(now.getMinutes()).padStart(2,'0')}`
    const statuses = ['完成','待发货','取消','退货','退款']
    return {
      orderId: `OD2025${String(now.getMonth()+1).padStart(2,'0')}${String(now.getDate()).padStart(2,'0')}${String(i+1).padStart(4,'0')}`,
      customer: ['张三','李四','王五','赵六','钱七','孙八','周九','吴十'][Math.floor(Math.random() * 8)],
      amount: Math.floor(Math.random() * 10000 + 100),
      status: statuses[Math.floor(Math.random() * statuses.length)],
      date: dateStr
    }
  })
  
  updateTime()
}

// 查看订单详情
function viewOrderDetail(order) {
  console.log('查看订单详情:', order)
}

// 查看所有订单
function viewAllOrders() {
  console.log('跳转到订单列表页')
}

// 导出订单
function exportOrders() {
  console.log('导出订单数据')
}

// 初始化
onMounted(() => {
  fetchAllData()
  setInterval(updateTime, 1000)
})
</script>

<style scoped>
.dashboard-container {
  padding: 20px;
  background-color: #fbfbfb;
  min-height: 100vh;
  color: #333;
}

.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid #e6e6e6;
}

.header-left {
  display: flex;
  flex-direction: column;
}

.dashboard-title {
  font-size: 24px;
  font-weight: 600;
  margin: 0;
  color: #333;
}

.dashboard-subtitle {
  font-size: 14px;
  color: #999;
  margin-top: 4px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.time-display {
  font-size: 14px;
  color: #666;
  background-color: #f0f2f5;
  padding: 6px 12px;
  border-radius: 4px;
}

.refresh-icon {
  margin-right: 6px;
}

.kpi-container {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 24px;
}

.kpi-card {
  border-radius: 8px;
  border: none;
  transition: transform 0.3s;
}

.kpi-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1) !important;
}

.card-content {
  display: flex;
  align-items: center;
  padding: 16px;
}

.card-icon {
  width: 48px;
  height: 48px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16px;
  color: white;
  font-size: 20px;
}

.card-text {
  flex: 1;
}

.card-title {
  font-size: 14px;
  color: #666;
  margin-bottom: 4px;
}

.card-value {
  font-size: 24px;
  font-weight: 600;
  margin-bottom: 4px;
  color: #333;
}

.card-trend {
  font-size: 12px;
  display: flex;
  align-items: center;
}

.up-trend {
  color: #f56c6c;
}

.down-trend {
  color: #67c23a;
}

.chart-area {
  margin-bottom: 24px;
}

.chart-row {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  margin-bottom: 16px;
}

.chart-card {
  border-radius: 8px;
  border: none;
  transition: transform 0.3s;
}

.chart-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1) !important;
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  padding: 0 8px;
}

.chart-title {
  font-size: 16px;
  font-weight: 500;
  color: #333;
}

.chart-content {
  height: 300px;
  width: 100%;
}

.order-table-card {
  border-radius: 8px;
  border: none;
}

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.table-title {
  font-size: 16px;
  font-weight: 500;
}

.table-actions {
  display: flex;
  align-items: center;
}

.table-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
}

.order-table {
  --el-table-border-color: #e6e6e6;
  --el-table-header-bg-color: #f5f7fa;
  --el-table-row-hover-bg-color: #f5f7fa;
}

.order-table :deep(.el-table__header) th {
  background-color: #f5f7fa;
  color: #666;
  font-weight: 600;
}

.order-table :deep(.el-table__body) tr:hover > td {
  background-color: #f5f7fa !important;
}

.v-chart {
  height: 100%;
}
</style>