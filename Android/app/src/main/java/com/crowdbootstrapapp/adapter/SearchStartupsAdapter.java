package com.crowdbootstrapapp.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.models.CurrentStartUpObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/13/2016.
 */
public class SearchStartupsAdapter extends BaseAdapter {

    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<CurrentStartUpObject> list;

    public SearchStartupsAdapter(Context context, ArrayList<CurrentStartUpObject> list) {
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
            convertView = l_Inflater.inflate(R.layout.search_startup_row_item, null);
            holder = new ViewHolder();

            holder.tv_startupname = (TextView) convertView.findViewById(R.id.tv_startupname);
            holder.tv_enterpreneurName = (TextView) convertView.findViewById(R.id.tv_enterpreneurName);
            holder.tv_startupDescription = (TextView) convertView.findViewById(R.id.tv_startupDescription);
            holder.arrow = (TextView) convertView.findViewById(R.id.arrow);

            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.tv_startupname.setText(list.get(position).getStartUpName());
            holder.tv_enterpreneurName.setText(list.get(position).getEntrenprenuerName());
            holder.tv_startupDescription.setText(list.get(position).getStartUpDiscription());


        } catch (Exception e) {

            e.printStackTrace();
        }

        return convertView;
    }

    static class ViewHolder {
        TextView tv_startupname, tv_enterpreneurName, tv_startupDescription, arrow;
    }
}
