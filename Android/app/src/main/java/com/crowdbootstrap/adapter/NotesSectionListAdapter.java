package com.crowdbootstrap.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.SectionIndexer;
import android.widget.TextView;

import com.crowdbootstrap.R;
import com.crowdbootstrap.models.NotesObject;
import com.crowdbootstrap.utilities.DateTimeFormatClass;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;

import se.emilsjolander.stickylistheaders.StickyListHeadersAdapter;

/**
 * Created by neelmani.karn on 1/20/2016.
 */
public class NotesSectionListAdapter extends BaseAdapter implements StickyListHeadersAdapter, SectionIndexer {


    private final Context mContext;
    private ArrayList<NotesObject> list;
    private int[] mSectionIndices;
    private String[] mSectionLetters;
    private LayoutInflater mInflater;

    public NotesSectionListAdapter(Context context , ArrayList<NotesObject> list) {
        mContext = context;
        mInflater = LayoutInflater.from(context);
        this.list = list;
        Collections.sort(list, new Comparator<NotesObject>() {
            public int compare(NotesObject s1, NotesObject s2) {
                return s1.getNoteStartupId().compareToIgnoreCase(s2.getNoteStartupId());
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
        String lastFirstChar = list.get(0).getNoteStartupId();
        sectionIndices.add(0);

        for (int i = 1; i < list.size(); i++) {
            if (list.get(i).getNoteStartupId() != lastFirstChar) {
                lastFirstChar = list.get(i).getNoteStartupId();
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
            letters[i] = list.get(i).getNoteStartupId();
        }
        return letters;
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
        if (convertView == null) {
            convertView = mInflater.inflate(R.layout.notes_row_item, null);
            holder = new ViewHolder();

            holder.tv_notifications = (TextView) convertView.findViewById(R.id.tv_notification);
            holder.tv_forumDescription = (TextView) convertView.findViewById(R.id.tv_notificationDetails);
            holder.tv_CreatedTime = (TextView) convertView.findViewById(R.id.tv_notificationCreatedTime);
            convertView.setTag(holder);
        }else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            JSONObject title = new JSONObject(list.get(position).getNoteName());

            JSONObject desc = new JSONObject(list.get(position).getNoteDescription());
            holder.tv_notifications.setText(title.getString("title"));
            holder.tv_forumDescription.setText(desc.getString("desc"));
            Date myDate = new Date(list.get(position).getNoteCreatedDate());

            holder.tv_CreatedTime.setText(DateTimeFormatClass.convertDateObjectToMMDDYYYFormat(myDate));

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
            convertView = mInflater.inflate(R.layout.header, parent, false);
            holder.text = (TextView) convertView.findViewById(R.id.header1);
            convertView.setTag(holder);
        } else {
            holder = (HeaderViewHolder) convertView.getTag();
        }

        String abc = list.get(position).getNoteStartupName();
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
        return Long.parseLong(list.get(position).getNoteStartupId());
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

    class ViewHolder {
        TextView tv_notifications, tv_forumDescription, tv_CreatedTime;
    }
}
