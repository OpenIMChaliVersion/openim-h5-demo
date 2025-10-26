// const BASE_DOMAIN = '43.160.198.172'
// const CHAT_URL = `http://${BASE_DOMAIN}:10008`
// const API_URL = `http://${BASE_DOMAIN}:10002`
// const WS_URL = `ws://${BASE_DOMAIN}:10001`
const BASE_DOMAIN = 'bao.acone.icu'
const CHAT_URL = `https://${BASE_DOMAIN}/chat`
const API_URL = `https://${BASE_DOMAIN}/api`
const WS_URL = `wss://${BASE_DOMAIN}/msg_gateway`
export default {
  NODE_ENV: 'development',
  CHAT_URL,
  API_URL,
  WS_URL,
  LOG_LEVEL: 5,
  VERSION: 'H5-Demo',
}
