package com.crowdbootstrap.fragments.meetupsmodule;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.utilities.NonSwipeableViewPager;

/**
 * Created by neelmani.karn on 3/14/2016.
 */
public class MeetUpsFragment extends Fragment{

    private TextView dummyText;
    public MeetUpsFragment() {
        super();
    }

    public TabLayout tabLayout;
    public NonSwipeableViewPager viewPager;
    public static int int_items = 2;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.funds_tab_layout, container, false);
        ((HomeActivity)getActivity()).setActionBarTitle(getString(R.string.meet_ups));

        try {
            tabLayout = (TabLayout) rootView.findViewById(R.id.tabs);
            viewPager = (NonSwipeableViewPager) rootView.findViewById(R.id.viewpager);
            viewPager.setAdapter(new MyAdapter(getChildFragmentManager()));

            tabLayout.post(new Runnable() {
                @Override
                public void run() {
                    viewPager.setOffscreenPageLimit(0);
                    tabLayout.setupWithViewPager(viewPager);
                }
            });

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rootView;
    }

    class MyAdapter extends FragmentPagerAdapter {

        public MyAdapter(FragmentManager fm) {
            super(fm);
        }

        /**
         * Return fragment_commit_campaign with respect to Position .
         */

        @Override
        public Fragment getItem(int position) {
            try {
                switch (position) {
                    case 0:
                        return new SearchResourcesMeetUpsFragment();
                    case 1:
                        return new AddResourceMeetUpsFragment();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return null;
        }

        @Override
        public int getCount() {
            return int_items;
        }

        /**
         * This method returns the title of the tab according to the position.
         */

        @Override
        public CharSequence getPageTitle(int position) {

            switch (position) {
                case 0:
                    return "Search Meet Ups";
                case 1:
                    return "Add Meet Up";
            }
            return null;
        }
    }


}