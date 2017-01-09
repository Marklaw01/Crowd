package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.SearchContractrosAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.loadmore_listview.LoadMoreListView;
import com.staging.models.ContractorsObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 2/1/2016.
 */
public class RecommendedContractorsFragment extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private ArrayList<ContractorsObject> contractorsList;
    private EditText et_search;
    private TextView btn_search;
    private LoadMoreListView list_startups;
    private SearchContractrosAdapter adapter;
    private String statup_id = "";
    private String logged_in_user_role = "";

    public RecommendedContractorsFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        try {
            current_page = 1;
            contractorsList = new ArrayList<ContractorsObject>();
            contractorsList.clear();
            adapter = null;

            logged_in_user_role = getArguments().getString("logged_in_user_role");
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.RECOMMENDED_CONTRACTORS_OF_STARTUP_TAG, Constants.RECOMMENDED_CONTRACTORS_OF_STARTUP_URL + "?startup_id=" + statup_id + "&user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
            if (getArguments().getString("commingFrom").equalsIgnoreCase("teams")) {
                ((HomeActivity) getActivity()).setActionBarTitle("Recommended Contractor");
            } else {
                ((HomeActivity) getActivity()).setActionBarTitle("Search Contractor");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_search_starups, container, false);

        try {
            et_search = (EditText) rootView.findViewById(R.id.et_search);
            btn_search = (TextView) rootView.findViewById(R.id.btn_search);
            btn_search.setVisibility(View.GONE);
            list_startups = (LoadMoreListView) rootView.findViewById(R.id.list_startups);
            statup_id = getArguments().getString("startup_id");
            Log.e("startup_id", getArguments().getString("startup_id"));
            contractorsList = new ArrayList<ContractorsObject>();

       /* if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.RECOMMENDED_CONTRACTORS_OF_STARTUP_TAG, Constants.RECOMMENDED_CONTRACTORS_OF_STARTUP_URL + "?startup_id=" + statup_id + "&page_no=" + current_page, Constants.HTTP_GET);
            a.execute();
        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }
*/
            list_startups.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
                public void onLoadMore() {
                    // Do the work to load more items at the end of list
                    // here
                    //
                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                        current_page += 1;
                        if (TOTAL_ITEMS != adapter.getCount()) {
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.RECOMMENDED_CONTRACTORS_OF_STARTUP_TAG, Constants.RECOMMENDED_CONTRACTORS_OF_STARTUP_URL + "?startup_id=" + statup_id + "&user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
                            a.execute();
                        } else {
                            list_startups.onLoadMoreComplete();
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                        }

                    } else {

                        list_startups.onLoadMoreComplete();
                        adapter.notifyDataSetChanged();
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                }
            });


            list_startups.setOnItemClickListener(this);

            et_search.addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                }

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                    if (adapter != null) {
                        adapter.getFilter().filter(s);
                    }

                }

                @Override
                public void afterTextChanged(Editable s) {

                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }


        return rootView;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        try {
            if (contractorsList.get(position).getIsPublicProfile().equalsIgnoreCase("1")) {
                Fragment currentStartUPDetails = new ViewOtherContractorPublicProfileFragment();

                Bundle args = new Bundle();
                args.putString("STARTUP_ID", CurrentStartUpDetailFragment.STARTUP_ID);
                args.putString("id", contractorsList.get(position).getId());
                args.putString("logged_in_user_role", logged_in_user_role);
                args.putString("COMMING_FROM", "RECOMMENDED_CONTRACTOR_DETAILS");
                currentStartUPDetails.setArguments(args);
                ((HomeActivity) getActivity()).replaceFragment(currentStartUPDetails);
            } else {
                Toast.makeText(getActivity(), "This user's profile can't be viewed as it is a private profile.", Toast.LENGTH_LONG).show();
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
        /*FragmentTransaction transactionAdd = getFragmentManager().beginTransaction();

        transactionAdd.replace(R.id.container, currentStartUPDetails);
        transactionAdd.addToBackStack(null);

        transactionAdd.commit();*/

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
                if (tag.equalsIgnoreCase(Constants.RECOMMENDED_CONTRACTORS_OF_STARTUP_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();

                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));

                            if (jsonObject.optJSONArray("Contractors").length() != 0) {
                                for (int i = 0; i < jsonObject.optJSONArray("Contractors").length(); i++) {
                                    JSONObject contracotrs = jsonObject.optJSONArray("Contractors").getJSONObject(i);
                                    ContractorsObject obj = new ContractorsObject();
                                    obj.setIsPublicProfile(contracotrs.optString("is_profile_public"));
                                    obj.setId(contracotrs.optString("id"));
                                    obj.setImage(contracotrs.optString("image"));

                                    if (contracotrs.optString("rate").length() == 0) {
                                        obj.setContractorRate((((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat("0")));
                                    } else {
                                        obj.setContractorRate((((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat(contracotrs.optString("rate"))));
                                    }


                                    obj.setContractorName(contracotrs.optString("name"));


                                    StringBuilder stringBuilder = new StringBuilder();
                                    for (int j = 0; j < contracotrs.optJSONArray("skills").length(); j++) {
                                        if (stringBuilder.length() > 0) {
                                            stringBuilder.append(",");
                                        }

                                        stringBuilder.append(contracotrs.optJSONArray("skills").getJSONObject(j).optString("name"));
                                    }

                                    obj.setContractorSkills(stringBuilder.toString());

                                    contractorsList.add(obj);

                                }
                            } else {
                                Toast.makeText(getActivity(), "No Contractors found", Toast.LENGTH_LONG).show();
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No Contractors found", Toast.LENGTH_LONG).show();
                        }


                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }

                    if (adapter == null) {
                        adapter = new SearchContractrosAdapter(getActivity(), contractorsList);
                        list_startups.setAdapter(adapter);
                    }


                    list_startups.onLoadMoreComplete();
                    adapter.notifyDataSetChanged();

                    int index = list_startups.getLastVisiblePosition();
                    list_startups.smoothScrollToPosition(index);
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}