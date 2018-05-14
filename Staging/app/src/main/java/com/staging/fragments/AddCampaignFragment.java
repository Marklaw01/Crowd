package com.staging.fragments;

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
import android.os.Handler;
import android.provider.MediaStore;
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
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.KeywordsAdapter;
import com.staging.dropdownadapter.SpinnerAdapter;
import com.staging.filebrowser.FilePicker;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.listeners.onActivityResultListener;
import com.staging.models.GenericObject;
import com.staging.models.Mediabeans;
import com.staging.utilities.AndroidMultipartEntity;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.DateTimeFormatClass;

import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.content.ContentBody;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.nio.charset.Charset;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

/**
 * Created by neelmani.karn on 1/22/2016.
 */
public class AddCampaignFragment extends Fragment implements onActivityResultListener, AsyncTaskCompleteListener<String> {

    private ScrollView scrollView;
    private ImageView tv_deleteFile;
    private TextView tv_fileName;
    private LinearLayout layout_fileName;
    private String fileType;
    private Bitmap bitmap;
    public static String filepath;
    public static String fileName;
    private static int STARTUP_ID = 0;
    private Uri fileUri;
    private LinearLayout parent_layout;
    private ImageView image_forum;
    private String selectedKeyword = "";
    private String selectedCampaignKeyword = "";
    private ArrayList<String> selectedKeywordList;
    private ArrayList<GenericObject> keywordsList;
    private ArrayList<GenericObject> startupsList;
    private DatePickerDialog.OnDateSetListener date;
    private Calendar myCalendar;
    private EditText et_campaignName, et_interests, et_dueDate, et_targetAmount, et_summary;
    private Spinner spinner_chooseStartup, spinner_uploadFileType;
    private Button btn_submit, btn_browseImage;
    private LinearLayout layout_more;
    private TextView btn_browse;
    private ImageView btn_plus;
    private LinearLayout layout;
    private boolean filepicker;
    private int browseid = 1;
    private int deleteId = 0;
   // private LinearLayout mainLayout;
    private ProgressBar pb;
   // private TextView tv;
    private int progressStatus = 0;
    private Handler handler = new Handler();

    public AddCampaignFragment() {
        super();
    }

    private File selectedFile;
    ArrayList<TextView> filenames;

    public ArrayList<Mediabeans> pathofmedia;
    public static int selection;
    int tagno, deleteNumber;


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
                            System.out.println(selectedFile.getPath() + " selectedFile.getPath()");

                            fileType = data.getStringExtra(FilePicker.EXTRA_FILE_TYPE);
                            System.out.println(fileType + " filetype");
                            // CALL THIS METHOD TO GET THE ACTUAL PATH
                            File finalFile = new File(data.getStringExtra(FilePicker.EXTRA_FILE_PATH));
                            long length = finalFile.length();
                            int a = finalFile.getAbsolutePath().lastIndexOf("/");
                            if (length >= Constants.MAX_FILE_LENGTH_ALLOWED) {
                                Toast.makeText(getActivity(), finalFile.getAbsolutePath().substring(a + 1).toString().trim() + " size is more than 5 MB.", Toast.LENGTH_LONG).show();
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
                        if (requestCode == Constants.CAMERA_CAPTURE_IMAGE_REQUEST_CODE) {
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
                                        Toast.makeText(getActivity(), finalFile.getAbsolutePath().substring(a + 1).toString().trim() + " size is more than 5 MB.", Toast.LENGTH_LONG).show();
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
                        }

                        break;
                    case Constants.IMAGE_PICKER:

                        if (resultCode == Activity.RESULT_OK) {
                            Uri selectedImageUri = data.getData();
                            System.out.println("selectedImageUri " + selectedImageUri);

                            try {
                                String filemanagerstring = selectedImageUri.getPath();
                                System.out.println("filemanagerstring " + filemanagerstring);
                                String selectedImagePath = getPath(getActivity(), selectedImageUri);
                                System.out.println("selectedImagePath " + selectedImagePath);
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
                                        Toast.makeText(getActivity(), finalFile.getAbsolutePath().substring(a + 1).toString().trim() + " size is more than 5 MB.", Toast.LENGTH_LONG).show();
                                    } else {
                                        decodeFile(filepath, selectedImageUri);
                                    }
                                    //addpath(finalFile.getAbsolutePath(), "image", String.valueOf(length), finalFile.getAbsolutePath().substring(a + 1).toString().trim());
                                }
                            } catch (Exception e) {
                                System.out.println(e);
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
                if ((pathofmedia.get(i).getPath().equals(path))/* && (groupNameList.get(i).getPath().equals(fileName))*/) {
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
                    if ((pathofmedia.get(i).getTag() == tagno)/* && (groupNameList.get(i).getPath().equals(fileName))*/) {
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
        //selection = groupNameList.size();
    }

    long totalSize = 0;


    private void saveCampaign(final HashMap<String, String> map, final String editUrl) {

        try {
            new AsyncTask<Integer, Integer, String>() {

                ProgressDialog pDialog;

                @Override
                protected void onPreExecute() {
                    // TODO Auto-generated method stub
                    super.onPreExecute();

                    pDialog = new ProgressDialog(getActivity());
                    pDialog.setMessage("Adding Campaign Please wait...");
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
                    return uploadFile();
                }

                private String uploadFile() {
                    StringBuilder responseString = new StringBuilder();

                    HttpClient httpclient = ((HomeActivity) getActivity()).utilitiesClass.createHttpClient();
                    String url = Constants.APP_BASE_URL + editUrl;
                    HttpPost httppost = new HttpPost(url);
                    HttpContext localContext = new BasicHttpContext();
                    ArrayList<File> files = new ArrayList<File>();
                    ArrayList<FileBody> bin = new ArrayList<FileBody>();
                    for (int i = 0; i < pathofmedia.size(); i++) {
                        files.add(new File(pathofmedia.get(i).getPath()));
                    }

                    for (int i = 0; i < files.size(); i++) {
                        bin.add(new FileBody(files.get(i)));
                    }
                    try {

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
                            System.out.println(file);

                            ContentBody cbFile = new FileBody(file);

                            bitmap.compress(Bitmap.CompressFormat.JPEG, 0, bos);

                            entity.addPart("returnformat", new StringBody("json"));
                            entity.addPart("campaign_image", cbFile);
                            for (String key : map.keySet()) {
                                entity.addPart(key, new StringBody(map.get(key), "text/plain", Charset.forName("UTF-8")));
                            }
                            for (int i = 0; i < bin.size(); i++) {
                                entity.addPart("docs[]", bin.get(i));
                            }

                        } else {
                            for (String key : map.keySet()) {
                                entity.addPart(key, new StringBody(map.get(key), "text/plain", Charset.forName("UTF-8")));
                            }
                            for (int i = 0; i < bin.size(); i++) {
                                entity.addPart("docs[]", bin.get(i));
                            }

                        }
                        httppost.setEntity(entity);
                        totalSize = entity.getContentLength();

                        HttpResponse response = httpclient.execute(httppost, localContext);
                        StatusLine statusLine = response.getStatusLine();
                        int statusCode = statusLine.getStatusCode();
                        System.out.println(statusCode + " neel");

                        if (statusCode == HttpURLConnection.HTTP_OK) {
                            responseString.append(EntityUtils.toString(response.getEntity()));
                        } else if (statusCode == HttpURLConnection.HTTP_ENTITY_TOO_LARGE) {
                            JSONObject obj = new JSONObject();
                            obj.put("code", "404");
                            obj.put("message", "Invalid File Size!");
                            responseString.append(obj.toString());
                        }

                        Log.d("response", responseString.toString());

                    } catch (ClientProtocolException e) {
                        Log.e("Debug", "error: " + e.getMessage(), e);
                    } catch (IOException e) {
                        Log.e("Debug", "error: " + e.getMessage(), e);
                    } catch (Exception e) {
                        Log.e("Debug", "error: " + e.getMessage(), e);
                    }

                    return responseString.toString();
                }

                @Override
                protected void onPostExecute(String result) {
                    super.onPostExecute(result);
                    pDialog.dismiss();
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            pathofmedia.clear();
                            Toast.makeText(getActivity(), "Your campaign is created successfully.", Toast.LENGTH_LONG).show();
                            getActivity().onBackPressed();
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    Async a;
    EditText et_campaignKeywords;
    ArrayList<GenericObject> campaignKeywordsList;
    @Override
    public View onCreateView(LayoutInflater inflater, final ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_add_campaign, container, false);

        try {
            btn_submit = (Button) rootView.findViewById(R.id.btn_submit);
            scrollView = (ScrollView) rootView.findViewById(R.id.scrollview);
            // mainLayout = (LinearLayout) rootView.findViewById(R.id.mainlayout);
            pathofmedia = new ArrayList<Mediabeans>();
            // tv = (TextView) rootView.findViewById(R.id.tv);
            layout_more = (LinearLayout) rootView.findViewById(R.id.layout_more);
            image_forum = (ImageView) rootView.findViewById(R.id.image_forum);
            startupsList = new ArrayList<GenericObject>();
            btn_browseImage = (Button) rootView.findViewById(R.id.btn_browseImage);
            tv_fileName = (TextView) rootView.findViewById(R.id.tv_fileName);
            tv_deleteFile = (ImageView) rootView.findViewById(R.id.tv_deleteFile);
            layout_fileName = (LinearLayout) rootView.findViewById(R.id.layout_fileName);
            parent_layout = (LinearLayout) rootView.findViewById(R.id.parent_layout);
            et_campaignName = (EditText) rootView.findViewById(R.id.et_campaignName);
            et_interests = (EditText) rootView.findViewById(R.id.et_interests);
            et_campaignKeywords = (EditText) rootView.findViewById(R.id.et_campaignKeyword);
            et_dueDate = (EditText) rootView.findViewById(R.id.et_dueDate);
            et_targetAmount = (EditText) rootView.findViewById(R.id.et_targetAmount);
            et_summary = (EditText) rootView.findViewById(R.id.et_summary);
            spinner_chooseStartup = (Spinner) rootView.findViewById(R.id.spinner_chooseStartup);
            spinner_uploadFileType = (Spinner) rootView.findViewById(R.id.spinner_uploadFileType);
            keywordsList = new ArrayList<GenericObject>();
            campaignKeywordsList = new ArrayList<GenericObject>();
            selectedKeywordList = new ArrayList<String>();
            btn_browse = (TextView) rootView.findViewById(R.id.btn_browse);
            //btn_delete = (ImageView) rootView.findViewById(R.id.btn_delete);
            btn_plus = (ImageView) rootView.findViewById(R.id.btn_plus);
            layout = (LinearLayout) rootView.findViewById(R.id.layout);

            filenames = new ArrayList<TextView>();

            myCalendar = Calendar.getInstance();
            date = new DatePickerDialog.OnDateSetListener() {

                @Override
                public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {

                    myCalendar.set(Calendar.YEAR, year);
                    myCalendar.set(Calendar.MONTH, monthOfYear);
                    myCalendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                    updateLabel();
                }

            };

            et_dueDate.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    new DatePickerDialog(getActivity(), date, myCalendar
                            .get(Calendar.YEAR), myCalendar.get(Calendar.MONTH),
                            myCalendar.get(Calendar.DAY_OF_MONTH)).show();
                }
            });

            //et_targetAmount.addTextChangedListener(new USCurrencyFormatter(et_targetAmount));
            et_targetAmount.addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                }

                private String current = "";

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {

                }

                @Override
                public void afterTextChanged(Editable s) {
                    if (!s.toString().equals(current)) {
                        String cleanString = s.toString().replaceAll("[$,.]", "");

                        Locale locale = new Locale("en", "US");
                        NumberFormat fmt = NumberFormat.getCurrencyInstance(locale);

                        double parsed = Double.parseDouble(cleanString);
                        String formated = fmt.format((parsed / 100));//NumberFormat.getCurrencyInstance().format((parsed / 100));

                        current = formated;
                        et_targetAmount.setText(formated);
                        et_targetAmount.setSelection(formated.length());
                    }
                }
            });

            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_STARTUPS_TAG, Constants.USER_STARTUPS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&user_type=" + Constants.ENTREPRENEUR, Constants.HTTP_POST,"Home Activity");
                a.execute();;
            } else {

                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }

            spinner_chooseStartup.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                @Override
                public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                    STARTUP_ID = Integer.parseInt(startupsList.get(position).getId());
                }

                @Override
                public void onNothingSelected(AdapterView<?> parent) {

                }
            });


            et_interests.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    for (int i = 0; i < keywordsList.size(); i++) {
                        Log.d("ischecked", String.valueOf(keywordsList.get(i).ischecked()));
                    }

                    if (keywordsList.size() == 0) {
                        Toast.makeText(getActivity(), "No Keyword available!", Toast.LENGTH_LONG).show();
                    } else {
                        final Dialog dialog = new Dialog(getActivity());
                        dialog.setContentView(R.layout.keywords_dialog);
                        dialog.setTitle("Target Market");
                        final EditText search = (EditText)dialog.findViewById(R.id.et_search);
                        final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                        for (int i = 0; i < keywordsList.size(); i++) {
                            tempArray.add(keywordsList.get(i));
                            Log.e("retain", String.valueOf(tempArray.get(i).ischecked()));
                        }
                        final ListView lv = (ListView) dialog.findViewById(R.id.listKeywords);
                        lv.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);

                        final KeywordsAdapter adapter = new KeywordsAdapter(getActivity(), 0, keywordsList);
                        lv.setAdapter(adapter);

                        TextView dialogCancelButton = (TextView) dialog.findViewById(R.id.button_cancel);
                        TextView dialogButton = (TextView) dialog.findViewById(R.id.button);

                        search.addTextChangedListener(new TextWatcher() {
                            @Override
                            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                            }

                            @Override
                            public void onTextChanged(CharSequence s, int start, int before, int count) {
                                if (adapter!=null){
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
                                keywordsList.clear();

                                for (int i = 0; i < tempArray.size(); i++) {
                                    keywordsList.add(i, tempArray.get(i));
                                }

                                StringBuilder selectedKeywordsId = new StringBuilder();
                                selectedKeywordList.clear();
                                for (int i = 0; i < keywordsList.size(); i++) {
                                    if (keywordsList.get(i).ischecked()) {
                                        selectedKeywordList.add(keywordsList.get(i).getId());
                                    }
                                }

                                for (int i = 0; i < selectedKeywordList.size(); i++) {
                                    if (selectedKeywordsId.length() > 0) {
                                        selectedKeywordsId.append(",");
                                    }
                                    selectedKeywordsId.append(selectedKeywordList.get(i));
                                }
                                selectedKeyword = selectedKeywordsId.toString();
                                System.out.println(selectedKeyword.toString() + "-------------------------");
                                tempArray.clear();

                                dialog.dismiss();
                            }
                        });


                        dialogButton.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {

                                ArrayList<GenericObject> mArrayProducts = adapter.getCheckedItems();
                                for (int i = 0; i < mArrayProducts.size(); i++) {
                                    for (int j = 0; j < keywordsList.size(); j++) {
                                        if (mArrayProducts.get(i).getId().equalsIgnoreCase(keywordsList.get(j).getId())) {
                                            keywordsList.get(j).setIschecked(true);
                                        }
                                    }
                                }

                                StringBuilder sb = new StringBuilder();
                                StringBuilder selectedKeywordID = new StringBuilder();
                                for (int i = 0; i < mArrayProducts.size(); i++) {
                                    if (sb.length() > 0) {
                                        sb.append(", ");
                                        selectedKeywordID.append(",");
                                    }
                                    sb.append(mArrayProducts.get(i).getTitle());
                                    selectedKeywordID.append(mArrayProducts.get(i).getId());
                                }

                                selectedKeyword = selectedKeywordID.toString();
                                et_interests.setText(sb.toString());
                                System.out.println(selectedKeyword.toString() + "-------------------------");

                                dialog.dismiss();
                            }
                        });
                        dialog.show();
                    }
                }

            });







            //Code Change


            et_campaignKeywords.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    for (int i = 0; i < campaignKeywordsList.size(); i++) {
                        Log.d("ischecked", String.valueOf(campaignKeywordsList.get(i).ischecked()));
                    }

                    if (campaignKeywordsList.size() == 0) {
                        Toast.makeText(getActivity(), "No Keyword available!", Toast.LENGTH_LONG).show();
                    } else {
                        final Dialog dialog = new Dialog(getActivity());
                        dialog.setContentView(R.layout.keywords_dialog);
                        dialog.setTitle("Campaign Keywords");
                        final EditText search = (EditText) dialog.findViewById(R.id.et_search);
                        final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                        for (int i = 0; i < campaignKeywordsList.size(); i++) {
                            tempArray.add(campaignKeywordsList.get(i));
                            Log.e("retain", String.valueOf(tempArray.get(i).ischecked()));
                        }
                        final ListView lv = (ListView) dialog.findViewById(R.id.listKeywords);
                        lv.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);

                        final KeywordsAdapter adapterCampaign = new KeywordsAdapter(getActivity(), 0, campaignKeywordsList);
                        lv.setAdapter(adapterCampaign);

                        TextView dialogCancelButton = (TextView) dialog.findViewById(R.id.button_cancel);
                        TextView dialogButton = (TextView) dialog.findViewById(R.id.button);

                        search.addTextChangedListener(new TextWatcher() {
                            @Override
                            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                            }

                            @Override
                            public void onTextChanged(CharSequence s, int start, int before, int count) {
                                if (adapterCampaign != null) {
                                    adapterCampaign.getFilter().filter(s);
                                }
                            }

                            @Override
                            public void afterTextChanged(Editable s) {

                            }
                        });
                        dialogCancelButton.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                campaignKeywordsList.clear();

                                for (int i = 0; i < tempArray.size(); i++) {
                                    campaignKeywordsList.add(i, tempArray.get(i));
                                }

                                StringBuilder selectedKeywordsId = new StringBuilder();
                                selectedKeywordList.clear();
                                for (int i = 0; i < campaignKeywordsList.size(); i++) {
                                    if (campaignKeywordsList.get(i).ischecked()) {
                                        selectedKeywordList.add(campaignKeywordsList.get(i).getId());
                                    }
                                }

                                for (int i = 0; i < selectedKeywordList.size(); i++) {
                                    if (selectedKeywordsId.length() > 0) {
                                        selectedKeywordsId.append(",");
                                    }
                                    selectedKeywordsId.append(selectedKeywordList.get(i));
                                }
                                selectedCampaignKeyword = selectedKeywordsId.toString();
                                System.out.println(selectedCampaignKeyword.toString() + "-------------------------");
                                tempArray.clear();

                                dialog.dismiss();
                            }
                        });


                        dialogButton.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {

                                ArrayList<GenericObject> mArrayProducts = adapterCampaign.getCheckedItems();
                                for (int i = 0; i < mArrayProducts.size(); i++) {
                                    for (int j = 0; j < campaignKeywordsList.size(); j++) {
                                        if (mArrayProducts.get(i).getId().equalsIgnoreCase(campaignKeywordsList.get(j).getId())) {
                                            campaignKeywordsList.get(j).setIschecked(true);
                                        }
                                    }
                                }

                                StringBuilder sb = new StringBuilder();
                                StringBuilder selectedKeywordID = new StringBuilder();
                                for (int i = 0; i < mArrayProducts.size(); i++) {
                                    if (sb.length() > 0) {
                                        sb.append(", ");
                                        selectedKeywordID.append(",");
                                    }
                                    sb.append(mArrayProducts.get(i).getTitle());
                                    selectedKeywordID.append(mArrayProducts.get(i).getId());
                                }

                                selectedCampaignKeyword = selectedKeywordID.toString();
                                et_campaignKeywords.setText(sb.toString());
                                System.out.println(selectedCampaignKeyword.toString() + "-------------------------");

                                dialog.dismiss();
                            }
                        });
                        dialog.show();
                    }
                }

            });




            btn_plus.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

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
                }
            });


            btn_submit.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    try {
                        InputMethodManager inputMethodManager = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
                        inputMethodManager.hideSoftInputFromWindow(getActivity().getCurrentFocus().getWindowToken(), 0);

                        if (et_campaignName.getText().toString().isEmpty()) {
                            Toast.makeText(getActivity(), "Campaign name cannot be left blank!", Toast.LENGTH_LONG).show();
                        } else if (STARTUP_ID == 0) {
                            Toast.makeText(getActivity(), "Select Startup!", Toast.LENGTH_LONG).show();
                        } else if (selectedKeyword.isEmpty()) {
                            Toast.makeText(getActivity(), "Select at least one Target Market!", Toast.LENGTH_LONG).show();
                        } else if (selectedCampaignKeyword.isEmpty()) {
                            Toast.makeText(getActivity(), "Select at least one Campaign Keyword!", Toast.LENGTH_LONG).show();
                        } else if (et_dueDate.getText().toString().trim().isEmpty()) {
                            Toast.makeText(getActivity(), "Due date cannot be left blank!", Toast.LENGTH_LONG).show();
                        } else if (DateTimeFormatClass.compareDates(myCalendar.getTime())) {
                            Toast.makeText(getActivity(), "Due date cannot be present or past date!", Toast.LENGTH_LONG).show();
                        } else if (et_targetAmount.getText().toString().trim().isEmpty()) {
                            Toast.makeText(getActivity(), "Target amount cannot be left blank!", Toast.LENGTH_LONG).show();
                        } else if (et_summary.getText().toString().trim().isEmpty()) {
                            Toast.makeText(getActivity(), "Summary cannot be left blank!", Toast.LENGTH_LONG).show();
                        } else {

                            HashMap<String, String> map = new HashMap<String, String>();
                            map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            map.put("campaigns_name", et_campaignName.getText().toString().trim());
                            map.put("startup_id", String.valueOf(STARTUP_ID));
                            map.put("keywords", selectedKeyword);
                            map.put("campaign_keywords",selectedCampaignKeyword);
                            map.put("due_date", et_dueDate.getText().toString().trim());
                            map.put("target_amount", ((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(et_targetAmount.getText().toString().trim()));
                            map.put("summary", et_summary.getText().toString().trim());

                            //getActivity().onBackPressed();
                            for (int j = 0; j < pathofmedia.size(); j++) {
                                Log.d("file path", pathofmedia.get(j).getPath());
                                Log.d("file size", pathofmedia.get(j).getFilesize());
                                Log.d("file type", pathofmedia.get(j).getType());
                            }
                            Log.e("map", map.toString());
                            if (((HomeActivity)getActivity()).networkConnectivity.isOnline()){
                                saveCampaign(map, Constants.ADD_CAMPAIGN_URL);
                               // new ImageUploader().execute();
                            }else{
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }

                            //saveCampaign(map, Constants.ADD_CAMPAIGN_URL);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });

            btn_browseImage.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    alertDialogForPicture();
                }
            });

            tv_deleteFile.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
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
                }
            });

            btn_browse.setTag(0);
            btn_browse.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
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

                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootView;
    }

    @Override
    public void onPause() {
        super.onPause();
        if (a.getStatus()== AsyncTask.Status.RUNNING){
            a.cancel(true);
        }

    }

    /**
     * update date of birth after change.
     */
    private void updateLabel() {

        try {
            SimpleDateFormat sdf = new SimpleDateFormat(Constants.DATE_FORMAT, Locale.US);
            et_dueDate.setText(sdf.format(myCalendar.getTime()));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        try {
            Log.e("Fragment Name", AddCampaignFragment.class.getSimpleName());
            ((HomeActivity) getActivity()).setOnActivityResultListener(this);
            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            try {
                // if (getArguments().getString("CAMPAIGN_NAME").trim().length() == 0) {
                ((HomeActivity) getActivity()).setActionBarTitle("Add Campaign");
                btn_submit.setText(getString(R.string.submit));
                /*} else {
                    ((HomeActivity) getActivity()).setActionBarTitle(getArguments().getString("CAMPAIGN_NAME"));
                    btn_submit.setText("Edit Campaign");
                    et_campaignName.setText(getArguments().getString("CAMPAIGN_NAME"));
                    et_dueDate.setText(getArguments().getString("DUE_DATE"));
                    et_summary.setText(getArguments().getString("DESCRIPTION"));
                    et_targetAmount.setText(getArguments().getString("TARGET_AMOUNT"));

                }*/
            } catch (NullPointerException e) {
                getActivity().onBackPressed();
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void alertDialogForPicture() {
        try {
            AlertDialog.Builder builderSingle =  new AlertDialog.Builder(getActivity(), R.style.MyDialogTheme);
            final CharSequence[] opsChars = {"Upload Image", "Take Picture"};
            builderSingle.setCancelable(true);
            builderSingle.setItems(opsChars, new DialogInterface.OnClickListener() {

                @Override
                public void onClick(DialogInterface dialog, int which) {
                    if ((ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                        requestPermission();
                    } else {
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
                }
            });
            builderSingle.show();
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

                // Camera permission has not been granted yet. Request it directly.
                ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.CAMERA, Manifest.permission.READ_EXTERNAL_STORAGE}, Constants.APP_PERMISSION);
            }
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
        System.out.println("media file " + mediaFile.getAbsolutePath());
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
                System.out.println(filePath);
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
                image_forum.setImageBitmap(bitmap);
            } catch (Exception e) {
                e.printStackTrace();
                image_forum.setImageResource(R.drawable.app_icon);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onTaskComplete(String result, String tag) {
        try {
            if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
                ((HomeActivity)getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
            } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
                ((HomeActivity)getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
            } else {
                if (tag.equalsIgnoreCase(Constants.USER_STARTUPS_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        GenericObject obj = new GenericObject();
                        obj.setTitle("Choose Startup");
                        obj.setId("0");
                        startupsList.add(obj);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            for (int i = 0; i < jsonObject.optJSONArray("startup").length(); i++) {
                                GenericObject startupsObject = new GenericObject();
                                startupsObject.setId(jsonObject.optJSONArray("startup").optJSONObject(i).optString("id"));
                                startupsObject.setTitle(jsonObject.optJSONArray("startup").optJSONObject(i).optString("name"));

                                startupsList.add(startupsObject);
                            }

                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.KEYWORDS_TAG, Constants.KEYWORDS_URL, Constants.HTTP_GET,"Home Activity");
                                a.execute();
                            } else {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CAMPAIGN_KEYWORDS_TAG, Constants.CAMPAIGN_KEYWORDS_URL, Constants.HTTP_GET, "Home Activity");
                                a.execute();
                            } else {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            Toast.makeText(getActivity(), jsonObject.optString("message") + " Try Again!", Toast.LENGTH_LONG).show();
                            /*if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.KEYWORDS_TAG, Constants.KEYWORDS_URL, Constants.HTTP_GET);
                                a.execute();
                            } else {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }*/
                        }
                        spinner_chooseStartup.setAdapter(new SpinnerAdapter(getActivity(), 0, startupsList));
                    } catch (JSONException e) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.KEYWORDS_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        keywordsList.clear();
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            for (int i = 0; i < jsonObject.optJSONArray("keywords").length(); i++) {
                                GenericObject obj = new GenericObject();
                                obj.setId(jsonObject.optJSONArray("keywords").getJSONObject(i).optString("id"));
                                obj.setTitle(jsonObject.optJSONArray("keywords").getJSONObject(i).optString("name"));
                                keywordsList.add(obj);
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            keywordsList.clear();
                        }


                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
                else if (tag.equalsIgnoreCase(Constants.CAMPAIGN_KEYWORDS_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        campaignKeywordsList.clear();
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            for (int i = 0; i < jsonObject.optJSONArray("keywords").length(); i++) {
                                GenericObject obj = new GenericObject();
                                obj.setId(jsonObject.optJSONArray("keywords").getJSONObject(i).optString("id"));
                                obj.setTitle(jsonObject.optJSONArray("keywords").getJSONObject(i).optString("name"));
                                campaignKeywordsList.add(obj);
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            campaignKeywordsList.clear();
                        }


                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
