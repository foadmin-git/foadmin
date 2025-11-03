<!--src/views/login.vue-->
<template>
  <div class="min-h-screen bg-white flex">
    <!-- 左侧品牌背景区 -->
    <div class="hidden lg:flex w-1/2 bg-gray-50 relative items-center justify-center">
      <!-- 大型F字母背景 -->
      <div class="absolute inset-0 flex items-center justify-center">
        <span class="text-[20rem] font-bold text-gray-100">FAD</span>
      </div>
      
      <!-- 品牌标语 -->
      <div class="relative z-10 max-w-xs text-center">
        <h2 class="text-4xl font-bold text-gray-800 mb-4">Foadmin</h2>
        <p class="text-gray-600">最智能的后台开发框架</p>
      </div>
    </div>
    
    <!-- 右侧登录表单区 -->
    <div class="w-full lg:w-1/2 flex items-center justify-center p-8">
      <div class="w-full max-w-md">
        <!-- Logo -->
        <div class="flex items-center justify-center mb-6 lg:hidden">
          <div class="w-10 h-10 bg-[#0031ff] bg-opacity-10 rounded-lg flex items-center justify-center mr-3 border border-[#0031ff] border-opacity-20">
            <span class="text-xl font-bold text-[#0031ff]">F</span>
          </div>
          <h1 class="text-xl font-bold text-gray-800">Foadmin</h1>
        </div>
        
        <h2 class="text-lg font-semibold text-gray-800 mb-4 text-center lg:text-left">欢迎回来</h2>
        
        <!-- 登录表单 -->
        <el-form :model="form" @keyup.enter="submit">
          <el-form-item class="mb-4">
            <el-input 
              v-model="form.username" 
              placeholder="请输入用户名"
              class="custom-input-compact"
            >
              <template #prefix>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                </svg>
              </template>
            </el-input>
          </el-form-item>
          
          <el-form-item class="mb-5">
            <el-input 
              v-model="form.password" 
              type="password" 
              placeholder="请输入密码"
              show-password
              class="custom-input-compact"
            >
              <template #prefix>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                </svg>
              </template>
            </el-input>
          </el-form-item>
          
          <el-button 
            type="primary" 
            class="w-full h-10 rounded bg-[#0031ff] hover:bg-[#0028d8] active:bg-[#0020b0] border-none text-white font-medium text-sm transition-colors duration-300 shadow-md shadow-[#0031ff]/20"
            :loading="loading"
            @click="submit"
          >
            <span v-if="!loading">登录系统</span>
            <span v-else>登录中...</span>
          </el-button>
        </el-form>
        
        <!-- 底部链接 -->
        <div class="mt-5 text-center text-xs text-gray-500">
          <a href="#" class="text-[#0031ff] hover:text-blue-600 transition-colors">忘记密码?</a>
          <span class="mx-2">·</span>
        </div>
      </div>
    </div>
  </div>
  
  <!-- 验证码弹窗：点击登录后显示，用户完成滑动验证后触发登录 -->
  <el-dialog
    v-model="dialogVisible"
    title="请完成安全验证"
    width="400px"
    :show-close="true"
    :close-on-click-modal="true"
    align-center
    :before-close="handleDialogClose"
  >
    <div class="p-4">
      <div class="text-sm text-gray-600 mb-4 text-center">
        请按住滑块，拖动到右边完成验证
      </div>
      <SlideVerify
        :key="sliderKey"
        class="w-full custom-slide-verify"
        style="width: 100%"
        :slider-text="'向右滑动验证'"
        :accuracy="1"
        :imgs="captchaImgs"
        @success="onSlideSuccess"
        @fail="onSlideFail"
        @again="onSlideAgain"
      />
      <div class="flex items-center justify-center mt-4 text-xs text-gray-500">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
        </svg>
        安全验证，防止恶意登录
      </div>
    </div>
  </el-dialog>
</template>

<script setup>
import { reactive, ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { userStore } from '@/store/user'
import { loginApi } from '@/api/auth'
import { ElMessage } from 'element-plus'
import http from '@/api/http'

// 引入滑动验证组件
import SlideVerify from 'vue3-slide-verify'
import 'vue3-slide-verify/dist/style.css'

// 本地验证码背景图片
import img1 from '@/assets/captcha/img1.jpg'
import img2 from '@/assets/captcha/img2.jpg'
import img3 from '@/assets/captcha/img3.jpg'
import img4 from '@/assets/captcha/img4.jpg'
import img5 from '@/assets/captcha/img5.jpg'
import img6 from '@/assets/captcha/img6.jpg'

const captchaImgs = [img1, img2, img3, img4, img5, img6]

// 每次修改 key 会强制重新渲染 SlideVerify 组件，用于关闭弹窗后重置滑块状态
const sliderKey = ref(0)

const router = useRouter()
// 登录表单数据
const form = reactive({
  username: '',
  password: ''
})

// 验证码开关（从系统配置读取）
const enableCaptcha = ref(true)

// 弹窗显示控制
const dialogVisible = ref(false)
const loading = ref(false)

// 页面加载时获取公开配置
onMounted(async () => {
  try {
    const response = await http.get('/api/admin/system/config/public')
    // http.js 的响应拦截器返回的是 res，需要取 res.data
    const res = response.data || response
    // 读取验证码开关配置，支持多种格式
    const captchaValue = res.enable_captcha
    // 兼容多种数据类型：字符串'1'/'true'、数字1、布尔true
    enableCaptcha.value = (
      captchaValue === '1' || 
      captchaValue === 1 || 
      captchaValue === true || 
      captchaValue === 'true' ||
      String(captchaValue).toLowerCase() === 'true'
    )
  } catch (e) {
    console.error('获取公开配置失败:', e)
    // 失败时默认启用验证码
    enableCaptcha.value = true
  }
})

// 滑动验证回调
const onSlideSuccess = async () => {
  // 滑动验证成功后调用登录接口
  await doLogin()
}
const onSlideFail = () => {
  // 验证失败保持弹窗打开供重新尝试
  ElMessage.error('验证失败，请重试')
}
const onSlideAgain = () => {
  // 重新开始
}

const submit = async () => {
  // 点击登录按钮时先检查表单
  if (!form.username || !form.password) {
    return ElMessage.error('用户名和密码不能为空')
  }
  
  // 如果启用了验证码，展示验证码弹窗
  if (enableCaptcha.value) {
    dialogVisible.value = true
  } else {
    // 如果未启用验证码，直接调用登录接口
    await doLogin()
  }
}

// 登录逻辑（抽取为公共函数）
const doLogin = async () => {
  loading.value = true
  try {
    const { username, password } = form
    const payload = { username, password }
    const data = await loginApi(payload)
    userStore.setAuth(data)
    dialogVisible.value = false
    router.replace('/dashboard')
  } catch (e) {
    const msg = (e?.response?.data && e.response.data.detail) || '登录失败'
    ElMessage.error(msg)
    if (enableCaptcha.value) {
      handleDialogClose()
    }
  } finally {
    loading.value = false
  }
}

// 弹窗关闭处理：重置加载状态和关闭弹窗
const handleDialogClose = () => {
  loading.value = false
  dialogVisible.value = false
  // 修改 key 以重新渲染 SlideVerify，恢复滑块初始位置
  sliderKey.value++
}
</script>

<style>
.custom-input-compact .el-input__wrapper {
  @apply bg-gray-50 border border-gray-200 rounded h-10 px-3 shadow-none hover:border-gray-300 focus:border-[#0031ff] text-gray-800 text-sm;
}
.custom-input-compact .el-input__inner {
  @apply text-gray-800 placeholder-gray-400 text-sm;
}

/* 滑动验证组件美化 */
.custom-slide-verify {
  --slide-bg: #f5f7fa;
  --slide-border: #e4e7ed;
  --slide-success-bg: #f0f9ff;
  --slide-success-border: #bae6fd;
  --slider-bg: #0031ff;
  --slider-hover-bg: #0028d8;
  --slider-active-bg: #0020b0;
  --slider-text: #606266;
  --slider-icon: #ffffff;
  --slider-shadow: 0 2px 4px rgba(0, 49, 255, 0.2);
}

.custom-slide-verify .slide-verify {
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  width: 100% !important;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.custom-slide-verify .slide-verify-slider {
  height: 40px;
  background: var(--slide-bg);
  border: 1px solid #0031ff !important;
  border-radius: 8px;
  margin-top: 12px;
  position: relative;
  transition: all 0.3s ease;
  width: 310px !important;
  display: flex;
  align-items: center;
  justify-content: flex-start;
}

.custom-slide-verify .slide-verify-slider:hover {
  border-color: #c0c4cc;
}

.custom-slide-verify .slide-verify-slider-mask {
  height: 38px;
  border-radius: 6px;
  background: var(--slide-success-bg);
  border: 1px solid var(--slide-success-border);
  width: 100% !important;
}

.custom-slide-verify .slide-verify-slider-mask-item {
  top: -2px;
  background: var(--slider-active-bg);
  border-radius: 4px;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 500;
}

.custom-slide-verify .slide-verify-slider-text {
  color: var(--slider-text);
  font-size: 14px;
  user-select: none;
}

.custom-slide-verify .slide-verify-slider-button {
  width: 42px;
  height: 38px !important;
  background: var(--slider-bg);
  border-radius: 6px;
  box-shadow: var(--slider-shadow);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: grab;
  transition: all 0.2s ease;
  border: 1px solid var(--slider-bg);
  position: absolute;
  top: 0 !important;
  left: 0 !important;
  transform: translateY(0) !important;
  display: flex;
  align-items: center;
  justify-content: center;
}

.custom-slide-verify .slide-verify-slider-button:hover {
  background: var(--slider-hover-bg);
  box-shadow: 0 3px 6px rgba(0, 49, 255, 0.3);
  border-color: var(--slider-hover-bg);
}

.custom-slide-verify .slide-verify-slider-button:active {
  cursor: grabbing;
  box-shadow: 0 1px 2px rgba(0, 49, 255, 0.2);
  background: var(--slider-active-bg);
  border-color: var(--slider-active-bg);
}

.custom-slide-verify .slide-verify-slider-button .slide-verify-slider-icon {
  color: white !important;
  font-size: 16px;
  transition: color 0.2s ease;
}

/* 成功状态样式 */
.custom-slide-verify .slide-verify.success .slide-verify-slider {
  background: var(--slide-success-bg);
  border-color: var(--slide-success-border);
}

.custom-slide-verify .slide-verify.success .slide-verify-slider-button {
  background: var(--slider-active-bg);
  border-color: var(--slider-active-bg);
}

.custom-slide-verify .slide-verify.success .slide-verify-slider-button .slide-verify-slider-icon {
  color: white !important;
}

/* 确保图片容器和滑动条宽度一致 */
.custom-slide-verify .slide-verify-content {
  width: 100% !important;
}

.custom-slide-verify .slide-verify-img-panel {
  width: 100% !important;
}

/* 弹窗样式微调 */
.el-dialog__header {
  padding: 20px 20px 10px;
  margin: 0;
}

.el-dialog__title {
  font-weight: 600;
  color: #303133;
}

.el-dialog__body {
  padding: 10px 20px 20px;
}

/* 修复滑动条位置问题 */
.custom-slide-verify .slide-verify-slider .slide-verify-slider-button {
  position: absolute !important;
  top: -5px !important;
  left: 0 !important;
  transform: translateY(0) !important;
}
.slide-verify-slider-mask-item-icon[data-v-617ae856] {
    line-height: 1;
    font-size: 25px;
    color: #ffffff !important;
}
.custom-slide-verify .slide-verify-slider-mask-item

 {
    background: var(--slider-active-bg);
    border-radius: 4px;
    color: white;
    display: flex
;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    font-weight: 500;
}
.slide-verify-slider-mask-item[data-v-617ae856]:hover {
    background: #0031ff;
}
.container.active .slide.verify.slider-mask-item[data-v-617ae656] {
    height: 36px;
    top: -1px;
    border: 1px solid #0031ff !important;
}
.custom-slide-verify .slide-verify-slider-mask {
    height: 38px;
    border-radius: 6px;
    background: var(--slide-success-bg);
    border: 1px solid #0031ff !important;
    width: 100% !important;
}
.container-active .slide-verify-slider-mask-item[data-v-617ae856] {
    height: 38px;
    top: -1px;
    border: 1px solid #0031ff !important;
}
</style>
