package com.crowdbootstrap.chat.adapter;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Typeface;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.crowdbootstrap.R;
import com.crowdbootstrap.chat.QbDialogUtils;
import com.crowdbootstrap.helper.CircleImageView;
import com.crowdbootstrap.utilities.TimeUtils;
import com.quickblox.chat.model.QBDialog;
import com.quickblox.chat.model.QBDialogType;

import java.util.ArrayList;

public class DialogsAdapter extends BaseAdapter {

    protected LayoutInflater inflater;
    protected Context context;
    ArrayList<QBDialog> dialogs;

    public DialogsAdapter(Context context, ArrayList<QBDialog> dialogs){
        inflater = LayoutInflater.from(context);
        this.context = context;
        this.dialogs = dialogs;
    }
    /*public DialogsAdapter(Context context, List<QBDialog> dialogs) {
        super(context, dialogs);
    }*/

    @Override
    public int getCount() {
        return dialogs.size();
    }

    @Override
    public Object getItem(int position) {
        return dialogs.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.list_item_dialog, parent, false);

            holder = new ViewHolder();
            holder.rootLayout = (ViewGroup) convertView.findViewById(R.id.root);
            holder.nameTextView = (TextView) convertView.findViewById(R.id.text_dialog_name);
            holder.user = (TextView) convertView.findViewById(R.id.user);
            holder.text_last_message_time = (TextView) convertView.findViewById(R.id.text_last_message_time);
            holder.lastMessageTextView = (TextView) convertView.findViewById(R.id.text_dialog_last_message);
            holder.dialogImageView = (CircleImageView) convertView.findViewById(R.id.image_dialog_icon);
            holder.unreadCounterTextView = (TextView) convertView.findViewById(R.id.text_dialog_unread_count);

            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        try {
            QBDialog dialog = dialogs.get(position);
            if (dialog.getType().equals(QBDialogType.GROUP)) {
                //holder.dialogImageView.setBackgroundDrawable(UiUtils.getGreyCircleDrawable());
                holder.user.setVisibility(View.GONE);
                holder.dialogImageView.setBackgroundDrawable(context.getResources().getDrawable(R.drawable.group_chat_icon));
            } else {
                //holder.dialogImageView.setBackgroundDrawable(UiUtils.getColorCircleDrawable(position));
                holder.user.setVisibility(View.VISIBLE);
                holder.user.setText(QbDialogUtils.getDialogName(dialog).trim().substring(0,1));
                holder.dialogImageView.setBackgroundDrawable(context.getResources().getDrawable(R.drawable.circle));
            }

            holder.text_last_message_time.setText(TimeUtils.getDateOrTime(dialog.getLastMessageDateSent()));
            holder.nameTextView.setText(QbDialogUtils.getDialogName(dialog));
            if (isLastMessageAttachment(dialog)) {
                holder.lastMessageTextView.setText("Attachment");
            } else {
                holder.lastMessageTextView.setText(dialog.getLastMessage());
            }

            int unreadMessagesCount = dialog.getUnreadMessageCount();
            if (unreadMessagesCount == 0) {
                holder.unreadCounterTextView.setVisibility(View.GONE);
                holder.nameTextView.setTypeface(null, Typeface.NORMAL);

            } else {
                holder.unreadCounterTextView.setVisibility(View.VISIBLE);
                holder.unreadCounterTextView.setText(String.valueOf(unreadMessagesCount > 99 ? 99 : unreadMessagesCount));
                holder.nameTextView.setTypeface(null, Typeface.BOLD);
            }
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        }


        return convertView;
    }

    private boolean isLastMessageAttachment(QBDialog dialog) {
        String lastMessage = dialog.getLastMessage();
        Integer lastMessageSenderId = dialog.getLastMessageUserId();
        return TextUtils.isEmpty(lastMessage) && lastMessageSenderId != null;
    }

    private static class ViewHolder {
        ViewGroup rootLayout;
        CircleImageView dialogImageView;
        TextView nameTextView, text_last_message_time, user;
        TextView lastMessageTextView;
        TextView unreadCounterTextView;
    }
}
