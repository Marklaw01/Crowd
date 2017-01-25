package com.staging.fragments;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by neelmani.karn on 1/19/2016.
 */
public class SettingsFragment extends Fragment implements CompoundButton.OnCheckedChangeListener, AsyncTaskCompleteListener<String> {

    private TextView txtVersion;
    boolean isCheckedSwitch = false;
    private boolean profileChecked = false;
    private Switch switchNotification, switchPublicProfile;

    public SettingsFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        ((HomeActivity) getActivity()).setActionBarTitle("Settings");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_setting, container, false);
        switchNotification = (Switch) rootView.findViewById(R.id.switchNotification);
        switchPublicProfile = (Switch) rootView.findViewById(R.id.switchPublicProfile);

        txtVersion = (TextView) rootView.findViewById(R.id.txtVersion);
        txtVersion.setText(getString(R.string.version) + ((HomeActivity) getActivity()).prefManager.getAppVersion(getActivity()));
        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_NOTIFICATION_ON)) {
            switchNotification.setChecked(true);
        } else {
            switchNotification.setChecked(false);
        }

        profileChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONTRACTOR_PUBLIC_PROFILE_ON);

        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONTRACTOR_PUBLIC_PROFILE_ON)) {
            switchPublicProfile.setChecked(true);
        } else {
            switchPublicProfile.setChecked(false);
        }


        switchPublicProfile.setOnCheckedChangeListener(this);
        switchNotification.setOnCheckedChangeListener(this);
        return rootView;
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        switch (buttonView.getId()) {
            case R.id.switchNotification:
                if (isChecked) {
                    ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_NOTIFICATION_ON, true);
                } else {
                    ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_NOTIFICATION_ON, false);
                }
                break;
            case R.id.switchPublicProfile:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingAlert("Are you sure you want to make your Profile Public?", isChecked);
                    } else {
                        showSettingAlert("Are you sure you want to make your Profile Private?", isChecked);
                    }
                }
                break;
        }
    }

    public void showSettingAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();

                    profileChecked = isChecked;
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.PROFILE_SETTING_TAG, Constants.PROFILE_SETTING_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&public_profile=" + isChecked, Constants.HTTP_GET, "Home Activity");
                    a.execute();
                } else {

                    profileChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONTRACTOR_PUBLIC_PROFILE_ON);
                    isCheckedSwitch = true;
                    switchPublicProfile.setChecked(profileChecked);
                    isCheckedSwitch = false;

                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }

            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                profileChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONTRACTOR_PUBLIC_PROFILE_ON);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchPublicProfile.setChecked(profileChecked);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
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
            if (tag.equalsIgnoreCase(Constants.PROFILE_SETTING_TAG)) {

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONTRACTOR_PUBLIC_PROFILE_ON, profileChecked);

                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            }
        }
    }
}