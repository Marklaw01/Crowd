package com.crowdbootstrap.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.crowdbootstrap.R;
import com.crowdbootstrap.activities.HomeActivity;
import com.crowdbootstrap.fragments.groupbuyingModule.GroupBuyingFragment;
import com.crowdbootstrap.fragments.launchdealsmodule.LaunchDealsFragment;
import com.crowdbootstrap.models.GenericObject;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/12/2016.
 */
public class ChoosePaymentGatewayFragment extends Fragment implements View.OnClickListener {

    String[] titles = new String[]{"Group Buying", "Launch Deals", "Product/Service Exchange", "Recommended Suppliers", "CBS App Store", "Recommended Apps"};
    ArrayList<GenericObject> companiesList;
    private ListView listView;
    private Button btn_conform;
    private CompaniesAdapter adapter;

    public ChoosePaymentGatewayFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setActionBarTitle("Shopping Cart");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_payment_gateway, container, false);

        companiesList = new ArrayList<GenericObject>();

        btn_conform = (Button) rootView.findViewById(R.id.btn_conform);

        btn_conform.setOnClickListener(this);
        listView = (ListView) rootView.findViewById(R.id.list_compaigns);
        for (int i = 0; i < 6; i++) {
            GenericObject obj = new GenericObject();
            obj.setId("" + (i + 1));
            obj.setTitle(titles[i]);
            obj.setIschecked(false);
            companiesList.add(obj);
        }


        adapter = new CompaniesAdapter();
        listView.setAdapter(adapter);
        //listView.setChoiceMode(ListView.CHOICE_MODE_SINGLE);


        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (position == 0) {
                    Fragment GroupBuying = new GroupBuyingFragment();
                    FragmentTransaction transactionRate = getFragmentManager().beginTransaction();

                    transactionRate.replace(R.id.container, GroupBuying);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();
                } else if (position == 1) {
                    Fragment LaunchDeals = new LaunchDealsFragment();
                    FragmentTransaction transactionRate = getFragmentManager().beginTransaction();

                    transactionRate.replace(R.id.container, LaunchDeals);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();
                }
                else if (position == 2) {
                    Fragment ExchangeProduct = new ExchangeProductServicesFragment();
                    FragmentTransaction transactionRate = getFragmentManager().beginTransaction();

                    transactionRate.replace(R.id.container, ExchangeProduct);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();

                }
                else if (position == 3) {
                    Fragment RecommendedSupplier = new RecommenedSupplierFragment();
                    FragmentTransaction transactionRate = getFragmentManager().beginTransaction();

                    transactionRate.replace(R.id.container, RecommendedSupplier);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();


                }
                else if (position == 4) {
                    Fragment CBSApps = new CBSAppFragment();
                    FragmentTransaction transactionRate = getFragmentManager().beginTransaction();

                    transactionRate.replace(R.id.container, CBSApps);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();


                }
                else if (position == 5) {
                    Fragment RecommendedApps = new RecommendedAppsFragment();
                    FragmentTransaction transactionRate = getFragmentManager().beginTransaction();

                    transactionRate.replace(R.id.container, RecommendedApps);
                    transactionRate.addToBackStack(null);

                    transactionRate.commit();
                }
            }
        });
        return rootView;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_conform:
                TermsAndConditionsFragment terms = new TermsAndConditionsFragment();
                //getFragmentManager().beginTransaction().replace(R.id.container, terms).addToBackStack(null).commit();
                ((HomeActivity) getActivity()).replaceFragment(terms);
                break;
        }
    }

    interface SelectedPosition {
        public void setSelectedIndex(int index);
    }

    class CompaniesAdapter extends BaseAdapter implements SelectedPosition {
        int selectedIndex = -1;
        private LayoutInflater l_Inflater;
        private View convertView1;

        public CompaniesAdapter() {
            super();
            l_Inflater = LayoutInflater.from(getActivity());
        }

        @Override
        public int getCount() {
            return companiesList.size();
        }

        @Override
        public Object getItem(int position) {
            return companiesList.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder;

            if (convertView == null) {
                convertView = l_Inflater.inflate(R.layout.payment_gateway_row_item, null);
                holder = new ViewHolder();
                holder.tv = (TextView) convertView.findViewById(R.id.text);

                //holder.tv.setCheckMarkDrawable(getResources().getDrawable(R.drawable.checkbox_textview));
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            try {
                holder.tv.setText(companiesList.get(position).getTitle());

            } catch (Exception e) {

                e.printStackTrace();
            }


            return convertView;
        }

        class ViewHolder {
            TextView tv;
        }

        @Override
        public void setSelectedIndex(int index) {
            selectedIndex = index;
            System.out.println(" item click " + index);
        }
    }
}