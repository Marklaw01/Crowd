package com.staging.logger;

import android.content.Context;
import android.util.Log;

import com.staging.BuildConfig;

/**
 * Class to log the exception in rollbar
 * Created by amit.thaper on 5/25/2016.
 */
public class CrowdBootstrapLogger {

    private static String EXCEPTON_TAG = "CrowdBootstrapException"; // Tag to log the exception in stack trace
    private static String INFO_TAG = "CrowdBootstrapInfo"; // Tag to log the information in stack trace

    private CrowdBootstrapLogger(){
        // Private Constructor to hide the implicit public one
    }
    /**
     *  Method to log the exception in logcat and in rollbar. Developer can set the tag to SpeazieException to view in logcat
     * @param applicationContext Context of the application
     * @param methodName    method name in which exception occurs
     * @param exceptionMessage   error message
     * @param className class name where exception occurs
     */
    public static void logError(Context applicationContext, String methodName,Exception exceptionMessage, String className){

        if(BuildConfig.DEBUG){     //If application in debug mode then log the exception in logcat
            Log.e(EXCEPTON_TAG, "Error:" + exceptionMessage + " Method " + methodName + " Class Name " + className);
        }
       
    }


    /**
     * Method to log the information in logcat. Developer can set the tag to SpeazieInfo to view in logcat
     * @param infoMessage message to log in logcat
     */
    public static void logInfo(String infoMessage){
        if(BuildConfig.DEBUG){
            Log.i(INFO_TAG, infoMessage);
        }
    }
}
