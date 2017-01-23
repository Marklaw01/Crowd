package com.staging.adapter;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.Gravity;
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
public class DeactivatedFundsAdapter extends BaseAdapter implements View.OnClickListener {

    String userType, fragmentName;
    public DisplayImageOptions options;
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<FundsObject> list;
    private NetworkConnectivity networkConnectivity;
    private UtilitiesClass utilitiesClass;
    private static int pos = 0;

    public DeactivatedFundsAdapter(Context context, ArrayList<FundsObject> list, String userType) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
        this.userType = userType;
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

        ViewHolder holder;
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
            holder.fund_icon = (ImageView) convertView.findViewById(R.id.fund_icon);
            holder.likeBtn = (ImageView) convertView.findViewById(R.id.like);
            holder.dislikeBtn = (ImageView) convertView.findViewById(R.id.dislike);
            holder.tv_archive = (TextView) convertView.findViewById(R.id.tv_archive);
            holder.tv_deactivate = (TextView) convertView.findViewById(R.id.tv_deactivate);
            holder.tv_delete = (TextView) convertView.findViewById(R.id.tv_delete);
            holder.layoutButtons = (LinearLayout) convertView.findViewById(R.id.layoutButtons);
            holder.layoutButtons.setVisibility(View.VISIBLE);

            holder.tv_archive.setVisibility(View.VISIBLE);
            holder.tv_deactivate.setVisibility(View.GONE);
            holder.tv_delete.setVisibility(View.GONE);


            LinearLayout.LayoutParams buttonParams = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            buttonParams.gravity = Gravity.RIGHT;
            holder.tv_archive.setLayoutParams(buttonParams);

            //holder.tv_archive.setGravity(Gravity.RIGHT | Gravity.CENTER_VERTICAL);
            holder.tv_archive.setText(context.getString(R.string.activate));
            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.likeBtn.setOnClickListener(this);
            holder.dislikeBtn.setOnClickListener(this);
            holder.fundTitle.setText(list.get(position).getFund_title());
            holder.fundDescription.setText(list.get(position).getFund_description());
            holder.tv_postedDate.setText(list.get(position).getFund_start_date());
            holder.tv_Likes.setText(list.get(position).getFund_likes() + " Likes");
            holder.tv_dislikes.setText(list.get(position).getFund_dislike() + " Dislikes");

            holder.likeBtn.setOnClickListener(this);
            holder.dislikeBtn.setOnClickListener(this);
            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + list.get(position).getFund_image(), holder.fund_icon, options);
            holder.tv_dislikes.setOnClickListener(this);
            holder.tv_Likes.setOnClickListener(this);


            holder.tv_archive.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context);

                    alertDialogBuilder
                            .setMessage("Do you want to activate this Fund?")
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
                                    if (networkConnectivity.isInternetConnectionAvaliable()) {
                                        try {
                                            JSONObject obj = new JSONObject();
                                            obj.put("user_id", PrefManager.getInstance(context).getString(Constants.USER_ID));
                                            obj.put("fund_id", list.get(position).getId());
                                            doJob(context.getString(R.string.fundActivated), position, Constants.FUND_ACTIVATE_URL, Constants.HTTP_POST_REQUEST, obj);
                                        } catch (JSONException e) {
                                            e.printStackTrace();
                                        }

                                    } else {
                                        utilitiesClass.alertDialogSingleButton(context.getString(R.string.no_internet_connection));
                                    }


                                    //list.remove(position);
                                    notifyDataSetChanged();
                                }
                            });

                    AlertDialog alertDialog = alertDialogBuilder.create();

                    alertDialog.show();


                }
            });


        } catch (Exception e) {

            e.printStackTrace();
        }

        return convertView;
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
                if (userType.equals(Constants.LOGGED_USER)) {
                    Toast.makeText(context, context.getString(R.string.donot_like_dislike_own_funds), Toast.LENGTH_SHORT).show();
                }
                break;
            case R.id.dislike:
                if (userType.equals(Constants.LOGGED_USER)) {
                    Toast.makeText(context, context.getString(R.string.donot_like_dislike_own_funds), Toast.LENGTH_SHORT).show();
                }
                break;
            case R.id.tv_Like:
                Bundle like = new Bundle();
                like.putInt(Constants.FUND_ID, 1);
                like.putString(Constants.LIKE_DISLIKE, Constants.LIKE);
                Fragment likeFragment = new LikeDislikeFragment();
                likeFragment.setArguments(like);
                (((HomeActivity) context)).replaceFragment(likeFragment);
                break;

            case R.id.tv_dislike:
                Bundle dislike = new Bundle();
                dislike.putInt(Constants.FUND_ID, 1);
                dislike.putString(Constants.LIKE_DISLIKE, Constants.DISLIKE);
                Fragment dislikeFragment = new LikeDislikeFragment();
                dislikeFragment.setArguments(dislike);
                (((HomeActivity) context)).replaceFragment(dislikeFragment);
                break;
        }
    }

    static class ViewHolder {
        TextView fundTitle, fundDescription, tv_postedDate, tv_Likes, tv_dislikes, tv_archive, tv_delete, tv_deactivate;
        ImageView fund_icon;
        ImageView likeBtn, dislikeBtn;
        LinearLayout layoutButtons, layoutLikeDeslikeButtons;
    }


    private void doJob(final String message, final int position, final String url, final String requestType, final JSONObject jsonObject) {

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
                                Toast.makeText(context, message, Toast.LENGTH_LONG).show();
                                list.remove(position);
                                notifyDataSetChanged();
                            } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                                Toast.makeText(context, message, Toast.LENGTH_LONG).show();
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
