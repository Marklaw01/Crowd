package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.staging.R;

/**
 * Created by sunakshi.gautam on 7/25/2016.
 */
public class CBSAppFragment  extends Fragment {
    private TextView dummyText;

    public CBSAppFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_cms, container, false);
        dummyText = (TextView) rootView.findViewById(R.id.dummyText);
        dummyText.setText("Coming soon – A list of Crowd Bootstrap applications.");
        return rootView;
    }
}
