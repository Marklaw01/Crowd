package com.staging.fragments;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.utilities.NonSwipeableViewPager;

/**
 * Created by Neelmani.Karn on 1/11/2017.
 */
public class FundInvestFragment extends Fragment implements AsyncTaskCompleteListener<String> {
    public TabLayout tabLayout;
    public NonSwipeableViewPager viewPager;
    public int int_items = 3;

    public FundInvestFragment() {
        super();
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            // we check that the fragment is becoming visible

            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        }
    }

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
                    tabLayout.setupWithViewPager(viewPager);
                }
            });

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rootView;
    }

    /**
     * When network give response in this.
     *
     * @param result
     * @param tag
     */
    @Override
    public void onTaskComplete(String result, String tag) {

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
                        return new MyFundsFragments();
                    case 1:
                        return new ArchivedFundsFragment();
                    case 2:
                        return new DeactivatedFundsFragment();
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
                    return getString(R.string.myfunds);
                case 1:
                    return getString(R.string.archived);
                case 2:
                    return getString(R.string.deactivated);
            }
            return null;
        }
    }
}
