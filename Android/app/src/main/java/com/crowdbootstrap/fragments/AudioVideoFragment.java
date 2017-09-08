package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.crowdbootstrap.R;

/**
 * \\\\\\
 *
 *
 *
 * Created by neelmani.karn on 3/14/2016.
 */
public class AudioVideoFragment extends Fragment {
    private TextView dummyText;
    public AudioVideoFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_cms, container, false);
        dummyText = (TextView)rootView.findViewById(R.id.dummyText);
        dummyText.setText("Coming soon - A list of communal audio and video resources that are available for use by Crowd Bootstrap startups.");

        return rootView;
    }
}
