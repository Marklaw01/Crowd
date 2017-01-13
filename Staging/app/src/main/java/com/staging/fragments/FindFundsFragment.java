package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.FundsAdapter;
import com.staging.loadmore_listview.LoadMoreListView;

/**
 * Created by Neelmani.Karn on 1/11/2017.
 */
public class FindFundsFragment extends Fragment implements AdapterView.OnItemClickListener {

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private Button btn_addCampaign;
    private LoadMoreListView list_funds;
    private FundsAdapter adapter;

    public FindFundsFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.funds_fragment, container, false);

        btn_addCampaign = (Button) rootView.findViewById(R.id.btn_createFund);
        btn_addCampaign.setVisibility(View.GONE);
        list_funds = (LoadMoreListView) rootView.findViewById(R.id.list_funds);

        adapter = new FundsAdapter(getActivity());
        list_funds.setAdapter(adapter);

        list_funds.setOnItemClickListener(this);
        return rootView;
    }

    /**
     * Callback method to be invoked when an item in this AdapterView has
     * been clicked.
     * <p>
     * Implementers can call getItemAtPosition(position) if they need
     * to access the data associated with the selected item.
     *
     * @param parent   The AdapterView where the click happened.
     * @param view     The view within the AdapterView that was clicked (this
     *                 will be a view provided by the adapter)
     * @param position The position of the view in the adapter.
     * @param id       The row id of the item that was clicked.
     */
    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        ((HomeActivity) getActivity()).replaceFragment(new FundDetailFragment());
    }
}