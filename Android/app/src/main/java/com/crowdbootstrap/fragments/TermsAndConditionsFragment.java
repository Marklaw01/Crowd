package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;

import com.crowdbootstrap.R;
import com.crowdbootstrap.utilities.Constants;


public class TermsAndConditionsFragment extends Fragment implements View.OnClickListener {

    private WebView termsAndConditions;
    private CheckBox cbx_agree;
    private Button btn_submit;
    private boolean isAgree;

    public TermsAndConditionsFragment() {

    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_terms_and_conditions, container, false);

        termsAndConditions = (WebView) rootView.findViewById(R.id.termsAndConditions);
        cbx_agree = (CheckBox) rootView.findViewById(R.id.cbx_agree);
        btn_submit = (Button) rootView.findViewById(R.id.btn_submit);

        cbx_agree.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    isAgree = true;
                } else {
                    isAgree = false;
                }
            }
        });

        StringBuilder sb = new StringBuilder();
        sb.append(Constants.HTTP_PREFIX_TAX);
        sb.append("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.");
        sb.append(Constants.HTTP_SUFFIX_TAX);
        //tv_terms_conditions.setMovementMethod(new ScrollingMovementMethod());

        termsAndConditions.loadData(sb.toString(), "text/html", "UTF-8");
        termsAndConditions.getSettings().setRenderPriority(WebSettings.RenderPriority.HIGH);
        termsAndConditions.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);

        btn_submit.setOnClickListener(this);
        return rootView;
    }


    /**
     * Called when a view has been clicked.
     *
     * @param v The view that was clicked.
     */
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_submit:
                System.out.println(isAgree);
                break;
        }
    }
}
