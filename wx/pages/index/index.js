let goEasy = getApp().globalData.goEasy;
let pubSub = goEasy.pubsub;
Page({
    data: {
        message: "",
        messages: []
    },
    onLoad: function () {
		var self = this;
		//接收（订阅)消息
		pubSub.subscribe({
		    channel: "my_channel",
		    onMessage: function (message) {
		        self.unshiftMessage(message.content);
		    },
		    onSuccess: function () {
		        self.unshiftMessage('订阅成功.');
		    },
            onFailed: function (error) {
                self.unshiftMessage("订阅失败，错误编码："+error.code+" 错误信息："+error.content);
            }
		});
    },
    sendMessage: function () {
        var self = this;
        var content = this.data.message;
        if (content.trim() != '') {
            //发送消息
            pubSub.publish({
                channel: "my_channel",
                message: self.data.message,
                onSuccess: function () {
                    //清空发送消息内容
                    self.setData({
                        message: ''
                    });
                    console.log("send message success");
                },
                onFailed: function (error) {
                    self.unshiftMessage("消息发送失败，错误编码："+error.code+" 错误信息："+error.content);
                }
            });
        }
    },
	unshiftMessage(content) {
	    var formattedTime = new Date().formatDate("hh:mm");
	    var message = formattedTime +" "+ content;
	    var messages = this.data.messages;
	    messages.unshift(message);
	    this.setData({
	        messages: messages
	    })
	},
})
