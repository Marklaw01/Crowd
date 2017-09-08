package com.staging.fragments;

import android.app.Dialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.CheckboxQuickBloxContactsAdapter;
import com.staging.chat.QbDialogUtils;
import com.staging.chat.adapter.DialogsAdapter;
import com.staging.chat.callback.QbEntityCallbackTwoTypeWrapper;
import com.staging.chat.callback.QbEntityCallbackWrapper;
import com.staging.models.ContactsObject;
import com.staging.utilities.Constants;
import com.quickblox.chat.QBChatService;
import com.quickblox.chat.model.QBDialog;
import com.quickblox.chat.model.QBDialogType;
import com.quickblox.core.QBEntityCallback;
import com.quickblox.core.exception.QBResponseException;
import com.quickblox.core.request.QBPagedRequestBuilder;
import com.quickblox.core.request.QBRequestGetBuilder;
import com.quickblox.users.QBUsers;
import com.quickblox.users.model.QBUser;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Created by neelmani.karn on 5/17/2016.
 */
public class RecentChatFragment extends Fragment {

    private QBRequestGetBuilder requestBuilder;
    /*private static final String ORDER_RULE = "order";
    private static final String ORDER_VALUE = "desc date created_at";
    private static final int LIMIT_USERS = 50;*/
    public static final int MINIMUM_CHAT_OCCUPANTS_SIZE = 2;

    private ArrayList<ContactsObject> users;
    private ListView list_contacts;
    private DialogsAdapter dialogsAdapter;
    FloatingActionButton fab_dialogs_new_chat;
    ArrayList<QBDialog> chatDialogs;
    //ArrayList<QBUser> users;
    private CheckboxQuickBloxContactsAdapter adapter;

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            try {
                // we check that the fragment is becoming visible
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();
                    requestBuilder = new QBRequestGetBuilder();
                    chatDialogs = new ArrayList<QBDialog>();
                    getDialogs(requestBuilder, new QBEntityCallback<ArrayList<QBDialog>>() {

                        @Override
                        public void onSuccess(ArrayList<QBDialog> qbDialogs, Bundle bundle) {

                            //QbDialogHolder.getInstance().addDialogs(qbDialogs);
                            try {
                                chatDialogs = qbDialogs;

                                dialogsAdapter = new DialogsAdapter(getActivity(), qbDialogs);
                                list_contacts.setAdapter(dialogsAdapter);
                                dialogsAdapter.notifyDataSetChanged();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            //((HomeActivity) getActivity()).dismissProgressDialog();
                        }

                        @Override
                        public void onError(QBResponseException e) {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                        }
                    });
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_contacts, container, false);

        try {
            chatDialogs = new ArrayList<QBDialog>();
            users = new ArrayList<ContactsObject>();
            fab_dialogs_new_chat = (FloatingActionButton) rootView.findViewById(R.id.fab_dialogs_new_chat);
            list_contacts = (ListView) rootView.findViewById(R.id.list_contacts);
            requestBuilder = new QBRequestGetBuilder();

       /* dialogsAdapter = new DialogsAdapter(getActivity(), chatDialogs);
        list_contacts.setAdapter(dialogsAdapter);*/

            list_contacts.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                    QBDialog selectedDialog = (QBDialog) parent.getItemAtPosition(position);

                    Fragment addContributor = new ChatFragment();

                    Bundle bundle = new Bundle();
                    bundle.putSerializable("dialog", selectedDialog);
                    addContributor.setArguments(bundle);
                    ((HomeActivity)getActivity()).replaceFragment(addContributor);
                    /*FragmentTransaction transactionAdd = getParentFragment().getFragmentManager().beginTransaction();
                    transactionAdd.replace(R.id.container, addContributor);
                    transactionAdd.addToBackStack(null);

                    transactionAdd.commit();*/
                }
            });


        /*((HomeActivity)getActivity()).toolbarTitle.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(getActivity(),"Hello", Toast.LENGTH_LONG).show();
            }
        });*/


            fab_dialogs_new_chat.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    try {
                        final Dialog dialog = new Dialog(getActivity());
                        dialog.setContentView(R.layout.create_group_chat_dialog);
                        dialog.setTitle("Create New Group");
                        dialog.setCancelable(false);
                        //                dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
                        final ProgressBar progressBar = (ProgressBar) dialog.findViewById(R.id.progress_chat);
                        progressBar.setVisibility(View.GONE);
                        final EditText name = (EditText) dialog.findViewById(R.id.groupName);
                        final ListView lv = (ListView) dialog.findViewById(R.id.select_users_list);
                        lv.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);
                        new AsyncTask<Void, Void, String>() {

                            @Override
                            protected void onPreExecute() {
                                super.onPreExecute();
                                ((HomeActivity) getActivity()).showProgressDialog();
                            }

                            @Override
                            protected String doInBackground(Void... params) {

                                String json = ((HomeActivity) getActivity()).utilitiesClass.getJSON(Constants.LIST_OF_ALL_QUICKBLOX_USERS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                                return json;
                            }

                            @Override
                            protected void onPostExecute(String result) {
                                super.onPostExecute(result);
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                                if (result != null) {
                                    try {
                                        JSONObject jsonObject = new JSONObject(result);
                                        users.clear();
                                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                                            for (int i = 0; i < jsonObject.getJSONArray("users").length(); i++) {
                                                ContactsObject obj = new ContactsObject();
                                                obj.setImage(Constants.APP_IMAGE_URL + jsonObject.getJSONArray("users").getJSONObject(i).getString("userimage"));
                                                obj.setName(jsonObject.getJSONArray("users").getJSONObject(i).getString("username"));
                                                obj.setQuickbloxid(Integer.parseInt(jsonObject.getJSONArray("users").getJSONObject(i).getString("quickbloxid")));
                                                users.add(obj);
                                            }

                                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                                            Toast.makeText(getActivity(), "No Contacts Available for Chat", Toast.LENGTH_LONG).show();
                                        }
                                        //((HomeActivity)getActivity()).dismissProgressDialog();
                                        //progressBar.setVisibility(View.GONE);
                                        adapter = new CheckboxQuickBloxContactsAdapter(getActivity(), users);
                                        lv.setAdapter(adapter);
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                }
                            }
                        }.execute();


                        TextView dialogCancelButton = (TextView) dialog.findViewById(R.id.button_cancel);
                        TextView dialogButton = (TextView) dialog.findViewById(R.id.buttonCreateGroup);

                        dialogCancelButton.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {

                                //contactsTask.cancel(true);
                                dialog.dismiss();
                            }
                        });
                        dialogButton.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {

                                if (adapter != null) {
                                    ArrayList<ContactsObject> selectedUser = adapter.getSelectedUsers();

                                    if (selectedUser.size() <= MINIMUM_CHAT_OCCUPANTS_SIZE) {
                                        if (name.getText().toString().trim().isEmpty()) {
                                            Toast.makeText(getActivity(), "Enter group chat name", Toast.LENGTH_LONG).show();
                                        } else {
                                            ((HomeActivity) getActivity()).showProgressDialog();
                                            createDialogWithSelectedUsers(name.getText().toString().trim(), selectedUser, new QBEntityCallback<QBDialog>() {

                                                @Override
                                                public void onSuccess(QBDialog qbDialog, Bundle bundle) {
                                                    if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                                                        ((HomeActivity) getActivity()).dismissProgressDialog();
                                                    }
                                                    dialog.dismiss();
                                                }

                                                @Override
                                                public void onError(QBResponseException e) {
                                                    if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                                                        ((HomeActivity) getActivity()).dismissProgressDialog();
                                                    }
                                                    dialog.dismiss();
                                                }
                                            });
                                        }


                                    } else {
                                        //
                                        Toast.makeText(getActivity(), getString(R.string.select_users_choose_users), Toast.LENGTH_LONG).show();
                                    }
                                }
                                //dialog.dismiss();
                            }
                        });

                        dialog.show();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }


        return rootView;
    }


    private void loadUsersFromQb() {

    }

    public void getDialogs(QBRequestGetBuilder customObjectRequestBuilder, final QBEntityCallback<ArrayList<QBDialog>> callback) {
        customObjectRequestBuilder.setLimit(100);



        //QBChatService.getChatDialogs()


        QBChatService.getChatDialogs(null, customObjectRequestBuilder, new QbEntityCallbackWrapper<ArrayList<QBDialog>>(callback) {
            @Override
            public void onSuccess(ArrayList<QBDialog> dialogs, Bundle args) {

                try {
                    Iterator<QBDialog> dialogIterator = dialogs.iterator();
                    while (dialogIterator.hasNext()) {
                        QBDialog dialog = dialogIterator.next();
                        if (dialog.getType() == QBDialogType.PUBLIC_GROUP) {
                            dialogIterator.remove();
                        }

                    }

                    for (QBDialog dialog : dialogs) {
                        dialog.setId(dialog.getDialogId().hashCode());
                    }
                    dialogsAdapter = new DialogsAdapter(getActivity(), chatDialogs);
                    list_contacts.setAdapter(dialogsAdapter);
                    dialogsAdapter.notifyDataSetChanged();
                    getUsersFromDialogs(dialogs, callback);
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    // Not calling super.onSuccess() because
                    // we want to load chat users before triggering callback
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }


    private void getUsersFromDialogs(final ArrayList<QBDialog> dialogs,
                                     final QBEntityCallback<ArrayList<QBDialog>> callback) {
        List<Integer> userIds = new ArrayList<>();
        for (QBDialog dialog : dialogs) {
            userIds.addAll(dialog.getOccupants());
            userIds.add(dialog.getLastMessageUserId());
        }

        QBPagedRequestBuilder requestBuilder = new QBPagedRequestBuilder(userIds.size(), 1);
        QBUsers.getUsersByIDs(userIds, requestBuilder,
                new QbEntityCallbackTwoTypeWrapper<ArrayList<QBUser>, ArrayList<QBDialog>>(callback) {
                    @Override
                    public void onSuccess(ArrayList<QBUser> users, Bundle params) {
                        //QbUsersHolder.getInstance().putUsers(users);
                        onSuccessInMainThread(dialogs, params);
                    }
                });
    }


    public void createDialogWithSelectedUsers(String dialogName, final ArrayList<ContactsObject> users, final QBEntityCallback<QBDialog> callback) {
        QBChatService.getInstance().getGroupChatManager().createDialog(QbDialogUtils.createDialog(users, dialogName), new QbEntityCallbackWrapper<QBDialog>(callback) {
                    @Override
                    public void onSuccess(QBDialog dialog, Bundle args) {
                        //QbUsersHolder.getInstance().putUsers(users);
                        super.onSuccess(dialog, args);
                        try {
                            Fragment addContributor = new ChatFragment();

                            Bundle bundle = new Bundle();
                            bundle.putSerializable("dialog", dialog);
                            addContributor.setArguments(bundle);
                            ((HomeActivity)getActivity()).replaceFragment(addContributor);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        /*FragmentTransaction transactionAdd = getParentFragment().getFragmentManager().beginTransaction();
                        transactionAdd.replace(R.id.container, addContributor);
                        transactionAdd.addToBackStack(null);
                        transactionAdd.commit();*/
                    }
                }
        );
    }
}