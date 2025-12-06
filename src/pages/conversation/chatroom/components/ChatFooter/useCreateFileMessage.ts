import { feedbackToast, getPicInfo } from '@/utils/common'
import { v4 as uuidV4 } from 'uuid'
import { MessageType } from '@openim/client-sdk'
import { IMSDK } from '@/utils/imCommon'
import type { MessageItem } from '@openim/client-sdk/lib/types/entity'
// import { showFailToast } from 'vant'

export default function useCreateFileMessage() {
  const { t } = useI18n()

  const getFileData = (data: Blob): Promise<ArrayBuffer> => {
    // return new Promise((resolve, reject) => {
    //   let reader = new FileReader()
    //   reader.onload = function () {
    //     resolve(reader.result as ArrayBuffer)
    //   }
    //   reader.readAsArrayBuffer(data)
    // })
    return new Promise((resolve, reject) => {
      let reader = new FileReader()

      // --- 增加成功处理 ---
      reader.onload = function () {
        resolve(reader.result as ArrayBuffer)
      }

      // --- 增加失败处理 (关键修复) ---
      reader.onerror = function (error) {
        console.error('FileReader error:', error)
        // 调用 reject 结束 Promise，并传递错误信息
        // showFailToast('图片上传失败，请重试')
        reject(new Error('读取图片失败'))
      }
      // 开始读取文件
      reader.readAsArrayBuffer(data)
    })
  }

  const getImageMessage = async (file: File): Promise<MessageItem> => {
    const { width, height } = await getPicInfo(file)
    const baseInfo = {
      uuid: uuidV4(),
      type: file.type,
      size: file.size,
      width,
      height,
      url: URL.createObjectURL(file),
    }
    const options = {
      sourcePicture: baseInfo,
      bigPicture: baseInfo,
      snapshotPicture: baseInfo,
      sourcePath: '',
      file,
    }
    // const createMessageAndNotify = async (
    //   attempt: number,
    // ): Promise<{ errCode: number; data?: MessageItem }> => {
    //   const result = await IMSDK.createImageMessageByFile(options)
    //   if (result.errCode === 0) {
    //     console.log(`a${attempt}`)
    //     feedbackToast({ message: '上传成功,准备发送' })
    //     console.log(`尝试 ${attempt} 失败`)
    //   } else {
    //     console.log(`尝试 ${attempt} 失败`)
    //     feedbackToast({ message: `尝试 上传 ${attempt} 失败` })
    //   }
    //   return result
    // }
    // let messageimg = await createMessageAndNotify(1)
    // if (messageimg.errCode === 0) {
    //   return messageimg.data!
    // }

    // messageimg = await createMessageAndNotify(2)
    // if (messageimg.errCode === 0) {
    //   return messageimg.data!
    // }

    // messageimg = await createMessageAndNotify(3)
    // if (messageimg.errCode === 0) {
    //   return messageimg.data!
    // }

    const result = await IMSDK.createImageMessageByFile(options)
    if (result.errCode === 0) {
      // 成功处理
      console.log('消息创建成功')
      // feedbackToast({ message: '上传成功,准备发送' })
      return result.data!
    } else {
      // 失败处理
      console.error(`消息创建失败，错误码：${result.errCode}`)
      // showFailToast('图片上传失败，请重试')
      // 抛出异常，要求上层调用者（createFileMessage）必须使用 try...catch 捕获
      throw new Error(`Failed to create image message. Error code: ${result.errCode}`)
    }
  }

  const createFileMessage = async (file: File, messageType: MessageType) => {
    switch (messageType) {
      case MessageType.PictureMessage:
        try {
          const message = await getImageMessage(file)
          const data = await getFileData(file)
          return {
            message: message,
            buffer: data,
          }
        }
         catch (error) {
          // 捕获 getImageMessage 中抛出的错误
          return {
            error: (error as Error).message,
          }
        }
        // return {
        //   message: await getImageMessage(file),
        //   buffer: await getFileData(file),
        // }
      default:
        return {
          error: 'message type error',
        }
    }
  }

  return {
    createFileMessage,
  }
}
