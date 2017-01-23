package com.crowdbootstrapapp.adapter;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.fragments.ViewOtherContractorPublicProfileFragment;
import com.crowdbootstrapapp.loadmore_listview.LoadMoreListView;
import com.crowdbootstrapapp.utilities.Constants;

/**
 * Created by Neelmani.Karn on 1/12/2017.
 */
public class LikeDislikeFragment extends Fragment implements AdapterView.OnItemClickListener {

    private Bundle bundle;

    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private Button btn_addCampaign;
    private LoadMoreListView list_persons;
    private LikesDislikesAdapter adapter;

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
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.likes_dislike_fragment, container, false);

        list_persons = (LoadMoreListView) rootView.findViewById(R.id.list_persons);
        adapter = new LikesDislikesAdapter(getActivity());
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
}
