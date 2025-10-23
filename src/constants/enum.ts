import { MessageType, SessionType } from '@openim/client-sdk'

export const CustomMessageType = {
  Call: 100,
  MassMsg: 903,
  MeetingInvitation: 905,
}

export enum CustomType {
  CallingInvite = 200,
  CallingAccept = 201,
  CallingReject = 202,
  CallingCancel = 203,
  CallingHungup = 204,
}

export enum RtcMessageStatus {
  Refused,
  Canceled,
  Timeout,
  Successed,
  HandleByOtherDevice,
}

export const GroupSessionTypes = [SessionType.Group, SessionType.Notification]

export const GroupSystemMessageTypes = [
  MessageType.GroupCreated,
  // MessageType.GroupNameUpdated,
  MessageType.MemberQuit,
  MessageType.GroupOwnerTransferred,
  MessageType.MemberKicked,
  MessageType.MemberInvited,
  MessageType.MemberEnter,
  MessageType.GroupDismissed,
  MessageType.GroupMemberMuted,
  MessageType.GroupMuted,
  MessageType.GroupCancelMuted,
  MessageType.GroupMemberCancelMuted,
  MessageType.GroupNameUpdated,
]

export const TipTypes = [
  MessageType.RevokeMessage,
  MessageType.FriendAdded,
  MessageType.BurnMessageChange,
  ...GroupSystemMessageTypes,
]

export const FileMessageTypes = [
  MessageType.PictureMessage,
  MessageType.VideoMessage,
  MessageType.VoiceMessage,
  MessageType.FileMessage,
]
