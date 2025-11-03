// docxImporter.js
import mammoth from 'mammoth'

export async function importDocxToHtml(file) {
  const arrayBuffer = await file.arrayBuffer()
  const result = await mammoth.convertToHtml({ arrayBuffer }, {
    styleMap: [
      "u => u",          // 下划线
      "strike => s",     // 删除线
    ],
    includeDefaultStyleMap: true,
  })
  return result.value || ''
}
