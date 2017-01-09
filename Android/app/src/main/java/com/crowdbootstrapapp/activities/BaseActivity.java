package com.crowdbootstrapapp.activities;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.widget.TextView;

import com.crowdbootstrapapp.chat.QbAuthUtils;
import com.crowdbootstrapapp.chat.interfaces.QbSessionStateCallback;
import com.crowdbootstrapapp.utilities.PrefManager;
import com.quickblox.auth.QBAuth;
import com.quickblox.auth.model.QBSession;
import com.quickblox.chat.QBChatService;
import com.quickblox.core.QBEntityCallback;
import com.quickblox.core.exception.QBResponseException;
import com.quickblox.users.model.QBUser;


/**
 * Created by neelmani.karn on 1/6/2016.
 *
 *test
 */
public abstract class BaseActivity extends AppCompatActivity implements QbSessionStateCallback {
    private static final String TAG = BaseActivity.class.getSimpleName();
    public Toolbar toolbar;
    public TextView toolbarTitle;

    /*public PrefManager prefManager;
    public NetworkConnectivity networkConnectivity;
    public UtilitiesClass utilitiesClass;*/
    protected boolean isAppSessionActive;

    private static final Handler mainThreadHandler = new Handler(Looper.getMainLooper());
    public abstract void setActionBarTitle(String title);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        try {
            boolean wasAppRestored = savedInstanceState != null;
            boolean isQbSessionActive = QbAuthUtils.isSessionActive();
            final boolean needToRestoreSession = wasAppRestored || !isQbSessionActive;
            Log.v(TAG, "wasAppRestored = " + wasAppRestored);
            Log.v(TAG, "isQbSessionActive = " + isQbSessionActive);

            // Triggering callback via Handler#post() method
            // to let child's code in onCreate() to execute first
            mainThreadHandler.post(new Runnable() {
                @Override
                public void run() {
                    if (needToRestoreSession) {
                        recreateChatSession();
                        isAppSessionActive = false;
                    } else {
                        onSessionCreated(true);
                        isAppSessionActive = true;
                    }
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private void recreateChatSession() {
        Log.d(TAG, "Need to recreate chat session");

        try {
            QBUser user = PrefManager.getInstance(BaseActivity.this).getQbUser();
            if (user == null) {
                throw new RuntimeException("User is null, can't restore session");
            }

            login(user);
        } catch (RuntimeException e) {
            e.printStackTrace();
        }

    }

    private void login(final QBUser user) {

        try {
            final QBChatService chatService = QBChatService.getInstance();

            QBAuth.createSession(user, new QBEntityCallback<QBSession>() {
                @Override
                public void onSuccess(final QBSession session, Bundle params) {
                    // success, login to chat

                    user.setId(session.getUserId());
                    Log.e("session", session.getToken());
                    chatService.login(user, new QBEntityCallback() {

                        @Override
                        public void onSuccess(Object o, Bundle bundle) {
                            isAppSessionActive = true;
                            onSessionCreated(true);
                        }

                        @Override
                        public void onError(QBResponseException e) {
                            onSessionCreated(false);
                        }
                    });
                }

                @Override
                public void onError(QBResponseException errors) {

                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    @Override
    protected void onResume() {
        super.onResume();

    }
}