<template>
    <WangEditor v-model="content" :height="600" />
  </template>
  
  <script setup>
  import { ref } from 'vue'
  import WangEditor from '@/components/RichEditor/WangEditor.vue'
  const content = ref('<p>欢迎使用Foadmin</p>')
  </script>
  