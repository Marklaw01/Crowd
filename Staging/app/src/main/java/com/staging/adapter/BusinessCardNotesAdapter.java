package com.staging.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.staging.R;
import com.staging.models.NotificationObject;
import com.staging.swipelistviewinscrollview.BaseSwipListAdapter;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 11/30/2017.
 */

public class BusinessCardNotesAdapter extends BaseSwipListAdapter {

    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<NotificationObject> list;

    public BusinessCardNotesAdapter(Context context, ArrayList<NotificationObject> list){
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
        MessagesAdapter.ViewHolder holder;
        if (convertView == null) {
            convertView = l_Inflater.inflate(R.layout.archieve_notifications_row_item, null);
            holder = new MessagesAdapter.ViewHolder();

            holder.tv_notifications = (TextView) convertView.findViewById(R.id.tv_notification);
            holder.tv_sender = (TextView) convertView.findViewById(R.id.tv_sender);
            holder.tv_date = (TextView) convertView.findViewById(R.id.tv_date);
            holder.tv_forumDescription = (TextView) convertView.findViewById(R.id.tv_notificationDetails);
            holder.tv_CreatedTime = (TextView) convertView.findViewById(R.id.tv_notificationCreatedTime);
            convertView.setTag(holder);
        }else {
            holder = (MessagesAdapter.ViewHolder) convertView.getTag();
        }
        try {
            holder.tv_notifications.setText(list.get(position).getName());
            holder.tv_forumDescription.setText(list.get(position).getDescriptoin());
            holder.tv_CreatedTime.setVisibility(View.GONE);
            holder.tv_date.setVisibility(View.GONE);
            holder.tv_sender.setVisibility(View.GONE);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return convertView;
    }

    static class ViewHolder{
        TextView tv_notifications, tv_forumDescription, tv_CreatedTime, tv_sender, tv_date;
    }

    @Override
    public boolean getSwipEnableByPosition(int position) {
        return true;
    }
}