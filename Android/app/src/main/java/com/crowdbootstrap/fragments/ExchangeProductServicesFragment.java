package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;

/**
 * Created by sunakshi.gautam on 7/22/2016.
 */
public class ExchangeProductServicesFragment extends Fragment {
    private TextView dummyText;
    public ExchangeProductServicesFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_cms, container, false);
        dummyText = (TextView) rootView.findViewById(R.id.dummyText);
        dummyText.setText("Coming soon - An App that enables startups to barter products and services.");

        try {
            ((HomeActivity) getActivity()).setActionBarTitle("Product/Service Exchange");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootView;
    }
}