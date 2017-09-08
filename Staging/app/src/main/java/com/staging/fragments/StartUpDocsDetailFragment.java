package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;

import com.staging.R;
import com.staging.activities.HomeActivity;

import java.util.ArrayList;

/**
 * Created by sunakshi.gautam on 2/2/2016.
 */
public class StartUpDocsDetailFragment extends Fragment implements View.OnClickListener {

    private Spinner spinnerCurrentRoadmap, spinnerNextStep;
    private Button btnSubmitApplication, btnUploadStartupProfile, btnUpdate;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragmentstartupdocsdetails, container, false);

        spinnerCurrentRoadmap = (Spinner) rootView.findViewById(R.id.spinner_currentroadmap);
        spinnerNextStep = (Spinner) rootView.findViewById(R.id.spinner_nextstep);
        btnSubmitApplication = (Button) rootView.findViewById(R.id.submitapplication);
        btnUploadStartupProfile = (Button) rootView.findViewById(R.id.uploadstartupprofile);
        btnUpdate = (Button) rootView.findViewById(R.id.uploadstartupdoc);

        ArrayList<String> currentRoadmapType = new ArrayList<String>();
        currentRoadmapType.add("Problem");
        currentRoadmapType.add("Solution");
        ArrayAdapter<String> currentTypeAdapter = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_spinner_item, currentRoadmapType);
        currentTypeAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinnerCurrentRoadmap.setAdapter(currentTypeAdapter);


        ArrayList<String> nextRoadmapType = new ArrayList<String>();
        nextRoadmapType.add("Solution");
        nextRoadmapType.add("Implementation");
        ArrayAdapter<String> nextTypeAdapter = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_spinner_item, nextRoadmapType);
        nextTypeAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinnerNextStep.setAdapter(nextTypeAdapter);

        btnUpdate.setOnClickListener(this);
        btnUploadStartupProfile.setOnClickListener(this);
        btnSubmitApplication.setOnClickListener(this);

        return rootView;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.uploadstartupdoc:
                getActivity().onBackPressed();
                break;

            case R.id.submitapplication:

                Fragment SubmitApplication = new SubmitApplicationFragment();

                ((HomeActivity)getActivity()).replaceFragment(SubmitApplication);
                /*FragmentTransaction transactionApplication = getFragmentManager().beginTransaction();

                transactionApplication.replace(R.id.container, SubmitApplication);
                transactionApplication.addToBackStack(null);

                transactionApplication.commit();*/
                break;

            case R.id.uploadstartupprofile:


                Fragment uploadStartupProfile = new UploadStartupProfileFragment();
                ((HomeActivity)getActivity()).replaceFragment(uploadStartupProfile);
                /*FragmentTransaction transactionProfile = getFragmentManager().beginTransaction();

                transactionProfile.replace(R.id.container, uploadStartupProfile);
                transactionProfile.addToBackStack(null);

                transactionProfile.commit();*/
                break;

        }
    }
}
