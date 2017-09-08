package com.crowdbootstrap.fragments.webinarsmodule;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.ContentResolver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.annotation.Nullable;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.adapter.FundsKeywordsAdapter;
import com.crowdbootstrap.filebrowser.FilePicker;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.listeners.onActivityResultListener;
import com.crowdbootstrap.logger.CrowdBootstrapLogger;
import com.crowdbootstrap.models.GenericObject;
import com.crowdbootstrap.models.Mediabeans;
import com.crowdbootstrap.utilities.AndroidMultipartEntity;
import com.crowdbootstrap.utilities.AsyncNew;
import com.crowdbootstrap.utilities.Constants;
import com.crowdbootstrap.utilities.DateTimeFormatClass;
import com.crowdbootstrap.utilities.UtilitiesClass;

import org.apache.http.entity.mime.content.ContentBody;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.UnknownHostException;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

/**
 * Created by Neelmani.Karn on 1/11/2017.
 */
public class RequestWebinarsFragment extends Fragment implements onActivityResultListener, View.OnClickListener, AsyncTaskCompleteListener<String> {

    private String selectedInterestedKeywordsId = "", selectedTargetMarktetIDs = "", selectedKeywordsIDs = "";
    private ArrayList<GenericObject> keywordsList, interestedKeywordsList, targetMarktetList;
    private DatePickerDialog.OnDateSetListener investmentStartdate, investmentEnddate/*, funcCloseddate*/;
    private Calendar myCalendarInvestmentStartDate, myCalendarInvestmentEndDate, myCalendarFuncClosedDate;

    private EditText et_start_date, et_endDate/*, et_fundsClosedDate*/;
    private EditText et_title, et_description, et_targetMarket, et_interestKeywords/*, et_industry, et_portfolio*/, et_keywords;
    private Spinner spinner_uploadFileType;
    private ImageView image_fundImage;
    private ImageView tv_deleteFile;
    private TextView tv_fileName;
    private LinearLayout layout_fileName;
    private String fileType;
    private Bitmap bitmap;
    public static String filepath;
    public static String fileName;
    private Uri fileUri;
    private LinearLayout parent_layout;
    private Button btnCreate;
    private LinearLayout layout_more;
    private TextView btn_browse;
    private ImageView btn_plus;
    private LinearLayout layout;
    private boolean filepicker;
    private int browseid = 1;
    private int deleteId = 0;
    private TextView startDateTV, endDateTV, titleTV, descriptionlbl, keywordTV;

    private File selectedFile;
    ArrayList<TextView> filenames;

    public ArrayList<Mediabeans> pathofmedia;
    public static int selection;
    int tagno, deleteNumber;

    public RequestWebinarsFragment() {
        super();
    }

    /**
     * Called when the fragment is visible to the user and actively running.
     * This is generally
     * tied to {@link Activity#onResume() Activity.onResume} of the containing
     * Activity's lifecycle.
     */
    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnActivityResultListener(this);
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
    }

    /**
     * Called to do initial creation of a fragment.  This is called after
     * {@link #onAttach(Activity)} and before
     * {@link #onCreateView(LayoutInflater, ViewGroup, Bundle)}.
     * <p>
     * <p>Note that this can be called while the fragment's activity is
     * still in the process of being created.  As such, you can not rely
     * on things like the activity's content view hierarchy being initialized
     * at this point.  If you want to do work once the activity itself is
     * created, see {@link #onActivityCreated(Bundle)}.
     *
     * @param savedInstanceState If the fragment is being re-created from
     *                           a previous saved state, this is the state.
     */
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        keywordsList = new ArrayList<>();
        targetMarktetList = new ArrayList<>();
        interestedKeywordsList = new ArrayList<>();
        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
            ((HomeActivity) getActivity()).showProgressDialog();
            AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.WEBINAR_KEYWORDS_LIST_TAG, Constants.WEBINAR_KEYWORDS_LIST_URL, Constants.HTTP_GET_REQUEST, null);
            a.execute();
        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }

    }

    /**
     * Set Start Investment Date on edit text
     */
    private void setStartDate() {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat(Constants.DATE_FORMAT, Locale.US);

            et_start_date.setText(sdf.format(myCalendarInvestmentStartDate.getTime()));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Set Start Investment Date on edit text
     */
    private void setEndDate() {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat(Constants.DATE_FORMAT, Locale.US);

            et_endDate.setText(sdf.format(myCalendarInvestmentEndDate.getTime()));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Set Start Investment Date on edit text
     */
    /*private void setFundClosedDate() {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat(Constants.DATE_FORMAT, Locale.US);

            et_fundsClosedDate.setText(sdf.format(myCalendarFuncClosedDate.getTime()));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }*/
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.create_boardmember_fragment, container, false);
        ((HomeActivity) getActivity()).setActionBarTitle("Webinars");


        et_title = (EditText) rootView.findViewById(R.id.et_title);
        et_description = (EditText) rootView.findViewById(R.id.et_description);
        et_interestKeywords = (EditText) rootView.findViewById(R.id.et_interestKeywords);
        et_keywords = (EditText) rootView.findViewById(R.id.et_keywords);
        et_targetMarket = (EditText) rootView.findViewById(R.id.et_targetMarket);
        //et_portfolio = (EditText) rootView.findViewById(R.id.et_portfolio);
        //et_keywords = (EditText) rootView.findViewById(R.id.et_keywords);

        //et_fundsClosedDate = (EditText) rootView.findViewById(R.id.et_fundsClosedDate);
        et_endDate = (EditText) rootView.findViewById(R.id.et_endDate);
        et_start_date = (EditText) rootView.findViewById(R.id.et_start_date);
        titleTV = (TextView) rootView.findViewById(R.id.namelbl);
        descriptionlbl = (TextView) rootView.findViewById(R.id.descriptionlbl);
        keywordTV = (TextView) rootView.findViewById(R.id.keywordTitle);
        keywordTV.setText("Webinar Keywords");
        startDateTV = (TextView) rootView.findViewById(R.id.tv_startDate);
        endDateTV = (TextView) rootView.findViewById(R.id.tv_endDate);
        startDateTV.setText("Webinar Availability Start Date");
        endDateTV.setText("Webinar Availability End Date");
        titleTV.setText("Webinar Title");
        descriptionlbl.setText("Webinar Description");

        spinner_uploadFileType = (Spinner) rootView.findViewById(R.id.spinner_uploadFileType);
        pathofmedia = new ArrayList<Mediabeans>();
        // tv = (TextView) rootView.findViewById(R.id.tv);
        layout_more = (LinearLayout) rootView.findViewById(R.id.layout_more);
        image_fundImage = (ImageView) rootView.findViewById(R.id.image_fundImage);
        tv_fileName = (TextView) rootView.findViewById(R.id.tv_fileName);
        tv_deleteFile = (ImageView) rootView.findViewById(R.id.tv_deleteFile);
        layout_fileName = (LinearLayout) rootView.findViewById(R.id.layout_fileName);
        parent_layout = (LinearLayout) rootView.findViewById(R.id.parent_layout);

        btnCreate = (Button) rootView.findViewById(R.id.btn_submit);
        btn_browse = (TextView) rootView.findViewById(R.id.btn_browse);
        //btn_delete = (ImageView) rootView.findViewById(R.id.btn_delete);
        btn_plus = (ImageView) rootView.findViewById(R.id.btn_plus);
        layout = (LinearLayout) rootView.findViewById(R.id.layout);

        filenames = new ArrayList<TextView>();

        myCalendarInvestmentStartDate = Calendar.getInstance();
        investmentStartdate = new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                myCalendarInvestmentStartDate.set(Calendar.YEAR, year);
                myCalendarInvestmentStartDate.set(Calendar.MONTH, monthOfYear);
                myCalendarInvestmentStartDate.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                setStartDate();
            }
        };

        myCalendarInvestmentEndDate = Calendar.getInstance();
        investmentEnddate = new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                myCalendarInvestmentEndDate.set(Calendar.YEAR, year);
                myCalendarInvestmentEndDate.set(Calendar.MONTH, monthOfYear);
                myCalendarInvestmentEndDate.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                setEndDate();
            }
        };

        /*myCalendarFuncClosedDate = Calendar.getInstance();
        funcCloseddate = new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                myCalendarFuncClosedDate.set(Calendar.YEAR, year);
                myCalendarFuncClosedDate.set(Calendar.MONTH, monthOfYear);
                myCalendarFuncClosedDate.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                setFundClosedDate();
            }
        };*/


        btn_browse.setTag(0);
        btn_browse.setOnClickListener(this);
        btnCreate.setText("Create");
        btn_plus.setOnClickListener(this);
        btnCreate.setOnClickListener(this);
        image_fundImage.setOnClickListener(this);
        tv_deleteFile.setOnClickListener(this);

        et_start_date.setOnClickListener(this);
        //et_fundsClosedDate.setOnClickListener(this);
        et_endDate.setOnClickListener(this);
        et_targetMarket.setOnClickListener(this);
        et_keywords.setOnClickListener(this);
        et_interestKeywords.setOnClickListener(this);
        return rootView;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        // TODO Auto-generated method stub
        super.onActivityResult(requestCode, resultCode, data);
        try {
            if (resultCode == Activity.RESULT_OK) {

                switch (requestCode) {

                    case Constants.FILE_PICKER:

                        if (data.hasExtra(FilePicker.EXTRA_FILE_PATH)) {

                            selectedFile = new File(data.getStringExtra(FilePicker.EXTRA_FILE_PATH));
                            CrowdBootstrapLogger.logInfo(selectedFile.getPath() + " selectedFile.getPath()");

                            fileType = data.getStringExtra(FilePicker.EXTRA_FILE_TYPE);
                            CrowdBootstrapLogger.logInfo(fileType + " filetype");
                            // CALL THIS METHOD TO GET THE ACTUAL PATH
                            File finalFile = new File(data.getStringExtra(FilePicker.EXTRA_FILE_PATH));
                            long length = finalFile.length();
                            int a = finalFile.getAbsolutePath().lastIndexOf("/");
                            if (length >= Constants.MAX_FILE_LENGTH_ALLOWED) {
                                Toast.makeText(getActivity(), finalFile.getAbsolutePath().substring(a + 1).toString().trim() + " size is more than 20 MB.", Toast.LENGTH_LONG).show();
                            } else {
                                layout_fileName.setVisibility(View.VISIBLE);

                                if (tagno > 0) {
                                    TextView view = filenames.get(tagno - 1);
                                    view.setText(finalFile.getAbsolutePath().substring(a + 1).toString().trim());
                                } else {
                                    tv_fileName.setText(finalFile.getAbsolutePath().substring(a + 1).toString().trim());
                                }

                                addpath(finalFile.getAbsolutePath(), "text", String.valueOf(length), finalFile.getAbsolutePath().substring(a + 1).toString().trim());
                            }
                            //filePath.setText();
                        }
                        break;

                    case Constants.CAMERA_CAPTURE_IMAGE_REQUEST_CODE:

                        // if the result is capturing Image
                        // if (requestCode == Constants.CAMERA_CAPTURE_IMAGE_REQUEST_CODE) {
                        if (resultCode == Activity.RESULT_OK) {
                            // successfully captured the image
                            // display it in image view
                            try {
                                // bimatp factory
                                BitmapFactory.Options options = new BitmapFactory.Options();

                                // downsizing image as it throws OutOfMemory Exception for larger
                                // images
                                options.inSampleSize = 8;

                                filepath = fileUri.getPath();
                                File finalFile = new File(filepath);
                                long length = finalFile.length();
                                int a = finalFile.getAbsolutePath().lastIndexOf("/");

                                if (length >= Constants.MAX_FILE_LENGTH_ALLOWED) {
                                    Toast.makeText(getActivity(), finalFile.getAbsolutePath().substring(a + 1).toString().trim() + " size is more than 20 MB.", Toast.LENGTH_LONG).show();
                                } else {
                                    decodeFile(filepath, fileUri);
                                }


                                //addpath(finalFile.getAbsolutePath(), "image", String.valueOf(length), finalFile.getAbsolutePath().substring(a + 1).toString().trim());

                            } catch (NullPointerException e) {
                                e.printStackTrace();
                            }
                        } else if (resultCode == Activity.RESULT_CANCELED) {
                            // user cancelled Image capture
                            Toast.makeText(getActivity(),
                                    "User cancelled image capture", Toast.LENGTH_LONG)
                                    .show();
                        } else {
                            // failed to capture image
                            Toast.makeText(getActivity(),
                                    "Sorry! Failed to capture image", Toast.LENGTH_LONG)
                                    .show();
                        }
                        //}

                        break;
                    case Constants.IMAGE_PICKER:

                        if (resultCode == Activity.RESULT_OK) {
                            Uri selectedImageUri = data.getData();
                            CrowdBootstrapLogger.logInfo("selectedImageUri " + selectedImageUri);

                            try {
                                String filemanagerstring = selectedImageUri.getPath();
                                CrowdBootstrapLogger.logInfo("filemanagerstring " + filemanagerstring);
                                String selectedImagePath = getPath(getActivity(), selectedImageUri);
                                CrowdBootstrapLogger.logInfo("selectedImagePath " + selectedImagePath);
                                if (selectedImagePath != null) {
                                    filepath = selectedImagePath;
                                } else if (filemanagerstring != null) {
                                    filepath = filemanagerstring;
                                } else {
                                    Toast.makeText(getActivity(), "Unknown path", Toast.LENGTH_LONG).show();
                                }

                                if (filepath.contains("http") || filepath.contains("https")) {
                                    Toast.makeText(getActivity(), "Unknown path", Toast.LENGTH_LONG).show();
                                } else if (filepath != null) {
                                    int a = filepath.lastIndexOf("/");
                                    fileName = filepath.substring(a + 1);


                                    File finalFile = new File(filepath);
                                    long length = finalFile.length();
                                    if (length >= Constants.MAX_FILE_LENGTH_ALLOWED) {
                                        Toast.makeText(getActivity(), finalFile.getAbsolutePath().substring(a + 1).toString().trim() + " size is more than 20 MB.", Toast.LENGTH_LONG).show();
                                    } else {
                                        decodeFile(filepath, selectedImageUri);
                                    }
                                    //addpath(finalFile.getAbsolutePath(), "image", String.valueOf(length), finalFile.getAbsolutePath().substring(a + 1).toString().trim());
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                Toast.makeText(getActivity(), "Internal error", Toast.LENGTH_LONG).show();
                            }
                        }
                        break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void addpath(String path, String type, String filesize, String fileName) {
        try {
            boolean alreadyexist = false, already = false;
            for (int i = 0; i < pathofmedia.size(); i++) {
                if ((pathofmedia.get(i).getPath().equals(path))/* && (pathofmedia.get(i).getPath().equals(fileName))*/) {
                    alreadyexist = true;
                }
            }
            if (!alreadyexist) {
                if (type.equalsIgnoreCase("image")) {
                    for (int i = 0; i < pathofmedia.size(); i++) {
                        if (pathofmedia.get(i).getType().equals("image")) {
                            pathofmedia.remove(i);
                        } else {
                            continue;
                        }
                    }
                }
                for (int i = 0; i < pathofmedia.size(); i++) {
                    if ((pathofmedia.get(i).getTag() == tagno)/* && (pathofmedia.get(i).getPath().equals(fileName))*/) {
                        already = true;
                        pathofmedia.remove(i);
                        break;
                    }
                }

                pathofmedia.add(new Mediabeans(path, type, filesize, fileName, tagno));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //selection = pathofmedia.size();
    }

    long totalSize = 0;


    protected void alertDialogForPicture() {
        try {
            if ((ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                requestPermission();
            } else {
                AlertDialog.Builder builderSingle = new AlertDialog.Builder(getActivity()/*new ContextThemeWrapper(getActivity(), android.R.style.Theme_Holo_Light_Dialog)*/);
                final CharSequence[] opsChars = {"Upload Image", "Take Picture"};
                builderSingle.setCancelable(true);
                builderSingle.setItems(opsChars, new DialogInterface.OnClickListener() {

                    @Override
                    public void onClick(DialogInterface dialog, int which) {

                        switch (which) {

                            case 0:
                                try {
                                    Intent i = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);

                                    getActivity().startActivityForResult(i, Constants.IMAGE_PICKER);
                                } catch (Exception e) {
                                    Toast.makeText(getActivity(), "Please provide permission of Sd-Card from apps permission setting", Toast.LENGTH_LONG).show();
                                }
                                break;
                            case 1:

                                try {

                                    Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                                    fileUri = getOutputMediaFileUri(Constants.FILE_PICKER);
                                    intent.putExtra(MediaStore.EXTRA_OUTPUT, fileUri);
                                    getActivity().startActivityForResult(intent, Constants.CAMERA_CAPTURE_IMAGE_REQUEST_CODE);


                                } catch (SecurityException e) {
                                    Toast.makeText(getActivity(), "Please provide permission of camera from apps permission setting", Toast.LENGTH_LONG).show();
                                    e.printStackTrace();
                                }
                        }

                    }
                });
                builderSingle.show();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Requests the Camera permission.
     * If the permission has been denied previously, a SnackBar will prompt the user to grant the
     * permission, otherwise it is requested directly.
     */
    private void requestPermission() {
        try {
            Log.i("TAG", "CAMERA permission has NOT been granted. Requesting permission.");

            // BEGIN_INCLUDE(camera_permission_request)
            if ((ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.CAMERA)) && ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE)) {
                // Provide an additional rationale to the user if the permission was not granted
                // and the user would benefit from additional context for the use of the permission.
                // For example if the user has previously denied the permission.
                Log.i("TAG", "Displaying camera permission rationale to provide additional context.");

                Snackbar.make(parent_layout, R.string.app_permision, Snackbar.LENGTH_INDEFINITE)
                        .setAction("OK", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.CAMERA, Manifest.permission.READ_EXTERNAL_STORAGE}, Constants.APP_PERMISSION);
                            }
                        })
                        .show();
            } else {
                ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.CAMERA, Manifest.permission.READ_EXTERNAL_STORAGE}, Constants.APP_PERMISSION);
                // Camera permission has not been granted yet. Request it directly.

            }
            //ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.CAMERA, Manifest.permission.READ_EXTERNAL_STORAGE}, Constants.APP_PERMISSION);
            // END_INCLUDE(camera_permission_request)
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * Callback received when a permissions request has been completed.
     */
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {

        try {
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    /**
     * Creating file uri to store image/video
     */
    public Uri getOutputMediaFileUri(int type) {
        return Uri.fromFile(getOutputMediaFile(type));
    }

    /**
     * returning image / video
     */
    private static File getOutputMediaFile(int type) {

        // External sdcard location
        File mediaStorageDir = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM), Constants.IMAGE_DIRECTORY_NAME);

        // Create the storage directory if it does not exist
        if (!mediaStorageDir.exists()) {
            if (!mediaStorageDir.mkdirs()) {
                Log.d(Constants.IMAGE_DIRECTORY_NAME, "Oops! Failed create " + Constants.IMAGE_DIRECTORY_NAME + " directory");
                return null;
            }
        }

        // Create a media file name
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(new Date());
        File mediaFile;
        if (type == Constants.FILE_PICKER) {
            mediaFile = new File(mediaStorageDir.getPath() + File.separator + "IMG_" + timeStamp + ".jpg");
        } else {
            return null;
        }
        CrowdBootstrapLogger.logInfo("media file " + mediaFile.getAbsolutePath());
        return mediaFile;
    }

    public String getPath(Context context, Uri uri) {

        try {
            ContentResolver content = context.getContentResolver();
            String[] projection = {MediaStore.Images.Media.DATA};
            Cursor cursor = content.query(uri, projection, null, null, null);
            if (cursor != null) {
                int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
                cursor.moveToFirst();
                String s = cursor.getString(column_index);
                //cursor.close();
                return s;

            } else
                return null;
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            return null;
        }
    }

    public void decodeFile(String filePath, Uri selectedImageUri) {
        try {
            int orientation;
            try {
                CrowdBootstrapLogger.logInfo(filePath);
                // Decode image size
                BitmapFactory.Options o = new BitmapFactory.Options();
                o.inJustDecodeBounds = true;
                BitmapFactory.decodeFile(filePath, o);
                // The new size we want to scale to
                final int REQUIRED_SIZE = 1024;
                // Find the correct scale value. It should be the power of 2.
                int width_tmp = o.outWidth, height_tmp = o.outHeight;
                int scale = 1;
                while (true) {
                    if (width_tmp < REQUIRED_SIZE && height_tmp < REQUIRED_SIZE)
                        break;
                    width_tmp /= 2;
                    height_tmp /= 2;
                    scale *= 2;
                }

                BitmapFactory.Options o2 = new BitmapFactory.Options();
                o2.inSampleSize = scale;
                bitmap = BitmapFactory.decodeFile(filePath, o2);
                image_fundImage.setImageBitmap(bitmap);
            } catch (Exception e) {
                e.printStackTrace();
                image_fundImage.setImageResource(R.drawable.app_icon);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Called when a view has been clicked.
     *
     * @param v The view that was clicked.
     */
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_submit:
                InputMethodManager inputMethodManager = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
                inputMethodManager.hideSoftInputFromWindow(getActivity().getCurrentFocus().getWindowToken(), 0);
                if (et_title.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity(), getString(R.string.title_required), Toast.LENGTH_LONG).show();
                    return;
                }
                if (et_description.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity(), getString(R.string.description_required), Toast.LENGTH_LONG).show();
                    return;
                }
                if (et_start_date.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity(), getString(R.string.startDateRequired), Toast.LENGTH_LONG).show();
                    return;
                }
                if (DateTimeFormatClass.compareDates(myCalendarInvestmentStartDate.getTime())) {
                    Toast.makeText(getActivity(), getString(R.string.startdate_validation), Toast.LENGTH_LONG).show();
                    return;
                }
                if (et_endDate.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity(), getString(R.string.endDateRequired), Toast.LENGTH_LONG).show();
                    return;
                }
                if (DateTimeFormatClass.compareDates(myCalendarInvestmentStartDate.getTime(), myCalendarInvestmentEndDate.getTime())) {
                    Toast.makeText(getActivity(), getString(R.string.end_date_validation), Toast.LENGTH_LONG).show();
                    return;
                }
                if (et_targetMarket.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity(), getString(R.string.targetMarket_required), Toast.LENGTH_LONG).show();
                    return;
                }
                if (et_keywords.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity(), getString(R.string.keyword_required), Toast.LENGTH_LONG).show();
                    return;
                }
                if (et_interestKeywords.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity(), getString(R.string.interestKeyword_required), Toast.LENGTH_LONG).show();
                    return;
                }


                HashMap<String, String> map = new HashMap<String, String>();
                map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                map.put("title", et_title.getText().toString().trim());
                map.put("description", et_description.getText().toString().trim());
                map.put("interest_keywords_id", selectedInterestedKeywordsId);
                map.put("keywords_id", selectedKeywordsIDs);
                map.put("target_market", selectedTargetMarktetIDs);
                map.put("start_date", et_start_date.getText().toString().trim());
                map.put("end_date", et_endDate.getText().toString().trim());
                for (int j = 0; j < pathofmedia.size(); j++) {
                    CrowdBootstrapLogger.logInfo("file path" + pathofmedia.get(j).getPath());
                    CrowdBootstrapLogger.logInfo("file size" + pathofmedia.get(j).getFilesize());
                    CrowdBootstrapLogger.logInfo("file type" + pathofmedia.get(j).getType());
                }

                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    create(map, Constants.CREATE_WEBINAR_URL);
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
                CrowdBootstrapLogger.logInfo("map" + map.toString());
                break;
            case R.id.et_start_date:
                new DatePickerDialog(getActivity(), investmentStartdate, myCalendarInvestmentStartDate
                        .get(Calendar.YEAR), myCalendarInvestmentStartDate.get(Calendar.MONTH),
                        myCalendarInvestmentStartDate.get(Calendar.DAY_OF_MONTH)).show();
                break;

            case R.id.et_endDate:
                new DatePickerDialog(getActivity(), investmentEnddate, myCalendarInvestmentEndDate
                        .get(Calendar.YEAR), myCalendarInvestmentEndDate.get(Calendar.MONTH),
                        myCalendarInvestmentEndDate.get(Calendar.DAY_OF_MONTH)).show();
                break;
           /* case R.id.et_fundsClosedDate:
                new DatePickerDialog(getActivity(), funcCloseddate, myCalendarFuncClosedDate
                        .get(Calendar.YEAR), myCalendarFuncClosedDate.get(Calendar.MONTH),
                        myCalendarFuncClosedDate.get(Calendar.DAY_OF_MONTH)).show();
                break;*/
            case R.id.btn_browse:
                try {
                    if ((ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                        requestPermission();
                    } else {
                        tagno = (int) v.getTag();
                        filepicker = true;
                        Intent intent = new Intent(getActivity(), FilePicker.class);
                        String[] acceptedFileExtensions = null;
                        if (spinner_uploadFileType.getSelectedItem().toString().trim().equalsIgnoreCase("Document")) {
                            acceptedFileExtensions = new String[]{".pdf"};
                        } else if (spinner_uploadFileType.getSelectedItem().toString().trim().equalsIgnoreCase("Audio")) {
                            acceptedFileExtensions = new String[]{".mp3"};
                        } else if (spinner_uploadFileType.getSelectedItem().toString().trim().equalsIgnoreCase("Video")) {
                            acceptedFileExtensions = new String[]{".mp4"};
                        }
                        intent.putExtra("FILE_EXTENSION", acceptedFileExtensions);
                        getActivity().startActivityForResult(intent, Constants.FILE_PICKER);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }


                break;
            case R.id.image_fundImage:
                alertDialogForPicture();
                break;
            case R.id.tv_deleteFile:
                try {
                    layout_fileName.setVisibility(View.GONE);
                    String fileName = tv_fileName.getText().toString().trim();
                    for (int i = 0; i < pathofmedia.size(); i++) {
                        if (pathofmedia.get(i).getFileName().equals(fileName)) {
                            pathofmedia.remove(i);
                        } else {
                            continue;
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;
            case R.id.btn_plus:
                try {
                    if (layout_more.getChildCount() <= 1) {
                        LayoutInflater mInflater = (LayoutInflater) getActivity().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                        final View layout = mInflater.inflate(R.layout.predefined_upload_filelayout, null);

                        ImageView delete = (ImageView) layout.findViewById(R.id.btn_delete);
                        final Spinner spinner = (Spinner) layout.findViewById(R.id.spinner_uploadFileType);
                        final LinearLayout layout_file = (LinearLayout) layout.findViewById(R.id.layout_fileName);

                        TextView tv_fName = (TextView) layout.findViewById(R.id.tv_fileName);
                        ImageView tv_delFile = (ImageView) layout.findViewById(R.id.tv_deleteFile);

                        filenames.add(tv_fName);
                        TextView btn_browse = (TextView) layout.findViewById(R.id.btn_browse);

                        btn_browse.setTag(browseid);
                        tv_delFile.setTag(deleteId);

                        btn_browse.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                layout_file.setVisibility(View.VISIBLE);
                                if ((ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                                    requestPermission();
                                } else {

                                    tagno = (int) v.getTag();
                                    Intent intent = new Intent(getActivity(), FilePicker.class);
                                    String[] acceptedFileExtensions = null;
                                    if (spinner.getSelectedItem().toString().trim().equalsIgnoreCase("Document")) {
                                        acceptedFileExtensions = new String[]{".pdf"};
                                    } else if (spinner.getSelectedItem().toString().trim().equalsIgnoreCase("Audio")) {
                                        acceptedFileExtensions = new String[]{".mp3"};
                                    } else if (spinner.getSelectedItem().toString().trim().equalsIgnoreCase("Video")) {
                                        acceptedFileExtensions = new String[]{".mp4"};
                                    }

                                    intent.putExtra("FILE_EXTENSION", acceptedFileExtensions);
                                    //ArrayList<String> fileExtension = new ArrayList<String>();

                                    //intent.putStringArrayListExtra(FilePicker.EXTRA_ACCEPTED_FILE_EXTENSIONS, fileExtension.add(spinner_uploadFileType.getSelectedItem().toString()));
                                    getActivity().startActivityForResult(intent, Constants.FILE_PICKER);
                                }
                            }
                        });

                        tv_delFile.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {

                                deleteNumber = (int) v.getTag();
                                layout_file.setVisibility(View.GONE);
                                String fileName = filenames.get(deleteNumber).getText().toString().trim();
                                for (int i = 0; i < pathofmedia.size(); i++) {
                                    if (pathofmedia.get(i).getFileName().equals(fileName)) {
                                        pathofmedia.remove(i);
                                    } else {
                                        continue;
                                    }
                                }
                            }
                        });

                        delete.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                ((ViewGroup) layout.getParent()).removeView(layout);
                            }
                        });
                        layout_more.addView(layout);
                    } else {
                        Toast.makeText(getActivity(), "At a time only 3 file you can upload!", Toast.LENGTH_LONG).show();
                    }
                    browseid++;
                    deleteId++;
                } catch (Exception e) {
                    e.printStackTrace();
                }

                break;
            case R.id.et_targetMarket:
                showKeywordsDialog(targetMarktetList, getString(R.string.target_market), R.id.et_targetMarket);
                break;
            case R.id.et_keywords:
                showKeywordsDialog(keywordsList, getString(R.string.keyword), R.id.et_keywords);
                break;
            case R.id.et_interestKeywords:
                showKeywordsDialog(interestedKeywordsList, getString(R.string.interest_keyword), R.id.et_interestKeywords);
                break;
        }
    }


    private void showKeywordsDialog(final ArrayList<GenericObject> list, String title, final int id) {

        if (list.size() == 0) {
            Toast.makeText(getActivity(), "No " + title + " available!", Toast.LENGTH_LONG).show();
        } else {
            final Dialog dialog = new Dialog(getActivity());
            dialog.setContentView(R.layout.funds_keywords_dialog);
            dialog.setCancelable(false);
            final EditText search = (EditText) dialog.findViewById(R.id.et_search);
            search.setHint(getString(R.string.search) + " " + title);
            dialog.setTitle(title);
            final ListView lv = (ListView) dialog.findViewById(R.id.listKeywords);
            lv.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);

            final FundsKeywordsAdapter adapter = new FundsKeywordsAdapter(getActivity(), 0, list, list.size());
            lv.setAdapter(adapter);

            TextView dialogCancelButton = (TextView) dialog.findViewById(R.id.button_cancel);
            TextView dialogButton = (TextView) dialog.findViewById(R.id.button);

            search.addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                }

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                    if (adapter != null) {
                        adapter.getFilter().filter(s);
                    }
                }

                @Override
                public void afterTextChanged(Editable s) {

                }
            });
            dialogCancelButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    dialog.dismiss();
                }
            });


            dialogButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    StringBuilder sb = new StringBuilder();
                    StringBuilder selectedID = new StringBuilder();
                    for (int i = 0; i < list.size(); i++) {

                        Log.d("checked value", adapter.getcheckedlist()[i] + "");

                        list.get(i).setIschecked(adapter.getcheckedlist()[i]);
                        if (list.get(i).ischecked()) {
                            if (sb.length() > 0) {
                                sb.append(", ");
                                selectedID.append(",");
                            }
                            sb.append(list.get(i).getTitle());
                            selectedID.append(list.get(i).getId());
                        }
                    }
                    switch (id) {
                        case R.id.et_interestKeywords:
                            selectedInterestedKeywordsId = selectedID.toString();
                            et_interestKeywords.setText(sb.toString());
                            CrowdBootstrapLogger.logInfo(selectedID.toString() + " " + sb.toString());
                            break;
                        case R.id.et_keywords:
                            selectedKeywordsIDs = selectedID.toString();
                            et_keywords.setText(sb.toString());
                            CrowdBootstrapLogger.logInfo(selectedID.toString() + " " + sb.toString());
                            break;
                        case R.id.et_targetMarket:
                            selectedTargetMarktetIDs = selectedID.toString();
                            et_targetMarket.setText(sb.toString());
                            CrowdBootstrapLogger.logInfo(selectedID.toString() + " " + sb.toString());
                            break;
                        /*case R.id.et_fundsponsers:
                            selectedSponsorsIDs = selectedID.toString();
                            et_fundsponsers.setText(sb.toString());
                            CrowdBootstrapLogger.logInfo(selectedID.toString() + " " + sb.toString());
                            break;
                        case R.id.et_portfolio:
                            selectedPortfolioIDs = selectedID.toString();
                            et_portfolio.setText(sb.toString());
                            CrowdBootstrapLogger.logInfo(selectedID.toString() + " " + sb.toString());
                            break;*/

                    }

                    dialog.dismiss();
                }
            });
            dialog.show();
        }
    }


    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.TIMEOUT_EXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            UtilitiesClass.getInstance(getActivity()).alertDialogSingleButton(getString(R.string.time_out));
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {

            if (tag.equals(Constants.WEBINAR_KEYWORDS_LIST_TAG)) {
                CrowdBootstrapLogger.logInfo(result);
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    keywordsList.clear();
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        for (int i = 0; i < jsonObject.optJSONArray("keyword_list").length(); i++) {
                            GenericObject obj = new GenericObject();
                            obj.setId(jsonObject.optJSONArray("keyword_list").getJSONObject(i).optString("id"));
                            obj.setTitle(jsonObject.optJSONArray("keyword_list").getJSONObject(i).optString("name"));
                            obj.setPosition(i);
                            keywordsList.add(obj);
                        }
                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                            AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.WEBINAR_INTEREST_KEYWORDS_LIST_TAG, Constants.WEBINAR_INTEREST_KEYWORDS_LIST_URL, Constants.HTTP_GET_REQUEST, null);
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        keywordsList.clear();
                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equals(Constants.WEBINAR_INTEREST_KEYWORDS_LIST_TAG)) {
                CrowdBootstrapLogger.logInfo(result);
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    interestedKeywordsList.clear();
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        for (int i = 0; i < jsonObject.optJSONArray("interest_keyword_list").length(); i++) {
                            GenericObject obj = new GenericObject();
                            obj.setId(jsonObject.optJSONArray("interest_keyword_list").getJSONObject(i).optString("id"));
                            obj.setTitle(jsonObject.optJSONArray("interest_keyword_list").getJSONObject(i).optString("name"));
                            obj.setPosition(i);
                            interestedKeywordsList.add(obj);
                        }
                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                            AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.WEBINAR_TARGET_MARKET_KEYWORDS_LIST_TAG, Constants.WEBINAR_TARGET_MARKET_KEYWORDS_LIST_URL, Constants.HTTP_GET_REQUEST, null);
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        interestedKeywordsList.clear();
                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equals(Constants.WEBINAR_TARGET_MARKET_KEYWORDS_LIST_TAG)) {
                CrowdBootstrapLogger.logInfo(result);
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    targetMarktetList.clear();
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        for (int i = 0; i < jsonObject.optJSONArray("target_market_list").length(); i++) {
                            GenericObject obj = new GenericObject();
                            obj.setId(jsonObject.optJSONArray("target_market_list").getJSONObject(i).optString("id"));
                            obj.setTitle(jsonObject.optJSONArray("target_market_list").getJSONObject(i).optString("name"));
                            obj.setPosition(i);
                            targetMarktetList.add(obj);
                        }

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        targetMarktetList.clear();
                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            }
        }
    }


    /**
     * Save fund to database.
     *
     * @param map
     * @param createUrl
     */
    private void create(final HashMap<String, String> map, final String createUrl) {

        try {
            new AsyncTask<Integer, Integer, String>() {

                ProgressDialog pDialog;

                @Override
                protected void onPreExecute() {
                    // TODO Auto-generated method stub
                    super.onPreExecute();

                    pDialog = new ProgressDialog(getActivity());
                    pDialog.setMessage("Please wait...");
                    pDialog.setIndeterminate(false);
                    pDialog.setMax(100);
                    pDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
                    pDialog.setCancelable(false);
                    pDialog.show();


                }

                @Override
                protected void onProgressUpdate(Integer... values) {
                    super.onProgressUpdate(values);
                    pDialog.setProgress(values[0]);
                }

                @Override
                protected String doInBackground(Integer... params) {
                    File docFile = null;
                    File audioFile = null;
                    File videoFile = null;
                    FileBody docFileBody = null;
                    FileBody audioFileBody = null;
                    FileBody videoFileBody = null;
                    try {
                        /*ArrayList<File> files = new ArrayList<File>();
                        ArrayList<FileBody> bin = new ArrayList<FileBody>();
                        for (int i = 0; i < pathofmedia.size(); i++) {
                            files.add(new File(pathofmedia.get(i).getPath()));
                        }*/

                        /*for (int i = 0; i < files.size(); i++) {
                            bin.add(new FileBody(files.get(i)));
                        }*/

                        for (int i = 0; i < pathofmedia.size(); i++) {
                            if (pathofmedia.get(i).getPath().contains(".pdf")) {
                                docFile = (new File(pathofmedia.get(i).getPath()));
                            }
                            if (pathofmedia.get(i).getPath().contains(".mp3")) {
                                audioFile = (new File(pathofmedia.get(i).getPath()));
                            }
                            if (pathofmedia.get(i).getPath().contains(".mp4")) {
                                videoFile = (new File(pathofmedia.get(i).getPath()));
                            }
                        }

                        if (docFile != null) {
                            docFileBody = new FileBody(docFile);
                        }

                        if (audioFile != null) {
                            audioFileBody = new FileBody(audioFile);
                        }

                        if (videoFile != null) {
                            videoFileBody = new FileBody(videoFile);
                        }

                        AndroidMultipartEntity entity = new AndroidMultipartEntity(
                                new AndroidMultipartEntity.ProgressListener() {

                                    @Override
                                    public void transferred(long num) {
                                        publishProgress((int) ((num / (float) totalSize) * 100));
                                    }
                                });
                        if (bitmap != null) {
                            ByteArrayOutputStream bos = new ByteArrayOutputStream();
                            File file = new File(filepath);
                            CrowdBootstrapLogger.logInfo(file.getAbsolutePath());

                            ContentBody cbFile = new FileBody(file);

                            bitmap.compress(Bitmap.CompressFormat.JPEG, 0, bos);

                            entity.addPart("returnformat", new StringBody("json"));
                            entity.addPart("image", cbFile);
                            for (String key : map.keySet()) {
                                entity.addPart(key, new StringBody(map.get(key), "text/plain", Charset.forName("UTF-8")));
                                //entity.addPart(key, new StringBody(map.get(key), "text/plain", Charset.forName("UTF-8")));
                            }
                                /*for (int i = 0; i < bin.size(); i++) {
                                    entity.addPart("docs[]", bin.get(i));
                                }*/
                            if (videoFileBody != null) {
                                entity.addPart("video", videoFileBody);
                            }
                            if (audioFileBody != null) {
                                entity.addPart("audio", audioFileBody);
                            }
                            if (docFileBody != null) {
                                entity.addPart("document", docFileBody);
                            }
                        } else {
                            for (String key : map.keySet()) {
                                entity.addPart(key, new StringBody(map.get(key), "text/plain", Charset.forName("UTF-8")));
                            }
                            if (videoFileBody != null) {
                                entity.addPart("video", videoFileBody);
                            }
                            if (audioFileBody != null) {
                                entity.addPart("audio", audioFileBody);
                            }
                            if (docFileBody != null) {
                                entity.addPart("document", docFileBody);
                            }
                        }

                        try {
                            return multipost(createUrl, entity);
                        } catch (UnknownHostException e) {
                            e.printStackTrace();
                            return Constants.NOINTERNET;
                        } catch (SocketTimeoutException e) {
                            e.printStackTrace();
                            return Constants.TIMEOUT_EXCEPTION;
                        }
                    } catch (UnsupportedEncodingException e) {
                        e.printStackTrace();
                    }
                    return Constants.SERVEREXCEPTION;
                    //return uploadFile();
                }

                private String multipost(String urlString, AndroidMultipartEntity reqEntity) throws UnknownHostException, SocketTimeoutException {
                    try {
                        URL url = new URL(Constants.APP_BASE_URL + urlString);
                        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                        conn.setReadTimeout(1200000);
                        conn.setConnectTimeout(1200000);
                        conn.setRequestMethod(Constants.HTTP_POST_REQUEST);
                        conn.setUseCaches(false);
                        conn.setDoInput(true);
                        conn.setDoOutput(true);

                        conn.setRequestProperty("Connection", "Keep-Alive");
                        conn.addRequestProperty("Content-length", reqEntity.getContentLength() + "");
                        conn.addRequestProperty(reqEntity.getContentType().getName(), reqEntity.getContentType().getValue());

                        OutputStream os = conn.getOutputStream();
                        reqEntity.writeTo(conn.getOutputStream());
                        os.close();
                        conn.connect();

                        if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                            return readStream(conn.getInputStream());
                        } else {
                            return Constants.SERVEREXCEPTION;
                        }

                    } catch (UnknownHostException e) {
                        e.printStackTrace();
                        throw e;
                    } catch (SocketTimeoutException e) {
                        throw e;
                    } catch (Exception e) {
                        Log.e("TAG", "multipart post error " + e + "(" + urlString + ")");
                        return Constants.SERVEREXCEPTION;
                    }
                    //return Constants.SERVEREXCEPTION;
                }

                private String readStream(InputStream in) {
                    BufferedReader reader = null;
                    StringBuilder builder = new StringBuilder();
                    try {
                        reader = new BufferedReader(new InputStreamReader(in));
                        String line = "";
                        while ((line = reader.readLine()) != null) {
                            builder.append(line);
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    } finally {
                        if (reader != null) {
                            try {
                                reader.close();
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                    return builder.toString();
                }

                @Override
                protected void onPostExecute(String result) {
                    super.onPostExecute(result);
                    pDialog.dismiss();
                    if (result.equals(Constants.NOINTERNET)) {
                        Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
                    } else if (result.equals(Constants.SERVEREXCEPTION)) {
                        Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
                    } else if (result.equals(Constants.TIMEOUT_EXCEPTION)) {
                        UtilitiesClass.getInstance(getActivity()).alertDialogSingleButton(getString(R.string.time_out));
                    } else {
                        if (result.isEmpty()) {
                            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
                        } else {
                            try {
                                CrowdBootstrapLogger.logInfo(result);
                                JSONObject jsonObject = new JSONObject(result);

                                if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                                    pathofmedia.clear();
                                    Toast.makeText(getActivity(), "Your event is created successfully.", Toast.LENGTH_LONG).show();
                                    getActivity().onBackPressed();
                                } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                                    if (jsonObject.has("errors")) {
                                       /* if (!jsonObject.optJSONObject("errors").optString("username").isEmpty()) {
                                            Toast.makeText(getActivity(), jsonObject.optJSONObject("errors").optString("description"), Toast.LENGTH_LONG).show();
                                        }*/
                                    }
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        }

                    }

                }
            }.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}