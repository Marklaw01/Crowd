package com.staging.utilities;

/**
 * Created by neelmani.karn on 5/6/2015.
 */

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import com.staging.R;
import com.staging.logger.CrowdBootstrapLogger;

public class NetworkConnectivity {

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


    /**
     * Check if internet connection is available or not
     *
     * @param mContext calling context of the application
     * @return true if internet is available else false
     */
    public boolean isInternetConnectionAvaliable(Context mContext) {
        if (null == mContext) {
            return true;
        }
        ConnectivityManager connectivityManager = (ConnectivityManager) mContext.getSystemService(Context.CONNECTIVITY_SERVICE);
        // test for connection
        NetworkInfo netInfo = null;
        if (null != connectivityManager) {
            netInfo = connectivityManager.getActiveNetworkInfo();
        }
        if (null != netInfo && netInfo.isAvailable() && netInfo.isConnected()) {
            return true;
        } else {
            CrowdBootstrapLogger.logInfo(mContext.getString(R.string.no_internet_connection));
            return false;
        }
    }
}