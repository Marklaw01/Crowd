package com.crowdbootstrapapp.database;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

/**
 * Created by neelmani.karn on 2/10/2016.
 */
public class AppDatabase extends SQLiteOpenHelper {

    // All Static variables
    // Database Version
    private static final int DATABASE_VERSION = 1;

    // Database Name
    private static final String DATABASE_NAME = "CrowdBootstrap.db";

    // Contacts table name
    public static final String TABLE_NOTES = "Notes";

    public static final String _ID = "_id";
    public static final String STARTUP_ID = "startup_id";
    public static final String STARTUP_NAME = "startup_name";
    public static final String NOTE_CREATED_TIME = "created_time";
    public static final String NOTE_NAME = "note_name";
    public static final String NOTE_DESCRIPTION = "note_description";
    public static final String NOTE_CREATED_BY = "user_id";

    public AppDatabase(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        String create_note_table_query = "CREATE TABLE " + TABLE_NOTES + " (" + _ID + " INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , " + NOTE_CREATED_BY + " TEXT, " + STARTUP_ID + " TEXT, " + STARTUP_NAME + " TEXT, " + NOTE_NAME + " TEXT, " + NOTE_DESCRIPTION + " TEXT, " + NOTE_CREATED_TIME + " TEXT )";
        System.out.println(create_note_table_query);

        db.execSQL(create_note_table_query);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }
}
