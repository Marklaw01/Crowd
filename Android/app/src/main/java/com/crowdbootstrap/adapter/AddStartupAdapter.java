package com.crowdbootstrap.adapter;

import android.content.Context;
import android.util.SparseBooleanArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.TextView;

import com.crowdbootstrap.R;
import com.crowdbootstrap.models.GenericObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 2/11/2016.
 */
public class AddStartupAdapter extends BaseAdapter {

    private boolean[] thumbnailsselection;
    // GenericObject cObj = new GenericObject();
    private LayoutInflater l_Inflater;
    ArrayList<GenericObject> playListMap;
    boolean status;
    int pos = 0;
    View convertView1;
    Context context;
    SparseBooleanArray mSparseBooleanArray;
    int count = 0;

    public AddStartupAdapter(Context context, ArrayList<GenericObject> playListMap) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.playListMap = playListMap;
        mSparseBooleanArray = new SparseBooleanArray();
        count = playListMap.size();
        thumbnailsselection = new boolean[count];

        for (int i=0; i<playListMap.size();i++){
            thumbnailsselection[i] = playListMap.get(i).ischecked();
        }
   }

    @Override
    public GenericObject getItem(int position) {
        return playListMap.get(position);
    }

    public int getCount() {
        return playListMap.size();
    }

    public long getItemId(int position) {
        return position;
    }


    public String getId(int position) {
        return playListMap.get(position).getId();
    }

    public ArrayList<GenericObject> getCheckedItems() {
        ArrayList<GenericObject> mTempArry = new ArrayList<GenericObject>();
        for (int i = 0; i < playListMap.size(); i++) {
            if (thumbnailsselection[i]) {
                mTempArry.add(playListMap.get(i));
            }
        }
        return mTempArry;
    }


    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {

        final ViewHolder holder;
        convertView1 = convertView;
        try {
            if (convertView == null) {
                convertView = l_Inflater.inflate(R.layout.add_startup_row_item, null);
                holder = new ViewHolder();
                holder.checkbox = (CheckBox) convertView.findViewById(R.id.checkbox);
                holder.checkbox.setChecked(false);
                holder.tv_StartupName = (TextView) convertView.findViewById(R.id.tv_StartupName);
                holder.tv_forumDescription = (TextView) convertView.findViewById(R.id.tv_forumDescription);

                convertView.setTag(holder);

            } else {
                holder = (ViewHolder) convertView.getTag();
            }


            try {
                holder.checkbox.setId(position);
                holder.checkbox.setOnClickListener(new View.OnClickListener() {
                    public void onClick(View v) {
                        CheckBox cb = (CheckBox) v;
                        int id = cb.getId();
                        if (thumbnailsselection[id]) {
                            cb.setChecked(false);
                            thumbnailsselection[id] = false;
                        } else {
                            cb.setChecked(true);
                            thumbnailsselection[id] = true;
                        }
                    }
                });
                holder.checkbox.setChecked(thumbnailsselection[position]);
                holder.tv_forumDescription.setText(playListMap.get(position).getAnswer());
                holder.tv_StartupName.setText(playListMap.get(position).getTitle());

            } catch (Exception e) {

                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return convertView;
    }

    static class ViewHolder {
        TextView tv_StartupName, tv_forumDescription;
        CheckBox checkbox;
    }
}