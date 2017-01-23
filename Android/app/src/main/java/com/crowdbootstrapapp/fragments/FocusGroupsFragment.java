package com.crowdbootstrapapp.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.crowdbootstrapapp.R;

/**
 * Created by neelmani.karn on 3/14/2016.
 */
public class FocusGroupsFragment  extends Fragment {
    private TextView dummyText;
    public FocusGroupsFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_cms, container, false);
        dummyText = (TextView) rootView.findViewById(R.id.dummyText);
        dummyText.setText("If you are interested in participating in focus groups, please input the types of products, businesses and focus groups that may interest you. We will send you a list of opportunities that match your preference.");
        return rootView;
    }
}