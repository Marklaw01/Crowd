package com.crowdbootstrapapp.adapter;

import android.content.Context;
import android.graphics.Bitmap;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.helper.CircleImageView;

/**
 * Created by Neelmani.Karn on 1/11/2017.
 */
public class LikesDislikesAdapter extends BaseAdapter {

    public DisplayImageOptions options;
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;

    private static int pos = 0;

    public LikesDislikesAdapter(Context context/*, ArrayList<JobListObject> list*/) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.image)
                .showImageForEmptyUri(R.drawable.image)
                .showImageOnFail(R.drawable.image)
                .cacheInMemory(true)
                .cacheOnDisk(true)
                .considerExifParams(true)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();
    }

    @Override
    public int getCount() {
        return 50;
    }

    @Override
    public Object getItem(int position) {
        return new Object();
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {

        ViewHolder holder;
        convertView1 = convertView;

        if (convertView == null) {
            convertView = l_Inflater.inflate(R.layout.likes_dislikes_row_item, null);
            holder = new ViewHolder();
            holder.fundTitle = (TextView) convertView.findViewById(R.id.fundTitle);
            holder.fundDescription = (TextView) convertView.findViewById(R.id.fundDescription);


            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }


        return convertView;
    }


    static class ViewHolder {
        TextView fundTitle, fundDescription;
        CircleImageView fund_icon;
    }
}