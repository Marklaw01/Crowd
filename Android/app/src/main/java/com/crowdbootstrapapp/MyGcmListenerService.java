package com.crowdbootstrapapp;

/**
 * Created by neelmani.karn on 2/23/2016.
 */

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.application.CrowdBootstrapApplicationClass;
import com.crowdbootstrapapp.utilities.Constants;
import com.google.android.gms.gcm.GcmListenerService;

import java.util.Date;
import java.util.Iterator;
import java.util.Set;

public class MyGcmListenerService extends GcmListenerService {

    //Context context;
    //PrefManager prefManager;
    private static final String TAG = "MyGcmListenerService";

    //CrowdBootstrapApplicationClass instance;
    public MyGcmListenerService() {
        super();

        //instance = (CrowdBootstrapApplicationClass) getApplication();
        // context = CrowdBootstrapApplicationClass.getContext();
        //  prefManager = PrefManager.getInstance(context);
    }

    /**
     * Called when message is received.
     *
     * @param from SenderID of the sender.
     * @param data Data bundle containing message data as key/value pairs.
     *             For Set of keys use data.keySet().
     */
    // [START receive_message]
    @Override
    public void onMessageReceived(String from, Bundle data) {
        //Log.e("instance", instance.toString());
        if (CrowdBootstrapApplicationClass.getPref().getBoolean(Constants.IS_NOTIFICATION_ON)) {
            if (data != null) {
                Set<String> keys = data.keySet();
                Iterator<String> it = keys.iterator();
                Log.e("LOG_TAG", "Dumping Intent start");
                while (it.hasNext()) {
                    String key = it.next();
                    Log.e(key, key + "=" + data.get(key));
                }
                Log.e("LOG_TAG", "Dumping Intent end");
            }

            String message = data.getString("message");
            Log.d(TAG, "From: " + from);
            Log.d(TAG, "Message: " + message);

            if (from.startsWith("/topics/")) {
                // message received from some topic.
            } else {
                // normal downstream message.
            }

            // [START_EXCLUDE]
            /**
             * Production applications would usually process the message here.
             * Eg: - Syncing with server.
             *     - Store message in local database.
             *     - Update UI.
             */

            /**
             * In some cases it may be useful to show a notification indicating to the user
             * that a message was received.
             */


           /* if (data.getString("tag").equalsIgnoreCase("Profile")) {
                sendNotification(message, data.getString("tag"));
            }
*/
            sendNotification(message, data);
        }

        // [END_EXCLUDE]
    }
    // [END receive_message]

    /**
     * Create and show a simple notification containing the received GCM message.
     *
     * @param message GCM message received.
     */
    /*private void sendNotification(String message, String tag) {


        Intent intent = new Intent(this, HomeActivity.class);
        intent.putExtra(Constants.NOTIFICATION_CONSTANT, tag);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0 *//* Request code *//*, intent,
                PendingIntent.FLAG_ONE_SHOT);

        Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this)
                .setSmallIcon(R.drawable.ic_launcher)
                .setContentTitle(getString(R.string.app_name))
                .setStyle(new NotificationCompat.BigTextStyle().bigText(message))
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
                .setSound(defaultSoundUri)
                .setContentText(message);

        NotificationManager notificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        notificationManager.notify(0 *//* ID of notification *//*, notificationBuilder.build());

    }*/

    private void sendNotification(String message, Bundle tag) {

        long time = new Date().getTime();
        String tmpStr = String.valueOf(time);
        String last4Str = tmpStr.substring(tmpStr.length() - 5);
        int notificationId = Integer.valueOf(last4Str);

        Intent intent = new Intent(this, HomeActivity.class);
        intent.putExtras(tag);
        //intent.putExtra(Constants.NOTIFICATION_CONSTANT, tag);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, notificationId /* Request code */, intent, PendingIntent.FLAG_ONE_SHOT);

        Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this)
                .setSmallIcon(R.drawable.ic_launcher)
                .setLargeIcon(BitmapFactory.decodeResource(this.getResources(), R.drawable.ic_launcher))
                .setContentTitle(getString(R.string.app_name))
                .setStyle(new NotificationCompat.BigTextStyle().bigText(message))
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
                .setColor(getResources().getColor(R.color.white))
                .setSound(defaultSoundUri)
                .setContentText(message);

        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.notify(notificationId /* ID of notification */, notificationBuilder.build());

    }
}