package com.staging.models;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 3/23/2016.
 */
public class B implements Parcelable {
    String idNa, start;
    String desc;
    ArrayList<A> itemsObjectArrayList;

    public B(String id, String start, String desc, ArrayList<A> items){
        this.start = start;
        this.idNa = id;
        this.desc = desc;
        this.itemsObjectArrayList = items;
    }
    protected B(Parcel in) {
        desc = in.readString();
        idNa = in.readString();
        start = in.readString();
        if (in.readByte() == 0x01) {
            itemsObjectArrayList = new ArrayList<A>();
            in.readList(itemsObjectArrayList, A.class.getClassLoader());
        } else {
            itemsObjectArrayList = null;
        }
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(desc);
        dest.writeString(idNa);
        dest.writeString(start);

        if (itemsObjectArrayList == null) {
            dest.writeByte((byte) (0x00));
        } else {
            dest.writeByte((byte) (0x01));
            dest.writeList(itemsObjectArrayList);
        }
    }

    @SuppressWarnings("unused")
    public static final Parcelable.Creator<B> CREATOR = new Parcelable.Creator<B>() {
        @Override
        public B createFromParcel(Parcel in) {
            return new B(in);
        }

        @Override
        public B[] newArray(int size) {
            return new B[size];
        }
    };
}