package com.staging.fragments;

import android.animation.Animator;
import android.animation.ValueAnimator;
import android.app.DatePickerDialog;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.models.AudioObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.UtilityList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

/**
 * Created by sunakshi.gautam on 11/22/2016.
 */
public class OrganizationDetailFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    boolean is_commited_by_user = false;
    boolean commited_by_user = false;
    boolean isCheckedFollow = false;
    private boolean followChecked = false;

    private static String CAMPAING_ID;
    private ValueAnimator mAnimator;
    //private ArrayList<GenericObject> keywordsList;
    private String titleText;
    private TextView cbx_Follow;
    //private AudioListAdapter adapter;
    private ListView list_audios, list_docs, list_video;
    private ArrayList<AudioObject> audioObjectsList, documentObjectList, videoObjectList;

    private DatePickerDialog.OnDateSetListener date;
    private Calendar myCalendar;
    private EditText et_dueDate, et_summary, et_campaignName, et_startupName, et_keywords, et_targetAmount, et_fundRaiseSoFor;
    private Button btn_commit, btn_ViewDonators;
    private ImageView viewDocumentArrow, viewplayAudioArrow, viewplayVideoArrow, viewsummaryArrow, viewroadmapGraphicArrow, image_roadmap;
    private LinearLayout btn_playAudio, btn_viewDocument, btn_playVideo, btn_summary;

    private LinearLayout expandable_playAudio, expandable_viewDocument, expandable_playVideo, expandable_Summary, roadmapGraphiclayout, roadmapGraphic, roadmapGraphicexpandable;
    private ValueAnimator mAnimatorForDoc, mAnimatorForAudio, mAnimatorForVideo, mAnimatorForSummary;
    //private AudioListAdapter audiosListAdapter, docsListAdapter, videosListAdapter;

    public OrganizationDetailFragment() {
        super();
    }


    @Override
    public void onResume() {
        super.onResume();

        titleText = getArguments().getString("COMPANY_NAME");

        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        ((HomeActivity) getActivity()).setActionBarTitle(getArguments().getString("COMPANY_NAME"));

    }

    EditText et_campaignKeywords;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.organization_details_layout, container, false);
        //((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.campaignDetails));

            audioObjectsList = new ArrayList<AudioObject>();
            videoObjectList = new ArrayList<AudioObject>();
            documentObjectList = new ArrayList<AudioObject>();
            CAMPAING_ID = getArguments().getString("COMPANY_ID");
            myCalendar = Calendar.getInstance();
            cbx_Follow = (TextView) rootView.findViewById(R.id.cbx_Follow);

            list_audios = (ListView) rootView.findViewById(R.id.list_audios);
            list_docs = (ListView) rootView.findViewById(R.id.list_docs);
            list_video = (ListView) rootView.findViewById(R.id.list_video);

            expandable_playAudio = (LinearLayout) rootView.findViewById(R.id.expandable_playAudio);
            expandable_playVideo = (LinearLayout) rootView.findViewById(R.id.expandable_playVideo);
            expandable_viewDocument = (LinearLayout) rootView.findViewById(R.id.expandable_viewDocument);
            expandable_Summary = (LinearLayout) rootView.findViewById(R.id.expandable_Summary);
            roadmapGraphiclayout = (LinearLayout) rootView.findViewById(R.id.roadmapGraphiclayout);

            roadmapGraphic = (LinearLayout) rootView.findViewById(R.id.roadmapGraphic);
            viewroadmapGraphicArrow = (ImageView) rootView.findViewById(R.id.viewroadmapGraphicArrow);
            roadmapGraphicexpandable = (LinearLayout) rootView.findViewById(R.id.roadmapGraphicexpandable);
            image_roadmap = (ImageView) rootView.findViewById(R.id.image_roadmap);


            btn_commit = (Button) rootView.findViewById(R.id.btn_commit);
            btn_ViewDonators = (Button) rootView.findViewById(R.id.btn_ViewDonators);

            btn_playAudio = (LinearLayout) rootView.findViewById(R.id.btn_playAudio);
            btn_playVideo = (LinearLayout) rootView.findViewById(R.id.btn_playVideo);
            btn_viewDocument = (LinearLayout) rootView.findViewById(R.id.btn_viewDocument);
            btn_summary = (LinearLayout) rootView.findViewById(R.id.btn_summary);

            viewDocumentArrow = (ImageView) rootView.findViewById(R.id.viewDocumentArrow);
            viewplayAudioArrow = (ImageView) rootView.findViewById(R.id.viewplayAudioArrow);
            viewplayVideoArrow = (ImageView) rootView.findViewById(R.id.viewplayVideoArrow);
            viewsummaryArrow = (ImageView) rootView.findViewById(R.id.viewsummaryArrow);

            et_dueDate = (EditText) rootView.findViewById(R.id.et_dueDate);
            et_summary = (EditText) rootView.findViewById(R.id.et_summary);
            et_campaignName = (EditText) rootView.findViewById(R.id.et_campaignName);
            et_startupName = (EditText) rootView.findViewById(R.id.et_startupName);
            et_keywords = (EditText) rootView.findViewById(R.id.et_keywords);
            et_campaignKeywords = (EditText) rootView.findViewById(R.id.et_keywordsCampaign);
            et_targetAmount = (EditText) rootView.findViewById(R.id.et_targetAmount);
            et_fundRaiseSoFor = (EditText) rootView.findViewById(R.id.et_fundRaiseSoFor);


            btn_commit.setOnClickListener(this);
            btn_ViewDonators.setOnClickListener(this);

            btn_playAudio.setOnClickListener(this);
            btn_viewDocument.setOnClickListener(this);
            btn_playVideo.setOnClickListener(this);
            btn_summary.setOnClickListener(this);

            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.DETAIL_ORGANIZATION_TAG, Constants.DETAIL_ORGANIZATION_URL + "?company_id=" + CAMPAING_ID + "&user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET, "Home Activity");
                a.execute();

            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }

            et_summary.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(final View v, final MotionEvent motionEvent) {
                    if (v.getId() == R.id.et_summary) {
                        v.getParent().requestDisallowInterceptTouchEvent(true);
                        switch (motionEvent.getAction() & MotionEvent.ACTION_MASK) {
                            case MotionEvent.ACTION_UP:
                                v.getParent().requestDisallowInterceptTouchEvent(false);
                                break;
                        }
                    }
                    return false;
                }
            });
            date = new DatePickerDialog.OnDateSetListener() {

                @Override
                public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {

                    myCalendar.set(Calendar.YEAR, year);
                    myCalendar.set(Calendar.MONTH, monthOfYear);
                    myCalendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                    updateLabel();
                }

            };

            cbx_Follow.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
//                    if (cbx_Follow.getText().toString().trim().equalsIgnoreCase("Follow")) {
//                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
//                            ((HomeActivity) getActivity()).showProgressDialog();
//
//                            JSONObject jsonObject = new JSONObject();
//                            try {
//
//                                jsonObject.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
//                                jsonObject.put("campaign_id", CAMPAING_ID);
//                                jsonObject.put("status", true);
//                            } catch (JSONException e) {
//                                e.printStackTrace();
//                            }
//                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FOLLOW_CAMPAIGN_TAG, Constants.FOLLOW_CAMPAIGN_URL, Constants.HTTP_POST, jsonObject,"Home Activity");
//                            a.execute();
//                        } else {
//                            ((HomeActivity) getActivity()).dismissProgressDialog();
//                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
//                        }
//                    } else {
//
//                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
//                            ((HomeActivity) getActivity()).showProgressDialog();
//
//                            JSONObject jsonObject = new JSONObject();
//                            try {
//
//                                jsonObject.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
//                                jsonObject.put("campaign_id", CAMPAING_ID);
//                                jsonObject.put("status", false);
//                            } catch (JSONException e) {
//                                e.printStackTrace();
//                            }
//                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FOLLOW_CAMPAIGN_TAG, Constants.FOLLOW_CAMPAIGN_URL, Constants.HTTP_POST, jsonObject,"Home Activity");
//                            a.execute();
//                        } else {
//                            ((HomeActivity) getActivity()).dismissProgressDialog();
//                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
//                        }
//
//                    }
                }
            });


            expandable_Summary.getViewTreeObserver().addOnPreDrawListener(
                    new ViewTreeObserver.OnPreDrawListener() {

                        @Override
                        public boolean onPreDraw() {
                            expandable_Summary.getViewTreeObserver().removeOnPreDrawListener(this);
                            expandable_Summary.setVisibility(View.GONE);

                            final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            final int heightSpec = View.MeasureSpec.makeMeasureSpec(et_summary.getHeight(), View.MeasureSpec.UNSPECIFIED);
                            System.out.println(heightSpec);
                            expandable_Summary.measure(widthSpec, heightSpec);

                            mAnimatorForSummary = slideAnimatorForSummary(0, expandable_Summary.getMeasuredHeight());
                            return true;
                        }
                    });

            expandable_playAudio.getViewTreeObserver().addOnPreDrawListener(
                    new ViewTreeObserver.OnPreDrawListener() {

                        @Override
                        public boolean onPreDraw() {
                            expandable_playAudio.getViewTreeObserver().removeOnPreDrawListener(this);
                            expandable_playAudio.setVisibility(View.GONE);

                            final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_audios.getHeight(), View.MeasureSpec.UNSPECIFIED);
                            System.out.println(heightSpec);
                            expandable_playAudio.measure(widthSpec, heightSpec);

                            mAnimatorForAudio = slideAnimatorForAudio(0, expandable_playAudio.getMeasuredHeight());
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
                            System.out.println(heightSpec);
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
                            System.out.println(heightSpec);
                            expandable_playVideo.measure(widthSpec, heightSpec);

                            mAnimatorForVideo = slideAnimatorForVideo(0, expandable_playVideo.getMeasuredHeight());
                            return true;
                        }
                    });


            roadmapGraphicexpandable.getViewTreeObserver().addOnPreDrawListener(
                    new ViewTreeObserver.OnPreDrawListener() {

                        @Override
                        public boolean onPreDraw() {
                            roadmapGraphicexpandable.getViewTreeObserver().removeOnPreDrawListener(this);
                            roadmapGraphicexpandable.setVisibility(View.GONE);

                            final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            final int heightSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            roadmapGraphicexpandable.measure(widthSpec, heightSpec);

                            mAnimator = slideAnimatorForRoadmapGraphic(0, roadmapGraphicexpandable.getMeasuredHeight());
                            return true;
                        }
                    });

            roadmapGraphic.setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(View v) {
                    if (roadmapGraphicexpandable.getVisibility() == View.GONE) {
                        viewroadmapGraphicArrow.setBackground(getResources().getDrawable(R.drawable.arrow_upward));
                        expandForRoadmapGraphic();
                    } else {
                        viewroadmapGraphicArrow.setBackground(getResources().getDrawable(R.drawable.arrow_downward));
                        collapseForRoadmapGraphic();
                    }
                }
            });





        return rootView;
    }

    private void expandForRoadmapGraphic() {
        //set Visible
        roadmapGraphicexpandable.setVisibility(View.VISIBLE);

		/* Remove and used in preDrawListener
        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
		final int heightSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
		mLinearLayout.measure(widthSpec, heightSpec);
		mAnimator = slideAnimator(0, mLinearLayout.getMeasuredHeight());
		*/

        mAnimator.start();
    }

    private void collapseForRoadmapGraphic() {
        try {
            int finalHeight = roadmapGraphicexpandable.getHeight();

            ValueAnimator mAnimator = slideAnimatorForRoadmapGraphic(finalHeight, 0);

            mAnimator.addListener(new Animator.AnimatorListener() {
                @Override
                public void onAnimationEnd(Animator animator) {
                    //Height=0, but it set visibility to GONE
                    roadmapGraphicexpandable.setVisibility(View.GONE);
                }

                @Override
                public void onAnimationStart(Animator animator) {
                }

                @Override
                public void onAnimationCancel(Animator animator) {
                }

                @Override
                public void onAnimationRepeat(Animator animator) {
                }
            });
            mAnimator.start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private ValueAnimator slideAnimatorForRoadmapGraphic(int start, int end) {

        ValueAnimator animator = ValueAnimator.ofInt(start, end);


        try {
            animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                @Override
                public void onAnimationUpdate(ValueAnimator valueAnimator) {
                    //Update Height
                    int value = (Integer) valueAnimator.getAnimatedValue();

                    ViewGroup.LayoutParams layoutParams = roadmapGraphicexpandable.getLayoutParams();
                    layoutParams.height = value;
                    roadmapGraphicexpandable.setLayoutParams(layoutParams);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return animator;
    }

    private ValueAnimator slideAnimatorForDocument(int start, int end) {

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

    private ValueAnimator slideAnimatorForSummary(int start, int end) {

        ValueAnimator animator = ValueAnimator.ofInt(start, end);


        try {
            animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                @Override
                public void onAnimationUpdate(ValueAnimator valueAnimator) {
                    //Update Height
                    int value = (Integer) valueAnimator.getAnimatedValue();

                    ViewGroup.LayoutParams layoutParams = expandable_Summary.getLayoutParams();
                    layoutParams.height = value;
                    expandable_Summary.setLayoutParams(layoutParams);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return animator;
    }

    private ValueAnimator slideAnimatorForAudio(int start, int end) {

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

    private ValueAnimator slideAnimatorForVideo(int start, int end) {

        ValueAnimator animator = ValueAnimator.ofInt(start, end);


        try {
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

    /**
     * update date of birth after change.
     */
    private void updateLabel() {

        try {
            SimpleDateFormat sdf = new SimpleDateFormat(Constants.DATE_FORMAT, Locale.US);
            et_dueDate.setText(sdf.format(myCalendar.getTime()));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void expandForSummary() {
        //set Visible
        try {
            expandable_Summary.setVisibility(View.VISIBLE);
            viewsummaryArrow.setBackground(getResources().getDrawable(R.drawable.arrow_upward));
            et_summary.requestFocus();
        /* Remove and used in preDrawListener
        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
		final int heightSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
		mLinearLayout.measure(widthSpec, heightSpec);
		mAnimator = slideAnimator(0, mLinearLayout.getMeasuredHeight());
		*/

            mAnimatorForSummary.start();
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void expandForDocument() {
        //set Visible
        try {
            expandable_viewDocument.setVisibility(View.VISIBLE);
            viewDocumentArrow.setBackground(getResources().getDrawable(R.drawable.arrow_upward));

            list_docs.setVisibility(View.VISIBLE);
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        //mAnimatorForDoc.start();
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


        // mAnimatorForVideo.start();
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

        // mAnimatorForAudio.start();
    }


    private void collapseForSummary() {
        try {
            int finalHeight = expandable_viewDocument.getHeight();
            viewsummaryArrow.setBackground(getResources().getDrawable(R.drawable.arrow_downward));
            ValueAnimator mAnimator = slideAnimatorForDocument(finalHeight, 0);

            mAnimator.addListener(new Animator.AnimatorListener() {
                @Override
                public void onAnimationEnd(Animator animator) {
                    //Height=0, but it set visibility to GONE
                    expandable_Summary.setVisibility(View.GONE);
                }

                @Override
                public void onAnimationStart(Animator animator) {
                }

                @Override
                public void onAnimationCancel(Animator animator) {
                }

                @Override
                public void onAnimationRepeat(Animator animator) {
                }
            });
            mAnimator.start();
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
                            System.out.println(heightSpec);
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
                            System.out.println(heightSpec);
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
                            System.out.println(heightSpec);
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


    @Override
    public void onClick(View v) {
        try {
            switch (v.getId()) {
                case R.id.btn_playAudio:
                    if (expandable_playAudio.getVisibility() == View.GONE) {
                        expandForAudio();
                    } else {
                        collapseForAudio();
                    }
                    break;
                case R.id.btn_playVideo:
                    if (expandable_playVideo.getVisibility() == View.GONE) {
                        expandForVideo();
                    } else {
                        collapseForVideo();
                    }
                    break;
                case R.id.btn_viewDocument:
                    if (expandable_viewDocument.getVisibility() == View.GONE) {
                        expandForDocument();
                    } else {
                        collapseForDoc();
                    }
                    break;
                case R.id.btn_summary:
                    if (expandable_Summary.getVisibility() == View.GONE) {
                        expandForSummary();
                    } else {
                        collapseForSummary();
                    }
                    break;

                case R.id.btn_commit:
//                    if (btn_commit.getText().toString().toString().equalsIgnoreCase("UnCommit")) {
//                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
//                            ((HomeActivity) getActivity()).showProgressDialog();
//                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNCOMMIT_CAMPAIGN_TAG, Constants.UNCOMMIT_CAMPAIGN_URL + "?campaign_id=" + CAMPAING_ID + "&user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
//                            a.execute();
//                        } else {
//                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
//                        }
//                    } else if (btn_commit.getText().toString().toString().equalsIgnoreCase("Commit")) {
//                        if (et_fundRaiseSoFor.getText().toString().compareTo(et_targetAmount.getText().toString()) == 0) {
//                            Toast.makeText(getActivity(), "Target Amount already Achieved.", Toast.LENGTH_LONG).show();
//
//                        } else {
//
//
//                            if (!((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(et_targetAmount.getText().toString().trim()).equalsIgnoreCase("0.00")) {
//                                Fragment rateContributor = new CampaignCommitFragment();
//
//                                Bundle bundle = new Bundle();
//                                bundle.putString("target_amount", et_targetAmount.getText().toString().trim());
//                                bundle.putString("fund_raised", et_fundRaiseSoFor.getText().toString().trim());
//                                bundle.putString("CAMPAIGN_NAME", titleText);
//                                bundle.putString("CAMPAIGN_ID", CAMPAING_ID);
//                                rateContributor.setArguments(bundle);
//                                ((HomeActivity) getActivity()).replaceFragment(rateContributor);
//                            } else {
//                                Toast.makeText(getActivity(), "Target amount of campaign is ZERO, So you cann't commit on this.", Toast.LENGTH_LONG).show();
//                            }
//                        }
//
//
//                        /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
//                        transactionRate.replace(R.id.container, rateContributor);
//                        transactionRate.addToBackStack(null);
//
//                        transactionRate.commit();*/
//                    }

                    // ((HomeActivity)getActivity()).replaceFragment(new CampaignCommitFragment(), false);
                    break;

                case R.id.btn_ViewDonators:
//                    Fragment viewDonators = new ViewContractorsFragment();
//
//
//                    Bundle bundleDonators = new Bundle();
//                    bundleDonators.putString("CAMPAIGN_NAME", titleText);
//                    bundleDonators.putString("CAMPAIGN_ID", CAMPAING_ID);
//                    bundleDonators.putString("CommingFrom", "CampaignDetails");
//                    viewDonators.setArguments(bundleDonators);
//                    /*FragmentTransaction viewDonatorsTransation = getFragmentManager().beginTransaction();
//                    viewDonatorsTransation.replace(R.id.container, viewDonators);
//                    viewDonatorsTransation.addToBackStack(null);
//
//                    viewDonatorsTransation.commit();*/
//                    ((HomeActivity) getActivity()).replaceFragment(viewDonators);
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
                if (tag.equalsIgnoreCase(Constants.DETAIL_ORGANIZATION_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();

                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                            JSONArray campaigndetail = jsonObject.getJSONArray("company_details");

                            et_campaignName.setText(campaigndetail.getJSONObject(0).optString("company_name"));
                            et_summary.setText(campaigndetail.getJSONObject(0).optString("company_description"));



                            DisplayImageOptions options = new DisplayImageOptions.Builder()
                                    .showImageOnLoading(R.drawable.forum_dummy_image)
                                    .showImageForEmptyUri(R.drawable.forum_dummy_image)
                                    .showImageOnFail(R.drawable.forum_dummy_image)
                                    .cacheInMemory(true)
                                    .cacheOnDisk(true)
                                    .considerExifParams(true)
                                    .bitmapConfig(Bitmap.Config.RGB_565)
                                    .build();

                            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + "/" + campaigndetail.getJSONObject(0).optString("company_image").trim(), image_roadmap, options);
                            //STARTUP_ID = Integer.parseInt(campaigndetail.optString("startup_id").trim());


                            StringBuilder stringBuilderCampaign = new StringBuilder();


                            if (campaigndetail.getJSONObject(0).has("company_keywords")) {
                                for (int i = 0; i < campaigndetail.getJSONObject(0).optJSONArray("company_keywords").length(); i++) {
                                    //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                    if ((i >= 0) && (i < (campaigndetail.getJSONObject(0).optJSONArray("company_keywords").length() - 1))) {
                                        stringBuilderCampaign.append(campaigndetail.getJSONObject(0).optJSONArray("company_keywords").getJSONObject(i).optString("name") + ", ");
                                    } else {
                                        stringBuilderCampaign.append(campaigndetail.getJSONObject(0).optJSONArray("company_keywords").getJSONObject(i).optString("name") + " ");

                                    }
                                }
                                et_campaignKeywords.setText("Company Keywords: " + stringBuilderCampaign.toString());
                            }


                            //keywords


                            audioObjectsList.clear();

                            AudioObject audioObject = new AudioObject();
                            audioObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + campaigndetail.getJSONObject(0).optString("company_audio").trim());
                            //   int a = audios_list.getJSONObject(i).getString("file").lastIndexOf("/");
                            audioObject.setName("Audio File");
                            audioObjectsList.add(audioObject);


                            list_audios.setAdapter(new AudioAdapter());
                            //UtilityList.setListViewHeightBasedOnChildren(list_audios);
                            //ListUtils.setDynamicHeight(list_audios);


                            videoObjectList.clear();

                            AudioObject VideoObject = new AudioObject();
                            VideoObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + campaigndetail.getJSONObject(0).optString("company_video").trim());
                            // int a = videos_list.getJSONObject(i).getString("file").lastIndexOf("/");
                            VideoObject.setName("Video File");
                            videoObjectList.add(VideoObject);

                            list_video.setAdapter(new VideoListAdapter());
                            //UtilityList.setListViewHeightBasedOnChildren(list_video);
                            //ListUtils.setDynamicHeight(list_video);

                            documentObjectList.clear();

                            AudioObject documentObject = new AudioObject();
                            documentObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + campaigndetail.getJSONObject(0).optString("company_document").trim());
                            //   int a = documents_list.getJSONObject(i).getString("file").lastIndexOf("/");
                            documentObject.setName("Document File" );
                            //Log.e("doc", Constants.APP_IMAGE_URL + "/" + documents_list.getJSONObject(i).getString("file").replaceAll(" ", "%20"));
                            documentObjectList.add(documentObject);


                            list_docs.setAdapter(new DocumentListAdapter());

                            UtilityList.setListViewHeightBasedOnChildren(list_docs);
                            UtilityList.setListViewHeightBasedOnChildren(list_audios);
                            UtilityList.setListViewHeightBasedOnChildren(list_video);
                            //docsListAdapter = new AudioListAdapter(getActivity(), documentObjectList);

                            //Toast.makeText(getActivity(), docsListAdapter.getCount() + "", Toast.LENGTH_LONG).show();
                            //list_docs.setAdapter(docsListAdapter);
                            // UtilityList.setListViewHeightBasedOnChildren(list_docs);
                            //ListUtils.setDynamicHeight(list_docs);


                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                }
            }
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    class DocumentListAdapter extends BaseAdapter {
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
                        /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*/
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
                        /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*/
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
                        /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*/
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
                        /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*/
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
                       /* FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*/
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
                        /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*/
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }
            return convertView;
        }
    }
}