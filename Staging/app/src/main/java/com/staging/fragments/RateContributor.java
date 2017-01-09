package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RatingBar;
import android.widget.Spinner;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.dropdownadapter.SpinnerAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.models.GenericObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.DateTimeFormatClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;

/**
 * Created by sunakshi.gautam on 1/14/2016.
 */
public class RateContributor extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    private String selectedKeyword = "";
    private ArrayList<String> selectedKeywordList;
    private ArrayList<GenericObject> deliverableList;
    private Button cancelBtn, doneBtn;
    private EditText timeStamp, et_description;
    private Spinner et_deliverable;
    private String user_id = "";
    private String user_type = "";
    private RatingBar rating;
    private float rating_count = 0;
    private String deliverable_id;

    public RateContributor() {

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_ratecontibutor, container, false);

        try {
            rating = (RatingBar) rootView.findViewById(R.id.rating);
            et_description = (EditText) rootView.findViewById(R.id.et_description);
            et_deliverable = (Spinner) rootView.findViewById(R.id.et_deliverable);
            timeStamp = (EditText) rootView.findViewById(R.id.et_timeStamp);
           /* SimpleDateFormat dateformate = new SimpleDateFormat(Constants.DATE_FORMAT);
            Calendar currentDate = Calendar.getInstance();
            String currentDateStr = dateformate.format(currentDate.getTime());*/
            timeStamp.setText(DateTimeFormatClass.convertDateObjectToMMDDYYYFormat(new Date()));
            user_id = getArguments().getString("userId");
            user_type = getArguments().getString("user_type");
            deliverableList = new ArrayList<GenericObject>();
            selectedKeywordList = new ArrayList<String>();

            cancelBtn = (Button) rootView.findViewById(R.id.cancel);
            doneBtn = (Button) rootView.findViewById(R.id.done);

            doneBtn.setOnClickListener(this);
            cancelBtn.setOnClickListener(this);

            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ALL_DELIVERABLES_TAG, Constants.ALL_DELIVERABLES_URL, Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }

            rating.setOnRatingBarChangeListener(new RatingBar.OnRatingBarChangeListener() {
                @Override
                public void onRatingChanged(RatingBar ratingBar, float rating, boolean fromUser) {
                    rating_count = rating;
                }
            });





//            et_deliverable.setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View v) {

// else {
//
//                        final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
//                        for (int i = 0; i < deliverableList.size(); i++) {
//                            tempArray.add(i, deliverableList.get(i));
//                        }
//                        String[] deviceNameArr = new String[deliverableList.size()];
//                        final boolean[] selectedItems = new boolean[deliverableList.size()];
//                        for (int i = 0; i < deviceNameArr.length; i++) {
//                            deviceNameArr[i] = deliverableList.get(i).getTitle();
//                            selectedItems[i] = deliverableList.get(i).ischecked();
//                        }
//                        final AlertDialog.Builder builderDialog = new AlertDialog.Builder(new ContextThemeWrapper(getActivity(), R.style.AlertDialogCustom));
//                        builderDialog.setTitle("Deliverables");
//
//                        builderDialog.setMultiChoiceItems(deviceNameArr, selectedItems,
//                                new DialogInterface.OnMultiChoiceClickListener() {
//                                    public void onClick(DialogInterface dialog,
//                                                        int whichButton, boolean isChecked) {
//                                    }
//                                });
//
//                        builderDialog.setPositiveButton("OK",
//                                new DialogInterface.OnClickListener() {
//                                    @Override
//                                    public void onClick(DialogInterface dialog, int which) {
//
//                                        ListView list = ((AlertDialog) dialog).getListView();
//                                        // make selected item in the comma seprated string
//                                        StringBuilder stringBuilder = new StringBuilder();
//                                        StringBuilder selectedKeywordsId = new StringBuilder();
//                                        for (int i = 0; i < list.getCount(); i++) {
//                                            boolean checked = list.isItemChecked(i);
//
//                                            if (checked) {
//                                                if (stringBuilder.length() > 0)
//                                                    stringBuilder.append(",");
//                                                stringBuilder.append(list.getItemAtPosition(i));
//                                                deliverableList.get(i).setIschecked(checked);
//                                            } else {
//
//                                                deliverableList.get(i).setIschecked(checked);
//                                            }
//                                        }
//                                        selectedKeywordList.clear();
//                                        for (int i = 0; i < deliverableList.size(); i++) {
//                                            if (deliverableList.get(i).ischecked()) {
//                                                selectedKeywordList.add(deliverableList.get(i).getId());
//                                            }
//                                        }
//
//                                        for (int i = 0; i < selectedKeywordList.size(); i++) {
//                                            if (selectedKeywordsId.length() > 0) {
//                                                selectedKeywordsId.append(",");
//                                            }
//                                            selectedKeywordsId.append(selectedKeywordList.get(i));
//                                        }
//                                        selectedKeyword = selectedKeywordsId.toString();
//                                        et_deliverable.setText("Deliverable: " + stringBuilder.toString());
//                                    }
//                                });
//
//                        builderDialog.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
//
//                            @Override
//                            public void onClick(DialogInterface dialog, int which) {
//                                deliverableList.clear();
//                                for (int i = 0; i < tempArray.size(); i++) {
//                                    deliverableList.add(i, tempArray.get(i));
//                                }
//
//                                StringBuilder selectedKeywordsId = new StringBuilder();
//                                selectedKeywordList.clear();
//                                for (int i = 0; i < deliverableList.size(); i++) {
//                                    if (deliverableList.get(i).ischecked()) {
//                                        selectedKeywordList.add(deliverableList.get(i).getId());
//                                    }
//                                }
//
//                                for (int i = 0; i < selectedKeywordList.size(); i++) {
//                                    if (selectedKeywordsId.length() > 0) {
//                                        selectedKeywordsId.append(",");
//                                    }
//                                    selectedKeywordsId.append(selectedKeywordList.get(i));
//                                }
//                                selectedKeyword = selectedKeywordsId.toString();
//                                tempArray.clear();
//                            }
//                        });
//
//                        AlertDialog alert = builderDialog.create();
//                        alert.show();
//                    }
//                }
//            });
        } catch (Exception e) {
            e.printStackTrace();
        }


            et_deliverable.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                @Override
                public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                    deliverable_id = deliverableList.get(position).getId();

                }

                @Override
                public void onNothingSelected(AdapterView<?> parent) {
                    Toast.makeText(getActivity(), "No Deliverable Selected!", Toast.LENGTH_LONG).show();
                }
            });


        return rootView;
    }


    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        ((HomeActivity) getActivity()).setActionBarTitle("Rate Contractor");
    }

    @Override
    public void onClick(View v) {
        try {
            switch (v.getId()) {

                case R.id.cancel:


                    getActivity().onBackPressed();
                    break;

                case R.id.done:
                    if(et_description.getText().toString().trim().isEmpty()){
                        Toast.makeText(getActivity(), "Description can not be left blank.", Toast.LENGTH_LONG).show();
                    }else if (deliverable_id.compareTo("")==0){
                        Toast.makeText(getActivity(), "Please select Deliverable.", Toast.LENGTH_LONG).show();
                    }else if (rating_count==0){
                        Toast.makeText(getActivity(), "Please give rating starts.", Toast.LENGTH_LONG).show();
                    }else{
                        JSONObject ratingJson = new JSONObject();
                        try {
                            ratingJson.put("given_by", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            ratingJson.put("given_to", user_id);
                            ratingJson.put("description", et_description.getText().toString().trim());
                            ratingJson.put("rating_star", rating_count);
                            ratingJson.put("deliverable", deliverable_id);
                            ratingJson.put("user_type", user_type);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }


                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.RATE_CONTRACTOR_TAG, Constants.RATE_CONTRACTOR_URL, Constants.HTTP_POST, ratingJson,"Home Activity");
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    }
                    //getActivity().onBackPressed();
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
                if (tag.equalsIgnoreCase(Constants.ALL_DELIVERABLES_TAG)) {

                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        deliverableList.clear();

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            for (int i = 0; i < jsonObject.optJSONArray("Deliverables").length(); i++) {
                                GenericObject deliverableObj = new GenericObject();
                                deliverableObj.setId(jsonObject.optJSONArray("Deliverables").getJSONObject(i).optString("id"));
                                deliverableObj.setTitle(jsonObject.optJSONArray("Deliverables").getJSONObject(i).optString("name"));
                                deliverableList.add(deliverableObj);
                            }

                            if (deliverableList.size() == 0) {
                                Toast.makeText(getActivity(), "No Deliverable is available!", Toast.LENGTH_LONG).show();
                            } else {

                                SpinnerAdapter dataAdapter = new SpinnerAdapter(getActivity(),0,deliverableList);

                                // Drop down layout style - list view with radio button

                                et_deliverable.setAdapter(dataAdapter);

                            }


                        }
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            if (!jsonObject.optJSONObject("errors").optString("rating_star").isEmpty()) {
                                Toast.makeText(getActivity(), jsonObject.optJSONObject("errors").optString("rating_star"), Toast.LENGTH_LONG).show();
                            }else if (!jsonObject.optJSONObject("errors").optString("description").isEmpty()){
                                Toast.makeText(getActivity(), jsonObject.optJSONObject("errors").optString("description"), Toast.LENGTH_LONG).show();
                            }else if (!jsonObject.optJSONObject("errors").optString("deliverable").isEmpty()){
                                Toast.makeText(getActivity(), jsonObject.optJSONObject("errors").optString("deliverable"), Toast.LENGTH_LONG).show();
                            }
                        }
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    } catch (JSONException e) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.RATE_CONTRACTOR_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                            getActivity().onBackPressed();
                        }else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            if (jsonObject.getJSONObject("errors").has("description")){
                                Toast.makeText(getActivity(), jsonObject.getJSONObject("errors").optString("description"), Toast.LENGTH_LONG).show();
                            }
                        }
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