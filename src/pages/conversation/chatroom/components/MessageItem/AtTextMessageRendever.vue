<template>
  <div class="text_content need_bg" v-html="content"></div>
  <!-- <component v-if="props.message.atTextElem?.quoteMessage != null"
          :message=props.message.atTextElem?.quoteMessage
          :is="getRenderComp"
        >
</component> -->

</template>

<script setup lang="ts">
import { formatLink, IMSDK, parseBr } from '@/utils/imCommon'
import { MessageType } from '@openim/client-sdk'
import { ExedMessageItem } from './data'
import TextMessageRenderer from './TextMessageRenderer.vue'
import MediaMessageRenderer from './MediaMessageRenderer.vue'
import QuoteMessageRendever from './QuoteMessageRendever.vue'
import AtTextMessageRendever from './AtTextMessageRendever.vue'
import CatchMsgRenderer from './CatchMsgRenderer.vue'
import useConversationStore from '@/store/modules/conversation'
import useUserStore from '@/store/modules/user'
type AtTextMessageRendeverProps = {
  message: ExedMessageItem
}
const conversationStore = useConversationStore()
const selfInfo = useUserStore().selfInfo
const props = defineProps<AtTextMessageRendeverProps>()

const content = computed(() => {
   console.log("来了是一条@消息"+props.message.atTextElem?.text)
  let message = props.message
  let msgStr = props.message.atTextElem?.text!

  var atUser = props.message.atTextElem?.atUserList
  var atUsersInfo = props.message.atTextElem?.atUsersInfo
 
  // console.log("@消息用户信息=atUser"+atUser?.length)
  // console.log("@消息用户信息atUsersInfo="+atUsersInfo?.length)
  // console.log("@消息用户信息atUsersInfo=atUserID="+(atUsersInfo?.[0]?.atUserID || 'undefined'))
  // console.log("@消息用户信息atUsersInfo=groupNickname="+(atUsersInfo?.[0]?.groupNickname || 'undefined'))
  var atUserName = props.message.atTextElem?.atUserList
  
  if(atUser?.length == 1 ){
     let replacedString = msgStr
      atUsersInfo?.forEach(member => {
        const userID = member.atUserID;
        const nickname = member.groupNickname;
        // 构造替换目标：将 '@' + userID 替换为 '@' + nickname
        const targetString = '@' + userID;
        const replacementString = '@' + nickname;
        // const regex = new RegExp(`@${userID}`, 'g');
        const regex = new RegExp(`@${userID}\\b`, 'g');
        replacedString = replacedString.replace(regex, replacementString);
        
      });
      console.log("最后的@消息"+replacedString)
      return parseBr(formatLink(replacedString))
  }else {

    // if (message.groupID && atUser && atUser?.length > 0) {
      const filteredMembers = conversationStore.groupMember.filter(member => atUser?.includes(member.userID))
      let replacedString = msgStr
      filteredMembers.forEach(member => {
        const userID = member.userID;
        const nickname = member.nickname;
        // 构造替换目标：将 '@' + userID 替换为 '@' + nickname
        const targetString = '@' + userID;
        const replacementString = '@' + nickname;
        // const regex = new RegExp(`@${userID}`, 'g');
        const regex = new RegExp(`@${userID}\\b`, 'g');
        replacedString = replacedString.replace(regex, replacementString);
      });
      console.log(replacedString)
      return parseBr(formatLink(replacedString))
    // }
  }
  return parseBr(formatLink(msgStr))
})
const getRenderComp = computed(() => {
  switch (props.message.contentType) {

    case MessageType.AtTextMessage:
      return AtTextMessageRendever
    case MessageType.QuoteMessage:
      return QuoteMessageRendever
    case MessageType.MergeMessage:
      return TextMessageRenderer
    default:
      return CatchMsgRenderer
  }
})
</script>

<style lang="scss" scoped>
.text_content {
  word-break: break-all;
  word-wrap: break-word;

  :deep(.emoji_el) {
    padding-right: 2px;
    vertical-align: sub;
    width: 24px;
  }
}
</style>
