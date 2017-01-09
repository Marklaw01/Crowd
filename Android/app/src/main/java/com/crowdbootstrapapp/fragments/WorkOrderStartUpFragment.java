package com.crowdbootstrapapp.fragments;

import android.Manifest;
import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.drawable.LayerDrawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RatingBar;
import android.widget.TextView;
import android.widget.Toast;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.adapter.WorkOrderContractorTableAdapter;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.models.RoadmapDeliverables;
import com.crowdbootstrapapp.models.WorkOrderItem;
import com.crowdbootstrapapp.utilities.Async;
import com.crowdbootstrapapp.utilities.Constants;
import com.crowdbootstrapapp.utilities.UtilitiesClass;
import com.inqbarna.tablefixheaders.TableFixHeaders;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

/**
 * Created by sunakshi.gautam on 1/21/2016.
 */
public class WorkOrderStartUpFragment extends Fragment implements AsyncTaskCompleteListener<String> {

    private LinearLayout layout;
    private TableFixHeaders tableFixHeaders;
    private String dayText;
    private String dateText;

    public static ArrayList<WorkOrderItem> arrDeliverablesworkUnitsLabel;
    public static ArrayList<String> arrDeliverablesLabel;
    private ArrayList<RoadmapDeliverables> arrDeliverablesID;
    private ArrayList<String> arrTotalOfWorkUnitsDeliverable;
    private ArrayList<String> arrDeliverablesDate;
    //    private Spinner spnrDeliverable_Name;
//    private EditText edt_Workunit_date;
//    private EditText edt_Workunit;
    private Button btnUpdateWorkOrder;
    private Button btnDownloadWorkOrder;

    private DatePickerDialog.OnDateSetListener date;
    private Calendar myCalendar;
    private int[] arrayWorkunits;
    public static int[] sumOfColumnText;


    private RatingBar entrepreneurRating;
    private EditText entrepreneursComment;
    private EditText contractorsComment;
    private Button submitRatingComments;


    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            // we check that the fragment is becoming visible

            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();

                Calendar cal = Calendar.getInstance();
                SimpleDateFormat sdfDate = new SimpleDateFormat("MMM d, yyyy");
                SimpleDateFormat sdfDay = new SimpleDateFormat("EEE");
                dateText = "" + sdfDate.format(cal.getTime());
                dayText = "" + sdfDay.format(cal.getTime());
                JSONObject jsonObject = new JSONObject();
                try {

                    jsonObject.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    jsonObject.put("startup_id", CurrentStartUpDetailFragment.STARTUP_ID);
                    jsonObject.put("date", dateText);
                    jsonObject.put("day", dayText);
                    jsonObject.put("startup_team_id", CurrentStartUpDetailFragment.STARTUP_TEAMID);
                    jsonObject.put("contractor_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    jsonObject.put("entrepreneur_id", CurrentStartUpDetailFragment.ENTREPRENEUR_ID);
                    jsonObject.put("is_entrepreneur", "0");

                } catch (JSONException e) {
                    e.printStackTrace();
                }
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_WORKORDER_TAG, Constants.STARTUP_WORKORDER_URL, Constants.HTTP_POST, jsonObject, "Home Activity");
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

                Calendar cal = Calendar.getInstance();
                SimpleDateFormat sdfDate = new SimpleDateFormat("MMM d, yyyy");
                SimpleDateFormat sdfDay = new SimpleDateFormat("EEE");
                dateText = "" + sdfDate.format(cal.getTime());
                dayText = "" + sdfDay.format(cal.getTime());
                JSONObject jsonObject = new JSONObject();
                try {

                    jsonObject.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    jsonObject.put("startup_id", CurrentStartUpDetailFragment.STARTUP_ID);
                    jsonObject.put("date", dateText);
                    jsonObject.put("day", dayText);
                    jsonObject.put("startup_team_id", CurrentStartUpDetailFragment.STARTUP_TEAMID);
                    jsonObject.put("contractor_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    jsonObject.put("entrepreneur_id", CurrentStartUpDetailFragment.ENTREPRENEUR_ID);
                    jsonObject.put("is_entrepreneur", "0");

                } catch (JSONException e) {
                    e.printStackTrace();
                }
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_WORKORDER_TAG, Constants.STARTUP_WORKORDER_URL, Constants.HTTP_POST, jsonObject, "Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        } else {

        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_workordercontractor, container, false);
        layout = (LinearLayout) rootView.findViewById(R.id.layout);
        arrDeliverablesLabel = new ArrayList<String>();
        arrDeliverablesID = new ArrayList<RoadmapDeliverables>();
        arrTotalOfWorkUnitsDeliverable = new ArrayList<String>();
        arrDeliverablesDate = new ArrayList<String>();
        arrDeliverablesworkUnitsLabel = new ArrayList<WorkOrderItem>();

        tableFixHeaders = (TableFixHeaders) rootView.findViewById(R.id.workordertable);
        btnUpdateWorkOrder = (Button) rootView.findViewById(R.id.updateworkorder);
        btnDownloadWorkOrder = (Button) rootView.findViewById(R.id.downloadworkorder);


        entrepreneurRating = (RatingBar) rootView.findViewById(R.id.rating);
        entrepreneursComment = (EditText) rootView.findViewById(R.id.entreprenuerscomment);
        contractorsComment = (EditText) rootView.findViewById(R.id.contractorscomment);
        submitRatingComments = (Button) rootView.findViewById(R.id.saveComment);


        if (CurrentStartUpDetailFragment.from.compareTo("complete") == 0) {

            entrepreneurRating.setIsIndicator(true);
            btnUpdateWorkOrder.setVisibility(View.GONE);
            btnDownloadWorkOrder.setVisibility(View.GONE);
            submitRatingComments.setVisibility(View.GONE);
            entrepreneursComment.setEnabled(false);
            contractorsComment.setEnabled(false);
        } else if (CurrentStartUpDetailFragment.from.compareTo("current") == 0) {
            entrepreneurRating.setIsIndicator(true);
            btnUpdateWorkOrder.setVisibility(View.VISIBLE);
            btnDownloadWorkOrder.setVisibility(View.VISIBLE);
            submitRatingComments.setVisibility(View.VISIBLE);
            entrepreneursComment.setEnabled(false);
            contractorsComment.setEnabled(true);
        } else {
            entrepreneurRating.setIsIndicator(false);
            btnUpdateWorkOrder.setVisibility(View.GONE);
            btnDownloadWorkOrder.setVisibility(View.VISIBLE);
            submitRatingComments.setVisibility(View.VISIBLE);
            entrepreneursComment.setEnabled(true);
            contractorsComment.setEnabled(false);

        }


        myCalendar = Calendar.getInstance();
        date = new DatePickerDialog.OnDateSetListener()

        {

            @Override
            public void onDateSet(DatePicker view, int year, int monthOfYear,
                                  int dayOfMonth) {

                myCalendar.set(Calendar.YEAR, year);
                myCalendar.set(Calendar.MONTH, monthOfYear);
                myCalendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);
//                edt_Workunit_date.setText(DateTimeFormatClass.convertDateObjectToMMDDYYYFormat(myCalendar.getTime()));

            }
        }

        ;


        submitRatingComments.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                String str_given_by = contractor_id;
                String str_given_to = entrepreneur_id;
                String str_is_entrepreneur = "0";
                String str_startup_id = startUP_ID;
                String str_startup_team_id = startup_teamId;
                String str_status = "1";
                String str_week_no = week_no;
                String str_work_comment = contractorsComment.getText().toString();
                String str_rating_star = String.valueOf(entrepreneurRating.getRating());


                JSONObject finalCommentObject = new JSONObject();

                try {
                    finalCommentObject.put("given_by", str_given_by);
                    finalCommentObject.put("given_to", str_given_to);
                    finalCommentObject.put("work_comment", str_work_comment);
                    finalCommentObject.put("startup_id", str_startup_id);
                    finalCommentObject.put("rating_star", str_rating_star);
                    finalCommentObject.put("week_no", str_week_no);
                    finalCommentObject.put("status", str_status);
                    finalCommentObject.put("is_entrepreneur", str_is_entrepreneur);
                    finalCommentObject.put("startup_team_id", str_startup_team_id);
                } catch (JSONException e) {

                    e.printStackTrace();
                }


                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_WORKORDER_COMMENT_TAG, Constants.STARTUP_WORKORDER_COMMENT_URL, Constants.HTTP_POST, finalCommentObject, "Home Activity");
                a.execute();


            }
        });

        btnUpdateWorkOrder.setOnClickListener(new View.OnClickListener()

                                              {
                                                  @Override
                                                  public void onClick(View v) {

                                                      Fragment workOderUpdate = new WorkOrderStartupUpdateFragment();
                                                      ((HomeActivity) getActivity()).replaceFragment(workOderUpdate);
                                                  }
                                              }

        );
        btnDownloadWorkOrder.setOnClickListener(new View.OnClickListener()

                                                {
                                                    @Override
                                                    public void onClick(View v) {

                                                        if ((ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                                                            requestPermission();
                                                        } else {
                                                            downloadWorkOrder();
                                                        }


                                                    }
                                                }

        );


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


    private String roadMapId;
    private String workDate;
    private String workunits;

    private void updateWorkOrder() {
        int approvedWorkUnit = 0, pendingWorkUnits = 0;
        int approvedHoursInteger = Integer.parseInt(approvedHours);
        int WorkUnitEntered = Integer.parseInt(workunits);
        int ConsumedWorkUnits = Integer.parseInt(consumedHours);


        if (ConsumedWorkUnits <= approvedHoursInteger) {

            approvedHoursInteger = approvedHoursInteger - ConsumedWorkUnits;

            if ((approvedHoursInteger - WorkUnitEntered) >= 0) {
                approvedWorkUnit = WorkUnitEntered;
                pendingWorkUnits = 0;
            } else if ((WorkUnitEntered - approvedHoursInteger) > 0) {
                approvedWorkUnit = approvedHoursInteger;
                pendingWorkUnits = WorkUnitEntered - approvedHoursInteger;
            }
        } else if (ConsumedWorkUnits > approvedHoursInteger) {
            approvedWorkUnit = 0;
            pendingWorkUnits = WorkUnitEntered;

        }

        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();


            JSONObject approvedObject = new JSONObject();
            try {
                if (approvedWorkUnit > 0) {
                    approvedObject.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    approvedObject.put("startup_id", startUP_ID);
                    approvedObject.put("roadmap_id", roadMapId);
                    approvedObject.put("work_date", workDate);
                    approvedObject.put("workunit", String.valueOf(approvedWorkUnit));
                } else {

                }
            } catch (JSONException e) {

                e.printStackTrace();
            }


            JSONObject notApprovedObject = new JSONObject();
            try {
                if (pendingWorkUnits > 0) {
                    notApprovedObject.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    notApprovedObject.put("startup_id", startUP_ID);
                    notApprovedObject.put("roadmap_id", roadMapId);
                    notApprovedObject.put("work_date", workDate);
                    notApprovedObject.put("workunit", String.valueOf(pendingWorkUnits));
                } else {

                }
            } catch (JSONException e) {

                e.printStackTrace();
            }

            JSONObject finalUpdateObject = new JSONObject();

            try {
                finalUpdateObject.put("Approved", approvedObject);
                finalUpdateObject.put("Pending", notApprovedObject);

            } catch (JSONException e) {

                e.printStackTrace();
            }

            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_WORKORDER_UPDATE_TAG, Constants.STARTUP_WORKORDER_UPDATE_URL, Constants.HTTP_POST, finalUpdateObject, "Home Activity");
            a.execute();
        } else {

            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }

    }

    private void downloadWorkOrder() {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
            jsonObject.put("startup_id", CurrentStartUpDetailFragment.STARTUP_ID);
            jsonObject.put("date", dateText);
            jsonObject.put("day", dayText);

        } catch (JSONException e) {
            e.printStackTrace();
        }

        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();
            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.DOWNLOAD_CONTRACTOR_STARTUP_WORKORDER_TAG, Constants.DOWNLOAD_CONTRACTOR_STARTUP_WORKORDER_URL, Constants.HTTP_POST, jsonObject, "Home Activity");
            a.execute();
        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }
    }


    public class MyAdapter extends WorkOrderContractorTableAdapter {

        private final int width;
        private final int height;

        public MyAdapter(Context context) {
            super(context);

            Resources resources = context.getResources();

            width = resources.getDimensionPixelSize(R.dimen.table_width);
            height = resources.getDimensionPixelSize(R.dimen.table_height);
        }

        @Override
        public int getRowCount() {
            return 10;
        }

        @Override
        public int getColumnCount() {
            return arrDeliverablesLabel.size();
        }

        @Override
        public int getWidth(int column) {
            return width;
        }

        @Override
        public int getHeight(int row) {
            return height;
        }

        @Override
        public String getCellString(int row, int column) {
            DateFormat format = new SimpleDateFormat(Constants.DATE_FORMAT);
            DateFormat formatDays = new SimpleDateFormat("EEE");
            DateFormat formatAPI = new SimpleDateFormat("yyyy-MM-dd");
            Date dateEntered = null;


            Calendar calendar = Calendar.getInstance();

            calendar.setFirstDayOfWeek(Calendar.MONDAY);
            calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
            String[] days = new String[7];

            String[] weekDays = new String[7];
            String[] dayAPI = new String[7];
            for (int i = 0; i < 7; i++) {

                try {
                    dateEntered = formatAPI.parse(arrDeliverablesDate.get(i).toString());
                } catch (ParseException e) {
                    e.printStackTrace();
                }
                days[i] = format.format(dateEntered);
                weekDays[i] = formatDays.format(calendar.getTime());
                dayAPI[i] = formatAPI.format(dateEntered);
                calendar.add(Calendar.DAY_OF_MONTH, 1);
            }


            String layoutText = "null";
            switch (getItemViewType(row, column)) {
                case 0:
                    layoutText = arrDeliverablesLabel.get(column).toString();
                    break;
                case 1:

                    if (row < 7) {
                        if (arrDeliverablesDate.get(row).compareTo(dayAPI[row]) == 0) {

                            Log.e("XXX", "ROWS++" + String.valueOf(row) + "++++++++++" + "COLUMNS+++" + String.valueOf(column));

                            for (int i = 0; i < arrDeliverablesworkUnitsLabel.size(); i++) {

                                if ((arrDeliverablesworkUnitsLabel.get(i).getDeliverableName().compareTo(arrDeliverablesLabel.get(column)) == 0) &&

                                        (arrDeliverablesworkUnitsLabel.get(i).getDate().compareTo(arrDeliverablesDate.get(row)) == 0)
                                        ) {
                                    Log.e("XXX", "VALUES+++" + arrDeliverablesworkUnitsLabel.get(i).getWorkUnit());
                                    layoutText = "" + arrDeliverablesworkUnitsLabel.get(i).getWorkUnit();

                                } else {

                                    //layoutText = "" + "0";
                                    continue;

                                }
                            }

                            if (layoutText.compareTo("null") == 0) {
                                layoutText = "" + "0";
                            }
                        }

                    } else if (row == 7) {


                        layoutText = "" + arrTotalOfWorkUnitsDeliverable.get(column);
                    } else if (row == 8) {
                        remainingHours = (Integer.parseInt(approvedHours) - Integer.parseInt(consumedHours));
                        if (column == 0) {
                            layoutText = "" + String.valueOf(remainingHours);
                        } else {
                            layoutText = "-";
                        }
                    } else if (row == 9) {
                        if (column == 0) {
                            layoutText = approvedHours;
                        } else {
                            layoutText = "-";
                        }
                    }
                    //layoutResource = R.layout.item_table1;
                    break;
                case 2:
                    layoutText = "" + dateText;
                    break;
                case 3:
                    if (row < 7) {
                        layoutText = days[row] + ":" + weekDays[row];

                        // layoutText = arrDeliverablesDate.get(row).toString() + ":" + weekDays[row];
                    } else if (row == 7) {
                        layoutText = "Total";
                    } else if (row == 8) {
                        layoutText = "Remaining";
                    } else if (row == 9) {
                        layoutText = "Allocated";
                    }


                    break;
                default:
                    throw new RuntimeException("Exception in the Table Adapter");
            }
            return layoutText;

        }

        @Override
        public void callAPI(String Dste) {
            //((HomeActivity) getActivity()).setOnBackPressedListener((AsyncTaskCompleteListener<String>) this);
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Date dateEntered = null;
                Date dayEntered = null;

                Calendar cal = Calendar.getInstance();
                SimpleDateFormat sdfDate = new SimpleDateFormat("MMM d, yyyy");
                SimpleDateFormat sdfDay = new SimpleDateFormat("EEE");


                try {
                    dateEntered = sdfDate.parse(Dste);
                    dayEntered = sdfDate.parse(Dste);
                } catch (ParseException e) {
                    e.printStackTrace();
                }
                dateText = "" + sdfDate.format(dateEntered);
                dayText = "" + sdfDay.format(dayEntered);
                JSONObject jsonObject = new JSONObject();
                try {

                    jsonObject.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    jsonObject.put("startup_id", CurrentStartUpDetailFragment.STARTUP_ID);
                    jsonObject.put("date", dateText);
                    jsonObject.put("day", dayText);
                    jsonObject.put("startup_team_id", CurrentStartUpDetailFragment.STARTUP_TEAMID);
                    jsonObject.put("contractor_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    jsonObject.put("entrepreneur_id", CurrentStartUpDetailFragment.ENTREPRENEUR_ID);
                    jsonObject.put("is_entrepreneur", "0");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_WORKORDER_TAG, Constants.STARTUP_WORKORDER_URL, Constants.HTTP_POST, jsonObject, "Home Activity");
                a.execute();
            } else {

                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }

        }

        @Override
        public int getLayoutResource(int row, int column) {
            final int layoutResource;
            switch (getItemViewType(row, column)) {
                case 0:
                    layoutResource = R.layout.item_table1_header;
                    break;
                case 1:
                    layoutResource = R.layout.item_table1;
                    break;
                case 2:
                    layoutResource = R.layout.item_calendertableheader;
                    break;
                case 3:
                    layoutResource = R.layout.item_columheader;
                    break;
                default:
                    throw new RuntimeException("Exception in the Table Adapter");
            }
            return layoutResource;
        }


        @Override
        public int getItemViewType(int row, int column) {
            if ((row < 0) && (column >= 0)) {
                return 0;
            } else if ((row < 0) && (column < 0)) {
                return 2;
            } else if (column < 0) {
                return 3;
            } else {
                return 1;
            }
        }

        @Override
        public int getViewTypeCount() {
            return 4;
        }
    }


    private String allocatedHours;
    private String approvedHours;
    private String consumedHours;
    private String teamMember_ID;
    private String startUP_ID;
    private int remainingHours;
    public static String startup_teamId;
    private String week_no;
    private String entrepreneur_id;
    private String contractor_id;
    private String entrepreneur_comment;
    private String contractor_comment;
    private String iscontractor_comment_editable;
    private String ratingValue;


    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {


            if (tag.equalsIgnoreCase(Constants.STARTUP_WORKORDER_UPDATE_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();

//                    edt_Workunit.setText("");
//                    edt_Workunit_date.setText("Date");

                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.STARTUP_WORKORDER_TAG)) {

                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    arrDeliverablesLabel.clear();
                    arrDeliverablesworkUnitsLabel.clear();
                    arrDeliverablesDate.clear();
                    arrDeliverablesID.clear();
                    arrTotalOfWorkUnitsDeliverable.clear();

                    allocatedHours = jsonObject.optString("Allocated_hours").trim();
                    approvedHours = jsonObject.optString("Approved_hours").trim();
                    consumedHours = jsonObject.optString("consumedHours").trim();
                    teamMember_ID = jsonObject.optString("teammember_id").trim();
                    startUP_ID = jsonObject.optString("startup_id").trim();
                    startup_teamId = jsonObject.optString("startup_team_id").trim();
                    week_no = jsonObject.optString("week_no").trim();
                    entrepreneur_id = jsonObject.optString("entrepreneur_id").trim();
                    contractor_id = jsonObject.optString("contractor_id").trim();

                    entrepreneur_comment = jsonObject.optString("entrepreneur_comment").trim();
                    contractor_comment = jsonObject.optString("contractor_comment").trim();
                    iscontractor_comment_editable = jsonObject.optString("is_editable").trim();
                    ratingValue = jsonObject.optString("entrepreneur_rating_star").trim();

                    for (int k = 0; k < jsonObject.optJSONArray("Maindeliverables").length(); k++) {
                        JSONObject mainDeliverable_OBJ = jsonObject.optJSONArray("Maindeliverables").getJSONObject(k);
                        String deliverableName = mainDeliverable_OBJ.optString("deliverable_name").trim();
                        String deliverableid = mainDeliverable_OBJ.optString("deliverable_id").trim();
                        arrDeliverablesLabel.add(deliverableName);

                        RoadmapDeliverables deliverablesID = new RoadmapDeliverables();
                        deliverablesID.setId(deliverableid);
                        deliverablesID.setRoadmapName(deliverableName);
                        arrDeliverablesID.add(deliverablesID);
                        arrTotalOfWorkUnitsDeliverable.add("0");

                    }

                    for (int i = 0; i < jsonObject.optJSONArray("weekly_update").length(); i++) {
                        JSONObject weekly_Workorder_OBJ = jsonObject.optJSONArray("weekly_update").getJSONObject(i);
                        String deliverableDate = weekly_Workorder_OBJ.optString("date").trim();
                        arrDeliverablesDate.add(deliverableDate);
                        if (weekly_Workorder_OBJ.optJSONArray("deliverables").length() == jsonObject.optJSONArray("Maindeliverables").length()) {


                            for (int j = 0; j < weekly_Workorder_OBJ.optJSONArray("deliverables").length(); j++) {
                                JSONObject weekly_Deliverable_OBJ = weekly_Workorder_OBJ.optJSONArray("deliverables").getJSONObject(j);
                                String deliverableName = weekly_Deliverable_OBJ.optString("deliverable_name").trim();
                                String deliverableWorkUnits = weekly_Deliverable_OBJ.optString("work_units").trim();
                                String deliverableWorkOrderID = weekly_Deliverable_OBJ.optString("work_orderid").trim();
                                String deliverableID = weekly_Deliverable_OBJ.optString("deliverable_id").trim();


                                WorkOrderItem item = new WorkOrderItem();
                                item.setDate(deliverableDate);
                                item.setDeliverableName(deliverableName);
                                item.setWorkUnit(deliverableWorkUnits);
                                item.setWorkorderID(deliverableWorkOrderID);
                                item.setDeliverableID(deliverableID);
                                item.setStartupID(startUP_ID);
                                arrDeliverablesworkUnitsLabel.add(item);
                            }
                        } else if (weekly_Workorder_OBJ.optJSONArray("deliverables").length() < jsonObject.optJSONArray("Maindeliverables").length()) {
                            for (int l = 0; l < jsonObject.optJSONArray("Maindeliverables").length(); l++) {
                                String DeliverableID = jsonObject.optJSONArray("Maindeliverables").getJSONObject(l).optString("deliverable_id").trim();
                                boolean is_added = false;
                                for (int j = 0; j < weekly_Workorder_OBJ.optJSONArray("deliverables").length(); j++) {
                                    JSONObject weekly_Deliverable_OBJ = weekly_Workorder_OBJ.optJSONArray("deliverables").getJSONObject(j);
                                    String deliverableName = weekly_Deliverable_OBJ.optString("deliverable_name").trim();
                                    String deliverableWorkUnits = weekly_Deliverable_OBJ.optString("work_units").trim();
                                    String deliverableWorkOrderID = weekly_Deliverable_OBJ.optString("work_orderid").trim();
                                    String deliverableID = weekly_Deliverable_OBJ.optString("deliverable_id").trim();

                                    if (jsonObject.optJSONArray("Maindeliverables").getJSONObject(l).optString("deliverable_id").trim().compareTo(deliverableID) == 0) {
                                        is_added = true;
                                        WorkOrderItem item = new WorkOrderItem();
                                        item.setDate(deliverableDate);
                                        item.setDeliverableName(deliverableName);
                                        item.setWorkUnit(deliverableWorkUnits);
                                        item.setWorkorderID(deliverableWorkOrderID);
                                        item.setDeliverableID(deliverableID);
                                        item.setStartupID(startUP_ID);
                                        arrDeliverablesworkUnitsLabel.add(item);
                                        break;
                                    } else {
                                        continue;
                                    }
                                }

                                if (is_added == false) {
                                    WorkOrderItem item = new WorkOrderItem();
                                    item.setDate(deliverableDate);
                                    item.setDeliverableName("");
                                    item.setWorkUnit("0");
                                    item.setWorkorderID("");
                                    item.setDeliverableID(DeliverableID);
                                    item.setStartupID(startUP_ID);
                                    arrDeliverablesworkUnitsLabel.add(item);
                                }
                            }
                        }
                    }


                    //remove all the duplicate items from the table
//                    HashSet<String> hashSet = new HashSet<String>();
//                    hashSet.addAll(arrDeliverables);
//                    arrDeliverables.clear();
//                    arrDeliverables.addAll(hashSet);

                    Log.e("XXX", arrDeliverablesLabel.toString());

                    tableFixHeaders.setAdapter(new MyAdapter(getActivity()));
                    arrayWorkunits = new int[arrDeliverablesworkUnitsLabel.size()];

                    for (int i = 0; i < arrDeliverablesworkUnitsLabel.size(); i++) {
                        arrayWorkunits[i] = Integer.parseInt(arrDeliverablesworkUnitsLabel.get(i).getWorkUnit());
                    }


                    int[][] mTwoDimensionalArray = monoToBidi(arrayWorkunits, 7, arrDeliverablesLabel.size());

                    System.out.println(Arrays.deepToString(mTwoDimensionalArray));

                    sumOfColumnText = sumTableColumns(mTwoDimensionalArray);
                    System.out.println(Arrays.toString(sumOfColumnText));
                    /*ArrayAdapter<String> contributorTypeAdapter = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_spinner_item, android.R.id.text1, arrDeliverables);
                    spnrDeliverable_Name.setAdapter(contributorTypeAdapter);*/
                    ArrayAdapter<String> contributorTypeAdapter = new ArrayAdapter<String>(getActivity(), R.layout.spinner_item, arrDeliverablesLabel);
                    contributorTypeAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

                    contractorsComment.setText(contractor_comment);
                    entrepreneursComment.setText(entrepreneur_comment);


                    if (CurrentStartUpDetailFragment.from.compareTo("complete") == 0) {
                        contractorsComment.setEnabled(false);
                    } else {
                        if (iscontractor_comment_editable.compareTo("1") == 0) {
                            contractorsComment.setEnabled(true);
                        } else {
                            contractorsComment.setEnabled(false);
                        }
                    }

                    entrepreneurRating.setRating(Float.parseFloat(ratingValue));
//                    spnrDeliverable_Name.setAdapter(contributorTypeAdapter);
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }


            } else if (tag.equalsIgnoreCase(Constants.STARTUP_WORKORDER_COMMENT_TAG)) {

                ((HomeActivity) getActivity()).dismissProgressDialog();

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);


                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        Toast.makeText(getActivity(), jsonObject.optString("message").trim(), Toast.LENGTH_LONG).show();

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), jsonObject.optString("message").trim(), Toast.LENGTH_LONG).show();
                    }


                } catch (JSONException e) {

                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.DOWNLOAD_CONTRACTOR_STARTUP_WORKORDER_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        String filePath = Constants.APP_IMAGE_URL + "/" + jsonObject.getString("file_path").replaceAll(" ", "%20");

                        int index = filePath.lastIndexOf("/");
                        String[] parmas = {filePath, filePath.substring(index + 1).toString()};
                        if (UtilitiesClass.isDownloadManagerAvailable(getActivity())) {
                            ((HomeActivity) getActivity()).utilitiesClass.downloadFile(filePath, filePath.substring(index + 1).toString());
                        } else {
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

    public static class ViewHolder {
        public TextView Text;
        public TextView Text2;

    }


    public int[][] monoToBidi(final int[] array, final int rows, final int cols) {
        if (array.length != (rows * cols))
            throw new IllegalArgumentException("Invalid array length");

        int[][] bidi = new int[rows][cols];
        for (int i = 0; i < rows; i++)
            System.arraycopy(array, (i * cols), bidi[i], 0, cols);

        return bidi;
    }

    public static int[] sumTableColumns(int[][] table) {
        int size = table[0].length; // Replace it with the size of maximum length inner array
        int temp[] = new int[size];

        for (int i = 0; i < table.length; i++) {
            for (int j = 0; j < table[i].length; j++) {
                temp[j] += table[i][j];  // Note that, I am adding to `temp[j]`.
            }
        }
        // Note you are not using this return value in the calling method
        return temp;
    }

}