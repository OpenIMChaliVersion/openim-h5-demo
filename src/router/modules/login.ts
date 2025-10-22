import { RouteLocationNormalized, RouteRecordRaw } from 'vue-router'
import router from '..'

const checkBaseData = ({ query }: RouteLocationNormalized) => {
  let baseData
  try {
    baseData = JSON.parse(query.baseData as string)
  } catch (error) {
    router.replace('login')
  }
  return {
    baseData,
  }
}

const loginRouters: Array<RouteRecordRaw> = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@pages/login/index/index.vue'),
  }
]

export default loginRouters
