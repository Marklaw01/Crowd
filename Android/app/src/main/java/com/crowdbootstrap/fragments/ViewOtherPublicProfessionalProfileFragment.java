package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;
import com.nostra13.universalimageloader.core.ImageLoader;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by neelmani.karn on 2/2/2016.
 */
public class ViewOtherPublicProfessionalProfileFragment extends Fragment implements AsyncTaskCompleteListener<String>, View.OnClickListener {

    /*Textview for contractors*/
    private TextView tv_experience, tv_keyword, tv_qualification, tv_certification, tv_skills, tv_industryfocus, tv_preferedstartup, tv_contributortype;

    /*Textview for entrepreneur*/
    private LinearLayout entrepreneur_layout, contractor_layout;
    private TextView tv_conpanyName, tv_companyUrl, tv_Description, tv_keyword_entrepreneur, tv_qualification_entrepreneur, tv_skills_entrepreneur, tv_industryfocus_entrepreneur;


    private Button btn_addStartup;
    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            // we check that the fragment is becoming visible
            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            ((HomeActivity) getActivity()).showProgressDialog();
            //run your async task here since the user has just focused on your fragment
            if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("home")) {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ENTREPRENEUR_PROFESSIONAL_PROFILE_TAG, Constants.ENTREPRENEUR_PROFESSIONAL_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    } else {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ENTREPRENEUR_PROFESSIONAL_PROFILE_TAG, Constants.ENTREPRENEUR_PROFESSIONAL_PROFILE_URL + ViewOtherEntrepreneurPublicProfileFragment.userId + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    }

                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            } else {
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("home")) {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONTRACTOR_PROFESSIONAL_PROFILE_TAG, Constants.CONTRACTOR_PROFESSIONAL_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    } else {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONTRACTOR_PROFESSIONAL_PROFILE_TAG, Constants.CONTRACTOR_PROFESSIONAL_PROFILE_URL + ViewOtherContractorPublicProfileFragment.userId + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    }

                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            }
            // _hasLoadedOnce = true;

        }
    }

    @Override
    public void onResume() {

        super.onResume();
        // ((HomeActivity) getActivity()).setOnBackPressedListener(this);


        if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("Teams")) {
            btn_addStartup.setVisibility(View.GONE);

        } else if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("public")) {
            btn_addStartup.setVisibility(View.GONE);
        } else if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("entrepreneur")) {
            btn_addStartup.setVisibility(View.GONE);
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
        } else if (Constants.COMMING_FROM_INTENT.compareTo(Constants.LIKE_DISLIKE) == 0) {
            btn_addStartup.setVisibility(View.GONE);
        } else {
            btn_addStartup.setVisibility(View.VISIBLE);
        }
    }

    View rootView;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {
            rootView = inflater.inflate(R.layout.fragment_view_professional_public_profile, container, false);


            contractor_layout = (LinearLayout) rootView.findViewById(R.id.contractor_layout);
            entrepreneur_layout = (LinearLayout) rootView.findViewById(R.id.entrepreneur_layout);
            entrepreneur_layout.setVisibility(View.VISIBLE);
            contractor_layout.setVisibility(View.GONE);
            tv_experience = (TextView) rootView.findViewById(R.id.tv_experience);
            tv_keyword = (TextView) rootView.findViewById(R.id.tv_keyword);
            tv_qualification = (TextView) rootView.findViewById(R.id.tv_qualification);
            tv_certification = (TextView) rootView.findViewById(R.id.tv_certification);
            tv_skills = (TextView) rootView.findViewById(R.id.tv_skills);
            tv_industryfocus = (TextView) rootView.findViewById(R.id.tv_industryfocus);
            tv_preferedstartup = (TextView) rootView.findViewById(R.id.tv_preferedstartup);
            tv_contributortype = (TextView) rootView.findViewById(R.id.tv_contributortype);
            btn_addStartup = (Button) rootView.findViewById(R.id.addcontributor);
            btn_addStartup.setOnClickListener(this);

            tv_conpanyName = (TextView) rootView.findViewById(R.id.tv_conpanyName);
            tv_companyUrl = (TextView) rootView.findViewById(R.id.tv_companyUrl);
            tv_Description = (TextView) rootView.findViewById(R.id.tv_Description);
            tv_keyword_entrepreneur = (TextView) rootView.findViewById(R.id.tv_keyword_entrepreneur);
            tv_qualification_entrepreneur = (TextView) rootView.findViewById(R.id.tv_qualification_entrepreneur);
            tv_skills_entrepreneur = (TextView) rootView.findViewById(R.id.tv_skills_entrepreneur);
            tv_industryfocus_entrepreneur = (TextView) rootView.findViewById(R.id.tv_industryfocus_entrepreneur);

            ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.getText().toString().trim().equalsIgnoreCase("Follow")) {
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();

                            JSONObject jsonObject = new JSONObject();
                            try {

                                jsonObject.put("user_id", ViewOtherEntrepreneurPublicProfileFragment.userId);
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

                                jsonObject.put("user_id", ViewOtherEntrepreneurPublicProfileFragment.userId);
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

        } else {
            rootView = inflater.inflate(R.layout.fragment_view_professional_public_profile, container, false);

            btn_addStartup = (Button) rootView.findViewById(R.id.addcontributor);
            btn_addStartup.setOnClickListener(this);
            contractor_layout = (LinearLayout) rootView.findViewById(R.id.contractor_layout);
            entrepreneur_layout = (LinearLayout) rootView.findViewById(R.id.entrepreneur_layout);
            entrepreneur_layout.setVisibility(View.GONE);
            contractor_layout.setVisibility(View.VISIBLE);
            tv_experience = (TextView) rootView.findViewById(R.id.tv_experience);
            tv_keyword = (TextView) rootView.findViewById(R.id.tv_keyword);
            tv_qualification = (TextView) rootView.findViewById(R.id.tv_qualification);
            tv_certification = (TextView) rootView.findViewById(R.id.tv_certification);
            tv_skills = (TextView) rootView.findViewById(R.id.tv_skills);
            tv_industryfocus = (TextView) rootView.findViewById(R.id.tv_industryfocus);
            tv_preferedstartup = (TextView) rootView.findViewById(R.id.tv_preferedstartup);
            tv_contributortype = (TextView) rootView.findViewById(R.id.tv_contributortype);


            tv_conpanyName = (TextView) rootView.findViewById(R.id.tv_conpanyName);
            tv_companyUrl = (TextView) rootView.findViewById(R.id.tv_companyUrl);
            tv_Description = (TextView) rootView.findViewById(R.id.tv_Description);
            tv_keyword_entrepreneur = (TextView) rootView.findViewById(R.id.tv_keyword_entrepreneur);
            tv_qualification_entrepreneur = (TextView) rootView.findViewById(R.id.tv_qualification_entrepreneur);
            tv_skills_entrepreneur = (TextView) rootView.findViewById(R.id.tv_skills_entrepreneur);
            tv_industryfocus_entrepreneur = (TextView) rootView.findViewById(R.id.tv_industryfocus_entrepreneur);

            ViewOtherContractorPublicProfileFragment.cbx_Follow.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (ViewOtherContractorPublicProfileFragment.cbx_Follow.getText().toString().trim().equalsIgnoreCase("Follow")) {
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();

                            JSONObject jsonObject = new JSONObject();
                            try {

                                jsonObject.put("user_id", ViewOtherContractorPublicProfileFragment.userId);
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

                                jsonObject.put("user_id", ViewOtherContractorPublicProfileFragment.userId);
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
        }


        //addcontributor = (Button)rootView.findViewById(R.id.addcontributor);


        if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {

        } else {

        }


        /*addcontributor.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Fragment fragment = new AddContributor();
                getParentFragment().getFragmentManager().beginTransaction().addToBackStack(null).replace(R.id.container, fragment).commit();
            }
        });*/


        return rootView;
    }

    public ViewOtherPublicProfessionalProfileFragment() {
        super();
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
            if (tag.equalsIgnoreCase(Constants.CONTRACTOR_PROFESSIONAL_PROFILE_TAG)) {
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);
                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        ViewOtherContractorPublicProfileFragment.tv_username.setText(jsonObject.optString("name"));
                        if (jsonObject.optString("perhour_rate").trim().length() == 0) {
                            ViewOtherContractorPublicProfileFragment.tv_rate.setText("$0.00/HR");
                        } else {
                            ViewOtherContractorPublicProfileFragment.tv_rate.setText(((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat(jsonObject.optString("perhour_rate")) + "/HR");
                        }

                        int followed = Integer.parseInt(jsonObject.getString("isFollowing"));
                        if (followed == 0) {
                            ViewOtherContractorPublicProfileFragment.cbx_Follow.setText("Follow");
                            ViewOtherContractorPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                        } else {
                            ViewOtherContractorPublicProfileFragment.cbx_Follow.setText("UnFollow");
                            ViewOtherContractorPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                        }

                        /*ImageLoaderWithoutProgressBar imageLoader = new ImageLoaderWithoutProgressBar(getActivity());
                        imageLoader.DisplayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), ViewOtherContractorPublicProfileFragment.circularImageView, R.drawable.image);
*/
                        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), ViewOtherContractorPublicProfileFragment.circularImageView, ((HomeActivity) getActivity()).options);
                        /*try {
                            Picasso.with(getActivity())
                                    .load(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim())
                                    .placeholder(R.drawable.image)
                                    .error(R.drawable.app_icon)
                                    .into(ViewOtherContractorPublicProfileFragment.circularImageView);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }*/
                        JSONObject professional_information = jsonObject.optJSONObject("professional_information");
                        tv_experience.setText("Experience: " + professional_information.optString("experience"));
                        tv_industryfocus.setText("Industry Focus: " + professional_information.optString("industry_focus"));
                        tv_preferedstartup.setText("Preferred Startup: " + professional_information.optString("preferred_startup"));
                        tv_contributortype.setText("Contractor Type: " + professional_information.optString("contractor_type"));
                        StringBuilder stringBuilder = new StringBuilder();
                        if (professional_information.length() > 0) {
                            if (professional_information.has("keywords")) {
                                for (int i = 0; i < professional_information.optJSONArray("keywords").length(); i++) {
                                    //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                    if ((i >= 0) && (i < (professional_information.optJSONArray("keywords").length() - 1))) {
                                        stringBuilder.append(professional_information.optJSONArray("keywords").getJSONObject(i).optString("name") + ", ");

                                    } else {
                                        stringBuilder.append(professional_information.optJSONArray("keywords").getJSONObject(i).optString("name") + " ");
                                    }
                                }
                                tv_keyword.setText("Keywords: " + stringBuilder.toString());
                            }


                            stringBuilder = new StringBuilder();
                            if (professional_information.has("qualifications")) {
                                for (int i = 0; i < professional_information.optJSONArray("qualifications").length(); i++) {
                                    //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                    if ((i >= 0) && (i < (professional_information.optJSONArray("qualifications").length() - 1))) {
                                        stringBuilder.append(professional_information.optJSONArray("qualifications").getJSONObject(i).optString("name") + ", ");

                                    } else {
                                        stringBuilder.append(professional_information.optJSONArray("qualifications").getJSONObject(i).optString("name") + " ");
                                    }
                                }
                                tv_qualification.setText("Qualifications: " + stringBuilder.toString());
                            }


                            stringBuilder = new StringBuilder();
                            if (professional_information.has("certifications")) {
                                for (int i = 0; i < professional_information.optJSONArray("certifications").length(); i++) {
                                    //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                    if ((i >= 0) && (i < (professional_information.optJSONArray("certifications").length() - 1))) {
                                        stringBuilder.append(professional_information.optJSONArray("certifications").getJSONObject(i).optString("name") + ", ");

                                    } else {
                                        stringBuilder.append(professional_information.optJSONArray("certifications").getJSONObject(i).optString("name") + " ");
                                    }
                                }
                                tv_certification.setText("Certifications: " + stringBuilder.toString());
                            }


                            stringBuilder = new StringBuilder();
                            if (professional_information.has("skills")) {
                                for (int i = 0; i < professional_information.optJSONArray("skills").length(); i++) {
                                    //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                    if ((i >= 0) && (i < (professional_information.optJSONArray("skills").length() - 1))) {
                                        stringBuilder.append(professional_information.optJSONArray("skills").getJSONObject(i).optString("name") + ", ");

                                    } else {
                                        stringBuilder.append(professional_information.optJSONArray("skills").getJSONObject(i).optString("name") + " ");
                                    }
                                }
                                tv_skills.setText("Skills: " + stringBuilder.toString());
                            }


                        }

                        //Toast.makeText(getActivity(), professional_information.toString(), Toast.LENGTH_SHORT).show();

                    } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                    }
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.ENTREPRENEUR_PROFESSIONAL_PROFILE_TAG)) {
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);
                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        ViewOtherEntrepreneurPublicProfileFragment.tv_username.setText(jsonObject.optString("name"));
                        ViewOtherEntrepreneurPublicProfileFragment.tv_rate.setText(jsonObject.optString("perhour_rate").trim() + "/HR");

                        int followed = Integer.parseInt(jsonObject.getString("isFollowing"));
                        if (followed == 0) {
                            ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.setText("Follow");
                            ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                        } else {
                            ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.setText("UnFollow");
                            ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                        }

                        /*if (jsonObject.optString("perhour_rate").trim().length() == 0) {
                            ViewOtherContractorPublicProfileFragment.tv_rate.setText("$0.00/HR");
                        } else {
                            ViewOtherContractorPublicProfileFragment.tv_rate.setText("$" + ((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(jsonObject.optString("perhour_rate")) + "/HR");
                        }*/
                        /*ImageLoaderWithoutProgressBar imageLoader = new ImageLoaderWithoutProgressBar(getActivity());
                        imageLoader.DisplayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), ViewOtherEntrepreneurPublicProfileFragment.circularImageView, R.drawable.image);
*/
                        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), ViewOtherEntrepreneurPublicProfileFragment.circularImageView, ((HomeActivity) getActivity()).options);

                        JSONObject professional_information = jsonObject.optJSONObject("professional_information");
                        tv_conpanyName.setText("Company Name: " + professional_information.optString("compnay_name").trim());
                        tv_industryfocus_entrepreneur.setText("Industry Focus: " + professional_information.optString("industry_focus"));
                        tv_companyUrl.setText("Link: " + professional_information.optString("website_link"));
                        tv_Description.setBackgroundResource(R.drawable.multiline_textview);
                        tv_Description.setText("Description: " + professional_information.optString("description"));


                        if (professional_information.length() > 0) {
                            StringBuilder stringBuilder = new StringBuilder();
                            if (professional_information.has("keywords")) {
                                for (int i = 0; i < professional_information.optJSONArray("keywords").length(); i++) {
                                    //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                    if ((i >= 0) && (i < (professional_information.optJSONArray("keywords").length() - 1))) {
                                        stringBuilder.append(professional_information.optJSONArray("keywords").getJSONObject(i).optString("name") + ", ");

                                    } else {
                                        stringBuilder.append(professional_information.optJSONArray("keywords").getJSONObject(i).optString("name") + " ");
                                    }
                                }
                                tv_keyword_entrepreneur.setText("Keywords: " + stringBuilder.toString());
                            }


                            stringBuilder = new StringBuilder();
                            if (professional_information.has("qualifications")) {
                                for (int i = 0; i < professional_information.optJSONArray("qualifications").length(); i++) {
                                    //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                    if ((i >= 0) && (i < (professional_information.optJSONArray("qualifications").length() - 1))) {
                                        stringBuilder.append(professional_information.optJSONArray("qualifications").getJSONObject(i).optString("name") + ", ");

                                    } else {
                                        stringBuilder.append(professional_information.optJSONArray("qualifications").getJSONObject(i).optString("name") + " ");
                                    }
                                }
                                tv_qualification_entrepreneur.setText("Qualifications: " + stringBuilder.toString());
                            }


                            stringBuilder = new StringBuilder();
                            if (professional_information.has("skills")) {
                                for (int i = 0; i < professional_information.optJSONArray("skills").length(); i++) {
                                    //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                    if ((i >= 0) && (i < (professional_information.optJSONArray("skills").length() - 1))) {
                                        stringBuilder.append(professional_information.optJSONArray("skills").getJSONObject(i).optString("name") + ", ");

                                    } else {
                                        stringBuilder.append(professional_information.optJSONArray("skills").getJSONObject(i).optString("name") + " ");
                                    }
                                }
                                tv_skills_entrepreneur.setText("Skills: " + stringBuilder.toString());
                            }


                        }

                        //Toast.makeText(getActivity(), professional_information.toString(), Toast.LENGTH_SHORT).show();

                    } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

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
                                ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.setText("UnFollow");
                                ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                            } else {
                                ViewOtherContractorPublicProfileFragment.cbx_Follow.setText("UnFollow");
                                ViewOtherContractorPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                            }

                        } else if (jsonObject.optString("message").equalsIgnoreCase("successfully deleted")) {

                            if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {
                                ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.setText("Follow");
                                ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                            } else {
                                ViewOtherContractorPublicProfileFragment.cbx_Follow.setText("Follow");
                                ViewOtherContractorPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGreen));
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

    @Override
    public void onClick(View view) {
        switch (view.getId()) {

            case R.id.addcontributor:


                if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("Teams") || Constants.COMMING_FROM_INTENT.equalsIgnoreCase("home")) {
                    Fragment rateContributor = new RateContributor();
                    ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                    /*FragmentTransaction transactionRate = getParentFragment().getFragmentManager().beginTransaction();

                    transactionRate.replace(R.id.container, rateContributor);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();*/
                } else if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("entrepreneur")) {
                    Fragment rateContributor = new RateContributor();
                    ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                    /*FragmentTransaction transactionRate = getParentFragment().getFragmentManager().beginTransaction();

                    transactionRate.replace(R.id.container, rateContributor);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();*/
                } else {
                    Fragment rateContributor = new AddContributor();

                    Bundle bundle = new Bundle();
                    Log.e("contractor_id", ViewOtherContractorPublicProfileFragment.userId);
                    bundle.putString("contractor_id", ViewOtherContractorPublicProfileFragment.userId);
                    bundle.putString("contractor_name", ViewOtherContractorPublicProfileFragment.tv_username.getText().toString().trim());
                    bundle.putString("hourly_rate", ViewOtherContractorPublicProfileFragment.tv_rate.getText().toString().trim());

                    rateContributor.setArguments(bundle);
                    ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                    /*FragmentTransaction transactionRate = getParentFragment().getFragmentManager().beginTransaction();
                    transactionRate.replace(R.id.container, rateContributor);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();*/
                }

                break;

        }
    }
}
