package com.staging.models;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by neelmani.karn on 3/23/2016.
 */
public class A implements Parcelable {
    String starupItemId;
    String startupItemName;
    String statupItemDescription;

    public String getStarupItemId() {
        return starupItemId;
    }

    public void setStarupItemId(String starupItemId) {
        this.starupItemId = starupItemId;
    }

    public String getStartupItemName() {
        return startupItemName;
    }

    public void setStartupItemName(String startupItemName) {
        this.startupItemName = startupItemName;
    }

    public String getStatupItemDescription() {
        return statupItemDescription;
    }

    public void setStatupItemDescription(String statupItemDescription) {
        this.statupItemDescription = statupItemDescription;
    }

    /* public A(String starupItemId, String startupItemName, String statupItemDescription){
            this.starupItemId = starupItemId;
            this.startupItemName = startupItemName;
            this.statupItemDescription = statupItemDescription;
        }*/
    protected A(Parcel in) {
        starupItemId = in.readString();
        startupItemName = in.readString();
        statupItemDescription = in.readString();
    }

    public A(){}
    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(starupItemId);
        dest.writeString(startupItemName);
        dest.writeString(statupItemDescription);
    }

    @SuppressWarnings("unused")
    public static final Parcelable.Creator<A> CREATOR = new Parcelable.Creator<A>() {
        @Override
        public A createFromParcel(Parcel in) {
            return new A(in);
        }

        @Override
        public A[] newArray(int size) {
            return new A[size];
        }
    };
}