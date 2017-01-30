package com.staging.activities;

import android.app.AlertDialog;
import android.app.NotificationManager;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.LayerDrawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.widget.Toolbar;

import android.text.Html;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.ExpandableListView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.iid.InstanceID;
import com.mikepenz.fontawesome_typeface_library.FontAwesome;
import com.staging.R;
import com.staging.adapter.ExpandableAdapter;
import com.staging.chat.QbUsersHolder;
import com.staging.fragments.AddStartupFragment;
import com.staging.fragments.ArchivedForumsFragment;
import com.staging.fragments.ArchivedNotificationFragment;
import com.staging.fragments.AudioVideoFragment;
import com.staging.fragments.BetaTestersFragment;
import com.staging.fragments.BoardMembersFragment;
import com.staging.fragments.CampaignsTabFragment;
import com.staging.fragments.ChatTabFragment;
import com.staging.fragments.ChoosePaymentGatewayFragment;
import com.staging.fragments.CommunalAssetsFragment;
import com.staging.fragments.ConferencesFragment;
import com.staging.fragments.ConnectionsFragment;
import com.staging.fragments.ConsultingFragment;
import com.staging.fragments.ContractorVideoFragment;
import com.staging.fragments.CurrentStartUpFragment;
import com.staging.fragments.DemoDaysFragment;
import com.staging.fragments.EarlyAdatorsFragment;
import com.staging.fragments.EndorsersFragment;
import com.staging.fragments.EntrepreneurVideoFragment;
import com.staging.fragments.FocusGroupsFragment;
import com.staging.fragments.ForumDetailsFragment;
import com.staging.fragments.ForumsTabFragment;
import com.staging.fragments.FundsFragment;
import com.staging.fragments.GroupsFragment;
import com.staging.fragments.HardwarFragment;
import com.staging.fragments.HomeFragment;
import com.staging.fragments.InformationFragment;
import com.staging.fragments.JobsFragment;
import com.staging.fragments.ManageWorkOrdersFragment;
import com.staging.fragments.MeetUpFragment;
import com.staging.fragments.MessagesFragment;
import com.staging.fragments.NotesFragment;
import com.staging.fragments.NotifictaionsListFragment;
import com.staging.fragments.OrganizationSearchFragment;
import com.staging.fragments.OrgnizationVideoFragment;
import com.staging.fragments.ProductivityFragment;
import com.staging.fragments.ProfileFragment;
import com.staging.fragments.RecruitersFragment;
import com.staging.fragments.RoadmapVideoFragment;
import com.staging.fragments.SearchCampaignFragment;
import com.staging.fragments.SearchContractorsFragment;
import com.staging.fragments.ServicesFragment;
import com.staging.fragments.SettingsFragment;
import com.staging.fragments.SoftwareFragment;
import com.staging.fragments.StartupApplicatioFragment;
import com.staging.fragments.StartupProfileFragment;
import com.staging.fragments.SuggestKeywordsFragment;
import com.staging.fragments.ViewContractorPublicProfileFragment;
import com.staging.fragments.ViewContractorsFragment;
import com.staging.fragments.WebinarFragment;
import com.staging.helper.BadgeDrawable;
import com.staging.helper.CircleImageView;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.listeners.onActivityResultListener;
import com.staging.logger.CrowdBootstrapLogger;
import com.staging.models.GenericObject;
import com.staging.models.NavDrawerItem;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.NetworkConnectivity;
import com.staging.utilities.PrefManager;
import com.staging.utilities.UtilitiesClass;
import com.google.android.gms.gcm.GoogleCloudMessaging;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.quickblox.chat.QBChatService;
import com.quickblox.core.QBEntityCallback;
import com.quickblox.core.exception.QBResponseException;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import static android.content.pm.ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
import static com.mikepenz.actionitembadge.library.ActionItemBadge.*;

//import com.quickblox.users.model.QBUser;

//import com.crowdbootstrapapp.chat.core.ChatService;


/**
 * Created by sunakshi.gautam on 1/13/2016.
 */
public class HomeActivity extends BaseActivity implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    //Thread notificationThread;
    ProgressDialog pd;
    public static TextView userName;
    public static String filename;
    public static Bitmap bitmap;
    LayoutInflater inflater;
    public static CircleImageView mUserImage;
    private Handler mHandler;
    public onActivityResultListener activytresultListener;
    public AsyncTaskCompleteListener<String> mListener;
    private ArrayList<NavDrawerItem> contributorNavigationArray, contributiorChildNavigationArrayStartup, contributiorChildNavigationArrayMessages, contributiorChildNavigationArrayContractor, contributorOrganizations;
    private ArrayList<NavDrawerItem> contributorNavigationProfileArray, contributorNavigationEvents, contributorNavigationResource, contributorNavigationOpportunities;
    private HashMap<Integer, ArrayList<NavDrawerItem>> contributiorChildArray = new HashMap<>();
    //private int DRAWER_ITEM_POSITION = 0;
    DrawerLayout mDrawerLayout;
    //public static TextView title;
    //private NavigationAdapter mAdapter;
    public ExpandableListView mDrawerList;

    private ActionBarDrawerToggle mDrawerToggle;
    private int lastExpandedGroupPosition;
    private int lastExpandedGroupPositionfirst;
    private int lastExpandedGroupPositionsecond;
    private int lastExpandedGroupPositionthird;
    private int lastExpandedGroupPositionfourth;
    private int lastExpandedGroupPositionfifth;
    private int lastExpandedGroupPositionsixth;
    private int lastExpandedGroupPositionseventh;
    private TextView referTextView;
    String StartupId = "";
    String notification_id = "";
    String ExtraMessageForAddTeamMember = "";
    String connectionNotificationStatus = "";
    String connectionUserId = "";
    String connectionConnectionID = "";
    String connectionStatus = "";

    public DisplayImageOptions options;
    private MenuItem itemMessages;


    public boolean isShowingProgressDialog() {
        return pd.isShowing();
    }

    public void showProgressDialog() {
        pd = new ProgressDialog(HomeActivity.this);
        pd.setMessage(Html.fromHtml("<b>" + getString(R.string.please_wait) + "</b>"));
        pd.setIndeterminate(true);
        pd.setCancelable(false);

        pd.show();
    }

    public void dismissProgressDialog() {
        if (pd.isShowing()) {
            pd.dismiss();
        }
    }

    public PrefManager prefManager;
    public NetworkConnectivity networkConnectivity;
    public UtilitiesClass utilitiesClass;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        try {
            prefManager = PrefManager.getInstance(HomeActivity.this);
            utilitiesClass = UtilitiesClass.getInstance(HomeActivity.this);
            networkConnectivity = NetworkConnectivity.getInstance(HomeActivity.this);
            mDrawerLayout = (DrawerLayout) findViewById(R.id.drawerLayout);
            mHandler = new Handler();

            options = new DisplayImageOptions.Builder()
                    .showImageOnLoading(R.drawable.image)
                    .showImageForEmptyUri(R.drawable.image)
                    .showImageOnFail(R.drawable.image)
                    .cacheInMemory(true)
                    .cacheOnDisk(true)
                    .considerExifParams(true)
                    .bitmapConfig(Bitmap.Config.RGB_565)
                    .build();

            toolbarTitle = (TextView) findViewById(R.id.titletext);
            mDrawerList = (ExpandableListView) findViewById(R.id.left_drawer);

            setupDrawer();
            addDrawerItemsForEntrepreneur();

            Bundle data = getIntent().getExtras();


            if (data != null) {
                if (data.containsKey(Constants.NOTIFICATION_TAG)) {
                    if (data.getString(Constants.NOTIFICATION_TAG).equalsIgnoreCase(Constants.NOTIFICATION_PROFILE_TAG) || data.getString(Constants.NOTIFICATION_TAG).equalsIgnoreCase(Constants.NOTIFICATION_FOLLOW_CAMPAIGN_TAG) || data.getString(Constants.NOTIFICATION_TAG).equalsIgnoreCase(Constants.NOTIFICATION_UNFOLLOW_CAMPAIGN_TAG) || data.getString(Constants.NOTIFICATION_TAG).equalsIgnoreCase(Constants.NOTIFICATION_TEAM_MEMBER_STAUS)) {
                        mDrawerList.setItemChecked(1, true);
                        Fragment fragment = new NotifictaionsListFragment();
                        if (fragment != null) {
                            FragmentManager fragmentManager = getSupportFragmentManager();
                            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.replace(R.id.container, fragment);
                            //fragmentTransaction.addToBackStack(HomeFragment.class.getName());
                            fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                            fragmentTransaction.commit();
                        }
                    } else if (data.getString(Constants.NOTIFICATION_TAG).equalsIgnoreCase(Constants.NOTIFICATION_MESSAGE_TAG)) {
                        mDrawerList.setItemChecked(10, true);
                        Fragment fragment = new MessagesFragment();
                        if (fragment != null) {
                            FragmentManager fragmentManager = getSupportFragmentManager();
                            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.replace(R.id.container, fragment);
                            //fragmentTransaction.addToBackStack(HomeFragment.class.getName());
                            fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                            fragmentTransaction.commit();
                        }
                    } else if (data.getString(Constants.NOTIFICATION_TAG).equalsIgnoreCase(Constants.NOTIFICATION_COMMIT_CAMPAIGN_TAG) || data.getString(Constants.NOTIFICATION_TAG).equalsIgnoreCase(Constants.NOTIFICATION_UNCOMMIT_CAMPAIGN_TAG)) {
                        mDrawerList.setItemChecked(5, true);
                        toolbarTitle.setText("Campaigns");
                        try {
                            Fragment fragment = new ViewContractorsFragment();
                            Bundle bundle = new Bundle();
                            try {
                                Log.e("values", "" + data.get("values"));
                                JSONObject values = new JSONObject(data.getString("values"));
                                // Log.e("values", data.getString("values"));
                                bundle.putString("CAMPAIGN_NAME", values.getString("campaign_name"));
                                bundle.putString("CAMPAIGN_ID", values.getString("campaign_id"));
                                bundle.putString("CommingFrom", "EditCampaign");
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }


                            //bundle.putString("home", "home");
                            fragment.setArguments(bundle);
                            FragmentManager fragmentManager = getSupportFragmentManager();
                            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.replace(R.id.container, fragment);
                            //fragmentTransaction.addToBackStack(HomeFragment.class.getName());
                            fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                            fragmentTransaction.commit();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                    } else if (data.getString(Constants.NOTIFICATION_TAG).equalsIgnoreCase(Constants.NOTIFICATION_RATE_PROFILE)) {

                        mDrawerList.setItemChecked(6, true);
                        toolbarTitle.setText("Campaigns");
                        Fragment fragment = new ViewContractorPublicProfileFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("COMMING_FROM", "home");
                        fragment.setArguments(bundle);
                        FragmentManager fragmentManager = getSupportFragmentManager();
                        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                        fragmentTransaction.replace(R.id.container, fragment);
                        //fragmentTransaction.addToBackStack(HomeFragment.class.getName());

                        fragmentTransaction.commit();
                    } else if (data.getString(Constants.NOTIFICATION_TAG).equalsIgnoreCase(Constants.NOTIFICATION_COMMENT_FOURM)) {
                        try {
                            Fragment fragment = new ForumDetailsFragment();
                            Bundle bundle = new Bundle();

                            try {
                                Log.e("values", "" + data.get("values"));
                                JSONObject values = new JSONObject(data.getString("values"));
                                // Log.e("values", data.getString("values"));
                                bundle.putString("forum_id", values.getString("forum_id"));
                                bundle.putString("TITLE", values.getString("forum_name"));
                                bundle.putString("COMMING_FROM", "MyForums");
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }

                            fragment.setArguments(bundle);
                            replaceFragment(fragment);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    /*if (fragment != null) {
                        FragmentManager fragmentManager = getSupportFragmentManager();
                        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                        fragmentTransaction.replace(R.id.container, fragment);
                        //fragmentTransaction.addToBackStack(HomeFragment.class.getName());
                       // fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                        fragmentTransaction.commit();
                    }*/
                    } else if (data.getString(Constants.NOTIFICATION_TAG).equalsIgnoreCase(Constants.NOTIFICATION_ADD_TEAM_MEMBER)) {

                        try {
                            JSONObject values = new JSONObject(data.getString("values"));
                            StartupId = values.getString("startup_id");
                            notification_id = values.getString("notification_id");
                            ExtraMessageForAddTeamMember = values.getString("extra_message");
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                        AlertDialog.Builder builder = new AlertDialog.Builder(HomeActivity.this);
                        builder.setTitle("Do you want to work with this team?");
                        builder.setMessage(ExtraMessageForAddTeamMember)
                                .setCancelable(false)
                                .setNeutralButton("Later", new DialogInterface.OnClickListener() {

                                    @Override
                                    public void onClick(DialogInterface dialog, int arg1) {
                                        dialog.dismiss();
                                        Fragment fragment = new NotifictaionsListFragment();

                                        if (fragment != null) {
                                            FragmentManager fragmentManager = getSupportFragmentManager();
                                            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                                            fragmentTransaction.replace(R.id.container, fragment);
                                            fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                            fragmentTransaction.commit();
                                        }
                                    }
                                })
                                .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                    @Override
                                    public void onClick(DialogInterface dialog, int arg1) {
                                        //dialog.cancel();
                                        if (networkConnectivity.isOnline()) {
                                            showProgressDialog();
                                            Async a = new Async(HomeActivity.this, (AsyncTaskCompleteListener<String>) HomeActivity.this, Constants.STARTUP_TEAM_MEMBER_STATUS_HOME_SCREEN_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + prefManager.getString(Constants.USER_ID) + "&startup_id=" + StartupId + "&status=" + "1" + "&loggedin_user_id=" + prefManager.getString(Constants.USER_ID) + "&notification_id=" + notification_id, Constants.HTTP_GET, "Home Activity");
                                            a.execute();
                                            dialog.dismiss();
                                        } else {
                                            utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                        }

                                    }
                                })
                                .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                    @Override
                                    public void onClick(DialogInterface dialog, int arg1) {
                                        if (networkConnectivity.isOnline()) {
                                            showProgressDialog();
                                            Async a = new Async(HomeActivity.this, (AsyncTaskCompleteListener<String>) HomeActivity.this, Constants.STARTUP_TEAM_MEMBER_STATUS_HOME_SCREEN_TAG, Constants.STARTUP_TEAM_MEMBER_STATUS_URL + "?user_id=" + prefManager.getString(Constants.USER_ID) + "&startup_id=" + StartupId + "&status=" + "3" + "&loggedin_user_id=" + prefManager.getString(Constants.USER_ID) + "&notification_id=" + notification_id, Constants.HTTP_GET, "Home Activity");
                                            a.execute();
                                            dialog.dismiss();
                                        } else {
                                            dialog.dismiss();
                                            utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                        }
                                    }
                                });

                        AlertDialog dialog = builder.create();
                        dialog.show();




                    /*Fragment fragment = new NotifictaionsListFragment();

                    if (fragment != null) {
                        FragmentManager fragmentManager = getSupportFragmentManager();
                        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                        fragmentTransaction.replace(R.id.container, fragment);
                        fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                        fragmentTransaction.commit();
                    }*/
                    } else if (data.getString(Constants.NOTIFICATION_TAG).equalsIgnoreCase(Constants.NOTIFICATION_ADD_CONNECTION)) {


                        try {
                            connectionNotificationStatus = data.getString("status");
                            JSONObject values = new JSONObject(data.getString("values"));
                            Log.e("values", "" + data.get("values"));
                            Log.e("connectionstatus", "" + connectionNotificationStatus);

                            connectionUserId = values.getString("user_id");
                            connectionConnectionID = values.getString("connection_id");
                            connectionStatus = values.getString("status");
                        } catch (JSONException e) {
                            e.printStackTrace();

                        }

                        if (connectionNotificationStatus.compareTo("1") == 0) {
                            utilitiesClass.alertDialogSingleButton("You have already performed the action.");
                        } else {
                            AlertDialog.Builder builder = new AlertDialog.Builder(HomeActivity.this);
                            builder.setTitle("Connection Request");
                            builder.setMessage("Do you want to connect with this user?")
                                    .setCancelable(false)

                                    .setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                                        @Override
                                        public void onClick(DialogInterface dialog, int arg1) {
                                            //dialog.cancel();
                                            if (networkConnectivity.isOnline()) {
                                                showProgressDialog();
                                                Async a = new Async(HomeActivity.this, (AsyncTaskCompleteListener<String>) HomeActivity.this, Constants.ACCEPT_CONNECTION_USER_TAG, Constants.ACCEPT_CONNECTION_USER_URL + "?user_id=" + connectionUserId + "&connection_id=" + connectionConnectionID + "&status=1", Constants.HTTP_GET, "Home Activity");
                                                a.execute();
                                                dialog.dismiss();
                                            } else {
                                                utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                            }

                                        }
                                    })
                                    .setNegativeButton("No", new DialogInterface.OnClickListener() {

                                        @Override
                                        public void onClick(DialogInterface dialog, int arg1) {
                                            if (networkConnectivity.isOnline()) {
                                                showProgressDialog();
                                                Async a = new Async(HomeActivity.this, (AsyncTaskCompleteListener<String>) HomeActivity.this, Constants.DISCONNECT_USER_TAG, Constants.DISCONNECT_USER_URL + "?user_id=" + connectionUserId + "&connection_id=" + connectionConnectionID, Constants.HTTP_GET, "Home Activity");
                                                a.execute();
                                                dialog.dismiss();
                                            } else {
                                                dialog.dismiss();
                                                utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                            }
                                        }
                                    });

                            AlertDialog dialog = builder.create();
                            dialog.show();

                        }


                    /*Fragment fragment = new NotifictaionsListFragment();

                    if (fragment != null) {
                        FragmentManager fragmentManager = getSupportFragmentManager();
                        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                        fragmentTransaction.replace(R.id.container, fragment);
                        fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                        fragmentTransaction.commit();
                    }*/

                    } else if (data.getString(Constants.NOTIFICATION_TAG).equalsIgnoreCase(Constants.NOTIFICATION_REPORT_ABUSE_FORUM_MEMBER)) {
                        Fragment fragment = new ForumDetailsFragment();
                        Bundle bundle = new Bundle();

                        try {
                            Log.e("values", "" + data.get("values"));
                            JSONObject values = new JSONObject(data.getString("values"));
                            // Log.e("values", data.getString("values"));
                            bundle.putString("forum_id", values.getString("forum_id"));
                            bundle.putString("TITLE", values.getString("forum_name"));
                            if (values.getBoolean("own_forum")) {
                                bundle.putString("COMMING_FROM", "MyForums");
                            } else {
                                bundle.putString("COMMING_FROM", "Common");
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                        fragment.setArguments(bundle);
                        replaceFragment(fragment);
                    } else if (data.getString(Constants.NOTIFICATION_TAG).equalsIgnoreCase(Constants.NOTIFICATION_REPORT_ABUSE_FORUM)) {
                        Fragment fragment = new ForumDetailsFragment();
                        Bundle bundle = new Bundle();

                        try {
                            Log.e("values", "" + data.get("values"));
                            JSONObject values = new JSONObject(data.getString("values"));
                            // Log.e("values", data.getString("values"));
                            bundle.putString("forum_id", values.getString("forum_id"));
                            bundle.putString("TITLE", values.getString("forum_name"));
                            bundle.putString("COMMING_FROM", "MyForums");
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                        fragment.setArguments(bundle);

                        replaceFragment(fragment);
                    } else {
                        if (savedInstanceState == null) {
                            mDrawerList.setItemChecked(1, true);
                            Fragment fragment = new NotifictaionsListFragment();
                            if (fragment != null) {
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);
                                FragmentManager fragmentManager = getSupportFragmentManager();
                                FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                                fragmentTransaction.replace(R.id.container, fragment);
                                //fragmentTransaction.addToBackStack(HomeFragment.class.getName());
                                fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                fragmentTransaction.commit();
                            }
                        }
                    }
                } else {
                    Fragment fragment = new ChatTabFragment();
                    if (fragment != null) {
                        FragmentManager fragmentManager = getSupportFragmentManager();
                        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                        fragmentTransaction.replace(R.id.container, fragment);
                        fragmentTransaction.commit();
                    }
                }

            } else {
                if (savedInstanceState == null) {
                    mDrawerList.setItemChecked(1, true);
                    Fragment fragment = new HomeFragment();
                    if (fragment != null) {
                        FragmentManager fragmentManager = getSupportFragmentManager();
                        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                        fragmentTransaction.replace(R.id.container, fragment);
                        fragmentTransaction.commit();
                    }
                }
            }

            setBadgeData();

            // ADD TIMER AFTER EVERY 5 SECOND FOR THE NOTIFICATION TO BE UPDATED


            /*notificationThread = new Thread(new Runnable() {
                @Override
                public void run() {
                    while (true) {
                        try {
                            Thread.sleep(160000);// 5 seconds lag
                            mHandler.post(new Runnable() {

                                @Override
                                public void run() {
                                    Log.e("XXX", "TIMERHIT");
                                    setBadgeData();
                                }
                            });
                        } catch (Exception e) {
                            // TODO: handle exception
                        }
                    }
                }
            });
            notificationThread.start();*/
            new Thread(new Runnable() {
                @Override
                public void run() {
                    // TODO Auto-generated method stub
                    while (true) {
                        try {
                            Thread.sleep(160000);// 5 seconds lag
                            mHandler.post(new Runnable() {

                                @Override
                                public void run() {
                                    Log.e("XXX", "TIMERHIT");
                                    setBadgeData();
                                }
                            });
                        } catch (Exception e) {
                            // TODO: handle exception
                        }
                    }
                }
            }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void setBadgeData() {

        if (networkConnectivity.isOnline()) {

            /*Async a = new Async(HomeActivity.this, (AsyncTaskCompleteListener<String>) HomeActivity.this, Constants.USER_NOTIFICATION_COUNT_TAG, Constants.USER_NOTIFICATION_COUNT_URL + "?user_id=" + prefManager.getString(Constants.USER_ID), Constants.HTTP_GET, "Home Activity");
            a.execute();*/
            checkNotificationBadgeCount();

        } else {
            utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }

    }

    private void checkNotificationBadgeCount() {
        new AsyncTask<Void, Void, String>() {

            @Override
            protected String doInBackground(Void... params) {
                HttpURLConnection urlConnection;
                String result = "";
                try {

                    String uri = Constants.USER_NOTIFICATION_COUNT_URL + "?user_id=" + prefManager.getString(Constants.USER_ID);
                    URL url = new URL(Constants.APP_BASE_URL + uri);
                    CrowdBootstrapLogger.logInfo("url: " + url.toString());


                    urlConnection = (HttpURLConnection) url.openConnection();

                    urlConnection.setDoOutput(true);
                    urlConnection.setRequestProperty("Content-Type", "application/json");
                    urlConnection.setRequestProperty("Accept", "application/json");

                    urlConnection.setRequestMethod(Constants.HTTP_GET_REQUEST);
                    urlConnection.connect();


                    if (urlConnection.getResponseCode() == HttpURLConnection.HTTP_OK) {

                        //Read
                        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), "UTF-8"));

                        String line = null;
                        StringBuilder sb = new StringBuilder();

                        while ((line = bufferedReader.readLine()) != null) {
                            sb.append(line);
                        }

                        bufferedReader.close();
                        result = sb.toString();
                    } else {
                        CrowdBootstrapLogger.logInfo("Status code: " + urlConnection.getResponseCode());

                    }

                } catch (IOException e) {
                    e.printStackTrace();
                    return result;
                } catch (Exception e) {
                    return result;
                }
                return result;
            }

            @Override
            protected void onPostExecute(String s) {
                super.onPostExecute(s);
                try {
                    if (!s.isEmpty()){
                        final JSONObject jsonObject = new JSONObject(s);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            badgeCount = jsonObject.optInt("count");

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            badgeCount = 0;
                        }

                        //For Testing purpose
//                        badgeCount = 7;
                        setMenuBagde();
                    }

                    //////////////////////
                } catch (Exception e) {

                }
            }
        }.execute();
    }


    private void addDrawerItemsForEntrepreneur() {

        try {
            contributorNavigationArray = new ArrayList<NavDrawerItem>();
            contributorNavigationArray.add(new NavDrawerItem(getString(R.string.home), R.drawable.ic_home));
            contributorNavigationArray.add(new NavDrawerItem(getString(R.string.myProfile), R.drawable.ic_profile));
            contributorNavigationArray.add(new NavDrawerItem(getString(R.string.startup), R.drawable.ic_startups));
            contributorNavigationArray.add(new NavDrawerItem(getString(R.string.contractor), R.drawable.ic_contractor));
            contributorNavigationArray.add(new NavDrawerItem(getString(R.string.organization), R.drawable.ic_contractor));

            contributorNavigationArray.add(new NavDrawerItem(getString(R.string.messaging), R.drawable.ic_messaging));
            contributorNavigationArray.add(new NavDrawerItem(getString(R.string.resources), R.drawable.ic_resources));
            contributorNavigationArray.add(new NavDrawerItem(getString(R.string.events), R.drawable.ic_event));
            contributorNavigationArray.add(new NavDrawerItem(getString(R.string.opportunities), R.drawable.ic_opportunity));
            contributorNavigationArray.add(new NavDrawerItem(getString(R.string.shoppingCart), R.drawable.ic_shoppingcart));
            contributorNavigationArray.add(new NavDrawerItem(getString(R.string.logout), R.drawable.ic_logout));


            contributiorChildNavigationArrayStartup = new ArrayList<NavDrawerItem>();
            contributiorChildNavigationArrayStartup.add(new NavDrawerItem(getString(R.string.roadmapvideo), R.drawable.roadmapvideoimg));
            contributiorChildNavigationArrayStartup.add(new NavDrawerItem(getString(R.string.addstartup), R.drawable.ic_addstartup));
            contributiorChildNavigationArrayStartup.add(new NavDrawerItem(getString(R.string.startupApplication), R.drawable.startupapplicationimg));
            contributiorChildNavigationArrayStartup.add(new NavDrawerItem(getString(R.string.startupProfile), R.drawable.startupprofileimg));
            contributiorChildNavigationArrayStartup.add(new NavDrawerItem(getString(R.string.currentStartup), R.drawable.ic_cuurent_startups));
            contributiorChildNavigationArrayStartup.add(new NavDrawerItem(getString(R.string.funds), R.drawable.fundsimg));
            contributiorChildNavigationArrayStartup.add(new NavDrawerItem(getString(R.string.campaighns), R.drawable.ic_campaigns));
            contributiorChildNavigationArrayStartup.add(new NavDrawerItem(getString(R.string.searchCampaign), R.drawable.searchcampaignimg));
            contributiorChildNavigationArrayStartup.add(new NavDrawerItem(getString(R.string.manageWorkorder), R.drawable.manageworkorderimg));

            contributorNavigationProfileArray = new ArrayList<NavDrawerItem>();
            contributorNavigationProfileArray.add(new NavDrawerItem(getString(R.string.entrepreneur_video), R.drawable.entrepreneurvideoimg));
            contributorNavigationProfileArray.add(new NavDrawerItem(getString(R.string.profile), R.drawable.ic_userprofile));
            contributorNavigationProfileArray.add(new NavDrawerItem(getString(R.string.connections), R.drawable.ic_userprofile));
            contributorNavigationProfileArray.add(new NavDrawerItem(getString(R.string.suggest_keywords), R.drawable.ic_userprofile));
            contributorNavigationProfileArray.add(new NavDrawerItem(getString(R.string.settings), R.drawable.ic_setting));

            contributorNavigationOpportunities = new ArrayList<NavDrawerItem>();
            contributorNavigationOpportunities.add(new NavDrawerItem(getString(R.string.beta_testers), R.drawable.dummy_betatesterimg));
            contributorNavigationOpportunities.add(new NavDrawerItem(getString(R.string.board_members), R.drawable.dummy_boardmemberimg));
            contributorNavigationOpportunities.add(new NavDrawerItem(getString(R.string.communal_assets), R.drawable.dummy_communalassetimg));
            contributorNavigationOpportunities.add(new NavDrawerItem(getString(R.string.consulting), R.drawable.dummy_ic_consulting));
            contributorNavigationOpportunities.add(new NavDrawerItem(getString(R.string.early_adopters), R.drawable.dummy_ic_earlyadopter));
            contributorNavigationOpportunities.add(new NavDrawerItem(getString(R.string.endorsers), R.drawable.dummy_ic_betatester));
            contributorNavigationOpportunities.add(new NavDrawerItem(getString(R.string.focus_groups), R.drawable.dummy_ic_focusgroup));
            contributorNavigationOpportunities.add(new NavDrawerItem(getString(R.string.jobs), R.drawable.ic_jobs));
            contributorNavigationOpportunities.add(new NavDrawerItem(getString(R.string.recruiter), R.drawable.recruiterimg));


            contributorNavigationEvents = new ArrayList<NavDrawerItem>();
            contributorNavigationEvents.add(new NavDrawerItem(getString(R.string.conferences), R.drawable.dummy_ic_conference));
            contributorNavigationEvents.add(new NavDrawerItem(getString(R.string.demo_days), R.drawable.dummy_ic_demo_days));
            contributorNavigationEvents.add(new NavDrawerItem(getString(R.string.meet_ups), R.drawable.dummy_ic_meetups));
            contributorNavigationEvents.add(new NavDrawerItem(getString(R.string.webinars), R.drawable.dummy_ic_webinars));

            contributorNavigationResource = new ArrayList<NavDrawerItem>();
            contributorNavigationResource.add(new NavDrawerItem(getString(R.string.hardware), R.drawable.dummy_ic_hardware));
            contributorNavigationResource.add(new NavDrawerItem(getString(R.string.software), R.drawable.dummy_ic_software));
            contributorNavigationResource.add(new NavDrawerItem(getString(R.string.services), R.drawable.dummy_ic_services));
            contributorNavigationResource.add(new NavDrawerItem(getString(R.string.audioVideo), R.drawable.dummy_ic_play));
            contributorNavigationResource.add(new NavDrawerItem(getString(R.string.information), R.drawable.dummy_ic_info));
            contributorNavigationResource.add(new NavDrawerItem(getString(R.string.productivity), R.drawable.dummy_ic_productivity));

            contributiorChildNavigationArrayContractor = new ArrayList<NavDrawerItem>();
            contributiorChildNavigationArrayContractor.add(new NavDrawerItem(getString(R.string.contractorVideo), R.drawable.contractorvideoimg));
            contributiorChildNavigationArrayContractor.add(new NavDrawerItem(getString(R.string.searchcontributor), R.drawable.ic_search_contracotrs));
            contributiorChildNavigationArrayContractor.add(new NavDrawerItem(getString(R.string.publicProfile), R.drawable.ic_public_profile));
            contributiorChildNavigationArrayContractor.add(new NavDrawerItem(getString(R.string.workOrders), R.drawable.ic_workorders));

            contributiorChildNavigationArrayMessages = new ArrayList<NavDrawerItem>();
            contributiorChildNavigationArrayMessages.add(new NavDrawerItem(getString(R.string.archivedForums), R.drawable.ic_archived_forum));
            contributiorChildNavigationArrayMessages.add(new NavDrawerItem(getString(R.string.archivedMessages), R.drawable.ic_archived_notifications));
            contributiorChildNavigationArrayMessages.add(new NavDrawerItem(getString(R.string.notification), R.drawable.notificationsimg));
            contributiorChildNavigationArrayMessages.add(new NavDrawerItem(getString(R.string.chat), R.drawable.ic_chats));
            contributiorChildNavigationArrayMessages.add(new NavDrawerItem(getString(R.string.forums), R.drawable.ic_forum));
            contributiorChildNavigationArrayMessages.add(new NavDrawerItem(getString(R.string.groups), R.drawable.dummy_groupsimg));
            contributiorChildNavigationArrayMessages.add(new NavDrawerItem(getString(R.string.messages), R.drawable.ic_messages));
            contributiorChildNavigationArrayMessages.add(new NavDrawerItem(getString(R.string.notes), R.drawable.ic_note));

            contributorOrganizations = new ArrayList<>();
            contributorOrganizations.add(new NavDrawerItem(getString(R.string.organizationvideo), R.drawable.ic_archived_forum));
            contributorOrganizations.add(new NavDrawerItem(getString(R.string.organizationsearch), R.drawable.ic_archived_forum));


            contributiorChildArray.put(0, new ArrayList<NavDrawerItem>());
            contributiorChildArray.put(1, contributorNavigationProfileArray);
            contributiorChildArray.put(2, contributiorChildNavigationArrayStartup);
            contributiorChildArray.put(3, contributiorChildNavigationArrayContractor);
            contributiorChildArray.put(4, contributorOrganizations);
            contributiorChildArray.put(5, contributiorChildNavigationArrayMessages);
            contributiorChildArray.put(6, contributorNavigationResource);
            contributiorChildArray.put(7, contributorNavigationEvents);
            contributiorChildArray.put(8, contributorNavigationOpportunities);
            contributiorChildArray.put(9, new ArrayList<NavDrawerItem>());
            contributiorChildArray.put(10, new ArrayList<NavDrawerItem>());

            //=-============Created the Header for the Side Navigation Drawer====================================
            inflater = getLayoutInflater();
            ViewGroup header = (ViewGroup) inflater.inflate(R.layout.navigation_headerlayout, mDrawerList, false);
            referTextView = (TextView) header.findViewById(R.id.referenceName);


            referTextView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    Intent i = new Intent(Intent.ACTION_SEND);
                    i.setType("message/rfc822");
                    i.putExtra(Intent.EXTRA_SUBJECT, "Crowd Bootstrap Invitation");
                    i.putExtra(Intent.EXTRA_TEXT, "\n" +
                            "[Name]:\n" +
                            "\n" +
                            "Crowd Bootstrap helps entrepreneurs accelerate their journey from a startup idea to initial revenues. It is a free App that enables you to benefit as an entrepreneur or help as an expert.\n" +
                            "\n" +
                            "Please click the following link to sign-up and help an entrepreneur realize their dream.\n" +
                            "\n" +
                            "link: http://crowdbootstrap.com/ \n" +
                            "\n" +
                            "Regards,\n" +
                            "\n" +
                            "The Crowd Bootstrap Team");
                    try {
                        startActivity(Intent.createChooser(i, "Send mail..."));
                    } catch (android.content.ActivityNotFoundException ex) {
                        Toast.makeText(HomeActivity.this, "There are no email clients installed.", Toast.LENGTH_SHORT).show();

                    }

                }
            });
            userName = (TextView) header.findViewById(R.id.userName);
            userName.setText(prefManager.getString(Constants.USER_FIRST_NAME) + " " + prefManager.getString(Constants.USER_LAST_NAME));
            //userName.setText("Mark Lawrence");
            mUserImage = (CircleImageView) header.findViewById(R.id.profileimage);

            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + prefManager.getString(Constants.USER_PROFILE_IMAGE_URL), mUserImage, options);
            mDrawerList.addHeaderView(header, null, false);

            mDrawerList.setAdapter(new ExpandableAdapter(HomeActivity.this, contributorNavigationArray, contributiorChildArray));

            mDrawerList.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {
                @Override
                public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) {
                    ArrayList<NavDrawerItem> list = contributiorChildArray.get(groupPosition);

                    if (list.size() > 0) {
                        if (groupPosition == 1) {
                            //                        mDrawerList.collapseGroup(lastExpandedGroupPosition);
                            lastExpandedGroupPosition = 1;
                            mDrawerList.setItemChecked(2, true);
                        } else if (groupPosition == 2) {
                            lastExpandedGroupPositionfirst = 2;
                            mDrawerList.setItemChecked(3, true);
                        } else if (groupPosition == 3) {
                            lastExpandedGroupPositionsecond = 3;
                            mDrawerList.setItemChecked(4, true);
                        } else if (groupPosition == 4) {
                            lastExpandedGroupPositionthird = 4;
                            mDrawerList.setItemChecked(5, true);
                        } else if (groupPosition == 5) {
                            lastExpandedGroupPositionfourth = 5;
                            mDrawerList.setItemChecked(6, true);
                        } else if (groupPosition == 6) {
                            lastExpandedGroupPositionfifth = 6;
                            mDrawerList.setItemChecked(7, true);
                        } else if (groupPosition == 7) {
                            lastExpandedGroupPositionsixth = 7;
                            mDrawerList.setItemChecked(8, true);
                        } else if (groupPosition == 8) {
                            lastExpandedGroupPositionseventh = 8;
                            mDrawerList.setItemChecked(9, true);
                        }
                    } else {

                        Fragment fragment = null;
                        Bundle bundle = null;
                        switch (groupPosition) {
                            case 0:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);
                                mDrawerList.setItemChecked(1, true);
                                toolbarTitle.setText("Home");
                                fragment = new HomeFragment();

                                break;
                            case 1:

                                break;
                            case 2:

                                break;

                            case 3:

                                break;

                            case 4:

                                break;
                            case 5:

                                break;
                            case 6:

                                break;
                            case 7:
                                break;
                            case 8:
                                break;
                            case 9:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);
                                mDrawerList.setItemChecked(10, true);
                                toolbarTitle.setText("Shopping Cart");
                                fragment = new ChoosePaymentGatewayFragment();
                                break;
                            case 10:
                                showLogoutAlert();
                                break;

                            default:
                                break;
                        }
                        if (fragment != null) {
                            //replaceFragment(fragment);
                            FragmentManager fragmentManager = getSupportFragmentManager();
                            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.replace(R.id.container, fragment);
                            //    fragmentTransaction.addToBackStack(HomeFragment.class.getName());
                            fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                            fragmentTransaction.commit();
                        }
                        mDrawerLayout.closeDrawer(mDrawerList);
                    }
                    return false;
                }
            });
            mDrawerList.setOnGroupExpandListener(new ExpandableListView.OnGroupExpandListener() {
                @Override
                public void onGroupExpand(int groupPosition) {

                    if (lastExpandedGroupPosition != -1 && groupPosition != lastExpandedGroupPosition) {
                        mDrawerList.collapseGroup(lastExpandedGroupPosition);
                        lastExpandedGroupPosition = groupPosition;
                    }
                    if (lastExpandedGroupPositionfirst != -1 && groupPosition != lastExpandedGroupPositionfirst) {
                        mDrawerList.collapseGroup(lastExpandedGroupPositionfirst);
                        lastExpandedGroupPositionfirst = groupPosition;
                    }
                    if (lastExpandedGroupPositionsecond != -1 && groupPosition != lastExpandedGroupPositionsecond) {
                        mDrawerList.collapseGroup(lastExpandedGroupPositionsecond);
                        lastExpandedGroupPositionsecond = groupPosition;
                    }
                    if (lastExpandedGroupPositionthird != -1 && groupPosition != lastExpandedGroupPositionthird) {
                        mDrawerList.collapseGroup(lastExpandedGroupPositionthird);
                        lastExpandedGroupPositionthird = groupPosition;
                    }
                    if (lastExpandedGroupPositionfourth != -1 && groupPosition != lastExpandedGroupPositionfourth) {
                        mDrawerList.collapseGroup(lastExpandedGroupPositionfourth);
                        lastExpandedGroupPositionfourth = groupPosition;
                    }
                    if (lastExpandedGroupPositionfifth != -1 && groupPosition != lastExpandedGroupPositionfifth) {
                        mDrawerList.collapseGroup(lastExpandedGroupPositionfifth);
                        lastExpandedGroupPositionfifth = groupPosition;
                    }
                    if (lastExpandedGroupPositionsixth != -1 && groupPosition != lastExpandedGroupPositionsixth) {
                        mDrawerList.collapseGroup(lastExpandedGroupPositionsixth);
                        lastExpandedGroupPositionsixth = groupPosition;
                    }
                    if (lastExpandedGroupPositionseventh != -1 && groupPosition != lastExpandedGroupPositionseventh) {
                        mDrawerList.collapseGroup(lastExpandedGroupPositionseventh);
                        lastExpandedGroupPositionseventh = groupPosition;
                    }


                }
            });


            mDrawerList.setOnChildClickListener(new ExpandableListView.OnChildClickListener() {


                @Override
                public boolean onChildClick(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {
                    ArrayList<NavDrawerItem> list = contributiorChildArray.get(groupPosition);
                    FragmentManager fragmentManager = getSupportFragmentManager();

                    int backStackEntryCount;
                    //toolbarTitle.setText(list.get(childPosition - 1).getName());
                    Fragment fragment = null;
                    Bundle bundle = null;
                    if (groupPosition == 1) {

                        switch (childPosition) {

                            case 0:
                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(3, true);
                                    toolbarTitle.setText("Entrepreneur Video");
                                    fragment = new EntrepreneurVideoFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }

                                break;
                            case 1:


                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);
                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(4, true);
                                    toolbarTitle.setText("My Profile");
                                    fragment = new ProfileFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                            case 2:

                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(5, true);
                                    toolbarTitle.setText("Connections");
                                    fragment = new ConnectionsFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }

                                break;

                            case 3:

                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(6, true);
                                    toolbarTitle.setText("Suggest Keywords");
                                    fragment = new SuggestKeywordsFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                            case 4:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(7, true);
                                    toolbarTitle.setText("Settings");
                                    fragment = new SettingsFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                        }
                    } else if (groupPosition == 2) {
                        switch (childPosition) {
                            case 0:
                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(4, true);
                                    toolbarTitle.setText("Roadmap Video");
                                    fragment = new RoadmapVideoFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                            case 1:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);
                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {

                                    mDrawerList.setItemChecked(5, true);
                                    fragment = new AddStartupFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                            case 2:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(6, true);
                                    toolbarTitle.setText("Upload Application");
                                    fragment = new StartupApplicatioFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 3:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(7, true);
                                    toolbarTitle.setText("Upload Profile");
                                    fragment = new StartupProfileFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                            case 4:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);
                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();
                                if (mDrawerList.getCheckedItemPosition() == 8) {

                                    mDrawerLayout.closeDrawer(mDrawerList);

                                    if (backStackEntryCount == 0) {

                                    } else {
                                        onBackPressed();
                                    }
                                    return false;
                                } else {

                                    if (backStackEntryCount == 0) {


                                        mDrawerList.setItemChecked(8, true);

                                        fragment = new CurrentStartUpFragment();
                                        bundle = new Bundle();
                                        bundle.putString("COMMING_FROM", "CURRENT_STARTUPS");


                                        fragment.setArguments(bundle);
                                    } else {
                                        Log.e("XXX", "INTO THE STACK");
//                                        for(int i = 0; i <= backStackEntryCount; ++i) {
//                                            fragmentManager.popBackStackImmediate();
//                                        }
                                        mDrawerLayout.closeDrawer(mDrawerList);
                                        fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
//                                        onBackPressed();
                                        Log.e("XXX", "BACKSTACKVALUE" + String.valueOf(backStackEntryCount));

//                                        mDrawerList.setItemChecked(8, true);
//
//                                        fragment = new CurrentStartUpFragment();
//                                        bundle = new Bundle();
//                                        bundle.putString("COMMING_FROM", "CURRENT_STARTUPS");
//                                        fragment.setArguments(bundle);

                                        return false;

                                    }


                                }
                                break;

                            case 5:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);


                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(9, true);
                                    toolbarTitle.setText("Funds");
                                    fragment = new FundsFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 6:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);


                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(10, true);
                                    toolbarTitle.setText("Campaigns");
                                    Bundle bundle1 = new Bundle();
                                    bundle1.putString("home", "");
                                    fragment = new CampaignsTabFragment();
                                    fragment.setArguments(bundle1);
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 7:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);


                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(11, true);
                                    toolbarTitle.setText("Search Campaigns");
                                    fragment = new SearchCampaignFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 8:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(12, true);
                                    toolbarTitle.setText("Assign Work Orders");
                                    fragment = new ManageWorkOrdersFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                        }
                    } else if (groupPosition == 3) {
                        switch (childPosition) {

                            case 0:

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(5, true);
                                    toolbarTitle.setText("Contractor Video");
                                    fragment = new ContractorVideoFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }

                                break;

                            case 1:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(6, true);
                                    toolbarTitle.setText("Search Contractor");
                                    fragment = new SearchContractorsFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                            case 2:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(7, true);
                                    fragment = new ViewContractorPublicProfileFragment();
                                    bundle = new Bundle();
                                    bundle.putString("COMMING_FROM", "home");
                                    fragment.setArguments(bundle);
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                            case 3:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(8, true);
                                    fragment = new CurrentStartUpFragment();
                                    bundle = new Bundle();
                                    bundle.putString("COMMING_FROM", "WORK_ORDERS");
                                    fragment.setArguments(bundle);
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                        }
                    } else if (groupPosition == 4) {
                        switch (childPosition) {
                            case 0:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(6, true);
                                    toolbarTitle.setText("Organization Video");
                                    fragment = new OrgnizationVideoFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                            case 1:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(7, true);
                                    toolbarTitle.setText("Organization Search");
                                    fragment = new OrganizationSearchFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                        }

                    } else if (groupPosition == 5) {

                        switch (childPosition) {
                            case 0:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(7, true);
                                    toolbarTitle.setText("Archived Forums");
                                    fragment = new ArchivedForumsFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                            case 1:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(8, true);
                                    toolbarTitle.setText("Archived Messages");
                                    fragment = new ArchivedNotificationFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                            case 2:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(9, true);
                                    toolbarTitle.setText("Notifications");
                                    fragment = new NotifictaionsListFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                            case 3:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(10, true);
                                    toolbarTitle.setText("Chat");
                                    fragment = new ChatTabFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 4:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(11, true);
                                    toolbarTitle.setText("Forums");
                                    fragment = new ForumsTabFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                            case 5:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(12, true);
                                    toolbarTitle.setText(getString(R.string.groups));
                                    fragment = new GroupsFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }

                                break;

                            case 6:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(13, true);
                                    toolbarTitle.setText(R.string.messages);
                                    fragment = new MessagesFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                            case 7:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(14, true);
                                    toolbarTitle.setText("Notes");
                                    fragment = new NotesFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                        }
                    } else if (groupPosition == 6) {
                        switch (childPosition) {
                            case 0:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(8, true);
                                    toolbarTitle.setText(getString(R.string.hardware));
                                    fragment = new HardwarFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 1:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(9, true);
                                    toolbarTitle.setText(getString(R.string.software));
                                    fragment = new SoftwareFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 2:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(10, true);
                                    toolbarTitle.setText(getString(R.string.services));
                                    fragment = new ServicesFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 3:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(11, true);
                                    toolbarTitle.setText(getString(R.string.audioVideo));
                                    fragment = new AudioVideoFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 4:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);


                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(12, true);
                                    toolbarTitle.setText(getString(R.string.information));
                                    fragment = new InformationFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                            case 5:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);


                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(13, true);
                                    toolbarTitle.setText(getString(R.string.productivity));
                                    fragment = new ProductivityFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                        }
                    } else if (groupPosition == 7) {

                        switch (childPosition) {
                            case 0:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(9, true);
                                    toolbarTitle.setText(getString(R.string.conferences));
                                    fragment = new ConferencesFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 1:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);


                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(10, true);
                                    toolbarTitle.setText(getString(R.string.demo_days));

                                    fragment = new DemoDaysFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 2:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(11, true);
                                    toolbarTitle.setText(getString(R.string.meet_ups));
                                    fragment = new MeetUpFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 3:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);


                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(12, true);
                                    toolbarTitle.setText(getString(R.string.webinars));
                                    fragment = new WebinarFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                        }
                    } else if (groupPosition == 8) {
                        switch (childPosition) {
                            case 0:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);


                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(10, true);
                                    toolbarTitle.setText(getString(R.string.beta_testers));
                                    fragment = new BetaTestersFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 1:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);


                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(11, true);
                                    toolbarTitle.setText(getString(R.string.board_members));
                                    fragment = new BoardMembersFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 2:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(12, true);
                                    toolbarTitle.setText(getString(R.string.communal_assets));
                                    fragment = new CommunalAssetsFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 3:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);


                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(13, true);
                                    toolbarTitle.setText(getString(R.string.consulting));
                                    fragment = new ConsultingFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 4:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(14, true);
                                    toolbarTitle.setText(getString(R.string.early_adopters));
                                    fragment = new EarlyAdatorsFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 5:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(15, true);
                                    toolbarTitle.setText(getString(R.string.endorsers));
                                    fragment = new EndorsersFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 6:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(16, true);
                                    toolbarTitle.setText(getString(R.string.focus_groups));
                                    fragment = new FocusGroupsFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 7:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(17, true);
                                    toolbarTitle.setText(getString(R.string.jobs));
                                    fragment = new JobsFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;
                            case 8:
                                setRequestedOrientation(SCREEN_ORIENTATION_PORTRAIT);

                                backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();

                                if (backStackEntryCount == 0) {
                                    mDrawerList.setItemChecked(18, true);
                                    toolbarTitle.setText(getString(R.string.recruiter));
                                    fragment = new RecruitersFragment();
                                } else {
                                    mDrawerLayout.closeDrawer(mDrawerList);
                                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                                    return false;
                                }
                                break;

                        }
                    }

                    mDrawerLayout.closeDrawer(mDrawerList);
                    //replaceFragment(fragment);
                    /*if (fragment != null) {
                        *//*if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                            fragment.setEnterTransition(new Slide(Gravity.RIGHT));
                            fragment.setExitTransition(new Slide(Gravity.LEFT));
                        }*/

                    FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                    fragmentTransaction.replace(R.id.container, fragment);
                    //fragmentTransaction.addToBackStack(HomeFragment.class.getName());
                    fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);


                    fragmentTransaction.commit();
                    //}

                    return false;
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    FragmentManager manager;

    public void replaceFragment(Fragment fragment) {

        try {
            String backStateName = fragment.getClass().getName();
            String fragmentTag = backStateName;
            ///mCurrentTab = backStateName;
            manager = getSupportFragmentManager();
            boolean fragmentPopped = manager.popBackStackImmediate(backStateName, 0);

            if (!fragmentPopped && manager.findFragmentByTag(fragmentTag) == null) { //fragment not in back stack, create it.
                FragmentTransaction ft = manager.beginTransaction();
                ft.replace(R.id.container, fragment, fragmentTag);
                ft.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_CLOSE);
                ft.addToBackStack(backStateName);
                ft.commit();

            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public void setOnActivityResultListener(onActivityResultListener listner) {
        this.activytresultListener = listner;
    }

    public static Fragment currentFragment;

    public void setCurrentFragment(Fragment currentFragment) {
        this.currentFragment = currentFragment;
    }

    public Fragment getCurrentFragment() {
        return currentFragment;
    }

    public static void setBadgeCount(Context context, LayerDrawable icon, String count) {

        BadgeDrawable badge;

// Reuse drawable if possible
        Drawable reuse = icon.findDrawableByLayerId(R.drawable.ic_notification);
        if (reuse != null && reuse instanceof BadgeDrawable) {
            badge = (BadgeDrawable) reuse;
        } else {
            badge = new BadgeDrawable(context);
        }

        badge.setCount(count);
        icon.mutate();
        icon.setDrawableByLayerId(R.drawable.ic_notification, badge);
    }


    private void setupDrawer() {
        try {
            toolbar = (Toolbar) findViewById(R.id.toolbar);

            setSupportActionBar(toolbar);
            getSupportActionBar().setDisplayShowTitleEnabled(false);

//            toolbar.setOnMenuItemClickListener(new Toolbar.OnMenuItemClickListener() {
//
//                @Override
//                public boolean onMenuItemClick(MenuItem item) {
//                    Fragment fragment = new NotifictaionsListFragment();
//
//                    if (fragment != null) {
//                        replaceFragment(fragment);
//                        /*FragmentManager fragmentManager = getSupportFragmentManager();
//                        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
//                        fragmentTransaction.replace(R.id.container, fragment);
//                        //fragmentTransaction.addToBackStack(HomeFragment.class.getName());
//                        fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
//                        fragmentTransaction.commit();*/
//
//                    }
//                    return true;
//                }
//            });
//            toolbar.inflateMenu(R.menu.menu);


            mDrawerToggle = new ActionBarDrawerToggle(HomeActivity.this, mDrawerLayout, toolbar, R.string.drawer_open, R.string.drawer_close) {

                /** Called when a drawer has settled in a completely open state. */
                public void onDrawerOpened(View drawerView) {
                    super.onDrawerOpened(drawerView);
                    InputMethodManager inputMethodManager = (InputMethodManager)
                            getSystemService(Context.INPUT_METHOD_SERVICE);
                    inputMethodManager.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(), 0);

                    //title.setText(getString(R.string.app_name));
                    invalidateOptionsMenu(); // creates call to onPrepareOptionsMenu()

                }

                /** Called when a drawer has settled in a completely closed state. */
                public void onDrawerClosed(View view) {
                    super.onDrawerClosed(view);
                    InputMethodManager inputMethodManager = (InputMethodManager)
                            getSystemService(Context.INPUT_METHOD_SERVICE);
                    inputMethodManager.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(), 0);

                    invalidateOptionsMenu(); // creates call to onPrepareOptionsMenu()
                }
            };


            mDrawerToggle.setDrawerIndicatorEnabled(true);
        /*mDrawerToggle.setHomeAsUpIndicator(R.drawable.ic_drawer);*/
            mDrawerLayout.setDrawerListener(mDrawerToggle);
            mDrawerToggle.syncState();


        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @Override
    public void setActionBarTitle(String title) {
        toolbarTitle.setText(title);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {

            /*case R.id.userimage:
                Toast.makeText(HomeActivity.this, "User Image CLickd!", Toast.LENGTH_SHORT).show();
                break;*/
        }
    }

    @Override
    public void onBackPressed() {
        int backStackEntryCount = getSupportFragmentManager().getBackStackEntryCount();
        if (backStackEntryCount == 0) {
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder.setMessage("Are you sure you want to exit?")
                    .setCancelable(false)
                    .setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            finish();
                        }
                    })
                    .setNegativeButton("No", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            dialog.cancel();
                        }
                    });
            AlertDialog alert = builder.create();
            alert.show();

        } else {
            super.onBackPressed();
        }
    }

    @Override
    public void onTaskComplete(String result, String tag) {

        CrowdBootstrapLogger.logInfo(result);
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            dismissProgressDialog();
            Toast.makeText(HomeActivity.this, getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            dismissProgressDialog();
            Toast.makeText(HomeActivity.this, getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            if (tag.equalsIgnoreCase(Constants.STARTUP_TEAM_MEMBER_STATUS_HOME_SCREEN_TAG)) {
                dismissProgressDialog();
                try {
                    final JSONObject jsonObject = new JSONObject(result);
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        Toast.makeText(HomeActivity.this, jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                        Fragment fragment = new HomeFragment();

                        if (fragment != null) {
                            FragmentManager fragmentManager = getSupportFragmentManager();
                            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.replace(R.id.container, fragment);
                            fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                            fragmentTransaction.commit();
                        }
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(HomeActivity.this, jsonObject.optString("message"), Toast.LENGTH_LONG).show();
                        Fragment fragment = new HomeFragment();

                        if (fragment != null) {
                            FragmentManager fragmentManager = getSupportFragmentManager();
                            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.replace(R.id.container, fragment);
                            fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                            fragmentTransaction.commit();
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            } else if (tag.equalsIgnoreCase(Constants.USER_NOTIFICATION_COUNT_TAG)) {


                try {
                    final JSONObject jsonObject = new JSONObject(result);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        badgeCount = jsonObject.optInt("count");

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        badgeCount = 0;
                    }

                    //For Testing purpose
//                        badgeCount = 7;
                    setMenuBagde();
                    //////////////////////
                } catch (Exception e) {

                }


            } else if (tag.equalsIgnoreCase(Constants.DISCONNECT_USER_TAG)) {
                (HomeActivity.this).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    //System.out.println(jsonObject);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        Toast.makeText(HomeActivity.this, "User disconnected successfully.", Toast.LENGTH_SHORT).show();


                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(HomeActivity.this, "Could not send request. Please Try after some time.", Toast.LENGTH_SHORT).show();
                    }


                } catch (JSONException e) {
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.ACCEPT_CONNECTION_USER_TAG)) {
                (HomeActivity.this).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    //System.out.println(jsonObject);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        Toast.makeText(HomeActivity.this, "User connected successfully.", Toast.LENGTH_SHORT).show();


                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(HomeActivity.this, "Could not send request. Please Try after some time.", Toast.LENGTH_SHORT).show();
                    }


                } catch (JSONException e) {
                    e.printStackTrace();
                }
            } else {
                mListener.onTaskComplete(result, tag);
            }
        }
    }

    public void setOnBackPressedListener(AsyncTaskCompleteListener<String> listner) {
        this.mListener = listner;
    }

    ProgressDialog dialog;

    @Override
    protected void onResume() {
        super.onResume();
        setOnBackPressedListener(this);
    }

    private void unRegisterInBackground() {
        new AsyncTask<Void, Void, Void>() {
            String result = null;

            @Override
            protected void onPreExecute() {
                super.onPreExecute();

                showProgressDialog();
                /*dialog = new ProgressDialog(HomeActivity.this);
                dialog.setMessage(Html.fromHtml("<b>" + getString(R.string.please_wait) + "</b>"));
                dialog.setIndeterminate(true);
                dialog.setCancelable(false);
                dialog.show();*/
            }

            @Override
            protected void onPostExecute(Void aVoid) {
                super.onPostExecute(aVoid);
                dismissProgressDialog();

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    CrowdBootstrapLogger.logInfo(jsonObject.toString());

                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase("200")) {
                       /* if (notificationThread != null) {
                            notificationThread.interrupt();
                        }*/
                        QBChatService.getInstance().logout(new QBEntityCallback<Void>() {
                            @Override
                            public void onSuccess(Void aVoid, Bundle bundle) {
                                QBChatService.getInstance().destroy();
                                Log.d("logout", "logout");
                            }

                            @Override
                            public void onError(QBResponseException e) {
                                Log.d("error", e.toString());
                            }
                        });
                        /*QBUsers.signOut(new QBEntityCallback<Void>() {
                            @Override
                            public void onSuccess(Void aVoid, Bundle bundle) {
                                Log.d("logout", "logout");
                            }

                            @Override
                            public void onError(QBResponseException e) {
                                Log.d("error", e.toString());
                            }
                        });*/

                        /*QBPushNotifications.getSubscriptions(new QBEntityCallback<ArrayList<QBSubscription>>() {
                            @Override
                            public void onSuccess(ArrayList<QBSubscription> subscriptions, Bundle args) {

                                String deviceId = Settings.Secure.getString(getContentResolver(), Settings.Secure.ANDROID_ID);/*//*** use for tablets

                         for (QBSubscription subscription : subscriptions) {
                         if (subscription.getDevice().getId().equals(deviceId)) {
                         QBPushNotifications.deleteSubscription(subscription.getId(), new QBEntityCallback<Void>() {

                        @Override public void onSuccess(Void aVoid, Bundle bundle) {

                        }

                        @Override public void onError(QBResponseException e) {

                        }
                        });
                         break;
                         }
                         }
                         }

                         @Override public void onError(QBResponseException errors) {

                         }
                         });*/
                        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

                        notificationManager.cancelAll();
                        QbUsersHolder.getInstance().clear();
                        prefManager.clearAllPreferences();
                        startActivity(new Intent(HomeActivity.this, LoginActivity.class).setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK));
                        finish();
                    } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase("404")) {
                        utilitiesClass.alertDialogSingleButton(jsonObject.getString("message"));
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }


            @Override
            protected Void doInBackground(Void... params) {

                try {
                    JSONObject logout = new JSONObject();
                    logout.put("user_id", prefManager.getString(Constants.USER_ID));
                    logout.put("access_token", prefManager.getString(Constants.GCM_REGISTRATION_ID));
                    logout.put("device_token", prefManager.getString(Constants.DEVICE_TOKEN));
                    logout.put("device_type", "android");
                    CrowdBootstrapLogger.logInfo(logout.toString());

                    result = utilitiesClass.postJsonObject(Constants.LOGOUT_URL, logout);
                    if (result.contains("200")) {
                        GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(getBaseContext());
                        try {
                            InstanceID.getInstance(HomeActivity.this).deleteInstanceID();
                            //gcm.unregister();
                            Log.d("unregister", "unregister");
                            // Toast.makeText(HomeActivity.this, "unregister", Toast.LENGTH_LONG).show();
                        } catch (IOException e) {
                            CrowdBootstrapLogger.logInfo("Error Message: " + e.getMessage());
                        }
                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                } catch (UnknownHostException e) {
                    e.printStackTrace();
                }

                return null;
            }
        }.execute(null, null, null);
    }

    public void showLogoutAlert() {

        try {
            AlertDialog.Builder alertDialog = new AlertDialog.Builder(HomeActivity.this);
            // Setting Dialog Message
            alertDialog.setMessage("Are you sure you want to log out?");

            // On pressing Settings button
            alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                    if (networkConnectivity.isOnline()) {
                        unRegisterInBackground();
                    } else {
                        utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                }
            });

            // on pressing cancel button
            alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int which) {
                    dialog.cancel();

                }
            });

            // Showing Alert Message
            AlertDialog dialog = alertDialog.create();
            dialog.show();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        activytresultListener.onActivityResult(requestCode, resultCode, data);

        /*for (Fragment fragment : getSupportFragmentManager().getFragments()) {
            if (fragment != null) {
                if (fragment instanceof IntoStartUpFragment) {
                    fragment.onActivityResult(requestCode, resultCode, data);
                } else {
                    activytresultListener.onActivityResult(requestCode, resultCode, data);
                }
            }
        }*/
    }

    @Override
    public void onSessionCreated(boolean success) {

    }


    private int badgeCount;
    private Menu mainMenu;

    private void setMenuBagde() {
//        Log.e("XXX", "INSETMENUBAGDE");
        if (badgeCount > 0) {
            update(this, this.mainMenu.findItem(R.id.action_notification), FontAwesome.Icon.faw_bell_o, BadgeStyles.GREEN.getStyle(), badgeCount);
        } else {
            update(this, this.mainMenu.findItem(R.id.action_notification), FontAwesome.Icon.faw_bell_o, BadgeStyles.GREEN.getStyle(), null);

        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu, menu);
        this.mainMenu = menu;
        if (badgeCount > 0) {
            update(this, this.mainMenu.findItem(R.id.action_notification), FontAwesome.Icon.faw_bell_o, BadgeStyles.GREEN.getStyle(), badgeCount);
        } else {
            update(this, this.mainMenu.findItem(R.id.action_notification), FontAwesome.Icon.faw_bell_o, BadgeStyles.GREEN.getStyle(), null);

        }
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.action_notification) {

            if (badgeCount > 0) {
                update(item, badgeCount);
                Fragment fragment = new NotifictaionsListFragment();

                if (fragment != null) {
                    replaceFragment(fragment);
                        /*FragmentManager fragmentManager = getSupportFragmentManager();
                        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                        fragmentTransaction.replace(R.id.container, fragment);
                        //fragmentTransaction.addToBackStack(HomeFragment.class.getName());
                        fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                        fragmentTransaction.commit();*/

                }
            } else {


                Fragment fragment = new NotifictaionsListFragment();

                if (fragment != null) {
                    replaceFragment(fragment);
                        /*FragmentManager fragmentManager = getSupportFragmentManager();
                        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                        fragmentTransaction.replace(R.id.container, fragment);
                        //fragmentTransaction.addToBackStack(HomeFragment.class.getName());
                        fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                        fragmentTransaction.commit();*/

                }
            }
        }
        return super.onOptionsItemSelected(item);
    }

}