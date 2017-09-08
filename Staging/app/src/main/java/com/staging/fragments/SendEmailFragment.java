package com.staging.fragments;

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
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.filebrowser.FilePicker;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.listeners.onActivityResultListener;
import com.staging.utilities.AndroidMultipartEntity;
import com.staging.utilities.Constants;

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
import java.util.HashMap;

/**
 * Created by neelmani.karn on 2/9/2016.
 */
public class SendEmailFragment extends Fragment implements onActivityResultListener, AsyncTaskCompleteListener<String> {
    private LinearLayout fileAttachment, layout;
    private TextView tv_fileName;
    private File selectedFile;
    private String fileType;
    private Button btn_send;
    private EditText et_recipient_to, et_recipient_cc, et_recipient_bcc, et_subject, et_message;

    public SendEmailFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();

        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        ((HomeActivity) getActivity()).setOnActivityResultListener(this);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_send_email, container, false);
        try {
            layout = (LinearLayout) rootView.findViewById(R.id.layout);
            et_message = (EditText) rootView.findViewById(R.id.et_message);
            et_recipient_to = (EditText) rootView.findViewById(R.id.et_recipient_to);
            et_recipient_cc = (EditText) rootView.findViewById(R.id.et_recipient_cc);
            et_recipient_bcc = (EditText) rootView.findViewById(R.id.et_recipient_bcc);
            et_subject = (EditText) rootView.findViewById(R.id.et_subject);

            et_recipient_to.setText(getArguments().getString("receiverMailId"));

            btn_send = (Button) rootView.findViewById(R.id.btn_send);
            fileAttachment = (LinearLayout) rootView.findViewById(R.id.fileAttachment);

            tv_fileName = (TextView) rootView.findViewById(R.id.tv_fileName);
            btn_send.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    HashMap<String, String> map = new HashMap<String, String>();
                    map.put("to", et_recipient_to.getText().toString().trim());
                    map.put("cc", et_recipient_cc.getText().toString().trim());
                    map.put("bcc", et_recipient_bcc.getText().toString().trim());
                    map.put("subject", et_subject.getText().toString().trim());
                    map.put("message", et_message.getText().toString().trim());
                    map.put("sender", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_EMAIL));
                    Log.e("map", map.toString());
                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        sendMail(map, Constants.UPLOAD_ROADMAP_DOCS_URL);
                    } else {
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            });


            fileAttachment.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if ((ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                        requestPermission();
                    } else {

                        Intent intent = new Intent(getActivity(), FilePicker.class);
                        String[] acceptedFileExtensions = {".doc", ".docx", ".pdf", ".xls", ".ppt", ".png", ".jpg", ".jpeg"};

                        intent.putExtra("FILE_EXTENSION", acceptedFileExtensions);
                        getActivity().startActivityForResult(intent, Constants.FILE_PICKER);
                    }

                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootView;
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
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            switch (requestCode) {
                case Constants.FILE_PICKER:
                    //String FilePath = data.getData().getPath();
                    //textFile.setText(FilePath);
                    /*selectedFile = new File(data.getData().getPath());
                    int a = selectedFile.getAbsolutePath().lastIndexOf("/");
                    if (selectedFile.length() >= Constants.MAX_FILE_LENGTH_ALLOWED) {
                        Toast.makeText(getActivity(), selectedFile.getAbsolutePath().substring(a + 1).toString().trim() + " size is more than 5 MB.", Toast.LENGTH_LONG).show();
                    } else {
                        tv_fileName.setText(selectedFile.getAbsolutePath().substring(a + 1).toString().trim());
                    }*/
                    if (data.hasExtra(FilePicker.EXTRA_FILE_PATH)) {

                        selectedFile = new File(data.getStringExtra(FilePicker.EXTRA_FILE_PATH));
                        System.out.println(selectedFile.getPath() + " selectedFile.getPath()");

                        fileType = data.getStringExtra(FilePicker.EXTRA_FILE_TYPE);
                        System.out.println(fileType + " filetype");
                        // CALL THIS METHOD TO GET THE ACTUAL PATH

                        int a = selectedFile.getAbsolutePath().lastIndexOf("/");
                        if (selectedFile.length() >= Constants.MAX_FILE_LENGTH_ALLOWED) {
                            Toast.makeText(getActivity(), selectedFile.getAbsolutePath().substring(a + 1).toString().trim() + " size is more than 5 MB.", Toast.LENGTH_LONG).show();
                        } else {
                            tv_fileName.setText(selectedFile.getAbsolutePath().substring(a + 1).toString().trim());
                        }
                    }
                    break;
                default:
            }
        }

    }

    long totalSize = 0;

    private void sendMail(final HashMap<String, String> map, final String editUrl) {

        try {
            new AsyncTask<Integer, Integer, String>() {

                ProgressDialog pDialog;

                @Override
                protected void onPreExecute() {
                    super.onPreExecute();
                    pDialog = new ProgressDialog(getActivity());
                    pDialog.setMessage("Sending mail Please wait...");
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
                            Toast.makeText(getActivity(), "Mail sent.", Toast.LENGTH_LONG).show();
                            getActivity().onBackPressed();
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            if (jsonObject.getJSONObject("errors").has("description")) {
                                Toast.makeText(getActivity(), jsonObject.getJSONObject("errors").optString("description"), Toast.LENGTH_LONG).show();
                            }
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
}