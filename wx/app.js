//app.js
import GoEasy from './utils/goeasy-2.5.20.min.js';

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
        Date.prototype.formatDate = function (fmt) {
            var o = {
                "M+": this.getMonth() + 1,
                "d+": this.getDate(),
                "h+": this.getHours(),
                "m+": this.getMinutes(),
                "s+": this.getSeconds(),
                "q+": Math.floor((this.getMonth() + 3) / 3),
                "S": this.getMilliseconds()
            };
            if (/(y+)/.test(fmt))
                fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
            for (var k in o)
                if (o.hasOwnProperty(k)) {
                    if (new RegExp("(" + k + ")").test(fmt))
                        fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
                }
            return fmt;
        };
    }
})
