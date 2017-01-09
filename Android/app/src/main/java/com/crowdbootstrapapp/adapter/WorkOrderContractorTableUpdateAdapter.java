package com.crowdbootstrapapp.adapter;

import android.app.DatePickerDialog;
import android.content.Context;
import android.graphics.Color;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.RecyclerView.ViewHolder;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.TextView;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.chat.adapter.UsersAdapter;
import com.crowdbootstrapapp.fragments.WorkOrderStartUpFragment;
import com.crowdbootstrapapp.fragments.WorkOrderStartupUpdateFragment.ViewHolderItems;
import com.crowdbootstrapapp.fragments.WorkOrderStartupUpdateFragment;
import com.crowdbootstrapapp.utilities.DateTimeFormatClass;
import com.inqbarna.tablefixheaders.adapters.BaseTableAdapter;

import java.util.Calendar;

/**
 * Created by sunakshi.gautam on 8/31/2016.
 */
public abstract class WorkOrderContractorTableUpdateAdapter extends BaseTableAdapter {
    private final Context context;
    private final LayoutInflater inflater;
    private DatePickerDialog.OnDateSetListener date;
    private Calendar myCalendar;
    private int layout;

    public TextView tvHeader;
    public EditText tvWorkUnit;
    public TextView tvCurrentDate;
    public TextView tvDate;
    public TextView tvDay;


    /**
     * Constructor
     *
     * @param context The current context.
     */
    public WorkOrderContractorTableUpdateAdapter(Context context) {
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
    public View getView(final int row, final int column, View converView, ViewGroup parent) {
        ViewHolderItems viewHolder;
        layout = getLayoutResource(row, column);
        if (converView == null) {
            viewHolder = new ViewHolderItems();
            converView = inflater.inflate(getLayoutResource(row, column), null);
            if (layout == R.layout.item_table1_header) {
                viewHolder.Text2 = (TextView) converView.findViewById(R.id.headerdeliverable);

            } else if (layout == R.layout.item_table_update) {
                viewHolder.Text = (EditText) converView.findViewById(R.id.workunittext);

            } else if (layout == R.layout.item_calendertableheader) {
                tvCurrentDate = (TextView) converView.findViewById(R.id.currentdatetext);

            } else if (layout == R.layout.item_columheader) {
                tvDate = (TextView) converView.findViewById(R.id.coldate);
                tvDay = (TextView) converView.findViewById(R.id.colname);
            }

            converView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolderItems) converView.getTag();
        }

        try {
            if (layout == R.layout.item_table1_header) {
                viewHolder.Text2.setText(WorkOrderStartupUpdateFragment.arrDeliverables.get(column).toString());
            } else if (layout == R.layout.item_table_update) {

                //viewHolder.Text.setText(WorkOrderStartupUpdateFragment.arrDeliverablesworkUnits.get(((row) * getColumnCount()) + (column)).getWorkUnit());

                if (viewHolder.textWatcher != null) {
                    viewHolder.Text.removeTextChangedListener(viewHolder.textWatcher);
                }

                    viewHolder.textWatcher = new TextWatcher() {
                        @Override
                        public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                            if (s.length() != 0) {

                                // WorkOrderStartupUpdateFragment.arrDeliverablesworkUnits.get(((row) * getColumnCount()) + (column)).setWorkUnit(s.toString());

                            }
                        }

                        @Override
                        public void onTextChanged(CharSequence s, int start, int before, int count) {
                            if (s.length() != 0) {

                                WorkOrderStartupUpdateFragment.arrDeliverablesworkUnits.get(((row) * getColumnCount()) + (column)).setWorkUnit(s.toString());

                            }
                        }

                        @Override
                        public void afterTextChanged(Editable s) {
                            if (s.length() != 0) {



                                //WorkOrderStartupUpdateFragment.arrDeliverablesworkUnits.get(((row) * getColumnCount()) + (column)).setWorkUnit(s.toString());

                            }

                        }
                    };

                    viewHolder.Text.addTextChangedListener(viewHolder.textWatcher);
                    viewHolder.Text.setText(WorkOrderStartupUpdateFragment.arrDeliverablesworkUnits.get(((row) * getColumnCount()) + (column)).getWorkUnit());


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
    private void setText(View view, String text, int row, int column) {


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


    private class CustomEtListener implements TextWatcher {
        private int position;
        private int row;
        private int column;

        public CustomEtListener(int row, int column) {
            this.row = row;
            this.column = column;
        }


        /**
         * Updates the position according to onBindViewHolder
         *
         * @param position - position of the focused item
         */
        public void updatePosition(int position) {
            this.position = position;
        }

        @Override
        public void beforeTextChanged(CharSequence charSequence, int i, int i2, int i3) {
            WorkOrderStartupUpdateFragment.arrDeliverablesworkUnits.get(((row) * getColumnCount()) + (column)).getWorkUnit();

        }

        @Override
        public void onTextChanged(CharSequence charSequence, int i, int i2, int i3) {
            // Change the value of array according to the position

        }

        @Override
        public void afterTextChanged(Editable s) {

        }
    }


}