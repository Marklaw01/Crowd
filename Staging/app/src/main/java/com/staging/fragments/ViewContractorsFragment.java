package com.staging.fragments;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
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

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.helper.CircleImageView;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.logger.CrowdBootstrapLogger;
import com.staging.models.ContractorsObject;
import com.staging.swipelistview_withoutscrollview.SwipeMenu;
import com.staging.swipelistview_withoutscrollview.SwipeMenuCreator;
import com.staging.swipelistview_withoutscrollview.SwipeMenuItem;
import com.staging.swipelistview_withoutscrollview.SwipeMenuListView;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.nostra13.universalimageloader.core.ImageLoader;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 2/8/2016.
 */

public class ViewContractorsFragment extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {
    private String COMMING_FROM = "";
    private ViewContratorsAdapter adapter;
    private SwipeMenuListView list;
    private ArrayList<ContractorsObject> contractorsObjectArrayList;
    int pos = 0;

    public ViewContractorsFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_view_contractors, container, false);
        ((HomeActivity) getActivity()).setActionBarTitle(getArguments().getString("CAMPAIGN_NAME"));
        COMMING_FROM = getArguments().getString("CommingFrom");

        contractorsObjectArrayList = new ArrayList<ContractorsObject>();
        list = (SwipeMenuListView) rootView.findViewById(R.id.list);
        list.onLoadMoreComplete();
        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();

            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CAMPAIGN_CONTRIBUTORS_LIST_TAG, Constants.CAMPAIGN_CONTRIBUTORS_LIST_URL + "?campaign_id=" + getArguments().getString("CAMPAIGN_ID"), Constants.HTTP_GET,"Home Activity");
            a.execute();

        } else {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }


        // step 1. create a MenuCreator
        SwipeMenuCreator creator = new SwipeMenuCreator() {

            @Override
            public void create(SwipeMenu menu) {
                // create "open" item
                SwipeMenuItem close = new SwipeMenuItem(getActivity().getApplicationContext());
                Drawable id = getResources().getDrawable(R.color.darkRed);
                close.setBackground(id);
                close.setIcon(getResources().getDrawable(R.drawable.close));
                // set item width
                close.setWidth(dp2px(90));
                // set item title
                close.setTitle("Reject");
                // set item title fontsize
                close.setTitleSize(15);
                // set item title font color
                close.setTitleColor(Color.WHITE);
                // add to menu
                menu.addMenuItem(close);


            }
        };
        // set creator
        if (COMMING_FROM.equalsIgnoreCase("EditCampaign")) {
            list.setMenuCreator(creator);
        }

        list.setOnItemClickListener(this);
        list.setOnMenuItemClickListener(new SwipeMenuListView.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(final int position, SwipeMenu menu, int index) {
                final ContractorsObject obj = contractorsObjectArrayList.get(position);

                switch (index) {
                    case 0:
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                            alertDialogBuilder
                                    .setMessage("Do you accept this commitment on your campaign?")
                                    .setCancelable(false)
                                    .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                        @Override
                                        public void onClick(DialogInterface dialog, int arg1) {
                                            dialog.cancel();
                                            ((HomeActivity) getActivity()).showProgressDialog();
                                            pos = position;
                                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.DELETE_COMMIT_USER_TAG, Constants.DELETE_COMMIT_USER_URL + "?user_id=" + obj.getId() + "&campaign_id=" + getArguments().getString("CAMPAIGN_ID"), Constants.HTTP_GET,"Home Activity");
                                            a.execute();
                                        }
                                    })
                                    .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                        @Override
                                        public void onClick(DialogInterface dialog, int arg1) {
                                            dialog.cancel();
                                        }
                                    });

                            AlertDialog alertDialog = alertDialogBuilder.create();

                            alertDialog.show();
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                        break;

                }

                return false;
            }
        });


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
            ((HomeActivity)getActivity()).replaceFragment(addContributor);
            /*FragmentTransaction transactionAdd = getFragmentManager().beginTransaction();
            transactionAdd.replace(R.id.container, addContributor);
            transactionAdd.addToBackStack(null);

            transactionAdd.commit();*/
        } catch (Exception e) {
            e.printStackTrace();
            CrowdBootstrapLogger.logError(getActivity(), new Object() {
            }.getClass().getEnclosingMethod().getName(), e, ViewContractorsFragment.this.getClass().getName());
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
            if (tag.equalsIgnoreCase(Constants.CAMPAIGN_CONTRIBUTORS_LIST_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        JSONArray campaignContributorsList = jsonObject.optJSONArray("campaignContributorsList");

                        for (int i = 0; i < campaignContributorsList.length(); i++) {
                            try {
                                ContractorsObject obj = new ContractorsObject();
                                obj.setContractorName(campaignContributorsList.getJSONObject(i).getString("contractor_name"));
                                obj.setId(campaignContributorsList.getJSONObject(i).getString("contractor_id"));
                                obj.setImage(Constants.APP_IMAGE_URL + campaignContributorsList.getJSONObject(i).getString("contractor_image"));
                                obj.setIsContributorType(Integer.parseInt(campaignContributorsList.getJSONObject(i).getString("status")));

                                if (COMMING_FROM.equalsIgnoreCase("CampaignDetails")) {
                                    if (obj.isContributorType() == 1) {
                                        if (obj.getId().equalsIgnoreCase(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID))) {
                                            obj.setContractorRate(((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat(campaignContributorsList.getJSONObject(i).getString("contractor_contribution")));
                                        } else {
                                            obj.setContractorRate("x.xx");
                                        }
                                    } else {
                                        obj.setContractorRate(((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat(campaignContributorsList.getJSONObject(i).getString("contractor_contribution")));
                                    }
                                } else {
                                    obj.setContractorRate(((HomeActivity) getActivity()).utilitiesClass.changeInUSCurrencyFormat(campaignContributorsList.getJSONObject(i).getString("contractor_contribution")));
                                }

                                contractorsObjectArrayList.add(obj);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            } catch (NumberFormatException e) {
                                e.printStackTrace();
                            }catch (Exception e) {
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
            } else if (tag.equalsIgnoreCase(Constants.DELETE_COMMIT_USER_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        contractorsObjectArrayList.remove(pos);
                        adapter.notifyDataSetChanged();
                        Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_LONG).show();
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_LONG).show();
                    }
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
