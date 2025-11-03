<!-- src/components/Sidebar.vue -->
<template>
  <div ref="sidebar" class="relative flex h-screen bg-white text-black">
    <!-- 左侧主栏（图标） -->
    <div class="w-20 border-r flex flex-col">
      <!-- Logo -->
      <div class="h-16 flex items-center justify-center">
        <img :src="logo" alt="logo" class="h-12" />
      </div>

      <!-- 一级（顶级） -->
      <ul class="flex-1">
        <li
          v-for="sec in topSections"
          :key="sec.key"
          @click="activateTop(sec)"
          :class="[
            'cursor-pointer flex flex-col items-center py-4 transition-colors',
            activeTop && isSameNode(activeTop, sec)
              ? 'bg-[#0031ff] text-white'
              : 'hover:bg-[#0031ff] hover:text-white'
          ]"
        >
          <component :is="resolveIcon(sec.icon)" class="h-6 w-6" />
          <span class="text-xs mt-1 truncate px-1">{{ sec.title }}</span>
        </li>
      </ul>

      <!-- 用户头像区 -->
      <div class="flex justify-center p-4">
        <el-dropdown trigger="hover">
          <span class="cursor-pointer block focus:outline-none focus:ring-0">
            <div class="rounded-full p-1 hover:bg-gray-200 transition-colors">
              <el-avatar :size="36" :src="avatars" class="[&>img]:!border-none !border-none" />
            </div>
          </span>
          <template #dropdown>
            <el-dropdown-menu class="w-44">
              <el-dropdown-item>{{ user.name }}（{{ user.role }}）</el-dropdown-item>
              <el-dropdown-item divided @click="goProfile">个人资料</el-dropdown-item>
              <el-dropdown-item @click="logout">退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </div>

    <!-- 右侧子面板：仅当有二级菜单时渲染 -->
    <div v-if="hasSubmenu" class="w-64 border-r flex flex-col">
      <!-- 搜索 + 收藏 -->
      <div class="p-3 border-b space-y-2">
        <el-input v-model="keyword" size="small" placeholder="搜索菜单" clearable />
        <template v-if="pinned.length">
          <div class="text-xs text-gray-500">常用</div>
          <ul class="flex flex-wrap gap-2">
            <li
              v-for="p in pinned"
              :key="p.path"
              class="px-2 py-1 border rounded text-xs cursor-pointer hover:text-[#0031ff]"
              @click="go(p.path)"
            >
              {{ p.title }}
            </li>
          </ul>
        </template>
      </div>

      <!-- 二级/三级/…（Accordion） -->
      <el-scrollbar class="flex-1 pl-2">
        <el-collapse v-model="openKeys" accordion>
          <el-collapse-item
            v-for="child in filteredSecond"
            :key="child.key"
            :name="child.key"
          >
            <template #title>
              <div class="flex items-center justify-between w-full pr-2">
                <span class="truncate">{{ child.title }}</span>
                <span v-if="!child.children?.length" class="text-xs text-gray-400">叶子</span>
              </div>
            </template>

            <!-- 叶子直接进入 -->
            <div
              v-if="!child.children?.length"
              class="px-3 py-2 hover:bg-gray-50 cursor-pointer rounded"
              @click="go(child.path)"
            >
              进入 {{ child.title }}
            </div>

            <!-- 多级缩进列表（无限级） -->
            <ul v-else class="py-1">
              <li
                v-for="g in child.flatChildren"
                :key="g.key"
                class="px-3 py-2 hover:bg-gray-50 cursor-pointer rounded flex items-center justify-between"
                @click="go(g.path)"
                :style="{ paddingLeft: (12 * (g.depth + 1)) + 'px' }"
              >
                <span class="truncate">{{ g.title }}</span>
                <el-icon @click.stop="togglePin(g)" class="ml-2 cursor-pointer">
                  <Star v-if="!isPinned(g)" />
                  <StarFilled v-else />
                </el-icon>
              </li>
            </ul>
          </el-collapse-item>
        </el-collapse>
      </el-scrollbar>
    </div>
  </div>
</template>

<script setup>
import { markRaw } from 'vue'
import { ref, computed, watch, onMounted, onBeforeUnmount } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { userStore } from '@/store/user'
import { appStore } from '@/store/app'
import logo from '../assets/logo.png'
import avatars from '../assets/T.jpg'

/**
 * 路由 meta 约定：
 * meta: { inNav: true, title: '标题', icon: 'Grid'(仅顶级), parent: '上级name', order: number|null|undefined, _seq: number }
 */

const router = useRouter()
const route = useRoute()

/** 稳定排序：先按 order，再按 _seq（无限级通用） */
const byOrderThenSeq = (a, b) => {
  const ao = a.order
  const bo = b.order
  const aHas = ao !== undefined && ao !== null
  const bHas = bo !== undefined && bo !== null

  if (aHas && bHas) {
    if (ao !== bo) return ao - bo
    return (a._seq ?? 0) - (b._seq ?? 0)
  }
  if (aHas !== bHas) return aHas ? -1 : 1
  return (a._seq ?? 0) - (b._seq ?? 0)
}

/** 递归扁平化：把任意深度的 children 展开为一维数组，附带 depth 用于缩进 */
function flattenTree(nodes = [], depth = 0) {
  const out = []
  for (const n of nodes) {
    out.push({ ...n, depth })
    if (n.children?.length) out.push(...flattenTree(n.children, depth + 1))
  }
  return out
}

/** 路由 → 扁平导航节点 */
const allNavRoutes = computed(() => {
  // 依赖 appStore.routesReady 保证动态路由已注入
  const ready = appStore.routesReady
  // 依赖 route 使其在路由切换时刷新
  const _ = route.fullPath
  if (!ready) return []
  return router
    .getRoutes()
    .filter((r) => r.meta?.inNav)
    .map((r) => ({
      key: r.name || r.path,
      name: r.name,
      title: r.meta.title || r.name || r.path,
      icon: r.meta.icon,
      path: r.path,
      parent: r.meta.parent || null,
      order: r.meta.order,   // ★ 从 meta 取出
      _seq: r.meta._seq ?? 0 // ★ 从 meta 取出
    }))
})

/** 顶级（主栏） */
const topSections = computed(() =>
  allNavRoutes.value
    .filter((r) => !r.parent)
    .sort(byOrderThenSeq)
)

const activeTop = ref(null)
const openKeys = ref([])
const keyword = ref('')

/** 构建任意深度的 children 树，并在每一层用统一比较器排序 */
function buildChildren(parentKey) {
  const direct = allNavRoutes.value
    .filter((r) => r.parent === parentKey)
    .sort(byOrderThenSeq)

  return direct.map((d) => ({
    ...d,
    children: buildChildren(d.name || d.key || d.path)
  }))
}

/** 二/三级/…（子面板根） */
const secondLevel = computed(() => {
  if (!activeTop.value) return []
  const topKey = activeTop.value.name || activeTop.value.key || activeTop.value.path

  const level2 = allNavRoutes.value
    .filter((r) => r.parent === topKey)
    .sort(byOrderThenSeq)

  return level2.map((sec) => {
    const secKey = sec.name || sec.key || sec.path
    const childrenTree = buildChildren(secKey)           // 已按 byOrderThenSeq 排序
    const flatChildren = flattenTree(childrenTree, 0)    // 展开保持当前顺序
    return { ...sec, children: childrenTree, flatChildren }
  })
})

/** 是否有子菜单（控制右侧面板渲染） */
const hasSubmenu = computed(() => secondLevel.value.length > 0)

/** 搜索过滤（仅过滤二/三级/…） */
const filteredSecond = computed(() => {
  if (!keyword.value) return secondLevel.value
  const k = keyword.value.toLowerCase()
  return secondLevel.value
    .map((s) => {
      const flat = (s.flatChildren || []).filter((c) => (c.title || '').toLowerCase().includes(k))
      return { ...s, flatChildren: flat }
    })
    .filter((s) => (s.title || '').toLowerCase().includes(k) || (s.flatChildren && s.flatChildren.length))
})

/** 收藏（本地持久化） */
const PIN_KEY = 'foadmin_pinned_v1'
const pinned = ref([])

onMounted(() => {
  try {
    const raw = localStorage.getItem(PIN_KEY)
    if (raw) pinned.value = JSON.parse(raw)
  } catch (_) {}
})
watch(
  pinned,
  (v) => {
    try {
      localStorage.setItem(PIN_KEY, JSON.stringify(v))
    } catch (_) {}
  },
  { deep: true }
)

function isPinned(item) {
  return pinned.value.some((p) => p.path === item.path)
}
function togglePin(item) {
  if (isPinned(item)) {
    pinned.value = pinned.value.filter((p) => p.path !== item.path)
  } else {
    pinned.value.push({ title: item.title, path: item.path })
  }
}

/** 顶级切换：
 *  - 有二级：展开第一个
 *  - 无二级：不显示右侧面板，直接进顶级页面
 */
function activateTop(sec) {
  activeTop.value = sec
  if (secondLevel.value.length) {
    openKeys.value = [secondLevel.value[0].key]
  } else {
    openKeys.value = []
    if (sec.path) {
      go(sec.path)
    }
  }
}

/** 导航：移动端抽屉内点击后自动关闭 */
const emit = defineEmits(['close'])
function go(path) {
  router.push(path)
  emit('close')
}

/** 与路由同步，保持定位感 */
function isSameNode(a, b) {
  return (a?.name || a?.key || a?.path) === (b?.name || b?.key || b?.path)
}

watch(
  () => route.fullPath,
  () => {
    const current = allNavRoutes.value.find((r) => r.path === route.path)
    if (!current) return

    // 回溯到顶级
    let top = current
    const chain = [current]
    let safety = 0
    while (top?.parent && safety++ < 50) {
      const parent = allNavRoutes.value.find((r) =>
        (r.name || r.key || r.path) === top.parent ||
        r.key === top.parent ||
        r.path === top.parent
      )
      if (!parent) break
      chain.push(parent)
      top = parent
    }

    const topInList = topSections.value.find((t) => isSameNode(t, top))
    if (topInList) {
      activeTop.value = topInList
      // 链里包含二级则展开；否则不打开面板
      const topKey = topInList.name || topInList.key || topInList.path
      const level2 = chain.find((x) => x.parent === topKey)
      openKeys.value = level2 ? [level2.key] : []
    } else if (topSections.value.length && !activeTop.value) {
      activeTop.value = topSections.value[0]
    }

    // 守护：当前顶级无子菜单时，不展示面板
    if (activeTop.value && !secondLevel.value.length) {
      openKeys.value = []
    }
  },
  { immediate: true }
)

/** 点击外部（可按需处理，这里不强制收起） */
const sidebar = ref(null)
function handleClickOutside(e) {
  if (!sidebar.value) return
  if (!sidebar.value.contains(e.target)) {
    // 可在此收起 openKeys
    // openKeys.value = []
  }
}
onMounted(() => document.addEventListener('click', handleClickOutside))
onBeforeUnmount(() => document.removeEventListener('click', handleClickOutside))

/** 图标解析：支持字符串（全局已注册）或组件本身 */
function resolveIcon(icon) {
  if (!icon) return 'Grid'
  if (typeof icon === 'string') return icon
  return markRaw(icon)
}

/** 用户信息（演示） */
const user = computed(() => ({
  name: userStore.user?.nick_name || userStore.user?.username || '用户',
  role: (userStore.roles && userStore.roles[0]) || 'member'
}))

function goProfile() {
  router.push('/account/profile')
}
function logout() {
  try { localStorage.removeItem('foadmin_pinned_v1') } catch {}
  userStore.clear()
  appStore.routesReady = false // 让侧栏等依赖马上清空
  // 为了把“已注入的动态路由/injected 标志”彻底复位，简单粗暴全量刷新
  window.location.href = '/login'
}
</script>

<style scoped>
/* 深度选择器覆盖头像边框 */
:deep(.el-avatar) { border: none !important; }
:deep(.el-avatar:hover) { border: none !important; }
</style>
