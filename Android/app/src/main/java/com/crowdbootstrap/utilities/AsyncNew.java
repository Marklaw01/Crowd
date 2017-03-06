package com.crowdbootstrap.utilities;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Handler;


import com.crowdbootstrap.exception.CrowdException;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;

import org.json.JSONObject;

import java.net.SocketTimeoutException;
import java.net.UnknownHostException;

public class AsyncNew extends AsyncTask<String, Integer, String> {
    private AsyncTaskCompleteListener<String> callback;
    private String tag;
    private Context context;
    private ProgressDialog pd;
    private JSONObject postDataParams;
    private String method;
    private String url;
    private UtilitiesClass utilitiesClass;

    public AsyncNew(Context context, AsyncTaskCompleteListener<String> cb, String tag, String url, String method, JSONObject postDataParams) {
        this.context = context;
        this.callback = cb;
        this.postDataParams = postDataParams;
        this.tag = tag;
        this.url = url;
        this.method = method;
        this.utilitiesClass = UtilitiesClass.getInstance(context);
    }

    @Override
    protected void onProgressUpdate(Integer... values) {
        super.onProgressUpdate(values);
        pd.setProgress(values[0]);
    }


    protected void onPostExecute(final String result) {
        // pd.dismiss();
        new Handler().postDelayed(new Runnable() {

            @Override
            public void run() {
                callback.onTaskComplete(result, tag);
            }
        }, 300);
    }

    @Override
    protected String doInBackground(String... params) {
        String response = "";
        try {

            response = utilitiesClass.makeRequest(url, postDataParams, method);

            return response;
        } catch (UnknownHostException e) {
            return Constants.NOINTERNET;
        } catch (SocketTimeoutException e) {
            return Constants.TIMEOUT_EXCEPTION;
        } catch (CrowdException e) {
            return Constants.SERVEREXCEPTION;
        } catch (Exception e) {
            e.printStackTrace();
            return Constants.SERVEREXCEPTION;

        }
    }
}