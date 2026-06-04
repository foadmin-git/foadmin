<!--src/App.vue-->
<template>
  <!-- 非 blank 布局：渲染全局框架 -->
  <div v-if="!isBlankLayout" class="flex flex-col h-screen">
    <div class="flex flex-1 overflow-hidden">
      <Sidebar class="hidden md:flex" />
      <div class="flex-1 flex flex-col overflow-hidden">
        <HeaderTabs @toggle-sidebar="toggleSidebar" />
        <div class="flex-1 overflow-auto p-4 bg-gray-100">
          <router-view />
        </div>
        <FooterBar />
      </div>
    </div>

    <!-- 移动端抽屉式侧边栏 -->
    <div v-if="showMobileSidebar" class="fixed inset-0 z-50 md:hidden">
      <div class="absolute inset-0 bg-black bg-opacity-50" @click="showMobileSidebar = false"></div>
      <div class="absolute left-0 top-0 bottom-0 w-64 bg-white">
        <Sidebar @close="showMobileSidebar = false" />
      </div>
    </div>
  </div>

  <!-- blank 布局：只渲染页面本身（登录页） -->
  <div v-else class="min-h-screen">
    <router-view />
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import Sidebar from './components/Sidebar.vue'
import HeaderTabs from './components/HeaderTabs.vue'
import FooterBar from './components/FooterBar.vue'
import { userStore } from './store/user'

const showMobileSidebar = ref(false)
const toggleSidebar = () => { showMobileSidebar.value = !showMobileSidebar.value }

const route = useRoute()
// 关键：当路由 meta.layout === 'blank' 时，不渲染全局布局
const isBlankLayout = computed(() => route.meta?.layout === 'blank')

// 演示账号提示：切换路由时显示，3秒后自动消失
watch(
  () => route.path,
  () => {
    if (userStore.is_demo && !isBlankLayout.value) {
      ElMessage({
        message: '当前为演示账号，仅拥有查看权限，无法执行任何操作',
        type: 'warning',
        duration: 3000,
        showClose: true,
        offset: 50
      })
    }
  },
  { immediate: true }
)
</script>
<style>
:root {
  /* Element Plus 主题色 - 默认值（会被 JavaScript 覆盖） */
  --el-color-primary: #0031ff;
  --el-color-primary-light-1: #0093ff;
  --el-color-primary-light-2: #0093ff;
  --el-color-primary-light-3: #0093ff;
  --el-color-primary-light-4: #6583ff;
  --el-color-primary-light-5: #7f98ff;
  --el-color-primary-light-6: #99acff;
  --el-color-primary-light-7: #b2c1ff;
  --el-color-primary-light-8: #ccd5fe;
  --el-color-primary-light-9: #e5eaff;
  --el-color-primary-dark-1: #0028d8;
  --el-color-primary-dark-2: #0027cc;
  --el-color-primary-dark-3: #0022b2;
  /* RGB 通用变量，用于 Element Plus 内部计算 */
  --el-color-primary-rgb: 0, 49, 255;

  /* Highlight color for the side navigation.  Use a CSS variable instead of
     hard‑coding colors in components so that the color automatically
     updates when the dark mode class is toggled on the <html> element.  In
     the default (light) theme this matches the primary blue.  In dark mode
     it is overridden in dark.css to a neutral dark gray (#3e4143). */
  --nav-highlight-color: #0031ff;
}
/* 覆盖所有 primary 类型按钮的背景色 - 使用 CSS 变量 */
.el-button--primary {
  background-color: var(--el-color-primary) !important;
  border-color: var(--el-color-primary) !important;
}

.el-button--primary:hover {
  background-color: var(--el-color-primary-dark-1) !important;
  border-color: var(--el-color-primary-dark-1) !important;
}

.el-button--primary:active {
  background-color: var(--el-color-primary-dark-2) !important;
  border-color: var(--el-color-primary-dark-2) !important;
}


/* 如果需要覆盖 hover 和 active 状态 */
.el-button--primary:hover,
.el-button--primary:focus {
  background-color: var(--el-color-primary-dark-1) !important;
  border-color: var(--el-color-primary-dark-1) !important;
}

.el-button--primary:active {
  background-color: var(--el-color-primary-dark-2) !important;
  border-color: var(--el-color-primary-dark-2) !important;
}


/* 输入框 / 文本域：聚焦边框与内阴影 */
.el-input__wrapper.is-focus,
.el-textarea__inner:focus {
  border-color: var(--el-color-primary) !important;
  box-shadow: 0 0 0 1px var(--el-color-primary) inset !important;
}

/* 输入框 hover 边框（可选） */
.el-input__wrapper:hover {
  border-color: var(--el-color-primary) !important;
}

/* Select：聚焦态 */
.el-select .el-input.is-focus .el-input__wrapper {
  border-color: var(--el-color-primary) !important;
  box-shadow: 0 0 0 1px var(--el-color-primary) inset !important;
}

/* 日期/时间选择器：聚焦态 */
.el-date-editor.el-input__wrapper.is-focus,
.el-time-picker .el-input__wrapper.is-focus {
  border-color: var(--el-color-primary) !important;
  box-shadow: 0 0 0 1px var(--el-color-primary) inset !important;
}

/* 复选/单选/开关/滑块：选中态主色 */
.el-checkbox.is-checked .el-checkbox__inner,
.el-radio.is-checked .el-radio__inner,
.el-switch.is-checked .el-switch__core,
.el-slider__bar,
.el-slider__button {
  border-color: var(--el-color-primary) !important;
  background-color: var(--el-color-primary) !important;
}


/* 悬停状态（hover） */
.el-button:not(.el-button--primary):not(.el-button--success):hover {
  color: var(--el-color-primary);
  border-color: var(--el-color-primary);
  background-color: rgba(var(--el-color-primary-rgb), 0.1); /* 可选：悬停背景色 */
}

/* 点击/聚焦状态（active + focus） */
.el-button:not(.el-button--primary):not(.el-button--success):active,
.el-button:not(.el-button--primary):not(.el-button--success):focus {
  color: var(--el-color-primary);
  border-color: var(--el-color-primary);
  background-color: rgba(var(--el-color-primary-rgb), 0.2); /* 可选：点击背景色 */
}

/* 确保按钮内部的 span 也继承颜色 */
.el-button:not(.el-button--primary):not(.el-button--success) span {
  color: inherit;
}


/* ========= Element Plus 分页颜色：统一为主色 ========= */
/* 分页当前页背景色改为主色 */
.el-pagination .el-pager li.is-active {
  background-color: var(--el-color-primary) !important;
  border-color: var(--el-color-primary) !important;
  color: #fff !important;
}

/* 悬停页码边框和文字改为主色 */
.el-pagination .el-pager li:not(.is-active):hover {
  color: var(--el-color-primary) !important;
  border-color: var(--el-color-primary) !important;
}
/* 分页箭头按钮背景色改为主色 */
.el-pagination .btn-prev,
.el-pagination .btn-next {
  color: var(--el-color-primary) !important; /* 箭头颜色 */
  border-color: var(--el-color-primary) !important; /* 边框颜色 */
}

/* 悬停箭头：背景和边框变为主色，箭头颜色保持白色 */
.el-pagination .btn-prev:hover,
.el-pagination .btn-next:hover {
  background-color: var(--el-color-primary) !important;
  border-color: var(--el-color-primary) !important;
  color: #fff !important; /* 悬停时箭头变为白色 */
}

/* 当前页按钮（箭头）的聚焦态 */
.el-pagination .btn-prev:focus,
.el-pagination .btn-next:focus {
  background-color: var(--el-color-primary) !important;
  border-color: var(--el-color-primary) !important;
  color: #fff !important;
}

/* 开关激活状态 */
.el-switch__label.is-active {
    color: var(--el-color-primary) !important;
}

/* 标签页激活状态 */
.el-tabs__item.is-active, .el-tabs__item:hover {
    color: var(--el-color-primary) !important;
}
.el-tabs__active-bar {
    background-color: var(--el-color-primary) !important;
    bottom: 0;
    height: 2px;
    left: 0;
    list-style: none;
    position: absolute;
    transition: width var(--el-transition-duration) var(--el-transition-function-ease-in-out-bezier), transform var(--el-transition-duration) var(--el-transition-function-ease-in-out-bezier);
    z-index: 1;
}

.el-select-dropdown__item.is-selected
 {
    color: var(--el-color-primary) !important;
    font-weight: bold;
}
.el-select__wrapper.is-focused {
    box-shadow: 0 0 0 1px var(--el-color-primary) !important;
}
.el-dropdown-menu__item:not(.is-disabled):focus,
.el-dropdown-menu__item:not(.is-disabled):hover {
    background-color: var(--el-dropdown-menuItem-hover-fill);
    color: var(--el-color-primary) !important;
}
.el-range-editor.is-active, 
.el-range-editor.is-active:hover {
    box-shadow: 0 0 0 1px var(--el-color-primary) !important;
}

.el-date-table td.end-date .el-date-table-cell__text, .el-date-table td.start-date .el-date-table-cell__text {
    background-color: var(--el-color-primary) !important;
}

</style>
