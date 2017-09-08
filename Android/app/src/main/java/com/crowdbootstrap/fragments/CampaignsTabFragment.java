package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;

/**
 * Created by neelmani.karn on 1/12/2016.
 */
public class CampaignsTabFragment extends Fragment {
    public static TabLayout tabLayout;
    public static ViewPager viewPager;
    public static int int_items = 4;
    String commingFrom="";

    public CampaignsTabFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.campaigns_tab_layout, container, false);

        try {
            tabLayout = (TabLayout) rootView.findViewById(R.id.tabs);
            viewPager = (ViewPager) rootView.findViewById(R.id.viewpager);
            //viewPager.setOffscreenPageLimit(4);
            viewPager.setAdapter(new MyAdapter(getChildFragmentManager()));

            tabLayout.post(new Runnable() {
                @Override
                public void run() {
                    tabLayout.setupWithViewPager(viewPager);
                }
            });

            commingFrom = getArguments().getString("home");
            if (commingFrom.equalsIgnoreCase("home")){
                selectPage(3);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootView;
    }

    void selectPage(int pageIndex){
        try {
            tabLayout.setScrollPosition(pageIndex, 0f, true);
            viewPager.setCurrentItem(pageIndex);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.campaighns));
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
                        return new SuggestionsFragment();
                    case 1:
                        return new FollowingFragment();
                    case 2:
                        return new CommitmentsFragment();
                    case 3:
                        return new MyCampaignsFragment();
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
                    return "Recommended";
                case 1:
                    return "Following";
                case 2:
                    return "Commitments";
                case 3:
                    return "My Campaigns";
            }
            return null;
        }
    }
}