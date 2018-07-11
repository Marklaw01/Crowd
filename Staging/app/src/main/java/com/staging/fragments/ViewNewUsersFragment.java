package com.staging.fragments;


import android.app.Dialog;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.adapter.AnonymousUserAdapter;
import com.staging.helper.TouchImageView;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.loadmore_listview.LoadMoreListView;
import com.staging.models.AnonymousUserObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class ViewNewUsersFragment extends Fragment implements AdapterView.OnItemClickListener, AsyncTaskCompleteListener<String> {


    private static int TOTAL_ITEMS = 0;
    int current_page = 1;
    private ArrayList<AnonymousUserObject> contractorsList;
    private TextView btn_search;
    private EditText et_search;
    private LoadMoreListView list_startups;
    private AnonymousUserAdapter adapter;
    private LinearLayout searchLayout;
    private String statup_id = "";

    public ViewNewUsersFragment() {
    }

    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            ((HomeActivity) getActivity()).setOnBackPressedListener(this);

            try {
                current_page = 1;
                contractorsList = new ArrayList<AnonymousUserObject>();
                contractorsList.clear();
                adapter = null;
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SEARCH_TEMP_BUSINESS_NETWORKS_TAG, Constants.SEARCH_TEMP_BUSINESS_NETWORKS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET, "Home Activity");
                    a.execute();
                } else {
                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }

            } catch (Exception e) {
                e.printStackTrace();
                Log.e("xxx", "EXception++++" + e.getMessage());
            }
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_search_starups, container, false);

        try {
            et_search = (EditText) rootView.findViewById(R.id.et_search);
            list_startups = (LoadMoreListView) rootView.findViewById(R.id.list_startups);
            btn_search = (TextView) rootView.findViewById(R.id.btn_search);
            searchLayout = (LinearLayout) rootView.findViewById(R.id.searchlayout);
            //statup_id = getArguments().getString("startup_id");
            contractorsList = new ArrayList<AnonymousUserObject>();
            btn_search.setVisibility(View.GONE);
            et_search.setVisibility(View.GONE);
            searchLayout.setVisibility(View.GONE);

            options = new DisplayImageOptions.Builder()
                    .showImageOnLoading(R.drawable.image)
                    .showImageForEmptyUri(R.drawable.image)
                    .showImageOnFail(R.drawable.image)
                    .cacheInMemory(true)
                    .cacheOnDisk(true)
                    .considerExifParams(true)
                    .bitmapConfig(Bitmap.Config.RGB_565)
                    .build();

            list_startups.setOnLoadMoreListener(new LoadMoreListView.OnLoadMoreListener() {
                public void onLoadMore() {
                    // Do the work to load more items at the end of list
                    // here
                    //
                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {

                        current_page += 1;
                        Log.e("items", String.valueOf(adapter.getCount()));
                        if (TOTAL_ITEMS != adapter.getCount()) {
                            String searchedKey = ((HomeActivity) getActivity()).utilitiesClass.removeSpecialCharacters(et_search.getText().toString().trim());
                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SEARCH_TEMP_BUSINESS_NETWORKS_TAG, Constants.SEARCH_TEMP_BUSINESS_NETWORKS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&page_no=" + current_page, Constants.HTTP_GET, "Home Activity");
                            a.execute();
                        } else {
                            list_startups.onLoadMoreComplete();
                            adapter.notifyDataSetChanged();
                            ((HomeActivity) getActivity()).dismissProgressDialog();
                        }

                    } else {

                        list_startups.onLoadMoreComplete();
                        adapter.notifyDataSetChanged();
                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                }
            });

            et_search.setVisibility(View.GONE);
//            et_search.setImeOptions(EditorInfo.IME_ACTION_DONE);
//            et_search.setOnEditorActionListener(new EditText.OnEditorActionListener() {
//                @Override
//                public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
//                    if (actionId == EditorInfo.IME_ACTION_DONE) {
//                        current_page = 1;
//                        contractorsList = new ArrayList<ContractorsObject>();
//                        contractorsList.clear();
//                        adapter = null;
//                        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
//
//                            String searchedKey = ((HomeActivity) getActivity()).utilitiesClass.removeSpecialCharacters(et_search.getText().toString().trim());
//                            Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SEARCH_BUSINESS_NETWORKS_TAG, Constants.SEARCH_BUSINESS_NETWORKS_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&search_text=" + searchedKey + "&page_no=" + current_page, Constants.HTTP_GET, "Home Activity");
//                            a.execute();
//                        } else {
//                            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
//                        }
//                        return true;
//                    }
//                    return false;
//                }
//            });


            list_startups.setOnItemClickListener(this);
        } catch (Exception e) {
            e.printStackTrace();
        }


        return rootView;
    }

    FragmentManager manager;

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        try {
            if (!contractorsList.get(position).getImage().isEmpty()) {
                Log.e("XXX" , "NOT EMPTY0");
                String imageUrl = Constants.APP_IMAGE_URL + "/" + contractorsList.get(position).getImage().toString();
                alertDialog(imageUrl);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


    public DisplayImageOptions options;
    private Bitmap bitmap;

    public void alertDialog(String imageUrl) {

        final Dialog dialog = new Dialog(getActivity());
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.pinch_and_zoom_imageview_dialog);

        final TouchImageView imageView = (TouchImageView) dialog.findViewById(R.id.roadmapImage);
        final Button okText = (Button) dialog.findViewById(R.id.btn_ok);
        imageView.setImageResource(R.drawable.image);

        Log.e("imageUrl", imageUrl);

        if (imageUrl.contains("http") || imageUrl.contains("https")) {
            ImageLoader.getInstance().displayImage(imageUrl, imageView, options);
        } else {

            int orientation;
            try {
                System.out.println(imageUrl);
                // Decode image size
                BitmapFactory.Options o = new BitmapFactory.Options();
                o.inJustDecodeBounds = true;
                BitmapFactory.decodeFile(imageUrl, o);
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
                bitmap = BitmapFactory.decodeFile(imageUrl, o2);
                imageView.setImageBitmap(bitmap);
            } catch (Exception e) {
                e.printStackTrace();
                Log.e("XXX", "INTENAL ERROR 4+" + e.getMessage());
                imageView.setImageResource(R.drawable.image);
            }

        }
        okText.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });
        dialog.show();
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
                if (tag.equalsIgnoreCase(Constants.SEARCH_TEMP_BUSINESS_NETWORKS_TAG)) {
                    Log.e("XXXX", "RESPONSE+++++ INONTASKCMPLETE");

                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        Log.e("XXXX", "RESPONSE+++++" + jsonObject.toString());
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            TOTAL_ITEMS = Integer.parseInt(jsonObject.optString("TotalItems"));
                            contractorsList.clear();
                            if (jsonObject.optJSONArray("businessCards").length() != 0) {
                                for (int i = 0; i < jsonObject.optJSONArray("businessCards").length(); i++) {
                                    JSONObject contracotrs = jsonObject.optJSONArray("businessCards").getJSONObject(i);
                                    AnonymousUserObject obj = new AnonymousUserObject();
                                    obj.setName(contracotrs.optString("name"));
                                    obj.setConnection_type(contracotrs.optString("connection_type"));
                                    obj.setConnection_type_id(contracotrs.optString("contact_id"));
                                    obj.setEmail(contracotrs.optString("email"));
                                    obj.setImage(contracotrs.optString("image"));
                                    obj.setNote(contracotrs.optString("note"));
                                    obj.setPhone(contracotrs.optString("phone"));


                                    contractorsList.add(obj);
                                    //Log.e("XXX","NAME"+contracotrs.optString("name")+"++++++ISPUBLIC"+contracotrs.optString("is_profile_public"));

                                }

                                if (adapter == null) {
                                    adapter = new AnonymousUserAdapter(getActivity(), contractorsList, "search", "   ");
                                    list_startups.setAdapter(adapter);
                                }


                                list_startups.onLoadMoreComplete();
                                adapter.notifyDataSetChanged();

                                int index = list_startups.getLastVisiblePosition();
                                list_startups.smoothScrollToPosition(index);
                            } else {
                                Toast.makeText(getActivity(), "No Contractors found", Toast.LENGTH_LONG).show();
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No Contractors found", Toast.LENGTH_LONG).show();
                        }


                    } catch (JSONException e) {
                        //((HomeActivity) getActivity()).dismissProgressDialog();
                        e.printStackTrace();
                        Log.e("XXX", "Exception+++++" + e.getMessage());
                    }


                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

    }


}

