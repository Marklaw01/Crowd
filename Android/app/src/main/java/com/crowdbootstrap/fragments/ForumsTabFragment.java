package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.utilities.NonSwipeableViewPager;

/**
 * Created by neelmani.karn on 1/13/2016.
 */
public class ForumsTabFragment extends Fragment {
    public static TabLayout tabLayout;
    public static NonSwipeableViewPager viewPager;
    public static int int_items = 3;

    public ForumsTabFragment() {
        super();
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.forums_tab_layout, container, false);
        //((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.forums));
        try {
            tabLayout = (TabLayout) rootView.findViewById(R.id.tabs);
            viewPager = (NonSwipeableViewPager) rootView.findViewById(R.id.viewpager);
            /**
             *Set an Apater for the View Pager
             */
            viewPager.setAdapter(new MyAdapter(getChildFragmentManager()));

            //viewPager.setOffscreenPageLimit(3);
            /**
             * Now , this is a workaround ,
             * The setupWithViewPager dose't works without the runnable .
             * Maybe a Support Library Bug .
             */

            tabLayout.post(new Runnable() {
                @Override
                public void run() {
                    tabLayout.setupWithViewPager(viewPager);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }


        return rootView;
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.forums));
    }

    class MyAdapter extends FragmentPagerAdapter {

        public MyAdapter(FragmentManager fm) {
            super(fm);
        }


        @Override
        public Fragment getItem(int position) {
            switch (position) {
                case 0:
                    //((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.forums));
                    return new StartupsFragment();
                case 1:
                    //((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.forums));
                    return new ForumsFragment();
                case 2:
                    //((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.myForum));
                    return new MyForumsFragment();
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
                    return "Startups";
                case 1:
                    return "Forums";
                case 2:
                    return "My Forums";
            }
            return null;
        }
    }
}