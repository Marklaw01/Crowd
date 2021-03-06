package com.staging.fragments.hardwaremodule;

import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.hardwareAdapter.HardwareAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.loadmore_listview.LoadMoreListView;
import com.staging.logger.CrowdBootstrapLogger;
import com.staging.models.FundsObject;
import com.staging.utilities.AsyncNew;
import com.staging.utilities.Constants;
import com.staging.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Neelmani.Karn on 1/11/2017.
 */
public class SearchResourcesHardwareFragment extends Fragment implements AdapterView.OnItemClickListener, View.OnClickListener, AsyncTaskCompleteListener<String> {
    private String searchText = "";
    private AsyncNew asyncNew;
    private EditText et_search;
    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private Button btn_createFund;
    private LoadMoreListView list_funds;
    private HardwareAdapter adapter;
    private TextView btn_search;
    private ArrayList<FundsObject> fundsList;

    public SearchResourcesHardwareFragment() {
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
                    obj.put("search_text", searchText);
                    asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FIND_HARDWARE_TAG, Constants.FIND_HARDWARE_LIST, Constants.HTTP_POST_REQUEST, obj);
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
     * Called when the fragment is visible to the user and actively running.
     * This is generally
     * tied to {@link Activity#onResume() Activity.onResume} of the containing
     * Activity's lifecycle.
     */
    @Override
    public void onResume() {
        super.onResume();
        //((HomeActivity) getActivity()).setOnBackPressedListener(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.funds_fragment, container, false);

        et_search = (EditText)rootView.findViewById(R.id.et_search);
        btn_search = (TextView) rootView.findViewById(R.id.btn_search);
        btn_createFund = (Button) rootView.findViewById(R.id.btn_createFund);
        btn_createFund.setVisibility(View.GONE);

        btn_search.setOnClickListener(this);

        list_funds = (LoadMoreListView) rootView.findViewById(R.id.list_funds);
        fundsList = new ArrayList<>();
/*        adapter = new CommunalAssetAdapter(getActivity(), fundsList, "FindFunds");
        list_funds.setAdapter(adapter);*/

        btn_search.setOnClickListener(this);
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
                            obj.put("search_text", searchText);
                            asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FIND_HARDWARE_TAG, Constants.FIND_HARDWARE_LIST, Constants.HTTP_POST_REQUEST, obj);
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
        bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
        HardwareDetailsFragment updateFundFragment = new HardwareDetailsFragment();
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
            case R.id.btn_search:
                if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                    if (!et_search.getText().toString().trim().isEmpty()) {
                        searchText = et_search.getText().toString().trim();
                        try {
                            JSONObject obj = new JSONObject();
                            current_page = 1;
                            fundsList = new ArrayList<>();
                            adapter = null;
                            obj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            obj.put("search_text", searchText);
                            obj.put("page_no", current_page);
                            ((HomeActivity) getActivity()).showProgressDialog();
                            AsyncNew asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FIND_HARDWARE_TAG, Constants.FIND_HARDWARE_LIST, Constants.HTTP_POST_REQUEST, obj);
                            asyncNew.execute();
                        } catch (JSONException e) {
                            e.printStackTrace();
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                        }
                    }
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
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
            if (tag.equals(Constants.FIND_HARDWARE_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);


                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));

                        if (jsonObject.optJSONArray("result_list").length() != 0) {
                            for (int i = 0; i < jsonObject.optJSONArray("result_list").length(); i++) {
                                JSONObject funds = jsonObject.optJSONArray("result_list").getJSONObject(i);
                                FundsObject fundsObject = new FundsObject();
                                fundsObject.setId(funds.optString("id"));
                                fundsObject.setFund_title(funds.optString("title"));
                                fundsObject.setFund_start_date(funds.optString("start_date"));
                                fundsObject.setFund_end_date(funds.optString("end_date"));

                                fundsObject.setFund_description(funds.optString("description"));
                                fundsObject.setFund_likes(funds.optInt("likes"));
                                fundsObject.setFund_dislike(funds.optInt("dislikes"));
                                fundsObject.setFund_image(funds.optString("image"));
                                fundsObject.setFund_created_by(funds.optString("created_by"));
                                fundsObject.setIs_liked_by_user(funds.getInt("is_liked_by_user"));
                                fundsObject.setIs_disliked_by_user(funds.getInt("is_disliked_by_user"));

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
                    adapter = new HardwareAdapter(getActivity(), fundsList, "FindFunds");
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