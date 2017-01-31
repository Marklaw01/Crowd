package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.crowdbootstrap.R;

/**
 * Created by sunakshi.gautam on 7/25/2016.
 */
public class BoardMembersFragment  extends Fragment {
    private TextView dummyText;

    public BoardMembersFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_cms, container, false);
        dummyText = (TextView) rootView.findViewById(R.id.dummyText);
        dummyText.setText("If you are interested in being a Board Member, please input the types of products and businesses that may interest you. We will send you a list of opportunities that match your preference.");
        return rootView;
    }
}