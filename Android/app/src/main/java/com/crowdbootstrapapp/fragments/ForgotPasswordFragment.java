package com.crowdbootstrapapp.fragments;

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

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.LoginActivity;
import com.crowdbootstrapapp.dropdownadapter.SpinnerAdapter;
import com.crowdbootstrapapp.helper.CustomEditTextView;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.models.GenericObject;
import com.crowdbootstrapapp.utilities.Async;
import com.crowdbootstrapapp.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/6/2016.
 */
public class ForgotPasswordFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

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

    public ForgotPasswordFragment() {

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
        securityQuestionsList = new ArrayList<GenericObject>();


        //et_email.addTextChangedListener(new MyTextWatcher(et_email));
        btn_resetPassword.setOnClickListener(this);
        return rootView;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_resetPassword:
                if (securityQuestion.getVisibility() == View.VISIBLE) {
                    submitForm();
                } else {
                    submitEmail();
                }
                break;
        }
    }

    private void submitEmail() {
        if (!validateEmail()) {
            requestFocus(et_email);
        } else {
            ((LoginActivity) getActivity()).showProgressDialog();
            if (((LoginActivity) getActivity()).networkConnectivity.isOnline()) {
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FORGOT_PASSWORD_USER_QUESTIONS_LIST_TAG, Constants.FORGOT_PASSWORD_USER_QUESTIONS_LIST_URL + et_email.getText().toString().trim(), Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {
                ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        }
    }


    private void submitForm() {



        if (COUNTER >= 3) {
            if (((LoginActivity) getActivity()).networkConnectivity.isOnline()) {
                ((LoginActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FORGOT_PASSWORD_MAX_NUMBER_OF_LIMIT_TAG, Constants.FORGOT_PASSWORD_MAX_NUMBER_OF_LIMIT_URL + "?email_id=" + et_email.getText().toString().trim(), Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {
                ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }

        } else {
            if (COUNTER >= securityQuestionsList.size()) {
                if (((LoginActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((LoginActivity) getActivity()).showProgressDialog();
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FORGOT_PASSWORD_MAX_NUMBER_OF_LIMIT_TAG, Constants.FORGOT_PASSWORD_MAX_NUMBER_OF_LIMIT_URL + "?email_id=" + et_email.getText().toString().trim(), Constants.HTTP_GET,"Home Activity");
                    a.execute();
                } else {
                    ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }

            } else {

                if (et_answer.getText().toString().trim().equalsIgnoreCase(obj.getAnswer())) {
                    if (((LoginActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((LoginActivity) getActivity()).showProgressDialog();
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FORGOT_PASSWORD_USER_MAIL_TAG, Constants.FORGOT_PASSWORD_USER_MAIL_URL + "?user_email=" + et_email.getText().toString().trim(), Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    } else {
                        ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                } else {
                    Toast.makeText(getActivity(), "InCorrect Answer!", Toast.LENGTH_LONG).show();
                    et_answer.setText("");

                    obj = securityQuestionsList.get(COUNTER);
                    securityQuestion.setText(obj.getTitle());
                    COUNTER++;
                    System.out.println(COUNTER);

                }
            }
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
        } else {

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
            if (tag.equalsIgnoreCase(Constants.FORGOT_PASSWORD_USER_QUESTIONS_LIST_TAG)) {
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);
                    securityQuestionsList.clear();


                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                        for (int i = 0; i < jsonObject.optJSONArray("questionAnswers").length(); i++) {
                            GenericObject inner = new GenericObject();

                            inner.setTitle(jsonObject.optJSONArray("questionAnswers").getJSONObject(i).optString("question"));
                            inner.setAnswer(jsonObject.optJSONArray("questionAnswers").getJSONObject(i).optString("answer"));

                            securityQuestionsList.add(inner);
                        }

                        et_email.setVisibility(View.GONE);
                        securityQuestion.setVisibility(View.VISIBLE);
                        et_answer.setVisibility(View.VISIBLE);

                        obj = securityQuestionsList.get(0);
                        securityQuestion.setText(obj.getTitle());

                        ((LoginActivity) getActivity()).dismissProgressDialog();

                        //submitForm();
                    } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(jsonObject.getString("message"));
                        ((LoginActivity) getActivity()).dismissProgressDialog();

                    }


                } catch (JSONException e) {
                    ((LoginActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.FORGOT_PASSWORD_USER_MAIL_TAG)) {
                ((LoginActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);
                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "An email has been sent with link to change password at your Email Address.", Toast.LENGTH_LONG).show();
                        LoginFragment loginFragment = new LoginFragment();//
                        FragmentManager fragmentManager = getFragmentManager();
                        FragmentTransaction transaction = fragmentManager.beginTransaction();
                        transaction.replace(R.id.container, loginFragment);
                        fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                        transaction.commit();
                    } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "Try Again", Toast.LENGTH_LONG).show();
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


            } else if (tag.equalsIgnoreCase(Constants.FORGOT_PASSWORD_MAX_NUMBER_OF_LIMIT_TAG)) {

                ((LoginActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);
                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "You have reached max number of hits. Please contact administrator!", Toast.LENGTH_LONG).show();
                        LoginFragment loginFragment = new LoginFragment();
                        FragmentManager fragmentManager = getFragmentManager();
                        FragmentTransaction transaction = fragmentManager.beginTransaction();
                        transaction.replace(R.id.container, loginFragment);
                        fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                        transaction.commit();
                    } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "Try Again", Toast.LENGTH_LONG).show();
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