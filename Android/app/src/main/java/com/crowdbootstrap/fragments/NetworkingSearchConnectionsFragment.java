package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.adapter.BusinessNetworkAdapter;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.loadmore_listview.LoadMoreListView;
import com.crowdbootstrap.models.ContractorsObject;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 11/21/2017.
 */

public class NetworkingSearchConnectionsFragment extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private ArrayList<ContractorsObject> contractorsList;
    private TextView btn_search;
    private EditText et_search;
    private LoadMoreListView list_startups;
    private BusinessNetworkAdapter adapter;
    private String statup_id = "";

    public NetworkingSearchConnectionsFragment() {
    }

    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            ((HomeActivity) getActivity()).setOnBackPressedListener(this);

            try {
                current_page = 1;
                contractorsList = new ArrayList<ContractorsObject>();
                contractorsList.clear();
                adapter = null;
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SEARCH_BUSINESS_NETWORKS_TAG, Constants.SEARCH_BUSINESS_NETWORKS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&search_text=" + "" + "&page_no=" + current_page, Constants.HTTP_GET, "Home Activity");
                    a.execute();
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }

            } catch (Exception e) {
                e.printStackTrace();
                Log.e("xxx", "EXception++++" + e.getMessage());
            }
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_search_starups, container, false);

        try {
            et_search = (EditText) rootView.findViewById(R.id.et_search);
            list_startups = (LoadMoreListView) rootView.findViewById(R.id.list_startups);
            btn_search = (TextView) rootView.findViewById(R.id.btn_search);
            //statup_id = getArguments().getString("startup_id");
            contractorsList = new ArrayList<ContractorsObject>();


            list_startups.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
                public void onLoadMore() {
                    // Do the work to load more items at the end of list
                    // here
                    //
                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                        current_page += 1;
                        Log.e("items", String.valueOf(adapter.getCount()));
                        if (TOTAL_ITEMS != adapter.getCount()) {
                            String searchedKey = ((HomeActivity) getActivity()).utilitiesClass.removeSpecialCharacters(et_search.getText().toString().trim());
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SEARCH_BUSINESS_NETWORKS_TAG, Constants.SEARCH_BUSINESS_NETWORKS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&search_text=" + searchedKey + "&page_no=" + current_page, Constants.HTTP_GET, "Home Activity");
                            a.execute();
                        } else {
                            list_startups.onLoadMoreComplete();
                            adapter.notifyDataSetChanged();
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                        }

                    } else {

                        list_startups.onLoadMoreComplete();
                        adapter.notifyDataSetChanged();
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                }
            });

            et_search.setImeOptions(EditorInfo.IME_ACTION_DONE);
            et_search.setOnEditorActionListener(new EditText.OnEditorActionListener() {
                @Override
                public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                    if (actionId == EditorInfo.IME_ACTION_DONE) {
                        current_page = 1;
                        contractorsList = new ArrayList<ContractorsObject>();
                        contractorsList.clear();
                        adapter = null;
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                            String searchedKey = ((HomeActivity) getActivity()).utilitiesClass.removeSpecialCharacters(et_search.getText().toString().trim());
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SEARCH_BUSINESS_NETWORKS_TAG, Constants.SEARCH_BUSINESS_NETWORKS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&search_text=" + searchedKey + "&page_no=" + current_page, Constants.HTTP_GET, "Home Activity");
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                        return true;
                    }
                    return false;
                }
            });


            list_startups.setOnItemClickListener(this);
        } catch (Exception e) {
            e.printStackTrace();
        }


        return rootView;
    }

    FragmentManager manager;

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        try {


            if(!contractorsList.get(position).getCardId().isEmpty()) {
                Fragment currentStartUPDetails = new ViewBusinessCardFragment();
                // Constants.COMMING_FROM_INTENT = "";
                Bundle args = new Bundle();
                args.putString("connection_id", contractorsList.get(position).getId());
                args.putString("is_network", contractorsList.get(position).getIsNetwork());
                args.putString("business_contact_type", contractorsList.get(position).getBusinessConnectionTypeId());
                args.putString("card_id", contractorsList.get(position).getCardId());
                args.putString("userName", contractorsList.get(position).getContractorName());
                args.putString("userImage", contractorsList.get(position).getImage());
                args.putString("noteId", "");
                args.putString("comingFrom", "SearchConnections");

                currentStartUPDetails.setArguments(args);

                FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
                FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                fragmentTransaction.replace(R.id.container, currentStartUPDetails);
                fragmentTransaction.addToBackStack(HomeFragment.class.getName());

                fragmentTransaction.commit();
            }
            else{
                Toast.makeText(getActivity(), "No Business Card Found.", Toast.LENGTH_LONG).show();
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
                if (tag.equalsIgnoreCase(Constants.SEARCH_BUSINESS_NETWORKS_TAG)) {
                    Log.e("XXXX", "RESPONSE+++++ INONTASKCMPLETE");

                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        Log.e("XXXX", "RESPONSE+++++" + jsonObject.toString());
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));
                            contractorsList.clear();
                            if (jsonObject.optJSONArray("Contractors").length() != 0) {
                                for (int i = 0; i < jsonObject.optJSONArray("Contractors").length(); i++) {
                                    JSONObject contracotrs = jsonObject.optJSONArray("Contractors").getJSONObject(i);
                                    ContractorsObject obj = new ContractorsObject();
                                    obj.setIsPublicProfile(contracotrs.optString("is_profile_public"));
                                    obj.setId(contracotrs.optString("id"));
                                    obj.setImage(contracotrs.optString("image"));
                                    obj.setIsNetwork(contracotrs.optString("is_network"));
                                    obj.setBusinessConnectionTypeId(contracotrs.optString("business_connection_type_id"));
                                    obj.setCardId(contracotrs.optString("card_id"));

                                    if (contracotrs.optString("rate").length() == 0) {
                                        obj.setContractorRate((((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat("0")));
                                    } else {
                                        obj.setContractorRate((((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat(contracotrs.optString("rate"))));
                                    }


                                    obj.setContractorName(contracotrs.optString("name"));


                                    StringBuilder stringBuilder = new StringBuilder();
                                    for (int j = 0; j < contracotrs.optJSONArray("keywords").length(); j++) {
                                        if (stringBuilder.length() > 0) {
                                            stringBuilder.append(", ");
                                        }

                                        stringBuilder.append(contracotrs.optJSONArray("keywords").getJSONObject(j).optString("name"));
                                    }

                                    obj.setContractorSkills(stringBuilder.toString());

                                    contractorsList.add(obj);
                                    //Log.e("XXX","NAME"+contracotrs.optString("name")+"++++++ISPUBLIC"+contracotrs.optString("is_profile_public"));

                                }

                                if (adapter == null) {
                                    adapter = new BusinessNetworkAdapter(getActivity(), contractorsList, "search", "   ");
                                    list_startups.setAdapter(adapter);
                                }


                                list_startups.onLoadMoreComplete();
                                adapter.notifyDataSetChanged();

                                int index = list_startups.getLastVisiblePosition();
                                list_startups.smoothScrollToPosition(index);
                            } else {
                                Toast.makeText(getActivity(), "No Contractors found", Toast.LENGTH_LONG).show();
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No Contractors found", Toast.LENGTH_LONG).show();
                        }


                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                        Log.e("XXX", "Exception+++++" + e.getMessage());
                    }


                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

    }


}