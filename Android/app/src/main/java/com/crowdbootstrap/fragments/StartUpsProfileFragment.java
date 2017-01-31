package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ExpandableListView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.adapter.StartupsExpandableListAdapter;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.models.StartupItemsObject;
import com.crowdbootstrap.models.StartupsObject;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by sunakshi.gautam on 1/13/2016.
 */
public class StartUpsProfileFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

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
            if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.CONTRACTOR)) {
                ProfileFragment.editView.setVisibility(View.GONE);
                ProfileFragment.et_rate.setFocusable(false);
                ProfileFragment.et_rate.setBackgroundDrawable(null);
                ProfileFragment.et_rate.setCursorVisible(false);
                ProfileFragment.et_rate.setFocusableInTouchMode(false);
                ProfileFragment.circularImageView.setClickable(false);
            } else {
                EntrepreneurProfileFragment.circularImageView.setClickable(false);
            }

            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity)getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_SELECTED_STARTUPS_TAG, Constants.USER_SELECTED_STARTUPS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&user_type=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE), Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        }
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_profilestartup, container, false);
        btn_addStartup = (Button) rootView.findViewById(R.id.btn_addStartup);


        list = new ArrayList<StartupsObject>();
        lvExp = (ExpandableListView) rootView.findViewById(R.id.lvExp);


        btn_addStartup.setOnClickListener(this);

        return rootView;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {

            case R.id.btn_addStartup:
                Fragment rateContributor = new AddStartupsToProfileFragment();
                ((HomeActivity)getActivity()).replaceFragment(rateContributor);
                /*FragmentTransaction transactionRate = getParentFragment().getFragmentManager().beginTransaction();

                transactionRate.replace(R.id.container, rateContributor);
                transactionRate.addToBackStack(null);

                transactionRate.commit();*/
                break;

        }
    }

    @Override
    public void onResume() {
        super.onResume();

        if (((HomeActivity)getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.CONTRACTOR)){
            ProfileFragment.progressProfileComplete.setProgress(((HomeActivity)getActivity()).prefManager.getInteger(Constants.CONTRACTOR_PROFILE_COMPLETENESS));
            ProfileFragment.tv_profileComplete.setText(ProfileFragment.progressProfileComplete.getProgress() + "% completed");
        }else{
            EntrepreneurProfileFragment.progressProfileComplete.setProgress(((HomeActivity)getActivity()).prefManager.getInteger(Constants.ENTREPRENEUR_PROFILE_COMPLETENESS));
            EntrepreneurProfileFragment.tv_profileComplete.setText(ProfileFragment.progressProfileComplete.getProgress() + "% completed");
        }
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


                               /* for (int j = 0; j < jsonObject.optJSONArray("startup").length(); j++) {*/
                                    StartupItemsObject inner = new StartupItemsObject();
                                    inner.setStartupItemName(jsonObject.optJSONArray("startup").optJSONObject(i).optString("description"));
                                    // System.out.println(jsonObject.optJSONArray("startup").optJSONObject(i).optString("description"));
                                    innerList.add(inner);
                               /*
                                for (int j = 0; j < 5; j++) {
                                    StartupItemsObject inner = new StartupItemsObject();
                                    inner.setStarupItemId("" + (j + 1));
                                    inner.setStartupItemName("Lorum ipsum lorum ipsum");
                                    innerList.add(inner);
                                }
                               */
                                    obj.setItemsObjectArrayList(innerList);
                                    list.add(obj);
                                }
                            }else{
                                Toast.makeText(getActivity(),"No Startups added on your profile", Toast.LENGTH_LONG).show();
                            }



                            adapter = new StartupsExpandableListAdapter(getActivity(), list);

                            Log.d("list", list.size() + "");
                            lvExp.setAdapter(adapter);

                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ENTREPRENEUR_BASIC_PROFILE_TAG, Constants.ENTREPRENEUR_BASIC_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+ "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                a.execute();
                                ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(),"No Startups added on your profile", Toast.LENGTH_LONG).show();
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ENTREPRENEUR_BASIC_PROFILE_TAG, Constants.ENTREPRENEUR_BASIC_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+ "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                a.execute();
                                ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                            } else {
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
                                Toast.makeText(getActivity(),"No Startups added on your profile", Toast.LENGTH_LONG).show();
                            }


                            adapter = new StartupsExpandableListAdapter(getActivity(), list);

                            Log.d("list", list.size() + "");
                            lvExp.setAdapter(adapter);

                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONTRACTOR_BASIC_PROFILE_TAG, Constants.CONTRACTOR_BASIC_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+ "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                a.execute();
                                ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        }else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(),"No Startups added on your profile", Toast.LENGTH_LONG).show();
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONTRACTOR_BASIC_PROFILE_TAG, Constants.CONTRACTOR_BASIC_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+ "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                a.execute();
                                ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        }
                    }
                } catch (JSONException e) {
                    ((HomeActivity)getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.CONTRACTOR_BASIC_PROFILE_TAG)) {
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), ProfileFragment.circularImageView, ((HomeActivity)getActivity()).options);
                        /*ImageLoaderWithoutProgressBar imageLoader = new ImageLoaderWithoutProgressBar(getActivity());
                        imageLoader.DisplayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), ProfileFragment.circularImageView, R.drawable.image);*/
//                        ProfileFragment.progressProfileComplete.setProgress(Integer.parseInt(jsonObject.optString("profile_completeness").trim()));
                        JSONObject basic_information = jsonObject.optJSONObject("basic_information");
                        String[] s = basic_information.optString("name").trim().split(" ");
                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_FIRST_NAME, s[0].trim());
                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_LAST_NAME, s[s.length - 1].trim());
                        HomeActivity.userName.setText(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_FIRST_NAME) + " " + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_LAST_NAME));
                        ProfileFragment.et_username.setText(basic_information.optString("name").trim());

                        if (Integer.parseInt(jsonObject.optString("profile_completeness").trim())==0){
                            ProfileFragment.progressProfileComplete.setProgress(0);
                            ProfileFragment.tv_profileComplete.setText(ProfileFragment.progressProfileComplete.getProgress() + "% completed");
                        }else{
                            ProfileFragment.progressProfileComplete.setProgress(Integer.parseInt(jsonObject.optString("profile_completeness").trim()));
                            ProfileFragment.tv_profileComplete.setText(ProfileFragment.progressProfileComplete.getProgress() + "% completed");
                        }
                        if (jsonObject.optString("perhour_rate").trim().length() == 0) {
                            ProfileFragment.et_rate.setText("$0.00/HR");
                        } else {
                            ProfileFragment.et_rate.setText("$" + ((HomeActivity)getActivity()).utilitiesClass.extractFloatValueFromStrin(jsonObject.optString("perhour_rate")) + "/HR");
                        }
                    } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                    }

                    ((HomeActivity)getActivity()).dismissProgressDialog();
                } catch (JSONException e) {
                    ((HomeActivity)getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.ENTREPRENEUR_BASIC_PROFILE_TAG)) {
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), EntrepreneurProfileFragment.circularImageView, ((HomeActivity)getActivity()).options);
                        /*ImageLoaderWithoutProgressBar imageLoader = new ImageLoaderWithoutProgressBar(getActivity());
                        imageLoader.DisplayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), EntrepreneurProfileFragment.circularImageView, R.drawable.image);*/
                        JSONObject basic_information = jsonObject.optJSONObject("basic_information");
                        EntrepreneurProfileFragment.et_username.setText(basic_information.optString("name").trim());
                        if (Integer.parseInt(jsonObject.optString("profile_completeness").trim())==0){
                            EntrepreneurProfileFragment.progressProfileComplete.setProgress(0);
                            EntrepreneurProfileFragment.tv_profileComplete.setText(EntrepreneurProfileFragment.progressProfileComplete.getProgress()+"% completed");
                        }else{
                            EntrepreneurProfileFragment.progressProfileComplete.setProgress(Integer.parseInt(jsonObject.optString("profile_completeness").trim()));
                            EntrepreneurProfileFragment.tv_profileComplete.setText(EntrepreneurProfileFragment.progressProfileComplete.getProgress() + "% completed");
                        }
                        //EntrepreneurProfileFragment.progressProfileComplete.setProgress(Integer.parseInt(jsonObject.optString("profile_completeness").trim()));
                    }
                    ((HomeActivity)getActivity()).dismissProgressDialog();

                } catch (JSONException e) {
                    ((HomeActivity)getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            }else{
                ((HomeActivity)getActivity()).dismissProgressDialog();
            }
        }
    }
}