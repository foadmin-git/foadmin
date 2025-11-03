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

          <!-- 滑动验证码使用弹窗方式触发，点击登录后弹出弹窗进行验证 -->

          
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
    title="请完成滑动验证"
    width="360px"
    :show-close="true"
    :close-on-click-modal="true"
    align-center
    :before-close="handleDialogClose"
  >
    <div class="p-2" style="margin-top: -15px;">
      <SlideVerify
        :key="sliderKey"
        class="w-full"
        style="width: 100%"
        :slider-text="'向右滑动验证'"
        :accuracy="1"
        :imgs="captchaImgs"
        @success="onSlideSuccess"
        @fail="onSlideFail"
        @again="onSlideAgain"
      />
    </div>
  </el-dialog>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { userStore } from '@/store/user'
import { loginApi } from '@/api/auth'
import { ElMessage } from 'element-plus'

// 引入滑动验证组件
import SlideVerify from 'vue3-slide-verify'
import 'vue3-slide-verify/dist/style.css'

// 本地验证码背景图片。引入图片可以避免从网络下载导致图片加载失败。
// 这里随机使用两张噪声图作为背景，可以根据需要替换为任意本地图片。
import img1 from '@/assets/captcha/img1.jpg'
import img2 from '@/assets/captcha/img2.jpg'
import img3 from '@/assets/captcha/img3.jpg'

const captchaImgs = [img1, img2, img3]

// 每次修改 key 会强制重新渲染 SlideVerify 组件，用于关闭弹窗后重置滑块状态
const sliderKey = ref(0)

const router = useRouter()
// 登录表单数据
const form = reactive({
  username: '',
  password: ''
})

// 弹窗显示控制
const dialogVisible = ref(false)
const loading = ref(false)

// 滑动验证回调
const onSlideSuccess = async () => {
  // 滑动验证成功后调用登录接口
  loading.value = true
  try {
    const { username, password } = form
    const payload = { username, password }
    const data = await loginApi(payload)
    userStore.setAuth(data)
    dialogVisible.value = false
    router.replace('/dashboard')
  } catch (e) {
    // 登录失败时关闭弹窗并提示错误
    const msg = (e?.response?.data && e.response.data.detail) || '登录失败'
    ElMessage.error(msg)
    handleDialogClose()
    return
  } finally {
    loading.value = false
  }
}
const onSlideFail = () => {
  // 验证失败保持弹窗打开供重新尝试
  ElMessage.error('验证失败，请重试')
}
const onSlideAgain = () => {
  // 重新开始
}

const submit = async () => {
  // 点击登录按钮时先检查表单，再展示验证码弹窗
  if (!form.username || !form.password) {
    return ElMessage.error('用户名和密码不能为空')
  }
  dialogVisible.value = true
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


</style>