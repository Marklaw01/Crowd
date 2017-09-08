package com.staging.fragments;

import android.animation.ValueAnimator;
import android.app.Dialog;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.PointF;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.RoadMapAdapter;
import com.staging.helper.TouchImageView;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.models.RoadMapObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.UtilityList;
import com.nostra13.universalimageloader.core.ImageLoader;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by sunakshi.gautam on 2/2/2016.
 */
public class StartupDetailsFragment extends Fragment implements AsyncTaskCompleteListener<String> {

   /* Matrix matrix = new Matrix();
    Matrix savedMatrix = new Matrix();*/
    String imageUrl;
    String STARTUP_ID = "";
    String entrenprenuer_id = "";
    // We can be in one of these 3 states
   /* static final int NONE = 0;
    static final int DRAG = 1;
    static final int ZOOM = 2;
    int mode = NONE;

    // Remember some things for zooming
    PointF start = new PointF();
    PointF mid = new PointF();
    float oldDist = 1f;*/
    private ArrayList<RoadMapObject> startupsObjectsList;
    private ListView list_startups;
    private ValueAnimator mAnimator;
    private EditText startupName, startupdesc, add_keyword, supportrequired, nextStep;
    LinearLayout roadMapEditText;
    private Button btnSubmit, editroadmapbtn, btnEditRoadmap;
    private RoadMapAdapter adapter;
    private ImageView viewRoadmapArrow, viewroadmapGraphicArrow, image_roadmap;
    private LinearLayout expendableRoadMapLayout, roadmapGraphiclayout, roadmapGraphic, roadmapGraphicexpandable;

    private TextView fundedBy;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_startupdetails, container, false);
        try {
            String titleStartUp = getArguments().getString("name");
            STARTUP_ID = getArguments().getString("id");
            //entrenprenuer_id = getArguments().getString("entrenprenuer_id");

            ((HomeActivity) getActivity()).setActionBarTitle(titleStartUp);

            btnEditRoadmap = (Button) rootView.findViewById(R.id.btn_editroadmap);
            roadmapGraphiclayout = (LinearLayout) rootView.findViewById(R.id.roadmapGraphiclayout);
            image_roadmap = (ImageView) rootView.findViewById(R.id.image_roadmap);
            viewroadmapGraphicArrow = (ImageView) rootView.findViewById(R.id.viewroadmapGraphicArrow);
            roadmapGraphicexpandable = (LinearLayout) rootView.findViewById(R.id.roadmapGraphicexpandable);
            roadmapGraphic = (LinearLayout) rootView.findViewById(R.id.roadmapGraphic);
            list_startups = (ListView) rootView.findViewById(R.id.list_roadmaps);
            startupsObjectsList = new ArrayList<RoadMapObject>();
            fundedBy = (TextView) rootView.findViewById(R.id.fundedBy);

            startupName = (EditText) rootView.findViewById(R.id.startupname);
            roadMapEditText = (LinearLayout) rootView.findViewById(R.id.roadmap);
            viewRoadmapArrow = (ImageView) rootView.findViewById(R.id.viewroadmapArrow);
            add_keyword = (EditText) rootView.findViewById(R.id.keywprd);
            nextStep = (EditText) rootView.findViewById(R.id.nextstep);
            supportrequired = (EditText) rootView.findViewById(R.id.supportrequired);
            startupdesc = (EditText) rootView.findViewById(R.id.startupdesc);

            btnSubmit = (Button) rootView.findViewById(R.id.editFields);
            expendableRoadMapLayout = (LinearLayout) rootView.findViewById(R.id.roadmapexpandable);
            editroadmapbtn = (Button) rootView.findViewById(R.id.editroadmapbtn);
            editroadmapbtn.setVisibility(View.GONE);
            btnEditRoadmap.setVisibility(View.GONE);

            btnSubmit.setVisibility(View.VISIBLE);
            btnSubmit.setText("View Entrepreneur's Profile");

            startupName.setText(titleStartUp);


            startupdesc.setOnTouchListener(new View.OnTouchListener() {
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


            startupName.setFocusable(false);
            add_keyword.setFocusable(false);
            supportrequired.setFocusable(false);
            roadMapEditText.setFocusable(false);
            startupdesc.setFocusable(false);
            nextStep.setFocusable(false);

            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_OVERVIEW_TAG, Constants.STARTUP_OVERVIEW_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&startup_id=" + STARTUP_ID, Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }



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
            btnSubmit.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Fragment fragment = new ViewOtherEntrepreneurPublicProfileFragment();
                    Bundle args = new Bundle();
                    args.putString("id", entrenprenuer_id);
                    args.putString("COMMING_FROM", "STARTUP_DETAILS");
                    fragment.setArguments(args);
                    ((HomeActivity)getActivity()).replaceFragment(fragment);
                    /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();

                    transactionRate.replace(R.id.container, fragment);
                    //transactionRate.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();*/
                }
            });


            list_startups.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    if (startupsObjectsList.get(position).getDeliverable_link().trim().length() == 0) {
                        Toast.makeText(getActivity(), "No Link available.", Toast.LENGTH_LONG).show();
                    } else {
                        Fragment rateContributor = new WebViewFragment();


                        Bundle bundle = new Bundle();

                        bundle.putString("url", Constants.APP_IMAGE_URL + "/" + startupsObjectsList.get(position).getDeliverable_link());
                        rateContributor.setArguments(bundle);
                        ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                    /*FragmentTransaction transactionRate = getParentFragment().getFragmentManager().beginTransaction();
                    transactionRate.replace(R.id.container, rateContributor);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();*/
                    }
                }
            });




        /*for (int i = 0; i < 5; i++) {
            RoadMapObject audioObject = new RoadMapObject();
            audioObject.setRoadmapName("Deliverable " + (i + 1));
            startupsObjectsList.add(audioObject);
        }
        adapter = new RoadMapAdapter(getActivity(), startupsObjectsList);
        list_startups.setAdapter(adapter);

        UtilityList.setListViewHeightBasedOnChildren(list_startups);*/

            image_roadmap.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    System.out.print(filepath);
                    if (filepath != null) {
                        alertDialog(filepath);
                    } else {
                        alertDialog(imageUrl);
                    }

                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootView;
    }




    private Bitmap bitmap;
    public String filepath;
    public String fileName;

    public void alertDialog(String imageUrl) {
        try {
            final Dialog dialog = new Dialog(getActivity());
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
            dialog.setContentView(R.layout.pinch_and_zoom_imageview_dialog);

            final TouchImageView imageView = (TouchImageView) dialog.findViewById(R.id.roadmapImage);
            final Button okText = (Button) dialog.findViewById(R.id.btn_ok);
            if (imageUrl.contains("http") || imageUrl.contains("https")) {
                ImageLoader.getInstance().displayImage(imageUrl, imageView, ((HomeActivity) getActivity()).options);

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


    private float spacing(MotionEvent event) {
        float x = event.getX(0) - event.getX(1);
        float y = event.getY(0) - event.getY(1);

        return (float) Math.sqrt(x * x + y * y);
        //return FloatMath.sqrt(x * x + y * y);
    }

    private void midPoint(PointF point, MotionEvent event) {
        float x = event.getX(0) + event.getX(1);
        float y = event.getY(0) + event.getY(1);
        point.set(x / 2, y / 2);
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

        //mAnimator.start();
    }

    private void collapseForRoadmapGraphic() {
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
        /*int finalHeight = roadmapGraphicexpandable.getHeight();

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
        mAnimator.start();*/
    }

    private ValueAnimator slideAnimatorForRoadmapGraphic(int start, int end) {

        ValueAnimator animator = ValueAnimator.ofInt(start, end);


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
        return animator;
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

        // mAnimator.start();
    }

    private void collapse() {

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


    }


    private ValueAnimator slideAnimator(int start, int end) {

        ValueAnimator animator = ValueAnimator.ofInt(start, end);


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
        return animator;
    }


    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
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
                if (tag.equalsIgnoreCase(Constants.STARTUP_OVERVIEW_TAG)) {
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            StringBuilder stringBuilder = new StringBuilder();

                            if (jsonObject.has("keywords")) {
                                for (int i = 0; i < jsonObject.optJSONArray("keywords").length(); i++) {
                                    if (stringBuilder.length() > 0) {
                                        stringBuilder.append(", ");
                                    }
                                    stringBuilder.append(jsonObject.optJSONArray("keywords").getJSONObject(i).optString("name") + " ");

                                }
                                add_keyword.setText("Keywords: " + stringBuilder.toString());
                            }

                            //keywords

                            startupdesc.setText(jsonObject.optString("startup_desc"));
                            entrenprenuer_id = jsonObject.optString("entrepreneur_id");
                            startupName.setText(jsonObject.optString("startup_name"));
                            nextStep.setText(jsonObject.optString("next_step"));
                            supportrequired.setText(jsonObject.optString("support_required"));

                            if (!jsonObject.optString("funded_by").isEmpty()) {
                                fundedBy.setVisibility(View.VISIBLE);
                                fundedBy.setText("Funded By: " + jsonObject.optString("funded_by"));
                            } else {
                                fundedBy.setVisibility(View.GONE);
                            }

                            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + "/" + jsonObject.optString("roadmap_grapic").trim(), image_roadmap, ((HomeActivity) getActivity()).options);
                            imageUrl = Constants.APP_IMAGE_URL + "/" + jsonObject.optString("roadmap_grapic").trim();

                            if (jsonObject.has("roadmap_deliverable_list")) {
                                for (int i = 0; i < jsonObject.optJSONArray("roadmap_deliverable_list").length(); i++) {
                                    RoadMapObject roadMapObject = new RoadMapObject();
                                    roadMapObject.setRoadmapName(jsonObject.optJSONArray("roadmap_deliverable_list").getJSONObject(i).getString("deliverable_name"));
                                    roadMapObject.setId(jsonObject.optJSONArray("roadmap_deliverable_list").getJSONObject(i).getString("deliverable_id"));
                                    roadMapObject.setDeliverable_link(jsonObject.optJSONArray("roadmap_deliverable_list").getJSONObject(i).getString("deliverable_link"));

                                    startupsObjectsList.add(roadMapObject);
                                }
                            }
                            adapter = new RoadMapAdapter(getActivity(), startupsObjectsList);
                            list_startups.setAdapter(adapter);

                            UtilityList.setListViewHeightBasedOnChildren(list_startups);

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        }


                        ((HomeActivity) getActivity()).dismissProgressDialog();

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
