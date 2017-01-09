package com.crowdbootstrapapp.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.adapter.DocumentsAdapter;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.models.DocumentObject;
import com.crowdbootstrapapp.utilities.Async;
import com.crowdbootstrapapp.utilities.Constants;
import com.crowdbootstrapapp.utilities.DateTimeFormatClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by sunakshi.gautam on 1/21/2016.
 */
public class DocsSharingFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    private Button bUpload;
    private ListView mDocumentList;
    private DocumentsAdapter adapterDocument;
    private ArrayList<DocumentObject> listDocument;
    private EditText et_search;

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            try {
                // we check that the fragment is becoming visible
                ((HomeActivity) getActivity()).setOnBackPressedListener(this);

                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ALL_DELIVERABLES_DOCS_LIST_TAG, Constants.ALL_DELIVERABLES_DOCS_LIST_URL + "?startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID, Constants.HTTP_GET,"Home Activity");
                    a.execute();
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_docssharing, container, false);

        try {
            et_search = (EditText)rootView.findViewById(R.id.et_search);

            listDocument = new ArrayList<DocumentObject>();
            mDocumentList = (ListView) rootView.findViewById(R.id.listViewdocs);
            bUpload = (Button) rootView.findViewById(R.id.uploaddoc);
            if(CurrentStartUpDetailFragment.from.compareTo("complete") == 0){
               bUpload.setVisibility(View.GONE);
            }
            else {
                bUpload.setVisibility(View.VISIBLE);
            }


            bUpload.setOnClickListener(this);

            // Add entrepreneur list

            et_search.addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                }

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                    if (adapterDocument != null) {
                        adapterDocument.getFilter().filter(s);
                    }
                }

                @Override
                public void afterTextChanged(Editable s) {

                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rootView;
    }


    @Override
    public void onClick(View v) {

        try {
            switch (v.getId()) {
                case R.id.uploaddoc:
                    Fragment uploadDocument = new UploadDocumentFragment();
                    ((HomeActivity)getActivity()).replaceFragment(uploadDocument);
                    /*FragmentTransaction transactionRate = getParentFragment().getFragmentManager().beginTransaction();
                    transactionRate.replace(R.id.container, uploadDocument);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();*/

                    break;
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
                if (tag.equalsIgnoreCase(Constants.ALL_DELIVERABLES_DOCS_LIST_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {

                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            listDocument.clear();
                            if (jsonObject.optJSONArray("filesList").length()!=0) {
                                for (int i = 0; i < jsonObject.optJSONArray("filesList").length(); i++) {
                                    DocumentObject obj = new DocumentObject();
                                    obj.setDate(DateTimeFormatClass.convertStringObjectToMMDDYYYFormat(jsonObject.optJSONArray("filesList").getJSONObject(i).optString("date")));

                                    obj.setId(jsonObject.optJSONArray("filesList").getJSONObject(i).optString("id"));
                                    obj.setDoc_name(jsonObject.optJSONArray("filesList").getJSONObject(i).optString("doc_name"));
                                    obj.setDownload_link(Constants.APP_IMAGE_URL + "/" + jsonObject.optJSONArray("filesList").getJSONObject(i).optString("download_link"));
                                    obj.setRoadmap_name(jsonObject.optJSONArray("filesList").getJSONObject(i).optString("roadmap_name"));
                                    obj.setUser_name(jsonObject.optJSONArray("filesList").getJSONObject(i).optString("user_name"));
                                    listDocument.add(obj);
                                }
                            }else{
                                Toast.makeText(getActivity(), "No Documents Available", Toast.LENGTH_LONG).show();
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No Documents Available", Toast.LENGTH_LONG).show();
                        }

                        adapterDocument = new DocumentsAdapter(getActivity(), listDocument);
                        mDocumentList.setAdapter(adapterDocument);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}