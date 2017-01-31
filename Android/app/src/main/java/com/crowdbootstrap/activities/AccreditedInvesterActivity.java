package com.crowdbootstrap.activities;

import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.TextView;

import com.crowdbootstrap.R;

/**
 * Created by neelmani.karn on 1/27/2016.
 */
public class AccreditedInvesterActivity extends BaseActivity implements View.OnClickListener{

    //private WebView webView;
    private Button btn_ok;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_with_webview);

        try {
            toolbar = (Toolbar)findViewById(R.id.toolbar);
            toolbarTitle = (TextView) findViewById(R.id.titletext);
            setActionBarTitle("Accredited Invester");
            final WebView webview = (WebView) findViewById(R.id.webView);

            webview.getSettings().setJavaScriptEnabled(true);
            webview.loadUrl("file:///android_asset/accredited_invester.html");


            btn_ok = (Button)findViewById(R.id.btn_ok);
            btn_ok.setOnClickListener(this);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @Override
    public void setActionBarTitle(String title) {
        toolbarTitle.setText(title);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.btn_ok:
                finish();
                break;
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        finish();
    }

    @Override
    public void onSessionCreated(boolean success) {

    }
}