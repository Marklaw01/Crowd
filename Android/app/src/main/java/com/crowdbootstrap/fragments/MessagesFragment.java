package com.crowdbootstrap.fragments;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.adapter.MessagesAdapter;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.loadmore_listview.LoadMoreListView;
import com.crowdbootstrap.models.NotificationObject;
import com.crowdbootstrap.swipelistview_withoutscrollview.SwipeMenu;
import com.crowdbootstrap.swipelistview_withoutscrollview.SwipeMenuCreator;
import com.crowdbootstrap.swipelistview_withoutscrollview.SwipeMenuItem;
import com.crowdbootstrap.swipelistview_withoutscrollview.SwipeMenuListView;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;
import com.crowdbootstrap.utilities.DateTimeFormatClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/19/2016.
 */
public class MessagesFragment extends Fragment implements AsyncTaskCompleteListener<String> {

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    int pos = 0;
    private MessagesAdapter adapter;
    private SwipeMenuListView mListView;
    private ArrayList<NotificationObject> list;

    public MessagesFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.messages));

        try {
            current_page = 1;
            list = new ArrayList<NotificationObject>();
            list.clear();
            adapter = null;
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_MESSAGES_TAG, Constants.USER_MESSAGES_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
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
        View rootView = inflater.inflate(R.layout.fragment_messages, container, false);

        try {
            list = new ArrayList<NotificationObject>();
            mListView = (SwipeMenuListView) rootView.findViewById(R.id.listView);


            mListView.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
                public void onLoadMore() {
                    // Do the work to load more items at the end of list
                    // here
                    //

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                        current_page += 1;
                        if (TOTAL_ITEMS != adapter.getCount()) {
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_MESSAGES_TAG, Constants.USER_MESSAGES_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
                            a.execute();
                        } else {
                            mListView.onLoadMoreComplete();
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                        }
                    } else {
                        mListView.onLoadMoreComplete();
                        adapter.notifyDataSetChanged();
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                }
            });

            // step 1. create a MenuCreator
            SwipeMenuCreator creator = new SwipeMenuCreator() {

                @Override
                public void create(SwipeMenu menu) {

                    SwipeMenuItem archive = new SwipeMenuItem(getActivity().getApplicationContext());
                    // set item background
                    Drawable arid = getResources().getDrawable(R.color.green);
                    archive.setBackground(arid);
                    // set item width
                    archive.setWidth(dp2px(90));
                    archive.setIcon(getResources().getDrawable(R.drawable.archive));
                    // set item title
                    archive.setTitle("Archive");
                    // set item title fontsize
                    archive.setTitleSize(15);
                    // set item title font color
                    archive.setTitleColor(Color.WHITE);
                    // add to menu
                    menu.addMenuItem(archive);


                    // create "delete" item
                    SwipeMenuItem deleteItem = new SwipeMenuItem(getActivity().getApplicationContext());
                    // set item background
                    Drawable delid = getResources().getDrawable(R.color.red);
                    deleteItem.setBackground(delid);
                    deleteItem.setIcon(getResources().getDrawable(R.drawable.delete));
                    // set item width
                    deleteItem.setWidth(dp2px(90));
                    // set a icon
                    deleteItem.setTitle("Delete");
                    deleteItem.setTitleSize(15);
                    deleteItem.setTitleColor(Color.WHITE);
                    // add to menu
                    menu.addMenuItem(deleteItem);
                }
            };
            // set creator
            mListView.setMenuCreator(creator);

            // step 2. listener item click event
            mListView.setOnMenuItemClickListener(new SwipeMenuListView.OnMenuItemClickListener() {
                @Override
                public boolean onMenuItemClick(final int position, SwipeMenu menu, int index) {
                    NotificationObject item = list.get(position);
                    switch (index) {
                        case 0:
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                                alertDialogBuilder
                                        .setMessage("Do you want to achieve this message?")
                                        .setCancelable(false)
                                        .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                            }
                                        })
                                        .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                                ((HomeActivity) getActivity()).showProgressDialog();
                                                pos = position;
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_MESSAGES_DELETE_TAG, Constants.USER_MESSAGES_DELETE_URL + "?message_id=" + list.get(position).getId() + "&status=" + "1", Constants.HTTP_GET,"Home Activity");
                                                a.execute();

                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }


                           /* Fragment fragment = new ArchivedNotificationFragment();
                            FragmentManager fragmentManager = getFragmentManager();
                            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.replace(R.id.container, fragment).addToBackStack(null);
                            fragmentTransaction.commit();
                            Toast.makeText(getActivity(), menu.getMenuItem(index).getTitle(), Toast.LENGTH_SHORT).show();*/
                            break;
                        case 1:
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                                alertDialogBuilder
                                        .setMessage("Do you want to delete this message?")
                                        .setCancelable(false)
                                        .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                            }
                                        })
                                        .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                                ((HomeActivity) getActivity()).showProgressDialog();
                                                pos = position;
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_MESSAGES_DELETE_TAG, Constants.USER_MESSAGES_DELETE_URL + "?message_id=" + list.get(position).getId() + "&status=" + "2", Constants.HTTP_GET,"Home Activity");
                                                a.execute();

                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                            break;
                    }
                    return false;
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rootView;
    }

    private int dp2px(int dp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp,
                getResources().getDisplayMetrics());
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
                if (tag.equalsIgnoreCase(Constants.USER_MESSAGES_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));
                            if (jsonObject.optJSONArray("Messages").length()!=0){
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
                            }else{
                                Toast.makeText(getActivity(), "No message received", Toast.LENGTH_LONG).show();
                            }


                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No message received", Toast.LENGTH_LONG).show();
                        }

                        //Collections.reverse(list);

                        if (adapter == null) {
                            adapter = new MessagesAdapter(getActivity(), list);
                            mListView.setAdapter(adapter);
                        }


                        mListView.onLoadMoreComplete();
                        adapter.notifyDataSetChanged();

                        int index = mListView.getLastVisiblePosition();
                        mListView.smoothScrollToPosition(index);

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.USER_MESSAGES_DELETE_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_LONG).show();

                            list.remove(pos);
                            adapter.notifyDataSetChanged();
                        } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

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
