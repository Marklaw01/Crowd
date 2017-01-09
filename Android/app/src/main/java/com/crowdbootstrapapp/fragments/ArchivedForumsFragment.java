package com.crowdbootstrapapp.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Toast;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.adapter.MyForumsAdapter;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.loadmore_listview.LoadMoreListView;
import com.crowdbootstrapapp.models.MyForumsObject;
import com.crowdbootstrapapp.utilities.Async;
import com.crowdbootstrapapp.utilities.Constants;
import com.crowdbootstrapapp.utilities.DateTimeFormatClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/19/2016.
 */
public class ArchivedForumsFragment extends Fragment implements AsyncTaskCompleteListener<String>{

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    int pos = 0;

    private LoadMoreListView listView;

    private ArrayList<MyForumsObject> list;
    private MyForumsAdapter adapter;
    public ArchivedForumsFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        try {
            ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.archivedForums));
            ((HomeActivity) getActivity()).setOnBackPressedListener(this);

            current_page = 1;
            list = new ArrayList<MyForumsObject>();
            list.clear();
            adapter = null;
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ARCHIEVE_FORUMS_LIST_TAG, Constants.ARCHIEVE_FORUMS_LIST_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
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

            list = new ArrayList<MyForumsObject>();

            listView.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
                public void onLoadMore() {
                    // Do the work to load more items at the end of list
                    // here
                    //

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                        current_page += 1;
                        if (TOTAL_ITEMS != adapter.getCount()) {
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ARCHIEVE_FORUMS_LIST_TAG, Constants.ARCHIEVE_FORUMS_LIST_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
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

            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    Fragment addContributor = new ForumDetailsFragment();
                    Bundle bundle = new Bundle();
                    bundle.putString("forum_id", list.get(position).getId());
                    bundle.putString("COMMING_FROM", "Archived_Forums");
                    bundle.putString("TITLE", list.get(position).getTitle());
                    addContributor.setArguments(bundle);
                    ((HomeActivity)getActivity()).replaceFragment(addContributor);

                    /*FragmentTransaction transactionAdd = getFragmentManager().beginTransaction();

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
                if (tag.equalsIgnoreCase(Constants.ARCHIEVE_FORUMS_LIST_TAG)) {

                    if (((HomeActivity)getActivity()).isShowingProgressDialog()){
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


                    if (adapter == null) {
                        adapter = new MyForumsAdapter(getActivity(), list);
                        listView.setAdapter(adapter);
                    }


                    listView.onLoadMoreComplete();
                    adapter.notifyDataSetChanged();

                    int index = listView.getLastVisiblePosition();
                    listView.smoothScrollToPosition(index);
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}