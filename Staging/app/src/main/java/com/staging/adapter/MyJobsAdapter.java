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
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.fragments.ViewContractorsFragment;
import com.staging.fragments.ViewFollowers;
import com.staging.models.JobListObject;
import com.staging.utilities.Constants;
import com.staging.utilities.NetworkConnectivity;
import com.staging.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 12/7/2016.
 */
public class MyJobsAdapter extends BaseAdapter implements Filterable {

    public DisplayImageOptions options;
    private ValueFilter valueFilter;
    ArrayList<JobListObject> mStringFilterList = new ArrayList<JobListObject>();
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<JobListObject> list;
    private NetworkConnectivity networkConnectivity;
    private UtilitiesClass utilitiesClass;
    private static int pos = 0;

    public MyJobsAdapter(Context context, ArrayList<JobListObject> list) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
        mStringFilterList = list;
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
            convertView = l_Inflater.inflate(R.layout.myjobs_item_layout, null);
            holder = new ViewHolder();
            holder.tv_ContractorName = (TextView) convertView.findViewById(R.id.tv_ContractorName);
            holder.tv_postedon = (TextView) convertView.findViewById(R.id.tv_postedon);
            holder.tv_location = (TextView) convertView.findViewById(R.id.tv_location);
            holder.img_contractorImage = (ImageView) convertView.findViewById(R.id.img_contractorImage);
            holder.tv_following = (TextView) convertView.findViewById(R.id.tv_following);
            holder.tv_archive = (TextView) convertView.findViewById(R.id.tv_archive);
            holder.tv_deactivate = (TextView) convertView.findViewById(R.id.tv_deactivate);
            holder.tv_delete = (TextView) convertView.findViewById(R.id.tv_delete);

            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.tv_ContractorName.setText(list.get(position).getJobTitle());
            holder.tv_postedon.setText(list.get(position).getPostedOn());
            holder.tv_location.setText(list.get(position).getCompanyName() + ", " + list.get(position).getJobState() + ", " + list.get(position).getJobCountry());
            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + list.get(position).getCompanyLogoImage(), holder.img_contractorImage, options);
            if (Integer.parseInt(list.get(position).getFollowersCount()) > 1) {
                holder.tv_following.setText(list.get(position).getFollowersCount() + " Followers");
            } else {
                holder.tv_following.setText(list.get(position).getFollowersCount() + " Follower");
            }


            holder.tv_following.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Fragment viewDonators = new ViewFollowers();


                    Bundle bundleDonators = new Bundle();
                    bundleDonators.putString("JOB_TILE", list.get(position).getJobTitle());
                    bundleDonators.putString("JOB_ID", list.get(position).getJobID());

                    viewDonators.setArguments(bundleDonators);
                    /*FragmentTransaction viewDonatorsTransation = getFragmentManager().beginTransaction();
                    viewDonatorsTransation.replace(R.id.container, viewDonators);
                    viewDonatorsTransation.addToBackStack(null);

                    viewDonatorsTransation.commit();*/
                    ((HomeActivity) context).replaceFragment(viewDonators);
                }
            });





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
                                        new DeleteJob().execute(list.get(position).getJobID());

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
                                        new ArchiveJob().execute(list.get(position).getJobID());

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
                                        new DeactivateJob().execute(list.get(position).getJobID());

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
        TextView tv_ContractorName, tv_postedon, tv_location, tv_following, tv_archive, tv_delete, tv_deactivate;
        ImageView img_contractorImage;

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

                ArrayList<JobListObject> filterList = new ArrayList<JobListObject>();

                for (int i = 0; i < mStringFilterList.size(); i++) {

                    if (mStringFilterList.get(i).getJobSkills().toLowerCase().startsWith(constraint.toString())) {
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

            list = (ArrayList<JobListObject>) results.values;
            notifyDataSetChanged();
        }
    }



///++++++++++++++++++++++++++++++DELETE+++++++++++++JOB+++++++++++++++++++


    private class DeleteJob extends AsyncTask<String, Void, Void> {

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
                jsonObject = new JSONObject(utilitiesClass.getJSON(Constants.DELETE_JOB_URL + "?job_id=" + params[0]));
            } catch (JSONException e) {
                e.printStackTrace();
            }

            return null;
        }
    }




///++++++++++++++++++++++++++++++ARCHIVEJOB+++++++++++++++++++





    private class ArchiveJob extends AsyncTask<String, Void, Void> {

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
                jsonObject = new JSONObject(utilitiesClass.getJSON(Constants.ARCHIVE_JOB_URL + "?job_id=" + params[0]));
            } catch (JSONException e) {
                e.printStackTrace();
            }

            return null;
        }
    }

///++++++++++++++++++++++++++++++DEACTIVATE++++JOB+++++++++++++++++++


    private class DeactivateJob extends AsyncTask<String, Void, Void> {

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
                jsonObject = new JSONObject(utilitiesClass.getJSON(Constants.DEACTIVATE_JOB_URL + "?job_id=" + params[0]));
            } catch (JSONException e) {
                e.printStackTrace();
            }

            return null;
        }
    }







}
