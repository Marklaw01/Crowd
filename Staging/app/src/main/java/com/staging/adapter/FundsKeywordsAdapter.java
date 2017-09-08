package com.staging.adapter;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CheckedTextView;
import android.widget.Filter;
import android.widget.Filterable;

import com.staging.R;
import com.staging.models.GenericObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 2/11/2016.
 */
public class FundsKeywordsAdapter extends BaseAdapter implements Filterable {

    private ValueFilter valueFilter;
    ArrayList<GenericObject> mStringFilterList = new ArrayList<GenericObject>();
    private boolean[] thumbnailsselection;
    private LayoutInflater l_Inflater;
    ArrayList<GenericObject> playListMap;
    boolean status;
    int pos = 0;
    View convertView1;
    Context context;
    //int count = 0;


    public FundsKeywordsAdapter(Context context, int textViewResourceId, ArrayList<GenericObject> playListMap,int count) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.playListMap = playListMap;
        mStringFilterList=new ArrayList<GenericObject>();
        mStringFilterList.addAll(playListMap);
        //mStringFilterList = playListMap;
       // count = playListMap.size();
        thumbnailsselection = new boolean[count];
        for (int i=0;i<count;i++) {
            thumbnailsselection[i]=playListMap.get(i).ischecked();
        }


    }

    public ArrayList<GenericObject> getCheckedItems() {
        ArrayList<GenericObject> mTempArry = new ArrayList<GenericObject>();
        for (int i = 0; i < playListMap.size(); i++) {
            if (playListMap.get(i).ischecked()) {
                mTempArry.add(playListMap.get(i));
            }
        }
        return mTempArry;
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

    public String getItemName(int position) {
        return playListMap.get(position).getTitle();
    }

    public String getId(int position) {
        return playListMap.get(position).getId();
    }


    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {

        ViewHolder holder;
        convertView1 = convertView;

        if (convertView == null) {
            convertView = l_Inflater.inflate(R.layout.funds_keywords_row_item, null);
            holder = new ViewHolder();
            holder.Title = (CheckBox) convertView.findViewById(R.id.text);
          //  holder.Title.setChecked(playListMap.get(position).ischecked());


            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }


        holder.Title.setTag(playListMap.get(position).getPosition());
        try {
            //holder.Title.setId(position);

            holder.Title.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    CheckBox cb = (CheckBox) v;
                    int id = (int) cb.getTag();
                    Log.d("id coming",id+"");
                    thumbnailsselection[id] = cb.isChecked();

                }
            });
            holder.Title.setText(playListMap.get(position).getTitle());
            holder.Title.setChecked(thumbnailsselection[position]);


        } catch (Exception e) {

            e.printStackTrace();
        }

        return convertView;
    }

    static class ViewHolder {

        CheckBox Title;
    }


    public boolean[] getcheckedlist()
    {
        return thumbnailsselection;
    }

    @Override
    public Filter getFilter() {
        if (valueFilter == null) {
            valueFilter = new ValueFilter();
        }
        return valueFilter;
    }


    private class ValueFilter extends Filter {

        @Override
        protected FilterResults performFiltering(CharSequence constraint) {

            FilterResults results = new FilterResults();

            try {


                    ArrayList<GenericObject> filterList = new ArrayList<GenericObject>();

                    for (int i = 0; i < mStringFilterList.size(); i++) {

                        if (mStringFilterList.get(i).getTitle().toLowerCase().startsWith(constraint.toString())) {
                          //  mStringFilterList.get(i).setIschecked(thumbnailsselection[i]);
                            filterList.add(mStringFilterList.get(i));
                        }
                    }
                    results.count = filterList.size();
                    results.values = filterList;

            } catch (Exception e) {
                e.printStackTrace();
            }
            return results;
        }


        //Invoked in the UI thread to publish the filtering results in the user interface.
        @SuppressWarnings("unchecked")
        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {

            playListMap = (ArrayList<GenericObject>) results.values;

            notifyDataSetChanged();
        }
    }
}

