package com.crowdbootstrapapp.fragments;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.crowdbootstrapapp.R;

/**
 * Created by Sunakshi.Gautam on 11/7/2016.
 */
public class ConnectionsFragment  extends Fragment {
    public static TabLayout tabLayout;
    public static ViewPager viewPager;
    public static int int_items = 2;

    public ConnectionsFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_currentstartup, container, false);

        try {
            tabLayout = (TabLayout) rootView.findViewById(R.id.tabs);

            viewPager = (ViewPager) rootView.findViewById(R.id.viewpager);

            viewPager.setAdapter(new ConnectionsFragmenAdapter(getChildFragmentManager()));

            tabLayout.post(new Runnable() {
                @Override
                public void run() {
                    //viewPager.setCurrentItem(3);
                    tabLayout.setupWithViewPager(viewPager);

                }
            });


        } catch (Exception e) {
            e.printStackTrace();
        }

        return rootView;
    }

    class ConnectionsFragmenAdapter extends FragmentPagerAdapter {
        public ConnectionsFragmenAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int position) {
            switch (position) {
                case 0:
                    return new MyConnectionsFragment();
                case 1:
                    return new MyMessagesFragment();

            }
            return null;
        }

        @Override
        public int getCount() {
            return int_items;

        }


        @Override
        public CharSequence getPageTitle(int position) {

            switch (position) {
                case 0:
                    return "My Connections";
                case 1:
                    return "My Messages";

            }
            return null;
        }
    }
}