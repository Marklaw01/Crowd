package com.crowdbootstrap.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.crowdbootstrap.R;
import com.crowdbootstrap.models.MyForumsObject;
import com.crowdbootstrap.swipelistviewinscrollview.BaseSwipListAdapter;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/14/2016.
 */
public class MyForumsAdapter extends BaseSwipListAdapter {

    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<MyForumsObject> list;

    public MyForumsAdapter(Context context, ArrayList<MyForumsObject> list) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
    }

    @Override
    public int getCount() {
        return list.size();
    }

    @Override
    public MyForumsObject getItem(int position) {
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
            convertView = l_Inflater.inflate(R.layout.myforums_row_item, null);
            holder = new ViewHolder();

            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_forumsTitle);
            holder.tv_description = (TextView) convertView.findViewById(R.id.tv_forumDescription);
            holder.tv_createdTime = (TextView) convertView.findViewById(R.id.tv_forumCreatedTime);
            holder.image = (ImageView) convertView.findViewById(R.id.image_forum);

            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }



        try {
            holder.tv_name.setText(list.get(position).getTitle());
            holder.tv_description.setText(list.get(position).getDescription());
            holder.tv_createdTime.setText(list.get(position).getCreatedDate());


        } catch (Exception e) {

            e.printStackTrace();
        }
        return convertView;
    }

    static class ViewHolder {

        TextView tv_name, tv_description, tv_createdTime;
        ImageView image;


    }

    @Override
    public boolean getSwipEnableByPosition(int position) {

        return true;
    }

}
