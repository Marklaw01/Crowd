package com.staging.adapter;

import android.content.Context;
import android.graphics.Bitmap;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.staging.R;
import com.staging.helper.CircleImageView;
import com.staging.models.UserCommentObject;
import com.staging.swipelistviewinscrollview.BaseSwipListAdapter;
import com.staging.utilities.Constants;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.listener.SimpleImageLoadingListener;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/19/2016.
 */
public class CommentsAdapter extends BaseSwipListAdapter {
    public DisplayImageOptions options;
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<UserCommentObject> list;

    public CommentsAdapter(Context context, ArrayList<UserCommentObject> list) {
        l_Inflater = LayoutInflater.from(context);
        System.out.println(context);
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
    public View getView(int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = l_Inflater.inflate(R.layout.comments_row_item, null);
            holder = new ViewHolder();

            holder.tv_notifications = (TextView) convertView.findViewById(R.id.tv_notification);
            holder.progressbar = (ProgressBar)convertView.findViewById(R.id.progressbar);
            holder.image_forum = (CircleImageView) convertView.findViewById(R.id.image_forum);
            holder.tv_forumDescription = (TextView) convertView.findViewById(R.id.tv_notificationDetails);
            holder.tv_CreatedTime = (TextView) convertView.findViewById(R.id.tv_notificationCreatedTime);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.tv_notifications.setText(list.get(position).getUserName());
            holder.tv_forumDescription.setText(list.get(position).getCommentText());
            holder.tv_CreatedTime.setText(list.get(position).getCreatedTime());
            //ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + list.get(position).getUserImage(), holder.image_forum, options);


            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + list.get(position).getUserImage(), holder.image_forum, options, new SimpleImageLoadingListener(){
                @Override
                public void onLoadingStarted(String imageUri, View view) {
                    holder.progressbar.setVisibility(View.VISIBLE);
                }

                @Override
                public void onLoadingFailed(String imageUri, View view, FailReason failReason) {
                    holder.progressbar.setVisibility(View.GONE);
                }

                @Override
                public void onLoadingComplete(String imageUri, View view, Bitmap loadedImage) {
                    holder.progressbar.setVisibility(View.GONE);
                }

                @Override
                public void onLoadingCancelled(String imageUri, View view) {
                    holder.progressbar.setVisibility(View.GONE);
                }

            });


        } catch (Exception e) {
            e.printStackTrace();
        }

        return convertView;
    }

    static class ViewHolder {
        CircleImageView image_forum;
        ProgressBar progressbar;
        TextView tv_notifications, tv_forumDescription, tv_CreatedTime;
    }

    @Override
    public boolean getSwipEnableByPosition(int position) {
        return true;
    }
}