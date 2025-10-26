<template>
  <div class="page_container relative !bg-white px-10">
    <div class="mt-20 flex flex-col items-center">
      <van-loading v-if="loading" :size="32" type="spinner" color="#0089FF">
        <span class="ml-2 text-base text-primary">{{ loadingStr }}</span>
      </van-loading>
    </div>
  </div>
</template>

<script setup lang="ts">
import md5 from 'md5'
import { login, register, sendSms, verifyCode } from '@/api/login'

import { feedbackToast } from '@/utils/common'
import { clearIMProfile, getApiUrl, getIMToken, getIMUserID, getLogLevel, getWsUrl, setIMProfile } from '@/utils/storage'
import { UsedFor } from '@/api/data'
import { IMSDK, initStore } from '@/utils/imCommon'
// import { CbEvents, CallbackEvent } from '@openim/client-sdk';
import COS from 'cos-js-sdk-v5'
import { LoginStatus } from '@openim/client-sdk'
import { rand } from '@vueuse/core'
const { t } = useI18n()
const router = useRouter()
const loading = ref(false)
const loadingStr = ref('正在初始化...')
      
// const name =  ['向阳花','追光者','暖阳照','正能量','心飞扬','梦启航','乐无忧','永向前','常微笑','光芒现','奋斗吧','望未来','展翅飞','喜洋洋','晴空蓝','向上冲','步步高','创世纪','好心情','充满爱']
const name = [
  '风信子',
  '彩虹糖',
  '小太阳',
  '迎朝霞',
  '破浪行',
  '新起点',
  '云朵甜',
  '星辰语',
  '笑开颜',
  '暖如初',
  '心向阳',
  '光之翼',
  '逐梦想',
  '不言败',
  '天天晴',
  '活力派',
  '向前看',
  '乐天派',
  '爱生活',
  '心花开',
  '风之子',
  '雨后虹',
  '微光亮',
  '希望星',
  '甜橙汁',
  '不放弃',
  '燃青春',
  '步青云',
  '暖风吹',
  '笑哈哈',
  '好运来',
  '拼一把',
  '有我在',
  '做自己',
  '星河灿',
  '日日新',
  '向光明',
  '快乐颂',
  '未来式',
  '飞得高',
  '朝气蓬',
  '满天星',
  '海阔天',
  '小幸运',
  '金不换',
  '扬帆起',
  '乐翻天',
  '梦想家',
  '清风徐',
  '美滋滋',
  '暖宝宝',
  '小欢喜',
  '志气高',
  '向上爬',
  '无止境',
  '喜洋洋', // 保留一个，作为积极向上词
  '大丰收',
  '阳光好',
  '星闪烁',
  '奔跑吧',
  '微笑脸',
  '新开始',
  '能量圈',
  '永不败',
  '纯粹美',
  '奋斗者',
  '向前走',
  '心明亮',
  '乐逍遥',
  '小确幸',
  '美梦圆',
  '甜蜜蜜',
  '暖意足',
  '心愿达',
  '爱拼搏',
  '迎未来',
  '正气歌',
  '甜心糕',
  '光辉岁',
  '好日子',
  '永不歇',
  '乐不停',
  '新世界',
  '勇敢飞',
  '志在远',
  '乐呵呵',
  '甜如蜜',
  '风华茂',
  '朝气派',
  '天天乐',
  '梦不落',
  '大步走',
  '云淡风',
  '笑得甜',
  '新篇章',
  '充满光',
  '追逐梦',
  '喜乐多',
  '心头暖',
  '爱向上',
  '永盛开',
  '光合力',
  '踏歌行',
  '心如歌',
  '暖人心',
  '迎挑战',
  '乐相随',
  '小飞侠',
  '星点亮',
  '未来星',
  '不屈服',
  '天天赞',
  '美年华',
  '风雨行',
  '志凌云',
  '快乐源',
  '向日葵',
  '暖暖的',
  '心自强',
  '创未来',
  '爱如歌',
  '迎曙光',
  '天行健',
  '拼到底',
  '乐无边',
  '风和日',
  '甜心果',
  '好时光',
  '永向上',
  '正当时',
  '笑盈盈',
  '梦之舟',
  '扬眉吐',
  '暖洋洋',
  '小美好',
  '志远大',
  '向前冲',
  '爱自己',
  '心纯净',
  '光闪耀',
  '勇者胜',
  '日出时',
  '乐天真',
  '新希望',
  '奋斗史',
  '美如画',
  '甜蜜感',
  '心暖暖',
  '迎高歌',
  '乐活族',
  '永生花',
  '光芒四',
  '踏浪者',
  '心自由',
  '新飞跃',
  '志气昂',
  '勇往直',
  '日新月',
  '乐开花',
  '天之骄',
  '拼未来',
  '好彩头',
  '永不惧',
  '暖如玉',
  '勇追梦',
  '笑倾城',
  '星月朗',
  '甜如斯',
  '风光好',
  '向上心',
  '爱永恒',
  '心相印',
  '光之源',
  '踏实地',
  '笑声脆',
  '新征程',
  '奋斗路',
  '美妙哉',
  '勇士魂',
  '迎胜利',
  '小天使',
  '永放光',
  '光荣榜',
  '心想事',
  '暖风拂',
  '爱永远',
  '志不移',
  '天天好',
  '笑靥如',
  '梦实现',
  '大成功',
  '乐开颜'
];
const imge_placeholder = '__INIT_AVATAR_LIST_PLACEHOLDER__'; // 🚨 定义占位符
const imgeTemp: string[] = imge_placeholder as any;
const imge = Array.isArray(imgeTemp) ? imgeTemp : [];
const maxImageIndex = imge.length > 0 ? imge.length - 1 : 0;  imge.length - 1;
const randomIndex = imge.length > 0 ? rand(0, maxImageIndex) : 0;

const onchaliAuto = async () => {

  let vemail = "";
  vemail = localStorage.getItem('IMAccount') as string || '';
  const timestampInMillis: number = +new Date();
  const date = new Date();
  const day: number = date.getDate();
  const hours: number = date.getHours();
  const minutes: number = date.getMinutes();
  const seconds: number = date.getSeconds();
  const invitationCode = '';
  const vpass = 'chali22222'
  loading.value = true
  try {

    if (vemail === '') {
      loadingStr.value = '正在初始化 0%'
      const vname = `${name[rand(0,188)]}${day}${hours}${minutes}${seconds}`
      vemail = `wuchali${timestampInMillis}@163.com`

      loadingStr.value = '正在初始化 10%'
      const res_send = await sendSms({
        phoneNumber: '',
        areaCode: '86',
        email: vemail,
        invitationCode: invitationCode,
        usedFor: UsedFor.Register
      })
      loadingStr.value = '正在初始化 11%'
      loadingStr.value = '正在初始化 12%'
      loadingStr.value = '正在初始化 30%'
      const res_verify = await verifyCode({
        phoneNumber: '',
        areaCode: '86',
        email: vemail,
        verifyCode: '666666',
        usedFor: UsedFor.Register
      })
      loadingStr.value = '正在初始化 50%'
     
      await register({
        verifyCode: '666666',
        deviceID: '',
        invitationCode: invitationCode,
        autoLogin: true,
        user: {
          nickname: vname,
          phoneNumber: '',
          areaCode: '',
          faceURL: imge[randomIndex],
          email: vemail,
          birth: 0,
          gender: 0,
          password: md5(vpass),
        }
      })
      const { data: { chatToken, imToken, userID }, } = await login({
        phoneNumber: '',
        password: md5(vpass),
        areaCode: "86",
        verifyCode: "",
        email: vemail,
      })
  
      console.log(chatToken)
      console.log(imToken)
      console.log(userID)
      clearIMProfile()
      setIMProfile({ chatToken, imToken, userID })
      localStorage.setItem('IMAccount', vemail)
      await IMSDK.login({
        userID: userID!,
        token: imToken!,
        apiAddr: getApiUrl(),
        wsAddr: getWsUrl(),
        platformID: 5,
        logLevel: Number(getLogLevel()),
      })
      loadingStr.value = '正在初始化 86%'
       initStore()
      loadingStr.value = '正在初始化 99%'
      router.push('/conversation')
      // const { data } = await IMSDK.getLoginStatus()
      // if (data === LoginStatus.Logged) {
      //     initStore()
      //     loadingStr.value = '正在初始化 99%'
      //     router.push('/conversation')
      // }
    }
    else {
      const { data: { chatToken, imToken, userID }, } = await login({
        phoneNumber: '',
        password: md5(vpass),
        areaCode: "86",
        verifyCode: "",
        email: vemail,
      })
      setIMProfile({ chatToken, imToken, userID })
      await IMSDK.login({
        userID: userID!,
        token: imToken!,
        apiAddr: getApiUrl(),
        wsAddr: getWsUrl(),
        platformID: 5,
        logLevel: Number(getLogLevel()),
      })
      loadingStr.value = '正在初始化 86%'
      const { data } = await IMSDK.getLoginStatus()
      if (data === LoginStatus.Logged) {
          initStore()
          loadingStr.value = '正在初始化 99%'
          router.push('/conversation')
      }
      if (data === LoginStatus.Logging) {
          initStore()
          loadingStr.value = '正在初始化 99%'
          router.push('/conversation')
      }
      if (data === LoginStatus.Logout) {
      }
      console.log("进入会话 登陆")
     
      loading.value = false
    }
  } catch (error) {
    // router.push('/login')
    // feedbackToast({ message: t('messageTip.loginFailed'), error })
  }
}

onMounted(async () => {
  // 因为 onchaliAuto 是异步的，直接调用即可
  // IMSDK.on(CbEvents.OnConnecting, handleConnecting);
  // IMSDK.on(CbEvents.OnConnectFailed, handleConnectFailed);
  // IMSDK.on(CbEvents.OnConnectSuccess, handleConnectSuccess);
  onchaliAuto();
  // const Itoken = getIMToken()
  // const IMUserID = getIMUserID()
  // const res =  await IMSDK.login({
  //       userID: IMUserID!,
  //       token: Itoken!,
  //       apiAddr: getApiUrl(),
  //       wsAddr: getWsUrl(),
  //       platformID: 5,
  //       logLevel: Number(getLogLevel()),
  // })

  // console.log(res)
});
</script>

<style lang="scss" scoped>
.page_container {
  background: linear-gradient(180deg,
      rgba(0, 137, 255, 0.1) 0%,
      rgba(255, 255, 255, 0) 100%);
}
</style>
