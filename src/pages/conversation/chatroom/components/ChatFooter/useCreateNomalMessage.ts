import useConversationStore from '@/store/modules/conversation'
import { feedbackToast } from '@/utils/common'
import { IMSDK, getCleanText } from '@/utils/imCommon'
import type { AtUsersInfoItem, MessageItem } from '@openim/client-sdk/lib/types/entity'
import { FaceMessageParams } from '@openim/client-sdk/lib/types/params'
import type { GroupMemberItem } from '@openim/client-sdk'
import { Ref } from 'vue'
import { storeToRefs } from 'pinia'
type CreateNomalMessageProps = {
  messageContent: Ref<string>
}
const conversationStore = useConversationStore()
const { atUsers, isAt } = storeToRefs(conversationStore)
const atUserList = computed<GroupMemberItem[]>(() => {
  const currentAtUsers = atUsers.value // 访问 .value 建立响应依赖

  if (!currentAtUsers || currentAtUsers.length === 0) {
    return []
  }
  return conversationStore.groupMember.filter((member: GroupMemberItem) =>
    currentAtUsers.includes(member.userID),
  )
})
const atUserListParam = computed<AtUsersInfoItem[]>(() => {
  if (!atUserList.value || atUserList.value.length === 0) {
    return []
  }
  return atUserList.value.map((member: GroupMemberItem) => {
    return {
      atUserID: member.userID,
      groupNickname: member.nickname,
    } as AtUsersInfoItem
  })
})
const quoteMsgParam = computed<MessageItem>(() => {
  return {} as MessageItem
})
export default function useCreateNomalMessage({
  messageContent,
}: CreateNomalMessageProps) {
  // if (!conversationStore.isSDKReady) {
  //       // Show a message to the user: "Connecting to server..."
  //       return;
  // }
  const getCleanTextWithBr = () => {
    let text = messageContent.value
    text = text.replace(/<div>/g, '\n').replace(/<\/div>/g, '')
    return getCleanText(text)
  }

  const getTextMessage = async () => {
    const formattedText = getCleanTextWithBr()
    console.log(formattedText)
    if (isAt) {
      console.log('有@')
      console.log('有@' + atUsers.value.length)
      var atUsersAt = atUsers.value.map(useid=> "@"+useid)
      console.log(formattedText)
      const res = await IMSDK.createTextAtMessage({
          text: formattedText+" "+atUsersAt.join(' '),
          atUserIDList: atUsers.value,
          atUsersInfo: atUserListParam.value,
        })
      console.log(res)    
       console.log(res.data.atTextElem)
       return res.data
    } else {
      return (await IMSDK.createTextMessage(formattedText)).data
    }
  }

  const switchNomalMessage = async () => {
    let message
    message = (await getTextMessage()) as MessageItem
    console.log("消息类型"+message.contentType)
    if (!message) {
      feedbackToast({
        error: 'create message failed',
        message: 'create message failed',
      })
      return
    }
    console.log("消息类型"+message.contentType)
    return message
  }
  return {
    switchNomalMessage,
    getCleanText,
  }
}