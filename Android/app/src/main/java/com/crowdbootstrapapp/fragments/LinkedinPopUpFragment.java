package com.crowdbootstrapapp.fragments;

import android.app.DialogFragment;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.linkedin.platform.APIHelper;
import com.linkedin.platform.errors.LIApiError;
import com.linkedin.platform.listeners.ApiListener;
import com.linkedin.platform.listeners.ApiResponse;
import com.crowdbootstrapapp.R;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Sunakshi.Gautam on 11/17/2016.
 */
public class LinkedinPopUpFragment extends DialogFragment {

    public LinkedinPopUpFragment() {
        super();
    }

    /**
     * creates a new instance of PropDialogFragment
     */
    public static android.support.v4.app.DialogFragment newInstance() {
        return new android.support.v4.app.DialogFragment();
    }

    private EditText messageBox;
    private TextView sendingTo;
    private Button sendButton;
    private Spinner subjectBox;
    private Button cancelButton;

    private static final String host = "api.linkedin.com";
//    private static final String topCardUrl = "https://" + host + "/v1/people/~:(first-name,last-name,public-profile-url)";
    private static final String shareUrl = "https://" + host + "/v1/people/~/shares";

    private String visibilityChoosen;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.popup_linkedindialog, container, false);
        messageBox = (EditText) rootView.findViewById(R.id.et_message);
        sendButton = (Button) rootView.findViewById(R.id.buttonSend);
        cancelButton = (Button) rootView.findViewById(R.id.buttonCancel);
        subjectBox = (Spinner) rootView.findViewById(R.id.et_subject);
        sendingTo = (TextView) rootView.findViewById(R.id.tv_name);

        sendingTo.setVisibility(View.GONE);


        // Spinner click listener
        subjectBox.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                visibilityChoosen = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        // Spinner Drop down elements
        List<String> categories = new ArrayList<String>();
        categories.add("anyone");
        categories.add("connections-only");


        // Creating adapter for spinner
        ArrayAdapter<String> dataAdapter = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_spinner_item, categories);

        // Drop down layout style - list view with radio button
        dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        // attaching data adapter to spinner
        subjectBox.setAdapter(dataAdapter);





        getDialog().setTitle("LinkedIn");
        messageBox.setText("\n" +
                "[Name]:\n" +
                "\n" +
                "Crowd Bootstrap helps entrepreneurs accelerate their journey from a startup idea to initial revenues. It is a free App that enables you to benefit as an entrepreneur or help as an expert.\n" +
                "\n" +
                "Please click the following link to sign-up and help an entrepreneur realize their dream.\n" +
                "\n" +
                "link: http://crowdbootstrap.com/ \n" +
                "\n" +
                "Regards,\n" +
                "\n" +
                "The Crowd Bootstrap Team");

//        sendingTo.setText(MyConnectionsAdapter.recievingContractorName);

        sendButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String shareJsonText = "{ \n" +
                        "   \"comment\":\"" + messageBox.getText() + "\"," +
                        "   \"visibility\":{ " +
                        "      \"code\":\""+visibilityChoosen +"\""+
                        "   }," +
                        "   \"content\":{ " +
                        "      \"title\":\"Crowd Bootstrap Invitation\"," +
                        "      \"description\":\"Crowd Bootstrap helps entrepreneurs accelerate their journey from a startup idea to initial revenues. It is a free App that enables you to benefit as an entrepreneur or help as an expert.Please click the following link to sign-up and help an entrepreneur realize their dream.\"," +
                        "      \"submitted-url\":\"http://crowdbootstrap.com/\"," +
                        "      \"submitted-image-url\":\"\"" +
                        "   }" +
                        "}";

                Log.e("XXX", "VALS+++" + shareJsonText);
                APIHelper apiHelper = APIHelper.getInstance(getActivity().getApplicationContext());
                apiHelper.postRequest(getActivity(), shareUrl, shareJsonText, new ApiListener() {

                    @Override
                    public void onApiSuccess(ApiResponse s) {
                        Toast.makeText(getActivity(), "Post shared successfully.", Toast.LENGTH_LONG).show();
                        dismiss();
                    }

                    @Override
                    public void onApiError(LIApiError error) {
                        Toast.makeText(getActivity(), "Could not post due to internal error.", Toast.LENGTH_LONG).show();
                        dismiss();
                        ;
                    }
                });

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






}