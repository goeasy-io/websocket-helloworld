<script>
  import {inject} from 'vue'
  export default {
    globalData:{

    },
    onLaunch: function() {
      const goEasy = inject('goEasy');
      //为了支持nvue能读到全局对象. 如果不需要支持nvue，main.js里app.provide,其他页面通过inject就可以获取
      this.globalData.goEasy = goEasy;

      console.log("App onLaunch");
    },
    onShow: function() {
      console.log('App Show');
    },
    onHide: function() {
      console.log('App Hide')
    }
  }
</script>

<style>
  /*每个页面公共css */
</style>
