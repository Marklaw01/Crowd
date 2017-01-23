package com.crowdbootstrapapp.utilities;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.CountDownTimer;
import android.os.Handler;
import android.support.v7.app.AlertDialog;


import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.activities.LeanStartupRoadmap;
import com.crowdbootstrapapp.activities.LoginActivity;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;

import org.json.JSONObject;

import java.net.UnknownHostException;

public class Async extends AsyncTask<String, Integer, String> {
    private AsyncTaskCompleteListener<String> callback;
    private String tag;
    private Context context;
    private ProgressDialog pd;
    private JSONObject postDataParams;
    private int method;
    private String url;
    public Async asyncObject;
    private UtilitiesClass utilitiesClass;
    private String strFrom;

    public Async(Context context, AsyncTaskCompleteListener<String> cb, String tag, String url, int method, JSONObject postDataParams, String from) {
        this.context = context;
        this.callback = cb;
        this.postDataParams = postDataParams;
        this.tag = tag;
        this.url = url;
        this.method = method;
        this.strFrom = from;
        this.utilitiesClass = UtilitiesClass.getInstance(context);
    }

    public Async(Context context, AsyncTaskCompleteListener<String> cb, String tag, String url, int method, String from) {
        this.context = context;
        this.callback = cb;
        this.tag = tag;
        this.url = url;
        this.method = method;
        this.strFrom = from;
        this.utilitiesClass = UtilitiesClass.getInstance(context);
    }

    @Override
    protected void onProgressUpdate(Integer... values) {
        super.onProgressUpdate(values);
        pd.setProgress(values[0]);
    }

    @Override
    protected void onPreExecute() {
        super.onPreExecute();
        asyncObject = this;
        new CountDownTimer(15000, 1000) {
            public void onTick(long millisUntilFinished) {
                // You can monitor the progress here as well by changing the onTick() time
            }
            public void onFinish() {
                // stop async task if not in progress
                if (asyncObject.getStatus() == Status.RUNNING) {
                    asyncObject.cancel(true);
                    if(strFrom.compareTo("Home Activity") == 0) {
                        ((HomeActivity) context).dismissProgressDialog();
                    }
                    else if(strFrom.compareTo("Login Activity") == 0){
                        ((LoginActivity) context).dismissProgressDialog();
                    }
                    else{
                        ((LeanStartupRoadmap) context).dismissProgressDialog();
                    }
                    new AlertDialog.Builder(context)
                            .setMessage("Your request has timed out. Please check your Internet connection then try again.")
                            .setCancelable(false)
                            .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {

                                }
                            }).create().show();
                }
            }
        }.start();

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

            if (method == Constants.HTTP_POST) {
                if (postDataParams!=null){
                    response = utilitiesClass.postJsonObject(url, postDataParams);
                }else{
                    response = utilitiesClass.postApiRequest(url);
                }
            } else if (method == Constants.HTTP_GET) {
                response = utilitiesClass.getJSON(url);
            }
            return response;
        } catch (UnknownHostException e) {
            return Constants.NOINTERNET;
        } catch (Exception e) {
            e.printStackTrace();
            return Constants.SERVEREXCEPTION;

        }
    }
}