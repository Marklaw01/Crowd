package com.staging.fragments;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.staging.R;
import com.staging.activities.HomeActivity;

/**
 * Created by Sunakshi.Gautam on 11/8/2017.
 */

public class NetworkingOptionFragment extends Fragment implements View.OnClickListener {


    public NetworkingOptionFragment() {
    }


    private ImageView networkingOptionMap;
    private ImageView networkingOptionGroups;
    private ImageView networkingOptionContacts;
    private ImageView networkingOptionSocialMedia;
    private ImageView networkingOptionNotes;
    private ImageView networkingOptionBusinessCard;


    @Override
    public void onResume() {
        super.onResume();

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.networkingoption_fragment, container, false);

        networkingOptionMap = (ImageView) rootView.findViewById(R.id.imageViewMap);
        networkingOptionGroups = (ImageView) rootView.findViewById(R.id.imageViewGroups);
        networkingOptionContacts = (ImageView) rootView.findViewById(R.id.imageViewContact);
        networkingOptionSocialMedia = (ImageView) rootView.findViewById(R.id.imageViewSocialMedia);
        networkingOptionNotes = (ImageView) rootView.findViewById(R.id.imageViewNotes);
        networkingOptionBusinessCard = (ImageView) rootView.findViewById(R.id.imageViewBusinessCard);


        networkingOptionMap.setOnClickListener(this);
        networkingOptionGroups.setOnClickListener(this);
        networkingOptionContacts.setOnClickListener(this);
        networkingOptionSocialMedia.setOnClickListener(this);
        networkingOptionNotes.setOnClickListener(this);
        networkingOptionBusinessCard.setOnClickListener(this);

        return rootView;
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.imageViewMap:
                networkingOptionMap.setImageResource(R.drawable.network_map_gr);
                networkingOptionGroups.setImageResource(R.drawable.network_groups);
                networkingOptionContacts.setImageResource(R.drawable.network_contact);
                networkingOptionSocialMedia.setImageResource(R.drawable.network_socialmedia);
                networkingOptionNotes.setImageResource(R.drawable.network_notes);
                networkingOptionBusinessCard.setImageResource(R.drawable.network_businesscard);

                try {
                    Fragment networkingMapsFragment = new NetworkingMapsFragment();
                    ((HomeActivity) getActivity()).replaceFragment(networkingMapsFragment);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;

            case R.id.imageViewGroups:
                networkingOptionMap.setImageResource(R.drawable.network_map);
                networkingOptionGroups.setImageResource(R.drawable.network_groups_gr);
                networkingOptionContacts.setImageResource(R.drawable.network_contact);
                networkingOptionSocialMedia.setImageResource(R.drawable.network_socialmedia);
                networkingOptionNotes.setImageResource(R.drawable.network_notes);
                networkingOptionBusinessCard.setImageResource(R.drawable.network_businesscard);
                try {
                    Fragment networkingGroupsFragment = new NetworkingGroupsFragment();
                    ((HomeActivity) getActivity()).replaceFragment(networkingGroupsFragment);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                break;

            case R.id.imageViewContact:
                networkingOptionMap.setImageResource(R.drawable.network_map);
                networkingOptionGroups.setImageResource(R.drawable.network_groups);
                networkingOptionContacts.setImageResource(R.drawable.network_contact_gr);
                networkingOptionSocialMedia.setImageResource(R.drawable.network_socialmedia);
                networkingOptionNotes.setImageResource(R.drawable.network_notes);
                networkingOptionBusinessCard.setImageResource(R.drawable.network_businesscard);

                try {
                    Fragment networkingContactsFragment = new NetworkingContactsFragment();
                    ((HomeActivity) getActivity()).replaceFragment(networkingContactsFragment);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                break;

            case R.id.imageViewSocialMedia:
                networkingOptionMap.setImageResource(R.drawable.network_map);
                networkingOptionGroups.setImageResource(R.drawable.network_groups);
                networkingOptionContacts.setImageResource(R.drawable.network_contact);
                networkingOptionSocialMedia.setImageResource(R.drawable.network_socialmedia_gr);
                networkingOptionNotes.setImageResource(R.drawable.network_notes);
                networkingOptionBusinessCard.setImageResource(R.drawable.network_businesscard);

                try {
                    Fragment networkingSocialMediaFragment = new NetworkingSocialMediaFragment();
                    ((HomeActivity) getActivity()).replaceFragment(networkingSocialMediaFragment);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;

            case R.id.imageViewNotes:
                networkingOptionMap.setImageResource(R.drawable.network_map);
                networkingOptionGroups.setImageResource(R.drawable.network_groups);
                networkingOptionContacts.setImageResource(R.drawable.network_contact);
                networkingOptionSocialMedia.setImageResource(R.drawable.network_socialmedia);
                networkingOptionNotes.setImageResource(R.drawable.network_notes_gr);
                networkingOptionBusinessCard.setImageResource(R.drawable.network_businesscard);

                try {
                    Fragment networkingNotesFragment = new NetworkingNotesFragment();

                    Bundle args = new Bundle();
                    args.putString("connected_toId", "");
                    networkingNotesFragment.setArguments(args);

                    ((HomeActivity) getActivity()).replaceFragment(networkingNotesFragment);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;

            case R.id.imageViewBusinessCard:
                networkingOptionMap.setImageResource(R.drawable.network_map);
                networkingOptionGroups.setImageResource(R.drawable.network_groups);
                networkingOptionContacts.setImageResource(R.drawable.network_contact);
                networkingOptionSocialMedia.setImageResource(R.drawable.network_socialmedia);
                networkingOptionNotes.setImageResource(R.drawable.network_notes);
                networkingOptionBusinessCard.setImageResource(R.drawable.network_businesscard_gr);
                try {
                    Fragment networkingBusinessCardFragment = new NetworkingBusinessCardFragment();
                    ((HomeActivity) getActivity()).replaceFragment(networkingBusinessCardFragment);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                break;
        }
    }
}
