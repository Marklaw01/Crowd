package com.staging.activities;

import android.annotation.TargetApi;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.drawable.GradientDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.text.Html;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.HorizontalScrollView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.models.LeanRoadmapObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.staging.utilities.NetworkConnectivity;
import com.staging.utilities.UtilitiesClass;

import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;

import java.util.ArrayList;

/**
 * Created by sunakshi.gautam on 9/8/2016.
 */
public class LeanStartupRoadmap extends BaseActivity implements AsyncTaskCompleteListener<String> {
    private LinearLayout mainRoadmapViewabove, mainRoadmapViewbelow, mainRoadmapaboveA, mainRoadmapbelowB;
    private ArrayList<LeanRoadmapObject> deliverablesArrayList;
    private ArrayList<LeanRoadmapObject> deliverablesArrayListabove;
    private ArrayList<LeanRoadmapObject> deliverablesArrayListbelow;
    private LinearLayout aboveScrollLayout;
    private LayoutInflater inflator;
    private ImageView arrowDirectionsLeft, arrowDirectionsRight;
    private HorizontalScrollView horizonatalScrollView;
    private TextView horizontalText;
    private TextView ventureText;
    private TextView roadmapTemplate;
    // private RelativeLayout belowlayout;
    private LinearLayout aboveLayout;
    private ImageView roadmapImage;
    public NetworkConnectivity networkConnectivity;
    ProgressDialog pdialog;

    public UtilitiesClass utilitiesClass;

    @Override
    public void setActionBarTitle(String title) {

    }

    @Override
    public void onResume() {
        super.onResume();
        this.setActionBarTitle("Lean Startup Roadmap");
        // ((HomeActivity) getActivity()).setOnActivityResultListener(this);
    }

    public void showProgressDialog() {
        pdialog = new ProgressDialog(LeanStartupRoadmap.this);
        pdialog.setMessage(Html.fromHtml("<b>" + getString(R.string.please_wait) + "</b>"));
        pdialog.setIndeterminate(true);
        pdialog.setCancelable(false);

        pdialog.show();
    }

    public void dismissProgressDialog() {
        try {
            if ((pdialog != null) && (pdialog.isShowing())) {
                pdialog.dismiss();
            }
        } catch (Exception e) {

        }
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.leanstartup_roadmap);
        mainRoadmapViewabove = (LinearLayout) findViewById(R.id.roadmapviewabove);
        mainRoadmapViewbelow = (LinearLayout) findViewById(R.id.roadmapviewbelow);
        aboveLayout = (LinearLayout) findViewById(R.id.abovelayoutRoadmap);
        horizonatalScrollView = (HorizontalScrollView) findViewById(R.id.horizontalView);
        horizontalText = (TextView) findViewById(R.id.scrollText);
        aboveScrollLayout = (LinearLayout) findViewById(R.id.scrollLayout);
        arrowDirectionsLeft = (ImageView) findViewById(R.id.arrowdirectionLeft);
        arrowDirectionsRight = (ImageView) findViewById(R.id.arrowdirectionRight);
        roadmapImage = (ImageView) findViewById(R.id.roadmapImage);
        ventureText = (TextView) findViewById(R.id.ventureText);
        roadmapTemplate = (TextView) findViewById(R.id.templateText);

        utilitiesClass = UtilitiesClass.getInstance(LeanStartupRoadmap.this);
        networkConnectivity = NetworkConnectivity.getInstance(LeanStartupRoadmap.this);

        deliverablesArrayList = new ArrayList<>();

        deliverablesArrayListabove = new ArrayList<>();
        deliverablesArrayListbelow = new ArrayList<>();


        inflator = (LayoutInflater) LeanStartupRoadmap.this.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        if (networkConnectivity.isOnline()) {
            showProgressDialog();
            Async a = new Async(LeanStartupRoadmap.this, (AsyncTaskCompleteListener<String>) LeanStartupRoadmap.this, Constants.LEAN_STARTUP_TAG, Constants.LEAN_STARTUP_URL, Constants.HTTP_GET, "Lean Startup Roadmap");
            a.execute();
        } else {
            utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }



        roadmapTemplate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder alert = new AlertDialog.Builder(LeanStartupRoadmap.this);
                alert.setTitle("Roadmap Template");


                LinearLayout layoutHorizontal = new LinearLayout(LeanStartupRoadmap.this);
                layoutHorizontal.setOrientation(LinearLayout.HORIZONTAL);
                layoutHorizontal.setGravity(Gravity.RIGHT);
                LinearLayout.LayoutParams parms = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                layoutHorizontal.setLayoutParams(parms);


                TextView scrollDownText = new TextView(LeanStartupRoadmap.this);
                scrollDownText.setText("Scroll Down\t\t");
//                    scrollDownText.setGravity(Gravity.RIGHT);


//                    sampleText.setGravity(Gravity.RIGHT);

                layoutHorizontal.addView(scrollDownText);


                LinearLayout layout = new LinearLayout(LeanStartupRoadmap.this);
                layout.setOrientation(LinearLayout.VERTICAL);
                layout.addView(layoutHorizontal);
                WebView wv = new WebView(LeanStartupRoadmap.this);

                wv.getSettings().setLoadsImagesAutomatically(true);
                wv.getSettings().setJavaScriptEnabled(true);
                wv.getSettings().setAllowContentAccess(true);
                wv.loadUrl("http://stage.crowdbootstrap.com/contractors/roadmap-template-apps");

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

        ventureText.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder alert = new AlertDialog.Builder(LeanStartupRoadmap.this);
                alert.setTitle("Venture Capital");


                LinearLayout layoutHorizontal = new LinearLayout(LeanStartupRoadmap.this);
                layoutHorizontal.setOrientation(LinearLayout.HORIZONTAL);
                layoutHorizontal.setGravity(Gravity.RIGHT);
                LinearLayout.LayoutParams parms = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                layoutHorizontal.setLayoutParams(parms);


                TextView scrollDownText = new TextView(LeanStartupRoadmap.this);
                scrollDownText.setText("Scroll Down\t\t");
//                    scrollDownText.setGravity(Gravity.RIGHT);


//                    sampleText.setGravity(Gravity.RIGHT);

                layoutHorizontal.addView(scrollDownText);


                LinearLayout layout = new LinearLayout(LeanStartupRoadmap.this);
                layout.setOrientation(LinearLayout.VERTICAL);
                layout.addView(layoutHorizontal);
                WebView wv = new WebView(LeanStartupRoadmap.this);

                wv.getSettings().setLoadsImagesAutomatically(true);
                wv.getSettings().setJavaScriptEnabled(true);
                wv.getSettings().setAllowContentAccess(true);
                wv.loadUrl("http://stage.crowdbootstrap.com/contractors/venture-capital-apps");

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

    }


    private void createRoadMap() {
        aboveLayout.setBackgroundResource(R.drawable.centerroad);


        for (int i = 0; i < deliverablesArrayList.size(); i++) {
            if ((i % 2) == 0) {
                deliverablesArrayListabove.add(deliverablesArrayList.get(i));
            } else {
                deliverablesArrayListbelow.add(deliverablesArrayList.get(i));
            }
        }


        for (int j = 0; j < deliverablesArrayListabove.size(); j++) {
            MyView mView = new MyView(this, j);
            View aboveView;

            if ((j % 2) == 0) {
                aboveView = inflator.inflate(R.layout.box_above, null);

            } else {
                aboveView = inflator.inflate(R.layout.box_above_high, null);

            }
            TextView tv = (TextView) aboveView.findViewById(R.id.deliverableName);
            LinearLayout mainLayout = (LinearLayout) aboveView.findViewById(R.id.mainLayout);
            LinearLayout layoutLin = (LinearLayout) aboveView.findViewById(R.id.layoutdynamic);
            tv.setText(deliverablesArrayListabove.get(j).getDeliverableName());
            final String title = deliverablesArrayListabove.get(j).getDeliverableName();
            final String url = deliverablesArrayListabove.get(j).getDescription();
            final String sampleUrl = deliverablesArrayListabove.get(j).getSampleLink();
            final String colorBackground = deliverablesArrayListabove.get(j).getColorBG();
            final String templateUrl = deliverablesArrayListabove.get(j).getTemplateLink();


            GradientDrawable bgShape = (GradientDrawable) mainLayout.getBackground().getCurrent();
            bgShape.setColor(Color.parseColor(colorBackground));
            mainLayout.setOnClickListener(new View.OnClickListener() {
                @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
                @Override
                public void onClick(View v) {
                    AlertDialog.Builder alert = new AlertDialog.Builder(LeanStartupRoadmap.this);
                    alert.setTitle(title);


                    LinearLayout layoutHorizontal = new LinearLayout(LeanStartupRoadmap.this);
                    layoutHorizontal.setOrientation(LinearLayout.HORIZONTAL);
                    layoutHorizontal.setGravity(Gravity.RIGHT | Gravity.CENTER_VERTICAL);
                    LinearLayout.LayoutParams parms = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                    layoutHorizontal.setLayoutParams(parms);


                    TextView scrollDownText = new TextView(LeanStartupRoadmap.this);
                    scrollDownText.setText("Scroll Down\t\t");
//                    scrollDownText.setGravity(Gravity.RIGHT);


                    TextView sampleText = new TextView(LeanStartupRoadmap.this);
                    sampleText.setBackgroundColor(Color.parseColor("#03375C"));
                    sampleText.setText("Sample\t");


                    LinearLayout.LayoutParams buttonLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                    buttonLayoutParams.setMargins(0, 0, 10, 0);
                    sampleText.setLayoutParams(buttonLayoutParams);
                    sampleText.setPadding(20, 10, 10, 10);
                    sampleText.setGravity(Gravity.CENTER_HORIZONTAL);
                    sampleText.setTextAlignment(View.TEXT_ALIGNMENT_CENTER);
                    sampleText.setTextColor(Color.parseColor("#FFFFFF"));

                    sampleText.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            Intent intent = new Intent(Intent.ACTION_VIEW,
                                    Uri.parse("http://docs.google.com/gview?embedded=true&url=" + sampleUrl));
                            intent.setFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
                            startActivity(intent);
                        }
                    });


                    TextView templateText = new TextView(LeanStartupRoadmap.this);
                    templateText.setBackgroundColor(Color.parseColor("#056a1f"));
                    templateText.setText("Template\t");


                    LinearLayout.LayoutParams buttonLayoutParamsTemplate = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                    buttonLayoutParamsTemplate.setMargins(0, 0, 10, 0);
                    templateText.setLayoutParams(buttonLayoutParamsTemplate);
                    templateText.setPadding(20, 10, 10, 10);
                    templateText.setGravity(Gravity.CENTER_HORIZONTAL);
                    templateText.setTextAlignment(View.TEXT_ALIGNMENT_CENTER);
                    templateText.setTextColor(Color.parseColor("#FFFFFF"));

                    templateText.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            Intent intent = new Intent(Intent.ACTION_VIEW,
                                    Uri.parse("http://docs.google.com/gview?embedded=true&url=" + templateUrl));
                            intent.setFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
                            startActivity(intent);
                        }
                    });
//                    sampleText.setGravity(Gravity.RIGHT);

                    layoutHorizontal.addView(scrollDownText);
                    layoutHorizontal.addView(sampleText);
                    layoutHorizontal.addView(templateText);

                    LinearLayout layout = new LinearLayout(LeanStartupRoadmap.this);
                    layout.setOrientation(LinearLayout.VERTICAL);
                    layout.addView(layoutHorizontal);
                    WebView wv = new WebView(LeanStartupRoadmap.this);

                    wv.getSettings().setLoadsImagesAutomatically(true);
                    wv.getSettings().setJavaScriptEnabled(true);
                    wv.getSettings().setAllowContentAccess(true);
                    wv.loadUrl(url);

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

            layoutLin.setGravity(Gravity.BOTTOM);
            // belowlayout.addView(mView);
            mainRoadmapViewabove.addView(aboveView);


        }


        for (int k = 0; k < deliverablesArrayListbelow.size(); k++) {

            View belowView;
            MyView mView = new MyView(this, k);
            if ((k % 2) == 0) {
                belowView = inflator.inflate(R.layout.box_below, null);

            } else {
                belowView = inflator.inflate(R.layout.box_below_low, null);

            }
            LinearLayout mainLayoutBelow = (LinearLayout) belowView.findViewById(R.id.mainLayout);
            TextView tv = (TextView) belowView.findViewById(R.id.deliverableName);
            tv.setText(deliverablesArrayListbelow.get(k).getDeliverableName());
            final String title = deliverablesArrayListbelow.get(k).getDeliverableName();
            final String url = deliverablesArrayListbelow.get(k).getDescription();
            final String sampleUrl = deliverablesArrayListbelow.get(k).getSampleLink();
            final String colorBackground = deliverablesArrayListbelow.get(k).getColorBG();
            final String templateUrl = deliverablesArrayListbelow.get(k).getTemplateLink();

            GradientDrawable bgShape = (GradientDrawable) mainLayoutBelow.getBackground().getCurrent();
            bgShape.setColor(Color.parseColor(colorBackground));

            mainLayoutBelow.setOnClickListener(new View.OnClickListener() {
                @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
                @Override
                public void onClick(View v) {
                    AlertDialog.Builder alert = new AlertDialog.Builder(LeanStartupRoadmap.this);
                    alert.setTitle(title);

                    LinearLayout layoutHorizontal = new LinearLayout(LeanStartupRoadmap.this);
                    layoutHorizontal.setOrientation(LinearLayout.HORIZONTAL);
                    layoutHorizontal.setGravity(Gravity.RIGHT | Gravity.CENTER_VERTICAL);
                    LinearLayout.LayoutParams parms = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                    layoutHorizontal.setLayoutParams(parms);


                    TextView scrollDownText = new TextView(LeanStartupRoadmap.this);
                    scrollDownText.setText("Scroll Down\t\t");
//                    scrollDownText.setGravity(Gravity.RIGHT);


                    TextView sampleText = new TextView(LeanStartupRoadmap.this);
                    sampleText.setBackgroundColor(Color.parseColor("#03375C"));
                    sampleText.setText("Sample\t");

                    LinearLayout.LayoutParams buttonLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                    buttonLayoutParams.setMargins(0, 0, 10, 0);
                    sampleText.setLayoutParams(buttonLayoutParams);
                    sampleText.setTextColor(Color.parseColor("#FFFFFF"));
                    sampleText.setPadding(20, 10, 10, 10);
                    sampleText.setGravity(Gravity.CENTER_HORIZONTAL);
                    sampleText.setTextAlignment(View.TEXT_ALIGNMENT_CENTER);
                    sampleText.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            Intent intent = new Intent(Intent.ACTION_VIEW,
                                    Uri.parse("http://docs.google.com/gview?embedded=true&url=" + sampleUrl));
                            intent.setFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
                            startActivity(intent);
                        }
                    });


                    final TextView templateText = new TextView(LeanStartupRoadmap.this);
                    templateText.setBackgroundColor(Color.parseColor("#056a1f"));
                    templateText.setText("Template\t");


                    LinearLayout.LayoutParams buttonLayoutParamsTemplate = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                    buttonLayoutParamsTemplate.setMargins(0, 0, 10, 0);
                    templateText.setLayoutParams(buttonLayoutParamsTemplate);
                    templateText.setPadding(20, 10, 10, 10);
                    templateText.setGravity(Gravity.CENTER_HORIZONTAL);
                    templateText.setTextAlignment(View.TEXT_ALIGNMENT_CENTER);
                    templateText.setTextColor(Color.parseColor("#FFFFFF"));

                    templateText.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            Intent intent = new Intent(Intent.ACTION_VIEW,
                                    Uri.parse("http://docs.google.com/gview?embedded=true&url=" + templateUrl));
                            intent.setFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
                            startActivity(intent);
                        }
                    });

                    layoutHorizontal.addView(scrollDownText);
                    layoutHorizontal.addView(sampleText);
                    layoutHorizontal.addView(templateText);

                    LinearLayout layout = new LinearLayout(LeanStartupRoadmap.this);
                    layout.setOrientation(LinearLayout.VERTICAL);
                    layout.addView(layoutHorizontal);


                    WebView wv = new WebView(LeanStartupRoadmap.this);
                    wv.getSettings().setLoadsImagesAutomatically(true);
                    wv.getSettings().setJavaScriptEnabled(true);
                    wv.getSettings().setAllowContentAccess(true);

                    wv.loadUrl(url);


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
            //belowlayout.addView(mView);
            mainRoadmapViewbelow.addView(belowView);


        }

        aboveScrollLayout.setVisibility(View.VISIBLE);
        arrowDirectionsRight.setVisibility(View.VISIBLE);
        horizonatalScrollView.getViewTreeObserver().addOnScrollChangedListener(new ViewTreeObserver.OnScrollChangedListener() {
            @Override
            public void onScrollChanged() {

                int scrollX = horizonatalScrollView.getScrollX();
                int bottomX = horizonatalScrollView.getChildAt(0).getMeasuredWidth() - horizonatalScrollView.getMeasuredWidth(); // For HorizontalScrollView
                // DO SOMETHING WITH THE SCROLL COORDINATES
                if ((scrollX == (bottomX))) {
                    arrowDirectionsLeft.setVisibility(View.VISIBLE);
                    arrowDirectionsRight.setVisibility(View.GONE);
                    horizontalText.setText("Scroll Left");
                } else if (scrollX == (0)) {
                    arrowDirectionsLeft.setVisibility(View.GONE);
                    arrowDirectionsRight.setVisibility(View.VISIBLE);
                    horizontalText.setText("Scroll Right");
                } else {
                    arrowDirectionsLeft.setVisibility(View.VISIBLE);
                    arrowDirectionsRight.setVisibility(View.VISIBLE);
                    horizontalText.setText("Scroll");
                }
            }

        });


//        aboveLayout.addView(scrollLeftText);

    }


    public class MyView extends View {

        public MyView(Context context, int kolki) {
            super(context);

            if (kolki == 0) {
                // this.setBackgroundResource(R.drawable.centerroad);
            }
            if (kolki == 1) {
                //this.setBackgroundResource(R.drawable.centerroad);
            }
        }

        public void setBackgroundResource(int resid) {
            super.setBackgroundResource(resid);
        }

        public void onDraw(Canvas c) {
            super.onDraw(c);
            Paint paint = new Paint();
            Path path = new Path();
            paint.setStyle(Paint.Style.FILL);
            paint.setColor(Color.TRANSPARENT);
            c.drawPaint(paint);
            for (int i = 50; i < 100; i++) {
                path.moveTo(i, i - 1);
                path.lineTo(i, i);
            }
            path.close();
            paint.setStrokeWidth(3);
            paint.setPathEffect(null);
            paint.setColor(Color.BLACK);
            paint.setStyle(Paint.Style.STROKE);
            c.drawPath(path, paint);
        }

    }


    @Override
    public void onTaskComplete(String result, String tag) {
        try {
            if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
                LeanStartupRoadmap.this.dismissProgressDialog();
                Toast.makeText(LeanStartupRoadmap.this, getString(R.string.check_internet), Toast.LENGTH_LONG).show();
            } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
                (LeanStartupRoadmap.this).dismissProgressDialog();
                Toast.makeText(LeanStartupRoadmap.this, getString(R.string.server_down), Toast.LENGTH_LONG).show();
            } else if (result.contains("<pre")) {
                (LeanStartupRoadmap.this).dismissProgressDialog();
                Toast.makeText(LeanStartupRoadmap.this, getString(R.string.server_down), Toast.LENGTH_LONG).show();
            } else if (tag.equalsIgnoreCase(Constants.LEAN_STARTUP_TAG)) {
                (LeanStartupRoadmap.this).dismissProgressDialog();
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    System.out.println(jsonObject); //{"message":"successfully saved","code":200}

                    Log.e("XXX", "RESULT" + jsonObject.toString());

                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                        deliverablesArrayList.clear();
                        deliverablesArrayListabove.clear();
                        deliverablesArrayListbelow.clear();
                        for (int i = 0; i < jsonObject.optJSONArray("startup").length(); i++) {
                            LeanRoadmapObject obj = new LeanRoadmapObject();
                            obj.setDeliverableid(jsonObject.optJSONArray("startup").getJSONObject(i).optString("id"));
                            obj.setDeliverableName(jsonObject.optJSONArray("startup").getJSONObject(i).optString("title"));
                            obj.setDescription(jsonObject.optJSONArray("startup").getJSONObject(i).optString("description"));
                            obj.setSampleLink(jsonObject.optJSONArray("startup").getJSONObject(i).optString("sample_link"));
                            obj.setColorBG(jsonObject.optJSONArray("startup").getJSONObject(i).optString("color_hexa"));
                            obj.setTemplateLink(jsonObject.optJSONArray("startup").getJSONObject(i).optString("template_link"));
                            deliverablesArrayList.add(obj);
                        }

                        createRoadMap();
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onSessionCreated(boolean success) {

    }
}
