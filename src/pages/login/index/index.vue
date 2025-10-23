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
const { t } = useI18n()
const router = useRouter()
const loading = ref(false)
const loadingStr = ref('正在初始化...')
// function handleConnecting() {
//   // Connecting...
   
// }

// function handleConnectFailed({ errCode, errMsg }: CallbackEvent<any>) {
//   // Connection failed ❌
//   console.log(errCode, errMsg);
//   IMSDK.forceReconnect()
// }

// function handleConnectSuccess() {
//   // initStore()
//   // Connection successful ✅
//    router.push('/conversation')
// }
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
      const vname = `访客${day}${hours}${minutes}${seconds}`
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
          faceURL: 'https://kefu.acone.icu/api/object/9653164283/1761021086245png',
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
