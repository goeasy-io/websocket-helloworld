<script>
	export default {
		globalData:{

        },
        onLaunch: function() {

            //为了支持nvue能读到全局对象. 如果不需要支持nvue，main.js里挂在Vue.prototype,其他页面通过this.goEasy就可以获取
            this.globalData.goEasy = this.goEasy;

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
