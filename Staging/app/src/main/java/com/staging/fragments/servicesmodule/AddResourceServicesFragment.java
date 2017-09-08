package com.staging.fragments.servicesmodule;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.staging.R;
import com.staging.utilities.NonSwipeableViewPager;

/**
 * Created by Neelmani.Karn on 1/11/2017.
 */
public class AddResourceServicesFragment extends Fragment  {
    public TabLayout tabLayout;
    public NonSwipeableViewPager viewPager;
    public int int_items = 3;

    public AddResourceServicesFragment() {
        super();
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            // we check that the fragment is becoming visible
            viewPager.setAdapter(new MyAdapter(getChildFragmentManager()));
            tabLayout.post(new Runnable() {
                @Override
                public void run() {
                    tabLayout.setupWithViewPager(viewPager);
                }
            });

        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.funds_tab_layout, container, false);


        try {
            tabLayout = (TabLayout) rootView.findViewById(R.id.tabs);
            viewPager = (NonSwipeableViewPager) rootView.findViewById(R.id.viewpager);




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
                        return new MyResourcesServicesFragments();
                    case 1:
                        return new ArchivedServicesFragment();
                    case 2:
                        return new DeactivatedServicesFragment();
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
                    return "My Services";
                case 1:
                    return getString(R.string.archived);
                case 2:
                    return getString(R.string.deactivated);
            }
            return null;
        }
    }
}
