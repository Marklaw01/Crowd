package com.crowdbootstrapapp.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.TextView;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;

/**
 * Created by sunakshi.gautam on 7/22/2016.
 */
public class GroupBuyingFragment extends Fragment{
    private TextView dummyText;
    public GroupBuyingFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_cms, container, false);
        dummyText = (TextView) rootView.findViewById(R.id.dummyText);
        dummyText.setText("Comming soon - A Group Purchasing application that leverages purchasing volume to reduce price and improve terms and conditons.");

        try {
            ((HomeActivity) getActivity()).setActionBarTitle("Group Buying");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootView;
    }
}