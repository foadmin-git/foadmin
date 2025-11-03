// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router'
import { userStore } from '@/store/user'
import { appStore } from '@/store/app'
import { meApi } from '@/api/auth'
import { adminMenusApi } from '@/api/menu'

const Login = () => import('../views/login.vue')
const Profile = () => import('../views/account/profile.vue')
const Placeholder = () => import('../views/dashboard/index.vue')

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/login', name: 'login', component: Login, meta: { inNav: false, title: '登录', layout: 'blank' } },
    { path: '/account/profile', name: 'account-profile', component: Profile, meta: { inNav: false, title: '个人资料' } },
    { path: '/', redirect: '/dashboard' },
    { path: '/:pathMatch(.*)*', name: 'not-found', component: Placeholder, meta: { inNav: false, title: '未找到' } }
  ]
})

let injected = false
let seq = 0
const usedNames = new Set()

// ① 预扫描 views 下的所有 .vue 文件
const viewModules = import.meta.glob('../views/**/*.vue')

// 工具：标准化 path（必须以 / 开头）
function normalizePath(p, fallback) {
  const base = (p ?? fallback ?? '').toString().trim()
  if (!base) return '/'
  return base.startsWith('/') ? base : `/${base}`
}

// 工具：标准化 route_component（去掉前导/ 与 .vue）
function normalizeCompPath(p, fallback = 'dashboard/index') {
  const raw = (p ?? fallback).toString().trim()
  return raw.replace(/^\/+/, '').replace(/\.vue$/i, '')
}

// ② 路由组件解析器：兼容 xxx.vue 与 xxx/index.vue
function resolveView(compPath) {
  const full = `../views/${compPath}.vue`
  const alt  = `../views/${compPath}/index.vue`
  if (viewModules[full]) return viewModules[full]
  if (viewModules[alt])  return viewModules[alt]
  console.warn('[route_component missing]', full, 'or', alt, '→ fallback to dashboard/index.vue')
  return viewModules['../views/dashboard/index.vue'] || (() => import('../views/dashboard/index.vue'))
}

// ③ 递归注入：为每个节点写入 meta._seq、meta.order（从 sort 映射）
function injectMenusToRoutes(tree, parentName = null) {
  tree.forEach(node => {
    const compPath = normalizeCompPath(node.route_component, 'dashboard/index')

    // 唯一 name
    const base = node.name || node.path || `route_${node.id || seq}`
    const routeName = usedNames.has(base) ? `${base}__${node.id || seq}` : base
    usedNames.add(routeName)

    const finalPath = normalizePath(node.path, base)

    const route = {
      path: finalPath,
      name: routeName,
      component: resolveView(compPath),
      meta: {
        inNav: true,
        title: node.title || base,
        icon: node.icon,
        parent: parentName,
        order: (typeof node.sort === 'number' ? node.sort : null),
        _seq: seq++
      }
    }

    router.addRoute(route)

    if (node.children?.length) {
      injectMenusToRoutes(node.children, routeName)
    }
  })
}

router.beforeEach(async (to, from, next) => {
  if (to.path === '/login') return next()
  if (!userStore.token) return next('/login')

  if (!injected) {
    try {
      await meApi()
    } catch {
      userStore.clear()
      return next('/login')
    }

    const { items } = await adminMenusApi()
    injectMenusToRoutes(items)
    injected = true
    appStore.routesReady = true

    // 提前设置目标标题（如果已可解析）
    const target = router.getRoutes().find(r => r.path === to.path)
    if (target?.meta?.title) document.title = target.meta.title

    // ⚠️ 关键修复：用“原始 URL”重新按 path 匹配，而不是展开 to（避免继续命中 not-found）
    return next({ path: to.fullPath, replace: true })
  }

  document.title = to.meta?.title || 'Foadmin'
  next()
})

export default router
