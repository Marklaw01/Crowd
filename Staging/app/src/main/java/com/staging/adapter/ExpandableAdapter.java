package com.staging.adapter;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.staging.R;
import com.staging.models.NavDrawerItem;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by sunakshi.gautam on 2/23/2016.
 */
public class ExpandableAdapter  extends BaseExpandableListAdapter {

    private Context context;
    private List<NavDrawerItem> mainElements;
    private HashMap<Integer, ArrayList<NavDrawerItem>> childElements = new HashMap<>(); ;
    private LayoutInflater vi;

    public ExpandableAdapter(Context context, List<NavDrawerItem> mainElements, HashMap<Integer,ArrayList<NavDrawerItem>> childElements) {
        this.context = context;
        this.mainElements = mainElements;
        this.childElements = childElements;
        vi = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getGroupCount() {
        return this.mainElements.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        if (this.childElements.get(groupPosition) == null)
            return 0;
        return this.childElements.get(groupPosition).size();
    }

    @Override
    public Object getGroup(int groupPosition) {
        return this.mainElements.get(groupPosition);
    }

    @Override
    public Object getChild(int groupPosition, int childPosition) {
        return this.childElements.get(groupPosition).get(childPosition);
    }

    @Override
    public long getGroupId(int groupPosition) {
        return groupPosition;
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        return childPosition;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        View v = convertView;

        try {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();

            v = inflater.inflate(R.layout.drawer_list_item, parent, false);

            ImageView imageView = (ImageView) v.findViewById(R.id.navimage);
            TextView textView = (TextView) v.findViewById(R.id.navtext);

            NavDrawerItem choice = mainElements.get(groupPosition);

            imageView.setImageResource(choice.icon);
            textView.setText(choice.name);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return v;
    }

    @Override
    public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {

        View v = convertView;

        try {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();

            if(groupPosition == 5){
                v = inflater.inflate(R.layout.navigation_child_item_dummy, parent, false);
            }
            else if(groupPosition == 6){
                v = inflater.inflate(R.layout.navigation_child_item_dummy, parent, false);
            }
            else if(groupPosition == 7){
                if(childPosition == 7){
                    v = inflater.inflate(R.layout.navigation_child_item, parent, false);
                }
                else if(childPosition == 8){
                    v = inflater.inflate(R.layout.navigation_child_item, parent, false);
                }
                else
                {
                    v = inflater.inflate(R.layout.navigation_child_item_dummy, parent, false);
                }
            }
            else if(groupPosition == 4){

                if(childPosition == 5){
                    v = inflater.inflate(R.layout.navigation_child_item_dummy, parent, false);
                }
                else
                {
                    v = inflater.inflate(R.layout.navigation_child_item, parent, false);
                }
            }
            else {
                v = inflater.inflate(R.layout.navigation_child_item, parent, false);
            }

            ImageView imageView = (ImageView) v.findViewById(R.id.navimage);
            TextView textView = (TextView) v.findViewById(R.id.navtext);



            NavDrawerItem choice =(NavDrawerItem)getChild(groupPosition, childPosition);

            imageView.setImageResource(choice.icon);
            textView.setText(choice.name);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return v;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return true;
    }
}
