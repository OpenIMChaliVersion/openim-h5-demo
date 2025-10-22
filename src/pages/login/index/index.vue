<template>
  <div class="page_container relative !bg-white px-10">
    <img class="mx-auto mt-[80px] h-16 w-16" src="@assets/images/logo.png" alt="" />
    <div class="mx-auto text-lg font-semibold text-primary">{{ $t('welcome') }}</div>
    <div class="mt-20 flex flex-col items-center">
      <!-- <van-button
        type="primary"
        class="w-full text-base"
        :loading="loading"
        @click="onchaliAuto"
        >{{ $t('loginAsGuest') }}</van-button
      >  -->
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
import { getApiUrl, getIMToken, getIMUserID, getLogLevel, getWsUrl, setIMProfile } from '@/utils/storage'
import { UsedFor } from '@/api/data'
import { IMSDK, initStore } from '@/utils/imCommon'
const { t } = useI18n()
const router = useRouter()
const loading = ref(false)
const loadingStr = ref('正在初始化...')
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
      console.log('初始化 res_send', res_send)
      loadingStr.value = '正在初始化 11%'
      // if (res_send.data.errCode === 0) {}
      // else{
      //   console.log('初始化 res_send 失败，继续注册', res_send)
      // }
      loadingStr.value = '正在初始化 12%'
      loadingStr.value = '正在初始化 30%'
      const res_verify = await verifyCode({
        phoneNumber: '',
        areaCode: '86',
        email: vemail,
        verifyCode: '666666',
        usedFor: UsedFor.Register
      })
      console.log('初始化 res_verify', res_verify)
      // if (res_verify.data.errCode !== 0) {
      //   feedbackToast({
      //     message: t('messageTip.verifyFailed'),
      //     error: res_verify.data.errMsg,
      //   })
      //   return
      // }

      loadingStr.value = '正在初始化 50%'
      const res_register = await register({
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
      console.log('初始化 res_register', res_register)
      loadingStr.value = '正在初始化 80%'
      const { data: { chatToken, imToken, userID }, } = await login({
        phoneNumber: '',
        password: md5(vpass),
        areaCode: "86",
        verifyCode: "",
        email: vemail,
      })
      console.log('初始化 login', { chatToken, imToken, userID }) 
      setIMProfile({ chatToken, imToken, userID })
      localStorage.setItem('IMAccount', vemail)
      // router.push('/conversation')
      // localStorage.setItem('userID', userID)
      // localStorage.setItem('chatToken', chatToken)
      // localStorage.setItem('imToken', imToken)
      // localStorage.setItem('vpass', vpass)
      loadingStr.value = '正在初始化 85%'
      await IMSDK.login({
        userID: userID!,
        token: imToken!,
        apiAddr: getApiUrl(),
        wsAddr: getWsUrl(),
        platformID: 5,
        logLevel: Number(getLogLevel()),
      })
       loadingStr.value = '正在初始化 90%'
      const { data } = await IMSDK.getLoginStatus()
    
      if (data === 3) {
          initStore()
          loadingStr.value = '正在初始化 99%'
          router.push('/conversation')
      }
      // if (data !== LoginStatus.Logging) {
       
      // }
      // if (data === LoginStatus.Logging) {
        // const unLoginInterval = setInterval(async () => {
        //   const { data } = await IMSDK.getLoginStatus()
        //   if (data === LoginStatus.Logged) {
        //     clearInterval(unLoginInterval)
        //     loadingStr.value = '正在初始化 100%'
        //     await initStore()
        //     router.push('/conversation')
        //   }
        // }, 1000)
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
      router.push('/conversation')
      loading.value = false
    }
  } catch (error) {
    router.push('/login')
    feedbackToast({ message: t('messageTip.loginFailed'), error })
  }
}

onMounted(() => {
  // 因为 onchaliAuto 是异步的，直接调用即可
  onchaliAuto();
});
</script>

<style lang="scss" scoped>
.page_container {
  background: linear-gradient(180deg,
      rgba(0, 137, 255, 0.1) 0%,
      rgba(255, 255, 255, 0) 100%);
}
</style>
