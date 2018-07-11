package com.staging.fragments;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
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
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.helper.CircleImageView;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.listeners.onActivityResultListener;
import com.staging.logger.CrowdBootstrapLogger;
import com.staging.utilities.AndroidMultipartEntity;
import com.staging.utilities.AsyncNew;
import com.staging.utilities.Constants;
import com.staging.utilities.NetworkConnectivity;
import com.staging.utilities.PrefManager;
import com.staging.utilities.UtilitiesClass;

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
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

/**
 * Created by Sunakshi.Gautam on 11/21/2017.
 */

public class AddBusinessCardFragment extends Fragment implements onActivityResultListener, AsyncTaskCompleteListener<String> {

    private CircleImageView userImage;
    private ImageView businessCardImage;
    private EditText username, userBio, userInterest,userStatement;
    private Button addImage, saveBusinessCard;
    public NetworkConnectivity networkConnectivity;
    public UtilitiesClass utilitiesClass;
    public DisplayImageOptions options;
    private Bitmap bitmap;
    public static String filepath;
    private Uri fileUri;
    private RelativeLayout parent_layout;
    private LinearLayout layout;
    public static String fileName;

    public AddBusinessCardFragment(){

    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle("Add Business Card");
        ((HomeActivity) getActivity()).setOnActivityResultListener(this);
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_businesscard_details, container, false);

        userImage = (CircleImageView) rootView.findViewById(R.id.profileimage);
        businessCardImage =  (ImageView) rootView.findViewById(R.id.businesscard_imageView);
        username =  (EditText) rootView.findViewById(R.id.usernameLogedin);
        userBio =  (EditText) rootView.findViewById(R.id.et_usersbio);
        userInterest =  (EditText) rootView.findViewById(R.id.et_usersinterest);
        userStatement = (EditText) rootView.findViewById(R.id.et_usersstatement);
        addImage = (Button) rootView.findViewById(R.id.btn_addBusinessCardImage);
        saveBusinessCard =  (Button) rootView.findViewById(R.id.btn_save);
        parent_layout = (RelativeLayout) rootView.findViewById(R.id.parent_layout);
        layout = (LinearLayout) rootView.findViewById(R.id.layout);



        options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.image)
                .showImageForEmptyUri(R.drawable.image)
                .showImageOnFail(R.drawable.image)
                .cacheInMemory(true)
                .cacheOnDisk(true)
                .considerExifParams(true)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();

        username.setText(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_FIRST_NAME) + " " + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_LAST_NAME));

        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_PROFILE_IMAGE_URL), userImage, options);


        addImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                alertDialogForPicture();
            }
        });


        saveBusinessCard.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                HashMap<String, String> map = new HashMap<String, String>();
                map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                map.put("user_bio", userBio.getText().toString().trim());
                map.put("user_interest", userInterest.getText().toString().trim());
                map.put("linkedin_image", "");
                map.put("linkedin_username", "");
                map.put("statement",userStatement.getText().toString().trim());
                map.put("status", "0");


                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    create(map, Constants.CREATE_BUSINESS_CARD_URL);
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }

                CrowdBootstrapLogger.logInfo("map" + map.toString());
            }
        });



        return rootView;
    }




    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    long totalSize = 0;

    private void create(final HashMap<String, String> map, final String createBusinessCardUrl) {

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

                    try {
                        /*ArrayList<File> files = new ArrayList<File>();
                        ArrayList<FileBody> bin = new ArrayList<FileBody>();
                        for (int i = 0; i < pathofmedia.size(); i++) {
                            files.add(new File(pathofmedia.get(i).getPath()));
                        }*/

                        /*for (int i = 0; i < files.size(); i++) {
                            bin.add(new FileBody(files.get(i)));
                        }*/



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

                        } else {
                            for (String key : map.keySet()) {
                                entity.addPart(key, new StringBody(map.get(key), "text/plain", Charset.forName("UTF-8")));
                                //entity.addPart(key, new StringBody(map.get(key), "text/plain", Charset.forName("UTF-8")));
                            }
                        }

                        try {
                            return multipost(createBusinessCardUrl, entity);
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

                                    Toast.makeText(getActivity(), "Your business card is created successfully.", Toast.LENGTH_LONG).show();
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






    private void alertDialogForPicture() {
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


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        // TODO Auto-generated method stub
        super.onActivityResult(requestCode, resultCode, data);
        try {

            if (resultCode == Activity.RESULT_OK) {

                switch (requestCode) {

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
                businessCardImage.setImageBitmap(bitmap);


            } catch (Exception e) {
                e.printStackTrace();
                //businessCardImage.setImageResource(R.drawable.app_icon);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
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

    @Override
    public void onTaskComplete(String result, String tag) {

    }
}
