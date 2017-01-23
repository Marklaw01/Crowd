package com.crowdbootstrapapp.fragments;

import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.MobileAds;
import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.activities.IndependentContractorActivity;
import com.crowdbootstrapapp.activities.LeanStartupRoadmap;
import com.crowdbootstrapapp.activities.OurMissionActivity;
import com.crowdbootstrapapp.activities.OurValuesActivity;
import com.crowdbootstrapapp.activities.OurVisionActivity;
import com.crowdbootstrapapp.utilities.Constants;

/**
 * Created by neelmani.karn on 1/15/2016.
 */
public class HomeFragment extends Fragment implements View.OnClickListener {

    boolean isEntrepreneur = false, isContractor = false;
    private TextView tv_textview,  tv_vision, tv_mission, tv_values;
    private ImageView tv_howItWorks, tv_IndependentContractorRequierement, tv_explainerVideo,tv_leanstartupRoadmap;

    private ImageView img_UserSwitch;
    private boolean fromContractor = false;

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle("Home");
        getActivity().setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

    }

    public HomeFragment() {
        super();
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_home, container, false);

        try {
            MobileAds.initialize(getActivity(), Constants.Ad_UNIT_ID);

            AdView mAdView = (AdView) rootView.findViewById(R.id.adView);
            AdRequest adRequest = new AdRequest.Builder().build();
            mAdView.loadAd(adRequest);

            img_UserSwitch = (ImageView) rootView.findViewById(R.id.imageuser);
            tv_explainerVideo = (ImageView) rootView.findViewById(R.id.tv_explainerVideo);
            tv_textview = (TextView) rootView.findViewById(R.id.tv_textview);
            tv_howItWorks = (ImageView) rootView.findViewById(R.id.tv_howItWorks);
            tv_IndependentContractorRequierement = (ImageView) rootView.findViewById(R.id.tv_IndependentContractorRequierement);
            tv_vision = (TextView) rootView.findViewById(R.id.tv_vision);
            tv_mission = (TextView) rootView.findViewById(R.id.tv_mission);
            tv_values = (TextView) rootView.findViewById(R.id.tv_values);
            tv_leanstartupRoadmap = (ImageView)rootView.findViewById(R.id.tv_leanroadmap);

            tv_vision.setOnClickListener(this);
            tv_mission.setOnClickListener(this);
            tv_values.setOnClickListener(this);
            ((HomeActivity) getActivity()).mDrawerList.setItemChecked(1, true);
            //System.out.println(((HomeActivity)getActivity()).isSessionActive());

            tv_textview.setText(getString(R.string.homeScreenTextForContractor));


            img_UserSwitch.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (fromContractor == true) {
                        fromContractor = false;
                        img_UserSwitch.setImageResource(R.drawable.contractorselected);
                        tv_textview.setText(getString(R.string.homeScreenTextForContractor));
                        tv_IndependentContractorRequierement.setVisibility(View.VISIBLE);

                    } else {
                        fromContractor = true;
                        img_UserSwitch.setImageResource(R.drawable.entrepreneurselected);
                        tv_textview.setText(getString(R.string.homeScreenTextForEntrenpreur));
                        tv_IndependentContractorRequierement.setVisibility(View.VISIBLE);
                    }
                }
            });

            tv_explainerVideo.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent video = new Intent(Intent.ACTION_VIEW);
                    //video.setData(Uri.parse("https://www.youtube.com/watch?v=t4qOmcKPsC0&feature=youtu.be"));
                    video.setData(Uri.parse("https://youtu.be/t4qOmcKPsC0"));
                    startActivity(video);
                }
            });
            tv_leanstartupRoadmap.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    getActivity().setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
                    startActivity(new Intent(getActivity(), LeanStartupRoadmap.class));
                }
            });

            tv_howItWorks.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    //((HomeActivity) getActivity()).utilitiesClass.alertDialog("An entrepreneur submits a startup. If it attracts sufficient interest from the crowd of Contractors then the entrepreneur receives a $100,000 sweat equity investment of contributor's time for 5% equity. Crowd Bootstrap helps match entrepreneurs and Contractors. They agree hours of sweat equity to help complete deliverables. This is formalized by Contractors submitting deliverable-based timesheets for approval by the entrepreneur. When the startup receives a subsequent funding event, the contributor's sweat equity is converted into actual equity. Crowd Bootstrap also receives 5% equity at that first subsequent funding event. Crowd Bootstrap leverages its network to accelerate the progress of each startup but does not charge the entrepreneurs (or Contractors) for the service.");
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.howItWorks));
                }
            });

            tv_IndependentContractorRequierement.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    startActivity(new Intent(getActivity(), IndependentContractorActivity.class));
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootView;
    }


    @Override
    public void onClick(View v) {
        try {
            switch (v.getId()) {
                case R.id.tv_mission:
                    startActivity(new Intent(getActivity(), OurMissionActivity.class));
                    break;
                case R.id.tv_vision:
                    startActivity(new Intent(getActivity(), OurVisionActivity.class));
                    break;
                case R.id.tv_values:
                    startActivity(new Intent(getActivity(), OurValuesActivity.class));
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
