package com.staging.filebrowser;

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.staging.R;
import com.staging.utilities.UtilitiesClass;

import java.io.File;
import java.io.FilenameFilter;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

/**
 * Created by neelmani.karn on 2/12/2016.
 */
public class FilePicker extends ListActivity {

    public final static String EXTRA_FILE_TYPE = "file_type";
    public final static String EXTRA_FILE_PATH = "file_path";
    public final static String EXTRA_SHOW_HIDDEN_FILES = "show_hidden_files";
    public final static String EXTRA_ACCEPTED_FILE_EXTENSIONS = "accepted_file_extensions";
    private final static String DEFAULT_INITIAL_DIRECTORY = Environment.getExternalStorageDirectory() + "/";
    //private String FILE_EXTENSION = "file_extension";
    Bundle getIntent;
    int bytes, bytesDecimal, kilobytes, kilobytesDecimal;
    int megabytes, megabytesDecimal;
    int gigabytes, gigabytesDecimal;

    protected File mDirectory;
    protected ArrayList<File> mFiles;
    protected FilePickerListAdapter mAdapter;
    protected boolean mShowHiddenFiles = false;
    protected String[] acceptedFileExtensions;
    //private Typeface face;
    UtilitiesClass utilitiesClass;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        utilitiesClass = UtilitiesClass.getInstance(FilePicker.this);
        // Set the view to be shown if the list is empty
        LayoutInflater inflator = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View emptyView = inflator.inflate(R.layout.empty_view, null);
        ((ViewGroup) getListView().getParent()).addView(emptyView);
        getListView().setEmptyView(emptyView);

        getIntent = getIntent().getExtras();
        acceptedFileExtensions = getIntent.getStringArray("FILE_EXTENSION");
        // Set initial directory
        mDirectory = new File(DEFAULT_INITIAL_DIRECTORY);

        // Initialize the ArrayList
        mFiles = new ArrayList<File>();
        //face = Typeface.createFromAsset(getAssets(),"fonts/app_font.ttf");
        // Set the ListAdapter
        mAdapter = new FilePickerListAdapter(this, mFiles);
        setListAdapter(mAdapter);

        // Initialize the extensions array to allow any file extensions
        //acceptedFileExtensions = new String[]{FILE_EXTENSION};

        // Get intent extras
        if (getIntent().hasExtra(EXTRA_FILE_PATH)) {
            mDirectory = new File(getIntent().getStringExtra(EXTRA_FILE_PATH));
        }
        if (getIntent().hasExtra(EXTRA_SHOW_HIDDEN_FILES)) {
            mShowHiddenFiles = getIntent().getBooleanExtra(EXTRA_SHOW_HIDDEN_FILES, false);
        }
        /*if (getIntent().hasExtra(EXTRA_ACCEPTED_FILE_EXTENSIONS)) {
            ArrayList<String> collection = getIntent().getStringArrayListExtra(EXTRA_ACCEPTED_FILE_EXTENSIONS);
            acceptedFileExtensions = (String[]) collection.toArray(new String[collection.size()]);
        }*/
    }

    @Override
    protected void onResume() {
        refreshFilesList();
        super.onResume();
    }

    /**
     * Updates the list view to the current directory
     */
    protected void refreshFilesList() {
        // Clear the files ArrayList
        mFiles.clear();

        // Set the extension file filter
        ExtensionFilenameFilter filter = new ExtensionFilenameFilter(acceptedFileExtensions);

        // Get the files in the directory
        File[] files = mDirectory.listFiles(filter);
        if (files != null && files.length > 0) {
            for (File f : files) {
                if (f.isHidden() && !mShowHiddenFiles) {
                    // Don't add the file
                    continue;
                }

                // Add the file the ArrayAdapter
                mFiles.add(f);
            }

            Collections.sort(mFiles, new FileComparator());
        }
        mAdapter.notifyDataSetChanged();
    }

    @Override
    public void onBackPressed() {
        if (mDirectory.getParentFile() != null) {
            // Go to parent directory
            mDirectory = mDirectory.getParentFile();
            refreshFilesList();
            return;
        }
        super.onBackPressed();
    }

    @Override
    protected void onListItemClick(ListView l, View v, int position, long id) {
        File newFile = (File) l.getItemAtPosition(position);

        if (newFile.isFile()) {
            // Set result
            String fileName = null;
            Intent extra = new Intent();
            extra.putExtra(EXTRA_FILE_PATH, newFile.getAbsolutePath());
            if (newFile.getAbsolutePath() != null) {
                int a = newFile.getAbsolutePath().lastIndexOf(".");
                fileName = newFile.getAbsolutePath().substring(a+1);
                if (fileName.contains(" ")) {
                    fileName.replace(" ", "");
                }
            }

            extra.putExtra(EXTRA_FILE_TYPE, fileName);
            setResult(RESULT_OK, extra);

            // Finish the activity
            finish();
        } else {
            mDirectory = newFile;
            // Update the files list
            refreshFilesList();
        }

        super.onListItemClick(l, v, position, id);
    }

    private class FilePickerListAdapter extends ArrayAdapter<File> {

        private List<File> mObjects;

        class ViewHolder {
            TextView textView, fileSize, fileDate;
            ImageView imageView;
        }

        public FilePickerListAdapter(Context context, List<File> objects) {
            super(context, R.layout.list_item, R.id.file_picker_text, objects);
            mObjects = objects;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {

            //View row = null;
            final ViewHolder holder;

            if (convertView == null) {
                LayoutInflater inflater = (LayoutInflater) getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                convertView = inflater.inflate(R.layout.list_item, parent, false);
                holder = new ViewHolder();

                holder.fileDate = (TextView) convertView.findViewById(R.id.file_date);
                holder.fileSize = (TextView) convertView.findViewById(R.id.file_size);
                holder.textView = (TextView) convertView.findViewById(R.id.file_picker_text);
                holder.imageView = (ImageView) convertView.findViewById(R.id.file_picker_image);

                convertView.setTag(holder);
            }else {
                holder = (ViewHolder) convertView.getTag();
            }


            File object = mObjects.get(position);

            Date lastModDate = new Date(object.lastModified());
            DateFormat formater = DateFormat.getDateTimeInstance();
            String date_modify = formater.format(lastModDate);
           // System.out.println("date_modify "+date_modify);

            long filesize = object.length();

           /* ImageView imageView = (ImageView) row.findViewById(R.id.file_picker_image);
            TextView textView = (TextView) row.findViewById(R.id.file_picker_text);
            TextView fileSize = (TextView) row.findViewById(R.id.file_size);
            TextView fileDate = (TextView) row.findViewById(R.id.file_date);*/
            // Set single line
            holder.textView.setSingleLine(true);
            holder.fileSize.setSingleLine(true);
            holder.textView.setText(object.getName());

            holder.fileDate.setText(date_modify/*DateTimeFormatClass.convertDateObjectToMMDDYYYFormat(lastModDate)*/);


            ExtensionFilenameFilter filter = new ExtensionFilenameFilter(acceptedFileExtensions);

            if (object.isFile()) {

                if (Arrays.asList(acceptedFileExtensions).contains(".mp3")){
                    holder.imageView.setImageResource(R.drawable.music);
                }else if (Arrays.asList(acceptedFileExtensions).contains(".mp4")){
                    holder.imageView.setImageResource(R.drawable.video);
                }else if (Arrays.asList(acceptedFileExtensions).contains(".doc") || Arrays.asList(acceptedFileExtensions).contains(".docx") || Arrays.asList(acceptedFileExtensions).contains(".pdf")){
                    holder.imageView.setImageResource(R.drawable.doc);
                }else{
                    holder.imageView.setImageResource(R.drawable.file);
                }
               /* if (acceptedFileExtensions..equalsIgnoreCase(".mp3")){
                    holder.imageView.setImageResource(R.drawable.music);
                }else if (FILE_EXTENSION.equalsIgnoreCase(".mp4")){
                    holder.imageView.setImageResource(R.drawable.video);
                }else if (FILE_EXTENSION.equalsIgnoreCase(".doc")){
                    holder.imageView.setImageResource(R.drawable.doc);
                }else{
                    holder.imageView.setImageResource(R.drawable.file);
                }*/

                if (filesize >= 1024 && filesize < 1048576) {
                    kilobytes = (int) (filesize / 1024);
                    kilobytesDecimal = (int) (filesize % 1024);

                    holder.fileSize.setText(kilobytes /*+ "." + utilitiesClass.truncateIntValueUpto2DecimalPlaces(kilobytesDecimal)*/ + " KB");
                } else if (filesize >= 1048576) {
                    megabytes = (int) (filesize / 1048576);
                    megabytesDecimal = (int) (filesize % 1048576);
                    bytes = (int) filesize;
                    holder.fileSize.setText(megabytes /*+ "." + utilitiesClass.truncateIntValueUpto2DecimalPlaces(megabytesDecimal)*/ + " MB");
                } else if (filesize < 1024) {
                    bytes = (int) filesize;
                    holder.fileSize.setText(bytes/*utilitiesClass.truncateIntValueUpto2DecimalPlaces(bytes)*/ + " Bytes");
                }

            } else {
                // Show the folder icon
                holder.imageView.setImageResource(R.drawable.folder);
                File[] fbuf = object.listFiles(filter);
                int buf = 0;
                if (fbuf != null) {
                    buf = fbuf.length;
                } else
                    buf = 0;
                String num_item = String.valueOf(buf);
                if (buf == 0)
                    num_item = num_item + " item";
                else
                    num_item = num_item + " items";

                if (buf == 0) {
                    holder.fileSize.setText(num_item);
                } else {
                    holder.fileSize.setText(num_item);
                }
            }
            return convertView;
        }
    }

    private class FileComparator implements Comparator<File> {
        public int compare(File f1, File f2) {

            if (f1 == f2) {
                return 0;
            }
            if (f1.isDirectory() && f2.isFile()) {
                // Show directories above files
                return -1;
            }
            if (f1.isFile() && f2.isDirectory()) {
                // Show files below directories
                return 1;
            }
            // Sort the directories alphabetically
            return f1.getName().compareToIgnoreCase(f2.getName());
        }
    }

    private class ExtensionFilenameFilter implements FilenameFilter {
        private String[] mExtensions;

        public ExtensionFilenameFilter(String[] extensions) {
            super();
            mExtensions = extensions;
        }

        public boolean accept(File dir, String filename) {
            if (new File(dir, filename).isDirectory()) {
                // Accept all directory names
                return true;
            }
            if (mExtensions != null && mExtensions.length > 0) {
                for (int i = 0; i < mExtensions.length; i++) {
                    if (filename.endsWith(mExtensions[i])) {
                        // The filename ends with the extension
                        return true;
                    }
                }
                // The filename did not match any of the extensions
                return false;
            }
            // No extensions has been set. Accept all file extensions.
            return true;
        }
    }

    private String getFileExtension(String fileName) {
        return fileName.substring(fileName.lastIndexOf(".") + 1);
    }
}