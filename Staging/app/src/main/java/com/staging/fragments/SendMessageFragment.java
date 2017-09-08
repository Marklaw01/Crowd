package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by neelmani.karn on 2/9/2016.
 */
public class SendMessageFragment extends Fragment implements AsyncTaskCompleteListener<String> {

    private EditText et_recipient, et_subject, et_message;
    String to_team_memberid, to_team_memberName;
    private Button btn_send;

    public SendMessageFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_send_message, container, false);

        try {
            to_team_memberid = getArguments().getString("to_team_memberid");
            to_team_memberName = getArguments().getString("to_team_memberName");

            btn_send = (Button) rootView.findViewById(R.id.btn_send);
            et_recipient = (EditText) rootView.findViewById(R.id.et_recipient);
            et_subject = (EditText) rootView.findViewById(R.id.et_subject);
            et_message = (EditText) rootView.findViewById(R.id.et_message);
            et_recipient.setText(to_team_memberName);

            et_message.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View v, MotionEvent event) {
                    if (v.getId() == R.id.et_message) {
                        v.getParent().requestDisallowInterceptTouchEvent(true);
                        switch (event.getAction() & MotionEvent.ACTION_MASK) {
                            case MotionEvent.ACTION_UP:
                                v.getParent().requestDisallowInterceptTouchEvent(false);
                                break;
                        }
                    }
                    return false;
                }
            });
            btn_send.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    if (et_subject.getText().toString().trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Subject cannot be left blank", Toast.LENGTH_LONG).show();
                    } else if (et_message.getText().toString().trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Message cannot be left blank", Toast.LENGTH_LONG).show();
                    } else {
                        JSONObject obj = new JSONObject();
                        try {
                            obj.put("from_team_memberid", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            obj.put("sender_role_id", TeamStartUpFragment.LOGGEDIN_USER_ROLE);
                            obj.put("to_team_memberid", to_team_memberid);
                            obj.put("msg_type", "team");
                            obj.put("subject", et_subject.getText().toString().trim());
                            obj.put("message_text", et_message.getText().toString().trim());
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_SEND_MESSAGE_TAG, Constants.STARTUP_SEND_MESSAGE_URL, Constants.HTTP_POST, obj,"Home Activity");
                            a.execute();

                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    }


                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootView;
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
                if (tag.equalsIgnoreCase(Constants.STARTUP_SEND_MESSAGE_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                        }


                        getActivity().onBackPressed();
                    } catch (JSONException e) {

                        e.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }


    }
}
