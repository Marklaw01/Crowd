package com.crowdbootstrap.adapter;

import android.content.Context;
import android.graphics.Bitmap;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.crowdbootstrap.R;
import com.crowdbootstrap.helper.CircleImageView;
import com.crowdbootstrap.models.UserObject;
import com.crowdbootstrap.utilities.Constants;

import java.util.ArrayList;

/**
 * Created by Neelmani.Karn on 1/11/2017.
 */
public class LikesDislikesAdapter extends BaseAdapter {

    public DisplayImageOptions options;
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<UserObject> list;

    private static int pos = 0;

    public LikesDislikesAdapter(Context context, ArrayList<UserObject> list) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
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
    public View getView(final int position, View convertView, ViewGroup parent) {

        ViewHolder holder;
        convertView1 = convertView;

        if (convertView == null) {
            convertView = l_Inflater.inflate(R.layout.likes_dislikes_row_item, null);
            holder = new ViewHolder();
            holder.fundTitle = (TextView) convertView.findViewById(R.id.personName);
            holder.fundDescription = (TextView) convertView.findViewById(R.id.aboutMe);
            holder.fund_icon = (CircleImageView) convertView.findViewById(R.id.profileimage);
            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        holder.fundTitle.setText(list.get(position).getName());
        holder.fundDescription.setText(list.get(position).getBio());
        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + list.get(position).getImage(), holder.fund_icon);

        return convertView;
    }


    static class ViewHolder {
        TextView fundTitle, fundDescription;
        CircleImageView fund_icon;
    }
}