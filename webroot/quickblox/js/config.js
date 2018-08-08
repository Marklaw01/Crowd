/*var QBApp = {
  appId: 40533,
  authKey: '3Hj94aQKC5ZLuZu',
  authSecret: 'z89sW8qvsbJ-vbC'
};*/
var QBApp = {
  appId: 32716,
  authKey: 'GFZx5kekuYNsP7Z',
  authSecret: 'mUJHuFX3m-uXu2x'
};


var config = {
  chatProtocol: {
    active: 2
  },
  debug: {
    mode: 1,
    file: null
  },
  stickerpipe: {
    elId: 'stickers_btn',

    apiKey: '847b82c49db21ecec88c510e377b452c',

    enableEmojiTab: false,
    enableHistoryTab: true,
    enableStoreTab: true,

    userId: null,

    priceB: '0.99 $',
    priceC: '1.99 $'
  }
};


QB.init(QBApp.appId, QBApp.authKey, QBApp.authSecret, config);
