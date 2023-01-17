import { defineConfig } from 'vite'
import uni from '@dcloudio/vite-plugin-uni'

let argv = process.env.npm_config_argv;
if (argv) {
  argv = JSON.parse(argv);
  const cooked = argv.cooked;
  const length = argv.cooked.length;
  if (!process.env.VITE_VUE_APP_APPKEY) {
    process.env.VITE_VUE_APP_APPKEY = cooked[length-1]
  }
}

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    uni(),
  ],
})
