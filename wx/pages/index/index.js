let goEasy = getApp().globalData.goEasy;
let pubSub = goEasy.pubsub;
Page({
    data: {
        message: "",
        messages: []
    },
    onLoad() {
        this.connectGoEasy();
    },
    connectGoEasy() {
        //建立连接
        goEasy.connect({
            onSuccess: () => {
                console.log("GoEasy connect successfully.")
                this.subscribe();
            },
            onFailed: (error) => {
                console.log("Failed to connect GoEasy, code:" + error.code + ",error:" + error.content);
                wx.showModal({
                    icon: "none",
                    title: error.code.toString(),
                    content: error.content,
                    showCancel: false,
                    duration: 6000
                });
            },
            onProgress: (attempts) => {
                console.log("GoEasy is connecting", attempts);
            }
        });
    },
    subscribe() {
        //接收（订阅)消息
        pubSub.subscribe({
            channel: "my_channel",
            onMessage: (message) => {
                this.unshiftMessage(message.content);
            },
            onSuccess: () => {
                this.unshiftMessage('订阅成功.');
            },
            onFailed: (error) => {
                this.unshiftMessage("订阅失败，错误编码："+error.code+" 错误信息："+error.content);
            }
        });
    },
    sendMessage() {
        var content = this.data.message;
        if (content.trim() !== '') {
            //发送消息
            pubSub.publish({
                channel: "my_channel",
                message: this.data.message,
                onSuccess: () => {
                    //清空发送消息内容
                    this.setData({
                        message: ''
                    });
                    console.log("send message success");
                },
                onFailed: (error) => {
                    this.unshiftMessage("消息发送失败，错误编码："+error.code+" 错误信息："+error.content);
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
