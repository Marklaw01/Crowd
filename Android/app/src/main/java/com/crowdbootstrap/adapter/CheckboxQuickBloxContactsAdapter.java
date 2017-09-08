package com.crowdbootstrap.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;

import com.crowdbootstrap.models.ContactsObject;

import java.util.ArrayList;
import java.util.List;

public class CheckboxQuickBloxContactsAdapter extends ContactsAdapter {

    private List<Integer> initiallySelectedUsers;
    private ArrayList<ContactsObject> selectedUsers;

    public CheckboxQuickBloxContactsAdapter(Context context, ArrayList<ContactsObject> users) {
        super(context, users);
        this.selectedUsers = new ArrayList<ContactsObject>();
        //this.selectedUsers.add(PrefManager.getInstance(context).getQbUser());

        this.initiallySelectedUsers = new ArrayList<>();
    }

    /*public void addSelectedUsers(List<Integer> userIds) {
        for (QBUser user : objectsList) {
            for (Integer id : userIds) {
                if (user.getId().equals(id)) {
                    selectedUsers.add(user);
                    initiallySelectedUsers.add(user.getId());
                    break;
                }
            }
        }
    }*/

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View view = super.getView(position, convertView, parent);

        try {
            final ContactsObject user = getItem(position);
            final ViewHolder holder = (ViewHolder) view.getTag();

            view.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {


                    holder.userCheckBox.setChecked(!holder.userCheckBox.isChecked());

                    if (holder.userCheckBox.isChecked()) {
                        selectedUsers.add(user);
                    } else {
                        selectedUsers.remove(user);
                    }
                }
            });

            holder.userCheckBox.setVisibility(View.VISIBLE);
            holder.userCheckBox.setChecked(selectedUsers.contains(user));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return view;
    }

    public ArrayList<ContactsObject> getSelectedUsers() {
        return selectedUsers;
    }

    /*@Override
    protected boolean isAvailableForSelection(QBUser user) {
        return super.isAvailableForSelection(user) && !initiallySelectedUsers.contains(user.getId());
    }*/
}
