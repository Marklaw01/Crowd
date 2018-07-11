package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.MyBusinessCardAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.logger.CrowdBootstrapLogger;
import com.staging.models.BusinessCardObject;
import com.staging.utilities.Async;
import com.staging.utilities.AsyncNew;
import com.staging.utilities.Constants;
import com.staging.utilities.UtilitiesClass;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 11/9/2017.
 */

public class NetworkingBusinessCardFragment extends Fragment implements AdapterView.OnItemClickListener, View.OnClickListener, AsyncTaskCompleteListener<String> {

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private Button btn_addBusinessCard;
    private ListView list_businesscard;
    private MyBusinessCardAdapter adapter;
    private ArrayList<BusinessCardObject> businessCardList;
    private AsyncNew asyncNew;


    public NetworkingBusinessCardFragment() {
        super();
    }


    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle("My Business Cards");
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
    }



    /**
     * Called when the Fragment is no longer resumed.  This is generally
     * tied to {@link android.app.Activity#onPause() Activity.onPause} of the containing
     * Activity's lifecycle.
     *//*
    @Override
    public void onPause() {
        super.onPause();
        if (asyncNew.getStatus() == AsyncTask.Status.RUNNING) {
            asyncNew.cancel(true);
        }
    }*/
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_mybusinesscards, container, false);

        btn_addBusinessCard = (Button) rootView.findViewById(R.id.btn_createBusinessCard);

        list_businesscard = (ListView) rootView.findViewById(R.id.list_businesscard);

        /*adapter = new FundsAdapter(getActivity(), Constants.LOGGED_USER, "MyFunds");
        list_businesscard.setAdapter(adapter);*/

        btn_addBusinessCard.setOnClickListener(this);
        list_businesscard.setOnItemClickListener(this);


        businessCardList = new ArrayList<>();
        adapter = null;


        String UserID = ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID);
        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
            ((HomeActivity) getActivity()).showProgressDialog();
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.GET_MY_BUSINESS_CARD_TAG, Constants.GET_MY_BUSINESS_CARD_URL + "?user_id=" + UserID, Constants.HTTP_GET, "Home Activity");
            a.execute();

        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }

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
        Bundle bundle = new Bundle();
        bundle.putString("CARD_ID", businessCardList.get(position).getCardID());
        bundle.putString("CARD_TITLE", businessCardList.get(position).getCardTitle());
        UpdateBusinessCardFragment updateFundFragment = new UpdateBusinessCardFragment();
        updateFundFragment.setArguments(bundle);
        ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
    }

    /**
     * Called when a view has been clicked.
     *
     * @param v The view that was clicked.
     */
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_createBusinessCard:
                ((HomeActivity) getActivity()).replaceFragment(new AddBusinessCardFragment());
                break;

        }
    }

    /**
     * When network give response in this.
     *
     * @param result
     * @param tag
     */
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
            if (tag.equalsIgnoreCase(Constants.GET_MY_BUSINESS_CARD_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);


                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {


                        if (jsonObject.optJSONArray("businessCards").length() != 0) {
                            for (int i = 0; i < jsonObject.optJSONArray("businessCards").length(); i++) {
                                JSONObject funds = jsonObject.optJSONArray("businessCards").getJSONObject(i);

                                BusinessCardObject businessCardObject = new BusinessCardObject();
                                businessCardObject.setCardID(funds.optString("card_id"));
                                businessCardObject.setCardTitle("Business Card "+ String.valueOf(i+1));
                                businessCardObject.setCardDescription(funds.optString("user_bio"));
                                businessCardObject.setCardInterest(funds.optString("user_interest"));
                                businessCardObject.setCardImage(funds.optString("image"));
                                businessCardObject.setStatus(funds.optString("status"));


                                businessCardList.add(businessCardObject);

                            }
                        } else {
                            Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                        }

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    Log.e("XXX","ERROR++++++"+ e.getMessage());
                    Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
                }

                if (adapter == null) {
                    adapter = new MyBusinessCardAdapter(getActivity(), businessCardList, "MyFunds");
                    list_businesscard.setAdapter(adapter);
                }

            }
        }
        CrowdBootstrapLogger.logInfo(result);
    }
}
