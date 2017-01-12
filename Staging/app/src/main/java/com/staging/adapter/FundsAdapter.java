package com.staging.adapter;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.fragments.ViewFollowers;
import com.staging.models.JobListObject;
import com.staging.utilities.Constants;
import com.staging.utilities.NetworkConnectivity;
import com.staging.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Neelmani.Karn on 1/11/2017.
 */
public class FundsAdapter extends BaseAdapter implements View.OnClickListener {

    public DisplayImageOptions options;
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    //private ArrayList<JobListObject> list;
    private NetworkConnectivity networkConnectivity;
    private UtilitiesClass utilitiesClass;
    private static int pos = 0;

    public FundsAdapter(Context context/*, ArrayList<JobListObject> list*/) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        //this.list = list;

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
        return 10;
    }

    @Override
    public Object getItem(int position) {
        return new Object();
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

            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            //ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + list.get(position).getCompanyLogoImage(), holder.fund_icon, options);

            holder.tv_Likes.setOnClickListener(this);
            holder.tv_dislikes.setOnClickListener(this);
            holder.tv_delete.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {


                    AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context);

                    alertDialogBuilder
                            .setMessage("Do you want to delete this Job?")
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
                                    if (networkConnectivity.isOnline()) {
                                        pos = position;
                                        //new DeleteJob().execute(list.get(position).getJobID());

                                        /*Async a = new Async(context, (AsyncTaskCompleteListener<String>) context, Constants.DELETE_CAMPAIGN_TAG, Constants.DELETE_CAMPAIGN_TAG + list.get(position).getId(), Constants.HTTP_GET);
                                        a.execute();*/
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


            holder.tv_archive.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context);

                    alertDialogBuilder
                            .setMessage("Do you want to archive this Job?")
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
                                    if (networkConnectivity.isOnline()) {
                                        pos = position;
                                        //new ArchiveJob().execute(list.get(position).getJobID());

                                        /*Async a = new Async(context, (AsyncTaskCompleteListener<String>) context, Constants.DELETE_CAMPAIGN_TAG, Constants.DELETE_CAMPAIGN_TAG + list.get(position).getId(), Constants.HTTP_GET);
                                        a.execute();*/
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


            holder.tv_deactivate.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context);

                    alertDialogBuilder
                            .setMessage("Do you want to deactivate this Job?")
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
                                    if (networkConnectivity.isOnline()) {
                                        pos = position;
                                        // new DeactivateJob().execute(list.get(position).getJobID());

                                        /*Async a = new Async(context, (AsyncTaskCompleteListener<String>) context, Constants.DELETE_CAMPAIGN_TAG, Constants.DELETE_CAMPAIGN_TAG + list.get(position).getId(), Constants.HTTP_GET);
                                        a.execute();*/
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


}
