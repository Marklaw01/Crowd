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
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.TextView;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.models.CurrentStartUpObject;
import com.crowdbootstrap.utilities.Constants;
import com.crowdbootstrap.utilities.NetworkConnectivity;
import com.crowdbootstrap.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by sunakshi.gautam on 1/19/2016.
 */
public class CurrentStartupsAdapter extends BaseAdapter implements Filterable {

    private ValueFilter valueFilter;
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<CurrentStartUpObject> list;
    ArrayList<CurrentStartUpObject> mStringFilterList = new ArrayList<CurrentStartUpObject>();
    private boolean isDelete = false;
    private NetworkConnectivity networkConnectivity;
    private UtilitiesClass utilitiesClass;
    private static int pos = 0;

    public CurrentStartupsAdapter(Context context, ArrayList<CurrentStartUpObject> list, boolean isDelete) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
        this.mStringFilterList = list;
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
            convertView = l_Inflater.inflate(R.layout.search_startup_row_item, null);
            holder = new ViewHolder();

            holder.tv_startupname = (TextView) convertView.findViewById(R.id.tv_startupname);
            holder.tv_enterpreneurName = (TextView) convertView.findViewById(R.id.tv_enterpreneurName);
            holder.tv_startupDescription = (TextView) convertView.findViewById(R.id.tv_startupDescription);
            holder.arrow = (TextView) convertView.findViewById(R.id.arrow);

            if (isDelete){
                holder.arrow.setBackground(context.getResources().getDrawable(R.drawable.campaign_delete_icon));
            }else{
                holder.arrow.setBackground(context.getResources().getDrawable(R.drawable.arrow));
            }
            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.tv_startupname.setText(list.get(position).getStartUpName());
            holder.tv_enterpreneurName.setText(list.get(position).getEntrenprenuerName());
            holder.tv_startupDescription.setText(list.get(position).getStartUpDiscription());


            holder.arrow.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (isDelete){


                        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context, R.style.MyDialogTheme);

                        alertDialogBuilder
                                .setMessage("Do you want to delete your startup?")
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
                                            new DeleteStartup().execute(list.get(position).getId());

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
                }
            });

        } catch (Exception e) {

            e.printStackTrace();
        }

        return convertView;
    }

    static class ViewHolder {
        TextView tv_startupname, tv_enterpreneurName, tv_startupDescription, arrow;
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
                jsonObject = new JSONObject(utilitiesClass.getJSON(Constants.DELETE_STARTUPS_URL + "?startup_id=" + params[0]));
            } catch (JSONException e) {
                e.printStackTrace();
            }

            return null;
        }
    }


    @Override
    public Filter getFilter() {
        if (valueFilter == null) {
            valueFilter = new ValueFilter();
        }
        return valueFilter;
    }


    private class ValueFilter extends Filter {

        @Override
        protected FilterResults performFiltering(CharSequence constraint) {

            FilterResults results = new FilterResults();

            if (constraint != null && constraint.length() > 0) {

                ArrayList<CurrentStartUpObject> filterList = new ArrayList<CurrentStartUpObject>();

                for (int i = 0; i < mStringFilterList.size(); i++) {

                    if (mStringFilterList.get(i).getStartUpName().toLowerCase().startsWith(constraint.toString()) || mStringFilterList.get(i).getEntrenprenuerName().toLowerCase().startsWith(constraint.toString())) {
                        filterList.add(mStringFilterList.get(i));
                    }
                }
                results.count = filterList.size();
                results.values = filterList;
            } else {
                results.count = mStringFilterList.size();
                results.values = mStringFilterList;
            }
            return results;
        }


        //Invoked in the UI thread to publish the filtering results in the user interface.
        @SuppressWarnings("unchecked")
        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {

            list = (ArrayList<CurrentStartUpObject>) results.values;
            notifyDataSetChanged();
        }
    }
}
