package com.crowdbootstrapapp.fragments;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.helper.GetRoundedCornerBitmap;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.utilities.Constants;


public class ViewPublicProfileFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    private RatingBar profileRating;
    private TextView cbx_Follow;
    private ImageView img_excellenceAward;
    public static TabLayout tabLayout;
    public static ViewPager viewPager;
    public static int int_items = 3;
    private ImageView img_UserSwitch, img_chat;
    private boolean fromContractor = false;
    private TextView rateLayout;
    private TextView userName;

    public ViewPublicProfileFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("CAMPAIGNS"))) {

            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            Constants.COMMING_FROM_INTENT = "campaignsearch";
            cbx_Follow.setVisibility(View.VISIBLE);
        } else if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("SEARCH_CONTRACTOR_DETAILS"))) {
            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            Constants.COMMING_FROM_INTENT = "searchprofile";
            cbx_Follow.setVisibility(View.VISIBLE);
        } else if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("home"))) {
            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            Constants.COMMING_FROM_INTENT = "home";
            cbx_Follow.setVisibility(View.GONE);
        } else {
            ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.myProfile));
            Constants.COMMING_FROM_INTENT = "home";
            cbx_Follow.setVisibility(View.GONE);
        }

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_view_public_profile, container, false);

        profileRating = (RatingBar) rootView.findViewById(R.id.profileRating);
        profileRating.setClickable(false);
        profileRating.setFocusable(false);
        profileRating.setFocusableInTouchMode(false);
        profileRating.setIsIndicator(false);

        img_UserSwitch = (ImageView) rootView.findViewById(R.id.imageuser);
        userName = (TextView) rootView.findViewById(R.id.tv_username);
        img_chat = (ImageView) rootView.findViewById(R.id.img_chat);
        rateLayout = (TextView) rootView.findViewById(R.id.tv_rate);
        cbx_Follow = (TextView) rootView.findViewById(R.id.cbx_Follow);
        img_excellenceAward = (ImageView) rootView.findViewById(R.id.img_excellenceAward);
        img_excellenceAward.setOnClickListener(this);

        Bitmap bitmap = BitmapFactory.decodeResource(this.getResources(), R.drawable.image);
        Bitmap circularBitmap = GetRoundedCornerBitmap.getRoundedCornerBitmap(bitmap, 100);
        ImageView circularImageView = (ImageView) rootView.findViewById(R.id.profileimage);
        circularImageView.setImageBitmap(circularBitmap);

        /*cbx_Follow.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    cbx_Follow.setText("Unfollow");
                    cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGrey));
                } else {
                    cbx_Follow.setText("Follow");
                    cbx_Follow.setBackgroundColor(getResources().getColor(R.color.darkGreen));
                }
            }
        });*/

        tabLayout = (TabLayout) rootView.findViewById(R.id.tabs);
        viewPager = (ViewPager) rootView.findViewById(R.id.viewpager);


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


        if (getArguments().getString("COMMING_FROM").equalsIgnoreCase("CAMPAIGNS") || getArguments().getString("COMMING_FROM").equalsIgnoreCase("TEAMS") || getArguments().getString("COMMING_FROM").equalsIgnoreCase("Teams")) {
            img_UserSwitch.setVisibility(View.GONE);
            Constants.COMMING_FROM_INTENT = "Teams";
        } else {
            img_UserSwitch.setVisibility(View.VISIBLE);
        }
        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_TYPE, Constants.CONTRACTOR);

        img_UserSwitch.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (fromContractor == true) {
                    fromContractor = false;
                    rateLayout.setVisibility(View.VISIBLE);
                    userName.setText("Contractor Name");

                } else {
                    fromContractor = true;
                    rateLayout.setVisibility(View.GONE);
                    userName.setText("Entrepreneur Name");
                    img_UserSwitch.setImageResource(R.drawable.entrepreneurselected);
                    img_UserSwitch.setImageResource(R.drawable.contractorselected);
                    ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_TYPE, Constants.ENTREPRENEUR);

                    Fragment fragment = new ViewEntrepreneurPublicProfileFragment();
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
        img_chat.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Fragment rateContributor = new ContactsFragment();
                ((HomeActivity)getActivity()).replaceFragment(rateContributor);
                /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();

                transactionRate.replace(R.id.container, rateContributor).addToBackStack(ViewPublicProfileFragment.class.getName());
                //transactionRate.addToBackStack(null);

                transactionRate.commit();*/
            }
        });
        return rootView;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.img_excellenceAward:
                Fragment excellenceAward = new ExcellenceAwardFragment();
                ((HomeActivity)getActivity()).replaceFragment(excellenceAward);
               // getFragmentManager().beginTransaction().replace(R.id.container, excellenceAward).addToBackStack(ViewPublicProfileFragment.class.getName()).commit();
                break;
        }
    }

    @Override
    public void onTaskComplete(String result, String tag) {

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
