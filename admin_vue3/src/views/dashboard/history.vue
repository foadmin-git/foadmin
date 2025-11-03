<template>
    <div class="p-6 bg-gray-100 min-h-screen">
      <!-- 标题 -->
      <h1 class="text-2xl font-semibold mb-6">控制台</h1>
  
      <!-- 统计卡片 -->
      <el-row :gutter="20" class="mb-6">
        <el-col :span="6" v-for="card in stats" :key="card.title">
          <el-card shadow="hover" class="p-4">
            <div class="flex items-center">
              <el-icon :size="32" class="text-blue-500">
                <component :is="card.icon" />
              </el-icon>
              <div class="ml-4">
                <div class="text-gray-500">{{ card.title }}</div>
                <div class="text-xl font-bold">{{ card.value }}</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
  
      <!-- 最近订单表格 -->
      <el-card shadow="hover">
        <div slot="header" class="flex justify-between items-center">
          <span class="font-semibold">最近订单</span>
          <el-button type="primary" size="small">查看全部</el-button>
        </div>
        <el-table
          :data="recentOrders"
          stripe
          style="width: 100%"
        >
          <el-table-column prop="orderId" label="订单号" width="180" />
          <el-table-column prop="customer" label="客户" />
          <el-table-column prop="amount" label="金额" width="120">
            <template #default="{ row }">
              ¥{{ row.amount }}
            </template>
          </el-table-column>
          <el-table-column prop="status" label="状态" width="120">
            <template #default="{ row }">
              <el-tag :type="statusType(row.status)">{{ row.status }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="date" label="日期" width="180" />
        </el-table>
      </el-card>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue'
  import {
    UserFilled,
    Ticket,
    Money,
    User
  } from '@element-plus/icons-vue'
  
  const stats = [
    {
      title: '用户数',
      value: 1024,
      icon: UserFilled
    },
    {
      title: '新增订单',
      value: 58,
      icon: Ticket
    },
    {
      title: '销售额',
      value: '¥76,540',
      icon: Money
    },
    {
      title: '活跃访客',
      value: 345,
      icon: User
    }
  ]
  
  const recentOrders = ref([
    { orderId: 'OD20250701001', customer: '张三', amount: 230, status: '完成', date: '2025-07-04 10:23' },
    { orderId: 'OD20250701002', customer: '李四', amount: 450, status: '待发货', date: '2025-07-04 09:45' },
    { orderId: 'OD20250701003', customer: '王五', amount: 125, status: '取消', date: '2025-07-03 16:12' },
    { orderId: 'OD20250701004', customer: '赵六', amount: 980, status: '完成', date: '2025-07-03 14:05' }
  ])
  
  function statusType(status) {
    switch (status) {
      case '完成':
        return 'success'
      case '待发货':
        return 'warning'
      case '取消':
        return 'danger'
      default:
        return ''
    }
  }
  </script>
  
  <style scoped>
  /* 隐藏表格滚动条 */
  .el-table__body-wrapper::-webkit-scrollbar {
    display: none;
  }
  </style>
  