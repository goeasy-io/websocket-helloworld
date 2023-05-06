//app.js
import GoEasy from './utils/goeasy-2.6.6.esm.min.js';

App({
    globalData: {
        goEasy: GoEasy.getInstance({
          host:"hangzhou.goeasy.io",//应用所在的区域地址: 【hangzhou.goeasy.io |singapore.goeasy.io】
          appkey:"BC-xxxx",// common key
          modules: ['pubsub']
        })
    },
    onLaunch: function () {
        this.extendDateFormat();
    },
    extendDateFormat() {
        Date.prototype.formatDate = function () {
            const hours = ("0" + this.getHours()).slice(-2);
            const minutes = ("0" + this.getMinutes()).slice(-2);
            return hours + ":" + minutes;
        };
    }
})
