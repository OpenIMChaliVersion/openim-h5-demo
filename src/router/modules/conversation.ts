import { IMSDK } from '@/utils/imCommon'
import { LoginStatus } from '@openim/client-sdk'
import { da } from 'date-fns/locale'
import { RouteRecordRaw } from 'vue-router'
import router from '..'

const conversationRouters: Array<RouteRecordRaw> = [
  {
    path: '/chatroom',
    name: 'ChatRoom',
    component: () => import('@pages/conversation/chatroom/index.vue'),
    beforeEnter: async (to, from, next) => {
      const isInitialLoadOrRefresh = from.name === undefined;

      if (isInitialLoadOrRefresh) {
        // 【可选增强】在重定向前检查登录状态，只有未登录才跳。
        // 如果您的业务逻辑是：无论登录与否，刷新访问 /chatroom 都跳到 /login，则可以跳过此检查。
        
        // 🚨 关键修正：使用 next() 进行重定向
        console.log('检测到系统刷新或首次加载，重定向到 /login。');
        
        next({ 
          path: '/login',
          // 加上 query 参数，便于登录后跳回 /chatroom
          query: { redirect: to.fullPath } 
        });
        return;        
      }else{
        next()
      }
    },

  },
  {
    path: '/singleSetting',
    name: 'SingleSetting',
    component: () => import('@pages/conversation/singleSetting/index.vue'),
  },
  {
    path: '/groupSetting',
    name: 'GroupSetting',
    component: () => import('@pages/conversation/groupSetting/index.vue'),
  },
  {
    path: '/groupManage',
    name: 'GroupManage',
    component: () => import('@pages/conversation/groupManage/index.vue'),
  },
  {
    path: '/changeName',
    name: 'ChangeName',
    props: ({ query }) => ({
      originData: JSON.parse(query.originData as string),
    }),
    component: () => import('@pages/conversation/changeName/index.vue'),
  },
]
function checkUserPermission(roomId: string) {
  // 在实际应用中，这里会发起 API 请求检查用户是否能进入该聊天室
  return true // 示例：暂时返回 true 允许进入
}
export default conversationRouters
