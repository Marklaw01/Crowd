package com.crowdbootstrapapp.fragments;

import android.app.Dialog;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.adapter.ReportAbuseUserAdapter;
import com.crowdbootstrapapp.helper.ListViewForEmbeddingInScrollView;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.models.UserCommentObject;
import com.crowdbootstrapapp.utilities.Async;
import com.crowdbootstrapapp.utilities.Constants;
import com.crowdbootstrapapp.utilities.DateTimeFormatClass;
import com.crowdbootstrapapp.utilities.UtilityList;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.listener.SimpleImageLoadingListener;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;

/**
 * Created by neelmani.karn on 1/18/2016.
 */
public class ForumDetailsFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    private int forum_status = 0;
    private String commingFrom = "";
    private ScrollView sv;
    private ArrayList<UserCommentObject> list, reportAbuseList;
    private TextView tv_forumTitle, tv_forumCreater, tv_forumDescription, tv_seeAllComments;
    ImageView tv_reportAbuse;
    private ImageView image_forum;
    private ListViewForEmbeddingInScrollView list_comments;

    private EditText et_comment;
    private Button btn_postComment;
    private LinearLayout commentLayout;
    private String forum_id = "";
    ProgressBar progressBar;

    public ForumDetailsFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        try {
            ((HomeActivity) getActivity()).setActionBarTitle(getArguments().getString("TITLE"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_forum_details, container, false);
        try {
            forum_id = getArguments().getString("forum_id");
            progressBar = (ProgressBar) rootView.findViewById(R.id.progressBar);

            commingFrom = getArguments().getString("COMMING_FROM");
            System.out.println("commingFrom " + commingFrom);
            sv = (ScrollView) rootView.findViewById(R.id.sv);
            tv_forumTitle = (TextView) rootView.findViewById(R.id.tv_forumTitle);
            tv_forumCreater = (TextView) rootView.findViewById(R.id.tv_forumCreater);
            tv_forumDescription = (TextView) rootView.findViewById(R.id.tv_forumDescription);
            tv_reportAbuse = (ImageView) rootView.findViewById(R.id.tv_reportAbuse);
            commentLayout = (LinearLayout) rootView.findViewById(R.id.commentLayout);
            image_forum = (ImageView) rootView.findViewById(R.id.image_forum);
            list_comments = (ListViewForEmbeddingInScrollView) rootView.findViewById(R.id.list_comments);
            et_comment = (EditText) rootView.findViewById(R.id.et_comment);
            btn_postComment = (Button) rootView.findViewById(R.id.btn_postComment);

            tv_seeAllComments = (TextView) rootView.findViewById(R.id.tv_seeAllComments);
            // tv_forumDescription.setMovementMethod(new ScrollingMovementMethod());

            list = new ArrayList<UserCommentObject>();
            reportAbuseList = new ArrayList<UserCommentObject>();


            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FORUMS_DETAILS_TAG, Constants.FORUMS_DETAILS_URL + "?forum_id=" + forum_id, Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }


            btn_postComment.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (!et_comment.getText().toString().trim().isEmpty()) {
                        JSONObject comment = new JSONObject();
                        try {
                            comment.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            comment.put("forum_id", forum_id);
                            comment.put("comment", et_comment.getText().toString().trim());
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }


                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();

                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ADD_FORUMS_COMMENT_TAG, Constants.ADD_FORUMS_COMMENT_URL, Constants.HTTP_POST, comment, "Home Activity");
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    }
                }
            });


            tv_seeAllComments.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Fragment addContributor = new CommentsFragment();

                    Bundle bundle = new Bundle();

                    bundle.putString("forum_id", forum_id);

                    addContributor.setArguments(bundle);
                    ((HomeActivity)getActivity()).replaceFragment(addContributor);
                    /*FragmentTransaction transactionAdd = getFragmentManager().beginTransaction();
                    transactionAdd.replace(R.id.container, addContributor);
                    transactionAdd.addToBackStack(null);

                    transactionAdd.commit();*/
                }
            });


       /* tv_forumDescription.setOnTouchListener(new View.OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {

               v.getParent().requestDisallowInterceptTouchEvent(true);

                return false;
            }
        });*/
            et_comment.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(final View v, final MotionEvent motionEvent) {
                    if (v.getId() == R.id.et_comment) {
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

            if (commingFrom.equalsIgnoreCase("MyForums")) {
                tv_reportAbuse.setVisibility(View.VISIBLE);
                commentLayout.setVisibility(View.VISIBLE);
            } else if (commingFrom.equalsIgnoreCase("Archived_Forums")) {
                tv_reportAbuse.setVisibility(View.GONE);
                commentLayout.setVisibility(View.GONE);
            } else {
                tv_reportAbuse.setVisibility(View.VISIBLE);
                commentLayout.setVisibility(View.VISIBLE);
            }

            tv_reportAbuse.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

//                    if (reportAbuseList.size() == 0) {
//                        Toast.makeText(getActivity(), "No other user commented yet.", Toast.LENGTH_SHORT).show();
//                    } else {
                        final Dialog dialog = new Dialog(getActivity());
                        dialog.setContentView(R.layout.report_abuse_dialog);
                        dialog.setTitle(getArguments().getString("TITLE"));
                        final CheckBox forumName = (CheckBox) dialog.findViewById(R.id.text_forumName);
                        final TextView textView = (TextView) dialog.findViewById(R.id.textview);
                        final View view = (View) dialog.findViewById(R.id.view);
                        final EditText et_report = (EditText) dialog.findViewById(R.id.et_reportabuse);
                        if (commingFrom.equalsIgnoreCase("MyForums")) {
                            forumName.setVisibility(View.GONE);
                            view.setVisibility(View.GONE);
                            textView.setVisibility(View.GONE);

                        } else {
                            forumName.setVisibility(View.VISIBLE);
                            view.setVisibility(View.VISIBLE);
                            textView.setVisibility(View.VISIBLE);

                        }

                        forumName.setText(getArguments().getString("TITLE"));

                        final ListView lv = (ListView) dialog.findViewById(R.id.listKeywords);
                        lv.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);
                        for (int i = 0; i < list.size(); i++) {
                            list.get(i).setChecked(false);
                        }
                        final ReportAbuseUserAdapter adapter = new ReportAbuseUserAdapter(getActivity(), 0, reportAbuseList);
                        lv.setAdapter(adapter);

                        Button dialogButtonOK = (Button) dialog.findViewById(R.id.buttonOK);
                        Button dialogButtonCancel = (Button) dialog.findViewById(R.id.buttonCancel);
                        dialogButtonOK.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {

                                if (adapter != null) {

                                    if(et_report.getText().toString().compareTo("") == 0)
                                    {
                                        Toast.makeText(getActivity(), "Comment section cannot be left empty!", Toast.LENGTH_LONG).show();
                                    }
                                    else if(adapter.getCheckedItems().size() <= 0)
                                    {
                                        Toast.makeText(getActivity(), "You have to select a user to Report Abuse!", Toast.LENGTH_LONG).show();
                                    }
                                    else {

                                        ArrayList<UserCommentObject> mArrayProducts = adapter.getCheckedItems();

                                        JSONObject report = new JSONObject();
                                        try {
                                            report.put("comment", et_report.getText().toString().trim());
                                            JSONArray userArray = new JSONArray();
                                            for (int i = 0; i < mArrayProducts.size(); i++) {
                                                JSONObject user = new JSONObject();
                                                user.put("userId", mArrayProducts.get(i).getId());
                                                //user.put("userName", mArrayProducts.get(i).getUserName());
                                                userArray.put(i, user);
                                            }
                                   /* if (commingFrom.equalsIgnoreCase("MyForums")) {
                                        report.put("isForumMine", true);
                                    } else {
                                        report.put("isForumMine", false);
                                    }*/
                                            report.put("reported_users", userArray);
                                            report.put("forum_id", forum_id);
                                            report.put("is_form_reported", forumName.isChecked());
                                            report.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));

                                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                                ((HomeActivity) getActivity()).showProgressDialog();

                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FORUMS_REPORT_ABUSE_TAG, Constants.FORUMS_REPORT_ABUSE_URL, Constants.HTTP_POST, report,"Home Activity");
                                                a.execute();
                                            } else {
                                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                            }

                                        } catch (JSONException e) {
                                            e.printStackTrace();
                                        }

                                        System.out.println(report);
                                        dialog.dismiss();
                                    }
                                }


                            }
                        });

                        dialogButtonCancel.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                dialog.dismiss();
                            }
                        });
                        dialog.show();
                    }
//                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootView;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_postComment:
                break;
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
                if (tag.equalsIgnoreCase(Constants.FORUMS_DETAILS_TAG)) {

                    /*if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    }*/
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            JSONObject Forums = jsonObject.optJSONObject("Forums");

                            tv_forumTitle.setText(Forums.optString("forum_title").trim());
                            tv_forumDescription.setText("Description: " + Forums.optString("forum_description").trim());
                            tv_forumCreater.setText("Created By: " +Forums.optString("forum_createdBy").trim());

                            DisplayImageOptions options = new DisplayImageOptions.Builder()
                                    .showImageOnLoading(R.drawable.forum_dummy_image)
                                    .showImageForEmptyUri(R.drawable.forum_dummy_image)
                                    .showImageOnFail(R.drawable.forum_dummy_image)
                                    .cacheInMemory(true)
                                    .cacheOnDisk(true)
                                    .considerExifParams(true)
                                    .bitmapConfig(Bitmap.Config.RGB_565)
                                    .build();
                            //ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + "/" + Forums.optString("forum_image").trim(), image_forum, ((HomeActivity) getActivity()).options);
                            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + "/" + Forums.optString("forum_image").trim(), image_forum, options, new SimpleImageLoadingListener() {
                                @Override
                                public void onLoadingStarted(String imageUri, View view) {
                                    progressBar.setVisibility(View.VISIBLE);
                                }

                                @Override
                                public void onLoadingFailed(String imageUri, View view, FailReason failReason) {
                                    progressBar.setVisibility(View.GONE);
                                }

                                @Override
                                public void onLoadingComplete(String imageUri, View view, Bitmap loadedImage) {
                                    progressBar.setVisibility(View.GONE);
                                }

                                @Override
                                public void onLoadingCancelled(String imageUri, View view) {
                                    progressBar.setVisibility(View.GONE);
                                }
                            });

                            forum_status = Forums.getInt("archivedClosedStatus");
                            if (forum_status == 2) {
                                tv_reportAbuse.setVisibility(View.GONE);
                                commentLayout.setVisibility(View.GONE);
                            } else {
                                tv_reportAbuse.setVisibility(View.VISIBLE);
                                commentLayout.setVisibility(View.VISIBLE);
                            }

                            list.clear();

                            for (int i = 0; i < Forums.getJSONArray("forum_comments").length(); i++) {

                                UserCommentObject obj = new UserCommentObject();
                                obj.setId(Forums.getJSONArray("forum_comments").getJSONObject(i).optString("commenter_id"));
                                obj.setCreatedTime(DateTimeFormatClass.convertStringObjectToMMMDDYYYYFormat(Forums.getJSONArray("forum_comments").getJSONObject(i).optString("commentedTime")));
                                obj.setUserName(Forums.getJSONArray("forum_comments").getJSONObject(i).optString("commentedBy"));
                                obj.setCommentText(Forums.getJSONArray("forum_comments").getJSONObject(i).optString("CommentText"));
                                obj.setUserImage(Forums.getJSONArray("forum_comments").getJSONObject(i).optString("userImage"));

                                list.add(obj);
                            }


                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FORUM_COMMENTED_USERS_TAG, Constants.FORUM_COMMENTED_USERS_URL + "?forum_id=" + forum_id, Constants.HTTP_GET,"Home Activity");
                                a.execute();
                            } else {
                                if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                                    ((HomeActivity) getActivity()).dismissProgressDialog();
                                }
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }

                            Collections.reverse(list);
                            list_comments.setAdapter(new CommentsAdapter());
                            UtilityList.setListViewHeightBasedOnChildren(list_comments);


                        } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }


                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.ADD_FORUMS_COMMENT_TAG)) {


                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);

                        if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FORUMS_DETAILS_TAG, Constants.FORUMS_DETAILS_URL + "?forum_id=" + forum_id, Constants.HTTP_GET,"Home Activity");
                                a.execute();
                            } else {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                            et_comment.setText("");
                        }
                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.FORUMS_REPORT_ABUSE_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();

                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);

                        if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_LONG).show();
                        }
                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.FORUM_COMMENTED_USERS_TAG)) {
                    if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    }

                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);

                        if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            reportAbuseList.clear();

                            for (int i = 0; i < jsonObject.getJSONArray("users").length(); i++) {

                                if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID).equalsIgnoreCase(jsonObject.getJSONArray("users").getJSONObject(i).optString("user_id"))) {
                                    continue;
                                }

                                UserCommentObject obj = new UserCommentObject();
                                obj.setId(jsonObject.getJSONArray("users").getJSONObject(i).optString("user_id"));
                                obj.setUserName(jsonObject.getJSONArray("users").getJSONObject(i).optString("user_name"));
                                obj.setUserImage(jsonObject.getJSONArray("users").getJSONObject(i).optString("user_image"));

                                reportAbuseList.add(obj);
                            }
                        } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }
                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    class CommentsAdapter extends BaseAdapter {


        private LayoutInflater l_Inflater;

        public CommentsAdapter() {
            l_Inflater = LayoutInflater.from(getActivity());

        }

        @Override
        public int getCount() {
            return list.size();
        }

        @Override
        public Object getItem(int position) {
            return list.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            ViewHolder holder;
            try {
                if (convertView == null) {
                    convertView = l_Inflater.inflate(R.layout.user_commets_row_item, null);
                    holder = new ViewHolder();
                    holder.tv_username = (TextView) convertView.findViewById(R.id.tv_username);
                    holder.tv_CreatedTime = (TextView) convertView.findViewById(R.id.tv_CreatedTime);
                    holder.tv_Description = (TextView) convertView.findViewById(R.id.tv_Description);

                    convertView.setTag(holder);

                } else {
                    holder = (ViewHolder) convertView.getTag();
                }
                try {
                    holder.tv_username.setText(list.get(position).getUserName());
                    holder.tv_CreatedTime.setText(list.get(position).getCreatedTime());
                    holder.tv_Description.setText(list.get(position).getCommentText());

                } catch (Exception e) {
                    e.printStackTrace();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            return convertView;
        }


        class ViewHolder {
            TextView tv_username, tv_CreatedTime, tv_Description;
        }
    }
}
