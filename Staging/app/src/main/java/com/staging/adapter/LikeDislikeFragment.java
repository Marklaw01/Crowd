package com.staging.adapter;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.fragments.FundDetailFragment;
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
public class LikeDislikeFragment extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {

    private Bundle bundle;

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private LoadMoreListView list_persons;
    private LikesDislikesAdapter adapter;
    private int mFundId;
    private ArrayList<UserObject> list;
    public LikeDislikeFragment() {
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
        ((HomeActivity) getActivity()).setActionBarTitle(bundle.getString(Constants.LIKE_DISLIKE));
        mFundId = bundle.getInt(Constants.FUND_ID);
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
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.likes_dislike_fragment, container, false);

        list_persons = (LoadMoreListView) rootView.findViewById(R.id.list_persons);
        adapter = new LikesDislikesAdapter(getActivity(), list);
        list_persons.setAdapter(adapter);
        list_persons.setOnItemClickListener(this);
        list_persons.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
            @Override
            public void onLoadMore() {
                list_persons.onLoadMoreComplete();
            }
        });
        return rootView;
    }

    private void getLikersDislikers() {
        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
            try {
                JSONObject obj = new JSONObject();
                obj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                obj.put("page_no", current_page);
                AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.FUND_LIKERS_TAG, Constants.FUND_LIKERS_LIST, Constants.HTTP_POST_REQUEST, obj);
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
        bundle.putString("id", "3");
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


            ((HomeActivity) getActivity()).dismissProgressDialog();
            CrowdBootstrapLogger.logInfo(result);
        }
    }
}
