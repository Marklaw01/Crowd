package com.staging.fragments;

import android.Manifest;
import android.animation.Animator;
import android.animation.ValueAnimator;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.ContentResolver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.graphics.PointF;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.util.Log;
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
import com.nostra13.universalimageloader.core.DisplayImageOptions;
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
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

/**
 * Created by neelmani.karn on 1/21/2016.
 */
public class IntoStartUpFragment extends Fragment implements onActivityResultListener, AsyncTaskCompleteListener<String> {

    private ArrayList<String> selectedKeywordList;
    private String selectedKeyword = "";
    Matrix matrix = new Matrix();
    Matrix savedMatrix = new Matrix();

    String imageUrl;
    // We can be in one of these 3 states
    /*static final int NONE = 0;
    static final int DRAG = 1;
    static final int ZOOM = 2;
    int mode = NONE;

    // Remember some things for zooming
    PointF start = new PointF();
    PointF mid = new PointF();
    float oldDist = 1f;*/
    private LinearLayout layout;
    private Uri fileUri;
    private ValueAnimator mAnimator, mAnimatorGraphic;
    private LinearLayout expendableRoadMapLayout, roadmapGraphiclayout, roadmapGraphic, roadmapGraphicexpandable;
    private LinearLayout roadMapEditText;
    private ImageView viewRoadmapArrow, viewroadmapArrowGraphic, image_roadmap;
    private RoadMapAdapter adapter;
    private ArrayList<RoadMapObject> roadMapList;

    private ArrayList<GenericObject> keywordsList;
    private ListView roadMaps;
    private EditText startupName, startupDesc, startupNextStep, startupKeyword, startupSupportRequired;
    private Button editRoadMap, updateIntroItems;
    //public Bitmap bmpFinalImage = null;
    private Bitmap bitmap;
    public String filepath;
    public String fileName;
    public DisplayImageOptions options;

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            // we check that the fragment is becoming visible

            ((HomeActivity) getActivity()).setOnBackPressedListener(this);

            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_KEYWORDS_TAG, Constants.STARTUP_KEYWORDS_URL, Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }
        }
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_introstartup, container, false);
        roadMapList = new ArrayList<>();
        layout = (LinearLayout) rootView.findViewById(R.id.layout);
        roadmapGraphiclayout = (LinearLayout) rootView.findViewById(R.id.roadmapGraphiclayout);
        roadmapGraphic = (LinearLayout) rootView.findViewById(R.id.roadmapGraphic);
        roadmapGraphicexpandable = (LinearLayout) rootView.findViewById(R.id.roadmapGraphicexpandable);

        expendableRoadMapLayout = (LinearLayout) rootView.findViewById(R.id.roadmapexpandable);
        roadMapEditText = (LinearLayout) rootView.findViewById(R.id.roadmap);
        viewRoadmapArrow = (ImageView) rootView.findViewById(R.id.viewroadmapArrow);

        viewroadmapArrowGraphic = (ImageView) rootView.findViewById(R.id.viewroadmapArrowGraphic);
        image_roadmap = (ImageView) rootView.findViewById(R.id.image_roadmapintro);

        roadMaps = (ListView) rootView.findViewById(R.id.list_roadmaps);

        options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.defaultroadmapimg)
                .showImageForEmptyUri(R.drawable.defaultroadmapimg)
                .showImageOnFail(R.drawable.defaultroadmapimg)
                .cacheInMemory(true)
                .cacheOnDisk(true)
                .considerExifParams(true)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();


        startupName = (EditText) rootView.findViewById(R.id.startupname);
        startupDesc = (EditText) rootView.findViewById(R.id.startupdesc);
        startupNextStep = (EditText) rootView.findViewById(R.id.nextstep);
        startupKeyword = (EditText) rootView.findViewById(R.id.keywprd);
        startupSupportRequired = (EditText) rootView.findViewById(R.id.supportrequired);
        editRoadMap = (Button) rootView.findViewById(R.id.editroadmapbtn);
        updateIntroItems = (Button) rootView.findViewById(R.id.editFields);

        keywordsList = new ArrayList<GenericObject>();
        selectedKeywordList = new ArrayList<String>();

        startupDesc.setOnTouchListener(new View.OnTouchListener() {
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
        if (CurrentStartUpDetailFragment.from.equalsIgnoreCase("mystartup")) {

            startupName.setFocusable(true);

            startupDesc.setFocusable(true);
            startupNextStep.setFocusable(true);
            startupKeyword.setFocusable(false);


            startupKeyword.setOnClickListener(new View.OnClickListener() {
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
                                startupKeyword.setText(sb.toString());
                                System.out.println(selectedKeyword.toString() + "-------------------------");

                                dialog.dismiss();
                            }
                        });
                        dialog.show();
                    }
                }

            });

            startupSupportRequired.setFocusable(true);
            editRoadMap.setVisibility(View.VISIBLE);
            updateIntroItems.setVisibility(View.VISIBLE);
        } else {
            startupName.setFocusable(false);
            startupDesc.setFocusable(false);
            startupNextStep.setFocusable(false);
            startupKeyword.setFocusable(false);
            startupSupportRequired.setFocusable(false);
            editRoadMap.setVisibility(View.GONE);
            updateIntroItems.setVisibility(View.GONE);
        }

        roadMaps.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (roadMapList.get(position).getDeliverable_link().trim().length() == 0) {
                    Toast.makeText(getActivity(), "No Link available.", Toast.LENGTH_LONG).show();
                } else {
                    Fragment rateContributor = new WebViewFragment();


                    Bundle bundle = new Bundle();

                    bundle.putString("url", Constants.APP_IMAGE_URL + "/" + roadMapList.get(position).getDeliverable_link());
                    rateContributor.setArguments(bundle);
                    ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                    /*FragmentTransaction transactionRate = getParentFragment().getFragmentManager().beginTransaction();
                    transactionRate.replace(R.id.container, rateContributor);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();*/
                }
            }
        });
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
                    viewroadmapArrowGraphic.setBackground(getResources().getDrawable(R.drawable.arrow_upward));
                    expandForRoadmapGraphic();
                } else {
                    viewroadmapArrowGraphic.setBackground(getResources().getDrawable(R.drawable.arrow_downward));
                    collapseForRoadmapGraphic();
                }
            }
        });

        editRoadMap.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                alertDialogForPicture();

                /*Fragment startupDocs = new StartUpDocsDetailFragment();
                FragmentTransaction transactionAdd = getFragmentManager().beginTransaction();

                transactionAdd.replace(R.id.container, startupDocs);
                transactionAdd.addToBackStack(null);

                transactionAdd.commit();*/


                //CurrentStartUpDetailFragment.viewPager.setCurrentItem(4);

            }
        });


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

        updateIntroItems.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (startupDesc.getText().toString().trim().isEmpty()) {
                    Toast.makeText(getActivity(), "Description is mandatory", Toast.LENGTH_LONG).show();
                } else if (startupNextStep.toString().trim().isEmpty()) {
                    Toast.makeText(getActivity(), "Next Step is mandatory", Toast.LENGTH_LONG).show();
                } else if (selectedKeyword.isEmpty()) {
                    Toast.makeText(getActivity(), "Select at-least one keyword", Toast.LENGTH_LONG).show();
                } else if (startupSupportRequired.getText().toString().trim().isEmpty()) {
                    Toast.makeText(getActivity(), "Support is mandatory", Toast.LENGTH_LONG).show();
                } else {
                    HashMap<String, String> map = new HashMap<String, String>();
                    map.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    map.put("id", CurrentStartUpDetailFragment.STARTUP_ID);
                    map.put("name", startupName.getText().toString().trim());
                    map.put("description", startupDesc.getText().toString().trim());
                    map.put("next_step", startupNextStep.getText().toString().trim());
                    map.put("keywords", selectedKeyword);
                    map.put("support_required", startupSupportRequired.getText().toString().trim());

                    saveCampaign(map, Constants.STARTUP_OVERVIEW_UPDATE_URL);
                }

            }
        });


        return rootView;
    }


    private void saveCampaign(final HashMap<String, String> map, final String editUrl) {
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
                        entity.addPart("roadmap_graphic", cbFile);

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
                    Log.e("XXX","INTENAL ERROR 2+"+ e.getMessage());
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
                            Toast.makeText(getActivity(), obj.optString("message"), Toast.LENGTH_LONG).show();
                        } else if (obj.getString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), obj.optString("message"), Toast.LENGTH_LONG).show();
                        }

                    } catch (JSONException e) {
                        e.printStackTrace();
                        Log.e("XXX", "INTENAL ERROR 3+" + e.getMessage());
                    }
                } else {
                    Toast.makeText(getActivity(), "No response found", Toast.LENGTH_LONG).show();
                }
            }
        }.execute();
    }


    public void alertDialog(String imageUrl) {
        final Dialog dialog = new Dialog(getActivity());
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.pinch_and_zoom_imageview_dialog);

        final TouchImageView imageView = (TouchImageView) dialog.findViewById(R.id.roadmapImage);
        final Button okText = (Button) dialog.findViewById(R.id.btn_ok);

        Log.e("imageUrl", imageUrl);

        if (imageUrl.contains("http") || imageUrl.contains("https")) {
            ImageLoader.getInstance().displayImage(imageUrl, imageView, options);
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
                Log.e("XXX", "INTENAL ERROR 4+" + e.getMessage());
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

    @Override
    public void onResume() {
        super.onResume();

        ((HomeActivity) getActivity()).setOnActivityResultListener(this);
        /*if (bmpFinalImage != null) {
            image_roadmap.setImageBitmap(bmpFinalImage);
        }*/

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

    protected void alertDialogForPicture() {

        AlertDialog.Builder builderSingle = new AlertDialog.Builder(getActivity()/*new ContextThemeWrapper(getActivity(), android.R.style.Theme_Holo_Light_Dialog)*/);
        final CharSequence[] opsChars = {"Upload Image", "Take Picture"};
        builderSingle.setCancelable(true);
        builderSingle.setItems(opsChars, new DialogInterface.OnClickListener() {

            @Override
            public void onClick(DialogInterface dialog, int which) {
                if ((ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) || ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED || ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                    requestPermission();
                } else {
                    switch (which) {

                        case 0:
                            try {
                                Intent i = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);

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
    }

    /**
     * Requests the Camera permission.
     * If the permission has been denied previously, a SnackBar will prompt the user to grant the
     * permission, otherwise it is requested directly.
     */
    private void requestPermission() {
        Log.i("TAG", "CAMERA permission has NOT been granted. Requesting permission.");

        // BEGIN_INCLUDE(camera_permission_request)
        if ((ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.CAMERA)) || ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE) || ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
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
    }

    /**
     * Callback received when a permissions request has been completed.
     */
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {

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
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        // TODO Auto-generated method stub
        super.onActivityResult(requestCode, resultCode, data);


        System.out.println(requestCode);
        Log.e("XXX", "Into the Intro Activity result" + requestCode);
        switch (requestCode) {


            case Constants.CAMERA_CAPTURE_IMAGE_REQUEST_CODE:

                // if the result is capturing Image

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

                        File finalFile = new File(filepath);
                        long length = finalFile.length();
                        int a = finalFile.getAbsolutePath().lastIndexOf("/");

                        if (length >= Constants.MAX_FILE_LENGTH_ALLOWED) {
                            Toast.makeText(getActivity(), finalFile.getAbsolutePath().substring(a + 1).toString().trim() + " size is more than 5 MB.", Toast.LENGTH_LONG).show();
                        } else {
                            decodeFile(filepath, fileUri);
                        }
                    } catch (NullPointerException e) {
                        e.printStackTrace();
                        Log.e("XXX", "INTENAL ERROR 5+" + e.getMessage());
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


                break;
            case Constants.FILE_PICKER:

                if (resultCode == Activity.RESULT_OK) {
                    final Uri selectedImageUri = data.getData();
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
                            File finalFile = new File(filepath);
                            long length = finalFile.length();
                            if (length >= Constants.MAX_FILE_LENGTH_ALLOWED) {
                                Toast.makeText(getActivity(), finalFile.getAbsolutePath().substring(a + 1).toString().trim() + " size is more than 5 MB.", Toast.LENGTH_LONG).show();
                            } else {
                                decodeFile(filepath, selectedImageUri);
                            }
                        }
                    } catch (Exception e) {
                        System.out.println(e);
                        Toast.makeText(getActivity(), "Internal error", Toast.LENGTH_LONG).show();
                    }
                }
                break;
            default:
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
    }

    public String getPath(Context context, Uri uri) {

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
            Log.e("bitmap", String.valueOf(bitmap));
        } catch (Exception e) {
            e.printStackTrace();
            Log.e("xxx","INTERNAL ERROR+++"+e.getMessage());
            image_roadmap.setImageResource(R.drawable.app_icon);
        }
    }

    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            if (tag.equalsIgnoreCase(Constants.STARTUP_KEYWORDS_TAG)) {
                //((HomeActivity) getActivity()).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    keywordsList.clear();
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        for (int i = 0; i < jsonObject.optJSONArray("startup_keywords").length(); i++) {
                            GenericObject obj = new GenericObject();
                            obj.setId(jsonObject.optJSONArray("startup_keywords").getJSONObject(i).optString("id"));
                            obj.setTitle(jsonObject.optJSONArray("startup_keywords").getJSONObject(i).optString("name"));
                            keywordsList.add(obj);
                        }
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                        keywordsList.clear();
                    }
                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.STARTUP_OVERVIEW_TAG, Constants.STARTUP_OVERVIEW_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&startup_id=" + CurrentStartUpDetailFragment.STARTUP_ID, Constants.HTTP_GET,"Home Activity");
                        a.execute();
                    } else {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    Log.e("XXX", "INTENAL ERROR 6+" + e.getMessage());
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.STARTUP_OVERVIEW_TAG)) {
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject);

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        StringBuilder stringBuilder = new StringBuilder();

                        if (jsonObject.has("keywords")) {
                            for (int i = 0; i < jsonObject.optJSONArray("keywords").length(); i++) {
                                if((i >= 0) && ( i < (jsonObject.optJSONArray("keywords").length() - 1) )){
                                    stringBuilder.append(jsonObject.optJSONArray("keywords").getJSONObject(i).optString("name") + ", ");

                                }
                                else {
                                    stringBuilder.append(jsonObject.optJSONArray("keywords").getJSONObject(i).optString("name") + " ");
                                }
                                    GenericObject obj = new GenericObject();

                                obj.setId(jsonObject.optJSONArray("keywords").getJSONObject(i).optString("id"));
                                obj.setTitle(jsonObject.optJSONArray("keywords").getJSONObject(i).optString("name"));

                                for (int j = 0; j < keywordsList.size(); j++) {
                                    if (keywordsList.get(j).getId().equalsIgnoreCase(obj.getId())) {
                                        keywordsList.get(j).setIschecked(true);
                                    }
                                }
                            }
                            startupKeyword.setText(stringBuilder.toString());
                        }

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

                        startupDesc.setText(jsonObject.optString("startup_desc"));

                        startupName.setText(jsonObject.optString("startup_name"));
                        startupNextStep.setText(jsonObject.optString("next_step"));
                        startupSupportRequired.setText(jsonObject.optString("support_required"));

                        ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + "/" + jsonObject.optString("roadmap_grapic").trim(), image_roadmap, options);
                        imageUrl = Constants.APP_IMAGE_URL + "/" + jsonObject.optString("roadmap_grapic").trim();
                        roadMapList.clear();
                        if (jsonObject.has("roadmap_deliverable_list")) {
                            for (int i = 0; i < jsonObject.optJSONArray("roadmap_deliverable_list").length(); i++) {
                                RoadMapObject roadMapObject = new RoadMapObject();
                                roadMapObject.setRoadmapName(jsonObject.optJSONArray("roadmap_deliverable_list").getJSONObject(i).getString("deliverable_name"));
                                roadMapObject.setId(jsonObject.optJSONArray("roadmap_deliverable_list").getJSONObject(i).getString("deliverable_id"));
                                roadMapObject.setDeliverable_link(jsonObject.optJSONArray("roadmap_deliverable_list").getJSONObject(i).getString("deliverable_link"));

                                roadMapList.add(roadMapObject);
                            }
                        }
                        adapter = new RoadMapAdapter(getActivity(), roadMapList);
                        roadMaps.setAdapter(adapter);
                        UtilityList.setListViewHeightBasedOnChildren(roadMaps);

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                    }


                    ((HomeActivity) getActivity()).dismissProgressDialog();

                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    Log.e("XXX", "INTENAL ERROR 7+" + e.getMessage());
                    e.printStackTrace();
                }
            }
        }

    }
}