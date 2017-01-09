package com.staging.fragments;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.staging.R;
import com.staging.activities.HomeActivity;

/**
 * Created by sunakshi.gautam on 1/18/2016.
 */
public class CurrentStartUpFragment extends Fragment {

    public static TabLayout tabLayout;
    public static ViewPager viewPager;
    public static int int_items = 4;
    public static String strCommingFrom;

    public CurrentStartUpFragment() {
    }

    @Override
    public void onResume() {
        super.onResume();
   Log.e("XXX","ONRESUME CALLED");
        try {
            if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("WORK_ORDERS"))) {
                ((HomeActivity) getActivity()).setActionBarTitle("Work Orders");
                strCommingFrom = "WORK_ORDERS";
            } else if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("CURRENT_STARTUPS"))) {
                ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.currentStartup));
                selectPage(3);
                //strCommingFrom = "Current Startup";
            }
            else if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("ADD_STARTUPS"))) {
                ((HomeActivity) getActivity()).setActionBarTitle("My Startups");
               // strCommingFrom = "ADD STARTUPS";
                selectPage(3);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    void selectPage(int pageIndex){
        try {
            tabLayout.setScrollPosition(pageIndex,0f,true);
            viewPager.setCurrentItem(pageIndex);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_currentstartup, container, false);
        Log.e("XXX","ONCREATEVIEW CALLED");
        try {
            tabLayout = (TabLayout) rootView.findViewById(R.id.tabs);

            viewPager = (ViewPager) rootView.findViewById(R.id.viewpager);

            viewPager.setAdapter(new CurrentStartUpAdapter(getChildFragmentManager()));
            strCommingFrom = getArguments().getString("COMMING_FROM");

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


    class CurrentStartUpAdapter extends FragmentPagerAdapter {
        public CurrentStartUpAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int position) {
            switch (position) {
                case 0:
                    return new CurrentStartupTabsFragment();
                case 1:
                    return new CompletedStartupTabsFragment();
                case 2:
                    return new SearchStartupsTabsFragment();
                case 3:
                    return new MyStartupsFragment();
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
                    return "Current";
                case 1:
                    return "Completed";
                case 2:
                    return "Search";
                case 3:
                    return "My Startups";
            }
            return null;
        }
    }
}