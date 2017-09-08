package com.staging.fragments;

import android.Manifest;
import android.animation.ValueAnimator;
import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
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
import android.view.ViewTreeObserver;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.KeywordsAdapter;
import com.staging.dropdownadapter.CountryAdapter;
import com.staging.dropdownadapter.SpinnerAdapter;
import com.staging.dropdownadapter.StatesAdapter;
import com.staging.filebrowser.FilePicker;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.listeners.onActivityResultListener;
import com.staging.models.AudioObject;
import com.staging.models.CountryObject;
import com.staging.models.GenericObject;
import com.staging.models.Mediabeans;
import com.staging.models.StatesObject;
import com.staging.utilities.AndroidMultipartEntity;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.DateTimeFormatClass;
import com.staging.utilities.UtilityList;

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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

/**
 * Created by Sunakshi.Gautam on 12/7/2016.
 */
public class EditJobsFragment extends Fragment implements onActivityResultListener, AsyncTaskCompleteListener<String>, View.OnClickListener {

    private Spinner companyName;
    private Spinner countrySpinner, citySpinner;
    private EditText jobTitle;
    private EditText jobRole;
    private Spinner jobType;
    private EditText minimumWorkNPS;
    private EditText location;
    private EditText travel;
    private EditText startDate, endDate;
    private EditText skills;
    private EditText jobKeywords;
    private EditText jobRequirements;
    private EditText jobSummary;
    private ImageView tv_deleteFile;
    private EditText industry;
    private ArrayList<GenericObject> industryKeywordList;
    private ArrayList<GenericObject> jobTypeKeywordList;
    private ArrayList<GenericObject> jobPostingKeywordList;
    private ArrayList<GenericObject> jobSkillskeywordsList;
    private ArrayList<StatesObject> states;
    private ArrayList<CountryObject> countries;

    private ArrayList<GenericObject> companyList;
    private ArrayList<String> selectedKeywordList;
    private static int COUNTRY_ID = -1;
    private static int STATE_ID = -1;
    private static int COMPANY_ID;
    private static int JOB_TYPE_ID;
    private CountryAdapter countryAdapter;
    private StatesAdapter stateAdapter;

    private ImageView btn_plus;
    private TextView btn_browse;
    private int browseid = 1;
    private int deleteId = 0;
    private LinearLayout layout_more;
    public static String filepath;
    public static String fileName;
    ArrayList<TextView> filenames;
    int tagno, deleteNumber;
    private LinearLayout parent_layout, layout;
    private File selectedFile;
    private String fileType;
    private LinearLayout layout_fileName;
    private TextView tv_fileName;
    private Uri fileUri;
    private boolean filepicker;
    private Spinner spinner_chooseStartup, spinner_uploadFileType;
    private Button btn_submit;

    public ArrayList<Mediabeans> pathofmedia;


    private String selectedIndustryKeywords = "";
    private String selectedJobPostingKeywords = "";
    private String selectedSkillsKeywords = "";


    private Calendar myCalendar;
    private DatePickerDialog.OnDateSetListener date;


    private ImageView viewDocumentArrow, viewplayAudioArrow, viewplayVideoArrow, viewsummaryArrow, viewroadmapGraphicArrow, image_roadmap;
    private LinearLayout btn_playAudio, btn_viewDocument, btn_playVideo, btn_summary;

    private LinearLayout expandable_playAudio, expandable_viewDocument, expandable_playVideo, expandable_Summary, roadmapGraphiclayout, roadmapGraphic, roadmapGraphicexpandable;
    private ValueAnimator mAnimatorForDoc, mAnimatorForAudio, mAnimatorForVideo, mAnimatorForSummary;
    private ListView list_audios, list_docs, list_video;
    private ArrayList<AudioObject> audioObjectsList, documentObjectList, videoObjectList;
    private ValueAnimator mAnimator;


    public EditJobsFragment() {
        super();
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


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.editjobs_fragment, container, false);

        companyName = (Spinner) rootView.findViewById(R.id.et_companyName);
        countrySpinner = (Spinner) rootView.findViewById(R.id.country);
        citySpinner = (Spinner) rootView.findViewById(R.id.city);
        jobTitle = (EditText) rootView.findViewById(R.id.et_jobtitle);
        jobRole = (EditText) rootView.findViewById(R.id.et_role);
        jobType = (Spinner) rootView.findViewById(R.id.et_jobtype);
        minimumWorkNPS = (EditText) rootView.findViewById(R.id.et_targetResource);
        location = (EditText) rootView.findViewById(R.id.et_location);
        travel = (EditText) rootView.findViewById(R.id.et_travel);
        startDate = (EditText) rootView.findViewById(R.id.et_startDate);
        endDate = (EditText) rootView.findViewById(R.id.et_endDate);
        skills = (EditText) rootView.findViewById(R.id.et_skills);
        jobKeywords = (EditText) rootView.findViewById(R.id.et_jobPostingKeywords);
        jobRequirements = (EditText) rootView.findViewById(R.id.et_requirements);
        jobSummary = (EditText) rootView.findViewById(R.id.et_summary);
        industry = (EditText) rootView.findViewById(R.id.et_industry);
        layout_fileName = (LinearLayout) rootView.findViewById(R.id.layout_fileName);


        btn_browse = (TextView) rootView.findViewById(R.id.btn_browse);
        //btn_delete = (ImageView) rootView.findViewById(R.id.btn_delete);
        btn_plus = (ImageView) rootView.findViewById(R.id.btn_plus);
        layout_more = (LinearLayout) rootView.findViewById(R.id.layout_more);
        filenames = new ArrayList<TextView>();
        pathofmedia = new ArrayList<Mediabeans>();
        parent_layout = (LinearLayout) rootView.findViewById(R.id.parent_layout);
        layout = (LinearLayout) rootView.findViewById(R.id.layout);
        tv_fileName = (TextView) rootView.findViewById(R.id.tv_fileName);
        spinner_uploadFileType = (Spinner) rootView.findViewById(R.id.spinner_uploadFileType);


        countries = new ArrayList<CountryObject>();
        states = new ArrayList<StatesObject>();
        industryKeywordList = new ArrayList<GenericObject>();

        jobTypeKeywordList = new ArrayList<GenericObject>();
        jobPostingKeywordList = new ArrayList<GenericObject>();
        jobSkillskeywordsList = new ArrayList<GenericObject>();


        selectedKeywordList = new ArrayList<String>();
        companyList = new ArrayList<GenericObject>();


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

        endDate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                new DatePickerDialog(getActivity(), date, myCalendar
                        .get(Calendar.YEAR), myCalendar.get(Calendar.MONTH),
                        myCalendar.get(Calendar.DAY_OF_MONTH)).show();
            }
        });

        Calendar c = Calendar.getInstance();


        SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
        String formattedDate = df.format(c.getTime());
        startDate.setText(formattedDate);

// Get Companies Hired For+++++++++++++++++++++++++++++++++++++++++++++++++++

        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();

            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_COMPANY_TAG, Constants.USER_COMPANY_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_POST, "Home Activity");
            a.execute();
            ;
        } else {

            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


        industry.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                for (int i = 0; i < industryKeywordList.size(); i++) {
                    Log.d("ischecked", String.valueOf(industryKeywordList.get(i).ischecked()));
                }

                if (industryKeywordList.size() == 0) {
                    Toast.makeText(getActivity(), "No Keyword available!", Toast.LENGTH_LONG).show();
                } else {
                    final Dialog dialog = new Dialog(getActivity());
                    dialog.setContentView(R.layout.keywords_dialog);
                    dialog.setTitle("Industry Keywords");
                    final EditText search = (EditText) dialog.findViewById(R.id.et_search);
                    final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                    for (int i = 0; i < industryKeywordList.size(); i++) {
                        tempArray.add(industryKeywordList.get(i));
                        Log.e("retain", String.valueOf(tempArray.get(i).ischecked()));
                    }
                    final ListView lv = (ListView) dialog.findViewById(R.id.listKeywords);
                    lv.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);

                    final KeywordsAdapter adapterCampaign = new KeywordsAdapter(getActivity(), 0, industryKeywordList);
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
                            industryKeywordList.clear();

                            for (int i = 0; i < tempArray.size(); i++) {
                                industryKeywordList.add(i, tempArray.get(i));
                            }

                            StringBuilder selectedKeywordsId = new StringBuilder();
                            selectedKeywordList.clear();
                            for (int i = 0; i < industryKeywordList.size(); i++) {
                                if (industryKeywordList.get(i).ischecked()) {
                                    selectedKeywordList.add(industryKeywordList.get(i).getId());
                                }
                            }

                            for (int i = 0; i < selectedKeywordList.size(); i++) {
                                if (selectedKeywordsId.length() > 0) {
                                    selectedKeywordsId.append(",");
                                }
                                selectedKeywordsId.append(selectedKeywordList.get(i));
                            }
                            selectedIndustryKeywords = selectedKeywordsId.toString();
                            System.out.println(selectedIndustryKeywords.toString() + "-------------------------");
                            tempArray.clear();

                            dialog.dismiss();
                        }
                    });


                    dialogButton.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {

                            ArrayList<GenericObject> mArrayProducts = adapterCampaign.getCheckedItems();
                            for (int i = 0; i < mArrayProducts.size(); i++) {
                                for (int j = 0; j < industryKeywordList.size(); j++) {
                                    if (mArrayProducts.get(i).getId().equalsIgnoreCase(industryKeywordList.get(j).getId())) {
                                        industryKeywordList.get(j).setIschecked(true);
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

                            selectedIndustryKeywords = selectedKeywordID.toString();
                            industry.setText("Industry Keywords: " + sb.toString());
                            System.out.println(selectedIndustryKeywords.toString() + "-------------------------");

                            dialog.dismiss();
                        }
                    });
                    dialog.show();
                }
            }

        });

        //++++++++++++++++++++++++++++++++++++++++++++++++++JOB POSTING KEYWORDS++++++++++++++++++++++++++++++


        jobKeywords.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                for (int i = 0; i < jobPostingKeywordList.size(); i++) {
                    Log.d("ischecked", String.valueOf(jobPostingKeywordList.get(i).ischecked()));
                }

                if (jobPostingKeywordList.size() == 0) {
                    Toast.makeText(getActivity(), "No Keyword available!", Toast.LENGTH_LONG).show();
                } else {
                    final Dialog dialog = new Dialog(getActivity());
                    dialog.setContentView(R.layout.keywords_dialog);
                    dialog.setTitle("Job Posting Keywords");
                    final EditText search = (EditText) dialog.findViewById(R.id.et_search);
                    final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                    for (int i = 0; i < jobPostingKeywordList.size(); i++) {
                        tempArray.add(jobPostingKeywordList.get(i));
                        Log.e("retain", String.valueOf(tempArray.get(i).ischecked()));
                    }
                    final ListView lv = (ListView) dialog.findViewById(R.id.listKeywords);
                    lv.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);

                    final KeywordsAdapter adapterCampaign = new KeywordsAdapter(getActivity(), 0, jobPostingKeywordList);
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
                            jobPostingKeywordList.clear();

                            for (int i = 0; i < tempArray.size(); i++) {
                                jobPostingKeywordList.add(i, tempArray.get(i));
                            }

                            StringBuilder selectedKeywordsId = new StringBuilder();
                            selectedKeywordList.clear();
                            for (int i = 0; i < jobPostingKeywordList.size(); i++) {
                                if (jobPostingKeywordList.get(i).ischecked()) {
                                    selectedKeywordList.add(jobPostingKeywordList.get(i).getId());
                                }
                            }

                            for (int i = 0; i < selectedKeywordList.size(); i++) {
                                if (selectedKeywordsId.length() > 0) {
                                    selectedKeywordsId.append(",");
                                }
                                selectedKeywordsId.append(selectedKeywordList.get(i));
                            }
                            selectedJobPostingKeywords = selectedKeywordsId.toString();
                            System.out.println(selectedJobPostingKeywords.toString() + "-------------------------");
                            tempArray.clear();

                            dialog.dismiss();
                        }
                    });


                    dialogButton.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {

                            ArrayList<GenericObject> mArrayProducts = adapterCampaign.getCheckedItems();
                            for (int i = 0; i < mArrayProducts.size(); i++) {
                                for (int j = 0; j < jobPostingKeywordList.size(); j++) {
                                    if (mArrayProducts.get(i).getId().equalsIgnoreCase(jobPostingKeywordList.get(j).getId())) {
                                        jobPostingKeywordList.get(j).setIschecked(true);
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

                            selectedJobPostingKeywords = selectedKeywordID.toString();
                            jobKeywords.setText("Job Posting Keywords: " + sb.toString());
                            System.out.println(selectedJobPostingKeywords.toString() + "-------------------------");

                            dialog.dismiss();
                        }
                    });
                    dialog.show();
                }
            }

        });

//+++++++++++++++++++++++++++++++++++++++++++SKILLS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        skills.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                for (int i = 0; i < jobSkillskeywordsList.size(); i++) {
                    Log.d("ischecked", String.valueOf(jobSkillskeywordsList.get(i).ischecked()));
                }

                if (jobSkillskeywordsList.size() == 0) {
                    Toast.makeText(getActivity(), "No Keyword available!", Toast.LENGTH_LONG).show();
                } else {
                    final Dialog dialog = new Dialog(getActivity());
                    dialog.setContentView(R.layout.keywords_dialog);
                    dialog.setTitle("Skills Keywords");
                    final EditText search = (EditText) dialog.findViewById(R.id.et_search);
                    final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                    for (int i = 0; i < jobSkillskeywordsList.size(); i++) {
                        tempArray.add(jobSkillskeywordsList.get(i));
                        Log.e("retain", String.valueOf(tempArray.get(i).ischecked()));
                    }
                    final ListView lv = (ListView) dialog.findViewById(R.id.listKeywords);
                    lv.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);

                    final KeywordsAdapter adapterCampaign = new KeywordsAdapter(getActivity(), 0, jobSkillskeywordsList);
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
                            jobSkillskeywordsList.clear();

                            for (int i = 0; i < tempArray.size(); i++) {
                                jobSkillskeywordsList.add(i, tempArray.get(i));
                            }

                            StringBuilder selectedKeywordsId = new StringBuilder();
                            selectedKeywordList.clear();
                            for (int i = 0; i < jobSkillskeywordsList.size(); i++) {
                                if (jobSkillskeywordsList.get(i).ischecked()) {
                                    selectedKeywordList.add(jobSkillskeywordsList.get(i).getId());
                                }
                            }

                            for (int i = 0; i < selectedKeywordList.size(); i++) {
                                if (selectedKeywordsId.length() > 0) {
                                    selectedKeywordsId.append(",");
                                }
                                selectedKeywordsId.append(selectedKeywordList.get(i));
                            }
                            selectedSkillsKeywords = selectedKeywordsId.toString();
                            System.out.println(selectedSkillsKeywords.toString() + "-------------------------");
                            tempArray.clear();

                            dialog.dismiss();
                        }
                    });


                    dialogButton.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {

                            ArrayList<GenericObject> mArrayProducts = adapterCampaign.getCheckedItems();
                            for (int i = 0; i < mArrayProducts.size(); i++) {
                                for (int j = 0; j < jobSkillskeywordsList.size(); j++) {
                                    if (mArrayProducts.get(i).getId().equalsIgnoreCase(jobSkillskeywordsList.get(j).getId())) {
                                        jobSkillskeywordsList.get(j).setIschecked(true);
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

                            selectedSkillsKeywords = selectedKeywordID.toString();
                            skills.setText("Skills: " + sb.toString());
                            System.out.println(selectedSkillsKeywords.toString() + "-------------------------");

                            dialog.dismiss();
                        }
                    });
                    dialog.show();
                }
            }

        });

//++++++++++++++++++++++++++++++++++++++++++++++++++COUNTY+++++++++++++STATE+++++++++++++++++++++++++++++++++

        countrySpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                COUNTRY_ID = Integer.parseInt(countries.get(position).getId());
                //COUNTRY_ID = Integer.parseInt(countries.get(position).getId());

                states = countries.get(position).getStatesObjects();
                //Toast.makeText(getActivity(), "size" + states.size(), Toast.LENGTH_LONG).show();
                stateAdapter = new StatesAdapter(getActivity(), 0, states);
                citySpinner.setAdapter(stateAdapter);

                if (stateAdapter != null) {
                    for (int i = 0; i < stateAdapter.getCount(); i++) {
                        if (stateAdapter.getId(i).equalsIgnoreCase(STATE_ID + "")) {
                            citySpinner.setSelection(i);
                        }
                    }
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        citySpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                STATE_ID = Integer.parseInt(states.get(position).getId());

            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });


        //++++++++++++++++++++++BTN PLUS++++++++++++++++++++++++++++++++++++++++

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

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++btn_BROWSE+++++++++++++++++++++++++++++++++++++++++++
        tv_deleteFile = (ImageView) rootView.findViewById(R.id.tv_deleteFile);
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
//++++++++++++++++++++++++++++++++++++++BTN SUBMIT++++++++++++++++++++++++++++++++++++++++

        companyName.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                COMPANY_ID = Integer.parseInt(companyList.get(position).getId());
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        jobType.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                JOB_TYPE_ID = Integer.parseInt(jobTypeKeywordList.get(position).getId());
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });


        btn_submit = (Button) rootView.findViewById(R.id.btn_submit);

        btn_submit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                try {
                    InputMethodManager inputMethodManager = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
                    inputMethodManager.hideSoftInputFromWindow(getActivity().getCurrentFocus().getWindowToken(), 0);

                    if (companyName.getSelectedItemPosition() == 0) {
                        Toast.makeText(getActivity(), "Company Name cannot be left blank!", Toast.LENGTH_LONG).show();
                    } else if (selectedIndustryKeywords.isEmpty()) {
                        Toast.makeText(getActivity(), "Select at least one Industry Keyword!", Toast.LENGTH_LONG).show();
                    } else if (COUNTRY_ID == -1) {
                        Toast.makeText(getActivity(), "Select Country!", Toast.LENGTH_LONG).show();
                    } else if (STATE_ID == -1) {
                        Toast.makeText(getActivity(), "Select State!", Toast.LENGTH_LONG).show();
                    } else if (jobTitle.getText().toString().trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Job Title cannot be left blank!", Toast.LENGTH_LONG).show();
                    } else if (DateTimeFormatClass.compareDates(myCalendar.getTime())) {
                        Toast.makeText(getActivity(), "Due date cannot be present or past date!", Toast.LENGTH_LONG).show();
                    } else if (location.getText().toString().trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Location cannot be left blank!", Toast.LENGTH_LONG).show();
                    } else if (jobRequirements.getText().toString().trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Requirements cannot be left blank!", Toast.LENGTH_LONG).show();
                    } else if (selectedSkillsKeywords.isEmpty()) {
                        Toast.makeText(getActivity(), "Select at least one Skill!", Toast.LENGTH_LONG).show();
                    } else if (selectedJobPostingKeywords.isEmpty()) {
                        Toast.makeText(getActivity(), "Select at least one Job Posting Keyword!", Toast.LENGTH_LONG).show();
                    } else if (jobSummary.getText().toString().trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Summary cannot be left blank!", Toast.LENGTH_LONG).show();
                    } else if (minimumWorkNPS.getText().toString().trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Minimum Work NPS cannot be left blank!", Toast.LENGTH_LONG).show();
                    } else {

                        HashMap<String, String> map = new HashMap<String, String>();
                        map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                        map.put("company_id", String.valueOf(COMPANY_ID));
                        map.put("industry_id", selectedIndustryKeywords);
                        map.put("job_title", jobTitle.getText().toString());
                        map.put("role", jobRole.getText().toString());
                        map.put("job_type", String.valueOf(JOB_TYPE_ID));
                        map.put("min_work_nps", minimumWorkNPS.getText().toString());
                        map.put("country_id", String.valueOf(COUNTRY_ID));
                        map.put("state_id", String.valueOf(STATE_ID));
                        map.put("location", location.getText().toString());
                        map.put("description", jobSummary.getText().toString().trim());
                        map.put("travel", travel.getText().toString().trim());
                        map.put("start_date", startDate.getText().toString().trim());
                        map.put("end_date", endDate.getText().toString().trim());
                        map.put("skills", selectedSkillsKeywords);
                        map.put("requirements", jobRequirements.getText().toString().trim());
                        map.put("posting_keywords", selectedJobPostingKeywords);
                        map.put("job_id", getArguments().getString("JOB_ID"));


                        //getActivity().onBackPressed();
                        for (int j = 0; j < pathofmedia.size(); j++) {
                            Log.d("file path", pathofmedia.get(j).getPath());
                            Log.d("file size", pathofmedia.get(j).getFilesize());
                            Log.d("file type", pathofmedia.get(j).getType());
                        }
                        Log.e("map", map.toString());
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            saveCampaign(map, Constants.EDIT_JOB_URL);
                            // new ImageUploader().execute();
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }

                        //saveCampaign(map, Constants.ADD_CAMPAIGN_URL);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });


        audioObjectsList = new ArrayList<AudioObject>();
        videoObjectList = new ArrayList<AudioObject>();
        documentObjectList = new ArrayList<AudioObject>();


        list_audios = (ListView) rootView.findViewById(R.id.list_audios);
        list_docs = (ListView) rootView.findViewById(R.id.list_docs);
        list_video = (ListView) rootView.findViewById(R.id.list_video);

        expandable_playAudio = (LinearLayout) rootView.findViewById(R.id.expandable_playAudio);
        expandable_playVideo = (LinearLayout) rootView.findViewById(R.id.expandable_playVideo);
        expandable_viewDocument = (LinearLayout) rootView.findViewById(R.id.expandable_viewDocument);


        btn_playAudio = (LinearLayout) rootView.findViewById(R.id.btn_playAudio);
        btn_playVideo = (LinearLayout) rootView.findViewById(R.id.btn_playVideo);
        btn_viewDocument = (LinearLayout) rootView.findViewById(R.id.btn_viewDocument);


        viewDocumentArrow = (ImageView) rootView.findViewById(R.id.viewDocumentArrow);
        viewplayAudioArrow = (ImageView) rootView.findViewById(R.id.viewplayAudioArrow);
        viewplayVideoArrow = (ImageView) rootView.findViewById(R.id.viewplayVideoArrow);


        btn_playAudio.setOnClickListener(this);
        btn_viewDocument.setOnClickListener(this);
        btn_playVideo.setOnClickListener(this);


        expandable_playAudio.getViewTreeObserver().addOnPreDrawListener(
                new ViewTreeObserver.OnPreDrawListener() {

                    @Override
                    public boolean onPreDraw() {
                        expandable_playAudio.getViewTreeObserver().removeOnPreDrawListener(this);
                        expandable_playAudio.setVisibility(View.GONE);

                        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                        final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_audios.getHeight(), View.MeasureSpec.UNSPECIFIED);
                        System.out.println(heightSpec);
                        expandable_playAudio.measure(widthSpec, heightSpec);

                        mAnimatorForAudio = slideAnimatorForAudio(0, expandable_playAudio.getMeasuredHeight());
                        return true;
                    }
                });

        expandable_viewDocument.getViewTreeObserver().addOnPreDrawListener(
                new ViewTreeObserver.OnPreDrawListener() {

                    @Override
                    public boolean onPreDraw() {
                        expandable_viewDocument.getViewTreeObserver().removeOnPreDrawListener(this);
                        expandable_viewDocument.setVisibility(View.GONE);

                        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                        final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_docs.getHeight(), View.MeasureSpec.UNSPECIFIED);
                        System.out.println(heightSpec);
                        expandable_viewDocument.measure(widthSpec, heightSpec);

                        mAnimatorForDoc = slideAnimatorForDocument(0, expandable_viewDocument.getMeasuredHeight());
                        return true;
                    }
                });
        expandable_playVideo.getViewTreeObserver().addOnPreDrawListener(
                new ViewTreeObserver.OnPreDrawListener() {

                    @Override
                    public boolean onPreDraw() {
                        expandable_playVideo.getViewTreeObserver().removeOnPreDrawListener(this);
                        expandable_playVideo.setVisibility(View.GONE);

                        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                        final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_video.getHeight(), View.MeasureSpec.UNSPECIFIED);
                        System.out.println(heightSpec);
                        expandable_playVideo.measure(widthSpec, heightSpec);

                        mAnimatorForVideo = slideAnimatorForVideo(0, expandable_playVideo.getMeasuredHeight());
                        return true;
                    }
                });

        return rootView;
    }


    private ValueAnimator slideAnimatorForDocument(int start, int end) {

        ValueAnimator animator = ValueAnimator.ofInt(start, end);


        try {
            animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                @Override
                public void onAnimationUpdate(ValueAnimator valueAnimator) {
                    //Update Height
                    int value = (Integer) valueAnimator.getAnimatedValue();

                    ViewGroup.LayoutParams layoutParams = expandable_viewDocument.getLayoutParams();
                    layoutParams.height = value;
                    expandable_viewDocument.setLayoutParams(layoutParams);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return animator;
    }


    private ValueAnimator slideAnimatorForAudio(int start, int end) {

        ValueAnimator animator = ValueAnimator.ofInt(start, end);


        try {
            animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                @Override
                public void onAnimationUpdate(ValueAnimator valueAnimator) {
                    //Update Height
                    int value = (Integer) valueAnimator.getAnimatedValue();

                    ViewGroup.LayoutParams layoutParams = expandable_playAudio.getLayoutParams();
                    layoutParams.height = value;
                    expandable_playAudio.setLayoutParams(layoutParams);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return animator;
    }

    private ValueAnimator slideAnimatorForVideo(int start, int end) {

        ValueAnimator animator = ValueAnimator.ofInt(start, end);


        try {
            animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                @Override
                public void onAnimationUpdate(ValueAnimator valueAnimator) {
                    //Update Height
                    int value = (Integer) valueAnimator.getAnimatedValue();

                    ViewGroup.LayoutParams layoutParams = expandable_playVideo.getLayoutParams();
                    layoutParams.height = value;
                    expandable_playVideo.setLayoutParams(layoutParams);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return animator;
    }


    private void expandForDocument() {
        //set Visible
        try {
            expandable_viewDocument.setVisibility(View.VISIBLE);
            viewDocumentArrow.setBackground(getResources().getDrawable(R.drawable.arrow_upward));

            list_docs.setVisibility(View.VISIBLE);
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        //mAnimatorForDoc.start();
    }


    private void expandForVideo() {
        //set Visible
        try {
            expandable_playVideo.setVisibility(View.VISIBLE);
            viewplayVideoArrow.setBackground(getResources().getDrawable(R.drawable.arrow_upward));
            list_video.setVisibility(View.VISIBLE);
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }


        // mAnimatorForVideo.start();
    }

    private void expandForAudio() {
        //set Visible
        try {
            expandable_playAudio.setVisibility(View.VISIBLE);
            viewplayAudioArrow.setBackground(getResources().getDrawable(R.drawable.arrow_upward));
            list_audios.setVisibility(View.VISIBLE);
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // mAnimatorForAudio.start();
    }

    private void collapseForDoc() {
//        int finalHeight = expandable_viewDocument.getHeight();
        try {
            viewDocumentArrow.setBackground(getResources().getDrawable(R.drawable.arrow_downward));


            expandable_viewDocument.getViewTreeObserver().addOnPreDrawListener(
                    new ViewTreeObserver.OnPreDrawListener() {

                        @Override
                        public boolean onPreDraw() {
                            expandable_viewDocument.getViewTreeObserver().removeOnPreDrawListener(this);
                            expandable_viewDocument.setVisibility(View.GONE);

                            final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_docs.getHeight(), View.MeasureSpec.UNSPECIFIED);
                            System.out.println(heightSpec);
                            expandable_viewDocument.measure(widthSpec, heightSpec);

                            mAnimatorForDoc = slideAnimatorForDocument(0, expandable_viewDocument.getMeasuredHeight());
                            return true;
                        }

                    });
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void collapseForAudio() {
//        int finalHeight = expandable_playAudio.getHeight();
        try {
            viewplayAudioArrow.setBackground(getResources().getDrawable(R.drawable.arrow_downward));


            expandable_playAudio.getViewTreeObserver().addOnPreDrawListener(
                    new ViewTreeObserver.OnPreDrawListener() {

                        @Override
                        public boolean onPreDraw() {
                            expandable_playAudio.getViewTreeObserver().removeOnPreDrawListener(this);
                            expandable_playAudio.setVisibility(View.GONE);

                            final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_audios.getHeight(), View.MeasureSpec.UNSPECIFIED);
                            System.out.println(heightSpec);
                            expandable_playAudio.measure(widthSpec, heightSpec);

                            mAnimatorForAudio = slideAnimatorForAudio(0, expandable_playAudio.getMeasuredHeight());
                            return true;
                        }
                    });
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void collapseForVideo() {
//        int finalHeight = expandable_playVideo.getHeight();
        try {
            viewplayVideoArrow.setBackground(getResources().getDrawable(R.drawable.arrow_downward));

            expandable_playVideo.getViewTreeObserver().addOnPreDrawListener(
                    new ViewTreeObserver.OnPreDrawListener() {

                        @Override
                        public boolean onPreDraw() {
                            expandable_playVideo.getViewTreeObserver().removeOnPreDrawListener(this);
                            expandable_playVideo.setVisibility(View.GONE);

                            final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            final int heightSpec = View.MeasureSpec.makeMeasureSpec(list_video.getHeight(), View.MeasureSpec.UNSPECIFIED);
                            System.out.println(heightSpec);
                            expandable_playVideo.measure(widthSpec, heightSpec);

                            mAnimatorForVideo = slideAnimatorForVideo(0, expandable_playVideo.getMeasuredHeight());
                            return true;
                        }
                    });
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }


    }


    long totalSize = 0;
    Bitmap bitmap;

    private void saveCampaign(final HashMap<String, String> map, final String editUrl) {

        try {
            new AsyncTask<Integer, Integer, String>() {

                ProgressDialog pDialog;

                @Override
                protected void onPreExecute() {
                    // TODO Auto-generated method stub
                    super.onPreExecute();

                    pDialog = new ProgressDialog(getActivity());
                    pDialog.setMessage("Posting Job Please wait...");
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
                            Toast.makeText(getActivity(), "Your Job is created successfully.", Toast.LENGTH_LONG).show();
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

    private void updateLabel() {

        try {
            SimpleDateFormat sdf = new SimpleDateFormat(Constants.DATE_FORMAT, Locale.US);
            endDate.setText(sdf.format(myCalendar.getTime()));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


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
//                bitmap = BitmapFactory.decodeFile(filePath, o2);
//                image_forum.setImageBitmap(bitmap);
            } catch (Exception e) {
                e.printStackTrace();
//                image_forum.setImageResource(R.drawable.app_icon);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String titleText;

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnActivityResultListener(this);
        titleText = getArguments().getString("JOB_TITLE");

        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        ((HomeActivity) getActivity()).setActionBarTitle(getArguments().getString("JOB_TITLE"));
    }

    @Override
    public void onTaskComplete(String result, String tag) {
        try {
            if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
            } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
            } else {
                if (tag.equalsIgnoreCase(Constants.USER_COMPANY_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        GenericObject obj = new GenericObject();
                        obj.setTitle("Choose Company");
                        obj.setId("0");
                        companyList.add(obj);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            for (int i = 0; i < jsonObject.optJSONArray("company_list").length(); i++) {
                                GenericObject startupsObject = new GenericObject();
                                startupsObject.setId(jsonObject.optJSONArray("company_list").optJSONObject(i).optString("company_id"));
                                startupsObject.setTitle(jsonObject.optJSONArray("company_list").optJSONObject(i).optString("company_name"));

                                companyList.add(startupsObject);
                            }

                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.JOB_INDUSTRIES_KEYWORDS_TAG, Constants.JOB_INDUSTRIES_KEYWORDS_URL, Constants.HTTP_GET, "Home Activity");
                                a.execute();
                            } else {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }


                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.JOB_TYPE_KEYWORDS_TAG, Constants.JOB_TYPE_KEYWORDS_URL, Constants.HTTP_GET, "Home Activity");
                                a.execute();
                            } else {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }


                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.JOB_POSTING_KEYWORDS_TAG, Constants.JOB_POSTING_KEYWORDS_URL, Constants.HTTP_GET, "Home Activity");
                                a.execute();
                            } else {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }


                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SKILLS_QUALIFICATIONS_KEYWORDS_EXPERIENCE_CONTRACTORTYPE_PREFEREDSTARTUP_CERTIFICATIONS_TAG, Constants.SKILLS_QUALIFICATIONS_KEYWORDS_EXPERIENCE_CONTRACTORTYPE_PREFEREDSTARTUP_CERTIFICATIONS_URL, Constants.HTTP_GET, "Home Activity");
                                a.execute();
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }


                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.GET_COUNTRIES_LIST_WITH_STATES_TAG, Constants.GET_COUNTRIES_LIST_WITH_STATES, Constants.HTTP_POST, "Home Activity");
                                a.execute();
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            Toast.makeText(getActivity(), jsonObject.optString("message") + " Try Again!", Toast.LENGTH_LONG).show();


                        }
                        companyName.setAdapter(new SpinnerAdapter(getActivity(), 0, companyList));
                    } catch (JSONException e) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.JOB_INDUSTRIES_KEYWORDS_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        industryKeywordList.clear();
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            for (int i = 0; i < jsonObject.optJSONArray("job_industry_list").length(); i++) {
                                GenericObject obj = new GenericObject();
                                obj.setId(jsonObject.optJSONArray("job_industry_list").getJSONObject(i).optString("job_industry_id"));
                                obj.setTitle(jsonObject.optJSONArray("job_industry_list").getJSONObject(i).optString("job_industry_name"));
                                industryKeywordList.add(obj);
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            industryKeywordList.clear();
                        }


                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.JOB_TYPE_KEYWORDS_TAG)) {

                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        jobTypeKeywordList.clear();
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            for (int i = 0; i < jsonObject.optJSONArray("job_type_list").length(); i++) {
                                GenericObject obj = new GenericObject();
                                obj.setId(jsonObject.optJSONArray("job_type_list").getJSONObject(i).optString("job_type_id"));
                                obj.setTitle(jsonObject.optJSONArray("job_type_list").getJSONObject(i).optString("job_type_name"));
                                jobTypeKeywordList.add(obj);
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            jobTypeKeywordList.clear();
                        }
                        jobType.setAdapter(new SpinnerAdapter(getActivity(), 0, jobTypeKeywordList));

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                } else if (tag.equalsIgnoreCase(Constants.JOB_POSTING_KEYWORDS_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        jobPostingKeywordList.clear();
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            for (int i = 0; i < jsonObject.optJSONArray("company_keyword_list").length(); i++) {
                                GenericObject obj = new GenericObject();
                                obj.setId(jsonObject.optJSONArray("company_keyword_list").getJSONObject(i).optString("company_keyword_id"));
                                obj.setTitle(jsonObject.optJSONArray("company_keyword_list").getJSONObject(i).optString("company_keyword_name"));
                                jobPostingKeywordList.add(obj);
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            jobPostingKeywordList.clear();
                        }


                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.GET_COUNTRIES_LIST_WITH_STATES_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        countries.clear();

                        CountryObject obj = new CountryObject();
                        obj.setId("0");
                        obj.setName("Select Country");
                        ArrayList<StatesObject> selectCityObjectList = new ArrayList<StatesObject>();
                        StatesObject selectCityObj = new StatesObject();
                        selectCityObj.setId("0");
                        selectCityObj.setName("Select State");
                        selectCityObjectList.add(selectCityObj);
                        obj.setStatesObjects(selectCityObjectList);
                        countries.add(obj);

                        if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            JSONArray country = jsonObject.optJSONArray("country");

                            for (int i = 0; i < country.length(); i++) {
                                JSONObject countryJsonObject = country.getJSONObject(i);
                                CountryObject inner = new CountryObject();
                                inner.setId(countryJsonObject.getString("id"));
                                inner.setName(countryJsonObject.getString("name"));

                                states = new ArrayList<StatesObject>();
                                StatesObject obj1 = new StatesObject();
                                obj1.setId("0");
                                obj1.setName("Select State");
                                states.add(obj1);

                                JSONArray statesJsonArray = countryJsonObject.getJSONArray("state");
                                for (int j = 0; j < statesJsonArray.length(); j++) {
                                    StatesObject statesObject = new StatesObject();
                                    statesObject.setId(statesJsonArray.getJSONObject(j).getString("id"));
                                    statesObject.setName(statesJsonArray.getJSONObject(j).getString("name"));
                                    states.add(statesObject);
                                }

                                inner.setStatesObjects(states);

                                countries.add(inner);
                                countryAdapter = new CountryAdapter(getActivity(), 0, countries);
                                countrySpinner.setAdapter(countryAdapter);


                            }
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                ((HomeActivity) getActivity()).showProgressDialog();
                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.JOB_DETAILS_TAG, Constants.JOB_DETAILS_URL + "?job_id=" + getArguments().getString("JOB_ID") + "&user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET, "Home Activity");
                                a.execute();

                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }

                        } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            countryAdapter = new CountryAdapter(getActivity(), 0, countries);
                            countrySpinner.setAdapter(countryAdapter);
                        }




                    } catch (JSONException e) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }


                } else if (tag.equalsIgnoreCase(Constants.SKILLS_QUALIFICATIONS_KEYWORDS_EXPERIENCE_CONTRACTORTYPE_PREFEREDSTARTUP_CERTIFICATIONS_TAG)) {

                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        jobSkillskeywordsList.clear();
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            for (int i = 0; i < jsonObject.optJSONArray("skills").length(); i++) {
                                GenericObject obj = new GenericObject();
                                obj.setId(jsonObject.optJSONArray("skills").getJSONObject(i).optString("id"));
                                obj.setTitle(jsonObject.optJSONArray("skills").getJSONObject(i).optString("name"));
                                jobSkillskeywordsList.add(obj);
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            jobSkillskeywordsList.clear();
                        }


                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.JOB_DETAILS_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();

                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                            JSONObject campaigndetail = jsonObject.getJSONObject("job_details");

                            // companyName.setText(campaigndetail.optString("company_name"));
                            //   countrycity.setText(campaigndetail.optString("state").trim() + ", " + campaigndetail.optString("country").trim());
                            jobTitle.setText(campaigndetail.optString("job_title").trim());
                            jobRole.setText(campaigndetail.optString("role").trim());
                            //   jobType.setText(campaigndetail.optString("job_type").trim());
                            minimumWorkNPS.setText(campaigndetail.optString("min_work_nps").trim());
                            location.setText(campaigndetail.optString("location").trim());
                            travel.setText(campaigndetail.optString("travel").trim());
                            startDate.setText(campaigndetail.optString("start_date").trim());
                            endDate.setText(campaigndetail.optString("end_date").trim());
                            jobRequirements.setText(campaigndetail.optString("requirements").trim());
                            jobSummary.setText(campaigndetail.optString("description").trim());


                          //STARTUP_ID = Integer.parseInt(campaigndetail.optString("startup_id").trim());

                            StringBuilder stringBuilder = new StringBuilder();
                            StringBuilder stringBuilderCampaign = new StringBuilder();

                            if (campaigndetail.has("skills")) {
                                for (int i = 0; i < campaigndetail.optJSONArray("skills").length(); i++) {
                                    //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                    if ((i >= 0) && (i < (campaigndetail.optJSONArray("skills").length() - 1))) {
                                        stringBuilder.append(campaigndetail.optJSONArray("skills").getJSONObject(i).optString("name") + ", ");
                                    } else {
                                        stringBuilder.append(campaigndetail.optJSONArray("skills").getJSONObject(i).optString("name") + " ");
                                    }
                                }
                                skills.setText("Skills: " + stringBuilder.toString());
                            }


                            if (campaigndetail.has("posting_keywords")) {
                                for (int i = 0; i < campaigndetail.optJSONArray("posting_keywords").length(); i++) {
                                    //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                    if ((i >= 0) && (i < (campaigndetail.optJSONArray("posting_keywords").length() - 1))) {
                                        stringBuilderCampaign.append(campaigndetail.optJSONArray("posting_keywords").getJSONObject(i).optString("name") + ", ");
                                    } else {
                                        stringBuilderCampaign.append(campaigndetail.optJSONArray("posting_keywords").getJSONObject(i).optString("name") + " ");

                                    }
                                }
                                jobKeywords.setText("Job Search Keywords: " + stringBuilderCampaign.toString());
                            }


                            if (campaigndetail.has("job_industry")) {
                                for (int i = 0; i < campaigndetail.optJSONArray("job_industry").length(); i++) {
                                    //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                    if ((i >= 0) && (i < (campaigndetail.optJSONArray("job_industry").length() - 1))) {
                                        stringBuilderCampaign.append(campaigndetail.optJSONArray("job_industry").getJSONObject(i).optString("name") + ", ");
                                    } else {
                                        stringBuilderCampaign.append(campaigndetail.optJSONArray("job_industry").getJSONObject(i).optString("name") + " ");

                                    }
                                }
                                industry.setText("Industry Keywords: " + stringBuilderCampaign.toString());
                            }

                            //keywords



                            if (campaigndetail.optString("country_id").toString().trim().length() == 0) {
                                COUNTRY_ID = 0;
                            } else {
                                COUNTRY_ID = Integer.parseInt(campaigndetail.optString("country_id").toString().trim());
                            }
                            if (campaigndetail.optString("state_id").toString().trim().length() == 0) {
                                STATE_ID = 0;
                            } else {
                                STATE_ID = Integer.parseInt(campaigndetail.optString("state_id").toString().trim());
                            }
                            if (countryAdapter != null) {
                                for (int position = 0; position < countryAdapter.getCount(); position++) {
                                    if (countryAdapter.getId(position).equalsIgnoreCase(COUNTRY_ID + "")) {
                                        countrySpinner.setSelection(position);
                                    }
                                }
                            }
                            if (stateAdapter != null) {
                                for (int position = 0; position < stateAdapter.getCount(); position++) {
                                    if (stateAdapter.getId(position).equalsIgnoreCase(STATE_ID + "")) {
                                        citySpinner.setSelection(position);
                                    }
                                }
                            }




                            if (campaigndetail.optString("job_type_id").toString().trim().length() == 0) {
                                JOB_TYPE_ID = 0;
                            } else {
                                JOB_TYPE_ID = Integer.parseInt(campaigndetail.optString("job_type_id").toString().trim());
                            }
                            if (!jobTypeKeywordList.isEmpty()) {
                                for (int position = 0; position < jobTypeKeywordList.size(); position++) {
                                    if (jobTypeKeywordList.get(position).getId().equalsIgnoreCase(JOB_TYPE_ID + "")) {
                                        jobType.setSelection(position);
                                    }
                                }
                            }

                            if (campaigndetail.optString("company_id").toString().trim().length() == 0) {
                                COMPANY_ID = 0;
                            } else {
                                COMPANY_ID = Integer.parseInt(campaigndetail.optString("company_id").toString().trim());
                            }
                            if (!companyList.isEmpty()) {
                                for (int position = 0; position < companyList.size(); position++) {
                                    if (companyList.get(position).getId().equalsIgnoreCase(COMPANY_ID + "")) {
                                        companyName.setSelection(position);
                                    }
                                }
                            }




                            audioObjectsList.clear();

                            AudioObject audioObject = new AudioObject();
                            audioObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + campaigndetail.optString("audio"));
                            //   int a = audios_list.getJSONObject(i).getString("file").lastIndexOf("/");
                            audioObject.setName("Audio " + (1));
                            audioObjectsList.add(audioObject);


                            list_audios.setAdapter(new AudioAdapter());
                            //UtilityList.setListViewHeightBasedOnChildren(list_audios);
                            //ListUtils.setDynamicHeight(list_audios);


                            videoObjectList.clear();

                            AudioObject videoObject = new AudioObject();
                            videoObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + campaigndetail.optString("video"));
                            // int a = videos_list.getJSONObject(i).getString("file").lastIndexOf("/");
                            videoObject.setName("Video " + (1));
                            videoObjectList.add(videoObject);

                            list_video.setAdapter(new VideoListAdapter());
                            //UtilityList.setListViewHeightBasedOnChildren(list_video);
                            //ListUtils.setDynamicHeight(list_video);


                            documentObjectList.clear();

                            AudioObject documentObject = new AudioObject();
                            documentObject.setAudioUrl(Constants.APP_IMAGE_URL + "/" + campaigndetail.optString("document"));
                            //   int a = documents_list.getJSONObject(i).getString("file").lastIndexOf("/");
                            documentObject.setName("Document " + (1));
                            //Log.e("doc", Constants.APP_IMAGE_URL + "/" + documents_list.getJSONObject(i).getString("file").replaceAll(" ", "%20"));
                            documentObjectList.add(documentObject);


                            list_docs.setAdapter(new DocumentListAdapter());

                            UtilityList.setListViewHeightBasedOnChildren(list_docs);
                            UtilityList.setListViewHeightBasedOnChildren(list_audios);
                            UtilityList.setListViewHeightBasedOnChildren(list_video);


                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                }
            }


        } catch (Exception e) {

        }
    }

    @Override
    public void onClick(View v) {
        try {
            switch (v.getId()) {
                case R.id.btn_playAudio:
                    if (expandable_playAudio.getVisibility() == View.GONE) {
                        expandForAudio();
                    } else {
                        collapseForAudio();
                    }
                    break;
                case R.id.btn_playVideo:
                    if (expandable_playVideo.getVisibility() == View.GONE) {
                        expandForVideo();
                    } else {
                        collapseForVideo();
                    }
                    break;
                case R.id.btn_viewDocument:
                    if (expandable_viewDocument.getVisibility() == View.GONE) {
                        expandForDocument();
                    } else {
                        collapseForDoc();
                    }
                    break;


            }
        } catch (Exception e) {

        }
    }


    class DocumentListAdapter extends BaseAdapter {
        private LayoutInflater l_Inflater;

        class ViewHolder {
            TextView tv_name;
            ImageView view;
            LinearLayout row_layout;
        }

        public DocumentListAdapter() {
            l_Inflater = LayoutInflater.from(getActivity());
        }

        @Override
        public int getCount() {
            return documentObjectList.size();
        }


        @Override
        public Object getItem(int position) {
            return documentObjectList.get(position);
        }


        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder;


            if (convertView == null) {
                convertView = l_Inflater.inflate(R.layout.row_item, null);
                holder = new ViewHolder();
                holder.row_layout = (LinearLayout) convertView.findViewById(R.id.row_layout);
                holder.tv_name = (TextView) convertView.findViewById(R.id.text1);
                holder.view = (ImageView) convertView.findViewById(R.id.view);

                convertView.setTag(holder);

            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            try {
                holder.tv_name.setText(documentObjectList.get(position).getName());
            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                holder.row_layout.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Fragment rateContributor = new WebViewFragment();


                        Bundle bundle = new Bundle();

                        bundle.putString("url", documentObjectList.get(position).getAudioUrl());
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                        /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*/
                    }
                });
                holder.view.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Fragment rateContributor = new WebViewFragment();


                        Bundle bundle = new Bundle();

                        bundle.putString("url", documentObjectList.get(position).getAudioUrl());
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                        /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*/
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }


            return convertView;
        }
    }

    class VideoListAdapter extends BaseAdapter {
        private LayoutInflater l_Inflater;

        class ViewHolder {
            TextView tv_name;
            ImageView view;
            LinearLayout row_layout;
        }

        public VideoListAdapter() {
            l_Inflater = LayoutInflater.from(getActivity());
        }

        @Override
        public int getCount() {
            return videoObjectList.size();
        }


        @Override
        public Object getItem(int position) {
            return videoObjectList.get(position);
        }


        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder;


            if (convertView == null) {
                convertView = l_Inflater.inflate(R.layout.row_item, null);
                holder = new ViewHolder();
                holder.row_layout = (LinearLayout) convertView.findViewById(R.id.row_layout);
                holder.tv_name = (TextView) convertView.findViewById(R.id.text1);
                holder.view = (ImageView) convertView.findViewById(R.id.view);

                convertView.setTag(holder);

            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            try {
                holder.tv_name.setText(videoObjectList.get(position).getName());
            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                holder.view.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Fragment rateContributor = new WebViewFragment();


                        Bundle bundle = new Bundle();

                        bundle.putString("url", videoObjectList.get(position).getAudioUrl());
                        rateContributor.setArguments(bundle);

                        ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                        /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*/
                    }
                });

                holder.row_layout.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Fragment rateContributor = new WebViewFragment();


                        Bundle bundle = new Bundle();

                        bundle.putString("url", videoObjectList.get(position).getAudioUrl());
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                        /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*/
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }

            return convertView;
        }
    }

    class AudioAdapter extends BaseAdapter {
        private LayoutInflater l_Inflater;

        class ViewHolder {
            TextView tv_name;
            ImageView view;
            LinearLayout row_layout;
        }

        public AudioAdapter() {
            l_Inflater = LayoutInflater.from(getActivity());
        }

        @Override
        public int getCount() {
            return audioObjectsList.size();
        }


        @Override
        public Object getItem(int position) {
            return audioObjectsList.get(position);
        }


        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder;


            if (convertView == null) {
                convertView = l_Inflater.inflate(R.layout.row_item, null);
                holder = new ViewHolder();
                holder.row_layout = (LinearLayout) convertView.findViewById(R.id.row_layout);
                holder.tv_name = (TextView) convertView.findViewById(R.id.text1);
                holder.view = (ImageView) convertView.findViewById(R.id.view);

                convertView.setTag(holder);

            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            try {
                holder.tv_name.setText(audioObjectsList.get(position).getName());
            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                holder.view.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Fragment rateContributor = new WebViewFragment();


                        Bundle bundle = new Bundle();

                        bundle.putString("url", audioObjectsList.get(position).getAudioUrl());
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                       /* FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*/
                    }
                });

                holder.row_layout.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Fragment rateContributor = new WebViewFragment();


                        Bundle bundle = new Bundle();

                        bundle.putString("url", audioObjectsList.get(position).getAudioUrl());
                        rateContributor.setArguments(bundle);

                        ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                        /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                        transactionRate.replace(R.id.container, rateContributor);
                        transactionRate.addToBackStack(null);

                        transactionRate.commit();*/
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }
            return convertView;
        }
    }
}
