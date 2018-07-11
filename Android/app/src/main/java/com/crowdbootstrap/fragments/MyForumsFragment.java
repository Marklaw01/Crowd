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
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.adapter.MyForumsAdapter;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.loadmore_listview.LoadMoreListView;
import com.crowdbootstrap.models.MyForumsObject;
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
 * Created by neelmani.karn on 1/13/2016.
 */
public class MyForumsFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    int pos = 0;
    private Button btn_addCampaign;
    private MyForumsAdapter mAdapter;
    private SwipeMenuListView mListView;

    private ArrayList<MyForumsObject> list;

    public MyForumsFragment() {
        super();
    }


    /*@Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.myForum));
    }*/
    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            try {
                // we check that the fragment is becoming visible
                //((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.recommended));
                ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                current_page = 1;
                list = new ArrayList<MyForumsObject>();
                list.clear();
                mAdapter = null;
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.MY_FORUMS_TAG, Constants.MY_FORUMS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_POST,"Home Activity");
                    a.execute();
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.showSettingsAlert();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_my_forums, container, false);

        try {
            btn_addCampaign = (Button) rootView.findViewById(R.id.btn_addForum);
            list = new ArrayList<MyForumsObject>();
            mListView = (SwipeMenuListView) rootView.findViewById(R.id.listView);

            btn_addCampaign.setOnClickListener(this);


            mListView.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
                public void onLoadMore() {
                    // Do the work to load more items at the end of list
                    // here
                    //
                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        //((HomeActivity) getActivity()).showProgressDialog();
                        current_page += 1;
                        if (TOTAL_ITEMS != mAdapter.getCount()) {
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.MY_FORUMS_TAG, Constants.MY_FORUMS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_POST,"Home Activity");
                            a.execute();
                        } else {
                            mListView.onLoadMoreComplete();
                            //  ((HomeActivity) getActivity()).dismissProgressDialog();
                        }

                    } else {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        mListView.onLoadMoreComplete();
                        mAdapter.notifyDataSetChanged();
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                }
            });

            // step 1. create a MenuCreator
            SwipeMenuCreator creator = new SwipeMenuCreator() {

                @Override
                public void create(SwipeMenu menu) {
                    // create "open" item
                    SwipeMenuItem close = new SwipeMenuItem(getActivity().getApplicationContext());
                    Drawable id = getResources().getDrawable(R.color.darkGrey);
                    close.setBackground(id);
                    close.setIcon(getResources().getDrawable(R.drawable.close));
                    // set item width
                    close.setWidth(dp2px(90));
                    // set item title
                    close.setTitle("Close");
                    // set item title fontsize
                    close.setTitleSize(15);
                    // set item title font color
                    close.setTitleColor(Color.WHITE);
                    // add to menu
                    menu.addMenuItem(close);


                    SwipeMenuItem archive = new SwipeMenuItem(getActivity().getApplicationContext());
                    // set item background
                    Drawable arid = getResources().getDrawable(R.color.darkGreen);
                    archive.setBackground(arid);
                    archive.setIcon(getResources().getDrawable(R.drawable.archive));
                    // set item width
                    archive.setWidth(dp2px(90));

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
                    Drawable delid = getResources().getDrawable(R.color.darkRed);
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
                    MyForumsObject item = list.get(position);
                    switch (index) {
                        case 0:
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity(), R.style.MyDialogTheme);

                                alertDialogBuilder
                                        .setMessage("Do you want to close this forum?")
                                        .setCancelable(false)
                                        .setNeutralButton("Cancel", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.dismiss();
                                            }
                                        })
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
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FORUMS_ARCHIEVED_DELETE_TAG, Constants.FORUMS_ARCHIEVED_DELETE_URL + "?forum_id=" + list.get(position).getId() + "&status=" + "3", Constants.HTTP_GET,"Home Activity");
                                                a.execute();
                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                            break;
                        case 1:

                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity(), R.style.MyDialogTheme);

                                alertDialogBuilder
                                        .setMessage("Do you want to archive this forum?")
                                        .setCancelable(false)
                                        .setNeutralButton("Cancel", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.dismiss();
                                            }
                                        })
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
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FORUMS_ARCHIEVED_DELETE_TAG, Constants.FORUMS_ARCHIEVED_DELETE_URL + "?forum_id=" + list.get(position).getId() + "&status=" + "1", Constants.HTTP_GET,"Home Activity");
                                                a.execute();
                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }


                            /*Fragment fragment = new ArchivedForumsFragment();
                            FragmentManager fragmentManager = getParentFragment().getFragmentManager();
                            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.replace(R.id.container, fragment).addToBackStack(null);
                            fragmentTransaction.commit();*/
                            // Toast.makeText(getActivity(), menu.getMenuItem(index).getTitle(), Toast.LENGTH_SHORT).show();
                            break;
                        case 2:
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity(), R.style.MyDialogTheme);

                                alertDialogBuilder
                                        .setMessage("Do you want to delete this forum?")
                                        .setCancelable(false)
                                        .setNeutralButton("Cancel", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.dismiss();
                                            }
                                        })
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
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FORUMS_ARCHIEVED_DELETE_TAG, Constants.FORUMS_ARCHIEVED_DELETE_URL + "?forum_id=" + list.get(position).getId() + "&status=" + "2", Constants.HTTP_GET,"Home Activity");
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


            mListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    Fragment addContributor = new ForumDetailsFragment();

                    Bundle bundle = new Bundle();
                    bundle.putString("forum_id", list.get(position).getId());
                    bundle.putString("COMMING_FROM", "MyForums");
                    bundle.putString("TITLE", list.get(position).getTitle());
                    addContributor.setArguments(bundle);

                    ((HomeActivity) getActivity()).replaceFragment(addContributor);
                    /*FragmentTransaction transactionAdd = getParentFragment().getFragmentManager().beginTransaction();
                    transactionAdd.replace(R.id.container, addContributor);
                    transactionAdd.addToBackStack(null);

                    transactionAdd.commit();*/
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
    public void onClick(View v) {
        try {
            switch (v.getId()) {
                case R.id.btn_addForum:

                    Fragment addContributor = new AddForumFragment();
                    ((HomeActivity) getActivity()).replaceFragment(addContributor);
                    /*FragmentTransaction transactionAdd = getParentFragment().getFragmentManager().beginTransaction();

                    transactionAdd.replace(R.id.container, addContributor);
                    transactionAdd.addToBackStack(null);

                    transactionAdd.commit();*/

                    break;
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
                if (tag.equalsIgnoreCase(Constants.MY_FORUMS_TAG)) {

                    if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    }
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));
                            if (jsonObject.optJSONArray("Forums").length()!=0){
                                for (int i = 0; i < jsonObject.optJSONArray("Forums").length(); i++) {
                                    JSONObject Forums = jsonObject.optJSONArray("Forums").getJSONObject(i);
                                    MyForumsObject obj = new MyForumsObject();
                                    obj.setId(Forums.optString("id"));
                                    obj.setTitle(Forums.optString("forum_title"));
                                    obj.setCreatedBy(Forums.optString("forumCreatedBy"));
                                    obj.setDescription(Forums.optString("description"));
                                    obj.setCreatedTime(DateTimeFormatClass.convertStringObjectToAMPMTimeFormat(Forums.optString("createdTime")));
                                    obj.setCreatedDate(DateTimeFormatClass.convertStringObjectToMMMDDYYYYFormat(Forums.optString("createdTime")));
                                    list.add(obj);
                                }
                            }else{
                                Toast.makeText(getActivity(), "No Forums Created Yet.", Toast.LENGTH_LONG).show();
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No Forums Created Yet.", Toast.LENGTH_LONG).show();
                        }
                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }


                    if (mAdapter == null) {
                        mAdapter = new MyForumsAdapter(getActivity(), list);
                        mListView.setAdapter(mAdapter);
                    }


                    mListView.onLoadMoreComplete();
                    mAdapter.notifyDataSetChanged();

                    int index = mListView.getLastVisiblePosition();
                    mListView.smoothScrollToPosition(index);
                } else if (tag.equalsIgnoreCase(Constants.FORUMS_ARCHIEVED_DELETE_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_LONG).show();

                            list.remove(pos);
                            mAdapter.notifyDataSetChanged();
                        } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }
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