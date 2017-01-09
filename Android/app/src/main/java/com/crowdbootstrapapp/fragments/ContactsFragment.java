package com.crowdbootstrapapp.fragments;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.adapter.ContactsAdapter;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.models.ContactsObject;
import com.crowdbootstrapapp.utilities.Async;
import com.crowdbootstrapapp.utilities.Constants;
import com.quickblox.chat.QBChatService;
import com.quickblox.chat.QBPrivateChatManager;
import com.quickblox.chat.model.QBDialog;
import com.quickblox.core.QBEntityCallback;
import com.quickblox.core.exception.QBResponseException;
import com.quickblox.core.request.QBPagedRequestBuilder;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 2/19/2016.
 */
public class ContactsFragment extends Fragment implements AsyncTaskCompleteListener<String> {
    /*
        private static final String ORDER_RULE = "order";
        private static final String ORDER_VALUE = "desc date created_at";
        private static final int LIMIT_USERS = 100;*/
    //private ArrayList<QBUser> users;
    private ArrayList<ContactsObject> users;
    // private UsersAdapter adapter;
    private ListView list_contacts;

    private QBPrivateChatManager privateChatManager = QBChatService.getInstance().getPrivateChatManager();

    public ContactsFragment() {
        super();
    }

    FloatingActionButton fab_dialogs_new_chat;

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            try {
                // we check that the fragment is becoming visible
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();
                    ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.LIST_OF_ALL_QUICKBLOX_USERS_TAG, Constants.LIST_OF_ALL_QUICKBLOX_USERS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                    a.execute();

                    //getAllUsers();
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
            users = new ArrayList<ContactsObject>();
            // users = new ArrayList<QBUser>();
            fab_dialogs_new_chat = (FloatingActionButton) rootView.findViewById(R.id.fab_dialogs_new_chat);
            fab_dialogs_new_chat.setVisibility(View.GONE);
            list_contacts = (ListView) rootView.findViewById(R.id.list_contacts);
            //Log.e("users", users.toString());

            list_contacts.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    privateChatManager.createDialog(users.get(position).getQuickbloxid(), new QBEntityCallback<QBDialog>() {
                        @Override
                        public void onSuccess(QBDialog dialog, Bundle args) {
                            Fragment addContributor = new ChatFragment();

                            Bundle bundle = new Bundle();
                            bundle.putSerializable("dialog", dialog);
                            addContributor.setArguments(bundle);
                            ((HomeActivity) getActivity()).replaceFragment(addContributor);
                            /*FragmentTransaction transactionAdd = getParentFragment().getFragmentManager().beginTransaction();
                            transactionAdd.replace(R.id.container, addContributor);
                            transactionAdd.addToBackStack(null);

                            transactionAdd.commit();*/
                        }

                        @Override
                        public void onError(QBResponseException errors) {

                        }
                    });
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rootView;
    }

    private QBPagedRequestBuilder qbPagedBuilder;

    /*private void getAllUsers() {

        GenericQueryRule genericQueryRule = new GenericQueryRule(ORDER_RULE, ORDER_VALUE);
        ArrayList<GenericQueryRule> rule = new ArrayList<>();
        rule.add(genericQueryRule);

        qbPagedBuilder = new QBPagedRequestBuilder();
        qbPagedBuilder.setPerPage(LIMIT_USERS);
        qbPagedBuilder.setRules(rule);
        users = new ArrayList<QBUser>();
        QBUsers.getUsers(qbPagedBuilder, new QBEntityCallback<ArrayList<QBUser>>() {
            @Override
            public void onSuccess(ArrayList<QBUser> qbUsers, Bundle bundle) {
                for (int i = 0; i < qbUsers.size(); i++) {
                    if (qbUsers.get(i).getId().equals(((HomeActivity) getActivity()).prefManager.getQbUser().getId())) {
                        continue;
                    }
                    users.add(qbUsers.get(i));
                }

                adapter = new UsersAdapter(getActivity(), users);
                list_contacts.setAdapter(adapter);
                adapter.notifyDataSetChanged();
                ((HomeActivity) getActivity()).dismissProgressDialog();
                //list.setAdapter(new ArrayAdapter<String>(ListActivity.this, android.R.layout.simple_list_item_1, android.R.id.text1, users));

               *//* setOnRefreshListener.setEnabled(true);
                setOnRefreshListener.setRefreshing(false);

                DataHolder.getInstance().addQbUsers(qbUsers);
                qbUsersList = DataHolder.getInstance().getQBUsers();
                progressDialog.dismiss();
                usersListAdapter.updateList(qbUsersList);*//*
            }

            @Override
            public void onError(QBResponseException e) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                *//*progressDialog.dismiss();
                setOnRefreshListener.setEnabled(false);
                setOnRefreshListener.setRefreshing(false);

                View rootLayout = findViewById(R.id.swipy_refresh_layout);
                showSnackbarError(rootLayout, R.string.errors, e, new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        getAllUsers(false);
                    }
                });*//*
            }

        });
    }*/


    @Override
    public void onTaskComplete(String result, String tag) {
        try {
            if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
            } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
            } else {
                if (tag.equalsIgnoreCase(Constants.LIST_OF_ALL_QUICKBLOX_USERS_TAG)) {
                    try {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        JSONObject jsonObject = new JSONObject(result);

                        users.clear();
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            if (jsonObject.getJSONArray("users").length() != 0) {
                                for (int i = 0; i < jsonObject.getJSONArray("users").length(); i++) {
                                    ContactsObject obj = new ContactsObject();
                                    obj.setImage(Constants.APP_IMAGE_URL + jsonObject.getJSONArray("users").getJSONObject(i).getString("userimage"));
                                    obj.setName(jsonObject.getJSONArray("users").getJSONObject(i).getString("username"));
                                    obj.setQuickbloxid(Integer.parseInt(jsonObject.getJSONArray("users").getJSONObject(i).getString("quickbloxid")));
                                    users.add(obj);
                                }
                            } else {
                                Toast.makeText(getActivity(), "No Contacts Available for Chat", Toast.LENGTH_LONG).show();
                            }


                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No Contacts Available for Chat", Toast.LENGTH_LONG).show();
                        }

                        ContactsAdapter adapter = new ContactsAdapter(getActivity(), users);
                        list_contacts.setAdapter(adapter);

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
