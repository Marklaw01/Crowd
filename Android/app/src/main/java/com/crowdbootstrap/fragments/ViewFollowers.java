package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.helper.CircleImageView;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.models.ContractorsObject;
import com.crowdbootstrap.swipelistview_withoutscrollview.SwipeMenuListView;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 12/8/2016.
 */
public class ViewFollowers extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {
    private String COMMING_FROM = "";
    private ViewContratorsAdapter adapter;
    private SwipeMenuListView list;
    private ArrayList<ContractorsObject> contractorsObjectArrayList;
    int pos = 0;

    public ViewFollowers() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_view_contractors, container, false);
        ((HomeActivity) getActivity()).setActionBarTitle(getArguments().getString("JOB_TILE"));


        contractorsObjectArrayList = new ArrayList<ContractorsObject>();
        list = (SwipeMenuListView) rootView.findViewById(R.id.list);
        list.onLoadMoreComplete();
        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();

            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.VIEW_FOLLOWERS_TAG, Constants.VIEW_FOLLOWERS_URL + "?job_id=" + getArguments().getString("JOB_ID")+"&user_id="+((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET, "Home Activity");
            a.execute();

        } else {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }


        // step 1. create a MenuCreator

        // set creator


        list.setOnItemClickListener(this);


        return rootView;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        try {
            Fragment addContributor = new ViewContractorPublicProfileFragment();
            Bundle bundle = new Bundle();
            bundle.putString("COMMING_FROM", "CAMPAIGNS");
            bundle.putString("id", contractorsObjectArrayList.get(position).getId());

            addContributor.setArguments(bundle);
            ((HomeActivity) getActivity()).replaceFragment(addContributor);
            /*FragmentTransaction transactionAdd = getFragmentManager().beginTransaction();
            transactionAdd.replace(R.id.container, addContributor);
            transactionAdd.addToBackStack(null);

            transactionAdd.commit();*/
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private int dp2px(int dp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp,
                getResources().getDisplayMetrics());
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
    }


    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            if (tag.equalsIgnoreCase(Constants.VIEW_FOLLOWERS_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        JSONArray campaignContributorsList = jsonObject.optJSONArray("followersList");

                        for (int i = 0; i < campaignContributorsList.length(); i++) {
                            try {
                                ContractorsObject obj = new ContractorsObject();
                                obj.setContractorName(campaignContributorsList.getJSONObject(i).getString("name"));
                                obj.setId(campaignContributorsList.getJSONObject(i).getString("id"));
                                obj.setImage(Constants.APP_IMAGE_URL + campaignContributorsList.getJSONObject(i).getString("image"));
                                obj.setContractorRate(((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat(campaignContributorsList.getJSONObject(i).getString("rate")));


                                contractorsObjectArrayList.add(obj);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            } catch (NumberFormatException e) {
                                e.printStackTrace();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }


                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "No Contractor available", Toast.LENGTH_LONG).show();
                    }
                    adapter = new ViewContratorsAdapter();
                    list.setAdapter(adapter);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }
    }


    class ViewContratorsAdapter extends BaseAdapter {
        private LayoutInflater l_Inflater;

        public ViewContratorsAdapter() {
            l_Inflater = LayoutInflater.from(getActivity());
        }

        @Override
        public int getCount() {
            return contractorsObjectArrayList.size();
        }

        @Override
        public Object getItem(int position) {
            return contractorsObjectArrayList.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            ViewHolder holder;
            if (convertView == null) {
                convertView = l_Inflater.inflate(R.layout.view_contractors_row_item, null);
                holder = new ViewHolder();
                holder.tv_ContractorName = (TextView) convertView.findViewById(R.id.tv_ContractorName);
                holder.tv_contractorContribution = (TextView) convertView.findViewById(R.id.tv_contractorContribution);
                holder.userimage = (CircleImageView) convertView.findViewById(R.id.userimage);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            try {
                holder.tv_ContractorName.setText(contractorsObjectArrayList.get(position).getContractorName());
                holder.tv_contractorContribution.setText(contractorsObjectArrayList.get(position).getContractorRate());
                ImageLoader.getInstance().displayImage(contractorsObjectArrayList.get(position).getImage(), holder.userimage, ((HomeActivity) getActivity()).options);
            } catch (Exception e) {
                e.printStackTrace();
            }

            return convertView;
        }

        class ViewHolder {
            TextView tv_ContractorName, tv_contractorContribution;
            CircleImageView userimage;
        }
    }
}
