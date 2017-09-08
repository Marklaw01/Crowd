package com.staging.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.staging.R;
import com.staging.models.RoadMapObject;
import com.staging.models.UserExperienceObject;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 12/12/2016.
 */
public class UserExperienceAdapter extends BaseAdapter {

    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<UserExperienceObject> list;

    public UserExperienceAdapter(Context context, ArrayList<UserExperienceObject> list){
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
            convertView = l_Inflater.inflate(R.layout.userexperience_rowitem, null);
            holder = new ViewHolder();

            holder.tv_jobtitle = (TextView) convertView.findViewById(R.id.tv_jobtitle);
            holder.tv_company_url = (TextView) convertView.findViewById(R.id.tv_companyurl);
            holder.tv_timeperiod = (TextView) convertView.findViewById(R.id.tv_timeperiod);
            convertView.setTag(holder);
        }else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.tv_jobtitle.setText(list.get(position).getJobTitle());
            holder.tv_company_url.setText(list.get(position).getCompanyURL());
            holder.tv_timeperiod.setText(list.get(position).getStartDAte()+" to "+list.get(position).getEndDate());


        } catch (Exception e) {
            e.printStackTrace();
        }

        return convertView;
    }

    static class ViewHolder{
        TextView tv_jobtitle;
        TextView tv_company_url;
        TextView tv_timeperiod;
    }
}