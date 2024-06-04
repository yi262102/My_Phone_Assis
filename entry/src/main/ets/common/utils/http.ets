import { promptAction, router } from '@kit.ArkUI';
import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios';
import { BASE_URL, LOGIN_INFO, LoginInfoResponse } from '../constants';

// 创建实例
export const axiosInstance = axios.create({
  baseURL: BASE_URL, // 请求基地址
  timeout: 1000 * 20 // 请求超时时间
})

/**
 * 后端响应基本类型«result»
 */
export interface ServiceResponse<T> {
  /** 请求码，200为成功，300及300以上为请求失败 */
  code: number;
  msg: string;
  resTime: Date;
  result: T;
  tips: string;
}

// type 类型别名,保存类型（类似变量声明的关键词 const let）
// 三层对象嵌套：Axios 响应类型 > 后端响应基本类型 > 不同接口响应的类型
export type AxiosResponseData<Result = null> = AxiosResponse<ServiceResponse<Result>, null>

// --- 从官方文档中复制过来拦截器的基本结构，把 axios 修改成 axiosInstance ---
// 拦截器分为两部分：请求拦截器、响应拦截器

// 添加请求拦截器
axiosInstance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  // PersistentStorage 其实就是特殊的 AppStorage 而已，会自动持久化
  const loginInfo = AppStorage.get<LoginInfoResponse>(LOGIN_INFO)
  // 如果有 accessToken 信息，自动添加到 headers 中
  if (loginInfo?.accessToken) {
    config.headers.Authorization = loginInfo.accessToken
  }
  // 对请求数据做点什么
  return config;
}, (error: AxiosError) => {
  // 对请求错误做些什么
  return Promise.reject(error);
});

// 添加响应拦截器
axiosInstance.interceptors.response.use((response: AxiosResponseData) => {
  // 对响应数据做点什么，then 响应成功时
  //  response.data.code 是服务器的业务状态码
  if (response.data.code !== 200) {
    // 把后端响应的错误信息，通过轻提示，提醒用户
    promptAction.showToast({ message: response.data.msg })
    // 主动返回错误，避免 await 后续代码执行
    return Promise.reject(response.data.msg)
  }
  return response;
}, (error: AxiosError) => {
  // 对响应错误做点什么，catch 响应失败时
  if (error.message.includes('401')) {
    // 401 Unauthorized 身份验证出问题了 token
    promptAction.showToast({ message: '登录信息无效，请重新登录' })
    // 登录信息失效，跳转到登录页，重新登录
    router.pushUrl({ url: 'pages/User/UserLoginPage' })
  } else if (error.message.includes('404')) {
    // 404 Not Found 服务器找不到请求的资源
    promptAction.showToast({ message: '无法识别的 URL，请检查' })
  } else {
    promptAction.showToast({ message: '未知网络请求错误' })
  }
  // 未知错误
  return Promise.reject(error);
});