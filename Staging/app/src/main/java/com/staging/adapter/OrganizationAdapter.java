package com.staging.adapter;

import android.content.Context;
import android.graphics.Bitmap;
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
import com.staging.models.OrganizationObject;
import com.staging.utilities.Constants;

import java.util.ArrayList;

/**
 * Created by sunakshi.gautam on 11/22/2016.
 */
public class OrganizationAdapter extends BaseAdapter implements Filterable {

    public DisplayImageOptions options;
    private ValueFilter valueFilter;
    ArrayList<OrganizationObject> mStringFilterList = new ArrayList<OrganizationObject>();
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<OrganizationObject> list;
    public static String recievingContractorID;
    public static String recievingContractorName;

    public OrganizationAdapter(Context context, ArrayList<OrganizationObject> list) {
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
    public View getView(final int position, View convertView, ViewGroup parent) {

        ViewHolder holder;
        convertView1 = convertView;

        if (convertView == null) {
            convertView = l_Inflater.inflate(R.layout.organization_item_layout, null);
            holder = new ViewHolder();
            holder.tv_ContractorName = (TextView) convertView.findViewById(R.id.tv_ContractorName);
            holder.tv_ContractorDescription = (TextView) convertView.findViewById(R.id.tv_ContractorDescription);
            holder.img_contractorImage = (ImageView) convertView.findViewById(R.id.img_contractorImage);

            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.tv_ContractorName.setText(list.get(position).getCompanyName());
            holder.tv_ContractorDescription.setText(list.get(position).getCompanyDescription());

            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + list.get(position).getCompanyImage(), holder.img_contractorImage, options);


        } catch (Exception e) {

            e.printStackTrace();
        }

        return convertView;
    }

    static class ViewHolder {
        TextView tv_ContractorName, tv_ContractorDescription;
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

                ArrayList<OrganizationObject> filterList = new ArrayList<OrganizationObject>();

                for (int i = 0; i < mStringFilterList.size(); i++) {

                    if (mStringFilterList.get(i).getCompanySkills().toLowerCase().startsWith(constraint.toString())) {
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

            list = (ArrayList<OrganizationObject>) results.values;
            notifyDataSetChanged();
        }
    }
}
