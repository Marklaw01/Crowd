package com.staging.fragments;

import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteStatement;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.database.AppDatabase;
import com.staging.dropdownadapter.SpinnerAdapter;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.models.GenericObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;

/**
 * Created by neelmani.karn on 2/8/2016.
 */
public class AddNoteFragment extends Fragment implements AsyncTaskCompleteListener<String> {

    private String startupId = "0", startupName = "";
    private AppDatabase db;
    private ArrayList<GenericObject> list;
    private Spinner spinner_chooseStartup;
    private EditText et_title, et_description;
    private Button btn_add;

    public AddNoteFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_add_note, container, false);
        ((HomeActivity) getActivity()).setActionBarTitle("Add Note");

        list = new ArrayList<GenericObject>();
        btn_add = (Button) rootView.findViewById(R.id.btn_add);
        et_description = (EditText) rootView.findViewById(R.id.et_description);
        et_title = (EditText) rootView.findViewById(R.id.et_title);
        spinner_chooseStartup = (Spinner) rootView.findViewById(R.id.spinner_chooseStartup);

        db = new AppDatabase(getActivity());

        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();
            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.COMPLETE_LISTOF_STARTUPS_OF_USER_TAG, Constants.COMPLETE_LISTOF_STARTUPS_OF_USER_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID), Constants.HTTP_GET,"Home Activity");

            a.execute();
        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }

/*

        GenericObject choose = new GenericObject();
        choose.setId("0");
        choose.setTitle("Select Startup");
        list.add(choose);
        for (int i=0; i<10;i++){
            GenericObject obj = new GenericObject();
            obj.setId(""+(i+1));
            obj.setTitle("Startup "+(i+1));
            list.add(obj);
        }

        SpinnerAdapter adapter = new SpinnerAdapter(getActivity(), 0, list);
        spinner_chooseStartup.setAdapter(adapter);*/


        spinner_chooseStartup.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                startupId = list.get(position).getId();
                startupName = list.get(position).getTitle();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });


        btn_add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (startupId.equalsIgnoreCase("0")) {
                    Toast.makeText(getActivity(), "Select Startup!", Toast.LENGTH_LONG).show();
                } else if (et_title.getText().toString().trim().isEmpty()) {
                    Toast.makeText(getActivity(), "Title cannot be left blank!", Toast.LENGTH_LONG).show();
                } else {

                    try {
                        JSONObject title = new JSONObject();
                        title.put("title", et_title.getText().toString().trim().replaceAll("'", "''"));
                        JSONObject description = new JSONObject();
                        description.put("desc", et_description.getText().toString().trim().replaceAll("'", "''"));

                        //String insertQuery = "INSERT INTO " + AppDatabase.TABLE_NOTES + " (" + AppDatabase.NOTE_CREATED_BY + "," + AppDatabase.STARTUP_ID + "," + AppDatabase.STARTUP_NAME + "," + AppDatabase.NOTE_NAME + "," + AppDatabase.NOTE_DESCRIPTION + "," + AppDatabase.NOTE_CREATED_TIME + ") VALUES ('" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "','" + startupId + "','" + startupName + "','" + title.toString().trim() + "','" + description.toString().trim() + "','" + new Date() + "')";
                        //System.out.println(insertQuery);
                        SQLiteDatabase database = db.getWritableDatabase();
                        SQLiteStatement stmt = database.compileStatement("INSERT INTO Notes (user_id,startup_id,startup_name,note_name,note_description,created_time) VALUES (?,?,?,?,?,?)");
                        stmt.bindString(1, ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                        stmt.bindString(2, startupId);
                        stmt.bindString(3, startupName);
                        stmt.bindString(4, title.toString().trim());
                        stmt.bindString(5, description.toString().trim());
                        stmt.bindString(6, new Date().toString());
                        stmt.execute();


                        //database.execSQL(insertQuery);
                        database.close();

                        getActivity().onBackPressed();
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }


                }

            }
        });


        return rootView;
    }

    @Override
    public void onTaskComplete(String result, String tag) {
        try {
            if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
            } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
                ((HomeActivity) getActivity()).dismissProgressDialog();
                Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
            } else {
                if (tag.equalsIgnoreCase(Constants.COMPLETE_LISTOF_STARTUPS_OF_USER_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);

                        GenericObject obj = new GenericObject();
                        obj.setTitle("Choose Startup");
                        obj.setId("0");
                        list.add(obj);

                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            for (int i = 0; i < jsonObject.optJSONArray("startup").length(); i++) {
                                GenericObject startupsObject = new GenericObject();
                                startupsObject.setId(jsonObject.optJSONArray("startup").optJSONObject(i).optString("id"));
                                startupsObject.setTitle(jsonObject.optJSONArray("startup").optJSONObject(i).optString("name"));
                                list.add(startupsObject);
                            }
                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                            Toast.makeText(getActivity(), jsonObject.optString("message") + " Try Again!", Toast.LENGTH_LONG).show();

                        }
                        spinner_chooseStartup.setAdapter(new SpinnerAdapter(getActivity(), 0, list));
                    } catch (JSONException e) {
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}