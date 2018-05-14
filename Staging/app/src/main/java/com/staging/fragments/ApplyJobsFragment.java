package com.staging.fragments;

import android.Manifest;
import android.animation.ValueAnimator;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.ContentResolver;
import android.content.Context;
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
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.vision.text.Line;
import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.RoadMapAdapter;
import com.staging.adapter.UserExperienceAdapter;
import com.staging.filebrowser.FilePicker;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.listeners.onActivityResultListener;
import com.staging.models.Mediabeans;
import com.staging.models.RoadMapObject;
import com.staging.models.UserExperienceObject;
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
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

/**
 * Created by Sunakshi.Gautam on 12/8/2016.
 */
public class ApplyJobsFragment extends Fragment implements onActivityResultListener, AsyncTaskCompleteListener<String> {

    private TextView jobTitle;
    private EditText applicantName;
    private EditText applicantSummary;
    private EditText applicantCoverLetter;
    private TextView browse_CoverLetter;
    private TextView browse_resume;
    private TextView tv_fileName;
    private TextView tv_fileNmaeResume;
    private ImageView tv_deleteResumeFile;
    private ImageView tv_deleteFile;
    private LinearLayout parent_layout, layout;
    private LinearLayout layout_fileName, layout_fileNameResume;
    public ArrayList<Mediabeans> pathofmedia;
    public ArrayList<Mediabeans> pathofmediaResume;

    private UserExperienceAdapter adapter;
    private ArrayList<UserExperienceObject> userExperienceList;
    int tagno, deleteNumber;
    private boolean filepicker;

    private ListView experienceList;
    private LinearLayout expandableExperience;
    private ImageView viewExperienceArrow;
    private LinearLayout experienceLayout;
    private Button addExperience;
    private Button applyForJob;


    public ApplyJobsFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.applyjob_layout, container, false);
        jobTitle = (TextView) rootView.findViewById(R.id.jobtitle);
        applicantName = (EditText) rootView.findViewById(R.id.et_applicantName);
        applicantSummary = (EditText) rootView.findViewById(R.id.et_applicantSummary);
        applicantCoverLetter = (EditText) rootView.findViewById(R.id.et_applicantCoverLetter);
        browse_CoverLetter = (TextView) rootView.findViewById(R.id.btn_browse);
        browse_resume = (TextView) rootView.findViewById(R.id.btn_browse_resume);
        tv_fileName = (TextView) rootView.findViewById(R.id.tv_fileName);
        tv_deleteFile = (ImageView) rootView.findViewById(R.id.tv_deleteFile);
        tv_fileNmaeResume = (TextView) rootView.findViewById(R.id.tv_fileNameResume);
        tv_deleteResumeFile = (ImageView) rootView.findViewById(R.id.tv_deleteFileResume);
        layout_fileName = (LinearLayout) rootView.findViewById(R.id.layout_fileName);
        layout_fileNameResume = (LinearLayout) rootView.findViewById(R.id.layout_fileNameResume);
        parent_layout = (LinearLayout) rootView.findViewById(R.id.parent_layout);
        layout = (LinearLayout) rootView.findViewById(R.id.layout);
        applyForJob = (Button) rootView.findViewById(R.id.btn_apply);

        experienceList = (ListView) rootView.findViewById(R.id.listView2);
        pathofmedia = new ArrayList<Mediabeans>();
        pathofmediaResume = new ArrayList<Mediabeans>();
        filenames = new ArrayList<TextView>();
        addExperience = (Button) rootView.findViewById(R.id.btn_addExperience);

        expandableExperience = (LinearLayout) rootView.findViewById(R.id.linearLayout5);
        viewExperienceArrow = (ImageView) rootView.findViewById(R.id.imageView3);
        experienceLayout = (LinearLayout) rootView.findViewById(R.id.linearLayout4);
        userExperienceList = new ArrayList<>();
        jobTitle.setText(getArguments().getString("JOB_TITLE"));
        applicantName.setText(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_FIRST_NAME)+" "+((HomeActivity) getActivity()).prefManager.getString(Constants.USER_LAST_NAME) );
//++++++++++++++++++++++COVER LAETTER BROWSIG FILE+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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

        browse_CoverLetter.setTag(0);

        browse_CoverLetter.setOnClickListener(new View.OnClickListener() {
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

                        acceptedFileExtensions = new String[]{".pdf"};


                        intent.putExtra("FILE_EXTENSION", acceptedFileExtensions);
                        getActivity().startActivityForResult(intent, Constants.FILE_PICKER);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
        });
///+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++RESUME+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


        tv_deleteResumeFile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    layout_fileNameResume.setVisibility(View.GONE);
                    String fileName = tv_fileNmaeResume.getText().toString().trim();
                    for (int i = 0; i < pathofmediaResume.size(); i++) {
                        if (pathofmediaResume.get(i).getFileName().equals(fileName)) {
                            pathofmediaResume.remove(i);
                        } else {
                            continue;
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });

        browse_resume.setTag(0);

        browse_resume.setOnClickListener(new View.OnClickListener() {
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

                        acceptedFileExtensions = new String[]{".pdf"};


                        intent.putExtra("FILE_EXTENSION", acceptedFileExtensions);
                        getActivity().startActivityForResult(intent, Constants.FILE_PICKER_RESUME);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
        });

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        expandableExperience.getViewTreeObserver().addOnPreDrawListener(
                new ViewTreeObserver.OnPreDrawListener() {

                    @Override
                    public boolean onPreDraw() {
                        expandableExperience.getViewTreeObserver().removeOnPreDrawListener(this);
                        expandableExperience.setVisibility(View.GONE);

                        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                        final int heightSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                        expandableExperience.measure(widthSpec, heightSpec);

                        mAnimator = slideAnimator(0, expandableExperience.getMeasuredHeight());
                        return true;
                    }
                });
        experienceLayout.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                if (expandableExperience.getVisibility() == View.GONE) {
                    viewExperienceArrow.setBackground(getResources().getDrawable(R.drawable.arrow_upward));
                    expand();
                } else {
                    viewExperienceArrow.setBackground(getResources().getDrawable(R.drawable.arrow_downward));
                    collapse();
                }
            }
        });

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        addExperience.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Fragment applyForJob = new AddExperienceFragment();
                ((HomeActivity) getActivity()).replaceFragment(applyForJob);
            }
        });
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


        applyForJob.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                try {
                    InputMethodManager inputMethodManager = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
                    inputMethodManager.hideSoftInputFromWindow(getActivity().getCurrentFocus().getWindowToken(), 0);

                    if (applicantName.getText().toString().isEmpty()) {
                        Toast.makeText(getActivity(), "Applicant Name cannot be left blank!", Toast.LENGTH_LONG).show();
                    } else if (applicantSummary.getText().toString().trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Job Summary cannot be left blank!", Toast.LENGTH_LONG).show();
                    } else if (applicantCoverLetter.getText().toString().trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Cover Letter cannot be left blank!", Toast.LENGTH_LONG).show();
                    } else if (pathofmedia.isEmpty()) {
                        Toast.makeText(getActivity(), "Please upload a Cover Letter!", Toast.LENGTH_LONG).show();
                    } else if (pathofmediaResume.isEmpty()) {
                        Toast.makeText(getActivity(), "Please upload Resume!", Toast.LENGTH_LONG).show();
                    } else {

                        HashMap<String, String> map = new HashMap<String, String>();
                        map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                        map.put("name", applicantName.getText().toString());
                        map.put("job_id", getArguments().getString("JOB_ID"));
                        map.put("summary", applicantSummary.getText().toString());
                        map.put("coverletter_text", applicantCoverLetter.getText().toString());
                        map.put("job_experience_id", jobExperience_id);


                        //getActivity().onBackPressed();
                        for (int j = 0; j < pathofmedia.size(); j++) {
                            Log.d("file path", pathofmedia.get(j).getPath());
                            Log.d("file size", pathofmedia.get(j).getFilesize());
                            Log.d("file type", pathofmedia.get(j).getType());
                        }

                        for (int j = 0; j < pathofmediaResume.size(); j++) {
                            Log.d("file path", pathofmediaResume.get(j).getPath());
                            Log.d("file size", pathofmediaResume.get(j).getFilesize());
                            Log.d("file type", pathofmediaResume.get(j).getType());
                        }


                        Log.e("map", map.toString());
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            saveCampaign(map, Constants.APPLY_JOB_URL);
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
        return rootView;
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
                    pDialog.setMessage("Posting Job Application Please wait...");
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

                    for (int i = 0; i < pathofmediaResume.size(); i++) {
                        files.add(new File(pathofmediaResume.get(i).getPath()));
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
                            Toast.makeText(getActivity(), "Your Job applied successfully.", Toast.LENGTH_LONG).show();
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

    private ValueAnimator mAnimator;

    private void expand() {
        //set Visible
        expandableExperience.setVisibility(View.VISIBLE);

		/* Remove and used in preDrawListener
        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
		final int heightSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
		mLinearLayout.measure(widthSpec, heightSpec);
		mAnimator = slideAnimator(0, mLinearLayout.getMeasuredHeight());
		*/

        // mAnimator.start();
    }

    private void collapse() {


        expandableExperience.getViewTreeObserver().addOnPreDrawListener(
                new ViewTreeObserver.OnPreDrawListener() {

                    @Override
                    public boolean onPreDraw() {
                        expandableExperience.getViewTreeObserver().removeOnPreDrawListener(this);
                        expandableExperience.setVisibility(View.GONE);

                        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                        final int heightSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                        expandableExperience.measure(widthSpec, heightSpec);

                        mAnimator = slideAnimator(0, expandableExperience.getMeasuredHeight());
                        return true;
                    }
                });
    }

    private ValueAnimator slideAnimator(int start, int end) {

        ValueAnimator animator = ValueAnimator.ofInt(start, end);


        animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
            @Override
            public void onAnimationUpdate(ValueAnimator valueAnimator) {
                //Update Height
                int value = (Integer) valueAnimator.getAnimatedValue();

                ViewGroup.LayoutParams layoutParams = expandableExperience.getLayoutParams();
                layoutParams.height = value;
                expandableExperience.setLayoutParams(layoutParams);
            }
        });
        return animator;
    }


    private File selectedFile;
    private String fileType;
    ArrayList<TextView> filenames;
    public static String filepath;
    private Uri fileUri;
    public static String fileName;

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

                    case Constants.FILE_PICKER_RESUME:

                        // if the result is capturing Image
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
                                layout_fileNameResume.setVisibility(View.VISIBLE);

                                if (tagno > 0) {
                                    TextView view = filenames.get(tagno - 1);
                                    view.setText(finalFile.getAbsolutePath().substring(a + 1).toString().trim());
                                } else {
                                    tv_fileNmaeResume.setText(finalFile.getAbsolutePath().substring(a + 1).toString().trim());
                                }

                                addpathResume(finalFile.getAbsolutePath(), "text", String.valueOf(length), finalFile.getAbsolutePath().substring(a + 1).toString().trim());
                            }
                            //filePath.setText();
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


    private void addpathResume(String path, String type, String filesize, String fileName) {
        try {
            boolean alreadyexist = false, already = false;
            for (int i = 0; i < pathofmediaResume.size(); i++) {
                if ((pathofmediaResume.get(i).getPath().equals(path))/* && (groupNameList.get(i).getPath().equals(fileName))*/) {
                    alreadyexist = true;
                }
            }
            if (!alreadyexist) {
                if (type.equalsIgnoreCase("image")) {
                    for (int i = 0; i < pathofmediaResume.size(); i++) {
                        if (pathofmediaResume.get(i).getType().equals("image")) {
                            pathofmediaResume.remove(i);
                        } else {
                            continue;
                        }
                    }
                }
                for (int i = 0; i < pathofmediaResume.size(); i++) {
                    if ((pathofmediaResume.get(i).getTag() == tagno)/* && (groupNameList.get(i).getPath().equals(fileName))*/) {
                        already = true;
                        pathofmediaResume.remove(i);
                        break;
                    }
                }

                pathofmediaResume.add(new Mediabeans(path, type, filesize, fileName, tagno));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //selection = groupNameList.size();
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


    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnActivityResultListener(this);
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        ((HomeActivity) getActivity()).setActionBarTitle("Apply for Job");

        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();

            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.GET_JOBEXPERIENCE_LIST_TAG, Constants.GET_JOBEXPERIENCE_LIST_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_POST, "Home Activity");
            a.execute();
            ;
        } else {

            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }
    }

    private String jobExperience_id;

    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            if (tag.equalsIgnoreCase(Constants.GET_JOBEXPERIENCE_LIST_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        userExperienceList.clear();
                        jobExperience_id = jsonObject.optString("job_experience_id");
                        Log.e("XXX", "JOB EXPERIENCEID" + jobExperience_id);
                        if (jsonObject.has("user_experience_list")) {
                            for (int i = 0; i < jsonObject.optJSONArray("user_experience_list").length(); i++) {
                                UserExperienceObject roadMapObject = new UserExperienceObject();
                                roadMapObject.setCompanyURL(jsonObject.optJSONArray("user_experience_list").getJSONObject(i).getString("company_name"));
                                roadMapObject.setJobTitle(jsonObject.optJSONArray("user_experience_list").getJSONObject(i).getString("job_title"));
                                roadMapObject.setStartDAte(jsonObject.optJSONArray("user_experience_list").getJSONObject(i).getString("start_date"));
                                roadMapObject.setEndDate(jsonObject.optJSONArray("user_experience_list").getJSONObject(i).getString("end_date"));


                                userExperienceList.add(roadMapObject);
                            }
                        }
                        adapter = new UserExperienceAdapter(getActivity(), userExperienceList);
                        experienceList.setAdapter(adapter);
                        UtilityList.setListViewHeightBasedOnChildren(experienceList);

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                    }
                } catch (Exception e) {
                    Toast.makeText(((HomeActivity) getActivity()), "No Experience Found.", Toast.LENGTH_SHORT).show();

                }
            }
        }
    }
}
