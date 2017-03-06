package com.crowdbootstrap.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.crowdbootstrap.R;
import com.crowdbootstrap.models.RoadMapObject;

import java.util.ArrayList;

/**
 * Created by sunakshi.gautam on 2/11/2016.
 */
public class RoadMapAdapter extends BaseAdapter {

    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<RoadMapObject> list;

    public RoadMapAdapter(Context context, ArrayList<RoadMapObject> list){
        l_Inflater = LayoutInflater.from(context);
        //System.out.println(context);
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
        if (convertView == null) {
            convertView = l_Inflater.inflate(R.layout.roadmap_row_item, null);
            holder = new ViewHolder();

            holder.tv_roadmapname = (TextView) convertView.findViewById(R.id.tv_roadmap);
                 convertView.setTag(holder);
        }else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.tv_roadmapname.setText(list.get(position).getRoadmapName());

        } catch (Exception e) {
            e.printStackTrace();
        }

        return convertView;
    }

    static class ViewHolder{
        TextView tv_roadmapname;
    }
}