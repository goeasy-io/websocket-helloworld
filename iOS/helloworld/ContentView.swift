import SwiftUI
import GoEasySwift

struct ContentView: View {

    @State var message = ""
    @State var messages: [String] = []
    
    var body: some View {

        VStack(alignment: .center) {

            VStack(alignment: .center) {
                Text("GoEasy Websocket示例")
                    .font(.title)
                    .foregroundColor(Color("GoEasyRed"))
                Text("Swift Hello world")
                    .font(.title2)
                    .foregroundColor(Color("GoEasyRed"))
            }

            HStack {
                TextField("", text: $message)
                    .padding()
                    .frame(width: 270.0, height: 30.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Button(action: {
                    publish()
                }) {
                    Text("发送")
                        .foregroundColor(Color("GoEasyRed"))
                }

            }

            ScrollView {
                if (!messages.isEmpty) {
                    ForEach(messages.reversed(), id: \.self) { content in
                        Text("\(content)")
                            .lineLimit(nil)
                            .lineSpacing(10)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding([.top,.leading], 5)
                    }
                }

            }
            .frame(width: 320.0, height: 400.0)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            initGoEasy()
            connect()
            subscribe()
        }
    }

    func initGoEasy() {
        GoEasy.initGoEasy(host: GoEasyConfig.host, appkey: GoEasyConfig.appkey)
    }

    func connect() {
        let connectEventListener = ConnectEventListener()
        connectEventListener.onSuccess = { result in
            unshiftMessage("连接成功")
            print("连接成功result：\(result)")
        }
        connectEventListener.onFailed = { result in
            print("连接失败result：\(result)")
        }
        connectEventListener.onProgress = { attempts in
            print("尝试重连次数:\(attempts)")
        }
        GoEasy.connect(connectEventListener: connectEventListener)
    }

    func subscribe() {
        let subscribeEventListener = SubscribeEventListener()
        subscribeEventListener.onSuccess = { result in
            unshiftMessage("订阅成功")
        }
        subscribeEventListener.onFailed = { result in
            unshiftMessage("订阅失败")
        }
        subscribeEventListener.onMessage = { message in
            unshiftMessage(message.content)
        }
        GPubSub.subscribe(channel: "test_channel", subscribeEventListener: subscribeEventListener)
    }

    func publish() {
        let publishEventListener = GoEasyEventListener()
        publishEventListener.onSuccess = { result in
            print("发送成功 code:\(result.code) data:\(result.data)")
            message = ""
        }
        publishEventListener.onFailed = { result in
            unshiftMessage("发送失败")
        }
        GPubSub.publish(channel: "test_channel", message: message, publishEventListener: publishEventListener)
    }

    func unshiftMessage(_ message: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let current_time = dateFormatter.string(from: Date())
        messages.append(current_time + " " + message)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
