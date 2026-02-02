<script>
	export default {
        onLaunch: function() {
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
  /*  #ifdef  H5  */
  *{
    font-family: "HanHei SC",PingHei,"PingFang SC","Helvetica Neue",Helvetica,Arial,"Microsoft Yahei","Hiragino Sans GB","Heiti SC","WenQuanYi Micro Hei",sans-serif;;
    font-style: normal;
    font-weight: normal;
  }
  /*  #endif  */
</style>
