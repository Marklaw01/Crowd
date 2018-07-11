package com.crowdbootstrap.adapter;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.exception.CrowdException;
import com.crowdbootstrap.helper.CircleImageView;
import com.crowdbootstrap.logger.CrowdBootstrapLogger;
import com.crowdbootstrap.models.BusinessCardObject;
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
 * Created by Sunakshi.Gautam on 11/17/2017.
 */

public class MyBusinessCardAdapter extends BaseAdapter {

    String fragmentName;
    public DisplayImageOptions options;
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<BusinessCardObject> list;
    private NetworkConnectivity networkConnectivity;
    private UtilitiesClass utilitiesClass;
    //private static int pos = 0;

    public MyBusinessCardAdapter(Context context, ArrayList<BusinessCardObject> list, String fragmentName) {
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
            convertView = l_Inflater.inflate(R.layout.mybusinesscard_item, null);
            holder = new ViewHolder();
            holder.cardTitle = (TextView) convertView.findViewById(R.id.cardTitle);
            holder.cardStatus = (TextView) convertView.findViewById(R.id.tv_status);
            holder.cardDescription = (TextView) convertView.findViewById(R.id.cardDescription);
            holder.card_icon = (CircleImageView) convertView.findViewById(R.id.businesscard_icon);
            holder.card_Selected = (ImageView) convertView.findViewById(R.id.cardSelected);
            holder.btnDeleteCard = (ImageView) convertView.findViewById(R.id.delete_card);

            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {

            holder.cardTitle.setText(list.get(position).getCardTitle());
            holder.cardDescription.setText(list.get(position).getCardDescription());


            holder.cardStatus.setText(list.get(position).getCardID());
            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + list.get(position).getCardImage(), holder.card_icon, options);

            if (list.get(position).getStatus().compareTo("1") == 0) {
                holder.card_Selected.setImageResource(R.drawable.radiobutton_selected);
            } else {
                holder.card_Selected.setImageResource(R.drawable.radiobutton_unselected);
            }


            holder.card_Selected.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    showDialog(position, "Do you want to select this card as your public business card?", Constants.ACTIVATE_BUSINESS_CARD, holder.card_Selected);
                }
            });

            holder.btnDeleteCard.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    showDialog(position, "Do you want to delete this business card?", Constants.DELETE_BUSINESS_CARD_URL,holder.btnDeleteCard);
                }
            });


        } catch (Exception e) {

            e.printStackTrace();
        }

        return convertView;
    }


    static class ViewHolder {
        TextView cardTitle, cardDescription, cardStatus;
        CircleImageView card_icon;
        ImageView card_Selected,btnDeleteCard;

    }

    private void showDialog(final int position, String message, final String url, final ImageView holderSelected) {
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

                                holderSelected.setImageResource(R.drawable.radiobutton_selected);
                                JSONObject obj = new JSONObject();
                                obj.put("user_id", PrefManager.getInstance(context).getString(Constants.USER_ID));
                                obj.put("card_id", list.get(position).getCardID());
                                obj.put("status", "1");
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
                                notifyDataSetChanged();
                                ((HomeActivity)context).onBackPressed();
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
