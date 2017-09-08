package com.staging.fragments.conferencesmodule;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.LikesDislikesAdapter;
import com.staging.fragments.ViewOtherContractorPublicProfileFragment;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.loadmore_listview.LoadMoreListView;
import com.staging.logger.CrowdBootstrapLogger;
import com.staging.models.UserObject;
import com.staging.utilities.AsyncNew;
import com.staging.utilities.Constants;
import com.staging.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Neelmani.Karn on 1/12/2017.
 */
public class ConferencesComittersFragment extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {

    private Bundle bundle;
    private AsyncNew asyncNew;
    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private LoadMoreListView list_persons;
    private LikesDislikesAdapter adapter;
    private String mFundId;
    private ArrayList<UserObject> list;

    public ConferencesComittersFragment() {
        super();
    }

    /**
     * Called to do initial creation of a fragment.  This is called after
     * {@link #onAttach(Activity)} and before
     * {@link #onCreateView(LayoutInflater, ViewGroup, Bundle)}.
     * <p>
     * <p>Note that this can be called while the fragment's activity is
     * still in the process of being created.  As such, you can not rely
     * on things like the activity's content view hierarchy being initialized
     * at this point.  If you want to do work once the activity itself is
     * created, see {@link #onActivityCreated(Bundle)}.
     *
     * @param savedInstanceState If the fragment is being re-created from
     *                           a previous saved state, this is the state.
     */
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        bundle = this.getArguments();
        ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.commitments));
        mFundId = bundle.getString(Constants.FUND_ID);
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
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.commitments));
        current_page = 1;
        list = new ArrayList<>();
        adapter = null;

        getLikersDislikers(current_page, Constants.CONFERENCE_COMMIT_LIST, Constants.CONFERENCE_COMMIT_LIST_TAG);


    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.likes_dislike_fragment, container, false);

        list_persons = (LoadMoreListView) rootView.findViewById(R.id.list_persons);
       /* adapter = new LikesDislikesAdapter(getActivity(), list);
        list_persons.setAdapter(adapter);*/
        list_persons.setOnItemClickListener(this);
        list_persons.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
            @Override
            public void onLoadMore() {
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    current_page += 1;
                    if (TOTAL_ITEMS != adapter.getCount()) {

                        getLikersDislikers(current_page, Constants.CONFERENCE_COMMIT_LIST, Constants.CONFERENCE_COMMIT_LIST_TAG);

                    } else {
                        list_persons.onLoadMoreComplete();
                    }
                } else {
                    list_persons.onLoadMoreComplete();
                    adapter.notifyDataSetChanged();
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            }
        });
        return rootView;
    }

    private void getLikersDislikers(int pageNumber, String url, String tag) {
        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
            try {
                JSONObject obj = new JSONObject();
                obj.put("conference_id", mFundId);
                obj.put("page_no", pageNumber);
                ((HomeActivity) getActivity()).showProgressDialog();
                asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), tag, url, Constants.HTTP_POST_REQUEST, obj);
                asyncNew.execute();
            } catch (JSONException e) {
                e.printStackTrace();
            }
        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }
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
        bundle.putString("COMMING_FROM", Constants.LIKE_DISLIKE);
        bundle.putString("id", list.get(position).getId());
        ViewOtherContractorPublicProfileFragment profile = new ViewOtherContractorPublicProfileFragment();
        profile.setArguments(bundle);
        ((HomeActivity) getActivity()).replaceFragment(profile);
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
            if (tag.equals(Constants.CONFERENCE_COMMIT_LIST_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);


                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));
                        for (int i = 0; i < jsonObject.getJSONArray("users").length(); i++) {
                            JSONObject obj = jsonObject.getJSONArray("users").getJSONObject(i);
                            UserObject userObject = new UserObject();
                            userObject.setBio(obj.getString("bio"));
                            userObject.setId(obj.getString("id"));
                            userObject.setName(obj.getString("name"));
                            userObject.setImage(obj.getString("image"));
                            list.add(userObject);
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                    Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
                }
                if (adapter == null) {
                    adapter = new LikesDislikesAdapter(getActivity(), list);
                    list_persons.setAdapter(adapter);
                }
                list_persons.onLoadMoreComplete();
                adapter.notifyDataSetChanged();

                int index = list_persons.getLastVisiblePosition();
                list_persons.smoothScrollToPosition(index);

            }


            CrowdBootstrapLogger.logInfo(result);
        }
    }
}
