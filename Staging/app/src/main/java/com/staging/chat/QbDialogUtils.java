package com.staging.chat;

import android.text.TextUtils;
import android.util.Log;

import com.staging.models.ContactsObject;
import com.quickblox.chat.QBChatService;
import com.quickblox.chat.model.QBDialog;
import com.quickblox.chat.model.QBDialogType;
import com.quickblox.users.model.QBUser;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class QbDialogUtils {
    private static final String TAG = QbDialogUtils.class.getSimpleName();

    public static QBDialog createDialog(List<QBUser> users) {


        QBDialog dialogToCreate = new QBDialog();
        try {
            QBUser currentUser = QBChatService.getInstance().getUser();
            users.remove(currentUser);
            dialogToCreate.setName(QbDialogUtils.createChatNameFromUserList(users));
            if (users.size() == 1) {
                dialogToCreate.setType(QBDialogType.PRIVATE);
            } else {
                dialogToCreate.setType(QBDialogType.GROUP);
            }
            dialogToCreate.setOccupantsIds(new ArrayList<>(Arrays.asList(QbDialogUtils.getUserIds(users))));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dialogToCreate;
    }

    public static QBDialog createDialog(ArrayList<ContactsObject> users, String dialogName) {

        QBDialog dialogToCreate = new QBDialog();
        try {
            dialogToCreate.setName(dialogName);
            if (users.size() == 1) {
                dialogToCreate.setType(QBDialogType.PRIVATE);
            } else {
                dialogToCreate.setType(QBDialogType.GROUP);
            }
            dialogToCreate.setOccupantsIds(new ArrayList<>(Arrays.asList(QbDialogUtils.getUserIds(users))));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dialogToCreate;
    }


    public static List<QBUser> getAddedUsers(QBDialog dialog, List<QBUser> currentUsers) {
        return getAddedUsers(getQbUsersFromQbDialog(dialog), currentUsers);
    }

    public static List<QBUser> getAddedUsers(List<QBUser> previousUsers, List<QBUser> currentUsers) {
        List<QBUser> addedUsers = new ArrayList<>();
        try {
            for (QBUser currentUser : currentUsers) {
                boolean wasInChatBefore = false;
                for (QBUser previousUser : previousUsers) {
                    if (currentUser.getId().equals(previousUser.getId())) {
                        wasInChatBefore = true;
                        break;
                    }
                }
                if (!wasInChatBefore) {
                    addedUsers.add(currentUser);
                }
            }

            QBUser currentUser = QBChatService.getInstance().getUser();
            addedUsers.remove(currentUser);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return addedUsers;
    }

    public static List<QBUser> getRemovedUsers(QBDialog dialog, List<QBUser> currentUsers) {
        return getRemovedUsers(getQbUsersFromQbDialog(dialog), currentUsers);
    }

    public static List<QBUser> getRemovedUsers(List<QBUser> previousUsers, List<QBUser> currentUsers) {
        List<QBUser> removedUsers = new ArrayList<>();
        try {
            for (QBUser previousUser : previousUsers) {
                boolean isUserStillPresented = false;
                for (QBUser currentUser : currentUsers) {
                    if (previousUser.getId().equals(currentUser.getId())) {
                        isUserStillPresented = true;
                        break;
                    }
                }
                if (!isUserStillPresented) {
                    removedUsers.add(previousUser);
                }
            }

            QBUser currentUser = QBChatService.getInstance().getUser();
            removedUsers.remove(currentUser);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return removedUsers;
    }

    public static void logDialogUsers(QBDialog qbDialog) {
        Log.v(TAG, "Dialog " + getDialogName(qbDialog));
        logUsersByIds(qbDialog.getOccupants());
    }

    public static void logUsers(List<QBUser> users) {
        for (QBUser user : users) {
            Log.i(TAG, user.getId() + " " + user.getFullName());
        }
    }

    private static void logUsersByIds(List<Integer> users) {
        for (Integer id : users) {
            QBUser user = QbUsersHolder.getInstance().getUserById(id);
            Log.i(TAG, user.getId() + " " + user.getFullName());
        }
    }

    public static Integer getOpponentIdForPrivateDialog(QBDialog dialog) {
        Integer opponentId = -1;
        try {
            QBUser qbUser = QBChatService.getInstance().getUser();
            if (qbUser == null) {
                return opponentId;
            }

            Integer currentUserId = qbUser.getId();

            for (Integer userId : dialog.getOccupants()) {
                if (!userId.equals(currentUserId)) {
                    opponentId = userId;
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return opponentId;
    }

    public static Integer[] getUserIds(List<QBUser> users) {
        ArrayList<Integer> ids = new ArrayList<>();
        for (QBUser user : users) {
            ids.add(user.getId());
        }
        return ids.toArray(new Integer[ids.size()]);
    }

    public static Integer[] getUserIds(ArrayList<ContactsObject> users) {
        ArrayList<Integer> ids = new ArrayList<>();
        for (ContactsObject user : users) {
            ids.add(user.getQuickbloxid());
        }
        return ids.toArray(new Integer[ids.size()]);
    }

    public static String createChatNameFromUserList(List<QBUser> users) {
        String chatName = "";
        QBUser currentUser = QBChatService.getInstance().getUser();
        for (QBUser user : users) {
            if (user.getId().equals(currentUser.getId())) {
                continue;
            }

            String prefix = chatName.equals("") ? "" : ", ";
            chatName = chatName + prefix + user.getFullName();
        }
        return chatName;
    }

    public static String createChatNameFromUserList(ArrayList<ContactsObject> users) {
        String chatName = "";
       // QBUser currentUser = QBChatService.getInstance().getUser();
        for (ContactsObject user : users) {

            String prefix = chatName.equals("") ? "" : ", ";
            chatName = chatName + prefix + user.getName();
        }
        return chatName;
    }


    public static String getDialogName(QBDialog dialog) {
        if (dialog.getType().equals(QBDialogType.GROUP)) {
            return dialog.getName();
        } else {
            // It's a private dialog, let's use opponent's name as chat name
            Integer opponentId = getOpponentIdForPrivateDialog(dialog);
            QBUser user = QbUsersHolder.getInstance().getUserById(opponentId);
            if (user != null) {
                return TextUtils.isEmpty(user.getFullName()) ? user.getLogin() : user.getFullName();
            } else {
                return dialog.getName();
            }
        }
    }

    private static List<QBUser> getQbUsersFromQbDialog(QBDialog dialog) {
        List<QBUser> previousDialogUsers = new ArrayList<>();
        for (Integer id : dialog.getOccupants()) {
            QBUser user = QbUsersHolder.getInstance().getUserById(id);
            if (user == null) {
                throw new RuntimeException("User from dialog is not in memory. This should never happen, or we are screwed");
            }
            previousDialogUsers.add(user);
        }
        return previousDialogUsers;
    }
}
