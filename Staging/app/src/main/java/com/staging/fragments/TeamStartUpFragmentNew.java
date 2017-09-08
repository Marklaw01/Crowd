package com.staging.fragments;

import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.TeamMemberAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.stickyswipelistview.StickyHeadersSwipeToDismissListView;
import com.staging.swipelistviewinscrollview.SwipeMenu;
import com.staging.swipelistviewinscrollview.SwipeMenuCreator;
import com.staging.swipelistviewinscrollview.SwipeMenuItem;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by sunakshi.gautam on 1/21/2016.
 */
public class TeamStartUpFragmentNew extends Fragment implements AsyncTaskCompleteListener<String> {

    public static int LOGGEDIN_USER_ROLE = 1;
    private Button recommendcontractor, groupchat;
    private EditText et_search;
    private TeamMemberAdapter adapterEntrePreneur;
    private TeamMemberAdapter adapterCoFounder;
    private TeamMemberAdapter adapterTeamMember;
    private TeamMemberAdapter adapterContractor;

    private SwipeMenuCreator creator;
    StickyHeadersSwipeToDismissListView mListViewEntrepreneur;
    /*private ListViewForEmbeddingInScrollView mListViewEntrepreneur;
    private SwipeMenuListView mListViewCoFounder;
    private SwipeMenuListView mListViewTeamMember;
    private SwipeMenuListView mListViewContractor;

    public static ArrayList<TeamMemberObject> listEntrepreneurs;
    public static ArrayList<TeamMemberObject> listCofounders;
    public static ArrayList<TeamMemberObject> listTeamMembers;
    public static ArrayList<TeamMemberObject> listContractors;*/


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
        View rootView = inflater.inflate(R.layout.fragment_teamstartup_new, container, false);

        et_search = (EditText) rootView.findViewById(R.id.et_search);
        recommendcontractor = (Button) rootView.findViewById(R.id.recommendcontractor);
        groupchat = (Button) rootView.findViewById(R.id.groupchat);

        mListViewEntrepreneur = (StickyHeadersSwipeToDismissListView) rootView.findViewById(R.id.listView);

        /*listEntrepreneurs = new ArrayList<TeamMemberObject>();
        listCofounders = new ArrayList<TeamMemberObject>();
        listTeamMembers = new ArrayList<TeamMemberObject>();
        listContractors = new ArrayList<TeamMemberObject>();

        mListViewEntrepreneur = (ListViewForEmbeddingInScrollView) rootView.findViewById(R.id.listViewentrepreneur);
        mListViewCoFounder = (SwipeMenuListView) rootView.findViewById(R.id.listViewcofounders);
        mListViewTeamMember = (SwipeMenuListView) rootView.findViewById(R.id.listViewteammember);
        mListViewContractor = (SwipeMenuListView) rootView.findViewById(R.id.listViewcontractor);


        mListViewEntrepreneur.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (!((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID).equalsIgnoreCase(listEntrepreneurs.get(position).getMemberId())) {
                    Fragment contractor = new ViewEntrepreneurPublicProfileFragment();
                    Bundle bundle = new Bundle();
                    bundle.putString("id", listEntrepreneurs.get(position).getMemberId());
                    bundle.putString("COMMING_FROM", "entrepreneur");
                    contractor.setArguments(bundle);
                    getParentFragment().getFragmentManager().beginTransaction().addToBackStack(null).replace(R.id.container, contractor).commit();
                }

            }
        });


        mListViewCoFounder.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (!((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID).equalsIgnoreCase(listCofounders.get(position).getMemberId())) {
                    Fragment contractor = new ViewContractorPublicProfileFragment();
                    Bundle bundle = new Bundle();
                    bundle.putString("id", listCofounders.get(position).getMemberId());
                    bundle.putString("COMMING_FROM", "Teams");
                    contractor.setArguments(bundle);
                    getParentFragment().getFragmentManager().beginTransaction().addToBackStack(null).replace(R.id.container, contractor).commit();
                }


            }
        });


        mListViewTeamMember.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (!((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID).equalsIgnoreCase(listTeamMembers.get(position).getMemberId())) {
                    Fragment contractor = new ViewContractorPublicProfileFragment();
                    Bundle bundle = new Bundle();
                    bundle.putString("id", listTeamMembers.get(position).getMemberId());
                    bundle.putString("COMMING_FROM", "Teams");
                    contractor.setArguments(bundle);
                    getParentFragment().getFragmentManager().beginTransaction().addToBackStack(null).replace(R.id.container, contractor).commit();
                }


            }
        });


        mListViewContractor.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (!((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID).equalsIgnoreCase(listContractors.get(position).getMemberId())) {
                    Fragment contractor = new ViewContractorPublicProfileFragment();
                    Bundle bundle = new Bundle();
                    bundle.putString("id", listContractors.get(position).getMemberId());
                    bundle.putString("COMMING_FROM", "Teams");
                    contractor.setArguments(bundle);
                    getParentFragment().getFragmentManager().beginTransaction().addToBackStack(null).replace(R.id.container, contractor).commit();
                }
            }
        });

        */

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


        /*mListViewCoFounder.setOnMenuItemClickListener(new SwipeMenuListView.OnMenuItemClickListener() {
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
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listCofounders.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "2", Constants.HTTP_GET);
                                                a.execute();

                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();


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
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listCofounders.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "1", Constants.HTTP_GET);
                                                a.execute();
                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();

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
                                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listCofounders.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "3", Constants.HTTP_GET);
                                            a.execute();

                                        }
                                    });

                            AlertDialog alertDialog = alertDialogBuilder.create();

                            alertDialog.show();

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
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listTeamMembers.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "2", Constants.HTTP_GET);
                                                a.execute();

                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();

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
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listTeamMembers.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "1", Constants.HTTP_GET);
                                                a.execute();

                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();

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
                                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listTeamMembers.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "3", Constants.HTTP_GET);
                                            a.execute();

                                        }
                                    });

                            AlertDialog alertDialog = alertDialogBuilder.create();

                            alertDialog.show();

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
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listContractors.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "2", Constants.HTTP_GET);
                                                a.execute();

                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();

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
                                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listContractors.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "1", Constants.HTTP_GET);
                                                a.execute();

                                            }
                                        });

                                AlertDialog alertDialog = alertDialogBuilder.create();

                                alertDialog.show();

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
                                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_TEAM_MEMBER_STATUS_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + listContractors.get(position).getMemberId() + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID + "&status=" + "3", Constants.HTTP_GET);
                                            a.execute();

                                        }
                                    });

                            AlertDialog alertDialog = alertDialogBuilder.create();

                            alertDialog.show();

                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }

                        break;
                }
                return false;
            }
        });
*/
        recommendcontractor.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Fragment contractor = new RecommendedContractorsFragment();
                Bundle bundle = new Bundle();
                bundle.putString("commingFrom", "teams");
                bundle.putString("startup_id", CurrentStartUpDetailFragment.STARTUP_ID);
                bundle.putString("logged_in_user_role", String.valueOf(LOGGEDIN_USER_ROLE));
                contractor.setArguments(bundle);

                getParentFragment().getFragmentManager().beginTransaction().addToBackStack(null).replace(R.id.container, contractor).commit();
            }
        });

        groupchat.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Fragment contractor = new ContactsFragment();
                getParentFragment().getFragmentManager().beginTransaction().addToBackStack(null).replace(R.id.container, contractor).commit();
            }
        });

        return rootView;
    }

    private int dp2px(int dp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, getResources().getDisplayMetrics());
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
            if (tag.equalsIgnoreCase(Constants.STARTUP_TEAM_TAG)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();

                /*try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

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
                        } else {
                            recommendcontractor.setVisibility(View.VISIBLE);
                        }

                        TeamMemberObject entrepreneur = new TeamMemberObject();

                        entrepreneur.setMemberName(jsonObject.optJSONObject("entrepreneur").optString("name").trim());

                        entrepreneur.setMemberBio(jsonObject.optJSONObject("entrepreneur").optString("bio").trim());
                        entrepreneur.setMemberEmail(jsonObject.optJSONObject("entrepreneur").optString("email").trim());
                        entrepreneur.setMemberId(jsonObject.optJSONObject("entrepreneur").optString("id").trim());
                        entrepreneur.setMemberDesignation("Entrepreneur");
                        listEntrepreneurs.add(entrepreneur);


                        for (int i = 0; i < jsonObject.optJSONArray("team_member").length(); i++) {

                            JSONObject team_memberOBJ = jsonObject.optJSONArray("team_member").getJSONObject(i);

                            if (team_memberOBJ.optString("member_role").trim().compareTo("Team-member") == 0) {
                                TeamMemberObject obj = new TeamMemberObject();
                                obj.setMemberId(team_memberOBJ.optString("team_memberid").trim());
                                obj.setMemberName(team_memberOBJ.optString("member_name").trim());
                                obj.setMemberDesignation(team_memberOBJ.optString("member_role").trim());
                                obj.setMemberBio(team_memberOBJ.optString("member_bio").trim());
                                obj.setMemberEmail(team_memberOBJ.optString("member_email").trim());
                                if (team_memberOBJ.optString("member_status").trim().length() == 0) {
                                    obj.setMemberStatus(1);
                                } else {
                                    obj.setMemberStatus(Integer.parseInt(team_memberOBJ.optString("member_status").trim()));
                                }

                                listTeamMembers.add(obj);

                            } else if (team_memberOBJ.optString("member_role").trim().compareTo("Co-founder") == 0) {
                                TeamMemberObject obj = new TeamMemberObject();
                                obj.setMemberId(team_memberOBJ.optString("team_memberid").trim());
                                obj.setMemberName(team_memberOBJ.optString("member_name").trim());
                                obj.setMemberDesignation(team_memberOBJ.optString("member_role").trim());
                                obj.setMemberBio(team_memberOBJ.optString("member_bio").trim());
                                obj.setMemberEmail(team_memberOBJ.optString("member_email").trim());
                                if (team_memberOBJ.optString("member_status").trim().length() == 0) {
                                    obj.setMemberStatus(1);
                                } else {
                                    obj.setMemberStatus(Integer.parseInt(team_memberOBJ.optString("member_status").trim()));
                                }

                                listCofounders.add(obj);
                            } else if (team_memberOBJ.optString("member_role").trim().compareTo("Contractor") == 0) {
                                TeamMemberObject obj = new TeamMemberObject();
                                obj.setMemberId(team_memberOBJ.optString("team_memberid").trim());
                                obj.setMemberName(team_memberOBJ.optString("member_name").trim());
                                obj.setMemberDesignation(team_memberOBJ.optString("member_role").trim());
                                obj.setMemberBio(team_memberOBJ.optString("member_bio").trim());
                                obj.setMemberEmail(team_memberOBJ.optString("member_email").trim());
                                if (team_memberOBJ.optString("member_status").trim().length() == 0) {
                                    obj.setMemberStatus(1);
                                } else {
                                    obj.setMemberStatus(Integer.parseInt(team_memberOBJ.optString("member_status").trim()));
                                }

                                listContractors.add(obj);
                            }
                        }

                    }
                    adapterEntrePreneur = new TeamMemberAdapter(getActivity(), listEntrepreneurs);
                    mListViewEntrepreneur.setAdapter(adapterEntrePreneur);

                    adapterTeamMember = new TeamMemberAdapter(getActivity(), listTeamMembers);
                    mListViewTeamMember.setAdapter(adapterTeamMember);

                    adapterCoFounder = new TeamMemberAdapter(getActivity(), listCofounders);
                    mListViewCoFounder.setAdapter(adapterCoFounder);

                    adapterContractor = new TeamMemberAdapter(getActivity(), listContractors);
                    mListViewContractor.setAdapter(adapterContractor);




                    switch (LOGGEDIN_USER_ROLE) {
                        case 1:
                            mListViewCoFounder.setMenuCreator(creator);
                            mListViewTeamMember.setMenuCreator(creator);
                            mListViewContractor.setMenuCreator(creator);
                            break;
                        case 2:
                            mListViewTeamMember.setMenuCreator(creator);
                            mListViewContractor.setMenuCreator(creator);
                            break;
                        case 3:
                            mListViewContractor.setMenuCreator(creator);
                            break;
                        case 4:
                            break;
                    }


                } catch (JSONException e) {
                    e.printStackTrace();
                }*/
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
}
