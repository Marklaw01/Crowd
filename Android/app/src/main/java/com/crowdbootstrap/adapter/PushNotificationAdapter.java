package com.crowdbootstrap.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.crowdbootstrap.R;
import com.crowdbootstrap.models.PushNotificationObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 2/8/2016.
 */
public class PushNotificationAdapter extends BaseAdapter {

    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<PushNotificationObject> list;

    public PushNotificationAdapter(Context context, ArrayList<PushNotificationObject> list) {
        l_Inflater = LayoutInflater.from(context);
        System.out.println(context);
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
            convertView = l_Inflater.inflate(R.layout.push_notification_row_item, null);
            holder = new ViewHolder();

            holder.tv_notificationDetails = (TextView) convertView.findViewById(R.id.tv_notificationDetails);
            holder.tv_notificationCreatedTime = (TextView) convertView.findViewById(R.id.tv_notificationCreatedTime);

            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.tv_notificationDetails.setText(list.get(position).getNotificationTitle());
            holder.tv_notificationCreatedTime.setText(list.get(position).getNotificationTime());
        } catch (Exception e) {
            e.printStackTrace();
        }

        return convertView;
    }

    static class ViewHolder {
        TextView tv_notificationDetails, tv_notificationCreatedTime;
    }
}