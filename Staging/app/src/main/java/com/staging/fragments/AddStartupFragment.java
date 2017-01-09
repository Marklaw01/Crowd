package com.staging.fragments;

import android.Manifest;
import android.animation.Animator;
import android.animation.ValueAnimator;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.support.v4.app.FragmentTransaction;
import android.content.ContentResolver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.Window;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.KeywordsAdapter;
import com.staging.adapter.RoadMapAdapter;
import com.staging.helper.TouchImageView;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.listeners.onActivityResultListener;
import com.staging.models.GenericObject;
import com.staging.models.RoadMapObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.UtilityList;
import com.nostra13.universalimageloader.core.ImageLoader;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

/**
 * Created by neelmani.karn on 2/1/2016.
 */
public class AddStartupFragment extends Fragment implements onActivityResultListener, AsyncTaskCompleteListener<String> {

    private ArrayList<String> selectedKeywordList;
    private String selectedKeyword;
    /*Matrix matrix = new Matrix();
    Matrix savedMatrix = new Matrix();

    // We can be in one of these 3 states
    static final int NONE = 0;
    static final int DRAG = 1;
    static final int ZOOM = 2;
    int mode = NONE;

    // Remember some things for zooming
    PointF start = new PointF();
    PointF mid = new PointF();
    float oldDist = 1f;*/


    private LinearLayout layout;
    private Uri fileUri;
    private ArrayList<RoadMapObject> startupsObjectsList;
    private ArrayList<GenericObject> keywordsList;
    private ListView list_startups;
    private ValueAnimator mAnimator;

    private LinearLayout expendableRoadMapLayout, roadmapLayout, roadmapGraphiclayout, roadmapGraphic, roadmapGraphicexpandable;
    private EditText nextRoadMapStep, startupName, description, supportrequired, keyword;
    private LinearLayout roadMapEditText;
    private Button submit, btnEditRoadmap;
    private ImageView viewRoadmapArrow, viewroadmapGraphicArrow, image_roadmap;
    private RoadMapAdapter adapter;
    //private boolean startupInfoSubmitted = false;

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle("Create Startup");
        ((HomeActivity) getActivity()).setOnActivityResultListener(this);
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        /*if (startupInfoSubmitted == true) {
            startupInfoSubmitted = false;
            roadmapLayout.setVisibility(View.GONE);
            roadmapGraphiclayout.setVisibility(View.GONE);
            nextRoadMapStep.setVisibility(View.GONE);
            startupName.setVisibility(View.VISIBLE);
            description.setVisibility(View.VISIBLE);
            keyword.setVisibility(View.VISIBLE);
            supportrequired.setVisibility(View.VISIBLE);

            startupName.setText("");
            description.setText("");
            keyword.setText("");
            supportrequired.setText("");
        } else {
            nextRoadMapStep.setText("");
            startupName.setText("");
            description.setText("");
            supportrequired.setText("");
            keyword.setText("");
        }*/

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_add_startup, container, false);

        try {
            layout = (LinearLayout) rootView.findViewById(R.id.layout);
            selectedKeywordList = new ArrayList<String>();


            roadmapGraphiclayout = (LinearLayout) rootView.findViewById(R.id.roadmapGraphiclayout);
            expendableRoadMapLayout = (LinearLayout) rootView.findViewById(R.id.roadmapexpandable);
            roadmapGraphicexpandable = (LinearLayout) rootView.findViewById(R.id.roadmapGraphicexpandable);
            roadMapEditText = (LinearLayout) rootView.findViewById(R.id.roadmap);
            roadmapGraphic = (LinearLayout) rootView.findViewById(R.id.roadmapGraphic);
            submit = (Button) rootView.findViewById(R.id.submitstartup);
            viewRoadmapArrow = (ImageView) rootView.findViewById(R.id.viewroadmapArrow);
            viewroadmapGraphicArrow = (ImageView) rootView.findViewById(R.id.viewroadmapGraphicArrow);
            image_roadmap = (ImageView) rootView.findViewById(R.id.image_roadmap);

            roadmapLayout = (LinearLayout) rootView.findViewById(R.id.roadmaplayout);
            roadmapGraphicexpandable = (LinearLayout) rootView.findViewById(R.id.roadmapGraphicexpandable);


            btnEditRoadmap = (Button) rootView.findViewById(R.id.btn_editroadmap);

            list_startups = (ListView) rootView.findViewById(R.id.list_startups);
            startupsObjectsList = new ArrayList<RoadMapObject>();

            nextRoadMapStep = (EditText) rootView.findViewById(R.id.nextstep);
            startupName = (EditText) rootView.findViewById(R.id.startupname);
            description = (EditText) rootView.findViewById(R.id.startupdesc);
            supportrequired = (EditText) rootView.findViewById(R.id.supportrequired);
            keyword = (EditText) rootView.findViewById(R.id.add_keyword);

            // roadMapEditText.setFocusable(false);

            nextRoadMapStep.setVisibility(View.GONE);
            roadmapLayout.setVisibility(View.GONE);
            roadmapGraphiclayout.setVisibility(View.GONE);

            startupName.setVisibility(View.VISIBLE);
            description.setVisibility(View.VISIBLE);
            keyword.setVisibility(View.VISIBLE);
            supportrequired.setVisibility(View.VISIBLE);


            keyword.setFocusable(false);
            keywordsList = new ArrayList<GenericObject>();

            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_KEYWORDS_TAG, Constants.STARTUP_KEYWORDS_URL, Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }


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
                        final EditText search = (EditText) dialog.findViewById(R.id.et_search);
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


        /*keyword.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (keywordsList.size() == 0) {
                    Toast.makeText(getActivity(), "No Keywords in available!", Toast.LENGTH_LONG).show();
                } else {

                    final ArrayList<GenericObject> tempArray = new ArrayList<GenericObject>();
                    for (int i = 0; i < keywordsList.size(); i++) {
                        tempArray.add(i, keywordsList.get(i));
                    }
                    String[] deviceNameArr = new String[keywordsList.size()];
                    final boolean[] selectedItems = new boolean[keywordsList.size()];
                    for (int i = 0; i < deviceNameArr.length; i++) {
                        deviceNameArr[i] = keywordsList.get(i).getTitle();
                        selectedItems[i] = keywordsList.get(i).ischecked();
                    }
                    final AlertDialog.Builder builderDialog = new AlertDialog.Builder(new ContextThemeWrapper(getActivity(), R.style.AlertDialogCustom));
                    builderDialog.setTitle("Keywords");

                    builderDialog.setMultiChoiceItems(deviceNameArr, selectedItems, new DialogInterface.OnMultiChoiceClickListener() {
                                public void onClick(DialogInterface dialog, int whichButton, boolean isChecked) {

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
                                                stringBuilder.append(",");
                                            stringBuilder.append(list.getItemAtPosition(i));
                                            keywordsList.get(i).setIschecked(checked);
                                        } else {

                                            keywordsList.get(i).setIschecked(checked);
                                        }
                                    }
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
                                    keyword.setText("Keywords: " + stringBuilder.toString());
                                }
                            });

                    builderDialog.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {

                        @Override
                        public void onClick(DialogInterface dialog, int which) {
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
                        }
                    });


                    AlertDialog alert = builderDialog.create();
                    alert.show();
                }
            }
        });*/

            expendableRoadMapLayout.getViewTreeObserver().addOnPreDrawListener(
                    new ViewTreeObserver.OnPreDrawListener() {

                        @Override
                        public boolean onPreDraw() {
                            expendableRoadMapLayout.getViewTreeObserver().removeOnPreDrawListener(this);
                            expendableRoadMapLayout.setVisibility(View.GONE);

                            final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            final int heightSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            expendableRoadMapLayout.measure(widthSpec, heightSpec);

                            mAnimator = slideAnimator(0, expendableRoadMapLayout.getMeasuredHeight());
                            return true;
                        }
                    });


            roadmapGraphicexpandable.getViewTreeObserver().addOnPreDrawListener(
                    new ViewTreeObserver.OnPreDrawListener() {

                        @Override
                        public boolean onPreDraw() {
                            roadmapGraphicexpandable.getViewTreeObserver().removeOnPreDrawListener(this);
                            roadmapGraphicexpandable.setVisibility(View.GONE);

                            final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            final int heightSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                            roadmapGraphicexpandable.measure(widthSpec, heightSpec);

                            mAnimator = slideAnimatorForRoadmapGraphic(0, roadmapGraphicexpandable.getMeasuredHeight());
                            return true;
                        }
                    });


            roadMapEditText.setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(View v) {
                    if (expendableRoadMapLayout.getVisibility() == View.GONE) {
                        viewRoadmapArrow.setBackground(getResources().getDrawable(R.drawable.arrow_upward));
                        expand();
                    } else {
                        viewRoadmapArrow.setBackground(getResources().getDrawable(R.drawable.arrow_downward));
                        collapse();
                    }
                }
            });


            roadmapGraphic.setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(View v) {
                    if (roadmapGraphicexpandable.getVisibility() == View.GONE) {
                        viewroadmapGraphicArrow.setBackground(getResources().getDrawable(R.drawable.arrow_upward));
                        expandForRoadmapGraphic();
                    } else {
                        viewroadmapGraphicArrow.setBackground(getResources().getDrawable(R.drawable.arrow_downward));
                        collapseForRoadmapGraphic();
                    }
                }
            });

            for (int i = 0; i < 5; i++) {
                RoadMapObject audioObject = new RoadMapObject();
                audioObject.setRoadmapName("Deliverable " + (i + 1));
                startupsObjectsList.add(audioObject);
            }

            adapter = new RoadMapAdapter(getActivity(), startupsObjectsList);
            list_startups.setAdapter(adapter);
            UtilityList.setListViewHeightBasedOnChildren(list_startups);
            btnEditRoadmap.setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(View v) {

                    //startupInfoSubmitted = true;

                    alertDialogForPicture();

                    /*Fragment startupDocs = new StartUpDocsDetailFragment();
                    FragmentTransaction transactionAdd = getFragmentManager().beginTransaction();

                    transactionAdd.replace(R.id.container, startupDocs);
                    transactionAdd.addToBackStack(null);

                    transactionAdd.commit();*/
                }
            });


            submit.setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(View v) {

                    // if (startupInfoSubmitted == false) {
                    //   startupInfoSubmitted = true;
                   /* roadmapLayout.setVisibility(View.VISIBLE);
                    roadmapGraphiclayout.setVisibility(View.VISIBLE);
                    nextRoadMapStep.setVisibility(View.VISIBLE);

                    startupName.setVisibility(View.GONE);
                    description.setVisibility(View.GONE);
                    keyword.setVisibility(View.GONE);
                    supportrequired.setVisibility(View.GONE);*/

                    InputMethodManager inputMethodManager = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
                    inputMethodManager.hideSoftInputFromWindow(getActivity().getCurrentFocus().getWindowToken(), 0);
                    JSONObject addStartupObj = new JSONObject();


                    if (startupName.getText().toString().trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Startup Name is required!", Toast.LENGTH_LONG).show();
                    } else if (keyword.getText().toString().trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Select At-Least one keyword!", Toast.LENGTH_LONG).show();
                    } else if (supportrequired.getText().toString().trim().isEmpty()) {
                        Toast.makeText(getActivity(), "Support required field cannot be left blank!", Toast.LENGTH_LONG).show();
                    } else {
                        try {
                            addStartupObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                            addStartupObj.put("name", startupName.getText().toString().trim());
                            addStartupObj.put("description", description.getText().toString().trim());
                            addStartupObj.put("support_required", supportrequired.getText().toString().trim());
                            addStartupObj.put("keywords", selectedKeyword);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                            ((HomeActivity) getActivity()).showProgressDialog();
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ADD_STARTUP_TAG, Constants.ADD_STARTUP_URL, Constants.HTTP_POST, addStartupObj,"Home Activity");
                            a.execute();
                        } else {
                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                        }
                    }


                    // } else if (startupInfoSubmitted == true) {
                     /*   startupInfoSubmitted = false;
                        roadmapLayout.setVisibility(View.GONE);
                        roadmapGraphiclayout.setVisibility(View.GONE);
                        nextRoadMapStep.setVisibility(View.GONE);

                        startupName.setVisibility(View.VISIBLE);
                        description.setVisibility(View.VISIBLE);
                        keyword.setVisibility(View.VISIBLE);
                        supportrequired.setVisibility(View.VISIBLE);

                        startupName.setText("");
                        description.setText("");
                        keyword.setText("");
                        supportrequired.setText("");
                        Toast.makeText(getActivity(), "Information added successfully!", Toast.LENGTH_LONG).show();
                    }*/

                }
            });


            image_roadmap.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (filepath != null) {
                        alertDialog(filepath);
                    } else {
                        alertDialog(Constants.APP_IMAGE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_PROFILE_IMAGE_URL));
                    }

                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }


        return rootView;
    }


    public void alertDialog(String imageUrl) {
        try {
            final Dialog dialog = new Dialog(getActivity());
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
            dialog.setContentView(R.layout.pinch_and_zoom_imageview_dialog);

            final TouchImageView imageView = (TouchImageView) dialog.findViewById(R.id.roadmapImage);
            final Button okText = (Button) dialog.findViewById(R.id.btn_ok);
            if (imageUrl.contains("http") || imageUrl.contains("https")) {
                ImageLoader.getInstance().displayImage(imageUrl, imageView, ((HomeActivity) getActivity()).options);


                /*try {
                    Picasso.with(getActivity())
                            .load(imageUrl)
                            .placeholder(R.drawable.image)
                            .error(R.drawable.app_icon)
                            .into(imageView);
                } catch (Exception e) {
                    e.printStackTrace();
                }*/
            } else {

                int orientation;
                try {
                    System.out.println(imageUrl);
                    // Decode image size
                    BitmapFactory.Options o = new BitmapFactory.Options();
                    o.inJustDecodeBounds = true;
                    BitmapFactory.decodeFile(imageUrl, o);
                    // The new size we want to scale to
                    final int REQUIRED_SIZE = 1024;
                    // Find the correct scale value. It should be the power of 2.
                    int width_tmp = o.outWidth, height_tmp = o.outHeight;
                    int scale = 1;
                    while (true) {
                        if (width_tmp < REQUIRED_SIZE && height_tmp < REQUIRED_SIZE)
                            break;
                        width_tmp /= 2;
                        height_tmp /= 2;
                        scale *= 2;
                    }

                    BitmapFactory.Options o2 = new BitmapFactory.Options();
                    o2.inSampleSize = scale;
                    bitmap = BitmapFactory.decodeFile(imageUrl, o2);
                    imageView.setImageBitmap(bitmap);
                } catch (Exception e) {
                    e.printStackTrace();
                    imageView.setImageResource(R.drawable.image);
                }

            }

        /*imageView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {

                ImageView view = (ImageView) v;
                // make the image scalable as a matrix
                view.setScaleType(ImageView.ScaleType.MATRIX);
                float scale;

                // Handle touch events here...
                switch (event.getAction() & MotionEvent.ACTION_MASK) {

                    case MotionEvent.ACTION_DOWN: //first finger down only
                        savedMatrix.set(matrix);
                        start.set(event.getX(), event.getY());
                        //Log.d(TAG, "mode=DRAG");
                        mode = DRAG;
                        break;
                    case MotionEvent.ACTION_UP: //first finger lifted
                    case MotionEvent.ACTION_POINTER_UP: //second finger lifted
                        mode = NONE;
                        //Log.d(TAG, "mode=NONE" );
                        break;
                    case MotionEvent.ACTION_POINTER_DOWN: //second finger down
                        oldDist = spacing(event); // calculates the distance between two points where user touched.
                        // Log.d(TAG, "oldDist=" + oldDist);
                        // minimal distance between both the fingers
                        if (oldDist > 5f) {
                            savedMatrix.set(matrix);
                            midPoint(mid, event); // sets the mid-point of the straight line between two points where user touched.
                            mode = ZOOM;
                            // Log.d(TAG, "mode=ZOOM");
                        }
                        break;

                    case MotionEvent.ACTION_MOVE:
                        if (mode == DRAG) { //movement of first finger
                            matrix.set(savedMatrix);
                            if (view.getLeft() >= -392) {
                                matrix.postTranslate(event.getX() - start.x, event.getY() - start.y);
                            }
                        } else if (mode == ZOOM) { //pinch zooming
                            float newDist = spacing(event);
                            //Log.d(TAG, "newDist=" + newDist);
                            if (newDist > 5f) {
                                matrix.set(savedMatrix);
                                scale = newDist / oldDist; //thinking I need to play around with this value to limit it**
                                matrix.postScale(scale, scale, mid.x, mid.y);
                            }
                        }
                        break;
                }

                // Perform the transformation
                view.setImageMatrix(matrix);

                return true; // indicate event was handled

            }
        });*/

            okText.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    dialog.dismiss();
                }
            });

            dialog.show();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /*private float spacing(MotionEvent event) {
        float x = event.getX(0) - event.getX(1);
        float y = event.getY(0) - event.getY(1);

        return (float) Math.sqrt(x * x + y * y);
        //return FloatMath.sqrt(x * x + y * y);
    }

    private void midPoint(PointF point, MotionEvent event) {
        float x = event.getX(0) + event.getX(1);
        float y = event.getY(0) + event.getY(1);
        point.set(x / 2, y / 2);
    }*/

    public AddStartupFragment() {
        super();
    }


    private void expand() {
        //set Visible
        expendableRoadMapLayout.setVisibility(View.VISIBLE);

		/* Remove and used in preDrawListener
        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
		final int heightSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
		mLinearLayout.measure(widthSpec, heightSpec);
		mAnimator = slideAnimator(0, mLinearLayout.getMeasuredHeight());
		*/

        mAnimator.start();
    }

    private void collapse() {
        try {
            int finalHeight = expendableRoadMapLayout.getHeight();

            ValueAnimator mAnimator = slideAnimator(finalHeight, 0);

            mAnimator.addListener(new Animator.AnimatorListener() {
                @Override
                public void onAnimationEnd(Animator animator) {
                    //Height=0, but it set visibility to GONE
                    expendableRoadMapLayout.setVisibility(View.GONE);
                }

                @Override
                public void onAnimationStart(Animator animator) {
                }

                @Override
                public void onAnimationCancel(Animator animator) {
                }

                @Override
                public void onAnimationRepeat(Animator animator) {
                }
            });
            mAnimator.start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void expandForRoadmapGraphic() {
        //set Visible
        roadmapGraphicexpandable.setVisibility(View.VISIBLE);

		/* Remove and used in preDrawListener
        final int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
		final int heightSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
		mLinearLayout.measure(widthSpec, heightSpec);
		mAnimator = slideAnimator(0, mLinearLayout.getMeasuredHeight());
		*/

        mAnimator.start();
    }

    private void collapseForRoadmapGraphic() {
        try {
            int finalHeight = roadmapGraphicexpandable.getHeight();

            ValueAnimator mAnimator = slideAnimator(finalHeight, 0);

            mAnimator.addListener(new Animator.AnimatorListener() {
                @Override
                public void onAnimationEnd(Animator animator) {
                    //Height=0, but it set visibility to GONE
                    roadmapGraphicexpandable.setVisibility(View.GONE);
                }

                @Override
                public void onAnimationStart(Animator animator) {
                }

                @Override
                public void onAnimationCancel(Animator animator) {
                }

                @Override
                public void onAnimationRepeat(Animator animator) {
                }
            });
            mAnimator.start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private ValueAnimator slideAnimator(int start, int end) {

        ValueAnimator animator = ValueAnimator.ofInt(start, end);


        try {
            animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                @Override
                public void onAnimationUpdate(ValueAnimator valueAnimator) {
                    //Update Height
                    int value = (Integer) valueAnimator.getAnimatedValue();

                    ViewGroup.LayoutParams layoutParams = expendableRoadMapLayout.getLayoutParams();
                    layoutParams.height = value;
                    expendableRoadMapLayout.setLayoutParams(layoutParams);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return animator;
    }

    private ValueAnimator slideAnimatorForRoadmapGraphic(int start, int end) {

        ValueAnimator animator = ValueAnimator.ofInt(start, end);


        try {
            animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                @Override
                public void onAnimationUpdate(ValueAnimator valueAnimator) {
                    //Update Height
                    int value = (Integer) valueAnimator.getAnimatedValue();

                    ViewGroup.LayoutParams layoutParams = roadmapGraphicexpandable.getLayoutParams();
                    layoutParams.height = value;
                    roadmapGraphicexpandable.setLayoutParams(layoutParams);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return animator;
    }


    protected void alertDialogForPicture() {
        try {
            AlertDialog.Builder builderSingle = new AlertDialog.Builder(getActivity()/*new ContextThemeWrapper(getActivity(), android.R.style.Theme_Holo_Light_Dialog)*/);
            final CharSequence[] opsChars = {"Upload Image", "Take Picture"};
            builderSingle.setCancelable(true);
            builderSingle.setItems(opsChars, new DialogInterface.OnClickListener() {

                @Override
                public void onClick(DialogInterface dialog, int which) {
                    if ((ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                        requestPermission();
                    } else {
                        switch (which) {

                            case 0:
                                try {
                                    Intent i = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);

                                    getActivity().startActivityForResult(i, Constants.FILE_PICKER);
                                } catch (Exception e) {
                                    Toast.makeText(getActivity(), "Please provide permission of Sd-Card from apps permission setting", Toast.LENGTH_LONG).show();
                                }
                                break;
                            case 1:

                                try {

                                    Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                                    fileUri = getOutputMediaFileUri(Constants.FILE_PICKER);
                                    intent.putExtra(MediaStore.EXTRA_OUTPUT, fileUri);
                                    getActivity().startActivityForResult(intent, Constants.CAMERA_CAPTURE_IMAGE_REQUEST_CODE);


                                } catch (SecurityException e) {
                                    Toast.makeText(getActivity(), "Please provide permission of camera from apps permission setting", Toast.LENGTH_LONG).show();
                                    e.printStackTrace();
                                }
                        }
                    }
                }
            });
            builderSingle.show();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Requests the Camera permission.
     * If the permission has been denied previously, a SnackBar will prompt the user to grant the
     * permission, otherwise it is requested directly.
     */
    private void requestPermission() {
        try {
            Log.i("TAG", "CAMERA permission has NOT been granted. Requesting permission.");

            // BEGIN_INCLUDE(camera_permission_request)
            if ((ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.CAMERA)) && ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE)) {
                // Provide an additional rationale to the user if the permission was not granted
                // and the user would benefit from additional context for the use of the permission.
                // For example if the user has previously denied the permission.
                Log.i("TAG", "Displaying camera permission rationale to provide additional context.");

                Snackbar.make(layout, R.string.app_permision, Snackbar.LENGTH_INDEFINITE)
                        .setAction("OK", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.CAMERA, Manifest.permission.READ_EXTERNAL_STORAGE}, Constants.APP_PERMISSION);
                            }
                        })
                        .show();
            } else {

                // Camera permission has not been granted yet. Request it directly.
                ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.CAMERA, Manifest.permission.READ_EXTERNAL_STORAGE}, Constants.APP_PERMISSION);
            }
            // END_INCLUDE(camera_permission_request)
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Callback received when a permissions request has been completed.
     */
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {

        try {
            if (requestCode == Constants.APP_PERMISSION) {
                // BEGIN_INCLUDE(permission_result)
                // Received permission result for camera permission.
                Log.i("TAG", "Received response for Camera permission request.");

                // Check if the only required permission has been granted
                if (grantResults.length == 1 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // Camera permission has been granted, preview can be displayed
                    Log.i("TAG", "CAMERA permission has now been granted. Showing preview.");
                    Snackbar.make(layout, R.string.permision_available_camera, Snackbar.LENGTH_SHORT).show();
                } else {
                    Log.i("TAG", "CAMERA permission was NOT granted.");
                    Snackbar.make(layout, R.string.permissions_not_granted, Snackbar.LENGTH_SHORT).show();
                }
            } else {
                super.onRequestPermissionsResult(requestCode, permissions, grantResults);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private Bitmap bitmap;
    public String filepath;
    public String fileName;


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        // TODO Auto-generated method stub
        super.onActivityResult(requestCode, resultCode, data);
        try {
            switch (requestCode) {

                case Constants.CAMERA_CAPTURE_IMAGE_REQUEST_CODE:

                    // if the result is capturing Image
                    if (requestCode == Constants.CAMERA_CAPTURE_IMAGE_REQUEST_CODE) {
                        if (resultCode == Activity.RESULT_OK) {
                            // successfully captured the image
                            // display it in image view
                            try {
                                // bimatp factory
                                BitmapFactory.Options options = new BitmapFactory.Options();

                                // downsizing image as it throws OutOfMemory Exception for larger
                                // images
                                options.inSampleSize = 8;

                                filepath = fileUri.getPath();
                                decodeFile(filepath, fileUri);
                            } catch (NullPointerException e) {
                                e.printStackTrace();
                            }
                        } else if (resultCode == Activity.RESULT_CANCELED) {
                            // user cancelled Image capture
                            Toast.makeText(getActivity(),
                                    "User cancelled image capture", Toast.LENGTH_LONG)
                                    .show();
                        } else {
                            // failed to capture image
                            Toast.makeText(getActivity(),
                                    "Sorry! Failed to capture image", Toast.LENGTH_LONG)
                                    .show();
                        }
                    }

                    break;
                case Constants.FILE_PICKER:

                    if (resultCode == Activity.RESULT_OK) {
                        Uri selectedImageUri = data.getData();
                        System.out.println("selectedImageUri " + selectedImageUri);

                        try {
                            String filemanagerstring = selectedImageUri.getPath();
                            System.out.println("filemanagerstring " + filemanagerstring);
                            String selectedImagePath = getPath(getActivity(), selectedImageUri);
                            System.out.println("selectedImagePath " + selectedImagePath);
                            if (selectedImagePath != null) {
                                filepath = selectedImagePath;
                            } else if (filemanagerstring != null) {
                                filepath = filemanagerstring;
                            } else {
                                Toast.makeText(getActivity(), "Unknown path", Toast.LENGTH_LONG).show();
                            }

                            if (filepath.contains("http") || filepath.contains("https")) {
                                Toast.makeText(getActivity(), "Unknown path", Toast.LENGTH_LONG).show();
                            } else if (filepath != null) {
                                int a = filepath.lastIndexOf("/");
                                fileName = filepath.substring(a + 1);
                                decodeFile(filepath, selectedImageUri);
                            }
                        } catch (Exception e) {
                            System.out.println(e);
                            Toast.makeText(getActivity(), "Internal error", Toast.LENGTH_LONG).show();
                        }
                    }
                    break;
                default:
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * Creating file uri to store image/video
     */
    public Uri getOutputMediaFileUri(int type) {
        return Uri.fromFile(getOutputMediaFile(type));
    }

    /**
     * returning image / video
     */
    private static File getOutputMediaFile(int type) {

        try {
            // External sdcard location
            File mediaStorageDir = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM), Constants.IMAGE_DIRECTORY_NAME);

            // Create the storage directory if it does not exist
            if (!mediaStorageDir.exists()) {
                if (!mediaStorageDir.mkdirs()) {
                    Log.d(Constants.IMAGE_DIRECTORY_NAME, "Oops! Failed create " + Constants.IMAGE_DIRECTORY_NAME + " directory");
                    return null;
                }
            }

            // Create a media file name
            String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(new Date());
            File mediaFile;
            if (type == Constants.FILE_PICKER) {
                mediaFile = new File(mediaStorageDir.getPath() + File.separator + "IMG_" + timeStamp + ".jpg");
            } else {
                return null;
            }
            System.out.println("media file " + mediaFile.getAbsolutePath());
            return mediaFile;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public String getPath(Context context, Uri uri) {

        try {
            ContentResolver content = context.getContentResolver();
            String[] projection = {MediaStore.Images.Media.DATA};
            Cursor cursor = content.query(uri, projection, null, null, null);
            if (cursor != null) {
                int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
                cursor.moveToFirst();
                String s = cursor.getString(column_index);
                //cursor.close();
                return s;

            } else
                return null;
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            return null;
        }
    }

    public void decodeFile(String filePath, Uri selectedImageUri) {
        int orientation;
        try {
            System.out.println(filePath);
            // Decode image size
            BitmapFactory.Options o = new BitmapFactory.Options();
            o.inJustDecodeBounds = true;
            BitmapFactory.decodeFile(filePath, o);
            // The new size we want to scale to
            final int REQUIRED_SIZE = 1024;
            // Find the correct scale value. It should be the power of 2.
            int width_tmp = o.outWidth, height_tmp = o.outHeight;
            int scale = 1;
            while (true) {
                if (width_tmp < REQUIRED_SIZE && height_tmp < REQUIRED_SIZE)
                    break;
                width_tmp /= 2;
                height_tmp /= 2;
                scale *= 2;
            }

            BitmapFactory.Options o2 = new BitmapFactory.Options();
            o2.inSampleSize = scale;
            bitmap = BitmapFactory.decodeFile(filePath, o2);
            image_roadmap.setImageBitmap(bitmap);
        } catch (Exception e) {
            e.printStackTrace();
            image_roadmap.setImageResource(R.drawable.image);
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
            } else if (result.contains("<pre")) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
            } else {
                if (tag.equalsIgnoreCase(Constants.STARTUP_KEYWORDS_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        keywordsList.clear();
                        for (int i = 0; i < jsonObject.optJSONArray("startup_keywords").length(); i++) {
                            GenericObject obj = new GenericObject();
                            obj.setId(jsonObject.optJSONArray("startup_keywords").getJSONObject(i).optString("id"));
                            obj.setTitle(jsonObject.optJSONArray("startup_keywords").getJSONObject(i).optString("name"));
                            obj.setIschecked(false);
                            keywordsList.add(obj);
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                } else if (tag.equalsIgnoreCase(Constants.ADD_STARTUP_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        System.out.println(jsonObject); //{"message":"successfully saved","code":200}

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
//                            Fragment fragment = new HomeFragment();
//                            if (fragment != null) {
//                                ((HomeActivity) getActivity()).replaceFragment(fragment);
//                                /*FragmentManager fragmentManager = getFragmentManager();
//                                FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
//                                fragmentTransaction.replace(R.id.container, fragment);
//                                fragmentTransaction.commit();*/
//                            }
                            Toast.makeText(getActivity(), "Startup created successfully.", Toast.LENGTH_LONG).show();

                            // EMPTY ALL THE DATA IN THE FIELDS++++++
                            startupName.setText("");
                            description.setText("");
                            keyword.setText("");
                            supportrequired.setText("");
                            //+++++++++++++++++++++++++++++++++++


                            // OPENING THE CURRENT STARUPS WHEN THE STARTUP IS CREATED+++
                            Fragment fragmentCurrent = new CurrentStartUpFragment();
                            Bundle bundle = new Bundle();
                            bundle.putString("COMMING_FROM", "ADD_STARTUPS");
                            fragmentCurrent.setArguments(bundle);
                            FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                            transactionRate.replace(R.id.container, fragmentCurrent);
                            transactionRate.addToBackStack(null);
                            transactionRate.commit();
                            //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                } else {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}