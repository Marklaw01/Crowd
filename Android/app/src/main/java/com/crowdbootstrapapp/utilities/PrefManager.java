/**
 *
 */
package com.crowdbootstrapapp.utilities;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;

import com.quickblox.users.model.QBUser;

/**
 * @author neelmani.karn
 */
public final class PrefManager {

    private static SharedPreferences prefs;
    private Editor editor;

    private static PrefManager instance = new PrefManager();
    private static Context context;

    public static PrefManager getInstance(Context ctx) {
        context = ctx;
        prefs = ctx.getSharedPreferences(Constants.APP_SHARED_PREFERENCES, Context.MODE_PRIVATE);
        return instance;
    }

    /*public void saveQbUser(QBUser qbUser) {
        editor = prefs.edit();
        editor.putString(QB_USER_ID, qbUser.getId());
        helper.save(QB_USER_LOGIN, qbUser.getLogin());
        helper.save(QB_USER_PASSWORD, qbUser.getPassword());
        helper.save(QB_USER_FULL_NAME, qbUser.getFullName());
    }*/

    public void storeString(String key, String value) {
        editor = prefs.edit();
        editor.putString(key, value);
        editor.commit();
    }

    public String getString(String key) {
        return prefs.getString(key, "");
    }

    public void storeInteger(String key, int value) {
        editor = prefs.edit();
        editor.putInt(key, value);
        editor.commit();
    }

    public int getInteger(String key) {
        return prefs.getInt(key, 0);
    }

    public void storeBoolean(String key, boolean value) {
        editor = prefs.edit();
        editor.putBoolean(key, value);
        editor.commit();
    }

    public boolean getBoolean(String key) {
        return prefs.getBoolean(key, false);
    }

    public void storeRegistrationId(String regId) {

        String appVersion = getAppVersion(context);
        // Log.i("TAG", "Saving regId on app version " + appVersion);
        editor = prefs.edit();
        editor.putString(Constants.GCM_REGISTRATION_ID, regId);
        editor.putString(Constants.APP_VERSION, appVersion);
        editor.commit();
    }

    /**
     * Gets the current registration ID for application on GCM service.
     * <p/>
     * If result is empty, the app needs to register.
     *
     * @return registration ID, or empty string if there is no existing
     * registration ID.
     */
    public String getRegistrationId() {

        String registrationId = prefs.getString(Constants.GCM_REGISTRATION_ID, "");
        if (registrationId.isEmpty()) {
            //Log.i("TAG", "Registration not found.");
            return "";
        }
        // Check if app was updated; if so, it must clear the registration ID
        // since the existing registration ID is not guaranteed to work with
        // the new app version.
        String registeredVersion = prefs.getString(
                Constants.APP_VERSION, "");
        String currentVersion = getAppVersion(context);
        if (!registeredVersion.equalsIgnoreCase(currentVersion)) {
            //Log.i("TAG", "App version changed.");
            return "";
        }
        return registrationId;
    }

    /**
     * @return Application's version code from the {@code PackageManager}.
     */
    private String getAppVersion(Context context) {
        try {
            PackageInfo packageInfo = context.getPackageManager()
                    .getPackageInfo(context.getPackageName(), 0);
            return packageInfo.versionName;
        } catch (NameNotFoundException e) {
            // should never happen
            throw new RuntimeException("Could not get package name: " + e);
        }
    }

    public void clearAllPreferences() {
        editor = prefs.edit();
        editor.clear();
        editor.commit();
    }


    public void saveQbUser(QBUser qbUser) {
        editor = prefs.edit();
        editor.putInt(Constants.QB_USER_ID, qbUser.getId());

        editor.putString(Constants.QB_USER_LOGIN, qbUser.getLogin());
        editor.putString(Constants.QB_USER_PASSWORD, qbUser.getPassword());
        editor.putString(Constants.QB_USER_FULL_NAME, qbUser.getFullName());
        editor.commit();
    }

    public void removeQbUser() {
        editor = prefs.edit();
        editor.remove(Constants.QB_USER_ID);
        editor.remove(Constants.QB_USER_LOGIN);
        editor.remove(Constants.QB_USER_PASSWORD);
        editor.remove(Constants.QB_USER_FULL_NAME);
        editor.commit();
    }

    public boolean hasQbUser() {

        return prefs.contains(Constants.QB_USER_LOGIN) && prefs.contains(Constants.QB_USER_PASSWORD);
    }

    public QBUser getQbUser() {


        if (hasQbUser()) {
            Integer id = prefs.getInt(Constants.QB_USER_ID, 0);
            String login = prefs.getString(Constants.QB_USER_LOGIN, "");
            String password = prefs.getString(Constants.QB_USER_PASSWORD, "");
            String fullName = prefs.getString(Constants.QB_USER_FULL_NAME, "");

            QBUser user = new QBUser(login, password);
            user.setId(id);
            user.setFullName(fullName);
            return user;
        } else {
            return null;
        }
    }
}