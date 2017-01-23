package com.crowdbootstrapapp.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
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

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.adapter.OrganizationAdapter;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.loadmore_listview.LoadMoreListView;
import com.crowdbootstrapapp.models.OrganizationObject;
import com.crowdbootstrapapp.utilities.Async;
import com.crowdbootstrapapp.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by sunakshi.gautam on 11/22/2016.
 */
public class OrganizationSearchFragment extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private ArrayList<OrganizationObject> contractorsList;
    private TextView btn_search;
    private EditText et_search;
    private LoadMoreListView list_startups;
    private OrganizationAdapter adapter;
    public static String sendingContractorId;
    private String statup_id = "";

    public OrganizationSearchFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        // we check that the fragment is becoming visible
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);

        try {
            current_page = 1;
            contractorsList = new ArrayList<OrganizationObject>();
            contractorsList.clear();
            adapter = null;
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SEARCH_ORGANIZATION_TAG, Constants.SEARCH_ORGANIZATION_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page + "&search_text=" + "", Constants.HTTP_GET, "Home Activity");
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
        View rootView = inflater.inflate(R.layout.fragment_search_starups, container, false);

        try {
            et_search = (EditText) rootView.findViewById(R.id.et_search);
            list_startups = (LoadMoreListView) rootView.findViewById(R.id.list_startups);
            btn_search = (TextView) rootView.findViewById(R.id.btn_search);
            //statup_id = getArguments().getString("startup_id");
            contractorsList = new ArrayList<OrganizationObject>();

            sendingContractorId = ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID);
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
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SEARCH_ORGANIZATION_TAG, Constants.SEARCH_ORGANIZATION_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page + "&search_text=" + "", Constants.HTTP_GET, "Home Activity");
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
                        contractorsList = new ArrayList<OrganizationObject>();
                        contractorsList.clear();
                        adapter = null;
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            String searchedKey = ((HomeActivity) getActivity()).utilitiesClass.removeSpecialCharacters(et_search.getText().toString().trim());
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SEARCH_ORGANIZATION_TAG, Constants.SEARCH_ORGANIZATION_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page + "&search_text=" + searchedKey, Constants.HTTP_GET, "Home Activity");
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                        return true;
                    }
                    return false;
                }
            });
            btn_search.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    current_page = 1;
                    contractorsList = new ArrayList<OrganizationObject>();
                    contractorsList.clear();
                    adapter = null;
                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();
                        String searchedKey = ((HomeActivity) getActivity()).utilitiesClass.removeSpecialCharacters(et_search.getText().toString().trim());
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SEARCH_ORGANIZATION_TAG, Constants.SEARCH_ORGANIZATION_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page + "&search_text=" + searchedKey, Constants.HTTP_GET, "Home Activity");
                        a.execute();
                    } else {
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
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


            Fragment OrgaganizationDetail = new OrganizationDetailFragment();
            // Constants.COMMING_FROM_INTENT = "";

            Bundle bundle = new Bundle();
            bundle.putString("COMPANY_NAME", contractorsList.get(position).getCompanyName());
            bundle.putString("COMPANY_ID", contractorsList.get(position).getCompanyID());
            OrgaganizationDetail.setArguments(bundle);

            ((HomeActivity)getActivity()).replaceFragment(OrgaganizationDetail);


        } catch (Exception e) {
            e.printStackTrace();
            Log.e("XXX",e.getMessage());
        }
        /*manager = getActivity().getSupportFragmentManager();
        FragmentTransaction transactionAdd = manager.beginTransaction();

        transactionAdd.replace(R.id.container, currentStartUPDetails);
        transactionAdd.addToBackStack(null);
        //manager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
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
                if (tag.equalsIgnoreCase(Constants.SEARCH_ORGANIZATION_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    contractorsList.clear();
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));

                            if (jsonObject.optJSONArray("company_list").length() != 0) {
                                for (int i = 0; i < jsonObject.optJSONArray("company_list").length(); i++) {
                                    JSONObject contracotrs = jsonObject.optJSONArray("company_list").getJSONObject(i);
                                    OrganizationObject obj = new OrganizationObject();
                                    obj.setCompanyID(contracotrs.optString("company_id"));
                                    obj.setCompanyImage(contracotrs.optString("company_image"));
                                    obj.setCompanyName(contracotrs.optString("company_name"));
                                    obj.setCompanyDescription(contracotrs.optString("company_description"));

                                    StringBuilder stringBuilder = new StringBuilder();
                                    for (int j = 0; j < contracotrs.optJSONArray("company_keywords").length(); j++) {
                                        if (stringBuilder.length() > 0) {
                                            stringBuilder.append(", ");
                                        }

                                        stringBuilder.append(contracotrs.optJSONArray("company_keywords").getJSONObject(j).optString("name"));
                                    }

                                    obj.setCompanySkills(stringBuilder.toString());
                                    contractorsList.add(obj);
                                    //Log.e("XXX","NAME"+contracotrs.optString("name")+"++++++ISPUBLIC"+contracotrs.optString("is_profile_public"));

                                }
                            } else {
                                Toast.makeText(getActivity(), "No Company found", Toast.LENGTH_LONG).show();
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No Company found", Toast.LENGTH_LONG).show();
                        }


                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }

                    if (adapter == null) {
                        adapter = new OrganizationAdapter(getActivity(), contractorsList);
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
        }

    }

    /*public void replaceFragment(Fragment fragment) {

        String backStateName = fragment.getClass().getName();
        String fragmentTag = backStateName;
///mCurrentTab = backStateName;
        manager = getActivity().getSupportFragmentManager();
        boolean fragmentPopped = manager.popBackStackImmediate(backStateName, 0);

        if (!fragmentPopped && manager.findFragmentByTag(fragmentTag) == null) {
//fragment not in back stack, create it.
            FragmentTransaction ft = manager.beginTransaction();
            ft.replace(R.id.container, fragment, fragmentTag);
            ft.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_CLOSE);
            ft.addToBackStack(backStateName);
            ft.commit();
        }

    }*/
}