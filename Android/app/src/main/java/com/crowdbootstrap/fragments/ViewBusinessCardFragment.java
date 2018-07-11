package com.crowdbootstrap.fragments;

import android.app.Dialog;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.util.Base64;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Spinner;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.adapter.ConnectionTypeAdapter;
import com.crowdbootstrap.helper.CircleImageView;
import com.crowdbootstrap.helper.TouchImageView;
import com.crowdbootstrap.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrap.logger.CrowdBootstrapLogger;
import com.crowdbootstrap.models.GenericObject;
import com.crowdbootstrap.utilities.AsyncNew;
import com.crowdbootstrap.utilities.Constants;
import com.crowdbootstrap.utilities.NetworkConnectivity;
import com.crowdbootstrap.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Sunakshi.Gautam on 11/29/2017.
 */

public class ViewBusinessCardFragment extends Fragment implements AsyncTaskCompleteListener<String> {


    private CircleImageView userImage;
    private ImageView businessCardImage;
    private EditText username, userBio, userInterest, userNotes, userStatement;
    public NetworkConnectivity networkConnectivity;
    public UtilitiesClass utilitiesClass;
    public DisplayImageOptions options;
    private RelativeLayout parent_layout;
    private LinearLayout layout;
    private Button btnConnect, btnViewNotes, btnAddNotes;
    private ConnectionTypeAdapter connectionAdapter;
    private Spinner connectionType;
    private int CONNECTION_TYPE_ID;
    private Button saveConnectionType;
    private ArrayList<GenericObject> keywordsList;
    private String str_businessConnectionTypeId, str_isNetwork, strUserImage, strUserName, cardID, connectionUserId, strComingFrom;


    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle("Business Card Details");
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_view_businesscard_details, container, false);

        userImage = (CircleImageView) rootView.findViewById(R.id.profileimage);
        businessCardImage = (ImageView) rootView.findViewById(R.id.businesscard_imageView);
        username = (EditText) rootView.findViewById(R.id.usernameLogedin);
        userBio = (EditText) rootView.findViewById(R.id.et_usersbio);
        userInterest = (EditText) rootView.findViewById(R.id.et_usersinterest);
        userNotes = (EditText) rootView.findViewById(R.id.et_usersNotes);
        userStatement = (EditText) rootView.findViewById(R.id.et_usersstatement);

        connectionType = (Spinner) rootView.findViewById(R.id.spinner_connectionType);
        imageUrl = "";
        parent_layout = (RelativeLayout) rootView.findViewById(R.id.parent_layout);
        layout = (LinearLayout) rootView.findViewById(R.id.layout);

        btnConnect = (Button) rootView.findViewById(R.id.btn_connect);
        btnViewNotes = (Button) rootView.findViewById(R.id.btn_viewnotes);
        btnAddNotes = (Button) rootView.findViewById(R.id.btn_addnote);
        saveConnectionType = (Button) rootView.findViewById(R.id.btn_save);

        keywordsList = new ArrayList<>();

        cardID = getArguments().getString("card_id").toString().trim();
        strUserName = getArguments().getString("userName").toString().trim();
        strUserImage = getArguments().getString("userImage").toString().trim();
        str_isNetwork = getArguments().getString("is_network").toString().trim();
        str_businessConnectionTypeId = getArguments().getString("business_contact_type").toString().trim();
        connectionUserId = getArguments().getString("connection_id").toString().trim();
        strComingFrom = getArguments().getString("comingFrom").trim();

        if (strComingFrom.compareTo("NotesList") == 0) {
            btnViewNotes.setVisibility(View.GONE);
            btnAddNotes.setText("Edit Note");
            userNotes.setText(getArguments().getString("noteDescription").trim());
        } else {
            btnViewNotes.setVisibility(View.VISIBLE);
            btnAddNotes.setText("Add Note");
        }


        if (!str_businessConnectionTypeId.isEmpty()) {
            btnConnect.setVisibility(View.VISIBLE);
            btnConnect.setText("Disconnect");
        } else {
            btnConnect.setVisibility(View.VISIBLE);
            btnConnect.setText("Connect");
        }


        options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.image)
                .showImageForEmptyUri(R.drawable.image)
                .showImageOnFail(R.drawable.image)
                .cacheInMemory(true)
                .cacheOnDisk(true)
                .considerExifParams(true)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();

        username.setText(strUserName);

        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + strUserImage, userImage, options);

        connectionType.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                CONNECTION_TYPE_ID = Integer.parseInt(keywordsList.get(position).getId());
                str_businessConnectionTypeId = String.valueOf(CONNECTION_TYPE_ID);
                //COUNTRY_ID = Integer.parseInt(countries.get(position).getId());

            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        try {
            if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                JSONObject object = new JSONObject();
                object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                object.put("card_id", cardID);
                AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.GET_BUSINESS_CARD_DETAILS_TAG, Constants.GET_BUSINESS_CARD_DETAILS_URL, Constants.HTTP_POST_REQUEST, object);
                a.execute();
            } else {

                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }


        btnConnect.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                if (btnConnect.getText().toString().compareTo("Connect") == 0) {

                    try {
                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            JSONObject object = new JSONObject();
                            object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            object.put("connected_to", connectionUserId);
                            object.put("business_card_id", cardID);
                            object.put("connection_type_id", str_businessConnectionTypeId);
                            AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ADD_BUSINESS_CONNECTION_TAG, Constants.ADD_BUSINESS_CONNECTION_URL, Constants.HTTP_POST_REQUEST, object);
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                } else if (btnConnect.getText().toString().compareTo("Disconnect") == 0) {

                    try {
                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            JSONObject object = new JSONObject();
                            object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            object.put("connected_to", connectionUserId);
                            object.put("business_card_id", cardID);
                            AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.DISCONNECT_BUSINESS_CONNECTION_TAG, Constants.DISCONNECT_BUSINESS_CONNECTION_URL, Constants.HTTP_POST_REQUEST, object);
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                }

            }
        });


        btnAddNotes.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                try {

                    if (strComingFrom.compareTo("NotesList") == 0) {

                        String noteId = getArguments().getString("noteId").toString().trim();


                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                            ((HomeActivity) getActivity()).showProgressDialog();

                            String noteText = userNotes.getText().toString().trim();
                            JSONObject object = new JSONObject();
                            object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            object.put("business_card_id", cardID);
                            object.put("description", noteText);
                            object.put("id", noteId);
                            AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.EDIT_BUSINESS_CONNECTION_NOTES_TAG, Constants.EDIT_BUSINESS_CONNECTION_NOTES_URL, Constants.HTTP_POST_REQUEST, object);
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }


                    } else {

                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                            ((HomeActivity) getActivity()).showProgressDialog();

                            String noteText = userNotes.getText().toString().trim();
                            JSONObject object = new JSONObject();
                            object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            object.put("business_card_id", cardID);
                            object.put("description", noteText);
                            AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ADD_BUSINESS_CONNECTION_NOTES_TAG, Constants.ADD_BUSINESS_CONNECTION_NOTES_URL, Constants.HTTP_POST_REQUEST, object);
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }

                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }


            }
        });


        btnViewNotes.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {


                Fragment NetworkingNotesList = new NetworkingNotesFragment();

                Bundle args = new Bundle();
                args.putString("connected_toId", cardID);
                NetworkingNotesList.setArguments(args);

                FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
                FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                fragmentTransaction.replace(R.id.container, NetworkingNotesList);
                fragmentTransaction.addToBackStack(HomeFragment.class.getName());

                fragmentTransaction.commit();


            }
        });


        saveConnectionType.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                try {
                    if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                        ((HomeActivity) getActivity()).showProgressDialog();
                        JSONObject object = new JSONObject();
                        object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                        object.put("connected_to", connectionUserId);
                        object.put("business_card_id", cardID);
                        object.put("connection_type_id", str_businessConnectionTypeId);
                        AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ADD_BUSINESS_CONNECTION_TAG, Constants.ADD_BUSINESS_CONNECTION_URL, Constants.HTTP_POST_REQUEST, object);
                        a.execute();
                    } else {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }
        });


        businessCardImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (!imageUrl.isEmpty()) {
                    alertDialog(imageUrl);
                }
            }
        });

        return rootView;
    }


    private String imageUrl;


    public void alertDialog(String imageUrl) {
        final Dialog dialog = new Dialog(getActivity());
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.pinch_and_zoom_imageview_dialog);

        final TouchImageView imageView = (TouchImageView) dialog.findViewById(R.id.roadmapImage);
        final Button okText = (Button) dialog.findViewById(R.id.btn_ok);

        Log.e("imageUrl", imageUrl);

        if (imageUrl.contains("http") || imageUrl.contains("https")) {
            ImageLoader.getInstance().displayImage(imageUrl, imageView, options);
        }


        okText.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });

        dialog.show();
    }


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

            if (tag.equals(Constants.GET_BUSINESS_CARD_DETAILS_TAG)) {
                CrowdBootstrapLogger.logInfo(result);
                try {
                    JSONObject jsonObject = new JSONObject(result);


                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        userBio.setText(jsonObject.getString("user_bio"));
                        userInterest.setText(jsonObject.getString("user_interest"));
                        userStatement.setText(jsonObject.getString("user_card_statement"));
                        userBio.setFocusable(false);
                        userInterest.setFocusable(false);
                        userStatement.setFocusable(false);

                        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.getString("image").trim(), businessCardImage);
                        imageUrl = Constants.APP_IMAGE_URL + jsonObject.getString("image").trim();


                        if (!jsonObject.getString("linkedin_username").isEmpty()) {
                            username.setText(jsonObject.getString("linkedin_username").toString().trim());
                        }

                        if (!jsonObject.getString("linkedin_image").isEmpty()) {
                            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + jsonObject.getString("linkedin_image").toString().trim(), userImage, options);

//                            byte[] decodedByte = Base64.decode(jsonObject.getString("linkedin_image"), 0);
//                            Bitmap newBitmap = BitmapFactory.decodeByteArray(decodedByte, 0, decodedByte.length);
//                            userImage.setImageBitmap(newBitmap);
                        }

                        try {
                            if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                                ((HomeActivity) getActivity()).showProgressDialog();
                                JSONObject object = new JSONObject();
                                object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                                AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BUSINESS_CONNECTION_TYPE_TAG, Constants.BUSINESS_CONNECTION_TYPE_URL, Constants.HTTP_POST_REQUEST, object);
                                a.execute();
                            } else {
                                ((HomeActivity) getActivity()).dismissProgressDialog();
                                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }


                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), jsonObject.optString("message").toString(), Toast.LENGTH_LONG).show();
                    }
                } catch (JSONException e) {

                    e.printStackTrace();
                }
            } else if (tag.equals(Constants.BUSINESS_CONNECTION_TYPE_TAG)) {
                try {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    JSONObject jsonObject = new JSONObject(result);
                    keywordsList.clear();
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        for (int i = 0; i < jsonObject.optJSONArray("businessConnectionTypes").length(); i++) {
                            GenericObject obj = new GenericObject();
                            obj.setId(jsonObject.optJSONArray("businessConnectionTypes").getJSONObject(i).optString("id"));
                            obj.setTitle(jsonObject.optJSONArray("businessConnectionTypes").getJSONObject(i).optString("name"));
                            obj.setPosition(i);
                            keywordsList.add(obj);
                        }

                        connectionAdapter = new ConnectionTypeAdapter(getActivity(), 0, keywordsList);
                        connectionType.setAdapter(connectionAdapter);

                        if (!str_businessConnectionTypeId.isEmpty()) {
                            CONNECTION_TYPE_ID = Integer.parseInt(str_businessConnectionTypeId);
                            if (connectionAdapter != null) {
                                for (int position = 0; position < connectionAdapter.getCount(); position++) {
                                    if (connectionAdapter.getId(position).equalsIgnoreCase(CONNECTION_TYPE_ID + "")) {
                                        connectionType.setSelection(position);
                                    }
                                }
                            }

                            connectionType.setEnabled(true);
                            saveConnectionType.setVisibility(View.VISIBLE);
                            btnConnect.setText("Disconnect");

                        } else {
                            btnConnect.setText("Connect");
                            connectionType.setEnabled(true);
                            saveConnectionType.setVisibility(View.GONE);
                        }

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        keywordsList.clear();
                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equals(Constants.ADD_BUSINESS_CONNECTION_TAG)) {

                try {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    JSONObject jsonObject = new JSONObject(result);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                        Toast.makeText(getActivity(), "User connected successfully", Toast.LENGTH_LONG).show();
                        getActivity().onBackPressed();
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), jsonObject.optString("message").toString(), Toast.LENGTH_LONG).show();

                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }

            } else if (tag.equals(Constants.DISCONNECT_BUSINESS_CONNECTION_TAG)) {
                try {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    JSONObject jsonObject = new JSONObject(result);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        btnConnect.setText("Connect");
                        saveConnectionType.setVisibility(View.GONE);
                        Toast.makeText(getActivity(), "User disconnected successfully", Toast.LENGTH_LONG).show();
                        getActivity().onBackPressed();
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        Toast.makeText(getActivity(), jsonObject.optString("message").toString(), Toast.LENGTH_LONG).show();
                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equals(Constants.ADD_BUSINESS_CONNECTION_NOTES_TAG)) {

                try {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    JSONObject jsonObject = new JSONObject(result);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                        Toast.makeText(getActivity(), "Note added successfully", Toast.LENGTH_LONG).show();

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), jsonObject.optString("message").toString(), Toast.LENGTH_LONG).show();

                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }

            } else if (tag.equals(Constants.EDIT_BUSINESS_CONNECTION_NOTES_TAG)) {
                try {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    JSONObject jsonObject = new JSONObject(result);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                        Toast.makeText(getActivity(), "Note updated successfully", Toast.LENGTH_LONG).show();
                        getActivity().onBackPressed();
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        Toast.makeText(getActivity(), jsonObject.optString("message").toString(), Toast.LENGTH_LONG).show();

                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            }
        }
    }
}
