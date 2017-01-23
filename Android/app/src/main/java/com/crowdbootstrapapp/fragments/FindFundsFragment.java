package com.crowdbootstrapapp.fragments;

import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.adapter.FundsAdapter;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.loadmore_listview.LoadMoreListView;
import com.crowdbootstrapapp.logger.CrowdBootstrapLogger;
import com.crowdbootstrapapp.models.FundsObject;
import com.crowdbootstrapapp.utilities.Constants;
import com.crowdbootstrapapp.utilities.UtilitiesClass;

import java.util.ArrayList;

/**
 * Created by Neelmani.Karn on 1/11/2017.
 */
public class FindFundsFragment extends Fragment implements AdapterView.OnItemClickListener, View.OnClickListener, AsyncTaskCompleteListener<String> {

    private EditText et_search;
    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private Button btn_createFund;
    private LoadMoreListView list_funds;
    private FundsAdapter adapter;
    private TextView btn_search;
    private ArrayList<FundsObject> fundsList;

    public FindFundsFragment() {
        super();
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            // we check that the fragment is becoming visible

            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        }
    }

    /**
     * Called when the fragment is visible to the user and actively running.
     * This is generally
     * tied to {@link Activity#onResume() Activity.onResume} of the containing
     * Activity's lifecycle.
     */
    @Override
    public void onResume() {
        super.onResume();
        //((HomeActivity) getActivity()).setOnBackPressedListener(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.funds_fragment, container, false);

        btn_search = (TextView) rootView.findViewById(R.id.btn_search);
        btn_createFund = (Button) rootView.findViewById(R.id.btn_createFund);
        btn_createFund.setVisibility(View.GONE);
        list_funds = (LoadMoreListView) rootView.findViewById(R.id.list_funds);
        fundsList = new ArrayList<>();
        adapter = new FundsAdapter(getActivity(), fundsList, Constants.NOT_LOGGED_USER, "FindFunds");
        list_funds.setAdapter(adapter);

        btn_search.setOnClickListener(this);
        list_funds.setOnItemClickListener(this);
        list_funds.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
            @Override
            public void onLoadMore() {
                list_funds.onLoadMoreComplete();
            }
        });
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

    /**
     * Called when a view has been clicked.
     *
     * @param v The view that was clicked.
     */
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_search:
                if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {

                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
                break;
        }

    }

    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.TIMEOUT_EXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            UtilitiesClass.getInstance(getActivity()).alertDialogSingleButton(getString(R.string.time_out));
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            CrowdBootstrapLogger.logInfo(result);
        }

    }
}