package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.staging.R;
import com.staging.loadmore_listview.LoadMoreListView;

/**
 * Created by Neelmani.Karn on 1/11/2017.
 */
public class DeactivatedFundsFragment extends Fragment {
    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private Button btn_addCampaign;
    private LoadMoreListView list_compaigns;

    public DeactivatedFundsFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.funds_fragment, container, false);

        btn_addCampaign = (Button) rootView.findViewById(R.id.btn_createFund);

        list_compaigns = (LoadMoreListView) rootView.findViewById(R.id.list_funds);
        return rootView;
    }
}
