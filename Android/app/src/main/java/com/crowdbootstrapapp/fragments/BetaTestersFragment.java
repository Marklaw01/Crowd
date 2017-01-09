package com.crowdbootstrapapp.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.TextView;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.utilities.Constants;

/**
 * Created by neelmani.karn on 3/14/2016.
 */
public class BetaTestersFragment  extends Fragment{
    private TextView dummyText;
    public BetaTestersFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_cms, container, false);
        dummyText = (TextView) rootView.findViewById(R.id.dummyText);
        dummyText.setText("If you are interested in being a beta tester, please input the types of products and businesses that may interest you. We will send you a list of opportunities that match your preference.");
        return rootView;
    }
}