package com.crowdbootstrap.fragments;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.logger.CrowdBootstrapLogger;
import com.crowdbootstrap.models.GenericObject;
import com.crowdbootstrap.utilities.AsyncNew;
import com.crowdbootstrap.utilities.Constants;
import com.crowdbootstrap.utilities.NetworkConnectivity;
import com.crowdbootstrap.utilities.UtilitiesClass;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 11/9/2017.
 */

public class NetworkingGroupsFragment extends Fragment implements AsyncTaskCompleteListener<String> {


    private LinearLayout layout_more;
    private ImageView btn_plus;
    private Button btn_submit;

    public NetworkConnectivity networkConnectivity;
    public UtilitiesClass utilitiesClass;

    public NetworkingGroupsFragment() {

    }


    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle("Manage Groups");
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);


    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_networkinggroups, container, false);
        layout_more = (LinearLayout) rootView.findViewById(R.id.layout_more);
        btn_plus = (ImageView) rootView.findViewById(R.id.btn_plus);
        btn_submit = (Button) rootView.findViewById(R.id.btn_submit);


        btn_plus.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {

                    addLayout("", "");

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });

        btn_submit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                    listAllAddView();
                    updateGroupSettings();
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            }
        });


        try {
            if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                JSONObject object = new JSONObject();
                object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BUSINESS_CONNECTION_TYPE_TAG, Constants.BUSINESS_CONNECTION_TYPE_URL, Constants.HTTP_POST_REQUEST, object);
                a.execute();
            } else {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }


        return rootView;
    }

    private void updateGroupSettings() {
        JSONArray jsonArray = new JSONArray();
        for (int i = 0; i < GroupTypesList.size(); i++) {
            JSONObject groupItem = new JSONObject();
            try {
                groupItem.put("id", i + 1);
                groupItem.put("name", GroupTypesList.get(i).getTitle().toString().trim());
                groupItem.put("description", GroupTypesList.get(i).getAnswer().toString().trim());

            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            jsonArray.put(groupItem);
        }


        try {
            if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                JSONObject object = new JSONObject();
                object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                object.put("data", jsonArray);
                AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ADD_BUSINESS_CONNECTION_TYPE_TAG, Constants.ADD_BUSINESS_CONNECTION_TYPE_URL, Constants.HTTP_POST_REQUEST, object);
                a.execute();
            } else {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

    }


    private void addLayout(String cbRowVal, String groupDescription) {

        LayoutInflater layoutInflater =
                (LayoutInflater) getActivity().getBaseContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        final View addView = layoutInflater.inflate(R.layout.networking_groupitemlayout, null);
        ImageView buttonRemove = (ImageView) addView.findViewById(R.id.btn_delete);

        EditText limitValueEditText = (EditText) addView.findViewById(R.id.et_groupname);
        EditText limitDescriptionEditText = (EditText) addView.findViewById(R.id.et_groupDescription);


        limitValueEditText.setText(cbRowVal);
        limitDescriptionEditText.setText(groupDescription);


        final View.OnClickListener thisListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.e("XXX", "thisListener called:\t" + this + "\n");
                Log.e("XXX", "Remove addView: " + addView + "\n\n");
                ((LinearLayout) addView.getParent()).removeView(addView);

                listAllAddView();
            }
        };

        buttonRemove.setOnClickListener(thisListener);

        layout_more.addView(addView);

        Log.e("XXX",
                "thisListener:\t" + thisListener + "\n"
                        + "addView:\t" + addView + "\n\n"
        );


        listAllAddView();

    }


    private ArrayList<GenericObject> GroupTypesList;

    private void listAllAddView() {

        GroupTypesList = new ArrayList<>();
        GroupTypesList.clear();
        int childCount = layout_more.getChildCount();

        Log.e("XXX", "CHILDCOUNT++++++++" + String.valueOf(childCount));


        for (int i = 0; i < childCount; i++) {
            View thisChild = layout_more.getChildAt(i);

            EditText limitValueEditText = (EditText) thisChild.findViewById(R.id.et_groupname);
            EditText limitDescriptionEditText = (EditText) thisChild.findViewById(R.id.et_groupDescription);

            String groupName = limitValueEditText.getText().toString().trim();
            String groupDescription = limitDescriptionEditText.getText().toString().trim();


            GenericObject obj = new GenericObject();
            obj.setTitle(groupName);
            obj.setAnswer(groupDescription);
            GroupTypesList.add(obj);

        }

    }

    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.TIMEOUT_EXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            UtilitiesClass.getInstance(getActivity()).alertDialogSingleButton(getString(R.string.time_out));
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {

            if (tag.equals(Constants.BUSINESS_CONNECTION_TYPE_TAG)) {
                CrowdBootstrapLogger.logInfo(result);

                try {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    JSONObject jsonObject = new JSONObject(result);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        for (int i = 0; i < jsonObject.optJSONArray("businessConnectionTypes").length(); i++) {
                            GenericObject obj = new GenericObject();
//                            String connectionID = jsonObject.optJSONArray("businessConnectionTypes").getJSONObject(i).optString("id");
                            String connectionName = jsonObject.optJSONArray("businessConnectionTypes").getJSONObject(i).optString("name");
                            String connectionDescription = jsonObject.optJSONArray("businessConnectionTypes").getJSONObject(i).optString("description");

                            addLayout(connectionName, connectionDescription);
                        }


                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();

                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equals(Constants.ADD_BUSINESS_CONNECTION_TYPE_TAG)) {
                try {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    JSONObject jsonObject = new JSONObject(result);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                        Toast.makeText(getActivity(), "Groups updated successfully", Toast.LENGTH_LONG).show();
                        getActivity().onBackPressed();
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
