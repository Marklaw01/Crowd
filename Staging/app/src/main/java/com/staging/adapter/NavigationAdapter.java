package com.staging.adapter;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.staging.R;
import com.staging.models.NavDrawerItem;

import java.util.ArrayList;

/**
 * Created by sunakshi.gautam on 1/12/2016.
 */
public class NavigationAdapter extends ArrayAdapter<NavDrawerItem> {
    private final Context context;
    private final int layoutResourceId;
    private ArrayList<NavDrawerItem> data = null;

    public NavigationAdapter(Context context, int layoutResourceId, ArrayList<NavDrawerItem> data) {
        super(context, layoutResourceId, data);
        this.context = context;
        this.layoutResourceId = layoutResourceId;
        this.data = data;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = ((Activity) context).getLayoutInflater();

        View v = inflater.inflate(layoutResourceId, parent, false);

        try {
            ImageView imageView = (ImageView) v.findViewById(R.id.navimage);
            TextView textView = (TextView) v.findViewById(R.id.navtext);

            NavDrawerItem choice = data.get(position);

            imageView.setImageResource(choice.icon);
            textView.setText(choice.name);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return v;
    }

    public String getTitle(int position){
        return data.get(position).getName();
    }


}