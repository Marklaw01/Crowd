package com.crowdbootstrap.fragments;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.adapter.KeywordTypeAdapter;
import com.crowdbootstrap.adapter.UserSuggestedKeywordsAdapter;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.loadmore_listview.LoadMoreListView;
import com.crowdbootstrap.models.GenericObject;
import com.crowdbootstrap.models.SuggestKeywords;
import com.crowdbootstrap.swipelistview_withoutscrollview.SwipeMenu;
import com.crowdbootstrap.swipelistview_withoutscrollview.SwipeMenuCreator;
import com.crowdbootstrap.swipelistview_withoutscrollview.SwipeMenuItem;
import com.crowdbootstrap.swipelistview_withoutscrollview.SwipeMenuListView;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;
import com.crowdbootstrap.utilities.UtilityList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 11/7/2016.
 */
public class SuggestKeywordsFragment extends Fragment implements AsyncTaskCompleteListener<String> {

    private EditText keywordName;
    private Spinner keywordType;
    private SwipeMenuListView keywordListCreated;
    private ArrayList<GenericObject> keywordList;
    private String keywordSelectedID, keywordSelectedName;
    private ArrayList<SuggestKeywords> keywordsSuggestedArrayList;
    private Button addKeyword;

    public SuggestKeywordsFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        ((HomeActivity) getActivity()).setActionBarTitle("Suggest Keywords");

        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_SUGGESTED_KEYWORDS_TAG, Constants.USER_SUGGESTED_KEYWORDS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET, "Home Activity");
            a.execute();
        } else {

            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.suggest_keywords_layout, container, false);
        keywordName = (EditText) rootView.findViewById(R.id.keywordName);
        keywordType = (Spinner) rootView.findViewById(R.id.keywordType);
        keywordListCreated = (SwipeMenuListView) rootView.findViewById(R.id.listViewKeywords);
        keywordList = new ArrayList<>();
        addKeyword = (Button) rootView.findViewById(R.id.addButton);

        keywordsSuggestedArrayList = new ArrayList<>();
        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.KEYWORDTYPE_TAG, Constants.KEYWORDTYPE_URL, Constants.HTTP_GET, "Home Activity");
            a.execute();
        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }


        keywordType.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                keywordSelectedID = keywordList.get(position).getId();
                keywordSelectedName = keywordList.get(position).getTitle();

            }


            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        keywordListCreated.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
            @Override
            public void onLoadMore() {
                keywordListCreated.onLoadMoreComplete();
            }
        });
        SwipeMenuCreator creator = new SwipeMenuCreator() {

            @Override
            public void create(SwipeMenu menu) {

                // create "delete" item
                SwipeMenuItem deleteItem = new SwipeMenuItem(getActivity().getApplicationContext());
                // set item background
                Drawable delid = getResources().getDrawable(R.color.red);
                deleteItem.setBackground(delid);
                // set item width
                deleteItem.setWidth(dp2px(90));
                // set a icon
                deleteItem.setIcon(getResources().getDrawable(R.drawable.reject));
                deleteItem.setTitle("Delete");
                deleteItem.setTitleSize(15);
                deleteItem.setTitleColor(Color.WHITE);
                // add to menu
                menu.addMenuItem(deleteItem);
            }
        };


        keywordListCreated.setMenuCreator(creator);


        // step 2. listener item click event
        keywordListCreated.setOnMenuItemClickListener(new SwipeMenuListView.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(final int position, SwipeMenu menu, int index) {

                switch (index) {
                    case 0:

                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            //

                            AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());

                            alertDialogBuilder
                                    .setMessage("Do you want to delete this keyword?")
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
                                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.DELETE_KEYWORDTYPE_TAG, Constants.DELETE_KEYWORDTYPE_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&keyword_id=" + keywordsSuggestedArrayList.get(position).getKeywordID(), Constants.HTTP_GET, "Home Activity");
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


        // set SwipeListener
        keywordListCreated.setOnSwipeListener(new SwipeMenuListView.OnSwipeListener() {

            @Override
            public void onSwipeStart(int position) {
                // swipe start
            }

            @Override
            public void onSwipeEnd(int position) {
                // swipe end
            }
        });

        // set MenuStateChangeListener
        keywordListCreated.setOnMenuStateChangeListener(new SwipeMenuListView.OnMenuStateChangeListener() {
            @Override
            public void onMenuOpen(int position) {
            }

            @Override
            public void onMenuClose(int position) {
            }
        });


        // test item long click
        keywordListCreated.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {

            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                Toast.makeText(getActivity().getApplicationContext(), position + " long click", Toast.LENGTH_LONG).show();
                return false;
            }
        });

        UtilityList.setListViewHeightBasedOnChildren(keywordListCreated);


        addKeyword.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();
                    JSONObject jsonObject = new JSONObject();
                    try {

                        jsonObject.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                        jsonObject.put("keyword_name", keywordName.getText().toString().trim());
                        jsonObject.put("keyword_type_id", keywordSelectedID);


                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ADDKEYWORD_KEYWORDTYPE_TAG, Constants.ADDKEYWORD_KEYWORDTYPE_URL, Constants.HTTP_POST, jsonObject, "Home Activity");
                    a.execute();
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }

            }
        });
        return rootView;
    }


    private int dp2px(int dp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp,
                getResources().getDisplayMetrics());
    }

    private KeywordTypeAdapter keywordTypeAdapter;

    private UserSuggestedKeywordsAdapter userKeywordAdapter;

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
                if (tag.equalsIgnoreCase(Constants.KEYWORDTYPE_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        ((HomeActivity) getActivity()).dismissProgressDialog();

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                            keywordList.clear();
                            for (int i = 0; i < jsonObject.optJSONArray("keyword_type_list").length(); i++) {
                                GenericObject obj = new GenericObject();
                                obj.setId(jsonObject.optJSONArray("keyword_type_list").getJSONObject(i).optString("keyword_type_id"));
                                obj.setTitle(jsonObject.optJSONArray("keyword_type_list").getJSONObject(i).optString("keyword_type_name"));
                                keywordList.add(obj);
                            }

                            keywordTypeAdapter = new KeywordTypeAdapter(getActivity(), keywordList);
                            keywordType.setAdapter(keywordTypeAdapter);

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            //experience.setAdapter(new SpinnerAdapter(getActivity(), 0, experienceList));
                            //preferedstartup.setAdapter(new SpinnerAdapter(getActivity(), 0, preferedstartupList));
                            //contributoTypeSpinner.setAdapter(new SpinnerAdapter(getActivity(), 0, contributorTypeList));
                        }


                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.USER_SUGGESTED_KEYWORDS_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        keywordsSuggestedArrayList.clear();
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                            JSONArray workOrders = jsonObject.optJSONArray("suggest_keyword_list");
                            for (int i = 0; i < workOrders.length(); i++) {

                                SuggestKeywords obj = new SuggestKeywords();
                                obj.setKeywordID(workOrders.getJSONObject(i).optString("keyword_id"));
                                obj.setKeywordName(workOrders.getJSONObject(i).optString("keyword_name"));
                                obj.setKeywordStatus(workOrders.getJSONObject(i).optString("status"));
                                obj.setKeywordType(workOrders.getJSONObject(i).optString("keyword_type_name"));


                                keywordsSuggestedArrayList.add(obj);
                            }


                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            //experience.setAdapter(new SpinnerAdapter(getActivity(), 0, experienceList));
                            //preferedstartup.setAdapter(new SpinnerAdapter(getActivity(), 0, preferedstartupList));
                            //contributoTypeSpinner.setAdapter(new SpinnerAdapter(getActivity(), 0, contributorTypeList));
                            Toast.makeText(getActivity(), "No Keywords available", Toast.LENGTH_LONG).show();
                            keywordsSuggestedArrayList.clear();
                        }

                        userKeywordAdapter = new UserSuggestedKeywordsAdapter(getActivity(), keywordsSuggestedArrayList);

                        keywordListCreated.setAdapter(userKeywordAdapter);
                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                    }

                } else if (tag.equalsIgnoreCase(Constants.DELETE_KEYWORDTYPE_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        ((HomeActivity) getActivity()).dismissProgressDialog();

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "Keyword deleted successfully.", Toast.LENGTH_LONG).show();
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_SUGGESTED_KEYWORDS_TAG, Constants.USER_SUGGESTED_KEYWORDS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET, "Home Activity");
                                a.execute();
                            } else {

                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            //experience.setAdapter(new SpinnerAdapter(getActivity(), 0, experienceList));
                            //preferedstartup.setAdapter(new SpinnerAdapter(getActivity(), 0, preferedstartupList));
                            //contributoTypeSpinner.setAdapter(new SpinnerAdapter(getActivity(), 0, contributorTypeList));
                        }


                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                    }

                }

                else if(tag.equalsIgnoreCase(Constants.ADDKEYWORD_KEYWORDTYPE_TAG)){

                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        ((HomeActivity) getActivity()).dismissProgressDialog();

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "Keyword sent successfully.", Toast.LENGTH_LONG).show();
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_SUGGESTED_KEYWORDS_TAG, Constants.USER_SUGGESTED_KEYWORDS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET, "Home Activity");
                                a.execute();
                            } else {

                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            //experience.setAdapter(new SpinnerAdapter(getActivity(), 0, experienceList));
                            //preferedstartup.setAdapter(new SpinnerAdapter(getActivity(), 0, preferedstartupList));
                            //contributoTypeSpinner.setAdapter(new SpinnerAdapter(getActivity(), 0, contributorTypeList));
                        }


                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                    }

                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}
