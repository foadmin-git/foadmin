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
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import Sidebar from './components/Sidebar.vue'
import HeaderTabs from './components/HeaderTabs.vue'
import FooterBar from './components/FooterBar.vue'

const showMobileSidebar = ref(false)
const toggleSidebar = () => { showMobileSidebar.value = !showMobileSidebar.value }

const route = useRoute()
// 关键：当路由 meta.layout === 'blank' 时，不渲染全局布局
const isBlankLayout = computed(() => route.meta?.layout === 'blank')
</script>
<style>
:root {
  --el-color-primary: #0031ff;
  /* 以下是可选的深浅变体，按需调整 */
  --el-color-primary-light-3: #dde1ff;
  --el-color-primary-light-2: #b7bcff;
  --el-color-primary-light-1: #8a96ff;
  --el-color-primary-dark-1: #002ecc;

}
/* 覆盖所有 primary 类型按钮的背景色 */
.el-button--primary {
  background-color: #0031ff !important;
  border-color: #0031ff !important;
}


/* 如果需要覆盖 hover 和 active 状态 */
.el-button--primary:hover,
.el-button--primary:focus {
  background-color: #0028d4 !important;
  border-color: #0028d4 !important;
}

.el-button--primary:active {
  background-color: #0021b0 !important;
  border-color: #0021b0 !important;
}


/* 输入框 / 文本域：聚焦边框与内阴影 */
.el-input__wrapper.is-focus,
.el-textarea__inner:focus {
  border-color: #0031ff !important;
  box-shadow: 0 0 0 1px #0031ff inset !important;
}

/* 输入框 hover 边框（可选） */
.el-input__wrapper:hover {
  border-color: #0031ff !important;
}

/* Select：聚焦态 */
.el-select .el-input.is-focus .el-input__wrapper {
  border-color: #0031ff !important;
  box-shadow: 0 0 0 1px #0031ff inset !important;
}

/* 日期/时间选择器：聚焦态 */
.el-date-editor.el-input__wrapper.is-focus,
.el-time-picker .el-input__wrapper.is-focus {
  border-color: #0031ff !important;
  box-shadow: 0 0 0 1px #0031ff inset !important;
}

/* 复选/单选/开关/滑块：选中态主色 */
.el-checkbox.is-checked .el-checkbox__inner,
.el-radio.is-checked .el-radio__inner,
.el-switch.is-checked .el-switch__core,
.el-slider__bar,
.el-slider__button {
  border-color: #0031ff !important;
  background-color: #0031ff !important;
}


/* 悬停状态（hover） */
.el-button:not(.el-button--primary):not(.el-button--success):hover {
  color: #0031ff;
  border-color: #0031ff;
  background-color: rgba(0, 49, 255, 0.1); /* 可选：悬停背景色 */
}

/* 点击/聚焦状态（active + focus） */
.el-button:not(.el-button--primary):not(.el-button--success):active,
.el-button:not(.el-button--primary):not(.el-button--success):focus {
  color: #0031ff;
  border-color: #0031ff;
  background-color: rgba(0, 49, 255, 0.2); /* 可选：点击背景色 */
}

/* 确保按钮内部的 span 也继承颜色 */
.el-button:not(.el-button--primary):not(.el-button--success) span {
  color: inherit;
}


/* ========= Element Plus 分页颜色：统一为主色 ========= */
/* 分页当前页背景色改为主色 #0031ff */
.el-pagination .el-pager li.is-active {
  background-color: #0031ff !important;
  border-color: #0031ff !important;
  color: #fff !important;
}

/* 悬停页码边框和文字改为主色 */
.el-pagination .el-pager li:not(.is-active):hover {
  color: #0031ff !important;
  border-color: #0031ff !important;
}
/* 分页箭头按钮背景色改为主色 */
.el-pagination .btn-prev,
.el-pagination .btn-next {
  color: #0031ff !important; /* 箭头颜色 */
  border-color: #0031ff !important; /* 边框颜色 */
}

/* 悬停箭头：背景和边框变为主色，箭头颜色保持白色 */
.el-pagination .btn-prev:hover,
.el-pagination .btn-next:hover {
  background-color: #0031ff !important;
  border-color: #0031ff !important;
  color: #fff !important; /* 悬停时箭头变为白色 */
}

/* 当前页按钮（箭头）的聚焦态 */
.el-pagination .btn-prev:focus,
.el-pagination .btn-next:focus {
  background-color: #0031ff !important;
  border-color: #0031ff !important;
  color: #fff !important;
}
.el-switch__label.is-active {
    color: #0031ff !important;
}
.el-tabs__item.is-active, .el-tabs__item:hover {
    color: #0031ff !important;
}
.el-tabs__active-bar {
    background-color: #0031ff !important;
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
    color: #0031ff !important;
    font-weight: bold;
}
.el-select__wrapper.is-focused {
    box-shadow: 0 0 0 1px #0031ff !important;
}
.el-dropdown-menu__item:not(.is-disabled):focus,
.el-dropdown-menu__item:not(.is-disabled):hover {
    background-color: var(--el-dropdown-menuItem-hover-fill);
    color: #0031ff !important;
}
.el-range-editor.is-active, 
.el-range-editor.is-active:hover {
    box-shadow: 0 0 0 1px #0031ff !important;
}

.el-date-table td.end-date .el-date-table-cell__text, .el-date-table td.start-date .el-date-table-cell__text {
    background-color: #0031ff !important;
}

</style>
