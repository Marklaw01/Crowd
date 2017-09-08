package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.MyForumsAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.loadmore_listview.LoadMoreListView;
import com.staging.models.MyForumsObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.DateTimeFormatClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/18/2016.
 */
public class StartUpsForumsListFragemnt extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {

    private static int TOTAL_ITEMS = 0;
    private int current_page = 1;
    int pos = 0;
    private String startup_id;
    private MyForumsAdapter adapter;
    private LoadMoreListView mListView;

    private ArrayList<MyForumsObject> list;

    public StartUpsForumsListFragemnt() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        ((HomeActivity) getActivity()).setActionBarTitle(getArguments().getString("TITLE"));

        current_page = 1;
        list = new ArrayList<MyForumsObject>();
        list.clear();
        adapter = null;
        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_FORUMS_LIST_TAG, Constants.STARTUP_FORUMS_LIST_URL + "?startup_id=" + startup_id + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
            a.execute();
        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }


    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_startupslist, container, false);

        startup_id = getArguments().getString("startup_id");
        list = new ArrayList<MyForumsObject>();
        mListView = (LoadMoreListView) rootView.findViewById(R.id.listView);


        /*for (int i = 0; i < 15; i++) {
            MyForumsObject obj = new MyForumsObject();
            obj.setTitle("Forum Title " + (i + 1));
            obj.setCreatedTime(new Date().toString());
            obj.setDescription("Description: Lorum Ipsum Lorum Ipsum Lorum Ipsum Lorum Ipsum Lorum Ipsum Lorum Ipsum Lorum Ipsum Lorum Ipsum Lorum Ipsum Lorum Ipsum Lorum Ipsum Lorum Ipsum Lorum Ipsum Lorum Ipsum Lorum Ipsum Lorum Ipsum " );

            list.add(obj);
        }
*/
       // mListView.setAdapter(new MyForumsAdapter(getActivity(), list));


        mListView.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
            public void onLoadMore() {
                // Do the work to load more items at the end of list
                // here
                //
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                    current_page += 1;
                    if (TOTAL_ITEMS != adapter.getCount()) {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_FORUMS_LIST_TAG, Constants.STARTUP_FORUMS_LIST_URL + "?startup_id=" + startup_id + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
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


        mListView.setOnItemClickListener(this);
        return rootView;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        Fragment addContributor = new ForumDetailsFragment();

        Bundle bundle = new Bundle();
        bundle.putString("forum_id", list.get(position).getId());
        bundle.putString("COMMING_FROM", getArguments().getString("COMMING_FROM"));
        bundle.putString("TITLE", list.get(position).getTitle());
        addContributor.setArguments(bundle);
        ((HomeActivity)getActivity()).replaceFragment(addContributor);
        /*FragmentTransaction transactionAdd = getFragmentManager().beginTransaction();
        transactionAdd.replace(R.id.container, addContributor);
        transactionAdd.addToBackStack(null);

        transactionAdd.commit();*/

    }

    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity)getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity)getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            if (tag.equalsIgnoreCase(Constants.STARTUP_FORUMS_LIST_TAG)) {

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
                    mListView.setAdapter(adapter);
                }


                mListView.onLoadMoreComplete();
                adapter.notifyDataSetChanged();

                int index = mListView.getLastVisiblePosition();
                mListView.smoothScrollToPosition(index);
            }
        }
    }
}
