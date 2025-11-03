<!--src\views\account\profile.vue-->
<template>
  <div class="max-w-1xl mx-auto">
    <el-card>
      <template #header>个人资料</template>

      <!-- 头像区域 -->
      <div class="flex items-center gap-4 mb-6">
        <el-avatar :size="80" :src="avatarPreview" />
        <div class="flex gap-2 items-center">
          <el-button @click="chooseAvatar">媒体库选择</el-button>
          <el-button @click="triggerUpload">上传图片</el-button>
          <el-button v-if="form.avatar_file_id || form.avatar_url" @click="clearAvatar" type="warning" plain>移除头像</el-button>
          <!-- 隐藏的文件上传输入，用于上传本地图片 -->
          <input
            ref="uploadInput"
            type="file"
            accept="image/*"
            class="hidden"
            @change="handleUpload"
          />
        </div>
        <div class="text-gray-500 text-sm">
          建议使用正方形图片（例如 400×400），支持 JPG/PNG。
        </div>
      </div>

      <el-form :model="form" :rules="rules" ref="formRef" label-width="90px" class="space-y-2">
        <el-form-item label="用户名">
          <el-input v-model="form.username" disabled />
        </el-form-item>

        <el-form-item label="昵称" prop="nick_name">
          <el-input v-model="form.nick_name" placeholder="请输入昵称" />
        </el-form-item>

        <el-divider>修改密码（可选）</el-divider>

        <el-form-item label="旧密码" prop="old_password">
          <el-input v-model="form.old_password" type="password" autocomplete="current-password" />
        </el-form-item>

        <el-form-item label="新密码" prop="new_password">
          <el-input v-model="form.new_password" type="password" autocomplete="new-password" />
        </el-form-item>

        <div class="pt-2">
          <el-button type="primary" :loading="loading" @click="submit">保存</el-button>
          <el-button @click="load">重置</el-button>
        </div>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed, getCurrentInstance } from 'vue'
import { ElMessage } from 'element-plus'
import { getProfile, updateProfile } from '@/api/profile'
import { userStore } from '@/store/user'
import { mediaFiles, uploadMedia } from '@/api/media'

// 表单
const formRef = ref()
const loading = ref(false)
// 上传输入框引用
const uploadInput = ref(null)
const form = reactive({
  username: '',
  nick_name: '',
  // 头像字段：优先使用 SHA256，其次 file_id（媒体库），最后直链 url
  avatar_sha256: null,
  avatar_file_id: null,
  avatar_url: '',
  old_password: '',
  new_password: ''
})

const rules = {
  nick_name: [{ required: true, message: '请输入昵称', trigger: 'blur' }],
  new_password: [{
    validator: (_, v, cb) => {
      if (form.old_password && !v) return cb(new Error('请输入新密码'))
      cb()
    },
    trigger: 'blur'
  }]
}

// 头像预览地址：优先使用 SHA256，其次使用 file_id（兼容旧数据）
const avatarPreview = computed(() => {
  // 优先使用 SHA256 防止 ID 遍历攻击
  if (form.avatar_sha256) return mediaFiles.previewUrl(form.avatar_sha256)
  // 兼容：如果没有 SHA256 但有 file_id
  if (form.avatar_file_id) return mediaFiles.previewUrl(form.avatar_file_id)
  return form.avatar_url || ''
})

// 读取资料
async function load () {
  const { data } = await getProfile()
  form.username = data.username
  form.nick_name = data.nick_name || ''
  // 兼容后端返回的头像信息：优先 SHA256，其次 file_id，最后 url
  form.avatar_sha256 = data.avatar_sha256 || null
  form.avatar_file_id = data.avatar_file_id || null
  form.avatar_url = data.avatar_url || ''
  form.old_password = ''
  form.new_password = ''
}

// 集成全局媒体库：更换头像
const { appContext } = getCurrentInstance()
const pick = appContext?.config?.globalProperties?.$pickMedia

async function chooseAvatar () {
  try {
    if (!pick) {
      ElMessage.error('媒体库未就绪，请先在 main.js 安装 MediaPicker 插件')
      return
    }
    const files = await pick({ selectMode: 'single' })
    if (!files?.length) return
    const f = files[0]
    // 选择后：记录 SHA256 + file_id，清空自定义 url
    form.avatar_sha256 = f.sha256
    form.avatar_file_id = f.id
    form.avatar_url = '' // 以后用媒体库直链
  } catch (e) {
    // 用户取消
  }
}

function clearAvatar () {
  form.avatar_sha256 = null
  form.avatar_file_id = null
  form.avatar_url = ''
}

// 点击上传按钮：触发隐藏的文件选择框
function triggerUpload () {
  const input = uploadInput.value
  if (input) input.click()
}

// 上传头像
async function handleUpload (e) {
  const files = e.target.files
  if (!files || !files.length) return
  const file = files[0]
  // 简单校验文件类型
  if (!file.type.startsWith('image/')) {
    ElMessage.error('请选择图片文件')
    e.target.value = ''
    return
  }
  try {
    const res = await uploadMedia({ file })
    // 返回 { id: number, sha256: string }
    if (res && res.id) {
      form.avatar_sha256 = res.sha256 || null
      form.avatar_file_id = res.id
      form.avatar_url = ''
      ElMessage.success('上传成功')
    }
  } catch (err) {
    ElMessage.error('上传失败')
  } finally {
    // 清空输入框，以便重新选择同一文件也能触发 change 事件
    e.target.value = ''
  }
}

// 提交
async function submit () {
  const valid = await formRef.value.validate().then(() => true).catch(() => false)
  if (!valid) return

  loading.value = true
  await updateProfile({
    nick_name: form.nick_name || '',
    // 将头像字段一并提交；后端可根据是否有 avatar_file_id 来保存
    avatar_file_id: form.avatar_file_id || undefined,
    avatar_url: form.avatar_url || undefined,
    old_password: form.old_password || undefined,
    new_password: form.new_password || undefined
  })
  // 同步本地用户信息（昵称 & 头像）
  userStore.setAuth({
    token: userStore.token,
    user: {
      ...userStore.user,
      nick_name: form.nick_name,
      avatar_sha256: form.avatar_sha256 ?? null,
      avatar_file_id: form.avatar_file_id ?? null,
      avatar_url: form.avatar_url ?? ''
    },
    roles: userStore.roles,
    perms: userStore.perms
  })
  ElMessage.success('已保存')
  form.old_password = ''
  form.new_password = ''
  loading.value = false
}

onMounted(load)
</script>

<style>
.el-divider__text {
  background-color: #f3f3f3;
  color: #898e97;
  font-size: 14px;
  font-weight: 500;
  padding: 0 20px;
  position: absolute;
}
</style>
