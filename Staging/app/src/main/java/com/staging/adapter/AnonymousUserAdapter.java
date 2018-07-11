package com.staging.adapter;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.models.AnonymousUserObject;
import com.staging.utilities.Constants;
import com.staging.utilities.NetworkConnectivity;
import com.staging.utilities.UtilitiesClass;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class AnonymousUserAdapter extends BaseAdapter  {

    public DisplayImageOptions options;
//    private ValueFilter valueFilter;
    ArrayList<AnonymousUserObject> mStringFilterList = new ArrayList<AnonymousUserObject>();
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<AnonymousUserObject> list;
    private String comingFrom, consultingID;
    private NetworkConnectivity networkConnectivity;
    private UtilitiesClass utilitiesClass;
    private int pos;

    public AnonymousUserAdapter(Context context, ArrayList<AnonymousUserObject> list, String type, String consultingID) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
        mStringFilterList = list;
        this.comingFrom = type;
        this.consultingID = consultingID;
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
            convertView = l_Inflater.inflate(R.layout.anonymoususer_item, null);
            holder = new ViewHolder();
            holder.tv_ContractorName = (TextView) convertView.findViewById(R.id.tv_ContractorName);
            holder.phone = (TextView) convertView.findViewById(R.id.tv_phone);
            holder.email = (TextView) convertView.findViewById(R.id.tv_email);
            holder.img_contractorImage = (ImageView) convertView.findViewById(R.id.img_contractorImage);
            holder.connection_type =  (TextView) convertView.findViewById(R.id.tv_connectiontype);
            holder.note =  (TextView) convertView.findViewById(R.id.tv_note);
            holder.deleteIcon =  (TextView) convertView.findViewById(R.id.delete);

            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {



            holder.tv_ContractorName.setText(list.get(position).getName());
            holder.phone.setText(list.get(position).getPhone());
            holder.note.setText(list.get(position).getNote());
            holder.email.setText(list.get(position).getEmail());
            holder.connection_type.setText(list.get(position).getConnection_type());


            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + "/" + list.get(position).getImage(), holder.img_contractorImage, options);


            holder.deleteIcon.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context, R.style.MyDialogTheme);

                    alertDialogBuilder
                            .setMessage("Do you want to delete this connection?")
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
                                    if (networkConnectivity.isOnline()) {
                                         pos = position;
                                        new DeleteStartup().execute(list.get(position).getConnection_type_id());

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
        TextView tv_ContractorName, phone, email, connection_type,note,deleteIcon;
        ImageView img_contractorImage;

    }


    private class DeleteStartup extends AsyncTask<String, Void, Void> {

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
                jsonObject = new JSONObject(utilitiesClass.getJSON(Constants.DELETE_NEW_USERS_URL + "?contact_id=" + params[0]));
            } catch (JSONException e) {
                e.printStackTrace();
            }

            return null;
        }
    }







//    @Override
//    public Filter getFilter() {
//        if (valueFilter == null) {
//            valueFilter = new ValueFilter();
//        }
//        return valueFilter;
//    }


//    private void showDialog(final int position, String message, final String url) {
//        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context, R.style.MyDialogTheme);
//
//        alertDialogBuilder
//                .setMessage(message)
//                .setCancelable(false)
//                .setNeutralButton("Cancel", new DialogInterface.OnClickListener() {
//
//                    @Override
//                    public void onClick(DialogInterface dialog, int arg1) {
//                        dialog.dismiss();
//                    }
//                })
//                .setNegativeButton("No", new DialogInterface.OnClickListener() {
//                    @Override
//                    public void onClick(DialogInterface dialog, int arg1) {
//                        dialog.cancel();
//                    }
//                })
//                .setPositiveButton("Yes", new DialogInterface.OnClickListener() {
//
//                    @Override
//                    public void onClick(DialogInterface dialog, int arg1) {
//                        dialog.cancel();
//                        if (networkConnectivity.isInternetConnectionAvaliable()) {
//                            //pos = position;
//                            try {
//                                JSONObject obj = new JSONObject();
//                                obj.put("sent_by", PrefManager.getInstance(context).getString(Constants.USER_ID));
//                                obj.put("consulting_id", consultingID);
//                                obj.put("sent_to", list.get(position).getId());
//                                doJob(position, url, Constants.HTTP_POST_REQUEST, obj);
//                            } catch (JSONException e) {
//                                e.printStackTrace();
//                            }
//                        } else {
//                            utilitiesClass.alertDialogSingleButton(context.getString(R.string.no_internet_connection));
//                        }
//                    }
//                });
//
//        AlertDialog alertDialog = alertDialogBuilder.create();
//
//        alertDialog.show();
//    }



//    private class ValueFilter extends Filter {
//
//        @Override
//        protected FilterResults performFiltering(CharSequence constraint) {
//
//            FilterResults results = new FilterResults();
//
//            if (constraint != null && constraint.length() > 0) {
//
//                ArrayList<ContractorsObject> filterList = new ArrayList<ContractorsObject>();
//
//                for (int i = 0; i < mStringFilterList.size(); i++) {
//
//                    if (mStringFilterList.get(i).getContractorSkills().toLowerCase().startsWith(constraint.toString())) {
//                        filterList.add(mStringFilterList.get(i));
//                    }
//                }
//                results.count = filterList.size();
//                results.values = filterList;
//            } else {
//                results.count = mStringFilterList.size();
//                results.values = mStringFilterList;
//            }
//            return results;
//        }
//
//
//        //Invoked in the UI thread to publish the filtering results in the user interface.
//        @SuppressWarnings("unchecked")
//        @Override
//        protected void publishResults(CharSequence constraint, FilterResults results) {
//
//            list = (ArrayList<ContractorsObject>) results.values;
//            notifyDataSetChanged();
//        }
//    }
//
//
//
//
//    private void doJob(final int position, final String url, final String requestType, final JSONObject jsonObject) {
//
//        new AsyncTask<Void, Void, String>() {
//
//            ProgressDialog pDialog;
//
//            @Override
//            protected void onPreExecute() {
//                // TODO Auto-generated method stub
//                super.onPreExecute();
//
//                pDialog = new ProgressDialog(context);
//                pDialog.setMessage("Please wait...");
//                pDialog.setIndeterminate(true);
//                pDialog.setCancelable(false);
//                pDialog.show();
//
//
//            }
//
//            @Override
//            protected String doInBackground(Void... params) {
//                String response = "";
//                try {
//                    response = utilitiesClass.makeRequest(url, jsonObject, requestType);
//                    return response;
//                } catch (UnknownHostException e) {
//                    return Constants.NOINTERNET;
//                } catch (SocketTimeoutException e) {
//                    return Constants.TIMEOUT_EXCEPTION;
//                } catch (CrowdException e) {
//                    return Constants.SERVEREXCEPTION;
//                } catch (Exception e) {
//                    e.printStackTrace();
//                    return Constants.SERVEREXCEPTION;
//                }
//            }
//
//
//            @Override
//            protected void onPostExecute(String result) {
//                super.onPostExecute(result);
//
//                pDialog.dismiss();
//
//                if (result.equals(Constants.NOINTERNET)) {
//                    Toast.makeText(context, context.getString(R.string.check_internet), Toast.LENGTH_LONG).show();
//                } else if (result.equals(Constants.SERVEREXCEPTION)) {
//                    Toast.makeText(context, context.getString(R.string.server_down), Toast.LENGTH_LONG).show();
//                } else if (result.equals(Constants.TIMEOUT_EXCEPTION)) {
//                    utilitiesClass.alertDialogSingleButton(context.getString(R.string.time_out));
//                } else {
//                    if (result.isEmpty()) {
//                        Toast.makeText(context, context.getString(R.string.server_down), Toast.LENGTH_LONG).show();
//                    } else {
//                        try {
//                            JSONObject jsonObject = new JSONObject(result);
//                            CrowdBootstrapLogger.logInfo(result);
//                            if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
//                                Toast.makeText(context, jsonObject.getString("message"), Toast.LENGTH_LONG).show();
//                                list.remove(position);
//                                notifyDataSetChanged();
//                            } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
//                                Toast.makeText(context, jsonObject.getString("message"), Toast.LENGTH_LONG).show();
//                            }
//                        } catch (JSONException e) {
//                            Toast.makeText(context, context.getString(R.string.server_down), Toast.LENGTH_LONG).show();
//                            e.printStackTrace();
//                        }
//                    }
//                }
//            }
//        }.execute();
//
//    }


}
