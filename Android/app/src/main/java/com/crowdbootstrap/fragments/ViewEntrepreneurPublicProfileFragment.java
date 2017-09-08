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
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.utilities.Constants;


public class ViewEntrepreneurPublicProfileFragment extends Fragment implements View.OnClickListener {

    public static TextView tv_username, tv_rate;
    public static TextView cbx_Follow;
    public static ImageView circularImageView;
    private ImageView img_excellenceAward;
    public static TabLayout tabLayout;
    public static ViewPager viewPager;
    public static int int_items = 3;
    private TextView rateLayout;
    public static RatingBar profileRating;
    private ImageView img_UserSwitch, img_chat;
    private boolean fromEntrepreneur = false;
    public static String userId = "0";

    public ViewEntrepreneurPublicProfileFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();


        if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("CAMPAIGNS")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("STARTUP_DETAILS")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("entrepreneur")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("teams"))) {

            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            Constants.COMMING_FROM_INTENT = getArguments().getString("COMMING_FROM");
            userId = getArguments().getString("id");

            cbx_Follow.setVisibility(View.VISIBLE);
        } else if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("home"))) {
            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            Constants.COMMING_FROM_INTENT = "home";
            img_chat.setVisibility(View.GONE);
            cbx_Follow.setVisibility(View.GONE);
        } else {
            ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.myProfile));
            Constants.COMMING_FROM_INTENT = getArguments().getString("COMMING_FROM");
            cbx_Follow.setVisibility(View.GONE);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_entrepreneur_view_public_profile, container, false);

        profileRating = (RatingBar) rootView.findViewById(R.id.profileRating);
        profileRating.setClickable(false);
        profileRating.setFocusable(false);
        profileRating.setIsIndicator(true);
        profileRating.setFocusableInTouchMode(false);
        circularImageView = (ImageView) rootView.findViewById(R.id.profileimage);
        tv_username = (TextView) rootView.findViewById(R.id.tv_username);
        tv_rate = (TextView) rootView.findViewById(R.id.tv_rate);
        img_UserSwitch = (ImageView) rootView.findViewById(R.id.imageuser);
        cbx_Follow = (TextView) rootView.findViewById(R.id.cbx_Follow);
        img_excellenceAward = (ImageView) rootView.findViewById(R.id.img_excellenceAward);
        img_chat = (ImageView) rootView.findViewById(R.id.img_chat);
        img_excellenceAward.setOnClickListener(this);
        rateLayout = (TextView) rootView.findViewById(R.id.tv_rate);
        rateLayout.setVisibility(View.GONE);

        /*Bitmap bitmap = BitmapFactory.decodeResource(this.getResources(), R.drawable.image);
        Bitmap circularBitmap = GetRoundedCornerBitmap.getRoundedCornerBitmap(bitmap, 100);
        ImageView circularImageView = (ImageView) rootView.findViewById(R.id.profileimage);
        circularImageView.setImageBitmap(circularBitmap);*/

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

        if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("CAMPAIGNS")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("STARTUP_DETAILS") || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("TEAMS")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("entrepreneur")))) {
            img_UserSwitch.setVisibility(View.GONE);

        } else {
            img_UserSwitch.setVisibility(View.VISIBLE);
        }
        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_TYPE, Constants.ENTREPRENEUR);
        img_UserSwitch.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (fromEntrepreneur == true) {
                    fromEntrepreneur = false;

                } else {
                    fromEntrepreneur = true;
                    img_UserSwitch.setImageResource(R.drawable.entrepreneurselected);
                    img_UserSwitch.setImageResource(R.drawable.contractorselected);
                    ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_TYPE, Constants.CONTRACTOR);
                    Fragment rateContributor = new ViewContractorPublicProfileFragment();
                    /*if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        rateContributor.setEnterTransition(new Slide(Gravity.RIGHT));
                        rateContributor.setExitTransition(new Slide(Gravity.LEFT));
                    }*/
                    Bundle bundle = new Bundle();
                    bundle.putString("COMMING_FROM", "home");
                    rateContributor.setArguments(bundle);
                    ((HomeActivity)getActivity()).replaceFragment(rateContributor);
                    /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();

                    transactionRate.replace(R.id.container, rateContributor);
                    //transactionRate.addToBackStack(null);

                    transactionRate.commit();*/

                }

            }
        });

        img_chat.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Fragment rateContributor = new ContactsFragment();
                /*if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    rateContributor.setEnterTransition(new Slide(Gravity.RIGHT));
                    rateContributor.setExitTransition(new Slide(Gravity.LEFT));
                }*/
                ((HomeActivity)getActivity()).replaceFragment(rateContributor);
                /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();

                transactionRate.replace(R.id.container, rateContributor).addToBackStack(ViewEntrepreneurPublicProfileFragment.class.getName());
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
                Bundle bundle = new Bundle();
                if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("CAMPAIGNS")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("teams")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("SEARCH_CONTRACTOR_DETAILS")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("RECOMMENDED_CONTRACTOR_DETAILS"))) {
                    bundle.putString("id", userId);
                }else{
                    bundle.putString("id", ((HomeActivity)getActivity()).prefManager.getString(Constants.USER_ID));
                }
                excellenceAward.setArguments(bundle);
                ((HomeActivity)getActivity()).replaceFragment(excellenceAward);
                //getFragmentManager().beginTransaction().replace(R.id.container, excellenceAward).addToBackStack(ViewEntrepreneurPublicProfileFragment.class.getName()).commit();
                break;
        }
    }


    class ProfileAdapter extends FragmentPagerAdapter {

        public ProfileAdapter(FragmentManager fm) {
            super(fm);
        }

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
