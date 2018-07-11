package com.crowdbootstrap.fragments;

/**
 * @author neelmani.karn
 */

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.Settings;
import android.support.v4.app.Fragment;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.quickblox.auth.QBAuth;
import com.quickblox.auth.model.QBSession;
import com.quickblox.chat.QBChatService;
import com.quickblox.core.QBEntityCallback;
import com.quickblox.core.exception.QBResponseException;
import com.quickblox.messages.QBPushNotifications;
import com.quickblox.messages.model.QBEnvironment;
import com.quickblox.messages.model.QBNotificationChannel;
import com.quickblox.messages.model.QBSubscription;
import com.quickblox.users.model.QBUser;
import com.crowdbootstrap.R;
import com.crowdbootstrap.RegistrationIntentService;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.activities.LoginActivity;
import com.crowdbootstrap.helper.CustomEditTextView;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.logger.CrowdBootstrapLogger;
import com.crowdbootstrap.utilities.AsyncNew;
import com.crowdbootstrap.utilities.Constants;
import com.crowdbootstrap.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.net.UnknownHostException;
import java.util.ArrayList;


public class LoginFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    String android_id;
    private Button btn_signup, btn_login;
    private TextView tv_forgotPassword, tv_aboutCrowdBootstrap, tv_resendConfirmationLink;
    private CustomEditTextView et_email, et_password;
    //private CustomEditTextView et_email;
    UtilitiesClass utils;


    public LoginFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_login, container, false);

        et_email = (CustomEditTextView) rootView.findViewById(R.id.et_email);
        et_password = (CustomEditTextView) rootView.findViewById(R.id.et_password);

        btn_signup = (Button) rootView.findViewById(R.id.btn_signup);
        tv_forgotPassword = (TextView) rootView.findViewById(R.id.tv_forgotPassword);
        tv_aboutCrowdBootstrap = (TextView) rootView.findViewById(R.id.tv_aboutCrowdBootstrap);
        btn_login = (Button) rootView.findViewById(R.id.btn_login);
        tv_resendConfirmationLink = (TextView) rootView.findViewById(R.id.tv_resendConfirmation);

        utils = UtilitiesClass.getInstance((LoginActivity) getActivity());
        if (((LoginActivity) getActivity()).checkPlayServices()) {
            // Start IntentService to register this application with GCM.
            Intent intent = new Intent(getActivity(), RegistrationIntentService.class);
            getActivity().startService(intent);
        }
        return rootView;
    }


    @Override
    public void onResume() {
        super.onResume();

        btn_login.setOnClickListener(this);
        btn_signup.setOnClickListener(this);
        tv_forgotPassword.setOnClickListener(this);
        tv_aboutCrowdBootstrap.setOnClickListener(this);
        tv_resendConfirmationLink.setOnClickListener(this);

        et_password.setImeOptions(EditorInfo.IME_ACTION_DONE);
        et_password.setOnEditorActionListener(new EditText.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_DONE) {
                    submitLogin();
                    return true;
                }
                return false;
            }
        });

        ((LoginActivity) getActivity()).setOnBackPressedListener(this);
    }

    private void submitLogin() {
        if (!validateEmail()) {
            requestFocus(et_email);
        } else if (!validatePassword()) {
            requestFocus(et_password);
        } else {
            android_id = Settings.Secure.getString(getActivity().getContentResolver(), Settings.Secure.ANDROID_ID);

            JSONObject login = null;
            try {
                login = new JSONObject();
                login.put("email", et_email.getText().toString().trim());
                login.put("password", et_password.getText().toString().trim());
                login.put("access_token", ((LoginActivity) getActivity()).prefManager.getRegistrationId());
                login.put("device_token", android_id);
                login.put("device_type", "android");

            } catch (JSONException e) {
                e.printStackTrace();
            }

            CrowdBootstrapLogger.logInfo(login.toString());
            if (((LoginActivity) getActivity()).networkConnectivity.isOnline()) {
                ((LoginActivity) getActivity()).showProgressDialog();
                CrowdBootstrapLogger.logInfo("startTime" + String.valueOf(System.currentTimeMillis()));

                AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.LOGIN_TAG, Constants.LOGIN_URL, Constants.HTTP_POST_REQUEST, login);
                a.execute();
                /*Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.LOGIN_TAG, Constants.LOGIN_URL, Constants.HTTP_POST, login, "Login Activity");
                a.execute();*/
            } else {
                utils.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        }
    }

    private boolean validatePassword() {
        String password = et_password.getText().toString().trim();
        if (password.isEmpty()) {
            //((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.password_required));
            et_password.setError(getString(R.string.password_required), getResources().getDrawable(android.R.drawable.ic_dialog_alert));
            requestFocus(et_password);
            return false;
        } else {

        }
        return true;
    }


    private boolean validateEmail() {
        String email = et_email.getText().toString().trim();

        if (email.isEmpty()) {
            //((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.email_required));
            //et_email.setError(getString(R.string.email_required));
            et_email.setError(getString(R.string.email_required), getResources().getDrawable(android.R.drawable.ic_dialog_alert));
            //et_email.setError(Html.fromHtml("<font color='"+getResources().getColor(R.color.drawerListSelectorColor)+"'>hello</font>"));
            requestFocus(et_email);
            return false;
        } else if (!isValidEmail(email)) {
            //((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.invalidEmail));
            et_email.setError(getString(R.string.invalidEmail), getResources().getDrawable(android.R.drawable.ic_dialog_alert));
            //et_email.setError(getString(R.string.invalidEmail));
            requestFocus(et_email);
            return false;
        }
        return true;
    }

    private static boolean isValidEmail(String email) {
        return !TextUtils.isEmpty(email) && android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches();
    }

    private void requestFocus(View view) {
        if (view.requestFocus()) {
            getActivity().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_login:
                submitLogin();
                break;

            case R.id.tv_aboutCrowdBootstrap:
                LoginInfoFragment aboutCrowdFragment = new LoginInfoFragment();
                getFragmentManager().beginTransaction().replace(R.id.container, aboutCrowdFragment).addToBackStack(null).commit();
                break;
            case R.id.btn_signup:
                SignupFragment signupFragment = new SignupFragment();
                getFragmentManager().beginTransaction().replace(R.id.container, signupFragment).addToBackStack(null).commit();
                break;
            case R.id.tv_forgotPassword:
                ForgotPasswordFragment forgotPasswordFragment = new ForgotPasswordFragment();
                getFragmentManager().beginTransaction().replace(R.id.container, forgotPasswordFragment).addToBackStack(null).commit();
                break;

            case R.id.tv_resendConfirmation:
                ResendConfirmationFragment resendConfirmationFragment = new ResendConfirmationFragment();
                getFragmentManager().beginTransaction().replace(R.id.container, resendConfirmationFragment).addToBackStack(null).commit();

                break;
        }
    }

    @Override
    public void onTaskComplete(String result, String tag) {

        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((LoginActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.TIMEOUT_EXCEPTION)) {
            ((LoginActivity) getActivity()).dismissProgressDialog();
            UtilitiesClass.getInstance(getActivity()).alertDialogSingleButton(getString(R.string.time_out));
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((LoginActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        }
        /*if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((LoginActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((LoginActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        }*/
        else {
            if (tag.equalsIgnoreCase(Constants.LOGIN_TAG)) {
                try {
                    CrowdBootstrapLogger.logInfo(result);
                    final JSONObject jsonObject = new JSONObject(result);


                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        ((LoginActivity) getActivity()).prefManager.storeString(Constants.USER_EMAIL, jsonObject.optString("email"));
                        //((LoginActivity) getActivity()).prefManager.storeString(Constants.USER_PASSWORD, et_password.getText().toString().trim());
                        ((LoginActivity) getActivity()).prefManager.storeString(Constants.USER_FIRST_NAME, jsonObject.optString("first_name"));
                        ((LoginActivity) getActivity()).prefManager.storeString(Constants.USER_LAST_NAME, jsonObject.optString("last_name"));
                        ((LoginActivity) getActivity()).prefManager.storeString(Constants.USER_ID, jsonObject.optString("user_id"));
                        ((LoginActivity) getActivity()).prefManager.storeString(Constants.USER_PROFILE_IMAGE_URL, jsonObject.optString("user_image"));
                        ((LoginActivity) getActivity()).prefManager.storeString(Constants.USER_PHONE_NUMBER, jsonObject.optString("phoneno"));
                        ((LoginActivity) getActivity()).prefManager.storeString(Constants.USER_NAME, jsonObject.optString("username"));
                        ((LoginActivity) getActivity()).prefManager.storeString(Constants.DEVICE_TOKEN, android_id);
                        ((LoginActivity) getActivity()).prefManager.storeBoolean(Constants.ISLOGGEDIN, true);
                        ((LoginActivity) getActivity()).prefManager.storeBoolean(Constants.IS_NOTIFICATION_ON, true);


                        ((LoginActivity) getActivity()).prefManager.storeBoolean(Constants.IS_BETA_TESTER, jsonObject.optBoolean("isBetaTester"));
                        ((LoginActivity) getActivity()).prefManager.storeBoolean(Constants.IS_BOARD_MEMBER,jsonObject.optBoolean("isBoardMember"));
                        ((LoginActivity) getActivity()).prefManager.storeBoolean(Constants.IS_ENDORSER, jsonObject.optBoolean("isEndorsor"));
                        ((LoginActivity) getActivity()).prefManager.storeBoolean(Constants.IS_EARLY_ADOPTER, jsonObject.optBoolean("isEarlyAdopter"));
                        ((LoginActivity) getActivity()).prefManager.storeBoolean(Constants.IS_FOCUS_GROUP, jsonObject.optBoolean("isFocusGroup"));




                        ((LoginActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONTRACTOR_PUBLIC_PROFILE_ON, jsonObject.optBoolean("isPublicProfile"));
                        ((LoginActivity) getActivity()).prefManager.storeString(Constants.USER_TYPE, Constants.CONTRACTOR);

                        QBUser user = new QBUser();
                        user.setEmail(jsonObject.optString("email"));
                        user.setLogin(jsonObject.optString("username"));
                        user.setPassword(jsonObject.getString("quickblox_password"));
                        user.setFullName(jsonObject.optString("first_name") + " " + jsonObject.optString("last_name"));
                        user.setId(Integer.parseInt(jsonObject.optString("user_id")));


                        login(user);

                        /*if (((LoginActivity) getActivity()).isShowingProgressDialog()) {
                            ((LoginActivity) getActivity()).dismissProgressDialog();
                        }

                        Intent go = new Intent(getActivity(), HomeActivity.class);
                        startActivity(go);
                        getActivity().finish();*/

                    } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        ((LoginActivity) getActivity()).dismissProgressDialog();

                        ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(jsonObject.getString("message"));
                    }
                } catch (JSONException e) {
                    ((LoginActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else {
                ((LoginActivity) getActivity()).dismissProgressDialog();
            }
        }
    }


    private void login(final QBUser user) {

        final QBChatService chatService = QBChatService.getInstance();

        QBAuth.createSession(user, new QBEntityCallback<QBSession>() {
            @Override
            public void onSuccess(final QBSession session, Bundle params) {
                // success, login to chat

                user.setId(session.getUserId());
                CrowdBootstrapLogger.logInfo("session" + session.getToken());
                chatService.login(user, new QBEntityCallback() {

                    @Override
                    public void onSuccess(Object o, Bundle bundle) {
                        if (((LoginActivity) getActivity()).isShowingProgressDialog()) {
                            ((LoginActivity) getActivity()).dismissProgressDialog();

                        }
                        CrowdBootstrapLogger.logInfo("endTime" + String.valueOf(System.currentTimeMillis()));
                        /*((LoginActivity)getActivity()).runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                subscribeToPushNotifications(((LoginActivity) getActivity()).prefManager.getRegistrationId());
                            }
                        });*/

                        ((LoginActivity) getActivity()).prefManager.saveQbUser(user);
                        ((LoginActivity) getActivity()).prefManager.storeString(Constants.QUICKBLOX_SESSION_TOKEN, session.getToken());
                        Intent go = new Intent(getActivity(), HomeActivity.class);
                        startActivity(go);
                        getActivity().finish();
                    }

                    @Override
                    public void onError(QBResponseException e) {

                        if (e.getMessage().equalsIgnoreCase("You have already logged in chat")) {
                            if (((LoginActivity) getActivity()).isShowingProgressDialog()) {
                                ((LoginActivity) getActivity()).dismissProgressDialog();
                            }

                            /*((LoginActivity)getActivity()).runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    subscribeToPushNotifications(((LoginActivity) getActivity()).prefManager.getRegistrationId());
                                }
                            });*/
                            ((LoginActivity) getActivity()).prefManager.saveQbUser(user);
                            ((LoginActivity) getActivity()).prefManager.storeString(Constants.QUICKBLOX_SESSION_TOKEN, session.getToken());
                            Intent go = new Intent(getActivity(), HomeActivity.class);
                            startActivity(go);
                            getActivity().finish();
                        } else {
                            unRegisterInBackground();
                        }
                        CrowdBootstrapLogger.logInfo("signinerror" + e.toString());
                    }
                });
            }

            @Override
            public void onError(QBResponseException errors) {
                CrowdBootstrapLogger.logInfo("sessioninerror" + errors.toString());
                unRegisterInBackground();
            }




        });

    }

    private void unRegisterInBackground() {
        new AsyncTask<Void, Void, Void>() {
            String result = null;

            @Override
            protected void onPreExecute() {
                super.onPreExecute();

            }

            @Override
            protected void onPostExecute(Void aVoid) {
                super.onPostExecute(aVoid);

                try {
                    CrowdBootstrapLogger.logInfo(result);
                    JSONObject jsonObject = new JSONObject(result);

                    if (((LoginActivity) getActivity()).isShowingProgressDialog()) {
                        ((LoginActivity) getActivity()).dismissProgressDialog();
                    }
                    if (((LoginActivity) getActivity()).checkPlayServices()) {
                        // Start IntentService to register this application with GCM.
                        Intent intent = new Intent(getActivity(), RegistrationIntentService.class);
                        getActivity().startService(intent);
                    }

                    QBChatService.getInstance().logout(new QBEntityCallback<Void>() {
                        @Override
                        public void onSuccess(Void aVoid, Bundle bundle) {
                            QBChatService.getInstance().destroy();
                            CrowdBootstrapLogger.logInfo("logout");
                        }

                        @Override
                        public void onError(QBResponseException e) {
                            CrowdBootstrapLogger.logInfo("error" + e.toString());
                        }
                    });
                    /*QBUsers.signOut(new QBEntityCallback<Void>() {
                        @Override
                        public void onSuccess(Void aVoid, Bundle bundle) {
                            Log.d("logout", "logout");
                        }

                        @Override
                        public void onError(QBResponseException e) {
                            Log.d("error", e.toString());
                        }
                    });
*/
                    /*QBPushNotifications.getSubscriptions(new QBEntityCallback<ArrayList<QBSubscription>>() {
                        @Override
                        public void onSuccess(ArrayList<QBSubscription> subscriptions, Bundle args) {

                            String deviceId = Settings.Secure.getString(getActivity().getContentResolver(), Settings.Secure.ANDROID_ID);/*//*** use for tablets

                     for (QBSubscription subscription : subscriptions) {
                     if (subscription.getDevice().getId().equals(deviceId)) {
                     QBPushNotifications.deleteSubscription(subscription.getId(), new QBEntityCallback<Void>() {

                    @Override public void onSuccess(Void aVoid, Bundle bundle) {

                    }

                    @Override public void onError(QBResponseException e) {

                    }
                    });
                     break;
                     }
                     }
                     }

                     @Override public void onError(QBResponseException errors) {

                     }
                     });*/


                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase("200")) {
                        ((LoginActivity) getActivity()).prefManager.clearAllPreferences();

                    } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase("404")) {
                        ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(jsonObject.getString("message"));
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }


            @Override
            protected Void doInBackground(Void... params) {

                try {
                    JSONObject logout = new JSONObject();
                    logout.put("user_id", ((LoginActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    logout.put("access_token", ((LoginActivity) getActivity()).prefManager.getString(Constants.GCM_REGISTRATION_ID));
                    logout.put("device_token", ((LoginActivity) getActivity()).prefManager.getString(Constants.DEVICE_TOKEN));
                    logout.put("device_type", "android");
                    CrowdBootstrapLogger.logInfo(logout.toString());

                    result = ((LoginActivity) getActivity()).utilitiesClass.postJsonObject(Constants.LOGOUT_URL, logout);
                    if (result.contains("200")) {
                        GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(getActivity());
                        try {
                            gcm.unregister();
                            CrowdBootstrapLogger.logInfo("unregister");
                        } catch (IOException e) {
                            CrowdBootstrapLogger.logInfo("Error Message: " + e.getMessage());
                        }
                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                } catch (UnknownHostException e) {
                    e.printStackTrace();
                }

                return null;
            }
        }.execute(null, null, null);
    }


    public void subscribeToPushNotifications(String registrationID) {

        QBSubscription subscription = new QBSubscription(QBNotificationChannel.GCM);
        subscription.setEnvironment(QBEnvironment.PRODUCTION);
        //
        String deviceId;

        deviceId = Settings.Secure.getString(getActivity().getContentResolver(), Settings.Secure.ANDROID_ID);//*** use for tablets


        subscription.setDeviceUdid(deviceId);
        //
        subscription.setRegistrationID(registrationID);
        //
        QBPushNotifications.createSubscription(subscription, new QBEntityCallback<ArrayList<QBSubscription>>() {

            @Override
            public void onSuccess(ArrayList<QBSubscription> subscriptions, Bundle args) {
                Log.e("subs", subscriptions.toString());
            }

            @Override
            public void onError(QBResponseException error) {

            }
        });
    }
}