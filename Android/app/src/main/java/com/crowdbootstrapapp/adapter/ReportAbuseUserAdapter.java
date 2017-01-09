package com.crowdbootstrapapp.adapter;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.SparseBooleanArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.helper.CircleImageView;
import com.crowdbootstrapapp.models.GenericObject;
import com.crowdbootstrapapp.models.UserCommentObject;
import com.crowdbootstrapapp.utilities.Constants;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 2/11/2016.
 */
public class ReportAbuseUserAdapter extends BaseAdapter {

    public DisplayImageOptions options;
    private boolean[] thumbnailsselection;
    GenericObject cObj = new GenericObject();
    private LayoutInflater l_Inflater;
    ArrayList<UserCommentObject> playListMap;
    boolean status;
    int pos = 0;
    View convertView1;
    Context context;
    SparseBooleanArray mSparseBooleanArray;
    int count = 0;

    public ReportAbuseUserAdapter(Context context, int textViewResourceId, ArrayList<UserCommentObject> playListMap) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.playListMap = playListMap;
        mSparseBooleanArray = new SparseBooleanArray();
        count = playListMap.size();
        thumbnailsselection = new boolean[count];
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
    public UserCommentObject getItem(int position) {
        return playListMap.get(position);
    }

    public int getCount() {
        return playListMap.size();
    }

    public long getItemId(int position) {
        return position;
    }

    public String getItemName(int position) {
        return playListMap.get(position).getUserName();
    }

    public String getId(int position) {
        return playListMap.get(position).getId();
    }

    public ArrayList<UserCommentObject> getCheckedItems() {
        ArrayList<UserCommentObject> mTempArry = new ArrayList<UserCommentObject>();
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

        if (convertView == null) {
            convertView = l_Inflater.inflate(R.layout.report_abuse_row_item, null);
            holder = new ViewHolder();
            holder.img_contractorImage = (CircleImageView)convertView.findViewById(R.id.img_contractorImage);
            holder.Title = (CheckBox) convertView.findViewById(R.id.text);
            holder.Title.setChecked(false);
            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        try {

            holder.Title.setId(position);
            holder.Title.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {
                    // TODO Auto-generated method stub
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
            holder.Title.setText(playListMap.get(position).getUserName());
            holder.Title.setChecked(thumbnailsselection[position]);
            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + playListMap.get(position).getUserImage(), holder.img_contractorImage, options);

        } catch (Exception e) {

            e.printStackTrace();
        }

        return convertView;
    }

    static class ViewHolder {
        CircleImageView img_contractorImage;
        CheckBox Title;
    }
}