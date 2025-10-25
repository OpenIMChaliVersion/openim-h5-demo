<template>
  <div 
    class="quote-message-container"
  >
  <div v-html="content"></div>
  </div>
  <component
          :message=props.message.quoteElem?.quoteMessage
          :is="getRenderComp"
        >
        </component>
</template>

<script setup lang="ts">
import { formatLink, parseBr } from '@/utils/imCommon'
import { MessageType } from '@openim/client-sdk'
import { ExedMessageItem } from './data'
import TextMessageRenderer from './TextMessageRenderer.vue'
import MediaMessageRenderer from './MediaMessageRenderer.vue'
import CatchMsgRenderer from './CatchMsgRenderer.vue'

type QuoteMsgRendererProps = {
  message: ExedMessageItem
}

const props = defineProps<QuoteMsgRendererProps>()

const content = computed(() => {
  
  let msgStr = props.message.quoteElem?.text!
  let nickname = props.message.quoteElem?.quoteMessage.senderNickname

  if (props.message.contentType === MessageType.QuoteMessage) {
    console.log(props.message.quoteElem?.quoteMessage)
   
    let quoteElem = props.message.quoteElem
    if(quoteElem?.quoteMessage.contentType === MessageType.TextMessage){
        
    }
  }
  return parseBr(formatLink(msgStr))
})
const getRenderComp = computed(() => {
  switch (props.message.quoteElem?.quoteMessage.contentType) {
    case MessageType.TextMessage:
      return TextMessageRenderer
    case MessageType.PictureMessage:
      return MediaMessageRenderer
    case MessageType.AtTextMessage:
      return TextMessageRenderer
    case MessageType.QuoteMessage:
    //   return QuoteMessageRendever
    case MessageType.MergeMessage:
      return TextMessageRenderer
    default:
      return CatchMsgRenderer
  }
})
</script>

<style lang="scss" scoped>

.quote-message-container {
  // 核心样式：左侧的垂直线
  border-left: 3px solid #dcdcdc; // 较浅的灰色，作为引用指示
  padding: 4px 0 4px 8px;      // 增加内边距，使内容与左侧线分离
  margin-bottom: 6px;          // 如果后面还有其他内容，增加一点间距

  // 视觉辅助：微弱的背景色
  background-color: #f8f8f8;
  border-radius: 4px;        // 轻微的圆角
  
  // 针对引用文本的样式调整
  .text_content {
    font-size: 0.8em;        // 字体稍微小一点
    color: #4d4646;          // 文本颜色比主内容稍微浅一点
    white-space: pre-wrap;   // 保持换行符的显示（如果 parseBr 依赖于此）
  }
}

// 文本内容的通用样式
.text_content {
  word-break: break-all;
  word-wrap: break-word;

  // 针对表情图片的样式
  :deep(.emoji_el) {
    padding-right: 2px;
    vertical-align: sub;
    width: 24px;
  }
}
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
