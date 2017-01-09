package com.crowdbootstrapapp.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.crowdbootstrapapp.R;

/**
 * Created by sunakshi.gautam on 7/25/2016.
 */
public class CommunalAssetsFragment  extends Fragment {
    private TextView dummyText;
    public CommunalAssetsFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_cms, container, false);
        dummyText = (TextView) rootView.findViewById(R.id.dummyText);
        dummyText.setText("If you are interested in providing assets for communal use, please input a description of each asset and its use. We will add the assets to the communal portfolio.");
        return rootView;
    }
}
