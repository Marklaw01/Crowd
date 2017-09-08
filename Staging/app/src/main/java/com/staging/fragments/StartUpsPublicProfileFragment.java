package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ExpandableListView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.StartupsExpandableListAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.models.StartupItemsObject;
import com.staging.models.StartupsObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.nostra13.universalimageloader.core.ImageLoader;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by sunakshi.gautam on 1/13/2016.
 */
public class StartUpsPublicProfileFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    private Button btn_addStartup;
    StartupsExpandableListAdapter adapter;
    ExpandableListView lvExp;
    ArrayList<StartupsObject> list;


    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            // we check that the fragment is becoming visible
            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            ((HomeActivity) getActivity()).showProgressDialog();

            if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {

                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("home")) {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_SELECTED_STARTUPS_TAG, Constants.USER_SELECTED_STARTUPS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&user_type=" + Constants.ENTREPRENEUR, Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    } else {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_SELECTED_STARTUPS_TAG, Constants.USER_SELECTED_STARTUPS_URL + "?user_id=" + ViewEntrepreneurPublicProfileFragment.userId + "&user_type=" + Constants.ENTREPRENEUR, Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    }

                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            } else {
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("home")) {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_SELECTED_STARTUPS_TAG, Constants.USER_SELECTED_STARTUPS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&user_type=" + Constants.CONTRACTOR, Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    } else {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_SELECTED_STARTUPS_TAG, Constants.USER_SELECTED_STARTUPS_URL + "?user_id=" + ViewContractorPublicProfileFragment.userId + "&user_type=" + Constants.CONTRACTOR, Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    }

                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            }




         /*   if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_SELECTED_STARTUPS_TAG, Constants.USER_SELECTED_STARTUPS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&user_type=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE), Constants.HTTP_GET);
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }*/
        }
    }
    //Button addContributor, rateContributor;

    @Override
    public void onResume() {
        super.onResume();
        if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("Teams")) {
            btn_addStartup.setText("Rate Contractor");

        } else if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("public")) {
            btn_addStartup.setText("Rate Contractor");
        } else if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("entrepreneur")) {
            btn_addStartup.setText("Rate Entrepreneur");
        } else if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("STARTUP_DETAILS")) {
            btn_addStartup.setVisibility(View.GONE);
        } else if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("searchprofile")) {
            btn_addStartup.setText("Add Contractor");
        } else if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("recommendedContractors")) {
            btn_addStartup.setText("Add Contractor");
        } else if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("campaignsearch")) {
            btn_addStartup.setVisibility(View.GONE);
        } else if (Constants.COMMING_FROM_INTENT.compareTo("home") == 0) {
            btn_addStartup.setVisibility(View.GONE);
        } else {
            btn_addStartup.setVisibility(View.VISIBLE);
        }
    }

    View rootView;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {
            rootView = inflater.inflate(R.layout.fragment_profilestartup, container, false);
            btn_addStartup = (Button) rootView.findViewById(R.id.btn_addStartup);

            //btn_addStartup.setVisibility(View.GONE);

            list = new ArrayList<StartupsObject>();
            lvExp = (ExpandableListView) rootView.findViewById(R.id.lvExp);

            ViewEntrepreneurPublicProfileFragment.cbx_Follow.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (ViewEntrepreneurPublicProfileFragment.cbx_Follow.getText().toString().trim().equalsIgnoreCase("Follow")) {
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();

                            JSONObject jsonObject = new JSONObject();
                            try {

                                jsonObject.put("user_id", ViewEntrepreneurPublicProfileFragment.userId);
                                jsonObject.put("followed_by", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                                jsonObject.put("status", 1);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FOLLOW_USER_TAG, Constants.FOLLOW_USER_URL, Constants.HTTP_POST, jsonObject,"Home Activity");
                            a.execute();
                        } else {
                            //((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } else {

                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();

                            JSONObject jsonObject = new JSONObject();
                            try {

                                jsonObject.put("user_id", ViewEntrepreneurPublicProfileFragment.userId);
                                jsonObject.put("followed_by", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                                jsonObject.put("status", 0);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FOLLOW_USER_TAG, Constants.FOLLOW_USER_URL, Constants.HTTP_POST, jsonObject,"Home Activity");
                            a.execute();
                        } else {
                            // ((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    }
                }
            });
        /*for (int i = 0; i < 5; i++) {
            StartupsObject obj = new StartupsObject();
            obj.setId("" + (i + 1));
            obj.setStartupName("Startup " + (i + 1));
            ArrayList<StartupItemsObject> innerList = new ArrayList<StartupItemsObject>();
            for (int j = 0; j < 5; j++) {
                StartupItemsObject inner = new StartupItemsObject();
                inner.setStarupItemId("" + (j + 1));
                inner.setStartupItemName("Lorum ipsum lorum ipsum");
                innerList.add(inner);
            }
            obj.setItemsObjectArrayList(innerList);
            list.add(obj);
        }*/
            btn_addStartup.setOnClickListener(this);
        /*ratecontributor.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Fragment rateContributor = new AddStartupFragment();
                FragmentTransaction transactionRate = getParentFragment().getFragmentManager().beginTransaction();
                transactionRate.add(R.id.container, rateContributor);
                transactionRate.addToBackStack(null);
                transactionRate.commit();
            }
        });*/

        /*adapter = new StartupsExpandableListAdapter(getActivity(), list);
        lvExp.setAdapter(adapter);*/
        } else {
            rootView = inflater.inflate(R.layout.fragment_profilestartup, container, false);
            btn_addStartup = (Button) rootView.findViewById(R.id.btn_addStartup);

            //btn_addStartup.setVisibility(View.GONE);

            list = new ArrayList<StartupsObject>();
            lvExp = (ExpandableListView) rootView.findViewById(R.id.lvExp);


            ViewContractorPublicProfileFragment.cbx_Follow.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (ViewContractorPublicProfileFragment.cbx_Follow.getText().toString().trim().equalsIgnoreCase("Follow")) {
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();

                            JSONObject jsonObject = new JSONObject();
                            try {

                                jsonObject.put("user_id", ViewContractorPublicProfileFragment.userId);
                                jsonObject.put("followed_by", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                                jsonObject.put("status", 1);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FOLLOW_USER_TAG, Constants.FOLLOW_USER_URL, Constants.HTTP_POST, jsonObject,"Home Activity");
                            a.execute();
                        } else {
                            //((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } else {

                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();

                            JSONObject jsonObject = new JSONObject();
                            try {

                                jsonObject.put("user_id", ViewContractorPublicProfileFragment.userId);
                                jsonObject.put("followed_by", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                                jsonObject.put("status", 0);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FOLLOW_USER_TAG, Constants.FOLLOW_USER_URL, Constants.HTTP_POST, jsonObject,"Home Activity");
                            a.execute();
                        } else {
                            // ((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }

                    }
                }
            });

        /*for (int i = 0; i < 5; i++) {
            StartupsObject obj = new StartupsObject();
            obj.setId("" + (i + 1));
            obj.setStartupName("Startup " + (i + 1));
            ArrayList<StartupItemsObject> innerList = new ArrayList<StartupItemsObject>();
            for (int j = 0; j < 5; j++) {
                StartupItemsObject inner = new StartupItemsObject();
                inner.setStarupItemId("" + (j + 1));
                inner.setStartupItemName("Lorum ipsum lorum ipsum");
                innerList.add(inner);
            }
            obj.setItemsObjectArrayList(innerList);
            list.add(obj);
        }*/
            btn_addStartup.setOnClickListener(this);
        /*ratecontributor.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Fragment rateContributor = new AddStartupFragment();
                FragmentTransaction transactionRate = getParentFragment().getFragmentManager().beginTransaction();
                transactionRate.add(R.id.container, rateContributor);
                transactionRate.addToBackStack(null);
                transactionRate.commit();
            }
        });*/

        /*adapter = new StartupsExpandableListAdapter(getActivity(), list);
        lvExp.setAdapter(adapter);*/
        }


        return rootView;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {

            case R.id.btn_addStartup:


                if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("Teams") || Constants.COMMING_FROM_INTENT.equalsIgnoreCase("home")) {
                    Fragment rateContributor = new RateContributor();
                    ((HomeActivity)getActivity()).replaceFragment(rateContributor);
                    /*FragmentTransaction transactionRate = getParentFragment().getFragmentManager().beginTransaction();

                    transactionRate.replace(R.id.container, rateContributor);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();*/
                } else if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("entrepreneur")) {
                    Fragment rateContributor = new RateContributor();
                    ((HomeActivity)getActivity()).replaceFragment(rateContributor);
                    /*FragmentTransaction transactionRate = getParentFragment().getFragmentManager().beginTransaction();

                    transactionRate.replace(R.id.container, rateContributor);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();*/
                } else {
                    Fragment rateContributor = new AddContributor();

                    Bundle bundle = new Bundle();
                    Log.e("contractor_id", ViewContractorPublicProfileFragment.userId);
                    bundle.putString("contractor_id", ViewContractorPublicProfileFragment.userId);
                    bundle.putString("contractor_name", ViewContractorPublicProfileFragment.tv_username.getText().toString().trim());
                    bundle.putString("hourly_rate", ViewContractorPublicProfileFragment.tv_rate.getText().toString().trim());

                    rateContributor.setArguments(bundle);
                    ((HomeActivity)getActivity()).replaceFragment(rateContributor);
                    /*FragmentTransaction transactionRate = getParentFragment().getFragmentManager().beginTransaction();
                    transactionRate.replace(R.id.container, rateContributor);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();*/
                }

                break;

        }
    }

    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            if (tag.equalsIgnoreCase(Constants.USER_SELECTED_STARTUPS_TAG)) {
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);
                    if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            list.clear();
                            if (jsonObject.optJSONArray("startup").length()!=0){
                                for (int i = 0; i < jsonObject.optJSONArray("startup").length(); i++) {
                                    StartupsObject obj = new StartupsObject();
                                    obj.setStartupName(jsonObject.optJSONArray("startup").optJSONObject(i).optString("name"));
                                    obj.setDescription(jsonObject.optJSONArray("startup").optJSONObject(i).optString("description"));
                                    ArrayList<StartupItemsObject> innerList = new ArrayList<StartupItemsObject>();

                                    StartupItemsObject inner = new StartupItemsObject();
                                    inner.setStartupItemName(jsonObject.optJSONArray("startup").optJSONObject(i).optString("description"));
                                    innerList.add(inner);
                                    obj.setItemsObjectArrayList(innerList);
                                    list.add(obj);
                                }
                            }else{
                                Toast.makeText(getActivity(),"No Startups found", Toast.LENGTH_LONG).show();
                            }
                            adapter = new StartupsExpandableListAdapter(getActivity(), list);

                            Log.d("list", list.size() + "");
                            lvExp.setAdapter(adapter);

                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("home")) {
                                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ENTREPRENEUR_BASIC_PROFILE_TAG, Constants.ENTREPRENEUR_BASIC_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                    a.execute();
                                } else {
                                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ENTREPRENEUR_BASIC_PROFILE_TAG, Constants.ENTREPRENEUR_BASIC_PROFILE_URL + ViewEntrepreneurPublicProfileFragment.userId + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                    a.execute();
                                }

                                ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                            } else {

                                ((HomeActivity) getActivity()).dismissProgressDialog();
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(),"No Startups found", Toast.LENGTH_LONG).show();
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("home")) {
                                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ENTREPRENEUR_BASIC_PROFILE_TAG, Constants.ENTREPRENEUR_BASIC_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                    a.execute();
                                } else {
                                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ENTREPRENEUR_BASIC_PROFILE_TAG, Constants.ENTREPRENEUR_BASIC_PROFILE_URL + ViewEntrepreneurPublicProfileFragment.userId + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                    a.execute();
                                }

                                ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                            } else {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        }
                    } else {
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            list.clear();
                            if (jsonObject.optJSONArray("startup").length()!=0){
                                for (int i = 0; i < jsonObject.optJSONArray("startup").length(); i++) {
                                    StartupsObject obj = new StartupsObject();
                                    obj.setStartupName(jsonObject.optJSONArray("startup").optJSONObject(i).optString("name"));
                                    obj.setDescription(jsonObject.optJSONArray("startup").optJSONObject(i).optString("description"));

                                    ArrayList<StartupItemsObject> innerList = new ArrayList<StartupItemsObject>();

                               /* for (int j = 0; j < jsonObject.optJSONArray("startup").length(); j++) {*/
                                    StartupItemsObject inner = new StartupItemsObject();
                                    inner.setStartupItemName(jsonObject.optJSONArray("startup").optJSONObject(i).optString("description"));
                                    // System.out.println(jsonObject.optJSONArray("startup").optJSONObject(i).optString("description"));
                                    innerList.add(inner);
                                    //}
                                /*for (int j = 0; j < 5; j++) {
                                    StartupItemsObject inner = new StartupItemsObject();
                                    inner.setStarupItemId("" + (j + 1));
                                    inner.setStartupItemName("Lorum ipsum lorum ipsum");
                                    innerList.add(inner);
                                }*/
                                    obj.setItemsObjectArrayList(innerList);
                                    list.add(obj);
                                }
                            }else{
                                Toast.makeText(getActivity(),"No Startups found", Toast.LENGTH_LONG).show();
                            }


                            adapter = new StartupsExpandableListAdapter(getActivity(), list);

                            Log.d("list", list.size() + "");
                            lvExp.setAdapter(adapter);

                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("home")) {
                                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONTRACTOR_BASIC_PROFILE_TAG, Constants.CONTRACTOR_BASIC_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                    a.execute();
                                } else {
                                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONTRACTOR_BASIC_PROFILE_TAG, Constants.CONTRACTOR_BASIC_PROFILE_URL + ViewContractorPublicProfileFragment.userId + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                    a.execute();
                                }

                                ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                            } else {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(),"No Startups found", Toast.LENGTH_LONG).show();
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("home")) {
                                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONTRACTOR_BASIC_PROFILE_TAG, Constants.CONTRACTOR_BASIC_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                    a.execute();
                                } else {
                                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONTRACTOR_BASIC_PROFILE_TAG, Constants.CONTRACTOR_BASIC_PROFILE_URL + ViewContractorPublicProfileFragment.userId + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                    a.execute();
                                }

                                ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                            } else {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        }
                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.CONTRACTOR_BASIC_PROFILE_TAG)) {
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), ViewContractorPublicProfileFragment.circularImageView, ((HomeActivity) getActivity()).options);
                        /*ImageLoaderWithoutProgressBar imageLoader = new ImageLoaderWithoutProgressBar(getActivity());
                        imageLoader.DisplayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), ViewContractorPublicProfileFragment.circularImageView, R.drawable.image);*/
//                        ProfileFragment.progressProfileComplete.setProgress(Integer.parseInt(jsonObject.optString("profile_completeness").trim()));
                        JSONObject basic_information = jsonObject.optJSONObject("basic_information");
                        String[] s = basic_information.optString("name").trim().split(" ");

                        if (ViewContractorPublicProfileFragment.userId.equalsIgnoreCase(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID))) {

                            ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_FIRST_NAME, s[0].trim());
                            ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_LAST_NAME, s[s.length - 1].trim());

                            HomeActivity.userName.setText(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_FIRST_NAME) + " " + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_LAST_NAME));

                        }

                        int followed = Integer.parseInt(jsonObject.getString("isFollowing"));
                        if (followed == 0) {
                            ViewContractorPublicProfileFragment.cbx_Follow.setText("Follow");
                            ViewContractorPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                        } else {
                            ViewContractorPublicProfileFragment.cbx_Follow.setText("UnFollow");
                            ViewContractorPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                        }

                       /*

                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_FIRST_NAME, s[0].trim());
                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_LAST_NAME, s[s.length - 1].trim());*/
                        HomeActivity.userName.setText(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_FIRST_NAME) + " " + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_LAST_NAME));
                        ViewContractorPublicProfileFragment.tv_username.setText(basic_information.optString("name").trim());
                        if (jsonObject.optString("perhour_rate").trim().length() == 0) {
                            ViewContractorPublicProfileFragment.tv_rate.setText("$0.00/HR");
                        } else {
                            ViewContractorPublicProfileFragment.tv_rate.setText("$" + ((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(jsonObject.optString("perhour_rate")) + "/HR");
                        }
                    } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                    }

                    ((HomeActivity) getActivity()).dismissProgressDialog();
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.ENTREPRENEUR_BASIC_PROFILE_TAG)) {
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), ViewEntrepreneurPublicProfileFragment.circularImageView, ((HomeActivity) getActivity()).options);
                        /*ImageLoaderWithoutProgressBar imageLoader = new ImageLoaderWithoutProgressBar(getActivity());
                        imageLoader.DisplayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), ViewEntrepreneurPublicProfileFragment.circularImageView, R.drawable.image);*/
                        JSONObject basic_information = jsonObject.optJSONObject("basic_information");
                        ViewEntrepreneurPublicProfileFragment.tv_username.setText(basic_information.optString("name").trim());
                        //EntrepreneurProfileFragment.progressProfileComplete.setProgress(Integer.parseInt(jsonObject.optString("profile_completeness").trim()));

                        int followed = Integer.parseInt(jsonObject.getString("isFollowing"));
                        if (followed == 0) {
                            ViewEntrepreneurPublicProfileFragment.cbx_Follow.setText("Follow");
                            ViewEntrepreneurPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                        } else {
                            ViewEntrepreneurPublicProfileFragment.cbx_Follow.setText("UnFollow");
                            ViewEntrepreneurPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                        }

                    }
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.FOLLOW_USER_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        if (jsonObject.optString("message").equalsIgnoreCase("Successfully following")) {
                            if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {
                                ViewEntrepreneurPublicProfileFragment.cbx_Follow.setText("UnFollow");
                                ViewEntrepreneurPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                            } else {
                                ViewContractorPublicProfileFragment.cbx_Follow.setText("UnFollow");
                                ViewContractorPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                            }

                        } else if (jsonObject.optString("message").equalsIgnoreCase("successfully deleted")) {

                            if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {
                                ViewEntrepreneurPublicProfileFragment.cbx_Follow.setText("Follow");
                                ViewEntrepreneurPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                            } else {
                                ViewContractorPublicProfileFragment.cbx_Follow.setText("Follow");
                                ViewContractorPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                            }
                        }
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                    }


                } catch (JSONException e) {
                    e.printStackTrace();
                }
            } else {
                ((HomeActivity) getActivity()).dismissProgressDialog();
            }
        }
    }
/*
    @Override
    public void onClick(View v) {
        switch (v.getId()) {

            case R.id.ratecontributor:
                Fragment rateContributor = new RateContributor();
                FragmentTransaction transactionRate = getParentFragment().getFragmentManager().beginTransaction();

                transactionRate.replace(R.id.container, rateContributor);
                transactionRate.addToBackStack(null);

                transactionRate.commit();
                break;

            case R.id.addcontributor:
                Fragment addContributor = new AddContributor();
                FragmentTransaction transactionAdd = getParentFragment().getFragmentManager().beginTransaction();

                transactionAdd.replace(R.id.container, addContributor);
                transactionAdd.addToBackStack(null);

                transactionAdd.commit();

                break;

        }
    }*/
}
