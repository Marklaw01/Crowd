package com.crowdbootstrapapp.fragments;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.Toast;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.adapter.FundsAdapter;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.loadmore_listview.LoadMoreListView;
import com.crowdbootstrapapp.logger.CrowdBootstrapLogger;
import com.crowdbootstrapapp.models.FundsObject;
import com.crowdbootstrapapp.utilities.AsyncNew;
import com.crowdbootstrapapp.utilities.Constants;
import com.crowdbootstrapapp.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Neelmani.Karn on 1/11/2017.
 */
public class MyFundsFragments extends Fragment implements AdapterView.OnItemClickListener, View.OnClickListener, AsyncTaskCompleteListener<String> {
    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private Button btn_addCampaign;
    private LoadMoreListView list_funds;
    private FundsAdapter adapter;
    private ArrayList<FundsObject> fundsList;
    private AsyncNew asyncNew;

    public MyFundsFragments() {
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
                    obj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    obj.put("page_no", current_page);
                    asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.MY_FUND_TAG, Constants.MY_FUND_LIST, Constants.HTTP_POST_REQUEST, obj);
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

    /**
     * Called when the Fragment is no longer resumed.  This is generally
     * tied to {@link Activity#onPause() Activity.onPause} of the containing
     * Activity's lifecycle.
     */
    @Override
    public void onPause() {
        super.onPause();
        if (asyncNew.getStatus() == AsyncTask.Status.RUNNING) {
            asyncNew.cancel(true);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.funds_fragment, container, false);

        btn_addCampaign = (Button) rootView.findViewById(R.id.btn_createFund);

        list_funds = (LoadMoreListView) rootView.findViewById(R.id.list_funds);

        /*adapter = new FundsAdapter(getActivity(), Constants.LOGGED_USER, "MyFunds");
        list_funds.setAdapter(adapter);*/
        btn_addCampaign.setOnClickListener(this);
        list_funds.setOnItemClickListener(this);

        list_funds.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
            @Override
            public void onLoadMore() {
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    current_page += 1;
                    if (TOTAL_ITEMS != adapter.getCount()) {
                        JSONObject obj = new JSONObject();
                        try {
                            obj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            obj.put("page_no", current_page);
                            asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.MY_FUND_TAG, Constants.MY_FUND_LIST, Constants.HTTP_POST_REQUEST, obj);
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
        return rootView;
    }

    /**
     * Callback method to be invoked when an item in this AdapterView has
     * been clicked.
     * <p>
     * Implementers can call getItemAtPosition(position) if they need
     * to access the data associated with the selected item.
     *
     * @param parent   The AdapterView where the click happened.
     * @param view     The view within the AdapterView that was clicked (this
     *                 will be a view provided by the adapter)
     * @param position The position of the view in the adapter.
     * @param id       The row id of the item that was clicked.
     */
    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        Bundle bundle = new Bundle();
        bundle.putString(Constants.FUND_ID, fundsList.get(position).getId());
        UpdateFundFragment updateFundFragment = new UpdateFundFragment();
        updateFundFragment.setArguments(bundle);
        ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
    }

    /**
     * Called when a view has been clicked.
     *
     * @param v The view that was clicked.
     */
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_createFund:
                ((HomeActivity) getActivity()).replaceFragment(new CreateFundFragment());
                break;
        }
    }

    /**
     * When network give response in this.
     *
     * @param result
     * @param tag
     */
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
            if (tag.equals(Constants.MY_FUND_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);


                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));

                        if (jsonObject.optJSONArray("my_funds_list").length() != 0) {
                            for (int i = 0; i < jsonObject.optJSONArray("my_funds_list").length(); i++) {
                                JSONObject funds = jsonObject.optJSONArray("my_funds_list").getJSONObject(i);
                                FundsObject fundsObject = new FundsObject();
                                fundsObject.setId(funds.optString("id"));
                                fundsObject.setFund_title(funds.optString("fund_title"));
                                fundsObject.setFund_start_date(funds.optString("fund_start_date"));
                                fundsObject.setFund_end_date(funds.optString("fund_end_date"));
                                fundsObject.setFund_close_date(funds.optString("fund_close_date"));
                                fundsObject.setFund_description(funds.optString("fund_description"));
                                fundsObject.setFund_likes(funds.optInt("fund_likes"));
                                fundsObject.setFund_dislike(funds.optInt("fund_dislike"));
                                fundsObject.setFund_image(funds.optString("fund_image"));
                                fundsObject.setFund_created_by(funds.optString("fund_created_by"));

                                fundsList.add(fundsObject);
                            }
                        } else {
                            Toast.makeText(getActivity(), getString(R.string.noFunds), Toast.LENGTH_LONG).show();
                        }

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), getString(R.string.noFunds), Toast.LENGTH_LONG).show();
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                    Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
                }

                if (adapter == null) {
                    adapter = new FundsAdapter(getActivity(), fundsList, Constants.LOGGED_USER, "MyFunds");
                    list_funds.setAdapter(adapter);
                }
                list_funds.onLoadMoreComplete();
                adapter.notifyDataSetChanged();

                int index = list_funds.getLastVisiblePosition();
                list_funds.smoothScrollToPosition(index);

            }
        }
        CrowdBootstrapLogger.logInfo(result);
    }
}
