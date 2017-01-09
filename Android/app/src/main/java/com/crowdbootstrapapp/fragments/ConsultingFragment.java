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
public class ConsultingFragment  extends Fragment{
    private TextView dummyText;
    public ConsultingFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_cms, container, false);
        dummyText = (TextView) rootView.findViewById(R.id.dummyText);
        dummyText.setText("If you are interested in being part of a project team for a consulting assignment, please input your preferred role and the type of project that may interest you. We will send you a list of opportunities that match your preference.");
        return rootView;
    }
}