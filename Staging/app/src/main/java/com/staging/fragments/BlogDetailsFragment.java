package com.staging.fragments;

import android.app.ProgressDialog;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.staging.R;

/**
 * Created by sunakshi.gautam on 9/14/2017.
 */

public class BlogDetailsFragment extends Fragment {

    String url;
    private WebView webView;

    public BlogDetailsFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_webview, container, false);

        webView = (WebView) rootView.findViewById(R.id.webView);
        url = getArguments().getString("url").replaceAll(" ", "%20");


        webView.getSettings().setAllowFileAccess(true);

        webView.getSettings().setJavaScriptEnabled(true);
        webView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
        webView.getSettings().setPluginState(WebSettings.PluginState.ON);

        //webView.setWebChromeClient(new WebChromeClient());


        webView.setWebViewClient(new WebViewClient() {
            ProgressDialog pDialog;

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                pDialog = new ProgressDialog(getActivity());
                pDialog.setMessage("Loading Please wait...");
                pDialog.setIndeterminate(false);
                pDialog.setCancelable(false);
                pDialog.show();
                super.onPageStarted(view, url, favicon);
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                try {
                    pDialog.dismiss();
                } catch (Exception e) {

                }
                super.onPageFinished(view, url);
            }
        });


        Log.d("url", getArguments().getString("url"));

        webView.loadUrl(url);

        return rootView;
    }


    @Override
    public void onPause() {
        super.onPause();
        toggleWebViewState(true);
        webView.onPause();
        webView.loadUrl("");
    }

    @Override
    public void onResume() {
        super.onResume();
        toggleWebViewState(false);
        webView.onResume();
    }


    private void toggleWebViewState(boolean pause) {
        try {
            Class.forName("android.webkit.WebView").getMethod(pause ? "onPause" : "onResume", (Class[]) null).invoke(webView, (Object[]) null);
        } catch (Exception e) {
        }
    }


    @Override
    public void onStop() {
        super.onStop();
        // your code

        webView.clearView();
    }
}