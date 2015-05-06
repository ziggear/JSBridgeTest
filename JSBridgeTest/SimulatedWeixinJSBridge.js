//by ziggzhang
//模拟微信客户端进行分享数据传递

WeixinJSBridge = document.createElement("iframe");

WeixinJSBridge.style.display = 'none';
WeixinJSBridge.sendMessageQueue = [];

WeixinJSBridge.onWebViewReady = function () {
    //alert('WeixinJSBridge.onWebViewReady');
    var webViewReadyEvent = new Event('WeixinJSBridgeReady');
    document.dispatchEvent(webViewReadyEvent);
};

WeixinJSBridge.on = function (eventName, eventFunc) {
    WeixinJSBridge.addEventListener(eventName, eventFunc);
};

WeixinJSBridge.invoke = function (name, data, other) {
    //alert('WeixinJSBridge.invoke');
    if(name == 'sendAppMessage') {
        this.sendMessageQueue.push(data);
        window.location.href = 'simulatedweixinjsbridge://sendAppMessage/';
    }
};

WeixinJSBridge.dispatchShareEvent = function () {
    var shareMessageEvent = new Event('menu:share:appmessage');
    this.dispatchEvent(shareMessageEvent);
};

WeixinJSBridge.fetchQueue = function () {
    var messageQueueString = JSON.stringify(this.sendMessageQueue.pop());
    return messageQueueString;
};

