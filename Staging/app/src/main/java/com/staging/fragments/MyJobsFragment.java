package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.JobListAdapter;
import com.staging.adapter.MyJobsAdapter;
import com.staging.dropdownadapter.CountryAdapter;
import com.staging.dropdownadapter.StatesAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.loadmore_listview.LoadMoreListView;
import com.staging.models.CountryObject;
import com.staging.models.JobListObject;
import com.staging.models.StatesObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 12/1/2016.
 */
public class MyJobsFragment extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private Spinner countrySpinner, citySpinner;
    private EditText et_search;
    private static int COUNTRY_ID;
    private static int STATE_ID;
    private CountryAdapter countryAdapter;
    private StatesAdapter stateAdapter;
    private ArrayList<StatesObject> states;
    private ArrayList<CountryObject> countries;
    private ArrayList<JobListObject> contractorsList;
    private MyJobsAdapter adapter;
    private TextView btn_search;
    private LoadMoreListView list_startups;
    private Button postNewJob;


    public MyJobsFragment() {
        super();
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
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.GET_COUNTRIES_LIST_WITH_STATES_TAG, Constants.GET_COUNTRIES_LIST_WITH_STATES, Constants.HTTP_POST, "Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        }
    }

    private void makeFiltersPreFilled(){

        et_search.setText(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_SELECTED_SEARCH_TEXT));


        if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_SELECTED_COUNTRY_ID).compareTo("") == 0) {
            COUNTRY_ID = 0;
        } else {
            COUNTRY_ID = Integer.parseInt(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_SELECTED_COUNTRY_ID));
        }
        if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_SELECTED_STATE_ID).compareTo("") == 0) {

            STATE_ID = 0;
        } else {
            STATE_ID = Integer.parseInt(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_SELECTED_STATE_ID));
        }
        if (countryAdapter != null) {
            for (int position = 0; position < countryAdapter.getCount(); position++) {
                if (countryAdapter.getId(position).equalsIgnoreCase(COUNTRY_ID + "")) {
                    countrySpinner.setSelection(position);
                }
            }
        }
        if (stateAdapter != null) {
            for (int position = 0; position < stateAdapter.getCount(); position++) {
                if (stateAdapter.getId(position).equalsIgnoreCase(STATE_ID + "")) {
                    citySpinner.setSelection(position);
                }
            }
        }
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.recruiter_joblist_layout, container, false);
        countries = new ArrayList<CountryObject>();
        states = new ArrayList<StatesObject>();

        countrySpinner = (Spinner) rootView.findViewById(R.id.country);
        list_startups = (LoadMoreListView) rootView.findViewById(R.id.list_startups);
        citySpinner = (Spinner) rootView.findViewById(R.id.city);
        btn_search = (TextView) rootView.findViewById(R.id.btn_search);
        postNewJob =  (Button) rootView.findViewById(R.id.btn_addCampaign);
        et_search = (EditText) rootView.findViewById(R.id.et_search);
        contractorsList = new ArrayList<JobListObject>();
        countrySpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                COUNTRY_ID = Integer.parseInt(countries.get(position).getId());
                //COUNTRY_ID = Integer.parseInt(countries.get(position).getId());

                states = countries.get(position).getStatesObjects();
                //Toast.makeText(getActivity(), "size" + states.size(), Toast.LENGTH_LONG).show();
                stateAdapter = new StatesAdapter(getActivity(), 0, states);
                citySpinner.setAdapter(stateAdapter);

                if (stateAdapter != null) {
                    for (int i = 0; i < stateAdapter.getCount(); i++) {
                        if (stateAdapter.getId(i).equalsIgnoreCase(STATE_ID + "")) {
                            citySpinner.setSelection(i);
                        }
                    }
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        citySpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                STATE_ID = Integer.parseInt(states.get(position).getId());

            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });


        list_startups.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
            public void onLoadMore() {
                // Do the work to load more items at the end of list
                // here
                //
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                    current_page += 1;

                    if (TOTAL_ITEMS != adapter.getCount()) {
                        String searchedKey = ((HomeActivity) getActivity()).utilitiesClass.removeSpecialCharacters(et_search.getText().toString().trim());
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.MYJOBS_LIST_TAG, Constants.MYJOBS_LIST_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&search_text=" + searchedKey + "&page_no=" + current_page + "&country_id=" + COUNTRY_ID + "&state_id=" + STATE_ID, Constants.HTTP_GET, "Home Activity");
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
                    contractorsList = new ArrayList<JobListObject>();
                    contractorsList.clear();
                    adapter = null;
                    ((HomeActivity) getActivity()).prefManager.storeString((Constants.USER_SELECTED_SEARCH_TEXT), String.valueOf(et_search.getText().toString()));

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();
                        String searchedKey = ((HomeActivity) getActivity()).utilitiesClass.removeSpecialCharacters(et_search.getText().toString().trim());
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.MYJOBS_LIST_TAG, Constants.MYJOBS_LIST_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&search_text=" + searchedKey + "&page_no=" + current_page + "&country_id=" + COUNTRY_ID + "&state_id=" + STATE_ID, Constants.HTTP_GET, "Home Activity");
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
                contractorsList = new ArrayList<JobListObject>();
                contractorsList.clear();
                adapter = null;
                ((HomeActivity) getActivity()).prefManager.storeString((Constants.USER_SELECTED_COUNTRY_ID), String.valueOf(COUNTRY_ID));
                ((HomeActivity) getActivity()).prefManager.storeString((Constants.USER_SELECTED_STATE_ID), String.valueOf(STATE_ID));
                ((HomeActivity) getActivity()).prefManager.storeString((Constants.USER_SELECTED_SEARCH_TEXT), String.valueOf(et_search.getText().toString()));

                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();
                    String searchedKey = ((HomeActivity) getActivity()).utilitiesClass.removeSpecialCharacters(et_search.getText().toString().trim());
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.MYJOBS_LIST_TAG, Constants.MYJOBS_LIST_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&search_text=" + searchedKey + "&page_no=" + current_page + "&country_id=" + COUNTRY_ID + "&state_id=" + STATE_ID, Constants.HTTP_GET, "Home Activity");
                    a.execute();
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            }
        });

        list_startups.setOnItemClickListener(this);


        postNewJob.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                try {
                    Fragment addJobFragment = new AddJobFragment();
                    ((HomeActivity) getActivity()).replaceFragment(addJobFragment);
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
        });

        return rootView;
    }


    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        try {
            Fragment jobDetails = new EditJobsFragment();

            Bundle bundle = new Bundle();
            bundle.putString("JOB_ID", contractorsList.get(position).getJobID());
            bundle.putString("JOB_TITLE", contractorsList.get(position).getJobTitle());

            jobDetails.setArguments(bundle);
            ((HomeActivity)getActivity()).replaceFragment(jobDetails);
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
                ((HomeActivity) getActivity()).dismissProgressDialog();
                if (tag.equalsIgnoreCase(Constants.GET_COUNTRIES_LIST_WITH_STATES_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        countries.clear();

                        CountryObject obj = new CountryObject();
                        obj.setId("0");
                        obj.setName("Select Country");
                        ArrayList<StatesObject> selectCityObjectList = new ArrayList<StatesObject>();
                        StatesObject selectCityObj = new StatesObject();
                        selectCityObj.setId("0");
                        selectCityObj.setName("Select State");
                        selectCityObjectList.add(selectCityObj);
                        obj.setStatesObjects(selectCityObjectList);
                        countries.add(obj);

                        if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            JSONArray country = jsonObject.optJSONArray("country");

                            for (int i = 0; i < country.length(); i++) {
                                JSONObject countryJsonObject = country.getJSONObject(i);
                                CountryObject inner = new CountryObject();
                                inner.setId(countryJsonObject.getString("id"));
                                inner.setName(countryJsonObject.getString("name"));

                                states = new ArrayList<StatesObject>();
                                StatesObject obj1 = new StatesObject();
                                obj1.setId("0");
                                obj1.setName("Select State");
                                states.add(obj1);

                                JSONArray statesJsonArray = countryJsonObject.getJSONArray("state");
                                for (int j = 0; j < statesJsonArray.length(); j++) {
                                    StatesObject statesObject = new StatesObject();
                                    statesObject.setId(statesJsonArray.getJSONObject(j).getString("id"));
                                    statesObject.setName(statesJsonArray.getJSONObject(j).getString("name"));
                                    states.add(statesObject);
                                }

                                inner.setStatesObjects(states);

                                countries.add(inner);
                                countryAdapter = new CountryAdapter(getActivity(), 0, countries);
                                countrySpinner.setAdapter(countryAdapter);

                            }

                        } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            countryAdapter = new CountryAdapter(getActivity(), 0, countries);
                            countrySpinner.setAdapter(countryAdapter);
                        }
                        makeFiltersPreFilled();
                    } catch (JSONException e) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }

                    try {
                        current_page = 1;
                        contractorsList = new ArrayList<JobListObject>();
                        contractorsList.clear();
                        adapter = null;
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.MYJOBS_LIST_TAG, Constants.MYJOBS_LIST_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&search_text=" + et_search.getText().toString().trim() + "&page_no=" + current_page + "&country_id=" + COUNTRY_ID + "&state_id=" + STATE_ID, Constants.HTTP_GET, "Home Activity");
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }

                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                } else if (tag.equalsIgnoreCase(Constants.MYJOBS_LIST_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();

                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));

                            if (jsonObject.optJSONArray("job_list").length() != 0) {
                                for (int i = 0; i < jsonObject.optJSONArray("job_list").length(); i++) {
                                    JSONObject contracotrs = jsonObject.optJSONArray("job_list").getJSONObject(i);
                                    JobListObject obj = new JobListObject();
                                    obj.setJobID(contracotrs.optString("job_id"));
                                    obj.setCompanyName(contracotrs.optString("company_name"));
                                    obj.setCompanyLogoImage(contracotrs.optString("company_image"));
                                    obj.setFollowersCount(contracotrs.optString("followers"));
                                    obj.setJobCountry(contracotrs.optString("country"));
                                    obj.setJobState(contracotrs.optString("state"));
                                    obj.setJobLocation(contracotrs.optString("location"));
                                    obj.setJobTitle(contracotrs.optString("job_title"));
                                    obj.setPostedOn(contracotrs.optString("start_date"));


                                    StringBuilder stringBuilder = new StringBuilder();
                                    obj.setJobSkills(stringBuilder.toString());

                                    contractorsList.add(obj);
                                    //Log.e("XXX","NAME"+contracotrs.optString("name")+"++++++ISPUBLIC"+contracotrs.optString("is_profile_public"));

                                }
                            } else {
                                Toast.makeText(getActivity(), "No Contractors found", Toast.LENGTH_LONG).show();
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No Contractors found", Toast.LENGTH_LONG).show();
                        }


                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }

                    if (adapter == null) {
                        adapter = new MyJobsAdapter(getActivity(), contractorsList);
                        list_startups.setAdapter(adapter);
                    }


                    list_startups.onLoadMoreComplete();
                    adapter.notifyDataSetChanged();

                    int index = list_startups.getLastVisiblePosition();
                    list_startups.smoothScrollToPosition(index);
                }

            }
        } catch (Exception e) {

        }
    }


}