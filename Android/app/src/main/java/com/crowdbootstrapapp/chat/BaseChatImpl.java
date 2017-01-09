package com.crowdbootstrapapp.chat;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.crowdbootstrapapp.chat.interfaces.Chat;
import com.crowdbootstrapapp.chat.interfaces.QBChatMessageListener;
import com.quickblox.chat.QBChat;
import com.quickblox.chat.exception.QBChatException;
import com.quickblox.chat.listeners.QBMessageListener;
import com.quickblox.chat.model.QBChatMessage;

import org.jivesoftware.smack.SmackException;
import org.jivesoftware.smack.XMPPException;



public abstract class BaseChatImpl<T extends QBChat> implements Chat, QBMessageListener<T> {
    private static final String TAG = BaseChatImpl.class.getSimpleName();

    protected Handler mainThreadHandler = new Handler(Looper.getMainLooper());
    protected QBChatMessageListener chatMessageListener;
    protected T qbChat;

    public BaseChatImpl(QBChatMessageListener chatMessageListener) {
        // It's not a good practice to pass Activity to other classes as it may lead to memory leak
        // We're doing this only for chat sample simplicity, don't do this in your projects
        this.chatMessageListener = chatMessageListener;
        initManagerIfNeed();
    }

    protected abstract void initManagerIfNeed();

    @Override
    public void sendMessage(QBChatMessage message) throws XMPPException, SmackException.NotConnectedException {
        try {
            if (qbChat != null) {
                try {
                    qbChat.sendMessage(message);
                } catch (SmackException.NotConnectedException e) {
                    Log.w(TAG, e);

                } catch (IllegalStateException e) {
                    Log.w(TAG, e);

                }
            } else {

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void processMessage(final T qbChat, final QBChatMessage chatMessage) {
        // Show message in activity
        try {
            Log.i(TAG, "New incoming message: " + chatMessage);
            mainThreadHandler.post(new Runnable() {
                @Override
                public void run() {
                    chatMessageListener.onQBChatMessageReceived(qbChat, chatMessage);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void processError(T qbChat, QBChatException e, QBChatMessage qbChatMessage) {
        Log.w(TAG, "Error processing message", e);
    }
}
