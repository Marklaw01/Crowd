package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.CurrentStartupsAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.loadmore_listview.LoadMoreListView;
import com.staging.models.CurrentStartUpObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by sunakshi.gautam on 1/19/2016.
 */
public class SearchStartupsTabsFragment extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {

    private EditText et_search;
    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private CurrentStartupsAdapter adapter;
    private LoadMoreListView listView;

    public ArrayList<CurrentStartUpObject> currentStartupsList;

    public SearchStartupsTabsFragment() {

    }


    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            try {
                // we check that the fragment is becoming visible

                ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                current_page = 1;
                currentStartupsList = new ArrayList<CurrentStartUpObject>();
                currentStartupsList.clear();
                adapter = null;
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUPS_TAG, Constants.STARTUPS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&startup_type=" + Constants.SEARCH_STARTUPS + "&page_no=" + current_page + "&search_text=", Constants.HTTP_GET,"Home Activity");
                    a.execute();
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        // ((HomeActivity)getActivity()).setActionBarTitle(getString(R.string.currentStartup));
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_searchstartuptab, container, false);

        try {
            listView = (LoadMoreListView) rootView.findViewById(R.id.list_currentstartups);
            et_search = (EditText) rootView.findViewById(R.id.et_search);
            et_search.setHint("Search by Keywords");
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
                            String searchedKey = ((HomeActivity) getActivity()).utilitiesClass.removeSpecialCharacters(et_search.getText().toString().trim());
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUPS_TAG, Constants.STARTUPS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&startup_type=" + Constants.SEARCH_STARTUPS + "&page_no=" + current_page + "&search_text=" + searchedKey, Constants.HTTP_GET,"Home Activity");
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

            et_search.setImeOptions(EditorInfo.IME_ACTION_DONE);
            et_search.setOnEditorActionListener(new EditText.OnEditorActionListener() {
                @Override
                public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                    if (actionId == EditorInfo.IME_ACTION_DONE) {
                        current_page = 1;
                        currentStartupsList = new ArrayList<CurrentStartUpObject>();
                        currentStartupsList.clear();
                        adapter = null;
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            String searchedKey = ((HomeActivity) getActivity()).utilitiesClass.removeSpecialCharacters(et_search.getText().toString().trim());
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUPS_TAG, Constants.STARTUPS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&startup_type=" + Constants.SEARCH_STARTUPS + "&page_no=" + current_page + "&search_text=" + searchedKey, Constants.HTTP_GET,"Home Activity");
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                        return true;
                    }
                    return false;
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
            Fragment StartUPDetails = new StartupDetailsFragment();

            Bundle args = new Bundle();
            args.putString("id", currentStartupsList.get(position).getId());
            args.putString("from", "search");
            args.putString("name", currentStartupsList.get(position).getStartUpName());
            StartUPDetails.setArguments(args);
            ((HomeActivity)getActivity()).replaceFragment(StartUPDetails);
        } catch (Exception e) {
            e.printStackTrace();
        }
        /*FragmentTransaction transactionAdd = getParentFragment().getFragmentManager().beginTransaction();

        transactionAdd.replace(R.id.container, StartUPDetails);
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
