package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.crowdbootstrap.R;

/**
 * Created by neelmani.karn on 3/14/2016.
 */
public class EarlyAdatorsFragment  extends Fragment {
    private TextView dummyText;
    public EarlyAdatorsFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_cms, container, false);
        dummyText = (TextView) rootView.findViewById(R.id.dummyText);
        dummyText.setText("If you are interested in being an early adopter customer, please input the types of products and businesses that may interest you. We will send you a list of offerings that match your preference.");
        return rootView;
    }
}