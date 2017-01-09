package com.crowdbootstrapapp.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.models.WorkOrderEntrepreneur;
import com.crowdbootstrapapp.swipelistviewinscrollview.BaseSwipListAdapter;

import java.util.ArrayList;

/**
 * Created by sunakshi.gautam on 2/8/2016.
 */
public class WorkOrderAdapter extends BaseSwipListAdapter {

    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<WorkOrderEntrepreneur> list;

    public WorkOrderAdapter(Context context, ArrayList<WorkOrderEntrepreneur> list) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
    }

    @Override
    public int getCount() {
        return list.size();
    }

    @Override
    public WorkOrderEntrepreneur getItem(int position) {
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
            convertView = l_Inflater.inflate(R.layout.workorder_listitem, null);
            holder = new ViewHolder();

            holder.contractorname = (TextView) convertView.findViewById(R.id.contractornameentrepreneur);
            holder.dateentered = (TextView) convertView.findViewById(R.id.datetext);
            holder.roadmap_name = (TextView) convertView.findViewById(R.id.workRoadmap);
            holder.workunit = (TextView) convertView.findViewById(R.id.workunittext);


            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.contractorname.setText(list.get(position).getContractorName());
            holder.dateentered.setText(list.get(position).getDateEntered());
            holder.roadmap_name.setText(list.get(position).getRoadmap_name());
            holder.workunit.setText(list.get(position).getWorkUnitEntered());

        } catch (Exception e) {
            e.printStackTrace();
        }
        return convertView;
    }

    static class ViewHolder {
        TextView contractorname;
        TextView dateentered;
        TextView workunit;
        TextView roadmap_name;
    }

    @Override
    public boolean getSwipEnableByPosition(int position) {
        return true;
    }

}
