package com.crowdbootstrapapp.fragments;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.ContentResolver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.design.widget.Snackbar;
import android.support.design.widget.TabLayout;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.text.Editable;
import android.text.Selection;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.helper.CircleImageView;
import com.crowdbootstrapapp.listeners.onActivityResultListener;
import com.crowdbootstrapapp.utilities.Constants;
import com.crowdbootstrapapp.utilities.ExifUtil;

import java.io.File;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class ProfileFragment extends Fragment implements onActivityResultListener {

    /*private static final int FILE_PICKER = 1;
    private static final int CAMERA_CAPTURE_IMAGE_REQUEST_CODE = 2;
    private static final String IMAGE_DIRECTORY_NAME="Camera";*/
    public static Uri fileUri;

    public static EditText et_username, et_rate;
    public static ImageView editView;
    public static TextView tv_profileComplete;

    public static ProgressBar progressProfileComplete;
    public static TabLayout tabLayout;
    public static ViewPager viewPager;
    public static int int_items = 3;
    public static ImageView circularImageView;
    private ImageView img_UserSwitch;
    private boolean fromContractor = false;
    private LinearLayout layout;
    public static Bitmap bitmap;
    public String filepath;
    public String fileName;
    public String selectedImagePath;
    public BasicProfileFragment basefragment;
    public ProfessionalFragment professionalFragment;
    public StartUpsProfileFragment startupsfragment;

    ProfileAdapter adapter;

    public ProfileFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.myProfile));
        ((HomeActivity) getActivity()).setOnActivityResultListener(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_profile, container, false);

        try {
            layout = (LinearLayout) rootView.findViewById(R.id.layout);
            img_UserSwitch = (ImageView) rootView.findViewById(R.id.imageuser);
            editView = (ImageView) rootView.findViewById(R.id.edit);
            et_rate = (EditText) rootView.findViewById(R.id.et_rate);
            et_username = (EditText) rootView.findViewById(R.id.et_username);

            tv_profileComplete = (TextView) rootView.findViewById(R.id.tv_profileComplete);
            progressProfileComplete = (ProgressBar) rootView.findViewById(R.id.progressProfileComplete);
            et_rate.setVisibility(View.VISIBLE);

            et_rate.setFocusable(false);

            et_rate.setCursorVisible(false);
            et_rate.setFocusableInTouchMode(false);

            //priceEditText.addTextChangedListener(new MoneyTextWatcher(priceEditText));


            et_rate.addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                }

                private String current = "";

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                    if (!s.toString().matches("^\\$(\\d{1,3}(\\,\\d{3})*|(\\d+))(\\.\\d{2})?$")) {
                        String userInput = "" + s.toString().replaceAll("[^\\d]", "");
                        StringBuilder cashAmountBuilder = new StringBuilder(userInput);

                        while (cashAmountBuilder.length() > 3 && cashAmountBuilder.charAt(0) == '0') {
                            cashAmountBuilder.deleteCharAt(0);
                        }
                        while (cashAmountBuilder.length() < 3) {
                            cashAmountBuilder.insert(0, '0');
                        }
                        //cashAmountBuilder.insert(cashAmountBuilder.length() - 2, '.');
                        //cashAmountBuilder.insert(0, '$');
                        //cashAmountBuilder.insert(cashAmountBuilder.length(),"/HR");
                        Locale locale = new Locale("en", "US");
                        NumberFormat fmt = NumberFormat.getCurrencyInstance(locale);

                        double parsed = Double.parseDouble(cashAmountBuilder.toString());
                        String formated = fmt.format((parsed/100));

                        et_rate.setText(formated);
                        Selection.setSelection(et_rate.getText(), formated.length());
                    }
                }

                @Override
                public void afterTextChanged(Editable s) {
                    /*if (!s.toString().equals(current)) {
                        String cleanString = s.toString().replaceAll("[^\\d.]", "");

                        Locale locale = new Locale("en", "US");
                        NumberFormat fmt = NumberFormat.getCurrencyInstance(locale);

                        double parsed = Double.parseDouble(cleanString);
                        String formated = fmt.format((parsed/100));//NumberFormat.getCurrencyInstance().format((parsed / 100));

                        current = formated;
                        et_rate.setText(formated+"/HR");
                        et_rate.setSelection(formated.length());
                    }*/
                }
            });


            //et_rate.addTextChangedListener(new USCurrencyFormatter(et_rate));


            ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_TYPE, Constants.CONTRACTOR);
            img_UserSwitch.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (fromContractor == true) {
                        // fromContractor = false;
                        //et_rate.setVisibility(View.VISIBLE);
                        //et_username.setText("Contractor Name");

                    } else {
                        //et_rate.setVisibility(View.VISIBLE);
                        // et_username.setText("Contractor Name");
                        //et_rate.setVisibility(View.GONE);
                        //et_username.setText("EntrePreneur Name");
                        img_UserSwitch.setImageResource(R.drawable.entrepreneurselected);
                        ((HomeActivity) getActivity()).prefManager.storeString(Constants.USER_TYPE, Constants.ENTREPRENEUR);
                        Fragment fragment = new EntrepreneurProfileFragment();
                        /*if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                            fragment.setEnterTransition(new Slide(Gravity.RIGHT));
                            fragment.setExitTransition(new Slide(Gravity.LEFT));
                        }*/

                        ((HomeActivity)getActivity()).replaceFragment(fragment);
                        /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();

                        transactionRate.replace(R.id.container, fragment);
                        //transactionRate.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                        //transactionRate.addToBackStack(null);

                        transactionRate.commit();*/
                    }

                }
            });

            editView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    et_rate.setBackgroundDrawable(getResources().getDrawable(R.drawable.emailtextbox));
                    et_rate.setFocusable(true);
                    et_rate.requestFocus();
                    et_rate.setCursorVisible(true);
                    et_rate.setFocusableInTouchMode(true);
                    editView.setVisibility(View.GONE);
                }
            });


            circularImageView = (CircleImageView) rootView.findViewById(R.id.profileimage);

            ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_PROFILE_IMAGE_URL), circularImageView, ((HomeActivity) getActivity()).options);

            circularImageView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    alertDialogForPicture();
                }
            });

            tabLayout = (TabLayout) rootView.findViewById(R.id.tabs);
            viewPager = (ViewPager) rootView.findViewById(R.id.viewpager);

            viewPager.setOffscreenPageLimit(3);
            viewPager.setAdapter(new ProfileAdapter(getChildFragmentManager()));

            tabLayout.post(new Runnable() {
                @Override
                public void run() {
                    tabLayout.setupWithViewPager(viewPager);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootView;
    }

    class ProfileAdapter extends FragmentPagerAdapter {

        public ProfileAdapter(FragmentManager fm) {
            super(fm);
        }

        /**
         * Return fragment with respect to Position .
         */

        @Override
        public Fragment getItem(int position) {
            switch (position) {
                case 0:
                    return basefragment = new BasicProfileFragment();
                case 1:
                    return professionalFragment = new ProfessionalFragment();
                case 2:
                    return startupsfragment = new StartUpsProfileFragment();
            }
            return null;
        }

        @Override
        public int getCount() {
            return int_items;
        }

        /**
         * This method returns the title of the tab according to the position.
         */

        @Override
        public CharSequence getPageTitle(int position) {

            switch (position) {
                case 0:
                    return "Basic";
                case 1:
                    return "Professional";
                case 2:
                    return "Startup";
            }
            return null;
        }
    }

    protected void alertDialogForPicture() {
        try {
            AlertDialog.Builder builderSingle = new AlertDialog.Builder(getActivity()/*new ContextThemeWrapper(getActivity(), android.R.style.Theme_Holo_Light_Dialog)*/);
            final CharSequence[] opsChars = {"Upload Image", "Take Picture"};
            builderSingle.setCancelable(true);
            builderSingle.setItems(opsChars, new DialogInterface.OnClickListener() {

                @Override
                public void onClick(DialogInterface dialog, int which) {
                    if ((ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                        requestPermission();
                    } else {
                        switch (which) {

                            case 0:
                                try {
                                    Intent i = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                                    getActivity().startActivityForResult(i, Constants.FILE_PICKER);
                                } catch (Exception e) {
                                    Toast.makeText(getActivity(), "Please provide permission of Sd-Card from apps permission setting", Toast.LENGTH_LONG).show();
                                }
                                break;
                            case 1:
                                try {
                                    Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                                    fileUri = getOutputMediaFileUri(Constants.FILE_PICKER);
                                    intent.putExtra(MediaStore.EXTRA_OUTPUT, fileUri);
                                    getActivity().startActivityForResult(intent, Constants.CAMERA_CAPTURE_IMAGE_REQUEST_CODE);
                                } catch (SecurityException e) {
                                    Toast.makeText(getActivity(), "Please provide permission of camera from apps permission setting", Toast.LENGTH_LONG).show();
                                    e.printStackTrace();
                                }
                        }
                    }
                }
            });
            builderSingle.show();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void requestPermission() {
        try {
            Log.i("TAG", "CAMERA permission has NOT been granted. Requesting permission.");

            // BEGIN_INCLUDE(camera_permission_request)
            if ((ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.CAMERA)) && ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.READ_EXTERNAL_STORAGE)) {
                // Provide an additional rationale to the user if the permission was not granted
                // and the user would benefit from additional context for the use of the permission.
                // For example if the user has previously denied the permission.
                Log.i("TAG", "Displaying camera permission rationale to provide additional context.");

                Snackbar.make(layout, R.string.app_permision, Snackbar.LENGTH_INDEFINITE)
                        .setAction("OK", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.CAMERA, Manifest.permission.READ_EXTERNAL_STORAGE}, Constants.APP_PERMISSION);
                            }
                        })
                        .show();
            } else {

                // Camera permission has not been granted yet. Request it directly.
                ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.CAMERA, Manifest.permission.READ_EXTERNAL_STORAGE}, Constants.APP_PERMISSION);
            }
            // END_INCLUDE(camera_permission_request)
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {

        try {
            if (requestCode == Constants.APP_PERMISSION) {
                // BEGIN_INCLUDE(permission_result)
                // Received permission result for camera permission.
                Log.i("TAG", "Received response for Camera permission request.");

                // Check if the only required permission has been granted
                if (grantResults.length == 1 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // Camera permission has been granted, preview can be displayed
                    Log.i("TAG", "CAMERA permission has now been granted. Showing preview.");
                    Snackbar.make(layout, R.string.permision_available_camera, Snackbar.LENGTH_SHORT).show();
                } else {
                    Log.i("TAG", "CAMERA permission was NOT granted.");
                    Snackbar.make(layout, R.string.permissions_not_granted, Snackbar.LENGTH_SHORT).show();
                }
            } else {
                super.onRequestPermissionsResult(requestCode, permissions, grantResults);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        try {
            switch (requestCode) {

                case Constants.CAMERA_CAPTURE_IMAGE_REQUEST_CODE:

                    // if the result is capturing Image
                    if (requestCode == Constants.CAMERA_CAPTURE_IMAGE_REQUEST_CODE) {
                        if (resultCode == Activity.RESULT_OK) {
                            // successfully captured the image
                            // display it in image view
                            try {
                                // bimatp factory
                                BitmapFactory.Options options = new BitmapFactory.Options();

                                // downsizing image as it throws OutOfMemory Exception for larger
                                // images
                                options.inSampleSize = 8;

                                filepath = fileUri.getPath();

                                decodeFile(filepath, fileUri);
                            } catch (NullPointerException e) {
                                e.printStackTrace();
                            }
                        } else if (resultCode == Activity.RESULT_CANCELED) {
                            // user cancelled Image capture
                            Toast.makeText(getActivity(),
                                    "User cancelled image capture", Toast.LENGTH_LONG)
                                    .show();
                        } else {
                            // failed to capture image
                            Toast.makeText(getActivity(),
                                    "Sorry! Failed to capture image", Toast.LENGTH_LONG)
                                    .show();
                        }
                    }

                    break;
                case Constants.FILE_PICKER:

                    if (resultCode == Activity.RESULT_OK) {
                        Uri selectedImageUri = data.getData();
                        System.out.println("selectedImageUri " + selectedImageUri);

                        try {
                            String filemanagerstring = selectedImageUri.getPath();
                            System.out.println("filemanagerstring " + filemanagerstring);
                            selectedImagePath = getPath(getActivity(), selectedImageUri);
                            System.out.println("selectedImagePath " + selectedImagePath);
                            if (selectedImagePath != null) {
                                filepath = selectedImagePath;
                            } else if (filemanagerstring != null) {
                                filepath = filemanagerstring;
                            } else {
                                Toast.makeText(getActivity(), "Unknown path", Toast.LENGTH_LONG).show();
                            }


                            if (filepath.contains("http") || filepath.contains("https")) {
                                Toast.makeText(getActivity(), "Unknown path", Toast.LENGTH_LONG).show();
                            } else if (filepath != null) {
                                int a = filepath.lastIndexOf("/");
                                fileName = filepath.substring(a + 1);
                                decodeFile(filepath, selectedImageUri);
                            }
                        } catch (Exception e) {
                            System.out.println(e);
                            Toast.makeText(getActivity(), "Internal error", Toast.LENGTH_LONG).show();
                        }
                    }
                    break;
                default:
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Uri getOutputMediaFileUri(int type) {
        return Uri.fromFile(getOutputMediaFile(type));
    }


    private static File getOutputMediaFile(int type) {

        try {
            // External sdcard location
            File mediaStorageDir = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM), Constants.IMAGE_DIRECTORY_NAME);

            // Create the storage directory if it does not exist
            if (!mediaStorageDir.exists()) {
                if (!mediaStorageDir.mkdirs()) {
                    Log.d(Constants.IMAGE_DIRECTORY_NAME, "Oops! Failed create " + Constants.IMAGE_DIRECTORY_NAME + " directory");
                    return null;
                }
            }

            // Create a media file name
            String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(new Date());
            File mediaFile;
            if (type == Constants.FILE_PICKER) {
                mediaFile = new File(mediaStorageDir.getPath() + File.separator + "IMG_" + timeStamp + ".jpg");
            } else {
                return null;
            }
            System.out.println("media file " + mediaFile.getAbsolutePath());
            return mediaFile;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public String getPath(Context context, Uri uri) {

        try {
            ContentResolver content = context.getContentResolver();
            String[] projection = {MediaStore.Images.Media.DATA};
            Cursor cursor = content.query(uri, projection, null, null, null);
            if (cursor != null) {
                int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
                cursor.moveToFirst();
                String s = cursor.getString(column_index);
                //cursor.close();
                return s;

            } else
                return null;
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            return null;
        }catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void decodeFile(String filePath, Uri selectedImageUri) {
        int orientation;
        try {
            System.out.println("filePath " + filePath);
            // Decode image size
            BitmapFactory.Options o = new BitmapFactory.Options();
            o.inJustDecodeBounds = true;
            BitmapFactory.decodeFile(filePath, o);
            // The new size we want to scale to
            final int REQUIRED_SIZE = 1024;
            // Find the correct scale value. It should be the power of 2.
            int width_tmp = o.outWidth, height_tmp = o.outHeight;
            int scale = 1;
            while (true) {
                if (width_tmp < REQUIRED_SIZE && height_tmp < REQUIRED_SIZE)
                    break;
                width_tmp /= 2;
                height_tmp /= 2;
                scale *= 2;
            }

            BitmapFactory.Options o2 = new BitmapFactory.Options();
            o2.inSampleSize = scale;
            bitmap = BitmapFactory.decodeFile(filePath, o2);
            Bitmap orientedBitmap = ExifUtil.rotateBitmap(filePath, bitmap);


            circularImageView.setImageBitmap(orientedBitmap);


            basefragment.SetFilename(filepath, orientedBitmap);
            professionalFragment.SetFilename(filepath, orientedBitmap);
        } catch (Exception e) {
            e.printStackTrace();
            circularImageView.setImageResource(R.drawable.image);
        }
    }

    /*public void SetFilename(String filename, Bitmap bitmap)
    {
        basefragment.SetFilename(filepath);
    }*/
}