package com.staging.fragments.consultingModule;

import android.Manifest;
import android.animation.ValueAnimator;
import android.app.Activity;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.Window;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.vision.text.Line;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.filebrowser.FilePicker;
import com.staging.fragments.WebViewFragment;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.listeners.onActivityResultListener;
import com.staging.logger.CrowdBootstrapLogger;
import com.staging.models.AudioObject;
import com.staging.models.Mediabeans;
import com.staging.utilities.AndroidMultipartEntity;
import com.staging.utilities.AsyncNew;
import com.staging.utilities.Constants;
import com.staging.utilities.UtilitiesClass;

import org.apache.http.entity.mime.content.ContentBody;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.UnknownHostException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by Neelmani.Karn on 1/11/2017.
 */
public class ConsultingDetailsFragment extends Fragment implements onActivityResultListener, View.OnClickListener, AsyncTaskCompleteListener<String> {

    private LinearLayout commitLayout;
    private TextView tv_comittCounter;
    private Button apply, invite;

    private AudioObject docObject, audioObject, videoObject, questionObject, finalbidObject;
    private LinearLayout layoutFundPostedBy;
    private String calledFragment;
    private Bundle bundle;
    private String fund_id;
    private TextView cbx_Follow, cbx_Like;
    private EditText et_postedBy, et_title, et_description, et_start_date, et_endDate, et_targetMarket, et_keywords, et_interestKeywords/*, et_investmentEndDate, et_fundsClosedDate, et_keywords*/;
    private ImageView image_roadmap;


    private ImageView viewDocumentArrow, viewplayAudioArrow, viewplayVideoArrow;
    private LinearLayout btn_playAudio, btn_viewDocument, btn_playVideo;
    private LinearLayout expandable_playAudio, expandable_viewDocument, expandable_playVideo;
    private TextView startDateTV, endDateTV, titleTV, descriptionlbl, keywordTV;

    private ValueAnimator mAnimatorForDoc, mAnimatorForAudio, mAnimatorForVideo, mAnimatorForQuestions, mAnimatorForFinalbid;
    private TextView list_audios, list_docs, list_video;


    //Layouts to be made visible
    private TextView conditionsTV, assignment_startdateTV, assignment_enddateTV, bids_daadlinedateTV, questions_deadlinedateTV, answers_deadlinedateTV, projectoverview_deadlinedateTV, bidderpresentation_dedlinedateTV, commitintentbid_deadlinedateTV, answers_targetdateTV, proposal_deadlinedateTV, awardproject_targetdateTV, startproject_dateTV, completeproject_targetdateTV;
    private EditText et_conditions, et_assignment_startdate, et_bids_deadlinedate, et_questions_dedlinedate, et_projectoverview_deadlinedate, et_bidderpresentation_deadlinedate, et_commitintentbid_deadlinedate, et_answers_targetdate, et_proposal_deadlinedate, et_awardproject_targetdate, et_startproject_date, et_completeproject_targetdate;
    private LinearLayout consultingLayout, getExpandable_question, getExpandable_finalbid, parentQuestionLayout, parentFinalbidLayout, btn_playQuestions, btn_playFinalbid;
    private ImageView viewQuestionArrow, viewFinalbidArrow;
    private TextView list_questions, list_finalbids, targetMarketTV;


    public ConsultingDetailsFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        ((HomeActivity) getActivity()).setOnActivityResultListener(this);
    }

    /**
     * Called to do initial creation of a fragment.  This is called after
     * {@link #onAttach(Activity)} and before
     * {@link #onCreateView(LayoutInflater, ViewGroup, Bundle)}.
     * <p>
     * <p>Note that this can be called while the fragment's activity is
     * still in the process of being created.  As such, you can not rely
     * on things like the activity's content view hierarchy being initialized
     * at this point.  If you want to do work once the activity itself is
     * created, see {@link #onActivityCreated(Bundle)}.
     *
     * @param savedInstanceState If the fragment is being re-created from
     *                           a previous saved state, this is the state.
     */
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        /*audioObjectsList = new ArrayList<>();
        videoObjectList = new ArrayList<>();
        documentObjectList = new ArrayList<>();*/
       /* audioObject = new AudioObject();
        videoObject = new AudioObject();
        docObject = new AudioObject();*/
        bundle = this.getArguments();
        if (bundle != null) {
            fund_id = bundle.getString(Constants.FUND_ID);
            calledFragment = bundle.getString(Constants.CALLED_FROM);
        }
    }

    ArrayList<TextView> filenames;
    private LinearLayout layout;
    private LinearLayout parent_layout;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.boardmember_detail_fragment, container, false);

        tv_comittCounter = (TextView) rootView.findViewById(R.id.tv_comittCounter);
        commitLayout = (LinearLayout) rootView.findViewById(R.id.commitLayout);
        image_roadmap = (ImageView) rootView.findViewById(R.id.image_roadmap);
        layoutFundPostedBy = (LinearLayout) rootView.findViewById(R.id.layoutFundPostedBy);
        titleTV = (TextView) rootView.findViewById(R.id.namelbl);
        descriptionlbl = (TextView) rootView.findViewById(R.id.descriptionlbl);
        filenames = new ArrayList<TextView>();

        layout = (LinearLayout) rootView.findViewById(R.id.layout);
        parent_layout = (LinearLayout) rootView.findViewById(R.id.parent_layout);
        startDateTV = (TextView) rootView.findViewById(R.id.tv_startDate);
        endDateTV = (TextView) rootView.findViewById(R.id.tv_endDate);
        keywordTV = (TextView) rootView.findViewById(R.id.keywordTitle);


        keywordTV.setText("Target user keywords");
        startDateTV.setText("Date to distribute project requirement");
        endDateTV.setText("Deadline for commitment to bid");
        titleTV.setText("Consulting Project Title");
        descriptionlbl.setText("Project Overview");


        // Layouts to be made visible in consulting
        conditionsTV = (TextView) rootView.findViewById(R.id.conditionlbl);
        et_conditions = (EditText) rootView.findViewById(R.id.et_condition);
        consultingLayout = (LinearLayout) rootView.findViewById(R.id.consultinbgfieldslayout);
        parentQuestionLayout = (LinearLayout) rootView.findViewById(R.id.parent_questions_layout);
        parentFinalbidLayout = (LinearLayout) rootView.findViewById(R.id.parent_finalbid_layout);
        getExpandable_finalbid = (LinearLayout) rootView.findViewById(R.id.expandable_playFinalbid);
        getExpandable_question = (LinearLayout) rootView.findViewById(R.id.expandable_playQuestions);
        viewQuestionArrow = (ImageView) rootView.findViewById(R.id.viewplayQuestionsArrow);
        viewFinalbidArrow = (ImageView) rootView.findViewById(R.id.viewplayFinalbidArrow);
        list_questions = (TextView) rootView.findViewById(R.id.list_Questions);
        list_finalbids = (TextView) rootView.findViewById(R.id.list_Finalbid);
        btn_playFinalbid = (LinearLayout) rootView.findViewById(R.id.btn_playFinalbid);
        btn_playQuestions = (LinearLayout) rootView.findViewById(R.id.btn_playQuestions);
        invite = (Button) rootView.findViewById(R.id.invite);

        et_assignment_startdate = (EditText) rootView.findViewById(R.id.et_asignment_startdatetime);

        et_bids_deadlinedate = (EditText) rootView.findViewById(R.id.et_deadline_datetime_bids);
        et_questions_dedlinedate = (EditText) rootView.findViewById(R.id.et_deadline_datetime_questions);
        et_projectoverview_deadlinedate = (EditText) rootView.findViewById(R.id.et_deadline_datetime_projectoverview);
        et_bidderpresentation_deadlinedate = (EditText) rootView.findViewById(R.id.et_deadline_datetime_bidderpresentation);
        et_commitintentbid_deadlinedate = (EditText) rootView.findViewById(R.id.et_deadline_datetime_commitintentbid);
        et_answers_targetdate = (EditText) rootView.findViewById(R.id.et_targetdate_foranswers);
        et_proposal_deadlinedate = (EditText) rootView.findViewById(R.id.et_deadlinedate_proposals);
        et_awardproject_targetdate = (EditText) rootView.findViewById(R.id.et_targetdate_awardproject);
        et_startproject_date = (EditText) rootView.findViewById(R.id.et_targetdate_startproject);
        et_completeproject_targetdate = (EditText) rootView.findViewById(R.id.et_targetdate_completeproject);
        et_endDate = (EditText) rootView.findViewById(R.id.et_endDate);
        et_start_date = (EditText) rootView.findViewById(R.id.et_start_date);

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        // Set the Visibility of the Views

        conditionsTV.setVisibility(View.VISIBLE);
        et_conditions.setVisibility(View.VISIBLE);
        consultingLayout.setVisibility(View.VISIBLE);
        parentQuestionLayout.setVisibility(View.VISIBLE);
        parentFinalbidLayout.setVisibility(View.VISIBLE);
        invite.setVisibility(View.VISIBLE);
        startDateTV.setVisibility(View.GONE);
        endDateTV.setVisibility(View.GONE);
        et_start_date.setVisibility(View.GONE);
        et_endDate.setVisibility(View.GONE);


        //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


        apply = (Button) rootView.findViewById(R.id.apply);
        if (calledFragment.equals(Constants.FIND_FUND_TAG)) {
            layoutFundPostedBy.setVisibility(View.VISIBLE);
            apply.setVisibility(View.VISIBLE);
        } else {
            layoutFundPostedBy.setVisibility(View.GONE);
            apply.setVisibility(View.GONE);
        }
        list_audios = (TextView) rootView.findViewById(R.id.list_audios);
        list_docs = (TextView) rootView.findViewById(R.id.list_docs);
        list_video = (TextView) rootView.findViewById(R.id.list_video);
        cbx_Follow = (TextView) rootView.findViewById(R.id.cbx_Follow);
        cbx_Like = (TextView) rootView.findViewById(R.id.cbx_Like);


        et_postedBy = (EditText) rootView.findViewById(R.id.et_postedBy);
        et_title = (EditText) rootView.findViewById(R.id.et_title);
        et_description = (EditText) rootView.findViewById(R.id.et_description);
        et_targetMarket = (EditText) rootView.findViewById(R.id.et_targetMarket);
        et_keywords = (EditText) rootView.findViewById(R.id.et_keywords);
        et_interestKeywords = (EditText) rootView.findViewById(R.id.et_interestKeywords);

        targetMarketTV = (TextView) rootView.findViewById(R.id.tv_targetmarket);

        et_targetMarket.setVisibility(View.GONE);
        targetMarketTV.setVisibility(View.GONE);


        expandable_playAudio = (LinearLayout) rootView.findViewById(R.id.expandable_playAudio);
        expandable_playVideo = (LinearLayout) rootView.findViewById(R.id.expandable_playVideo);
        expandable_viewDocument = (LinearLayout) rootView.findViewById(R.id.expandable_viewDocument);

        btn_playAudio = (LinearLayout) rootView.findViewById(R.id.btn_playAudio);
        btn_playVideo = (LinearLayout) rootView.findViewById(R.id.btn_playVideo);
        btn_viewDocument = (LinearLayout) rootView.findViewById(R.id.btn_viewDocument);

        viewDocumentArrow = (ImageView) rootView.findViewById(R.id.viewDocumentArrow);
        viewplayAudioArrow = (ImageView) rootView.findViewById(R.id.viewplayAudioArrow);
        viewplayVideoArrow = (ImageView) rootView.findViewById(R.id.viewplayVideoArrow);

        commitLayout.setOnClickListener(this);
        apply.setOnClickListener(this);
        cbx_Follow.setOnClickListener(this);
        cbx_Like.setOnClickListener(this);
        expandable_playAudio.getViewTreeObserver().addOnPreDrawListener(
                new ViewTreeObserver.OnPreDrawListener() {

                    @Override
                    public boolean onPreDraw() {
                        expandable_playAudio.getViewTreeObserver().removeOnPreDrawListener(this);
                        expandable_playAudio.setVisibility(View.GONE);

                        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                        final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_audios.getHeight(), View.MeasureSpec.UNSPECIFIED);
                        //System.out.println(heightSpec);
                        expandable_playAudio.measure(widthSpec, heightSpec);

                        mAnimatorForAudio = slideAnimatorForAudio(0, expandable_playAudio.getMeasuredHeight());
                        return true;
                    }
                });


        getExpandable_question.getViewTreeObserver().addOnPreDrawListener(
                new ViewTreeObserver.OnPreDrawListener() {

                    @Override
                    public boolean onPreDraw() {
                        getExpandable_question.getViewTreeObserver().removeOnPreDrawListener(this);
                        getExpandable_question.setVisibility(View.GONE);

                        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                        final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_questions.getHeight(), View.MeasureSpec.UNSPECIFIED);
                        //System.out.println(heightSpec);
                        getExpandable_question.measure(widthSpec, heightSpec);

                        mAnimatorForQuestions = slideAnimatorForAudio(0, getExpandable_question.getMeasuredHeight());
                        return true;
                    }
                });


        getExpandable_finalbid.getViewTreeObserver().addOnPreDrawListener(
                new ViewTreeObserver.OnPreDrawListener() {

                    @Override
                    public boolean onPreDraw() {
                        getExpandable_finalbid.getViewTreeObserver().removeOnPreDrawListener(this);
                        getExpandable_finalbid.setVisibility(View.GONE);

                        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                        final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_finalbids.getHeight(), View.MeasureSpec.UNSPECIFIED);
                        //System.out.println(heightSpec);
                        getExpandable_finalbid.measure(widthSpec, heightSpec);

                        mAnimatorForFinalbid = slideAnimatorForAudio(0, getExpandable_finalbid.getMeasuredHeight());
                        return true;
                    }
                });


        expandable_viewDocument.getViewTreeObserver().addOnPreDrawListener(
                new ViewTreeObserver.OnPreDrawListener() {

                    @Override
                    public boolean onPreDraw() {
                        expandable_viewDocument.getViewTreeObserver().removeOnPreDrawListener(this);
                        expandable_viewDocument.setVisibility(View.GONE);

                        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                        final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_docs.getHeight(), View.MeasureSpec.UNSPECIFIED);
                        //System.out.println(heightSpec);
                        expandable_viewDocument.measure(widthSpec, heightSpec);

                        mAnimatorForDoc = slideAnimatorForDocument(0, expandable_viewDocument.getMeasuredHeight());
                        return true;
                    }

                });
        expandable_playVideo.getViewTreeObserver().addOnPreDrawListener(
                new ViewTreeObserver.OnPreDrawListener() {

                    @Override
                    public boolean onPreDraw() {
                        expandable_playVideo.getViewTreeObserver().removeOnPreDrawListener(this);
                        expandable_playVideo.setVisibility(View.GONE);

                        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                        final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_video.getHeight(), View.MeasureSpec.UNSPECIFIED);
                        //System.out.println(heightSpec);
                        expandable_playVideo.measure(widthSpec, heightSpec);

                        mAnimatorForVideo = slideAnimatorForVideo(0, expandable_playVideo.getMeasuredHeight());
                        return true;
                    }
                });


        btn_playAudio.setOnClickListener(this);
        btn_viewDocument.setOnClickListener(this);
        btn_playVideo.setOnClickListener(this);
        btn_playQuestions.setOnClickListener(this);
        btn_playFinalbid.setOnClickListener(this);
        invite.setOnClickListener(this);


        list_audios.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (audioObject != null) {
                    Fragment rateContributor = new WebViewFragment();


                    Bundle bundle = new Bundle();

                    bundle.putString("url", audioObject.getAudioUrl());
                    rateContributor.setArguments(bundle);
                    ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                }

            }
        });

        list_docs.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (docObject != null) {
                    Fragment rateContributor = new WebViewFragment();


                    Bundle bundle = new Bundle();

                    bundle.putString("url", docObject.getAudioUrl());
                    rateContributor.setArguments(bundle);
                    ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                }

            }
        });

        list_video.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (videoObject != null) {
                    Fragment rateContributor = new WebViewFragment();


                    Bundle bundle = new Bundle();

                    bundle.putString("url", videoObject.getAudioUrl());
                    rateContributor.setArguments(bundle);
                    ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                }

            }
        });


        list_questions.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (questionObject != null) {
                    Fragment rateContributor = new WebViewFragment();


                    Bundle bundle = new Bundle();

                    bundle.putString("url", questionObject.getAudioUrl());
                    rateContributor.setArguments(bundle);
                    ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                }

            }
        });


        list_finalbids.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (finalbidObject != null) {
                    Fragment rateContributor = new WebViewFragment();


                    Bundle bundle = new Bundle();

                    bundle.putString("url", finalbidObject.getAudioUrl());
                    rateContributor.setArguments(bundle);
                    ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                }

            }
        });

        detials();
        return rootView;
    }

    private void detials() {
        try {
            if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                JSONObject object = new JSONObject();
                object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                object.put("consulting_id", fund_id);
                AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONSULTING_DETAILS_TAG, Constants.CONSULTING_DETAILS_URL, Constants.HTTP_POST_REQUEST, object);
                a.execute();
            } else {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     * Called when a view has been clicked.
     *
     * @param v The view that was clicked.
     */
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.commitLayout:
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fund_id);
                bundle.putString("from","");
                ConsultingComittersFragment betaTestersComittersFragment = new ConsultingComittersFragment();
                betaTestersComittersFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(betaTestersComittersFragment);


                break;


            case R.id.invite:

                Bundle bundlenew = new Bundle();
                bundlenew.putString(Constants.FUND_ID, fund_id);
                SearchContactorsAndInviteFragment seacrchContractorandInvite = new SearchContactorsAndInviteFragment();
                seacrchContractorandInvite.setArguments(bundlenew);
                ((HomeActivity) getActivity()).replaceFragment(seacrchContractorandInvite);
                break;
            case R.id.apply:
                if (apply.getText().toString().trim().equals(getString(R.string.applyresources))) {
                    showDialog(getActivity(), "");
                } else {
                    try {
                        JSONObject likeObj = new JSONObject();
                        likeObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                        likeObj.put("consulting_id", fund_id);
                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            AsyncNew asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONSULTING_UNCOMMIT_TAG, Constants.CONSULTING_UNCOMMIT_URL, Constants.HTTP_POST_REQUEST, likeObj);
                            asyncNew.execute();
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
                break;
            case R.id.cbx_Like:
                if (cbx_Like.getText().toString().trim().equals("Like")) {
                    try {
                        JSONObject likeObj = new JSONObject();
                        likeObj.put("like_by", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                        likeObj.put("consulting_id", fund_id);
                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            AsyncNew asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONSULTING_LIKE_TAG, Constants.CONSULTING_LIKE_URL, Constants.HTTP_POST_REQUEST, likeObj);
                            asyncNew.execute();
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                } else {
                    try {
                        JSONObject likeObj = new JSONObject();
                        likeObj.put("dislike_by", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                        likeObj.put("consulting_id", fund_id);
                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            AsyncNew asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONSULTING_DISLIKE_TAG, Constants.CONSULTING_DISLIKE_URL, Constants.HTTP_POST_REQUEST, likeObj);
                            asyncNew.execute();
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }


                break;
            case R.id.cbx_Follow:
                JSONObject followObj = new JSONObject();
                try {
                    followObj.put("follow_by", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    followObj.put("consulting_id", fund_id);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                    if (cbx_Follow.getText().toString().trim().equalsIgnoreCase("Follow")) {
                        ((HomeActivity) getActivity()).showProgressDialog();
                        AsyncNew asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONSULTING_FOLLOW_TAG, Constants.CONSULTING_FOLLOW_URL, Constants.HTTP_POST_REQUEST, followObj);
                        asyncNew.execute();
                    } else {
                        ((HomeActivity) getActivity()).showProgressDialog();
                        AsyncNew asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONSULTING_UNFOLLOW_TAG, Constants.CONSULTING_UNFOLLOW_URL, Constants.HTTP_POST_REQUEST, followObj);
                        asyncNew.execute();
                    }
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
                break;
            case R.id.btn_playAudio:
                if (audioObject != null) {
                    if (expandable_playAudio.getVisibility() == View.GONE) {
                        expandForAudio();
                    } else {
                        collapseForAudio();
                    }
                }

                break;
            case R.id.btn_playVideo:
                if (videoObject != null) {
                    if (expandable_playVideo.getVisibility() == View.GONE) {
                        expandForVideo();
                    } else {
                        collapseForVideo();
                    }
                }

                break;
            case R.id.btn_viewDocument:
                if (docObject != null) {
                    if (expandable_viewDocument.getVisibility() == View.GONE) {
                        expandForDocument();
                    } else {
                        collapseForDoc();
                    }
                }
                break;


            case R.id.btn_playQuestions:
                if (questionObject != null) {
                    if (getExpandable_question.getVisibility() == View.GONE) {
                        expandForQuestion();
                    } else {
                        collapseForQuestion();
                    }
                }
                break;


            case R.id.btn_playFinalbid:
                if (finalbidObject != null) {
                    if (getExpandable_finalbid.getVisibility() == View.GONE) {
                        expandForFinalbid();
                    } else {
                        collapseForFinalbid();
                    }
                }
                break;

        }
    }

    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.TIMEOUT_EXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            UtilitiesClass.getInstance(getActivity()).alertDialogSingleButton(getString(R.string.time_out));
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            if (tag.equals(Constants.CONSULTING_DETAILS_TAG)) {
                CrowdBootstrapLogger.logInfo(result);
                try {
                    JSONObject jsonObject = new JSONObject(result);


                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        et_description.setText(jsonObject.getString("description"));
                        et_title.setText(jsonObject.getString("title"));
                        ((HomeActivity) getActivity()).setActionBarTitle(jsonObject.getString("title"));
                        if (Integer.parseInt(jsonObject.getString("numOfCommits")) == 0) {
                            commitLayout.setVisibility(View.GONE);
                        } else {
                            commitLayout.setVisibility(View.VISIBLE);
                            tv_comittCounter.setText(jsonObject.getString("numOfCommits"));
                        }
                        et_description.setText(jsonObject.getString("description"));
                        et_title.setText(jsonObject.getString("title"));

                        et_assignment_startdate.setText(jsonObject.getString("requirement_distribute_date"));
                        et_commitintentbid_deadlinedate.setText(jsonObject.getString("bid_intent_deadline_date"));
                        et_bids_deadlinedate.setText(jsonObject.getString("bid_commitment_deadline_date"));
                        et_questions_dedlinedate.setText(jsonObject.getString("question_deadline_date"));

                        et_conditions.setText(jsonObject.getString("overview"));
                        et_bidderpresentation_deadlinedate.setText(jsonObject.getString("bidder_presentation_date"));

                        et_projectoverview_deadlinedate.setText(jsonObject.getString("client_overview_date"));
                        et_answers_targetdate.setText(jsonObject.getString("answer_target_date"));
                        et_proposal_deadlinedate.setText(jsonObject.getString("proposal_submit_date"));
                        et_awardproject_targetdate.setText(jsonObject.getString("project_award_date"));
                        et_startproject_date.setText(jsonObject.getString("project_start_date"));
                        et_completeproject_targetdate.setText(jsonObject.getString("project_complete_date"));

                        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.getString("image").trim(), image_roadmap);

                        if (jsonObject.has("interest_keyword_id")) {
                            StringBuilder sb = new StringBuilder();
                            for (int i = 0; i < jsonObject.getJSONArray("interest_keyword_id").length(); i++) {
                                if (sb.length() > 0) {
                                    sb.append(", ");
                                }
                                sb.append(jsonObject.getJSONArray("interest_keyword_id").getJSONObject(i).getString("name"));
                            }
                            et_interestKeywords.setText(sb.toString());
                        }

                        if (jsonObject.has("target_keywords_id")) {
                            StringBuilder sb = new StringBuilder();
                            for (int i = 0; i < jsonObject.getJSONArray("target_keywords_id").length(); i++) {
                                if (sb.length() > 0) {
                                    sb.append(", ");
                                }
                                sb.append(jsonObject.getJSONArray("target_keywords_id").getJSONObject(i).getString("name"));
                            }
                            et_keywords.setText(sb.toString());
                        }


                        if (!jsonObject.getString("document").isEmpty()) {
                            docObject = new AudioObject();
                            docObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + jsonObject.getString("document"));
                            int a = jsonObject.getString("document").lastIndexOf("/");
                            docObject.setOrignalName(jsonObject.getString("document").substring(a + 1));
                            docObject.setName("Document 1");
                            list_docs.setText(docObject.getName());
                        } else {
                            expandable_viewDocument.setVisibility(View.GONE);
                        }
                        if (!jsonObject.getString("video").isEmpty()) {
                            videoObject = new AudioObject();
                            videoObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + jsonObject.getString("video"));
                            int a = jsonObject.getString("video").lastIndexOf("/");
                            videoObject.setOrignalName(jsonObject.getString("video").substring(a + 1));
                            videoObject.setName("Video 1");
                            list_video.setText(videoObject.getName());
                        } else {
                            expandable_playVideo.setVisibility(View.GONE);
                        }

                        if (!jsonObject.getString("audio").isEmpty()) {
                            audioObject = new AudioObject();
                            audioObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + jsonObject.getString("audio"));
                            int a = jsonObject.getString("audio").lastIndexOf("/");
                            audioObject.setOrignalName(jsonObject.getString("audio").substring(a + 1));
                            audioObject.setName("Audio 1");
                            list_audios.setText(audioObject.getName());
                        } else {
                            expandable_playAudio.setVisibility(View.GONE);
                        }


                        if (!jsonObject.getString("question").isEmpty()) {
                            questionObject = new AudioObject();
                            questionObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + jsonObject.getString("question"));
                            int a = jsonObject.getString("question").lastIndexOf("/");
                            questionObject.setOrignalName(jsonObject.getString("question").substring(a + 1));
                            questionObject.setName("Questions");
                            list_questions.setText(questionObject.getName());
                        } else {
                            getExpandable_question.setVisibility(View.GONE);
                        }


                        if (!jsonObject.getString("final_bid").isEmpty()) {
                            finalbidObject = new AudioObject();
                            finalbidObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + jsonObject.getString("final_bid"));
                            int a = jsonObject.getString("final_bid").lastIndexOf("/");
                            finalbidObject.setOrignalName(jsonObject.getString("final_bid").substring(a + 1));
                            finalbidObject.setName("Final Bid");
                            list_finalbids.setText(finalbidObject.getName());
                        } else {
                            getExpandable_finalbid.setVisibility(View.GONE);
                        }


                        et_postedBy.setText(jsonObject.getString("created_by"));
                        if (jsonObject.getString("isComitted").equals("1")) {
                            apply.setText(getString(R.string.appliedresources));
                            apply.setBackgroundResource(R.drawable.green_color_button);
                            //apply.setBackground(getDrawable(R.drawable.green_color_button));
                        } else {
                            apply.setText(getString(R.string.applyresources));
                            apply.setBackgroundResource(R.drawable.blue_button);
                        }
                        if (jsonObject.getString("is_liked_by_user").equals("1")) {
                            cbx_Like.setText("Liked");
                            cbx_Like.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                        } else {
                            cbx_Like.setText("Like");
                            cbx_Like.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                        }
                        if (jsonObject.getString("is_follwed_by_user").equals("1")) {
                            cbx_Follow.setText("UnFollow");
                            cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                        } else {
                            cbx_Follow.setText("Follow");
                            cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                        }

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equals(Constants.CONSULTING_LIKE_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        cbx_Like.setText("Liked");
                        cbx_Like.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }

            } else if (tag.equals(Constants.CONSULTING_DISLIKE_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        cbx_Like.setText("Like");
                        cbx_Like.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }

            } else if (tag.equals(Constants.CONSULTING_FOLLOW_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        cbx_Follow.setText("UnFollow");
                        cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }

            } else if (tag.equals(Constants.CONSULTING_UNFOLLOW_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        cbx_Follow.setText("Follow");
                        cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }

            } else if (tag.equals(Constants.CONSULTING_UNCOMMIT_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        apply.setText(getString(R.string.applyresources));
                        apply.setBackgroundResource(R.drawable.blue_button);
                        if (Integer.parseInt(jsonObject.getString("numOfCommits")) == 0) {
                            commitLayout.setVisibility(View.GONE);
                        } else {
                            commitLayout.setVisibility(View.VISIBLE);
                            tv_comittCounter.setText(jsonObject.getString("numOfCommits"));
                        }
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }
        }


    }

    /*class DocumentListAdapter extends BaseAdapter {
        private LayoutInflater l_Inflater;

        class ViewHolder {
            TextView tv_name;
            ImageView view;
            LinearLayout row_layout;
        }

        public DocumentListAdapter() {
            l_Inflater = LayoutInflater.from(getActivity());
        }

        @Override
        public int getCount() {
            return documentObjectList.size();
        }


        @Override
        public Object getItem(int position) {
            return documentObjectList.get(position);
        }


        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder;


            if (convertView == null) {
                convertView = l_Inflater.inflate(R.layout.row_item, null);
                holder = new ViewHolder();
                holder.row_layout = (LinearLayout) convertView.findViewById(R.id.row_layout);
                holder.tv_name = (TextView) convertView.findViewById(R.id.text1);
                holder.view = (ImageView) convertView.findViewById(R.id.view);

                convertView.setTag(holder);

            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            try {
                holder.tv_name.setText(documentObjectList.get(position).getName());
            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                holder.row_layout.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Fragment rateContributor = new WebViewFragment();


                        Bundle bundle = new Bundle();

                        bundle.putString("url", documentObjectList.get(position).getAudioUrl());
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                        *//*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*//*
                    }
                });
                holder.view.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Fragment rateContributor = new WebViewFragment();


                        Bundle bundle = new Bundle();

                        bundle.putString("url", documentObjectList.get(position).getAudioUrl());
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                        *//*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*//*
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }


            return convertView;
        }
    }

    class VideoListAdapter extends BaseAdapter {
        private LayoutInflater l_Inflater;

        class ViewHolder {
            TextView tv_name;
            ImageView view;
            LinearLayout row_layout;
        }

        public VideoListAdapter() {
            l_Inflater = LayoutInflater.from(getActivity());
        }

        @Override
        public int getCount() {
            return videoObjectList.size();
        }


        @Override
        public Object getItem(int position) {
            return videoObjectList.get(position);
        }


        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder;


            if (convertView == null) {
                convertView = l_Inflater.inflate(R.layout.row_item, null);
                holder = new ViewHolder();
                holder.row_layout = (LinearLayout) convertView.findViewById(R.id.row_layout);
                holder.tv_name = (TextView) convertView.findViewById(R.id.text1);
                holder.view = (ImageView) convertView.findViewById(R.id.view);

                convertView.setTag(holder);

            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            try {
                holder.tv_name.setText(videoObjectList.get(position).getName());
            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                holder.view.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Fragment rateContributor = new WebViewFragment();


                        Bundle bundle = new Bundle();

                        bundle.putString("url", videoObjectList.get(position).getAudioUrl());
                        rateContributor.setArguments(bundle);

                        ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                        *//*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*//*
                    }
                });

                holder.row_layout.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Fragment rateContributor = new WebViewFragment();


                        Bundle bundle = new Bundle();

                        bundle.putString("url", videoObjectList.get(position).getAudioUrl());
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                        *//*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*//*
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }

            return convertView;
        }
    }

    class AudioAdapter extends BaseAdapter {
        private LayoutInflater l_Inflater;

        class ViewHolder {
            TextView tv_name;
            ImageView view;
            LinearLayout row_layout;
        }

        public AudioAdapter() {
            l_Inflater = LayoutInflater.from(getActivity());
        }

        @Override
        public int getCount() {
            return audioObjectsList.size();
        }


        @Override
        public Object getItem(int position) {
            return audioObjectsList.get(position);
        }


        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder;


            if (convertView == null) {
                convertView = l_Inflater.inflate(R.layout.row_item, null);
                holder = new ViewHolder();
                holder.row_layout = (LinearLayout) convertView.findViewById(R.id.row_layout);
                holder.tv_name = (TextView) convertView.findViewById(R.id.text1);
                holder.view = (ImageView) convertView.findViewById(R.id.view);

                convertView.setTag(holder);

            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            try {
                holder.tv_name.setText(audioObjectsList.get(position).getName());
            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                holder.view.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Fragment rateContributor = new WebViewFragment();


                        Bundle bundle = new Bundle();

                        bundle.putString("url", audioObjectsList.get(position).getAudioUrl());
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                       *//* FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*//*
                    }
                });

                holder.row_layout.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Fragment rateContributor = new WebViewFragment();


                        Bundle bundle = new Bundle();

                        bundle.putString("url", audioObjectsList.get(position).getAudioUrl());
                        rateContributor.setArguments(bundle);

                        ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                        *//*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*//*
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }
            return convertView;
        }
    }*/

    public ValueAnimator slideAnimatorForDocument(int start, int end) {

        ValueAnimator animator = ValueAnimator.ofInt(start, end);


        try {
            animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                @Override
                public void onAnimationUpdate(ValueAnimator valueAnimator) {
                    //Update Height
                    int value = (Integer) valueAnimator.getAnimatedValue();
                    ViewGroup.LayoutParams layoutParams = expandable_viewDocument.getLayoutParams();
                    layoutParams.height = value;
                    expandable_viewDocument.setLayoutParams(layoutParams);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return animator;
    }


    ValueAnimator slideAnimatorForAudio(int start, int end) {

        ValueAnimator animator = ValueAnimator.ofInt(start, end);


        try {
            animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                @Override
                public void onAnimationUpdate(ValueAnimator valueAnimator) {
                    //Update Height
                    int value = (Integer) valueAnimator.getAnimatedValue();

                    ViewGroup.LayoutParams layoutParams = expandable_playAudio.getLayoutParams();
                    layoutParams.height = value;
                    expandable_playAudio.setLayoutParams(layoutParams);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return animator;
    }

    ValueAnimator slideAnimatorForVideo(int start, int end) {

        ValueAnimator animator = null;
        try {
            animator = ValueAnimator.ofInt(start, end);


            animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                @Override
                public void onAnimationUpdate(ValueAnimator valueAnimator) {
                    //Update Height
                    int value = (Integer) valueAnimator.getAnimatedValue();

                    ViewGroup.LayoutParams layoutParams = expandable_playVideo.getLayoutParams();
                    layoutParams.height = value;
                    expandable_playVideo.setLayoutParams(layoutParams);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return animator;
    }


    private void expandForDocument() {
        //set Visible
        try {
            expandable_viewDocument.setVisibility(View.VISIBLE);
            viewDocumentArrow.setBackground(getResources().getDrawable(R.drawable.arrow_upward));

            // UtilityList.setListViewHeightBasedOnChildren(list_docs);
            list_docs.setVisibility(View.VISIBLE);
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


    private void expandForQuestion() {
        //set Visible
        try {
            getExpandable_question.setVisibility(View.VISIBLE);
            viewQuestionArrow.setBackground(getResources().getDrawable(R.drawable.arrow_upward));

            // UtilityList.setListViewHeightBasedOnChildren(list_docs);
            list_questions.setVisibility(View.VISIBLE);
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


    private void expandForFinalbid() {
        //set Visible
        try {
            getExpandable_finalbid.setVisibility(View.VISIBLE);
            viewFinalbidArrow.setBackground(getResources().getDrawable(R.drawable.arrow_upward));

            // UtilityList.setListViewHeightBasedOnChildren(list_docs);
            list_finalbids.setVisibility(View.VISIBLE);
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private void expandForVideo() {
        //set Visible
        try {
            expandable_playVideo.setVisibility(View.VISIBLE);
            viewplayVideoArrow.setBackground(getResources().getDrawable(R.drawable.arrow_upward));
            list_video.setVisibility(View.VISIBLE);
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void expandForAudio() {
        //set Visible
        try {
            expandable_playAudio.setVisibility(View.VISIBLE);
            viewplayAudioArrow.setBackground(getResources().getDrawable(R.drawable.arrow_upward));
            list_audios.setVisibility(View.VISIBLE);
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private void collapseForDoc() {
//        int finalHeight = expandable_viewDocument.getHeight();
        try {
            viewDocumentArrow.setBackground(getResources().getDrawable(R.drawable.arrow_downward));


            expandable_viewDocument.getViewTreeObserver().addOnPreDrawListener(
                    new ViewTreeObserver.OnPreDrawListener() {

                        @Override
                        public boolean onPreDraw() {
                            expandable_viewDocument.getViewTreeObserver().removeOnPreDrawListener(this);
                            expandable_viewDocument.setVisibility(View.GONE);

                            final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_docs.getHeight(), View.MeasureSpec.UNSPECIFIED);
                            //System.out.println(heightSpec);
                            expandable_viewDocument.measure(widthSpec, heightSpec);

                            mAnimatorForDoc = slideAnimatorForDocument(0, expandable_viewDocument.getMeasuredHeight());
                            return true;
                        }

                    });
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void collapseForQuestion() {
//        int finalHeight = expandable_viewDocument.getHeight();
        try {
            viewQuestionArrow.setBackground(getResources().getDrawable(R.drawable.arrow_downward));


            getExpandable_question.getViewTreeObserver().addOnPreDrawListener(
                    new ViewTreeObserver.OnPreDrawListener() {

                        @Override
                        public boolean onPreDraw() {
                            getExpandable_question.getViewTreeObserver().removeOnPreDrawListener(this);
                            getExpandable_question.setVisibility(View.GONE);

                            final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_questions.getHeight(), View.MeasureSpec.UNSPECIFIED);
                            //System.out.println(heightSpec);
                            getExpandable_question.measure(widthSpec, heightSpec);

                            mAnimatorForQuestions = slideAnimatorForDocument(0, getExpandable_question.getMeasuredHeight());
                            return true;
                        }

                    });
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void collapseForFinalbid() {
//        int finalHeight = expandable_viewDocument.getHeight();
        try {
            viewFinalbidArrow.setBackground(getResources().getDrawable(R.drawable.arrow_downward));


            getExpandable_finalbid.getViewTreeObserver().addOnPreDrawListener(
                    new ViewTreeObserver.OnPreDrawListener() {

                        @Override
                        public boolean onPreDraw() {
                            getExpandable_finalbid.getViewTreeObserver().removeOnPreDrawListener(this);
                            getExpandable_finalbid.setVisibility(View.GONE);

                            final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_finalbids.getHeight(), View.MeasureSpec.UNSPECIFIED);
                            //System.out.println(heightSpec);
                            getExpandable_finalbid.measure(widthSpec, heightSpec);

                            mAnimatorForFinalbid = slideAnimatorForDocument(0, getExpandable_finalbid.getMeasuredHeight());
                            return true;
                        }

                    });
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void collapseForAudio() {
//        int finalHeight = expandable_playAudio.getHeight();
        try {
            viewplayAudioArrow.setBackground(getResources().getDrawable(R.drawable.arrow_downward));


            expandable_playAudio.getViewTreeObserver().addOnPreDrawListener(
                    new ViewTreeObserver.OnPreDrawListener() {

                        @Override
                        public boolean onPreDraw() {
                            expandable_playAudio.getViewTreeObserver().removeOnPreDrawListener(this);
                            expandable_playAudio.setVisibility(View.GONE);

                            final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_audios.getHeight(), View.MeasureSpec.UNSPECIFIED);
                            //System.out.println(heightSpec);
                            expandable_playAudio.measure(widthSpec, heightSpec);

                            mAnimatorForAudio = slideAnimatorForAudio(0, expandable_playAudio.getMeasuredHeight());
                            return true;
                        }
                    });
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void collapseForVideo() {
//        int finalHeight = expandable_playVideo.getHeight();
        try {
            viewplayVideoArrow.setBackground(getResources().getDrawable(R.drawable.arrow_downward));

            expandable_playVideo.getViewTreeObserver().addOnPreDrawListener(
                    new ViewTreeObserver.OnPreDrawListener() {

                        @Override
                        public boolean onPreDraw() {
                            expandable_playVideo.getViewTreeObserver().removeOnPreDrawListener(this);
                            expandable_playVideo.setVisibility(View.GONE);

                            final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_video.getHeight(), View.MeasureSpec.UNSPECIFIED);
                            //System.out.println(heightSpec);
                            expandable_playVideo.measure(widthSpec, heightSpec);

                            mAnimatorForVideo = slideAnimatorForVideo(0, expandable_playVideo.getMeasuredHeight());
                            return true;
                        }
                    });
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }


    }


    private TextView _filetext;
    private Dialog dialog;
    private boolean filepicker;

    public void showDialog(Activity activity, String msg) {
        dialog = new Dialog(activity);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setCancelable(false);
        dialog.setContentView(R.layout.browse_answers_customdialog);

        final boolean resultVideo = UtilitiesClass.checkPermission(getActivity());

        TextView browseBtn = (TextView) dialog.findViewById(R.id.browse_btn);
        _filetext = (TextView) dialog.findViewById(R.id.filepath);

        browseBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                try {

                    filepicker = true;

                    Intent intent = new Intent(getActivity(), FilePicker.class);
                    String[] acceptedFileExtensions = null;
                    acceptedFileExtensions = new String[]{".pdf"};


                    intent.putExtra("FILE_EXTENSION", acceptedFileExtensions);
                    getActivity().startActivityForResult(intent, Constants.FILE_PICKER);

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });

        Button upload = (Button) dialog.findViewById(R.id.btn_yes);
        upload.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                InputMethodManager inputMethodManager = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
                inputMethodManager.hideSoftInputFromWindow(getActivity().getCurrentFocus().getWindowToken(), 0);
                if (_filetext.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity(), "You cannot apply without a document.", Toast.LENGTH_LONG).show();
                    return;
                }


                HashMap<String, String> map = new HashMap<String, String>();
                map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                map.put("consulting_id", fund_id);
                for (int j = 0; j < pathofmedia.size(); j++) {
                    CrowdBootstrapLogger.logInfo("file path" + pathofmedia.get(j).getPath());
                    CrowdBootstrapLogger.logInfo("file size" + pathofmedia.get(j).getFilesize());
                    CrowdBootstrapLogger.logInfo("file type" + pathofmedia.get(j).getType());
                }

                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    applyConsulting(map, Constants.APPLY_CONSULTING_URL);
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }


            }

        });

        Button cancel = (Button) dialog.findViewById(R.id.btn_no);
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();

            }
        });


        dialog.show();

    }

    private static final int SELECT_FILE_TEXT = 199;


    private String userChoosenTask;

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {

        try {
            if (requestCode == Constants.APP_PERMISSION) {
                // BEGIN_INCLUDE(permission_result)
                // Received permission result for camera permission.
                Log.i("TAG", "Received response for Camera permission request.");

                // Check if the only required permission has been granted
                if (grantResults.length == 1 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // Camera permission has been granted, preview can be displayed
                    Log.i("TAG", "CAMERA permission has now been granted. Showing preview.");
                    Snackbar.make(layout, R.string.permision_available_camera, Snackbar.LENGTH_SHORT).show();
                } else {
                    Log.i("TAG", "CAMERA permission was NOT granted.");
                    Snackbar.make(layout, R.string.permissions_not_granted, Snackbar.LENGTH_SHORT).show();
                }
            } else {
                super.onRequestPermissionsResult(requestCode, permissions, grantResults);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    private void requestPermission() {
        try {
            Log.i("TAG", "CAMERA permission has NOT been granted. Requesting permission.");

            // BEGIN_INCLUDE(camera_permission_request)
            if ((ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.CAMERA)) && ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE)) {
                // Provide an additional rationale to the user if the permission was not granted
                // and the user would benefit from additional context for the use of the permission.
                // For example if the user has previously denied the permission.
                Log.i("TAG", "Displaying camera permission rationale to provide additional context.");

                Snackbar.make(parent_layout, R.string.app_permision, Snackbar.LENGTH_INDEFINITE)
                        .setAction("OK", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.CAMERA, Manifest.permission.READ_EXTERNAL_STORAGE}, Constants.APP_PERMISSION);
                            }
                        })
                        .show();
            } else {

                // Camera permission has not been granted yet. Request it directly.

            }
            ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.CAMERA, Manifest.permission.READ_EXTERNAL_STORAGE}, Constants.APP_PERMISSION);
            // END_INCLUDE(camera_permission_request)
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        try {
            if (resultCode == Activity.RESULT_OK) {
                if (requestCode == Constants.FILE_PICKER) {
                    onSelectTextFroGalleryResult(data);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private File fileSelected;
    private Uri finalUri;
    private String fileType;


    private void onSelectTextFroGalleryResult(Intent data) {

        if (data.hasExtra(FilePicker.EXTRA_FILE_PATH)) {

            fileSelected = new File(data.getStringExtra(FilePicker.EXTRA_FILE_PATH));
            Log.e("XXX", "++++++++++++++++++++" + fileSelected.getAbsolutePath());

            fileType = data.getStringExtra(FilePicker.EXTRA_FILE_TYPE);
            CrowdBootstrapLogger.logInfo(fileType + " filetype");
            // CALL THIS METHOD TO GET THE ACTUAL PATH
            File finalFile = new File(data.getStringExtra(FilePicker.EXTRA_FILE_PATH));
            long length = finalFile.length();
            int a = finalFile.getAbsolutePath().lastIndexOf("/");
            if (length >= Constants.MAX_FILE_LENGTH_ALLOWED) {
                Toast.makeText(getActivity(), finalFile.getAbsolutePath().substring(a + 1).toString().trim() + " size is more than 20 MB.", Toast.LENGTH_LONG).show();
            } else {
                _filetext.setVisibility(View.VISIBLE);


                _filetext.setText(finalFile.getAbsolutePath().substring(a + 1).toString().trim());


                addpath(finalFile.getAbsolutePath(), "document", String.valueOf(length), finalFile.getAbsolutePath().substring(a + 1).toString().trim());
            }

        }

    }

    public ArrayList<Mediabeans> pathofmedia;

    private void addpath(String path, String type, String filesize, String fileName) {
        try {

            pathofmedia = new ArrayList<Mediabeans>();
            pathofmedia.add(new Mediabeans(path, type, filesize, fileName));

        } catch (Exception e) {
            e.printStackTrace();
        }
        //selection = pathofmedia.size();
    }


    long totalSize = 0;

    private void applyConsulting(final HashMap<String, String> map, final String createUrl) {

        try {
            new AsyncTask<Integer, Integer, String>() {

                ProgressDialog pDialog;

                @Override
                protected void onPreExecute() {
                    // TODO Auto-generated method stub
                    super.onPreExecute();

                    pDialog = new ProgressDialog(getActivity());
                    pDialog.setMessage("Please wait...");
                    pDialog.setIndeterminate(false);
                    pDialog.setMax(100);
                    pDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
                    pDialog.setCancelable(false);
                    pDialog.show();


                }

                @Override
                protected void onProgressUpdate(Integer... values) {
                    super.onProgressUpdate(values);
                    pDialog.setProgress(values[0]);
                }

                @Override
                protected String doInBackground(Integer... params) {

                    File docFile = null;
                    File audioFile = null;
                    File videoFile = null;
                    File questionFile = null;
                    File finalbidFile = null;
                    FileBody docFileBody = null;
                    FileBody audioFileBody = null;
                    FileBody videoFileBody = null;
                    FileBody questionFileBody = null;
                    FileBody finalbidFileBody = null;
                    try {
                       /* ArrayList<File> files = new ArrayList<File>();
                        ArrayList<FileBody> bin = new ArrayList<FileBody>();
                        for (int i = 0; i < pathofmedia.size(); i++) {
                            files.add(new File(pathofmedia.get(i).getPath()));
                        }

                        for (int i = 0; i < files.size(); i++) {
                            bin.add(new FileBody(files.get(i)));
                        }*/

                        for (int i = 0; i < pathofmedia.size(); i++) {
                            if (pathofmedia.get(i).getPath().contains(".pdf") && (pathofmedia.get(i).getType().compareTo("document") == 0)) {
                                Log.e("XXX","+++++++++++++++++"+pathofmedia.get(i).getPath());
                                docFile = (new File(pathofmedia.get(i).getPath()));
                            }


                        }

                        if (docFile != null) {
                            docFileBody = new FileBody(docFile);
                        }


                        AndroidMultipartEntity entity = new AndroidMultipartEntity(
                                new AndroidMultipartEntity.ProgressListener() {

                                    @Override
                                    public void transferred(long num) {
                                        publishProgress((int) ((num / (float) totalSize) * 100));
                                    }
                                });

                        for (String key : map.keySet()) {
                            entity.addPart(key, new StringBody(map.get(key), "text/plain", Charset.forName("UTF-8")));
                        }
                               /* for (int i = 0; i < bin.size(); i++) {
                                    entity.addPart("docs[]", bin.get(i));
                                }*/

                        if (docFileBody != null) {
                            entity.addPart("document", docFileBody);
                        }


                        try {
                            return multipost(createUrl, entity);
                        } catch (UnknownHostException e) {
                            e.printStackTrace();
                            return Constants.NOINTERNET;
                        } catch (SocketTimeoutException e) {
                            e.printStackTrace();
                            return Constants.TIMEOUT_EXCEPTION;
                        }
                    } catch (UnsupportedEncodingException e) {
                        e.printStackTrace();
                    }
                    return Constants.SERVEREXCEPTION;
                    //return uploadFile();
                }

                private String multipost(String urlString, AndroidMultipartEntity reqEntity) throws UnknownHostException, SocketTimeoutException {
                    try {
                        URL url = new URL(Constants.APP_BASE_URL + urlString);
                        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                        conn.setReadTimeout(1200000);
                        conn.setConnectTimeout(1200000);
                        conn.setRequestMethod(Constants.HTTP_POST_REQUEST);
                        conn.setUseCaches(false);
                        conn.setDoInput(true);
                        conn.setDoOutput(true);

                        conn.setRequestProperty("Connection", "Keep-Alive");
                        conn.addRequestProperty("Content-length", reqEntity.getContentLength() + "");
                        conn.addRequestProperty(reqEntity.getContentType().getName(), reqEntity.getContentType().getValue());

                        OutputStream os = conn.getOutputStream();
                        reqEntity.writeTo(conn.getOutputStream());
                        os.close();
                        conn.connect();

                        if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                            return readStream(conn.getInputStream());
                        } else {
                            return Constants.SERVEREXCEPTION;
                        }

                    } catch (UnknownHostException e) {
                        e.printStackTrace();
                        throw e;
                    } catch (SocketTimeoutException e) {
                        throw e;
                    } catch (Exception e) {
                        Log.e("TAG", "multipart post error " + e + "(" + urlString + ")");
                        return Constants.SERVEREXCEPTION;
                    }
                    //return Constants.SERVEREXCEPTION;
                }

                private String readStream(InputStream in) {
                    BufferedReader reader = null;
                    StringBuilder builder = new StringBuilder();
                    try {
                        reader = new BufferedReader(new InputStreamReader(in));
                        String line = "";
                        while ((line = reader.readLine()) != null) {
                            builder.append(line);
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    } finally {
                        if (reader != null) {
                            try {
                                reader.close();
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                    return builder.toString();
                }

                @Override
                protected void onPostExecute(String result) {
                    super.onPostExecute(result);
                    pDialog.dismiss();
                    if (result.equals(Constants.NOINTERNET)) {
                        Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
                    } else if (result.equals(Constants.SERVEREXCEPTION)) {
                        Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
                    } else if (result.equals(Constants.TIMEOUT_EXCEPTION)) {
                        UtilitiesClass.getInstance(getActivity()).alertDialogSingleButton(getString(R.string.time_out));
                    } else {
                        if (result.isEmpty()) {
                            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
                        } else {
                            try {
                                CrowdBootstrapLogger.logInfo(result);
                                JSONObject jsonObject = new JSONObject(result);
                                if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                                    pathofmedia.clear();
                                    dialog.dismiss();
                                    apply.setText(getString(R.string.appliedresources));
                                    apply.setBackgroundResource(R.drawable.green_color_button);
                                    if (Integer.parseInt(jsonObject.getString("numOfCommits")) == 0) {
                                        commitLayout.setVisibility(View.GONE);
                                    } else {
                                        commitLayout.setVisibility(View.VISIBLE);
                                        tv_comittCounter.setText(jsonObject.getString("numOfCommits"));
                                    }

                                } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        }

                    }

                }
            }.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
