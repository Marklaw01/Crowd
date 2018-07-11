package com.staging.models;

/**
 * Created by Sunakshi.Gautam on 11/16/2017.
 */

public class MyMarkerObject {


    private String mLabel;
    private String mIcon;
    private Double mLatitude;
    private Double mLongitude;
    private String mStatus;
    private String count;
    private String userId;
    private String markerType;
    private String userStatement;
    private String connectionTypeID;
    private String cardID;

    public MyMarkerObject(String label, String icon, Double latitude, Double longitude, String status, String count, String userId, String markerType, String userStatement, String connectionTypeID, String cardID)
    {
        this.mLabel = label;
        this.mLatitude = latitude;
        this.mLongitude = longitude;
        this.mIcon = icon;
        this.mStatus = status;
        this.count = count;
        this.markerType = markerType;
        this.userId = userId;
        this.userStatement = userStatement;
        this.connectionTypeID = connectionTypeID;
        this.cardID = cardID;
    }

    public String getCardID() {
        return cardID;
    }

    public String getConnectionTypeID() {
        return connectionTypeID;
    }

    public String getUserStatement() {
        return userStatement;
    }

    public String getmLabel()
    {
        return mLabel;
    }

    public void setmLabel(String mLabel)
    {
        this.mLabel = mLabel;
    }

    public String getmStatus() {
        return mStatus;
    }

    public void setmStatus(String mStatus) {
        this.mStatus = mStatus;
    }

    public String getmIcon()
    {
        return mIcon;
    }

    public void setmIcon(String icon)
    {
        this.mIcon = icon;
    }

    public Double getmLatitude()
    {
        return mLatitude;
    }

    public void setmLatitude(Double mLatitude)
    {
        this.mLatitude = mLatitude;
    }

    public Double getmLongitude()
    {
        return mLongitude;
    }

    public void setmLongitude(Double mLongitude)
    {
        this.mLongitude = mLongitude;
    }

    public String getCount() {
        return count;
    }

    public String getUserId() {
        return userId;
    }

    public String getMarkerType() {
        return markerType;
    }
}
