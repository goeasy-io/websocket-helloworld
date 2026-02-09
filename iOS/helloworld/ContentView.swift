import SwiftUI
import GoEasySwift

struct ContentView: View {

    @State private var message = ""
    @State private var messages: [String] = []
    
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
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
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
                LazyVStack(alignment: .leading) {
                    ForEach(messages.reversed(), id: \.self) { content in
                        Text(content)
                            .lineLimit(nil)
                            .lineSpacing(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)
                    }
                }
            }
            .frame(width: 320, height: 400)
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
        let options = GoEasySwift.V2Api.Common.InitOptions(
            host: GoEasyConfig.host,
            appkey: GoEasyConfig.appkey,
            modules: ["pubsub"],
            allowNotification: true
        )
        GoEasy.initGoEasy(options: options)
    }

    func connect() {
        let options = GoEasySwift.V2Api.Common.ConnectOptions(
            onSuccess: {
                unshiftMessage("连接成功")
                print("连接成功")
            },
            onFailed: { result in
                print("连接失败result：\(result)")
            },
            onProgress: { attempts in
                print("尝试重连次数:\(attempts)")
            }
        )
        GoEasy.connect(options: options)
    }

    func subscribe() {
        let subscribeOptions = GoEasySwift.V2Api.Pubsub.SubscribeOptions(
            channel: "my_channel",
            onSuccess: {
                unshiftMessage("订阅成功")
                print("订阅成功")
            },
            onFailed: { result in
                unshiftMessage("订阅失败")
                print("订阅失败, code: \(result.code) data: \(result.data)")
            },
            onMessage: { message in
                print("收到消息: \(message)")
                unshiftMessage(message.content)
            },
        )

        GoEasy.pubsub.subscribe(options: subscribeOptions)
    }

    func publish() {
        let options = GoEasySwift.V2Api.Pubsub.PublishOptions(
            channel: "my_channel",
            message: message,
            notification: GoEasySwift.V2Api.Common.NotificationOptions(
                title: "您有一条新消息请查收",
                body: message,
                badge: "+1",
                vendorOptions: GoEasySwift.V2Api.Common.VendorOptions(
                    huawei: GoEasySwift.V2Api.Common.HuaweiOptions(
                        category: "EXPRESS"   // "VOIP" / "IM"
                    ),
                    honor: GoEasySwift.V2Api.Common.HonorOptions(
                        importance: "NORMAL"
                    ),
                    xiaomi: GoEasySwift.V2Api.Common.XiaomiOptions(
                        channel_id: .stringValue("110828")
                    ),
                    oppo: GoEasySwift.V2Api.Common.OppoOptions(
                        channel_id: "order_channel"
                    ),
                    vivo: GoEasySwift.V2Api.Common.VivoOptions(
                        classification: 1,
                        category: "ORDER"
                    ),
                    harmony: GoEasySwift.V2Api.Common.HarmonyOptions(
                        category: "IM"
                    )
                )
            ),
            qos: 1,
            onSuccess: {
                print("发送成功")
                message = ""
            },
            onFailed: { result in
                print("发送成功失败, code: \(result.code) data: \(result.data)")
                unshiftMessage("发送失败")
            }
        )
        GoEasy.pubsub.publish(options: options)
        
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
