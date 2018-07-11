package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.adapter.BusinessCardNotesAdapter;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.loadmore_listview.LoadMoreListView;
import com.crowdbootstrap.models.NotificationObject;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 11/9/2017.
 */

public class NetworkingNotesFragment extends Fragment implements AsyncTaskCompleteListener<String>, AdapterView.OnItemClickListener {


    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    int pos = 0;
    private BusinessCardNotesAdapter adapter;
    private LoadMoreListView mListView;
    private ArrayList<NotificationObject> list;
    private Button searchConnections;

    public NetworkingNotesFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle("Contractor Notes");
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);


        try {
            current_page = 1;
            list = new ArrayList<NotificationObject>();
            list.clear();
            adapter = null;
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.GET_USER_NETWORK_NOTES_TAG, Constants.GET_USER_NETWORK_NOTES_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page + "&card_id=" + getArguments().getString("connected_toId"), Constants.HTTP_GET, "Home Activity");
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
        View rootView = inflater.inflate(R.layout.fragment_archive_notifications, container, false);

        try {
            list = new ArrayList<NotificationObject>();
            mListView = (LoadMoreListView) rootView.findViewById(R.id.list_notificaitons);
            searchConnections =  (Button) rootView.findViewById(R.id.btn_search);
            searchConnections.setVisibility(View.VISIBLE);


            mListView.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
                public void onLoadMore() {
                    // Do the work to load more items at the end of list
                    // here
                    //

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                        current_page += 1;
                        if (TOTAL_ITEMS != adapter.getCount()) {
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.GET_USER_NETWORK_NOTES_TAG, Constants.GET_USER_NETWORK_NOTES_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page + "&card_id=" + getArguments().getString("connected_toId"), Constants.HTTP_GET, "Home Activity");
                            a.execute();
                        } else {
                            mListView.onLoadMoreComplete();
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                        }
                    } else {
                        mListView.onLoadMoreComplete();
                        adapter.notifyDataSetChanged();
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                }
            });
            mListView.setOnItemClickListener(this);


            searchConnections.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    try {
                        Fragment networkingContactsFragment = new NetworkingContactsFragment();
                        ((HomeActivity) getActivity()).replaceFragment(networkingContactsFragment);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rootView;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        try {

            Fragment currentStartUPDetails = new ViewBusinessCardFragment();
            // Constants.COMMING_FROM_INTENT = "";
            Bundle args = new Bundle();
            args.putString("connection_id", list.get(position).getCardOwner());
            args.putString("is_network", "1");
            args.putString("business_contact_type", list.get(position).getCreatedTime());
            args.putString("card_id", list.get(position).getCreatedDate());
            args.putString("userName", list.get(position).getOwnerName());
            args.putString("userImage", list.get(position).getOwnerImage());
            args.putString("noteId", list.get(position).getId());
            args.putString("noteDescription", list.get(position).getDescriptoin());
            args.putString("comingFrom", "NotesList");

            currentStartUPDetails.setArguments(args);

            FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
            fragmentTransaction.replace(R.id.container, currentStartUPDetails);
            fragmentTransaction.addToBackStack(HomeFragment.class.getName());

            fragmentTransaction.commit();


        } catch (Exception e) {
            e.printStackTrace();
        }
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
                if (tag.equalsIgnoreCase(Constants.GET_USER_NETWORK_NOTES_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));
                            if (jsonObject.optJSONArray("businessCards").length() != 0) {
                                for (int i = 0; i < jsonObject.optJSONArray("businessCards").length(); i++) {
                                    JSONObject messages = jsonObject.optJSONArray("businessCards").getJSONObject(i);
                                    NotificationObject obj = new NotificationObject();

                                    obj.setId(messages.optString("note_id"));
                                    obj.setName("Note: " + String.valueOf(list.size() + 1));
                                    obj.setSender(messages.optString("connected_to_id"));
                                    obj.setDescriptoin(messages.optString("notes_detail"));
                                    obj.setCreatedTime(messages.optString("connection_type_id"));
                                    obj.setCreatedDate(messages.optString("card_id"));
                                    obj.setOwnerImage(messages.optString("profile_image"));
                                    obj.setOwnerName(messages.optString("name"));
                                    obj.setCardOwner(messages.optString("card_owner"));
                                    list.add(obj);

                                }
                            } else {
                                Toast.makeText(getActivity(), "No notes found", Toast.LENGTH_LONG).show();
                            }


                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No notes found", Toast.LENGTH_LONG).show();
                        }

                        //Collections.reverse(list);

                        if (adapter == null) {
                            adapter = new BusinessCardNotesAdapter(getActivity(), list);
                            mListView.setAdapter(adapter);
                        }


                        mListView.onLoadMoreComplete();
                        adapter.notifyDataSetChanged();

                        int index = mListView.getLastVisiblePosition();
                        mListView.smoothScrollToPosition(index);

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
