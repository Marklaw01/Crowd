package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.LoginActivity;
import com.staging.dropdownadapter.SpinnerAdapter;
import com.staging.helper.CustomEditTextView;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.models.GenericObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 12/29/2017.
 */

public class ResendConfirmationFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    int COUNTER = 1;
    //private TextInputLayout input_layout_email, input_layout_answer;
    private CustomEditTextView et_email, et_answer;
    private CustomEditTextView securityQuestion;
    private Button btn_resetPassword;
    private static String SECURITY_QUESTION = "";
    private static String SECURITY_ANSWER = "";
    private SpinnerAdapter spinnerAdapter;
    private ArrayList<GenericObject> securityQuestionsList;
    GenericObject obj;

    public ResendConfirmationFragment() {

    }

    @Override
    public void onResume() {
        super.onResume();
        ((LoginActivity) getActivity()).setOnBackPressedListener(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_forgotpassword, container, false);
        securityQuestion = (CustomEditTextView) rootView.findViewById(R.id.et_question);

        et_answer = (CustomEditTextView) rootView.findViewById(R.id.et_answer);
        et_email = (CustomEditTextView) rootView.findViewById(R.id.et_email);

        btn_resetPassword = (Button) rootView.findViewById(R.id.btn_resetPassword);
        btn_resetPassword.setText("Resend Link");
        securityQuestionsList = new ArrayList<GenericObject>();
        securityQuestion.setVisibility(View.GONE);

        //et_email.addTextChangedListener(new MyTextWatcher(et_email));
        btn_resetPassword.setOnClickListener(this);
        return rootView;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_resetPassword:
                if (validateEmail() == true) {
                    submitForm();
                }
                break;
        }
    }


    private void submitForm() {


        if (((LoginActivity) getActivity()).networkConnectivity.isOnline()) {
            ((LoginActivity) getActivity()).showProgressDialog();
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.RESEND_CONFIRMATION_USER_MAIL_TAG, Constants.RESEND_CONFIRMATION_USER_MAIL_URL + "?user_email=" + et_email.getText().toString().trim(), Constants.HTTP_GET, "Home Activity");
            a.execute();
        } else {
            ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }


    }


    private boolean validateEmail() {
        String email = et_email.getText().toString().trim();

        if (email.isEmpty()) {
            et_email.setError("Enter your registered email!", getResources().getDrawable(android.R.drawable.ic_dialog_alert));
            requestFocus(et_email);
            return false;
        } else if (!isValidEmail(email)) {
            et_email.setError("Enter your registered email!", getResources().getDrawable(android.R.drawable.ic_dialog_alert));
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
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((LoginActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((LoginActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            if (tag.equalsIgnoreCase(Constants.RESEND_CONFIRMATION_USER_MAIL_TAG)) {
                ((LoginActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);
                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "We have sent an email that contains the confirmation link to your email address.", Toast.LENGTH_LONG).show();
                        LoginFragment loginFragment = new LoginFragment();//
                        FragmentManager fragmentManager = getFragmentManager();
                        FragmentTransaction transaction = fragmentManager.beginTransaction();
                        transaction.replace(R.id.container, loginFragment);
                        fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                        transaction.commit();
                    } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "This email is not registered.", Toast.LENGTH_LONG).show();
                        LoginFragment loginFragment = new LoginFragment();
                        FragmentManager fragmentManager = getFragmentManager();
                        FragmentTransaction transaction = fragmentManager.beginTransaction();
                        transaction.replace(R.id.container, loginFragment);
                        fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                        transaction.commit();
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }






            } else {
                ((LoginActivity) getActivity()).dismissProgressDialog();
            }
        }
    }

    /*private class MyTextWatcher implements TextWatcher {

        private View view;

        private MyTextWatcher(View view) {
            this.view = view;
        }


        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {

        }


        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {

        }


        @Override
        public void afterTextChanged(Editable s) {
            switch (view.getId()){
                case R.id.et_email:
                    validateEmail();
                    break;

            }
        }
    }*/
}