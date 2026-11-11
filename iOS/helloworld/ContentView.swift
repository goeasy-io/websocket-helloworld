import SwiftUI
import GoEasySDK

struct ContentView: View {

    @State var message = ""
    @State var messages: [String] = []
    @FocusState private var isInputFocused: Bool
    
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
                TextField("请输入消息", text: $message)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 270.0)
                    .focused($isInputFocused)
                Button(action: {
                    Task {
                        await publish()
                    }
                    isInputFocused = false
                }) {
                    Text("发送")
                        .foregroundColor(Color("GoEasyRed"))
                }

            }

            ScrollView {
                if !messages.isEmpty {
                    ForEach(messages.reversed(), id: \.self) { content in
                        Text("\(content)")
                            .lineLimit(nil)
                            .lineSpacing(10)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding([.top,.leading], 5)
                    }
                }

            }
            .frame(width: 320.0)
            .frame(maxHeight: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.bottom, 100)
        }
        .padding(.top, 30)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .task {
            //监听网络状态变化
            GoEasy.onStateChange { event in
                addMessage("\(event.current), 尝试 \(event.attempts) 次, 错误: \(event.error)")
            }

            do {
                //连接
                try await GoEasy.connect()
                addMessage("连接成功")

                //订阅消息
                try await GoEasy.ws.subscribe(
                    channels: ["demo_channel"],
                    onMessage: { message in
                        //收到消息
                        addMessage(message.content)
                    }
                )
                addMessage("订阅成功")
            } catch {
                addMessage("连接或订阅失败：\(error)")
            }
        }
    }

    func publish() async {
        let notificationOptions = NotificationOptions(title: "GoEasy推送", body: "您有一条新的消息")
        let options = PublishOptions(channel: "demo_channel", content: message, notification: notificationOptions)
        do {
            //发送消息
            try await GoEasy.ws.publish(options)
            message = ""
        } catch {
            addMessage("发送失败：\(error)")
        }
    }

    private static let messageDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()

    func addMessage(_ text: String) {
        let currentTime = Self.messageDateFormatter.string(from: Date())
        messages.append("\(currentTime) \(text)")
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
