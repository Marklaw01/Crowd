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
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.utilities.Constants;


public class ViewContractorPublicProfileFragment extends Fragment implements View.OnClickListener {

    public static TextView tv_username, tv_rate;
    public static ImageView circularImageView;
    public static RatingBar profileRating;
    public static TextView cbx_Follow;
    private ImageView img_excellenceAward;
    public static TabLayout tabLayout;
    public static ViewPager viewPager;
    public static int int_items = 3;
    private ImageView img_UserSwitch, img_chat;
    private boolean fromContractor = false;
    //public static String commingFrom;
    public static String userId = "0";
    public static int LOGGEDIN_USER_ROLE = 1;
    public static String TEAM_STARTUP_ID = "";

    public static RelativeLayout aboveLayoutProfile;
    public static RelativeLayout belowLayoutProfile;
    public static TextView connectOptionProfile;

    public ViewContractorPublicProfileFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();

        if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("CAMPAIGNS"))) {

            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            try {
                userId = getArguments().getString("id");
                Log.e("id", userId);
            } catch (Exception e) {
                e.printStackTrace();
                //CrowdBootstrapLogger.logError(getActivity(), new Object() {}.getClass().getEnclosingMethod().getName(), e, this.getClass().getName());
            }
            Constants.COMMING_FROM_INTENT = "campaignsearch";
            cbx_Follow.setVisibility(View.VISIBLE);
            connectOptionProfile.setVisibility(View.VISIBLE);
            aboveLayoutProfile.setVisibility(View.GONE);
            belowLayoutProfile.setVisibility(View.VISIBLE);

        } else if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("teams"))) {

            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            userId = getArguments().getString("id");
            Log.e("id", userId);
            Constants.COMMING_FROM_INTENT = "Teams";

            cbx_Follow.setVisibility(View.VISIBLE);
            connectOptionProfile.setVisibility(View.VISIBLE);
            aboveLayoutProfile.setVisibility(View.GONE);
            belowLayoutProfile.setVisibility(View.VISIBLE);

        } else if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("SEARCH_CONTRACTOR_DETAILS"))) {
            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            Constants.COMMING_FROM_INTENT = "searchprofile";
            LOGGEDIN_USER_ROLE = Integer.parseInt(getArguments().getString("logged_in_user_role"));
            userId = getArguments().getString("id");
            Log.e("id", userId);
            cbx_Follow.setVisibility(View.VISIBLE);
            connectOptionProfile.setVisibility(View.VISIBLE);
            aboveLayoutProfile.setVisibility(View.GONE);
            belowLayoutProfile.setVisibility(View.VISIBLE);

        } else if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("RECOMMENDED_CONTRACTOR_DETAILS"))) {
            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            Constants.COMMING_FROM_INTENT = "recommendedContractors";
            LOGGEDIN_USER_ROLE = Integer.parseInt(getArguments().getString("logged_in_user_role"));
            TEAM_STARTUP_ID = getArguments().getString("STARTUP_ID");
            userId = getArguments().getString("id");
            Log.e("id", userId);
            cbx_Follow.setVisibility(View.VISIBLE);
            connectOptionProfile.setVisibility(View.VISIBLE);
            aboveLayoutProfile.setVisibility(View.GONE);
            belowLayoutProfile.setVisibility(View.VISIBLE);

        } else if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("home"))) {
            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            Constants.COMMING_FROM_INTENT = "home";
            cbx_Follow.setVisibility(View.GONE);
            img_chat.setVisibility(View.GONE);
            connectOptionProfile.setVisibility(View.GONE);
            aboveLayoutProfile.setVisibility(View.VISIBLE);
            belowLayoutProfile.setVisibility(View.GONE);

        } else {
            ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.myProfile));
            Constants.COMMING_FROM_INTENT = "home";
            img_chat.setVisibility(View.GONE);
            cbx_Follow.setVisibility(View.GONE);
            connectOptionProfile.setVisibility(View.GONE);
            aboveLayoutProfile.setVisibility(View.VISIBLE);
            belowLayoutProfile.setVisibility(View.GONE);

        }

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_view_public_profile, container, false);

        tv_username = (TextView) rootView.findViewById(R.id.tv_username);
        tv_rate = (TextView) rootView.findViewById(R.id.tv_rate);

        img_chat = (ImageView) rootView.findViewById(R.id.img_chat);
        profileRating = (RatingBar) rootView.findViewById(R.id.profileRating);
        profileRating.setClickable(false);
        profileRating.setFocusable(false);
        profileRating.setIsIndicator(true);
        profileRating.setFocusableInTouchMode(false);
        img_UserSwitch = (ImageView) rootView.findViewById(R.id.imageuser);
        cbx_Follow = (TextView) rootView.findViewById(R.id.cbx_Follow);
        img_excellenceAward = (ImageView) rootView.findViewById(R.id.img_excellenceAward);
        img_excellenceAward.setOnClickListener(this);


        circularImageView = (ImageView) rootView.findViewById(R.id.profileimage);


        tabLayout = (TabLayout) rootView.findViewById(R.id.tabs);
        viewPager = (ViewPager) rootView.findViewById(R.id.viewpager);


        aboveLayoutProfile = (RelativeLayout) rootView.findViewById(R.id.abovelayoutProfile);
        belowLayoutProfile  = (RelativeLayout) rootView.findViewById(R.id.belowlayoutProfile);
        connectOptionProfile = (TextView) rootView.findViewById(R.id.connect);

        viewPager.setOffscreenPageLimit(1);
        viewPager.setAdapter(new ProfileAdapter(getChildFragmentManager()));

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


        img_chat.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
               /* Fragment rateContributor = new ContactsFragment();

                FragmentTransaction transactionRate = getFragmentManager().beginTransaction();

                transactionRate.replace(R.id.container, rateContributor).addToBackStack(ViewContractorPublicProfileFragment.class.getName());


                transactionRate.commit();*/
            }
        });
        if (getArguments().getString("COMMING_FROM").equalsIgnoreCase("RECOMMENDED_CONTRACTOR_DETAILS") || getArguments().getString("COMMING_FROM").equalsIgnoreCase("CAMPAIGNS") || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("SEARCH_CONTRACTOR_DETAILS")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("teams"))) {
            img_UserSwitch.setVisibility(View.GONE);
            connectOptionProfile.setVisibility(View.VISIBLE);
            aboveLayoutProfile.setVisibility(View.GONE);
            belowLayoutProfile.setVisibility(View.VISIBLE);

        } else {
            img_UserSwitch.setVisibility(View.VISIBLE);
            connectOptionProfile.setVisibility(View.GONE);
            aboveLayoutProfile.setVisibility(View.VISIBLE);
            belowLayoutProfile.setVisibility(View.GONE);

        }
        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_TYPE, Constants.CONTRACTOR);

        img_UserSwitch.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (fromContractor == true) {
                    fromContractor = false;


                } else {
                    fromContractor = true;
                    img_UserSwitch.setImageResource(R.drawable.entrepreneurselected);
                    img_UserSwitch.setImageResource(R.drawable.contractorselected);
                    ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_TYPE, Constants.ENTREPRENEUR);
                    Fragment fragment = new ViewEntrepreneurPublicProfileFragment();
                    /*if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        fragment.setEnterTransition(new Slide(Gravity.RIGHT));
                        fragment.setExitTransition(new Slide(Gravity.LEFT));
                    }*/
                    Bundle bundle = new Bundle();
                    bundle.putString("COMMING_FROM", "home");
                    fragment.setArguments(bundle);
                    ((HomeActivity)getActivity()).replaceFragment(fragment);
                    /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();

                    transactionRate.replace(R.id.container, fragment);
                    //transactionRate.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                    //transactionRate.addToBackStack(null);

                    transactionRate.commit();*/
                }

            }
        });
        return rootView;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.img_excellenceAward:
                Fragment excellenceAward = new ExcellenceAwardFragment();
                Bundle bundle = new Bundle();
                if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("CAMPAIGNS")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("teams")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("SEARCH_CONTRACTOR_DETAILS")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("RECOMMENDED_CONTRACTOR_DETAILS"))) {
                    bundle.putString("id", userId);
                } else {
                    bundle.putString("id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                }
                excellenceAward.setArguments(bundle);
                ((HomeActivity)getActivity()).replaceFragment(excellenceAward);
                //getFragmentManager().beginTransaction().replace(R.id.container, excellenceAward).addToBackStack(ViewContractorPublicProfileFragment.class.getName()).commit();
                break;
        }
    }


    class ProfileAdapter extends FragmentPagerAdapter {

        public ProfileAdapter(FragmentManager fm) {
            super(fm);
        }

        /**
         * Return fragment with respect to Position .
         */

        @Override
        public Fragment getItem(int position) {
            switch (position) {
                case 0:
                    return new ViewBasicPublicProfileFragment();
                case 1:
                    return new ViewPublicProfessionalProfileFragment();
                case 2:
                    return new StartUpsPublicProfileFragment();
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
                    return "Basic";
                case 1:
                    return "Professional";
                case 2:
                    return "Startup";
            }
            return null;
        }
    }
}
