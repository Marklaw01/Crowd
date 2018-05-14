package com.staging.adapter.servicesAdapter;

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
import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.exception.CrowdException;
import com.staging.fragments.productivitymodule.ProductivityLikeDislikeFragment;
import com.staging.fragments.servicesmodule.ServicesLikeDislikeFragment;
import com.staging.helper.CircleImageView;
import com.staging.logger.CrowdBootstrapLogger;
import com.staging.models.FundsObject;
import com.staging.utilities.Constants;
import com.staging.utilities.NetworkConnectivity;
import com.staging.utilities.PrefManager;
import com.staging.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.SocketTimeoutException;
import java.net.UnknownHostException;
import java.util.ArrayList;

/**
 * Created by Neelmani.Karn on 1/11/2017.
 */
public class ServicesAdapter extends BaseAdapter implements View.OnClickListener {

    String fragmentName;
    public DisplayImageOptions options;
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<FundsObject> list;
    private NetworkConnectivity networkConnectivity;
    private UtilitiesClass utilitiesClass;
    //private static int pos = 0;

    public ServicesAdapter(Context context, ArrayList<FundsObject> list, String fragmentName) {
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

        if (convertView == null) {
            convertView = l_Inflater.inflate(R.layout.funds_row_item, null);
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

            holder.fundTitle.setText(list.get(position).getFund_title());
            holder.fundDescription.setText(list.get(position).getFund_description());
            holder.tv_postedDate.setText(list.get(position).getFund_start_date());
            holder.tv_Likes.setText(list.get(position).getFund_likes() + " Likes");
            holder.tv_dislikes.setText(list.get(position).getFund_dislike() + " Dislikes");

            //holder.likeBtn.setOnClickListener(this);
            //holder.dislikeBtn.setOnClickListener(this);
            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + list.get(position).getFund_image(), holder.fund_icon, options);

            holder.tv_dislikes.setTag(R.integer.selected_index, position);
            holder.tv_dislikes.setOnClickListener(this);
            holder.tv_Likes.setTag(R.integer.selected_index, position);
            holder.tv_Likes.setOnClickListener(this);

            holder.dislikeBtn.setTag(R.integer.selected_index, position);
            holder.dislikeBtn.setOnClickListener(this);
            holder.likeBtn.setTag(R.integer.selected_index, position);
            holder.likeBtn.setOnClickListener(this);
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


            holder.tv_delete.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    showDialog(position, "Do you want to delete this resource?", Constants.SERVICES_DELETE_URL);
                }
            });


            holder.tv_archive.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    showDialog(position, "Do you want to archive this resource?", Constants.SERVICES_ARCHIEVE_URL);
                }
            });


            holder.tv_deactivate.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    showDialog(position, "Do you want to deactivate this resource?", Constants.SERVICES_DEACTIVATE_URL);
                }
            });


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
                                obj.put("service_id", list.get(position).getId());
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
                int tagLikePosition = (int) v.getTag(R.integer.selected_index);
                if (list.get(tagLikePosition).getIs_liked_by_user() == 1) {
                    Toast.makeText(context, "You already liked this resource", Toast.LENGTH_LONG).show();
                } else {
                    try {
                        JSONObject likeObj = new JSONObject();
                        likeObj.put("like_by", PrefManager.getInstance(context).getString(Constants.USER_ID));
                        likeObj.put("service_id", list.get(tagLikePosition).getId());
                        fundLikeDislike(tagLikePosition, Constants.SERVICES_LIKE_URL, Constants.HTTP_POST_REQUEST, likeObj);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                break;
            case R.id.dislike:
                int tagDislikeIdPosition = (int) v.getTag(R.integer.selected_index);
                if (list.get(tagDislikeIdPosition).getIs_disliked_by_user() == 1) {
                    Toast.makeText(context, "You already disliked this resource", Toast.LENGTH_LONG).show();
                } else {
                    try {
                        JSONObject dislikeObj = new JSONObject();
                        dislikeObj.put("dislike_by", PrefManager.getInstance(context).getString(Constants.USER_ID));
                        dislikeObj.put("service_id", list.get(tagDislikeIdPosition).getId());
                        fundLikeDislike(tagDislikeIdPosition, Constants.SERVICES_DISLIKE_URL, Constants.HTTP_POST_REQUEST, dislikeObj);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                break;
            case R.id.tv_Like:
                int tagLikeId = (int) v.getTag(R.integer.selected_index);
                if (list.get(tagLikeId).getFund_likes() != 0) {
                    Bundle like = new Bundle();
                    like.putInt(Constants.FUND_ID, Integer.parseInt(list.get(tagLikeId).getId()));
                    like.putString(Constants.LIKE_DISLIKE, Constants.LIKE);
                    Fragment likeFragment = new ServicesLikeDislikeFragment();
                    likeFragment.setArguments(like);
                    (((HomeActivity) context)).replaceFragment(likeFragment);
                }
                break;

            case R.id.tv_dislike:
                int tagDislikeId = (int) v.getTag(R.integer.selected_index);
                if (list.get(tagDislikeId).getFund_dislike() != 0) {
                    Bundle dislike = new Bundle();
                    dislike.putInt(Constants.FUND_ID, Integer.parseInt(list.get(tagDislikeId).getId()));
                    dislike.putString(Constants.LIKE_DISLIKE, Constants.DISLIKE);
                    Fragment dislikeFragment = new ServicesLikeDislikeFragment();
                    dislikeFragment.setArguments(dislike);
                    (((HomeActivity) context)).replaceFragment(dislikeFragment);
                }
                break;
        }
    }

    static class ViewHolder {
        TextView fundTitle, fundDescription, tv_postedDate, tv_Likes, tv_dislikes, tv_archive, tv_delete, tv_deactivate;
        CircleImageView fund_icon;
        ImageView likeBtn, dislikeBtn;
        LinearLayout layoutButtons, layoutLikeDeslikeButtons;
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
                        try {
                            JSONObject jsonObject = new JSONObject(result);
                            CrowdBootstrapLogger.logInfo(result);
                            if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                                Toast.makeText(context, jsonObject.getString("message"), Toast.LENGTH_LONG).show();
                                list.get(position).setFund_dislike(jsonObject.getInt("dislikes"));
                                list.get(position).setFund_likes(jsonObject.getInt("likes"));
                                list.get(position).setIs_disliked_by_user(jsonObject.getInt("is_disliked_by_user"));
                                list.get(position).setIs_liked_by_user(jsonObject.getInt("is_liked_by_user"));
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


}
