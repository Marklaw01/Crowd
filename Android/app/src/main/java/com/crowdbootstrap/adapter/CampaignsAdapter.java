package com.crowdbootstrap.adapter;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.models.CampaignsObject;
import com.crowdbootstrap.utilities.Constants;
import com.crowdbootstrap.utilities.NetworkConnectivity;
import com.crowdbootstrap.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/13/2016.
 */
public class CampaignsAdapter extends BaseAdapter {

    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<CampaignsObject> list;
    private boolean isDelete = false;
    private NetworkConnectivity networkConnectivity;
    private UtilitiesClass utilitiesClass;
    private static int pos = 0;

    public CampaignsAdapter(Context context, ArrayList<CampaignsObject> list, boolean isDelete) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
        this.isDelete = isDelete;
        this.networkConnectivity = NetworkConnectivity.getInstance(context);
        this.utilitiesClass = UtilitiesClass.getInstance(context);
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
            convertView = l_Inflater.inflate(R.layout.campaigns_row_item, null);
            holder = new ViewHolder();

            holder.tv_campaignName = (TextView) convertView.findViewById(R.id.tv_campaignName);
            holder.tv_startUpName = (TextView) convertView.findViewById(R.id.tv_startUpName);
            holder.tv_campaignDescription = (TextView) convertView.findViewById(R.id.tv_campaignDescription);
            holder.tv_campaignTargetAmount = (TextView) convertView.findViewById(R.id.tv_campaignTargetAmount);
            holder.tv_campaignFundRaiseFor = (TextView) convertView.findViewById(R.id.tv_campaignFundRaiseFor);
            holder.tv_campaignDueDate = (TextView) convertView.findViewById(R.id.tv_campaignDueDate);
            holder.img_deleteCampaign = (ImageView) convertView.findViewById(R.id.deleteCampaign);
            if (isDelete) {
                holder.img_deleteCampaign.setVisibility(View.VISIBLE);
            } else {
                holder.img_deleteCampaign.setVisibility(View.GONE);
            }

            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.tv_campaignName.setText(list.get(position).getName());
            holder.tv_startUpName.setText(list.get(position).getStartUpName());
            holder.tv_campaignDescription.setText(list.get(position).getDescription());
            holder.tv_campaignDueDate.setText("Due Date: " + list.get(position).getDueDate());
            holder.tv_campaignFundRaiseFor.setText("Fund Raised So Far: " + list.get(position).getFundRaiseFor());
            holder.tv_campaignTargetAmount.setText("Target Amount: " + list.get(position).getTargetAmount());


            holder.img_deleteCampaign.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context);

                    alertDialogBuilder
                            .setMessage("Do you want to delete your campaign?")
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
                                        new DeleteCampaign().execute(list.get(position).getId());

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

    static class ViewHolder {
        TextView tv_campaignName, tv_startUpName, tv_campaignDescription, tv_campaignTargetAmount, tv_campaignFundRaiseFor, tv_campaignDueDate;
        ImageView img_deleteCampaign;
    }

    private class DeleteCampaign extends AsyncTask<String, Void, Void> {

        JSONObject jsonObject;
        ProgressDialog progressBar;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();

            progressBar = new ProgressDialog(context);
            progressBar.setCancelable(false);
            progressBar.setMessage(Html.fromHtml(context.getString(R.string.please_wait)));
            progressBar.setIndeterminate(true);
            progressBar.show();
        }


        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);
            progressBar.dismiss();
            try {
                if (jsonObject != null) {
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        Toast.makeText(context, jsonObject.getString("message"), Toast.LENGTH_LONG).show();
                        list.remove(pos);
                        notifyDataSetChanged();
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(context, jsonObject.getString("message"), Toast.LENGTH_LONG).show();
                    }
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        @Override
        protected Void doInBackground(String... params) {

            try {
                jsonObject = new JSONObject(utilitiesClass.getJSON(Constants.DELETE_CAMPAIGN_URL + "?campaign_id=" + params[0]));
            } catch (JSONException e) {
                e.printStackTrace();
            }

            return null;
        }
    }
}
