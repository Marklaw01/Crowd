package com.crowdbootstrapapp.adapter;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckedTextView;
import android.widget.Filter;
import android.widget.Filterable;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.models.GenericObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 2/11/2016.
 */
public class KeywordsAdapter extends BaseAdapter implements Filterable {

    private ValueFilter valueFilter;
    ArrayList<GenericObject> mStringFilterList = new ArrayList<GenericObject>();
    private boolean[] thumbnailsselection;
    private LayoutInflater l_Inflater;
    ArrayList<GenericObject> playListMap;
    boolean status;
    int pos = 0;
    View convertView1;
    Context context;
    int count = 0;

    public KeywordsAdapter(Context context, int textViewResourceId, ArrayList<GenericObject> playListMap) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.playListMap = playListMap;

        mStringFilterList = playListMap;
        count = playListMap.size();
        thumbnailsselection = new boolean[count];
        /*for (int i=0;i<playListMap.size();i++){
           playListMap.get(i).setIschecked(false);
        }*/
        Log.d("size", playListMap.size()+"");
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
            convertView = l_Inflater.inflate(R.layout.keywords_row_item, null);
            holder = new ViewHolder();
            holder.Title = (CheckedTextView) convertView.findViewById(R.id.text);
            holder.Title.setChecked(false);
           /* holder.Title = (CheckedTextView) convertView.findViewById(R.id.text);
            holder.Title.setCheckMarkDrawable(context.getResources().getDrawable(R.drawable.checkbox_textview));
            holder.Title.setChecked(false);*/
            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }



        try {
            holder.Title.setId(position);

            holder.Title.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    CheckedTextView cb = (CheckedTextView) v;
                    int id = cb.getId();
                    if (playListMap.get(id).ischecked()) {
                        cb.setChecked(false);
                        playListMap.get(position).setIschecked(false);
                        thumbnailsselection[id] = false;
                    } else {
                        cb.setChecked(true);
                        playListMap.get(position).setIschecked(true);
                        thumbnailsselection[id] = true;
                    }
                }
            });
            holder.Title.setText(playListMap.get(position).getTitle());
            holder.Title.setChecked(playListMap.get(position).ischecked());


        } catch (Exception e) {

            e.printStackTrace();
        }

        return convertView;
    }

    static class ViewHolder {

        CheckedTextView Title;
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
                if (constraint != null && constraint.length() > 0) {

                    ArrayList<GenericObject> filterList = new ArrayList<GenericObject>();

                    for (int i = 0; i < mStringFilterList.size(); i++) {

                        if (mStringFilterList.get(i).getTitle().toLowerCase().startsWith(constraint.toString())) {
                            filterList.add(mStringFilterList.get(i));
                        }
                    }
                    results.count = filterList.size();
                    results.values = filterList;
                } else {
                    results.count = mStringFilterList.size();
                    results.values = mStringFilterList;
                }
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