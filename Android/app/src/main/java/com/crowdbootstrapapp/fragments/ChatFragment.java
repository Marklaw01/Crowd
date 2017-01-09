package com.crowdbootstrapapp.fragments;

import android.app.Dialog;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.application.CrowdBootstrapApplicationClass;
import com.crowdbootstrapapp.chat.GroupChatImpl;
import com.crowdbootstrapapp.chat.PrivateChatImpl;
import com.crowdbootstrapapp.chat.QbDialogUtils;
import com.crowdbootstrapapp.chat.QbUsersHolder;
import com.crowdbootstrapapp.chat.adapter.ChatAdapter;
import com.crowdbootstrapapp.chat.adapter.UsersAdapter;
import com.crowdbootstrapapp.chat.callback.QbEntityCallbackTwoTypeWrapper;
import com.crowdbootstrapapp.chat.callback.QbEntityCallbackWrapper;
import com.crowdbootstrapapp.chat.interfaces.Chat;
import com.crowdbootstrapapp.chat.interfaces.PaginationHistoryListener;
import com.crowdbootstrapapp.chat.interfaces.QBChatMessageListener;
import com.quickblox.chat.QBChat;
import com.quickblox.chat.QBChatService;
import com.quickblox.chat.model.QBAttachment;
import com.quickblox.chat.model.QBChatMessage;
import com.quickblox.chat.model.QBDialog;
import com.quickblox.chat.model.QBDialogType;
import com.quickblox.core.QBEntityCallback;
import com.quickblox.core.exception.QBResponseException;
import com.quickblox.core.request.QBPagedRequestBuilder;
import com.quickblox.core.request.QBRequestGetBuilder;
import com.quickblox.users.QBUsers;
import com.quickblox.users.model.QBUser;

import org.jivesoftware.smack.ConnectionListener;
import org.jivesoftware.smack.SmackException;
import org.jivesoftware.smack.XMPPException;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import se.emilsjolander.stickylistheaders.StickyListHeadersListView;

//import com.crowdbootstrapapp.chat.QbUsersHolder;

/**
 * Created by neelmani.karn on 2/18/2016.
 */
public class ChatFragment extends Fragment {

    public static final int CHAT_HISTORY_ITEMS_PER_PAGE = 50;
    private static final String CHAT_HISTORY_ITEMS_SORT_FIELD = "date_sent";
    private static final String TAG = ChatFragment.class.getSimpleName();
    private static final int REQUEST_CODE_ATTACHMENT = 721;
    private static final int REQUEST_CODE_SELECT_PEOPLE = 752;

    private static final String EXTRA_DIALOG = "dialog";
    private static final String PROPERTY_SAVE_TO_HISTORY = "save_to_history";

    public static final String EXTRA_MARK_READ = "markRead";
    public static final String EXTRA_DIALOG_ID = "dialogId";

    //private ProgressBar progressBar;
    private StickyListHeadersListView messagesListView;
    private EditText messageEditText;
    private ChatAdapter chatAdapter;
    //private AttachmentPreviewAdapter attachmentPreviewAdapter;
    private ConnectionListener chatConnectionListener;

    private Chat chat;
    private QBDialog qbDialog;
    private ArrayList<String> chatMessageIds;
    private ArrayList<QBChatMessage> unShownMessages;
    private int skipPagination = 0;
    private ImageView button_chat_send;

    private LinearLayout layout, chatInfoLayout;


    @Override
    public void onResume() {
        super.onResume();
        try {
            ((HomeActivity) getActivity()).setActionBarTitle(QbDialogUtils.getDialogName(qbDialog));
            Log.e("addinglistener", "addinglistener");
            addConnectionListener(chatConnectionListener);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void addConnectionListener(ConnectionListener listener) {
        QBChatService.getInstance().addConnectionListener(listener);
    }
    ArrayList<QBUser> users = new ArrayList<QBUser>();

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_chat, container, false);


        try {
            chatInfoLayout = (LinearLayout) rootView.findViewById(R.id.chatInfoLayout);
            button_chat_send = (ImageView) rootView.findViewById(R.id.button_chat_send);
            layout = (LinearLayout) rootView.findViewById(R.id.layout);
            qbDialog = (QBDialog) getArguments().getSerializable(EXTRA_DIALOG);
            chatMessageIds = new ArrayList<>();
            messagesListView = (StickyListHeadersListView) rootView.findViewById(R.id.list_chat_messages);
            messageEditText = (EditText) rootView.findViewById(R.id.edit_chat_message);
            //progressBar = (ProgressBar) rootView.findViewById(R.id.progress_chat);

            if (qbDialog.getType().equals(QBDialogType.GROUP)) {
                chatInfoLayout.setVisibility(View.VISIBLE);
            } else if (qbDialog.getType().equals(QBDialogType.PRIVATE)) {
                chatInfoLayout.setVisibility(View.GONE);
            }

            ((HomeActivity)getActivity()).showProgressDialog();
            initChat();
            chatInfoLayout.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    try {
                        final Dialog dialog = new Dialog(getActivity());
                        dialog.setContentView(R.layout.create_group_chat_dialog);
                        dialog.setTitle(qbDialog.getName() + " Members");
                        dialog.setCancelable(false);
    //                dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
                        //((HomeActivity)getActivity()).showProgressDialog();
                        final ProgressBar progressBar = (ProgressBar) dialog.findViewById(R.id.progress_chat);
                        final EditText name = (EditText) dialog.findViewById(R.id.groupName);
                        final ListView lv = (ListView) dialog.findViewById(R.id.select_users_list);
                        name.setVisibility(View.GONE);


                        QBPagedRequestBuilder requestBuilder = new QBPagedRequestBuilder(qbDialog.getOccupants().size(), 1);

                        QBUsers.getUsersByIDs(qbDialog.getOccupants(), requestBuilder, new QBEntityCallback<ArrayList<QBUser>>() {
                            @Override
                            public void onSuccess(ArrayList<QBUser> qbUsers, Bundle bundle) {
                                try {
                                    for (int i = 0; i < qbUsers.size(); i++) {
                                        if (qbUsers.get(i).getId().equals(((HomeActivity) getActivity()).prefManager.getQbUser().getId())) {
                                            continue;
                                        }
                                        users.add(qbUsers.get(i));
                                    }


                                    UsersAdapter adapter = new UsersAdapter(getActivity(), qbUsers);
                                    lv.setAdapter(adapter);
                                    //((HomeActivity)getActivity()).dismissProgressDialog();
                                    progressBar.setVisibility(View.GONE);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }

                            @Override
                            public void onError(QBResponseException e) {
                                //((HomeActivity)getActivity()).dismissProgressDialog();
                                progressBar.setVisibility(View.GONE);
                            }
                        });

                        TextView dialogCancelButton = (TextView) dialog.findViewById(R.id.button_cancel);
                        TextView dialogButton = (TextView) dialog.findViewById(R.id.buttonCreateGroup);
                        dialogButton.setVisibility(View.GONE);
                        dialogCancelButton.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                dialog.dismiss();
                            }
                        });

                        dialog.show();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });

            QBRequestGetBuilder requestBuilder = new QBRequestGetBuilder();
            requestBuilder.setLimit(100);
            requestBuilder.sortDesc(CHAT_HISTORY_ITEMS_SORT_FIELD);

            button_chat_send.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    try {
                        String text = messageEditText.getText().toString().trim();
                        if (!TextUtils.isEmpty(text)) {
                            sendChatMessage(text, null);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });

            //((HomeActivity) getActivity()).showProgressDialog();
            QBChatService.getDialogMessages(qbDialog, requestBuilder, new QBEntityCallback<ArrayList<QBChatMessage>>() {
                @Override
                public void onSuccess(ArrayList<QBChatMessage> messages, Bundle args) {

                    try {
                        // The newest messages should be in the end of list,
                        // so we need to reverse list to show messages in the right order

                        Collections.reverse(messages);
                        QBPagedRequestBuilder requestBuilderForUsers = new QBPagedRequestBuilder(qbDialog.getOccupants().size(), 1);

                        QBUsers.getUsersByIDs(qbDialog.getOccupants(), requestBuilderForUsers, new QBEntityCallback<ArrayList<QBUser>>() {
                            @Override
                            public void onSuccess(ArrayList<QBUser> qbUsers, Bundle bundle) {
                                try {
                                    for (int i = 0; i < qbUsers.size(); i++) {
                                        if (qbUsers.get(i).getId().equals(CrowdBootstrapApplicationClass.getPref().getQbUser().getId())) {
                                            continue;
                                        }
                                        users.add(qbUsers.get(i));
                                    }


                                    QbUsersHolder.getInstance().putUsers(users);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                                //progressBar.setVisibility(View.GONE);
                            }

                            @Override
                            public void onError(QBResponseException e) {
                                //progressBar.setVisibility(View.GONE);
                            }
                        });

                        if (chatAdapter == null) {

                            try {
                                chatAdapter = new ChatAdapter(getActivity(), messages, qbDialog);
                                chatAdapter.setPaginationHistoryListener(new PaginationHistoryListener() {
                                    @Override
                                    public void downloadMore() {
                                        //loadChatHistory();
                                    }
                                });
                                chatAdapter.setOnItemInfoExpandedListener(new ChatAdapter.OnItemInfoExpandedListener() {
                                    @Override
                                    public void onItemInfoExpanded(final int position) {
                                        if (isLastItem(position)) {
                                            // HACK need to allow info textview visibility change so posting it via handler
                                            getActivity().runOnUiThread(new Runnable() {
                                                @Override
                                                public void run() {
                                                    messagesListView.setSelection(position);
                                                }
                                            });
                                        } else {
                                            messagesListView.smoothScrollToPosition(position);
                                        }
                                    }

                                    private boolean isLastItem(int position) {
                                        return position == chatAdapter.getCount() - 1;
                                    }
                                });
                                if (unShownMessages != null && !unShownMessages.isEmpty()) {
                                    List<QBChatMessage> chatList = chatAdapter.getList();
                                    for (QBChatMessage message : unShownMessages) {
                                        if (!chatList.contains(message)) {
                                            chatAdapter.add(message);
                                        }
                                    }
                                }

                                QBPagedRequestBuilder requestBuilder = new QBPagedRequestBuilder(qbDialog.getOccupants().size(), 1);

                                QBUsers.getUsersByIDs(qbDialog.getOccupants(), requestBuilder, new QBEntityCallback<ArrayList<QBUser>>() {
                                    @Override
                                    public void onSuccess(ArrayList<QBUser> qbUsers, Bundle bundle) {
                                        try {
                                            for (int i = 0; i < qbUsers.size(); i++) {
                                                try {
                                                    if (qbUsers.get(i).getId().equals(CrowdBootstrapApplicationClass.getPref().getQbUser().getId())) {
                                                        continue;
                                                    }
                                                } catch (Exception e) {
                                                    e.printStackTrace();
                                                }
                                                users.add(qbUsers.get(i));
                                            }


                                            QbUsersHolder.getInstance().putUsers(users);
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                        //progressBar.setVisibility(View.GONE);
                                    }

                                    @Override
                                    public void onError(QBResponseException e) {
                                        //progressBar.setVisibility(View.GONE);
                                    }
                                });


                                messagesListView.setAdapter(chatAdapter);
                                messagesListView.setAreHeadersSticky(false);
                                messagesListView.setDivider(null);
                                if (((HomeActivity)getActivity()).isShowingProgressDialog()){
                                    ((HomeActivity)getActivity()).dismissProgressDialog();
                                }
                                messagesListView.setSelection(messages.size()-1);
                                //progressBar.setVisibility(View.GONE);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        } else {
                            try {
                                chatAdapter.addList(messages);
                                messagesListView.setSelection(messages.size()-1);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                        //messagesListView.setSelection(messages.size());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void onError(QBResponseException e) {
                    if (((HomeActivity)getActivity()).isShowingProgressDialog()){
                        ((HomeActivity)getActivity()).dismissProgressDialog();
                    }
                    skipPagination -= CHAT_HISTORY_ITEMS_PER_PAGE;
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootView;
    }


    @Override
    public void onSaveInstanceState(Bundle outState) {
        if (qbDialog != null) {
            outState.putSerializable(EXTRA_DIALOG, qbDialog);
        }
        super.onSaveInstanceState(outState);
    }


    public ChatFragment() {
        super();
    }

    public void loadChatHistory(QBDialog dialog, int skipPagination, final QBEntityCallback<ArrayList<QBChatMessage>> callback) {
        try {
            QBRequestGetBuilder customObjectRequestBuilder = new QBRequestGetBuilder();
            customObjectRequestBuilder.setSkip(skipPagination);
            customObjectRequestBuilder.setLimit(CHAT_HISTORY_ITEMS_PER_PAGE);
            customObjectRequestBuilder.sortDesc(CHAT_HISTORY_ITEMS_SORT_FIELD);

            QBChatService.getDialogMessages(dialog, customObjectRequestBuilder,
                    new QbEntityCallbackWrapper<ArrayList<QBChatMessage>>(callback) {
                        @Override
                        public void onSuccess(ArrayList<QBChatMessage> qbChatMessages, Bundle bundle) {
                            try {
                                getUsersFromMessages(qbChatMessages, callback);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            // Not calling super.onSuccess() because
                            // we're want to load chat users before triggering the callback
                        }
                    });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void getUsersFromMessages(final ArrayList<QBChatMessage> messages, final QBEntityCallback<ArrayList<QBChatMessage>> callback) {
        try {
            Set<Integer> userIds = new HashSet<>();
            for (QBChatMessage message : messages) {
                userIds.add(message.getSenderId());
            }

            QBPagedRequestBuilder requestBuilder = new QBPagedRequestBuilder(userIds.size(), 1);
            QBUsers.getUsersByIDs(userIds, requestBuilder,
                    new QbEntityCallbackTwoTypeWrapper<ArrayList<QBUser>, ArrayList<QBChatMessage>>(callback) {
                        @Override
                        public void onSuccess(ArrayList<QBUser> users, Bundle params) {
                            //QbUsersHolder.getInstance().putUsers(users);
                            try {
                                onSuccessInMainThread(messages, params);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void loadChatHistory() {
        try {
            loadChatHistory(qbDialog, skipPagination, new QBEntityCallback<ArrayList<QBChatMessage>>() {
                @Override
                public void onSuccess(ArrayList<QBChatMessage> messages, Bundle args) {
                    // The newest messages should be in the end of list,
                    // so we need to reverse list to show messages in the right order
                    Collections.reverse(messages);
                    if (chatAdapter == null) {
                        chatAdapter = new ChatAdapter(getActivity(), messages, qbDialog);
                        chatAdapter.setPaginationHistoryListener(new PaginationHistoryListener() {
                            @Override
                            public void downloadMore() {
                                loadChatHistory();
                            }
                        });
                        chatAdapter.setOnItemInfoExpandedListener(new ChatAdapter.OnItemInfoExpandedListener() {
                            @Override
                            public void onItemInfoExpanded(final int position) {
                                if (isLastItem(position)) {
                                    // HACK need to allow info textview visibility change so posting it via handler
                                    getActivity().runOnUiThread(new Runnable() {
                                        @Override
                                        public void run() {
                                            messagesListView.setSelection(position);
                                        }
                                    });
                                } else {
                                    messagesListView.smoothScrollToPosition(position);
                                }
                            }

                            private boolean isLastItem(int position) {
                                return position == chatAdapter.getCount() - 1;
                            }
                        });
                        if (unShownMessages != null && !unShownMessages.isEmpty()) {
                            List<QBChatMessage> chatList = chatAdapter.getList();
                            for (QBChatMessage message : unShownMessages) {
                                if (!chatList.contains(message)) {
                                    chatAdapter.add(message);
                                }
                            }
                        }
                        messagesListView.setAdapter(chatAdapter);
                        messagesListView.setAreHeadersSticky(false);
                        messagesListView.setDivider(null);
                        if (((HomeActivity)getActivity()).isShowingProgressDialog()){
                            ((HomeActivity)getActivity()).dismissProgressDialog();
                        }
                    } else {
                        chatAdapter.addList(messages);
                        messagesListView.setSelection(messages.size());
                    }
                }

                @Override
                public void onError(QBResponseException e) {
                    if (((HomeActivity)getActivity()).isShowingProgressDialog()){
                        ((HomeActivity)getActivity()).dismissProgressDialog();
                    }
                    skipPagination -= CHAT_HISTORY_ITEMS_PER_PAGE;
                    //snackbar = showErrorSnackbar(R.string.connection_error, e, null);
                }
            });
            skipPagination += CHAT_HISTORY_ITEMS_PER_PAGE;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void onSendChatClick(View view) {
        //sendChatMessage(null, attachment);
        //int totalAttachmentsCount = attachmentPreviewAdapter.getCount();
        //Collection<QBAttachment> uploadedAttachments = attachmentPreviewAdapter.getUploadedAttachments();
       /* if (!uploadedAttachments.isEmpty()) {
            if (uploadedAttachments.size() == totalAttachmentsCount) {
                for (QBAttachment attachment : uploadedAttachments) {

                }
            } else {
                Toaster.shortToast(R.string.chat_wait_for_attachments_to_upload);
            }
        }*/

        String text = messageEditText.getText().toString().trim();
        if (!TextUtils.isEmpty(text)) {
            sendChatMessage(text, null);
        }
    }

    private void sendChatMessage(String text, QBAttachment attachment) {
        QBChatMessage chatMessage = null;
        try {
            chatMessage = new QBChatMessage();
            if (attachment != null) {
                chatMessage.addAttachment(attachment);
            } else {
                chatMessage.setBody(text);
            }
            chatMessage.setProperty(PROPERTY_SAVE_TO_HISTORY, "1");
            chatMessage.setDateSent(System.currentTimeMillis() / 1000);
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            chat.sendMessage(chatMessage);

            if (qbDialog.getType() == QBDialogType.PRIVATE) {
                showMessage(chatMessage);
            }
            messageEditText.setText("");
           /* StringifyArrayList<Integer> userIds = new StringifyArrayList<Integer>();
            for (int i=0;i<qbDialog.getOccupants().size();i++){
                if (qbDialog.getOccupants().get(i).equals(((HomeActivity)getActivity()).prefManager.getQbUser().getId())){
                    continue;
                }
                userIds.add(qbDialog.getOccupants().get(i));
            }
            QBEvent event = new QBEvent();
            event.setUserIds(userIds);
            event.setEnvironment(QBEnvironment.PRODUCTION);
            event.setNotificationType(QBNotificationType.PUSH);
            event.setPushType(QBPushType.GCM);

            event.setMessage(text);

            QBPushNotifications.createEvent(event, new QBEntityCallback<QBEvent>() {
                @Override
                public void onSuccess(QBEvent qbEvent, Bundle args) {
                    // sent
                }

                @Override
                public void onError(QBResponseException errors) {

                }
            });
*/


            /*if (attachment != null) {
                attachmentPreviewAdapter.remove(attachment);
            } else {
                messageEditText.setText("");
            }*/
        } catch (XMPPException | SmackException e) {
            Log.e(TAG, "Failed to send a message", e);
            //Toaster.shortToast(R.string.chat_send_message_error);
        }
    }

    public void showMessage(QBChatMessage message) {
        try {
            if (chatAdapter != null) {
                chatAdapter.add(message);
                scrollMessageListDown();
            } else {
                if (unShownMessages == null) {
                    unShownMessages = new ArrayList<>();
                }
                unShownMessages.add(message);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void scrollMessageListDown() {
        messagesListView.setSelection(messagesListView.getCount() - 1);
    }

    private void initChat() {
        switch (qbDialog.getType()) {
            case GROUP:
            case PUBLIC_GROUP:
                try {
                    chat = new GroupChatImpl(chatMessageListener);
                    joinGroupChat();
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;
            case PRIVATE:
                try {
                    chat = new PrivateChatImpl(chatMessageListener, QbDialogUtils.getOpponentIdForPrivateDialog(qbDialog));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                //loadDialogUsers();
                break;

            default:
                // Toaster.shortToast(String.format("%s %s", getString(R.string.chat_unsupported_type), qbDialog.getType().name()));
                //finish();
                break;
        }
    }

    public void getUsersFromDialog(QBDialog dialog, final QBEntityCallback<ArrayList<QBUser>> callback) {
        try {
            List<Integer> userIds = dialog.getOccupants();

            ArrayList<QBUser> users = new ArrayList<>(userIds.size());
            for (Integer id : userIds) {
                //users.add(QbUsersHolder.getInstance().getUserById(id));
            }


            // If we already have all users in memory
            // there is no need to make REST requests to QB
            if (userIds.size() == users.size()) {
                callback.onSuccess(users, null);
                return;
            }

            QBPagedRequestBuilder requestBuilder = new QBPagedRequestBuilder(userIds.size(), 1);
            QBUsers.getUsersByIDs(userIds, requestBuilder,
                    new QbEntityCallbackWrapper<ArrayList<QBUser>>(callback) {
                        @Override
                        public void onSuccess(ArrayList<QBUser> qbUsers, Bundle bundle) {
                            // QbUsersHolder.getInstance().putUsers(qbUsers);
                            super.onSuccess(qbUsers, bundle);
                        }
                    });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void loadDialogUsers() {
        try {
            getUsersFromDialog(qbDialog, new QBEntityCallback<ArrayList<QBUser>>() {
                @Override
                public void onSuccess(ArrayList<QBUser> users, Bundle bundle) {
                    //setChatNameToActionBar();
                    //loadChatHistory();
                }

                @Override
                public void onError(QBResponseException e) {

                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private QBChatMessageListener chatMessageListener = new QBChatMessageListener() {
        @Override
        public void onQBChatMessageReceived(QBChat chat, QBChatMessage message) {
            try {
                chatMessageIds.add(message.getId());
                showMessage(message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    };

    private void joinGroupChat() {
        //progressBar.setVisibility(View.VISIBLE);
        //((HomeActivity)getActivity()).showProgressDialog();
        /*if (((HomeActivity)getActivity()).isShowingProgressDialog()){

        }*/
        ((GroupChatImpl) chat).joinGroupChat(qbDialog, new QBEntityCallback<Void>() {
            @Override
            public void onSuccess(Void result, Bundle b) {
                if (((HomeActivity)getActivity()).isShowingProgressDialog()){
                    ((HomeActivity)getActivity()).dismissProgressDialog();
                }
                /*if (snackbar != null) {
                    snackbar.dismiss();
                }*/
                //loadDialogUsers();
            }

            @Override
            public void onError(QBResponseException e) {
                //progressBar.setVisibility(View.GONE);
                if (((HomeActivity)getActivity()).isShowingProgressDialog()){
                    ((HomeActivity)getActivity()).dismissProgressDialog();
                }
                //snackbar = showErrorSnackbar(R.string.connection_error, e, null);
            }
        });
    }
}
