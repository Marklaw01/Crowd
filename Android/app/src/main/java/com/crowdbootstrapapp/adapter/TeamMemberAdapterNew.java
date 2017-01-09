package com.crowdbootstrapapp.adapter;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.SectionIndexer;
import android.widget.TextView;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.fragments.SendEmailFragment;
import com.crowdbootstrapapp.fragments.SendMessageFragment;
import com.crowdbootstrapapp.models.TeamMemberObject;
import com.crowdbootstrapapp.utilities.Constants;
import com.crowdbootstrapapp.utilities.PrefManager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import se.emilsjolander.stickylistheaders.StickyListHeadersAdapter;

/**
 * Created by sunakshi.gautam on 1/22/2016.
 */
public class TeamMemberAdapterNew extends BaseAdapter implements Filterable, StickyListHeadersAdapter, SectionIndexer {

    private ValueFilter valueFilter;
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<TeamMemberObject> list;
    ArrayList<TeamMemberObject> mStringFilterList = new ArrayList<TeamMemberObject>();
    private PrefManager prefManager;
    private int[] mSectionIndices;
    private String[] mSectionLetters;


    public TeamMemberAdapterNew(Context context, ArrayList<TeamMemberObject> list) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
        mStringFilterList = list;
        prefManager = PrefManager.getInstance(context);

        Collections.sort(list, new Comparator<TeamMemberObject>() {
            public int compare(TeamMemberObject s1, TeamMemberObject s2) {
                return s1.getMemberRoleId().compareToIgnoreCase(s2.getMemberRoleId());
            }
        });
        if (list.size()==0){

        }else{
            mSectionIndices = getSectionIndices();
            mSectionLetters = getSectionLetters();
        }
    }


    private int[] getSectionIndices() {
        ArrayList<Integer> sectionIndices = new ArrayList<Integer>();
        String lastFirstChar = list.get(0).getMemberDesignation();
        sectionIndices.add(0);

        for (int i = 1; i < list.size(); i++) {
            if (list.get(i).getMemberDesignation() != lastFirstChar) {
                lastFirstChar = list.get(i).getMemberDesignation();
                sectionIndices.add(i);
            }
        }
        int[] sections = new int[sectionIndices.size()];
        for (int i = 0; i < sectionIndices.size(); i++) {
            sections[i] = sectionIndices.get(i);
        }
        return sections;
    }

    private String[] getSectionLetters() {
        String[] letters = new String[mSectionIndices.length];
        for (int i = 0; i < mSectionIndices.length; i++) {
            letters[i] = list.get(i).getMemberDesignation();
        }
        return letters;
    }



    @Override
    public int getCount() {
        return list.size();
    }

    @Override
    public TeamMemberObject getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public int getViewTypeCount() {
        // menu type count
        return 2;
    }

    @Override
    public int getItemViewType(int position) {
        // current menu type
        return list.get(position).getMemberStatus();
    }


    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        convertView1 = convertView;

        if (convertView == null) {
            convertView = l_Inflater.inflate(R.layout.team_list_item, null);
            holder = new ViewHolder();

            holder.member_name = (TextView) convertView.findViewById(R.id.membername);
            holder.member_desig = (TextView) convertView.findViewById(R.id.memberdesignation);
            holder.message = (ImageView) convertView.findViewById(R.id.message);
            holder.chat = (ImageView) convertView.findViewById(R.id.chat);
            holder.mail = (ImageView) convertView.findViewById(R.id.mail);
            holder.member_description = (TextView) convertView.findViewById(R.id.memberdesctiption);

            if (prefManager.getString(Constants.USER_ID).equalsIgnoreCase(list.get(position).getMemberId())) {
                holder.message.setVisibility(View.GONE);
                holder.chat.setVisibility(View.GONE);
                holder.mail.setVisibility(View.GONE);
            } else {
                holder.message.setVisibility(View.VISIBLE);
                holder.chat.setVisibility(View.VISIBLE);
                holder.mail.setVisibility(View.VISIBLE);
            }
            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.member_name.setText(list.get(position).getMemberName());
            holder.member_desig.setText(list.get(position).getMemberDesignation());
            holder.member_description.setText(list.get(position).getMemberBio());

            holder.chat.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                }
            });

            holder.mail.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    /*Intent intent = new Intent(android.content.Intent.ACTION_SEND);
                    intent.setType("text/html");
                    // intent.setType("text/plain");
                    final PackageManager pm = context.getPackageManager();
                    final List<ResolveInfo> matches = pm.queryIntentActivities(intent, 0);
                    ResolveInfo best = null;
                    for (final ResolveInfo info : matches) {
                        if (info.activityInfo.packageName.endsWith(".gm") || info.activityInfo.name.toLowerCase().contains("gmail")) {
                            best = info;
                            break;
                        }
                    }
                    if (best != null) {
                        intent.setClassName(best.activityInfo.packageName, best.activityInfo.name);
                    }
                    intent.putExtra(android.content.Intent.EXTRA_SUBJECT, "SUBJECT");
                    intent.putExtra(android.content.Intent.EXTRA_TEXT, Html.fromHtml("Messages"));
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    context.startActivity(intent);*/
                    Fragment mailFragment = new SendEmailFragment();
                    Bundle bundle = new Bundle();
                    bundle.putString("receiverMailId", list.get(position).getMemberEmail());
                    bundle.putString("receiverId", list.get(position).getMemberId());
                    mailFragment.setArguments(bundle);
                    FragmentTransaction fragmentTransaction = ((HomeActivity) context).getSupportFragmentManager().beginTransaction();
                    fragmentTransaction.add(R.id.container, mailFragment).addToBackStack(null).commit();
                }
            });

            holder.message.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Fragment messageFragment = new SendMessageFragment();
                    FragmentTransaction fragmentTransaction = ((HomeActivity) context).getSupportFragmentManager().beginTransaction();
                    Bundle bundle = new Bundle();
                    Log.e("to_team_memberid", list.get(position).getMemberId());

                    bundle.putString("to_team_memberid", list.get(position).getMemberId());
                    bundle.putString("to_team_memberName", list.get(position).getMemberName());
                    messageFragment.setArguments(bundle);
                    fragmentTransaction.add(R.id.container, messageFragment).addToBackStack(null).commit();
                }
            });


        } catch (Exception e) {
            e.printStackTrace();
        }
        return convertView;
    }

    @Override
    public View getHeaderView(int position, View convertView, ViewGroup parent) {
        HeaderViewHolder holder;
        if (convertView == null) {
            holder = new HeaderViewHolder();
            convertView = l_Inflater.inflate(R.layout.header, parent, false);
            holder.text = (TextView) convertView.findViewById(R.id.header1);
            convertView.setTag(holder);
        } else {
            holder = (HeaderViewHolder) convertView.getTag();
        }

        String abc = list.get(position).getMemberDesignation();
        holder.text.setText(abc);
        return convertView;
    }

    /**
     * Remember that these have to be static, postion=1 should always return
     * the same Id that is.
     */
    @Override
    public long getHeaderId(int position) {
        // return the first character of the country as ID because this is what
        // headers are based upon  mCountries[position].subSequence(0, 1).charAt(0);
        return list.get(position).getMemberRoleId().charAt(0);
    }

    @Override
    public int getPositionForSection(int section) {
        if (mSectionIndices.length == 0) {
            return 0;
        }

        if (section >= mSectionIndices.length) {
            section = mSectionIndices.length - 1;
        } else if (section < 0) {
            section = 0;
        }
        return mSectionIndices[section];
    }

    @Override
    public int getSectionForPosition(int position) {
        for (int i = 0; i < mSectionIndices.length; i++) {
            if (position < mSectionIndices[i]) {
                return i - 1;
            }
        }
        return mSectionIndices.length - 1;
    }

    @Override
    public Object[] getSections() {
        return mSectionLetters;
    }


    class HeaderViewHolder {
        TextView text;
    }
    static class ViewHolder {
        TextView member_name;
        TextView member_desig;
        TextView member_description;
        ImageView chat;
        ImageView message;
        ImageView mail;
    }

    /*@Override
    public boolean getSwipEnableByPosition(int position) {
        return true;
    }*/


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

                ArrayList<TeamMemberObject> filterList = new ArrayList<TeamMemberObject>();

                for (int i = 0; i < mStringFilterList.size(); i++) {

                    if (mStringFilterList.get(i).getMemberName().toLowerCase().startsWith(constraint.toString())) {
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

        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {

            list = (ArrayList<TeamMemberObject>) results.values;
            notifyDataSetChanged();
        }
    }
}