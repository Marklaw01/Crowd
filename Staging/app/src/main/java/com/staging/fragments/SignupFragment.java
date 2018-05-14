package com.staging.fragments;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;
import com.google.android.gms.auth.api.Auth;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.auth.api.signin.GoogleSignInResult;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.OptionalPendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.plus.PlusShare;
import com.linkedin.platform.LISession;
import com.linkedin.platform.LISessionManager;
import com.linkedin.platform.errors.LIAuthError;
import com.linkedin.platform.listeners.AuthListener;
import com.linkedin.platform.utils.Scope;
import com.quickblox.auth.QBAuth;
import com.quickblox.auth.model.QBSession;
import com.quickblox.chat.QBChatService;
import com.quickblox.core.QBEntityCallback;
import com.quickblox.core.exception.QBResponseException;
import com.quickblox.users.QBUsers;
import com.quickblox.users.model.QBUser;
import com.staging.R;
//import com.staging.activities.HomeActivity;
import com.staging.activities.LoginActivity;
import com.staging.dropdownadapter.CountryAdapter;
import com.staging.dropdownadapter.SpinnerAdapter;
import com.staging.dropdownadapter.StatesAdapter;
import com.staging.helper.CustomEditTextView;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.listeners.onActivityResultListener;
import com.staging.models.CountryObject;
import com.staging.models.GenericObject;
import com.staging.models.StatesObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.DateTimeFormatClass;
import com.staging.utilities.UsPhoneNumberFormatter;
import com.staging.utilities.UtilitiesClass;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.ref.WeakReference;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

/**
 * Created by neelmani.karn on 1/6/2016.
 */
public class SignupFragment extends Fragment implements AsyncTaskCompleteListener<String>, onActivityResultListener, GoogleApiClient.OnConnectionFailedListener {

    CountryAdapter countryAdapter;
    StatesAdapter stateAdapter;
    private ArrayList<StatesObject> states;
    private ArrayList<CountryObject> countries;
    private int COUNTRY_ID;
    private int STATE_ID;
    /*private ArrayList<GenericObject> countriesList;
    private ArrayList<GenericObject> statesList;*/
    private DatePickerDialog.OnDateSetListener date;
    //private TimePickerDialog.OnTimeSetListener time;
    private Calendar myCalendar, myCalenderForTime;

    private CustomEditTextView et_city, et_firtName, et_lastName, et_userName, et_email, et_phoneNumber, et_bestAvailability, et_password, et_ConfPassword, et_DOB, et_answer, et_question, et_customanswer;
    private LinearLayout layout_predefinedQuestions, layout_customQuestions;

    private ImageView btn_addMorePredefinedQuestion, /*btn_deletePredefinedQuestion,*/
            btn_addMoreCustomQuestion/*, btn_deleteCustomQuestion*/;
    private Button btn_signup;
    private CheckBox agreeTermsAndConditions;


    private Spinner spinner_chooseSecurityQuestion, spinner_country, spinner_city;

    private ArrayList<GenericObject> securityQuestionsList;

    private ArrayList<Spinner> spinnersPreDefinedQuestions;
    private ArrayList<CustomEditTextView> editTextsForPredefinedAnswer;

    private ArrayList<CustomEditTextView> editTextsForCustomQuestions;
    private ArrayList<CustomEditTextView> editTextsForCustomAnswer;
    private TextView termsAndconditions;
    private TextView privacyPolicy;
    private TextView facebookRequest;
    private TextView googleRequest;
    private static final String TAG = "SIGNUP";
    public static final String PACKAGE_MOBILE_SDK_SAMPLE_APP = "com.staging.fragments";

    private TextView linkedinRequest;
    private Activity thisActivity;


    private static final int SIGN_IN_CODE = 9001;
    private GoogleApiClient mGoogleApiClient;

    private GoogleSignInAccount account;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_signup, container, false);

        thisActivity = getActivity();

        try {
            PackageInfo info = thisActivity.getPackageManager().getPackageInfo(getActivity().getPackageName(),
                    PackageManager.GET_SIGNATURES);
            for (Signature signature : info.signatures) {
                MessageDigest md = MessageDigest.getInstance("SHA");
                md.update(signature.toByteArray());

            }
        } catch (PackageManager.NameNotFoundException e) {


        } catch (NoSuchAlgorithmException e) {

        }
        states = new ArrayList<StatesObject>();
        countries = new ArrayList<CountryObject>();
        /*countriesList = new ArrayList<GenericObject>();
        statesList = new ArrayList<GenericObject>();*/
        agreeTermsAndConditions = (CheckBox) rootView.findViewById(R.id.cbx_agree);
        termsAndconditions = (TextView) rootView.findViewById(R.id.tv_termsAndConditions);
        privacyPolicy = (TextView) rootView.findViewById(R.id.tv_privacypolicy);
        spinner_chooseSecurityQuestion = (Spinner) rootView.findViewById(R.id.spinner_chooseSecurityQuestion);
        et_city = (CustomEditTextView) rootView.findViewById(R.id.et_city);
        layout_customQuestions = (LinearLayout) rootView.findViewById(R.id.layout_customQuestions);
        layout_predefinedQuestions = (LinearLayout) rootView.findViewById(R.id.layout_predefinedQuestions);

        btn_addMorePredefinedQuestion = (ImageView) rootView.findViewById(R.id.btn_addMorePredefinedQuestion);
        btn_addMoreCustomQuestion = (ImageView) rootView.findViewById(R.id.btn_addMoreCustomQuestion);

        btn_signup = (Button) rootView.findViewById(R.id.btn_signup);

        et_answer = (CustomEditTextView) rootView.findViewById(R.id.et_answer);
        et_question = (CustomEditTextView) rootView.findViewById(R.id.et_question);
        et_customanswer = (CustomEditTextView) rootView.findViewById(R.id.et_customanswer);


        facebookRequest = (TextView) rootView.findViewById(R.id.tv_facebook);
        linkedinRequest = (TextView) rootView.findViewById(R.id.tv_linkedin);
        googleRequest = (TextView) rootView.findViewById(R.id.tv_google);

        et_bestAvailability = (CustomEditTextView) rootView.findViewById(R.id.et_bestAvailability);
        spinner_city = (Spinner) rootView.findViewById(R.id.spinner_city);
        et_ConfPassword = (CustomEditTextView) rootView.findViewById(R.id.et_ConfPassword);
        spinner_country = (Spinner) rootView.findViewById(R.id.spinner_country);
        et_email = (CustomEditTextView) rootView.findViewById(R.id.et_email);
        et_firtName = (CustomEditTextView) rootView.findViewById(R.id.et_firtName);
        et_lastName = (CustomEditTextView) rootView.findViewById(R.id.et_lastName);
        et_password = (CustomEditTextView) rootView.findViewById(R.id.et_password);
        et_phoneNumber = (CustomEditTextView) rootView.findViewById(R.id.et_phoneNumber);
        et_userName = (CustomEditTextView) rootView.findViewById(R.id.et_userName);
        et_DOB = (CustomEditTextView) rootView.findViewById(R.id.et_DOB);
        agreeTermsAndConditions.setChecked(false);

        ((LoginActivity) getActivity()).showProgressDialog();
        if (((LoginActivity) getActivity()).networkConnectivity.isOnline()) {

            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.GET_COUNTRIES_LIST_WITH_STATES_TAG, Constants.GET_COUNTRIES_LIST_WITH_STATES, Constants.HTTP_POST, "Home Activity");
            a.execute();
        } else {
            ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }


        if (((LoginActivity) getActivity()).networkConnectivity.isOnline()) {
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.PREDEFINED_QUESTIONS_TAG, Constants.PREDEFINED_QUESTIONS_URL, Constants.HTTP_POST, "Home Activity");
            a.execute();
        } else {
            ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }

        termsAndconditions.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder alert = new AlertDialog.Builder(getActivity(), R.style.MyDialogTheme);
                alert.setTitle("Terms And Conditions");


                LinearLayout layoutHorizontal = new LinearLayout(getActivity());
                layoutHorizontal.setOrientation(LinearLayout.HORIZONTAL);
                layoutHorizontal.setGravity(Gravity.RIGHT);
                LinearLayout.LayoutParams parms = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                layoutHorizontal.setLayoutParams(parms);


                LinearLayout layout = new LinearLayout(getActivity());
                layout.setOrientation(LinearLayout.VERTICAL);
                layout.addView(layoutHorizontal);
                WebView wv = new WebView(getActivity());

                wv.getSettings().setLoadsImagesAutomatically(true);
                wv.getSettings().setJavaScriptEnabled(true);
                wv.getSettings().setAllowContentAccess(true);
                wv.loadUrl(Constants.APP_IMAGE_URL + "/users/terms--and-conditions");

                wv.setWebViewClient(new WebViewClient() {
                    @Override
                    public boolean shouldOverrideUrlLoading(WebView view, String url) {
                        view.loadUrl(url);

                        return true;
                    }
                });
                layout.addView(wv);
                alert.setView(layout);
                alert.setNegativeButton("Close", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.dismiss();
                    }
                });
                alert.show();
            }
        });
// GOOGLE SHARING TO BE IMPLEMENTED BELOW++++++++++++++++++++++++++

        try {
            GoogleSignInOptions gso = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                    .requestEmail()
                    .build();


            mGoogleApiClient = new GoogleApiClient.Builder(getActivity())
                    .enableAutoManage(getActivity(), this)
                    .addApi(Auth.GOOGLE_SIGN_IN_API, gso)
                    .build();


        } catch (Exception e){}

        googleRequest.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (isGoogleAppInstalled()) {
                    signIn();
                } else {
                    Toast.makeText(getActivity(), "Google Plus App Not Installed, Kindly install the App from Google Playstore", Toast.LENGTH_LONG).show();
                }
            }
        });


        facebookRequest.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {


                // if (isFacebookAppInstalled()) {
                FacebookSdk.sdkInitialize(getActivity().getApplicationContext());
                CallbackManager callbackManager = CallbackManager.Factory.create();
                final ShareDialog shareDialog = new ShareDialog(getActivity());

                shareDialog.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {

                    @Override
                    public void onSuccess(Sharer.Result result) {
                        Log.d("XXX", "success");
                    }

                    @Override
                    public void onError(FacebookException error) {
                        Log.d("XXX", "error");
                    }

                    @Override
                    public void onCancel() {
                        Log.d("XXX", "cancel");
                    }
                });


                if (shareDialog.canShow(ShareLinkContent.class)) {
                    ShareLinkContent content = new ShareLinkContent.Builder()
                            .setContentTitle("Crowd Bootstrap Invitation")
                            .setImageUrl(Uri.parse(Constants.APP_IMAGE_URL + "/img/small-logo.png"))
                            .setContentUrl(Uri.parse(Constants.APP_IMAGE_URL))
                            .setContentDescription(
                                    "Crowd Bootstrap helps entrepreneurs accelerate their journey from a startup idea to initial revenues. It is a free App that enables you to benefit as an entrepreneur or help as an expert." +
                                            "Please click the following link to sign-up and help an entrepreneur realize their dream.\n" +
                                            "Regards,\n" +
                                            "The Crowd Bootstrap Team")
                            .build();
                    ShareDialog shareDialogContent = new ShareDialog(getActivity());
                    shareDialogContent.show(content);

                }



            }
        });

//Linked in Tasks++++++++++++++++++++++++++

        setUpdateState();

        linkedinRequest.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (isSessionValidLinkedin == false) {
                    LISessionManager.getInstance(getActivity().getApplicationContext()).init(getActivity(), buildScope(), new AuthListener() {
                        @Override
                        public void onAuthSuccess() {
                            setUpdateState();
                            Toast.makeText(getActivity(), "Connected with LinkedIn", Toast.LENGTH_LONG).show();


                        }

                        @Override
                        public void onAuthError(LIAuthError error) {
                            setUpdateState();
                            Toast.makeText(getActivity(), "Failed to connect with LinkedIn", Toast.LENGTH_LONG).show();
                        }
                    }, true);


                } else {
                    android.app.FragmentManager fm = ((LoginActivity) getActivity()).getFragmentManager();
                    LinkedinPopUpFragment dialogFragment = new LinkedinPopUpFragment();
                    dialogFragment.show(fm, "LinkedIn Fragment");
                }
            }

        });


        privacyPolicy.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder alert = new AlertDialog.Builder(getActivity(), R.style.MyDialogTheme);
                alert.setTitle("Privacy Policy");


                LinearLayout layoutHorizontal = new LinearLayout(getActivity());
                layoutHorizontal.setOrientation(LinearLayout.HORIZONTAL);
                layoutHorizontal.setGravity(Gravity.RIGHT);
                LinearLayout.LayoutParams parms = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                layoutHorizontal.setLayoutParams(parms);


                LinearLayout layout = new LinearLayout(getActivity());
                layout.setOrientation(LinearLayout.VERTICAL);
                layout.addView(layoutHorizontal);
                WebView wv = new WebView(getActivity());

                wv.getSettings().setLoadsImagesAutomatically(true);
                wv.getSettings().setJavaScriptEnabled(true);
                wv.getSettings().setAllowContentAccess(true);
                wv.loadUrl(Constants.APP_IMAGE_URL + "/users/privacy-policy");

                wv.setWebViewClient(new WebViewClient() {
                    @Override
                    public boolean shouldOverrideUrlLoading(WebView view, String url) {
                        view.loadUrl(url);

                        return true;
                    }
                });
                layout.addView(wv);
                alert.setView(layout);
                alert.setNegativeButton("Close", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.dismiss();
                    }
                });
                alert.show();
            }
        });


        spinner_country.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                COUNTRY_ID = Integer.parseInt(countries.get(position).getId());

                states = countries.get(position).getStatesObjects();
                //Toast.makeText(getActivity(), "size" + states.size(), Toast.LENGTH_LONG).show();
                stateAdapter = new StatesAdapter(getActivity(), 0, states);
                spinner_city.setAdapter(stateAdapter);

                if (stateAdapter != null) {
                    for (int i = 0; i < stateAdapter.getCount(); i++) {
                        if (stateAdapter.getId(i).equalsIgnoreCase(STATE_ID + "")) {
                            spinner_city.setSelection(i);
                        }
                    }
                }

            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        spinner_city.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                STATE_ID = Integer.parseInt(states.get(position).getId());
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        myCalendar = Calendar.getInstance();
        myCalenderForTime = Calendar.getInstance();
        securityQuestionsList = new ArrayList<GenericObject>();

        date = new DatePickerDialog.OnDateSetListener() {

            @Override
            public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {

                myCalendar.set(Calendar.YEAR, year);
                myCalendar.set(Calendar.MONTH, monthOfYear);
                myCalendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                updateLabel();
            }
        };

        /*time = new TimePickerDialog.OnTimeSetListener() {
            @Override
            public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                myCalenderForTime.set(Calendar.HOUR_OF_DAY, hourOfDay);
                myCalenderForTime.set(Calendar.MINUTE, minute);
                updateTimeLabel();
            }
        };*/


//        UsPhoneNumberFormatter addLineNumberFormatter = new UsPhoneNumberFormatter(
//                new WeakReference<EditText>(et_phoneNumber));
//        et_phoneNumber.addTextChangedListener(addLineNumberFormatter);


        btn_signup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                spinnersPreDefinedQuestions = new ArrayList<Spinner>();
                editTextsForPredefinedAnswer = new ArrayList<CustomEditTextView>();
                editTextsForCustomQuestions = new ArrayList<CustomEditTextView>();
                editTextsForCustomAnswer = new ArrayList<CustomEditTextView>();

                if (et_answer.getText().toString().trim().isEmpty()) {

                } else {
                    editTextsForPredefinedAnswer.add(et_answer);
                    spinnersPreDefinedQuestions.add(spinner_chooseSecurityQuestion);
                }

                for (int i = 0; i < layout_predefinedQuestions.getChildCount(); i++) {
                    CustomEditTextView answer = (CustomEditTextView) ((LinearLayout) layout_predefinedQuestions.getChildAt(i)).findViewById(R.id.et_answer);
                    Spinner spinner = (Spinner) ((LinearLayout) layout_predefinedQuestions.getChildAt(i)).findViewById(R.id.spinner);
                    spinnersPreDefinedQuestions.add(spinner);
                    editTextsForPredefinedAnswer.add(answer);
                }

                if (et_question.getText().toString().trim().isEmpty()) {

                } else {
                    editTextsForCustomQuestions.add(et_question);
                    editTextsForCustomAnswer.add(et_customanswer);
                }

                for (int i = 0; i < layout_customQuestions.getChildCount(); i++) {
                    CustomEditTextView answer = (CustomEditTextView) ((LinearLayout) layout_customQuestions.getChildAt(i)).findViewById(R.id.et_answer);
                    CustomEditTextView questions = (CustomEditTextView) ((LinearLayout) layout_customQuestions.getChildAt(i)).findViewById(R.id.et_question);
                    editTextsForCustomQuestions.add(questions);
                    editTextsForCustomAnswer.add(answer);
                }

                System.out.println(COUNTRY_ID);
                if (agreeTermsAndConditions.isChecked()) {
                    submitForm();
                } else {
                    Toast.makeText(getActivity(), "Please Agree to the Terms And Conditions before proceeding.", Toast.LENGTH_LONG).show();

                }
            }
        });

        btn_addMorePredefinedQuestion.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                LayoutInflater mInflater = (LayoutInflater) getActivity().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                final View layout = mInflater.inflate(R.layout.predefined_security_questions_layout, null);

                ImageView delete = (ImageView) layout.findViewById(R.id.btn_delete);

                Spinner spinner = (Spinner) layout.findViewById(R.id.spinner);
                spinner.setAdapter(new SpinnerAdapter(getActivity(), 0, securityQuestionsList));

                delete.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        ((ViewGroup) layout.getParent()).removeView(layout);

                    }
                });
                layout_predefinedQuestions.addView(layout);
            }
        });

        btn_addMoreCustomQuestion.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                LayoutInflater mInflater = (LayoutInflater) getActivity().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                final View layout = mInflater.inflate(R.layout.custom_security_questions_layout, null);

                ImageView delete = (ImageView) layout.findViewById(R.id.btn_delete);

                delete.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        ((ViewGroup) layout.getParent()).removeView(layout);

                    }
                });
                layout_customQuestions.addView(layout);
            }
        });

        et_DOB.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Calendar cMax = Calendar.getInstance();
                int year = cMax.get(Calendar.YEAR);
                int month = cMax.get(Calendar.MONTH);
                int day = cMax.get(Calendar.DAY_OF_MONTH);

                cMax.set(year - 100, month, day);
                long now = System.currentTimeMillis() - 1000;

                DatePickerDialog dialog = new DatePickerDialog(getActivity(), date, myCalendar
                        .get(Calendar.YEAR), myCalendar.get(Calendar.MONTH),
                        myCalendar.get(Calendar.DAY_OF_MONTH));
                dialog.getDatePicker().setMinDate(cMax.getTimeInMillis());
                dialog.getDatePicker().setMaxDate(now);
                dialog.show();
            }
        });


        return rootView;
    }



    private static Scope buildScope() {
        return Scope.build(Scope.R_BASICPROFILE, Scope.W_SHARE);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {

        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == Activity.RESULT_OK) {
            LISessionManager.getInstance(getActivity().getApplicationContext()).onActivityResult(getActivity(), requestCode, resultCode, data);
        }


        if (requestCode == SIGN_IN_CODE) {
            Log.e("XXX", "ONACTIVITY RESULT");
            GoogleSignInResult result = Auth.GoogleSignInApi.getSignInResultFromIntent(data);
            handleSignInResult(result);
        }
    }


    private void handleSignInResult(GoogleSignInResult result) {
        Log.d(TAG, "handleSignInResult:" + result.isSuccess());
        if (result.isSuccess()) {
            updateUI(true);
            account = result.getSignInAccount();
        } else {
            updateUI(false);
        }
    }


    private void updateUI(boolean signedIn) {
        if (signedIn) {
            Intent shareIntent = new PlusShare.Builder(getActivity())
                    .setType("text/plain")
                    .setText("\n" +
                            "[Name]:\n" +
                            "\n" +
                            "Crowd Bootstrap helps entrepreneurs accelerate their journey from a startup idea to initial revenues. It is a free App that enables you to benefit as an entrepreneur or help as an expert.\n" +
                            "\n" +
                            "Please click the following link to sign-up and help an entrepreneur realize their dream.\n" +
                            "\n" +
                            "\n" +
                            "Regards,\n" +
                            "\n" +
                            "The Crowd Bootstrap Team")
                    .setContentUrl(Uri.parse("http://crowdbootstrap.com/"))
                    .getIntent();
            startActivityForResult(shareIntent, 0);
        } else {

        }
    }

    private void signIn() {
        Intent signInIntent = Auth.GoogleSignInApi.getSignInIntent(mGoogleApiClient);
        startActivityForResult(signInIntent, SIGN_IN_CODE);
    }

    private void signOut() {
        Auth.GoogleSignInApi.signOut(mGoogleApiClient).setResultCallback(
                new ResultCallback<Status>() {
                    @Override
                    public void onResult(Status status) {
                        updateUI(false);
                    }
                });
    }

    private boolean isSessionValidLinkedin;

    private void setUpdateState() {
        LISessionManager sessionManager = LISessionManager.getInstance(getActivity().getApplicationContext());
        LISession session = sessionManager.getSession();
        boolean accessTokenValid = session.isValid();
        Log.e("XXX", String.valueOf(accessTokenValid));
        if (accessTokenValid == true) {

            isSessionValidLinkedin = true;
        } else {
            isSessionValidLinkedin = false;
        }
    }

    private void updateLabel() {
        et_DOB.setText(DateTimeFormatClass.convertDateObjectToMMDDYYYFormat(myCalendar.getTime()));
    }

    /*private void updateTimeLabel() {
        System.out.println(myCalenderForTime.getTime());
        et_bestAvailability.setText(DateTimeFormatClass.convertDateObjectINTOTimeAmPmFormat(myCalenderForTime.getTime()));
    }*/

    @Override
    public void onDestroy() {
        super.onDestroy();
        mGoogleApiClient.stopAutoManage(getActivity());
        mGoogleApiClient.disconnect();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((LoginActivity) getActivity()).setOnBackPressedListener(this);
        ((LoginActivity) getActivity()).setOnActivityResultListener(this);


    }


    public boolean isGoogleAppInstalled() {
        try {
            thisActivity.getApplicationContext().getPackageManager().getApplicationInfo("om.google.android.apps.plus", 0);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }

    @Override
    public void onStart() {
        super.onStart();

        Log.e("XXX", "ONSTART");



    }

    public SignupFragment() {
        super();
    }


    JSONObject signup = null;

    private void submitForm() {

        if (et_firtName.getText().toString().trim().isEmpty()) {
            et_firtName.setError("First name required!", getResources().getDrawable(android.R.drawable.ic_dialog_alert));
        } else if (et_lastName.getText().toString().trim().isEmpty()) {
            et_lastName.setError("Last name required!", getResources().getDrawable(android.R.drawable.ic_dialog_alert));
            requestFocus(et_lastName);
        } else if (et_userName.getText().toString().trim().isEmpty()) {
            et_userName.setError("Username required and must be unique!", getResources().getDrawable(android.R.drawable.ic_dialog_alert));
            requestFocus(et_userName);
        } else if (!validateEmail()) {
            requestFocus(et_email);
        } else if (!validatePassword()) {
            requestFocus(et_password);
        } else if (!et_ConfPassword.getText().toString().trim().equals(et_password.getText().toString().trim())) {
            et_ConfPassword.setError("Password and Confirm Password must be same!", getResources().getDrawable(android.R.drawable.ic_dialog_alert));
            requestFocus(et_ConfPassword);
        }
//        else if (spinnersPreDefinedQuestions.size() == 0) {
//            ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton("Please select at-least one security question!");
//        }
        else {
//            if (!et_DOB.getText().toString().trim().isEmpty() && !DateTimeFormatClass.compareDates(myCalendar.getTime())) {
//                ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton("Date of Birth must be before than current date!");
//            } else {
                try {
                    signup = new JSONObject();
                    signup.put("first_name", et_firtName.getText().toString().trim());
                    signup.put("last_name", et_lastName.getText().toString().trim());
                    signup.put("username", et_userName.getText().toString().trim());
                    signup.put("email", et_email.getText().toString().trim());
                    //signup.put("date_of_birth", et_DOB.getText().toString().trim());
                    signup.put("phoneno", et_phoneNumber.getText().toString().trim());




                   // signup.put("country", COUNTRY_ID);
                   // signup.put("state", STATE_ID);
                   // signup.put("best_availablity", et_bestAvailability.getText().toString().trim());
                    signup.put("password", et_password.getText().toString().trim());
                    signup.put("confirm_password", et_ConfPassword.getText().toString().trim());
                    signup.put("terms", "1");
                    //signup.put("city", et_city.getText().toString().trim());
                    JSONArray predefined_questions = new JSONArray();
                    for (int i = 0; i < spinnersPreDefinedQuestions.size(); i++) {
                        JSONObject inner = new JSONObject();
                        GenericObject obj = (GenericObject) spinnersPreDefinedQuestions.get(i).getItemAtPosition(spinnersPreDefinedQuestions.get(i).getSelectedItemPosition());
                        inner.put("id", obj.getId());
                        inner.put("answer", editTextsForPredefinedAnswer.get(i).getText().toString().trim());
                        predefined_questions.put(i, inner);
                    }
                    signup.put("predefined_questions", predefined_questions);
                    JSONArray own_questions = new JSONArray();
                    for (int i = 0; i < editTextsForCustomQuestions.size(); i++) {
                        JSONObject inner = new JSONObject();
                        inner.put("id", editTextsForCustomQuestions.get(i).getText().toString().trim());
                        inner.put("answer", editTextsForCustomAnswer.get(i).getText().toString().trim());
                        own_questions.put(i, inner);
                    }
                    signup.put("own_questions", own_questions);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                System.out.println(signup);

                if (((LoginActivity) getActivity()).networkConnectivity.isOnline()) {

                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SIGNUP_TAG, Constants.SIGNUP_URL, Constants.HTTP_POST, signup, "Home Activity");
                    a.execute();
                } else {
                    ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }

            }
//        }
    }

    private boolean validatePassword() {
        String password = et_password.getText().toString().trim();
        if (password.isEmpty()) {
            et_password.setError("Password field cannot be empty!", getResources().getDrawable(android.R.drawable.ic_dialog_alert));
            return false;

        } else if (!isValidPassword(password)) {
            et_password.setError("The password must be a minimum of 8 characters with at least one special character or number, at least one uppercase letter & at least one lower case letter", getResources().getDrawable(android.R.drawable.ic_dialog_alert));
            return false;
        } else {

        }
        return true;
    }

    private boolean isValidPassword(String password) {
        return password.matches(Constants.PASSWORD_REGEX_PATTERN);
    }


    private boolean validateEmail() {
        String email = et_email.getText().toString().trim();

        if (email.isEmpty()) {
            et_email.setError("Email required and must be unique!", getResources().getDrawable(android.R.drawable.ic_dialog_alert));
            requestFocus(et_email);
            return false;
        } else if (!isValidEmail(email)) {
            et_email.setError("Invalid email format!", getResources().getDrawable(android.R.drawable.ic_dialog_alert));
            requestFocus(et_email);
            return false;
        } else {

        }
        return true;
    }

    private static boolean isValidEmail(String email) {
        return !TextUtils.isEmpty(email) && android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches();
    }

    private void requestFocus(View view) {
        if (view.requestFocus()) {
            getActivity().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
        }
    }


    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((LoginActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((LoginActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            if (tag.equalsIgnoreCase(Constants.SIGNUP_TAG)) {
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        ((LoginActivity) getActivity()).dismissProgressDialog();
                        LoginFragment loginFragment = new LoginFragment();
                        FragmentManager fragmentManager = getFragmentManager();
                        FragmentTransaction transaction = fragmentManager.beginTransaction();
                        transaction.replace(R.id.container, loginFragment);
                        //fragmentTransaction.addToBackStack(HomeFragment.class.getName());
                        fragmentManager.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                        transaction.commit();

                        Toast.makeText(getActivity(), "You are successfully registered. Please check your mail to activate your account.", Toast.LENGTH_LONG).show();

                        Log.d("end Time", String.valueOf(System.currentTimeMillis()));
                    } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        if (jsonObject.has("errors")) {
                            if (!jsonObject.optJSONObject("errors").optString("username").isEmpty()) {
                                requestFocus(et_userName);
                                //deleteUser(registeredUser, jsonObject.optJSONObject("errors").optString("username"));
                                ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(jsonObject.optJSONObject("errors").optString("username"));
                            } else if (!jsonObject.optJSONObject("errors").optString("email").isEmpty()) {
                                requestFocus(et_email);
                                //deleteUser(registeredUser, jsonObject.optJSONObject("errors").optString("email"));
                                ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(jsonObject.optJSONObject("errors").optString("email"));
                            } else if (!jsonObject.optJSONObject("errors").optString("first_name").isEmpty()) {
                                //deleteUser(registeredUser, jsonObject.optJSONObject("errors").optString("first_name"));
                                ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(jsonObject.optJSONObject("errors").optString("first_name"));
                            } else if (!jsonObject.optJSONObject("errors").optString("last_name").isEmpty()) {
                                //deleteUser(registeredUser, jsonObject.optJSONObject("errors").optString("last_name"));
                                ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(jsonObject.optJSONObject("errors").optString("last_name"));
                            } else if (!jsonObject.optJSONObject("errors").optString("date_of_birth").isEmpty()) {
                                //deleteUser(registeredUser, jsonObject.optJSONObject("errors").optString("date_of_birth"));
                                ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(jsonObject.optJSONObject("errors").optString("date_of_birth"));
                            } else if (!jsonObject.optJSONObject("errors").optString("phoneno").isEmpty()) {
                                //deleteUser(registeredUser, jsonObject.optJSONObject("errors").optString("phoneno"));
                                ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(jsonObject.optJSONObject("errors").optString("phoneno"));
                            } else if (!jsonObject.optJSONObject("errors").optString("best_availablity").isEmpty()) {
                                //deleteUser(registeredUser, jsonObject.optJSONObject("errors").optString("best_availablity"));
                                ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(jsonObject.optJSONObject("errors").optString("best_availablity"));
                            }
                        } else {
                            ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(jsonObject.optString("message"));
                        }

                        ((LoginActivity) getActivity()).dismissProgressDialog();
                    }
                } catch (JSONException e) {
                    ((LoginActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.GET_COUNTRIES_LIST_WITH_STATES_TAG)) {
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    countries.clear();

                    /*CountryObject obj = new CountryObject();
                    obj.setId("0");
                    obj.setName("Select Country");
                    ArrayList<StatesObject> selectCityObjectList = new ArrayList<StatesObject>();
                    StatesObject selectCityObj = new StatesObject();
                    selectCityObj.setId("0");
                    selectCityObj.setName("Select State");
                    selectCityObjectList.add(selectCityObj);
                    obj.setStatesObjects(selectCityObjectList);
                    countries.add(obj);
*/

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
                            spinner_country.setAdapter(countryAdapter);

                            if (countryAdapter != null) {
                                for (int position = 0; position < countryAdapter.getCount(); position++) {
                                    if (countryAdapter.getId(position).equalsIgnoreCase(Constants.DEFAULT_COUNTRY_ID)) {
                                        spinner_country.setSelection(position);
                                    }
                                }
                            }
                        }

                    } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        countryAdapter = new CountryAdapter(getActivity(), 0, countries);
                        spinner_country.setAdapter(countryAdapter);
                    }
                } catch (JSONException e) {
                    ((LoginActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.PREDEFINED_QUESTIONS_TAG)) {
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    securityQuestionsList.clear();
                    GenericObject obj = new GenericObject();
                    obj.setId("0");
                    obj.setTitle("Select Security Question");
                    securityQuestionsList.add(obj);
                    if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        JSONArray question = jsonObject.optJSONArray("question");

                        for (int i = 0; i < question.length(); i++) {
                            GenericObject inner = new GenericObject();
                            inner.setId(question.getJSONObject(i).getString("id"));
                            inner.setTitle(question.getJSONObject(i).getString("name"));
                            securityQuestionsList.add(inner);
                        }

                        SpinnerAdapter adapter = new SpinnerAdapter(getActivity(), 0, securityQuestionsList);
                        spinner_chooseSecurityQuestion.setAdapter(adapter);
                        ((LoginActivity) getActivity()).dismissProgressDialog();
                    } else if (jsonObject.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        SpinnerAdapter adapter = new SpinnerAdapter(getActivity(), 0, securityQuestionsList);
                        spinner_chooseSecurityQuestion.setAdapter(adapter);
                        ((LoginActivity) getActivity()).dismissProgressDialog();
                    }
                } catch (JSONException e) {
                    ((LoginActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else {
                ((LoginActivity) getActivity()).dismissProgressDialog();
            }
        }
    }


    QBUser registeredUser;

    private void signupOnQuickBlox(final QBUser user) {
        Log.d("start Time", String.valueOf(System.currentTimeMillis()));
        final QBChatService chatService = QBChatService.getInstance();
        QBAuth.createSession(new QBEntityCallback<QBSession>() {
            @Override
            public void onSuccess(final QBSession session, Bundle params) {
                QBUsers.signUp(user, new QBEntityCallback<QBUser>() {
                    @Override
                    public void onSuccess(QBUser qbUser, Bundle bundle) {
                        Log.e("user", qbUser.toString());
                        registeredUser = qbUser;
                        if (((LoginActivity) getActivity()).networkConnectivity.isOnline()) {
                            try {
                                signup.put("quickbloxid", qbUser.getId());
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SIGNUP_TAG, Constants.SIGNUP_URL, Constants.HTTP_POST, signup, "Home Activity");
                            a.execute();
                        } else {
                            //deleteUser(qbUser, getString(R.string.no_internet_connection));
                        }
                    }

                    @Override
                    public void onError(QBResponseException e) {
                        ((LoginActivity) getActivity()).dismissProgressDialog();
                        UtilitiesClass.getInstance(getActivity()).alertDialogSingleButton(e.getMessage().toUpperCase(Locale.US));
                    }
                });
            }

            @Override
            public void onError(QBResponseException e) {
                ((LoginActivity) getActivity()).dismissProgressDialog();
            }
        });

    }

    private void deleteUser(QBUser user, final String message) {
        QBUsers.deleteUser(user.getId(), new QBEntityCallback<Void>() {
            @Override
            public void onSuccess(Void aVoid, Bundle bundle) {
                ((LoginActivity) getActivity()).dismissProgressDialog();
                ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(message);
            }

            @Override
            public void onError(QBResponseException e) {
                ((LoginActivity) getActivity()).dismissProgressDialog();
                ((LoginActivity) getActivity()).utilitiesClass.alertDialogSingleButton(message);
            }
        });
    }

    @Override
    public void onConnectionFailed(ConnectionResult connectionResult) {
        Log.d(TAG, "onConnectionFailed:" + connectionResult);
    }
}