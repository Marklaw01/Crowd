package com.crowdbootstrap.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.crowdbootstrap.R;
import com.crowdbootstrap.models.SuggestKeywords;
import com.crowdbootstrap.swipelistviewinscrollview.BaseSwipListAdapter;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 11/15/2016.
 */
public class UserSuggestedKeywordsAdapter  extends BaseSwipListAdapter {

    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<SuggestKeywords> list;

    public UserSuggestedKeywordsAdapter(Context context, ArrayList<SuggestKeywords> list) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
    }

    @Override
    public int getCount() {
        return list.size();
    }

    @Override
    public SuggestKeywords getItem(int position) {
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
            convertView = l_Inflater.inflate(R.layout.suggest_keyword_listitem, null);
            holder = new ViewHolder();

            holder.keywordName = (TextView) convertView.findViewById(R.id.namelnl);
            holder.keywordType = (TextView) convertView.findViewById(R.id.typelbl);
            holder.keywordStatus = (TextView) convertView.findViewById(R.id.statuslbl);



            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.keywordName.setText(list.get(position).getKeywordName());
            holder.keywordType.setText(list.get(position).getKeywordType());

            if(list.get(position).getKeywordStatus().compareTo("0") == 0) {
                holder.keywordStatus.setText("Pending");
            }
            else if(list.get(position).getKeywordStatus().compareTo("1") == 0){

                holder.keywordStatus.setText("Accepted");
            }
            else if(list.get(position).getKeywordStatus().compareTo("2") == 0){
                holder.keywordStatus.setText("Not Accepted");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return convertView;
    }

    static class ViewHolder {
        TextView keywordName;
        TextView keywordType;
        TextView keywordStatus;
        TextView random;

    }

    @Override
    public boolean getSwipEnableByPosition(int position) {
        return true;
    }

}
