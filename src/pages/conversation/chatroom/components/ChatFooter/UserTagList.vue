<template>
  <div class="tag-list-container">
    <div class="tag-list">
      <div 
        v-for="(user, index) in atUserList" 
        :key="user.userID || index" 
        class="tag-item"
      >
        <span class="tag-text">{{ user.nickname }}</span>
        <button 
          @click="removeUser(user.userID)" 
          class="delete-button"
        >
          &times; </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type {
  GroupMemberItem
} from '@openim/client-sdk'
import useConversationStore from '@/store/modules/conversation'
import { storeToRefs } from 'pinia'

const conversationStore = useConversationStore()
const { atUsers } = storeToRefs(conversationStore)
const atUserList = computed<GroupMemberItem[]>(() => {
    const currentAtUsers = atUsers.value // 访问 .value 建立响应依赖
    
    if (!currentAtUsers || currentAtUsers.length === 0) {
        return []
    }
    return conversationStore.groupMember.filter((member: GroupMemberItem) => 
        currentAtUsers.includes(member.userID)
    )
})
const removeUser = (userID:string)=>{
     console.log("待删除数据"+userID)
    conversationStore.deleteAtinfo(userID)
}
</script>
<style scoped>
/* 左右滚动和圆角框的 CSS 保持不变 (参考上一个回答) */
.tag-list-container {
  /* ... CSS for overflow-x: hidden ... */
  width: 100%; 
  padding: 4px 0;
  white-space: nowrap; 
  overflow-x: hidden; 
}

.tag-list {
  display: flex;
  flex-direction: row;
  overflow-x: auto; /* 关键：实现左右滚动 */
  padding-bottom: 8px;
}

.tag-item {
  background-color: #e0e0e0; 
  border-radius: 16px; /* 关键：圆角框 */
  padding: 4px 10px 4px 12px;
  margin-right: 8px;
  display: flex;
  align-items: center;
  flex-shrink: 0; 
}

.tag-text {
  font-size: 14px;
  color: #333;
  margin-right: 6px;
}

.delete-button {
  background: none;
  border: none;
  cursor: pointer;
  color: #888;
  font-size: 16px;
  line-height: 1;
  padding: 0;
}

.delete-button:hover {
  color: #c00;
}
</style>