package com.staging.adapter;


import android.app.DatePickerDialog;
import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.DatePicker;
import android.widget.TextView;

import com.staging.R;
import com.staging.fragments.WorkOrderStartUpFragment;
import com.staging.fragments.WorkOrderStartUpFragment.ViewHolder;

import com.staging.utilities.DateTimeFormatClass;
import com.inqbarna.tablefixheaders.adapters.BaseTableAdapter;

import java.util.Calendar;

/**
 * Created by sunakshi.gautam on 2/5/2016.
 */
public abstract class WorkOrderContractorTableAdapter extends BaseTableAdapter {
    private final Context context;
    private final LayoutInflater inflater;
    private DatePickerDialog.OnDateSetListener date;
    private Calendar myCalendar;
    private int layout;


    public TextView tvCurrentDate;
    public TextView tvDate;
    public TextView tvDay;

    /**
     * Constructor
     *
     * @param context The current context.
     */
    public WorkOrderContractorTableAdapter(Context context) {
        this.context = context;
        inflater = LayoutInflater.from(context);
    }

    /**
     * Returns the context associated with this array adapter. The context is
     * used to create views from the resource passed to the constructor.
     *
     * @return The Context associated with this adapter.
     */
    public Context getContext() {
        return context;
    }

    /**
     * Quick access to the LayoutInflater instance that this Adapter retreived
     * from its Context.
     *
     * @return The shared LayoutInflater.
     */
    public LayoutInflater getInflater() {
        return inflater;
    }

    @Override
    public View getView(int row, int column, View converView, ViewGroup parent) {
        layout = getLayoutResource(row, column);
        int sumArray[] = new int[getColumnCount()];
        ViewHolder viewHolder;
        if (converView == null) {
            viewHolder = new ViewHolder();
            converView = inflater.inflate(getLayoutResource(row, column), null);


            if (layout == R.layout.item_table1_header) {
                viewHolder.Text = (TextView) converView.findViewById(R.id.headerdeliverable);

            } else if (layout == R.layout.item_table1) {
                viewHolder.Text2 = (TextView) converView.findViewById(R.id.workunittext);

            } else if (layout == R.layout.item_calendertableheader) {
                tvCurrentDate = (TextView) converView.findViewById(R.id.currentdatetext);

            } else if (layout == R.layout.item_columheader) {
                tvDate = (TextView) converView.findViewById(R.id.coldate);
                tvDay = (TextView) converView.findViewById(R.id.colname);
            }

            converView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) converView.getTag();
        }

        try {
            if (layout == R.layout.item_table1_header) {
                viewHolder.Text.setText(WorkOrderStartUpFragment.arrDeliverablesLabel.get(column).toString());
            } else if (layout == R.layout.item_table1) {
                if (row < 7) {

                    viewHolder.Text2.setText(WorkOrderStartUpFragment.arrDeliverablesworkUnitsLabel.get(((row) * getColumnCount()) + (column)).getWorkUnit());

                } else if (row == 7) {
                    viewHolder.Text2.setText(String.valueOf(WorkOrderStartUpFragment.sumOfColumnText[column]));


                } else {

                    viewHolder.Text2.setText(getCellString(row, column));
                }
            } else if (layout == R.layout.item_calendertableheader) {
                tvCurrentDate.setText(getCellString(row, column));
                myCalendar = Calendar.getInstance();
                final TextView finalTvCurrentDate = tvCurrentDate;

                date = new DatePickerDialog.OnDateSetListener() {

                    @Override
                    public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {

                        myCalendar.set(Calendar.YEAR, year);
                        myCalendar.set(Calendar.MONTH, monthOfYear);
                        myCalendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                        finalTvCurrentDate.setText(DateTimeFormatClass.convertDateObjectToMMDDYYYFormat(myCalendar.getTime()));
                        callAPI(finalTvCurrentDate.getText().toString());

                    }
                };

                tvCurrentDate.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        new DatePickerDialog(context, date, myCalendar
                                .get(Calendar.YEAR), myCalendar.get(Calendar.MONTH),
                                myCalendar.get(Calendar.DAY_OF_MONTH)).show();

                    }
                });

            } else if (layout == R.layout.item_columheader) {

                if (row < 7) {
                    String CurrentString = getCellString(row, column);

                    String[] separated = CurrentString.split(":");

                    tvDate.setText(separated[0]);
                    tvDay.setText(separated[1]);
                } else {
                    tvDate.setText(getCellString(row, column));
                    tvDate.setTextColor(Color.parseColor("#03375C"));
                    tvDay.setVisibility(View.GONE);
                }


            } else {
                //    setText(converView, getCellString(row, column));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return converView;
    }

    /**
     * Sets the text to the view.
     *
     * @param view
     * @param text
     */
    private void setText(View view, String text) {
        ((TextView) view.findViewById(android.R.id.text1)).setText(text);
    }

    /**
     * @param row    the title of the row of this header. If the column is -1
     *               returns the title of the row header.
     * @param column the title of the column of this header. If the column is -1
     *               returns the title of the column header.
     * @return the string for the cell [row, column]
     */
    public abstract String getCellString(int row, int column);

    public abstract void callAPI(String Date);

    public abstract int getLayoutResource(int row, int column);

}

