package com.crowdbootstrapapp.chat.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;

import com.crowdbootstrapapp.utilities.PrefManager;
import com.quickblox.users.model.QBUser;

import java.util.ArrayList;
import java.util.List;

public class CheckboxUsersAdapter extends UsersAdapter {

    private List<Integer> initiallySelectedUsers;
    private List<QBUser> selectedUsers;

    public CheckboxUsersAdapter(Context context, List<QBUser> users) {
        super(context, users);
        this.selectedUsers = new ArrayList<>();
        this.selectedUsers.add(PrefManager.getInstance(context).getQbUser());

        this.initiallySelectedUsers = new ArrayList<>();
    }

    public void addSelectedUsers(List<Integer> userIds) {
        try {
            for (QBUser user : objectsList) {
                for (Integer id : userIds) {
                    if (user.getId().equals(id)) {
                        selectedUsers.add(user);
                        initiallySelectedUsers.add(user.getId());
                        break;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View view = super.getView(position, convertView, parent);

        try {
            final QBUser user = getItem(position);
            final ViewHolder holder = (ViewHolder) view.getTag();

            view.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (!isAvailableForSelection(user)) {
                        return;
                    }

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

    public List<QBUser> getSelectedUsers() {
        return selectedUsers;
    }

    @Override
    protected boolean isAvailableForSelection(QBUser user) {
        return super.isAvailableForSelection(user) && !initiallySelectedUsers.contains(user.getId());
    }
}
