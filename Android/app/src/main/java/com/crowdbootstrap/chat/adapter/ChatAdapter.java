package com.crowdbootstrap.chat.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.Resources;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.crowdbootstrap.R;
import com.crowdbootstrap.chat.QbUsersHolder;
import com.crowdbootstrap.chat.interfaces.PaginationHistoryListener;
import com.crowdbootstrap.utilities.TimeUtils;
import com.quickblox.chat.QBChatService;
import com.quickblox.chat.model.QBAttachment;
import com.quickblox.chat.model.QBChatMessage;
import com.quickblox.chat.model.QBDialog;
import com.quickblox.chat.model.QBDialogType;
import com.quickblox.users.model.QBUser;

import java.util.Collection;
import java.util.List;

import se.emilsjolander.stickylistheaders.StickyListHeadersAdapter;

public class ChatAdapter extends BaseListAdapter<QBChatMessage> implements StickyListHeadersAdapter {

    private int DIALOG_TYPE;
    private OnItemInfoExpandedListener onItemInfoExpandedListener;
    private PaginationHistoryListener paginationListener;
    private int previousGetCount = 0;

    public ChatAdapter(Context context, List<QBChatMessage> chatMessages, QBDialog dialog) {
        super(context, chatMessages);
        if (dialog.getType().equals(QBDialogType.GROUP)) {
            DIALOG_TYPE = 2;
        } else {
            DIALOG_TYPE = 3;
        }
    }

    public void setOnItemInfoExpandedListener(OnItemInfoExpandedListener onItemInfoExpandedListener) {
        this.onItemInfoExpandedListener = onItemInfoExpandedListener;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.list_item_chat_message, parent, false);

            holder.messageBodyTextView = (TextView) convertView.findViewById(R.id.text_image_message);
            holder.messageAuthorTextView = (TextView) convertView.findViewById(R.id.text_message_author);
            holder.messageContainerLayout = (LinearLayout) convertView.findViewById(R.id.layout_chat_message_container);
            holder.messageBodyContainerLayout = (LinearLayout) convertView.findViewById(R.id.layout_message_content_container);
            holder.messageInfoTextView = (TextView) convertView.findViewById(R.id.text_message_info);
            // holder.attachmentImageView = (MaskedImageView) convertView.findViewById(R.id.image_message_attachment);
            holder.attachmentProgressBar = (ProgressBar) convertView.findViewById(R.id.progress_message_attachment);

            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        try {
            final QBChatMessage chatMessage = getItem(position);
            setIncomingOrOutgoingMessageAttributes(holder, chatMessage);
            setMessageBody(holder, chatMessage);
            setMessageInfo(chatMessage, holder);
            if (DIALOG_TYPE == 3) {
                holder.messageAuthorTextView.setVisibility(View.GONE);
            } else {
                setMessageAuthor(holder, chatMessage);
                //holder.messageAuthorTextView.setVisibility(View.GONE);
            }


        /*holder.messageContainerLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (hasAttachments(chatMessage)) {
                    Collection<QBAttachment> attachments = chatMessage.getAttachments();
                    QBAttachment attachment = attachments.iterator().next();
                    AttachmentImageActivity.start(context, attachment.getUrl());
                } else {
                    toggleItemInfo(holder, position);
                }
            }
        });*/
            holder.messageContainerLayout.setOnLongClickListener(new View.OnLongClickListener() {
                @Override
                public boolean onLongClick(View v) {
                    if (hasAttachments(chatMessage)) {
                        toggleItemInfo(holder, position);
                        return true;
                    }

                    return false;
                }
            });
            holder.messageInfoTextView.setVisibility(View.VISIBLE);

            downloadMore(position);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return convertView;
    }

    private void downloadMore(int position) {
        try {
            if (position == 0) {
                if (getCount() != previousGetCount) {
                    paginationListener.downloadMore();
                    previousGetCount = getCount();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void setPaginationHistoryListener(PaginationHistoryListener paginationListener) {
        this.paginationListener = paginationListener;
    }

    private void toggleItemInfo(ViewHolder holder, int position) {
        try {
            boolean isMessageInfoVisible = holder.messageInfoTextView.getVisibility() == View.VISIBLE;
            holder.messageInfoTextView.setVisibility(isMessageInfoVisible ? View.GONE : View.VISIBLE);

            if (onItemInfoExpandedListener != null) {
                onItemInfoExpandedListener.onItemInfoExpanded(position);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public View getHeaderView(int position, View convertView, ViewGroup parent) {
        HeaderViewHolder holder;
        if (convertView == null) {
            holder = new HeaderViewHolder();
            convertView = inflater.inflate(R.layout.view_chat_message_header, parent, false);
            holder.dateTextView = (TextView) convertView.findViewById(R.id.header_date_textview);
            convertView.setTag(holder);
        } else {
            holder = (HeaderViewHolder) convertView.getTag();
        }

        try {
            QBChatMessage chatMessage = getItem(position);
            holder.dateTextView.setText(TimeUtils.getDate(chatMessage.getDateSent() * 1000));

            LinearLayout.LayoutParams lp = (LinearLayout.LayoutParams) holder.dateTextView.getLayoutParams();
        /*if (position == 0) {
            lp.topMargin = ResourceUtils.getDimen(R.dimen.chat_date_header_top_margin);
        } else {*/
            lp.topMargin = 0;
            //}
            holder.dateTextView.setLayoutParams(lp);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return convertView;
    }

    @Override
    public long getHeaderId(int position) {
        QBChatMessage chatMessage = getItem(position);
        return TimeUtils.getDateAsHeaderId(chatMessage.getDateSent() * 1000);
    }

    private void setMessageBody(final ViewHolder holder, QBChatMessage chatMessage) {
        try {
            if (hasAttachments(chatMessage)) {
                Collection<QBAttachment> attachments = chatMessage.getAttachments();
                QBAttachment attachment = attachments.iterator().next();

                holder.messageBodyTextView.setVisibility(View.GONE);
                // holder.attachmentImageView.setVisibility(View.VISIBLE);
                holder.attachmentProgressBar.setVisibility(View.VISIBLE);
                /*Glide.with(context)
                        .load(attachment.getUrl())
                        .listener(new RequestListener<String, GlideDrawable>() {
                            @Override
                            public boolean onException(Exception e, String model,
                                                       Target<GlideDrawable> target, boolean isFirstResource) {
                                e.printStackTrace();
                                holder.attachmentImageView.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
                                holder.attachmentProgressBar.setVisibility(View.GONE);
                                return false;
                            }

                            @Override
                            public boolean onResourceReady(GlideDrawable resource, String model,
                                                           Target<GlideDrawable> target,
                                                           boolean isFromMemoryCache, boolean isFirstResource) {
                                holder.attachmentImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
                                holder.attachmentProgressBar.setVisibility(View.GONE);
                                return false;
                            }
                        })
                        .override(Consts.PREFERRED_IMAGE_SIZE_PREVIEW, Consts.PREFERRED_IMAGE_SIZE_PREVIEW)
                        .dontTransform()
                        .error(R.drawable.ic_error)
                        .into(holder.attachmentImageView);*/
            } else {

                holder.messageBodyTextView.setText(chatMessage.getBody());
                holder.messageBodyTextView.setVisibility(View.VISIBLE);
                //holder.attachmentImageView.setVisibility(View.GONE);
                holder.attachmentProgressBar.setVisibility(View.GONE);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    QBUser sender;

    private void setMessageAuthor(ViewHolder holder, QBChatMessage chatMessage) {

        try {
            if (isIncoming(chatMessage)) {
                /*QBUsers.getUser(chatMessage.getSenderId(), new QBEntityCallback<QBUser>() {
                    @Override
                    public void onSuccess(QBUser user, Bundle args) {
                        sender = user;
                    }

                    @Override
                    public void onError(QBResponseException errors) {

                    }
                });
    */

                sender = QbUsersHolder.getInstance().getUserById(chatMessage.getSenderId());
                if (sender != null) {
                    holder.messageAuthorTextView.setText(sender.getFullName());
                    holder.messageAuthorTextView.setVisibility(View.VISIBLE);
                    notifyDataSetChanged();
                } else {
                    holder.messageAuthorTextView.setText("No Name");
                    holder.messageAuthorTextView.setVisibility(View.VISIBLE);
                    notifyDataSetChanged();
                }


                /*if (hasAttachments(chatMessage)) {
                    holder.messageAuthorTextView.setBackgroundResource(R.drawable.shape_rectangle_semi_transparent);
                    holder.messageAuthorTextView.setTextColor(ResourceUtils.getColor(R.color.text_color_white));
                } else {
                    holder.messageAuthorTextView.setBackgroundResource(0);
                    holder.messageAuthorTextView.setTextColor(ResourceUtils.getColor(R.color.text_color_dark_grey));
                }*/
            } else {
                holder.messageAuthorTextView.setVisibility(View.GONE);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void setMessageInfo(QBChatMessage chatMessage, ViewHolder holder) {
        try {
            holder.messageInfoTextView.setText(TimeUtils.getTime(chatMessage.getDateSent() * 1000));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @SuppressLint("RtlHardcoded")
    private void setIncomingOrOutgoingMessageAttributes(ViewHolder holder, QBChatMessage chatMessage) {
        try {
            boolean isIncoming = isIncoming(chatMessage);
            int gravity = isIncoming ? Gravity.LEFT : Gravity.RIGHT;
            holder.messageContainerLayout.setGravity(gravity);
            holder.messageInfoTextView.setGravity(gravity);

            int messageBodyContainerBgResource = isIncoming
                    ? R.drawable.out_message_bg
                    : R.drawable.in_message_bg;
            if (hasAttachments(chatMessage)) {
                holder.messageBodyContainerLayout.setBackgroundResource(0);
                holder.messageBodyContainerLayout.setPadding(0, 0, 0, 0);

                //holder.attachmentImageView.setMaskResourceId(messageBodyContainerBgResource);
            } else {
                holder.messageBodyContainerLayout.setBackgroundResource(messageBodyContainerBgResource);
            }

            LinearLayout.LayoutParams lp = (LinearLayout.LayoutParams) holder.messageAuthorTextView.getLayoutParams();
            if (isIncoming && hasAttachments(chatMessage)) {
                lp.leftMargin = 12;
                lp.topMargin = 12;
            } else if (isIncoming) {
                lp.leftMargin = 4;
                lp.topMargin = 0;
            }
            holder.messageAuthorTextView.setLayoutParams(lp);

            int textColorResource = isIncoming ? R.color.textColor : R.color.textColor;
            holder.messageBodyTextView.setTextColor(context.getResources().getColor(R.color.textColor));
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        }
    }

    private boolean hasAttachments(QBChatMessage chatMessage) {
        Collection<QBAttachment> attachments = chatMessage.getAttachments();
        return attachments != null && !attachments.isEmpty();
    }

    private boolean isIncoming(QBChatMessage chatMessage) {
        QBUser currentUser = QBChatService.getInstance().getUser();
        return chatMessage.getSenderId() != null && !chatMessage.getSenderId().equals(currentUser.getId());
    }

    private static class HeaderViewHolder {
        public TextView dateTextView;
    }

    private static class ViewHolder {
        public TextView messageBodyTextView;
        public TextView messageAuthorTextView;
        public TextView messageInfoTextView;
        public LinearLayout messageContainerLayout;
        public LinearLayout messageBodyContainerLayout;
        //public MaskedImageView attachmentImageView;
        public ProgressBar attachmentProgressBar;
    }

    public interface OnItemInfoExpandedListener {
        void onItemInfoExpanded(int position);
    }
}