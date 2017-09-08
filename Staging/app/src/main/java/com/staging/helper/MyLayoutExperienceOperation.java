package com.staging.helper;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.adapter.KeywordsAdapter;
import com.staging.fragments.AddExperienceFragment;
import com.staging.models.GenericObject;
import com.staging.utilities.Constants;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

/**
 * Created by Sunakshi.Gautam on 12/9/2016.
 */
public class MyLayoutExperienceOperation {

    public static void display(final Activity activity, Button btn) {
        btn.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                LinearLayout scrollViewlinerLayout = (LinearLayout) activity.findViewById(R.id.linearLayoutForm);

                ArrayList<String> msg = new ArrayList<String>();

                for (int i = 0; i < scrollViewlinerLayout.getChildCount(); i++) {
                    LinearLayout innerLayout = (LinearLayout) scrollViewlinerLayout.getChildAt(i);
//					EditText edit = (EditText) innerLayout.findViewById(R.id.editDescricao);
//
//					msg.add(edit.getText().toString());

                }

                Toast t = Toast.makeText(activity.getApplicationContext(), msg.toString(), Toast.LENGTH_LONG);
                t.show();
            }
        });
    }


    public static LinearLayout linearLayoutForm;
    public static LinearLayout questionsLayout;
    public static ArrayList<String> selectedJobRole = new ArrayList<>();

    private static Calendar myCalendar;
    private static DatePickerDialog.OnDateSetListener date;
    private static Calendar myCalendarStartDate;
    private static DatePickerDialog.OnDateSetListener dateStart;
    private static int count = 0;

    public static void add(final Activity activity, ImageView btn) {
        linearLayoutForm = (LinearLayout) activity.findViewById(R.id.linearLayoutForm);


        final LinearLayout newView = (LinearLayout) activity.getLayoutInflater().inflate(R.layout.dynamicquestionere_rowitem, null);

        newView.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));


        questionsLayout = (LinearLayout) newView.findViewById(R.id.questansdynamic);

        for (int i = 0; i < AddExperienceFragment.mQuestionsDynamic.size(); i++) {
            final LinearLayout layoutquestions = (LinearLayout) activity.getLayoutInflater().inflate(R.layout.questanswerlayout, null);
            layoutquestions.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            final TextView question = (TextView) layoutquestions.findViewById(R.id.questionlbl);
            final EditText answers = (EditText) layoutquestions.findViewById(R.id.answer);
            question.setText(AddExperienceFragment.mQuestionsDynamic.get(i));
           if(!AddExperienceFragment.mAnswersDynamic.isEmpty()) {
               answers.setText(AddExperienceFragment.mAnswersDynamic.get(i));
           }
            if (AddExperienceFragment.mQuestionsDynamic.get(i).compareTo("Job Role") == 0) {
                answers.setFocusable(false);
                answers.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        for (int i = 0; i < AddExperienceFragment.jobRole.size(); i++) {
                            Log.d("ischecked", String.valueOf(AddExperienceFragment.jobRole.get(i).ischecked()));
                        }

                        if (AddExperienceFragment.jobRole.size() == 0) {
                            Toast.makeText(activity, "No Keyword available!", Toast.LENGTH_LONG).show();
                        } else {
                            final Dialog dialog = new Dialog(activity);
                            dialog.setContentView(R.layout.keywords_dialog);
                            dialog.setTitle("Job Role Keywords");
                            final EditText search = (EditText) dialog.findViewById(R.id.et_search);
                            final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                            for (int i = 0; i < AddExperienceFragment.jobRole.size(); i++) {
                                tempArray.add(AddExperienceFragment.jobRole.get(i));
                                Log.e("retain", String.valueOf(tempArray.get(i).ischecked()));
                            }
                            final ListView lv = (ListView) dialog.findViewById(R.id.listKeywords);
                            lv.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);

                            final KeywordsAdapter adapterCampaign = new KeywordsAdapter(activity, 0, AddExperienceFragment.jobRole);
                            lv.setAdapter(adapterCampaign);

                            TextView dialogCancelButton = (TextView) dialog.findViewById(R.id.button_cancel);
                            TextView dialogButton = (TextView) dialog.findViewById(R.id.button);

                            search.addTextChangedListener(new TextWatcher() {
                                @Override
                                public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                                }

                                @Override
                                public void onTextChanged(CharSequence s, int start, int before, int count) {
                                    if (adapterCampaign != null) {
                                        adapterCampaign.getFilter().filter(s);
                                    }
                                }

                                @Override
                                public void afterTextChanged(Editable s) {

                                }
                            });
                            dialogCancelButton.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    AddExperienceFragment.jobRole.clear();

                                    for (int i = 0; i < tempArray.size(); i++) {
                                        AddExperienceFragment.jobRole.add(i, tempArray.get(i));
                                    }

                                    StringBuilder selectedKeywordsId = new StringBuilder();
                                    AddExperienceFragment.selectedJobRoleList.clear();
                                    for (int i = 0; i < AddExperienceFragment.jobRole.size(); i++) {
                                        if (AddExperienceFragment.jobRole.get(i).ischecked()) {
                                            AddExperienceFragment.selectedJobRoleList.add(AddExperienceFragment.jobRole.get(i).getId());
                                        }
                                    }

                                    for (int i = 0; i < AddExperienceFragment.selectedJobRoleList.size(); i++) {
                                        if (selectedKeywordsId.length() > 0) {
                                            selectedKeywordsId.append(",");
                                        }
                                        selectedKeywordsId.append(AddExperienceFragment.selectedJobRoleList.get(i));
                                    }
                                    selectedJobRole.add(selectedKeywordsId.toString());
                                    System.out.println(selectedJobRole.toString() + "-------------------------");
                                    tempArray.clear();

                                    dialog.dismiss();
                                }
                            });


                            dialogButton.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {

                                    ArrayList<GenericObject> mArrayProducts = adapterCampaign.getCheckedItems();
                                    for (int i = 0; i < mArrayProducts.size(); i++) {
                                        for (int j = 0; j < AddExperienceFragment.jobRole.size(); j++) {
                                            if (mArrayProducts.get(i).getId().equalsIgnoreCase(AddExperienceFragment.jobRole.get(j).getId())) {
                                                AddExperienceFragment.jobRole.get(j).setIschecked(true);
                                            }
                                        }
                                    }

                                    StringBuilder sb = new StringBuilder();
                                    StringBuilder selectedKeywordID = new StringBuilder();
                                    for (int i = 0; i < mArrayProducts.size(); i++) {
                                        if (sb.length() > 0) {
                                            sb.append(", ");
                                            selectedKeywordID.append(",");
                                        }
                                        sb.append(mArrayProducts.get(i).getTitle());
                                        selectedKeywordID.append(mArrayProducts.get(i).getId());
                                    }

                                    selectedJobRole.add(selectedKeywordID.toString());
                                    answers.setText(sb.toString());
                                    System.out.println(selectedJobRole.toString() + "-------------------------");

                                    dialog.dismiss();
                                }
                            });
                            dialog.show();
                        }
                    }
                });


            }

           else if (AddExperienceFragment.mQuestionsDynamic.get(i).compareTo("Start Date") == 0) {
                answers.setFocusable(false);
                myCalendarStartDate = Calendar.getInstance();
                dateStart = new DatePickerDialog.OnDateSetListener() {

                    @Override
                    public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {

                        myCalendarStartDate.set(Calendar.YEAR, year);
                        myCalendarStartDate.set(Calendar.MONTH, monthOfYear);
                        myCalendarStartDate.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                        try {
                            SimpleDateFormat sdf = new SimpleDateFormat(Constants.DATE_FORMAT, Locale.US);
                            answers.setText(sdf.format(myCalendarStartDate.getTime()));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }

                };

                answers.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        new DatePickerDialog(activity, dateStart, myCalendarStartDate
                                .get(Calendar.YEAR), myCalendar.get(Calendar.MONTH),
                                myCalendarStartDate.get(Calendar.DAY_OF_MONTH)).show();
                    }
                });
            }

            else if (AddExperienceFragment.mQuestionsDynamic.get(i).compareTo("End Date") == 0){
                answers.setFocusable(false);
                myCalendar = Calendar.getInstance();
                date = new DatePickerDialog.OnDateSetListener() {

                    @Override
                    public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {

                        myCalendar.set(Calendar.YEAR, year);
                        myCalendar.set(Calendar.MONTH, monthOfYear);
                        myCalendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                        try {
                            SimpleDateFormat sdf = new SimpleDateFormat(Constants.DATE_FORMAT, Locale.US);
                            answers.setText(sdf.format(myCalendar.getTime()));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }

                };

                answers.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        new DatePickerDialog(activity, date, myCalendar
                                .get(Calendar.YEAR), myCalendar.get(Calendar.MONTH),
                                myCalendar.get(Calendar.DAY_OF_MONTH)).show();
                    }
                });
            }
            questionsLayout.addView(layoutquestions);
            count++;
        }


        final ImageView btnRemove = (ImageView) newView.findViewById(R.id.btnRemove);
        final ImageView btnAdd = (ImageView) newView.findViewById(R.id.btnadd);
        btnAdd.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                add(activity, btnAdd);


            }
        });
        btnRemove.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                linearLayoutForm.removeView(newView);

                if (linearLayoutForm.getChildCount() >= 0) {
                    AddExperienceFragment.coFounderAdded = true;
                } else {
                    AddExperienceFragment.coFounderAdded = false;
                }

            }
        });

        linearLayoutForm.addView(newView);
        /*btn.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                final LinearLayout newView = (LinearLayout) activity.getLayoutInflater().inflate(R.layout.dynamicquestionere_rowitem, null);

                newView.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));


                questionsLayout = (LinearLayout) newView.findViewById(R.id.questansdynamic);

                for (int i = 0; i < SubmitApplicationFragment.mQuestionsDynamic.size(); i++) {
                    final LinearLayout layoutquestions = (LinearLayout) activity.getLayoutInflater().inflate(R.layout.questanswerlayout, null);
                    layoutquestions.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
                    final TextView question = (TextView) layoutquestions.findViewById(R.id.questionlbl);
                    question.setText(SubmitApplicationFragment.mQuestionsDynamic.get(i));

                    questionsLayout.addView(layoutquestions);
                }


                final ImageView btnRemove = (ImageView) newView.findViewById(R.id.btnRemove);
                final ImageView btnAdd = (ImageView) newView.findViewById(R.id.btnadd);
                btnAdd.setOnClickListener(new OnClickListener() {

                    @Override
                    public void onClick(View v) {

                        add(activity, btnAdd);


                    }
                });
                btnRemove.setOnClickListener(new OnClickListener() {

                    @Override
                    public void onClick(View v) {

                        linearLayoutForm.removeView(newView);

                        if (linearLayoutForm.getChildCount() > 0) {
                            SubmitApplicationFragment.coFounderAdded = true;
                        } else {
                            SubmitApplicationFragment.coFounderAdded = true;
                        }

                    }
                });

                linearLayoutForm.addView(newView);
            }
        });*/
    }

}
