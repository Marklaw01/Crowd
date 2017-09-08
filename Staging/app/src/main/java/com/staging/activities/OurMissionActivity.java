package com.staging.activities;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.staging.R;

/**
 * Created by neelmani.karn on 1/27/2016.
 */
public class OurMissionActivity extends BaseActivity implements View.OnClickListener{

    //private WebView webView;
    private Button btn_ok;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.fragment_mission);

       /* webView = (WebView)findViewById(R.id.webView);

        StringBuilder sb = new StringBuilder();
        sb.append(Constants.HTTP_PREFIX_TAX);
        sb.append("Our mission is to accelerate the startup process by giving entrepreneurs on demand access to millions of subject matter experts who can quickly resolve almost any startup challenge no matter how specialized.");
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
