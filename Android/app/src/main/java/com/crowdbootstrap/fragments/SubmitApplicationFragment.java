package com.crowdbootstrap.fragments;

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
import android.widget.TextView;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.helper.MyLayoutOperation;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.models.QuestionAnswerObject;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;

/**
 * Created by sunakshi.gautam on 1/28/2016.
 */
public class SubmitApplicationFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    private JSONObject questionAnswersJsonObject;
    private JSONObject questions;
    private TextView noticeMessage;

    public static ArrayList<String> mQuestionsDynamic;
    public static ArrayList<String> mQuestionsStaticAbove;
    public static ArrayList<String> mQuestionsStaticBelow;
    public static ArrayList<String> mQuestionsStaticBelowSectionA;
    public static ArrayList<String> mQuestionsStaticBelowSectionB;
    public static ArrayList<String> mQuestionsStaticBelowSectionC;
    public static ArrayList<String> mQuestionsStaticBelowSectionD;

    public ArrayList<QuestionAnswerObject> mAnswerDynamic;


    public static ArrayList<String> mAnswersDynamic;
    public static ArrayList<String> mAnswerStaticAbove;
    public static ArrayList<String> mAnswerStaticBelow;
    public static ArrayList<String> mAnswerStaticBelowSectionA;
    public static ArrayList<String> mAnswerStaticBelowSectionB;
    public static ArrayList<String> mAnswerStaticBelowSectionC;
    public static ArrayList<String> mAnswerStaticBelowSectionD;


    private LinearLayout questionsLayoutSectionA;
    private LinearLayout questionsLayoutSectionB;
    private LinearLayout questionsLayoutSectionC;
    private LinearLayout questionsLayoutSectionD;
    private LinearLayout questionsLayoutSectionE;
    private LinearLayout questionsLayoutSectionF;


    private Button btnSubmit, btnSave;
    private ImageView add;
    private String STARTUP_ID;
    public static boolean coFounderAdded = false;

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_submitapplication, container, false);


        add = (ImageView) rootView.findViewById(R.id.add);
        btnSubmit = (Button) rootView.findViewById(R.id.submitquestionnair);
        btnSave = (Button) rootView.findViewById(R.id.savequestionnair);
        btnSave.setOnClickListener(this);
        btnSubmit.setOnClickListener(this);
        add.setOnClickListener(this);
        noticeMessage = (TextView) rootView.findViewById(R.id.noticemessage);


        mQuestionsDynamic = new ArrayList<String>();
        mAnswersDynamic = new ArrayList<String>();

        mQuestionsDynamic.add("Name");
        mQuestionsDynamic.add("Age");
        mQuestionsDynamic.add("University Degree");
        mQuestionsDynamic.add("Subject");
        mQuestionsDynamic.add("Facebook/Twitter");
        mQuestionsDynamic.add("Last Employed Job Title");
        mQuestionsDynamic.add("How did you meet?");
        mQuestionsDynamic.add("Have you worked together before?");
        mQuestionsDynamic.add("How long have you known each other?");
        mQuestionsDynamic.add("What is exceptional about your team?");
        mQuestionsDynamic.add("What are the three most significant achievements of any member of your team?");
        mQuestionsDynamic.add("Does your team have any conflicts of interest or restrictions that impact the startup?");
        mQuestionsDynamic.add("How is your equity distributed?");


        mQuestionsStaticAbove = new ArrayList<String>();
        mAnswerStaticAbove = new ArrayList<String>();
//        mQuestionsStaticAbove.add("Company Name");
//        mQuestionsStaticAbove.add("Your Name");
//        mQuestionsStaticAbove.add("Email Address");
//        mQuestionsStaticAbove.add("Phone Number");
//        mQuestionsStaticAbove.add("Company City");
//        mQuestionsStaticAbove.add("Company Country");
//        mQuestionsStaticAbove.add("Current Stage of Startup");
//        mQuestionsStaticAbove.add("Start Date of Startup");
//        mQuestionsStaticAbove.add("Is the Startup incorporated?");
//        mQuestionsStaticAbove.add("Have you participated in any incubator, \"accelerator\" or \"pre-accelerator\" program?");


        mQuestionsStaticBelow = new ArrayList<String>();
        mAnswerStaticBelow = new ArrayList<>();
//        mQuestionsStaticBelow.add("Provide a brief description of your company's Products and Services");
//        mQuestionsStaticBelow.add("How do you make money?");
//        mQuestionsStaticBelow.add("Who are your target customers?");
//        mQuestionsStaticBelow.add("What do your target customers do today to meet their needs?");
//        mQuestionsStaticBelow.add("What is significantly different about your solution?");
//        mQuestionsStaticBelow.add("How do you know that customers want your solution?");
//        mQuestionsStaticBelow.add("Who are your competitors?");
//        mQuestionsStaticBelow.add("Why will your competitors allow you to win marketshare?");
//        mQuestionsStaticBelow.add("What is your market entry strategy?");
//        mQuestionsStaticBelow.add("Why did you choose this opportunity?");
//        mQuestionsStaticBelow.add("What is your experience and your team's experience in this area?");


        mQuestionsStaticBelowSectionA = new ArrayList<String>();
        mAnswerStaticBelowSectionA = new ArrayList<>();
//        mQuestionsStaticBelowSectionA.add("How many users do you have?");
//        mQuestionsStaticBelowSectionA.add("What is you monthly revenue?");
//        mQuestionsStaticBelowSectionA.add("What is your monthly growth rate?");


        mQuestionsStaticBelowSectionB = new ArrayList<String>();
        mAnswerStaticBelowSectionB = new ArrayList<>();
//        mQuestionsStaticBelowSectionB.add("What prior investments have you received?");
//        mQuestionsStaticBelowSectionB.add("If you plan to raise funds, how much will you seek and what will you offer?");
//        mQuestionsStaticBelowSectionB.add("How will you become a huge company?");


        mQuestionsStaticBelowSectionC = new ArrayList<String>();
        mAnswerStaticBelowSectionC = new ArrayList<>();
//        mQuestionsStaticBelowSectionC.add("Company Website");
//        mQuestionsStaticBelowSectionC.add("Company Video URL (hidden URL on Youtube is OK)");
//        mQuestionsStaticBelowSectionC.add("Video of Co Founders URL (hidden URL on Youtube is OK)");

        mQuestionsStaticBelowSectionD = new ArrayList<String>();
        mAnswerStaticBelowSectionD = new ArrayList<>();
//        mQuestionsStaticBelowSectionD.add("Anything else you should declare (law suits, financial issues, performance problems, compliance issues)");


        questionsLayoutSectionA = (LinearLayout) rootView.findViewById(R.id.sectionA);
        questionsLayoutSectionB = (LinearLayout) rootView.findViewById(R.id.sectionc);
        questionsLayoutSectionC = (LinearLayout) rootView.findViewById(R.id.sectionD);
        questionsLayoutSectionD = (LinearLayout) rootView.findViewById(R.id.sectionE);
        questionsLayoutSectionE = (LinearLayout) rootView.findViewById(R.id.sectionF);
        questionsLayoutSectionF = (LinearLayout) rootView.findViewById(R.id.sectionG);

        STARTUP_ID = getArguments().getString("id");
        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_SAVED_QUESTIONS_TAG, Constants.STARTUP_SAVED_QUESTIONS_URL + "?startup_id=" + STARTUP_ID+ "&user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
            a.execute();
        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }

        // init();


        return rootView;
    }


    private void init() {

        for (int i = 0; i < mQuestionsStaticAbove.size(); i++) {
            final LinearLayout layoutquestions = (LinearLayout) getActivity().getLayoutInflater().inflate(R.layout.questanswerlayout, null);
            layoutquestions.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            final TextView question = (TextView) layoutquestions.findViewById(R.id.questionlbl);
            final EditText answer = (EditText) layoutquestions.findViewById(R.id.answer);
            question.setText(mQuestionsStaticAbove.get(i));
            answer.setText(mAnswerStaticAbove.get(i));

            questionsLayoutSectionA.addView(layoutquestions);
        }


        for (int i = 0; i < mQuestionsStaticBelow.size(); i++) {
            final LinearLayout layoutquestions1 = (LinearLayout) getActivity().getLayoutInflater().inflate(R.layout.questanswerlayout, null);
            layoutquestions1.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            final TextView question = (TextView) layoutquestions1.findViewById(R.id.questionlbl);
            final EditText answer = (EditText) layoutquestions1.findViewById(R.id.answer);
            question.setText(mQuestionsStaticBelow.get(i));
            answer.setText(mAnswerStaticBelow.get(i));

            questionsLayoutSectionB.addView(layoutquestions1);
        }


        for (int i = 0; i < mQuestionsStaticBelowSectionA.size(); i++) {
            final LinearLayout layoutquestions2 = (LinearLayout) getActivity().getLayoutInflater().inflate(R.layout.questanswerlayout, null);
            layoutquestions2.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            final TextView question = (TextView) layoutquestions2.findViewById(R.id.questionlbl);
            final EditText answer = (EditText) layoutquestions2.findViewById(R.id.answer);
            question.setText(mQuestionsStaticBelowSectionA.get(i));
            answer.setText(mAnswerStaticBelowSectionA.get(i));

            questionsLayoutSectionC.addView(layoutquestions2);
        }
        for (int i = 0; i < mQuestionsStaticBelowSectionB.size(); i++) {
            final LinearLayout layoutquestions3 = (LinearLayout) getActivity().getLayoutInflater().inflate(R.layout.questanswerlayout, null);
            layoutquestions3.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            final TextView question = (TextView) layoutquestions3.findViewById(R.id.questionlbl);
            final EditText answer = (EditText) layoutquestions3.findViewById(R.id.answer);
            question.setText(mQuestionsStaticBelowSectionB.get(i));
            answer.setText(mAnswerStaticBelowSectionB.get(i));

            questionsLayoutSectionD.addView(layoutquestions3);
        }


        for (int i = 0; i < mQuestionsStaticBelowSectionC.size(); i++) {
            final LinearLayout layoutquestions4 = (LinearLayout) getActivity().getLayoutInflater().inflate(R.layout.questanswerlayout, null);
            layoutquestions4.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            final TextView question = (TextView) layoutquestions4.findViewById(R.id.questionlbl);
            final EditText answer = (EditText) layoutquestions4.findViewById(R.id.answer);
            question.setText(mQuestionsStaticBelowSectionC.get(i));
            answer.setText(mAnswerStaticBelowSectionC.get(i));

            questionsLayoutSectionE.addView(layoutquestions4);
        }
        for (int i = 0; i < mQuestionsStaticBelowSectionD.size(); i++) {
            final LinearLayout layoutquestions5 = (LinearLayout) getActivity().getLayoutInflater().inflate(R.layout.questanswerlayout, null);
            layoutquestions5.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            final TextView question = (TextView) layoutquestions5.findViewById(R.id.questionlbl);
            final EditText answer = (EditText) layoutquestions5.findViewById(R.id.answer);
            question.setText(mQuestionsStaticBelowSectionD.get(i));
            answer.setText(mAnswerStaticBelowSectionD.get(i));

            questionsLayoutSectionF.addView(layoutquestions5);
        }

    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {

            case R.id.add:
                coFounderAdded = true;
                MyLayoutOperation.add(getActivity(), add);
                break;

            case R.id.submitquestionnair:
                questionAnswersJsonObject = new JSONObject();
                questions = new JSONObject();

                try {
                    questionAnswersJsonObject.put("startup_id",STARTUP_ID);
                    questionAnswersJsonObject.put("is_submited", "1");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                if (coFounderAdded == true) {
                    fetchDynamicAnswers();
                } else {
                    fetchAnswers();
                }

//                Log.e("xxx", mAnswerStaticAbove.get(0).toString());
                //    getActivity().onBackPressed();
                break;
            case R.id.savequestionnair:
                questionAnswersJsonObject = new JSONObject();
                questions = new JSONObject();

                try {
                    questionAnswersJsonObject.put("startup_id",STARTUP_ID);
                    questionAnswersJsonObject.put("is_submited", "0");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                if (coFounderAdded == true) {
                    fetchDynamicAnswers();
                } else {
                    fetchAnswers();
                }
                break;

        }

    }

    private ArrayList<ArrayList<QuestionAnswerObject>> arrayofDynamicQuestions;



    private void fetchDynamicAnswers() {
        arrayofDynamicQuestions = new ArrayList<ArrayList<QuestionAnswerObject>>();

        for (int i = 0; i < MyLayoutOperation.linearLayoutForm.getChildCount(); i++) {
            mAnswerDynamic = new ArrayList<QuestionAnswerObject>();
            for (int j = 0; j < MyLayoutOperation.questionsLayout.getChildCount(); j++) {
                LinearLayout coFounderitem = (LinearLayout) MyLayoutOperation.questionsLayout.getChildAt(j);
                final LinearLayout layoutquestions = (LinearLayout) getActivity().getLayoutInflater().inflate(R.layout.questanswerlayout, null);
                layoutquestions.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));


                EditText answer = (EditText) ((LinearLayout) coFounderitem).findViewById(R.id.answer);
                QuestionAnswerObject obj = new QuestionAnswerObject();
                obj.setAnswers(answer.getText().toString());
                obj.setQuestion(mQuestionsDynamic.get(j));
                mAnswerDynamic.add(obj);


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

        try {
            questions.put("cofounders", cofounders);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        fetchAnswers();
    }

    private void fetchAnswers() {
       /* mAnswerStaticAbove = new ArrayList<String>();
        mAnswerStaticBelow = new ArrayList<String>();
        mAnswerStaticBelowSectionA = new ArrayList<String>();
        mAnswerStaticBelowSectionB = new ArrayList<String>();
        mAnswerStaticBelowSectionC = new ArrayList<String>();
        mAnswerStaticBelowSectionD = new ArrayList<String>();
        mAnswer = new ArrayList<QuestionAnswerObject>();*/

        JSONObject above = new JSONObject();
        for (int i = 0; i < questionsLayoutSectionA.getChildCount(); i++) {
            final LinearLayout layoutquestions = (LinearLayout) getActivity().getLayoutInflater().inflate(R.layout.questanswerlayout, null);
            layoutquestions.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            EditText answer = (EditText) ((LinearLayout) questionsLayoutSectionA.getChildAt(i)).findViewById(R.id.answer);

            QuestionAnswerObject obj = new QuestionAnswerObject();
            obj.setAnswers(answer.getText().toString());
            obj.setQuestion(mQuestionsStaticAbove.get(i));

            //mAnswer.add(obj);
            //mAnswerStaticAbove.add(answer.getText().toString());


            try {
                above.put(obj.getQuestion(), obj.getAnswers());
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        try {
            questions.put("above", above);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JSONObject below = new JSONObject();
        for (int i = 0; i < questionsLayoutSectionB.getChildCount(); i++) {
            final LinearLayout layoutquestions1 = (LinearLayout) getActivity().getLayoutInflater().inflate(R.layout.questanswerlayout, null);
            layoutquestions1.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            EditText answer = (EditText) ((LinearLayout) questionsLayoutSectionB.getChildAt(i)).findViewById(R.id.answer);

            QuestionAnswerObject obj = new QuestionAnswerObject();
            obj.setAnswers(answer.getText().toString());
            obj.setQuestion(mQuestionsStaticBelow.get(i));

            // mAnswer.add(obj);


            //mAnswerStaticBelow.add(answer.getText().toString());
            try {
                below.put(obj.getQuestion(), obj.getAnswers());
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        try {
            questions.put("below", below);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JSONObject belowA = new JSONObject();
        for (int i = 0; i < questionsLayoutSectionC.getChildCount(); i++) {
            final LinearLayout layoutquestions2 = (LinearLayout) getActivity().getLayoutInflater().inflate(R.layout.questanswerlayout, null);
            layoutquestions2.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            EditText answer = (EditText) ((LinearLayout) questionsLayoutSectionC.getChildAt(i)).findViewById(R.id.answer);

            QuestionAnswerObject obj = new QuestionAnswerObject();
            obj.setAnswers(answer.getText().toString());
            obj.setQuestion(mQuestionsStaticBelowSectionA.get(i));


            try {
                belowA.put(obj.getQuestion(), obj.getAnswers());
            } catch (JSONException e) {
                e.printStackTrace();
            }

            //mAnswer.add(obj);

            //mAnswerStaticBelowSectionA.add(answer.getText().toString());
        }

        try {
            questions.put("belowA", belowA);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JSONObject belowB = new JSONObject();
        for (int i = 0; i < questionsLayoutSectionD.getChildCount(); i++) {
            final LinearLayout layoutquestions3 = (LinearLayout) getActivity().getLayoutInflater().inflate(R.layout.questanswerlayout, null);
            layoutquestions3.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            EditText answer = (EditText) ((LinearLayout) questionsLayoutSectionD.getChildAt(i)).findViewById(R.id.answer);

            QuestionAnswerObject obj = new QuestionAnswerObject();
            obj.setAnswers(answer.getText().toString());
            obj.setQuestion(mQuestionsStaticBelowSectionB.get(i));

            //mAnswer.add(obj);

            //mAnswerStaticBelowSectionB.add(answer.getText().toString());
            try {
                belowB.put(obj.getQuestion(), obj.getAnswers());
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        try {
            questions.put("belowB", belowB);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JSONObject belowC = new JSONObject();
        for (int i = 0; i < questionsLayoutSectionE.getChildCount(); i++) {
            final LinearLayout layoutquestions4 = (LinearLayout) getActivity().getLayoutInflater().inflate(R.layout.questanswerlayout, null);
            layoutquestions4.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            EditText answer = (EditText) ((LinearLayout) questionsLayoutSectionE.getChildAt(i)).findViewById(R.id.answer);

            QuestionAnswerObject obj = new QuestionAnswerObject();
            obj.setAnswers(answer.getText().toString());
            obj.setQuestion(mQuestionsStaticBelowSectionC.get(i));

            try {
                belowC.put(obj.getQuestion(), obj.getAnswers());
            } catch (JSONException e) {
                e.printStackTrace();
            }
            // mAnswer.add(obj);

            //mAnswerStaticBelowSectionC.add(answer.getText().toString());
        }

        try {
            questions.put("belowC", belowC);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JSONObject belowD = new JSONObject();
        for (int i = 0; i < questionsLayoutSectionF.getChildCount(); i++) {
            final LinearLayout layoutquestions5 = (LinearLayout) getActivity().getLayoutInflater().inflate(R.layout.questanswerlayout, null);
            layoutquestions5.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            EditText answer = (EditText) ((LinearLayout) questionsLayoutSectionF.getChildAt(i)).findViewById(R.id.answer);

            QuestionAnswerObject obj = new QuestionAnswerObject();
            obj.setAnswers(answer.getText().toString());
            obj.setQuestion(mQuestionsStaticBelowSectionD.get(i));

            try {
                belowD.put(obj.getQuestion(), obj.getAnswers());
            } catch (JSONException e) {
                e.printStackTrace();
            }
            // mAnswer.add(obj);

            //mAnswerStaticBelowSectionC.add(answer.getText().toString());
        }

        try {
            questions.put("belowD", belowD);
            questionAnswersJsonObject.put("questions", questions);
        } catch (JSONException e) {
            e.printStackTrace();
        }


        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_QUESTIONS_TAG, Constants.STARTUP_QUESTIONS_URL, Constants.HTTP_POST, questionAnswersJsonObject,"Home Activity");
            a.execute();
        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }

        Log.e("obj", questionAnswersJsonObject.toString());
    }

    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else if (tag.equalsIgnoreCase(Constants.STARTUP_SAVED_QUESTIONS_TAG)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            try {
                JSONObject jsonObject = new JSONObject(result);
                System.out.println(jsonObject);
                if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                    JSONObject questionObject = jsonObject.getJSONObject("questions");

                    JSONObject aboveObject = questionObject.optJSONObject("above");
                    JSONObject belowObject = questionObject.optJSONObject("below");
                    JSONObject belowAObject = questionObject.optJSONObject("belowA");
                    JSONObject belowBObject = questionObject.optJSONObject("belowB");
                    JSONObject belowCObject = questionObject.optJSONObject("belowC");
                    JSONObject belowDObject = questionObject.optJSONObject("belowD");
                    Integer isSubmitted = jsonObject.optInt("is_submited");
                    if(isSubmitted == 0){
                        noticeMessage.setVisibility(View.GONE);
                    }
                    else{
                        noticeMessage.setVisibility(View.VISIBLE);
                        noticeMessage.setText("You have Submitted your Application to the Admin for Approval.");
                    }


                    Iterator<String> keys = aboveObject.keys();
                    Iterator<String> keysBelow = belowObject.keys();
                    Iterator<String> keysBelowA = belowAObject.keys();
                    Iterator<String> keysBelowB = belowBObject.keys();
                    Iterator<String> keysBelowC = belowCObject.keys();
                    Iterator<String> keysBelowD = belowDObject.keys();


                    while (keys.hasNext()) {
                        // Get the key
                        String key = keys.next();
                        mQuestionsStaticAbove.add(key);
                        // Get the value
                        // JSONObject value = aboveObject.getJSONObject(key);
                        mAnswerStaticAbove.add(aboveObject.optString(key));

                    }

                    while (keysBelow.hasNext()) {
                        // Get the key
                        String key = keysBelow.next();
                        mQuestionsStaticBelow.add(key);
                        // Get the value
                        // JSONObject value = aboveObject.getJSONObject(key);
                        mAnswerStaticBelow.add(belowObject.optString(key));

                    }
                    while (keysBelowA.hasNext()) {
                        // Get the key
                        String key = keysBelowA.next();
                        mQuestionsStaticBelowSectionA.add(key);
                        // Get the value
                        // JSONObject value = aboveObject.getJSONObject(key);
                        mAnswerStaticBelowSectionA.add(belowAObject.optString(key));

                    }
                    while (keysBelowB.hasNext()) {
                        // Get the key
                        String key = keysBelowB.next();
                        mQuestionsStaticBelowSectionB.add(key);
                        mAnswerStaticBelowSectionB.add(belowBObject.optString(key));
                        // Get the value
                        // JSONObject value = aboveObject.getJSONObject(key);

                    }
                    while (keysBelowC.hasNext()) {
                        // Get the key
                        String key = keysBelowC.next();
                        mQuestionsStaticBelowSectionC.add(key);
                        mAnswerStaticBelowSectionC.add(belowCObject.optString(key));
                        // Get the value
                        // JSONObject value = aboveObject.getJSONObject(key);

                    }

                    while (keysBelowD.hasNext()) {
                        // Get the key
                        String key = keysBelowD.next();
                        mQuestionsStaticBelowSectionD.add(key);
                        mAnswerStaticBelowSectionD.add(belowDObject.optString(key));
                        // Get the value
                        // JSONObject value = aboveObject.getJSONObject(key);

                    }
                    if (questionObject.optJSONArray("cofounders").length()!=0) {

                        for (int i = 0; i < questionObject.optJSONArray("cofounders").length(); i++) {
                        mQuestionsDynamic.clear();
                        mAnswersDynamic.clear();
                            coFounderAdded = true;
                        JSONObject CofounderObject = questionObject.optJSONArray("cofounders").getJSONObject(i);
                        Iterator<String> keysCofunder = CofounderObject.keys();
                        while (keysCofunder.hasNext()) {
                            // Get the key
                            String key = keysCofunder.next();
                            mQuestionsDynamic.add(key);
                            // Get the value
                            // JSONObject value = aboveObject.getJSONObject(key);
                            mAnswersDynamic.add(CofounderObject.optString(key));

                        }
                            MyLayoutOperation.add(getActivity(), add);
                        }
                    }
                    init();
                } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                    Toast.makeText(getActivity(), "", Toast.LENGTH_LONG).show();
                }
            } catch (Exception e) {
                Log.e("ERROR", e.getMessage());
            }
        } else {
            if (tag.equalsIgnoreCase(Constants.STARTUP_QUESTIONS_TAG)) {
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
    }
}
