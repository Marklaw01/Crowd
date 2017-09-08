package com.crowdbootstrap.fragments;

import android.app.Activity;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.adapter.HomeFeedsAdapter;
import com.crowdbootstrap.fragments.audiovideomodule.AudioVideoDetailsFragment;
import com.crowdbootstrap.fragments.betatestmodule.BetaTesterDetailFragment;
import com.crowdbootstrap.fragments.boardMembersModule.BoardMemberDetailFragment;
import com.crowdbootstrap.fragments.careeradvancementsmodule.CareerAdvancementDetailsFragment;
import com.crowdbootstrap.fragments.communalassetsmodule.CommunalAssetsDetailFragment;
import com.crowdbootstrap.fragments.conferencesmodule.ConferencesDetailsFragment;
import com.crowdbootstrap.fragments.consultingModule.ConsultingDetailsFragment;
import com.crowdbootstrap.fragments.demodaysmodule.DemoDaysDetailsFragment;
import com.crowdbootstrap.fragments.earlyAdoptorsModule.EarlyAdoptorsDetailFragment;
import com.crowdbootstrap.fragments.endorsorsModule.EndorsersDetailFragment;
import com.crowdbootstrap.fragments.focusGroupModule.FocusGroupDetailsFragment;
import com.crowdbootstrap.fragments.groupbuyingModule.GroupBuyingDetailFragment;
import com.crowdbootstrap.fragments.groupsModule.GroupsDetailFragment;
import com.crowdbootstrap.fragments.hardwaremodule.HardwareDetailsFragment;
import com.crowdbootstrap.fragments.informationmodule.InformationDetailsFragment;
import com.crowdbootstrap.fragments.launchdealsmodule.LaunchDealsDetailsFragment;
import com.crowdbootstrap.fragments.meetupsmodule.MeetUpsDetailsFragment;
import com.crowdbootstrap.fragments.productivitymodule.ProductivityDetailsFragment;
import com.crowdbootstrap.fragments.selfimprovementmodule.SelfImprovementDetailsFragment;
import com.crowdbootstrap.fragments.servicesmodule.ServicesDetailsFragment;
import com.crowdbootstrap.fragments.softwaremodule.SoftwareDetailsFragment;
import com.crowdbootstrap.fragments.webinarsmodule.WebinarsDetailsFragment;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.loadmore_listview.LoadMoreListView;
import com.crowdbootstrap.logger.CrowdBootstrapLogger;
import com.crowdbootstrap.models.HomeFeedsObject;
import com.crowdbootstrap.utilities.AsyncNew;
import com.crowdbootstrap.utilities.Constants;
import com.crowdbootstrap.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 5/23/2017.
 */

public class HomeFeedsFragment extends Fragment implements AdapterView.OnItemClickListener, View.OnClickListener, AsyncTaskCompleteListener<String> {
    private String searchText = "";
    private AsyncNew asyncNew;
    private EditText et_search;
    private static int TOTAL_ITEMS = 0;
    int current_page = 1;

    private LoadMoreListView list_funds;
    private HomeFeedsAdapter adapter;
    private TextView btn_search;
    private ArrayList<HomeFeedsObject> fundsList;
    private SwipeRefreshLayout swipeContainer;
    private boolean setPullToRefresh = false;
    private FloatingActionButton fab;


    public HomeFeedsFragment() {
        super();
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            // we check that the fragment is becoming visible
            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            current_page = 1;
            fundsList = new ArrayList<>();
            adapter = null;
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    //obj.put("user_id", "303");
                    obj.put("page_no", current_page);
                    asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.HOME_FEEDS_TAG, Constants.HOME_FEEDS_LIST, Constants.HTTP_POST_REQUEST, obj);
                    asyncNew.execute();
                } catch (JSONException e) {
                    e.printStackTrace();
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                }

            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        }
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
        //((HomeActivity) getActivity()).setOnBackPressedListener(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.home_feeds, container, false);

        et_search = (EditText) rootView.findViewById(R.id.et_search);
        btn_search = (TextView) rootView.findViewById(R.id.btn_search);
//        btn_createFund = (Button) rootView.findViewById(R.id.btn_createFund);
//        btn_createFund.setVisibility(View.GONE);

        btn_search.setOnClickListener(this);

        list_funds = (LoadMoreListView) rootView.findViewById(R.id.list_funds);
        fundsList = new ArrayList<>();
/*        adapter = new CommunalAssetAdapter(getActivity(), fundsList, "FindFunds");
        list_funds.setAdapter(adapter);*/

        btn_search.setOnClickListener(this);
        et_search.setVisibility(View.GONE);
        btn_search.setVisibility(View.GONE);
        list_funds.setOnItemClickListener(this);
        list_funds.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
            @Override
            public void onLoadMore() {
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    current_page += 1;
                    if (TOTAL_ITEMS != adapter.getCount()) {
                        JSONObject obj = new JSONObject();
                        try {
                            obj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            //obj.put("user_id", "303");
                            obj.put("page_no", current_page);
                            asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.HOME_FEEDS_TAG, Constants.HOME_FEEDS_LIST, Constants.HTTP_POST_REQUEST, obj);
                            asyncNew.execute();
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                    } else {
                        list_funds.onLoadMoreComplete();
                    }
                } else {
                    list_funds.onLoadMoreComplete();
                    adapter.notifyDataSetChanged();
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            }
        });



        fab = (FloatingActionButton) rootView.findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                try {
                    Fragment addUserFeeds = new AddUserFeedsFragment();


                    ((HomeActivity) getActivity()).replaceFragment(addUserFeeds);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });


        // Pull to Refresh
        swipeContainer = (SwipeRefreshLayout) rootView.findViewById(R.id.swipeContainer);
        // Setup refresh listener which triggers new data loading
        swipeContainer.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                setPullToRefresh = true;
                // we check that the fragment is becoming visible
                current_page = 1;
                fundsList = new ArrayList<>();
                adapter = null;
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();
                    try {
                        JSONObject obj = new JSONObject();
                        obj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                        //obj.put("user_id", "303");
                        obj.put("page_no", current_page);
                        asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.HOME_FEEDS_TAG, Constants.HOME_FEEDS_LIST, Constants.HTTP_POST_REQUEST, obj);
                        asyncNew.execute();
                    } catch (JSONException e) {
                        e.printStackTrace();
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    }

                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            }
        });
        // Configure the refreshing colors
        swipeContainer.setColorSchemeResources(android.R.color.holo_blue_bright,
                android.R.color.holo_green_light,
                android.R.color.holo_orange_light,
                android.R.color.holo_red_light);


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

        if (fundsList.get(position).getFeedType().compareTo("feeds_profile") == 0) {
            Fragment currentStartUPDetails = new ViewOtherContractorPublicProfileFragment();
            // Constants.COMMING_FROM_INTENT = "";
            Bundle args = new Bundle();
            args.putString("id", fundsList.get(position).getFeedSenderId());
            args.putString("logged_in_user_role", "1");
            args.putString("COMMING_FROM", "SEARCH_CONTRACTOR_DETAILS");
            currentStartUPDetails.setArguments(args);


            FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
            fragmentTransaction.replace(R.id.container, currentStartUPDetails);
            fragmentTransaction.addToBackStack(HomeFragment.class.getName());

            fragmentTransaction.commit();

        } else if (fundsList.get(position).getFeedType().compareTo("feeds_startup_updated") == 0) {

            try {
                Fragment currentStartUPDetails = new StartupDetailsFragment();

                Bundle args = new Bundle();
                args.putString("entrenprenuer_id", fundsList.get(position).getFeedSenderId());
                args.putString("id", fundsList.get(position).getFeedRecordId());
                args.putString("name", fundsList.get(position).getFeedTitle());
                currentStartUPDetails.setArguments(args);
                ((HomeActivity) getActivity()).replaceFragment(currentStartUPDetails);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (fundsList.get(position).getFeedType().compareTo("feeds_startup_added") == 0) {
            try {
                Fragment currentStartUPDetails = new StartupDetailsFragment();

                Bundle args = new Bundle();
                args.putString("entrenprenuer_id", fundsList.get(position).getFeedSenderId());
                args.putString("id", fundsList.get(position).getFeedRecordId());
                args.putString("name", fundsList.get(position).getFeedTitle());
                currentStartUPDetails.setArguments(args);
                ((HomeActivity) getActivity()).replaceFragment(currentStartUPDetails);
            } catch (Exception e) {
                e.printStackTrace();
            }

        } else if (fundsList.get(position).getFeedType().compareTo("feeds_startup_member_added") == 0) {
            try {
                Fragment currentStartUPDetails = new CurrentStartUpDetailFragment();

                Bundle args = new Bundle();
                args.putString("id", fundsList.get(position).getFeedRecordId());
                args.putString("from", "feeds_home");
                args.putString("STARTUP_NAME", fundsList.get(position).getFeedTitle());
                args.putString("STARTUP_TEAMID", fundsList.get(position).getFeedTeamID());
                args.putString("entrepreneur_id", fundsList.get(position).getFeedSenderId());
                currentStartUPDetails.setArguments(args);
                ((HomeActivity) getActivity()).replaceFragment(currentStartUPDetails);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (fundsList.get(position).getFeedType().compareTo("feeds_startup_completed_assignment") == 0) {
            try {
                Fragment currentStartUPDetails = new CurrentStartUpDetailFragment();

                Bundle args = new Bundle();
                args.putString("id", fundsList.get(position).getFeedRecordId());
                args.putString("from", "feeds_home");
                args.putString("STARTUP_NAME", fundsList.get(position).getFeedTitle());
                args.putString("STARTUP_TEAMID", fundsList.get(position).getFeedTeamID());
                args.putString("entrepreneur_id", fundsList.get(position).getFeedSenderId());
                currentStartUPDetails.setArguments(args);
                ((HomeActivity) getActivity()).replaceFragment(currentStartUPDetails);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if ((fundsList.get(position).getFeedType().compareTo("feeds_fund_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_fund_following") == 0)) {

            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                FundDetailFragment updateFundFragment = new FundDetailFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {

            }
        } else if ((fundsList.get(position).getFeedType().compareTo("feeds_campaign_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_campaign_following") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_campaign_commited") == 0)) {

            try {
                Fragment addContributor = new CampaignInterestDetailsFragment();

                Bundle bundle = new Bundle();
                bundle.putString("CAMPAIGN_NAME", fundsList.get(position).getFeedTitle());
                bundle.putString("CAMPAIGN_ID", fundsList.get(position).getFeedRecordId());

                addContributor.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(addContributor);

            } catch (Exception e) {
            }
        } else if ((fundsList.get(position).getFeedType().compareTo("feeds_improvement_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_improvement_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                SelfImprovementDetailsFragment updateFundFragment = new SelfImprovementDetailsFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        } else if ((fundsList.get(position).getFeedType().compareTo("feeds_career_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_career_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                CareerAdvancementDetailsFragment updateFundFragment = new CareerAdvancementDetailsFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        } else if ((fundsList.get(position).getFeedType().compareTo("feeds_organization_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_organization_following") == 0)) {
            try {
                Fragment OrgaganizationDetail = new OrganizationDetailFragment();
                // Constants.COMMING_FROM_INTENT = "";

                Bundle bundle = new Bundle();
                bundle.putString("COMPANY_NAME", fundsList.get(position).getFeedTitle());
                bundle.putString("COMPANY_ID", fundsList.get(position).getFeedRecordId());
                OrgaganizationDetail.setArguments(bundle);

                ((HomeActivity) getActivity()).replaceFragment(OrgaganizationDetail);
            } catch (Exception e) {
            }
        } else if ((fundsList.get(position).getFeedType().compareTo("feeds_forum_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_foum_message") == 0)) {
            try {
                Fragment addContributor = new ForumDetailsFragment();

                Bundle bundle = new Bundle();
                bundle.putString("forum_id", fundsList.get(position).getFeedRecordId());
                bundle.putString("COMMING_FROM", "feeds_home");
                bundle.putString("TITLE", fundsList.get(position).getFeedTitle());
                addContributor.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(addContributor);
            } catch (Exception e) {
            }
        } else if ((fundsList.get(position).getFeedType().compareTo("feeds_group_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_group_joined") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                GroupsDetailFragment updateFundFragment = new GroupsDetailFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        } else if ((fundsList.get(position).getFeedType().compareTo("feeds_hardware_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_hardware_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                HardwareDetailsFragment updateFundFragment = new HardwareDetailsFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_software_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_software_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                SoftwareDetailsFragment updateFundFragment = new SoftwareDetailsFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_service_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_service_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                ServicesDetailsFragment updateFundFragment = new ServicesDetailsFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_audio_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_audio_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                AudioVideoDetailsFragment updateFundFragment = new AudioVideoDetailsFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_information_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_information_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                InformationDetailsFragment updateFundFragment = new InformationDetailsFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_productivity_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_productivity_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                ProductivityDetailsFragment updateFundFragment = new ProductivityDetailsFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_conference_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_conference_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                ConferencesDetailsFragment updateFundFragment = new ConferencesDetailsFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_demoday_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_demoday_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                DemoDaysDetailsFragment updateFundFragment = new DemoDaysDetailsFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_meetup_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_meetup_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                MeetUpsDetailsFragment updateFundFragment = new MeetUpsDetailsFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_webinar_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_webinar_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                WebinarsDetailsFragment updateFundFragment = new WebinarsDetailsFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_betatest_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_betatest_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                BetaTesterDetailFragment updateFundFragment = new BetaTesterDetailFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_boardmember_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_boardmember_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                BoardMemberDetailFragment updateFundFragment = new BoardMemberDetailFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_communal_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_communal_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                CommunalAssetsDetailFragment updateFundFragment = new CommunalAssetsDetailFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_consulting_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_consulting_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                ConsultingDetailsFragment updateFundFragment = new ConsultingDetailsFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_earlyadopter_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_earlyadopter_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                EarlyAdoptorsDetailFragment updateFundFragment = new EarlyAdoptorsDetailFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_endorser_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_endorser_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                EndorsersDetailFragment updateFundFragment = new EndorsersDetailFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_focusgroup_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_focusgroup_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                FocusGroupDetailsFragment updateFundFragment = new FocusGroupDetailsFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_job_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_job_following") == 0)) {
            try {
                Fragment jobDetails = new JobDetailsFragment();

                Bundle bundle = new Bundle();
                bundle.putString("JOB_ID", fundsList.get(position).getFeedRecordId());
                bundle.putString("JOB_TITLE", fundsList.get(position).getFeedTitle());
                bundle.putString("FROM", "JOBS");
                jobDetails.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(jobDetails);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_launchdeal_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_launchdeal_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                LaunchDealsDetailsFragment updateFundFragment = new LaunchDealsDetailsFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }else if ((fundsList.get(position).getFeedType().compareTo("feeds_purchaseorder_added") == 0) || (fundsList.get(position).getFeedType().compareTo("feeds_purchaseorder_following") == 0)) {
            try {
                Bundle bundle = new Bundle();
                bundle.putString(Constants.FUND_ID, fundsList.get(position).getFeedRecordId());
                bundle.putString(Constants.CALLED_FROM, Constants.FIND_FUND_TAG);
                GroupBuyingDetailFragment updateFundFragment = new GroupBuyingDetailFragment();
                updateFundFragment.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(updateFundFragment);
            } catch (Exception e) {
            }
        }

    }


    /**
     * Called when a view has been clicked.
     *
     * @param v The view that was clicked.
     */
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_search:
                if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                    if (!et_search.getText().toString().trim().isEmpty()) {
                        searchText = et_search.getText().toString().trim();
                        try {
                            JSONObject obj = new JSONObject();
                            current_page = 1;
                            fundsList = new ArrayList<>();
                            adapter = null;
                            obj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            //obj.put("user_id", "303");
                            obj.put("page_no", current_page);
                            ((HomeActivity) getActivity()).showProgressDialog();
                            AsyncNew asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.HOME_FEEDS_TAG, Constants.HOME_FEEDS_LIST, Constants.HTTP_POST_REQUEST, obj);
                            asyncNew.execute();
                        } catch (JSONException e) {
                            e.printStackTrace();
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                        }
                    }
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
                break;
        }

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
            if (tag.equals(Constants.HOME_FEEDS_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);


                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));

                        if (jsonObject.optJSONArray("feed_list").length() != 0) {
                            for (int i = 0; i < jsonObject.optJSONArray("feed_list").length(); i++) {
                                JSONObject funds = jsonObject.optJSONArray("feed_list").getJSONObject(i);
                                HomeFeedsObject fundsObject = new HomeFeedsObject();
                                fundsObject.setFeedId(funds.optString("id"));
                                fundsObject.setFeedTitle(funds.optString("title"));
                                fundsObject.setFeedMessage(funds.optString("message"));
                                fundsObject.setFeedType(funds.optString("type"));
                                fundsObject.setFeedSenderName(funds.optString("sender_name"));
                                fundsObject.setFeedSenderBio(funds.optString("sender_bio"));
                                fundsObject.setFeedSenderImage(funds.optString("sender_image"));
                                fundsObject.setFeedPostDate(funds.optString("date"));
                                fundsObject.setFeedSenderId(funds.optJSONObject("data").optString("sender_id"));
                                fundsObject.setFeedRecordId(funds.optJSONObject("data").optString("record_id"));
                                fundsObject.setFeedTeamID(funds.optJSONObject("data").optString("team_id"));
                                fundsObject.setFile1_link(funds.optString("file1"));
                                fundsObject.setFile2_link(funds.optString("file2"));
                                fundsObject.setFile3_link(funds.optString("file3"));
                                fundsObject.setFile4_link(funds.optString("file4"));

                                fundsList.add(fundsObject);
                            }
                        } else {
                            Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                        }

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                    Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
                }

                if (adapter == null) {
                    adapter = new HomeFeedsAdapter(getActivity(), fundsList, "FindFunds");
                    list_funds.setAdapter(adapter);
                }

                if (setPullToRefresh == true) {

                    adapter = new HomeFeedsAdapter(getActivity(), fundsList, "FindFunds");
                    list_funds.setAdapter(adapter);
                    setPullToRefresh = false;
                    swipeContainer.setRefreshing(false);

                } else {

                    list_funds.onLoadMoreComplete();
                    adapter.notifyDataSetChanged();


                    int index = list_funds.getLastVisiblePosition();
                    list_funds.smoothScrollToPosition(index);
                }

            }
        }
        CrowdBootstrapLogger.logInfo(result);
    }
}