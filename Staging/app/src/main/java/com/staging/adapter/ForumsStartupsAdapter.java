package com.staging.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.staging.R;
import com.staging.models.StartupsObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/13/2016.
 */
public class ForumsStartupsAdapter extends BaseAdapter {

    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<StartupsObject> list;

    public ForumsStartupsAdapter(Context context, ArrayList<StartupsObject> list) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
    }


    @Override
    public int getCount() {
        return list.size();
    }


    @Override
    public Object getItem(int position) {
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
            convertView = l_Inflater.inflate(R.layout.forums_startup_row_item, null);
            holder = new ViewHolder();

            holder.tv_forumDescription = (TextView)convertView.findViewById(R.id.tv_forumDescription);
            holder.tv_StartupName = (TextView)convertView.findViewById(R.id.tv_StartupName);


            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        try {
            holder.tv_forumDescription.setText(list.get(position).getDescription());
            holder.tv_StartupName.setText(list.get(position).getStartupName());


        } catch (Exception e) {

            e.printStackTrace();
        }

        return convertView;
    }

    static class ViewHolder {
        TextView tv_StartupName, tv_forumDescription;
    }
}
