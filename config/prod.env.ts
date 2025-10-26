const BASE_DOMAIN = '__BASE_DOMAIN_PLACEHOLDER__'
const CHAT_URL = `https://${BASE_DOMAIN}/chat`
const API_URL = `https://${BASE_DOMAIN}/api`
const WS_URL = `wss://${BASE_DOMAIN}/msg_gateway`


export default {
  NODE_ENV: 'production',
  BASE_DOMAIN,
  CHAT_URL,
  API_URL,
  WS_URL,
  LOG_LEVEL: 5,
  VERSION: 'H5-Demo',
}
