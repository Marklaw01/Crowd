package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.adapter.AddStartupAdapter;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.models.GenericObject;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 3/21/2016.
 */
public class AddStartupsToProfileFragment extends Fragment implements AsyncTaskCompleteListener<String>, View.OnClickListener {

    ArrayList<GenericObject> companiesList;
    private ListView listView;
    private Button btn_conform;
    private AddStartupAdapter adapter;

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_add_startup_to_profile, container, false);

        try {
            companiesList = new ArrayList<GenericObject>();

            btn_conform = (Button) rootView.findViewById(R.id.btn_conform);

            btn_conform.setOnClickListener(this);
            listView = (ListView) rootView.findViewById(R.id.list_compaigns);

            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_STARTUPS_TAG, Constants.USER_STARTUPS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&user_type=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE), Constants.HTTP_POST,"Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }


            listView.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rootView;
    }

    public AddStartupsToProfileFragment() {
        super();
    }


    @Override
    public void onClick(View v) {
        try {
            if (v.getId() == R.id.btn_conform) {

                ArrayList<GenericObject> tempArray = adapter.getCheckedItems();

               /* for (int i = 0; i < tempArray.size(); i++) {
                    System.out.println(tempArray.get(i).getId());
                }*/
                StringBuilder selectedKeywordsId = new StringBuilder();
                for (int i = 0; i < tempArray.size(); i++) {
                    if (selectedKeywordsId.length() > 0) {
                        selectedKeywordsId.append(",");
                    }
                    selectedKeywordsId.append(tempArray.get(i).getId());
                }

                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                    JSONObject jsonObject = new JSONObject();
                    try {
                        jsonObject.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                        jsonObject.put("user_type", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE));
                        jsonObject.put("startup_id", selectedKeywordsId.toString());
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    ((HomeActivity) getActivity()).showProgressDialog();
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ADD_STARTUPS_LIST_TO_PROFILE_TAG, Constants.ADD_STARTUPS_LIST_TO_PROFILE_URL, Constants.HTTP_POST, jsonObject,"Home Activity");
                    a.execute();
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            }
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
                if (tag.equalsIgnoreCase(Constants.USER_STARTUPS_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        ((HomeActivity) getActivity()).dismissProgressDialog();

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            companiesList.clear();

                            if (jsonObject.optJSONArray("startup").length()!=0){
                                for (int i = 0; i < jsonObject.optJSONArray("startup").length(); i++) {
                                    GenericObject obj = new GenericObject();
                                    obj.setTitle(jsonObject.optJSONArray("startup").getJSONObject(i).optString("name"));
                                    obj.setId(jsonObject.optJSONArray("startup").getJSONObject(i).optString("id"));
                                    obj.setAnswer(jsonObject.optJSONArray("startup").getJSONObject(i).optString("description"));
                                    obj.setIschecked(jsonObject.optJSONArray("startup").getJSONObject(i).optBoolean("isSelected"));
                                    companiesList.add(obj);
                                }
                            }else{
                                Toast.makeText(getActivity(),"No Startups found", Toast.LENGTH_LONG).show();
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(),"No Startups found", Toast.LENGTH_LONG).show();
                        }

                        adapter = new AddStartupAdapter(getActivity(), companiesList);

                        listView.setAdapter(adapter);
                    } catch (JSONException e) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.ADD_STARTUPS_LIST_TO_PROFILE_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        System.out.println(jsonObject);
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {


                            getActivity().onBackPressed();
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }

                    } catch (JSONException e) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}