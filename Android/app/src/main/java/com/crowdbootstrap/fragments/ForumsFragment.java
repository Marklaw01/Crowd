package com.crowdbootstrap.fragments;

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

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.adapter.MyForumsAdapter;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.loadmore_listview.LoadMoreListView;
import com.crowdbootstrap.models.MyForumsObject;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;
import com.crowdbootstrap.utilities.DateTimeFormatClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/13/2016.
 */
public class ForumsFragment extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    int pos = 0;
    private EditText et_search;
    private MyForumsAdapter adapter;
    private LoadMoreListView listView;

    private ArrayList<MyForumsObject> list;

    public ForumsFragment() {
        super();
    }

    /*@Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.forums));
    }*/

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            try {
                // we check that the fragment is becoming visible
                //((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.recommended));
                ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                current_page = 1;
                list = new ArrayList<MyForumsObject>();
                list.clear();
                adapter = null;
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();
                    String searchedKey = ((HomeActivity) getActivity()).utilitiesClass.removeSpecialCharacters(et_search.getText().toString().trim());
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SEARCH_FORUMS_LIST_TAG, Constants.SEARCH_FORUMS_LIST_URL + "?search_text=" + "&page_no=" + current_page + "&user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                    a.execute();
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.showSettingsAlert();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_forums, container, false);
        try {
            listView = (LoadMoreListView) rootView.findViewById(R.id.list_forums);
            et_search = (EditText) rootView.findViewById(R.id.et_search);

            list = new ArrayList<MyForumsObject>();

            et_search.setImeOptions(EditorInfo.IME_ACTION_DONE);
            et_search.setOnEditorActionListener(new EditText.OnEditorActionListener() {
                @Override
                public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                    if (actionId == EditorInfo.IME_ACTION_DONE) {
                        current_page = 1;
                        list = new ArrayList<MyForumsObject>();
                        list.clear();
                        adapter = null;
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            String searchedKey = ((HomeActivity) getActivity()).utilitiesClass.removeSpecialCharacters(et_search.getText().toString().trim());
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SEARCH_FORUMS_LIST_TAG, Constants.SEARCH_FORUMS_LIST_URL + "?search_text=" + searchedKey + "&page_no=" + current_page + "&user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                        return true;
                    }
                    return false;
                }
            });


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
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SEARCH_FORUMS_LIST_TAG, Constants.SEARCH_FORUMS_LIST_URL + "?search_text=" + "&page_no=" + current_page + "&user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
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
        /*Fragment addContributor = new StartUpsForumsListFragemnt();
        FragmentTransaction transactionAdd = getParentFragment().getFragmentManager().beginTransaction();

        transactionAdd.replace(R.id.container, addContributor);
        transactionAdd.addToBackStack(null);

        transactionAdd.commit();*/

        try {
            Fragment addContributor = new ForumDetailsFragment();

            Bundle bundle = new Bundle();
            bundle.putString("forum_id", list.get(position).getId());
            bundle.putString("COMMING_FROM", "Common");
            bundle.putString("TITLE", list.get(position).getTitle());
            addContributor.setArguments(bundle);
            ((HomeActivity)getActivity()).replaceFragment(addContributor);
        } catch (Exception e) {
            e.printStackTrace();
        }
       /* FragmentTransaction transactionAdd = getParentFragment().getFragmentManager().beginTransaction();
        transactionAdd.replace(R.id.container, addContributor);
        transactionAdd.addToBackStack(null);

        transactionAdd.commit();*/


        /*Fragment addContributor = new StartUpsForumsListFragemnt();
        FragmentTransaction transactionAdd = getParentFragment().getFragmentManager().beginTransaction();
        Bundle bundle = new Bundle();
        bundle.putString("COMMING_FROM", "Common");
        bundle.putString("TITLE", list.get(position).getTitle());
        addContributor.setArguments(bundle);
        transactionAdd.replace(R.id.container, addContributor);
        transactionAdd.addToBackStack(null);

        transactionAdd.commit();
*/
    }

    @Override
    public void onTaskComplete(String result, String tag) {
        try {
            if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
                Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
            } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
                Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
            } else {
                if (tag.equalsIgnoreCase(Constants.SEARCH_FORUMS_LIST_TAG)) {

                    if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    }
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));
                            if (jsonObject.optJSONArray("Forums").length()!=0){
                                for (int i = 0; i < jsonObject.optJSONArray("Forums").length(); i++) {
                                    JSONObject Forums = jsonObject.optJSONArray("Forums").getJSONObject(i);
                                    MyForumsObject obj = new MyForumsObject();
                                    obj.setId(Forums.optString("id"));
                                    obj.setTitle(Forums.optString("forum_title"));
                                    obj.setCreatedBy(Forums.optString("forumCreatedBy"));
                                    obj.setDescription(Forums.optString("description"));
                                    obj.setCreatedTime(DateTimeFormatClass.convertStringObjectToAMPMTimeFormat(Forums.optString("createdTime")));
                                    obj.setCreatedDate(DateTimeFormatClass.convertStringObjectToMMMDDYYYYFormat(Forums.optString("createdTime")));
                                    list.add(obj);
                                }
                            }else{
                                Toast.makeText(getActivity(), "No Forums Created Yet.", Toast.LENGTH_LONG).show();
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            //Toast.makeText(getActivity(), "No Forums Created Yet.", Toast.LENGTH_LONG).show();
                        }
                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }


                    if (adapter == null) {
                        adapter = new MyForumsAdapter(getActivity(), list);
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
