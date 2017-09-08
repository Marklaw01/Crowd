package com.crowdbootstrap.fragments;

import android.animation.ValueAnimator;
import android.app.Activity;
import android.content.res.Resources;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.models.AudioObject;
import com.crowdbootstrap.utilities.AsyncNew;
import com.crowdbootstrap.utilities.Constants;
import com.crowdbootstrap.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by Neelmani.Karn on 1/11/2017.
 */
public class FundDetailFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    private AudioObject docObject, audioObject, videoObject;
    private LinearLayout layoutFundPostedBy;
    private String calledFragment;
    private Bundle bundle;
    private String fund_id;
    private TextView cbx_Follow, cbx_Like;
    private EditText et_postedBy, et_title, et_fundDescription, et_fundManagers, et_fundsponsers, et_industry, et_portfolio, et_investmentStartDate, et_investmentEndDate, et_fundsClosedDate, et_keywords;
    private ImageView image_roadmap;

    private ImageView viewDocumentArrow, viewplayAudioArrow, viewplayVideoArrow;
    private LinearLayout btn_playAudio, btn_viewDocument, btn_playVideo;
    private LinearLayout expandable_playAudio, expandable_viewDocument, expandable_playVideo;

    private ValueAnimator mAnimatorForDoc, mAnimatorForAudio, mAnimatorForVideo;
    private TextView list_audios, list_docs, list_video;

    public FundDetailFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
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

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fund_detail_fragment, container, false);

        image_roadmap = (ImageView) rootView.findViewById(R.id.image_roadmap);
        layoutFundPostedBy = (LinearLayout) rootView.findViewById(R.id.layoutFundPostedBy);
        if (calledFragment.equals(Constants.FIND_FUND_TAG)) {
            layoutFundPostedBy.setVisibility(View.VISIBLE);
        } else {
            layoutFundPostedBy.setVisibility(View.GONE);
        }
        list_audios = (TextView) rootView.findViewById(R.id.list_audios);
        list_docs = (TextView) rootView.findViewById(R.id.list_docs);
        list_video = (TextView) rootView.findViewById(R.id.list_video);
        cbx_Follow = (TextView) rootView.findViewById(R.id.cbx_Follow);
        cbx_Like = (TextView) rootView.findViewById(R.id.cbx_Like);


        et_postedBy = (EditText) rootView.findViewById(R.id.et_postedBy);
        et_title = (EditText) rootView.findViewById(R.id.et_fundTitle);
        et_fundDescription = (EditText) rootView.findViewById(R.id.et_fundDescription);
        et_fundManagers = (EditText) rootView.findViewById(R.id.et_fundManagers);
        et_fundsClosedDate = (EditText) rootView.findViewById(R.id.et_fundsClosedDate);
        et_fundsponsers = (EditText) rootView.findViewById(R.id.et_fundsponsers);
        et_investmentEndDate = (EditText) rootView.findViewById(R.id.et_investmentEndDate);
        et_industry = (EditText) rootView.findViewById(R.id.et_industry);
        et_keywords = (EditText) rootView.findViewById(R.id.et_keywords);
        et_portfolio = (EditText) rootView.findViewById(R.id.et_portfolio);
        et_investmentStartDate = (EditText) rootView.findViewById(R.id.et_investmentStartDate);


        expandable_playAudio = (LinearLayout) rootView.findViewById(R.id.expandable_playAudio);
        expandable_playVideo = (LinearLayout) rootView.findViewById(R.id.expandable_playVideo);
        expandable_viewDocument = (LinearLayout) rootView.findViewById(R.id.expandable_viewDocument);

        btn_playAudio = (LinearLayout) rootView.findViewById(R.id.btn_playAudio);
        btn_playVideo = (LinearLayout) rootView.findViewById(R.id.btn_playVideo);
        btn_viewDocument = (LinearLayout) rootView.findViewById(R.id.btn_viewDocument);

        viewDocumentArrow = (ImageView) rootView.findViewById(R.id.viewDocumentArrow);
        viewplayAudioArrow = (ImageView) rootView.findViewById(R.id.viewplayAudioArrow);
        viewplayVideoArrow = (ImageView) rootView.findViewById(R.id.viewplayVideoArrow);

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

        list_audios.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (audioObject!=null){
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
                if (docObject!=null){
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
                if (videoObject!=null){
                    Fragment rateContributor = new WebViewFragment();


                    Bundle bundle = new Bundle();

                    bundle.putString("url", videoObject.getAudioUrl());
                    rateContributor.setArguments(bundle);
                    ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                }

            }
        });




        funDetials();
        return rootView;
    }

    private void funDetials() {
        try {
            if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                JSONObject object = new JSONObject();
                object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                object.put("fund_id", fund_id);
                AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FUND_DETAILS_TAG, Constants.FUND_DETAILS_URL, Constants.HTTP_POST_REQUEST, object);
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
            case R.id.cbx_Like:
                if (cbx_Like.getText().toString().trim().equals("Like")) {
                    try {
                        JSONObject likeObj = new JSONObject();
                        likeObj.put("like_by", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                        likeObj.put("fund_id", fund_id);
                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            AsyncNew asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FUND_LIKE_TAG, Constants.FUND_LIKE_URL, Constants.HTTP_POST_REQUEST, likeObj);
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
                        likeObj.put("fund_id", fund_id);
                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            AsyncNew asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FUND_DISLIKE_TAG, Constants.FUND_DISLIKE_URL, Constants.HTTP_POST_REQUEST, likeObj);
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
                    followObj.put("fund_id", fund_id);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                    if (cbx_Follow.getText().toString().trim().equalsIgnoreCase("Follow")) {
                        ((HomeActivity) getActivity()).showProgressDialog();
                        AsyncNew asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FUND_FOLLOW_TAG, Constants.FUND_FOLLOW_URL, Constants.HTTP_POST_REQUEST, followObj);
                        asyncNew.execute();
                    } else {
                        ((HomeActivity) getActivity()).showProgressDialog();
                        AsyncNew asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FUND_UNFOLLOW_TAG, Constants.FUND_UNFOLLOW_URL, Constants.HTTP_POST_REQUEST, followObj);
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
            if (tag.equals(Constants.FUND_FOLLOW_TAG)) {
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

            } else if (tag.equals(Constants.FUND_LIKE_TAG)) {
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

            } else if (tag.equals(Constants.FUND_DISLIKE_TAG)) {
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

            } else if (tag.equals(Constants.FUND_UNFOLLOW_TAG)) {
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

            } else if (tag.equals(Constants.FUND_DETAILS_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        et_postedBy.setText(jsonObject.getString("fund_created_by"));
                        et_investmentStartDate.setText(jsonObject.getString("fund_start_date"));
                        et_fundDescription.setText(jsonObject.getString("fund_description"));
                        et_investmentEndDate.setText(jsonObject.getString("fund_end_date"));
                        et_fundsClosedDate.setText(jsonObject.getString("fund_close_date"));
                        et_title.setText(jsonObject.getString("fund_title"));

                        if (!jsonObject.getString("fund_document").isEmpty()) {
                            docObject = new AudioObject();
                            docObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + jsonObject.getString("fund_document"));
                            int a = jsonObject.getString("fund_document").lastIndexOf("/");
                            docObject.setOrignalName(jsonObject.getString("fund_document").substring(a + 1));
                            docObject.setName("Document 1");
                            list_docs.setText(docObject.getName());
                        } else {
                            expandable_viewDocument.setVisibility(View.GONE);
                        }
                        if (!jsonObject.getString("fund_video").isEmpty()) {
                            videoObject = new AudioObject();
                            videoObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + jsonObject.getString("fund_video"));
                            int a = jsonObject.getString("fund_video").lastIndexOf("/");
                            videoObject.setOrignalName(jsonObject.getString("fund_video").substring(a + 1));
                            videoObject.setName("Video 1");
                            list_video.setText(videoObject.getName());
                        } else {
                            expandable_playVideo.setVisibility(View.GONE);
                        }

                        if (!jsonObject.getString("fund_audio").isEmpty()) {
                            audioObject = new AudioObject();
                            audioObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + jsonObject.getString("fund_audio"));
                            int a = jsonObject.getString("fund_audio").lastIndexOf("/");
                            audioObject.setOrignalName(jsonObject.getString("fund_audio").substring(a + 1));
                            audioObject.setName("Audio 1");
                            list_audios.setText(audioObject.getName());
                        } else {
                            expandable_playAudio.setVisibility(View.GONE);
                        }

                        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.getString("fund_image"), image_roadmap);
                        if (jsonObject.has("fund_mangers")) {
                            StringBuilder sb = new StringBuilder();
                            for (int i = 0; i < jsonObject.getJSONArray("fund_mangers").length(); i++) {
                                if (sb.length() > 0) {
                                    sb.append(", ");
                                }
                                sb.append(jsonObject.getJSONArray("fund_mangers").getJSONObject(i).getString("name"));
                            }
                            et_fundManagers.setText(sb.toString());
                        }

                        if (jsonObject.has("fund_sponsors")) {
                            StringBuilder sb = new StringBuilder();
                            for (int i = 0; i < jsonObject.getJSONArray("fund_sponsors").length(); i++) {
                                if (sb.length() > 0) {
                                    sb.append(", ");
                                }
                                sb.append(jsonObject.getJSONArray("fund_sponsors").getJSONObject(i).getString("name"));
                            }
                            et_fundsponsers.setText(sb.toString());
                        }
                        if (jsonObject.has("fund_portfolios")) {
                            StringBuilder sb = new StringBuilder();
                            for (int i = 0; i < jsonObject.getJSONArray("fund_portfolios").length(); i++) {
                                if (sb.length() > 0) {
                                    sb.append(", ");
                                }
                                sb.append(jsonObject.getJSONArray("fund_portfolios").getJSONObject(i).getString("name"));
                            }
                            et_portfolio.setText(sb.toString());
                        }

                        if (jsonObject.has("fund_industries")) {
                            StringBuilder sb = new StringBuilder();
                            for (int i = 0; i < jsonObject.getJSONArray("fund_industries").length(); i++) {
                                if (sb.length() > 0) {
                                    sb.append(", ");
                                }
                                sb.append(jsonObject.getJSONArray("fund_industries").getJSONObject(i).getString("name"));
                            }
                            et_industry.setText(sb.toString());
                        }

                        if (jsonObject.has("fund_keywords")) {
                            StringBuilder sb = new StringBuilder();
                            for (int i = 0; i < jsonObject.getJSONArray("fund_keywords").length(); i++) {
                                if (sb.length() > 0) {
                                    sb.append(", ");
                                }
                                sb.append(jsonObject.getJSONArray("fund_keywords").getJSONObject(i).getString("name"));
                            }
                            et_keywords.setText(sb.toString());
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
                        Toast.makeText(getActivity(), getString(R.string.noFunds), Toast.LENGTH_LONG).show();
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
}
