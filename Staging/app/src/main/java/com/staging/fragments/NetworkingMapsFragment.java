package com.staging.fragments;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.support.annotation.ColorInt;
import android.support.annotation.DrawableRes;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.content.res.ResourcesCompat;
import android.util.Log;
import android.view.InflateException;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.location.LocationListener;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.GoogleMapOptions;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.UiSettings;
import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.MarkerInfoWindowAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.logger.CrowdBootstrapLogger;
import com.staging.models.GenericObject;
import com.staging.models.MyMarkerObject;
import com.staging.utilities.AsyncNew;
import com.staging.utilities.Constants;
import com.staging.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by Sunakshi.Gautam on 11/9/2017.
 */

public class NetworkingMapsFragment extends Fragment implements AsyncTaskCompleteListener<String> {

    private GoogleMap mMap;
    private String TAG = "GOOGLE_MAPS";
    private UiSettings mapSettings;
    private RadioGroup availabiltyRadioGroup;
    private RadioButton availableRadio, DNDRadio, busyRadio;
    private Button showBtn, hideBtn, setVisibility, viewGroup;
    private double longitude, latitude;
    private EditText searchText;
    private LinearLayout userGroupType;

    private ArrayList<MyMarkerObject> mMyMarkersArray = new ArrayList<MyMarkerObject>();
    private HashMap<Marker, MyMarkerObject> mMarkersHashMap;
    private Criteria criteria;

    public NetworkingMapsFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle("Map");
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);

    }

    LocationManager lm;

    private void shwMap(View rootView) {
        availabiltyRadioGroup = (RadioGroup) rootView.findViewById(R.id.availabilityRadioGroup);
        availableRadio = (RadioButton) rootView.findViewById(R.id.radio_available);
        DNDRadio = (RadioButton) rootView.findViewById(R.id.radio_dnd);
        busyRadio = (RadioButton) rootView.findViewById(R.id.radio_busy);
        showBtn = (Button) rootView.findViewById(R.id.showBtn);
        hideBtn = (Button) rootView.findViewById(R.id.hideBtn);
        searchText = (EditText) rootView.findViewById(R.id.et_search);
        setVisibility = (Button) rootView.findViewById(R.id.setVisibility);
        viewGroup = (Button) rootView.findViewById(R.id.viewGroup);
        userGroupType = (LinearLayout) rootView.findViewById(R.id.userGroupType);
        setVisibility.setBackgroundColor(Color.parseColor("#056a1f"));
        viewGroup.setBackgroundColor(Color.parseColor("#919191"));

        setUpMapIfNeeded();
        setVisibility.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                setVisibility.setBackgroundColor(Color.parseColor("#056a1f"));
                viewGroup.setBackgroundColor(Color.parseColor("#919191"));

                availabiltyRadioGroup.setVisibility(View.VISIBLE);
                userGroupType.setVisibility(View.GONE);


            }
        });
        viewGroup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                viewGroup.setBackgroundColor(Color.parseColor("#056a1f"));
                setVisibility.setBackgroundColor(Color.parseColor("#919191"));

                userGroupType.setVisibility(View.VISIBLE);
                availabiltyRadioGroup.setVisibility(View.GONE);
            }
        });

        searchText.setImeOptions(EditorInfo.IME_ACTION_DONE);
        searchText.setOnEditorActionListener(new EditText.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_DONE) {

                    try {
                        addMarkers();
                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            JSONObject object = new JSONObject();
                            object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            object.put("search_text", searchText.getText().toString().trim());
                            object.put("connection_type_id", "");
                            object.put("latitude", String.valueOf(latitude));
                            object.put("longitude", String.valueOf(longitude));
                            AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_WITHIN_MILES_TAG, Constants.USER_WITHIN_MILES_URL, Constants.HTTP_POST_REQUEST, object);
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    return true;
                }
                return false;
            }
        });

        availabiltyRadioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {

                if (checkedId == R.id.radio_available) {
                    try {
                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {

                            JSONObject object = new JSONObject();
                            object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            object.put("visibility_status", "1");
                            AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_VISIBILITY_TAG, Constants.USER_VISIBILITY_URL, Constants.HTTP_POST_REQUEST, object);
                            a.execute();
                        } else {

                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }


                } else if (checkedId == R.id.radio_dnd) {

                    try {
                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {

                            JSONObject object = new JSONObject();
                            object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            object.put("visibility_status", "2");
                            AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_VISIBILITY_TAG, Constants.USER_VISIBILITY_URL, Constants.HTTP_POST_REQUEST, object);
                            a.execute();
                        } else {

                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }


                } else if (checkedId == R.id.radio_busy) {

                    try {
                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {

                            JSONObject object = new JSONObject();
                            object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            object.put("visibility_status", "3");
                            AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_VISIBILITY_TAG, Constants.USER_VISIBILITY_URL, Constants.HTTP_POST_REQUEST, object);
                            a.execute();
                        } else {

                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }


                }
            }
        });

        //Fetching USER's Location and hiding and showing the user++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


        lm = (LocationManager) getActivity().getSystemService(Context.LOCATION_SERVICE);
        if (ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants t
            //
            //
            //
            // he permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.

        } else {


            Location location = lm.getLastKnownLocation(LocationManager.GPS_PROVIDER);

            if (location != null) {
                longitude = location.getLongitude();
                latitude = location.getLatitude();


                mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(location.getLatitude(), location.getLongitude()), 13));

                CameraPosition cameraPosition = new CameraPosition.Builder()
                        .target(new LatLng(latitude, longitude))      // Sets the center of the map to location user
                        .zoom(10)                   // Sets the zoom
//                        .bearing(90)                // Sets the orientation of the camera to east
//                        .tilt(40)                   // Sets the tilt of the camera to 30 degrees
                        .build();                   // Creates a CameraPosition from the builder
                mMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
            } else {
                Location locationFetched = getLastKnownPossibleLocation();


                if (locationFetched != null) {
                    longitude = locationFetched.getLongitude();
                    latitude = locationFetched.getLatitude();


                    mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(locationFetched.getLatitude(), locationFetched.getLongitude()), 13));

                    CameraPosition cameraPosition = new CameraPosition.Builder()
                            .target(new LatLng(latitude, longitude))      // Sets the center of the map to location user
                            .zoom(10)                   // Sets the zoom
//                            .bearing(90)                // Sets the orientation of the camera to east
//                            .tilt(40)                   // Sets the tilt of the camera to 30 degrees
                            .build();                   // Creates a CameraPosition from the builder
                    mMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
                }
                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            }
        }
        showBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                showBtn.setBackgroundColor(Color.parseColor("#056a1f"));
                hideBtn.setBackgroundColor(Color.parseColor("#919191"));

                try {
                    if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {

                        JSONObject object = new JSONObject();
                        object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                        object.put("status", "1");
                        object.put("latitude", String.valueOf(latitude));
                        object.put("longitude", String.valueOf(longitude));
                        AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_AVAILABILITY_TAG, Constants.USER_AVAILABILITY_URL, Constants.HTTP_POST_REQUEST, object);
                        a.execute();
                    } else {

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });

        hideBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                try {
                    hideBtn.setBackgroundColor(Color.parseColor("#056a1f"));
                    showBtn.setBackgroundColor(Color.parseColor("#919191"));

                    if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {

                        JSONObject object = new JSONObject();
                        object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                        object.put("status", "0");
                        object.put("latitude", String.valueOf(latitude));
                        object.put("longitude", String.valueOf(longitude));
                        AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_AVAILABILITY_TAG, Constants.USER_AVAILABILITY_URL, Constants.HTTP_POST_REQUEST, object);
                        a.execute();
                    } else {

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });


        try {

            addMarkers();

            if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                JSONObject object = new JSONObject();
                object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                object.put("search_text", "");
                object.put("connection_type_id", "");
                object.put("latitude", String.valueOf(latitude));
                object.put("longitude", String.valueOf(longitude));
                AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_WITHIN_MILES_TAG, Constants.USER_WITHIN_MILES_URL, Constants.HTTP_POST_REQUEST, object);
                a.execute();
            } else {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    View rootView;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        rootView = null;
        if (rootView != null) {
            ViewGroup parent = (ViewGroup) rootView.getParent();
            if (parent != null)
                parent.removeView(rootView);


        }
        try {
            rootView = inflater.inflate(R.layout.fragment_networkingmaps, container, false);

            shwMap(rootView);
        } catch (InflateException e) {
        /* map is already there, just return view as it is */
            Log.e("XXXX", "ISSUE+++" + e.getMessage());
        }
        return rootView;
    }

    private Location getLastKnownPossibleLocation() {
        List<String> providers = lm.getProviders(true);
        Location bestLocation = null;
        for (String provider : providers) {
            if (ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                // TODO: Consider calling
                //    ActivityCompat#requestPermissions
                // here to request the missing permissions, and then overriding
                //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                //                                          int[] grantResults)
                // to handle the case where the user grants the permission. See the documentation
                // for ActivityCompat#requestPermissions for more details.

            } else {
                Location l = lm.getLastKnownLocation(provider);
//            Log.d("last known location, provider: %s, location: %s", provider,
//                    l);

                if (l == null) {
                    continue;
                }
                if (bestLocation == null
                        || l.getAccuracy() < bestLocation.getAccuracy()) {
//                Log.d("found best last known location: %s", l);
                    bestLocation = l;
                }
            }
            if (bestLocation == null) {
                return null;
            }
        }
        return bestLocation;
    }

    private void setUpMapIfNeeded() {


        if (mMap == null) {

            mMap = ((SupportMapFragment) getChildFragmentManager()
                    .findFragmentById(R.id.map)).getMap();
            if (mMap != null) {
                GoogleMapOptions options = new GoogleMapOptions();
                options.mapType(GoogleMap.MAP_TYPE_NORMAL)
                        .camera(new CameraPosition(new LatLng(25f, 47f), 13f, 0f, 0f));


                if (ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {


                    ActivityCompat.requestPermissions(getActivity(), new String[]{
                                    Manifest.permission.ACCESS_FINE_LOCATION,
                                    Manifest.permission.ACCESS_COARSE_LOCATION},
                            1);

                } else {

                    mMap.setMyLocationEnabled(true);
                    mMap.setMapType(GoogleMap.MAP_TYPE_HYBRID);

                    mapSettings = mMap.getUiSettings();
                    mapSettings.setZoomControlsEnabled(true);
                    mapSettings.setScrollGesturesEnabled(true);
                    mapSettings.setTiltGesturesEnabled(true);
                    mapSettings.setRotateGesturesEnabled(true);


//                    LatLng MUSEUM = new LatLng(38.8874245, -77.0200729);
//                    Marker museum = mMap.addMarker(new MarkerOptions()
//                            .position(MUSEUM)
//                            .title("Museum")
//                            .snippet("National Air and Space Museum"));
//
//
//                    mMap.animateCamera(CameraUpdateFactory.zoomIn());
//                    mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(MUSEUM, 10));
                    try {
                        if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {

                            JSONObject object = new JSONObject();
                            object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BUSINESS_CONNECTION_TYPE_TAG, Constants.BUSINESS_CONNECTION_TYPE_URL, Constants.HTTP_POST_REQUEST, object);
                            a.execute();
                        } else {

                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                }
            } else {
                Log.d(TAG, "googleMap is null !!!!!!!!!!!!!!!");
            }
        }
    }

    private void addMarkers() {

        // Initialize the HashMap for Markers and MyMarker object
        mMarkersHashMap = new HashMap<Marker, MyMarkerObject>();

        mMap.clear();

    }


    private void plotMarkers(ArrayList<MyMarkerObject> markers) {
        if (markers.size() > 0) {
            for (MyMarkerObject myMarker : markers) {

                // Create user marker with custom icon and other options
                MarkerOptions markerOption = new MarkerOptions().position(new LatLng(myMarker.getmLatitude(), myMarker.getmLongitude()));
                if (myMarker.getMarkerType().compareTo("Single") == 0) {

                } else {
                    markerOption.icon(vectorToBitmap(R.drawable.google_group, Color.parseColor("#A4C639")));
                }

//                markerOption.icon(vectorToBitmap(R.drawable.app_icon, Color.parseColor("#A4C639")));

                Marker currentMarker = mMap.addMarker(markerOption);
                mMarkersHashMap.put(currentMarker, myMarker);

                mMap.setInfoWindowAdapter(new MarkerInfoWindowAdapter(mMarkersHashMap, getActivity()));


                mMap.setOnInfoWindowClickListener(new GoogleMap.OnInfoWindowClickListener() {
                    @Override
                    public void onInfoWindowClick(Marker marker) {

                        final MyMarkerObject myMarker = mMarkersHashMap.get(marker);
                        if (myMarker.getMarkerType().compareTo("Single") == 0) {
                            Bundle like = new Bundle();
                            like.putString("connection_id", myMarker.getUserId());
                            like.putString("is_network", "");
                            like.putString("business_contact_type", myMarker.getConnectionTypeID());
                            like.putString("card_id", myMarker.getCardID());
                            like.putString("userName", myMarker.getmLabel());
                            like.putString("userImage", myMarker.getmIcon());
                            like.putString("noteId", "");
                            like.putString("comingFrom", "com.staging");

                            Fragment likeFragment = new ViewBusinessCardFragment();
                            likeFragment.setArguments(like);
                            FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
                            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.add(R.id.container, likeFragment);
                            fragmentTransaction.addToBackStack(null);

                            fragmentTransaction.commit();
                        } else {

                            Bundle like = new Bundle();
                            like.putString("latitude", String.valueOf(myMarker.getmLatitude()));
                            like.putString("longitude", String.valueOf(myMarker.getmLongitude()));

                            Fragment likeFragment = new ConnectionsAtLatLongFragment();
                            likeFragment.setArguments(like);
                            FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
                            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.add(R.id.container, likeFragment);
                            fragmentTransaction.addToBackStack(null);

                            fragmentTransaction.commit();


                        }
                    }
                });
            }
        }
    }

    private BitmapDescriptor vectorToBitmap(@DrawableRes int id, @ColorInt int color) {
        Drawable vectorDrawable = ResourcesCompat.getDrawable(getResources(), id, null);
        Bitmap bitmap = Bitmap.createBitmap(vectorDrawable.getIntrinsicWidth(),
                vectorDrawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bitmap);
        vectorDrawable.setBounds(0, 0, 130, 130);
//        DrawableCompat.setTint(vectorDrawable, color);
        vectorDrawable.draw(canvas);
        return BitmapDescriptorFactory.fromBitmap(bitmap);
    }


    private ArrayList<GenericObject> keywordsList;

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

            if (tag.equals(Constants.USER_VISIBILITY_TAG)) {
                CrowdBootstrapLogger.logInfo(result);

                try {
                    JSONObject jsonObject = new JSONObject(result);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                        Toast.makeText(getActivity(), "User's availability updated successfully.", Toast.LENGTH_LONG).show();

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                    }
                } catch (JSONException e) {

                    e.printStackTrace();
                }
            } else if (tag.equals(Constants.USER_AVAILABILITY_TAG)) {
                CrowdBootstrapLogger.logInfo(result);

                try {
                    JSONObject jsonObject = new JSONObject(result);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                        Toast.makeText(getActivity(), "User's visibility updated successfully.", Toast.LENGTH_LONG).show();

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                    }
                } catch (JSONException e) {

                    e.printStackTrace();
                }
            } else if (tag.equals(Constants.USER_WITHIN_MILES_TAG)) {
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    mMarkersHashMap.clear();
                    mMyMarkersArray.clear();
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();

                        String userAvailiibilityStatus = jsonObject.optString("availability_status").toString();
                        String userVisibilityStatus = jsonObject.optString("visibility_status").toString();

                        if (userAvailiibilityStatus.compareTo("0") == 0) {
                            hideBtn.setBackgroundColor(Color.parseColor("#056a1f"));
                            showBtn.setBackgroundColor(Color.parseColor("#919191"));
                        } else {
                            showBtn.setBackgroundColor(Color.parseColor("#056a1f"));
                            hideBtn.setBackgroundColor(Color.parseColor("#919191"));
                        }


                        if (userVisibilityStatus.compareTo("1") == 0) {
                            availabiltyRadioGroup.check(availableRadio.getId());
                        } else if (userVisibilityStatus.compareTo("2") == 0) {
                            availabiltyRadioGroup.check(DNDRadio.getId());
                        } else if (userVisibilityStatus.compareTo("3") == 0) {
                            availabiltyRadioGroup.check(busyRadio.getId());
                        }

                        if (jsonObject.optJSONArray("user_list").length() != 0) {
                            for (int i = 0; i < jsonObject.optJSONArray("user_list").length(); i++) {
                                JSONObject contracotrs = jsonObject.optJSONArray("user_list").getJSONObject(i);
                                String userID = contracotrs.optString("user_id").toString().trim();
                                String userName = contracotrs.optString("user_name").toString().trim();
                                String strLatitude = contracotrs.optString("latitude").toString().trim();
                                String strLongitude = contracotrs.optString("longitude").toString().trim();
                                String user_image = contracotrs.optString("user_image").toString().trim();
                                String markerType = contracotrs.optString("type").toString().trim();
                                String count = contracotrs.optString("count").toString().trim();
                                String status = contracotrs.optString("visibility_status").toString().trim();
                                String userStatement = contracotrs.optString("user_card_statement").toString().trim();
                                String userConnectionType = contracotrs.optString("connection_type_id").toString().trim();
                                String cardID = contracotrs.optString("card_id").toString().trim();

                                if ((!strLatitude.isEmpty()) && (!strLongitude.isEmpty())) {
                                    mMyMarkersArray.add(new MyMarkerObject(userName, user_image, Double.parseDouble(strLatitude), Double.parseDouble(strLongitude), status, count, userID, markerType, userStatement, userConnectionType, cardID));
                                }

                            }
                        }


                        plotMarkers(mMyMarkersArray);


                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equals(Constants.BUSINESS_CONNECTION_TYPE_TAG)) {

                try {

                    JSONObject jsonObject = new JSONObject(result);
                    keywordsList = new ArrayList<>();
                    keywordsList.clear();

                    final RadioGroup group = new RadioGroup(getActivity());
                    group.setOrientation(RadioGroup.VERTICAL);
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        for (int i = 0; i < jsonObject.optJSONArray("businessConnectionTypes").length(); i++) {
                            GenericObject obj = new GenericObject();
                            obj.setId(jsonObject.optJSONArray("businessConnectionTypes").getJSONObject(i).optString("id"));
                            obj.setTitle(jsonObject.optJSONArray("businessConnectionTypes").getJSONObject(i).optString("name"));
                            obj.setPosition(i);

                            keywordsList.add(obj);

                            RadioButton btn1 = new RadioButton(getActivity());
                            btn1.setText(jsonObject.optJSONArray("businessConnectionTypes").getJSONObject(i).optString("name"));
                            group.addView(btn1);
                        }


                        userGroupType.addView(group);

                        group.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
                            @Override
                            public void onCheckedChanged(RadioGroup radioGroup, int i) {
                                RadioButton btn = (RadioButton) group.findViewById(i);
                                int checkedIndex = radioGroup.indexOfChild(btn);
//                                Log.e("XXXX", "INDEXSELECTED+++" + String.valueOf(checkedIndex)+"VALUE++++"+ keywordsList.get(checkedIndex).getId());
                                try {

                                    addMarkers();

                                    if (((HomeActivity) getActivity()).networkConnectivity.isInternetConnectionAvaliable()) {
                                        ((HomeActivity) getActivity()).showProgressDialog();
                                        JSONObject object = new JSONObject();
                                        object.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                                        object.put("search_text", "");
                                        object.put("connection_type_id", keywordsList.get(checkedIndex).getId());
                                        object.put("latitude", String.valueOf(latitude));
                                        object.put("longitude", String.valueOf(longitude));
                                        AsyncNew a = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.USER_WITHIN_MILES_TAG, Constants.USER_WITHIN_MILES_URL, Constants.HTTP_POST_REQUEST, object);
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


                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        keywordsList.clear();
                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }

            }
        }
    }
}
