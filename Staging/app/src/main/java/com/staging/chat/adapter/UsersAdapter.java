package com.staging.chat.adapter;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.TextView;

import com.staging.R;
import com.staging.helper.CircleImageView;
import com.staging.utilities.PrefManager;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.quickblox.users.model.QBUser;

import java.util.List;

public class UsersAdapter extends BaseListAdapter<QBUser> {

    public DisplayImageOptions options;
    public UsersAdapter(Context context, List<QBUser> users) {
        super(context, users);
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
    public View getView(int position, View convertView, ViewGroup parent) {
        QBUser user = getItem(position);
        Log.e("user", user.getEmail());
        ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.list_item_user, parent, false);
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
            if (isUserMe(user)) {
                holder.loginTextView.setText(user.getLogin());
            } else {
                holder.loginTextView.setText(user.getLogin());
            }

            ImageLoader.getInstance().displayImage("", holder.userImageView, options);
            long currentTime = System.currentTimeMillis();
            if (user.getLastRequestAt()!=null){
                long userLastRequestAtTime = user.getLastRequestAt().getTime();

                // if user didn't do anything last 5 minutes (5*60*1000 milliseconds)
                if((currentTime - userLastRequestAtTime) > 5*60*1000){
                    holder.text_user_status.setText("Offline");
                }else {
                    holder.text_user_status.setText("Online");
                }
            }else{
                holder.text_user_status.setText("Offline");
            }

            if (isAvailableForSelection(user)) {
                holder.loginTextView.setTextColor(context.getResources().getColor(R.color.textColor));
            } else {
                holder.loginTextView.setTextColor(context.getResources().getColor(R.color.textColor));
            }

            //holder.userImageView.setBackgroundDrawable(UiUtils.getColorCircleDrawable(position));
            holder.userCheckBox.setVisibility(View.GONE);
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        }

        return convertView;
    }

    protected boolean isUserMe(QBUser user) {
        QBUser currentUser = PrefManager.getInstance(context).getQbUser();
        return currentUser != null && currentUser.getId().equals(user.getId());
    }

    protected boolean isAvailableForSelection(QBUser user) {
        QBUser currentUser = PrefManager.getInstance(context).getQbUser();
        return currentUser == null || !currentUser.getId().equals(user.getId());
    }

    protected static class ViewHolder {
        CircleImageView userImageView;
        TextView loginTextView, text_user_status;
        CheckBox userCheckBox;
    }
}
