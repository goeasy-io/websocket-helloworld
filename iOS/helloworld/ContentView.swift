import SwiftUI
import GoEasySDK

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
                    Task {
                        await publish()
                    }
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
            Task {
                await connect()
            }
        }
    }

    func connect() async {
        GoEasy.onStateChange { event in
            unshiftMessage("当前状态: \(event.current), 尝试 \(event.attempts) 次, 错误: \(event.error.map { "[\($0.code)] \($0.message)" } ?? "无")")
        }
        do {
            try await GoEasy.connect()
            unshiftMessage("连接成功")
            print("连接成功")
            await subscribe()
        } catch {
            print("连接失败：\(error)")
        }
    }

    func subscribe() async {
        do {
            let stream = GoEasy.ws.subscribe(
                channels: ["test_channel"]
            )
            unshiftMessage("订阅成功")
            for try await message in stream {
                print("收到消息：\(message)")
                unshiftMessage(message.content)
           }
        } catch {
            print("订阅失败：\(error)")
            unshiftMessage("订阅失败")
        }
    }

    func publish() async {
        let notificationOptions = NotificationOptions(title: "GoEasy推送", body: "您有一条新的消息")
        let options = PublishOptions(channel: "test_channel", content: message, notification: notificationOptions)
        do {
            try await GoEasy.ws.publish(options)
            print("发送成功")
            message = ""
        } catch {
            print("发送失败：\(error)")
            unshiftMessage("发送失败")
        }
    }

    func unshiftMessage(_ message: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let current_time = dateFormatter.string(from: Date())
        messages.append(current_time + " " + message)
        if messages.count > 100 {
            messages.removeFirst(messages.count - 100)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
