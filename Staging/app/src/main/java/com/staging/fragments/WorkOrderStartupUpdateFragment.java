package com.staging.fragments;

import android.Manifest;
import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.WorkOrderContractorTableUpdateAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.models.RoadmapDeliverables;
import com.staging.models.WorkOrderItem;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.UtilitiesClass;
import com.inqbarna.tablefixheaders.TableFixHeaders;

import org.json.JSONArray;
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
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

/**
 * Created by sunakshi.gautam on 8/31/2016.
 */
public class WorkOrderStartupUpdateFragment extends Fragment implements AsyncTaskCompleteListener<String> {

    private LinearLayout layout;
    private TableFixHeaders tableFixHeaders;
    private String dayText;
    private String dateText;

    public static ArrayList<WorkOrderItem> arrDeliverablesworkUnits;
    public static ArrayList<String> arrDeliverables;
    private ArrayList<RoadmapDeliverables> arrDeliverablesID;
    private ArrayList<String> arrTotalOfWorkUnitsDeliverable;
    private ArrayList<String> arrDeliverablesDate;
    //    private Spinner spnrDeliverable_Name;
//    private EditText edt_Workunit_date;
//    private EditText edt_Workunit;
    private Button btnSaveWorkOrder;
    private Button btnSubmitWorkOrder;

    private DatePickerDialog.OnDateSetListener date;
    private Calendar myCalendar;


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
                    jsonObject.put("startup_team_id",CurrentStartUpDetailFragment.STARTUP_TEAMID);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_WORKORDER_SAVED_TAG, Constants.STARTUP_WORKORDER_SAVED_URL, Constants.HTTP_POST, jsonObject, "Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        }
    }

    @Override
    public void onResume() {
        super.onResume();

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
                jsonObject.put("startup_team_id",CurrentStartUpDetailFragment.STARTUP_TEAMID);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_WORKORDER_SAVED_TAG, Constants.STARTUP_WORKORDER_SAVED_URL, Constants.HTTP_POST, jsonObject, "Home Activity");
            a.execute();
        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_workordercontractor_update, container, false);
        layout = (LinearLayout) rootView.findViewById(R.id.layout);
        arrDeliverables = new ArrayList<String>();
        arrDeliverablesID = new ArrayList<RoadmapDeliverables>();
        arrTotalOfWorkUnitsDeliverable = new ArrayList<String>();
        arrDeliverablesDate = new ArrayList<String>();
        arrDeliverablesworkUnits = new ArrayList<WorkOrderItem>();
//        spnrDeliverable_Name = (Spinner) rootView.findViewById(R.id.deliverablename);
//        edt_Workunit = (EditText) rootView.findViewById(R.id.workunitentered);
//        edt_Workunit_date = (EditText) rootView.findViewById(R.id.datetoday);
        tableFixHeaders = (TableFixHeaders) rootView.findViewById(R.id.workordertable);
        btnSaveWorkOrder = (Button) rootView.findViewById(R.id.updateworkorder);
        btnSubmitWorkOrder = (Button) rootView.findViewById(R.id.downloadworkorder);


        if (CurrentStartUpDetailFragment.from.compareTo("complete") == 0) {
//            edt_Workunit.setVisibility(View.GONE);
//            edt_Workunit_date.setVisibility(View.GONE);
//            spnrDeliverable_Name.setVisibility(View.GONE);
            btnSaveWorkOrder.setVisibility(View.GONE);
            btnSubmitWorkOrder.setVisibility(View.GONE);
        } else {
//            edt_Workunit.setVisibility(View.VISIBLE);
//            edt_Workunit_date.setVisibility(View.VISIBLE);
//            spnrDeliverable_Name.setVisibility(View.VISIBLE);
            btnSaveWorkOrder.setVisibility(View.VISIBLE);
            btnSubmitWorkOrder.setVisibility(View.VISIBLE);

        }

//        edt_Workunit.setFilters(new InputFilter[]{ new InputFilterMinMax("1", "24")});

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

//        edt_Workunit_date.setOnClickListener(new View.OnClickListener()
//
//                                             {
//                                                 @Override
//                                                 public void onClick (View v){
//
//                                                     new DatePickerDialog(getActivity(), date, myCalendar
//                                                             .get(Calendar.YEAR), myCalendar.get(Calendar.MONTH),
//                                                             myCalendar.get(Calendar.DAY_OF_MONTH)).show();
//
//                                                 }
//                                             }
//
//        );

        btnSaveWorkOrder.setOnClickListener(new View.OnClickListener()

                                            {
                                                @Override
                                                public void onClick(View v) {
                                                    int total_workunitsEntered = 0;
                                                    for (int i = 0; i < arrDeliverablesworkUnits.size(); i++) {
                                                        total_workunitsEntered = total_workunitsEntered + Integer.parseInt(arrDeliverablesworkUnits.get(i).getWorkUnit());
                                                    }

                                                    if (total_workunitsEntered > Integer.parseInt(approvedHours))

                                                    {
                                                        Toast.makeText(getActivity(), "Work Units entered are more than the Approved Work Units.", Toast.LENGTH_LONG).show();
                                                    } else

                                                    {
                                                        JSONObject WorkUnitObj = new JSONObject();
                                                        try {
                                                            JSONArray workOrderArray = new JSONArray();
                                                            for (int i = 0; i < arrDeliverablesworkUnits.size(); i++) {

                                                                Log.e("XXXX", arrDeliverablesworkUnits.get(i).getWorkUnit());
                                                                JSONObject workunit = new JSONObject();
                                                                try {
                                                                    workunit.put("date", arrDeliverablesworkUnits.get(i).getDate());
                                                                    workunit.put("deliverable_id", arrDeliverablesworkUnits.get(i).getDeliverableID());
                                                                    workunit.put("startup_id", arrDeliverablesworkUnits.get(i).getStartupID());
                                                                    workunit.put("work_units", arrDeliverablesworkUnits.get(i).getWorkUnit());


                                                                    workOrderArray.put(workunit);

                                                                } catch (JSONException e) {
                                                                    // TODO Auto-generated catch block
                                                                    e.printStackTrace();
                                                                }


                                                            }


                                                            WorkUnitObj.put("Work_order_array", workOrderArray);

                                                            WorkUnitObj.put("is_submitted", "0");
                                                            WorkUnitObj.put("startup_team_id", WorkOrderStartUpFragment.startup_teamId);
                                                            WorkUnitObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                                                            WorkUnitObj.put("main_startupid", CurrentStartUpDetailFragment.STARTUP_ID);


                                                            String jsonStr = WorkUnitObj.toString();

                                                            System.out.println("jsonString: " + "DSFSFDSF" + jsonStr);

                                                        } catch (JSONException e) {
                                                            e.printStackTrace();
                                                        }


                                                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                                            ((HomeActivity) getActivity()).showProgressDialog();


                                                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_WORKORDER_UPDATE_TAG, Constants.STARTUP_WORKORDER_UPDATE_URL, Constants.HTTP_POST, WorkUnitObj, "Home Activity");
                                                            a.execute();
                                                        } else {

                                                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                                        }

                                                    }
                                                }
                                            }

        );
        btnSubmitWorkOrder.setOnClickListener(new View.OnClickListener()

                                              {
                                                  @Override
                                                  public void onClick(View v) {

                                                      int total_workunitsEntered = 0;
                                                      for (int i = 0; i < arrDeliverablesworkUnits.size(); i++) {
                                                          total_workunitsEntered = total_workunitsEntered + Integer.parseInt(arrDeliverablesworkUnits.get(i).getWorkUnit());
                                                      }

                                                      if (total_workunitsEntered > Integer.parseInt(approvedHours))

                                                      {
                                                          Toast.makeText(getActivity(), "Work Units entered are more than the Approved Work Units.", Toast.LENGTH_LONG).show();
                                                      } else

                                                      {
                                                          JSONObject WorkUnitObj = new JSONObject();
                                                          try {
                                                              JSONArray workOrderArray = new JSONArray();
                                                              for (int i = 0; i < arrDeliverablesworkUnits.size(); i++) {

                                                                  Log.e("XXXX", arrDeliverablesworkUnits.get(i).getWorkUnit());
                                                                  JSONObject workunit = new JSONObject();
                                                                  try {
                                                                      workunit.put("date", arrDeliverablesworkUnits.get(i).getDate());
                                                                      workunit.put("deliverable_id", arrDeliverablesworkUnits.get(i).getDeliverableID());
                                                                      workunit.put("startup_id", arrDeliverablesworkUnits.get(i).getStartupID());
                                                                      workunit.put("work_units", arrDeliverablesworkUnits.get(i).getWorkUnit());


                                                                      workOrderArray.put(workunit);

                                                                  } catch (JSONException e) {
                                                                      // TODO Auto-generated catch block
                                                                      e.printStackTrace();
                                                                  }


                                                              }


                                                              WorkUnitObj.put("Work_order_array", workOrderArray);

                                                              WorkUnitObj.put("is_submitted", "1");
                                                              WorkUnitObj.put("startup_team_id", WorkOrderStartUpFragment.startup_teamId);
                                                              WorkUnitObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                                                              WorkUnitObj.put("main_startupid", CurrentStartUpDetailFragment.STARTUP_ID);


                                                              String jsonStr = WorkUnitObj.toString();

                                                              System.out.println("jsonString: " + "DSFSFDSF" + jsonStr);

                                                          } catch (JSONException e) {
                                                              e.printStackTrace();
                                                          }


                                                          if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                                              ((HomeActivity) getActivity()).showProgressDialog();


                                                              Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_WORKORDER_UPDATE_TAG, Constants.STARTUP_WORKORDER_UPDATE_URL, Constants.HTTP_POST, WorkUnitObj, "Home Activity");
                                                              a.execute();
                                                          } else {

                                                              ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                                          }

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


    public class MyAdapter extends WorkOrderContractorTableUpdateAdapter {

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
            return 7;
        }

        @Override
        public int getColumnCount() {
            return arrDeliverables.size();
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
                    Log.e("XXX", "COLUMNS+++HEADER" + arrDeliverables.get(column).toString());
                    layoutText = arrDeliverables.get(column).toString();
                    break;
                case 1:

                    if (row < 7) {
                        if (arrDeliverablesDate.get(row).compareTo(dayAPI[row]) == 0) {

                            Log.e("XXX", "ROWS++" + String.valueOf(row) + "++++++++++" + "COLUMNS+++" + String.valueOf(column));


                            for (int i = 0; i < arrDeliverablesworkUnits.size(); i++) {

                                if ((arrDeliverablesworkUnits.get(i).getDeliverableName().compareTo(arrDeliverables.get(column)) == 0) &&

                                        (arrDeliverablesworkUnits.get(i).getDate().compareTo(arrDeliverablesDate.get(row)) == 0)
                                        ) {
                                    Log.e("XXX", "VALUES+++" + arrDeliverablesworkUnits.get(i).getWorkUnit());
                                    layoutText = "" + arrDeliverablesworkUnits.get(i).getWorkUnit();
//                                    int totalWorkUnitPerDeliverable = Integer.parseInt(layoutText) + Integer.parseInt(arrTotalOfWorkUnitsDeliverable.get(column));
//                                    arrTotalOfWorkUnitsDeliverable.set(column, String.valueOf(totalWorkUnitPerDeliverable));
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
                        remainingHours = (Integer.parseInt(allocatedHours) - Integer.parseInt(consumedHours));
                        if (column == 0) {
                            layoutText = "" + String.valueOf(remainingHours);
                        } else {
                            layoutText = "-";
                        }
                    } else if (row == 9) {
                        if (column == 0) {
                            layoutText = allocatedHours;
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
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_WORKORDER_SAVED_TAG, Constants.STARTUP_WORKORDER_SAVED_URL, Constants.HTTP_POST, jsonObject, "Home Activity");
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
                    layoutResource = R.layout.item_table_update;
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
            if ((row < 0) && (column > -1)) {
                return 0;
            } else if ((row < 0) && (column < 0)) {
                return 2;
            } else if ((column < 0) && (row > -1)) {
                return 3;
            } else if ((row > -1) && (column > -1)) {
                return 1;
            }
            return -1;
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
            } else if (tag.equalsIgnoreCase(Constants.STARTUP_WORKORDER_SAVED_TAG)) {

                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    arrDeliverables.clear();
                    arrDeliverablesworkUnits.clear();
                    arrDeliverablesDate.clear();
                    arrDeliverablesID.clear();
                    arrTotalOfWorkUnitsDeliverable.clear();

                    allocatedHours = jsonObject.optString("Allocated_hours").trim();
                    approvedHours = jsonObject.optString("Approved_hours").trim();
                    consumedHours = jsonObject.optString("consumedHours").trim();
                    teamMember_ID = jsonObject.optString("teammember_id").trim();
                    startUP_ID = jsonObject.optString("startup_id").trim();
                    for (int k = 0; k < jsonObject.optJSONArray("Maindeliverables").length(); k++) {
                        JSONObject mainDeliverable_OBJ = jsonObject.optJSONArray("Maindeliverables").getJSONObject(k);
                        String deliverableName = mainDeliverable_OBJ.optString("deliverable_name").trim();
                        String deliverableid = mainDeliverable_OBJ.optString("deliverable_id").trim();
                        arrDeliverables.add(deliverableName);

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
                                arrDeliverablesworkUnits.add(item);
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
                                        arrDeliverablesworkUnits.add(item);
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
                                    arrDeliverablesworkUnits.add(item);
                                }
                            }
                        }
                    }


                    //remove all the duplicate items from the table
//                    HashSet<String> hashSet = new HashSet<String>();
//                    hashSet.addAll(arrDeliverables);
//                    arrDeliverables.clear();
//                    arrDeliverables.addAll(hashSet);

                    Log.e("XXX", arrDeliverables.toString());

                    tableFixHeaders.setAdapter(new MyAdapter(getActivity()));



                    /*ArrayAdapter<String> contributorTypeAdapter = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_spinner_item, android.R.id.text1, arrDeliverables);
                    spnrDeliverable_Name.setAdapter(contributorTypeAdapter);*/
                    ArrayAdapter<String> contributorTypeAdapter = new ArrayAdapter<String>(getActivity(), R.layout.spinner_item, arrDeliverables);
                    contributorTypeAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
//                    spnrDeliverable_Name.setAdapter(contributorTypeAdapter);
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
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

    public static class ViewHolderItems {
        public EditText Text;
        public TextView Text2;
        public TextWatcher textWatcher;
    }

}