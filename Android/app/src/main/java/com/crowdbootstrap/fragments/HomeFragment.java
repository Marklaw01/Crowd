package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.utilities.NonSwipeableViewPager;

/**
 * Created by neelmani.karn on 1/15/2016.
 */
public class HomeFragment extends Fragment {

    private TextView dummyText;

    public HomeFragment() {
        super();
    }

    public TabLayout tabLayout;
    public NonSwipeableViewPager viewPager;
    public static int int_items = 4;
    public static int selectedPosition;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.funds_tab_layout, container, false);
        ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.home));

        try {
            tabLayout = (TabLayout) rootView.findViewById(R.id.tabs);
            viewPager = (NonSwipeableViewPager) rootView.findViewById(R.id.viewpager);


//            tabLayout.post(new Runnable() {
//                @Override
//                public void run() {
//                    viewPager.setOffscreenPageLimit(0);
//                    tabLayout.setupWithViewPager(viewPager);
//                }
//            });




        } catch (Exception e) {
            e.printStackTrace();
        }

        return rootView;
    }

    @Override
    public void onResume() {
        super.onResume();

        viewPager.setAdapter(new HomeFragment.MyAdapter(getChildFragmentManager()));
        tabLayout.post(new Runnable() {
            @Override
            public void run() {
                viewPager.setOffscreenPageLimit(selectedPosition);
                tabLayout.setupWithViewPager(viewPager);
            }
        });

        selectPage(selectedPosition);
    }


    void selectPage(int pageIndex) {
        try {
            tabLayout.setScrollPosition(pageIndex, 0f, true);
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
                        return new HomeInfoFragment();
                    case 1:
                        return new BlogsFragment();
                    case 2:
                        return new HomeFeedsFragment();
                    case 3:
                        return new NetworkingOptionFragment();
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
                    return "Home";
                case 1:
                    return "News";
                case 2:
                    return "Alert";
                case 3:
                    return "Networking Options";

            }
            return null;
        }
    }


}