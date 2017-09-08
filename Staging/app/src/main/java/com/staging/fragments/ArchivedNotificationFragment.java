package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.MessagesAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.loadmore_listview.LoadMoreListView;
import com.staging.models.NotificationObject;
import com.staging.models.StartupsObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.DateTimeFormatClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/19/2016.
 */
public class ArchivedNotificationFragment extends Fragment implements AsyncTaskCompleteListener<String> {

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    int pos = 0;

    private LoadMoreListView listView;

    private ArrayList<StartupsObject> mapArrayList;
    private ArrayList<NotificationObject> list;
    private MessagesAdapter adapter;

    public ArchivedNotificationFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        try {
            ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.archivedMessages));
            ((HomeActivity) getActivity()).setOnBackPressedListener(this);

            current_page = 1;
            list = new ArrayList<NotificationObject>();
            list.clear();
            adapter = null;
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_ARCHIEVED_MESSAGES_TAG, Constants.USER_ARCHIEVED_MESSAGES_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET, "Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_archive_notifications, container, false);
        try {
            listView = (LoadMoreListView) rootView.findViewById(R.id.list_notificaitons);

            list = new ArrayList<NotificationObject>();

            listView.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
                public void onLoadMore() {
                    // Do the work to load more items at the end of list
                    // here
                    //

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                        current_page += 1;
                        if (TOTAL_ITEMS != adapter.getCount()) {
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_ARCHIEVED_MESSAGES_TAG, Constants.USER_ARCHIEVED_MESSAGES_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
                            a.execute();
                        } else {
                            listView.onLoadMoreComplete();
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                        }
                    } else {
                        listView.onLoadMoreComplete();
                        adapter.notifyDataSetChanged();
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootView;
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
                if (tag.equalsIgnoreCase(Constants.USER_ARCHIEVED_MESSAGES_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);


                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));
                            if (jsonObject.optJSONArray("Messages").length() != 0) {
                                for (int i = 0; i < jsonObject.optJSONArray("Messages").length(); i++) {
                                    JSONObject messages = jsonObject.optJSONArray("Messages").getJSONObject(i);
                                    NotificationObject obj = new NotificationObject();

                                    obj.setId(messages.optString("id"));
                                    obj.setName(messages.optString("title"));
                                    obj.setSender(messages.optString("sender"));
                                    obj.setDescriptoin(messages.optString("description"));
                                    obj.setCreatedTime(DateTimeFormatClass.convertStringObjectToAMPMTimeFormat(messages.optString("time")));
                                    obj.setCreatedDate(DateTimeFormatClass.convertStringObjectToMMMDDYYYYFormat(messages.optString("time")));
                                    list.add(obj);

                                }
                            } else {
                                Toast.makeText(getActivity(), "No message received", Toast.LENGTH_LONG).show();
                            }


                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No message received", Toast.LENGTH_LONG).show();
                        }

                        if (adapter == null) {
                            adapter = new MessagesAdapter(getActivity(), list);
                            listView.setAdapter(adapter);
                        }


                        listView.onLoadMoreComplete();
                        adapter.notifyDataSetChanged();

                        int index = listView.getLastVisiblePosition();
                        listView.smoothScrollToPosition(index);

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