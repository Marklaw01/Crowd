package com.crowdbootstrap.adapter;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.exception.CrowdException;
import com.crowdbootstrap.fragments.WebViewFragment;
import com.crowdbootstrap.helper.CircleImageView;
import com.crowdbootstrap.logger.CrowdBootstrapLogger;
import com.crowdbootstrap.models.HomeFeedsObject;
import com.crowdbootstrap.utilities.Constants;
import com.crowdbootstrap.utilities.NetworkConnectivity;
import com.crowdbootstrap.utilities.PrefManager;
import com.crowdbootstrap.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.SocketTimeoutException;
import java.net.UnknownHostException;
import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 5/29/2017.
 */

public class HomeFeedsAdapter extends BaseAdapter implements View.OnClickListener {

    String fragmentName;
    public DisplayImageOptions options;
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<HomeFeedsObject> list;
    private NetworkConnectivity networkConnectivity;
    private UtilitiesClass utilitiesClass;
    //private static int pos = 0;

    public HomeFeedsAdapter(Context context, ArrayList<HomeFeedsObject> list, String fragmentName) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
        this.fragmentName = fragmentName;
        this.networkConnectivity = NetworkConnectivity.getInstance(context);
        this.utilitiesClass = UtilitiesClass.getInstance(context);
        options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.image)
                .showImageForEmptyUri(R.drawable.image)
                .showImageOnFail(R.drawable.image)
                .cacheInMemory(true)
                .cacheOnDisk(true)
                .considerExifParams(true)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();


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
    public View getView(final int position, View convertView, ViewGroup parent) {

        final ViewHolder holder;
        convertView1 = convertView;
        final ArrayList<String> files = new ArrayList<>();
        if (convertView == null) {
            convertView = l_Inflater.inflate(R.layout.homefeed_item, null);
            holder = new ViewHolder();
            holder.fundTitle = (TextView) convertView.findViewById(R.id.fundTitle);
            holder.fundDescription = (TextView) convertView.findViewById(R.id.fundDescription);
            holder.tv_postedDate = (TextView) convertView.findViewById(R.id.tv_postedDate);
            holder.tv_Likes = (TextView) convertView.findViewById(R.id.tv_Like);
            holder.tv_dislikes = (TextView) convertView.findViewById(R.id.tv_dislike);
            holder.tv_postedDate = (TextView) convertView.findViewById(R.id.tv_postedDate);
            holder.fund_icon = (CircleImageView) convertView.findViewById(R.id.fund_icon);
            holder.likeBtn = (ImageView) convertView.findViewById(R.id.like);
            holder.dislikeBtn = (ImageView) convertView.findViewById(R.id.dislike);
            holder.tv_archive = (TextView) convertView.findViewById(R.id.tv_archive);
            holder.tv_deactivate = (TextView) convertView.findViewById(R.id.tv_deactivate);
            holder.tv_delete = (TextView) convertView.findViewById(R.id.tv_delete);
            holder.layoutButtons = (LinearLayout) convertView.findViewById(R.id.layoutButtons);
            holder.tv_status = (TextView) convertView.findViewById(R.id.tv_status);


            holder.attachmentLayout = (LinearLayout) convertView.findViewById(R.id.attatchmentLayout);
            holder.attachmentAboveLayout = (LinearLayout) convertView.findViewById(R.id.attatchmentAbove);
            holder.attachmrnyBelowLayout = (LinearLayout) convertView.findViewById(R.id.attatchmentBelow);
            holder.file1_attachment = (TextView) convertView.findViewById(R.id.file1);
            holder.file2_attachment = (TextView) convertView.findViewById(R.id.file2);
            holder.file3_attachment = (TextView) convertView.findViewById(R.id.file3);
            holder.file4_attachment = (TextView) convertView.findViewById(R.id.file4);
            holder.feed_description = (TextView) convertView.findViewById(R.id.feedDescription);


            if (list.get(position).getFeedType().compareTo("custom_feed") == 0) {

                holder.attachmentLayout.setVisibility(View.VISIBLE);
                holder.feed_description.setVisibility(View.VISIBLE);
                holder.fundDescription.setVisibility(View.GONE);

                if (!list.get(position).getFile1_link().isEmpty()) {
                    files.add(list.get(position).getFile1_link());
                }
                if (!list.get(position).getFile2_link().isEmpty()) {
                    files.add(list.get(position).getFile2_link());
                }
                if (!list.get(position).getFile3_link().isEmpty()) {
                    files.add(list.get(position).getFile3_link());
                }
                if (!list.get(position).getFile4_link().isEmpty()) {
                    files.add(list.get(position).getFile4_link());
                }

                if (files.size() > 2) {
                    holder.attachmrnyBelowLayout.setVisibility(View.VISIBLE);
                    holder.attachmentAboveLayout.setVisibility(View.VISIBLE);


                } else {
                    holder.attachmentAboveLayout.setVisibility(View.VISIBLE);
                    holder.attachmrnyBelowLayout.setVisibility(View.GONE);
                }


            } else {
                holder.attachmentLayout.setVisibility(View.GONE);
                holder.feed_description.setVisibility(View.GONE);
                holder.fundDescription.setVisibility(View.VISIBLE);
            }

            if (fragmentName.equals("MyFunds")) {
                holder.layoutButtons.setVisibility(View.VISIBLE);
            } else {
                holder.layoutButtons.setVisibility(View.GONE);
            }
            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.tv_status.setVisibility(View.VISIBLE);
            holder.tv_deactivate.setText("Close");
            holder.fundTitle.setText(list.get(position).getFeedTitle());

            if (list.get(position).getFeedType().compareTo("custom_feed") == 0) {
                holder.feed_description.setText(list.get(position).getFeedSenderBio());
            } else {
                holder.fundDescription.setText(list.get(position).getFeedSenderBio());
            }
            holder.tv_postedDate.setText(list.get(position).getFeedPostDate());
            holder.tv_status.setText("Message: " + list.get(position).getFeedMessage());


            if (files.size() == 1) {
                holder.file1_attachment.setText("Attachment 1");
                holder.file2_attachment.setVisibility(View.GONE);
                final String url = files.get(0).toString();
                holder.file1_attachment.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Fragment rateContributor = new WebViewFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("url", Constants.APP_IMAGE_URL + "/" + url);
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) context).replaceFragment(rateContributor);
                    }
                });
            } else if (files.size() == 2) {
                holder.file1_attachment.setText("Attachment 1");
                holder.file2_attachment.setText("Attachment 2");
                holder.file2_attachment.setVisibility(View.VISIBLE);
                final String url = files.get(0).toString();
                holder.file1_attachment.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Fragment rateContributor = new WebViewFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("url", Constants.APP_IMAGE_URL + "/" + url);
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) context).replaceFragment(rateContributor);
                    }
                });


                final String url2 = files.get(1).toString();
                holder.file2_attachment.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Fragment rateContributor = new WebViewFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("url", Constants.APP_IMAGE_URL + "/" + url2);
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) context).replaceFragment(rateContributor);
                    }
                });


            } else if (files.size() == 3) {
                holder.file1_attachment.setText("Attachment 1");
                holder.file2_attachment.setText("Attachment 2");
                holder.file3_attachment.setText("Attachment 3");


                final String url = files.get(0).toString();
                holder.file1_attachment.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Fragment rateContributor = new WebViewFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("url", Constants.APP_IMAGE_URL + "/" + url);
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) context).replaceFragment(rateContributor);
                    }
                });


                final String url2 = files.get(1).toString();
                holder.file2_attachment.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Fragment rateContributor = new WebViewFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("url", Constants.APP_IMAGE_URL + "/" + url2);
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) context).replaceFragment(rateContributor);
                    }
                });

                final String url3 = files.get(2).toString();
                holder.file3_attachment.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Fragment rateContributor = new WebViewFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("url", Constants.APP_IMAGE_URL + "/" + url3);
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) context).replaceFragment(rateContributor);
                    }
                });


            } else if (files.size() == 4) {
                holder.file1_attachment.setText("Attachment 1");
                holder.file2_attachment.setText("Attachment 2");
                holder.file3_attachment.setText("Attachment 3");
                holder.file4_attachment.setText("Attachment 4");


                final String url = files.get(0).toString();
                holder.file1_attachment.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Fragment rateContributor = new WebViewFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("url", Constants.APP_IMAGE_URL + "/" + url);
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) context).replaceFragment(rateContributor);
                    }
                });


                final String url2 = files.get(1).toString();
                holder.file2_attachment.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Fragment rateContributor = new WebViewFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("url", Constants.APP_IMAGE_URL + "/" + url2);
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) context).replaceFragment(rateContributor);
                    }
                });

                final String url3 = files.get(2).toString();
                holder.file3_attachment.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Fragment rateContributor = new WebViewFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("url", Constants.APP_IMAGE_URL + "/" + url3);
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) context).replaceFragment(rateContributor);
                    }
                });

                final String url4 = files.get(3).toString();
                holder.file4_attachment.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Fragment rateContributor = new WebViewFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("url", Constants.APP_IMAGE_URL + "/" + url4);
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) context).replaceFragment(rateContributor);
                    }
                });

            }


            //holder.likeBtn.setOnClickListener(this);
            //holder.dislikeBtn.setOnClickListener(this);
            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + list.get(position).getFeedSenderImage(), holder.fund_icon, options);

//            holder.tv_dislikes.setTag(R.integer.selected_index, position);
//            holder.tv_dislikes.setOnClickListener(this);
//            holder.tv_Likes.setTag(R.integer.selected_index, position);
//            holder.tv_Likes.setOnClickListener(this);
//
//            holder.dislikeBtn.setTag(R.integer.selected_index, position);
//            holder.dislikeBtn.setOnClickListener(this);
//            holder.likeBtn.setTag(R.integer.selected_index, position);
//            holder.likeBtn.setOnClickListener(this);
            /*holder.likeBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    try {
                        JSONObject likeObj = new JSONObject();
                        likeObj.put("like_by", PrefManager.getInstance(context).getString(Constants.USER_ID));
                        likeObj.put("fund_id", list.get(position).getId());
                        fundLikeDislike(position, Constants.FUND_LIKE_URL, Constants.HTTP_POST_REQUEST, likeObj, holder.likeBtn, holder.dislikeBtn);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            });

            holder.dislikeBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    try {
                        JSONObject dislikeObj = new JSONObject();
                        dislikeObj.put("dislike_by", PrefManager.getInstance(context).getString(Constants.USER_ID));
                        dislikeObj.put("fund_id", list.get(position).getId());
                        fundLikeDislike(position, Constants.FUND_DISLIKE_URL, Constants.HTTP_POST_REQUEST, dislikeObj, holder.likeBtn, holder.dislikeBtn);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            });*/

//            holder.tv_deactivate.setTag(R.integer.selected_index, position);
//            holder.tv_deactivate.setOnClickListener(this);
//
//
//            holder.tv_archive.setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View v) {
//                    showDialog(position, "Do you want to archive this Assignment?", Constants.CONSULTING_ARCHIEVE_URL);
//                }
//            });
//
//
//            holder.tv_delete.setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View v) {
//                    showDialog(position, "Do you want to delete this Assignment?", Constants.CONSULTING_DELETE_URL);
//                }
//            });


        } catch (Exception e) {

            e.printStackTrace();
        }

        return convertView;
    }

    private void showDialog(final int position, String message, final String url) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context, R.style.MyDialogTheme);

        alertDialogBuilder
                .setMessage(message)
                .setCancelable(false)
                .setNeutralButton("Cancel", new DialogInterface.OnClickListener() {

                    @Override
                    public void onClick(DialogInterface dialog, int arg1) {
                        dialog.dismiss();
                    }
                })
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
                        if (networkConnectivity.isInternetConnectionAvaliable()) {
                            //pos = position;
                            try {
                                JSONObject obj = new JSONObject();
                                obj.put("user_id", PrefManager.getInstance(context).getString(Constants.USER_ID));
                                //obj.put("consulting_id", list.get(position).getId());
                                doJob(position, url, Constants.HTTP_POST_REQUEST, obj);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        } else {
                            utilitiesClass.alertDialogSingleButton(context.getString(R.string.no_internet_connection));
                        }
                    }
                });

        AlertDialog alertDialog = alertDialogBuilder.create();

        alertDialog.show();
    }


    /**
     * Called when a view has been clicked.
     *
     * @param v The view that was clicked.
     */
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.like:
//                int tagLikePosition = (int) v.getTag(R.integer.selected_index);
//                if (list.get(tagLikePosition).getIs_liked_by_user() == 1) {
//                    Toast.makeText(context, "You already liked this assignment", Toast.LENGTH_LONG).show();
//                } else {
//                    try {
//                        JSONObject likeObj = new JSONObject();
//                        likeObj.put("like_by", PrefManager.getInstance(context).getString(Constants.USER_ID));
//                        likeObj.put("consulting_id", list.get(tagLikePosition).getId());
//                        fundLikeDislike(tagLikePosition, Constants.CONSULTING_LIKE_URL, Constants.HTTP_POST_REQUEST, likeObj);
//                    } catch (JSONException e) {
//                        e.printStackTrace();
//                    }
//                }

                break;
            case R.id.dislike:
                int tagDislikeIdPosition = (int) v.getTag(R.integer.selected_index);
//                if (list.get(tagDislikeIdPosition).getIs_disliked_by_user() == 1) {
//                    Toast.makeText(context, "You already disliked this assignment", Toast.LENGTH_LONG).show();
//                } else {
//                    try {
//                        JSONObject dislikeObj = new JSONObject();
//                        dislikeObj.put("dislike_by", PrefManager.getInstance(context).getString(Constants.USER_ID));
//                        dislikeObj.put("consulting_id", list.get(tagDislikeIdPosition).getId());
//                        fundLikeDislike(tagDislikeIdPosition, Constants.CONSULTING_DISLIKE_URL, Constants.HTTP_POST_REQUEST, dislikeObj);
//                    } catch (JSONException e) {
//                        e.printStackTrace();
//                    }
//                }

                break;
            case R.id.tv_Like:
                int tagLikeId = (int) v.getTag(R.integer.selected_index);
//                if (list.get(tagLikeId).getFund_likes() != 0) {
//                    Bundle like = new Bundle();
//                    like.putInt(Constants.FUND_ID, Integer.parseInt(list.get(tagLikeId).getId()));
//                    like.putString(Constants.LIKE_DISLIKE, Constants.LIKE);
//                    Fragment likeFragment = new ConsultingLikeDislikeFragment();
//                    likeFragment.setArguments(like);
//                    (((HomeActivity) context)).replaceFragment(likeFragment);
//                }
                break;

            case R.id.tv_dislike:
//                int tagDislikeId = (int) v.getTag(R.integer.selected_index);
//                if (list.get(tagDislikeId).getFund_dislike() != 0) {
//                    Bundle dislike = new Bundle();
//                    dislike.putInt(Constants.FUND_ID, Integer.parseInt(list.get(tagDislikeId).getId()));
//                    dislike.putString(Constants.LIKE_DISLIKE, Constants.DISLIKE);
//                    Fragment dislikeFragment = new ConsultingLikeDislikeFragment();
//                    dislikeFragment.setArguments(dislike);
//                    (((HomeActivity) context)).replaceFragment(dislikeFragment);
//                }
                break;

            case R.id.tv_deactivate:
//                int tagConsultingposition = (int) v.getTag(R.integer.selected_index);
//                Bundle closeFragment = new Bundle();
//                closeFragment.putString(Constants.FUND_ID, list.get(tagConsultingposition).getId());
//                closeFragment.putString("from","close");
//                Fragment likeFragment = new ConsultingComittersFragment();
//                likeFragment.setArguments(closeFragment);
//                (((HomeActivity) context)).replaceFragment(likeFragment);

                break;
        }
    }

    static class ViewHolder {
        TextView fundTitle, fundDescription, tv_postedDate, tv_Likes, tv_dislikes, tv_archive, tv_delete, tv_deactivate, tv_status, file1_attachment, file2_attachment, file3_attachment, file4_attachment, feed_description;
        CircleImageView fund_icon;
        ImageView likeBtn, dislikeBtn;
        LinearLayout layoutButtons, attachmentLayout, attachmentAboveLayout, attachmrnyBelowLayout;
    }

    private void doJob(final int position, final String url, final String requestType, final JSONObject jsonObject) {

        new AsyncTask<Void, Void, String>() {

            ProgressDialog pDialog;

            @Override
            protected void onPreExecute() {
                // TODO Auto-generated method stub
                super.onPreExecute();

                pDialog = new ProgressDialog(context);
                pDialog.setMessage("Please wait...");
                pDialog.setIndeterminate(true);
                pDialog.setCancelable(false);
                pDialog.show();


            }

            @Override
            protected String doInBackground(Void... params) {
                String response = "";
                try {
                    response = utilitiesClass.makeRequest(url, jsonObject, requestType);
                    return response;
                } catch (UnknownHostException e) {
                    return Constants.NOINTERNET;
                } catch (SocketTimeoutException e) {
                    return Constants.TIMEOUT_EXCEPTION;
                } catch (CrowdException e) {
                    return Constants.SERVEREXCEPTION;
                } catch (Exception e) {
                    e.printStackTrace();
                    return Constants.SERVEREXCEPTION;
                }
            }


            @Override
            protected void onPostExecute(String result) {
                super.onPostExecute(result);

                pDialog.dismiss();

                if (result.equals(Constants.NOINTERNET)) {
                    Toast.makeText(context, context.getString(R.string.check_internet), Toast.LENGTH_LONG).show();
                } else if (result.equals(Constants.SERVEREXCEPTION)) {
                    Toast.makeText(context, context.getString(R.string.server_down), Toast.LENGTH_LONG).show();
                } else if (result.equals(Constants.TIMEOUT_EXCEPTION)) {
                    utilitiesClass.alertDialogSingleButton(context.getString(R.string.time_out));
                } else {
                    if (result.isEmpty()) {
                        Toast.makeText(context, context.getString(R.string.server_down), Toast.LENGTH_LONG).show();
                    } else {
                        try {
                            JSONObject jsonObject = new JSONObject(result);
                            CrowdBootstrapLogger.logInfo(result);
                            if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                                Toast.makeText(context, jsonObject.getString("message"), Toast.LENGTH_LONG).show();
                                list.remove(position);
                                notifyDataSetChanged();
                            } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                                Toast.makeText(context, jsonObject.getString("message"), Toast.LENGTH_LONG).show();
                            }
                        } catch (JSONException e) {
                            Toast.makeText(context, context.getString(R.string.server_down), Toast.LENGTH_LONG).show();
                            e.printStackTrace();
                        }
                    }
                }
            }
        }.execute();


    }

    private void fundLikeDislike(final int position, final String url, final String requestType, final JSONObject jsonObject) {

        new AsyncTask<Void, Void, String>() {

            ProgressDialog pDialog;

            @Override
            protected void onPreExecute() {
                // TODO Auto-generated method stub
                super.onPreExecute();

                pDialog = new ProgressDialog(context);
                pDialog.setMessage("Please wait...");
                pDialog.setIndeterminate(true);
                pDialog.setCancelable(false);
                pDialog.show();


            }

            @Override
            protected String doInBackground(Void... params) {
                String response = "";
                try {
                    response = utilitiesClass.makeRequest(url, jsonObject, requestType);
                    return response;
                } catch (UnknownHostException e) {
                    return Constants.NOINTERNET;
                } catch (SocketTimeoutException e) {
                    return Constants.TIMEOUT_EXCEPTION;
                } catch (CrowdException e) {
                    return Constants.SERVEREXCEPTION;
                } catch (Exception e) {
                    e.printStackTrace();
                    return Constants.SERVEREXCEPTION;
                }
            }


            @Override
            protected void onPostExecute(String result) {
                super.onPostExecute(result);

                pDialog.dismiss();

                if (result.equals(Constants.NOINTERNET)) {
                    Toast.makeText(context, context.getString(R.string.check_internet), Toast.LENGTH_LONG).show();
                } else if (result.equals(Constants.SERVEREXCEPTION)) {
                    Toast.makeText(context, context.getString(R.string.server_down), Toast.LENGTH_LONG).show();
                } else if (result.equals(Constants.TIMEOUT_EXCEPTION)) {
                    utilitiesClass.alertDialogSingleButton(context.getString(R.string.time_out));
                } else {
                    if (result.isEmpty()) {
                        Toast.makeText(context, context.getString(R.string.server_down), Toast.LENGTH_LONG).show();
                    } else {
//                        try {
//                            JSONObject jsonObject = new JSONObject(result);
//                            CrowdBootstrapLogger.logInfo(result);
//                            if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
//                                Toast.makeText(context, jsonObject.getString("message"), Toast.LENGTH_LONG).show();
//                                list.get(position).setFund_dislike(jsonObject.getInt("dislikes"));
//                                list.get(position).setFund_likes(jsonObject.getInt("likes"));
//                                list.get(position).setIs_disliked_by_user(jsonObject.getInt("is_disliked_by_user"));
//                                list.get(position).setIs_liked_by_user(jsonObject.getInt("is_liked_by_user"));
//                                notifyDataSetChanged();
//                            } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
//                                Toast.makeText(context, jsonObject.getString("message"), Toast.LENGTH_LONG).show();
//                            }
//                        } catch (JSONException e) {
//                            Toast.makeText(context, context.getString(R.string.server_down), Toast.LENGTH_LONG).show();
//                            e.printStackTrace();
//                        }
                    }
                }
            }
        }.execute();

    }


}
