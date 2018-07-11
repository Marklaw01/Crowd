package com.staging.fragments;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.staging.R;
import com.staging.activities.GettingStartedVideoActivity;

/**
 * Created by sunakshi.gautam on 9/13/2017.
 */

public class GettingStartedFragment extends Fragment implements View.OnClickListener {


    private ImageView gettingStartedEntrepreneur;
    private ImageView gettingStartedRecruiter;
    private ImageView gettingstartedExpert;
    private ImageView gettingStartedSponsor;
    private ImageView gettingStartedHomePage;
    private ImageView gettingStartedVideo;
    private TextView homeText, alertText, newsText, networkingText;


    public GettingStartedFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.gettingstarted_layout, container, false);
        gettingStartedEntrepreneur = (ImageView) rootView.findViewById(R.id.imageViewEntrepreneur);
        gettingstartedExpert = (ImageView) rootView.findViewById(R.id.imageViewExpert);
        gettingStartedRecruiter = (ImageView) rootView.findViewById(R.id.imageViewRecruiter);
        gettingStartedSponsor = (ImageView) rootView.findViewById(R.id.imageViewSponsor);
        gettingStartedHomePage = (ImageView) rootView.findViewById(R.id.imageViewHomePage);
        gettingStartedVideo = (ImageView) rootView.findViewById(R.id.imageViewGettingStarted);

        homeText = (TextView) rootView.findViewById(R.id.homeTab);
        newsText = (TextView) rootView.findViewById(R.id.newsTab);
        alertText = (TextView) rootView.findViewById(R.id.alertTab);
        networkingText = (TextView) rootView.findViewById(R.id.networkingTab);

        homeText.setOnClickListener(this);
        newsText.setOnClickListener(this);
        alertText.setOnClickListener(this);
        networkingText.setOnClickListener(this);

        gettingStartedEntrepreneur.setOnClickListener(this);
        gettingstartedExpert.setOnClickListener(this);
        gettingStartedSponsor.setOnClickListener(this);
        gettingStartedHomePage.setOnClickListener(this);
        gettingStartedRecruiter.setOnClickListener(this);
        gettingStartedVideo.setOnClickListener(this);

        return rootView;
    }


    @Override
    public void onClick(View v) {

        FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        switch (v.getId()) {
            case R.id.imageViewEntrepreneur:
                gettingStartedEntrepreneur.setImageResource(R.drawable.gettingstartedentre);
                gettingStartedRecruiter.setImageResource(R.drawable.gettingstartedbluerecruit);
                gettingStartedVideo.setImageResource(R.drawable.gettingstartedbluevideo);
                gettingStartedSponsor.setImageResource(R.drawable.gettingstartedbluesponsor);
                gettingStartedHomePage.setImageResource(R.drawable.gettingstartedbluehomepage);
                gettingstartedExpert.setImageResource(R.drawable.gettingstartedblueexpert);


                final AlertDialog alertDialog = new AlertDialog.Builder(
                        getActivity(), R.style.MyDialogTheme).create();

                // Setting Dialog Title
                alertDialog.setTitle("Description");

                // Setting Dialog Message
                alertDialog.setMessage("If you are an Entrepreneur, click the menu option in the top left corner of the screen then select \"My Profile\" to create your \"Entrepreneur\" profile. Then select the \"Startup\" option on the menu to submit your startup application and create a startup profile.");

                // Setting Icon to Dialog

                // Setting OK Button
                alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // Write your code here to execute after dialog closed
                        alertDialog.dismiss();
                    }
                });

                // Showing Alert Message
                alertDialog.show();

                break;

            case R.id.imageViewExpert:
                gettingStartedEntrepreneur.setImageResource(R.drawable.gettingstartedblueentre);
                gettingStartedRecruiter.setImageResource(R.drawable.gettingstartedbluerecruit);
                gettingStartedVideo.setImageResource(R.drawable.gettingstartedbluevideo);
                gettingStartedSponsor.setImageResource(R.drawable.gettingstartedbluesponsor);
                gettingStartedHomePage.setImageResource(R.drawable.gettingstartedbluehomepage);
                gettingstartedExpert.setImageResource(R.drawable.gettingstartedexpert);

                final AlertDialog alertDialogExpert = new AlertDialog.Builder(
                        getActivity(), R.style.MyDialogTheme).create();

                // Setting Dialog Title
                alertDialogExpert.setTitle("Description");

                // Setting Dialog Message
                alertDialogExpert.setMessage("If you are an Expert, click the menu option in the top left corner of the screen then select \"My Profile\" to create your \"Contractor\" profile. Then select the \"Contractors\" option on the menu to start helping innovative startups.");

                // Setting Icon to Dialog

                // Setting OK Button
                alertDialogExpert.setButton("OK", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // Write your code here to execute after dialog closed
                        alertDialogExpert.dismiss();
                    }
                });

                // Showing Alert Message
                alertDialogExpert.show();
                break;
            case R.id.imageViewRecruiter:
                gettingStartedEntrepreneur.setImageResource(R.drawable.gettingstartedblueentre);
                gettingStartedRecruiter.setImageResource(R.drawable.gettingstartedrecruit);
                gettingStartedVideo.setImageResource(R.drawable.gettingstartedbluevideo);
                gettingStartedSponsor.setImageResource(R.drawable.gettingstartedbluesponsor);
                gettingStartedHomePage.setImageResource(R.drawable.gettingstartedbluehomepage);
                gettingstartedExpert.setImageResource(R.drawable.gettingstartedblueexpert);


                final AlertDialog alertDialogRecruit = new AlertDialog.Builder(
                        getActivity(), R.style.MyDialogTheme).create();

                // Setting Dialog Title
                alertDialogRecruit.setTitle("Description");

                // Setting Dialog Message
                alertDialogRecruit.setMessage("If you are a Recruiter, click the menu option in the top left corner of the screen then select \"My Profile\" to create a profile. Then select the \"Opportunities\" option on the menu to submit your job posting or search for job candidates whose job performance has been rated and validated by entrepreneurs.");

                // Setting Icon to Dialog

                // Setting OK Button
                alertDialogRecruit.setButton("OK", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // Write your code here to execute after dialog closed
                        alertDialogRecruit.dismiss();
                    }
                });

                // Showing Alert Message
                alertDialogRecruit.show();

                break;
            case R.id.imageViewSponsor:
                gettingStartedEntrepreneur.setImageResource(R.drawable.gettingstartedblueentre);
                gettingStartedRecruiter.setImageResource(R.drawable.gettingstartedbluerecruit);
                gettingStartedVideo.setImageResource(R.drawable.gettingstartedbluevideo);
                gettingStartedSponsor.setImageResource(R.drawable.gettingstartedsponsor);
                gettingStartedHomePage.setImageResource(R.drawable.gettingstartedbluehomepage);
                gettingstartedExpert.setImageResource(R.drawable.gettingstartedblueexpert);

                final AlertDialog alertDialogSponsor = new AlertDialog.Builder(
                        getActivity(), R.style.MyDialogTheme).create();

                // Setting Dialog Title
                alertDialogSponsor.setTitle("Description");

                // Setting Dialog Message
                alertDialogSponsor.setMessage("If you are an Organization, click the menu option in the top left corner of the screen then select the \"Organization\" option. You can create a organization page to explain your offerings. You can also sponsor events or even sponsor your own accelerator to access innovative startups in your industry.");

                // Setting Icon to Dialog

                // Setting OK Button
                alertDialogSponsor.setButton("OK", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // Write your code here to execute after dialog closed
                        alertDialogSponsor.dismiss();
                    }
                });

                // Showing Alert Message
                alertDialogSponsor.show();
                break;

            case R.id.imageViewHomePage:
                gettingStartedEntrepreneur.setImageResource(R.drawable.gettingstartedblueentre);
                gettingStartedRecruiter.setImageResource(R.drawable.gettingstartedbluerecruit);
                gettingStartedVideo.setImageResource(R.drawable.gettingstartedbluevideo);
                gettingStartedSponsor.setImageResource(R.drawable.gettingstartedbluesponsor);
                gettingStartedHomePage.setImageResource(R.drawable.gettingstartedhomepage);
                gettingstartedExpert.setImageResource(R.drawable.gettingstartedblueexpert);
                HomeFragment.selectedPosition = 0;
                Fragment homeFragmentnew = new HomeFragment();

                fragmentTransaction.replace(R.id.container, homeFragmentnew);

                fragmentTransaction.commit();

//
//                Intent go = new Intent((HomeActivity) getActivity(), HomeActivity.class);
//                go.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
//                startActivity(go);
//                finish();

                break;
            case R.id.imageViewGettingStarted:
                gettingStartedEntrepreneur.setImageResource(R.drawable.gettingstartedblueentre);
                gettingStartedRecruiter.setImageResource(R.drawable.gettingstartedbluerecruit);
                gettingStartedVideo.setImageResource(R.drawable.gettingstartedvideo);
                gettingStartedSponsor.setImageResource(R.drawable.gettingstartedbluesponsor);
                gettingStartedHomePage.setImageResource(R.drawable.gettingstartedbluehomepage);
                gettingstartedExpert.setImageResource(R.drawable.gettingstartedblueexpert);
                Intent goGettingStarted = new Intent(getActivity(), GettingStartedVideoActivity.class);
                startActivity(goGettingStarted);
                break;


            case R.id.homeTab:
                HomeFragment.selectedPosition = 0;
                Fragment currentBlogsDetails = new HomeFragment();



                fragmentTransaction.replace(R.id.container, currentBlogsDetails);

                fragmentTransaction.commit();
                break;

            case R.id.newsTab:
                HomeFragment.selectedPosition = 1;
                Fragment homeFragment = new HomeFragment();

                fragmentTransaction.replace(R.id.container, homeFragment);

                fragmentTransaction.commit();
                break;

            case R.id.alertTab:
                HomeFragment.selectedPosition = 2;
                Fragment homeFragment1 = new HomeFragment();

                fragmentTransaction.replace(R.id.container, homeFragment1);

                fragmentTransaction.commit();
                break;

            case R.id.networkingTab:
                HomeFragment.selectedPosition = 3;
                Fragment homeFragment2 = new HomeFragment();

                fragmentTransaction.replace(R.id.container, homeFragment2);

                fragmentTransaction.commit();
                break;
        }
    }
}
