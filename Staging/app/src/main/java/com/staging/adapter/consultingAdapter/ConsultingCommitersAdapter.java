package com.staging.adapter.consultingAdapter;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.support.v4.app.FragmentActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.staging.R;
import com.staging.adapter.LikesDislikesAdapter;
import com.staging.exception.CrowdException;
import com.staging.helper.CircleImageView;
import com.staging.logger.CrowdBootstrapLogger;
import com.staging.models.UserObject;
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
 * Created by Sunakshi.Gautam on 5/15/2017.
 */

public class ConsultingCommitersAdapter extends BaseAdapter {

    public DisplayImageOptions options;
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<UserObject> list;
    private String comingFrom;
    private NetworkConnectivity networkConnectivity;
    private UtilitiesClass utilitiesClass;
    private FragmentActivity activity;
    private String from;

    private static int pos = 0;


    public ConsultingCommitersAdapter(Context context, ArrayList<UserObject> list, String comingFrom, FragmentActivity activity, String from) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;

        this.comingFrom = comingFrom;
        this.activity = activity;
        this.from = from;
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
            convertView = l_Inflater.inflate(R.layout.likes_dislikes_row_item, null);
            holder = new ViewHolder();
            holder.fundTitle = (TextView) convertView.findViewById(R.id.personName);
            holder.fundDescription = (TextView) convertView.findViewById(R.id.aboutMe);
            holder.fund_icon = (CircleImageView) convertView.findViewById(R.id.profileimage);
            holder.award = (TextView) convertView.findViewById(R.id.tv_award);
            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        if (from.compareTo("close") == 0) {
            holder.award.setVisibility(View.VISIBLE);
        }
        holder.fundTitle.setText(list.get(position).getName());
        holder.fundDescription.setText(list.get(position).getBio());
        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + list.get(position).getImage(), holder.fund_icon);

        holder.award.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                showDialog(position, "Do you want to award this Assignment to " + list.get(position).getName(), Constants.CONSULTING_CLOSE_URL);
            }
        });
        return convertView;
    }


    static class ViewHolder {
        TextView fundTitle, fundDescription, award;
        CircleImageView fund_icon;
    }

    private void showDialog(final int position, String message, final String url) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context);

        alertDialogBuilder
                .setMessage(message)
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
                            //pos = position;
                            try {
                                JSONObject obj = new JSONObject();
                                obj.put("user_id", PrefManager.getInstance(context).getString(Constants.USER_ID));
                                obj.put("consulting_id", comingFrom);
                                obj.put("contractor_id", list.get(position).getId());
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
                                activity.onBackPressed();
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