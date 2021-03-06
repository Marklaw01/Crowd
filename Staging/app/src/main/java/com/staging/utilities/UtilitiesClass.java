package com.staging.utilities;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DownloadManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.database.Cursor;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.provider.Settings;
import android.support.annotation.ColorInt;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Base64;
import android.util.Base64OutputStream;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.exception.CrowdException;
import com.staging.logger.CrowdBootstrapLogger;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpVersion;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;
import org.apache.http.protocol.HTTP;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.UnknownHostException;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

/**
 * Created by neelmani.karn on 2/19/2016.
 */
public class UtilitiesClass {

    private static HttpGet httpGet;
    static Context context;
    private static UtilitiesClass instance = new UtilitiesClass();

    public static UtilitiesClass getInstance(Context ctx) {
        context = ctx;
        httpGet = new HttpGet();
        return instance;
    }

    /**
     * Check that device is supported by camera or not.
     */
    public boolean isDeviceSupportCamera() {
        if (context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA)) {
            // this device has a camera
            return true;
        } else {
            // no camera on this device
            return false;
        }
    }

    public static final int MY_PERMISSIONS_REQUEST_READ_EXTERNAL_STORAGE = 123;

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    public static boolean checkPermission(final Context context)
    {
        int currentAPIVersion = Build.VERSION.SDK_INT;
        if(currentAPIVersion>=android.os.Build.VERSION_CODES.M)
        {
            if (ContextCompat.checkSelfPermission(context, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                if (ActivityCompat.shouldShowRequestPermissionRationale((Activity) context, Manifest.permission.READ_EXTERNAL_STORAGE)) {
                    AlertDialog.Builder alertBuilder = new AlertDialog.Builder(context, R.style.MyDialogTheme);
                    alertBuilder.setCancelable(true);
                    alertBuilder.setTitle("Permission necessary");
                    alertBuilder.setMessage("External storage permission is necessary");
                    alertBuilder.setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
                        @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
                        public void onClick(DialogInterface dialog, int which) {
                            ActivityCompat.requestPermissions((Activity) context, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, MY_PERMISSIONS_REQUEST_READ_EXTERNAL_STORAGE);
                        }
                    });
                    AlertDialog alert = alertBuilder.create();
                    alert.show();

                } else {
                    ActivityCompat.requestPermissions((Activity) context, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, MY_PERMISSIONS_REQUEST_READ_EXTERNAL_STORAGE);
                }
                return false;
            } else {
                return true;
            }
        } else {
            return true;
        }
    }


    public static String getStringFile(File f) {
        InputStream inputStream = null;
        String encodedFile= "", lastVal;
        try {
            inputStream = new FileInputStream(f.getAbsolutePath());

            byte[] buffer = new byte[10240];//specify the size to allow
            int bytesRead;
            ByteArrayOutputStream output = new ByteArrayOutputStream();
            Base64OutputStream output64 = new Base64OutputStream(output, Base64.DEFAULT);

            while ((bytesRead = inputStream.read(buffer)) != -1) {
                output64.write(buffer, 0, bytesRead);
            }
            output64.close();
            encodedFile =  output.toString();
        }
        catch (FileNotFoundException e1 ) {
            e1.printStackTrace();
        }
        catch (IOException e) {
            e.printStackTrace();
        }
        lastVal = encodedFile;
        return lastVal;
    }


    public static String getRealPathFromURI(final Context context, final Uri uri) {

        final boolean isKitKat = Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT;
        Log.i("URI", uri + "");
        String result = uri + "";
        // DocumentProvider
        //  if (isKitKat && DocumentsContract.isDocumentUri(context, uri)) {
        if (isKitKat && (result.contains("media.documents"))) {
            String[] ary = result.split("/");
            int length = ary.length;
            String imgary = ary[length - 1];
            final String[] dat = imgary.split("%3A");
            final String docId = dat[1];
            final String type = dat[0];
            Uri contentUri = null;
            if ("image".equals(type)) {
                contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
            } else if ("video".equals(type)) {
                contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
            } else if ("audio".equals(type)) {
                contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
            }
            final String selection = "_id=?";
            final String[] selectionArgs = new String[]{
                    dat[1]
            };
            return getDataColumn(context, contentUri, selection, selectionArgs);
        } else if ("content".equalsIgnoreCase(uri.getScheme())) {
            return getDataColumn(context, uri, null, null);
        }
        // File
        else if ("file".equalsIgnoreCase(uri.getScheme())) {
            return uri.getPath();
        }
        return null;
    }



    public static String getDataColumn(Context context, Uri uri, String selection, String[] selectionArgs) {
        Cursor cursor = null;
        final String column = "_data";
        final String[] projection = {
                column
        };
        try {
            cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs, null);
            if (cursor != null && cursor.moveToFirst()) {
                final int column_index = cursor.getColumnIndexOrThrow(column);
                return cursor.getString(column_index);
            }
        } finally {
            if (cursor != null)
                cursor.close();
        }
        return null;
    }


    public void showSettingsAlert() {


        AlertDialog.Builder alertDialog = new AlertDialog.Builder(context, R.style.MyDialogTheme);

        // Setting Dialog Title
        alertDialog.setTitle("Network settings");

        // Setting Dialog Message
        alertDialog.setMessage("Network is not enabled. Do you want to go to settings menu?");

        // On pressing Settings button
        alertDialog.setPositiveButton("Settings", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                Intent intent = new Intent(Settings.ACTION_SETTINGS);
                context.startActivity(intent);
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.cancel();
            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }

    /**
     * gives the version of an app
     */
    /*public float getAppVersion() {
        try {
            PackageInfo packageInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
            return Float.parseFloat(packageInfo.versionName);
        } catch (PackageManager.NameNotFoundException e) {
            throw new RuntimeException("Could not get package name: " + e);
        }
    }*/
    public HttpClient createHttpClient() {
        try {
            KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());
            trustStore.load(null, null);

            SSLSocketFactory sf = new MySSLSocketFactory(trustStore);
            sf.setHostnameVerifier(SSLSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);

            HttpParams params = new BasicHttpParams();
            HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);
            HttpProtocolParams.setContentCharset(params, HTTP.UTF_8);

            SchemeRegistry registry = new SchemeRegistry();
            registry.register(new Scheme("http", PlainSocketFactory.getSocketFactory(), 80));
            registry.register(new Scheme("https", sf, 443));

            ClientConnectionManager ccm = new ThreadSafeClientConnManager(params, registry);

            return new DefaultHttpClient(ccm, params);
        } catch (Exception e) {
            return new DefaultHttpClient();
        }
    }

    static class MySSLSocketFactory extends SSLSocketFactory {
        SSLContext sslContext = SSLContext.getInstance("TLS");

        public MySSLSocketFactory(KeyStore truststore) throws NoSuchAlgorithmException, KeyManagementException, KeyStoreException, UnrecoverableKeyException {
            super(truststore);

            TrustManager tm = new X509TrustManager() {
                public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {
                }

                public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {
                }

                public X509Certificate[] getAcceptedIssuers() {
                    return null;
                }
            };

            sslContext.init(null, new TrustManager[]{tm}, null);
        }

        @Override
        public Socket createSocket(Socket socket, String host, int port, boolean autoClose) throws IOException, UnknownHostException {
            return sslContext.getSocketFactory().createSocket(socket, host, port, autoClose);
        }

        @Override
        public Socket createSocket() throws IOException {
            return sslContext.getSocketFactory().createSocket();
        }
    }

    public String postJsonObject(String url, JSONObject loginJobj) throws UnknownHostException/*throws SQWIPExceptionClass*/ {
        InputStream inputStream = null;
        String result = "";

        try {
            HttpClient httpclient = createHttpClient();
            HttpPost httpPost = new HttpPost(Constants.APP_BASE_URL + url);

            System.out.println(Constants.APP_BASE_URL + url);
            String json = "";
            json = loginJobj.toString();
            System.out.println(json);
            StringEntity se = new StringEntity(json, "UTF-8");
            httpPost.setEntity(se);
            httpPost.setHeader("Accept", "application/json");
            httpPost.setHeader("Content-type", "application/json");
            HttpResponse httpResponse = httpclient.execute(httpPost);
            StatusLine statusLine = httpResponse.getStatusLine();
            int statusCode = statusLine.getStatusCode();
            System.out.println("Status Code: " + statusCode);
            if (statusCode == HttpURLConnection.HTTP_OK) {
                inputStream = httpResponse.getEntity().getContent();
                if (inputStream != null)
                    result = convertInputStreamToString(inputStream);
                else
                    result = "Did not work!";
            } else if (statusCode == HttpURLConnection.HTTP_NOT_FOUND) {
                //throw new SQWIPExceptionClass(context, "Data communication error.\nPlease try later.");
            } else if (statusCode == HttpURLConnection.HTTP_INTERNAL_ERROR) {
                //throw new SQWIPExceptionClass(context,"Data communication error.\nPlease try later.");
            } else if (statusCode == HttpURLConnection.HTTP_BAD_REQUEST) {
                //throw new SQWIPExceptionClass(context,"Data communication error.\nPlease try later.");
            } else if (statusCode == HttpURLConnection.HTTP_BAD_METHOD) {
                //throw new SQWIPExceptionClass(context,"Data communication error.\nPlease try later.");
            } else if (statusCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                // throw new SQWIPExceptionClass(context,"Your account has been suspended or temporarily unavailable.\nPlease contact SQWIP admin.");
            } else if (statusCode == HttpURLConnection.HTTP_FORBIDDEN) {
                // throw new SQWIPExceptionClass(context,"Your account has been suspended or temporarily unavailable.\nPlease contact SQWIP admin.");
            } else if (statusCode == HttpURLConnection.HTTP_UNAVAILABLE) {
                // throw new SQWIPExceptionClass(context,"Your Internet Connection seems to be slow.\nPlease try later.");
            } else if (statusCode == HttpURLConnection.HTTP_REQ_TOO_LONG) {
                // throw new SQWIPExceptionClass(context,"You are logged in to a different device. To continue from this device please login again.");

            }
        } catch (UnknownHostException e) {
            e.printStackTrace();
            throw e;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private String convertInputStreamToString(InputStream inputStream) throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
        String line = "";
        String result = "";
        while ((line = bufferedReader.readLine()) != null)
            result += line;

        inputStream.close();
        return result;
    }

    public String getJSON(String url) /*throws SQWIPExceptionClass*/ {
        StringBuilder builder = new StringBuilder();
        HttpClient client = createHttpClient();
        try {
            //String url = Constants.APP_BASE_URL + rurl;
            //System.out.println(url);
            httpGet = new HttpGet(Constants.APP_BASE_URL + url);
            System.out.println(Constants.APP_BASE_URL + url);
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {

           /* HttpParams httpParameters = httpGet.getParams();
            // Set the timeout in milliseconds until a connection is established.
            // The default value is zero, that means the timeout is not used.
            int timeoutConnection = 1000;

            setConnectionTimeout(httpParameters, timeoutConnection);
            // Set the default socket timeout (SO_TIMEOUT)
            // in milliseconds which is the timeout for waiting for data.
            int timeoutSocket = 2000;
            setSoTimeout(httpParameters, timeoutSocket);*/

            HttpResponse response = client.execute(httpGet);
            response.setHeader("Cache-Control", "no-store");
            StatusLine statusLine = response.getStatusLine();
            int statusCode = statusLine.getStatusCode();

            if (statusCode == HttpURLConnection.HTTP_OK) {

                HttpEntity entity = response.getEntity();
                InputStream content = entity.getContent();
                BufferedReader reader = new BufferedReader(new InputStreamReader(content));
                String line;
                while ((line = reader.readLine()) != null) {
                    builder.append(line);
                }
            } else if (statusCode == HttpURLConnection.HTTP_NOT_FOUND) {
                //throw new SQWIPExceptionClass(context, "Data communication error.\nPlease try later.");
            } else if (statusCode == HttpURLConnection.HTTP_INTERNAL_ERROR) {
                //throw new SQWIPExceptionClass(context,"Data communication error.\nPlease try later.");
            } else if (statusCode == HttpURLConnection.HTTP_BAD_REQUEST) {
                //throw new SQWIPExceptionClass(context,"Data communication error.\nPlease try later.");
            } else if (statusCode == HttpURLConnection.HTTP_BAD_METHOD) {
                //throw new SQWIPExceptionClass(context,"Data communication error.\nPlease try later.");
            } else if (statusCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                //throw new SQWIPExceptionClass(context,"Your account has been suspended or temporarily unavailable.\nPlease contact SQWIP admin.");
            } else if (statusCode == HttpURLConnection.HTTP_FORBIDDEN) {
                //throw new SQWIPExceptionClass(context,"Your account has been suspended or temporarily unavailable.\nPlease contact SQWIP admin.");
            } else if (statusCode == HttpURLConnection.HTTP_UNAVAILABLE) {
                //throw new SQWIPExceptionClass(context,"Your Internet Connection seems to be slow.\nPlease try later.");
            } else if (statusCode == HttpURLConnection.HTTP_REQ_TOO_LONG) {
                //throw new SQWIPExceptionClass(context,"You are logged in to a different device. To continue from this device please login again.");
            }

        } catch (ClientProtocolException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return builder.toString();
    }

    public String postApiRequest(String url) throws UnknownHostException {
        InputStream inputStream = null;
        String result = "";
        // Making HTTP request
        try {
            // defaultHttpClient
            HttpClient httpClient = createHttpClient();
            HttpPost httpPost = new HttpPost(Constants.APP_BASE_URL + url);
            System.out.println(Constants.APP_BASE_URL + url);
            httpPost.setHeader("Accept", "application/json");
            httpPost.setHeader("Content-type", "application/json");
            HttpResponse httpResponse = httpClient.execute(httpPost);
            StatusLine statusLine = httpResponse.getStatusLine();
            int statusCode = statusLine.getStatusCode();
            System.out.println("Status Code: " + statusCode);
            if (statusCode == HttpURLConnection.HTTP_OK) {
                inputStream = httpResponse.getEntity().getContent();
                if (inputStream != null)
                    result = convertInputStreamToString(inputStream);
                else
                    result = "Did not work!";
            } else if (statusCode == HttpURLConnection.HTTP_NOT_FOUND) {
                //throw new SQWIPExceptionClass(context, "Data communication error.\nPlease try later.");
            } else if (statusCode == HttpURLConnection.HTTP_INTERNAL_ERROR) {
                //throw new SQWIPExceptionClass(context,"Data communication error.\nPlease try later.");
            } else if (statusCode == HttpURLConnection.HTTP_BAD_REQUEST) {
                //throw new SQWIPExceptionClass(context,"Data communication error.\nPlease try later.");
            } else if (statusCode == HttpURLConnection.HTTP_BAD_METHOD) {
                //throw new SQWIPExceptionClass(context,"Data communication error.\nPlease try later.");
            } else if (statusCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                // throw new SQWIPExceptionClass(context,"Your account has been suspended or temporarily unavailable.\nPlease contact SQWIP admin.");
            } else if (statusCode == HttpURLConnection.HTTP_FORBIDDEN) {
                // throw new SQWIPExceptionClass(context,"Your account has been suspended or temporarily unavailable.\nPlease contact SQWIP admin.");
            } else if (statusCode == HttpURLConnection.HTTP_UNAVAILABLE) {
                // throw new SQWIPExceptionClass(context,"Your Internet Connection seems to be slow.\nPlease try later.");
            } else if (statusCode == HttpURLConnection.HTTP_REQ_TOO_LONG) {
                // throw new SQWIPExceptionClass(context,"You are logged in to a different device. To continue from this device please login again.");

            }
        } catch (UnknownHostException e) {
            e.printStackTrace();
            throw e;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;

    }

    public void alertDialogSingleButton(String message) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context, R.style.MyDialogTheme);

        alertDialogBuilder
                .setMessage(message)
                .setCancelable(false)
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {

                    @Override
                    public void onClick(DialogInterface dialog, int arg1) {
                        dialog.cancel();
                    }
                });

        AlertDialog alertDialog = alertDialogBuilder.create();

        alertDialog.show();
    }

    public void alertDialog(String title) {
        final Dialog dialog = new Dialog(context);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.custom_alert_dialog);

        final TextView titleTextView = (TextView) dialog.findViewById(R.id.title);
        final TextView okText = (TextView) dialog.findViewById(R.id.ok);

        titleTextView.setText(title);
        okText.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });

        dialog.show();
    }

    public String extractFloatValueFromStrin(String s) {
        double f = Double.valueOf(s.replaceAll(Constants.EXTRACT_FLOAT_FROM_STRING_REGEX_PATTERN, ""));
        return String.format("%.2f", f);
    }

    public String changeInUSCurrencyFormat(String s) {
        double f = Double.valueOf(s.replaceAll(Constants.EXTRACT_FLOAT_FROM_STRING_REGEX_PATTERN, ""));
        Locale locale = new Locale("en", "US");
        NumberFormat fmt = NumberFormat.getCurrencyInstance(locale);
        System.out.println(fmt.format(f));

        return fmt.format(f);
    }


    public String removeSpecialCharacters(String url) {

        url = url.replaceAll("[^a-zA-Z0-9/?#(),;'°:.=&-]", " ");
        url = url.replaceAll("[ ]", "%20");

        return url;
    }

    /**
     * Check download manager is present in device or not.
     *
     * @param context to get the package name of the download manager
     * @return either true of false
     */
    public static boolean isDownloadManagerAvailable(Context context) {
        try {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.GINGERBREAD) {
                return false;
            }
            Intent intent = new Intent(Intent.ACTION_MAIN);
            intent.addCategory(Intent.CATEGORY_LAUNCHER);
            intent.setClassName("com.android.providers.downloads.ui", "com.android.providers.downloads.ui.DownloadList");
            List<ResolveInfo> list = context.getPackageManager().queryIntentActivities(intent,
                    PackageManager.MATCH_DEFAULT_ONLY);
            return list.size() > 0;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Download a file from URL
     *
     * @param url      URL of a file to be downloaded
     * @param fileName Name of the file while storing into sdcard.
     */
    public void downloadFile(String url, String fileName) {
        String DownloadUrl = url.replaceAll(" ", "%20");


        if (DownloadUrl.trim().length() == 0) {
            Toast.makeText(context, "File not attached for download", Toast.LENGTH_LONG).show();
        } else {

            String state = Environment.getExternalStorageState();
            if (Environment.MEDIA_MOUNTED.equalsIgnoreCase(state)) {
                DownloadManager.Request request = new DownloadManager.Request(Uri.parse(DownloadUrl));
                request.setDescription(context.getString(R.string.app_name));   //appears the same in Notification bar while downloading
                request.setTitle(fileName);

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.GINGERBREAD) {
                    request.allowScanningByMediaScanner();
                    request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
                }

                File appFolder = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM), Constants.IMAGE_DIRECTORY_NAME);

                if (!appFolder.exists()) {
                    if (!appFolder.mkdirs()) {
                        //Log.d(Constants.IMAGE_DIRECTORY_NAME, "Oops! Failed create " + Constants.IMAGE_DIRECTORY_NAME + " directory");
                    }
                }

                request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DCIM + "/" + Constants.IMAGE_DIRECTORY_NAME, fileName);
                //request.setDestinationInExternalPublicDir(appFolder.getAbsolutePath(), fileName);
                //request.setDestinationInExternalFilesDir(context,null, fileName);

                // get download service and enqueue file
                DownloadManager manager = (DownloadManager) context.getSystemService(Context.DOWNLOAD_SERVICE);
                manager.enqueue(request);
            } else if (Environment.MEDIA_MOUNTED_READ_ONLY.equalsIgnoreCase(state)) {
                Toast.makeText(context, "Your SD Card is not applicable for downloading!", Toast.LENGTH_LONG).show();
            } else {
                Toast.makeText(context, "Please insert sd card!", Toast.LENGTH_LONG).show();
            }
        }
    }

    private static Drawable getColoredCircleDrawable(@ColorInt int color) {
        GradientDrawable drawable = (GradientDrawable) context.getResources().getDrawable(R.drawable.circle);
        drawable.setColor(color);
        return drawable;
    }


    /**
     * Sending JsonObject data to server
     *
     * @param uri         sub url of the the api
     * @param json        if user put any data as a post parameter in json format.
     * @param requestType either GET or POST request.
     * @return JSONObject in String format.
     * @throws UnknownHostException   when internet connection is not available.
     * @throws SocketTimeoutException when server take too much time to give response.
     * @throws CrowdException         when server gives bad request.
     */
    public String makeRequest(String uri, JSONObject json, String requestType) throws UnknownHostException, SocketTimeoutException, CrowdException {
        HttpURLConnection urlConnection;
        // String url;
        //String data = json;
        String result = "";
        SSLContext sc;
        try {


            URL url = new URL(Constants.APP_BASE_URL + uri);
            CrowdBootstrapLogger.logInfo("url: " + url.toString());
            if (json != null) {
                CrowdBootstrapLogger.logInfo("postData: " + json.toString());
            }
            //disableSSLCertificateChecking();
            //Connect
            urlConnection = (HttpURLConnection) url.openConnection();

            /*sc = SSLContext.getInstance("TLS");
            sc.init(null, null, new java.security.SecureRandom());
            urlConnection.setSSLSocketFactory(sc.getSocketFactory());*/


            urlConnection.setDoOutput(true);
            urlConnection.setRequestProperty("Content-Type", "application/json");
            urlConnection.setRequestProperty("Accept", "application/json");

            urlConnection.setReadTimeout(Constants.API_CONNECTION_TIME_OUT_DURATION);
            urlConnection.setConnectTimeout(Constants.API_CONNECTION_TIME_OUT_DURATION);
            urlConnection.setRequestMethod(requestType);
            urlConnection.connect();


            //Write
            if (json != null) {
                OutputStream outputStream = urlConnection.getOutputStream();
                BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(outputStream, Constants.UTF_8));
                writer.write(json.toString());
                writer.close();
                outputStream.close();
            }
            if (urlConnection.getResponseCode() == HttpURLConnection.HTTP_OK) {

                //Read
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), Constants.UTF_8));

                String line = null;
                StringBuilder sb = new StringBuilder();

                while ((line = bufferedReader.readLine()) != null) {
                    sb.append(line);
                }

                bufferedReader.close();
                result = sb.toString();
            } else {
                CrowdBootstrapLogger.logInfo("Status code: " + urlConnection.getResponseCode());
                throw new CrowdException(Constants.SERVEREXCEPTION);
            }


        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (UnknownHostException e) {
            e.printStackTrace();
            throw e;
        } catch (SocketTimeoutException e) {
            throw e;
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            throw e;
        }
        /* catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (KeyManagementException e) {
            e.printStackTrace();
        }*/
        return result;
    }
    /*public String truncateIntValueUpto2DecimalPlaces(int value){
        return String.format("%.2f",value);
    }*/

    /**
     * Disable the SSL Certificate Checking
     */
    private static void disableSSLCertificateChecking() {
        TrustManager[] trustAllCerts = new TrustManager[]{new X509TrustManager() {

            /**
             * @param x509Certificates
             * @param s
             * @throws java.security.cert.CertificateException
             */
            @Override
            public void checkClientTrusted(java.security.cert.X509Certificate[] x509Certificates, String s)
                    throws java.security.cert.CertificateException {
                // not implemented
            }

            /**
             * @param x509Certificates
             * @param s
             * @throws java.security.cert.CertificateException
             */
            @Override
            public void checkServerTrusted(java.security.cert.X509Certificate[] x509Certificates, String s)
                    throws java.security.cert.CertificateException {
                // not implemented
            }

            @Override
            public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                return null;
            }

        }};

        try {

            HttpsURLConnection.setDefaultHostnameVerifier(new HostnameVerifier() {

                @Override
                public boolean verify(String s, SSLSession sslSession) {
                    return true;
                }

            });
            SSLContext sc = SSLContext.getInstance("TLS");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

        } catch (KeyManagementException e) {
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }
}