import mitt, { Emitter } from 'mitt'

type Events = {
  CHAT_MAIN_SCROLL_TO_BOTTOM: boolean
  KEYBOARD_UPDATE: void
}

const emitter: Emitter<Events> = mitt<Events>()

export default emitter
