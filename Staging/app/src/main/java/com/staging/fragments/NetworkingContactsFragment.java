package com.staging.fragments;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.utilities.NonSwipeableViewPager;

/**
 * Created by Sunakshi.Gautam on 11/9/2017.
 */

public class NetworkingContactsFragment extends Fragment {

    public NetworkingContactsFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle("Add Contact");
    }


    public static TabLayout tabLayout;
    public static NonSwipeableViewPager viewPager;
    public static int int_items = 3;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.funds_tab_layout, container, false);
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

    public static void selectPage(int pageIndex){
        try {
            tabLayout.setScrollPosition(pageIndex,0f,true);
            viewPager.setCurrentItem(pageIndex);
        } catch (Exception e) {
            e.printStackTrace();
        }
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
                        return new NetworkingSearchConnectionsFragment();
                    case 1:
                        return new NetworkingAddNewUserFragment();
                    case 2:
                        return new ViewNewUsersFragment();
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
                    return "Search";
                case 1:
                    return "Add New Contact";
                case 2:
                    return "Contacts";
            }
            return null;
        }
    }

}
