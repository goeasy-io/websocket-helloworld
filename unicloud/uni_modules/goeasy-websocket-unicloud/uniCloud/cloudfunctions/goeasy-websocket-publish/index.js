'use strict';
exports.main = async (event, context) => {
	//event为客户端上传的参数
	console.log('event : ', event);

	const res = await uniCloud.httpclient.request("https://rest-hz.goeasy.io/v2/pubsub/publish", {
		method: 'POST',
		data: {
			appkey: 'BC-xxx', //您的appkey
			channel: event.channel,
			content: 'uniCloud: ' + event.content,
			notification: {
				title: 'GoEasy订单提醒', //可选，通知栏提醒标题
				body: '您有新的订单提醒' //可选，通知栏提醒内容
			}
		},
		contentType: 'json', // 指定以application/json发送data内的数据
		dataType: 'json' // 指定返回值为json格式，自动进行parse
	});

	console.log('rest api result:', res);


	//返回数据给客户端
	return res
};
