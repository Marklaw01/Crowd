package com.crowdbootstrapapp.fragments;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by sunakshi.gautam on 1/20/2016.
 */
public class CurrentStartUpDetailFragment extends Fragment {

    private TabLayout tabLayout;
    public static ViewPager viewPager;
    public static String titleSTartup;
    public static String from;
    public static String STARTUP_ID;
    public static String STARTUP_TEAMID;
    public static String ENTREPRENEUR_ID;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_currentstartupdetails, container, false);

        try {
            STARTUP_ID = getArguments().getString("id");
            STARTUP_TEAMID = getArguments().getString("STARTUP_TEAMID");
            from = getArguments().getString("from");
            Log.e("startup_id", getArguments().getString("id"));
            titleSTartup = getArguments().getString("STARTUP_NAME");
            ENTREPRENEUR_ID = getArguments().getString("entrepreneur_id");

            viewPager = (ViewPager) rootView.findViewById(R.id.viewpager);

            tabLayout = (TabLayout) rootView.findViewById(R.id.tabs);
            if (from.compareTo("mystartup") == 0) {


                if (CurrentStartUpFragment.strCommingFrom.compareTo("WORK_ORDERS") == 0) {
                    Fragment workOrderEntrepreneur = new WorkOrderStartUpEntrepreneur();


                    FragmentTransaction ft = getFragmentManager().beginTransaction();
                    ft.replace(R.id.container, workOrderEntrepreneur);
                    ft.addToBackStack(null);
                    getFragmentManager().popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                    ft.commit();

                } else {
                    setupViewPagerEntrepreneur(viewPager);
                    tabLayout.setTabMode(TabLayout.MODE_SCROLLABLE);
                    tabLayout.post(new Runnable() {
                        @Override
                        public void run() {
                            tabLayout.setupWithViewPager(viewPager);
                        }
                    });
                }
            } else {
                if (CurrentStartUpFragment.strCommingFrom.compareTo("WORK_ORDERS") == 0) {

                    Fragment workOrderContractor = new WorkOrderStartUpFragment();


                    FragmentTransaction ft = getFragmentManager().beginTransaction();
                    ft.replace(R.id.container, workOrderContractor);
                    ft.addToBackStack(null);
                    getFragmentManager().popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                    ft.commit();

                } else {
                    setupViewPagerContractor(viewPager);
                    tabLayout.setTabMode(TabLayout.MODE_FIXED);
                    tabLayout.post(new Runnable() {
                        @Override
                        public void run() {
                            tabLayout.setupWithViewPager(viewPager);
                        }
                    });
                }
            }


            titleSTartup = getArguments().getString("STARTUP_NAME");
            ((HomeActivity) getActivity()).setActionBarTitle(getArguments().getString("STARTUP_NAME"));
//            if () {
//                selectPage(2);
//               /* TabLayout.Tab tab = tabLayout.getTabAt(2);
//                tab.select();*/
//            }
        } catch (Exception e) {
            e.printStackTrace();
        }


        /*viewPager.setOffscreenPageLimit(3);

*/
        return rootView;
    }

    void selectPage(int pageIndex) {
        try {
            tabLayout.setScrollPosition(pageIndex, 0f, true);
            viewPager.setCurrentItem(pageIndex);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


/*
    @Override
    public void onResume() {
        super.onResume();
        from = getArguments().getString("from");

    }*/


    /*@Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        List<Fragment> fragments = getChildFragmentManager().getFragments();
        if (fragments != null) {
            for (Fragment fragment : fragments) {

                if (fragment instanceof IntoStartUpFragment) {
                    Log.e("SupportFragmentCurrent", fragment.getClass().getSimpleName());
                    fragment.onActivityResult(requestCode, resultCode, data);
                }
            }
        }
    }*/

    private void setupViewPagerEntrepreneur(ViewPager viewPager) {
        try {
            ViewPagerAdapter adapter = new ViewPagerAdapter(getChildFragmentManager());
            //adapter.addFrag(IntoStartUpFragment.getInstance(STARTUP_ID), "Overview");
            adapter.addFrag(new IntoStartUpFragment(), "Overview");
            adapter.addFrag(new TeamStartUpFragment(), "Team");
            adapter.addFrag(new WorkOrderStartUpEntrepreneur(), "Work Orders");
            adapter.addFrag(new DocsSharingFragment(), "Docs");
            adapter.addFrag(new StartUpDocsFragment(), "Roadmap Docs");
            viewPager.setAdapter(adapter);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void setupViewPagerContractor(ViewPager viewPager) {
        try {
            ViewPagerAdapter adapter = new ViewPagerAdapter(getChildFragmentManager());
            adapter.addFrag(new IntoStartUpFragment(), "Overview");
            adapter.addFrag(new TeamStartUpFragment(), "Team");
            adapter.addFrag(new WorkOrderStartUpFragment(), "Work Order");
            adapter.addFrag(new DocsSharingFragment(), "Docs");
            viewPager.setAdapter(adapter);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    class ViewPagerAdapter extends FragmentPagerAdapter {
        private final List<Fragment> mFragmentList = new ArrayList<>();
        private final List<String> mFragmentTitleList = new ArrayList<>();

        public ViewPagerAdapter(FragmentManager manager) {
            super(manager);
        }

        @Override
        public Fragment getItem(int position) {
            return mFragmentList.get(position);
        }

        @Override
        public int getCount() {
            return mFragmentList.size();
        }

        public void addFrag(Fragment fragment, String title) {
            mFragmentList.add(fragment);
            mFragmentTitleList.add(title);
        }

        @Override
        public CharSequence getPageTitle(int position) {
            return mFragmentTitleList.get(position);
        }
    }
}
