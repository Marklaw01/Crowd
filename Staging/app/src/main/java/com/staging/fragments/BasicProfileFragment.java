package com.staging.fragments;

import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Html;
import android.text.InputType;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.dropdownadapter.CountryAdapter;
import com.staging.dropdownadapter.StatesAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.models.CountryObject;
import com.staging.models.StatesObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.DateTimeFormatClass;
import com.staging.utilities.UsPhoneNumberFormatter;
import com.nostra13.universalimageloader.core.ImageLoader;

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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStreamReader;
import java.lang.ref.WeakReference;
import java.net.HttpURLConnection;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Locale;

/**
 * Created by sunakshi.gautam on 1/13/2016.
 */
public class BasicProfileFragment extends Fragment implements View.OnClickListener, AsyncTaskCompleteListener<String> {

   // private boolean isEditTextEnabled = false;
    private LinearLayout layout;
    private static int COUNTRY_ID;
    private Uri fileUri;
    private static int STATE_ID;
    CountryAdapter countryAdapter;
    StatesAdapter stateAdapter;

    private ArrayList<StatesObject> states;
    private ArrayList<CountryObject> countries;


    private boolean _hasLoadedOnce = false; // your boolean field
    private DatePickerDialog.OnDateSetListener date;
    private Calendar myCalendar;

    private EditText et_bio, et_name, et_email, et_dob, et_phone, et_myinterests;
    private Spinner countrySpinner, citySpinner/*, securityQuestionSpinner*/;
    private Button addContributor/*, rateContributor*/;
    private String filepath;
    private Bitmap bitmap;

    //ProgressDialog pd;

    private void updateLabel() {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat(Constants.DATE_FORMAT, Locale.US);

            et_dob.setText(sdf.format(myCalendar.getTime()));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        try {
            if (isVisibleToUser) {
                // we check that the fragment is becoming visible



                ((HomeActivity) getActivity()).setOnBackPressedListener(this);
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
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.GET_COUNTRIES_LIST_WITH_STATES_TAG, Constants.GET_COUNTRIES_LIST_WITH_STATES, Constants.HTTP_POST,"Home Activity");
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
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = null;

        try {
            if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {
                rootView = inflater.inflate(R.layout.fragment_entrepreneur_basic, container, false);
                layout = (LinearLayout) rootView.findViewById(R.id.layout);
                //countriesList = new ArrayList<GenericObject>();
                countries = new ArrayList<CountryObject>();
                states = new ArrayList<StatesObject>();
                //statesList = new ArrayList<GenericObject>();
                et_bio = (EditText) rootView.findViewById(R.id.et_bio);
                et_name = (EditText) rootView.findViewById(R.id.et_name);
                et_email = (EditText) rootView.findViewById(R.id.et_email);
                et_dob = (EditText) rootView.findViewById(R.id.et_dob);
                et_phone = (EditText) rootView.findViewById(R.id.et_phone);
                et_myinterests = (EditText) rootView.findViewById(R.id.et_myinterests);


                et_bio.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                et_name.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                et_email.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                et_dob.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                et_phone.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                et_myinterests.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);

                UsPhoneNumberFormatter addLineNumberFormatter = new UsPhoneNumberFormatter(
                        new WeakReference<EditText>(et_phone));
                et_phone.addTextChangedListener(addLineNumberFormatter);

                et_bio.setOnTouchListener(new View.OnTouchListener() {
                    @Override
                    public boolean onTouch(View v, MotionEvent event) {
                        if (v.getId() == R.id.et_bio) {
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

                countrySpinner = (Spinner) rootView.findViewById(R.id.country);
                citySpinner = (Spinner) rootView.findViewById(R.id.city);
                //securityQuestionSpinner = (Spinner) rootView.findViewById(R.id.securityquestion);
                addContributor = (Button) rootView.findViewById(R.id.addcontributor);
                //rateContributor = (Button) rootView.findViewById(R.id.ratecontributor);
                addContributor.setText(getString(R.string.submit));

                addContributor.setOnClickListener(this);
                //rateContributor.setOnClickListener(this);
                myCalendar = Calendar.getInstance();
                date = new DatePickerDialog.OnDateSetListener() {

                    @Override
                    public void onDateSet(DatePicker view, int year, int monthOfYear,
                                          int dayOfMonth) {

                        myCalendar.set(Calendar.YEAR, year);
                        myCalendar.set(Calendar.MONTH, monthOfYear);
                        myCalendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                        updateLabel();
                    }

                };


                countrySpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                    @Override
                    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                        COUNTRY_ID = Integer.parseInt(countries.get(position).getId());
                        //COUNTRY_ID = Integer.parseInt(countries.get(position).getId());

                        states = countries.get(position).getStatesObjects();
                        //Toast.makeText(getActivity(), "size" + states.size(), Toast.LENGTH_LONG).show();
                        stateAdapter = new StatesAdapter(getActivity(),0, states);
                        citySpinner.setAdapter(stateAdapter);

                        if (stateAdapter != null) {
                            for (int i = 0; i < stateAdapter.getCount(); i++) {
                                if (stateAdapter.getId(i).equalsIgnoreCase(STATE_ID + "")) {
                                    citySpinner.setSelection(i);
                                }
                            }
                        }
                    }

                    @Override
                    public void onNothingSelected(AdapterView<?> parent) {

                    }
                });

                citySpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                    @Override
                    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                        STATE_ID = Integer.parseInt(states.get(position).getId());

                    }

                    @Override
                    public void onNothingSelected(AdapterView<?> parent) {

                    }
                });

                et_dob.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        new DatePickerDialog(getActivity(), date, myCalendar
                                .get(Calendar.YEAR), myCalendar.get(Calendar.MONTH),
                                myCalendar.get(Calendar.DAY_OF_MONTH)).show();
                    }
                });
            } else {
                rootView = inflater.inflate(R.layout.fragment_basic, container, false);
                layout = (LinearLayout) rootView.findViewById(R.id.layout);
                countries = new ArrayList<CountryObject>();
                states = new ArrayList<StatesObject>();
                //countriesList = new ArrayList<GenericObject>();
                //statesList = new ArrayList<GenericObject>();
                et_bio = (EditText) rootView.findViewById(R.id.et_bio);
                et_name = (EditText) rootView.findViewById(R.id.et_name);
                et_email = (EditText) rootView.findViewById(R.id.et_email);
                et_dob = (EditText) rootView.findViewById(R.id.et_dob);
                et_phone = (EditText) rootView.findViewById(R.id.et_phone);
                //et_myinterests = (EditText) rootView.findViewById(R.id.et_myinterests);


                et_bio.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                et_name.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                et_email.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                et_dob.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                et_phone.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);


                UsPhoneNumberFormatter addLineNumberFormatter = new UsPhoneNumberFormatter(
                        new WeakReference<EditText>(et_phone));
                et_phone.addTextChangedListener(addLineNumberFormatter);


                countrySpinner = (Spinner) rootView.findViewById(R.id.country);
                citySpinner = (Spinner) rootView.findViewById(R.id.city);
                //securityQuestionSpinner = (Spinner) rootView.findViewById(R.id.securityquestion);
                addContributor = (Button) rootView.findViewById(R.id.addcontributor);
                //rateContributor = (Button) rootView.findViewById(R.id.ratecontributor);
                addContributor.setText(getString(R.string.submit));


                addContributor.setOnClickListener(this);
                //rateContributor.setOnClickListener(this);
                myCalendar = Calendar.getInstance();
                date = new DatePickerDialog.OnDateSetListener() {

                    @Override
                    public void onDateSet(DatePicker view, int year, int monthOfYear,
                                          int dayOfMonth) {

                        myCalendar.set(Calendar.YEAR, year);
                        myCalendar.set(Calendar.MONTH, monthOfYear);
                        myCalendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                        updateLabel();
                    }

                };

                countrySpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                    @Override
                    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                        COUNTRY_ID = Integer.parseInt(countries.get(position).getId());
                        //COUNTRY_ID = Integer.parseInt(countries.get(position).getId());

                        states = countries.get(position).getStatesObjects();
                        //Toast.makeText(getActivity(), "size" + states.size(), Toast.LENGTH_LONG).show();
                        stateAdapter = new StatesAdapter(getActivity(),0, states);
                        citySpinner.setAdapter(stateAdapter);

                        if (stateAdapter != null) {
                            for (int i = 0; i < stateAdapter.getCount(); i++) {
                                if (stateAdapter.getId(i).equalsIgnoreCase(STATE_ID + "")) {
                                    citySpinner.setSelection(i);
                                }
                            }
                        }
                    }

                    @Override
                    public void onNothingSelected(AdapterView<?> parent) {

                    }
                });

                citySpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                    @Override
                    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                        STATE_ID = Integer.parseInt(states.get(position).getId());

                    }

                    @Override
                    public void onNothingSelected(AdapterView<?> parent) {

                    }
                });

                et_dob.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        new DatePickerDialog(getActivity(), date, myCalendar
                                .get(Calendar.YEAR), myCalendar.get(Calendar.MONTH),
                                myCalendar.get(Calendar.DAY_OF_MONTH)).show();
                    }
                });


                et_bio.setOnTouchListener(new View.OnTouchListener() {
                    @Override
                    public boolean onTouch(View v, MotionEvent event) {
                        if (v.getId() == R.id.et_bio) {
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
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootView;
    }

    @Override
    public void onResume() {
        super.onResume();

    }

    @Override
    public void onClick(View v) {
        try {
            switch (v.getId()) {

                case R.id.addcontributor:
                    InputMethodManager inputMethodManager = (InputMethodManager)getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
                    inputMethodManager.hideSoftInputFromWindow(getActivity().getCurrentFocus().getWindowToken(), 0);
                    if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {

                        if (!et_dob.getText().toString().trim().isEmpty() && !DateTimeFormatClass.compareDates(DateTimeFormatClass.convertStringObjectToDate(et_dob.getText().toString().trim()))) {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton("Date of Birth must be before than current date!");
                        } else {
                            EntrepreneurProfileFragment.et_rate.setBackgroundDrawable(null);
                            EntrepreneurProfileFragment.et_rate.setFocusableInTouchMode(false);
                            EntrepreneurProfileFragment.et_rate.setCursorVisible(false);
                            EntrepreneurProfileFragment.et_rate.setFocusable(false);
                            EntrepreneurProfileFragment.editView.setVisibility(View.GONE);

                            if (filepath != null) {
                                File file = new File(filepath);
                                if (file.length() >= 5242880) {
                                    Toast.makeText(getActivity(), "Image size is more than 5 MB.", Toast.LENGTH_LONG).show();
                                } else {
                                    HashMap<String, String> map = new HashMap<String, String>();
                                    map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));

                                    map.put("my_interests", et_myinterests.getText().toString().trim());
                                    map.put("bio", et_bio.getText().toString().trim());
                                    String name = et_name.getText().toString().trim();
                                    String[] s = et_name.getText().toString().trim().split(" ");

                                    if (s.length == 1) {
                                        map.put("first_name", s[0].trim());
                                        map.put("last_name", "");
                                    } else {
                                        map.put("first_name", name.substring(0, name.lastIndexOf(" ")));
                                        map.put("last_name", s[s.length - 1].trim());
                                    }

                                    map.put("email", et_email.getText().toString().trim());
                                    map.put("date_of_birth", et_dob.getText().toString().trim());
                                    map.put("country_id", String.valueOf(COUNTRY_ID));
                                    map.put("state_id", String.valueOf(STATE_ID));
                                    map.put("phoneno", et_phone.getText().toString().trim());
                                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                        saveProfile(map, Constants.ENTREPRENEUR_EDIT_BASIC_PROFILE_URL);
                                    } else {
                                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                    }
                                }
                            } else {
                                HashMap<String, String> map = new HashMap<String, String>();
                                map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));

                                map.put("my_interests", et_myinterests.getText().toString().trim());
                                map.put("bio", et_bio.getText().toString().trim());
                                String name = et_name.getText().toString().trim();
                                String[] s = et_name.getText().toString().trim().split(" ");

                                if (s.length == 1) {
                                    map.put("first_name", s[0].trim());
                                    map.put("last_name", "");
                                } else {
                                    map.put("first_name", name.substring(0, name.lastIndexOf(" ")));
                                    map.put("last_name", s[s.length - 1].trim());
                                }

                                map.put("email", et_email.getText().toString().trim());
                                map.put("date_of_birth", et_dob.getText().toString().trim());
                                map.put("country_id", String.valueOf(COUNTRY_ID));
                                map.put("state_id", String.valueOf(STATE_ID));
                                map.put("phoneno", et_phone.getText().toString().trim());
                                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                    saveProfile(map, Constants.ENTREPRENEUR_EDIT_BASIC_PROFILE_URL);
                                } else {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                }
                            }
                        }

                    } else {
                        if (!et_dob.getText().toString().trim().isEmpty() && !DateTimeFormatClass.compareDates(DateTimeFormatClass.convertStringObjectToDate(et_dob.getText().toString().trim()))) {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton("Date of Birth must be before than current date!");
                        } else {
                            ProfileFragment.et_rate.setBackgroundDrawable(null);
                            ProfileFragment.et_rate.setFocusableInTouchMode(false);
                            ProfileFragment.et_rate.setCursorVisible(false);
                            ProfileFragment.et_rate.setFocusable(false);
                            ProfileFragment.editView.setVisibility(View.VISIBLE);

                            if (filepath != null) {
                                File file = new File(filepath);
                                if (file.length() >= 5242880) {
                                    Toast.makeText(getActivity(), "Image size is more than 5 MB.", Toast.LENGTH_LONG).show();
                                } else {
                                    HashMap<String, String> map = new HashMap<String, String>();
                                    map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                                    String[] s1 = ProfileFragment.et_rate.getText().toString().trim().split("/");
                                    try {
                                        map.put("price", ((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(ProfileFragment.et_rate.getText().toString().trim()));
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                    map.put("bio", et_bio.getText().toString().trim());
                                    String name = et_name.getText().toString().trim();
                                    String[] s = et_name.getText().toString().trim().split(" ");

                                    if (s.length == 1) {
                                        map.put("first_name", s[0].trim());
                                        map.put("last_name", "");
                                    } else {
                                        map.put("first_name", name.substring(0, name.lastIndexOf(" ")));
                                        map.put("last_name", s[s.length - 1].trim());
                                    }

                                    map.put("email", et_email.getText().toString().trim());
                                    map.put("date_of_birth", et_dob.getText().toString().trim());
                                    map.put("country_id", String.valueOf(COUNTRY_ID));
                                    map.put("state_id", String.valueOf(STATE_ID));
                                    map.put("phoneno", et_phone.getText().toString().trim());
                                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                        saveProfile(map, Constants.CONTRACTOR_EDIT_BASIC_PROFILE_URL);
                                    } else {
                                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                    }
                                }
                            } else {
                                HashMap<String, String> map = new HashMap<String, String>();
                                map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                                String[] s1 = ProfileFragment.et_rate.getText().toString().trim().split("/");
                                try {
                                    map.put("price", ((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(ProfileFragment.et_rate.getText().toString().trim()));
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                                map.put("bio", et_bio.getText().toString().trim());
                                String name = et_name.getText().toString().trim();
                                String[] s = et_name.getText().toString().trim().split(" ");

                                if (s.length == 1) {
                                    map.put("first_name", s[0].trim());
                                    map.put("last_name", "");
                                } else {
                                    map.put("first_name", name.substring(0, name.lastIndexOf(" ")));
                                    map.put("last_name", s[s.length - 1].trim());
                                }

                                map.put("email", et_email.getText().toString().trim());
                                map.put("date_of_birth", et_dob.getText().toString().trim());
                                map.put("country_id", String.valueOf(COUNTRY_ID));
                                map.put("state_id", String.valueOf(STATE_ID));
                                map.put("phoneno", et_phone.getText().toString().trim());

                                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                    saveProfile(map, Constants.CONTRACTOR_EDIT_BASIC_PROFILE_URL);
                                } else {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                }
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
                    //String responseString = null;
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
                            obj.put("code", "404");
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
                                Toast.makeText(getActivity(), "Profile successfully updated.", Toast.LENGTH_LONG).show();
                                if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.CONTRACTOR)) {


                                    String[] s = et_name.getText().toString().trim().split(" ");

                                    if (s.length == 1) {
                                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_FIRST_NAME, s[0].trim());
                                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_LAST_NAME, "");

                                    } else {
                                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_FIRST_NAME, s[0].trim());
                                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_LAST_NAME, s[s.length - 1].trim());
                                    }
                                    if (Integer.parseInt(obj.optString("profile_completeness").trim()) == 0) {
                                        ProfileFragment.progressProfileComplete.setProgress(0);
                                        ProfileFragment.tv_profileComplete.setText(ProfileFragment.progressProfileComplete.getProgress() + "% completed");
                                        ((HomeActivity) getActivity()).prefManager.storeInteger(Constants.CONTRACTOR_PROFILE_COMPLETENESS, 0);
                                    } else {
                                        ProfileFragment.progressProfileComplete.setProgress(Integer.parseInt(obj.optString("profile_completeness").trim()));
                                        ProfileFragment.tv_profileComplete.setText(ProfileFragment.progressProfileComplete.getProgress() + "% completed");
                                        ((HomeActivity) getActivity()).prefManager.storeInteger(Constants.CONTRACTOR_PROFILE_COMPLETENESS, Integer.parseInt(obj.optString("profile_completeness").trim()));
                                    }

                                    ProfileFragment.et_username.setText(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_FIRST_NAME) + " " + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_LAST_NAME));
                                    HomeActivity.userName.setText(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_FIRST_NAME) + " " + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_LAST_NAME));

                                    if (!((HomeActivity) getActivity()).prefManager.getString(Constants.USER_PROFILE_IMAGE_URL).equalsIgnoreCase(obj.optString("image").trim())) {
                                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_PROFILE_IMAGE_URL, obj.optString("image").trim());
                                        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + obj.optString("image").trim(), HomeActivity.mUserImage, ((HomeActivity) getActivity()).options);
                                    }
                                    try {
                                        String rate = ProfileFragment.et_rate.getText().toString().trim();


                                        ProfileFragment.et_rate.setText("$" + ((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(rate) + "/HR");
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                } else {
                                    String[] s = et_name.getText().toString().trim().split(" ");

                                   /* if (s.length == 1) {
                                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_FIRST_NAME, s[0].trim());
                                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_LAST_NAME, "");

                                    } else {
                                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_FIRST_NAME, s[0].trim());
                                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_LAST_NAME, s[s.length - 1].trim());
                                    }*/
                                    EntrepreneurProfileFragment.et_username.setText(et_name.getText().toString().trim());
                                    if (Integer.parseInt(obj.optString("profile_completeness").trim()) == 0) {
                                        EntrepreneurProfileFragment.progressProfileComplete.setProgress(0);
                                        EntrepreneurProfileFragment.tv_profileComplete.setText(EntrepreneurProfileFragment.progressProfileComplete.getProgress() + "% completed");
                                        ((HomeActivity) getActivity()).prefManager.storeInteger(Constants.ENTREPRENEUR_PROFILE_COMPLETENESS, 0);
                                    } else {
                                        EntrepreneurProfileFragment.progressProfileComplete.setProgress(Integer.parseInt(obj.optString("profile_completeness").trim()));
                                        EntrepreneurProfileFragment.tv_profileComplete.setText(EntrepreneurProfileFragment.progressProfileComplete.getProgress() + "% completed");
                                        ((HomeActivity) getActivity()).prefManager.storeInteger(Constants.ENTREPRENEUR_PROFILE_COMPLETENESS, Integer.parseInt(obj.optString("profile_completeness").trim()));

                                    }
                                }
                            } else if (obj.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                                if (!obj.optJSONObject("errors").optString("bio").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton("Bio field is required!");
                                } else if (!obj.optJSONObject("errors").optString("last_name").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(obj.optJSONObject("errors").optString("last_name"));
                                } else if (!obj.optJSONObject("errors").optString("first_name").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(obj.optJSONObject("errors").optString("first_name"));
                                } else if (!obj.optJSONObject("errors").optString("date_of_birth").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton("Date-of-Birth is required!");
                                } else if (!obj.optJSONObject("errors").optString("country_id").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton("Country is required!");
                                } else if (!obj.optJSONObject("errors").optString("state_id").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton("State is required!");
                                } else if (!obj.optJSONObject("errors").optString("phoneno").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(obj.optJSONObject("errors").optString("phoneno"));
                                } else if (!obj.optJSONObject("errors").optString("price").isEmpty()) {
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton("Rate is required!");
                                }

                            }

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    } else {
                        Toast.makeText(getActivity(), "No response found", Toast.LENGTH_LONG).show();
                    }
                }
            }.execute();
        } catch (Exception e) {
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
                if (tag.equalsIgnoreCase(Constants.GET_COUNTRIES_LIST_WITH_STATES_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        countries.clear();

                        CountryObject obj = new CountryObject();
                        obj.setId("0");
                        obj.setName("Select Country");
                        ArrayList<StatesObject> selectCityObjectList = new ArrayList<StatesObject>();
                        StatesObject selectCityObj = new StatesObject();
                        selectCityObj.setId("0");
                        selectCityObj.setName("Select State");
                        selectCityObjectList.add(selectCityObj);
                        obj.setStatesObjects(selectCityObjectList);
                        countries.add(obj);


                        if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            JSONArray country = jsonObject.optJSONArray("country");

                            for (int i = 0; i < country.length(); i++) {
                                JSONObject countryJsonObject = country.getJSONObject(i);
                                CountryObject inner = new CountryObject();
                                inner.setId(countryJsonObject.getString("id"));
                                inner.setName(countryJsonObject.getString("name"));

                                states = new ArrayList<StatesObject>();
                                StatesObject obj1 = new StatesObject();
                                obj1.setId("0");
                                obj1.setName("Select State");
                                states.add(obj1);

                                JSONArray statesJsonArray = countryJsonObject.getJSONArray("state");
                                for (int j = 0; j < statesJsonArray.length(); j++) {
                                    StatesObject statesObject = new StatesObject();
                                    statesObject.setId(statesJsonArray.getJSONObject(j).getString("id"));
                                    statesObject.setName(statesJsonArray.getJSONObject(j).getString("name"));
                                    states.add(statesObject);
                                }

                                inner.setStatesObjects(states);

                                countries.add(inner);
                                countryAdapter = new CountryAdapter(getActivity(), 0, countries);
                                countrySpinner.setAdapter(countryAdapter);


                            }
                            if (((HomeActivity) getActivity()).prefManager.getString(Constants.USER_TYPE).equalsIgnoreCase(Constants.ENTREPRENEUR)) {
                                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ENTREPRENEUR_BASIC_PROFILE_TAG, Constants.ENTREPRENEUR_BASIC_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+ "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                    a.execute();
                                    ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                                } else {
                                    ((HomeActivity)getActivity()).dismissProgressDialog();
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                }
                            } else {
                                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.CONTRACTOR_BASIC_PROFILE_TAG, Constants.CONTRACTOR_BASIC_PROFILE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID)+ "&logged_in_user=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");
                                    a.execute();
                                    ((HomeActivity) getActivity()).setOnBackPressedListener(this);
                                } else {
                                    ((HomeActivity)getActivity()).dismissProgressDialog();
                                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                                }
                            }
                        } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            countryAdapter = new CountryAdapter(getActivity(), 0, countries);
                            countrySpinner.setAdapter(countryAdapter);
                        }
                    } catch (JSONException e) {
                        ((HomeActivity)getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.CONTRACTOR_BASIC_PROFILE_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);

                        if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                            if (!((HomeActivity) getActivity()).prefManager.getString(Constants.USER_PROFILE_IMAGE_URL).equalsIgnoreCase(jsonObject.optString("profile_image").trim())) {
                                ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_PROFILE_IMAGE_URL, jsonObject.optString("profile_image").trim());

                                ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), HomeActivity.mUserImage, ((HomeActivity) getActivity()).options);
                                /*ImageLoaderWithoutProgressBar imageLoader = new ImageLoaderWithoutProgressBar(getActivity());
                                imageLoader.DisplayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), HomeActivity.mUserImage, R.drawable.image);*/
                            }

                            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), ProfileFragment.circularImageView, ((HomeActivity) getActivity()).options);
                            /*ImageLoaderWithoutProgressBar imageLoader = new ImageLoaderWithoutProgressBar(getActivity());
                            imageLoader.DisplayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), ProfileFragment.circularImageView, R.drawable.image);*/

                            try {
                                if (Integer.parseInt(jsonObject.optString("profile_completeness").trim()) == 0) {
                                    ProfileFragment.progressProfileComplete.setProgress(0);
                                    ProfileFragment.tv_profileComplete.setText(ProfileFragment.progressProfileComplete.getProgress() + "% completed");
                                    ((HomeActivity) getActivity()).prefManager.storeInteger(Constants.CONTRACTOR_PROFILE_COMPLETENESS, 0);
                                } else {
                                    ProfileFragment.progressProfileComplete.setProgress(Integer.parseInt(jsonObject.optString("profile_completeness").trim()));
                                    ProfileFragment.tv_profileComplete.setText(ProfileFragment.progressProfileComplete.getProgress() + "% completed");
                                    ((HomeActivity) getActivity()).prefManager.storeInteger(Constants.CONTRACTOR_PROFILE_COMPLETENESS, Integer.parseInt(jsonObject.optString("profile_completeness").trim()));
                                }
                            } catch (NumberFormatException e) {
                                e.printStackTrace();
                            }


                            JSONObject basic_information = jsonObject.optJSONObject("basic_information");
                            et_bio.setText(basic_information.optString("biodata").trim());
                            et_dob.setText(DateTimeFormatClass.convertStringObjectToMMDDYYYFormat(basic_information.optString("dob").trim()));
                            et_email.setText(basic_information.optString("email").trim());
                            et_name.setText(basic_information.optString("name").trim());
                            et_phone.setText(basic_information.optString("phone").trim());

                            String name = et_name.getText().toString().trim();
                            String[] s = et_name.getText().toString().trim().split(" ");


                            if (s.length == 1) {
                                ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_FIRST_NAME, s[0].trim());
                                ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_LAST_NAME, "");
                            } else {
                                ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_FIRST_NAME, name.substring(0, name.lastIndexOf(" ")));
                                ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_LAST_NAME, s[s.length - 1].trim());
                            }

                            try {
                                HomeActivity.userName.setText(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_FIRST_NAME) + " " + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_LAST_NAME));
                                ProfileFragment.et_username.setText(basic_information.optString("name").trim());

                                if (jsonObject.optString("perhour_rate").trim().length() == 0) {
                                    ProfileFragment.et_rate.setText("$0.00/HR");
                                } else {
                                    ProfileFragment.et_rate.setText("$" + ((HomeActivity) getActivity()).utilitiesClass.extractFloatValueFromStrin(jsonObject.optString("perhour_rate")) + "/HR");
                                }

                                //String country_name = basic_information.optString("country");
                                if (basic_information.optString("country_id").toString().trim().length() == 0) {
                                    COUNTRY_ID = 0;
                                } else {
                                    COUNTRY_ID = Integer.parseInt(basic_information.optString("country_id").toString().trim());
                                }
                                if (basic_information.optString("city_id").toString().trim().length() == 0) {
                                    STATE_ID = 0;
                                } else {
                                    STATE_ID = Integer.parseInt(basic_information.optString("city_id").toString().trim());
                                }
                                if (countryAdapter != null) {
                                    for (int position = 0; position < countryAdapter.getCount(); position++) {
                                        if (countryAdapter.getId(position).equalsIgnoreCase(COUNTRY_ID + "")) {
                                            countrySpinner.setSelection(position);
                                        }
                                    }
                                }
                                if (stateAdapter != null) {
                                    for (int position = 0; position < stateAdapter.getCount(); position++) {
                                        if (stateAdapter.getId(position).equalsIgnoreCase(STATE_ID + "")) {
                                            citySpinner.setSelection(position);
                                        }
                                    }
                                }
                            } catch (NumberFormatException e) {
                                e.printStackTrace();
                            }

                        } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }

                        ((HomeActivity)getActivity()).dismissProgressDialog();
                    } catch (JSONException e) {
                        ((HomeActivity)getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                } else if (tag.equalsIgnoreCase(Constants.ENTREPRENEUR_BASIC_PROFILE_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject);

                        if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                            // EntrepreneurProfileFragment.et_rate.setText(jsonObject.optString("perhour_rate").trim() + "/HR");
                            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.optString("profile_image").trim(), EntrepreneurProfileFragment.circularImageView, ((HomeActivity) getActivity()).options);

                            JSONObject basic_information = jsonObject.optJSONObject("basic_information");
                            et_email.setText(basic_information.optString("email").trim());
                            et_bio.setText(basic_information.optString("biodata").trim());
                            et_phone.setText(basic_information.optString("phone").trim());
                            et_dob.setText(DateTimeFormatClass.convertStringObjectToMMDDYYYFormat(basic_information.optString("dob").trim()));
                            et_name.setText(basic_information.optString("name").trim());
                            EntrepreneurProfileFragment.et_username.setText(basic_information.optString("name").trim());
                            et_myinterests.setText(basic_information.optString("interest").trim());
                            try {
                                if (Integer.parseInt(jsonObject.optString("profile_completeness").trim()) == 0) {
                                    EntrepreneurProfileFragment.progressProfileComplete.setProgress(0);
                                    EntrepreneurProfileFragment.tv_profileComplete.setText(EntrepreneurProfileFragment.progressProfileComplete.getProgress() + "% completed");
                                    ((HomeActivity) getActivity()).prefManager.storeInteger(Constants.ENTREPRENEUR_PROFILE_COMPLETENESS, 0);
                                } else {
                                    EntrepreneurProfileFragment.progressProfileComplete.setProgress(Integer.parseInt(jsonObject.optString("profile_completeness").trim()));
                                    EntrepreneurProfileFragment.tv_profileComplete.setText(EntrepreneurProfileFragment.progressProfileComplete.getProgress() + "% completed");
                                    ((HomeActivity) getActivity()).prefManager.storeInteger(Constants.ENTREPRENEUR_PROFILE_COMPLETENESS, Integer.parseInt(jsonObject.optString("profile_completeness").trim()));
                                }
                            } catch (NumberFormatException e) {
                                e.printStackTrace();
                            }

                            try {
                                if (basic_information.optString("country_id").toString().trim().length() == 0) {
                                    COUNTRY_ID = 0;
                                } else {
                                    COUNTRY_ID = Integer.parseInt(basic_information.optString("country_id").toString().trim());
                                }
                                if (basic_information.optString("city_id").toString().trim().length() == 0) {
                                    STATE_ID = 0;
                                } else {
                                    STATE_ID = Integer.parseInt(basic_information.optString("city_id").toString().trim());
                                }
                                if (countryAdapter != null) {
                                    for (int position = 0; position < countryAdapter.getCount(); position++) {
                                        if (countryAdapter.getId(position).equalsIgnoreCase(COUNTRY_ID + "")) {
                                            countrySpinner.setSelection(position);
                                        }
                                    }
                                }
                                if (stateAdapter != null) {
                                    for (int position = 0; position < stateAdapter.getCount(); position++) {
                                        if (stateAdapter.getId(position).equalsIgnoreCase(STATE_ID + "")) {
                                            citySpinner.setSelection(position);
                                        }
                                    }
                                }
                            } catch (NumberFormatException e) {
                                e.printStackTrace();
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
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}