package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.adapter.BusinessNetworkAdapter;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.models.ContractorsObject;
import com.crowdbootstrap.utilities.AsyncNew;
import com.crowdbootstrap.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 12/12/2017.
 */

public class ConnectionsAtLatLongFragment extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {

    private Button btn_addBusinessCard;
    private ListView list_businesscard;
    private BusinessNetworkAdapter adapter;
    private ArrayList<ContractorsObject> contractorsList;


    public ConnectionsAtLatLongFragment() {
        super();
    }


    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle("Connections");
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_mybusinesscards, container, false);

        btn_addBusinessCard = (Button) rootView.findViewById(R.id.btn_createBusinessCard);

        list_businesscard = (ListView) rootView.findViewById(R.id.list_businesscard);


        btn_addBusinessCard.setVisibility(View.GONE);
        adapter = null;


        String latitude = getArguments().getString("latitude").toString().trim();
        String longitude = getArguments().getString("longitude").toString().trim();


        try {
            if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {

                JSONObject object = new JSONObject();
                object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                object.put("latitude", latitude);
                object.put("longitude", longitude);
                AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_IN_LAT_LONG_TAG, Constants.USER_IN_LAT_LONG_URL, Constants.HTTP_POST_REQUEST, object);
                a.execute();
            } else {

                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        list_businesscard.setOnItemClickListener(this);
        return rootView;
    }

    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
        Bundle like = new Bundle();
        like.putString("connection_id", contractorsList.get(i).getId());
        like.putString("is_network", "");
        like.putString("business_contact_type", contractorsList.get(i).getBusinessConnectionTypeId());
        like.putString("card_id", contractorsList.get(i).getCardId());
        like.putString("userName", contractorsList.get(i).getContractorName());
        like.putString("userImage", contractorsList.get(i).getImage());
        like.putString("noteId", "");
        like.putString("comingFrom", "SearchConnections");

        Fragment likeFragment = new ViewBusinessCardFragment();
        likeFragment.setArguments(like);
        FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        fragmentTransaction.add(R.id.container, likeFragment);
        fragmentTransaction.addToBackStack(null);

        fragmentTransaction.commit();
    }

    @Override
    public void onTaskComplete(String result, String tag) {
        try {
            if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
            } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
            } else {
                if (tag.equalsIgnoreCase(Constants.USER_IN_LAT_LONG_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        Log.e("XXXX", "RESPONSE+++++" + jsonObject.toString());
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            contractorsList = new ArrayList<>();

                            if (jsonObject.optJSONArray("user_list").length() != 0) {
                                for (int i = 0; i < jsonObject.optJSONArray("user_list").length(); i++) {
                                    JSONObject contracotrs = jsonObject.optJSONArray("user_list").getJSONObject(i);
                                    ContractorsObject obj = new ContractorsObject();
                                    obj.setIsPublicProfile("");
                                    obj.setId(contracotrs.optString("user_id"));
                                    obj.setImage(contracotrs.optString("user_image"));
                                    obj.setIsNetwork("");
                                    obj.setBusinessConnectionTypeId(contracotrs.optString("connection_type_id"));
                                    obj.setCardId(contracotrs.optString("card_id"));
                                    obj.setContractorName(contracotrs.optString("user_name"));


                                    contractorsList.add(obj);
                                    //Log.e("XXX","NAME"+contracotrs.optString("name")+"++++++ISPUBLIC"+contracotrs.optString("is_profile_public"));

                                }
                            } else {
                                Toast.makeText(getActivity(), "No Contractors found", Toast.LENGTH_LONG).show();
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No Contractors found", Toast.LENGTH_LONG).show();
                        }


                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                        Log.e("XXX", "Exception+++++" + e.getMessage());
                    }

                    if (adapter == null) {
                        adapter = new BusinessNetworkAdapter(getActivity(), contractorsList, "search", "   ");
                        list_businesscard.setAdapter(adapter);
                    }

                    adapter.notifyDataSetChanged();

                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

    }
}
