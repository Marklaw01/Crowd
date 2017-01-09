package com.crowdbootstrapapp.application;

import android.app.Application;
import android.content.Context;
import android.support.multidex.MultiDex;
import android.util.Log;

import com.crowdbootstrapapp.utilities.Constants;
import com.crowdbootstrapapp.utilities.NetworkConnectivity;
import com.crowdbootstrapapp.utilities.PrefManager;
import com.crowdbootstrapapp.utilities.UtilitiesClass;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;
import com.quickblox.core.QBSettings;
//import com.quickblox.core.QBSettings;

/**
 * Created by neelmani.karn on 2/26/2016.
 */
public class CrowdBootstrapApplicationClass extends Application {

    private static final String TAG = CrowdBootstrapApplicationClass.class.getSimpleName();
    private static Context context;
    private static CrowdBootstrapApplicationClass instance;

    private static PrefManager prefManager;
    private static NetworkConnectivity networkConnectivity;
    private static UtilitiesClass utilitiesClass;

    public static CrowdBootstrapApplicationClass getInstance() {
        return instance;
    }

    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }

    public static Context getContext() {
        return context;
    }

    public static void setContext(Context mContext) {
        context = mContext;
    }

    @Override
    public void onCreate() {
        super.onCreate();

        Log.d(TAG, "onCreate");

        instance = this;

        try {
            prefManager = PrefManager.getInstance(getApplicationContext());
            networkConnectivity = NetworkConnectivity.getInstance(getApplicationContext());
            utilitiesClass = UtilitiesClass.getInstance(getApplicationContext());
            initImageLoader(getApplicationContext());


            // Initialise Rollbar
            //Rollbar.init(this, Constants.ROLLBAR_CLIENT_SIDE_TOKEN, "production");
            // Initialise QuickBlox SDK
            initCredentials(Constants.QUICKBLOX_APP_ID, Constants.QUICKBLOX_AUTH_KEY, Constants.QUICKBLOX_AUTH_SECRET, Constants.QUICKBLOX_ACCOUNT_KEY);
        } catch (Exception e) {
            e.printStackTrace();
        }
        //QBSettings.getInstance().fastConfigInit(Constants.QUICKBLOX_APP_ID, Constants.QUICKBLOX_AUTH_KEY, Constants.QUICKBLOX_AUTH_SECRET);
    }

    public void initCredentials(String APP_ID, String AUTH_KEY, String AUTH_SECRET, String ACCOUNT_KEY) {
        try {
            QBSettings.getInstance().init(getApplicationContext(), APP_ID, AUTH_KEY, AUTH_SECRET);
            QBSettings.getInstance().setAccountKey(ACCOUNT_KEY);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void initImageLoader(Context context) {
        try {
            // This configuration tuning is custom. You can tune every option, you may tune some of them,
            // or you can create default configuration by
            //  ImageLoaderConfiguration.createDefault(this);
            // method.
            ImageLoaderConfiguration.Builder config = new ImageLoaderConfiguration.Builder(context);
            config.threadPriority(Thread.MAX_PRIORITY);
            config.denyCacheImageMultipleSizesInMemory();
            config.diskCacheFileNameGenerator(new Md5FileNameGenerator());
            config.diskCacheSize(50 * 1024 * 1024); // 50 MiB
            config.tasksProcessingOrder(QueueProcessingType.LIFO);
            config.writeDebugLogs(); // Remove for release app

            // Initialize ImageLoader with configuration.
            ImageLoader.getInstance().init(config.build());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static PrefManager getPref() {
        return prefManager;
    }

    public static UtilitiesClass getUtilities() {
        return utilitiesClass;
    }

    public static NetworkConnectivity getNetork() {
        return networkConnectivity;
    }

    public void setPrefManager(PrefManager prefManager) {
        this.prefManager = prefManager;
    }

    public void setNetworkConnectivity(NetworkConnectivity networkConnectivity) {
        this.networkConnectivity = networkConnectivity;
    }

    public void setUtilitiesClass(UtilitiesClass utilitiesClass) {
        this.utilitiesClass = utilitiesClass;
    }
}