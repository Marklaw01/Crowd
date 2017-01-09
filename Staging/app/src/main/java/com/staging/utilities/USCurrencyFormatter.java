package com.staging.utilities;

import android.text.Editable;
import android.text.TextWatcher;
import android.widget.EditText;

import java.lang.ref.WeakReference;
import java.text.NumberFormat;
import java.util.Locale;

/**
 * Created by neelmani.karn on 4/4/2016.
 */
public class USCurrencyFormatter implements TextWatcher {
    //UtilitiesClass utilitiesClass;
    //Context context;
    private final WeakReference<EditText> editTextWeakReference;

    public USCurrencyFormatter(EditText editText) {
        editTextWeakReference = new WeakReference<EditText>(editText);
        //this.context = context;
        //utilitiesClass = UtilitiesClass.getInstance(this.context);
    }

    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {
    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {
    }

    @Override
    public void afterTextChanged(Editable editable) {
        EditText editText = editTextWeakReference.get();
        if (editText == null) return;
        String s = editable.toString();

        editText.removeTextChangedListener(this);
        String cleanString = s.toString().replaceAll("[^\\d.]", "");
        //Log.d("cleanString", cleanString);
        Locale locale = new Locale("en", "US");
        NumberFormat fmt = NumberFormat.getCurrencyInstance(locale);
        editText.setText(fmt.format(Double.valueOf(cleanString))+"/HR");
        //editText.setSelection(formatted.length());
        editText.addTextChangedListener(this);
    }
}
