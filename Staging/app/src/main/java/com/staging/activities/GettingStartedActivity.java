package com.staging.activities;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Toast;

import com.staging.R;

/**
 * Created by Sunakshi.Gautam on 12/13/2016.
 */
public class GettingStartedActivity extends BaseActivity implements View.OnClickListener {


    private ImageView gettingStartedEntrepreneur;
    private ImageView gettingStartedRecruiter;
    private ImageView gettingstartedExpert;
    private ImageView gettingStartedSponsor;
    private ImageView gettingStartedHomePage;
    private ImageView gettingStartedVideo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.gettingstarted_layout);
        gettingStartedEntrepreneur = (ImageView) findViewById(R.id.imageViewEntrepreneur);
        gettingstartedExpert = (ImageView) findViewById(R.id.imageViewExpert);
        gettingStartedRecruiter = (ImageView) findViewById(R.id.imageViewRecruiter);
        gettingStartedSponsor = (ImageView) findViewById(R.id.imageViewSponsor);
        gettingStartedHomePage = (ImageView) findViewById(R.id.imageViewHomePage);
        gettingStartedVideo = (ImageView) findViewById(R.id.imageViewGettingStarted);


        gettingStartedEntrepreneur.setOnClickListener(this);
        gettingstartedExpert.setOnClickListener(this);
        gettingStartedSponsor.setOnClickListener(this);
        gettingStartedHomePage.setOnClickListener(this);
        gettingStartedRecruiter.setOnClickListener(this);
        gettingStartedVideo.setOnClickListener(this);


}

    @Override
    public void setActionBarTitle(String title) {

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.imageViewEntrepreneur:
                gettingStartedEntrepreneur.setImageResource(R.drawable.gettingstartedentre);
                gettingStartedRecruiter.setImageResource(R.drawable.gettingstartedbluerecruit);
                gettingStartedVideo.setImageResource(R.drawable.gettingstartedbluevideo);
                gettingStartedSponsor.setImageResource(R.drawable.gettingstartedbluesponsor);
                gettingStartedHomePage.setImageResource(R.drawable.gettingstartedbluehomepage);
                gettingstartedExpert.setImageResource(R.drawable.gettingstartedblueexpert);


                final AlertDialog alertDialog = new AlertDialog.Builder(
                        GettingStartedActivity.this).create();

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
                        GettingStartedActivity.this).create();

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
                        GettingStartedActivity.this).create();

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
                        GettingStartedActivity.this).create();

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


                Intent go = new Intent(GettingStartedActivity.this, HomeActivity.class);
                startActivity(go);


                break;
            case R.id.imageViewGettingStarted:
                gettingStartedEntrepreneur.setImageResource(R.drawable.gettingstartedblueentre);
                gettingStartedRecruiter.setImageResource(R.drawable.gettingstartedbluerecruit);
                gettingStartedVideo.setImageResource(R.drawable.gettingstartedvideo);
                gettingStartedSponsor.setImageResource(R.drawable.gettingstartedbluesponsor);
                gettingStartedHomePage.setImageResource(R.drawable.gettingstartedbluehomepage);
                gettingstartedExpert.setImageResource(R.drawable.gettingstartedblueexpert);
                Intent goGettingStarted = new Intent(GettingStartedActivity.this, GettingStartedVideoActivity.class);
                startActivity(goGettingStarted);
                break;

        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        finish();
    }

    @Override
    public void onSessionCreated(boolean success) {

    }
}
