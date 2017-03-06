package com.crowdbootstrap.fragments;

import android.animation.Animator;
import android.animation.ValueAnimator;
import android.app.AlertDialog;
import android.content.DialogInterface;
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
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.models.AudioObject;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;
import com.crowdbootstrap.utilities.UtilityList;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 12/6/2016.
 */
public class JobDetailsFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    private EditText companyName;
    private EditText countrycity;
    private EditText jobTitle;
    private EditText jobRole;
    private EditText jobType;
    private EditText minimumWorkNPS;
    private EditText location;
    private EditText travel;
    private EditText startDate, endDate;
    private EditText skills;
    private EditText jobKeywords;
    private EditText jobRequirements;
    private EditText jobSummary;
    private ImageView companyImage;
    private EditText industry;
    private EditText postedBy;


    private ImageView viewDocumentArrow, viewplayAudioArrow, viewplayVideoArrow, viewsummaryArrow, viewroadmapGraphicArrow, image_roadmap;
    private LinearLayout btn_playAudio, btn_viewDocument, btn_playVideo, btn_summary;

    private LinearLayout expandable_playAudio, expandable_viewDocument, expandable_playVideo, expandable_Summary, roadmapGraphiclayout, roadmapGraphic, roadmapGraphicexpandable;
    private ValueAnimator mAnimatorForDoc, mAnimatorForAudio, mAnimatorForVideo, mAnimatorForSummary;
    private ListView list_audios, list_docs, list_video;
    private ArrayList<AudioObject> audioObjectsList, documentObjectList, videoObjectList;
    private static String CAMPAING_ID;
    private ValueAnimator mAnimator;
    private String titleText;
    private TextView cbx_Follow;
    private String commingFrom;
    private Button btn_Apply;
    private String posted_by_userID;

    public JobDetailsFragment() {
        super();
    }


    @Override
    public void onResume() {
        super.onResume();
        //getArguments().getString("CAMPAIGN_NAME");
        try {
            titleText = getArguments().getString("JOB_TITLE");

            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            ((HomeActivity) getActivity()).setActionBarTitle(getArguments().getString("JOB_TITLE"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.job_description_layout, container, false);

        companyName = (EditText) rootView.findViewById(R.id.et_companyName);
        countrycity = (EditText) rootView.findViewById(R.id.et_citycountry);
        jobTitle = (EditText) rootView.findViewById(R.id.et_jobtitle);
        jobRole = (EditText) rootView.findViewById(R.id.et_role);
        jobType = (EditText) rootView.findViewById(R.id.et_jobType);
        minimumWorkNPS = (EditText) rootView.findViewById(R.id.et_minworkNPS);
        location = (EditText) rootView.findViewById(R.id.et_location);
        travel = (EditText) rootView.findViewById(R.id.et_travel);
        startDate = (EditText) rootView.findViewById(R.id.et_startDate);
        endDate = (EditText) rootView.findViewById(R.id.et_endDate);
        skills = (EditText) rootView.findViewById(R.id.et_skills);
        jobKeywords = (EditText) rootView.findViewById(R.id.et_jobPostingKeywords);
        jobRequirements = (EditText) rootView.findViewById(R.id.et_requirements);
        jobSummary = (EditText) rootView.findViewById(R.id.et_summary);
        industry = (EditText) rootView.findViewById(R.id.et_industry);
        companyImage = (ImageView) rootView.findViewById(R.id.image_roadmap);
        postedBy = (EditText) rootView.findViewById(R.id.et_postedBy);
        btn_Apply = (Button) rootView.findViewById(R.id.btn_apply);
        cbx_Follow = (TextView) rootView.findViewById(R.id.cbx_Follow);


        CAMPAING_ID = getArguments().getString("JOB_ID");
        commingFrom = getArguments().getString("FROM");

        if (commingFrom.compareTo("JOBS") == 0) {
            btn_Apply.setVisibility(View.VISIBLE);
            cbx_Follow.setVisibility(View.VISIBLE);
            btn_Apply.setText("Apply");

        } else if (commingFrom.compareTo("ARCHIVED") == 0) {
            btn_Apply.setVisibility(View.GONE);
            cbx_Follow.setVisibility(View.GONE);

        } else if (commingFrom.compareTo("DEACTIVATED") == 0) {
            btn_Apply.setVisibility(View.VISIBLE);
            cbx_Follow.setVisibility(View.GONE);
            btn_Apply.setText("Activate");

        }

        audioObjectsList = new ArrayList<AudioObject>();
        videoObjectList = new ArrayList<AudioObject>();
        documentObjectList = new ArrayList<AudioObject>();


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

        btn_playAudio = (LinearLayout) rootView.findViewById(R.id.btn_playAudio);
        btn_playVideo = (LinearLayout) rootView.findViewById(R.id.btn_playVideo);
        btn_viewDocument = (LinearLayout) rootView.findViewById(R.id.btn_viewDocument);
        btn_summary = (LinearLayout) rootView.findViewById(R.id.btn_summary);

        viewDocumentArrow = (ImageView) rootView.findViewById(R.id.viewDocumentArrow);
        viewplayAudioArrow = (ImageView) rootView.findViewById(R.id.viewplayAudioArrow);
        viewplayVideoArrow = (ImageView) rootView.findViewById(R.id.viewplayVideoArrow);
        viewsummaryArrow = (ImageView) rootView.findViewById(R.id.viewsummaryArrow);


        postedBy.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!postedBy.getText().toString().isEmpty()) {

                    try {
                        Fragment addContributor = new ViewContractorPublicProfileFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("COMMING_FROM", "CAMPAIGNS");
                        bundle.putString("id", posted_by_userID);

                        addContributor.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(addContributor);
            /*FragmentTransaction transactionAdd = getFragmentManager().beginTransaction();
            transactionAdd.replace(R.id.container, addContributor);
            transactionAdd.addToBackStack(null);

            transactionAdd.commit();*/
                    } catch (Exception e) {
                        e.printStackTrace();
                    }


                }
            }
        });

        cbx_Follow.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (cbx_Follow.getText().toString().trim().equalsIgnoreCase("Follow")) {
                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        JSONObject jsonObject = new JSONObject();
                        try {

                            jsonObject.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            jsonObject.put("job_id", CAMPAING_ID);

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FOLLOW_JOB_TAG, Constants.FOLLOW_JOB_URL, Constants.HTTP_POST, jsonObject, "Home Activity");
                        a.execute();
                    } else {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else if (cbx_Follow.getText().toString().trim().equalsIgnoreCase("UnFollow")) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        JSONObject jsonObject = new JSONObject();
                        try {

                            jsonObject.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            jsonObject.put("job_id", CAMPAING_ID);

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UN_FOLLOW_JOB_TAG, Constants.UN_FOLLOW_JOB_URL, Constants.HTTP_POST, jsonObject, "Home Activity");
                        a.execute();
                    } else {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });


        btn_playAudio.setOnClickListener(this);
        btn_viewDocument.setOnClickListener(this);
        btn_playVideo.setOnClickListener(this);
        btn_summary.setOnClickListener(this);
        btn_Apply.setOnClickListener(this);


        jobSummary.setOnTouchListener(new View.OnTouchListener() {
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


        expandable_Summary.getViewTreeObserver().addOnPreDrawListener(
                new ViewTreeObserver.OnPreDrawListener() {

                    @Override
                    public boolean onPreDraw() {
                        expandable_Summary.getViewTreeObserver().removeOnPreDrawListener(this);
                        expandable_Summary.setVisibility(View.GONE);

                        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                        final int heightSpec = View.MeasureSpec.makeMeasureSpec(jobSummary.getHeight(), View.MeasureSpec.UNSPECIFIED);
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


        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.JOB_DETAILS_TAG, Constants.JOB_DETAILS_URL + "?job_id=" + CAMPAING_ID + "&user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET, "Home Activity");
            a.execute();

        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }


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


    private void expandForSummary() {
        //set Visible
        try {
            expandable_Summary.setVisibility(View.VISIBLE);
            viewsummaryArrow.setBackground(getResources().getDrawable(R.drawable.arrow_upward));
            jobSummary.requestFocus();
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
            int finalHeight = expandable_Summary.getMeasuredHeight();
            viewsummaryArrow.setBackground(getResources().getDrawable(R.drawable.arrow_downward));
            ValueAnimator mAnimator = slideAnimatorForSummary(finalHeight, 0);

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

    private boolean followChecked = false;

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
                if (tag.equalsIgnoreCase(Constants.JOB_DETAILS_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();

                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                            JSONObject campaigndetail = jsonObject.getJSONObject("job_details");
                            postedBy.setText("Posted By: " + campaigndetail.optString("posted_by"));
                            companyName.setText("Company Name: " + campaigndetail.optString("company_name"));
                            countrycity.setText("State: " + campaigndetail.optString("state").trim() + ", " + campaigndetail.optString("country").trim());
                            jobTitle.setText("Job Title: " + campaigndetail.optString("job_title").trim());
                            jobRole.setText("Job Role: " + campaigndetail.optString("role").trim());
                            jobType.setText("Job Type: " + campaigndetail.optString("job_type").trim());
                            minimumWorkNPS.setText("Minimum Work NPS: " + campaigndetail.optString("min_work_nps").trim());
                            location.setText("Location: " + campaigndetail.optString("location").trim());
                            travel.setText("Travel: " + campaigndetail.optString("travel").trim());
                            startDate.setText("Start Date: " + campaigndetail.optString("start_date").trim());
                            endDate.setText("End Date: " + campaigndetail.optString("end_date").trim());
                            jobRequirements.setText("Requirement: " + campaigndetail.optString("requirements").trim());
                            jobSummary.setText(campaigndetail.optString("description").trim());
                            posted_by_userID = campaigndetail.optString("posted_by_userid").trim();

                            DisplayImageOptions options = new DisplayImageOptions.Builder()
                                    .showImageOnLoading(R.drawable.forum_dummy_image)
                                    .showImageForEmptyUri(R.drawable.forum_dummy_image)
                                    .showImageOnFail(R.drawable.forum_dummy_image)
                                    .cacheInMemory(true)
                                    .cacheOnDisk(true)
                                    .considerExifParams(true)
                                    .bitmapConfig(Bitmap.Config.RGB_565)
                                    .build();

                            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + "/" + campaigndetail.optString("company_image").trim(), image_roadmap, options);
                            //STARTUP_ID = Integer.parseInt(campaigndetail.optString("startup_id").trim());
                            if (campaigndetail.getString("is_follwed_by_user").trim().equalsIgnoreCase("0")) {
                                followChecked = false;
                                cbx_Follow.setText("Follow");
                                cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                                //cbx_Follow.setChecked(false);

                            } else {
                                followChecked = true;
                                cbx_Follow.setText("Unfollow");
                                cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                                // cbx_Follow.setChecked(true);
                            }


                            StringBuilder stringBuilder = new StringBuilder();
                            StringBuilder stringBuilderCampaign = new StringBuilder();

                            if (campaigndetail.has("skills")) {
                                for (int i = 0; i < campaigndetail.optJSONArray("skills").length(); i++) {
                                    //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                    if ((i >= 0) && (i < (campaigndetail.optJSONArray("skills").length() - 1))) {
                                        stringBuilder.append(campaigndetail.optJSONArray("skills").getJSONObject(i).optString("name") + ", ");
                                    } else {
                                        stringBuilder.append(campaigndetail.optJSONArray("skills").getJSONObject(i).optString("name") + " ");
                                    }
                                }
                                skills.setText("Skills: " + stringBuilder.toString());
                            }


                            if (campaigndetail.has("posting_keywords")) {
                                for (int i = 0; i < campaigndetail.optJSONArray("posting_keywords").length(); i++) {
                                    //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                    if ((i >= 0) && (i < (campaigndetail.optJSONArray("posting_keywords").length() - 1))) {
                                        stringBuilderCampaign.append(campaigndetail.optJSONArray("posting_keywords").getJSONObject(i).optString("name") + ", ");
                                    } else {
                                        stringBuilderCampaign.append(campaigndetail.optJSONArray("posting_keywords").getJSONObject(i).optString("name") + " ");

                                    }
                                }
                                jobKeywords.setText("Job Search Keywords: " + stringBuilderCampaign.toString());
                            }


                            if (campaigndetail.has("job_industry")) {
                                for (int i = 0; i < campaigndetail.optJSONArray("job_industry").length(); i++) {
                                    //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                    if ((i >= 0) && (i < (campaigndetail.optJSONArray("job_industry").length() - 1))) {
                                        stringBuilderCampaign.append(campaigndetail.optJSONArray("job_industry").getJSONObject(i).optString("name") + ", ");
                                    } else {
                                        stringBuilderCampaign.append(campaigndetail.optJSONArray("job_industry").getJSONObject(i).optString("name") + " ");

                                    }
                                }
                                industry.setText("Industry Keywords: " + stringBuilderCampaign.toString());
                            }

                            //keywords


                            audioObjectsList.clear();

                            AudioObject audioObject = new AudioObject();
                            audioObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + campaigndetail.optString("audio"));
                            //   int a = audios_list.getJSONObject(i).getString("file").lastIndexOf("/");
                            audioObject.setName("Audio " + (1));
                            audioObjectsList.add(audioObject);


                            list_audios.setAdapter(new AudioAdapter());
                            //UtilityList.setListViewHeightBasedOnChildren(list_audios);
                            //ListUtils.setDynamicHeight(list_audios);


                            videoObjectList.clear();

                            AudioObject videoObject = new AudioObject();
                            videoObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + campaigndetail.optString("video"));
                            // int a = videos_list.getJSONObject(i).getString("file").lastIndexOf("/");
                            videoObject.setName("Video " + (1));
                            videoObjectList.add(videoObject);

                            list_video.setAdapter(new VideoListAdapter());
                            //UtilityList.setListViewHeightBasedOnChildren(list_video);
                            //ListUtils.setDynamicHeight(list_video);


                            documentObjectList.clear();

                            AudioObject documentObject = new AudioObject();
                            documentObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + campaigndetail.optString("document"));
                            //   int a = documents_list.getJSONObject(i).getString("file").lastIndexOf("/");
                            documentObject.setName("Document " + (1));
                            //Log.e("doc", Constants.APP_IMAGE_URL + "/" + documents_list.getJSONObject(i).getString("file").replaceAll(" ", "%20"));
                            documentObjectList.add(documentObject);


                            list_docs.setAdapter(new DocumentListAdapter());

                            UtilityList.setListViewHeightBasedOnChildren(list_docs);
                            UtilityList.setListViewHeightBasedOnChildren(list_audios);
                            UtilityList.setListViewHeightBasedOnChildren(list_video);


                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                } else if (tag.equalsIgnoreCase(Constants.ACTIVATE_JOB_TAG)) {

                    ((HomeActivity) getActivity()).dismissProgressDialog();

                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_LONG).show();
                            getActivity().onBackPressed();

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_LONG).show();
                        }
                    } catch (Exception e) {

                    }
                } else if (tag.equalsIgnoreCase(Constants.FOLLOW_JOB_TAG)) {

                    ((HomeActivity) getActivity()).dismissProgressDialog();

                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            cbx_Follow.setText("UnFollow");
                            followChecked = true;

                            cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGrey));


                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_LONG).show();
                        }
                    } catch (Exception e) {

                    }
                } else if (tag.equalsIgnoreCase(Constants.UN_FOLLOW_JOB_TAG)) {

                    ((HomeActivity) getActivity()).dismissProgressDialog();

                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {


                            cbx_Follow.setText("Follow");
                            cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                            followChecked = false;

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_LONG).show();
                        }
                    } catch (Exception e) {

                    }
                }
            }
        } catch (Exception e) {


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


                case R.id.btn_apply:
                    if (commingFrom.compareTo("DEACTIVATED") == 0) {

                        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                        alertDialogBuilder
                                .setMessage("Do you want to activate this Job again?")
                                .setCancelable(false)
                                .setNegativeButton("No", new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int arg1) {
                                        dialog.cancel();
                                    }
                                })
                                .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                    @Override
                                    public void onClick(DialogInterface dialog, int arg1) {
                                        dialog.cancel();
                                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                            ((HomeActivity) getActivity()).showProgressDialog();
                                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ACTIVATE_JOB_TAG, Constants.ACTIVATE_JOB_URL + "?job_id=" + CAMPAING_ID, Constants.HTTP_GET, "Home Activity");
                                            a.execute();
                                        } else {
                                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                        }


                                    }
                                });

                        AlertDialog alertDialog = alertDialogBuilder.create();

                        alertDialog.show();
                    } else if (commingFrom.compareTo("JOBS") == 0) {

                        Fragment applyForJob = new ApplyJobsFragment();

                        Bundle bundle = new Bundle();
                        bundle.putString("JOB_TITLE",titleText);
                        bundle.putString("JOB_ID", CAMPAING_ID);
                        applyForJob.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(applyForJob);
                    }
                    break;
            }
        } catch (Exception e) {

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
