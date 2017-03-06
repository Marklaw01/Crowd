package com.crowdbootstrap.fragments;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.dropdownadapter.SpinnerAdapter;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.models.GenericObject;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Locale;

/**
 * Created by neelmani.karn on 1/15/2016.
 */
public class CampaignCommitFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    private RadioButton rb_public, rb_private;
    private boolean ACCREDETED_INVESTER = false;
    private static String CAMPAING_ID;
    private static String TIME_PERIOD_ID = "0";
    private String fundRaised;
    private String targetAmount;
    ArrayList<GenericObject> timePeriodList;
    private Spinner spinner_timePerios;
    private Button btn_cancel, btn_submit;
    private EditText et_targetAmount;
    private TextView tv_availableAmount;

    float amount = 0;

    public CampaignCommitFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();

        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        try {
            CAMPAING_ID = getArguments().getString("CAMPAIGN_ID");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_commit_campaign, container, false);
        try {
            ((HomeActivity) getActivity()).setActionBarTitle(getArguments().getString("CAMPAIGN_NAME"));

            tv_availableAmount = (TextView) rootView.findViewById(R.id.tv_availableAmount);
            rb_private = (RadioButton) rootView.findViewById(R.id.rb_private);
            rb_public = (RadioButton) rootView.findViewById(R.id.rb_public);

            fundRaised = getArguments().getString("fund_raised");
            targetAmount = getArguments().getString("target_amount");

            amount = Float.parseFloat(((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(targetAmount)) - Float.parseFloat(((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(fundRaised));

            tv_availableAmount.setText(((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat(String.format("%.2f", amount)));


            btn_cancel = (Button) rootView.findViewById(R.id.btn_cancel);
            btn_submit = (Button) rootView.findViewById(R.id.btn_submit);
            spinner_timePerios = (Spinner) rootView.findViewById(R.id.spinner_timePerios);
            et_targetAmount = (EditText) rootView.findViewById(R.id.et_targetAmount);

            timePeriodList = new ArrayList<GenericObject>();

            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.TIME_PERIOD_TAG, Constants.TIME_PERIOD_URL, Constants.HTTP_POST,"Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }

            spinner_timePerios.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                @Override
                public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                    TIME_PERIOD_ID = timePeriodList.get(position).getId();
                }

                @Override
                public void onNothingSelected(AdapterView<?> parent) {

                }
            });
            rb_private.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                @Override
                public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                    if (isChecked) {
                        //isAccredetInvester = true;
                        ACCREDETED_INVESTER = true;
                    } else {
                        //isAccredetInvester = false;
                        ACCREDETED_INVESTER = false;
                    }
                }
            });

            rb_public.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                @Override
                public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                    if (isChecked) {
                        //isAccredetInvester = false;
                        ACCREDETED_INVESTER = false;
                    } else {
                        //isAccredetInvester = true;
                        ACCREDETED_INVESTER = true;
                    }
                }
            });

            et_targetAmount.addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                }

                private String current = "";

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {

                }

                @Override
                public void afterTextChanged(Editable s) {


                    if (!s.toString().equals(current)) {
                        String edtString = s.toString();
                        String cleanString = edtString.replaceAll("[$,.]", "");

                        Locale locale = new Locale("en", "US");
                        NumberFormat fmt = NumberFormat.getCurrencyInstance(locale);

                        double parsed = Double.parseDouble(cleanString);
                        String formated = fmt.format((parsed / 100));//NumberFormat.getCurrencyInstance().format((parsed / 100));

                        current = formated;
                        et_targetAmount.setText(formated);
                        // Log.e("formated", formated);
                        et_targetAmount.setSelection(formated.length());

                        float formatedAmount = Float.parseFloat(((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(formated));
                        float balance = amount - formatedAmount;
                        if (balance < 0) {
                            String reqSubString = edtString.substring(0, edtString.length() - 1);
                            et_targetAmount.setText(reqSubString);
                            et_targetAmount.setSelection(reqSubString.length());
                        }
                        else {
                            tv_availableAmount.setText(((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat(String.format("%.2f", balance)));
                        }

                    }
                }
            });


            btn_submit.setOnClickListener(this);
            btn_cancel.setOnClickListener(this);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }catch (Exception e){
            e.printStackTrace();
        }
        return rootView;
    }

    @Override
    public void onClick(View v) {
        try {
            switch (v.getId()) {
                case R.id.btn_cancel:
                    getActivity().onBackPressed();
                    break;
                case R.id.btn_submit:
                    InputMethodManager inputMethodManager = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
                    inputMethodManager.hideSoftInputFromWindow(getActivity().getCurrentFocus().getWindowToken(), 0);

                    if (et_targetAmount.getText().toString().trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Target Cannot be left blank!", Toast.LENGTH_LONG).show();
                    } else if (TIME_PERIOD_ID.trim().equalsIgnoreCase("0")) {
                        Toast.makeText(getActivity(), "Please select Time Period!", Toast.LENGTH_LONG).show();
                    } else {
                        JSONObject jsonObject = new JSONObject();
                        try {
                            jsonObject.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            jsonObject.put("campaign_id", CAMPAING_ID);
                            try {
                                jsonObject.put("target_amount", ((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(et_targetAmount.getText().toString().trim()));
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                            jsonObject.put("contribution_public", ACCREDETED_INVESTER);
                            jsonObject.put("time_period", TIME_PERIOD_ID);

                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                ((HomeActivity) getActivity()).showProgressDialog();
                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.COMMIT_CAMPAIGN_TAG, Constants.COMMIT_CAMPAIGN_URL, Constants.HTTP_POST, jsonObject,"Home Activity");
                                a.execute();
                            } else {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onTaskComplete(String result, String tag) {
        try {
            if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
                Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
            } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
                Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
            } else {
                if (tag.equalsIgnoreCase(Constants.TIME_PERIOD_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        GenericObject obj = new GenericObject();
                        obj.setTitle("Select Time-Period");
                        obj.setId("0");
                        timePeriodList.add(obj);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            for (int i = 0; i < jsonObject.optJSONArray("DonationTimeperiods").length(); i++) {
                                GenericObject timePeriod = new GenericObject();
                                timePeriod.setId(jsonObject.optJSONArray("DonationTimeperiods").getJSONObject(i).optString("id"));
                                timePeriod.setTitle(jsonObject.optJSONArray("DonationTimeperiods").getJSONObject(i).optString("name"));
                                timePeriodList.add(timePeriod);
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            timePeriodList.clear();
                            System.out.println(jsonObject);
                            GenericObject errorObj = new GenericObject();
                            errorObj.setTitle("Select Time-Period");
                            errorObj.setId("0");
                            timePeriodList.add(errorObj);
                        }
                        spinner_timePerios.setAdapter(new SpinnerAdapter(getActivity(), 0, timePeriodList));
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    } catch (JSONException e) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.COMMIT_CAMPAIGN_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "Successfully committed", Toast.LENGTH_LONG).show();

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        getActivity().onBackPressed();
                    } catch (JSONException e) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}