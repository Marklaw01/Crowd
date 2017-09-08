package com.crowdbootstrap.adapter;

import android.app.DownloadManager;
import android.app.ProgressDialog;
import android.content.Context;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Environment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.models.DocumentObject;
import com.crowdbootstrap.utilities.Constants;
import com.crowdbootstrap.utilities.NetworkConnectivity;
import com.crowdbootstrap.utilities.UtilitiesClass;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

/**
 * Created by sunakshi.gautam on 1/27/2016.
 */
public class DocumentsAdapter extends BaseAdapter implements Filterable {

    private NetworkConnectivity networkConnectivity;
    private UtilitiesClass utilitiesClass;
    private ValueFilter valueFilter;
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<DocumentObject> list;
    ArrayList<DocumentObject> mStringFilterList = new ArrayList<DocumentObject>();

    public DocumentsAdapter(Context context, ArrayList<DocumentObject> list) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
        mStringFilterList = list;
        networkConnectivity = NetworkConnectivity.getInstance(context);
        utilitiesClass = UtilitiesClass.getInstance(context);
    }

    @Override
    public int getCount() {
        return list.size();
    }

    @Override
    public DocumentObject getItem(int position) {
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
            convertView = l_Inflater.inflate(R.layout.docs_list_item, null);
            holder = new ViewHolder();

            holder.doc_date = (TextView) convertView.findViewById(R.id.datetext);
            holder.uploader_name = (TextView) convertView.findViewById(R.id.nametext);

            holder.roadmap = (TextView) convertView.findViewById(R.id.roadmaptext);
            holder.doc_name = (TextView) convertView.findViewById(R.id.docnametext);
            holder.download = (ImageView) convertView.findViewById(R.id.download);


            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.doc_date.setText(list.get(position).getDate());
            holder.uploader_name.setText(list.get(position).getUser_name());
            holder.roadmap.setText(list.get(position).getRoadmap_name());
            holder.doc_name.setText(list.get(position).getDoc_name());

            holder.download.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    String[] parmas = {list.get(position).getDownload_link().replaceAll(" ", "%20"), list.get(position).getDoc_name()};

                    //String url = utilitiesClass.removeSpecialCharacters(list.get(position).getDownload_link());
                    //downloadUsingDownloadManager(url);
                    //

                    if (UtilitiesClass.isDownloadManagerAvailable(context)) {
                        utilitiesClass.downloadFile(list.get(position).getDownload_link().replaceAll(" ", "%20"), list.get(position).getDoc_name()+".pdf");
                    }else{
                        new DownloadFile().execute(parmas);
                    }

                }
            });


        } catch (Exception e) {
            e.printStackTrace();
        }
        return convertView;
    }

    static class ViewHolder {
        TextView doc_date;
        TextView uploader_name;
        TextView roadmap;
        TextView doc_name;
        ImageView download;

    }


    class DownloadFile extends AsyncTask<String, Integer, String> {

        ProgressDialog dialog = new ProgressDialog(context);


        @Override
        protected String doInBackground(String... sUrl) {
            try {
                URL url = new URL(sUrl[0]);
                System.out.println(sUrl[0]);

                URLConnection connection = url.openConnection();
                connection.connect();
                // this will be useful so that you can show a typical 0-100% progress bar
                int fileLength = connection.getContentLength();
                String state = Environment.getExternalStorageState();
                if (Environment.MEDIA_MOUNTED.equalsIgnoreCase(state)) {

                    File appFolder = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM), Constants.IMAGE_DIRECTORY_NAME);

                    if (!appFolder.exists()) {
                        if (!appFolder.mkdirs()) {
                            Log.d(Constants.IMAGE_DIRECTORY_NAME, "Oops! Failed create " + Constants.IMAGE_DIRECTORY_NAME + " directory");
                            return null;
                        }
                    }

                    String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(new Date());
                    //mediaFile = new File(mediaStorageDir.getPath() + File.separator + "IMG_" + timeStamp + ".jpg");
                    File outputFile = new File(appFolder.getPath() + File.separator + timeStamp + sUrl[1] + ".pdf");
                    // download the file
                    InputStream input = new BufferedInputStream(url.openStream());
                    FileOutputStream fos = new FileOutputStream(outputFile);

                    byte data[] = new byte[1024];
                    long total = 0;
                    int count;
                    while ((count = input.read(data)) != -1) {
                        total += count;
                        // publishing the progress....
                        publishProgress((int) (total * 100 / fileLength));
                        fos.write(data, 0, count);
                    }

                    fos.flush();
                    fos.close();
                    input.close();
                } else if (Environment.MEDIA_MOUNTED_READ_ONLY.equalsIgnoreCase(state)) {
                    Toast.makeText(context, "You SD Card is not applicable for downloading!", Toast.LENGTH_LONG).show();
                } else {
                    Toast.makeText(context, "Please insert sd card!", Toast.LENGTH_LONG).show();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);
            dialog.dismiss();
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();

            dialog.setMessage("Downloading...");
            dialog.setIndeterminate(false);
            dialog.setMax(100);
            dialog.setCancelable(false);
            dialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
            dialog.show();
        }

        @Override
        protected void onProgressUpdate(Integer... progress) {
            super.onProgressUpdate(progress);
            dialog.setProgress(progress[0]);
        }

    }

    private void downloadUsingDownloadManager(String url) {
        String servicestring = Context.DOWNLOAD_SERVICE;
        DownloadManager downloadmanager;
        downloadmanager = (DownloadManager) context.getSystemService(servicestring);
        Uri uri = Uri.parse(url);
        DownloadManager.Request request = new DownloadManager.Request(uri);
        Long reference = downloadmanager.enqueue(request);
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

                ArrayList<DocumentObject> filterList = new ArrayList<DocumentObject>();

                for (int i = 0; i < mStringFilterList.size(); i++) {

                    if (mStringFilterList.get(i).getUser_name().toLowerCase().startsWith(constraint.toString())) {
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

            list = (ArrayList<DocumentObject>) results.values;
            notifyDataSetChanged();
        }
    }
}