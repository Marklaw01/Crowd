package com.staging.fragments;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.BlogsAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.loadmore_listview.LoadMoreListView;
import com.staging.logger.CrowdBootstrapLogger;
import com.staging.models.BlogsObject;
import com.staging.utilities.AsyncNew;
import com.staging.utilities.Constants;
import com.staging.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by sunakshi.gautam on 9/13/2017.
 */

public class BlogsFragment extends Fragment implements AdapterView.OnItemClickListener, View.OnClickListener, AsyncTaskCompleteListener<String> {
    private String searchText = "";
    private AsyncNew asyncNew;

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;

    private LoadMoreListView list_funds;
    private BlogsAdapter adapter;

    private ArrayList<BlogsObject> fundsList;
    private SwipeRefreshLayout swipeContainer;
    private boolean setPullToRefresh = false;


    public BlogsFragment() {
        super();
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            // we check that the fragment is becoming visible
            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            current_page = 1;
            fundsList = new ArrayList<>();
            adapter = null;
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("page_no", current_page);
                    asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BLOG_FEEDS_TAG, Constants.BLOG_FEEDS_LIST, Constants.HTTP_POST_REQUEST, obj);
                    asyncNew.execute();
                } catch (JSONException e) {
                    e.printStackTrace();
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                }

            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        }
    }


    @Override
    public void onResume() {
        super.onResume();
        //((HomeActivity) getActivity()).setOnBackPressedListener(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.blogs_fragment, container, false);


        list_funds = (LoadMoreListView) rootView.findViewById(R.id.list_blogs);
        fundsList = new ArrayList<>();

        list_funds.setOnItemClickListener(this);
        list_funds.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
            @Override
            public void onLoadMore() {
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    current_page += 1;
                    if (TOTAL_ITEMS != adapter.getCount()) {
                        JSONObject obj = new JSONObject();
                        try {
                            obj.put("page_no", current_page);
                            asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BLOG_FEEDS_TAG, Constants.BLOG_FEEDS_LIST, Constants.HTTP_POST_REQUEST, obj);
                            asyncNew.execute();
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                    } else {
                        list_funds.onLoadMoreComplete();
                    }
                } else {
                    list_funds.onLoadMoreComplete();
                    adapter.notifyDataSetChanged();
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            }
        });


        // Pull to Refresh
        swipeContainer = (SwipeRefreshLayout) rootView.findViewById(R.id.swipeContainer);
        // Setup refresh listener which triggers new data loading
        swipeContainer.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                setPullToRefresh = true;
                // we check that the fragment is becoming visible
                current_page = 1;
                fundsList = new ArrayList<>();
                adapter = null;
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();
                    try {
                        JSONObject obj = new JSONObject();
                        obj.put("page_no", current_page);
                        asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BLOG_FEEDS_TAG, Constants.BLOG_FEEDS_LIST, Constants.HTTP_POST_REQUEST, obj);
                        asyncNew.execute();
                    } catch (JSONException e) {
                        e.printStackTrace();
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    }

                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            }
        });
        // Configure the refreshing colors
        swipeContainer.setColorSchemeResources(android.R.color.holo_blue_bright,
                android.R.color.holo_green_light,
                android.R.color.holo_orange_light,
                android.R.color.holo_red_light);


        return rootView;
    }


    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {


        Fragment currentBlogsDetails = new BlogDetailsFragment();
        // Constants.COMMING_FROM_INTENT = "";
        Bundle args = new Bundle();
        args.putString("url", fundsList.get(position).getBlogLink());
        currentBlogsDetails.setArguments(args);


        FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        fragmentTransaction.replace(R.id.container, currentBlogsDetails);
        fragmentTransaction.addToBackStack(HomeFragment.class.getName());

        fragmentTransaction.commit();


    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {

        }

    }


    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.TIMEOUT_EXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            UtilitiesClass.getInstance(getActivity()).alertDialogSingleButton(getString(R.string.time_out));
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            if (tag.equals(Constants.BLOG_FEEDS_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);


                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));

                        if (jsonObject.optJSONArray("result_list").length() != 0) {
                            for (int i = 0; i < jsonObject.optJSONArray("result_list").length(); i++) {
                                JSONObject funds = jsonObject.optJSONArray("result_list").getJSONObject(i);
                                BlogsObject fundsObject = new BlogsObject();
                                fundsObject.setBlogId(funds.optString("blog_id"));
                                fundsObject.setBlogName(funds.optString("blog_title"));
                                fundsObject.setBlogLink(funds.optString("link"));
                                fundsObject.setBolgDate(funds.optString("date"));
                                fundsObject.setBlogDesc(funds.optString("short_desc"));
                                fundsObject.setBlogStatus(funds.optString("status"));
                                fundsList.add(fundsObject);
                            }
                        } else {
                            Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                        }

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                    Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
                }

                if (adapter == null) {
                    adapter = new BlogsAdapter(getActivity(), fundsList, "FindFunds");
                    list_funds.setAdapter(adapter);
                }

                if (setPullToRefresh == true) {

                    adapter = new BlogsAdapter(getActivity(), fundsList, "FindFunds");
                    list_funds.setAdapter(adapter);
                    setPullToRefresh = false;
                    swipeContainer.setRefreshing(false);

                } else {

                    list_funds.onLoadMoreComplete();
                    adapter.notifyDataSetChanged();


                    int index = list_funds.getLastVisiblePosition();
                    list_funds.smoothScrollToPosition(index);
                }

            }
        }
        CrowdBootstrapLogger.logInfo(result);
    }
}
