<template>
  <div class="page_container relative !bg-white px-10">
    <img class="mx-auto mt-[80px] h-16 w-16" src="@assets/images/logo.png" alt="" />
    <div class="mx-auto text-lg font-semibold text-primary">{{ $t('welcome') }}</div>
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


  const IMToken = getIMToken()
  const IMUserID = getIMUserID()
  if (IMToken && IMUserID) {
    try {
      setIMProfile({ chatToken: '', imToken: IMToken, userID: IMUserID })
      const res = await IMSDK.login({
        userID: IMUserID!,
        token: IMToken!,
        apiAddr: getApiUrl(),
        wsAddr: getWsUrl(),
        platformID: 5,
        logLevel: Number(getLogLevel()),
      })
      console.log('查理login success', res)
      initStore()
      router.push('/conversation')
      return
    } catch (error) {
      feedbackToast({ message: t('messageTip.loginFailed'), error })
    }
  } 
  else {
    const timestampInMillis: number = +new Date();
    const date = new Date();
    const day: number = date.getDate();
    const hours: number = date.getHours();
    const minutes: number = date.getMinutes();
    const seconds: number = date.getSeconds();
    const invitationCode = 'LyvA69qG';
    const vpass = 'chali22222'
    const vname = `访客${day}${hours}${minutes}${seconds}`
    const vemail = `wuchali${timestampInMillis}@163.com`
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
    let chatToken = data.chatToken
    let imToken = data.imToken
    let userID = data.userID
    localStorage.setItem('IMAccount', vemail)
    localStorage.setItem('userID', userID)
    localStorage.setItem('chatToken', chatToken)
    localStorage.setItem('imToken', imToken)
    localStorage.setItem('vpass', vpass)
    console.log('register', data)
    try {
      const { data: { chatToken, imToken, userID }, } = await login({
        phoneNumber: '',
        password: md5(vpass),
        areaCode: "86",
        verifyCode: "",
        email: vemail,
      })

      setIMProfile({ chatToken, imToken, userID })
      router.push('/conversation')
    } catch (error) {
      feedbackToast({ message: t('messageTip.loginFailed'), error })
    }
    loading.value = false
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
