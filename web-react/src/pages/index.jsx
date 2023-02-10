import React from 'react'
import './index.css'

export default class Index extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      messages: [],
      content: '',
    }
  }

  componentDidMount() {
    this.connectGoEasy();
    this.subscribe();
  }

  connectGoEasy = () => {
    window.goEasy.connect({
      onProgress: (attempts) => {
        console.log("GoEasy is connecting", attempts);
        this.unshiftMessage("连接成功")
      },
      onSuccess: () => {
        console.log("GoEasy connect successfully.")
      },
      onFailed: (error) => {
        this.unshiftMessage("Failed to connect GoEasy, code:" + error.code + ",error:" + error.content);
      }
    });
  }

  subscribe = () => {
    window.goEasy.pubsub.subscribe({
      channel: "my_channel",
      onMessage: (message) => {
        this.unshiftMessage(message.content);
      },
      onSuccess: () => {
        this.unshiftMessage('订阅成功.');
      },
      onFailed: (error) => {
        this.unshiftMessage("订阅失败，错误编码：" + error.code + " 错误信息：" + error.content);
      }
    });
  }

  sendMessageByEnter = (event) => {
    if (event.key === 'Enter') { // enter发送
      event.preventDefault();
      this.sendMessage();
    }
  }

  sendMessage = () => {//发送消息
    if (this.state.content.trim() !== '') {
      //发送消息
      window.goEasy.pubsub.publish({
        channel: "my_channel",
        message: this.state.content,
        onSuccess: () => {
          this.setState({
            content: ''
          })
          console.log("send message success");
        },
        onFailed: (error) => {
          this.unshiftMessage("消息发送失败，错误编码：" + error.code + " 错误信息：" + error.content);
        }
      });
    }
  }

  unshiftMessage = (content) => {
    let formattedTime = this.formatDate(new Date(), "hh:mm");
    let message = formattedTime + " " + content;
    let newMessages = this.state.messages;
    newMessages.unshift(message);
    this.setState({
      messages: newMessages
    })
  }

  formatDate = (date, format) => {
    const o = {
      "M+": date.getMonth() + 1,
      "d+": date.getDate(),
      "h+": date.getHours(),
      "m+": date.getMinutes(),
      "s+": date.getSeconds(),
      "q+": Math.floor((date.getMonth() + 3) / 3),
      "S": date.getMilliseconds()
    };
    if (/(y+)/.test(format))
      format = format.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (let k in o)
      if (o.hasOwnProperty(k)) {
        if (new RegExp("(" + k + ")").test(format))
          format = format.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
      }
    return format;
  }

  inputValChange = e => {
    this.setState({
      content: e.target.value
    });
  }

  render() {
    return (
      <div className="index">
        <div className="container">
          <div className="header">
            <span className="title">GoEasy Websocket示例</span>
            <span className="description">React Hello world</span>
          </div>
          <div className="send-box">
            <input value={this.state.content} onChange={this.inputValChange} onKeyDown={this.sendMessageByEnter}/>
            <span onClick={this.sendMessage}>发送</span>
          </div>
          <div className="message-container">
            <div className="message-content">
              {this.state.messages.map((item, index) =>
                <div key={index} className="message-text">{item}</div>
              )}
            </div>
          </div>
        </div>
      </div>
    )
  }
}
