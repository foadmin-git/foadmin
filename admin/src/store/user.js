// src/store/user.js
import { reactive } from 'vue'
import { refreshApi } from '@/api/auth'
const KEY = 'foadmin_auth_v1'
const load = () => { try { return JSON.parse(localStorage.getItem(KEY)||'{}') } catch { return {} } }
const save = (v) => localStorage.setItem(KEY, JSON.stringify(v||{}))

export const userStore = reactive({
  token: load().token || '',
  user: load().user || null,
  roles: load().roles || [],
  perms: load().perms || [],
  // 用于保存刷新定时器句柄
  _refreshTimer: null,
  /**
   * 设置认证信息并启动自动刷新。
   * @param {Object} p 登录/刷新接口返回的对象
   */
  setAuth(p){
    this.token = p.token;
    this.user  = p.user;
    this.roles = p.roles || [];
    this.perms = p.perms || [];
    save(p);
    this._setupRefresh();
  },
  /**
   * 清除认证信息并取消自动刷新。
   */
  clear(){
    this.token = '';
    this.user  = null;
    this.roles = [];
    this.perms = [];
    save({});
    if (this._refreshTimer) {
      clearTimeout(this._refreshTimer);
      this._refreshTimer = null;
    }
  },
  /**
   * 解析当前 token 并在过期前 5 分钟自动调用刷新接口。
   */
  _setupRefresh(){
    // 清除旧定时器
    if (this._refreshTimer) {
      clearTimeout(this._refreshTimer);
      this._refreshTimer = null;
    }
    const token = this.token;
    if (!token) return;
    try {
      const payload = JSON.parse(atob(token.split('.')[1]));
      const expMs = payload.exp * 1000;
      const nowMs = Date.now();
      // 预留 5 分钟（300000ms）刷新时间
      const delay = expMs - nowMs - 5 * 60 * 1000;
      if (delay <= 0) return;
      this._refreshTimer = setTimeout(async () => {
        try {
          const data = await refreshApi();
          // 重新设置认证，触发新的定时器
          this.setAuth(data);
        } catch (e) {
          console.error('自动刷新 token 失败', e);
          // 刷新失败则清除状态
          this.clear();
        }
      }, delay);
    } catch (e) {
      console.error('解析 token 失败', e);
    }
  }
})
