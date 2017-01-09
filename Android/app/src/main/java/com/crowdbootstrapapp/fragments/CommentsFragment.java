package com.crowdbootstrapapp.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.adapter.CommentsAdapter;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.loadmore_listview.LoadMoreListView;
import com.crowdbootstrapapp.models.UserCommentObject;
import com.crowdbootstrapapp.utilities.Async;
import com.crowdbootstrapapp.utilities.Constants;
import com.crowdbootstrapapp.utilities.DateTimeFormatClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 2/19/2016.
 */
public class CommentsFragment extends Fragment implements AsyncTaskCompleteListener<String> {

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    int pos = 0;
    private CommentsAdapter adapter;
    private LoadMoreListView list_contacts;
    private ArrayList<UserCommentObject> list;

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);

        try {
            current_page = 1;
            list = new ArrayList<UserCommentObject>();
            list.clear();
            adapter = null;
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FORUMS_COMMENTS_LIST_TAG, Constants.FORUMS_COMMENTS_LIST_URL + "?forum_id=" + getArguments().getString("forum_id"), Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public CommentsFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_comments, container, false);

        try {
            list_contacts = (LoadMoreListView) rootView.findViewById(R.id.list_contacts);

            list = new ArrayList<UserCommentObject>();

            list_contacts.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
                public void onLoadMore() {
                    // Do the work to load more items at the end of list
                    // here
                    //

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                        current_page += 1;
                        if (TOTAL_ITEMS != adapter.getCount()) {
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FORUMS_COMMENTS_LIST_TAG, Constants.FORUMS_COMMENTS_LIST_URL + "?forum_id=" + getArguments().getString("forum_id"), Constants.HTTP_GET, "Home Activity");
                            a.execute();
                        } else {
                            list_contacts.onLoadMoreComplete();
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                        }
                    } else {
                        list_contacts.onLoadMoreComplete();
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
                if (tag.equalsIgnoreCase(Constants.FORUMS_COMMENTS_LIST_TAG)) {

                    if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    }
                    try {
                        JSONObject jsonObject = new JSONObject(result);


                        if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));
                            if (jsonObject.getJSONArray("Comments").length()!=0){
                                for (int i = 0; i < jsonObject.getJSONArray("Comments").length(); i++) {
                                    UserCommentObject obj = new UserCommentObject();
                                    obj.setId(jsonObject.getJSONArray("Comments").getJSONObject(i).optString("commenter_id"));
                                    obj.setCreatedTime(DateTimeFormatClass.convertStringObjectToMMMDDYYYYFormat(jsonObject.getJSONArray("Comments").getJSONObject(i).optString("commentedTime")));
                                    obj.setUserName(jsonObject.getJSONArray("Comments").getJSONObject(i).optString("commentedBy"));
                                    obj.setCommentText(jsonObject.getJSONArray("Comments").getJSONObject(i).optString("CommentText"));
                                    obj.setUserImage(jsonObject.getJSONArray("Comments").getJSONObject(i).optString("userImage"));
                                    list.add(obj);
                                }
                            }else{
                                Toast.makeText(getActivity(), "No comments received", Toast.LENGTH_LONG).show();
                            }


                            //list_comments.setAdapter(new CommentsAdapter());
                        } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No comments received", Toast.LENGTH_LONG).show();
                        }

                        if (adapter == null) {
                            adapter = new CommentsAdapter(getActivity(), list);
                            list_contacts.setAdapter(adapter);
                        }


                        list_contacts.onLoadMoreComplete();
                        adapter.notifyDataSetChanged();

                        int index = list_contacts.getLastVisiblePosition();
                        list_contacts.smoothScrollToPosition(index);
                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
