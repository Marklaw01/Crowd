package com.crowdbootstrapapp.logger;

import android.content.Context;
import android.util.Log;

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

        if(true){     //If application in debug mode then log the exception in logcat
            Log.e(EXCEPTON_TAG, "Error:" + exceptionMessage + " Method " + methodName + " Class Name " + className);
        }
        /*if(Constants.IS_IN_ROLLBAR_MODE){    *//* If rollbar is enabled then log the exception in rollbar*//*
            // Map the keys to log exception in rollbar
            Map<String, String> rollbarLogMap = new HashMap<String, String>();
            rollbarLogMap.put(Constants.ROLLBAR_USER_ID_TAG, PrefManager.getInstance(applicationContext).getString(Constants.USER_ID));
            rollbarLogMap.put(Constants.ROLLBAR_USER_NAME_TAG, PrefManager.getInstance(applicationContext).getString(Constants.USER_NAME));
            rollbarLogMap.put(Constants.ROLLBAR_CLASS_NAME_TAG, className);
            rollbarLogMap.put(Constants.ROLLBAR_METHOD_NAME_TAG, methodName);
            rollbarLogMap.put(Constants.ROLLBAR_EXCEPTION_MESSAGE_TAG, exceptionMessage.toString());
            Rollbar.reportMessage(Constants.ROLLBAR_EXCEPTION_TAG, Constants.ROLLBAR_EXCEPTION_CATEGORY_TAG, rollbarLogMap);
        }*/
    }


    /**
     * Method to log the information in logcat. Developer can set the tag to SpeazieInfo to view in logcat
     * @param infoMessage message to log in logcat
     */
    /*public static void logInfo(String infoMessage){
        if(Constants.IS_IN_DEBUG_MODE){
            Log.i(INFO_TAG, infoMessage);
        }
    }*/
}
