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
            let state = GoEasy.state;
            unshiftMessage("当前连接状态: \(state)")
            GoEasy.onStateChange { event in
                unshiftMessage("当前状态: \(event.current), 尝试连接次数: \(event.attempts), 错误: \(event.error.map { "[\($0.code)] \($0.message)" } ?? "无")")
            }
            connect()
            subscribe()
        }
    }

    func connect() {
        GoEasy.connect { result in
            switch result {
            case .success:
                unshiftMessage("连接成功")
                print("连接成功")
            case .failure(let error):
                print("连接失败：\(error)")
            }
        }
    }

    func subscribe() {
        GoEasy.ws.subscribe(
            channels: ["test_channel"],
            onMessage: { message in
                print("收到消息：\(message)")
                unshiftMessage(message.content)
            },
            completion: { result in
                switch result {
                case .success:
                    unshiftMessage("订阅成功")
                case .failure(let error):
                    print("订阅失败：\(error)")
                    unshiftMessage("订阅失败")
                }
            }
        )
    }

    func publish() {
        let options = PublishOptions(channel: "test_channel", content: message, qos: 1)
        GoEasy.ws.publish(options) { result in
            switch result {
            case .success:
                print("发送成功")
                message = ""
            case .failure(let error):
                print("发送失败：\(error)")
                unshiftMessage("发送失败")
            }
        }
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
