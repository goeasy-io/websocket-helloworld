import React, {Component} from 'react';
import {View, Text, TextInput, StyleSheet, ScrollView} from 'react-native';

class Index extends Component {

    constructor(props) {
        super(props);
        this.state = {
            messages: [],
            content: '',
        }
        this.inputValChange = this.inputValChange.bind(this);
        this.sendMessage = this.sendMessage.bind(this);
        this.unshiftMessage = this.unshiftMessage.bind(this);
    }

    componentDidMount() {
        //连接GoEasy
        this.connectGoEasy();
        //接收消息
        this.subscribe();
    }

    connectGoEasy() {
        global.goEasy.connect({
            onSuccess: () => {
                this.unshiftMessage("连接成功");
            },
            onFailed: (error) => {
                this.unshiftMessage("Failed to connect GoEasy, code:" + error.code + ",error:" + error.content);
            },
            onProgress: (attempts) => {
                this.unshiftMessage("GoEasy is connecting", attempts);
            }
        });
    }

    subscribe() {
        global.goEasy.pubsub.subscribe({
            channel: "my_channel",
            onMessage: (message) => {
                this.unshiftMessage(message.content);
            },
            onSuccess: () => {
                this.unshiftMessage("订阅成功");
            },
            onFailed: (error) => {
                this.unshiftMessage("订阅失败，错误编码：" + error.code + " 错误信息：" + error.content);
            }
        });
    }

    sendMessage() {
        let message = this.state.content;
        if (message.trim() !== '') {
            global.goEasy.pubsub.publish({
                channel: 'my_channel',
                message: message,
                onSuccess: () => {
                    //清空发送消息内容
                    this.setState({
                        content: '',
                    });
                    console.log("send message success");
                },
                onFailed: error => {
                    this.unshiftMessage("消息发送失败，错误编码：" + error.code + " 错误信息：" + error.content);
                },
            });
        }
    }

    unshiftMessage(content) {
        const formattedTime = this.formatDate(new Date(), "hh:mm");
        const message = formattedTime + " " + content;
        this.state.messages.unshift(message);
        this.setState({
            messages: this.state.messages
        })
    }

    formatDate(date) {
        const hours = ("0" + date.getHours()).slice(-2);
        const minutes = ("0" + date.getMinutes()).slice(-2);
        return hours + ":" + minutes;
    }

    inputValChange = (text) => {
        this.setState({content: text});
    }

    render() {
        return (
            <View style={styles.content}>
                <View style={styles.header}>
                    <Text style={styles.title}>GoEasy Websocket示例</Text>
                    <Text style={styles.description}>React Native Hello world</Text>
                </View>
                <View style={styles.sendBox}>
                    <TextInput style={styles.input} onChangeText={this.inputValChange} value={this.state.content}/>
                    <Text onPress={this.sendMessage} style={styles.sendBtn}>发送</Text>
                </View>
                <ScrollView style={styles.messageContent}>
                    {
                        this.state.messages.map((item, index) => {
                            return <Text style={styles.messageText} key={index}>{item}</Text>
                        })
                    }
                </ScrollView>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    content: {
        height: '100%',
        padding: 40,
        flexDirection: "column",
        backgroundColor: '#FFFFFF'
    },
    header: {
        marginTop: 50,
        flexDirection: "column",
        justifyContent: 'center',
        alignItems: 'center'
    },
    title: {
        color: '#D02129',
        fontSize: 25,
        fontWeight: 'bold'
    },
    description: {
        color: '#D02129',
        fontSize: 20,
        lineHeight: 33
    },
    sendBox: {
        height: 40,
        flexDirection: "row",
        marginTop: 32,
        marginBottom: 32,
        justifyContent: 'center',
        alignItems: 'center'
    },
    input: {
        flex: 1,
        padding: 12,
        borderWidth: 1,
        borderRadius: 6,
        borderColor: '#C8C7CC',
        fontSize: 14,
        backgroundColor: "#EFEFEF"
    },
    sendBtn: {
        color: '#D02129',
        marginLeft: 9,
        fontSize: 15,
        height: 40,
        lineHeight: 40,
        width: 40,
        textAlign: 'right'
    },
    messageContent: {
        flex: 1,
        borderWidth: 1,
        borderColor: '#DADADA',
        backgroundColor: '#FFFFFF',
        overflow: "scroll"
    },
    messageText: {
        fontSize: 15,
        lineHeight: 20,
        paddingTop: 3,
        paddingRight: 5,
        paddingBottom: 3,
        paddingLeft: 5,
        color: '#333333',
    },
});

export default Index;
