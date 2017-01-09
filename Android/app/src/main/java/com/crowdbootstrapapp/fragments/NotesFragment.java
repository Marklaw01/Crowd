package com.crowdbootstrapapp.fragments;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.adapter.NotesSectionListAdapter;
import com.crowdbootstrapapp.database.AppDatabase;
import com.crowdbootstrapapp.listeners.AsyncTaskCompleteListener;
import com.crowdbootstrapapp.models.NotesObject;
import com.crowdbootstrapapp.utilities.Constants;

import java.util.ArrayList;

import se.emilsjolander.stickylistheaders.StickyListHeadersListView;

/**
 * Created by neelmani.karn on 1/19/2016.
 */
public class NotesFragment extends Fragment implements AsyncTaskCompleteListener<String> {

    private AppDatabase db;
    private SQLiteDatabase database;
    private Button btn_add;
    private ArrayList<NotesObject> list;
    private StickyListHeadersListView stickyList;
    private NotesSectionListAdapter adapter;

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle("Notes");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_notes, container, false);
        stickyList = (StickyListHeadersListView) rootView.findViewById(R.id.list);

        btn_add = (Button) rootView.findViewById(R.id.btn_add);
        btn_add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Fragment addContributor = new AddNoteFragment();
                ((HomeActivity)getActivity()).replaceFragment(addContributor);
                /*FragmentTransaction transactionAdd = getFragmentManager().beginTransaction();

                transactionAdd.replace(R.id.container, addContributor);
                transactionAdd.addToBackStack(null);

                transactionAdd.commit();*/
            }
        });
        list = new ArrayList<NotesObject>();

        db = new AppDatabase(getActivity());
        database = db.getReadableDatabase();
        String selectQuery = "SELECT * FROM " + AppDatabase.TABLE_NOTES + " WHERE " + AppDatabase.NOTE_CREATED_BY + "=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID);

        Cursor cursor = database.rawQuery(selectQuery, null);

        if (cursor.moveToFirst()) {
            do {
                NotesObject obj = new NotesObject();

                obj.setNoteId(cursor.getString(cursor.getColumnIndex(AppDatabase._ID)));
                obj.setNoteStartupId(cursor.getString(cursor.getColumnIndex(AppDatabase.STARTUP_ID)));
                obj.setNoteStartupName(cursor.getString(cursor.getColumnIndex(AppDatabase.STARTUP_NAME)));
                obj.setNoteDescription(cursor.getString(cursor.getColumnIndex(AppDatabase.NOTE_DESCRIPTION)));
                obj.setNoteName(cursor.getString(cursor.getColumnIndex(AppDatabase.NOTE_NAME)));
                obj.setNoteCreatedDate(cursor.getString(cursor.getColumnIndex(AppDatabase.NOTE_CREATED_TIME)));
                list.add(obj);

            } while (cursor.moveToNext());
        }
        cursor.close();
        database.close();

        adapter = new NotesSectionListAdapter(getActivity(), list);
        stickyList.setAdapter(adapter);

        stickyList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Fragment addContributor = new UpdateOrDeleteNoteFragment();

                Bundle bundle = new Bundle();
                bundle.putString(AppDatabase._ID, list.get(position).getNoteId());
                bundle.putString(AppDatabase.STARTUP_ID, list.get(position).getNoteStartupId());
                bundle.putString(AppDatabase.STARTUP_NAME, list.get(position).getNoteStartupName());
                bundle.putString(AppDatabase.NOTE_NAME, list.get(position).getNoteName());
                bundle.putString(AppDatabase.NOTE_DESCRIPTION, list.get(position).getNoteDescription());
                /*bundle.putString(AppDatabase.NOTE_CREATED_TIME, list.get(position).getNoteCreatedDate());*/
                addContributor.setArguments(bundle);
                ((HomeActivity)getActivity()).replaceFragment(addContributor);
                /*FragmentTransaction transactionAdd = getFragmentManager().beginTransaction();
                transactionAdd.replace(R.id.container, addContributor);
                transactionAdd.addToBackStack(null);

                transactionAdd.commit();*/
            }
        });
        return rootView;
    }


    public NotesFragment() {
        super();
    }

    @Override
    public void onTaskComplete(String result, String tag) {

    }
}
