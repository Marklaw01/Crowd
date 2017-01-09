package com.staging.dropdownadapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.staging.R;
import com.staging.models.StatesObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/6/2016.
 */
public class StatesAdapter extends BaseAdapter{



    StatesObject cObj = new StatesObject();
    private LayoutInflater l_Inflater;
    ArrayList<StatesObject> playListMap;
    boolean status;
    int pos = 0;
    View convertView1;
    Context context;

    public StatesAdapter(Context context, int textViewResourceId, ArrayList<StatesObject> playListMap) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.playListMap = playListMap;
    }

    @Override
    public Object getItem(int position) {
        return playListMap.get(position);
    }

    public int getCount() {
        return playListMap.size();
    }

    public long getItemId(int position) {
        return position;
    }

    public String getItemName(int position) {
        return playListMap.get(position).getName();
    }

    public String getId(int position) {
        return playListMap.get(position).getId();
    }

    @Override
    public View getDropDownView(int position, View convertView, ViewGroup parent) {
        return getCustomView(position, convertView, parent);
    }

    public View getCustomView(int position, View convertView, ViewGroup parent) {

        ViewHolder holder;
        convertView1 = convertView;

        if (convertView == null) {

            convertView = l_Inflater.inflate(R.layout.spinner_cat_item, null);
            holder = new ViewHolder();
            holder.Title = (TextView) convertView.findViewById(R.id.text1);

            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        try {
            holder.Title.setText(playListMap.get(position).getName());

        } catch (Exception e) {
            e.printStackTrace();
        }

        return convertView;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        ViewHolder holder;
        convertView1 = convertView;

        if (convertView == null) {
            convertView = l_Inflater.inflate(R.layout.spinner_cat_item, null);
            holder = new ViewHolder();
            holder.Title = (TextView) convertView.findViewById(R.id.text1);

            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        try {
            holder.Title.setText(playListMap.get(position).getName());

        } catch (Exception e) {

            e.printStackTrace();
        }

        return convertView;
    }

    static class ViewHolder {

        TextView Title;
    }
}
