// src/api/profile.js
import http from '@/api/http'

export function getProfile() {
  return http.get('/api/common/profile')
}

export function updateProfile(payload) {
  return http.put('/api/common/profile', payload)
}