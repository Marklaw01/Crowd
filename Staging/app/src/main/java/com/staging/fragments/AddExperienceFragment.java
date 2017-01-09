package com.staging.fragments;

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

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.helper.MyLayoutExperienceOperation;
import com.staging.helper.MyLayoutOperation;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.models.GenericObject;
import com.staging.models.QuestionAnswerObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;

/**
 * Created by Sunakshi.Gautam on 12/9/2016.
 */
public class AddExperienceFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {
    private ImageView add;
    public static ArrayList<String> mQuestionsDynamic;
    public static ArrayList<String> mAnswersDynamic;
    public static ArrayList<GenericObject> jobRole;
    public static ArrayList<String> selectedJobRoleList;
    public static ArrayList<GenericObject> jobDuties;
    public static ArrayList<String> selectedJobDutiesList;
    public static ArrayList<GenericObject> jobAchievements;
    public static ArrayList<String> selectedJobAchievementsList;

    private Button saveExperience;
    private StringBuilder stringBuilderJob_RoleID;
    private StringBuilder stringBuilderJob_DutiesID;
    private StringBuilder stringBuilderJob_AchievementsID;


    public AddExperienceFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.add_experience_fragment, container, false);
        mQuestionsDynamic = new ArrayList<String>();

        mAnswersDynamic = new ArrayList<String>();
        jobRole = new ArrayList<GenericObject>();
        selectedJobRoleList = new ArrayList<String>();
        jobDuties = new ArrayList<GenericObject>();
        selectedJobDutiesList = new ArrayList<String>();
        jobAchievements = new ArrayList<GenericObject>();
        selectedJobAchievementsList = new ArrayList<String>();


        mQuestionsDynamic.add("Compay Name");
        mQuestionsDynamic.add("Job Title");
        mQuestionsDynamic.add("Start Date");
        mQuestionsDynamic.add("End Date");
        mQuestionsDynamic.add("Company URL");
        mQuestionsDynamic.add("Job Role");
        mQuestionsDynamic.add("Job Duties");
        mQuestionsDynamic.add("Achievements");


        add = (ImageView) rootView.findViewById(R.id.add);
        saveExperience = (Button) rootView.findViewById(R.id.savequestionnair);

        saveExperience.setOnClickListener(this);
        add.setOnClickListener(this);
        return rootView;
    }


    private StringBuilder stringBuilderJob_Role;
    private StringBuilder stringBuilderJob_Duties;
    private StringBuilder stringBuilderJob_Achievements;
    private String jobExperienceId;

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
                if (tag.equalsIgnoreCase(Constants.JOB_ROLES_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        ((HomeActivity) getActivity()).dismissProgressDialog();


                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            for (int i = 0; i < jsonObject.optJSONArray("job_role_list").length(); i++) {
                                GenericObject startupsObject = new GenericObject();
                                startupsObject.setId(jsonObject.optJSONArray("job_role_list").optJSONObject(i).optString("job_role_id"));
                                startupsObject.setTitle(jsonObject.optJSONArray("job_role_list").optJSONObject(i).optString("job_role_name"));

                                jobRole.add(startupsObject);
                            }


                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            Toast.makeText(getActivity(), jsonObject.optString("message") + " Try Again!", Toast.LENGTH_LONG).show();


                        }

                    } catch (JSONException e) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.JOB_DUTIES_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();

                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        jobDuties.clear();
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            for (int i = 0; i < jsonObject.optJSONArray("job_duty_list").length(); i++) {
                                GenericObject obj = new GenericObject();
                                obj.setId(jsonObject.optJSONArray("job_duty_list").getJSONObject(i).optString("job_duty_id"));
                                obj.setTitle(jsonObject.optJSONArray("job_duty_list").getJSONObject(i).optString("job_duty_name"));
                                jobDuties.add(obj);
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            jobDuties.clear();
                        }


                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                } else if (tag.equalsIgnoreCase(Constants.JOB_ACHIEVEMENTS_TAG)) {

                    ((HomeActivity) getActivity()).dismissProgressDialog();

                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        jobAchievements.clear();
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            for (int i = 0; i < jsonObject.optJSONArray("job_achievement_list").length(); i++) {
                                GenericObject obj = new GenericObject();
                                obj.setId(jsonObject.optJSONArray("job_achievement_list").getJSONObject(i).optString("job_achievement_id"));
                                obj.setTitle(jsonObject.optJSONArray("job_achievement_list").getJSONObject(i).optString("job_achievement_name"));
                                jobAchievements.add(obj);
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            jobAchievements.clear();
                        }


                    } catch (JSONException e) {
                        e.printStackTrace();
                    }


                } else if (tag.equalsIgnoreCase(Constants.ADD_EXPERIENCE_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();

                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                            getActivity().onBackPressed();
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.optString("message") + ", Try Again Later.", Toast.LENGTH_LONG).show();

                        }

                    } catch (Exception e) {
                    }

                } else if (tag.equalsIgnoreCase(Constants.USER_EDIT_EXPERIENCE_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            jobExperienceId = jsonObject.optString("job_experience_id");


                            if (jsonObject.optJSONArray("user_experience_list").length() != 0) {

                                for (int i = 0; i < jsonObject.optJSONArray("user_experience_list").length(); i++) {
                                    mQuestionsDynamic.clear();
                                    mAnswersDynamic.clear();
                                    coFounderAdded = true;


                                    JSONObject CofounderObject = jsonObject.optJSONArray("user_experience_list").getJSONObject(i);

                                    if (CofounderObject.has("company_name")) {
                                        mQuestionsDynamic.add("Compay Name");
                                        mAnswersDynamic.add(CofounderObject.optString("company_name"));
                                    }
                                    if (CofounderObject.has("job_title")) {
                                        mQuestionsDynamic.add("Job Title");
                                        mAnswersDynamic.add(CofounderObject.optString("job_title"));
                                    }
                                    if (CofounderObject.has("start_date")) {
                                        mQuestionsDynamic.add("Start Date");
                                        mAnswersDynamic.add(CofounderObject.optString("start_date"));
                                    }
                                    if (CofounderObject.has("end_date")) {
                                        mQuestionsDynamic.add("End Date");
                                        mAnswersDynamic.add(CofounderObject.optString("end_date"));
                                    }
                                    if (CofounderObject.has("company_url")) {
                                        mQuestionsDynamic.add("Company URL");
                                        mAnswersDynamic.add(CofounderObject.optString("company_url"));
                                    }

                                    stringBuilderJob_Role = new StringBuilder();
                                    stringBuilderJob_RoleID = new StringBuilder();
                                    if (CofounderObject.has("job_role_id")) {
                                        for (int j = 0; j < CofounderObject.optJSONArray("job_role_id").length(); j++) {
                                            //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                            if ((j >= 0) && (j < (CofounderObject.optJSONArray("job_role_id").length() - 1))) {
                                                stringBuilderJob_Role.append(CofounderObject.optJSONArray("job_role_id").getJSONObject(j).optString("name") + ", ");
                                                stringBuilderJob_RoleID.append(CofounderObject.optJSONArray("job_role_id").getJSONObject(j).optString("id") + ", ");
                                            } else {
                                                stringBuilderJob_Role.append(CofounderObject.optJSONArray("job_role_id").getJSONObject(j).optString("name") + " ");
                                                stringBuilderJob_RoleID.append(CofounderObject.optJSONArray("job_role_id").getJSONObject(j).optString("id") + ", ");

                                            }
                                        }
                                        MyLayoutExperienceOperation.selectedJobRole.add(stringBuilderJob_RoleID.toString());
                                        mQuestionsDynamic.add("Job Role");
                                        mAnswersDynamic.add(stringBuilderJob_Role.toString());
                                    }



                                    if (CofounderObject.has("job_duty_id")) {

                                        mQuestionsDynamic.add("Job Duties");
                                        mAnswersDynamic.add(CofounderObject.optString("job_duty_id"));
                                    }

                                    if (CofounderObject.has("job_achievement_id")) {

                                        mQuestionsDynamic.add("Achievements");
                                        mAnswersDynamic.add(CofounderObject.optString("job_achievement_id"));
                                    }

                                    MyLayoutExperienceOperation.add(getActivity(), add);
                                }
                            }


                        }
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.JOB_DUTIES_TAG, Constants.JOB_DUTIES_URL, Constants.HTTP_GET, "Home Activity");
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }


                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.JOB_ACHIEVEMENTS_TAG, Constants.JOB_ACHIEVEMENTS_URL, Constants.HTTP_GET, "Home Activity");
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }

                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.JOB_ROLES_TAG, Constants.JOB_ROLES_URL, Constants.HTTP_POST, "Home Activity");
                            a.execute();
                            ;
                        } else {

                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } catch (Exception e) {

                        Log.e("ERROR", e.getMessage());
                    }


                }
            }

        } catch (Exception e) {

        }
    }

    public static boolean coFounderAdded = false;
    private JSONObject questionAnswersJsonObject;

    @Override
    public void onClick(View v) {
        switch (v.getId()) {

            case R.id.add:
                coFounderAdded = true;
                mAnswersDynamic.clear();
                MyLayoutExperienceOperation.add(getActivity(), add);
                break;

            case R.id.savequestionnair:
                questionAnswersJsonObject = new JSONObject();
                questions = new JSONObject();

                try {
                    questionAnswersJsonObject.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    questionAnswersJsonObject.put("job_experience_id", jobExperienceId);

                } catch (JSONException e) {
                    e.printStackTrace();
                }
                if (coFounderAdded == true) {
                    fetchDynamicAnswers();
                }
                break;


        }


    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        ((HomeActivity) getActivity()).setActionBarTitle("Add Experience");


        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();

            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_EDIT_EXPERIENCE_TAG, Constants.USER_EDIT_EXPERIENCE_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET, "Home Activity");
            a.execute();
        } else {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }

    }


    private ArrayList<ArrayList<QuestionAnswerObject>> arrayofDynamicQuestions;
    public ArrayList<QuestionAnswerObject> mAnswerDynamic;
    private JSONObject questions;

    private void fetchDynamicAnswers() {
        arrayofDynamicQuestions = new ArrayList<ArrayList<QuestionAnswerObject>>();

        for (int i = 0; i < MyLayoutExperienceOperation.linearLayoutForm.getChildCount(); i++) {
            mAnswerDynamic = new ArrayList<QuestionAnswerObject>();
            for (int j = 0; j < MyLayoutExperienceOperation.questionsLayout.getChildCount(); j++) {
                LinearLayout coFounderitem = (LinearLayout) MyLayoutExperienceOperation.questionsLayout.getChildAt(j);
                final LinearLayout layoutquestions = (LinearLayout) getActivity().getLayoutInflater().inflate(R.layout.questanswerlayout, null);
                layoutquestions.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));


                EditText answer = (EditText) ((LinearLayout) coFounderitem).findViewById(R.id.answer);

                if (mQuestionsDynamic.get(j).compareTo("Job Role") == 0) {
                    QuestionAnswerObject obj = new QuestionAnswerObject();
                    obj.setAnswers(MyLayoutExperienceOperation.selectedJobRole.get(i).toString());
                    obj.setQuestion("job_role_id");
                    mAnswerDynamic.add(obj);

                } else if (mQuestionsDynamic.get(j).compareTo("Job Duties") == 0) {
                    QuestionAnswerObject obj = new QuestionAnswerObject();
                    obj.setAnswers(answer.getText().toString());
                    obj.setQuestion("job_duty_id");
                    mAnswerDynamic.add(obj);
                } else if (mQuestionsDynamic.get(j).compareTo("Achievements") == 0) {
                    QuestionAnswerObject obj = new QuestionAnswerObject();
                    obj.setAnswers(answer.getText().toString());
                    obj.setQuestion("job_achievement_id");
                    mAnswerDynamic.add(obj);
                } else if (mQuestionsDynamic.get(j).compareTo("Company URL") == 0) {
                    QuestionAnswerObject obj = new QuestionAnswerObject();
                    obj.setAnswers(answer.getText().toString());
                    obj.setQuestion("company_url");
                    mAnswerDynamic.add(obj);
                } else if (mQuestionsDynamic.get(j).compareTo("Start Date") == 0) {
                    QuestionAnswerObject obj = new QuestionAnswerObject();
                    obj.setAnswers(answer.getText().toString());
                    obj.setQuestion("start_date");
                    mAnswerDynamic.add(obj);
                } else if (mQuestionsDynamic.get(j).compareTo("End Date") == 0) {
                    QuestionAnswerObject obj = new QuestionAnswerObject();
                    obj.setAnswers(answer.getText().toString());
                    obj.setQuestion("end_date");
                    mAnswerDynamic.add(obj);
                } else if (mQuestionsDynamic.get(j).compareTo("Job Title") == 0) {
                    QuestionAnswerObject obj = new QuestionAnswerObject();
                    obj.setAnswers(answer.getText().toString());
                    obj.setQuestion("job_title");
                    mAnswerDynamic.add(obj);
                } else if (mQuestionsDynamic.get(j).compareTo("Compay Name") == 0) {
                    QuestionAnswerObject obj = new QuestionAnswerObject();
                    obj.setAnswers(answer.getText().toString());
                    obj.setQuestion("company_name");
                    mAnswerDynamic.add(obj);
                }

            }
            arrayofDynamicQuestions.add(mAnswerDynamic);

        }

        JSONArray cofounders = new JSONArray();

        for (int i = 0; i < arrayofDynamicQuestions.size(); i++) {
            JSONObject obj = new JSONObject();
            for (int j = 0; j < arrayofDynamicQuestions.get(i).size(); j++) {
                try {
                    obj.put(arrayofDynamicQuestions.get(i).get(j).getQuestion(), arrayofDynamicQuestions.get(i).get(j).getAnswers());
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            try {
                cofounders.put(i, obj);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

//        try {
//            questions.put("experience_details", cofounders);
//        } catch (JSONException e) {
//            e.printStackTrace();
//        }
//

        try {

            questionAnswersJsonObject.put("experience_details", cofounders);
        } catch (JSONException e) {
            e.printStackTrace();
        }


        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ADD_EXPERIENCE_TAG, Constants.ADD_EXPERIENCE_URL, Constants.HTTP_POST, questionAnswersJsonObject, "Home Activity");
            a.execute();
        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }

        Log.e("obj", questionAnswersJsonObject.toString());

    }
}
