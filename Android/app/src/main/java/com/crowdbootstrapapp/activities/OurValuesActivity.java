package com.crowdbootstrapapp.activities;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.crowdbootstrapapp.R;

/**
 * Created by neelmani.karn on 1/27/2016.
 */
public class OurValuesActivity extends BaseActivity implements View.OnClickListener{

   // private WebView webView;
    private Button btn_ok;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.fragment_values);
        /*webView = (WebView)findViewById(R.id.webView);

        StringBuilder sb = new StringBuilder();
        sb.append(Constants.HTTP_PREFIX_TAX);
        sb.append("We value integrity, intellectual property, creativity and drive. Startups should create and respect intellectual property. Entrepreneurs should develop creative solutions to significant problems then drive market penetration. Independent Contractors must have the integrity to do the right thing and do the thing right.");
        sb.append(Constants.HTTP_SUFFIX_TAX);

        webView.loadData(sb.toString(), "text/html", "UTF-8");
        webView.getSettings().setRenderPriority(WebSettings.RenderPriority.HIGH);
        webView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
*/
        btn_ok = (Button)findViewById(R.id.btn_ok);
        btn_ok.setOnClickListener(this);
    }


    @Override
    public void setActionBarTitle(String title) {

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
