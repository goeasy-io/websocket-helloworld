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
      },
      onSuccess: () => {
        this.unshiftMessage("连接成功")
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

  sendMessage = () => {
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
    this.state.messages.unshift(message);
    this.setState({
      messages: this.state.messages
    })
  }

  formatDate = (date) => {
    const hours = ("0" + date.getHours()).slice(-2);
    const minutes = ("0" + date.getMinutes()).slice(-2);
    return hours + ":" + minutes;
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
