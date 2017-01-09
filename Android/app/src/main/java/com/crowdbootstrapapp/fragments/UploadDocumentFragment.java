package com.crowdbootstrapapp.fragments;

import android.Manifest;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v7.widget.AppCompatCheckBox;
import android.util.Log;
import android.view.ContextThemeWrapper;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Spinner;
import android.widget.Toast;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.dropdownadapter.SpinnerAdapter;
import com.crowdbootstrapapp.filebrowser.FilePicker;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.listeners.onActivityResultListener;
import com.crowdbootstrapapp.models.GenericObject;
import com.crowdbootstrapapp.models.TeamMemberObject;
import com.crowdbootstrapapp.utilities.AndroidMultipartEntity;
import com.crowdbootstrapapp.utilities.Async;
import com.crowdbootstrapapp.utilities.Constants;

import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by sunakshi.gautam on 1/27/2016.
 */
public class UploadDocumentFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String>, onActivityResultListener {

    static int IS_PUBLIC;
    static String ROADMAP_ID;

    private EditText filename;
    private LinearLayout layout;
    private String[] ids;
    private SpinnerAdapter deliverableAdapter;
    private File selectedFile;
    private String fileType;
    private Spinner selectRoadMapSpinner;
    private ArrayList<GenericObject> roadMapType;
    private ArrayList<TeamMemberObject> teamMemberObjects;
    private LinearLayout teamMembers;
    private RadioGroup selectUnselectRadioGroup;
    private Button upload, browsefile;
    private CheckBox makePublic;
    private RadioButton selectAll, deselectAll;


    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        ((HomeActivity) getActivity()).setOnActivityResultListener(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        final View rootView = inflater.inflate(R.layout.fragment_uploaddoc, container, false);
        filename = (EditText) rootView.findViewById(R.id.filename);
        layout = (LinearLayout) rootView.findViewById(R.id.layout);
        selectRoadMapSpinner = (Spinner) rootView.findViewById(R.id.selectroadmap);
        teamMembers = (LinearLayout) rootView.findViewById(R.id.membercheckboxlayout);
        selectUnselectRadioGroup = (RadioGroup) rootView.findViewById(R.id.radioGroupselection);
        makePublic = (CheckBox) rootView.findViewById(R.id.makePublic);
        selectAll = (RadioButton) rootView.findViewById(R.id.selectall);
        deselectAll = (RadioButton) rootView.findViewById(R.id.deselectall);
        roadMapType = new ArrayList<GenericObject>();
        final float scale = this.getResources().getDisplayMetrics().density;
        makePublic.setPadding(makePublic.getPaddingLeft() + (int) (9.0f * scale + 0.5f),
                makePublic.getPaddingTop(),
                makePublic.getPaddingRight(),
                makePublic.getPaddingBottom());


        selectAll.setPadding(selectAll.getPaddingLeft() + (int) (9.0f * scale + 0.5f),
                selectAll.getPaddingTop(),
                selectAll.getPaddingRight(),
                selectAll.getPaddingBottom());

        deselectAll.setPadding(deselectAll.getPaddingLeft() + (int) (9.0f * scale + 0.5f),
                deselectAll.getPaddingTop(),
                deselectAll.getPaddingRight(),
                deselectAll.getPaddingBottom());


        browsefile = (Button) rootView.findViewById(R.id.browsefile);
        upload = (Button) rootView.findViewById(R.id.upload);
        upload.setOnClickListener(this);
        browsefile.setOnClickListener(this);


        teamMemberObjects = new ArrayList<TeamMemberObject>();

        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_TAG, Constants.STARTUP_TEAM_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID, Constants.HTTP_GET,"Home Activity");
            a.execute();
        } else {

            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }

        selectRoadMapSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                ROADMAP_ID = roadMapType.get(position).getId();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        selectUnselectRadioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                switch (checkedId) {
                    case R.id.selectall:
                        StringBuilder builder = new StringBuilder();
                        for (int i = 0; i < teamMembers.getChildCount(); i++) {
                            if (builder.length() > 0) {
                                builder.append(",");
                            }
                            builder.append(String.valueOf(teamMembers.getChildAt(i).getId()));
                            final AppCompatCheckBox cb = (AppCompatCheckBox) teamMembers.getChildAt(i);
                            cb.setChecked(true);
                        }
                        break;
                    case R.id.deselectall:
                        for (int i = 0; i < teamMembers.getChildCount(); i++) {
                            AppCompatCheckBox cb = (AppCompatCheckBox) teamMembers.getChildAt(i);
                            cb.setChecked(false);
                        }
                        break;
                }
            }
        });


        makePublic.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    IS_PUBLIC = 0;
                } else {
                    IS_PUBLIC = 1;
                }
            }
        });

        return rootView;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.upload:
                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < teamMembers.getChildCount(); i++) {

                    if (String.valueOf(teamMembers.getChildAt(i).getTag()).equalsIgnoreCase("selected")) {
                        if (builder.length() > 0) {
                            builder.append(",");
                        }
                        builder.append(String.valueOf(teamMembers.getChildAt(i).getId()));
                    }
                }

                if (Integer.parseInt(ROADMAP_ID) == 0) {
                    Toast.makeText(getActivity(), "Select Roadmap.", Toast.LENGTH_LONG).show();
                } else if (selectedFile == null) {
                    Toast.makeText(getActivity(), "Select file to be upload.", Toast.LENGTH_LONG).show();
                } else if (filename.getText().toString().trim().isEmpty()) {
                    Toast.makeText(getActivity(), "Please enter file name.", Toast.LENGTH_LONG).show();
                } else {

                    HashMap<String, String> map = new HashMap<String, String>();
                    map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    map.put("startup_id", CurrentStartUpDetailFragment.STARTUP_ID);
                    map.put("roadmap_id", ROADMAP_ID);
                    map.put("public", String.valueOf(IS_PUBLIC));
                    map.put("access", builder.toString());
                    map.put("name", filename.getText().toString().trim());
                    Log.d("map", map.toString());
                    uploadDocument(map, Constants.UPLOAD_DOCS_URL);

                }


                //getActivity().onBackPressed();
                break;
            case R.id.browsefile:
                if ((ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                    requestPermission();
                } else {
                    Intent intent = new Intent(getActivity(), FilePicker.class);
                    String[] acceptedFileExtensions = {".pdf"};

                    intent.putExtra("FILE_EXTENSION", acceptedFileExtensions);
                    getActivity().startActivityForResult(intent, Constants.FILE_PICKER);
                }
        }
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
            if (tag.equalsIgnoreCase(Constants.STARTUP_TEAM_TAG)) {
                //((HomeActivity) getActivity()).dismissProgressDialog();

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        //String startup_id = jsonObject.optString("startup_id");
                        teamMemberObjects.clear();

                        TeamMemberObject entrepreneur = new TeamMemberObject();

                        entrepreneur.setMemberName(jsonObject.optJSONObject("entrepreneur").optString("name").trim());

                        entrepreneur.setMemberBio(jsonObject.optJSONObject("entrepreneur").optString("bio").trim());
                        entrepreneur.setMemberEmail(jsonObject.optJSONObject("entrepreneur").optString("email").trim());
                        entrepreneur.setMemberId(jsonObject.optJSONObject("entrepreneur").optString("id").trim());
                        entrepreneur.setMemberDesignation("Entrepreneur");
                        teamMemberObjects.add(entrepreneur);

                        for (int i = 0; i < jsonObject.optJSONArray("team_member").length(); i++) {

                            JSONObject team_memberOBJ = jsonObject.optJSONArray("team_member").getJSONObject(i);


                            TeamMemberObject obj = new TeamMemberObject();
                            obj.setMemberId(team_memberOBJ.optString("team_memberid").trim());
                            obj.setMemberName(team_memberOBJ.optString("member_name").trim());
                            obj.setMemberDesignation(team_memberOBJ.optString("member_role").trim());
                            obj.setMemberBio(team_memberOBJ.optString("member_bio").trim());
                            obj.setMemberEmail(team_memberOBJ.optString("member_email").trim());
                            if (team_memberOBJ.optString("member_status").trim().length() == 0) {
                                obj.setMemberStatus(1);
                            } else {
                                obj.setMemberStatus(Integer.parseInt(team_memberOBJ.optString("member_status").trim()));
                            }

                            teamMemberObjects.add(obj);
                        }

                    }

                    for (int i = 0; i < teamMemberObjects.size(); i++) {
                        //TableRow row = new TableRow(getActivity());
                        //row.setId(i);
                        //row.setLayoutParams(new RadioGroup.LayoutParams(RadioGroup.LayoutParams.FILL_PARENT, RadioGroup.LayoutParams.WRAP_CONTENT));
                        //final CheckBox checkBox = new CheckBox(getActivity());
                        final AppCompatCheckBox checkBox = new AppCompatCheckBox(new ContextThemeWrapper(getActivity(), R.style.CheckBoxcheckbox));

                        checkBox.setTextSize(12);


                        // final CheckBox checkBox = new CheckBox(getActivity(), R.style.CheckBoxcheckbox);
                                 /*   checkBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                                        @Override
                                        public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                                            if (selectAll == true) {
                                                checkBox.setSelected(true);
                                            } else if (selectAll == false) {
                                                checkBox.setSelected(false);
                                            }
                                        }
                                    });*/
                        checkBox.setId(Integer.parseInt(teamMemberObjects.get(i).getMemberId()));

                        checkBox.setText(teamMemberObjects.get(i).getMemberName());

                        checkBox.setTag("notseected");
                        checkBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                            @Override
                            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                                if (isChecked) {
                                    checkBox.setTag("selected");
                                    deselectAll.setChecked(false);
                                } else {
                                    checkBox.setTag("notseected");
                                }
                            }
                        });
                        // row.addView(checkBox);
                        teamMembers.addView(checkBox);
                    }


                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ALL_DELIVERABLES_TAG, Constants.ALL_DELIVERABLES_URL, Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    } else {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }


                } catch (JSONException e) {

                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.ALL_DELIVERABLES_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);
                    roadMapType.clear();
                    GenericObject object = new GenericObject();
                    object.setId("0");
                    object.setTitle("Select Roadmap");
                    roadMapType.add(object);


                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        //String startup_id = jsonObject.optString("startup_id");


                        for (int i = 0; i < jsonObject.optJSONArray("Deliverables").length(); i++) {
                            GenericObject deliverableObj = new GenericObject();
                            deliverableObj.setId(jsonObject.optJSONArray("Deliverables").getJSONObject(i).optString("id"));
                            deliverableObj.setTitle(jsonObject.optJSONArray("Deliverables").getJSONObject(i).optString("name"));
                            roadMapType.add(deliverableObj);
                        }
                    }
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                    }

                    deliverableAdapter = new SpinnerAdapter(getActivity(), 0, roadMapType);

                    selectRoadMapSpinner.setAdapter(deliverableAdapter);

                } catch (JSONException e) {


                    e.printStackTrace();
                }
            }
        }
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        // TODO Auto-generated method stub
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {

            switch (requestCode) {

                case Constants.FILE_PICKER:

                    if (data.hasExtra(FilePicker.EXTRA_FILE_PATH)) {

                        selectedFile = new File(data.getStringExtra(FilePicker.EXTRA_FILE_PATH));
                        System.out.println(selectedFile.getPath() + " selectedFile.getPath()");

                        fileType = data.getStringExtra(FilePicker.EXTRA_FILE_TYPE);
                        System.out.println(fileType + " filetype");
                        // CALL THIS METHOD TO GET THE ACTUAL PATH

                        long length = selectedFile.length();
                        int a = selectedFile.getAbsolutePath().lastIndexOf("/");
                        if (length >= Constants.MAX_FILE_LENGTH_ALLOWED) {
                            Toast.makeText(getActivity(), selectedFile.getAbsolutePath().substring(a + 1).toString().trim() + " size is more than 5 MB.", Toast.LENGTH_LONG).show();
                        }
                    }
                    break;
            }
        }
    }

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

    long totalSize = 0;

    public void uploadDocument(final HashMap<String, String> map, final String uploadUrl) {
        new AsyncTask<Integer, Integer, String>() {

            ProgressDialog pDialog;

            @Override
            protected void onPreExecute() {
                // TODO Auto-generated method stub
                super.onPreExecute();

                pDialog = new ProgressDialog(getActivity());
                pDialog.setMessage("Uploading Document Please wait...");
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
                String url = Constants.APP_BASE_URL + uploadUrl;
                HttpPost httppost = new HttpPost(url);
                HttpContext localContext = new BasicHttpContext();

                FileBody fileBody = new FileBody(selectedFile);
                try {

                    AndroidMultipartEntity entity = new AndroidMultipartEntity(
                            new AndroidMultipartEntity.ProgressListener() {

                                @Override
                                public void transferred(long num) {
                                    publishProgress((int) ((num / (float) totalSize) * 100));
                                }
                            });

                    for (String key : map.keySet()) {
                        entity.addPart(key, new StringBody(map.get(key), "text/plain", Charset.forName("UTF-8")));
                    }

                    entity.addPart("file_path", fileBody);


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

                        Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                        getActivity().onBackPressed();
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        if (!jsonObject.optJSONObject("errors").optString("file_path").isEmpty()) {
                            Toast.makeText(getActivity(), jsonObject.optJSONObject("errors").optString("file_path"), Toast.LENGTH_LONG).show();
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }.execute();

    }

}
