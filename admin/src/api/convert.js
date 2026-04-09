// src/api/convert.js
import http from './http'

export const convert = {
  docx: (file, { inline = 1 } = {}) => {
    const fd = new FormData()
    fd.append('file', file)
    fd.append('inline', String(inline))
    return http.post('/api/convert/docx', fd).then(r => r.data)
  },
  pdf: (file, { inline = 1, dpi = 144 } = {}) => {
    const fd = new FormData()
    fd.append('file', file)
    fd.append('inline', String(inline))
    fd.append('dpi', String(dpi))
    return http.post('/api/convert/pdf', fd).then(r => r.data)
  },
  pptx: (file, { inline = 1, dpi = 144 } = {}) => {
    const fd = new FormData()
    fd.append('file', file)
    fd.append('inline', String(inline))
    fd.append('dpi', String(dpi))
    return http.post('/api/convert/pptx', fd).then(r => r.data)
  },
  excel: (file, { mode = 'image', inline = 1, dpi = 144 } = {}) => {
    const fd = new FormData()
    fd.append('file', file)
    fd.append('mode', mode)    // 'image' | 'html'
    fd.append('inline', String(inline))
    fd.append('dpi', String(dpi)) // image 模式有效
    return http.post('/api/convert/excel', fd).then(r => r.data)
  },
  
}

