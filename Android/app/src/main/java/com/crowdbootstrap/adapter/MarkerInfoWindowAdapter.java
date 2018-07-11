package com.crowdbootstrap.adapter;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.support.v4.app.FragmentActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.Marker;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.crowdbootstrap.R;
import com.crowdbootstrap.helper.CircleImageView;
import com.crowdbootstrap.models.MyMarkerObject;
import com.crowdbootstrap.utilities.Constants;

import java.util.HashMap;

/**
 * Created by Sunakshi.Gautam on 11/16/2017.
 */

public class MarkerInfoWindowAdapter implements GoogleMap.InfoWindowAdapter {

    private HashMap<Marker, MyMarkerObject> mMarkersHashMap;
    private Context context;
    private LayoutInflater l_Inflater;
    public DisplayImageOptions options;

    public MarkerInfoWindowAdapter(HashMap<Marker, MyMarkerObject> mMarkersHashMap, FragmentActivity activity) {
        this.mMarkersHashMap = mMarkersHashMap;
        this.context = activity;
        l_Inflater = LayoutInflater.from(context);
        options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.image)
                .showImageForEmptyUri(R.drawable.image)
                .showImageOnFail(R.drawable.image)
                .cacheInMemory(true)
                .cacheOnDisk(true)
                .considerExifParams(true)
                .bitmapConfig(Bitmap.Config.RGB_565)

                .build();
    }

    @Override
    public View getInfoWindow(Marker marker) {
        return null;
    }

    @Override
    public View getInfoContents(Marker marker) {
        final View v = l_Inflater.inflate(R.layout.marker_info_layout, null);

        final MyMarkerObject myMarker = mMarkersHashMap.get(marker);

        ImageView markerIcon = (CircleImageView) v.findViewById(R.id.marker_icon);

        LinearLayout markerLayout =  (LinearLayout) v.findViewById(R.id.marker_layout);

        TextView markerLabel = (TextView) v.findViewById(R.id.marker_label);
        TextView userVisibility =  (TextView) v.findViewById(R.id.user_visibility);

        TextView anotherLabel = (TextView)v.findViewById(R.id.another_label);
        anotherLabel.setText(myMarker.getUserStatement());



        if(myMarker.getmStatus().compareTo("1") == 0){
            userVisibility.setText("Available");
            userVisibility.setTextColor(Color.parseColor("#056a1f"));

        }else  if(myMarker.getmStatus().compareTo("2") == 0){
            userVisibility.setText("DND");
            userVisibility.setTextColor(Color.parseColor("#e8a514"));

        }else if(myMarker.getmStatus().compareTo("3") == 0){
            userVisibility.setText("Busy");
            userVisibility.setTextColor(Color.parseColor("#D21F1F"));

        }


        if(myMarker.getMarkerType().compareTo("Single") == 0) {
            markerLabel.setText(myMarker.getmLabel());
            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL +myMarker.getmIcon(), markerIcon, options);
        }else{
            markerLabel.setText(myMarker.getCount() + " Users found");
            markerIcon.setImageResource(R.drawable.dummy_groupsimg);
        }



        return v;
    }


}
