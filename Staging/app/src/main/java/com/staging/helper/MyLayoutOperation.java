package com.staging.helper;

import android.app.Activity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.fragments.SubmitApplicationFragment;

import java.util.ArrayList;

public class MyLayoutOperation {

    public static void display(final Activity activity, Button btn) {
        btn.setOnClickListener(new OnClickListener() {

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

    public static void add(final Activity activity, ImageView btn) {
        linearLayoutForm = (LinearLayout) activity.findViewById(R.id.linearLayoutForm);


        final LinearLayout newView = (LinearLayout) activity.getLayoutInflater().inflate(R.layout.dynamicquestionere_rowitem, null);

        newView.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));


        questionsLayout = (LinearLayout) newView.findViewById(R.id.questansdynamic);

        for (int i = 0; i < SubmitApplicationFragment.mQuestionsDynamic.size(); i++) {
            final LinearLayout layoutquestions = (LinearLayout) activity.getLayoutInflater().inflate(R.layout.questanswerlayout, null);
            layoutquestions.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
            final TextView question = (TextView) layoutquestions.findViewById(R.id.questionlbl);
            final EditText answers = (EditText) layoutquestions.findViewById(R.id.answer);
            question.setText(SubmitApplicationFragment.mQuestionsDynamic.get(i));
            answers.setText(SubmitApplicationFragment.mAnswersDynamic.get(i));

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

                if (linearLayoutForm.getChildCount() >= 0) {
                    SubmitApplicationFragment.coFounderAdded = true;
                } else {
                    SubmitApplicationFragment.coFounderAdded = false;
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
