package com.crowdbootstrapapp.fragments;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.utilities.Async;
import com.crowdbootstrapapp.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by neelmani.karn on 2/2/2016.
 */
public class ViewOtherBasicPublicProfileFragment extends Fragment implements AsyncTaskCompleteListener<String> {

    private TextView tv_bio, tv_name, tv_email, tv_dob, tv_phone, tv_city, tv_country, tv_myInterests;


    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            // we check that the fragment is becoming visible

            ((HomeActivity) getActivity()).showProgressDialog();
            //run your async task here since the user has just focused on your fragment
            if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("home")) {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ENTREPRENEUR_BASIC_PROFILE_TAG, Constants.ENTREPRENEUR_BASIC_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    } else {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ENTREPRENEUR_BASIC_PROFILE_TAG, Constants.ENTREPRENEUR_BASIC_PROFILE_URL + ViewOtherEntrepreneurPublicProfileFragment.userId + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    }

                    ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            } else {
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("home")) {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONTRACTOR_BASIC_PROFILE_TAG, Constants.CONTRACTOR_BASIC_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    } else {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONTRACTOR_BASIC_PROFILE_TAG, Constants.CONTRACTOR_BASIC_PROFILE_URL + ViewOtherContractorPublicProfileFragment.userId + "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    }
                    ((HomeActivity) getActivity()).setOnBackPressedListener(this);
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
        //((HomeActivity) getActivity()).setOnBackPressedListener(this);
    }

    View rootView;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {
            rootView = inflater.inflate(R.layout.fragment_view_basic_public_profile, container, false);


            tv_bio = (TextView) rootView.findViewById(R.id.tv_bio);
            tv_name = (TextView) rootView.findViewById(R.id.tv_name);
            tv_email = (TextView) rootView.findViewById(R.id.tv_email);
            tv_dob = (TextView) rootView.findViewById(R.id.tv_dob);
            tv_phone = (TextView) rootView.findViewById(R.id.tv_phone);
            tv_city = (TextView) rootView.findViewById(R.id.tv_city);
            tv_country = (TextView) rootView.findViewById(R.id.tv_country);
            tv_myInterests = (TextView) rootView.findViewById(R.id.tv_myInterests);

            tv_myInterests.setVisibility(View.VISIBLE);
            ((HomeActivity) getActivity()).setOnBackPressedListener(this);


            ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.getText().toString().trim().equalsIgnoreCase("Follow")) {
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();

                            JSONObject jsonObject = new JSONObject();
                            try {

                                jsonObject.put("user_id", ViewOtherEntrepreneurPublicProfileFragment.userId);
                                jsonObject.put("followed_by", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) );
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
                                jsonObject.put("followed_by", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) );
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
            rootView = inflater.inflate(R.layout.fragment_view_basic_public_profile, container, false);

            tv_bio = (TextView) rootView.findViewById(R.id.tv_bio);
            tv_name = (TextView) rootView.findViewById(R.id.tv_name);
            tv_email = (TextView) rootView.findViewById(R.id.tv_email);
            tv_dob = (TextView) rootView.findViewById(R.id.tv_dob);
            tv_phone = (TextView) rootView.findViewById(R.id.tv_phone);
            tv_city = (TextView) rootView.findViewById(R.id.tv_city);
            tv_country = (TextView) rootView.findViewById(R.id.tv_country);
            tv_myInterests = (TextView) rootView.findViewById(R.id.tv_myInterests);

            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            tv_myInterests.setVisibility(View.GONE);


            ViewOtherContractorPublicProfileFragment.connectionOption.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    if (ViewOtherContractorPublicProfileFragment.connectionOption.getText().toString().trim().compareTo("Connect") == 0) {
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONNECT_USER_TAG, Constants.CONNECT_USER_URL+"?connection_by="+ ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+"&connection_to="+ ViewOtherContractorPublicProfileFragment.userId + "&status=0", Constants.HTTP_GET, "Home Activity");
                            a.execute();
                        } else {
                            //((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }

                    } else if (ViewOtherContractorPublicProfileFragment.connectionOption.getText().toString().trim().compareTo("Disconnect") == 0) {
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.DISCONNECT_USER_TAG, Constants.DISCONNECT_USER_URL+"?user_id="+ ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+"&connection_id="+ connectionID, Constants.HTTP_GET, "Home Activity");
                            a.execute();
                        } else {
                            //((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }

                    }

                    else if (ViewOtherContractorPublicProfileFragment.connectionOption.getText().toString().trim().compareTo("Request Sent") == 0) {
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.DISCONNECT_USER_TAG, Constants.DISCONNECT_USER_URL+"?user_id="+ ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+"&connection_id="+ connectionID, Constants.HTTP_GET, "Home Activity");
                            a.execute();
                        } else {
                            //((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }

                    }
                    else if (ViewOtherContractorPublicProfileFragment.connectionOption.getText().toString().trim().compareTo("Respond") == 0) {

                        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                        alertDialogBuilder
                                .setMessage("Do you want to accept the connection request")
                                .setCancelable(false)
                                .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                    @Override
                                    public void onClick(DialogInterface dialog, int arg1) {
                                        dialog.cancel();

                                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                            ((HomeActivity) getActivity()).showProgressDialog();
                                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.DISCONNECT_USER_TAG, Constants.DISCONNECT_USER_URL+"?user_id="+ ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+"&connection_id="+ connectionID, Constants.HTTP_GET, "Home Activity");
                                            a.execute();
                                        } else {
                                            //((HomeActivity) getActivity()).dismissProgressDialog();
                                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                        }
                                    }
                                })
                                .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                    @Override
                                    public void onClick(DialogInterface dialog, int arg1) {
                                        dialog.cancel();
                                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                            ((HomeActivity) getActivity()).showProgressDialog();
                                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ACCEPT_CONNECTION_USER_TAG, Constants.ACCEPT_CONNECTION_USER_URL+"?user_id="+ ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+"&connection_id="+ connectionID+ "&status=1", Constants.HTTP_GET, "Home Activity");
                                            a.execute();
                                        } else {
                                            //((HomeActivity) getActivity()).dismissProgressDialog();
                                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                        }

                                    }
                                });

                        AlertDialog alertDialog = alertDialogBuilder.create();

                        alertDialog.show();




                    }

                }
            });




            ViewOtherContractorPublicProfileFragment.cbx_Follow.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (ViewOtherContractorPublicProfileFragment.cbx_Follow.getText().toString().trim().equalsIgnoreCase("Follow")) {
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();

                            JSONObject jsonObject = new JSONObject();
                            try {

                                jsonObject.put("user_id", ViewOtherContractorPublicProfileFragment.userId);
                                jsonObject.put("followed_by", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) );
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
                                jsonObject.put("followed_by", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) );
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


        return rootView;
    }

    public ViewOtherBasicPublicProfileFragment() {
        super();
    }


    private String connectionSent;
    private String connectionStatus;
    private String connectionID;
    private String connectionRecieved;
    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            if (tag.equalsIgnoreCase(Constants.CONTRACTOR_BASIC_PROFILE_TAG)) {
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);
                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                        //ViewContractorPublicProfileFragment.tv_rate.setText(jsonObject.optString("perhour_rate").trim()+"/HR");

                        ViewOtherContractorPublicProfileFragment.quickBloxId= jsonObject.getString("quickbloxid");
                        if (jsonObject.optString("perhour_rate").trim().length() == 0) {
                            ViewOtherContractorPublicProfileFragment.tv_rate.setText("$0.00/HR");
                        } else {
                            ViewOtherContractorPublicProfileFragment.tv_rate.setText(((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat(jsonObject.optString("perhour_rate")) + "/HR");
                        }

                        int followed = Integer.parseInt(jsonObject.getString("isFollowing"));
                        if (followed==0){
                            ViewOtherContractorPublicProfileFragment.cbx_Follow.setText("Follow");
                            ViewOtherContractorPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                        }else{
                            ViewOtherContractorPublicProfileFragment.cbx_Follow.setText("UnFollow");
                            ViewOtherContractorPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                        }
                        JSONObject basic_information = jsonObject.optJSONObject("basic_information");

                        tv_bio.setText("Bio: " + basic_information.optString("biodata").trim());
                        tv_city.setText("City: " + basic_information.optString("city").trim());
                        tv_country.setText("Country: " + basic_information.optString("country").trim());
                        tv_dob.setText("D.O.B: " + basic_information.optString("dob").trim());
                        tv_email.setText("Email: " + basic_information.optString("email").trim());
                        tv_phone.setText("Phone: " + basic_information.optString("phone").trim());
                        tv_name.setText("Name: " + basic_information.optString("name").trim());

                        connectionSent = jsonObject.optString("connection_sent").trim();
                        connectionStatus = jsonObject.optString("connection_status").trim();
                        connectionID = jsonObject.optString("connection_id").trim();
                        connectionRecieved = jsonObject.optString("connection_received").trim();




                        if ((connectionRecieved.compareTo("1") == 0) && (connectionSent.compareTo("0") == 0) && (connectionStatus.compareTo("0") == 0)) {
                            ViewOtherContractorPublicProfileFragment.connectionOption.setText("Respond");
                        }
                        else if((connectionRecieved.compareTo("1") == 0) && (connectionSent.compareTo("0") == 0) && (connectionStatus.compareTo("1") == 0)){
                            ViewOtherContractorPublicProfileFragment.connectionOption.setText("Disconnect");
                        }
                        else if((connectionRecieved.compareTo("0") == 0) && (connectionSent.compareTo("1") == 0) && (connectionStatus.compareTo("0") == 0)){
                            ViewOtherContractorPublicProfileFragment.connectionOption.setText("Request Sent");
                        }
                        else if((connectionRecieved.compareTo("0") == 0) && (connectionSent.compareTo("1") == 0) && (connectionStatus.compareTo("1") == 0)){
                            ViewOtherContractorPublicProfileFragment.connectionOption.setText("Disconnect");
                        }
                        else if((connectionRecieved.compareTo("0") == 0) && (connectionSent.compareTo("0") == 0) && (connectionStatus.compareTo("0") == 0)){
                            ViewOtherContractorPublicProfileFragment.connectionOption.setText("Connect");
                        }

                        ViewOtherContractorPublicProfileFragment.tv_username.setText(basic_information.optString("name").trim());
                        if (jsonObject.getString("rating").trim().length() == 0) {
                            ViewOtherContractorPublicProfileFragment.profileRating.setRating(Float.parseFloat("0"));
                        } else {
                            ViewOtherContractorPublicProfileFragment.profileRating.setRating(Float.parseFloat(jsonObject.getString("rating")));
                        }

                        String[] s = basic_information.optString("name").trim().trim().split(" ");
                        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), ViewOtherContractorPublicProfileFragment.circularImageView, ((HomeActivity) getActivity()).options);
                        if (ViewOtherContractorPublicProfileFragment.userId.equalsIgnoreCase(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID))) {

                            ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_FIRST_NAME, s[0].trim());
                            ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_LAST_NAME, s[s.length - 1].trim());

                            HomeActivity.userName.setText(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_FIRST_NAME) + " " + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_LAST_NAME));

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

                        ViewOtherEntrepreneurPublicProfileFragment.tv_rate.setText(jsonObject.optString("perhour_rate").trim() + "/HR");
                        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), ViewOtherEntrepreneurPublicProfileFragment.circularImageView, ((HomeActivity) getActivity()).options);

                        ViewOtherEntrepreneurPublicProfileFragment.quickBloxId= jsonObject.getString("quickbloxid");
                        if (jsonObject.getString("rating").trim().length() == 0) {
                            ViewOtherEntrepreneurPublicProfileFragment.profileRating.setRating(Float.parseFloat("0"));
                        } else {
                            ViewOtherEntrepreneurPublicProfileFragment.profileRating.setRating(Float.parseFloat(jsonObject.getString("rating")));
                        }
                        int followed = Integer.parseInt(jsonObject.getString("isFollowing"));
                        if (followed==0){
                            ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.setText("Follow");
                            ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                        }else{
                            ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.setText("UnFollow");
                            ViewOtherEntrepreneurPublicProfileFragment.cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                        }

                        JSONObject basic_information = jsonObject.optJSONObject("basic_information");

                        tv_bio.setText("Bio: " + basic_information.optString("biodata").trim());
                        tv_city.setText("City: " + basic_information.optString("city").trim());
                        tv_country.setText("Country: " + basic_information.optString("country").trim());
                        tv_dob.setText("D.O.B: " + basic_information.optString("dob").trim());
                        tv_email.setText("Email: " + basic_information.optString("email").trim());
                        tv_phone.setText("Phone: " + basic_information.optString("phone").trim());
                        tv_name.setText("Name: " + basic_information.optString("name").trim());
                        tv_myInterests.setText("My Interests: " + basic_information.optString("interest").trim());
                        ViewOtherEntrepreneurPublicProfileFragment.tv_username.setText(basic_information.optString("name").trim());

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
            }

            else if (tag.equalsIgnoreCase(Constants.CONNECT_USER_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "Connection request sent successfully", Toast.LENGTH_SHORT).show();
                        ViewOtherContractorPublicProfileFragment.connectionOption.setText("Request Sent");

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "Could not send request. Please Try after some time.", Toast.LENGTH_SHORT).show();
                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.DISCONNECT_USER_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "User disconnected successfully.", Toast.LENGTH_SHORT).show();
                        ViewOtherContractorPublicProfileFragment.connectionOption.setText("Connect");

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "Could not send request. Please Try after some time.", Toast.LENGTH_SHORT).show();
                    }


                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            else if (tag.equalsIgnoreCase(Constants.ACCEPT_CONNECTION_USER_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "User connected successfully.", Toast.LENGTH_SHORT).show();
                        ViewOtherContractorPublicProfileFragment.connectionOption.setText("Disconnect");

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "Could not send request. Please Try after some time.", Toast.LENGTH_SHORT).show();
                    }


                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }


            else {
                ((HomeActivity) getActivity()).dismissProgressDialog();
            }
        }
    }
}
