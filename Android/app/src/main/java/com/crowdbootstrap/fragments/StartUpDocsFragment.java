package com.crowdbootstrap.fragments;

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
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.Spinner;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.filebrowser.FilePicker;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.listeners.onActivityResultListener;
import com.crowdbootstrap.models.RoadmapDeliverables;
import com.crowdbootstrap.utilities.AndroidMultipartEntity;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;

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
import java.util.List;

/**
 * Created by sunakshi.gautam on 1/21/2016.
 */
public class StartUpDocsFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String>, onActivityResultListener {

    private Spinner spinnerCurrentRoadmap, spinnerNextStep;
    private Button btnSubmitApplication, btnUploadStartupProfile, btnUpdate;
    private RadioButton rBtnYes, rBtnNo;
    private EditText previosRoadmap, fileDoc;
    private LinearLayout layout;

    private List<RoadmapDeliverables> allRoadmapDeliverables;
    private List<RoadmapDeliverables> completedRoadmapDeliverables;
    private ArrayList<String> currentRoadmapType, nextRoadmapType;


    @Override
    public void onResume() {
        super.onResume();

        ((HomeActivity) getActivity()).setOnActivityResultListener(this);
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            // we check that the fragment is becoming visible

            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ALL_DELIVERABLES_TAG, Constants.ALL_DELIVERABLES_URL, Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {

                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }

        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_startupdocs, container, false);


        allRoadmapDeliverables = new ArrayList<RoadmapDeliverables>();
        completedRoadmapDeliverables = new ArrayList<RoadmapDeliverables>();
        currentRoadmapType = new ArrayList<String>();
        nextRoadmapType = new ArrayList<String>();

        layout = (LinearLayout) rootView.findViewById(R.id.layout);
        spinnerCurrentRoadmap = (Spinner) rootView.findViewById(R.id.spinner_currentroadmap);
        previosRoadmap = (EditText) rootView.findViewById(R.id.previousroadmap);
        spinnerNextStep = (Spinner) rootView.findViewById(R.id.spinner_nextstep);
        btnSubmitApplication = (Button) rootView.findViewById(R.id.submitapplication);
        btnUploadStartupProfile = (Button) rootView.findViewById(R.id.uploadstartupprofile);
        btnUpdate = (Button) rootView.findViewById(R.id.uploadstartupdoc);
        rBtnYes = (RadioButton) rootView.findViewById(R.id.yes);
        rBtnNo = (RadioButton) rootView.findViewById(R.id.no);
        fileDoc = (EditText) rootView.findViewById(R.id.filename);

        final float scale = this.getResources().getDisplayMetrics().density;
        rBtnYes.setPadding(rBtnYes.getPaddingLeft() + (int) (9.0f * scale + 0.5f),
                rBtnYes.getPaddingTop(),
                rBtnYes.getPaddingRight(),
                rBtnYes.getPaddingBottom());


        rBtnNo.setPadding(rBtnNo.getPaddingLeft() + (int) (9.0f * scale + 0.5f),
                rBtnNo.getPaddingTop(),
                rBtnNo.getPaddingRight(),
                rBtnNo.getPaddingBottom());


        fileDoc.setOnClickListener(this);
        btnUpdate.setOnClickListener(this);
        btnUploadStartupProfile.setOnClickListener(this);
        btnSubmitApplication.setOnClickListener(this);

        return rootView;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.uploadstartupdoc:
                int completed = 0;
                if (rBtnYes.isChecked()) {
                    completed = 1;
                } else {
                    completed = 0;
                }

                if (selectedFile == null) {
                    Toast.makeText(getActivity(), "Select file to be upload.", Toast.LENGTH_LONG).show();
                } else {
                    HashMap<String, String> map = new HashMap<String, String>();
                    map.put("startup_id", CurrentStartUpDetailFragment.STARTUP_ID);
                    map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    map.put("preffered_startup_stage", previosRoadmap.getText().toString());
                    map.put("current_roadmap", allRoadmapDeliverables.get(spinnerCurrentRoadmap.getSelectedItemPosition()).getId());
                    map.put("complete", String.valueOf(completed));
                    map.put("next_step", spinnerNextStep.getSelectedItem().toString());
                    Log.e("map", map.toString());
                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        uploadDocument(map, Constants.UPLOAD_ROADMAP_DOCS_URL);
                    } else {
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }

                break;
            case R.id.filename:

                if ((ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                    requestPermission();
                } else {
                    Intent intent = new Intent(getActivity(), FilePicker.class);
                    String[] acceptedFileExtensions = {".pdf"};

                    intent.putExtra("FILE_EXTENSION", acceptedFileExtensions);
                    getActivity().startActivityForResult(intent, Constants.FILE_PICKER);
                }

                break;
            case R.id.submitapplication:

                Fragment SubmitApplication = new SubmitApplicationFragment();
                Bundle argsApplication = new Bundle();
                argsApplication.putString("id", CurrentStartUpDetailFragment.STARTUP_ID);
                SubmitApplication.setArguments(argsApplication);
                ((HomeActivity) getActivity()).replaceFragment(SubmitApplication);
                /*FragmentTransaction transactionApplication = getParentFragment().getFragmentManager().beginTransaction();

                transactionApplication.replace(R.id.container, SubmitApplication);
                transactionApplication.addToBackStack(null);

                transactionApplication.commit();*/
                break;

            case R.id.uploadstartupprofile:


                Fragment uploadStartupProfile = new UploadStartupProfileFragment();

                Bundle args = new Bundle();
                args.putString("id", CurrentStartUpDetailFragment.STARTUP_ID);
                args.putString("startupname", CurrentStartUpDetailFragment.titleSTartup);
                uploadStartupProfile.setArguments(args);
                ((HomeActivity) getActivity()).replaceFragment(uploadStartupProfile);
                /*FragmentTransaction transactionProfile = getParentFragment().getFragmentManager().beginTransaction();

                transactionProfile.replace(R.id.container, uploadStartupProfile);
                transactionProfile.addToBackStack(null);

                transactionProfile.commit();*/
                break;

        }
    }

    private File selectedFile;
    private String fileType;

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
                        fileDoc.setText(selectedFile.getAbsolutePath().substring(a + 1).toString().trim());
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

    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            if (tag.equalsIgnoreCase(Constants.ALL_DELIVERABLES_TAG)) {
                JSONObject jsonObject_AllDeliverables = null;
                try {
                    jsonObject_AllDeliverables = new JSONObject(result);

                    if (jsonObject_AllDeliverables.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        for (int i = 0; i < jsonObject_AllDeliverables.optJSONArray("Deliverables").length(); i++) {

                            JSONObject roadmapOBJ = jsonObject_AllDeliverables.optJSONArray("Deliverables").getJSONObject(i);

                            RoadmapDeliverables obj = new RoadmapDeliverables();
                            obj.setRoadmapName(roadmapOBJ.optString("name").trim());
                            obj.setId(roadmapOBJ.optString("id").trim());

                            allRoadmapDeliverables.add(obj);

                        }


                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.COMPLETED_DELIVERABLES_TAG, Constants.COMPLETED_DELIVERABLES_URL + "?startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID, Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }

            } else if (tag.equalsIgnoreCase(Constants.COMPLETED_DELIVERABLES_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        if (jsonObject.has("CompletedRoadmaps")) {
                            for (int i = 0; i < jsonObject.optJSONArray("CompletedRoadmaps").length(); i++) {

                                JSONObject roadmapOBJ = jsonObject.optJSONArray("CompletedRoadmaps").getJSONObject(i);

                                RoadmapDeliverables obj = new RoadmapDeliverables();
                                obj.setRoadmapName(roadmapOBJ.optString("roadmap_name").trim());
                                obj.setId(roadmapOBJ.optString("roadmap_id").trim());

                                completedRoadmapDeliverables.add(obj);

                            }
                        }
                    }

//                    Log.e("XXX", "ALLROADMAP" + String.valueOf(allRoadmapDeliverables.size()));
//                    Log.e("XXX", "CoMPLETEROADMAP" + String.valueOf(completedRoadmapDeliverables.size()));

                    //allRoadmapDeliverables.removeAll(completedRoadmapDeliverables);

                    for (int i = 0; i < allRoadmapDeliverables.size(); i++) {
                        for (int j = 0; j < completedRoadmapDeliverables.size(); j++) {
                            if (allRoadmapDeliverables.get(i).getId().equals(completedRoadmapDeliverables.get(j).getId())) {
                                allRoadmapDeliverables.remove(i);
                            } else {
                            }
                        }
                    }
                    //Log.e("XXX", "ALLROADMAPAFTER REMOVAL" + String.valueOf(allRoadmapDeliverables.size()));

                    if (allRoadmapDeliverables.size() > 0) {
                        previosRoadmap.setText(allRoadmapDeliverables.get(0).getRoadmapName());

                        for (int i = 0; i < allRoadmapDeliverables.size(); i++) {
                            currentRoadmapType.add(allRoadmapDeliverables.get(i).getRoadmapName());

                        }


                        ArrayAdapter<String> currentTypeAdapter = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_spinner_item, currentRoadmapType);
                        currentTypeAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
                        spinnerCurrentRoadmap.setAdapter(currentTypeAdapter);

                        if (allRoadmapDeliverables.size() > 1) {

                            for (int i = 1; i < allRoadmapDeliverables.size(); i++) {
                                nextRoadmapType.add(allRoadmapDeliverables.get(i).getRoadmapName());

                            }
                            ArrayAdapter<String> nextTypeAdapter = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_spinner_item, nextRoadmapType);
                            nextTypeAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
                            spinnerNextStep.setAdapter(nextTypeAdapter);
                        }
                    } else {
                        Toast.makeText(getActivity(), getString(R.string.all_roadmap_complete), Toast.LENGTH_LONG).show();
                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
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
                        // getActivity().onBackPressed();
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }.execute();
    }
}
