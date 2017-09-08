package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.adapter.ForumsStartupsAdapter;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.loadmore_listview.LoadMoreListView;
import com.crowdbootstrap.models.StartupsObject;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/13/2016.
 */
public class StartupsFragment extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    int pos = 0;
    private Button btn_addCampaign;
    private ForumsStartupsAdapter adapter;
    private LoadMoreListView listView;


    private ArrayList<StartupsObject> list;

    public StartupsFragment() {
        super();
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            // we check that the fragment is becoming visible
            //((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.recommended));
            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            current_page = 1;
            list = new ArrayList<StartupsObject>();
            list.clear();
            adapter = null;
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_LIST_UNDER_FORUMS_TAG, Constants.STARTUP_LIST_UNDER_FORUMS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.showSettingsAlert();
            }
        }
    }

    /*@Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.forums));
    }*/
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_suggestions, container, false);
        listView = (LoadMoreListView) rootView.findViewById(R.id.list_compaigns);

        btn_addCampaign = (Button) rootView.findViewById(R.id.btn_addCampaign);
        btn_addCampaign.setVisibility(View.GONE);
        list = new ArrayList<StartupsObject>();

       /* for (int i=0;i<10;i++){
            StartupsObject obj = new StartupsObject();
            obj.setId((i+1)+"");
            obj.setStartupName("Startup Name "+(i+1));
            obj.setDescription("Description: Lorum Ipsum Description: Lorum Ipsum Description: Lorum Ipsum Description: Lorum Ipsum Description: Lorum Ipsum Description: Lorum Ipsum Description: Lorum Ipsum Description: Lorum Ipsum ");

            list.add(obj);

        }

        adapter = new ForumsStartupsAdapter(getActivity(), list);
        listView.setAdapter(adapter);
*/
        listView.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
            public void onLoadMore() {
                // Do the work to load more items at the end of list
                // here
                //
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    //((HomeActivity) getActivity()).showProgressDialog();
                    current_page += 1;
                    if (TOTAL_ITEMS != adapter.getCount()) {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_LIST_UNDER_FORUMS_TAG, Constants.STARTUP_LIST_UNDER_FORUMS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET,"Home Activity");
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

        return rootView;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        Fragment addContributor = new StartUpsForumsListFragemnt();

        Bundle bundle = new Bundle();
        bundle.putString("startup_id", list.get(position).getId());
        bundle.putString("COMMING_FROM", "Common");
        bundle.putString("TITLE", list.get(position).getStartupName());
        addContributor.setArguments(bundle);
        ((HomeActivity)getActivity()).replaceFragment(addContributor);
        /*FragmentTransaction transactionAdd = getParentFragment().getFragmentManager().beginTransaction();
        transactionAdd.replace(R.id.container, addContributor);
        transactionAdd.addToBackStack(null);

        transactionAdd.commit();*/

    }

    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            if (tag.equalsIgnoreCase(Constants.STARTUP_LIST_UNDER_FORUMS_TAG)) {

                if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                }
                try {
                    JSONObject jsonObject = new JSONObject(result);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));
                        if (jsonObject.optJSONArray("startups").length()!=0){
                            for (int i = 0; i < jsonObject.optJSONArray("startups").length(); i++) {
                                JSONObject Forums = jsonObject.optJSONArray("startups").getJSONObject(i);
                                StartupsObject obj = new StartupsObject();
                                obj.setId(Forums.optString("startup_id"));
                                obj.setStartupName(Forums.optString("startup_name"));
                                obj.setDescription(Forums.optString("description"));
                                list.add(obj);
                            }
                        }else{
                            Toast.makeText(getActivity(), "No Forums Created Yet.", Toast.LENGTH_LONG).show();
                        }

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), "No Forums Created Yet.", Toast.LENGTH_LONG).show();
                    }
                } catch (JSONException e) {
                    //((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }


                if (adapter == null) {
                    adapter = new ForumsStartupsAdapter(getActivity(), list);
                    listView.setAdapter(adapter);
                }


                listView.onLoadMoreComplete();
                adapter.notifyDataSetChanged();

                int index = listView.getLastVisiblePosition();
                listView.smoothScrollToPosition(index);
            }
        }
    }
}
