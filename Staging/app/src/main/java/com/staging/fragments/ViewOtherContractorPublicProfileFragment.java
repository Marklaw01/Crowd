package com.staging.fragments;

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
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.utilities.Constants;
import com.quickblox.chat.QBChatService;
import com.quickblox.chat.QBPrivateChatManager;
import com.quickblox.chat.model.QBDialog;
import com.quickblox.core.QBEntityCallback;
import com.quickblox.core.exception.QBResponseException;


public class ViewOtherContractorPublicProfileFragment extends Fragment implements View.OnClickListener {

    public static String quickBloxId;
    public static TextView tv_username, tv_rate;
    public static ImageView circularImageView;
    public static RatingBar profileRating;
    public static TextView cbx_Follow, cbx_businesscard;

    public static TextView connectionOption;
    public static RelativeLayout aboveLayoutProfile;
    public static RelativeLayout belowLayoutProfile;

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

    public static String cardID = "";
    public static String userImageURL = "";
    public static String contactTypeId = "";
    private QBPrivateChatManager privateChatManager = QBChatService.getInstance().getPrivateChatManager();

    public ViewOtherContractorPublicProfileFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();

        if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("CAMPAIGNS"))) {

            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            userId = getArguments().getString("id");
            Log.e("id", userId);
            Constants.COMMING_FROM_INTENT = "campaignsearch";
            cbx_Follow.setVisibility(View.VISIBLE);
            cbx_businesscard.setVisibility(View.VISIBLE);
            aboveLayoutProfile.setVisibility(View.GONE);
            belowLayoutProfile.setVisibility(View.VISIBLE);
            connectionOption.setVisibility(View.VISIBLE);
        } else if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase(Constants.LIKE_DISLIKE))) {

            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            userId = getArguments().getString("id");
            Log.e("id", userId);
            Constants.COMMING_FROM_INTENT = Constants.LIKE_DISLIKE;
            cbx_Follow.setVisibility(View.VISIBLE);
            cbx_businesscard.setVisibility(View.VISIBLE);
            aboveLayoutProfile.setVisibility(View.GONE);
            belowLayoutProfile.setVisibility(View.VISIBLE);
            connectionOption.setVisibility(View.VISIBLE);
        } else if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("teams"))) {

            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            userId = getArguments().getString("id");
            Log.e("id", userId);
            Constants.COMMING_FROM_INTENT = "Teams";
            aboveLayoutProfile.setVisibility(View.GONE);
            belowLayoutProfile.setVisibility(View.VISIBLE);
            cbx_Follow.setVisibility(View.VISIBLE);
            cbx_businesscard.setVisibility(View.VISIBLE);
            connectionOption.setVisibility(View.VISIBLE);
        } else if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("SEARCH_CONTRACTOR_DETAILS"))) {
            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            Constants.COMMING_FROM_INTENT = "searchprofile";
            LOGGEDIN_USER_ROLE = Integer.parseInt(getArguments().getString("logged_in_user_role"));
            userId = getArguments().getString("id");
            Log.e("id", userId);

            aboveLayoutProfile.setVisibility(View.GONE);
            belowLayoutProfile.setVisibility(View.VISIBLE);
            cbx_Follow.setVisibility(View.VISIBLE);
            cbx_businesscard.setVisibility(View.VISIBLE);
            connectionOption.setVisibility(View.VISIBLE);
        } else if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("RECOMMENDED_CONTRACTOR_DETAILS"))) {
            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            Constants.COMMING_FROM_INTENT = "recommendedContractors";
            LOGGEDIN_USER_ROLE = Integer.parseInt(getArguments().getString("logged_in_user_role"));
            TEAM_STARTUP_ID = getArguments().getString("STARTUP_ID");
            userId = getArguments().getString("id");
            Log.e("id", userId);

            aboveLayoutProfile.setVisibility(View.GONE);
            belowLayoutProfile.setVisibility(View.VISIBLE);
            cbx_Follow.setVisibility(View.VISIBLE);
            cbx_businesscard.setVisibility(View.VISIBLE);
            connectionOption.setVisibility(View.VISIBLE);
        } else if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase("home"))) {
            ((HomeActivity) getActivity()).setActionBarTitle("Public Profile");
            Constants.COMMING_FROM_INTENT = "home";
            cbx_Follow.setVisibility(View.GONE);
            cbx_businesscard.setVisibility(View.GONE);
            connectionOption.setVisibility(View.GONE);

            aboveLayoutProfile.setVisibility(View.VISIBLE);
            belowLayoutProfile.setVisibility(View.GONE);
        } else {
            ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.myProfile));
            Constants.COMMING_FROM_INTENT = "home";

            cbx_Follow.setVisibility(View.GONE);
            cbx_businesscard.setVisibility(View.GONE);
            connectionOption.setVisibility(View.GONE);
            aboveLayoutProfile.setVisibility(View.GONE);
            belowLayoutProfile.setVisibility(View.VISIBLE);
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
        cbx_businesscard = (TextView) rootView.findViewById(R.id.cbx_view_card);
        img_excellenceAward = (ImageView) rootView.findViewById(R.id.img_excellenceAward);
        img_excellenceAward.setOnClickListener(this);
        connectionOption = (TextView) rootView.findViewById(R.id.connect);
        aboveLayoutProfile = (RelativeLayout) rootView.findViewById(R.id.abovelayoutProfile);
        belowLayoutProfile = (RelativeLayout) rootView.findViewById(R.id.belowlayoutProfile);

        circularImageView = (ImageView) rootView.findViewById(R.id.profileimage);


        tabLayout = (TabLayout) rootView.findViewById(R.id.tabs);
        viewPager = (ViewPager) rootView.findViewById(R.id.viewpager);

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



        cbx_businesscard.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Fragment currentStartUPDetails = new ViewBusinessCardFragment();
                // Constants.COMMING_FROM_INTENT = "";
                Bundle args = new Bundle();
                args.putString("connection_id", userId);
                args.putString("is_network", "");
                args.putString("business_contact_type", contactTypeId);
                args.putString("card_id", cardID);
                args.putString("userName", tv_username.getText().toString().trim());
                args.putString("userImage", userImageURL);
                args.putString("noteId", "");
                args.putString("comingFrom", "com.staging");

                currentStartUPDetails.setArguments(args);

                FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
                FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                fragmentTransaction.replace(R.id.container, currentStartUPDetails);
                fragmentTransaction.addToBackStack(HomeFragment.class.getName());

                fragmentTransaction.commit();
            }
        });
        img_chat.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.e("Quick", quickBloxId);
                ((HomeActivity) getActivity()).showProgressDialog();
                privateChatManager.createDialog(Integer.parseInt(quickBloxId), new QBEntityCallback<QBDialog>() {
                    @Override
                    public void onSuccess(QBDialog dialog, Bundle args) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        Fragment addContributor = new ChatFragment();

                        Bundle bundle = new Bundle();
                        bundle.putSerializable("dialog", dialog);
                        addContributor.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(addContributor);
                        /*FragmentTransaction transactionAdd = getFragmentManager().beginTransaction();
                        transactionAdd.replace(R.id.container, addContributor);
                        transactionAdd.addToBackStack(null);

                        transactionAdd.commit();*/
                    }

                    @Override
                    public void onError(QBResponseException errors) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    }
                });
            }
        });
        if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase(Constants.LIKE_DISLIKE))||getArguments().getString("COMMING_FROM").equalsIgnoreCase("RECOMMENDED_CONTRACTOR_DETAILS") || getArguments().getString("COMMING_FROM").equalsIgnoreCase("CAMPAIGNS") || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("SEARCH_CONTRACTOR_DETAILS")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("teams"))) {
            img_UserSwitch.setVisibility(View.GONE);
            connectionOption.setVisibility(View.VISIBLE);
            aboveLayoutProfile.setVisibility(View.GONE);
            belowLayoutProfile.setVisibility(View.VISIBLE);
        } else {
            img_UserSwitch.setVisibility(View.VISIBLE);
            connectionOption.setVisibility(View.GONE);
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
                    Fragment fragment = new ViewOtherEntrepreneurPublicProfileFragment();
                    /*if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        fragment.setEnterTransition(new Slide(Gravity.RIGHT));
                        fragment.setExitTransition(new Slide(Gravity.LEFT));
                    }*/
                    Bundle bundle = new Bundle();
                    bundle.putString("COMMING_FROM", "home");
                    fragment.setArguments(bundle);
                    ((HomeActivity) getActivity()).replaceFragment(fragment);
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
                if ((getArguments().getString("COMMING_FROM").equalsIgnoreCase(Constants.LIKE_DISLIKE))||(getArguments().getString("COMMING_FROM").equalsIgnoreCase("CAMPAIGNS")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("teams")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("SEARCH_CONTRACTOR_DETAILS")) || (getArguments().getString("COMMING_FROM").equalsIgnoreCase("RECOMMENDED_CONTRACTOR_DETAILS"))) {
                    bundle.putString("id", userId);
                    bundle.putString("user_type", Constants.CONTRACTOR);
                } else {
                    bundle.putString("id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    bundle.putString("user_type", Constants.CONTRACTOR);
                }
                excellenceAward.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(excellenceAward);
                //getFragmentManager().beginTransaction().replace(R.id.container, excellenceAward).addToBackStack(ViewOtherContractorPublicProfileFragment.class.getName()).commit();
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
                    return new ViewOtherBasicPublicProfileFragment();
                case 1:
                    return new ViewOtherPublicProfessionalProfileFragment();
                case 2:
                    return new StartUpsOtherPublicProfileFragment();
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
