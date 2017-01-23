package com.crowdbootstrapapp.fragments;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Toast;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.adapter.CurrentStartupsAdapter;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.loadmore_listview.LoadMoreListView;
import com.crowdbootstrapapp.models.CurrentStartUpObject;
import com.crowdbootstrapapp.utilities.Async;
import com.crowdbootstrapapp.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by sunakshi.gautam on 8/2/2016.
 */
public class StartupProfileFragment extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {


    private int TOTAL_ITEMS = 0;
    int current_page = 1;
    private CurrentStartupsAdapter adapter;
    private LoadMoreListView listView;

    private ArrayList<CurrentStartUpObject> currentStartupsList;

    public StartupProfileFragment() {
     //super();
    }

//    @Override
//    public void onActivityResult(int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);
//        List<Fragment> fragments = getChildFragmentManager().getFragments();
//        if (fragments != null)
//        {
//            for (Fragment fragment : fragments)
//            {
//                Log.e("SupportFragmentmystart", fragment.getClass().getSimpleName());
//                if(fragment instanceof CurrentStartUpDetailFragment)
//                {
//                    fragment.onActivityResult(requestCode, resultCode, data);
//                }
//            }
//        }
//    }


    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {

        }
    }

    @Override
    public void onResume() {
        super.onResume();
        try {
            // we check that the fragment is becoming visible
            ((HomeActivity) getActivity()).setActionBarTitle("Upload Profile");
            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            current_page = 1;
            currentStartupsList = new ArrayList<CurrentStartUpObject>();
            currentStartupsList.clear();
            adapter = null;
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUPS_TAG, Constants.STARTUPS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&startup_type=" + Constants.MY_STARTUPS + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_currentstartuptab, container, false);
        try {
            listView = (LoadMoreListView) rootView.findViewById(R.id.list_currentstartups);


            currentStartupsList = new ArrayList<CurrentStartUpObject>();


            listView.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
                public void onLoadMore() {
                    // Do the work to load more items at the end of list
                    // here
                    //
                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        //((HomeActivity) getActivity()).showProgressDialog();
                        current_page += 1;
                        if (TOTAL_ITEMS != adapter.getCount()) {
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUPS_TAG, Constants.STARTUPS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&startup_type=" + Constants.MY_STARTUPS + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
                            a.execute();
                        } else {
                            listView.onLoadMoreComplete();
                            //  ((HomeActivity) getActivity()).dismissProgressDialog();
                        }

                    } else {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        listView.onLoadMoreComplete();
                        adapter.notifyDataSetChanged();
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                }
            });

            listView.setOnItemClickListener(this);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootView;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        try {
            Fragment uploadStartupProfile = new UploadStartupProfileFragment();

            Bundle args = new Bundle();
            args.putString("id", currentStartupsList.get(position).getId());
            args.putString("startupname", currentStartupsList.get(position).getStartUpName());
            uploadStartupProfile.setArguments(args);
            FragmentTransaction ft = getFragmentManager().beginTransaction();
            ft.add(R.id.container, uploadStartupProfile);
            ft.addToBackStack(null);
            //getFragmentManager().popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
            ft.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
        /*FragmentTransaction transactionAdd = getParentFragment().getFragmentManager().beginTransaction();

        transactionAdd.replace(R.id.container, currentStartUPDetails);
        transactionAdd.addToBackStack(null);

        transactionAdd.commit();*/

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
                if (tag.equalsIgnoreCase(Constants.STARTUPS_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));
                            if (jsonObject.optJSONArray("startups").length()!=0){
                                for (int i = 0; i < jsonObject.optJSONArray("startups").length(); i++) {
                                    JSONObject startups = jsonObject.optJSONArray("startups").getJSONObject(i);
                                    CurrentStartUpObject currentStartUpObject = new CurrentStartUpObject();

                                    currentStartUpObject.setId(startups.optString("startup_id").trim());
                                    currentStartUpObject.setEntrenprenuer_id(startups.optString("entrepreneur_id").trim());
                                    currentStartUpObject.setEntrenprenuerName(startups.optString("entrepreneur_name").trim());
                                    currentStartUpObject.setIs_contractor(Boolean.parseBoolean(startups.optString("is_contractor")));
                                    currentStartUpObject.setIs_entrepreneur(Boolean.parseBoolean(startups.optString("is_entrepreneur")));
                                    currentStartUpObject.setStartUpDiscription(startups.optString("startup_desc").trim());
                                    currentStartUpObject.setStartUpName(startups.optString("startup_name").trim());

                                    currentStartupsList.add(currentStartUpObject);
                                }
                            }else{
                                AlertDialog.Builder builder1 = new AlertDialog.Builder(getActivity());
                                builder1.setMessage("No Startups Available Yet.");
                                builder1.setCancelable(true);

                                builder1.setPositiveButton(
                                        "OK",
                                        new DialogInterface.OnClickListener() {
                                            public void onClick(DialogInterface dialog, int id) {
                                                dialog.cancel();
                                            }
                                        });

                                AlertDialog alert11 = builder1.create();
                                alert11.show();
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            AlertDialog.Builder builder1 = new AlertDialog.Builder(getActivity());
                            builder1.setMessage("No Startups Available Yet.");
                            builder1.setCancelable(true);

                            builder1.setPositiveButton(
                                    "OK",
                                    new DialogInterface.OnClickListener() {
                                        public void onClick(DialogInterface dialog, int id) {
                                            dialog.cancel();
                                        }
                                    });

                            AlertDialog alert11 = builder1.create();
                            alert11.show();
                        }
                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }

                    if (adapter == null) {
                        adapter = new CurrentStartupsAdapter(getActivity(), currentStartupsList, false);
                        listView.setAdapter(adapter);
                    }


                    listView.onLoadMoreComplete();
                    adapter.notifyDataSetChanged();

                    int index = listView.getLastVisiblePosition();
                    listView.smoothScrollToPosition(index);
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }catch (Exception e) {
            e.printStackTrace();
        }

    }

}