<!-- src/components/HeaderTabs.vue -->
<template>
  <div class="flex items-center h-12 border-b px-4 relative bg-white">
    <!-- 移动端菜单按钮 -->
    <button @click="$emit('toggle-sidebar')" class="md:hidden mr-2">
      <el-icon><Menu /></el-icon>
    </button>

    <!-- 左箭头 -->
    <button @click="scrollBy(-200)" class="mr-2 hidden md:block">
      <el-icon><ArrowLeft /></el-icon>
    </button>

    <!-- 标签容器 -->
    <div
      ref="tabs"
      class="flex-1 flex overflow-x-auto no-scrollbar cursor-grab text-sm"
      @mousedown="startDrag"
      @mousemove="onDrag"
      @mouseup="stopDrag"
      @mouseleave="stopDrag"
    >
      <div
        v-for="(tab, i) in tabsList"
        :key="tab.path"
        @click="activate(tab)"
        class="flex items-center justify-between px-3 py-1 mr-2 border rounded whitespace-nowrap cursor-pointer"
        :class="activeTab.path === tab.path ? 'border border-[#0031ff] text-[#0031ff]' : 'border-gray-300'"
      >
        <span class="truncate">{{ tab.title }}</span>
        <span v-if="i !== 0" @click.stop="closeTab(i)" class="ml-2 inline-flex items-center">
          <el-icon><Close /></el-icon>
        </span>
      </div>
    </div>

    <!-- 右箭头 -->
    <button @click="scrollBy(200)" class="ml-2 hidden md:block">
      <el-icon><ArrowRight /></el-icon>
    </button>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ArrowLeft, ArrowRight, Close, Menu } from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()
const tabs = ref(null)

// 初始固定一个“控制台”
const tabsList = ref([{ title: '控制台', path: '/dashboard' }])
const activeTab = ref(tabsList.value[0])

/** 仅使用路由自身的元信息/名称/路径，不再用 document.title 兜底 */
function titleOf(r) {
  return r?.meta?.title || r?.name || r?.path || '未命名'
}

/** 是否为可建标签的业务路由：必须 meta.inNav === true */
function isTabRoute(r) {
  // not-found 或未匹配到真实记录时，直接过滤
  if (!r || r.name === 'not-found' || !r.matched?.length) return false
  // 取最终匹配的记录（嵌套路由时以最后一条为准）
  const record = r.matched[r.matched.length - 1]
  return !!record.meta?.inNav
}

// 点击激活标签并路由跳转
function activate(tab) {
  activeTab.value = tab
  router.push(tab.path)
}

// 关闭标签并跳转到相邻标签
function closeTab(i) {
  tabsList.value.splice(i, 1)
  const newIndex = i < tabsList.value.length ? i : tabsList.value.length - 1
  const newTab = tabsList.value[newIndex]
  if (newTab) {
    activeTab.value = newTab
    router.push(newTab.path)
  }
}

// 左右滚动
function scrollBy(amount) {
  tabs.value?.scrollBy?.({ left: amount, behavior: 'smooth' })
}

// 拖拽滚动
let isDrag = false
let startX = 0
let scrollLeft = 0
function startDrag(e) {
  isDrag = true
  startX = e.pageX
  scrollLeft = tabs.value.scrollLeft
}
function onDrag(e) {
  if (!isDrag) return
  const delta = startX - e.pageX
  tabs.value.scrollLeft = scrollLeft + delta
}
function stopDrag() { isDrag = false }

/** 路由变化：只给业务路由建标签；若已存在则更新标题（修正首次为“未找到/站点标题”的情况） */
watch(
  () => route.fullPath,
  () => {
    if (!isTabRoute(route)) {
      // 不是业务路由就只做聚焦搬迁：若当前 activeTab 不属于业务路由，不新增
      return
    }
    const path = route.path
    const newTitle = titleOf(route)
    const existing = tabsList.value.find(tab => tab.path === path)
    if (!existing) {
      tabsList.value.push({ title: newTitle, path })
    } else if (existing.title !== newTitle) {
      existing.title = newTitle
    }
    const current = tabsList.value.find(tab => tab.path === path)
    if (current) activeTab.value = current
  },
  { immediate: true }
)
</script>

<style>
.no-scrollbar::-webkit-scrollbar { display: none; }
</style>
