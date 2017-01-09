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
 * Created by sunakshi.gautam on 7/11/2016.
 */
public class RecruitersFragment  extends Fragment{
    private TextView dummyText;
    public RecruitersFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_cms, container, false);
        dummyText = (TextView) rootView.findViewById(R.id.dummyText);
        dummyText.setText("If you are a job recruiter, please input information about the positions you are trying to fill. We will send you a list of candidates that match your requirements.");
        return rootView;
    }
}
