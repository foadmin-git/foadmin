<!-- src/components/RichEditor/WangEditor.vue -->
<template>
    <div class="we-wrapper" ref="editorWrapper">
      <Toolbar :editor="editor" :defaultConfig="toolbarConfig" :mode="mode" />
      <Editor
        v-model="innerHtml"
        :defaultConfig="editorConfig"
        :mode="mode"
        class="we-editor"
        :style="{ height }"
        @onCreated="handleCreated"
        @onChange="handleChange"
      />
    </div>
</template>

<script setup lang="ts">
/**
 * 变化点：
 * a) 新增：导入 PPTX 功能（纯前端解析），菜单 key 为 `importPpt`
 * b) 仍保持：导入 HTML / DOCX / PDF / 媒体库插入
 * c) TypeScript 严格无 any：为动态导入 jszip 做了最小必要类型
 */

import { ref, shallowRef, onBeforeUnmount, getCurrentInstance, watch } from 'vue'
import { Editor, Toolbar } from '@wangeditor/editor-for-vue'
import { Boot } from '@wangeditor/editor'
import '@wangeditor/editor/dist/css/style.css'
import { ElMessage, ElLoading  } from 'element-plus'
import type { IDomEditor, IButtonMenu } from '@wangeditor/core'
import { mediaFiles} from '@/api/media'
import { convert } from '@/api/convert'

/** ---- 第三方动态导入的最小必要类型 ---- */
type MammothModule = {
  convertToHtml: (
    input: { arrayBuffer: ArrayBuffer } | { arrayBuffer: ArrayBufferLike },
    options?: { styleMap?: string[] }
  ) => Promise<{ value: string }>
}

type PdfWorkerUrlModule = { default: string }
type PdfjsModule = {
  getDocument: (src: { data: ArrayBuffer }) => { promise: Promise<any> }
  GlobalWorkerOptions: { workerSrc: string }
}

/** PPT: jszip 的极简类型（只做我们用到的能力） */
type JSZipLike = {
  loadAsync(data: ArrayBuffer): Promise<JSZipLike>
  file(path: string): { async(type: 'string' | 'arraybuffer' | 'base64'): Promise<any> } | null
  folder(path: string): { name: string } | null
  filter(predicate: (relativePath: string, file: any) => boolean): Array<any>
}

const model = defineModel<string>({ default: '' })

const props = defineProps<{
  height?: string
  placeholder?: string
  mode?: 'default' | 'simple'
}>()

const height = props.height ?? '420px'
const placeholder = props.placeholder ?? '开始输入...'
const mode = props.mode ?? 'default'

const editor = shallowRef<IDomEditor | null>(null)
const innerHtml = ref<string>(model.value)

// 当上层 v-model 值变化时，重置编辑器内容。否则编辑器会继续显示之前的内容
watch(
  () => model.value,
  (val) => {
    // 当父组件传入的新值与当前内容不一致时，更新内部内容
    if (val !== innerHtml.value) {
      innerHtml.value = val || ''
    }
  }
)

const toolbarConfig = {
  excludeKeys: ['uploadImage', 'uploadVideo'],
  insertKeys: {
    index: 0,
    // ✅ 新增了 importPpt
    keys: ['importHtml', 'importWord', 'importPdf', 'importPpt', 'chooseMedia'] as const
  }
}
const editorConfig = {
  placeholder,
  MENU_CONF: {} as Record<string, unknown>
}

/** 绑定全局媒体库弹窗 */
const { appContext } = getCurrentInstance()!
const pickMedia = (appContext?.config?.globalProperties as any)?.$pickMedia as
  | ((opts: { selectMode?: 'single' | 'multiple' }) => Promise<Array<{ id: string | number; filename: string; mime?: string }>>)
  | undefined

function handleCreated(ed: IDomEditor) {
  editor.value = ed
}
function handleChange() {
  const html = editor.value?.getHtml() || ''
  innerHtml.value = html
  model.value = html
}

/** 安全插入（到光标处） */
function insertHtml(html: string) {
  if (!editor.value) {
    ElMessage.error('编辑器未就绪')
    return
  }
  if (!html) return
  editor.value.dangerouslyInsertHtml(html)
}

/** 导入 HTML */
async function importHtmlFile(file?: File) {
  try {
    if (!file) return
    const html = await file.text()
    insertHtml(html)
    ElMessage.success('已插入 HTML')
  } catch (e: unknown) {
    ElMessage.error('导入 HTML 失败：' + (e instanceof Error ? e.message : String(e)))
  }
}

/** 导入 DOCX -> HTML（使用 mammoth） */
async function importDocxFile(file?: File) {
  if (!file) return
  const loading = editorWrapper.value
    ? ElLoading.service({ target: editorWrapper.value, text: '正在解析 Word...' })
    : null
  try {
    const { html } = await convert.docx(file, { inline: 1 })
    insertHtml(html || '<p>(空文档)</p>')
    ElMessage.success('Word 导入完成')
  } catch (e: any) {
    ElMessage.error('导入 Word 失败：' + (e?.message || String(e)))
  } finally {
    loading?.close()
  }
}
/** 导入 PDF -> 每页转图片插入（使用 pdfjs-dist） */
async function importPdfFile(file?: File) {
  if (!file) return
  const loading = editorWrapper.value
    ? ElLoading.service({ target: editorWrapper.value, text: '正在渲染 PDF...' })
    : null
  try {
    // 大文档建议 inline:0（走预览URL），体积更小
    const { html } = await convert.pdf(file, { inline: 0, dpi: 144 })
    insertHtml(html || '<p>(空PDF)</p>')
    ElMessage.success('PDF 导入完成')
  } catch (e: any) {
    ElMessage.error('导入 PDF 失败：' + (e?.message || String(e)))
  } finally {
    loading?.close()
  }
}

/** 从媒体库插入（图片/视频/其他） */
async function chooseFromMedia() {
  if (!pickMedia) {
    ElMessage.error('媒体库未安装：请在 main.js 中 app.use(mediaPicker)')
    return
  }
  try {
    const list = await pickMedia({ selectMode: 'multiple' }).catch(() => [])
    if (!list?.length) return
    const html = list.map(it => {
      // 使用 SHA256 防止 ID 遍历攻击
      const url = mediaFiles.previewUrl(it.sha256)
      if (it.mime?.startsWith('image/')) {
        return `<p><img src="${url}" alt="${escapeHtml(it.filename)}" style="max-width:100%"/></p>`
      } else if (it.mime?.startsWith('video/')) {
        return `<p><video src="${url}" controls style="max-width:100%"></video></p>`
      } else {
        return `<p><a href="${url}" target="_blank" rel="noopener">${escapeHtml(it.filename)}</a></p>`
      }
    }).join('')
    insertHtml(html)
  } catch {
    // 用户取消
  }
}

/** 小工具：转义文件名到 HTML 文本 */
function escapeHtml(s = ''): string {
  return s.replace(/[&<>"']/g, (m) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[m] as string))
}

/** 文件选择器（代替 <el-upload> 的触发） */
function createFileInput(accept: string, onFile: (file?: File) => void): void {
  const input = document.createElement('input')
  input.type = 'file'
  input.accept = accept
  input.onchange = (e: Event) => {
    const target = e.target as HTMLInputElement
    const file = target.files?.[0]
    onFile(file)
    input.value = '' // 允许重复选择同一文件
  }
  input.click()
}

/** ======================= PPTX 解析（新增） ======================= */
/**
 * 轻量策略：
 * - 仅解析文本与图片（不还原复杂排版/动画）
 * - 每页生成一个 <section>，包含：页标题 + 文本块 + 图片
 * - 全前端，无服务端依赖
 */
 const editorWrapper = ref<HTMLElement>()
 async function importPptxFile(file?: File) {
  if (!file) return
  // 开启全局加载中
  const loading = ElLoading.service({
    target: editorWrapper.value,
    text: '正在解析 PPT，请稍候...',
   // background: 'rgba(0, 0, 0, 0.4)',
  })
  try {
    const { html } = await convert.pptx(file, { inline: 0, dpi: 144 })
    insertHtml(html || '<p>(空PPT)</p>')
    ElMessage.success('PPT 导入完成')
  } catch (e: any) {
    ElMessage.error('导入 PPT 失败：' + (e?.message || String(e)))
  } finally {
    loading.close()
  }
}


/** ==== 自定义菜单：实现为按钮类（显式实现 IButtonMenu） ==== */
class ImportHtmlMenu implements IButtonMenu {
  readonly title = '导入HTML'
  readonly tag: 'button' = 'button'
  readonly iconSvg = `
    <svg t="1755113655941" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="13768" width="20" height="20"><path d="M896 704a32 32 0 0 1 31.776 28.256L928 736v192a64 64 0 0 1-64 64H160a64 64 0 0 1-64-64v-192a32 32 0 0 1 63.776-3.744L160 736v192h704v-192a32 32 0 0 1 32-32zM132.8 398.72l3.2 3.2-0.032 87.36h72l0.032-87.36 3.2-3.2h56.64l3.2 3.2V640l-3.2 3.2H211.2l-3.2-3.2-0.032-94.72h-72L136 640l-3.2 3.2H75.52l-3.2-3.2v-238.08l3.2-3.2h57.28z m358.4 0l3.2 3.2v47.36l-3.2 3.2h-61.472L429.76 640l-3.2 3.2h-57.28l-3.2-3.2-0.032-187.52H304.96l-3.2-3.2v-47.36l3.2-3.2h186.24z m98.56 0l3.008 2.08 37.76 102.784 3.104 9.344 3.52 11.712 4.352 15.2 8.416-28.576 2.432-7.68 36.48-102.72 3.008-2.144h62.08l3.2 3.2V640l-3.2 3.2h-52.16l-3.2-3.2v-81.6c0-5.376 0.224-11.52 0.64-18.368l1.152-14.688 1.472-14.816 1.216-11.264-12.032 34.656-32 87.04-3.008 2.08h-31.36l-3.008-2.08-32.32-87.136-11.296-33.472 1.824 16.928 0.768 8.064 1.12 14.72c0.32 4.544 0.512 8.8 0.608 12.704l0.064 5.632V640l-3.2 3.2h-51.2l-3.2-3.2v-238.08l3.2-3.2h61.76z m276.16 0l3.2 3.2-0.032 186.88h89.312l3.2 3.2V640l-3.2 3.2h-149.76l-3.2-3.2v-238.08l3.2-3.2h57.28zM736 32l192 192v64h-256V96H160v192a32 32 0 0 1-63.776 3.744L96 288V96a64 64 0 0 1 64-64h576z m0 90.528V224l101.44-0.032L736 122.528z" fill="#000000" p-id="13769"></path></svg>`
  getValue(): string { return '' }
  isActive(): boolean { return false }
  isDisabled(): boolean { return false }
  exec(): void {
    createFileInput('.html,.htm,text/html', importHtmlFile)
  }
}

class ImportWordMenu implements IButtonMenu {
  readonly title = '导入Word'
  readonly tag: 'button' = 'button'
  readonly iconSvg = `
   <svg t="1755113478046" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="10076" width="200" height="200"><path d="M393.821091 180.782545a10.705455 10.705455 0 0 0-14.987636 0l-126.138182 130.746182c-5.259636 5.445818-0.837818 13.777455 7.493818 13.777455h81.547636v118.970182c0 4.096 3.351273 7.540364 7.447273 7.540363h75.403636a7.586909 7.586909 0 0 0 7.493819-7.540363V325.306182h80.47709c8.192 0 12.753455-8.331636 7.493819-13.777455L393.821091 180.782545zM259.490909 146.059636h253.626182c4.933818 0 9.029818-3.397818 9.029818-7.493818v-19.037091c0-4.096-4.096-7.493818-9.029818-7.493818H259.351273c-4.933818 0-9.029818 3.397818-9.029818 7.493818v19.037091c0.139636 4.282182 4.235636 7.493818 9.169454 7.493818zM805.655273 661.783273h-20.386909v114.734545h20.433454c17.826909 0 31.837091-5.352727 41.984-15.918545 10.100364-10.658909 15.173818-24.994909 15.173818-43.101091 0-17.547636-5.259636-31.185455-15.918545-41.006546-10.472727-9.821091-24.296727-14.708364-41.285818-14.708363zM470.621091 660.666182c-14.661818 0-26.205091 5.445818-34.676364 16.384s-12.660364 24.994909-12.660363 42.356363c0 17.175273 4.142545 31.185455 12.381091 41.984 8.285091 10.891636 19.595636 16.290909 33.978181 16.29091 14.661818 0 26.158545-5.166545 34.304-15.546182 8.192-10.472727 12.288-24.436364 12.288-42.077091 0-18.292364-3.956364-32.814545-11.962181-43.473455-7.912727-10.612364-19.130182-15.918545-33.652364-15.918545zM641.908364 659.595636h-19.083637v50.734546h18.432c8.797091 0 15.825455-2.56 21.178182-7.726546a25.181091 25.181091 0 0 0 8.005818-19.083636c0-15.918545-9.448727-23.924364-28.532363-23.924364z" p-id="10077" fill="#60a5fa"></path><path d="M75.729455 496.965818v429.102546h882.548363v-429.102546H75.729455z m249.576727 310.178909h-41.704727l-30.021819-114.827636a93.370182 93.370182 0 0 1-2.839272-19.362909h-0.465455a127.953455 127.953455 0 0 1-3.165091 19.362909l-30.673454 114.827636h-43.287273L126.231273 631.156364h41.146182l26.158545 119.296c1.117091 5.259636 1.908364 11.822545 2.373818 19.828363h0.837818a105.192727 105.192727 0 0 1 3.490909-20.386909l32.721455-118.737454h39.889455l29.78909 120.180363c1.163636 4.840727 2.141091 10.984727 2.839273 18.618182h0.605091c0.186182-6.562909 1.117091-12.986182 2.513455-19.269818l25.6-119.528727h38.027636l-46.917818 175.988363z m206.336-22.574545c-15.965091 17.082182-36.864 25.646545-62.696727 25.646545-25.227636 0-45.707636-8.285091-61.486546-24.808727-15.732364-16.523636-23.645091-37.888-23.645091-64 0-27.554909 8.052364-49.989818 24.203637-67.258182 16.104727-17.361455 37.376-26.018909 63.813818-26.018909 25.134545 0 45.381818 8.378182 60.741818 25.088 15.313455 16.709818 22.993455 38.260364 22.993454 64.558546 0 27.461818-7.959273 49.710545-23.924363 66.792727z m155.741091 22.574545l-27.554909-45.800727c-5.725091-9.448727-10.379636-15.546182-14.010182-18.292364s-7.540364-4.096-11.636364-4.096h-11.357091v68.189091h-37.469091V631.156364h61.719273c41.890909 0 62.836364 15.918545 62.836364 47.709091 0 11.915636-3.537455 22.202182-10.565818 30.72s-16.616727 14.615273-28.904728 18.106181v0.465455c8.098909 2.746182 17.082182 11.729455 26.903273 26.810182l33.186909 52.177454h-43.147636z m188.695272-24.715636c-17.454545 16.523636-40.075636 24.715636-67.723636 24.715636h-60.555636V631.156364h60.834909c62.464 0 93.742545 28.532364 93.742545 85.736727 0 27.229091-8.750545 49.058909-26.298182 65.536z" p-id="10078" fill="#60a5fa"></path><path d="M182.597818 58.181818h407.784727v275.456h257.815273v265.262546h57.157818V277.317818h-0.605091L646.656 0.884364H126.277818v412.625454h56.32zM848.197818 835.211636v131.956364H126.277818v56.133818h779.077818v-188.090182z" p-id="10079" fill="#60a5fa"></path></svg>`
  getValue(): string { return '' }
  isActive(): boolean { return false }
  isDisabled(): boolean { return false }
  exec(): void {
    createFileInput('.docx,application/vnd.openxmlformats-officedocument.wordprocessingml.document', importDocxFile)
  }
}



class ImportPdfMenu implements IButtonMenu {
  readonly title = '导入PDF'
  readonly tag: 'button' = 'button'
  readonly iconSvg = `
    <svg t="1755113429703" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="8073" width="200" height="200"><path d="M903.633455 280.017455L646.283636 4.282182H127.301818v411.554909h56.180364V61.44h406.621091v274.711273h257.163636v631.808H127.301818V1024H904.378182V280.017455h-0.744727z" p-id="8074" fill="#e64a36"></path><path d="M399.778909 177.710545a10.705455 10.705455 0 0 0-14.987636 0L258.699636 308.456727c-5.306182 5.445818-0.884364 13.777455 7.447273 13.777455H347.694545v118.970182c0 4.096 3.397818 7.493818 7.493819 7.493818h75.403636a7.540364 7.540364 0 0 0 7.493818-7.493818V322.234182h80.477091c8.192 0 12.753455-8.331636 7.493818-13.777455L399.778909 177.710545zM265.495273 142.987636h253.626182c4.933818 0 9.029818-3.397818 9.029818-7.493818v-19.037091c0-4.096-4.096-7.493818-9.029818-7.493818H265.309091c-4.933818 0-9.029818 3.397818-9.029818 7.493818v19.037091c0.186182 4.282182 4.282182 7.493818 9.216 7.493818zM291.421091 630.830545h-22.667636v77.777455h22.295272c30.114909 0 45.288727-13.079273 45.288728-39.330909 0-25.553455-14.987636-38.446545-44.916364-38.446546zM562.734545 653.079273c-14.475636-13.451636-33.373091-20.107636-56.692363-20.107637h-27.927273v157.137455h28.066909c24.343273 0 43.613091-7.307636 57.344-21.783273 14.010182-14.522182 20.945455-34.210909 20.945455-59.112727 0.046545-23.924364-7.307636-42.682182-21.736728-56.133818z" p-id="8075" fill="#e64a36"></path><path d="M76.939636 497.524364v427.938909h880.174546v-427.938909H76.939636zM363.054545 726.621091c-18.059636 14.801455-40.680727 21.969455-67.909818 21.457454h-26.391272v84.107637H217.367273v-241.198546h82.897454c59.904 0 90.065455 25.367273 90.065455 76.241455-0.046545 24.669091-9.076364 44.590545-27.275637 59.392z m239.476364 71.633454c-24.017455 22.621091-54.830545 33.931636-92.765091 33.931637H426.868364v-241.198546h83.269818c85.597091 0 128.325818 39.144727 128.325818 117.434182 0 37.282909-11.915636 67.211636-35.933091 89.832727z m213.969455-165.236363h-86.155637v61.998545h79.173818v41.984h-79.173818v95.185455h-51.386182v-241.198546h137.355637v42.030546h0.186182z" p-id="8076" fill="#e64a36"></path></svg>`
  getValue(): string { return '' }
  isActive(): boolean { return false }
  isDisabled(): boolean { return false }
  exec(): void {
    createFileInput('application/pdf,.pdf', importPdfFile)
  }
}

/** ✅ 新增：导入PPT 菜单 */
class ImportPptMenu implements IButtonMenu {
  readonly title = '导入PPT'
  readonly tag: 'button' = 'button'
  readonly iconSvg = `
    <svg t="1755116489917" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="7296" width="200" height="200"><path d="M692.134957 7.390609l0.356173 0.356174 214.817392 224.567652 0.356174 0.356174 6.633739 6.945391v708.296348c0 41.939478-34.148174 76.087652-76.132174 76.087652H142.914783C100.930783 1024 66.782609 989.851826 66.782609 947.867826V76.132174C66.782609 34.148174 100.930783 0 142.914783 0h542.141217l7.123478 7.390609z m-149.103305 330.796521H291.750957V428.29913h50.042434v414.408348h117.136696v-221.273043h84.146087c122.88-5.609739 171.76487-64.200348 172.165565-141.089392 0 0 6.41113-133.87687-172.210087-142.157913z m49.864348 143.983305c-0.178087 28.004174-17.986783 49.285565-62.820174 51.378087h-74.351304V430.436174h74.351304c65.135304 3.027478 62.775652 51.734261 62.775652 51.734261z m267.842783 385.513739c4.986435 4.452174 12.198957 7.212522 20.212869 7.212522 15.003826 0 27.158261-9.794783 27.158261-21.815653a19.589565 19.589565 0 0 0-6.989913-14.647652l-81.563826-72.837565a30.408348 30.408348 0 0 0-20.21287-7.212522 30.319304 30.319304 0 0 0-20.168347 7.212522l-81.563827 72.837565a19.589565 19.589565 0 0 0-6.989913 14.647652c0 12.02087 12.154435 21.815652 27.158261 21.815653a30.408348 30.408348 0 0 0 20.257392-7.212522l34.148173-30.541913v143.36c0 12.02087 12.154435 21.815652 27.158261 21.815652 15.048348 0 27.202783-9.750261 27.202783-21.815652v-143.36l34.192696 30.541913z" fill="#EC6544" p-id="7297"></path></svg>`
  getValue(): string { return '' }
  isActive(): boolean { return false }
  isDisabled(): boolean { return false }
  exec(): void {
    // 仅处理 .pptx（现代 PowerPoint 格式）
    createFileInput('.pptx,application/vnd.openxmlformats-officedocument.presentationml.presentation', importPptxFile)
  }
}

class ChooseMediaMenu implements IButtonMenu {
  readonly title = '媒体库'
  readonly tag: 'button' = 'button'
  readonly iconSvg = `
    <svg t="1755113744785" class="icon" viewBox="0 0 1280 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="16597" width="20" height="20"><path d="M1150.752936 128.250012H639.749988L512 0.498526H128.748538C-13.803041 0.498526 1.636304-8.433029 1.636304 128.250012l-0.637754 766.502924C0.99855 1038.669848-6.513778 1022.502924 128.748538 1022.502924h1022.004398c131.712749 0 127.749988 20.544374 127.749988-127.749988V256c0-132.452304 23.324444-127.749988-127.749988-127.749988zM301.91083 691.649123l217.450293-289.934222 169.127672 217.692818 120.805053-145.208889L978.423018 691.649123h-676.513685z" fill="#000000" p-id="16598"></path></svg>`
  getValue(): string { return '' }
  isActive(): boolean { return false }
  isDisabled(): boolean { return false }
  exec(): void {
    void chooseFromMedia()
  }
}

/** 注册自定义菜单（避免重复注册） */
// 注册自定义菜单。通过挂载在 window 上的标记防止重复注册
{
  const globalKey = '__wangEditorCustomMenusRegistered'
  const win = typeof window !== 'undefined' ? (window as any) : null
  const already = win ? win[globalKey] : false
  if (!already) {
    try {
      Boot.registerMenu({ key: 'importHtml', factory() { return new ImportHtmlMenu() } })
    } catch {}
    try {
      Boot.registerMenu({ key: 'importWord', factory() { return new ImportWordMenu() } })
    } catch {}
    try {
      Boot.registerMenu({ key: 'importPdf', factory() { return new ImportPdfMenu() } })
    } catch {}
    try {
      Boot.registerMenu({ key: 'importPpt', factory() { return new ImportPptMenu() } })
    } catch {}
    try {
      Boot.registerMenu({ key: 'chooseMedia', factory() { return new ChooseMediaMenu() } })
    } catch {}
    if (win) win[globalKey] = true
  }
}

/** 组件销毁时清理 editor */
onBeforeUnmount(() => {
  if (editor.value) {
    editor.value.destroy()
    editor.value = null
  }
})
</script>

<style scoped>
.we-wrapper {
  display: grid;
  gap: 0; /* 工具栏和编辑器紧贴 */
  border: 1px solid #e5e7eb; /* 整个外框 */
  border-radius: 8px; /* 圆角 */
  background-color: #fff; /* 背景白色 */
  overflow: hidden; /* 保证圆角裁切 */
}

/* wangEditor 工具栏背景改成白色（有些主题是灰色） */
:deep(.w-e-toolbar) {
  background-color: #fff;
  border-bottom: 1px solid #e5e7eb;
}

/* 编辑区域不要额外的边框 */
.we-editor {
  border: none;
}

/* wangEditor 内部文本容器自适应内容 */
:deep(.w-e-text-container) {
  border: none !important;
  min-height: 420px; /* 与上面一致 */
  box-sizing: border-box;
}
</style>
