<template>
  <div class="page_container relative !bg-white px-10">
    <img class="mx-auto mt-[80px] h-16 w-16" src="@assets/images/logo.png" alt="" />
    <div class="mx-auto text-lg font-semibold text-primary">{{ $t('welcome') }}</div>

    <div class="center-container">
      <van-loading v-if="loading" class="mt-20" type="spinner" size="24px" color="#1677ff">
        <div style="text-align: center;">
          连线中...
        </div>
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
const onchaliAuto = async () => {
  loading.value = true

  var vemail = ''
  vemail = localStorage.getItem('IMAccount') || ''
  const vpass = 'chali22222'
  if (vemail) {
    try {
      const { data: { chatToken, imToken, userID }, } = await login({
        phoneNumber: '',
        password: md5(vpass),
        areaCode: "86",
        verifyCode: "",
        email: vemail,
      })
      setIMProfile({ chatToken, imToken, userID })
 
      if (!imToken || !userID) {
        feedbackToast({ message: t('messageTip.loginFailed'), error: 'Invalid credentials' })
        return
      }
      const res = await IMSDK.login({
        userID: userID!,
        token: imToken!,
        apiAddr: getApiUrl(),
        wsAddr: getWsUrl(),
        platformID: 5,
        logLevel: Number(getLogLevel()),
      })
      console.log('login res', res)
      IMSDK.getLoginStatus().then((res) => {
        if (res) {
          router.push('/conversation')
        }
      })
    } catch (error) {
      feedbackToast({ message: t('messageTip.loginFailed'), error })
    }
    loading.value = false
    router.push('/conversation')
  } else {
    const timestampInMillis: number = +new Date();
    const date = new Date();
    const day: number = date.getDate();
    const hours: number = date.getHours();
    const minutes: number = date.getMinutes();
    const seconds: number = date.getSeconds();
    const invitationCode = 'LyvA69qG';
    const vname = `访客${day}${hours}${minutes}${seconds}`
    vemail = `wuchali${timestampInMillis}@163.com`
    sendSms({
      phoneNumber: '',
      areaCode: '86',
      email: vemail,
      invitationCode: invitationCode,
      usedFor: UsedFor.Register
    })

    verifyCode({
      phoneNumber: '',
      areaCode: '86',
      email: vemail,
      verifyCode: '666666',
      usedFor: UsedFor.Register
    })
    const res = register({
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
    const data = await res.then(res => res.data)
    if (data.userID === '' && data.imToken === '' && data.chatToken === '') {
      localStorage.setItem('IMAccount', vemail);
    }  

    try {
      const { data: { chatToken, imToken, userID }, } = await login({
        phoneNumber: '',
        password: md5(vpass),
        areaCode: "86",
        verifyCode: "",
        email: vemail,
      })
      setIMProfile({ chatToken, imToken, userID })
      const resIm = await IMSDK.login({
        userID: userID!,
        token: imToken!,
        apiAddr: getApiUrl(),
        wsAddr: getWsUrl(),
        platformID: 5,
        logLevel: Number(getLogLevel()),
      })

      console.log('login res', resIm)
      if (!resIm.data) {
       IMSDK.getLoginStatus().then((resloginstatus) => {
        if (!resloginstatus.data ) {
          router.push('/conversation')
        }else{
          feedbackToast({ message:  t('messageTip.loginFailed'), error: "请刷新稍后再试" })
        }
      })
      }else{
        feedbackToast({ message:  t('messageTip.loginFailed'), error: "请刷新稍后再试" })
      }
    } catch (error) {
      feedbackToast({ message: t('messageTip.loginFailed'), error })
    }
    loading.value = false
  }
}
onMounted(() => {
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
