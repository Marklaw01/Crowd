package com.staging.adapter;

import android.content.Context;
import android.graphics.Bitmap;
import android.media.Image;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.TextView;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.staging.R;
import com.staging.models.ContractorsObject;
import com.staging.models.JobListObject;
import com.staging.utilities.Constants;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 11/30/2016.
 */
public class JobListAdapter extends BaseAdapter implements Filterable {

    public DisplayImageOptions options;
    private ValueFilter valueFilter;
    ArrayList<JobListObject> mStringFilterList = new ArrayList<JobListObject>();
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<JobListObject> list;

    public JobListAdapter(Context context, ArrayList<JobListObject> list) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
        mStringFilterList = list;


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

        ViewHolder holder;
        convertView1 = convertView;

        if (convertView == null) {
            convertView = l_Inflater.inflate(R.layout.joblist_item_layout, null);
            holder = new ViewHolder();
            holder.tv_ContractorName = (TextView) convertView.findViewById(R.id.tv_ContractorName);
            holder.tv_postedon = (TextView) convertView.findViewById(R.id.tv_postedon);
            holder.tv_location = (TextView) convertView.findViewById(R.id.tv_location);
            holder.img_contractorImage = (ImageView) convertView.findViewById(R.id.img_contractorImage);
            holder.tv_following = (TextView) convertView.findViewById(R.id.tv_following);

            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.tv_ContractorName.setText(list.get(position).getJobTitle());
            holder.tv_postedon.setText(list.get(position).getPostedOn());
            holder.tv_location.setText(list.get(position).getCompanyName() + ", " + list.get(position).getJobState() + ", " + list.get(position).getJobCountry());
            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + list.get(position).getCompanyLogoImage(), holder.img_contractorImage, options);

            if (Integer.parseInt(list.get(position).getFollowersCount()) > 1) {
                holder.tv_following.setText(list.get(position).getFollowersCount() + " Followers");
            } else {
                holder.tv_following.setText(list.get(position).getFollowersCount() + " Follower");
            }
        } catch (Exception e) {

            e.printStackTrace();
        }

        return convertView;
    }

    static class ViewHolder {
        TextView tv_ContractorName, tv_postedon, tv_location, tv_following;
        ImageView img_contractorImage;

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

            if (constraint != null && constraint.length() > 0) {

                ArrayList<JobListObject> filterList = new ArrayList<JobListObject>();

                for (int i = 0; i < mStringFilterList.size(); i++) {

                    if (mStringFilterList.get(i).getJobSkills().toLowerCase().startsWith(constraint.toString())) {
                        filterList.add(mStringFilterList.get(i));
                    }
                }
                results.count = filterList.size();
                results.values = filterList;
            } else {
                results.count = mStringFilterList.size();
                results.values = mStringFilterList;
            }
            return results;
        }


        //Invoked in the UI thread to publish the filtering results in the user interface.
        @SuppressWarnings("unchecked")
        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {

            list = (ArrayList<JobListObject>) results.values;
            notifyDataSetChanged();
        }
    }
}
