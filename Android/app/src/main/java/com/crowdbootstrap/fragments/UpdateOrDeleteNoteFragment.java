package com.crowdbootstrap.fragments;

import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.database.AppDatabase;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Date;

/**
 * Created by neelmani.karn on 2/8/2016.
 */
public class UpdateOrDeleteNoteFragment extends Fragment {


    private AppDatabase db;

    private EditText et_startupName;
    private EditText et_title, et_description;
    private Button btn_add, btn_delete;
    Bundle getBundle;

    public UpdateOrDeleteNoteFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_update_note, container, false);
        getBundle = getArguments();


        btn_delete = (Button) rootView.findViewById(R.id.btn_delete);
        btn_add = (Button) rootView.findViewById(R.id.btn_add);
        et_description = (EditText) rootView.findViewById(R.id.et_description);
        et_title = (EditText) rootView.findViewById(R.id.et_title);
        et_startupName = (EditText) rootView.findViewById(R.id.et_startupName);

        db = new AppDatabase(getActivity());
        et_startupName.setText(getBundle.getString(AppDatabase.STARTUP_NAME));
        try {
            JSONObject title = new JSONObject(getBundle.getString(AppDatabase.NOTE_NAME));
            Log.e("title", title.toString());
            ((HomeActivity) getActivity()).setActionBarTitle(title.getString("title"));

            JSONObject desc = new JSONObject(getBundle.getString(AppDatabase.NOTE_DESCRIPTION));
            Log.e("desc", desc.toString());



            et_title.setText(title.getString("title"));
            et_description.setText(desc.getString("desc"));


        } catch (Exception e) {
            e.printStackTrace();
        }





        btn_delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //DELETE FROM Notes Where _id=1
                String deleteQuery = "DELETE FROM " + AppDatabase.TABLE_NOTES + " Where " + AppDatabase._ID + " = " + getBundle.getString(AppDatabase._ID);
                System.out.println(deleteQuery);
                SQLiteDatabase database = db.getWritableDatabase();
                database.execSQL(deleteQuery);
                database.close();
                Toast.makeText(getActivity(), "Your Note Deleted!", Toast.LENGTH_LONG).show();
                getActivity().onBackPressed();

            }
        });

        btn_add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (et_title.getText().toString().trim().isEmpty()) {
                    Toast.makeText(getActivity(), "Title cannot be left blank!", Toast.LENGTH_LONG).show();
                } else {


                    try {
                        JSONObject title = new JSONObject();
                        title.put("title", et_title.getText().toString().trim().replaceAll("'", "''"));
                        JSONObject description = new JSONObject();
                        description.put("desc", et_description.getText().toString().trim().replaceAll("'", "''"));

                        String updateQuery = "UPDATE " + AppDatabase.TABLE_NOTES + " SET " + AppDatabase.NOTE_NAME + " = '" + title.toString().trim() + "', " + AppDatabase.NOTE_DESCRIPTION + "='" + description.toString().trim() + "'," + AppDatabase.NOTE_CREATED_TIME + "='" + new Date() + "' where " + AppDatabase._ID + "=" + getBundle.getString(AppDatabase._ID);
                        System.out.println(updateQuery);
                        SQLiteDatabase database = db.getWritableDatabase();
                        database.execSQL(updateQuery);
                        database.close();
                        Toast.makeText(getActivity(), "Successfully Saved your note", Toast.LENGTH_LONG).show();
                        getActivity().onBackPressed();
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

            }
        });


        return rootView;
    }
}
