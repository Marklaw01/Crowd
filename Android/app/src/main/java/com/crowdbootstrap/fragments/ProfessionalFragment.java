package com.crowdbootstrap.fragments;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.Html;
import android.text.InputType;
import android.text.TextWatcher;
import android.util.Log;
import android.view.ContextThemeWrapper;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.AccreditedInvesterActivity;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.adapter.KeywordsAdapter;
import com.crowdbootstrap.dropdownadapter.SpinnerAdapter;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.models.GenericObject;
import com.crowdbootstrap.utilities.Async;
import com.crowdbootstrap.utilities.Constants;

import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.ContentBody;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by sunakshi.gautam on 1/13/2016.
 */
public class ProfessionalFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

    private String selectedKeyword="", selectedSkills="", selectedQualifications="", selectedCertifications="",selectedPreferedStartups = "";
    private ArrayList<String> selectedKeywordList, selectedSkillsList, selectedQualificationsList, selectedCertificationsList, selectedPreferedStartupStageList;
    private RadioButton rb_AccreditedInvestor_yes, rb_AccreditedInvestor_no;
    private static int EXPERIENCE_ID = 0, PREFERRED_STARTUP_ID = 0, CONTRACTOR_ID = 0;
    private int ACCREDETED_INVESTER = 0;
    private ArrayList<GenericObject> experienceList, preferedstartupList, qualificationList, certificationList, skillsList, contributorTypeList, keywordsList;

    private SpinnerAdapter preferedstartupListAdapter, contributorTypeListAdapter, experienceListAdapter;

    private TextView tv_IndependentContractorRequierement;
    /* common edittext */
    private EditText keyword, qualification, skills, industryfocus;

    /* ENTREPRENEUR edittext */
    private EditText companyName, companyUrl, description;
    /* contractor edittexts */
    private EditText certification, preferedstartup;
    private Spinner experience;
    Spinner contributoTypeSpinner;
    private Button addContributor/*, rateContributor*/;
    private LinearLayout layout;
    private Uri fileUri;

    private String filepath;
    private Bitmap bitmap;

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            try {
                // we check that the fragment is becoming visible
                selectedKeywordList = new ArrayList<String>();
                contributorTypeList = new ArrayList<GenericObject>();
                certificationList = new ArrayList<GenericObject>();
                experienceList = new ArrayList<GenericObject>();
                preferedstartupList = new ArrayList<GenericObject>();
                keywordsList = new ArrayList<GenericObject>();
                qualificationList = new ArrayList<GenericObject>();
                skillsList = new ArrayList<GenericObject>();

                selectedPreferedStartupStageList = new ArrayList<String>();
                selectedKeywordList = new ArrayList<String>();
                selectedCertificationsList = new ArrayList<String>();
                selectedQualificationsList = new ArrayList<String>();
                selectedSkillsList = new ArrayList<String>();

                if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.CONTRACTOR)) {
                    ProfileFragment.editView.setVisibility(View.VISIBLE);
                    ProfileFragment.et_rate.setFocusable(false);
                    ProfileFragment.et_rate.setBackgroundDrawable(null);
                    ProfileFragment.et_rate.setCursorVisible(false);
                    ProfileFragment.et_rate.setFocusableInTouchMode(false);
                    ProfileFragment.circularImageView.setClickable(true);
                } else {
                    EntrepreneurProfileFragment.circularImageView.setClickable(true);
                }

                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity)getActivity()).showProgressDialog();
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SKILLS_QUALIFICATIONS_KEYWORDS_EXPERIENCE_CONTRACTORTYPE_PREFEREDSTARTUP_CERTIFICATIONS_TAG, Constants.SKILLS_QUALIFICATIONS_KEYWORDS_EXPERIENCE_CONTRACTORTYPE_PREFEREDSTARTUP_CERTIFICATIONS_URL, Constants.HTTP_GET,"Home Activity");
                    a.execute();
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }

                ((HomeActivity) getActivity()).setOnBackPressedListener(this);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = null;

        try {
            if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {


                rootView = inflater.inflate(R.layout.fragment_entrepreneur_profileprofessional, container, false);
                layout = (LinearLayout) rootView.findViewById(R.id.layout);
                companyName = (EditText) rootView.findViewById(R.id.companyName);
                companyUrl = (EditText) rootView.findViewById(R.id.companyUrl);
                description = (EditText) rootView.findViewById(R.id.description);
                keyword = (EditText) rootView.findViewById(R.id.keyword);
                qualification = (EditText) rootView.findViewById(R.id.qualification);
                skills = (EditText) rootView.findViewById(R.id.skills);
                industryfocus = (EditText) rootView.findViewById(R.id.industryfocus);


                companyName.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                companyUrl.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                description.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                keyword.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                qualification.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                skills.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                industryfocus.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);



                /*filepath = ((HomeActivity)getActivity()).getFileName();
                bitmap = ((HomeActivity)getActivity()).getBitmap();*/

                contributorTypeList = new ArrayList<GenericObject>();
                experienceList = new ArrayList<GenericObject>();
                preferedstartupList = new ArrayList<GenericObject>();
                keywordsList = new ArrayList<GenericObject>();
                qualificationList = new ArrayList<GenericObject>();
                skillsList = new ArrayList<GenericObject>();

                selectedKeywordList = new ArrayList<String>();
                selectedQualificationsList = new ArrayList<String>();
                selectedSkillsList = new ArrayList<String>();

                qualification.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (qualificationList.size() == 0) {
                            Toast.makeText(getActivity(), "No Qualification in available!", Toast.LENGTH_SHORT).show();
                        } else {
                            final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                            for (int i = 0; i < qualificationList.size(); i++) {
                                tempArray.add(i, qualificationList.get(i));
                            }
                            String[] deviceNameArr = new String[qualificationList.size()];
                            final boolean[] selectedItems = new boolean[qualificationList.size()];
                            for (int i = 0; i < deviceNameArr.length; i++) {
                                deviceNameArr[i] = qualificationList.get(i).getTitle();
                                selectedItems[i] = qualificationList.get(i).ischecked();
                            }
                            final AlertDialog.Builder builderDialog = new AlertDialog.Builder(new ContextThemeWrapper(getActivity(), R.style.AlertDialogCustom));
                            builderDialog.setTitle("Qualifications");

                            // Creating multiple selection by using setMutliChoiceItem method

                            builderDialog.setMultiChoiceItems(deviceNameArr, selectedItems,
                                    new DialogInterface.OnMultiChoiceClickListener() {
                                        public void onClick(DialogInterface dialog,
                                                            int whichButton, boolean isChecked) {
                                        }
                                    });

                            builderDialog.setPositiveButton("OK",
                                    new DialogInterface.OnClickListener() {
                                        @Override
                                        public void onClick(DialogInterface dialog, int which) {

                                            ListView list = ((AlertDialog) dialog).getListView();
                                            // make selected item in the comma seprated string
                                            StringBuilder stringBuilder = new StringBuilder();
                                            StringBuilder selectedKeywordsId = new StringBuilder();
                                            for (int i = 0; i < list.getCount(); i++) {
                                                boolean checked = list.isItemChecked(i);

                                                if (checked) {
                                                    if (stringBuilder.length() > 0) {
                                                        stringBuilder.append(", ");
                                                    }
                                                    stringBuilder.append(list.getItemAtPosition(i));
                                                    qualificationList.get(i).setIschecked(checked);
                                                } else {
                                                    qualificationList.get(i).setIschecked(checked);
                                                }
                                            }
                                            selectedQualificationsList.clear();
                                            for (int i = 0; i < qualificationList.size(); i++) {
                                                if (qualificationList.get(i).ischecked()) {
                                                    selectedQualificationsList.add(qualificationList.get(i).getId());
                                                }
                                            }

                                            for (int i = 0; i < selectedQualificationsList.size(); i++) {
                                                if (selectedKeywordsId.length() > 0) {
                                                    selectedKeywordsId.append(",");
                                                }
                                                selectedKeywordsId.append(selectedQualificationsList.get(i));
                                            }
                                            selectedQualifications = selectedKeywordsId.toString();
                                            System.out.println(selectedQualifications.toString() + "-------------------------");
                                            qualification.setText( stringBuilder.toString());
                                        }
                                    });

                            builderDialog.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {

                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    qualificationList.clear();
                                    for (int i = 0; i < tempArray.size(); i++) {
                                        qualificationList.add(i, tempArray.get(i));
                                    }
                                    StringBuilder selectedKeywordsId = new StringBuilder();
                                    selectedQualificationsList.clear();
                                    for (int i = 0; i < qualificationList.size(); i++) {
                                        if (qualificationList.get(i).ischecked()) {
                                            selectedQualificationsList.add(qualificationList.get(i).getId());
                                        }
                                    }

                                    for (int i = 0; i < selectedQualificationsList.size(); i++) {
                                        if (selectedKeywordsId.length() > 0) {
                                            selectedKeywordsId.append(",");
                                        }
                                        selectedKeywordsId.append(selectedQualificationsList.get(i));
                                    }
                                    selectedQualifications = selectedKeywordsId.toString();
                                    System.out.println(selectedQualifications.toString() + "-------------------------");
                                    tempArray.clear();
                                }
                            });

                            AlertDialog alert = builderDialog.create();
                            alert.show();
                        }
                    }
                });


                skills.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (skillsList.size() == 0) {
                            Toast.makeText(getActivity(), "No Skills in available!", Toast.LENGTH_SHORT).show();
                        } else {

                            final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                            for (int i = 0; i < skillsList.size(); i++) {
                                tempArray.add(i, skillsList.get(i));
                            }
                            String[] deviceNameArr = new String[skillsList.size()];
                            final boolean[] selectedItems = new boolean[skillsList.size()];
                            for (int i = 0; i < deviceNameArr.length; i++) {
                                deviceNameArr[i] = skillsList.get(i).getTitle();
                                selectedItems[i] = skillsList.get(i).ischecked();
                            }
                            final AlertDialog.Builder builderDialog = new AlertDialog.Builder(new ContextThemeWrapper(getActivity(), R.style.AlertDialogCustom));
                            builderDialog.setTitle("Skills");

                            builderDialog.setMultiChoiceItems(deviceNameArr, selectedItems,
                                    new DialogInterface.OnMultiChoiceClickListener() {
                                        public void onClick(DialogInterface dialog,
                                                            int whichButton, boolean isChecked) {
                                        }
                                    });

                            builderDialog.setPositiveButton("OK",
                                    new DialogInterface.OnClickListener() {
                                        @Override
                                        public void onClick(DialogInterface dialog, int which) {

                                            ListView list = ((AlertDialog) dialog).getListView();
                                            // make selected item in the comma seprated string
                                            StringBuilder stringBuilder = new StringBuilder();
                                            StringBuilder selectedKeywordsId = new StringBuilder();
                                            for (int i = 0; i < list.getCount(); i++) {
                                                boolean checked = list.isItemChecked(i);

                                                if (checked) {
                                                    if (stringBuilder.length() > 0)
                                                        stringBuilder.append(", ");
                                                    stringBuilder.append(list.getItemAtPosition(i));
                                                    skillsList.get(i).setIschecked(checked);
                                                } else {

                                                    skillsList.get(i).setIschecked(checked);
                                                }
                                            }

                                            selectedSkillsList.clear();
                                            for (int i = 0; i < skillsList.size(); i++) {
                                                if (skillsList.get(i).ischecked()) {
                                                    selectedSkillsList.add(skillsList.get(i).getId());
                                                }
                                            }

                                            for (int i = 0; i < selectedSkillsList.size(); i++) {
                                                if (selectedKeywordsId.length() > 0) {
                                                    selectedKeywordsId.append(",");
                                                }
                                                selectedKeywordsId.append(selectedSkillsList.get(i));
                                            }
                                            selectedSkills = selectedKeywordsId.toString();
                                            System.out.println(selectedSkills.toString() + "-------------------------");


                                            skills.setText(stringBuilder.toString());
                                        }
                                    });

                            builderDialog.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {

                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    skillsList.clear();
                                    for (int i = 0; i < tempArray.size(); i++) {
                                        skillsList.add(i, tempArray.get(i));
                                    }
                                    StringBuilder selectedKeywordsId = new StringBuilder();
                                    selectedSkillsList.clear();
                                    for (int i = 0; i < skillsList.size(); i++) {
                                        if (skillsList.get(i).ischecked()) {
                                            selectedSkillsList.add(skillsList.get(i).getId());
                                        }
                                    }

                                    for (int i = 0; i < selectedSkillsList.size(); i++) {
                                        if (selectedKeywordsId.length() > 0) {
                                            selectedKeywordsId.append(",");
                                        }
                                        selectedKeywordsId.append(selectedSkillsList.get(i));
                                    }
                                    selectedSkills = selectedKeywordsId.toString();
                                    System.out.println(selectedSkills.toString() + "-------------------------");

                                    tempArray.clear();
                                }
                            });


                            AlertDialog alert = builderDialog.create();
                            alert.show();
                        }
                    }
                });


                keyword.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        for (int i = 0; i < keywordsList.size(); i++) {
                            Log.d("ischecked", String.valueOf(keywordsList.get(i).ischecked()));
                        }

                        if (keywordsList.size() == 0) {
                            Toast.makeText(getActivity(), "No Keywords in available!", Toast.LENGTH_LONG).show();
                        } else {
                            final Dialog dialog = new Dialog(getActivity());
                            dialog.setContentView(R.layout.keywords_dialog);
                            dialog.setTitle("Keywords");
                            final EditText search = (EditText)dialog.findViewById(R.id.et_search);
                            final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                            for (int i = 0; i < keywordsList.size(); i++) {
                                tempArray.add(keywordsList.get(i));
                                Log.e("retain", String.valueOf(tempArray.get(i).ischecked()));
                            }
                            final ListView lv = (ListView) dialog.findViewById(R.id.listKeywords);
                            lv.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);

                            final KeywordsAdapter adapter = new KeywordsAdapter(getActivity(), 0, keywordsList);
                            lv.setAdapter(adapter);

                            TextView dialogCancelButton = (TextView) dialog.findViewById(R.id.button_cancel);
                            TextView dialogButton = (TextView) dialog.findViewById(R.id.button);

                            search.addTextChangedListener(new TextWatcher() {
                                @Override
                                public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                                }

                                @Override
                                public void onTextChanged(CharSequence s, int start, int before, int count) {
                                    if (adapter != null) {
                                        adapter.getFilter().filter(s);
                                    }
                                }

                                @Override
                                public void afterTextChanged(Editable s) {

                                }
                            });
                            dialogCancelButton.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    keywordsList.clear();

                                    for (int i = 0; i < tempArray.size(); i++) {
                                        keywordsList.add(i, tempArray.get(i));
                                    }

                                    StringBuilder selectedKeywordsId = new StringBuilder();
                                    selectedKeywordList.clear();
                                    for (int i = 0; i < keywordsList.size(); i++) {
                                        if (keywordsList.get(i).ischecked()) {
                                            selectedKeywordList.add(keywordsList.get(i).getId());
                                        }
                                    }

                                    for (int i = 0; i < selectedKeywordList.size(); i++) {
                                        if (selectedKeywordsId.length() > 0) {
                                            selectedKeywordsId.append(",");
                                        }
                                        selectedKeywordsId.append(selectedKeywordList.get(i));
                                    }
                                    selectedKeyword = selectedKeywordsId.toString();
                                    System.out.println(selectedKeyword.toString() + "-------------------------");
                                    tempArray.clear();

                                    dialog.dismiss();
                                }
                            });


                            dialogButton.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {

                                    ArrayList<GenericObject> mArrayProducts = adapter.getCheckedItems();
                                    for (int i = 0; i < mArrayProducts.size(); i++) {
                                        for (int j = 0; j < keywordsList.size(); j++) {
                                            if (mArrayProducts.get(i).getId().equalsIgnoreCase(keywordsList.get(j).getId())) {
                                                keywordsList.get(j).setIschecked(true);
                                            }
                                        }
                                    }

                                    StringBuilder sb = new StringBuilder();
                                    StringBuilder selectedKeywordID = new StringBuilder();
                                    for (int i = 0; i < mArrayProducts.size(); i++) {
                                        if (sb.length() > 0) {
                                            sb.append(", ");
                                            selectedKeywordID.append(",");
                                        }
                                        sb.append(mArrayProducts.get(i).getTitle());
                                        selectedKeywordID.append(mArrayProducts.get(i).getId());
                                    }

                                    selectedKeyword = selectedKeywordID.toString();
                                    keyword.setText(sb.toString());
                                    System.out.println(selectedKeyword.toString() + "-------------------------");

                                    dialog.dismiss();
                                }
                            });
                            dialog.show();
                        }
                    }

                });

            } else {//contractor profile
                rootView = inflater.inflate(R.layout.fragment_profileprofessional, container, false);
                layout = (LinearLayout) rootView.findViewById(R.id.layout);
                tv_IndependentContractorRequierement = (TextView) rootView.findViewById(R.id.tv_IndependentContractorRequierement);
                contributoTypeSpinner = (Spinner) rootView.findViewById(R.id.contributortype);
                experience = (Spinner) rootView.findViewById(R.id.experience);
                certification = (EditText) rootView.findViewById(R.id.certification);
                preferedstartup = (EditText) rootView.findViewById(R.id.preferedstartup);
                keyword = (EditText) rootView.findViewById(R.id.keyword);
                qualification = (EditText) rootView.findViewById(R.id.qualification);
                skills = (EditText) rootView.findViewById(R.id.skills);
                industryfocus = (EditText) rootView.findViewById(R.id.industryfocus);
                rb_AccreditedInvestor_no = (RadioButton) rootView.findViewById(R.id.rb_AccreditedInvestor_no);
                rb_AccreditedInvestor_yes = (RadioButton) rootView.findViewById(R.id.rb_AccreditedInvestor_yes);



                certification.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                preferedstartup.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                keyword.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                qualification.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                skills.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                industryfocus.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);

                /*filepath = ((HomeActivity)getActivity()).getFileName();
                bitmap = ((HomeActivity)getActivity()).getBitmap();*/

                selectedKeywordList = new ArrayList<String>();
                contributorTypeList = new ArrayList<GenericObject>();
                certificationList = new ArrayList<GenericObject>();
                experienceList = new ArrayList<GenericObject>();
                preferedstartupList = new ArrayList<GenericObject>();
                keywordsList = new ArrayList<GenericObject>();
                qualificationList = new ArrayList<GenericObject>();
                skillsList = new ArrayList<GenericObject>();

                selectedKeywordList = new ArrayList<String>();
                selectedCertificationsList = new ArrayList<String>();
                selectedQualificationsList = new ArrayList<String>();
                selectedSkillsList = new ArrayList<String>();

                tv_IndependentContractorRequierement.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        startActivity(new Intent(getActivity(), AccreditedInvesterActivity.class));
                    }
                });

                experience.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                    @Override
                    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                        EXPERIENCE_ID = Integer.parseInt(experienceList.get(position).getId());
                    }

                    @Override
                    public void onNothingSelected(AdapterView<?> parent) {

                    }
                });

                contributoTypeSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                    @Override
                    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                        CONTRACTOR_ID = Integer.parseInt(contributorTypeList.get(position).getId());
                    }

                    @Override
                    public void onNothingSelected(AdapterView<?> parent) {

                    }
                });

//                preferedstartup.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
//                    @Override
//                    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
//                        PREFERRED_STARTUP_ID = Integer.parseInt(preferedstartupList.get(position).getId());
//                    }
//
//                    @Override
//                    public void onNothingSelected(AdapterView<?> parent) {
//
//                    }
//                });

                //rb_AccreditedInvestor_no.setChecked(false);
                rb_AccreditedInvestor_yes.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                    @Override
                    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                        if (isChecked) {
                            //isAccredetInvester = true;
                            ACCREDETED_INVESTER = 1;
                        } else {
                            //isAccredetInvester = false;
                            ACCREDETED_INVESTER = 0;
                        }
                    }
                });

                rb_AccreditedInvestor_no.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                    @Override
                    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                        if (isChecked) {
                            //isAccredetInvester = false;
                            ACCREDETED_INVESTER = 0;
                        } else {
                            //isAccredetInvester = true;
                            ACCREDETED_INVESTER = 1;
                        }
                    }
                });




//Change+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                preferedstartup.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (preferedstartupList.size() == 0) {
                            Toast.makeText(getActivity(), "No Startup Stage in available!", Toast.LENGTH_SHORT).show();
                        } else {
                            final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                            for (int i = 0; i < preferedstartupList.size(); i++) {
                                tempArray.add(i, preferedstartupList.get(i));
                            }
                            String[] deviceNameArr = new String[preferedstartupList.size()];
                            final boolean[] selectedItems = new boolean[preferedstartupList.size()];
                            for (int i = 0; i < deviceNameArr.length; i++) {
                                deviceNameArr[i] = preferedstartupList.get(i).getTitle();
                                selectedItems[i] = preferedstartupList.get(i).ischecked();
                            }
                            final AlertDialog.Builder builderDialog = new AlertDialog.Builder(new ContextThemeWrapper(getActivity(), R.style.AlertDialogCustom));
                            builderDialog.setTitle("Startup Stage");

                            // Creating multiple selection by using setMutliChoiceItem method

                            builderDialog.setMultiChoiceItems(deviceNameArr, selectedItems,
                                    new DialogInterface.OnMultiChoiceClickListener() {
                                        public void onClick(DialogInterface dialog,
                                                            int whichButton, boolean isChecked) {
                                        }
                                    });

                            builderDialog.setPositiveButton("OK",
                                    new DialogInterface.OnClickListener() {
                                        @Override
                                        public void onClick(DialogInterface dialog, int which) {

                                            ListView list = ((AlertDialog) dialog).getListView();
                                            // make selected item in the comma seprated string
                                            StringBuilder stringBuilder = new StringBuilder();
                                            StringBuilder selectedKeywordsId = new StringBuilder();
                                            for (int i = 0; i < list.getCount(); i++) {
                                                boolean checked = list.isItemChecked(i);

                                                if (checked) {
                                                    if (stringBuilder.length() > 0) {
                                                        stringBuilder.append(", ");
                                                    }
                                                    stringBuilder.append(list.getItemAtPosition(i));
                                                    preferedstartupList.get(i).setIschecked(checked);
                                                } else {
                                                    preferedstartupList.get(i).setIschecked(checked);
                                                }
                                            }
                                            selectedPreferedStartupStageList.clear();
                                            for (int i = 0; i < preferedstartupList.size(); i++) {
                                                if (preferedstartupList.get(i).ischecked()) {
                                                    selectedPreferedStartupStageList.add(preferedstartupList.get(i).getId());
                                                }
                                            }

                                            for (int i = 0; i < selectedPreferedStartupStageList.size(); i++) {
                                                if (selectedKeywordsId.length() > 0) {
                                                    selectedKeywordsId.append(",");
                                                }
                                                selectedKeywordsId.append(selectedPreferedStartupStageList.get(i));
                                            }
                                            selectedPreferedStartups = selectedKeywordsId.toString();
                                            System.out.println(selectedPreferedStartups.toString() + "-------------------------");
                                            preferedstartup.setText(stringBuilder.toString());
                                        }
                                    });

                            builderDialog.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {

                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    preferedstartupList.clear();
                                    for (int i = 0; i < tempArray.size(); i++) {
                                        preferedstartupList.add(i, tempArray.get(i));
                                    }
                                    StringBuilder selectedKeywordsId = new StringBuilder();
                                    selectedPreferedStartupStageList.clear();
                                    for (int i = 0; i < preferedstartupList.size(); i++) {
                                        if (preferedstartupList.get(i).ischecked()) {
                                            selectedPreferedStartupStageList.add(preferedstartupList.get(i).getId());
                                        }
                                    }

                                    for (int i = 0; i < selectedPreferedStartupStageList.size(); i++) {
                                        if (selectedKeywordsId.length() > 0) {
                                            selectedKeywordsId.append(",");
                                        }
                                        selectedKeywordsId.append(selectedPreferedStartupStageList.get(i));
                                    }
                                    selectedPreferedStartups= selectedKeywordsId.toString();
                                    System.out.println(selectedPreferedStartups.toString() + "-------------------------");
                                    tempArray.clear();
                                }
                            });

                            AlertDialog alert = builderDialog.create();
                            alert.show();
                        }
                    }
                });


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++






                qualification.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (qualificationList.size() == 0) {
                            Toast.makeText(getActivity(), "No Qualification in available!", Toast.LENGTH_SHORT).show();
                        } else {
                            final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                            for (int i = 0; i < qualificationList.size(); i++) {
                                tempArray.add(i, qualificationList.get(i));
                            }
                            String[] deviceNameArr = new String[qualificationList.size()];
                            final boolean[] selectedItems = new boolean[qualificationList.size()];
                            for (int i = 0; i < deviceNameArr.length; i++) {
                                deviceNameArr[i] = qualificationList.get(i).getTitle();
                                selectedItems[i] = qualificationList.get(i).ischecked();
                            }
                            final AlertDialog.Builder builderDialog = new AlertDialog.Builder(new ContextThemeWrapper(getActivity(), R.style.AlertDialogCustom));
                            builderDialog.setTitle("Qualifications");

                            // Creating multiple selection by using setMutliChoiceItem method

                            builderDialog.setMultiChoiceItems(deviceNameArr, selectedItems,
                                    new DialogInterface.OnMultiChoiceClickListener() {
                                        public void onClick(DialogInterface dialog,
                                                            int whichButton, boolean isChecked) {
                                        }
                                    });

                            builderDialog.setPositiveButton("OK",
                                    new DialogInterface.OnClickListener() {
                                        @Override
                                        public void onClick(DialogInterface dialog, int which) {

                                            ListView list = ((AlertDialog) dialog).getListView();
                                            // make selected item in the comma seprated string
                                            StringBuilder stringBuilder = new StringBuilder();
                                            StringBuilder selectedKeywordsId = new StringBuilder();
                                            for (int i = 0; i < list.getCount(); i++) {
                                                boolean checked = list.isItemChecked(i);

                                                if (checked) {
                                                    if (stringBuilder.length() > 0) {
                                                        stringBuilder.append(", ");
                                                    }
                                                    stringBuilder.append(list.getItemAtPosition(i));
                                                    qualificationList.get(i).setIschecked(checked);
                                                } else {
                                                    qualificationList.get(i).setIschecked(checked);
                                                }
                                            }
                                            selectedQualificationsList.clear();
                                            for (int i = 0; i < qualificationList.size(); i++) {
                                                if (qualificationList.get(i).ischecked()) {
                                                    selectedQualificationsList.add(qualificationList.get(i).getId());
                                                }
                                            }

                                            for (int i = 0; i < selectedQualificationsList.size(); i++) {
                                                if (selectedKeywordsId.length() > 0) {
                                                    selectedKeywordsId.append(",");
                                                }
                                                selectedKeywordsId.append(selectedQualificationsList.get(i));
                                            }
                                            selectedQualifications = selectedKeywordsId.toString();
                                            System.out.println(selectedQualifications.toString() + "-------------------------");
                                            qualification.setText(stringBuilder.toString());
                                        }
                                    });

                            builderDialog.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {

                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    qualificationList.clear();
                                    for (int i = 0; i < tempArray.size(); i++) {
                                        qualificationList.add(i, tempArray.get(i));
                                    }
                                    StringBuilder selectedKeywordsId = new StringBuilder();
                                    selectedQualificationsList.clear();
                                    for (int i = 0; i < qualificationList.size(); i++) {
                                        if (qualificationList.get(i).ischecked()) {
                                            selectedQualificationsList.add(qualificationList.get(i).getId());
                                        }
                                    }

                                    for (int i = 0; i < selectedQualificationsList.size(); i++) {
                                        if (selectedKeywordsId.length() > 0) {
                                            selectedKeywordsId.append(",");
                                        }
                                        selectedKeywordsId.append(selectedQualificationsList.get(i));
                                    }
                                    selectedQualifications = selectedKeywordsId.toString();
                                    System.out.println(selectedQualifications.toString() + "-------------------------");
                                    tempArray.clear();
                                }
                            });

                            AlertDialog alert = builderDialog.create();
                            alert.show();
                        }
                    }
                });


                skills.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (skillsList.size() == 0) {
                            Toast.makeText(getActivity(), "No Skills in available!", Toast.LENGTH_SHORT).show();
                        } else {

                            final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                            for (int i = 0; i < skillsList.size(); i++) {
                                tempArray.add(i, skillsList.get(i));
                            }
                            String[] deviceNameArr = new String[skillsList.size()];
                            final boolean[] selectedItems = new boolean[skillsList.size()];
                            for (int i = 0; i < deviceNameArr.length; i++) {
                                deviceNameArr[i] = skillsList.get(i).getTitle();
                                selectedItems[i] = skillsList.get(i).ischecked();
                            }
                            final AlertDialog.Builder builderDialog = new AlertDialog.Builder(new ContextThemeWrapper(getActivity(), R.style.AlertDialogCustom));
                            builderDialog.setTitle("Skills");

                            builderDialog.setMultiChoiceItems(deviceNameArr, selectedItems,
                                    new DialogInterface.OnMultiChoiceClickListener() {
                                        public void onClick(DialogInterface dialog,
                                                            int whichButton, boolean isChecked) {
                                        }
                                    });

                            builderDialog.setPositiveButton("OK",
                                    new DialogInterface.OnClickListener() {
                                        @Override
                                        public void onClick(DialogInterface dialog, int which) {

                                            ListView list = ((AlertDialog) dialog).getListView();
                                            // make selected item in the comma seprated string
                                            StringBuilder stringBuilder = new StringBuilder();
                                            StringBuilder selectedKeywordsId = new StringBuilder();
                                            for (int i = 0; i < list.getCount(); i++) {
                                                boolean checked = list.isItemChecked(i);

                                                if (checked) {
                                                    if (stringBuilder.length() > 0)
                                                        stringBuilder.append(", ");
                                                    stringBuilder.append(list.getItemAtPosition(i));
                                                    skillsList.get(i).setIschecked(checked);
                                                } else {

                                                    skillsList.get(i).setIschecked(checked);
                                                }
                                            }

                                            selectedSkillsList.clear();
                                            for (int i = 0; i < skillsList.size(); i++) {
                                                if (skillsList.get(i).ischecked()) {
                                                    selectedSkillsList.add(skillsList.get(i).getId());
                                                }
                                            }

                                            for (int i = 0; i < selectedSkillsList.size(); i++) {
                                                if (selectedKeywordsId.length() > 0) {
                                                    selectedKeywordsId.append(",");
                                                }
                                                selectedKeywordsId.append(selectedSkillsList.get(i));
                                            }
                                            selectedSkills = selectedKeywordsId.toString();
                                            System.out.println(selectedSkills.toString() + "-------------------------");


                                            skills.setText( stringBuilder.toString());
                                            skills.setText( stringBuilder.toString());
                                        }
                                    });

                            builderDialog.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {

                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    skillsList.clear();
                                    for (int i = 0; i < tempArray.size(); i++) {
                                        skillsList.add(i, tempArray.get(i));
                                    }
                                    StringBuilder selectedKeywordsId = new StringBuilder();
                                    selectedSkillsList.clear();
                                    for (int i = 0; i < skillsList.size(); i++) {
                                        if (skillsList.get(i).ischecked()) {
                                            selectedSkillsList.add(skillsList.get(i).getId());
                                        }
                                    }

                                    for (int i = 0; i < selectedSkillsList.size(); i++) {
                                        if (selectedKeywordsId.length() > 0) {
                                            selectedKeywordsId.append(",");
                                        }
                                        selectedKeywordsId.append(selectedSkillsList.get(i));
                                    }
                                    selectedSkills = selectedKeywordsId.toString();
                                    System.out.println(selectedSkills.toString() + "-------------------------");

                                    tempArray.clear();
                                }
                            });


                            AlertDialog alert = builderDialog.create();
                            alert.show();
                        }
                    }
                });


                keyword.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        for (int i = 0; i < keywordsList.size(); i++) {
                            Log.d("ischecked", String.valueOf(keywordsList.get(i).ischecked()));
                        }

                        if (keywordsList.size() == 0) {
                            Toast.makeText(getActivity(), "No Keywords in available!", Toast.LENGTH_LONG).show();
                        } else {
                            final Dialog dialog = new Dialog(getActivity());
                            dialog.setContentView(R.layout.keywords_dialog);
                            dialog.setTitle("Keywords");
                            final EditText search = (EditText)dialog.findViewById(R.id.et_search);
                            final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                            for (int i = 0; i < keywordsList.size(); i++) {
                                tempArray.add(keywordsList.get(i));
                                Log.e("retain", String.valueOf(tempArray.get(i).ischecked()));
                            }
                            final ListView lv = (ListView) dialog.findViewById(R.id.listKeywords);
                            lv.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);

                            final KeywordsAdapter adapter = new KeywordsAdapter(getActivity(), 0, keywordsList);
                            lv.setAdapter(adapter);

                            TextView dialogCancelButton = (TextView) dialog.findViewById(R.id.button_cancel);
                            TextView dialogButton = (TextView) dialog.findViewById(R.id.button);

                            search.addTextChangedListener(new TextWatcher() {
                                @Override
                                public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                                }

                                @Override
                                public void onTextChanged(CharSequence s, int start, int before, int count) {
                                    if (adapter!=null){
                                        adapter.getFilter().filter(s);
                                    }
                                }

                                @Override
                                public void afterTextChanged(Editable s) {

                                }
                            });
                            dialogCancelButton.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    keywordsList.clear();

                                    for (int i = 0; i < tempArray.size(); i++) {
                                        keywordsList.add(i, tempArray.get(i));
                                    }

                                    StringBuilder selectedKeywordsId = new StringBuilder();
                                    selectedKeywordList.clear();
                                    for (int i = 0; i < keywordsList.size(); i++) {
                                        if (keywordsList.get(i).ischecked()) {
                                            selectedKeywordList.add(keywordsList.get(i).getId());
                                        }
                                    }

                                    for (int i = 0; i < selectedKeywordList.size(); i++) {
                                        if (selectedKeywordsId.length() > 0) {
                                            selectedKeywordsId.append(",");
                                        }
                                        selectedKeywordsId.append(selectedKeywordList.get(i));
                                    }
                                    selectedKeyword = selectedKeywordsId.toString();
                                    System.out.println(selectedKeyword.toString() + "-------------------------");
                                    tempArray.clear();

                                    dialog.dismiss();
                                }
                            });


                            dialogButton.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {

                                    ArrayList<GenericObject> mArrayProducts = adapter.getCheckedItems();
                                    for (int i = 0; i < mArrayProducts.size(); i++) {
                                        for (int j = 0; j < keywordsList.size(); j++) {
                                            if (mArrayProducts.get(i).getId().equalsIgnoreCase(keywordsList.get(j).getId())) {
                                                keywordsList.get(j).setIschecked(true);
                                            }
                                        }
                                    }

                                    StringBuilder sb = new StringBuilder();
                                    StringBuilder selectedKeywordID = new StringBuilder();
                                    for (int i = 0; i < mArrayProducts.size(); i++) {
                                        if (sb.length() > 0) {
                                            sb.append(", ");
                                            selectedKeywordID.append(",");
                                        }
                                        sb.append(mArrayProducts.get(i).getTitle());
                                        selectedKeywordID.append(mArrayProducts.get(i).getId());
                                    }

                                    selectedKeyword = selectedKeywordID.toString();
                                    keyword.setText(sb.toString());
                                    System.out.println(selectedKeyword.toString() + "-------------------------");

                                    dialog.dismiss();
                                }
                            });
                            dialog.show();
                        }
                    }

                });

                certification.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (certificationList.size() == 0) {
                            Toast.makeText(getActivity(), "No Certification in available!", Toast.LENGTH_SHORT).show();
                        } else {

                            final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                            for (int i = 0; i < certificationList.size(); i++) {
                                tempArray.add(i, certificationList.get(i));
                            }
                            String[] deviceNameArr = new String[certificationList.size()];
                            final boolean[] selectedItems = new boolean[certificationList.size()];
                            for (int i = 0; i < deviceNameArr.length; i++) {
                                deviceNameArr[i] = certificationList.get(i).getTitle();
                                selectedItems[i] = certificationList.get(i).ischecked();
                            }
                            final AlertDialog.Builder builderDialog = new AlertDialog.Builder(new ContextThemeWrapper(getActivity(), R.style.AlertDialogCustom));
                            builderDialog.setTitle("Certifications");

                            // Creating multiple selection by using setMutliChoiceItem method

                            builderDialog.setMultiChoiceItems(deviceNameArr, selectedItems,
                                    new DialogInterface.OnMultiChoiceClickListener() {
                                        public void onClick(DialogInterface dialog,
                                                            int whichButton, boolean isChecked) {
                                        }
                                    });

                            builderDialog.setPositiveButton("OK",
                                    new DialogInterface.OnClickListener() {
                                        @Override
                                        public void onClick(DialogInterface dialog, int which) {

                                            ListView list = ((AlertDialog) dialog).getListView();
                                            // make selected item in the comma seprated string
                                            StringBuilder stringBuilder = new StringBuilder();
                                            StringBuilder selectedKeywordsId = new StringBuilder();
                                            for (int i = 0; i < list.getCount(); i++) {
                                                boolean checked = list.isItemChecked(i);

                                                if (checked) {
                                                    if (stringBuilder.length() > 0)
                                                        stringBuilder.append(", ");
                                                    stringBuilder.append(list.getItemAtPosition(i));
                                                    certificationList.get(i).setIschecked(checked);
                                                } else {

                                                    certificationList.get(i).setIschecked(checked);
                                                }
                                            }
                                            selectedCertificationsList.clear();
                                            for (int i = 0; i < certificationList.size(); i++) {
                                                if (certificationList.get(i).ischecked()) {
                                                    selectedCertificationsList.add(certificationList.get(i).getId());
                                                }
                                            }

                                            for (int i = 0; i < selectedCertificationsList.size(); i++) {
                                                if (selectedKeywordsId.length() > 0) {
                                                    selectedKeywordsId.append(",");
                                                }
                                                selectedKeywordsId.append(selectedCertificationsList.get(i));
                                            }
                                            selectedCertifications = selectedKeywordsId.toString();
                                            System.out.println(selectedCertifications.toString() + "-------------------------");
                                            certification.setText(stringBuilder.toString());
                                        }
                                    });

                            builderDialog.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {

                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    certificationList.clear();
                                    for (int i = 0; i < tempArray.size(); i++) {
                                        certificationList.add(i, tempArray.get(i));
                                    }
                                    StringBuilder selectedKeywordsId = new StringBuilder();
                                    selectedCertificationsList.clear();
                                    for (int i = 0; i < certificationList.size(); i++) {
                                        if (certificationList.get(i).ischecked()) {
                                            selectedCertificationsList.add(certificationList.get(i).getId());
                                        }
                                    }

                                    for (int i = 0; i < selectedCertificationsList.size(); i++) {
                                        if (selectedKeywordsId.length() > 0) {
                                            selectedKeywordsId.append(",");
                                        }
                                        selectedKeywordsId.append(selectedCertificationsList.get(i));
                                    }
                                    selectedCertifications = selectedKeywordsId.toString();
                                    System.out.println(selectedCertifications.toString() + "-------------------------");
                                    tempArray.clear();
                                }
                            });


                            AlertDialog alert = builderDialog.create();
                            alert.show();
                        }
                    }
                });
            }
            //rateContributor.setOnClickListener(this);

            addContributor = (Button) rootView.findViewById(R.id.addcontributor);
            //rateContributor = (Button) rootView.findViewById(R.id.ratecontributor);
            addContributor.setText(getString(R.string.submit));

            addContributor.setOnClickListener(this);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootView;
    }

    @Override
    public void onResume() {
        super.onResume();
        //((HomeActivity) getActivity()).setOnActivityResultListener(this);
        //((HomeActivity) getActivity()).setOnBackPressedListener(this);

    }

    @Override
    public void onClick(View v) {
        try {
            switch (v.getId()) {

                /*case R.id.ratecontributor:
                    Fragment rateContributor = new RateContributor();
                    FragmentTransaction transactionRate = getParentFragment().getFragmentManager().beginTransaction();
                    transactionRate.replace(R.id.container, rateContributor);
                    transactionRate.addToBackStack(null);
                    transactionRate.commit();
                    break;
    */
                case R.id.addcontributor:
                    InputMethodManager inputMethodManager = (InputMethodManager)getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
                    inputMethodManager.hideSoftInputFromWindow(getActivity().getCurrentFocus().getWindowToken(), 0);
                    if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {

                        /*EntrepreneurProfileFragment.et_rate.setBackgroundDrawable(null);
                        EntrepreneurProfileFragment.et_rate.setFocusableInTouchMode(false);
                        EntrepreneurProfileFragment.et_rate.setCursorVisible(false);
                        EntrepreneurProfileFragment.et_rate.setFocusable(false);
                        EntrepreneurProfileFragment.editView.setVisibility(View.VISIBLE);
    */
                        if (filepath != null) {
                            File file = new File(filepath);
                            if (file.length() >= 5242880) {
                                Toast.makeText(getActivity(), "Image size is more than 5 MB.", Toast.LENGTH_SHORT).show();
                            } else {
                                HashMap<String, String> map = new HashMap<String, String>();
                                map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                                map.put("company_name", companyName.getText().toString().trim());
                                map.put("website_link", companyUrl.getText().toString().trim());
                                map.put("description", description.getText().toString().trim());
                                map.put("keywords", selectedKeyword);
                                map.put("qualifications", selectedQualifications);
                                map.put("skills", selectedSkills);
                                map.put("industry_focus", industryfocus.getText().toString().trim());

                             /*   String[] s = EntrepreneurProfileFragment.et_username.getText().toString().trim().split(" ");

                                map.put("first_name", s[0]);
                                map.put("last_name", s[s.length - 1].trim());
    */
                                String name = EntrepreneurProfileFragment.et_username.getText().toString().trim();
                                String[] s = EntrepreneurProfileFragment.et_username.getText().toString().trim().split(" ");

                                if (s.length==1){
                                    map.put("first_name", s[0].trim());
                                    map.put("last_name", "");
                                }else{
                                    map.put("first_name", name.substring(0, name.lastIndexOf(" ")));
                                    map.put("last_name", s[s.length - 1].trim());
                                }



                                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                    saveProfile(map, Constants.ENTREPRENEUR_EDIT_PROFESSIONAL_PROFILE_URL);
                                } else {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                }
                            }
                        } else {
                            HashMap<String, String> map = new HashMap<String, String>();
                            map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            map.put("company_name", companyName.getText().toString().trim());
                            map.put("website_link", companyUrl.getText().toString().trim());
                            map.put("description", description.getText().toString().trim());
                            map.put("keywords", selectedKeyword);
                            map.put("qualifications", selectedQualifications);
                            map.put("skills", selectedSkills);
                            map.put("industry_focus", industryfocus.getText().toString().trim());

                            String name = EntrepreneurProfileFragment.et_username.getText().toString().trim();

                            String[] s = EntrepreneurProfileFragment.et_username.getText().toString().trim().split(" ");

                            if (s.length==1){
                                map.put("first_name", s[0].trim());
                                map.put("last_name", "");
                            }else{
                                map.put("first_name", name.substring(0, name.lastIndexOf(" ")));
                                map.put("last_name", s[s.length - 1].trim());
                            }
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                saveProfile(map, Constants.ENTREPRENEUR_EDIT_PROFESSIONAL_PROFILE_URL);
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        }
                    } else {
                        ProfileFragment.et_rate.setBackgroundDrawable(null);
                        ProfileFragment.et_rate.setFocusableInTouchMode(false);
                        ProfileFragment.et_rate.setCursorVisible(false);
                        ProfileFragment.et_rate.setFocusable(false);
                        ProfileFragment.editView.setVisibility(View.VISIBLE);


                        if (filepath != null) {
                            File file = new File(filepath);
                            if (file.length() >= 5242880) {
                                Toast.makeText(getActivity(), "Image size is more than 5 MB.", Toast.LENGTH_SHORT).show();
                            } else {
                                HashMap<String, String> map = new HashMap<String, String>();
                                map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                                String name = ProfileFragment.et_username.getText().toString().trim();
                                String[] s = ProfileFragment.et_username.getText().toString().trim().split(" ");

                                if (s.length==1){
                                    map.put("first_name", s[0].trim());
                                    map.put("last_name", "");
                                }else{
                                    map.put("first_name", name.substring(0, name.lastIndexOf(" ")));
                                    map.put("last_name", s[s.length - 1].trim());
                                }


                                String[] s1 = ProfileFragment.et_rate.getText().toString().trim().split("/");
                                map.put("rate", ((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(ProfileFragment.et_rate.getText().toString().trim()));
                                map.put("experience_id", EXPERIENCE_ID + "");
                                map.put("keywords", selectedKeyword);
                                map.put("qualifications", selectedQualifications);
                                map.put("certifications", selectedCertifications);
                                map.put("skills", selectedSkills);
                                map.put("industry_focus", industryfocus.getText().toString().trim());
                                map.put("startup_stage", PREFERRED_STARTUP_ID + "");
                                map.put("contributor_type", CONTRACTOR_ID + "");
                                map.put("accredited_investor", ACCREDETED_INVESTER + "");
                                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                    saveProfile(map, Constants.CONTRACTOR_EDIT_PROFESSIONAL_PROFILE_URL);
                                } else {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                }
                            }
                        } else {
                            HashMap<String, String> map = new HashMap<String, String>();
                            map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            String name = ProfileFragment.et_username.getText().toString().trim();
                            String[] s = ProfileFragment.et_username.getText().toString().trim().split(" ");

                            if (s.length==1){
                                map.put("first_name", s[0].trim());
                                map.put("last_name", "");
                            }else{
                                map.put("first_name", name.substring(0, name.lastIndexOf(" ")));
                                map.put("last_name", s[s.length - 1].trim());
                            }
                            String[] s1 = ProfileFragment.et_rate.getText().toString().trim().split("/");
                            map.put("rate", ((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(ProfileFragment.et_rate.getText().toString().trim()));
                            map.put("experience_id", EXPERIENCE_ID + "");
                            map.put("keywords", selectedKeyword);
                            map.put("qualifications", selectedQualifications);
                            map.put("certifications", selectedCertifications);
                            map.put("skills", selectedSkills);
                            map.put("industry_focus", industryfocus.getText().toString().trim());
                            map.put("startup_stage", PREFERRED_STARTUP_ID + "");
                            map.put("contributor_type", CONTRACTOR_ID + "");
                            map.put("accredited_investor", ACCREDETED_INVESTER + "");
                            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                saveProfile(map, Constants.CONTRACTOR_EDIT_PROFESSIONAL_PROFILE_URL);
                            } else {
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        }
                    }
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void saveProfile(final HashMap<String, String> map, final String editUrl) {

        try {
            System.out.println(map);
            new AsyncTask<Void, Void, String>() {

                ProgressDialog pd;

                @Override
                protected void onPreExecute() {
                    // TODO Auto-generated method stub
                    super.onPreExecute();
                    pd = new ProgressDialog(getActivity());
                    pd.setMessage(Html.fromHtml("<b>" + getString(R.string.please_wait) + "</b>"));
                    pd.setIndeterminate(true);
                    pd.setCancelable(false);
                    pd.setProgress(0);
                    pd.show();
                }

                @Override
                protected String doInBackground(Void... params) {
                    StringBuilder builder = new StringBuilder();

                    try {
                        HttpClient httpClient = ((HomeActivity) getActivity()).utilitiesClass.createHttpClient();
                        HttpContext localContext = new BasicHttpContext();
                        String url = Constants.APP_BASE_URL + editUrl;
                        HttpPost httpPost = new HttpPost(url);
                        MultipartEntity entity = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE);
                        System.out.println(url);

                        if (bitmap != null) {
                            ByteArrayOutputStream bos = new ByteArrayOutputStream();
                            File file = new File(filepath);
                            System.out.println(file);
                            ContentBody cbFile = new FileBody(file);
                            bitmap.compress(Bitmap.CompressFormat.JPEG, 0, bos);

                            entity.addPart("returnformat", new StringBody("json"));
                            entity.addPart("image", cbFile);

                            for (String key : map.keySet()) {
                                entity.addPart(key, new StringBody(map.get(key), "text/plain", Charset.forName("UTF-8")));
                            }
                        } else {
                            for (String key : map.keySet()) {
                                entity.addPart(key, new StringBody(map.get(key), "text/plain", Charset.forName("UTF-8")));
                            }
                        }
                        httpPost.setEntity(entity);
                        HttpResponse response = httpClient.execute(httpPost, localContext);
                        StatusLine statusLine = response.getStatusLine();
                        int statusCode = statusLine.getStatusCode();
                        System.out.println(statusCode + " neel");
                        if (statusCode == HttpURLConnection.HTTP_OK) {
                            BufferedReader reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), "UTF-8"));
                            String line;

                            while ((line = reader.readLine()) != null) {
                                builder.append(line);
                            }
                        } else if (statusCode == HttpURLConnection.HTTP_ENTITY_TOO_LARGE) {
                            JSONObject obj = new JSONObject();
                            obj.put("success", "false");
                            obj.put("message", "Invalid File Size!");

                            builder.append(obj.toString());
                        }
                        System.out.println(builder.toString());
                        //sResponse = builder.toString();
                    } catch (Exception e) {
                    }
                    return builder.toString();
                }

                @Override
                protected void onPostExecute(String result) {
                    super.onPostExecute(result);
                    pd.dismiss();
                    System.out.println(result);
                    if (result != null) {
                        try {
                            JSONObject obj = new JSONObject(result);

                            if (obj.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                                Toast.makeText(getActivity(), "Profile successfully updated.", Toast.LENGTH_SHORT).show();
                                if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.CONTRACTOR)) {





                                    if (!((HomeActivity) getActivity()).prefManager.getString(Constants.USER_PROFILE_IMAGE_URL).equalsIgnoreCase(obj.optString("image").trim())) {
                                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_PROFILE_IMAGE_URL, obj.optString("image").trim());
                                        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + obj.optString("image").trim(), HomeActivity.mUserImage, ((HomeActivity)getActivity()).options);
                                        /*ImageLoaderWithoutProgressBar imageLoader = new ImageLoaderWithoutProgressBar(getActivity());
                                        imageLoader.DisplayImage(Constants.APP_IMAGE_URL + obj.optString("image").trim(), HomeActivity.mUserImage, R.drawable.image);
    */
                                        /*try {
                                            Picasso.with(getActivity())
                                                    .load(Constants.APP_IMAGE_URL + obj.optString("image").trim())
                                                    .placeholder(R.drawable.image)
                                                    .error(R.drawable.app_icon)
                                                    .into(HomeActivity.mUserImage);
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }*/
                                    }


                                    if (Integer.parseInt(obj.optString("profile_completeness").trim())==0){
                                        ProfileFragment.progressProfileComplete.setProgress(0);
                                        ProfileFragment.tv_profileComplete.setText(ProfileFragment.progressProfileComplete.getProgress() + "% completed");
                                    }else{
                                        ProfileFragment.progressProfileComplete.setProgress(Integer.parseInt(obj.optString("profile_completeness").trim()));
                                        ProfileFragment.tv_profileComplete.setText(ProfileFragment.progressProfileComplete.getProgress() + "% completed");
                                    }

                                    String name = ProfileFragment.et_username.getText().toString().trim();
                                    String[] s = ProfileFragment.et_username.getText().toString().trim().split(" ");



                                    if (s.length==1){
                                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_FIRST_NAME, s[0].trim());
                                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_LAST_NAME, "");
                                    }else{
                                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_FIRST_NAME,name.substring(0, name.lastIndexOf(" ")));
                                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_LAST_NAME, s[s.length - 1].trim());
                                    }


                                    HomeActivity.userName.setText(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_FIRST_NAME) + " " + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_LAST_NAME));



                                   /* ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_PROFILE_IMAGE_URL, obj.optString("image").trim());
                                    try {
                                        Picasso.with(getActivity())
                                                .load(Constants.APP_IMAGE_URL + obj.optString("image").trim())
                                                .placeholder(R.drawable.image)
                                                .error(R.drawable.app_icon)
                                                .into(HomeActivity.mUserImage);
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }*/
                                    String rate = ProfileFragment.et_rate.getText().toString().trim();
                                    ProfileFragment.et_rate.setText("$" + ((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(rate) + "/HR");
                                } else {
                                    if (Integer.parseInt(obj.optString("profile_completeness").trim())==0){
                                        EntrepreneurProfileFragment.progressProfileComplete.setProgress(0);
                                        EntrepreneurProfileFragment.tv_profileComplete.setText(EntrepreneurProfileFragment.progressProfileComplete.getProgress() + "% completed");


                                    }else{
                                        EntrepreneurProfileFragment.progressProfileComplete.setProgress(Integer.parseInt(obj.optString("profile_completeness").trim()));
                                        EntrepreneurProfileFragment.tv_profileComplete.setText(EntrepreneurProfileFragment.progressProfileComplete.getProgress() + "% completed");
                                    }
                                }
                            } else if (obj.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                                Toast.makeText(getActivity(), "Error", Toast.LENGTH_SHORT).show();
                                if (!obj.optJSONObject("errors").optString("bio").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton("Bio field is required!");
                                }else if (!obj.optJSONObject("errors").optString("last_name").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(obj.optJSONObject("errors").optString("last_name"));
                                }else if (!obj.optJSONObject("errors").optString("first_name").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(obj.optJSONObject("errors").optString("first_name"));
                                }else if (!obj.optJSONObject("errors").optString("date_of_birth").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton("Date-of-Birth is required!");
                                }else if (!obj.optJSONObject("errors").optString("country_id").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton("Country is required!");
                                }else if (!obj.optJSONObject("errors").optString("state_id").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton("State is required!");
                                }else if (!obj.optJSONObject("errors").optString("phoneno").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(obj.optJSONObject("errors").optString("phoneno"));
                                }else if (!obj.optJSONObject("errors").optString("price").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton("Rate is required!");
                                }else if (!obj.optJSONObject("errors").optString("industry_focus").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(obj.optJSONObject("errors").optString("industry_focus"));
                                }
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    } else {
                        Toast.makeText(getActivity(), "No response found", Toast.LENGTH_SHORT).show();
                    }
                }
            }.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onTaskComplete(String result, String tag) {
        try {
            if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
                ((HomeActivity)getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
            } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
                ((HomeActivity)getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
            } else {
                if (tag.equalsIgnoreCase(Constants.SKILLS_QUALIFICATIONS_KEYWORDS_EXPERIENCE_CONTRACTORTYPE_PREFEREDSTARTUP_CERTIFICATIONS_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {
                            if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                                skillsList.clear();
                                for (int i = 0; i < jsonObject.optJSONArray("skills").length(); i++) {
                                    GenericObject obj = new GenericObject();
                                    obj.setId(jsonObject.optJSONArray("skills").getJSONObject(i).optString("id"));
                                    obj.setTitle(jsonObject.optJSONArray("skills").getJSONObject(i).optString("name"));
                                    skillsList.add(obj);
                                }


                                qualificationList.clear();
                                for (int i = 0; i < jsonObject.optJSONArray("qualifications").length(); i++) {
                                    GenericObject obj = new GenericObject();
                                    obj.setId(jsonObject.optJSONArray("qualifications").getJSONObject(i).optString("id"));
                                    obj.setTitle(jsonObject.optJSONArray("qualifications").getJSONObject(i).optString("name"));
                                    qualificationList.add(obj);
                                }


                                preferedstartupList.clear();
                                for (int i = 0; i < jsonObject.optJSONArray("prefferStartups").length(); i++) {
                                    GenericObject obj = new GenericObject();
                                    obj.setId(jsonObject.optJSONArray("prefferStartups").getJSONObject(i).optString("id"));
                                    obj.setTitle(jsonObject.optJSONArray("prefferStartups").getJSONObject(i).optString("name"));
                                    preferedstartupList.add(obj);
                                }

                                keywordsList.clear();
                                for (int i = 0; i < jsonObject.optJSONArray("keywords").length(); i++) {
                                    GenericObject obj = new GenericObject();
                                    obj.setId(jsonObject.optJSONArray("keywords").getJSONObject(i).optString("id"));
                                    obj.setTitle(jsonObject.optJSONArray("keywords").getJSONObject(i).optString("name"));
                                    keywordsList.add(obj);
                                }

                                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ENTREPRENEUR_PROFESSIONAL_PROFILE_TAG, Constants.ENTREPRENEUR_PROFESSIONAL_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+ "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                    a.execute();
                                    ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                                } else {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                }
                            } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                                //experience.setAdapter(new SpinnerAdapter(getActivity(), 0, experienceList));
                                //preferedstartup.setAdapter(new SpinnerAdapter(getActivity(), 0, preferedstartupList));
                                //contributoTypeSpinner.setAdapter(new SpinnerAdapter(getActivity(), 0, contributorTypeList));
                            }


                        } else if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.CONTRACTOR)) {//contractor profile
                            if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                                experienceList.clear();
                                GenericObject selectExperience = new GenericObject();
                                selectExperience.setId("0");
                                selectExperience.setTitle("Select Experience");
                                experienceList.add(selectExperience);
                                for (int i = 0; i < jsonObject.optJSONArray("experiences").length(); i++) {
                                    GenericObject obj = new GenericObject();
                                    obj.setId(jsonObject.optJSONArray("experiences").getJSONObject(i).optString("id"));
                                    obj.setTitle(jsonObject.optJSONArray("experiences").getJSONObject(i).optString("name"));
                                    experienceList.add(obj);
                                }
                                experienceListAdapter = new SpinnerAdapter(getActivity(), 0, experienceList);
                                experience.setAdapter(experienceListAdapter);


//                                preferedstartupList.clear();
//                                GenericObject selectpreferedstartup = new GenericObject();
//                                selectpreferedstartup.setId("0");
//                                selectpreferedstartup.setTitle("Select Preferred Startup Stage");
//                                preferedstartupList.add(selectpreferedstartup);
//
//                                for (int i = 0; i < jsonObject.optJSONArray("prefferStartups").length(); i++) {
//                                    GenericObject obj = new GenericObject();
//                                    obj.setId(jsonObject.optJSONArray("prefferStartups").getJSONObject(i).optString("id"));
//                                    obj.setTitle(jsonObject.optJSONArray("prefferStartups").getJSONObject(i).optString("name"));
//                                    preferedstartupList.add(obj);
//                                }
//


                                contributorTypeList.clear();
                                GenericObject selectcontributorType = new GenericObject();
                                selectcontributorType.setId("0");
                                selectcontributorType.setTitle("Select Contractor Type");
                                contributorTypeList.add(selectcontributorType);

                                for (int i = 0; i < jsonObject.optJSONArray("contractorTypes").length(); i++) {
                                    GenericObject obj = new GenericObject();
                                    obj.setId(jsonObject.optJSONArray("contractorTypes").getJSONObject(i).optString("id"));
                                    obj.setTitle(jsonObject.optJSONArray("contractorTypes").getJSONObject(i).optString("name"));
                                    contributorTypeList.add(obj);
                                }
                                contributorTypeListAdapter = new SpinnerAdapter(getActivity(), 0, contributorTypeList);
                                contributoTypeSpinner.setAdapter(contributorTypeListAdapter);

                                skillsList.clear();
                                for (int i = 0; i < jsonObject.optJSONArray("skills").length(); i++) {
                                    GenericObject obj = new GenericObject();
                                    obj.setId(jsonObject.optJSONArray("skills").getJSONObject(i).optString("id"));
                                    obj.setTitle(jsonObject.optJSONArray("skills").getJSONObject(i).optString("name"));
                                    skillsList.add(obj);
                                }
                                certificationList.clear();
                                for (int i = 0; i < jsonObject.optJSONArray("certifications").length(); i++) {
                                    GenericObject obj = new GenericObject();
                                    obj.setId(jsonObject.optJSONArray("certifications").getJSONObject(i).optString("id"));
                                    obj.setTitle(jsonObject.optJSONArray("certifications").getJSONObject(i).optString("name"));
                                    certificationList.add(obj);
                                }

                                qualificationList.clear();
                                for (int i = 0; i < jsonObject.optJSONArray("qualifications").length(); i++) {
                                    GenericObject obj = new GenericObject();
                                    obj.setId(jsonObject.optJSONArray("qualifications").getJSONObject(i).optString("id"));
                                    obj.setTitle(jsonObject.optJSONArray("qualifications").getJSONObject(i).optString("name"));
                                    qualificationList.add(obj);
                                }

                                preferedstartupList.clear();
                                for (int i = 0; i < jsonObject.optJSONArray("prefferStartups").length(); i++) {
                                    GenericObject obj = new GenericObject();
                                    obj.setId(jsonObject.optJSONArray("prefferStartups").getJSONObject(i).optString("id"));
                                    obj.setTitle(jsonObject.optJSONArray("prefferStartups").getJSONObject(i).optString("name"));
                                    preferedstartupList.add(obj);
                                }

                                keywordsList.clear();
                                for (int i = 0; i < jsonObject.optJSONArray("keywords").length(); i++) {
                                    GenericObject obj = new GenericObject();
                                    obj.setId(jsonObject.optJSONArray("keywords").getJSONObject(i).optString("id"));
                                    obj.setTitle(jsonObject.optJSONArray("keywords").getJSONObject(i).optString("name"));
                                    keywordsList.add(obj);
                                }
                                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONTRACTOR_PROFESSIONAL_PROFILE_TAG, Constants.CONTRACTOR_PROFESSIONAL_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+ "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                    a.execute();
                                    ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                                } else {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                }

                            } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                                experience.setAdapter(new SpinnerAdapter(getActivity(), 0, experienceList));
                                //preferedstartup.setAdapter(new SpinnerAdapter(getActivity(), 0, preferedstartupList));
                                contributoTypeSpinner.setAdapter(new SpinnerAdapter(getActivity(), 0, contributorTypeList));
                            }
                        }
                    } catch (JSONException e) {
                        ((HomeActivity)getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.CONTRACTOR_PROFESSIONAL_PROFILE_TAG)) {

                    selectedKeywordList.clear();
                    selectedCertificationsList.clear();
                    selectedKeywordList.clear();
                    selectedQualificationsList.clear();
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            if (jsonObject.optString("perhour_rate").trim().length() == 0) {
                                ProfileFragment.et_rate.setText("$0.00/HR");
                            } else {
                                ProfileFragment.et_rate.setText("$" + ((HomeActivity)getActivity()).utilitiesClass.extractFloatValueFromStrin(jsonObject.optString("perhour_rate")) + "/HR");
                            }

                            ProfileFragment.et_username.setText(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_FIRST_NAME) + " " + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_LAST_NAME));
                            // ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_PROFILE_IMAGE_URL, jsonObject.optString("profile_image").trim());

                            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image"), ProfileFragment.circularImageView, ((HomeActivity)getActivity()).options);
                            /*ImageLoaderWithoutProgressBar imageLoader = new ImageLoaderWithoutProgressBar(getActivity());
                            imageLoader.DisplayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image"), ProfileFragment.circularImageView, R.drawable.image);*/

                            if (Integer.parseInt(jsonObject.optString("profile_completeness").trim())==0){
                                ProfileFragment.progressProfileComplete.setProgress(0);
                                ProfileFragment.tv_profileComplete.setText(ProfileFragment.progressProfileComplete.getProgress() + "% completed");
                            }else{
                                ProfileFragment.progressProfileComplete.setProgress(Integer.parseInt(jsonObject.optString("profile_completeness").trim()));
                                ProfileFragment.tv_profileComplete.setText(ProfileFragment.progressProfileComplete.getProgress() + "% completed");
                            }

                            if (!((HomeActivity) getActivity()).prefManager.getString(Constants.USER_PROFILE_IMAGE_URL).equalsIgnoreCase(jsonObject.optString("profile_image").trim())) {
                                ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_PROFILE_IMAGE_URL, jsonObject.optString("profile_image").trim());

                                ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), HomeActivity.mUserImage, ((HomeActivity)getActivity()).options);
                                /*imageLoader = new ImageLoaderWithoutProgressBar(getActivity());
                                imageLoader.DisplayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), HomeActivity.mUserImage, R.drawable.image);*/

                            }

                            JSONObject professional_information = jsonObject.optJSONObject("professional_information");
                            if (professional_information.length() > 0) {
                                if (professional_information.optString("experience_id").trim().length()==0){
                                    EXPERIENCE_ID=0;
                                }else{
                                    EXPERIENCE_ID = Integer.parseInt(professional_information.optString("experience_id"));

                                }
                                for (int position = 0; position < experienceListAdapter.getCount(); position++) {
                                    if (experienceListAdapter.getId(position).equalsIgnoreCase(EXPERIENCE_ID + "")) {
                                        experience.setSelection(position);
                                    }
                                }

                                if (professional_information.optString("contractor_type_id").trim().length()==0){
                                    CONTRACTOR_ID=0;
                                }else{
                                    CONTRACTOR_ID = Integer.parseInt(professional_information.optString("contractor_type_id"));
                                }

                                for (int position = 0; position < contributorTypeListAdapter.getCount(); position++) {
                                    if (contributorTypeListAdapter.getId(position).equalsIgnoreCase(CONTRACTOR_ID + "")) {
                                        contributoTypeSpinner.setSelection(position);
                                    }
                                }
                               /* if (professional_information.optString("preferred_startup_id").trim().length()==0){
                                    PREFERRED_STARTUP_ID=0;
                                }else{
                                    PREFERRED_STARTUP_ID = Integer.parseInt(professional_information.optString("preferred_startup_id"));
                                }
*/
                                /*for (int position = 0; position < preferedstartupListAdapter.getCount(); position++) {
                                    if (preferedstartupListAdapter.getId(position).equalsIgnoreCase(PREFERRED_STARTUP_ID + "")) {
                                        preferedstartup.setSelection(position);
                                    }
                                }*/
                                industryfocus.setText(professional_information.optString("industry_focus"));
                                ACCREDETED_INVESTER = Integer.parseInt(professional_information.optString("accredited_investor"));
                                System.out.println(ACCREDETED_INVESTER);
                                if (ACCREDETED_INVESTER == 0) {
                                    rb_AccreditedInvestor_no.setChecked(true);
                                } else {
                                    rb_AccreditedInvestor_yes.setChecked(true);
                                }

                                StringBuilder stringBuilder = new StringBuilder();
                                if (professional_information.has("keywords")){
                                    for (int i = 0; i < professional_information.optJSONArray("keywords").length(); i++) {
                                        //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                        if((i >= 0) && ( i < (professional_information.optJSONArray("keywords").length() - 1) )){
                                            stringBuilder.append(professional_information.optJSONArray("keywords").getJSONObject(i).optString("name") + ", ");
                                        }

                                        else {
                                            stringBuilder.append(professional_information.optJSONArray("keywords").getJSONObject(i).optString("name") + " ");
                                        }

                                        GenericObject obj = new GenericObject();

                                        obj.setId(professional_information.optJSONArray("keywords").getJSONObject(i).optString("id"));
                                        obj.setTitle(professional_information.optJSONArray("keywords").getJSONObject(i).optString("name"));

                                        for (int j = 0; j < keywordsList.size(); j++) {
                                            if (keywordsList.get(j).getId().equalsIgnoreCase(obj.getId())) {
                                                keywordsList.get(j).setIschecked(true);
                                            }
                                        }
                                    }
                                    keyword.setText(stringBuilder.toString());
                                }


                                stringBuilder = new StringBuilder();
                                if (professional_information.has("qualifications")){
                                    for (int i = 0; i < professional_information.optJSONArray("qualifications").length(); i++) {
                                        //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                        if((i >= 0) && ( i < (professional_information.optJSONArray("qualifications").length() - 1) )){
                                            stringBuilder.append(professional_information.optJSONArray("qualifications").getJSONObject(i).optString("name") + ", ");

                                        }
                                        else {
                                            stringBuilder.append(professional_information.optJSONArray("qualifications").getJSONObject(i).optString("name") + " ");
                                        }
                                        GenericObject obj = new GenericObject();
                                        obj.setId(professional_information.optJSONArray("qualifications").getJSONObject(i).optString("id"));
                                        obj.setTitle(professional_information.optJSONArray("qualifications").getJSONObject(i).optString("name"));
                                        for (int j = 0; j < qualificationList.size(); j++) {
                                            if (qualificationList.get(j).getId().equalsIgnoreCase(obj.getId())) {
                                                qualificationList.get(j).setIschecked(true);
                                            }
                                        }
                                    }
                                    qualification.setText(stringBuilder.toString());
                                }
//+++++++++++++++++++++++CHANGE+++++++++++++++++

                                stringBuilder = new StringBuilder();
                                if (professional_information.has("preferred_startup")){
                                    for (int i = 0; i < professional_information.optJSONArray("preferred_startup").length(); i++) {
                                        //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);

                                        if((i >= 0) && ( i < (professional_information.optJSONArray("preferred_startup").length() - 1) )){
                                            stringBuilder.append(professional_information.optJSONArray("preferred_startup").getJSONObject(i).optString("name") + ", ");
                                        }else {
                                            stringBuilder.append(professional_information.optJSONArray("preferred_startup").getJSONObject(i).optString("name") + " ");
                                        }
                                        GenericObject obj = new GenericObject();
                                        obj.setId(professional_information.optJSONArray("preferred_startup").getJSONObject(i).optString("id"));
                                        obj.setTitle(professional_information.optJSONArray("preferred_startup").getJSONObject(i).optString("name"));
                                        for (int j = 0; j < preferedstartupList.size(); j++) {
                                            if (preferedstartupList.get(j).getId().equalsIgnoreCase(obj.getId())) {
                                                preferedstartupList.get(j).setIschecked(true);
                                            }
                                        }
                                    }
                                    preferedstartup.setText(stringBuilder.toString());
                                }

                                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                                stringBuilder = new StringBuilder();
                                if (professional_information.has("certifications")){
                                    for (int i = 0; i < professional_information.optJSONArray("certifications").length(); i++) {
                                        //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);

                                        if((i >= 0) && ( i < (professional_information.optJSONArray("certifications").length() - 1) )){
                                            stringBuilder.append(professional_information.optJSONArray("certifications").getJSONObject(i).optString("name") + ", ");

                                        }
                                        else {
                                            stringBuilder.append(professional_information.optJSONArray("certifications").getJSONObject(i).optString("name") + " ");
                                        }
                                        GenericObject obj = new GenericObject();
                                        obj.setId(professional_information.optJSONArray("certifications").getJSONObject(i).optString("id"));
                                        obj.setTitle(professional_information.optJSONArray("certifications").getJSONObject(i).optString("name"));
                                        for (int j = 0; j < certificationList.size(); j++) {
                                            if (certificationList.get(j).getId().equalsIgnoreCase(obj.getId())) {
                                                certificationList.get(j).setIschecked(true);
                                            }
                                        }
                                    }
                                    certification.setText(stringBuilder.toString());
                                }


                                stringBuilder = new StringBuilder();
                                if (professional_information.has("skills")){
                                    for (int i = 0; i < professional_information.optJSONArray("skills").length(); i++) {
                                        //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                        if((i >= 0) && ( i < (professional_information.optJSONArray("skills").length() - 1) )){
                                            stringBuilder.append(professional_information.optJSONArray("skills").getJSONObject(i).optString("name") + ", ");
                                        }else {
                                            stringBuilder.append(professional_information.optJSONArray("skills").getJSONObject(i).optString("name") + " ");
                                        }
                                        GenericObject obj = new GenericObject();
                                        obj.setId(professional_information.optJSONArray("skills").getJSONObject(i).optString("id"));
                                        obj.setTitle(professional_information.optJSONArray("skills").getJSONObject(i).optString("name"));
                                        for (int j = 0; j < skillsList.size(); j++) {
                                            if (skillsList.get(j).getId().equalsIgnoreCase(obj.getId())) {
                                                skillsList.get(j).setIschecked(true);
                                            }
                                        }
                                    }
                                    skills.setText( stringBuilder.toString());
                                }



                                StringBuilder selectedKeywordsId = new StringBuilder();
                                for (int i = 0; i < certificationList.size(); i++) {
                                    if (certificationList.get(i).ischecked()) {
                                        selectedCertificationsList.add(certificationList.get(i).getId());
                                    }
                                }

                                for (int i = 0; i < selectedCertificationsList.size(); i++) {
                                    if (selectedKeywordsId.length() > 0) {
                                        selectedKeywordsId.append(",");
                                    }
                                    selectedKeywordsId.append(selectedCertificationsList.get(i));
                                }
                                selectedCertifications = selectedKeywordsId.toString();
                                System.out.println(selectedCertifications.toString() + "-------------------------");


                                //keywords
                                selectedKeywordsId = new StringBuilder();
                                for (int i = 0; i < keywordsList.size(); i++) {
                                    if (keywordsList.get(i).ischecked()) {
                                        selectedKeywordList.add(keywordsList.get(i).getId());
                                    }
                                }

                                for (int i = 0; i < selectedKeywordList.size(); i++) {
                                    if (selectedKeywordsId.length() > 0) {
                                        selectedKeywordsId.append(",");
                                    }
                                    selectedKeywordsId.append(selectedKeywordList.get(i));
                                }
                                selectedKeyword = selectedKeywordsId.toString();
                                System.out.println(selectedKeyword.toString() + "-------------------------");

                                //skills
                                selectedKeywordsId = new StringBuilder();
                                for (int i = 0; i < skillsList.size(); i++) {
                                    if (skillsList.get(i).ischecked()) {
                                        selectedSkillsList.add(skillsList.get(i).getId());
                                    }
                                }

                                for (int i = 0; i < selectedSkillsList.size(); i++) {
                                    if (selectedKeywordsId.length() > 0) {
                                        selectedKeywordsId.append(",");
                                    }
                                    selectedKeywordsId.append(selectedSkillsList.get(i));
                                }
                                selectedSkills = selectedKeywordsId.toString();
                                System.out.println(selectedSkills.toString() + "-------------------------");




                                //startup stage
                                selectedKeywordsId = new StringBuilder();
                                for (int i = 0; i < preferedstartupList.size(); i++) {
                                    if (preferedstartupList.get(i).ischecked()) {
                                        selectedPreferedStartupStageList.add(preferedstartupList.get(i).getId());
                                    }
                                }

                                for (int i = 0; i < selectedPreferedStartupStageList.size(); i++) {
                                    if (selectedKeywordsId.length() > 0) {
                                        selectedKeywordsId.append(",");
                                    }
                                    selectedKeywordsId.append(selectedPreferedStartupStageList.get(i));
                                }
                                selectedPreferedStartups = selectedKeywordsId.toString();
                                System.out.println(selectedPreferedStartups.toString() + "-------------------------");


                                //qualifications
                                selectedKeywordsId = new StringBuilder();
                                for (int i = 0; i < qualificationList.size(); i++) {
                                    if (qualificationList.get(i).ischecked()) {
                                        selectedQualificationsList.add(qualificationList.get(i).getId());
                                    }
                                }

                                for (int i = 0; i < selectedQualificationsList.size(); i++) {
                                    if (selectedKeywordsId.length() > 0) {
                                        selectedKeywordsId.append(",");
                                    }
                                    selectedKeywordsId.append(selectedQualificationsList.get(i));
                                }
                                selectedQualifications = selectedKeywordsId.toString();
                                System.out.println(selectedQualifications.toString() + "-------------------------");


                            } else {
                                for (int j = 0; j < keywordsList.size(); j++) {
                                    keywordsList.get(j).setIschecked(false);
                                }
                                for (int j = 0; j < skillsList.size(); j++) {
                                    skillsList.get(j).setIschecked(false);
                                }
                                for (int j = 0; j < certificationList.size(); j++) {
                                    certificationList.get(j).setIschecked(false);
                                }
                                for (int j = 0; j < qualificationList.size(); j++) {
                                    qualificationList.get(j).setIschecked(false);
                                }
                                for (int j = 0; j < preferedstartupList.size(); j++) {
                                    preferedstartupList.get(j).setIschecked(false);
                                }
                                keyword.setText("");
                                skills.setText("");
                                certification.setText("");
                                qualification.setText("");
                                industryfocus.setText("");
                                preferedstartup.setText("");
                                if (ACCREDETED_INVESTER == 0) {
                                    rb_AccreditedInvestor_no.setChecked(true);
                                } else {
                                    rb_AccreditedInvestor_yes.setChecked(true);
                                }
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }

                        ((HomeActivity)getActivity()).dismissProgressDialog();
                    } catch (JSONException e) {
                        ((HomeActivity)getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.ENTREPRENEUR_PROFESSIONAL_PROFILE_TAG)) {
                    try {


                        selectedKeywordList.clear();
                        selectedKeywordList.clear();
                        selectedQualificationsList.clear();

                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            EntrepreneurProfileFragment.et_username.setText(jsonObject.optString("name"));
                            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image"), EntrepreneurProfileFragment.circularImageView, ((HomeActivity)getActivity()).options);
                            /*ImageLoaderWithoutProgressBar imageLoader = new ImageLoaderWithoutProgressBar(getActivity());
                            imageLoader.DisplayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image"), EntrepreneurProfileFragment.circularImageView, R.drawable.image);*/

                            if (Integer.parseInt(jsonObject.optString("profile_completeness").trim())==0){
                                EntrepreneurProfileFragment.progressProfileComplete.setProgress(0);
                                EntrepreneurProfileFragment.tv_profileComplete.setText(EntrepreneurProfileFragment.progressProfileComplete.getProgress() + "% completed");
                            }else{
                                EntrepreneurProfileFragment.progressProfileComplete.setProgress(Integer.parseInt(jsonObject.optString("profile_completeness").trim()));
                                EntrepreneurProfileFragment.tv_profileComplete.setText(EntrepreneurProfileFragment.progressProfileComplete.getProgress() + "% completed");
                            }
                            /*try {
                                Picasso.with(getActivity())
                                        .load(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image"))
                                        .placeholder(R.drawable.image)
                                        .error(R.drawable.app_icon)
                                        .into(EntrepreneurProfileFragment.circularImageView);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }*/

                            JSONObject professional_information = jsonObject.optJSONObject("professional_information");
                            if (professional_information.length() > 0) {


                                companyName.setText(professional_information.optString("compnay_name").trim());
                                industryfocus.setText(professional_information.optString("industry_focus"));
                                companyUrl.setText(professional_information.optString("website_link"));
                                description.setBackgroundResource(R.drawable.multiline_textview);
                                description.setText(professional_information.optString("description"));
                                description.setOnTouchListener(new View.OnTouchListener() {
                                    @Override
                                    public boolean onTouch(View v, MotionEvent event) {
                                        if (v.getId() == R.id.startupdesc) {
                                            v.getParent().requestDisallowInterceptTouchEvent(true);
                                            switch (event.getAction() & MotionEvent.ACTION_MASK) {
                                                case MotionEvent.ACTION_UP:
                                                    v.getParent().requestDisallowInterceptTouchEvent(false);
                                                    break;
                                            }
                                        }
                                        return false;
                                    }
                                });
                                StringBuilder stringBuilder = new StringBuilder();
                                if (professional_information.has("keywords")){
                                    for (int i = 0; i < professional_information.optJSONArray("keywords").length(); i++) {
                                        //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                        if((i >= 0) && ( i < (professional_information.optJSONArray("keywords").length() - 1) )){
                                            stringBuilder.append(professional_information.optJSONArray("keywords").getJSONObject(i).optString("name") + ", ");

                                        }
                                        else {
                                            stringBuilder.append(professional_information.optJSONArray("keywords").getJSONObject(i).optString("name") + " ");
                                        }
                                        GenericObject obj = new GenericObject();

                                        obj.setId(professional_information.optJSONArray("keywords").getJSONObject(i).optString("id"));
                                        obj.setTitle(professional_information.optJSONArray("keywords").getJSONObject(i).optString("name"));

                                        for (int j = 0; j < keywordsList.size(); j++) {
                                            if (keywordsList.get(j).getId().equalsIgnoreCase(obj.getId())) {
                                                keywordsList.get(j).setIschecked(true);
                                            }
                                        }
                                        //selectedkeywordsList.add(obj);
                                    }
                                    keyword.setText(stringBuilder.toString());
                                }


                                stringBuilder = new StringBuilder();
                                if (professional_information.has("skills")){
                                    for (int i = 0; i < professional_information.optJSONArray("skills").length(); i++) {
                                        //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                        if((i >= 0) && ( i < (professional_information.optJSONArray("skills").length() - 1) )){
                                            stringBuilder.append(professional_information.optJSONArray("skills").getJSONObject(i).optString("name") + ", ");
                                        }
                                        else {
                                            stringBuilder.append(professional_information.optJSONArray("skills").getJSONObject(i).optString("name") + " ");
                                        }
                                        GenericObject obj = new GenericObject();
                                        obj.setId(professional_information.optJSONArray("skills").getJSONObject(i).optString("id"));
                                        obj.setTitle(professional_information.optJSONArray("skills").getJSONObject(i).optString("name"));
                                        for (int j = 0; j < skillsList.size(); j++) {
                                            if (skillsList.get(j).getId().equalsIgnoreCase(obj.getId())) {
                                                skillsList.get(j).setIschecked(true);
                                            }
                                        }
                                        // selectedskillsList.add(obj);
                                    }
                                    skills.setText(stringBuilder.toString());
                                }


                                stringBuilder = new StringBuilder();
                                if (professional_information.has("qualifications")){
                                    for (int i = 0; i < professional_information.optJSONArray("qualifications").length(); i++) {
                                        //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                        if((i >= 0) && ( i < (professional_information.optJSONArray("qualifications").length() - 1) )){
                                            stringBuilder.append(professional_information.optJSONArray("qualifications").getJSONObject(i).optString("name") + ", ");
                                        }
                                        else {
                                            stringBuilder.append(professional_information.optJSONArray("qualifications").getJSONObject(i).optString("name") + " ");
                                        }
                                        GenericObject obj = new GenericObject();
                                        obj.setId(professional_information.optJSONArray("qualifications").getJSONObject(i).optString("id"));
                                        obj.setTitle(professional_information.optJSONArray("qualifications").getJSONObject(i).optString("name"));
                                        for (int j = 0; j < qualificationList.size(); j++) {
                                            if (qualificationList.get(j).getId().equalsIgnoreCase(obj.getId())) {
                                                qualificationList.get(j).setIschecked(true);
                                            }
                                        }
                                        //selectedqualificationList.add(obj);
                                    }
                                    qualification.setText(stringBuilder.toString());
                                }



                                //+++++++++++++++++++CHENGE++++++++++++++++++++++++++++++

                                stringBuilder = new StringBuilder();
                                if (professional_information.has("preferred_startup")){
                                    for (int i = 0; i < professional_information.optJSONArray("preferred_startup").length(); i++) {
                                        //JSONObject inner = professional_information.optJSONArray("keywords").getJSONObject(i);
                                        if((i >= 0) && ( i < (professional_information.optJSONArray("preferred_startup").length() - 1) )){
                                            stringBuilder.append(professional_information.optJSONArray("preferred_startup").getJSONObject(i).optString("name") + ", ");
                                        }
                                        else {
                                            stringBuilder.append(professional_information.optJSONArray("preferred_startup").getJSONObject(i).optString("name") + " ");
                                        }
                                        GenericObject obj = new GenericObject();
                                        obj.setId(professional_information.optJSONArray("preferred_startup").getJSONObject(i).optString("id"));
                                        obj.setTitle(professional_information.optJSONArray("preferred_startup").getJSONObject(i).optString("name"));
                                        for (int j = 0; j < preferedstartupList.size(); j++) {
                                            if (preferedstartupList.get(j).getId().equalsIgnoreCase(obj.getId())) {
                                                preferedstartupList.get(j).setIschecked(true);
                                            }
                                        }
                                        //selectedqualificationList.add(obj);
                                    }
                                    qualification.setText(stringBuilder.toString());
                                }




                                //+++++++++++++++++++++++++++++++++++++++++++++++++++++++

                                //keywords
                                StringBuilder selectedKeywordsId = new StringBuilder();
                                for (int i = 0; i < keywordsList.size(); i++) {
                                    if (keywordsList.get(i).ischecked()) {
                                        selectedKeywordList.add(keywordsList.get(i).getId());
                                    }
                                }

                                for (int i = 0; i < selectedKeywordList.size(); i++) {
                                    if (selectedKeywordsId.length() > 0) {
                                        selectedKeywordsId.append(",");
                                    }
                                    selectedKeywordsId.append(selectedKeywordList.get(i));
                                }
                                selectedKeyword = selectedKeywordsId.toString();
                                System.out.println(selectedKeyword.toString() + "-------------------------");

                                //skills
                                selectedKeywordsId = new StringBuilder();
                                for (int i = 0; i < skillsList.size(); i++) {
                                    if (skillsList.get(i).ischecked()) {
                                        selectedSkillsList.add(skillsList.get(i).getId());
                                    }
                                }
                                for (int i = 0; i < selectedSkillsList.size(); i++) {
                                    if (selectedKeywordsId.length() > 0) {
                                        selectedKeywordsId.append(",");
                                    }
                                    selectedKeywordsId.append(selectedSkillsList.get(i));
                                }
                                selectedSkills = selectedKeywordsId.toString();
                                System.out.println(selectedSkills.toString() + "-------------------------");

                                //qualifications
                                selectedKeywordsId = new StringBuilder();
                                for (int i = 0; i < qualificationList.size(); i++) {
                                    if (qualificationList.get(i).ischecked()) {
                                        selectedQualificationsList.add(qualificationList.get(i).getId());
                                    }
                                }

                                for (int i = 0; i < selectedQualificationsList.size(); i++) {
                                    if (selectedKeywordsId.length() > 0) {
                                        selectedKeywordsId.append(",");
                                    }
                                    selectedKeywordsId.append(selectedQualificationsList.get(i));
                                }
                                selectedQualifications = selectedKeywordsId.toString();
                                System.out.println(selectedQualifications.toString() + "-------------------------");

                            } else {

                                for (int j = 0; j < keywordsList.size(); j++) {
                                    keywordsList.get(j).setIschecked(false);
                                }
                                for (int j = 0; j < skillsList.size(); j++) {
                                    skillsList.get(j).setIschecked(false);
                                }

                                for (int j = 0; j < qualificationList.size(); j++) {
                                    qualificationList.get(j).setIschecked(false);
                                }


                                keyword.setText("");
                                qualification.setText("");
                                skills.setText("");
                            }
                        }
                        ((HomeActivity)getActivity()).dismissProgressDialog();
                    } catch (JSONException e) {
                        ((HomeActivity)getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                }else{
                    ((HomeActivity)getActivity()).dismissProgressDialog();
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void SetFilename(String filename, Bitmap bitmap) {
        try {
            filepath = filename;
            this.bitmap = bitmap;
            Log.d("file path", filename);
        } catch (Exception e) {
            e.printStackTrace();
        }



    }


}