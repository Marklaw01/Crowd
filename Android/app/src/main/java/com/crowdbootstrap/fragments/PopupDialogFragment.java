package com.crowdbootstrap.fragments;

import android.app.DialogFragment;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.adapter.MyConnectionsAdapter;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.listeners.onActivityResultListener;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by Sunakshi.Gautam on 11/10/2016.
 */
public class PopupDialogFragment extends DialogFragment implements onActivityResultListener, AsyncTaskCompleteListener<String> {

    public PopupDialogFragment() {
        super();
    }

    /**
     * creates a new instance of PropDialogFragment
     */
    public static android.support.v4.app.DialogFragment newInstance() {
        return new android.support.v4.app.DialogFragment();
    }

    private EditText messageBox, subjectBox;
    private TextView sendingTo;
    private Button sendButton;
    private Button cancelButton;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.popup_dialog_layout, container, false);
        messageBox = (EditText) rootView.findViewById(R.id.et_message);
        sendButton = (Button) rootView.findViewById(R.id.buttonSend);
        cancelButton = (Button) rootView.findViewById(R.id.buttonCancel);
        subjectBox = (EditText) rootView.findViewById(R.id.et_subject);
        sendingTo = (TextView) rootView.findViewById(R.id.tv_name);
        getDialog().setTitle("Send Message");

        sendingTo.setText(MyConnectionsAdapter.recievingContractorName);

        sendButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                JSONObject message = new JSONObject();

                try {
                    message.put("from_team_memberid", MyConnectionsFragment.sendingContractorId);
                    message.put("message_text", messageBox.getText().toString().trim());
                    message.put("msg_type", "connection");
                    message.put("sender_role_id", "0");
                    message.put("subject", subjectBox.getText().toString().trim());
                    message.put("to_team_memberid", MyConnectionsAdapter.recievingContractorID);
                } catch (Exception e) {

                }
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONNECTIONS_SENDMESSAGE_TAG, Constants.CONNECTIONS_SENDMESSAGE_URL, Constants.HTTP_POST, message, "Home Activity");
                    a.execute();
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }

            }
        });

        cancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });


        return rootView;
    }


    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
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
            } else if (result.contains("<pre")) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
            } else {
                if (tag.equalsIgnoreCase(Constants.CONNECTIONS_SENDMESSAGE_TAG)) {
                    Log.e("XXX", "INTO RESULT");
                    ((HomeActivity) getActivity()).dismissProgressDialog();

                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.optString("message").toString().trim(), Toast.LENGTH_LONG).show();


                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No Contractors found", Toast.LENGTH_LONG).show();

                        }

                        dismiss();
                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }


                } else {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                }

            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }


    }


}