// pdfImporter.js
import * as pdfjsLib from 'pdfjs-dist'
import workerUrl from 'pdfjs-dist/build/pdf.worker.min.mjs?url'

// 必需：指定 worker
pdfjsLib.GlobalWorkerOptions.workerSrc = workerUrl

export async function importPdfToImages(file, { maxPages = 5, width = 1000 } = {}) {
  const data = new Uint8Array(await file.arrayBuffer())
  const pdf = await pdfjsLib.getDocument({ data }).promise
  const pages = Math.min(pdf.numPages, maxPages)
  const imgs = []
  for (let i = 1; i <= pages; i++) {
    const page = await pdf.getPage(i)
    const viewport = page.getViewport({ scale: 1 })
    const scale = width / viewport.width
    const scaledViewport = page.getViewport({ scale })
    const canvas = document.createElement('canvas')
    const ctx = canvas.getContext('2d')
    canvas.width = scaledViewport.width
    canvas.height = scaledViewport.height
    await page.render({ canvasContext: ctx, viewport: scaledViewport }).promise
    imgs.push(canvas.toDataURL('image/png'))
  }
  return imgs
}
