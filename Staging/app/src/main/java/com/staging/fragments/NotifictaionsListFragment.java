package com.staging.fragments;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.PushNotificationAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.loadmore_listview.LoadMoreListView;
import com.staging.models.PushNotificationObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.DateTimeFormatClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;

/**
 * Created by neelmani.karn on 6/1/2016.
 */
public class NotifictaionsListFragment extends Fragment implements AsyncTaskCompleteListener<String> {

    String ExtraMessageForAddTeamMember="";
    String StartupId = "";
    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private PushNotificationAdapter adapter;
    private LoadMoreListView list_notifications;
    private ArrayList<PushNotificationObject> notificationObjectArrayList;
    String connectionUserId = "";
    String connectionConnectionID = "";
    String connectionStatus = "";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_archive_notifications, container, false);

        try {

            updateNotificationCount();
            notificationObjectArrayList = new ArrayList<PushNotificationObject>();
            list_notifications = (LoadMoreListView) rootView.findViewById(R.id.list_notificaitons);


            /*if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.LIST_OF_ALL_NOTIFICATIONS_TAG, Constants.LIST_OF_ALL_NOTIFICATIONS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET);
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }*/


            list_notifications.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
                @Override
                public void onLoadMore() {
                    current_page += 1;
                    if (TOTAL_ITEMS != adapter.getCount()) {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.LIST_OF_ALL_NOTIFICATIONS_TAG, Constants.LIST_OF_ALL_NOTIFICATIONS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    } else {
                        list_notifications.onLoadMoreComplete();
                        //  ((HomeActivity) getActivity()).dismissProgressDialog();
                    }
                }
            });

            list_notifications.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {
                    if (notificationObjectArrayList.get(position).getNotificationType().equalsIgnoreCase(Constants.NOTIFICATION_MESSAGE_TAG)) {
                        Fragment fragment = new MessagesFragment();
                        ((HomeActivity) getActivity()).replaceFragment(fragment);
                    } else if (notificationObjectArrayList.get(position).getNotificationType().equalsIgnoreCase(Constants.NOTIFICATION_COMMIT_CAMPAIGN_TAG) || notificationObjectArrayList.get(position).getNotificationType().equalsIgnoreCase(Constants.NOTIFICATION_UNCOMMIT_CAMPAIGN_TAG)) {
                        Fragment fragment = new ViewContractorsFragment();
                        Bundle bundle = new Bundle();
                        try {
                            //Log.e("values", "" + data.get("values"));
                            JSONObject values = notificationObjectArrayList.get(position).getValues();
                            // Log.e("values", data.getString("values"));
                            bundle.putString("CAMPAIGN_NAME", values.getString("campaign_name"));
                            bundle.putString("CAMPAIGN_ID", values.getString("campaign_id"));
                            bundle.putString("CommingFrom", "EditCampaign");
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }


                        //bundle.putString("home", "home");
                        fragment.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(fragment);
                    } else if (notificationObjectArrayList.get(position).getNotificationType().equalsIgnoreCase(Constants.NOTIFICATION_RATE_PROFILE)) {
                        Fragment fragment = new ViewContractorPublicProfileFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("COMMING_FROM", "home");
                        fragment.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(fragment);
                    } else if (notificationObjectArrayList.get(position).getNotificationType().equalsIgnoreCase(Constants.NOTIFICATION_COMMENT_FOURM)) {
                        Fragment fragment = new ForumDetailsFragment();
                        Bundle bundle = new Bundle();

                        try {
                            //Log.e("values", "" + data.get("values"));
                            JSONObject values = notificationObjectArrayList.get(position).getValues();
                            // Log.e("values", data.getString("values"));
                            bundle.putString("forum_id", values.getString("forum_id"));
                            bundle.putString("TITLE", values.getString("forum_name"));
                            bundle.putString("COMMING_FROM", "MyForums");
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                        fragment.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(fragment);
                    } else if (notificationObjectArrayList.get(position).getNotificationType().equalsIgnoreCase(Constants.NOTIFICATION_ADD_TEAM_MEMBER)) {
                        if (!notificationObjectArrayList.get(position).getNotificationStatus().trim().isEmpty()){
                            Toast.makeText(getActivity(),"You have already perfomed this operation", Toast.LENGTH_LONG).show();
                        }else{
                            JSONObject values;
                            try {
                                values = notificationObjectArrayList.get(position).getValues();
                                StartupId = values.getString("startup_id");
                                ExtraMessageForAddTeamMember = values.getString("extra_message");
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }

                            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
                            builder.setTitle("Do you want to work with this team?");
                            builder.setMessage(ExtraMessageForAddTeamMember)
                                    .setCancelable(false)
                                    .setNeutralButton("Later", new DialogInterface.OnClickListener() {

                                        @Override
                                        public void onClick(DialogInterface dialog, int arg1) {
                                            dialog.dismiss();
                                        }
                                    })
                                    .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                        @Override
                                        public void onClick(DialogInterface dialog, int arg1) {
                                            //dialog.cancel();
                                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                                ((HomeActivity) getActivity()).showProgressDialog();
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&startup_id=" + StartupId + "&status=" + "1" + "&loggedin_user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+ "&notification_id=" + notificationObjectArrayList.get(position).getNotificationId(), Constants.HTTP_GET,"Home Activity");
                                                a.execute();
                                                dialog.dismiss();
                                            } else {
                                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                            }
                                        }
                                    })
                                    .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                        @Override
                                        public void onClick(DialogInterface dialog, int arg1) {
                                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                                ((HomeActivity) getActivity()).showProgressDialog();
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&startup_id=" + StartupId + "&status=" + "3" + "&loggedin_user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+ "&notification_id=" + notificationObjectArrayList.get(position).getNotificationId(), Constants.HTTP_GET,"Home Activity");
                                                a.execute();
                                                dialog.dismiss();
                                            } else {
                                                dialog.dismiss();
                                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                            }
                                        }
                                    });

                            AlertDialog dialog = builder.create();
                            dialog.show();
                        }



                    }

                    else if (notificationObjectArrayList.get(position).getNotificationType().equalsIgnoreCase(Constants.NOTIFICATION_ADD_CONNECTION)) {
                        if (!notificationObjectArrayList.get(position).getNotificationStatus().trim().isEmpty()){
                            Toast.makeText(getActivity(),"You have already perfomed this operation", Toast.LENGTH_LONG).show();
                        }else{
                            JSONObject values;
                            try {
                                values = notificationObjectArrayList.get(position).getValues();
                                connectionUserId = values.getString("user_id");
                                connectionConnectionID = values.getString("connection_id");
                                connectionStatus = values.getString("status");
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }

                            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
                            builder.setTitle("Connection Request");
                            builder.setMessage("Do you want to connect with this user?")
                                    .setCancelable(false)

                                    .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                        @Override
                                        public void onClick(DialogInterface dialog, int arg1) {
                                            //dialog.cancel();
                                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                                ((HomeActivity) getActivity()).showProgressDialog();
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ACCEPT_CONNECTION_USER_TAG, Constants.ACCEPT_CONNECTION_USER_URL + "?user_id=" + connectionUserId + "&connection_id=" + connectionConnectionID + "&status=1", Constants.HTTP_GET, "Home Activity");
                                                a.execute();
                                                dialog.dismiss();
                                            } else {
                                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                            }

                                        }
                                    })
                                    .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                        @Override
                                        public void onClick(DialogInterface dialog, int arg1) {
                                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                                ((HomeActivity) getActivity()).showProgressDialog();
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.DISCONNECT_USER_TAG, Constants.DISCONNECT_USER_URL + "?user_id=" + connectionUserId + "&connection_id=" + connectionConnectionID, Constants.HTTP_GET, "Home Activity");
                                                a.execute();
                                                dialog.dismiss();
                                            } else {
                                                dialog.dismiss();
                                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                            }
                                        }
                                    });

                            AlertDialog dialog = builder.create();
                            dialog.show();
                        }



                    }



                    else if (notificationObjectArrayList.get(position).getNotificationType().equalsIgnoreCase(Constants.NOTIFICATION_REPORT_ABUSE_FORUM_MEMBER)) {
                        Fragment fragment = new ForumDetailsFragment();
                        Bundle bundle = new Bundle();

                        try {

                            JSONObject values = notificationObjectArrayList.get(position).getValues();
                            // Log.e("values", data.getString("values"));
                            bundle.putString("forum_id", values.getString("forum_id"));
                            bundle.putString("TITLE", values.getString("forum_name"));
                            if (values.getBoolean("own_forum")) {
                                bundle.putString("COMMING_FROM", "MyForums");
                            } else {
                                bundle.putString("COMMING_FROM", "Common");
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                        fragment.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(fragment);
                    } else if (notificationObjectArrayList.get(position).getNotificationType().equalsIgnoreCase(Constants.NOTIFICATION_REPORT_ABUSE_FORUM)) {
                        Fragment fragment = new ForumDetailsFragment();
                        Bundle bundle = new Bundle();

                        try {

                            JSONObject values = notificationObjectArrayList.get(position).getValues();
                            // Log.e("values", data.getString("values"));
                            bundle.putString("forum_id", values.getString("forum_id"));
                            bundle.putString("TITLE", values.getString("forum_name"));
                            bundle.putString("COMMING_FROM", "MyForums");
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                        fragment.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(fragment);
                    }
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rootView;
    }

    private void updateNotificationCount(){


        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

            Async a = new Async((HomeActivity) getActivity(), (AsyncTaskCompleteListener<String>) (HomeActivity) getActivity(), Constants.USER_NOTIFICATION_COUNT_UPDATE_TAG, Constants.USER_NOTIFICATION_COUNT_UPDATE_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET, "Home Activity");
            a.execute();

        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }
    }
    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle("Notifications");
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);

        try {
            current_page = 1;
            notificationObjectArrayList = new ArrayList<PushNotificationObject>();
            notificationObjectArrayList.clear();
            adapter = null;
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.LIST_OF_ALL_NOTIFICATIONS_TAG, Constants.LIST_OF_ALL_NOTIFICATIONS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

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
                if (tag.equalsIgnoreCase(Constants.LIST_OF_ALL_NOTIFICATIONS_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();

                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));
                            if (jsonObject.getJSONArray("notification").length() == 0) {
                                Toast.makeText(getActivity(), "No any notifications received.", Toast.LENGTH_LONG).show();
                            } else {
                                for (int i = 0; i < jsonObject.getJSONArray("notification").length(); i++) {
                                    JSONObject notification = jsonObject.getJSONArray("notification").getJSONObject(i);

                                    PushNotificationObject obj = new PushNotificationObject();
                                    obj.setNotificationStatus(notification.getString("status"));
                                    obj.setNotificationId(notification.getString("id"));
                                    String val = notification.getString("values");
                                    obj.setValues(new JSONObject(val));
                                    obj.setNotificationType(notification.getString("tags"));
                                    obj.setNotificationTitle(notification.getString("message"));
                                    if (notification.getString("time").trim().length() == 0) {
                                        obj.setNotificationTime(DateTimeFormatClass.convertDateObjectToMMDDYYYFormat(new Date()));
                                    } else {
                                        obj.setNotificationTime(DateTimeFormatClass.convertStringObjectToMMMDDYYYYFormat(notification.getString("time").trim()));
                                    }

                                    notificationObjectArrayList.add(obj);

                                    /*adapter = new PushNotificationAdapter(getActivity(), notificationObjectArrayList);
                                    list_notifications.setAdapter(adapter);*/



                                    if (adapter == null) {
                                        adapter = new PushNotificationAdapter(getActivity(), notificationObjectArrayList);
                                        list_notifications.setAdapter(adapter);
                                    }


                                    list_notifications.onLoadMoreComplete();
                                    adapter.notifyDataSetChanged();

                                    int index = list_notifications.getLastVisiblePosition();
                                    list_notifications.smoothScrollToPosition(index);



                                }
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No any notifications received.", Toast.LENGTH_LONG).show();
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
                else if(tag.equalsIgnoreCase(Constants.USER_NOTIFICATION_COUNT_UPDATE_TAG)){

                    try {
                        final JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
//                            Log.e("XXX","SUCCESS IN UPDATING COUNT");
                        }
                        else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }

                        }
                    catch (Exception e){


                    }


                }
                else if (tag.equalsIgnoreCase(Constants.STARTUP_TEAM_MEMBER_STATUS_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        final JSONObject jsonObject = new JSONObject(result);
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            notificationObjectArrayList.clear();
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.LIST_OF_ALL_NOTIFICATIONS_TAG, Constants.LIST_OF_ALL_NOTIFICATIONS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
                            a.execute();
                            Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                        }

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
                else if (tag.equalsIgnoreCase(Constants.DISCONNECT_USER_TAG)) {
                    ((HomeActivity)getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "User disconnected successfully.", Toast.LENGTH_SHORT).show();


                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "Could not send request. Please Try after some time.", Toast.LENGTH_SHORT).show();
                        }


                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.ACCEPT_CONNECTION_USER_TAG)) {
                    ((HomeActivity)getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "User connected successfully.", Toast.LENGTH_SHORT).show();


                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "Could not send request. Please Try after some time.", Toast.LENGTH_SHORT).show();
                        }


                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }


            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }catch (Exception e) {
            e.printStackTrace();
        }
    }
}
