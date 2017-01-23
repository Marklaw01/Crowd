package com.crowdbootstrapapp.utilities;

/**
 * Created by neelmani.karn on 5/6/2015.
 */

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.logger.CrowdBootstrapLogger;

public final class NetworkConnectivity {

    static Context context;
    private static NetworkConnectivity instance = new NetworkConnectivity();
    ConnectivityManager connectivityManager;

    public static NetworkConnectivity getInstance(Context ctx) {
        context = ctx;
        return instance;
    }

    public boolean isOnline() {
        ConnectivityManager cm = (ConnectivityManager) this.context.getSystemService(Context.CONNECTIVITY_SERVICE);

        NetworkInfo wifiNetwork = cm.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
        if (wifiNetwork != null && wifiNetwork.isConnected()) {
            return true;
        }

        NetworkInfo mobileNetwork = cm.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
        if (mobileNetwork != null && mobileNetwork.isConnected()) {
            return true;
        }

        NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
        if (activeNetwork != null && activeNetwork.isConnected()) {
            return true;
        }

        return false;
    }


    //created by Neel on 10th Jan 2017

    /**
     * Check if internet connection is available or not
     *
     * @return true if internet is available else false
     */
    public boolean isInternetConnectionAvaliable() {
        if (null == context) {
            return true;
        }
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        // test for connection
        NetworkInfo netInfo = null;
        if (null != connectivityManager) {
            netInfo = connectivityManager.getActiveNetworkInfo();
        }
        if (null != netInfo && netInfo.isAvailable() && netInfo.isConnected()) {
            return true;
        } else {
            CrowdBootstrapLogger.logInfo(context.getString(R.string.no_internet_connection));
            return false;
        }
    }
}