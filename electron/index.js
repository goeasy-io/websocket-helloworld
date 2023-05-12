import GoEasy from "./goeasy-2.6.6.esm.min.js";

// 初始化goEasy
const goEasy = GoEasy.getInstance({
    host:"hangzhou.goeasy.io",//应用所在的区域地址: 【hangzhou.goeasy.io |singapore.goeasy.io】
    appkey:"BC-xxxx",// common key
    modules: ['pubsub']
});

connectGoEasy();
subscribe();

// 监听DOM加载完成
window.addEventListener('DOMContentLoaded', () => {
    document.getElementById('send').addEventListener('click', sendMessage)
})

// 连接goEasy
function connectGoEasy() {
    goEasy.connect({
        onProgress: function (attempts) {
            console.log("GoEasy is connecting", attempts);
        },
        onSuccess: function () {
            unshiftMessage("连接成功")
            console.log("GoEasy connect successfully.")
        },
        onFailed: function (error) {
            unshiftMessage("Failed to connect GoEasy, code:" + error.code + ",error:" + error.content);
        }
    });
}

// 订阅
function subscribe() {
    goEasy.pubsub.subscribe({
        channel: "my_channel",
        onMessage: function (message) {
            unshiftMessage(message.content);
        },
        onSuccess: function () {
            unshiftMessage('订阅成功.');
        },
        onFailed: function (error) {
            unshiftMessage("订阅失败，错误编码：" + error.code + " 错误信息：" + error.content);
        }
    });
}

// 发送消息
function sendMessage() {
    const input = document.getElementById('message')
    const content = input.value
    if (content.trim() !== '') {
        //发送消息
        goEasy.pubsub.publish({
            channel: "my_channel",
            message: content,
            onSuccess: function () {
                console.log("send message success");
            },
            onFailed: function (error) {
                unshiftMessage("消息发送失败，错误编码：" + error.code + " 错误信息：" + error.content);
            }
        });
    }
    // 清空消息
    input.value = ''
}

function unshiftMessage(content) {
    let formattedTime = formatDate(new Date(), "hh:mm");
    let message = formattedTime + " " + content;
    const messageBox = document.getElementById('message-box')
    const messageHtml = document.createElement('div')
    messageHtml.className = "message-text"
    messageHtml.innerText = message
    messageBox.appendChild(messageHtml)
}

function formatDate(date) {
    const hours = ("0" + date.getHours()).slice(-2);
    const minutes = ("0" + date.getMinutes()).slice(-2);
    return hours + ":" + minutes;
}