package com.crowdbootstrapapp.fragments;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.quickblox.chat.QBChatService;
import com.quickblox.chat.model.QBDialog;
import com.quickblox.chat.model.QBDialogType;
import com.quickblox.chat.request.QBDialogRequestBuilder;
import com.quickblox.core.QBEntityCallback;
import com.quickblox.core.exception.QBResponseException;
import com.quickblox.core.request.GenericQueryRule;
import com.quickblox.core.request.QBPagedRequestBuilder;
import com.quickblox.core.request.QBRequestGetBuilder;
import com.quickblox.core.request.QueryRule;
import com.quickblox.customobjects.QBCustomObjects;
import com.quickblox.customobjects.model.QBCustomObject;
import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.adapter.TeamMemberAdapter;
import com.crowdbootstrapapp.chat.callback.QbEntityCallbackWrapper;
import com.crowdbootstrapapp.helper.ListViewForEmbeddingInScrollView;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.models.TeamMemberObject;
import com.crowdbootstrapapp.swipelistviewinscrollview.SwipeMenu;
import com.crowdbootstrapapp.swipelistviewinscrollview.SwipeMenuCreator;
import com.crowdbootstrapapp.swipelistviewinscrollview.SwipeMenuItem;
import com.crowdbootstrapapp.swipelistviewinscrollview.SwipeMenuListView;
import com.crowdbootstrapapp.utilities.Async;
import com.crowdbootstrapapp.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashSet;

/**
 * Created by sunakshi.gautam on 1/21/2016.
 */
public class TeamStartUpFragment extends Fragment implements AsyncTaskCompleteListener<String> {

    private static final String ORDER_RULE = "order";
    private static final String ORDER_VALUE = "desc date created_at";
    private static final int LIMIT_USERS = 50;
    public static final int MINIMUM_CHAT_OCCUPANTS_SIZE = 2;
    ArrayList<Integer> users;
    HashSet<Integer> usersIds;

    public static int LOGGEDIN_USER_ROLE = 1;
    private Button recommendcontractor, groupchat;
    private EditText et_search;
    private TeamMemberAdapter adapterEntrePreneur;
    private TeamMemberAdapter adapterCoFounder;
    private TeamMemberAdapter adapterTeamMember;
    private TeamMemberAdapter adapterContractor;

    private SwipeMenuCreator creator;
    private ListViewForEmbeddingInScrollView mListViewEntrepreneur;
    private SwipeMenuListView mListViewCoFounder;
    private SwipeMenuListView mListViewTeamMember;
    private SwipeMenuListView mListViewContractor;

    public static ArrayList<TeamMemberObject> listEntrepreneurs;
    public static ArrayList<TeamMemberObject> listCofounders;
    public static ArrayList<TeamMemberObject> listTeamMembers;
    public static ArrayList<TeamMemberObject> listContractors;


    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            // we check that the fragment is becoming visible

            ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_TAG, Constants.STARTUP_TEAM_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID, Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {

                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }

        }
    }


    @Override
    public View onCreateView(LayoutInflater inflater, final ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_teamstartup, container, false);

        usersIds = new HashSet<Integer>();
        users = new ArrayList<Integer>();
        et_search = (EditText) rootView.findViewById(R.id.et_search);
        et_search.setVisibility(View.GONE);
        recommendcontractor = (Button) rootView.findViewById(R.id.recommendcontractor);
        groupchat = (Button) rootView.findViewById(R.id.groupchat);
        listEntrepreneurs = new ArrayList<TeamMemberObject>();
        listCofounders = new ArrayList<TeamMemberObject>();
        listTeamMembers = new ArrayList<TeamMemberObject>();
        listContractors = new ArrayList<TeamMemberObject>();

        mListViewEntrepreneur = (ListViewForEmbeddingInScrollView) rootView.findViewById(R.id.listViewentrepreneur);
        mListViewCoFounder = (SwipeMenuListView) rootView.findViewById(R.id.listViewcofounders);
        mListViewTeamMember = (SwipeMenuListView) rootView.findViewById(R.id.listViewteammember);
        mListViewContractor = (SwipeMenuListView) rootView.findViewById(R.id.listViewcontractor);

        if (CurrentStartUpDetailFragment.from.compareTo("complete") == 0) {
            recommendcontractor.setVisibility(View.GONE);
            groupchat.setVisibility(View.GONE);
        } else {
            recommendcontractor.setVisibility(View.VISIBLE);
            groupchat.setVisibility(View.VISIBLE);
        }


        mListViewEntrepreneur.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (!((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID).equalsIgnoreCase(listEntrepreneurs.get(position).getMemberId())) {
                    if (listEntrepreneurs.get(position).getIsPublicProfile().equalsIgnoreCase("1")) {
                        Fragment contractor = new ViewOtherEntrepreneurPublicProfileFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("id", listEntrepreneurs.get(position).getMemberId());
                        bundle.putString("COMMING_FROM", "entrepreneur");
                        contractor.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(contractor);
                    } else {
                        Toast.makeText(getActivity(), "This user's profile can't be viewed as it is a private profile.", Toast.LENGTH_LONG).show();
                    }

                    //getParentFragment().getFragmentManager().beginTransaction().addToBackStack(null).replace(R.id.container, contractor).commit();
                }

            }
        });

        mListViewCoFounder.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (!((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID).equalsIgnoreCase(listCofounders.get(position).getMemberId())) {
                    if (listCofounders.get(position).getIsPublicProfile().equalsIgnoreCase("1")) {
                        Fragment contractor = new ViewOtherContractorPublicProfileFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("id", listCofounders.get(position).getMemberId());
                        bundle.putString("COMMING_FROM", "Teams");
                        contractor.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(contractor);
                    } else {
                        Toast.makeText(getActivity(), "This user's profile can't be viewed as it is a private profile.", Toast.LENGTH_LONG).show();
                    }

                    //getParentFragment().getFragmentManager().beginTransaction().addToBackStack(null).replace(R.id.container, contractor).commit();
                }
            }
        });


        mListViewTeamMember.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (!((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID).equalsIgnoreCase(listTeamMembers.get(position).getMemberId())) {
                    if (listTeamMembers.get(position).getIsPublicProfile().equalsIgnoreCase("1")) {
                        Fragment contractor = new ViewOtherContractorPublicProfileFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("id", listTeamMembers.get(position).getMemberId());
                        bundle.putString("COMMING_FROM", "Teams");
                        contractor.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(contractor);
                    } else {
                        Toast.makeText(getActivity(), "This user's profile can't be viewed as it is a private profile.", Toast.LENGTH_LONG).show();
                    }

                    //getParentFragment().getFragmentManager().beginTransaction().addToBackStack(null).replace(R.id.container, contractor).commit();
                }


            }
        });
//        adapterContractor = new TeamMemberAdapter(getActivity(), listContractors);
//        mListViewContractor.setAdapter(adapterContractor);

        mListViewContractor.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (!((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID).equalsIgnoreCase(listContractors.get(position).getMemberId())) {
                    if (listContractors.get(position).getIsPublicProfile().equalsIgnoreCase("1")) {
                        Fragment contractor = new ViewOtherContractorPublicProfileFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("id", listContractors.get(position).getMemberId());
                        bundle.putString("COMMING_FROM", "Teams");
                        contractor.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(contractor);
                    } else {
                        Toast.makeText(getActivity(), "This user's profile can't be viewed as it is a private profile.", Toast.LENGTH_LONG).show();
                    }

                    //getParentFragment().getFragmentManager().beginTransaction().addToBackStack(null).replace(R.id.container, contractor).commit();
                }
            }
        });

        /*et_search.addTextChangedListener(new TextWatcher() {

            @Override
            public void afterTextChanged(Editable arg0) {

            }

            @Override
            public void beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {

            }

            @Override
            public void onTextChanged(CharSequence s, int arg1, int arg2, int arg3) {
                if (adapterCoFounder != null && adapterContractor != null && adapterContractor != null) {
                    adapterCoFounder.getFilter().filter(s);
                    adapterContractor.getFilter().filter(s);
                    adapterContractor.getFilter().filter(s);
                }
            }
        });*/

        //2 = suspended
        // 1 = resumed
        // 3 = remove
        creator = new SwipeMenuCreator() {
            @Override
            public void create(SwipeMenu menu) {
                switch (menu.getViewType()) {
                    case 1:
                        createMenuResume(menu);
                        break;
                    case 0:
                        createMenuSuspend(menu);
                        break;
                }
            }

            private void createMenuResume(SwipeMenu menu) {
                SwipeMenuItem archive = new SwipeMenuItem(getActivity().getApplicationContext());
                // set item background
                Drawable arid = getResources().getDrawable(R.color.green);
                archive.setBackground(arid);
                archive.setIcon(getResources().getDrawable(R.drawable.resume));
                // set item width
                archive.setWidth(dp2px(90));

                // set item title
                archive.setTitle("Resume");
                // set item title fontsize
                archive.setTitleSize(15);
                // set item title font color
                archive.setTitleColor(Color.WHITE);
                // add to menu
                menu.addMenuItem(archive);


                // create "delete" item
                SwipeMenuItem deleteItem = new SwipeMenuItem(getActivity().getApplicationContext());
                // set item background
                Drawable delid = getResources().getDrawable(R.color.red);
                deleteItem.setBackground(delid);
                deleteItem.setIcon(getResources().getDrawable(R.drawable.delete));
                // set item width
                deleteItem.setWidth(dp2px(90));
                // set a icon
                deleteItem.setTitle("Remove");
                deleteItem.setTitleSize(15);
                deleteItem.setTitleColor(Color.WHITE);
                // add to menu
                menu.addMenuItem(deleteItem);
            }

            private void createMenuSuspend(SwipeMenu menu) {
                SwipeMenuItem archive = new SwipeMenuItem(getActivity().getApplicationContext());
                // set item background
                Drawable arid = getResources().getDrawable(R.color.green);
                archive.setBackground(arid);
                archive.setIcon(getResources().getDrawable(R.drawable.suspend));
                // set item width
                archive.setWidth(dp2px(90));

                // set item title
                archive.setTitle("Suspend");
                // set item title fontsize
                archive.setTitleSize(15);
                // set item title font color
                archive.setTitleColor(Color.WHITE);
                // add to menu
                menu.addMenuItem(archive);


                // create "delete" item
                SwipeMenuItem deleteItem = new SwipeMenuItem(getActivity().getApplicationContext());
                // set item background
                Drawable delid = getResources().getDrawable(R.color.red);
                deleteItem.setBackground(delid);
                deleteItem.setIcon(getResources().getDrawable(R.drawable.delete));
                // set item width
                deleteItem.setWidth(dp2px(90));
                // set a icon
                deleteItem.setTitle("Remove");
                deleteItem.setTitleSize(15);
                deleteItem.setTitleColor(Color.WHITE);
                // add to menu
                menu.addMenuItem(deleteItem);
            }

        };


        mListViewCoFounder.setOnMenuItemClickListener(new SwipeMenuListView.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(final int position, SwipeMenu menu, int index) {
                String id;

                switch (index) {
                    case 0:

                        if (menu.getMenuItem(index).getTitle().equalsIgnoreCase("Suspend")) {
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                                AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                                alertDialogBuilder
                                        .setMessage("Do you want to suspend this Co-Founder?")
                                        .setCancelable(false)
                                        .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                            }
                                        })
                                        .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                                ((HomeActivity) getActivity()).showProgressDialog();
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listCofounders.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "2" + "&loggedin_user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+"&startup_team_id="+listCofounders.get(position).getStartup_teamID(), Constants.HTTP_GET,"Home Activity");
                                                a.execute();

                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();

                                /*((HomeActivity) getActivity()).showProgressDialog();
                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listCofounders.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "2", Constants.HTTP_GET);
                                a.execute();*/
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        } else if (menu.getMenuItem(index).getTitle().equalsIgnoreCase("Resume")) {
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                                AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                                alertDialogBuilder
                                        .setMessage("Do you want to resume this Co-Founder?")
                                        .setCancelable(false)
                                        .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                            }
                                        })
                                        .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                                ((HomeActivity) getActivity()).showProgressDialog();
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listCofounders.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "1" + "&loggedin_user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+"&startup_team_id="+listCofounders.get(position).getStartup_teamID(), Constants.HTTP_GET,"Home Activity");
                                                a.execute();
                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();




                               /* ((HomeActivity) getActivity()).showProgressDialog();
                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listCofounders.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "1", Constants.HTTP_GET);
                                a.execute();*/
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        }


                        break;
                    case 1:

                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {


                            AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                            alertDialogBuilder
                                    .setMessage("Do you want to remove this Co-Founder?")
                                    .setCancelable(false)
                                    .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                        @Override
                                        public void onClick(DialogInterface dialog, int arg1) {
                                            dialog.cancel();
                                        }
                                    })
                                    .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                        @Override
                                        public void onClick(DialogInterface dialog, int arg1) {
                                            dialog.cancel();
                                            ((HomeActivity) getActivity()).showProgressDialog();
                                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listCofounders.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "3" + "&loggedin_user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+"&startup_team_id="+ listCofounders.get(position).getStartup_teamID(), Constants.HTTP_GET,"Home Activity");
                                            a.execute();

                                        }
                                    });

                            AlertDialog alertDialog = alertDialogBuilder.create();

                            alertDialog.show();


                           /* ((HomeActivity) getActivity()).showProgressDialog();
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listCofounders.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "3", Constants.HTTP_GET);
                            a.execute();*/
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }

                        break;
                }
                return false;
            }
        });


        mListViewTeamMember.setOnMenuItemClickListener(new SwipeMenuListView.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(final int position, SwipeMenu menu, int index) {
                String id;

                switch (index) {
                    case 0:


                        if (menu.getMenuItem(index).getTitle().equalsIgnoreCase("Suspend")) {
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                                AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                                alertDialogBuilder
                                        .setMessage("Do you want to suspend this Team-Member?")
                                        .setCancelable(false)
                                        .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                            }
                                        })
                                        .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                                ((HomeActivity) getActivity()).showProgressDialog();
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listTeamMembers.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "2" + "&loggedin_user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+"&startup_team_id="+ listTeamMembers.get(position).getStartup_teamID(), Constants.HTTP_GET,"Home Activity");
                                                a.execute();

                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();


                               /* ((HomeActivity) getActivity()).showProgressDialog();
                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listTeamMembers.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "2", Constants.HTTP_GET);
                                a.execute();*/
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        } else if (menu.getMenuItem(index).getTitle().equalsIgnoreCase("Resume")) {
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {


                                AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                                alertDialogBuilder
                                        .setMessage("Do you want to resume this Team-Member?")
                                        .setCancelable(false)
                                        .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                            }
                                        })
                                        .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                                ((HomeActivity) getActivity()).showProgressDialog();
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listTeamMembers.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "1" + "&loggedin_user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+"&startup_team_id="+ listTeamMembers.get(position).getStartup_teamID(), Constants.HTTP_GET,"Home Activity");
                                                a.execute();

                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();





                               /* ((HomeActivity) getActivity()).showProgressDialog();
                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listTeamMembers.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "1", Constants.HTTP_GET);
                                a.execute();*/
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        }


                        break;
                    case 1:


                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                            AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                            alertDialogBuilder
                                    .setMessage("Do you want to remove this Team-Member?")
                                    .setCancelable(false)
                                    .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                        @Override
                                        public void onClick(DialogInterface dialog, int arg1) {
                                            dialog.cancel();
                                        }
                                    })
                                    .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                        @Override
                                        public void onClick(DialogInterface dialog, int arg1) {
                                            dialog.cancel();
                                            ((HomeActivity) getActivity()).showProgressDialog();
                                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listTeamMembers.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "3" + "&loggedin_user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+"&startup_team_id="+listTeamMembers.get(position).getStartup_teamID(), Constants.HTTP_GET,"Home Activity");
                                            a.execute();

                                        }
                                    });

                            AlertDialog alertDialog = alertDialogBuilder.create();

                            alertDialog.show();

                            /*((HomeActivity) getActivity()).showProgressDialog();
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listTeamMembers.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "3", Constants.HTTP_GET);
                            a.execute();*/
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }

                        break;
                }
                return false;
            }
        });

        mListViewContractor.setOnMenuItemClickListener(new SwipeMenuListView.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(final int position, SwipeMenu menu, int index) {
                String id;

                switch (index) {
                    case 0:

                        if (menu.getMenuItem(index).getTitle().equalsIgnoreCase("Suspend")) {
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                                AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                                alertDialogBuilder
                                        .setMessage("Do you want to suspend this Contractor?")
                                        .setCancelable(false)
                                        .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                            }
                                        })
                                        .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                                ((HomeActivity) getActivity()).showProgressDialog();
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listContractors.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "2" + "&loggedin_user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+"&startup_team_id="+listContractors.get(position).getStartup_teamID(), Constants.HTTP_GET,"Home Activity");
                                                a.execute();

                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();



                                /*((HomeActivity) getActivity()).showProgressDialog();
                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listContractors.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "2", Constants.HTTP_GET);
                                a.execute();*/
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        } else if (menu.getMenuItem(index).getTitle().equalsIgnoreCase("Resume")) {
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {


                                AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                                alertDialogBuilder
                                        .setMessage("Do you want to resume this Contractor?")
                                        .setCancelable(false)
                                        .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                            }
                                        })
                                        .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                            @Override
                                            public void onClick(DialogInterface dialog, int arg1) {
                                                dialog.cancel();
                                                ((HomeActivity) getActivity()).showProgressDialog();
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listContractors.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "1" + "&loggedin_user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+"&startup_team_id="+listContractors.get(position).getStartup_teamID(), Constants.HTTP_GET,"Home Activity");
                                                a.execute();

                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();



                               /* ((HomeActivity) getActivity()).showProgressDialog();
                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listContractors.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "1", Constants.HTTP_GET);
                                a.execute();*/
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        }


                        break;
                    case 1:


                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                            alertDialogBuilder
                                    .setMessage("Do you want to remove this Contractor?")
                                    .setCancelable(false)
                                    .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                        @Override
                                        public void onClick(DialogInterface dialog, int arg1) {
                                            dialog.cancel();
                                        }
                                    })
                                    .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                        @Override
                                        public void onClick(DialogInterface dialog, int arg1) {
                                            dialog.cancel();
                                            ((HomeActivity) getActivity()).showProgressDialog();
                                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listContractors.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "3" + "&loggedin_user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+"&startup_team_id="+listContractors.get(position).getStartup_teamID(), Constants.HTTP_GET,"Home Activity");
                                            a.execute();

                                        }
                                    });

                            AlertDialog alertDialog = alertDialogBuilder.create();

                            alertDialog.show();


                            /*((HomeActivity) getActivity()).showProgressDialog();
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listContractors.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "3", Constants.HTTP_GET);
                            a.execute();*/
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }

                        break;
                }
                return false;
            }
        });

        recommendcontractor.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Fragment contractor = new RecommendedContractorsFragment();
                Bundle bundle = new Bundle();
                bundle.putString("commingFrom", "teams");
                bundle.putString("startup_id", CurrentStartUpDetailFragment.STARTUP_ID);
                bundle.putString("logged_in_user_role", String.valueOf(LOGGEDIN_USER_ROLE));
                contractor.setArguments(bundle);
                ((HomeActivity) getActivity()).replaceFragment(contractor);
                //getParentFragment().getFragmentManager().beginTransaction().addToBackStack(null).replace(R.id.container, contractor).commit();
            }
        });

        groupchat.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (usersIds.size() <= 2) {
                    Toast.makeText(getActivity(), "Group chat need atleast two group members", Toast.LENGTH_LONG).show();
                } else {
                    ((HomeActivity) getActivity()).showProgressDialog();
                    GenericQueryRule genericQueryRule = new GenericQueryRule(ORDER_RULE, ORDER_VALUE);
                    ArrayList<GenericQueryRule> rule = new ArrayList<>();
                    rule.add(genericQueryRule);

                    QBPagedRequestBuilder pagedRequestBuilder = new QBPagedRequestBuilder();
                    pagedRequestBuilder.setPage(1);
                    pagedRequestBuilder.setPerPage(LIMIT_USERS);

                    users = new ArrayList<Integer>(usersIds);

                    createDialogWithSelectedUsers(users, new QBEntityCallback<QBDialog>() {

                        @Override
                        public void onSuccess(QBDialog qbDialog, Bundle bundle) {

                            if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                            }
                        }

                        @Override
                        public void onError(QBResponseException e) {
                            if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                            }
                        }
                    });

                   /* } else {
                        //dialog.dismiss();
                        Toast.makeText(getActivity(), getString(R.string.select_users_choose_users), Toast.LENGTH_LONG).show();
                    }*/


                /*Fragment contractor = new ContactsFragment();
                getParentFragment().getFragmentManager().beginTransaction().addToBackStack(null).replace(R.id.container, contractor).commit();*/

                }
            }
        });

        return rootView;
    }

    private int dp2px(int dp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, getResources().getDisplayMetrics());
    }


    private String startup_teamID;
    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            if (tag.equalsIgnoreCase(Constants.STARTUP_TEAM_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);
                    usersIds.clear();
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        //String startup_id = jsonObject.optString("startup_id");

                        listEntrepreneurs.clear();
                        listCofounders.clear();
                        listContractors.clear();
                        listTeamMembers.clear();

                        if (jsonObject.optString("loggedin_role_id").trim().isEmpty()) {
                            LOGGEDIN_USER_ROLE = 1;
                        } else {
                            LOGGEDIN_USER_ROLE = Integer.parseInt(jsonObject.optString("loggedin_role_id"));
                        }

                        if (LOGGEDIN_USER_ROLE == 4) {
                            recommendcontractor.setVisibility(View.GONE);
                        }
                        else if(CurrentStartUpDetailFragment.from.compareTo("complete") == 0){
                            recommendcontractor.setVisibility(View.GONE);
                        }
                        else {
                            recommendcontractor.setVisibility(View.VISIBLE);
                        }

                        TeamMemberObject entrepreneur = new TeamMemberObject();

                        entrepreneur.setMemberName(jsonObject.optJSONObject("entrepreneur").optString("name").trim());
                        entrepreneur.setQuickbloxid(jsonObject.optJSONObject("entrepreneur").optInt("quickbloxid"));
                        entrepreneur.setMemberBio(jsonObject.optJSONObject("entrepreneur").optString("bio").trim());
                        entrepreneur.setMemberEmail(jsonObject.optJSONObject("entrepreneur").optString("email").trim());
                        entrepreneur.setMemberId(jsonObject.optJSONObject("entrepreneur").optString("id").trim());
                        entrepreneur.setIsPublicProfile(jsonObject.optJSONObject("entrepreneur").optString("is_profile_public").trim());
                        entrepreneur.setMemberDesignation("Entrepreneur");
                        listEntrepreneurs.add(entrepreneur);
                        usersIds.add(entrepreneur.getQuickbloxid());

                        for (int i = 0; i < jsonObject.optJSONArray("team_member").length(); i++) {

                            JSONObject team_memberOBJ = jsonObject.optJSONArray("team_member").getJSONObject(i);

                            if (team_memberOBJ.optString("member_role").trim().compareTo("Team-member") == 0) {
                                TeamMemberObject obj = new TeamMemberObject();
                                obj.setMemberId(team_memberOBJ.optString("team_memberid").trim());
                                obj.setMemberName(team_memberOBJ.optString("member_name").trim());
                                obj.setQuickbloxid(team_memberOBJ.optInt("quickbloxid"));
                                obj.setMemberDesignation(team_memberOBJ.optString("member_role").trim());
                                obj.setMemberBio(team_memberOBJ.optString("member_bio").trim());
                                obj.setMemberEmail(team_memberOBJ.optString("member_email").trim());
                                obj.setIsPublicProfile(team_memberOBJ.optString("is_profile_public").trim());
                                obj.setStartup_teamID(team_memberOBJ.optString("startup_team_id").trim());
                                if (team_memberOBJ.optString("member_status").trim().length() == 0) {
                                    obj.setMemberStatus(1);
                                } else {
                                    obj.setMemberStatus(Integer.parseInt(team_memberOBJ.optString("member_status").trim()));
                                }
                                usersIds.add(obj.getQuickbloxid());
                                listTeamMembers.add(obj);

                            } else if (team_memberOBJ.optString("member_role").trim().compareTo("Co-founder") == 0) {
                                TeamMemberObject obj = new TeamMemberObject();
                                obj.setMemberId(team_memberOBJ.optString("team_memberid").trim());
                                obj.setMemberName(team_memberOBJ.optString("member_name").trim());
                                obj.setMemberDesignation(team_memberOBJ.optString("member_role").trim());
                                obj.setMemberBio(team_memberOBJ.optString("member_bio").trim());
                                obj.setMemberEmail(team_memberOBJ.optString("member_email").trim());
                                obj.setQuickbloxid(team_memberOBJ.optInt("quickbloxid"));
                                obj.setIsPublicProfile(team_memberOBJ.optString("is_profile_public").trim());
                                obj.setStartup_teamID(team_memberOBJ.optString("startup_team_id").trim());
                                if (team_memberOBJ.optString("member_status").trim().length() == 0) {
                                    obj.setMemberStatus(1);
                                } else {
                                    obj.setMemberStatus(Integer.parseInt(team_memberOBJ.optString("member_status").trim()));
                                }

                                usersIds.add(obj.getQuickbloxid());

                                listCofounders.add(obj);
                            } else if (team_memberOBJ.optString("member_role").trim().compareTo("Contractor") == 0) {
                                TeamMemberObject obj = new TeamMemberObject();
                                obj.setMemberId(team_memberOBJ.optString("team_memberid").trim());
                                obj.setMemberName(team_memberOBJ.optString("member_name").trim());
                                obj.setMemberDesignation(team_memberOBJ.optString("member_role").trim());
                                obj.setMemberBio(team_memberOBJ.optString("member_bio").trim());
                                obj.setMemberEmail(team_memberOBJ.optString("member_email").trim());
                                obj.setQuickbloxid(team_memberOBJ.optInt("quickbloxid"));
                                obj.setIsPublicProfile(team_memberOBJ.optString("is_profile_public").trim());
                                obj.setStartup_teamID(team_memberOBJ.optString("startup_team_id").trim());
                                if (team_memberOBJ.optString("member_status").trim().length() == 0) {
                                    obj.setMemberStatus(1);
                                } else {
                                    obj.setMemberStatus(Integer.parseInt(team_memberOBJ.optString("member_status").trim()));
                                }

                                usersIds.add(obj.getQuickbloxid());
                                listContractors.add(obj);
                            }
                        }
                        Log.e("teamUserids", usersIds.toString());
                    }
                    adapterEntrePreneur = new TeamMemberAdapter(getActivity(), listEntrepreneurs);
                    mListViewEntrepreneur.setAdapter(adapterEntrePreneur);

                    adapterTeamMember = new TeamMemberAdapter(getActivity(), listTeamMembers);
                    mListViewTeamMember.setAdapter(adapterTeamMember);

                    adapterCoFounder = new TeamMemberAdapter(getActivity(), listCofounders);
                    mListViewCoFounder.setAdapter(adapterCoFounder);

                    adapterContractor = new TeamMemberAdapter(getActivity(), listContractors);
                    mListViewContractor.setAdapter(adapterContractor);


                    /*UtilityList.setListViewHeightBasedOnChildren(mListViewEntrepreneur);
                    UtilityList.setListViewHeightBasedOnChildren(mListViewTeamMember);
                    UtilityList.setListViewHeightBasedOnChildren(mListViewCoFounder);
                    UtilityList.setListViewHeightBasedOnChildren(mListViewContractor);*/


                    switch (LOGGEDIN_USER_ROLE) {
                        case 1:
                            if (CurrentStartUpDetailFragment.from.compareTo("complete") == 0) {

                            } else {
                                mListViewCoFounder.setMenuCreator(creator);
                                mListViewTeamMember.setMenuCreator(creator);
                                mListViewContractor.setMenuCreator(creator);
                            }
                            break;
                        case 2:
                            if (CurrentStartUpDetailFragment.from.compareTo("complete") == 0) {

                            } else {
                                mListViewTeamMember.setMenuCreator(creator);
                                mListViewContractor.setMenuCreator(creator);
                            }
                            break;
                        case 3:
                            if (CurrentStartUpDetailFragment.from.compareTo("complete") == 0) {

                            } else {
                                mListViewContractor.setMenuCreator(creator);
                            }
                            break;
                        case 4:
                            break;
                    }


                } catch (JSONException e) {
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.STARTUP_TEAM_MEMBER_STATUS_TAG)) {
                //((HomeActivity) getActivity()).dismissProgressDialog();

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            //((HomeActivity) getActivity()).showProgressDialog();
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_TAG, Constants.STARTUP_TEAM_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID, Constants.HTTP_GET,"Home Activity");
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        Toast.makeText(getActivity(), jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                    }

                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            }
        }
    }

    boolean isAlreadyCreatedGroup = false;
    QBDialog dialogToBeUpdated;

    public void createDialogWithSelectedUsers(final ArrayList<Integer> usersIds, final QBEntityCallback<QBDialog> callback) {

        Log.e("userids", usersIds.toString());
        final QBDialog dialog = new QBDialog();
        dialog.setName(CurrentStartUpDetailFragment.titleSTartup + " Group");
        dialog.setType(QBDialogType.GROUP);
        dialog.setOccupantsIds(usersIds);



       /* QBCustomObject object = new QBCustomObject();
        object.setClassName("CustomDialogClass");
        object.putString("startup_id", CurrentStartUpDetailFragment.STARTUP_ID);*/

        QBRequestGetBuilder requestBuilder = new QBRequestGetBuilder();
        requestBuilder.addRule("startup_id", QueryRule.EQ, CurrentStartUpDetailFragment.STARTUP_ID);

        QBCustomObjects.getObjects("CustomDialogClass", requestBuilder, new QBEntityCallback<ArrayList<QBCustomObject>>() {
            @Override
            public void onSuccess(ArrayList<QBCustomObject> customObjects, Bundle params) {
                for (int i = 0; i < customObjects.size(); i++) {

                    if (customObjects.get(i).get("startup_id").toString().equalsIgnoreCase(CurrentStartUpDetailFragment.STARTUP_ID)) {
                        isAlreadyCreatedGroup = true;
                        Log.e("dialogid", customObjects.get(i).get("dialog_id").toString());
                        dialogToBeUpdated = new QBDialog();
                        dialogToBeUpdated.setDialogId(customObjects.get(i).get("dialog_id").toString());
                        break;
                    }
                }


                if (!isAlreadyCreatedGroup) {
                    QBChatService.getInstance().getGroupChatManager().createDialog(dialog, new QbEntityCallbackWrapper<QBDialog>(callback) {
                                @Override
                                public void onSuccess(QBDialog dialog, Bundle args) {
                                    super.onSuccess(dialog, args);

                                    QBCustomObject object = new QBCustomObject();
                                    object.putString("startup_id", CurrentStartUpDetailFragment.STARTUP_ID);
                                    object.putString("dialog_id", dialog.getDialogId().toString());

                                    object.setClassName("CustomDialogClass");

                                    QBCustomObjects.createObject(object, new QBEntityCallback<QBCustomObject>() {
                                        @Override
                                        public void onSuccess(QBCustomObject createdObject, Bundle params) {
                                            Log.e("class", "classcreated");
                                        }

                                        @Override
                                        public void onError(QBResponseException errors) {
                                            Log.e("class", errors.toString());
                                        }
                                    });

                                    Fragment addContributor = new ChatFragment();

                                    Bundle bundle = new Bundle();
                                    bundle.putSerializable("dialog", dialog);
                                    addContributor.setArguments(bundle);
                                    ((HomeActivity) getActivity()).replaceFragment(addContributor);

                                    if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                                        ((HomeActivity) getActivity()).dismissProgressDialog();
                                    }
                                }
                            }
                    );
                } else {

                    QBDialogRequestBuilder requestBuilder = new QBDialogRequestBuilder();
                    for (int i=0;i< usersIds.size();i++){
                        requestBuilder.addUsers(usersIds.get(i));
                    }

                   // QBRequestUpdateBuilder requestBuilder = new QBRequestUpdateBuilder();
                    //requestBuilder.pushAll("occupants_ids", usersIds);
                    //dialogToBeUpdated.setOccupantsIds(usersIds);
                    dialogToBeUpdated.setName(CurrentStartUpDetailFragment.titleSTartup + " Group");

                    QBChatService.getInstance().getGroupChatManager().updateDialog(dialogToBeUpdated, requestBuilder, new QBEntityCallback<QBDialog>() {
                        @Override
                        public void onSuccess(QBDialog dialog, Bundle args) {

                            Fragment addContributor = new ChatFragment();

                            Bundle bundle = new Bundle();
                            bundle.putSerializable("dialog", dialog);
                            addContributor.setArguments(bundle);
                            ((HomeActivity) getActivity()).replaceFragment(addContributor);

                            if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                            }
                        }

                        @Override
                        public void onError(QBResponseException errors) {
                            if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                            }
                            if (errors.getMessage().equalsIgnoreCase("You don't have appropriate permissions to perform this operation")){
                                Toast.makeText(getActivity(), "Ask Group Admin to add you in group.", Toast.LENGTH_LONG).show();
                            }
                        }
                    });
                }
            }

            @Override
            public void onError(QBResponseException errors) {
                if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                }
                Toast.makeText(getActivity(), "Group not created", Toast.LENGTH_LONG).show();
            }
        });


       /* QBDialogCustomData customData = new QBDialogCustomData("CustomDialogClass"); // class name
        customData.putInteger("startup_id", Integer.parseInt(CurrentStartUpDetailFragment.STARTUP_ID)); // field 'startup_id'

        dialog.setCustomData(customData);*/

        /*QBRequestGetBuilder customObjectRequestBuilder = new QBRequestGetBuilder();
        customObjectRequestBuilder.setLimit(100);
        customObjectRequestBuilder.addRule("type", QueryRule.EQ, "2");
        customObjectRequestBuilder.addRule("data[class_name]", QueryRule.EQ, "CustomDialogClass");
        customObjectRequestBuilder.addRule("data[startup_id]", QueryRule.EQ, Integer.parseInt(CurrentStartUpDetailFragment.STARTUP_ID));

        QBChatService.getChatDialogs(null, customObjectRequestBuilder, new QBEntityCallback<ArrayList<QBDialog>>() {
            @Override
            public void onSuccess(ArrayList<QBDialog> dialogs, Bundle args) {
                Iterator<QBDialog> dialogIterator = dialogs.iterator();
                while (dialogIterator.hasNext()) {
                    QBDialog dialog = dialogIterator.next();
                    if (dialog.getType() == QBDialogType.PUBLIC_GROUP) {
                        dialogIterator.remove();
                    }
                }

                Log.e("bundle", args.keySet().toString());
                for (int i = 0; i < dialogs.size(); i++) {

                    try {
                        QBDialogCustomData mycustomdata = dialogs.get(i).getCustomData();
                        Log.e("mycustomData", mycustomdata.getClassName());

                        if (mycustomdata.getInteger("startup_id") == Integer.parseInt(CurrentStartUpDetailFragment.STARTUP_ID)) {
                            dialogToBeUpdated = dialogs.get(i);
                            isAlreadyCreatedGroup = true;
                            break;
                        }
                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                Log.e("allready", String.valueOf(isAlreadyCreatedGroup));

                if (!isAlreadyCreatedGroup) {
                    QBChatService.getInstance().getGroupChatManager().createDialog(dialog, new QbEntityCallbackWrapper<QBDialog>(callback) {
                                @Override
                                public void onSuccess(QBDialog dialog, Bundle args) {
                                    super.onSuccess(dialog, args);
                                    Fragment addContributor = new ChatFragment();

                                    Bundle bundle = new Bundle();
                                    bundle.putSerializable("dialog", dialog);
                                    addContributor.setArguments(bundle);
                                    ((HomeActivity) getActivity()).replaceFragment(addContributor);

                                    if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                                        ((HomeActivity) getActivity()).dismissProgressDialog();
                                    }
                                }
                            }
                    );
                } else {

                    QBRequestUpdateBuilder requestBuilder = new QBRequestUpdateBuilder();
                    dialogToBeUpdated.setOccupantsIds(usersIds);
                    dialogToBeUpdated.setName(CurrentStartUpDetailFragment.titleSTartup + " Group");

                    QBChatService.getInstance().getGroupChatManager().updateDialog(dialogToBeUpdated, requestBuilder, new QBEntityCallback<QBDialog>() {
                        @Override
                        public void onSuccess(QBDialog dialog, Bundle args) {

                            Fragment addContributor = new ChatFragment();

                            Bundle bundle = new Bundle();
                            bundle.putSerializable("dialog", dialog);
                            addContributor.setArguments(bundle);
                            ((HomeActivity) getActivity()).replaceFragment(addContributor);

                            if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                            }
                        }

                        @Override
                        public void onError(QBResponseException errors) {
                            if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                            }
                        }
                    });
                }

            }

            @Override
            public void onError(QBResponseException e) {
                if (((HomeActivity) getActivity()).isShowingProgressDialog()) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                }
            }
        });*/
    }
}
