package com.staging.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.RatingBar;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.helper.CircleImageView;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.models.ExcellenceAwardObject;
import com.staging.utilities.Async;
import com.staging.utilities.Constants;
import com.nostra13.universalimageloader.core.ImageLoader;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 2/5/2016.
 */
public class ExcellenceAwardFragment extends Fragment implements AsyncTaskCompleteListener<String> {

    private Button btn_rate;
    private ExcellenceAwardAdapter adapter;
    private ListView list_awards;
    private ArrayList<ExcellenceAwardObject> list;
    private String userId = "";
    private String userType = "";

    public ExcellenceAwardFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        ((HomeActivity) getActivity()).setActionBarTitle(getString(R.string.excellenceAward));
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_excellence_award, container, false);

        try {
            list = new ArrayList<ExcellenceAwardObject>();
            list_awards = (ListView) rootView.findViewById(R.id.list_awards);

            userId = getArguments().getString("id");
            userType = getArguments().getString("user_type");
            btn_rate = (Button) rootView.findViewById(R.id.btn_rate);
            btn_rate.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Fragment rateContributor = new RateContributor();

                    Bundle bundle = new Bundle();
                    bundle.putString("userId", userId);
                    bundle.putString("user_type", userType);
                    rateContributor.setArguments(bundle);
                    ((HomeActivity) getActivity()).replaceFragment(rateContributor);
                    /*FragmentTransaction transactionRate = getFragmentManager().beginTransaction();
                    transactionRate.replace(R.id.container, rateContributor);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();*/
                }
            });

            if (userId.equalsIgnoreCase(((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID))) {
                btn_rate.setVisibility(View.GONE);
            } else {
                btn_rate.setVisibility(View.VISIBLE);
            }


            if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                ((HomeActivity) getActivity()).showProgressDialog();
                Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.ALL_RATINGS_OF_CONTRACTOR_TAG, Constants.ALL_RATINGS_OF_CONTRACTOR_URL + "?user_id=" + userId+ "&user_type=" + userType, Constants.HTTP_GET,"Home Activity");
                a.execute();
            } else {
                ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
            }


            adapter = new ExcellenceAwardAdapter();
            list_awards.setAdapter(adapter);
        } catch (Exception e) {
            e.printStackTrace();
        }

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
                if (tag.equalsIgnoreCase(Constants.ALL_RATINGS_OF_CONTRACTOR_TAG)) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        list.clear();
                        if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                            if (jsonObject.optJSONArray("Ratings").length() != 0) {
                                for (int i = 0; i < jsonObject.optJSONArray("Ratings").length(); i++) {
                                    try {
                                        ExcellenceAwardObject excellenceAwardObject = new ExcellenceAwardObject();
                                        excellenceAwardObject.setDate(jsonObject.optJSONArray("Ratings").getJSONObject(i).getString("date"));
                                        excellenceAwardObject.setDescription(jsonObject.optJSONArray("Ratings").getJSONObject(i).getString("description"));
                                        excellenceAwardObject.setGivenby_id(jsonObject.optJSONArray("Ratings").getJSONObject(i).getString("givenby_id"));
                                        excellenceAwardObject.setGivenby_image(jsonObject.optJSONArray("Ratings").getJSONObject(i).getString("givenby_image"));
                                        excellenceAwardObject.setGivenby_name(jsonObject.optJSONArray("Ratings").getJSONObject(i).getString("givenby_name"));
                                        excellenceAwardObject.setRating(jsonObject.optJSONArray("Ratings").getJSONObject(i).getString("rating"));


                                        list.add(excellenceAwardObject);
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                            } else {
                                Toast.makeText(getActivity(), "No-One rated on your profile", Toast.LENGTH_LONG).show();
                            }

                        } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {
                            Toast.makeText(getActivity(), "No-One rated on your profile", Toast.LENGTH_LONG).show();
                        }

                        adapter = new ExcellenceAwardAdapter();
                        list_awards.setAdapter(adapter);

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    class ExcellenceAwardAdapter extends BaseAdapter {

        private LayoutInflater l_Inflater;
        private View convertView1;

        public ExcellenceAwardAdapter() {
            super();
            l_Inflater = LayoutInflater.from(getActivity());
        }

        @Override
        public int getCount() {
            return list.size();
        }

        @Override
        public Object getItem(int position) {
            return list.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            ViewHolder holder;
            convertView1 = convertView;
            try {
                if (convertView == null) {
                    convertView = l_Inflater.inflate(R.layout.excellence_award_row_item, null);
                    holder = new ViewHolder();

                    holder.image_user = (CircleImageView) convertView.findViewById(R.id.image_user);
                    holder.profileRating = (RatingBar) convertView.findViewById(R.id.profileRating);
                    holder.profileRating.setClickable(false);
                    holder.profileRating.setFocusable(false);
                    holder.profileRating.setIsIndicator(true);
                    holder.profileRating.setFocusableInTouchMode(false);
                    holder.tv_Description = (TextView) convertView.findViewById(R.id.tv_Description);
                    holder.tv_username = (TextView) convertView.findViewById(R.id.tv_username);
                    convertView.setTag(holder);
                } else {
                    holder = (ViewHolder) convertView.getTag();
                }

                holder.tv_Description.setText(list.get(position).getDescription());
                holder.tv_username.setText(list.get(position).getGivenby_name());
                holder.profileRating.setRating(Integer.parseInt(list.get(position).getRating()));
                ImageLoader.getInstance().displayImage(Constants.APP_IMAGE_URL + list.get(position).getGivenby_image(), holder.image_user, ((HomeActivity) getActivity()).options);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return convertView;
        }

        class ViewHolder {
            CircleImageView image_user;
            TextView tv_username, tv_Description;
            RatingBar profileRating;
        }
    }
}