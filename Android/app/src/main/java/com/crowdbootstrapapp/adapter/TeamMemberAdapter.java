package com.crowdbootstrapapp.adapter;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.text.Html;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.crowdbootstrapapp.R;
import com.crowdbootstrapapp.activities.HomeActivity;
import com.crowdbootstrapapp.fragments.ChatFragment;
import com.crowdbootstrapapp.fragments.CurrentStartUpDetailFragment;
import com.crowdbootstrapapp.fragments.SendMessageFragment;
import com.crowdbootstrapapp.models.TeamMemberObject;
import com.crowdbootstrapapp.utilities.Constants;
import com.crowdbootstrapapp.utilities.PrefManager;
import com.quickblox.chat.QBChatService;
import com.quickblox.chat.QBPrivateChatManager;
import com.quickblox.chat.model.QBDialog;
import com.quickblox.core.QBEntityCallback;
import com.quickblox.core.exception.QBResponseException;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by sunakshi.gautam on 1/22/2016.
 */
public class TeamMemberAdapter extends BaseAdapter implements Filterable {

    private ValueFilter valueFilter;
    private LayoutInflater l_Inflater;
    private View convertView1;
    private Context context;
    private ArrayList<TeamMemberObject> list;
    ArrayList<TeamMemberObject> mStringFilterList = new ArrayList<TeamMemberObject>();
    private PrefManager prefManager;
    private QBPrivateChatManager privateChatManager;// = QBChatService.getInstance().getPrivateChatManager();


    ProgressDialog pd;
    public TeamMemberAdapter(Context context, ArrayList<TeamMemberObject> list) {
        l_Inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
        mStringFilterList = list;
        prefManager = PrefManager.getInstance(context);
        try {
            privateChatManager = QBChatService.getInstance().getPrivateChatManager();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public int getCount() {
        return list.size();
    }

    @Override
    public TeamMemberObject getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public int getViewTypeCount() {
        // menu type count
        return 2;
    }

    @Override
    public int getItemViewType(int position) {
        // current menu type
        return list.get(position).getMemberStatus();
    }


    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        convertView1 = convertView;

        if (convertView == null) {
            convertView = l_Inflater.inflate(R.layout.team_list_item, null);
            holder = new ViewHolder();

            holder.member_name = (TextView) convertView.findViewById(R.id.membername);
            holder.member_desig = (TextView) convertView.findViewById(R.id.memberdesignation);
            holder.message = (ImageView) convertView.findViewById(R.id.message);
            holder.chat = (ImageView) convertView.findViewById(R.id.chat);
            holder.mail = (ImageView) convertView.findViewById(R.id.mail);
            holder.member_description = (TextView) convertView.findViewById(R.id.memberdesctiption);

            if (prefManager.getString(Constants.USER_ID).equalsIgnoreCase(list.get(position).getMemberId())) {
                holder.message.setVisibility(View.GONE);
                holder.chat.setVisibility(View.GONE);
                holder.mail.setVisibility(View.GONE);
            }
            else if(CurrentStartUpDetailFragment.from.compareTo("complete") == 0){
                holder.message.setVisibility(View.GONE);
                holder.chat.setVisibility(View.GONE);
                holder.mail.setVisibility(View.GONE);
            }
            else {
                holder.message.setVisibility(View.VISIBLE);
                holder.chat.setVisibility(View.VISIBLE);
                holder.mail.setVisibility(View.VISIBLE);
            }
            convertView.setTag(holder);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        try {
            holder.member_name.setText(list.get(position).getMemberName());
            holder.member_desig.setText(list.get(position).getMemberDesignation());
            holder.member_description.setText(list.get(position).getMemberBio());

            holder.chat.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                }
            });

            holder.mail.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    try {
                        Intent intent = new Intent(Intent.ACTION_SEND);
                        intent.setType("text/html");
                        // intent.setType("text/plain");
                        final PackageManager pm = context.getPackageManager();
                        final List<ResolveInfo> matches = pm.queryIntentActivities(intent, 0);
                        ResolveInfo best = null;
                        for (final ResolveInfo info : matches) {
                            if (info.activityInfo.packageName.endsWith(".gm") || info.activityInfo.name.toLowerCase().contains("gmail")) {
                                best = info;
                                break;
                            }
                        }
                        if (best != null) {
                            intent.setClassName(best.activityInfo.packageName, best.activityInfo.name);
                        }
                        intent.putExtra(Intent.EXTRA_EMAIL, new String[]{list.get(position).getMemberEmail()});
                        intent.putExtra(Intent.EXTRA_SUBJECT, "Subject");
                        intent.putExtra(Intent.EXTRA_TEXT, Html.fromHtml("Message"));
                        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        context.startActivity(intent);

                    /*Fragment mailFragment = new SendEmailFragment();
                    Bundle bundle = new Bundle();
                    bundle.putString("receiverMailId", list.get(position).getMemberEmail());
                    bundle.putString("receiverId", list.get(position).getMemberId());
                    mailFragment.setArguments(bundle);
                    FragmentTransaction fragmentTransaction = ((HomeActivity) context).getSupportFragmentManager().beginTransaction();
                    fragmentTransaction.add(R.id.container, mailFragment).addToBackStack(null).commit();*/
                    } catch (Exception e) {
                        Toast.makeText(context, "Please install mail app on your device", Toast.LENGTH_LONG).show();
                        e.printStackTrace();
                    }
                }
            });

            holder.message.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Fragment messageFragment = new SendMessageFragment();
                    FragmentTransaction fragmentTransaction = ((HomeActivity) context).getSupportFragmentManager().beginTransaction();
                    Bundle bundle = new Bundle();
                    Log.e("to_team_memberid", list.get(position).getMemberId());

                    bundle.putString("to_team_memberid", list.get(position).getMemberId());
                    bundle.putString("to_team_memberName", list.get(position).getMemberName());
                    messageFragment.setArguments(bundle);
                    fragmentTransaction.add(R.id.container, messageFragment).addToBackStack(null).commit();
                }
            });



            holder.chat.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    Log.e("Quick", String.valueOf(list.get(position).getQuickbloxid()));
                    try {
                        ((HomeActivity)context).showProgressDialog();
                        privateChatManager.createDialog(list.get(position).getQuickbloxid(), new QBEntityCallback<QBDialog>() {
                            @Override
                            public void onSuccess(QBDialog dialog, Bundle args) {
                                ((HomeActivity)context).dismissProgressDialog();

                                Fragment addContributor = new ChatFragment();
                                Bundle bundle = new Bundle();
                                bundle.putSerializable("dialog", dialog);
                                addContributor.setArguments(bundle);

                                ((HomeActivity) context).replaceFragment(addContributor);


                               /* FragmentTransaction transactionAdd = ((HomeActivity) context).getSupportFragmentManager().beginTransaction();

                                transactionAdd.replace(R.id.container, addContributor);
                                transactionAdd.addToBackStack(null);

                                transactionAdd.commit();*/
                            }

                            @Override
                            public void onError(QBResponseException errors) {
                                ((HomeActivity)context).dismissProgressDialog();
                            }
                        });
                    } catch (Exception e) {
                        ((HomeActivity)context).dismissProgressDialog();
                        e.printStackTrace();
                    }
                }
            });

        } catch (Exception e) {
            e.printStackTrace();
        }
        return convertView;
    }

    static class ViewHolder {
        TextView member_name;
        TextView member_desig;
        TextView member_description;
        ImageView chat;
        ImageView message;
        ImageView mail;
    }

    /*@Override
    public boolean getSwipEnableByPosition(int position) {
        return true;
    }*/



    @Override
    public Filter getFilter() {
        if (valueFilter == null) {
            valueFilter = new ValueFilter();
        }
        return valueFilter;
    }


    private class ValueFilter extends Filter {

        @Override
        protected FilterResults performFiltering(CharSequence constraint) {

            FilterResults results = new FilterResults();

            if (constraint != null && constraint.length() > 0) {

                ArrayList<TeamMemberObject> filterList = new ArrayList<TeamMemberObject>();

                for (int i = 0; i < mStringFilterList.size(); i++) {

                    if (mStringFilterList.get(i).getMemberName().toLowerCase().startsWith(constraint.toString())) {
                        filterList.add(mStringFilterList.get(i));
                    }
                }
                results.count = filterList.size();
                results.values = filterList;
            } else {
                results.count = mStringFilterList.size();
                results.values = mStringFilterList;
            }
            return results;
        }


        //Invoked in the UI thread to publish the filtering results in the user interface.

        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {

            list = (ArrayList<TeamMemberObject>) results.values;
            notifyDataSetChanged();
        }
    }


}