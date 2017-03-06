package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.crowdbootstrap.R;

/**
 * Created by neelmani.karn on 01/10/2017.
 */


public class FundsFragment  extends Fragment {
    private TextView dummyText;
    public FundsFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_cms, container, false);
        dummyText = (TextView) rootView.findViewById(R.id.dummyText);
        dummyText.setText("Coming soon – Each startup is assigned to a fund that has a specific focus.");
        return rootView;
    }
}
/*
public class FundsFragment extends Fragment {
    public TabLayout tabLayout;
    public NonSwipeableViewPager viewPager;
    public static int int_items = 2;

    public FundsFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.funds_tab_layout, container, false);
        ((HomeActivity)getActivity()).setActionBarTitle(getString(R.string.funds));

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


    class MyAdapter extends FragmentPagerAdapter {

        public MyAdapter(FragmentManager fm) {
            super(fm);
        }


        @Override
        public Fragment getItem(int position) {
            try {
                switch (position) {
                    case 0:
                        return new FindFundsFragment();
                    case 1:
                        return new FundInvestFragment();
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



        @Override
        public CharSequence getPageTitle(int position) {

            switch (position) {
                case 0:
                    return getString(R.string.findFunds);
                case 1:
                    return getString(R.string.fundInvest);
            }
            return null;
        }
    }
}*/
