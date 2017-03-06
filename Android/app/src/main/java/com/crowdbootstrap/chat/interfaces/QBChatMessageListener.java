package com.crowdbootstrap.chat.interfaces;

import com.quickblox.chat.QBChat;
import com.quickblox.chat.model.QBChatMessage;

public interface QBChatMessageListener {

    void onQBChatMessageReceived(QBChat chat, QBChatMessage message);

}
