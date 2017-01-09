package com.crowdbootstrapapp.activities;

import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.app.AppCompatActivity;
import android.text.Html;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.application.CrowdBootstrapApplicationClass;
import com.crowdbootstrapapp.fragments.LoginFragment;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.utilities.Constants;
import com.crowdbootstrapapp.utilities.NetworkConnectivity;
import com.crowdbootstrapapp.utilities.PrefManager;
import com.crowdbootstrapapp.utilities.UtilitiesClass;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;


public class LoginActivity extends AppCompatActivity implements AsyncTaskCompleteListener<String> {
    ProgressDialog pd;
    public AsyncTaskCompleteListener<String> mListener;
    private BroadcastReceiver mRegistrationBroadcastReceiver;

    public NetworkConnectivity networkConnectivity;
    public UtilitiesClass utilitiesClass;
    public PrefManager prefManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        networkConnectivity = CrowdBootstrapApplicationClass.getNetork();
        utilitiesClass = CrowdBootstrapApplicationClass.getUtilities();
        prefManager = CrowdBootstrapApplicationClass.getPref();

        mRegistrationBroadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                boolean sentToken = prefManager.getBoolean(Constants.SENT_TOKEN_TO_SERVER);
            }
        };


        //getSupportActionBar().setDisplayShowTitleEnabled(false);
        if (savedInstanceState == null) {
            getSupportFragmentManager().beginTransaction().add(R.id.container, new LoginFragment()).commit();
        }
    }

    /*@Override
    public void setActionBarTitle(String title) {
    }*/
    public void showProgressDialog(){
        pd = new ProgressDialog(LoginActivity.this);
        pd.setMessage(Html.fromHtml("<b>" + getString(R.string.please_wait) + "</b>"));
        pd.setIndeterminate(true);
        pd.setCancelable(false);

        pd.show();
    }

    public boolean isShowingProgressDialog(){
        return pd.isShowing();
    }
    public void dismissProgressDialog(){
        pd.dismiss();
    }

    @Override
    protected void onPause() {
        super.onPause();
        LocalBroadcastManager.getInstance(this).unregisterReceiver(mRegistrationBroadcastReceiver);
    }

    @Override
    protected void onResume() {
        super.onResume();
        LocalBroadcastManager.getInstance(this).registerReceiver(mRegistrationBroadcastReceiver, new IntentFilter(Constants.REGISTRATION_COMPLETE));
    }

    /*
     * Check device has google play service enabled or not
     * @param context
     * @return boolean
    */
   /* public boolean checkPlayServices() {
        int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(LoginActivity.this);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (GooglePlayServicesUtil.isUserRecoverableError(resultCode)) {
                GooglePlayServicesUtil.getErrorDialog(resultCode, LoginActivity.this, Constants.PLAY_SERVICES_RESOLUTION_REQUEST).show();
            } else {
                // Log.i(TAG, "This device is not supported.");
                //((Activity) context).finish();
            }
            return false;
        }
        return true;
    }*/

    /**
     * Check the device to make sure it has the Google Play Services APK. If
     * it doesn't, display a dialog that allows users to download the APK from
     * the Google Play Store or enable it in the device's system settings.
     */
    public boolean checkPlayServices() {
        GoogleApiAvailability apiAvailability = GoogleApiAvailability.getInstance();
        int resultCode = apiAvailability.isGooglePlayServicesAvailable(this);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (apiAvailability.isUserResolvableError(resultCode)) {
                apiAvailability.getErrorDialog(this, resultCode, Constants.PLAY_SERVICES_RESOLUTION_REQUEST).show();
            } else {
                //Log.i(TAG, "This device is not supported.");
                //finish();
            }
            return false;
        }
        return true;
    }
	

    @Override
    public void onTaskComplete(String result, String tag) {
        mListener.onTaskComplete(result, tag);
    }

    public void setOnBackPressedListener(AsyncTaskCompleteListener<String> listner) {
        this.mListener = listner;
    }


    /*@Override
    public void onSessionCreated(boolean success) {

    }*/
}