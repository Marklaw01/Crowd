package com.staging.adapter;

import android.content.Context;
import android.graphics.Bitmap;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.TextView;

import com.staging.R;
import com.staging.helper.CircleImageView;
import com.staging.models.ContactsObject;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 2/19/2016.
 */
public class ContactsAdapter extends BaseAdapter {

    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<ContactsObject> list;
    public DisplayImageOptions options;

    public ContactsAdapter(Context context, ArrayList<ContactsObject> list) {
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
    public ContactsObject getItem(int position) {
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
            convertView = l_Inflater.inflate(R.layout.list_item_user, parent, false);
            holder = new ViewHolder();
            holder.userImageView = (CircleImageView) convertView.findViewById(R.id.image_user);
            holder.loginTextView = (TextView) convertView.findViewById(R.id.text_user_login);
            holder.text_user_status = (TextView) convertView.findViewById(R.id.text_user_status);
            holder.userCheckBox = (CheckBox) convertView.findViewById(R.id.checkbox_user);
            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.loginTextView.setText(list.get(position).getName());
           // holder.tv_status.setText(list.get(position).getStatus());
            holder.text_user_status.setVisibility(View.GONE);
            ImageLoader.getInstance().displayImage(list.get(position).getImage(), holder.userImageView, options);
            holder.userCheckBox.setVisibility(View.GONE);
        } catch (Exception e) {
            e.printStackTrace();
        }


        return convertView;
    }

    static class ViewHolder {
        CircleImageView userImageView;
        TextView loginTextView, text_user_status;
        CheckBox userCheckBox;
    }
}
