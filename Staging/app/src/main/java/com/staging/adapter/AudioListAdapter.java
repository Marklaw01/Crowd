package com.staging.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.staging.R;
import com.staging.models.AudioObject;
import com.staging.swipelistviewinscrollview.BaseSwipListAdapter;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/19/2016.
 */
public class AudioListAdapter extends BaseSwipListAdapter {

    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<AudioObject> list;

    public AudioListAdapter(Context context, ArrayList<AudioObject> list) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
    }

    @Override
    public int getCount() {
        return list.size();
    }

    @Override
    public AudioObject getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        convertView1 = convertView;

        if (convertView == null) {
            convertView = l_Inflater.inflate(R.layout.row_item, null);
            holder = new ViewHolder();
            holder.row_layout = (LinearLayout)convertView.findViewById(R.id.row_layout);
            holder.tv_name = (TextView) convertView.findViewById(R.id.text1);
            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.tv_name.setText(list.get(position).getName());
            holder.row_layout.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }



        return convertView;
    }

    static class ViewHolder {
        TextView tv_name;
        LinearLayout row_layout;
    }

    @Override
    public boolean getSwipEnableByPosition(int position) {
        return true;
    }
}