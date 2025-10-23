import { BusinessUserInfo } from '@/api/data'
import type {
  ConversationItem,
  FriendUserItem,
  GroupItem,
  GroupMemberItem,
} from '@openim/client-sdk/lib/types/entity'

export type GenericListItemSource = FriendUserItem &
  GroupItem &
  GroupMemberItem &
  BusinessUserInfo &
  ConversationItem
