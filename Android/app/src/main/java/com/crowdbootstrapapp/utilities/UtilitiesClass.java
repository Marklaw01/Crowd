package com.crowdbootstrapapp.utilities;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DownloadManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.Settings;
import android.support.annotation.ColorInt;
import android.view.View;
import android.view.Window;
import android.widget.TextView;
import android.widget.Toast;


import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.exception.CrowdException;
import com.crowdbootstrapapp.logger.CrowdBootstrapLogger;

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
import java.io.File;
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

import javax.net.ssl.SSLContext;
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

    public void showSettingsAlert() {


        AlertDialog.Builder alertDialog = new AlertDialog.Builder(context);

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
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context);

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
     * @param uri         is the url for the api
     * @param json        data come from UI in JsonObject form.
     * @param requestType it would be either GET or POST
     * @return String object in jsonFormat
     * @throws UnknownHostException   if internet connection is not there or may be bandwidth of internet is low.
     * @throws SocketTimeoutException when user connection is slow and it takes much time to execute then user get timeout message
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
                CrowdBootstrapLogger.logInfo("postData" + json.toString());
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
                BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(outputStream, "UTF-8"));
                writer.write(json.toString());
                writer.close();
                outputStream.close();
            }
            if (urlConnection.getResponseCode() == HttpURLConnection.HTTP_OK) {

                //Read
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), "UTF-8"));

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
}