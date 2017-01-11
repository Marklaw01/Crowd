package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.staging.R;

/**
 * Created by Neelmani.Karn on 1/11/2017.
 */
public class FundDetailFragment extends Fragment {


    public FundDetailFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fund_details_fragment, container, false);





        return rootView;
    }

}
