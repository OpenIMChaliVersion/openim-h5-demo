import type {
  FriendApplicationItem,
  GroupApplicationItem,
} from '@openim/client-sdk/lib/types/entity'
import { GroupJoinSource } from '@openim/client-sdk'

export enum ApplicationTypeEnum {
  RecivedFriendApplication,
  SentFriendApplication,
  RecivedGroupApplication,
  SentGroupApplication,
}

export type ApplicationItemSource = FriendApplicationItem &
  GroupApplicationItem & { joinSource: GroupJoinSource }
