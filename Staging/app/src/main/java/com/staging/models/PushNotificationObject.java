package com.staging.models;

import org.json.JSONObject;

/**
 * Created by neelmani.karn on 6/1/2016.
 */
public class PushNotificationObject {
    String notificationType;
    String notificationId;
    String notificationTitle;
    String notificationTime;
    JSONObject values;
    String notificationStatus;

    public String getNotificationStatus() {
        return notificationStatus;
    }

    public void setNotificationStatus(String notificationStatus) {
        this.notificationStatus = notificationStatus;
    }

    public JSONObject getValues() {
        return values;
    }

    public void setValues(JSONObject values) {
        this.values = values;
    }

    public String getNotificationType() {
        return notificationType;
    }

    public void setNotificationType(String notificationType) {
        this.notificationType = notificationType;
    }

    public String getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(String notificationId) {
        this.notificationId = notificationId;
    }

    public String getNotificationTitle() {
        return notificationTitle;
    }

    public void setNotificationTitle(String notificationTitle) {
        this.notificationTitle = notificationTitle;
    }

    public String getNotificationTime() {
        return notificationTime;
    }

    public void setNotificationTime(String notificationTime) {
        this.notificationTime = notificationTime;
    }
}
