package com.staging.fragments;

import android.Manifest;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.WorkOrderAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.loadmore_listview.LoadMoreListView;
import com.staging.models.WorkOrderEntrepreneur;
import com.staging.swipelistview_withoutscrollview.SwipeMenu;
import com.staging.swipelistview_withoutscrollview.SwipeMenuCreator;
import com.staging.swipelistview_withoutscrollview.SwipeMenuItem;
import com.staging.swipelistview_withoutscrollview.SwipeMenuListView;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.DateTimeFormatClass;
import com.staging.utilities.UtilitiesClass;
import com.staging.utilities.UtilityList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

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
 * Created by sunakshi.gautam on 2/8/2016.
 */
public class WorkOrderStartUpEntrepreneur extends Fragment implements AsyncTaskCompleteListener<String> {

    private LinearLayout layout;
    private Button downloaddoc;
    private SwipeMenuListView mWorkorderList;
    private WorkOrderAdapter adapterWorkOrder;
    private ArrayList<WorkOrderEntrepreneur> listContractor;


    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            // we check that the fragment is becoming visible

            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_ENTREPRENEUR_WORKORDERS_TAG, Constants.STARTUP_ENTREPRENEUR_WORKORDERS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID, Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {

                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }

        }
    }

    @Override
    public void onResume() {
        super.onResume();
        if (CurrentStartUpFragment.strCommingFrom.compareTo("WORK_ORDERS") == 0) {

            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_ENTREPRENEUR_WORKORDERS_TAG, Constants.STARTUP_ENTREPRENEUR_WORKORDERS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID, Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {

                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        }
        else{

        }

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_workorderentreprenur, container, false);
        listContractor = new ArrayList<WorkOrderEntrepreneur>();
        mWorkorderList = (SwipeMenuListView) rootView.findViewById(R.id.listViewcontractors);
        layout = (LinearLayout) rootView.findViewById(R.id.layout);
        downloaddoc = (Button) rootView.findViewById(R.id.downloaddoc);

        mWorkorderList.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
            @Override
            public void onLoadMore() {
                mWorkorderList.onLoadMoreComplete();
            }
        });
        // step 1. create a MenuCreator
        SwipeMenuCreator creator = new SwipeMenuCreator() {

            @Override
            public void create(SwipeMenu menu) {

                SwipeMenuItem archive = new SwipeMenuItem(getActivity().getApplicationContext());
                // set item background
                Drawable arid = getResources().getDrawable(R.color.green);
                archive.setBackground(arid);
                // set item width
                archive.setWidth(dp2px(90));
                archive.setIcon(getResources().getDrawable(R.drawable.accept));
                // set item title
                archive.setTitle("Accept");
                // set item title fontsize
                archive.setTitleSize(15);
                // set item title font color
                archive.setTitleColor(Color.WHITE);
                // add to menu
                menu.addMenuItem(archive);


                // create "delete" item
                SwipeMenuItem deleteItem = new SwipeMenuItem(getActivity().getApplicationContext());
                // set item background
                Drawable delid = getResources().getDrawable(R.color.red);
                deleteItem.setBackground(delid);
                // set item width
                deleteItem.setWidth(dp2px(90));
                // set a icon
                deleteItem.setIcon(getResources().getDrawable(R.drawable.reject));
                deleteItem.setTitle("Reject");
                deleteItem.setTitleSize(15);
                deleteItem.setTitleColor(Color.WHITE);
                // add to menu
                menu.addMenuItem(deleteItem);
            }
        };
        // set creator
        mWorkorderList.setMenuCreator(creator);


        mWorkorderList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                try {
                    Fragment WorkOrderStartupEntrepreneurDetailsFragment = new WorkOrderStartupEntrepreneurDetails();

                    Bundle args = new Bundle();
                    args.putString("week_no", listContractor.get(position).getWeek_no() );
                    args.putString("contractor_id",  listContractor.get(position).getContactor_id());
                    args.putString("startup_id", listContractor.get(position).getStartup_id());
                    args.putString("startup_teamid", listContractor.get(position).getStartup_teamid());
                    WorkOrderStartupEntrepreneurDetailsFragment.setArguments(args);

                    ((HomeActivity) getActivity()).replaceFragment(WorkOrderStartupEntrepreneurDetailsFragment);
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
        });
        // step 2. listener item click event
        mWorkorderList.setOnMenuItemClickListener(new SwipeMenuListView.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(final int position, SwipeMenu menu, int index) {
                final WorkOrderEntrepreneur item = listContractor.get(position);
                switch (index) {
                    case 0:


                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            //

                            AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                            alertDialogBuilder
                                    .setMessage("Do you want to accept this workorder unit?")
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
                                            ((HomeActivity) getActivity()).showProgressDialog();
                                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_ENTREPRENEUR_WORKORDERS_ACCEPT_TAG, Constants.STARTUP_ENTREPRENEUR_WORKORDERS_ACCEPT_URL +"?startup_id="+CurrentStartUpDetailFragment.STARTUP_ID+"&user_id="+item.getTeam_memberid()+ "&week_no=" + listContractor.get(position).getWork_orderid(), Constants.HTTP_GET,"Home Activity");
                                            a.execute();

                                        }
                                    });

                            AlertDialog alertDialog = alertDialogBuilder.create();

                            alertDialog.show();


                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                        break;
                    case 1:
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            //((HomeActivity) getActivity()).showProgressDialog();

                            AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                            alertDialogBuilder
                                    .setMessage("Do you want to reject this workorder unit?")
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
                                            ((HomeActivity) getActivity()).showProgressDialog();
                                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_ENTREPRENEUR_WORKORDERS_REJECT_TAG, Constants.STARTUP_ENTREPRENEUR_WORKORDERS_REJECT_URL +"?startup_id="+CurrentStartUpDetailFragment.STARTUP_ID+"&user_id="+item.getTeam_memberid()+ "&week_no=" + listContractor.get(position).getWork_orderid(), Constants.HTTP_GET,"Home Activity");
                                            a.execute();

                                        }
                                    });

                            AlertDialog alertDialog = alertDialogBuilder.create();

                            alertDialog.show();

                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                        break;
                }
                return false;
            }
        });

        // set SwipeListener
        mWorkorderList.setOnSwipeListener(new SwipeMenuListView.OnSwipeListener() {

            @Override
            public void onSwipeStart(int position) {
                // swipe start
            }

            @Override
            public void onSwipeEnd(int position) {
                // swipe end
            }
        });

        // set MenuStateChangeListener
        mWorkorderList.setOnMenuStateChangeListener(new SwipeMenuListView.OnMenuStateChangeListener() {
            @Override
            public void onMenuOpen(int position) {
            }

            @Override
            public void onMenuClose(int position) {
            }
        });


        // test item long click
        mWorkorderList.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {

            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                Toast.makeText(getActivity().getApplicationContext(), position + " long click", Toast.LENGTH_LONG).show();
                return false;
            }
        });

        UtilityList.setListViewHeightBasedOnChildren(mWorkorderList);


        downloaddoc.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if ((ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                    requestPermission();
                } else {
                    downloadWorkOrder();
                }
            }
        });


        return rootView;
    }


    /**
     * Requests the Camera permission.
     * If the permission has been denied previously, a SnackBar will prompt the user to grant the
     * permission, otherwise it is requested directly.
     */
    private void requestPermission() {
        Log.i("TAG", "CAMERA permission has NOT been granted. Requesting permission.");

        // BEGIN_INCLUDE(camera_permission_request)
        if ((ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.CAMERA)) && ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE)) {
            // Provide an additional rationale to the user if the permission was not granted
            // and the user would benefit from additional context for the use of the permission.
            // For example if the user has previously denied the permission.
            Log.i("TAG", "Displaying camera permission rationale to provide additional context.");

            Snackbar.make(layout, R.string.app_permision, Snackbar.LENGTH_INDEFINITE)
                    .setAction("OK", new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.CAMERA, Manifest.permission.READ_EXTERNAL_STORAGE}, Constants.APP_PERMISSION);
                        }
                    })
                    .show();
        } else {

            // Camera permission has not been granted yet. Request it directly.
            ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.CAMERA, Manifest.permission.READ_EXTERNAL_STORAGE}, Constants.APP_PERMISSION);
        }
        // END_INCLUDE(camera_permission_request)
    }

    /**
     * Callback received when a permissions request has been completed.
     */
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {

        if (requestCode == Constants.APP_PERMISSION) {
            // BEGIN_INCLUDE(permission_result)
            // Received permission result for camera permission.
            Log.i("TAG", "Received response for Camera permission request.");

            // Check if the only required permission has been granted
            if (grantResults.length == 1 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Camera permission has been granted, preview can be displayed
                Log.i("TAG", "CAMERA permission has now been granted. Showing preview.");
                Snackbar.make(layout, R.string.permision_available_camera, Snackbar.LENGTH_SHORT).show();
            } else {
                Log.i("TAG", "CAMERA permission was NOT granted.");
                Snackbar.make(layout, R.string.permissions_not_granted, Snackbar.LENGTH_SHORT).show();
            }
        } else {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }


    private void downloadWorkOrder() {
        JSONObject jsonObject = new JSONObject();

        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.DOWNLOAD_STARTUP_ENTREPRENEUR_WORKORDERS_TAG, Constants.DOWNLOAD_STARTUP_ENTREPRENEUR_WORKORDERS_URL + "?startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID, Constants.HTTP_GET,"Home Activity");
            a.execute();
        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }
    }


    private int dp2px(int dp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp,
                getResources().getDisplayMetrics());
    }

    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {


            if (tag.equalsIgnoreCase(Constants.STARTUP_ENTREPRENEUR_WORKORDERS_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);
                    listContractor.clear();
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        JSONArray workOrders = jsonObject.optJSONArray("approvalList");
                        for (int i = 0; i < workOrders.length(); i++) {

                            WorkOrderEntrepreneur obj = new WorkOrderEntrepreneur();

                            obj.setContractorName(workOrders.getJSONObject(i).optString("first_name")+" "+workOrders.getJSONObject(i).optString("last_name"));
                            obj.setWorkUnitEntered(workOrders.getJSONObject(i).optString("total_work_units"));
                            obj.setDateEntered(DateTimeFormatClass.convertStringObjectToMMDDYYYFormat(workOrders.getJSONObject(i).optString("start_date")));
                            obj.setRoadmap_name(workOrders.getJSONObject(i).optString("deliverable_name"));
                            obj.setTeam_memberid(workOrders.getJSONObject(i).optString("user_id"));
                            obj.setWork_orderid(workOrders.getJSONObject(i).optString("week_no"));
                            obj.setContactor_id(workOrders.getJSONObject(i).optString("contractor_id"));
                            obj.setWeek_no(workOrders.getJSONObject(i).optString("week_no"));
                            obj.setStartup_id(workOrders.getJSONObject(i).optString("startup_id"));
                            obj.setStartup_teamid(workOrders.getJSONObject(i).optString("startup_team_id"));


                            listContractor.add(obj);
                        }


                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "No workorders available", Toast.LENGTH_LONG).show();
                        listContractor.clear();
                    }

                    adapterWorkOrder = new WorkOrderAdapter(getActivity(), listContractor);
                    mWorkorderList.setAdapter(adapterWorkOrder);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            } else if ((tag.equalsIgnoreCase(Constants.STARTUP_ENTREPRENEUR_WORKORDERS_ACCEPT_TAG)) || (tag.equalsIgnoreCase(Constants.STARTUP_ENTREPRENEUR_WORKORDERS_REJECT_TAG))) {
                ((HomeActivity) getActivity()).dismissProgressDialog();

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            //((HomeActivity) getActivity()).showProgressDialog();
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_ENTREPRENEUR_WORKORDERS_TAG, Constants.STARTUP_ENTREPRENEUR_WORKORDERS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID, Constants.HTTP_GET,"Home Activity");
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                    }

                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.DOWNLOAD_STARTUP_ENTREPRENEUR_WORKORDERS_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        String filePath = Constants.APP_IMAGE_URL + "/" + jsonObject.getString("file_path").replaceAll(" ", "%20");
                        int index = filePath.lastIndexOf("/");
                        String[] parmas = {filePath, filePath.substring(index + 1).toString()};
                        if (UtilitiesClass.isDownloadManagerAvailable(getActivity())) {
                            ((HomeActivity)getActivity()).utilitiesClass.downloadFile(filePath, filePath.substring(index + 1).toString());
                        }else{
                            new DownloadFile().execute(parmas);
                        }
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "File Not Found.", Toast.LENGTH_LONG).show();
                    }


                } catch (JSONException e) {

                    e.printStackTrace();
                }
            }
        }
    }


    class DownloadFile extends AsyncTask<String, Integer, String> {

        ProgressDialog dialog = new ProgressDialog(getActivity());


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
                    File outputFile = new File(appFolder.getPath() + File.separator + timeStamp + sUrl[1]);
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
                    Toast.makeText(getActivity(), "You SD Card is not applicable for downloading!", Toast.LENGTH_LONG).show();
                } else {
                    Toast.makeText(getActivity(), "Please insert sd card!", Toast.LENGTH_LONG).show();
                }
            } catch (Exception e) {
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


}
