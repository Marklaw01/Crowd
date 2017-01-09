package com.crowdbootstrapapp.fragments;

import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.ContextThemeWrapper;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.Toast;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.dropdownadapter.SpinnerAdapter;
import com.crowdbootstrapapp.helper.NumberTextWatcherForThousand;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.models.GenericObject;
import com.crowdbootstrapapp.utilities.Async;
import com.crowdbootstrapapp.utilities.Constants;
import com.crowdbootstrapapp.utilities.DateTimeFormatClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

/**
 * Created by sunakshi.gautam on 1/14/2016.
 */
public class AddContributor extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    private String startup_id = "0", role_id = "0";
    private String contractor_id = "";
    private String selectedKeyword = "";
    private ArrayList<String> selectedKeywordList;
    private ArrayList<GenericObject> deliverableList;
    private ArrayList<GenericObject> rolesList;
    private EditText et_deliverablename, contributorname, hoursrate, hoursallowed, hoursapproved,targetCompletionDate;
    private ArrayList<GenericObject> startupList;
    private Spinner roleSpinner, selectStartup;
    private Button assignBtn;
    private Calendar myCalendar;
    private DatePickerDialog.OnDateSetListener date;
    public AddContributor() {
        super();
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_addcontributor, container, false);

        try {
            ((HomeActivity) getActivity()).setActionBarTitle("Add Contractor");
            startupList = new ArrayList<GenericObject>();
            et_deliverablename = (EditText) rootView.findViewById(R.id.et_deliverablename);

//        contractor_id = getArguments().getString("contractor_id");
            Log.e("contractor_id", contractor_id);
            rolesList = new ArrayList<GenericObject>();
            deliverableList = new ArrayList<GenericObject>();
            selectedKeywordList = new ArrayList<String>();

            roleSpinner = (Spinner) rootView.findViewById(R.id.role);
            selectStartup = (Spinner) rootView.findViewById(R.id.selectStartup);
            assignBtn = (Button) rootView.findViewById(R.id.assign);
            assignBtn.setOnClickListener(this);

            hoursapproved = (EditText) rootView.findViewById(R.id.hoursapproved);
            contributorname = (EditText) rootView.findViewById(R.id.contributorname);
            hoursrate = (EditText) rootView.findViewById(R.id.hoursrate);
            hoursallowed = (EditText) rootView.findViewById(R.id.hoursallowed);
            targetCompletionDate = (EditText) rootView.findViewById(R.id.targetcompletedate);
            myCalendar = Calendar.getInstance();


            hoursapproved.addTextChangedListener(new NumberTextWatcherForThousand(hoursapproved));
            hoursallowed.addTextChangedListener(new NumberTextWatcherForThousand(hoursallowed));


            date = new DatePickerDialog.OnDateSetListener() {

                @Override
                public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {

                    myCalendar.set(Calendar.YEAR, year);
                    myCalendar.set(Calendar.MONTH, monthOfYear);
                    myCalendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                    updateLabel();
                }
            };

            targetCompletionDate.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    DatePickerDialog dialog = new DatePickerDialog(getActivity(), date, myCalendar
                            .get(Calendar.YEAR), myCalendar.get(Calendar.MONTH),
                            myCalendar.get(Calendar.DAY_OF_MONTH));
                    dialog.show();
                }
            });



            if (Constants.COMMING_FROM_INTENT.equalsIgnoreCase("recommendedContractors")) {
                selectStartup.setVisibility(View.GONE);
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ALL_DELIVERABLES_TAG, Constants.ALL_DELIVERABLES_URL, Constants.HTTP_GET,"Home Activity");
                    a.execute();
                } else {
                    //((HomeActivity) getActivity()).dismissProgressDialog();
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            } else {
                selectStartup.setVisibility(View.VISIBLE);
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_STARTUPS_TAG, Constants.USER_STARTUPS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&user_type=" + Constants.ENTREPRENEUR, Constants.HTTP_POST, "Home Activity");
                    a.execute();
                } else {

                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            }
        /*if (getArguments().getString("contractor_id").equalsIgnoreCase(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID))){

        }else{

        }*/

            contributorname.setText(getArguments().getString("contractor_name"));

            hoursrate.setText(((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat(getArguments().getString("hourly_rate")));
            hoursrate.addTextChangedListener(new TextWatcher() {
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
                        String cleanString = s.toString().replaceAll("[$,.]", "");

                        Locale locale = new Locale("en", "US");
                        NumberFormat fmt = NumberFormat.getCurrencyInstance(locale);

                        double parsed = Double.parseDouble(cleanString);
                        String formated = fmt.format((parsed / 100));//NumberFormat.getCurrencyInstance().format((parsed / 100));

                        current = formated;
                        hoursrate.setText(formated);
                        hoursrate.setSelection(formated.length());
                    }
                }
            });

            selectStartup.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                @Override
                public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                    startup_id = startupList.get(position).getId();
                }

                @Override
                public void onNothingSelected(AdapterView<?> parent) {

                }
            });

            roleSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                @Override
                public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                    role_id = rolesList.get(position).getId();
                }

                @Override
                public void onNothingSelected(AdapterView<?> parent) {

                }
            });


            et_deliverablename.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (deliverableList.size() == 0) {
                        Toast.makeText(getActivity(), "No Deliverable is available!", Toast.LENGTH_LONG).show();
                    } else {

                        final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                        for (int i = 0; i < deliverableList.size(); i++) {
                            tempArray.add(i, deliverableList.get(i));
                        }
                        String[] deviceNameArr = new String[deliverableList.size()];
                        final boolean[] selectedItems = new boolean[deliverableList.size()];
                        for (int i = 0; i < deviceNameArr.length; i++) {
                            deviceNameArr[i] = deliverableList.get(i).getTitle();
                            selectedItems[i] = deliverableList.get(i).ischecked();
                        }
                        final AlertDialog.Builder builderDialog = new AlertDialog.Builder(new ContextThemeWrapper(getActivity(), R.style.AlertDialogCustom));
                        builderDialog.setTitle("Select Roadmap Deliverable");

                        builderDialog.setMultiChoiceItems(deviceNameArr, selectedItems,
                                new DialogInterface.OnMultiChoiceClickListener() {
                                    public void onClick(DialogInterface dialog,
                                                        int whichButton, boolean isChecked) {
                                    }
                                });

                        builderDialog.setPositiveButton("OK",
                                new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {

                                        ListView list = ((AlertDialog) dialog).getListView();
                                        // make selected item in the comma seprated string
                                        StringBuilder stringBuilder = new StringBuilder();
                                        StringBuilder selectedKeywordsId = new StringBuilder();
                                        for (int i = 0; i < list.getCount(); i++) {
                                            boolean checked = list.isItemChecked(i);

                                            if (checked) {
                                                if (stringBuilder.length() > 0)
                                                    stringBuilder.append(",");
                                                stringBuilder.append(list.getItemAtPosition(i));
                                                deliverableList.get(i).setIschecked(checked);
                                            } else {

                                                deliverableList.get(i).setIschecked(checked);
                                            }
                                        }
                                        selectedKeywordList.clear();
                                        for (int i = 0; i < deliverableList.size(); i++) {
                                            if (deliverableList.get(i).ischecked()) {
                                                selectedKeywordList.add(deliverableList.get(i).getId());
                                            }
                                        }

                                        for (int i = 0; i < selectedKeywordList.size(); i++) {
                                            if (selectedKeywordsId.length() > 0) {
                                                selectedKeywordsId.append(",");
                                            }
                                            selectedKeywordsId.append(selectedKeywordList.get(i));
                                        }
                                        selectedKeyword = selectedKeywordsId.toString();
                                        et_deliverablename.setText("Deliverable: " + stringBuilder.toString());
                                    }
                                });

                        builderDialog.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {

                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                deliverableList.clear();
                                for (int i = 0; i < tempArray.size(); i++) {
                                    deliverableList.add(i, tempArray.get(i));
                                }

                                StringBuilder selectedKeywordsId = new StringBuilder();
                                selectedKeywordList.clear();
                                for (int i = 0; i < deliverableList.size(); i++) {
                                    if (deliverableList.get(i).ischecked()) {
                                        selectedKeywordList.add(deliverableList.get(i).getId());
                                    }
                                }

                                for (int i = 0; i < selectedKeywordList.size(); i++) {
                                    if (selectedKeywordsId.length() > 0) {
                                        selectedKeywordsId.append(",");
                                    }
                                    selectedKeywordsId.append(selectedKeywordList.get(i));
                                }
                                selectedKeyword = selectedKeywordsId.toString();
                                tempArray.clear();
                            }
                        });

                        AlertDialog alert = builderDialog.create();
                        alert.show();
                    }
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }


        return rootView;
    }


    private void updateLabel() {
        targetCompletionDate.setText(DateTimeFormatClass.convertDateObjectToMMDDYYYFormat(myCalendar.getTime()));
    }


    @Override
    public void onResume() {
        super.onResume();
        try {
            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.addContributortitle));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onClick(View v) {
        try {
            switch (v.getId()) {
                case R.id.assign:
//                    Log.e("XXX","APPROVED HOURS+++"+NumberTextWatcherForThousand.trimCommaOfString(hoursapproved.getText().toString())+"ALLOCATED HOURS+++++"+NumberTextWatcherForThousand.trimCommaOfString(hoursallowed.getText().toString()));
                    String WorkUnitsApproved = NumberTextWatcherForThousand.trimCommaOfString(hoursapproved.getText().toString());
                    String WorkUnitsAllocated = NumberTextWatcherForThousand.trimCommaOfString(hoursallowed.getText().toString());
                    String TargetDate =  targetCompletionDate.getText().toString();
                    if (role_id.equalsIgnoreCase("0")) {
                        Toast.makeText(getActivity(), "Select Role", Toast.LENGTH_LONG).show();
                    } else if (((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(hoursrate.getText().toString().trim()).equalsIgnoreCase("0.00")) {
                        Toast.makeText(getActivity(), "Hourly rate cannot be 0.00", Toast.LENGTH_LONG).show();
                    } else if (selectedKeyword.trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Select Deliverable", Toast.LENGTH_LONG).show();
                    } else if (WorkUnitsAllocated.trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Hours Allocated cannot be left blank.", Toast.LENGTH_LONG).show();
                    } else if (WorkUnitsApproved.trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Hours Approved cannot be left blank.", Toast.LENGTH_LONG).show();
                    }
                    else if(TargetDate.trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Target Date cannot be left blank.", Toast.LENGTH_LONG).show();
                    }
                    else if (Integer.parseInt(WorkUnitsApproved) > Integer.parseInt(WorkUnitsAllocated)) {
                        Toast.makeText(getActivity(), "Approved work units can not be greater than the Allocated work units.", Toast.LENGTH_LONG).show();
                    } else {
                        JSONObject addContractorObj = new JSONObject();
                        try {
                        if (!ViewOtherContractorPublicProfileFragment.TEAM_STARTUP_ID.trim().isEmpty()) {
                                addContractorObj.put("startup_id", ViewOtherContractorPublicProfileFragment.TEAM_STARTUP_ID.trim());
                            } else {
                                addContractorObj.put("startup_id", startup_id);
                            }
                            addContractorObj.put("user_id", getArguments().getString("contractor_id"));
                            addContractorObj.put("contractor_role_id", role_id);
                            addContractorObj.put("hourly_price", ((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(hoursrate.getText().toString().trim()));
                            addContractorObj.put("roadmap_id", selectedKeyword);
                            addContractorObj.put("work_units_allocated",WorkUnitsAllocated);
                            addContractorObj.put("work_units_approved",WorkUnitsApproved);
                            addContractorObj.put("target_date",TargetDate);
                            addContractorObj.put("hired_by", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }


                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ADD_CONTRACTOR_TAG, Constants.ADD_CONTRACTOR_URL, Constants.HTTP_POST, addContractorObj,"Home Activity");
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
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
                ((HomeActivity) getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
            } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
            } else {
                if (tag.equalsIgnoreCase(Constants.USER_STARTUPS_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        GenericObject obj = new GenericObject();
                        obj.setTitle("Choose Startup");
                        obj.setId("0");
                        startupList.add(obj);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            for (int i = 0; i < jsonObject.optJSONArray("startup").length(); i++) {
                                GenericObject startupsObject = new GenericObject();
                                startupsObject.setId(jsonObject.optJSONArray("startup").optJSONObject(i).optString("id"));
                                startupsObject.setTitle(jsonObject.optJSONArray("startup").optJSONObject(i).optString("name"));

                                startupList.add(startupsObject);
                            }

                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ALL_DELIVERABLES_TAG, Constants.ALL_DELIVERABLES_URL, Constants.HTTP_GET,"Home Activity");
                                a.execute();
                            } else {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            Toast.makeText(getActivity(), jsonObject.optString("message") + " Try Again!", Toast.LENGTH_LONG).show();

                        }
                        selectStartup.setAdapter(new SpinnerAdapter(getActivity(), 0, startupList));
                    } catch (JSONException e) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }

                    /*if (!ViewContractorPublicProfileFragment.TEAM_STARTUP_ID.trim().isEmpty()){
                        selectStartup.setVisibility(View.GONE);
                    }else {
                        selectStartup.setVisibility(View.VISIBLE);
                    }*/


                } else if (tag.equalsIgnoreCase(Constants.ALL_DELIVERABLES_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        deliverableList.clear();


                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            //String startup_id = jsonObject.optString("startup_id");


                            for (int i = 0; i < jsonObject.optJSONArray("Deliverables").length(); i++) {
                                GenericObject deliverableObj = new GenericObject();
                                deliverableObj.setId(jsonObject.optJSONArray("Deliverables").getJSONObject(i).optString("id"));
                                deliverableObj.setTitle(jsonObject.optJSONArray("Deliverables").getJSONObject(i).optString("name"));
                                deliverableList.add(deliverableObj);
                            }
                        }
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }


                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.TEAM_MEMBER_ROLES_TAG, Constants.TEAM_MEMBER_ROLES_URL, Constants.HTTP_GET,"Home Activity");
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } catch (JSONException e) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.TEAM_MEMBER_ROLES_TAG)) {

                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        rolesList.clear();
                        GenericObject obj = new GenericObject();
                        obj.setId("0");
                        obj.setTitle("Choose Role");
                        rolesList.add(obj);


                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                            for (int i = 0; i < jsonObject.optJSONArray("Roles").length(); i++) {
                                GenericObject deliverableObj = new GenericObject();

                                if (ViewOtherContractorPublicProfileFragment.LOGGEDIN_USER_ROLE == 2) {
                                    if (jsonObject.optJSONArray("Roles").getJSONObject(i).optString("name").equalsIgnoreCase("Entrepreneur")) {
                                        continue;
                                    } else if (jsonObject.optJSONArray("Roles").getJSONObject(i).optString("name").equalsIgnoreCase("Co-founder")) {
                                        continue;
                                    } else {
                                        deliverableObj.setId(jsonObject.optJSONArray("Roles").getJSONObject(i).optString("id"));
                                        deliverableObj.setTitle(jsonObject.optJSONArray("Roles").getJSONObject(i).optString("name"));
                                    }
                                } else if (ViewOtherContractorPublicProfileFragment.LOGGEDIN_USER_ROLE == 3) {
                                    if (jsonObject.optJSONArray("Roles").getJSONObject(i).optString("name").equalsIgnoreCase("Entrepreneur")) {
                                        continue;
                                    } else if (jsonObject.optJSONArray("Roles").getJSONObject(i).optString("name").equalsIgnoreCase("Co-founder")) {
                                        continue;
                                    } else if (jsonObject.optJSONArray("Roles").getJSONObject(i).optString("name").equalsIgnoreCase("Team-member")) {
                                        continue;
                                    } else {
                                        deliverableObj.setId(jsonObject.optJSONArray("Roles").getJSONObject(i).optString("id"));
                                        deliverableObj.setTitle(jsonObject.optJSONArray("Roles").getJSONObject(i).optString("name"));
                                    }
                                } else if (ViewOtherContractorPublicProfileFragment.LOGGEDIN_USER_ROLE == 1) {
                                    if (jsonObject.optJSONArray("Roles").getJSONObject(i).optString("name").equalsIgnoreCase("Entrepreneur")) {
                                        continue;
                                    } else {
                                        deliverableObj.setId(jsonObject.optJSONArray("Roles").getJSONObject(i).optString("id"));
                                        deliverableObj.setTitle(jsonObject.optJSONArray("Roles").getJSONObject(i).optString("name"));
                                    }
                                }
                                rolesList.add(deliverableObj);
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }


                        roleSpinner.setAdapter(new SpinnerAdapter(getActivity(), 0, rolesList));

                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    } catch (JSONException e) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.ADD_CONTRACTOR_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();

                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_LONG).show();
                            getActivity().onBackPressed();
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_LONG).show();
                        }
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
