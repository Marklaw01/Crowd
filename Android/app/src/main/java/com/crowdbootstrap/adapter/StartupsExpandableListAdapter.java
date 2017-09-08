package com.crowdbootstrap.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.TextView;

import com.crowdbootstrap.R;
import com.crowdbootstrap.models.StartupItemsObject;
import com.crowdbootstrap.models.StartupsObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 2/4/2016.
 */
public class StartupsExpandableListAdapter extends BaseExpandableListAdapter {
    private Context _context;
    //private List<String> _listDataHeader; // header titles
    // child data in format of header title, child title
    private ArrayList<StartupsObject> startupsObjectArrayList;

    public StartupsExpandableListAdapter(Context context, ArrayList<StartupsObject> startupsObjectArrayList) {
        this._context = context;
        this.startupsObjectArrayList = startupsObjectArrayList;
        //this._listDataChild = listChildData;
    }

    @Override
    public StartupItemsObject getChild(int groupPosition, int childPosititon) {
        return startupsObjectArrayList.get(groupPosition).getItemsObjectArrayList().get(childPosititon);
        //return this.startupsObjectArrayList.get(startupsObjectArrayList.get(groupPosition).getItemsObjectArrayList().get(childPosititon));
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        return childPosition;
    }

    @Override
    public View getChildView(int groupPosition, final int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {

        //final String childText = (String) getChild(groupPosition, childPosition);

        if (convertView == null) {
            LayoutInflater infalInflater = (LayoutInflater) this._context
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = infalInflater.inflate(R.layout.list_child, null);
        }

        try {
            TextView txtListChild = (TextView) convertView .findViewById(R.id.lblListItem);

            StartupItemsObject obj = getChild(groupPosition, childPosition);
            txtListChild.setText(obj.getStartupItemName());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return convertView;
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return startupsObjectArrayList.get(groupPosition).getItemsObjectArrayList().size();
    }

    @Override
    public StartupsObject getGroup(int groupPosition) {
        return startupsObjectArrayList.get(groupPosition);
    }

    @Override
    public int getGroupCount() {
        return startupsObjectArrayList.size();
    }

    @Override
    public long getGroupId(int groupPosition) {
        return groupPosition;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        //String headerTitle = getGroup(groupPosition);
        if (convertView == null) {
            LayoutInflater infalInflater = (LayoutInflater) this._context
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = infalInflater.inflate(R.layout.list_group_header, null);
        }

        try {
            TextView lblListHeader = (TextView) convertView.findViewById(R.id.lblListHeader);
            StartupsObject obj = getGroup(groupPosition);
            lblListHeader.setText(obj.getStartupName());
        } catch (Exception e) {
            e.printStackTrace();
        }

        return convertView;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return true;
    }
}
