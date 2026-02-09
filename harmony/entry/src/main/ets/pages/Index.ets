import { hilog } from '@kit.PerformanceAnalysisKit';
import { GoEasy, PubSubMessage } from 'goeasy';

const DOMAIN = 0x0000;
const TAG = 'HelloWorld';

@Entry
@Component
struct Index {
  @State message: string = '';
  @State messages: string[] = [];
  private scroller: Scroller = new Scroller();

  aboutToAppear() {
    hilog.info(DOMAIN, TAG, 'HelloWorldPage: aboutToAppear executed');

    this.connectGoEasy();
    this.subscribe();
  }

  formatDate(date: Date): string {
    const hours = ("0" + date.getHours()).slice(-2);
    const minutes = ("0" + date.getMinutes()).slice(-2);
    return hours + ":" + minutes;
  }

  unshiftMessage(content: string): void {
    const formattedTime = this.formatDate(new Date());
    const msg = `${formattedTime} ${content}`;
    hilog.info(DOMAIN, TAG, 'HelloWorldPage: UI Message -> %{public}s', msg);
    this.messages = [msg, ...this.messages];
  }

  connectGoEasy() {
    hilog.info(DOMAIN, TAG, 'HelloWorldPage: start connect');
    GoEasy.connect({
      onSuccess: () => {
        hilog.info(DOMAIN, TAG, 'HelloWorldPage: connect Success');
        this.unshiftMessage("连接成功");
      },
      onFailed: (error) => {
        hilog.error(DOMAIN, TAG, 'HelloWorldPage: connect Failed: %{public}s', error.content);
        this.unshiftMessage("连接失败: " + error.content);
      }
    });
  }

  subscribe() {
    hilog.info(DOMAIN, TAG, 'HelloWorldPage: start subscribe');
    GoEasy.pubsub.subscribe({
      channel: "my_channel",
      onMessage: (message: PubSubMessage) => {
        hilog.info(DOMAIN, TAG, 'HelloWorldPage: onMessage -> %{public}s', message.content);
        this.unshiftMessage(message.content);
      },
      onSuccess: () => {
        hilog.info(DOMAIN, TAG, 'HelloWorldPage: subscribe Success');
        this.unshiftMessage("订阅成功");
      },
      onFailed: (error) => {
        hilog.error(DOMAIN, TAG, 'HelloWorldPage: subscribe Failed: %{public}s', error.content);
        this.unshiftMessage("订阅失败: " + error.content);
      }
    });
  }

  sendMessage() {
    if (this.message.trim() !== "") {
      const text = this.message;
      hilog.info(DOMAIN, TAG, 'HelloWorldPage: start publish -> %{public}s', text);
      let notificationBody = text;
      if (text.length >= 50) {
        notificationBody = text.substring(0, 30) + "...";
      }
      GoEasy.pubsub.publish({
        channel: "my_channel",
        message: text,
        notification: {
          title: "收到一条新消息",
          body: notificationBody,
          sound: "message",
          badge: "+1",
          vendorOptions:{
            huawei: {
              category: 'EXPRESS'  // "VOIP"、"IM"
            },
            oppo: {
              channel_id: 'order_channel'
            },
            xiaomi: {
              channel_id: '110828'
            },
            vivo:{
              classification:1,
              category: "ORDER"
            },
            honor: {
              importance: 'NORMAL'
            },
            harmony: {
              category: 'IM'
            }
          }
        },
        onSuccess: () => {
          hilog.info(DOMAIN, TAG, 'HelloWorldPage: publish Success');
          this.message = '';
        },
        onFailed: (error) => {
          hilog.error(DOMAIN, TAG, 'HelloWorldPage: publish Failed: %{public}s', error.content);
          this.unshiftMessage("发送失败: " + error.content);
        }
      });
    }
  }

  build() {
    Column() {
      // 标题
      Column() {
        Text('GoEasy Websocket示例')
          .fontSize(24)
          .fontColor('#D02129')
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30, bottom: 10 })
        Text('Hello world')
          .fontSize(18)
          .fontColor('#D02129')
      }
      .width('100%')

      // 发送区域
      Row() {
        TextInput({ text: this.message, placeholder: '请输入消息内容' })
          .layoutWeight(1)
          .height(45)
          .backgroundColor('#EFEFEF')
          .border({ width: 1, color: '#C8C7CC' })
          .borderRadius(6)
          .padding({ left: 10, right: 10 })
          .fontSize(17)
          .onChange((v) => this.message = v)
          .onSubmit(() => this.sendMessage())

        Text('发送')
          .width(60)
          .height(45)
          .fontSize(17)
          .fontColor('#D02129')
          .textAlign(TextAlign.Center)
          .margin({ left: 10 })
          .onClick(() => this.sendMessage())
      }
      .width('100%')
      .padding({ left: 20, right: 20 })
      .margin({ top: 32, bottom: 10 })

      // 消息列表
      Column() {
        List({ space: 0, scroller: this.scroller }) {
          ForEach(this.messages, (msg: string, index: number) => {
            ListItem() {
              Text(msg)
                .fontSize(17)
                .fontColor('#333333')
                .padding({ left: 12, right: 12, top: 8, bottom: 8 })
                .width('100%')
            }
          }, (msg: string, index: number) => index + msg)
        }
        .width('100%')
        .edgeEffect(EdgeEffect.Spring)
      }
      .flexGrow(1)
      .width('100%')
      .backgroundColor('#F1F1F1')
      .border({ width: 1, color: '#DADADA' })
      .borderRadius(4)
      .margin({ bottom: 40 })
      .clip(true)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 20, right: 20 })
    .backgroundColor('#FFFFFF')
  }
}
