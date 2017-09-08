package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.CampaignsAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.loadmore_listview.LoadMoreListView;
import com.staging.models.CampaignsObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.DateTimeFormatClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/12/2016.
 */
public class CommitmentsFragment extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private Button btn_addCampaign;
    CampaignsAdapter adapter;
    ArrayList<CampaignsObject> campaignsObjectArrayList;
    private LoadMoreListView list_compaigns;

    public CommitmentsFragment() {
        super();
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            // we check that the fragment is becoming visible

            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            try {
                current_page = 1;
                campaignsObjectArrayList = new ArrayList<CampaignsObject>();
                campaignsObjectArrayList.clear();
                adapter = null;
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CAMPAIGNS_TAG, Constants.CAMPAIGNS_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&campaign_type=" + Constants.COMMITMENTS + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
                    a.execute();
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_suggestions, container, false);

        try {
            btn_addCampaign = (Button) rootView.findViewById(R.id.btn_addCampaign);
            btn_addCampaign.setVisibility(View.GONE);
            list_compaigns = (LoadMoreListView) rootView.findViewById(R.id.list_compaigns);
            campaignsObjectArrayList = new ArrayList<CampaignsObject>();

            list_compaigns.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
                public void onLoadMore() {
                    // Do the work to load more items at the end of list
                    // here
                    //
                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                        current_page += 1;
                        if (TOTAL_ITEMS != adapter.getCount()) {
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CAMPAIGNS_TAG, Constants.CAMPAIGNS_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&campaign_type=" + Constants.COMMITMENTS + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
                            a.execute();
                        } else {
                            list_compaigns.onLoadMoreComplete();
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                        }

                    } else {

                        list_compaigns.onLoadMoreComplete();
                        adapter.notifyDataSetChanged();
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                }
            });

            list_compaigns.setOnItemClickListener(this);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rootView;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

        try {
            Fragment addContributor = new CampaignInterestDetailsFragment();

            Bundle bundle = new Bundle();
            bundle.putString("CAMPAIGN_NAME", campaignsObjectArrayList.get(position).getName());
            bundle.putString("CAMPAIGN_ID", campaignsObjectArrayList.get(position).getId());
            addContributor.setArguments(bundle);
            ((HomeActivity)getActivity()).replaceFragment(addContributor);
        } catch (Exception e) {
            e.printStackTrace();
        }
        /*FragmentTransaction transactionAdd = getParentFragment().getFragmentManager().beginTransaction();
        transactionAdd.replace(R.id.container, addContributor);
        transactionAdd.addToBackStack(null);

        transactionAdd.commit();*/
    }

    @Override
    public void onResume() {
        super.onResume();

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
                if (tag.equalsIgnoreCase(Constants.CAMPAIGNS_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));
                            if (jsonObject.optJSONArray("campaigns").length()!=0){
                                for (int i = 0; i < jsonObject.optJSONArray("campaigns").length(); i++) {
                                    JSONObject campaigns = jsonObject.optJSONArray("campaigns").getJSONObject(i);
                                    CampaignsObject campaignsObject = new CampaignsObject();
                                    campaignsObject.setId(campaigns.optString("campaign_id"));
                                    campaignsObject.setName(campaigns.optString("campaign_name"));
                                    campaignsObject.setStartUpName(campaigns.optString("startup_name"));
                                    try {
                                        String target_ammount = campaigns.optString("target_amount").trim();
                                        if (target_ammount.length() == 0) {
                                            campaignsObject.setTargetAmount((((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat("0")));
                                        } else {
                                            campaignsObject.setTargetAmount((((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat(target_ammount)));
                                        }
                                        String fundRaisedFor = campaigns.optString("fund_raised").trim();
                                        if (fundRaisedFor.length() == 0) {
                                            campaignsObject.setFundRaiseFor((((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat("0")));
                                        } else {
                                            campaignsObject.setFundRaiseFor((((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat(fundRaisedFor)));
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                    campaignsObject.setDescription(campaigns.optString("description"));
                                    campaignsObject.setDueDate(DateTimeFormatClass.convertStringObjectToMMDDYYYFormat(campaigns.optString("due_date")));

                                    campaignsObjectArrayList.add(campaignsObject);
                                }
                            }else{
                                Toast.makeText(getActivity(), "No Campaigns Available", Toast.LENGTH_LONG).show();
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No Campaigns Available", Toast.LENGTH_LONG).show();
                        }
                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }

                    if (adapter == null) {
                        adapter = new CampaignsAdapter(getActivity(), campaignsObjectArrayList, false);
                        list_compaigns.setAdapter(adapter);
                    }


                    list_compaigns.onLoadMoreComplete();
                    adapter.notifyDataSetChanged();

                    int index = list_compaigns.getLastVisiblePosition();
                    list_compaigns.smoothScrollToPosition(index);


                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
