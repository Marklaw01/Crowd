package com.staging.fragments;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.staging.R;
import com.staging.activities.HomeActivity;
import com.staging.listeners.AsyncTaskCompleteListener;
import com.staging.utilities.Async;
import com.staging.utilities.AsyncNew;
import com.staging.utilities.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import static com.staging.R.string.funds;

/**
 * Created by neelmani.karn on 1/19/2016.
 */
public class SettingsFragment extends Fragment implements CompoundButton.OnCheckedChangeListener, AsyncTaskCompleteListener<String> {

    private TextView txtVersion;
    boolean isCheckedSwitch = false;
    private boolean profileChecked = false;
    private boolean betaTesterChecked = false;
    private boolean endorserChecked = false;
    private boolean boardMemberChecked = false;
    private boolean earlyAdopterChecked = false;
    private boolean focusGroupChecked = false;
    private boolean consultingChecked = false;

    private Switch switchNotification, switchPublicProfile, switchBetaTester, switchEndorser, switchBoardMember, switchEarlyAdopter, switchFocusGroups, switchConsulting;
    private Switch switchMyConnectionUpdate, switchStartupUpdate, switchFundUpdate, switchCampaignFollowedUpdate, switchCampaignCommittedUpdate;
    private Switch switchSelfImprovementUpdate, switchCareerHelpUpdate, switchOrganizationUpdate, switchForumUpdate, switchGroupUpdate, switchHardwareUpdate, switchSoftwareUpdate;
    private Switch switchServiceUpdate, switchAudioVideoUpdate, switchInformationUpdate, switchProductivityUpdate, switchConferenceUpdate, switchDemoDayUpdate;
    private Switch switchMeetupUpdate, switchWebinarUpdate, switchBetaTestUpdate, switchBoardMemberUpdate, switchCommunalAssetUpdate, switchConsultingUpdate, switchEarlyAdopterUpdate;
    private Switch switchEndorserUpdate, switchFocusGroupUpdate, switchJobUpdate, switchLaunchDealUpdate, switchGroupBuyingUpdate;

    private String WidgetSelected = "";
    private AsyncNew asyncNew;

    public SettingsFragment() {
        super();
    }

    @Override
    public void onResume() {
        super.onResume();
        ((HomeActivity) getActivity()).setOnBackPressedListener(this);
        ((HomeActivity) getActivity()).setActionBarTitle("Settings");

        if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
            ((HomeActivity) getActivity()).showProgressDialog();
            try {
                JSONObject obj = new JSONObject();
                obj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                asyncNew = new AsyncNew(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.SETTINGS_PREFS_TAG, Constants.SETTINGS_PREFS_URL, Constants.HTTP_POST_REQUEST, obj);
                asyncNew.execute();
            } catch (JSONException e) {
                e.printStackTrace();
                ((HomeActivity) getActivity()).dismissProgressDialog();
            }

        } else {
            ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_setting, container, false);
        switchNotification = (Switch) rootView.findViewById(R.id.switchNotification);
        switchPublicProfile = (Switch) rootView.findViewById(R.id.switchPublicProfile);
        switchBetaTester = (Switch) rootView.findViewById(R.id.switchBetaTester);
        switchBoardMember = (Switch) rootView.findViewById(R.id.sitchBoardMember);
        switchEndorser = (Switch) rootView.findViewById(R.id.switchEndorser);
        switchEarlyAdopter = (Switch) rootView.findViewById(R.id.switchEarlyAdopter);
        switchFocusGroups = (Switch) rootView.findViewById(R.id.switchFocusGroups);
        switchConsulting = (Switch) rootView.findViewById(R.id.switchConsulting);


        switchMyConnectionUpdate = (Switch) rootView.findViewById(R.id.connectionsUpdate);
        switchStartupUpdate = (Switch) rootView.findViewById(R.id.startupUpdate);
        switchFundUpdate = (Switch) rootView.findViewById(R.id.fundUpdate);
        switchCampaignFollowedUpdate = (Switch) rootView.findViewById(R.id.campaignFollowedUpdate);
        switchCampaignCommittedUpdate = (Switch) rootView.findViewById(R.id.campaignCommitedUpdate);
        switchSelfImprovementUpdate = (Switch) rootView.findViewById(R.id.selfImprovementUpdate);
        switchCareerHelpUpdate = (Switch) rootView.findViewById(R.id.careerHelpUpdate);
        switchOrganizationUpdate = (Switch) rootView.findViewById(R.id.organizationUpdate);
        switchForumUpdate = (Switch) rootView.findViewById(R.id.forumUpdate);
        switchGroupUpdate = (Switch) rootView.findViewById(R.id.groupUpdate);
        switchHardwareUpdate = (Switch) rootView.findViewById(R.id.hadwareUpdate);
        switchSoftwareUpdate = (Switch) rootView.findViewById(R.id.softwareUpdate);
        switchServiceUpdate = (Switch) rootView.findViewById(R.id.serviceUpdate);
        switchAudioVideoUpdate = (Switch) rootView.findViewById(R.id.audioVideoUpdate);
        switchInformationUpdate = (Switch) rootView.findViewById(R.id.informationUpdate);
        switchProductivityUpdate = (Switch) rootView.findViewById(R.id.productivityUpdate);
        switchConferenceUpdate = (Switch) rootView.findViewById(R.id.conferenceUpdate);
        switchDemoDayUpdate = (Switch) rootView.findViewById(R.id.demodayUpdate);
        switchMeetupUpdate = (Switch) rootView.findViewById(R.id.meetupUpdate);
        switchWebinarUpdate = (Switch) rootView.findViewById(R.id.webinarUpdate);
        switchBetaTestUpdate = (Switch) rootView.findViewById(R.id.betatestUpdate);
        switchBoardMemberUpdate = (Switch) rootView.findViewById(R.id.boardmemberUpdate);
        switchCommunalAssetUpdate = (Switch) rootView.findViewById(R.id.communalassetUpdate);
        switchConsultingUpdate = (Switch) rootView.findViewById(R.id.consultingUpdate);
        switchEarlyAdopterUpdate = (Switch) rootView.findViewById(R.id.earlyadopterUpdate);
        switchEndorserUpdate = (Switch) rootView.findViewById(R.id.endorserUpdate);
        switchFocusGroupUpdate = (Switch) rootView.findViewById(R.id.focusgroupUpdate);
        switchJobUpdate = (Switch) rootView.findViewById(R.id.jobUpdate);
        switchLaunchDealUpdate = (Switch) rootView.findViewById(R.id.launchDealUpdate);
        switchGroupBuyingUpdate = (Switch) rootView.findViewById(R.id.groupBuyingUpdate);


        txtVersion = (TextView) rootView.findViewById(R.id.txtVersion);
        txtVersion.setText(getString(R.string.version) + ((HomeActivity) getActivity()).prefManager.getAppVersion(getActivity()));
        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_NOTIFICATION_ON)) {
            switchNotification.setChecked(true);
        } else {
            switchNotification.setChecked(false);
        }

        profileChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONTRACTOR_PUBLIC_PROFILE_ON);

        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONTRACTOR_PUBLIC_PROFILE_ON)) {
            switchPublicProfile.setChecked(true);
        } else {
            switchPublicProfile.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BETA_TESTER)) {
            switchBetaTester.setChecked(true);
        } else {
            switchBetaTester.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BOARD_MEMBER)) {
            switchBoardMember.setChecked(true);
        } else {
            switchBoardMember.setChecked(false);
        }

        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_ENDORSER)) {
            switchEndorser.setChecked(true);
        } else {
            switchEndorser.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_EARLY_ADOPTER)) {
            switchEarlyAdopter.setChecked(true);
        } else {
            switchEarlyAdopter.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FOCUS_GROUP)) {
            switchFocusGroups.setChecked(true);
        } else {
            switchFocusGroups.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONSULTING)) {
            switchConsulting.setChecked(true);
        } else {
            switchConsulting.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONNECTION_UPDATE)) {
            switchMyConnectionUpdate.setChecked(true);
        } else {
            switchMyConnectionUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_STARTUP_UPDATE)) {
            switchStartupUpdate.setChecked(true);
        } else {
            switchStartupUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FUND_UPDATE)) {
            switchFundUpdate.setChecked(true);
        } else {
            switchFundUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CAMPAIGN_FOLLOWED_UPDATE)) {
            switchCampaignFollowedUpdate.setChecked(true);
        } else {
            switchCampaignFollowedUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CAMPAIGN_COMMITED_UPDATE)) {
            switchCampaignCommittedUpdate.setChecked(true);
        } else {
            switchCampaignCommittedUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_SELF_IMPROVEMENT_UPDATE)) {
            switchSelfImprovementUpdate.setChecked(true);
        } else {
            switchSelfImprovementUpdate.setChecked(false);
        }

        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CAREER_HELP_UPDATE)) {
            switchCareerHelpUpdate.setChecked(true);
        } else {
            switchCareerHelpUpdate.setChecked(false);
        }

        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_ORGANIZATION_UPDATE)) {
            switchOrganizationUpdate.setChecked(true);
        } else {
            switchOrganizationUpdate.setChecked(false);
        }

        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FORUM_UPDATE)) {
            switchForumUpdate.setChecked(true);
        } else {
            switchForumUpdate.setChecked(false);
        }

        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_GROUP_UPDATE)) {
            switchGroupUpdate.setChecked(true);
        } else {
            switchGroupUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_HARDWARE_UPDATE)) {
            switchHardwareUpdate.setChecked(true);
        } else {
            switchHardwareUpdate.setChecked(false);
        }

        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_SOFTWARE_UPDATE)) {
            switchSoftwareUpdate.setChecked(true);
        } else {
            switchSoftwareUpdate.setChecked(false);
        }

        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_PRODUCTIVITY_UPDATE)) {
            switchProductivityUpdate.setChecked(true);
        } else {
            switchProductivityUpdate.setChecked(false);
        }

        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_SERVICE_UPDATE)) {
            switchServiceUpdate.setChecked(true);
        } else {
            switchServiceUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_AUDIOVIDEO_UPDATE)) {
            switchAudioVideoUpdate.setChecked(true);
        } else {
            switchAudioVideoUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_INFORMATION_UPDATE)) {
            switchInformationUpdate.setChecked(true);
        } else {
            switchInformationUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONFERENCE_UPDATE)) {
            switchConferenceUpdate.setChecked(true);
        } else {
            switchConferenceUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_DEMODAY_UPDATE)) {
            switchDemoDayUpdate.setChecked(true);
        } else {
            switchDemoDayUpdate.setChecked(false);
        }

        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_WEBINAR_UPDATE)) {
            switchWebinarUpdate.setChecked(true);
        } else {
            switchWebinarUpdate.setChecked(false);
        }

        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_MEETUP_UPDATE)) {
            switchMeetupUpdate.setChecked(true);
        } else {
            switchMeetupUpdate.setChecked(false);
        }

        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BETATEST_UPDATE)) {
            switchBetaTestUpdate.setChecked(true);
        } else {
            switchBetaTestUpdate.setChecked(false);
        }

        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BOARD_MEMBER_UPDATE)) {
            switchBoardMemberUpdate.setChecked(true);
        } else {
            switchBoardMemberUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONSULTING_UPDATE)) {
            switchConsultingUpdate.setChecked(true);
        } else {
            switchConsultingUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_COMMUNAL_ASSET_UPDATE)) {
            switchCommunalAssetUpdate.setChecked(true);
        } else {
            switchCommunalAssetUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_EARLY_ADOPTER_UPDATE)) {
            switchEarlyAdopterUpdate.setChecked(true);
        } else {
            switchEarlyAdopterUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_ENDORSER_UPDATE)) {
            switchEndorserUpdate.setChecked(true);
        } else {
            switchEndorserUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FOCUS_GROUP_UPDATE)) {
            switchFocusGroupUpdate.setChecked(true);
        } else {
            switchFocusGroupUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_JOB_UPDATE)) {
            switchJobUpdate.setChecked(true);
        } else {
            switchJobUpdate.setChecked(false);
        }


        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_LAUNCH_DEAL_UPDATE)) {
            switchLaunchDealUpdate.setChecked(true);
        } else {
            switchLaunchDealUpdate.setChecked(false);
        }

        if (((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_GROUP_BUYING_UPDATE)) {
            switchGroupBuyingUpdate.setChecked(true);
        } else {
            switchGroupBuyingUpdate.setChecked(false);
        }

        switchPublicProfile.setOnCheckedChangeListener(this);
        switchNotification.setOnCheckedChangeListener(this);
        switchBoardMember.setOnCheckedChangeListener(this);
        switchBetaTester.setOnCheckedChangeListener(this);
        switchEndorser.setOnCheckedChangeListener(this);
        switchEarlyAdopter.setOnCheckedChangeListener(this);
        switchFocusGroups.setOnCheckedChangeListener(this);
        switchConsulting.setOnCheckedChangeListener(this);

        switchMyConnectionUpdate.setOnCheckedChangeListener(this);
        switchStartupUpdate.setOnCheckedChangeListener(this);
        switchFundUpdate.setOnCheckedChangeListener(this);
        switchCampaignFollowedUpdate.setOnCheckedChangeListener(this);
        switchCampaignCommittedUpdate.setOnCheckedChangeListener(this);
        switchSelfImprovementUpdate.setOnCheckedChangeListener(this);
        switchCareerHelpUpdate.setOnCheckedChangeListener(this);
        switchOrganizationUpdate.setOnCheckedChangeListener(this);
        switchForumUpdate.setOnCheckedChangeListener(this);
        switchGroupUpdate.setOnCheckedChangeListener(this);
        switchHardwareUpdate.setOnCheckedChangeListener(this);
        switchSoftwareUpdate.setOnCheckedChangeListener(this);
        switchServiceUpdate.setOnCheckedChangeListener(this);
        switchAudioVideoUpdate.setOnCheckedChangeListener(this);
        switchInformationUpdate.setOnCheckedChangeListener(this);
        switchProductivityUpdate.setOnCheckedChangeListener(this);
        switchConferenceUpdate.setOnCheckedChangeListener(this);
        switchDemoDayUpdate.setOnCheckedChangeListener(this);
        switchMeetupUpdate.setOnCheckedChangeListener(this);
        switchWebinarUpdate.setOnCheckedChangeListener(this);
        switchBetaTestUpdate.setOnCheckedChangeListener(this);
        switchBoardMemberUpdate.setOnCheckedChangeListener(this);
        switchConsultingUpdate.setOnCheckedChangeListener(this);
        switchCommunalAssetUpdate.setOnCheckedChangeListener(this);
        switchEarlyAdopterUpdate.setOnCheckedChangeListener(this);
        switchEndorserUpdate.setOnCheckedChangeListener(this);
        switchFocusGroupUpdate.setOnCheckedChangeListener(this);
        switchJobUpdate.setOnCheckedChangeListener(this);
        switchLaunchDealUpdate.setOnCheckedChangeListener(this);
        switchGroupBuyingUpdate.setOnCheckedChangeListener(this);


        return rootView;
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        switch (buttonView.getId()) {
            case R.id.switchNotification:
                if (isChecked) {
                    ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_NOTIFICATION_ON, true);
                } else {
                    ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_NOTIFICATION_ON, false);
                }
                break;
            case R.id.switchPublicProfile:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingAlert("Are you sure you want to make your Profile Public?", isChecked);
                    } else {
                        showSettingAlert("Are you sure you want to make your Profile Private?", isChecked);
                    }
                }
                break;

            case R.id.switchBetaTester:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingBetaTesterAlert("Are you sure you want to register for Beta Tester opportunities?", isChecked);
                    } else {
                        showSettingBetaTesterAlert("Are you sure you want to unregister for Beta Tester opportunities?", isChecked);
                    }
                }
                break;

            case R.id.switchEndorser:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingEndorserAlert("Are you sure you want to register for Endorser opportunities?", isChecked);
                    } else {
                        showSettingEndorserAlert("Are you sure you want to unregister for Endorser opportunities?", isChecked);
                    }
                }
                break;

            case R.id.sitchBoardMember:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingBoardMemberrAlert("Are you sure you want to register for Board Member opportunities?", isChecked);
                    } else {
                        showSettingBoardMemberrAlert("Are you sure you want to unregister for Board Member opportunities?", isChecked);
                    }
                }
                break;

            case R.id.switchEarlyAdopter:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingEarlyAdopterAlert("Are you sure you want to register for Early Adopter opportunities?", isChecked);
                    } else {
                        showSettingEarlyAdopterAlert("Are you sure you want to unregister for Early Adopter opportunities?", isChecked);
                    }
                }
                break;

            case R.id.switchFocusGroups:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingFocusGroupAlert("Are you sure you want to register for Focus Group opportunities?", isChecked);
                    } else {
                        showSettingFocusGroupAlert("Are you sure you want to unregister for Focus Group opportunities?", isChecked);
                    }
                }

                break;

            case R.id.switchConsulting:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingConsultingAlert("Are you sure you want to register for Consulting opportunities?", isChecked);
                    } else {
                        showSettingConsultingAlert("Are you sure you want to unregister for Consulting opportunities?", isChecked);
                    }
                }

                break;


            case R.id.connectionsUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingConnectionAlert("Are you sure you want to enable Connection updates?", isChecked);
                    } else {
                        showSettingConnectionAlert("Are you sure you want to disable Connection updates?", isChecked);
                    }
                }

                break;

            case R.id.startupUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingStartupAlert("Are you sure you want to enable Startup updates?", isChecked);
                    } else {
                        showSettingStartupAlert("Are you sure you want to disable Startup updates?", isChecked);
                    }
                }

                break;

            case R.id.fundUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingFundAlert("Are you sure you want to enable Fund updates?", isChecked);
                    } else {
                        showSettingFundAlert("Are you sure you want to disable Fund updates?", isChecked);
                    }
                }

                break;

            case R.id.campaignFollowedUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingCampaignFollowedAlert("Are you sure you want to enable Campaign Followed updates?", isChecked);
                    } else {
                        showSettingCampaignFollowedAlert("Are you sure you want to diable Campaign Followed updates?", isChecked);
                    }
                }

                break;


            case R.id.campaignCommitedUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingCampaignCommitedAlert("Are you sure you want to enable Campaign Committed updates", isChecked);
                    } else {
                        showSettingCampaignCommitedAlert("Are you sure you want to disable Campaign Committed updates?", isChecked);
                    }
                }

                break;

            case R.id.selfImprovementUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingSelfImprovementAlert("Are you sure you want to enable Self Improvement Tool updates?", isChecked);
                    } else {
                        showSettingSelfImprovementAlert("Are you sure you want to disable Self Improvement Tool updates?", isChecked);
                    }
                }

                break;


            case R.id.careerHelpUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingCareerHelpAlert("Are you sure you want to enable Career Help Tool updates", isChecked);
                    } else {
                        showSettingCareerHelpAlert("Are you sure you want to disable Career Help Tool updates?", isChecked);
                    }
                }

                break;

            case R.id.organizationUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingOrganizationAlert("Are you sure you want to enable Organization updates?", isChecked);
                    } else {
                        showSettingOrganizationAlert("Are you sure you want to disable Organization updates?", isChecked);
                    }
                }

                break;

            case R.id.forumUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingForumAlert("Are you sure you want to enable Forum updates?", isChecked);
                    } else {
                        showSettingForumAlert("Are you sure you want to disable Forum updates?", isChecked);
                    }
                }

                break;
            case R.id.groupUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingGroupAlert("Are you sure you want to enable Group updates?", isChecked);
                    } else {
                        showSettingGroupAlert("Are you sure you want to disable Group updates?", isChecked);
                    }
                }

                break;
            case R.id.hadwareUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingHardwareAlert("Are you sure you want to enable Hardware updates?", isChecked);
                    } else {
                        showSettingHardwareAlert("Are you sure you want to disable Hardware updates?", isChecked);
                    }
                }

                break;

            case R.id.softwareUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingSoftwareAlert("Are you sure you want to enable Software updates?", isChecked);
                    } else {
                        showSettingSoftwareAlert("Are you sure you want to disable Software updates?", isChecked);
                    }
                }

                break;

            case R.id.serviceUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingServiceAlert("Are you sure you want to enable Service updates?", isChecked);
                    } else {
                        showSettingServiceAlert("Are you sure you want to disable Service updates?", isChecked);
                    }
                }

                break;

            case R.id.audioVideoUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingAudioVideoAlert("Are you sure you want to enable Audio/Video updates?", isChecked);
                    } else {
                        showSettingAudioVideoAlert("Are you sure you want to disable Audio/Video updates?", isChecked);
                    }
                }

                break;
            case R.id.informationUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingInformationAlert("Are you sure you want to enable Information updates?", isChecked);
                    } else {
                        showSettingInformationAlert("Are you sure you want to disable Information updates?", isChecked);
                    }
                }

                break;
            case R.id.productivityUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingProductivityAlert("Are you sure you want to enable Productivity updates?", isChecked);
                    } else {
                        showSettingProductivityAlert("Are you sure you want to disable Productivity updates?", isChecked);
                    }
                }

                break;

            case R.id.conferenceUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingConferenceAlert("Are you sure you want to enable Conference updates?", isChecked);
                    } else {
                        showSettingConferenceAlert("Are you sure you want to disable Conference updates?", isChecked);
                    }
                }

                break;

            case R.id.demodayUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingDemoDayAlert("Are you sure you want to enable Demo Day updates?", isChecked);
                    } else {
                        showSettingDemoDayAlert("Are you sure you want to diable Demo Day updates?", isChecked);
                    }
                }

                break;

            case R.id.webinarUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingWebinarAlert("Are you sure you want to enable Webinar updates?", isChecked);
                    } else {
                        showSettingWebinarAlert("Are you sure you want to disable Webinar updates?", isChecked);
                    }
                }

                break;

            case R.id.meetupUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingMeetupAlert("Are you sure you want to enable Meetup updates?", isChecked);
                    } else {
                        showSettingMeetupAlert("Are you sure you want to diable Meetup updates?", isChecked);
                    }
                }

                break;

            case R.id.betatestUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingBetaTestUpdateAlert("Are you sure you want to enable Beta Test updates?", isChecked);
                    } else {
                        showSettingBetaTestUpdateAlert("Are you sure you want to disable Beta Test updates?", isChecked);
                    }
                }

                break;

            case R.id.boardmemberUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingBoardMemberUpdateAlert("Are you sure you want to enable Board Member updates?", isChecked);
                    } else {
                        showSettingBoardMemberUpdateAlert("Are you sure you want to disable Board Member updates?", isChecked);
                    }
                }

                break;


            case R.id.consultingUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingConsultingUpdateAlert("Are you sure you want to enable Consulting updates?", isChecked);
                    } else {
                        showSettingConsultingUpdateAlert("Are you sure you want to diable Consulting updatess?", isChecked);
                    }
                }

                break;


            case R.id.communalassetUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingCommunalAssetUpdateAlert("Are you sure you want to enable Communal Asset updates?", isChecked);
                    } else {
                        showSettingCommunalAssetUpdateAlert("Are you sure you want to disable Communal Asset updates?", isChecked);
                    }
                }

                break;

            case R.id.endorserUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingEndorserUpdateAlert("Are you sure you want to enable Endorser updates?", isChecked);
                    } else {
                        showSettingEndorserUpdateAlert("Are you sure you want to disable Endorser updates?", isChecked);
                    }
                }

                break;


            case R.id.earlyadopterUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingEarlyAdopterUpdateAlert("Are you sure you want to enable Early Adopter updates?", isChecked);
                    } else {
                        showSettingEarlyAdopterUpdateAlert("Are you sure you want to disable Early Adopter updates?", isChecked);
                    }
                }

                break;

            case R.id.focusgroupUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingFocusGroupUpdateAlert("Are you sure you want to enable Focus Group updates?", isChecked);
                    } else {
                        showSettingFocusGroupUpdateAlert("Are you sure you want to disable Focus Group updates?", isChecked);
                    }
                }

                break;

            case R.id.jobUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingJobUpdateAlert("Are you sure you want to enable Job updates?", isChecked);
                    } else {
                        showSettingJobUpdateAlert("Are you sure you want to disable Job updates?", isChecked);
                    }
                }

                break;
            case R.id.launchDealUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingLaunchDealUpdateAlert("Are you sure you want to enable Launch Deal updates?", isChecked);
                    } else {
                        showSettingLaunchDealUpdateAlert("Are you sure you want to disable Launch Deal updates?", isChecked);
                    }
                }

                break;
            case R.id.groupBuyingUpdate:
                if (!isCheckedSwitch) {
                    if (isChecked) {
                        showSettingGroupBuyingUpdateAlert("Are you sure you want to enable Group Buying updates?", isChecked);
                    } else {
                        showSettingGroupBuyingUpdateAlert("Are you sure you want to disable Group Buying updates?", isChecked);
                    }
                }

                break;


        }
    }

    public void showSettingAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                    ((HomeActivity) getActivity()).showProgressDialog();

                    profileChecked = isChecked;
                    Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.PROFILE_SETTING_TAG, Constants.PROFILE_SETTING_URL + "?user_id=" + ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID) + "&public_profile=" + isChecked, Constants.HTTP_GET, "Home Activity");
                    a.execute();
                } else {

                    profileChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONTRACTOR_PUBLIC_PROFILE_ON);
                    isCheckedSwitch = true;
                    switchPublicProfile.setChecked(profileChecked);
                    isCheckedSwitch = false;

                    ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                }

            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                profileChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONTRACTOR_PUBLIC_PROFILE_ON);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchPublicProfile.setChecked(profileChecked);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    public void showSettingBetaTesterAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                JSONObject roleObj = new JSONObject();
                try {


                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "beta_tester");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {


                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        betaTesterChecked = isChecked;

                        WidgetSelected = "beta_tester";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        betaTesterChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BETA_TESTER);
                        isCheckedSwitch = true;
                        switchBetaTester.setChecked(betaTesterChecked);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        betaTesterChecked = isChecked;
                        WidgetSelected = "beta_tester";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        betaTesterChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BETA_TESTER);
                        isCheckedSwitch = true;
                        switchBetaTester.setChecked(betaTesterChecked);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }


                }


            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                betaTesterChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BETA_TESTER);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchBetaTester.setChecked(betaTesterChecked);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    public void showSettingBoardMemberrAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "board_member");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                if (isChecked) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        boardMemberChecked = isChecked;

                        WidgetSelected = "board_member";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        boardMemberChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BOARD_MEMBER);
                        isCheckedSwitch = true;
                        switchBoardMember.setChecked(boardMemberChecked);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        boardMemberChecked = isChecked;
                        WidgetSelected = "board_member";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        boardMemberChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BOARD_MEMBER);
                        isCheckedSwitch = true;
                        switchBoardMember.setChecked(boardMemberChecked);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }


            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                boardMemberChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BOARD_MEMBER);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchBoardMember.setChecked(boardMemberChecked);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    public void showSettingEndorserAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "endorsor");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {


                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        endorserChecked = isChecked;
                        WidgetSelected = "endorser";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        endorserChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_ENDORSER);
                        isCheckedSwitch = true;
                        switchEndorser.setChecked(endorserChecked);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }


                } else {
                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        endorserChecked = isChecked;
                        WidgetSelected = "endorser";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        endorserChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_ENDORSER);
                        isCheckedSwitch = true;
                        switchEndorser.setChecked(endorserChecked);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                endorserChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_ENDORSER);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchEndorser.setChecked(endorserChecked);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    public void showSettingEarlyAdopterAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "early_adopter");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        earlyAdopterChecked = isChecked;
                        WidgetSelected = "early_adopter";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        earlyAdopterChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_EARLY_ADOPTER);
                        isCheckedSwitch = true;
                        switchEarlyAdopter.setChecked(earlyAdopterChecked);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        earlyAdopterChecked = isChecked;
                        WidgetSelected = "early_adopter";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        earlyAdopterChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_EARLY_ADOPTER);
                        isCheckedSwitch = true;
                        switchEarlyAdopter.setChecked(earlyAdopterChecked);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }


            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                earlyAdopterChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_EARLY_ADOPTER);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchEarlyAdopter.setChecked(earlyAdopterChecked);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    public void showSettingFocusGroupAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "focus_group");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        focusGroupChecked = isChecked;
                        WidgetSelected = "focus_group";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        focusGroupChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FOCUS_GROUP);
                        isCheckedSwitch = true;
                        switchFocusGroups.setChecked(focusGroupChecked);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        focusGroupChecked = isChecked;
                        WidgetSelected = "focus_group";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        focusGroupChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FOCUS_GROUP);
                        isCheckedSwitch = true;
                        switchFocusGroups.setChecked(focusGroupChecked);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }


            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                focusGroupChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FOCUS_GROUP);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchFocusGroups.setChecked(focusGroupChecked);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean connectionUpdated = false;

    public void showSettingConnectionAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_profile");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        connectionUpdated = isChecked;
                        WidgetSelected = "connectionUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        connectionUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONNECTION_UPDATE);
                        isCheckedSwitch = true;
                        switchMyConnectionUpdate.setChecked(connectionUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        connectionUpdated = isChecked;
                        WidgetSelected = "connectionUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        connectionUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONNECTION_UPDATE);
                        isCheckedSwitch = true;
                        switchMyConnectionUpdate.setChecked(connectionUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                connectionUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONNECTION_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchMyConnectionUpdate.setChecked(connectionUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean startupUpdated = false;

    public void showSettingStartupAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_startup");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        startupUpdated = isChecked;
                        WidgetSelected = "startupUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        startupUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_STARTUP_UPDATE);
                        isCheckedSwitch = true;
                        switchStartupUpdate.setChecked(startupUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        startupUpdated = isChecked;
                        WidgetSelected = "startupUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        startupUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_STARTUP_UPDATE);
                        isCheckedSwitch = true;
                        switchStartupUpdate.setChecked(startupUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                startupUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_STARTUP_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchStartupUpdate.setChecked(startupUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean fundsUpdated = false;

    public void showSettingFundAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_fund");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        fundsUpdated = isChecked;
                        WidgetSelected = "fundsUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        fundsUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FUND_UPDATE);
                        isCheckedSwitch = true;
                        switchFundUpdate.setChecked(fundsUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        fundsUpdated = isChecked;
                        WidgetSelected = "fundsUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        fundsUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FUND_UPDATE);
                        isCheckedSwitch = true;
                        switchFundUpdate.setChecked(fundsUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                fundsUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FUND_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchFundUpdate.setChecked(fundsUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean campaignFollowedUpdated = false;

    public void showSettingCampaignFollowedAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_campaign");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        campaignFollowedUpdated = isChecked;
                        WidgetSelected = "campaignFollowedUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        campaignFollowedUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CAMPAIGN_FOLLOWED_UPDATE);
                        isCheckedSwitch = true;
                        switchCampaignFollowedUpdate.setChecked(campaignFollowedUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        campaignFollowedUpdated = isChecked;
                        WidgetSelected = "campaignFollowedUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        campaignFollowedUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CAMPAIGN_FOLLOWED_UPDATE);
                        isCheckedSwitch = true;
                        switchCampaignFollowedUpdate.setChecked(campaignFollowedUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                campaignFollowedUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CAMPAIGN_FOLLOWED_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchCampaignFollowedUpdate.setChecked(campaignFollowedUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean campaignCommitedUpdated = false;

    public void showSettingCampaignCommitedAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_campaign_commited");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        campaignCommitedUpdated = isChecked;
                        WidgetSelected = "campaignCommitedUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        campaignCommitedUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CAMPAIGN_COMMITED_UPDATE);
                        isCheckedSwitch = true;
                        switchCampaignCommittedUpdate.setChecked(campaignCommitedUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        campaignCommitedUpdated = isChecked;
                        WidgetSelected = "campaignCommitedUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        campaignCommitedUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CAMPAIGN_COMMITED_UPDATE);
                        isCheckedSwitch = true;
                        switchCampaignCommittedUpdate.setChecked(campaignCommitedUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                campaignCommitedUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CAMPAIGN_COMMITED_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchCampaignCommittedUpdate.setChecked(campaignCommitedUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean selfImprovementUpdated = false;

    public void showSettingSelfImprovementAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_improvement");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        selfImprovementUpdated = isChecked;
                        WidgetSelected = "selfImprovementUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        selfImprovementUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_SELF_IMPROVEMENT_UPDATE);
                        isCheckedSwitch = true;
                        switchSelfImprovementUpdate.setChecked(selfImprovementUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        selfImprovementUpdated = isChecked;
                        WidgetSelected = "selfImprovementUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        selfImprovementUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_SELF_IMPROVEMENT_UPDATE);
                        isCheckedSwitch = true;
                        switchSelfImprovementUpdate.setChecked(selfImprovementUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                selfImprovementUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_SELF_IMPROVEMENT_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchSelfImprovementUpdate.setChecked(selfImprovementUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean careerHelpUpdated = false;

    public void showSettingCareerHelpAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_career");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        careerHelpUpdated = isChecked;
                        WidgetSelected = "careerHelpUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        careerHelpUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CAREER_HELP_UPDATE);
                        isCheckedSwitch = true;
                        switchCareerHelpUpdate.setChecked(careerHelpUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        careerHelpUpdated = isChecked;
                        WidgetSelected = "careerHelpUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        careerHelpUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CAREER_HELP_UPDATE);
                        isCheckedSwitch = true;
                        switchCareerHelpUpdate.setChecked(careerHelpUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                careerHelpUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CAREER_HELP_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchCareerHelpUpdate.setChecked(careerHelpUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean organizationUpdated = false;

    public void showSettingOrganizationAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_organization");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        organizationUpdated = isChecked;
                        WidgetSelected = "organizationUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        organizationUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_ORGANIZATION_UPDATE);
                        isCheckedSwitch = true;
                        switchOrganizationUpdate.setChecked(organizationUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        organizationUpdated = isChecked;
                        WidgetSelected = "organizationUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        organizationUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_ORGANIZATION_UPDATE);
                        isCheckedSwitch = true;
                        switchOrganizationUpdate.setChecked(organizationUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                organizationUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_ORGANIZATION_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchOrganizationUpdate.setChecked(organizationUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean forumUpdated = false;

    public void showSettingForumAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_forum");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        forumUpdated = isChecked;
                        WidgetSelected = "forumUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        forumUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FORUM_UPDATE);
                        isCheckedSwitch = true;
                        switchForumUpdate.setChecked(forumUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        forumUpdated = isChecked;
                        WidgetSelected = "forumUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        forumUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FORUM_UPDATE);
                        isCheckedSwitch = true;
                        switchForumUpdate.setChecked(forumUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                forumUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FORUM_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchForumUpdate.setChecked(forumUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean GroupUpdated = false;

    public void showSettingGroupAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_group");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        GroupUpdated = isChecked;
                        WidgetSelected = "GroupUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        GroupUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_GROUP_UPDATE);
                        isCheckedSwitch = true;
                        switchGroupUpdate.setChecked(GroupUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        GroupUpdated = isChecked;
                        WidgetSelected = "GroupUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        GroupUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_GROUP_UPDATE);
                        isCheckedSwitch = true;
                        switchGroupUpdate.setChecked(GroupUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                GroupUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_GROUP_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchGroupUpdate.setChecked(GroupUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean hardwareUpdated = false;

    public void showSettingHardwareAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_hardware");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        hardwareUpdated = isChecked;
                        WidgetSelected = "hardwareUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        hardwareUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_HARDWARE_UPDATE);
                        isCheckedSwitch = true;
                        switchHardwareUpdate.setChecked(hardwareUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        hardwareUpdated = isChecked;
                        WidgetSelected = "hardwareUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        hardwareUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_HARDWARE_UPDATE);
                        isCheckedSwitch = true;
                        switchHardwareUpdate.setChecked(hardwareUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                hardwareUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_HARDWARE_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchHardwareUpdate.setChecked(hardwareUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean softwareUpdated = false;

    public void showSettingSoftwareAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_software");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        softwareUpdated = isChecked;
                        WidgetSelected = "softwareUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        softwareUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_SOFTWARE_UPDATE);
                        isCheckedSwitch = true;
                        switchSoftwareUpdate.setChecked(softwareUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        softwareUpdated = isChecked;
                        WidgetSelected = "softwareUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        softwareUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_SOFTWARE_UPDATE);
                        isCheckedSwitch = true;
                        switchSoftwareUpdate.setChecked(softwareUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                softwareUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_SOFTWARE_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchSoftwareUpdate.setChecked(softwareUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean serviceUpdated = false;

    public void showSettingServiceAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_service");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        serviceUpdated = isChecked;
                        WidgetSelected = "serviceUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        serviceUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_SERVICE_UPDATE);
                        isCheckedSwitch = true;
                        switchServiceUpdate.setChecked(serviceUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        serviceUpdated = isChecked;
                        WidgetSelected = "serviceUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        serviceUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_SERVICE_UPDATE);
                        isCheckedSwitch = true;
                        switchServiceUpdate.setChecked(serviceUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                serviceUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_SERVICE_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchServiceUpdate.setChecked(serviceUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean audioVideoUpdated = false;

    public void showSettingAudioVideoAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_audio");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        audioVideoUpdated = isChecked;
                        WidgetSelected = "audioVideoUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        audioVideoUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_AUDIOVIDEO_UPDATE);
                        isCheckedSwitch = true;
                        switchAudioVideoUpdate.setChecked(audioVideoUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        audioVideoUpdated = isChecked;
                        WidgetSelected = "audioVideoUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        audioVideoUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_AUDIOVIDEO_UPDATE);
                        isCheckedSwitch = true;
                        switchAudioVideoUpdate.setChecked(audioVideoUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                audioVideoUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_AUDIOVIDEO_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchAudioVideoUpdate.setChecked(audioVideoUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean informationUpdated = false;

    public void showSettingInformationAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_information");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        informationUpdated = isChecked;
                        WidgetSelected = "informationUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        informationUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_INFORMATION_UPDATE);
                        isCheckedSwitch = true;
                        switchInformationUpdate.setChecked(informationUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        informationUpdated = isChecked;
                        WidgetSelected = "informationUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        informationUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_INFORMATION_UPDATE);
                        isCheckedSwitch = true;
                        switchInformationUpdate.setChecked(informationUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                informationUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_INFORMATION_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchInformationUpdate.setChecked(informationUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean productivityUpdated = false;

    public void showSettingProductivityAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_productivity");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        productivityUpdated = isChecked;
                        WidgetSelected = "productivityUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        productivityUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_PRODUCTIVITY_UPDATE);
                        isCheckedSwitch = true;
                        switchProductivityUpdate.setChecked(productivityUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        productivityUpdated = isChecked;
                        WidgetSelected = "productivityUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        productivityUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_PRODUCTIVITY_UPDATE);
                        isCheckedSwitch = true;
                        switchProductivityUpdate.setChecked(productivityUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                productivityUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_PRODUCTIVITY_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchProductivityUpdate.setChecked(productivityUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean conferenceUpdated = false;

    public void showSettingConferenceAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_conference");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        conferenceUpdated = isChecked;
                        WidgetSelected = "conferenceUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        conferenceUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONFERENCE_UPDATE);
                        isCheckedSwitch = true;
                        switchConferenceUpdate.setChecked(conferenceUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        conferenceUpdated = isChecked;
                        WidgetSelected = "conferenceUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        conferenceUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONFERENCE_UPDATE);
                        isCheckedSwitch = true;
                        switchConferenceUpdate.setChecked(conferenceUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                conferenceUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONFERENCE_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchConferenceUpdate.setChecked(conferenceUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean demodayUpdated = false;

    public void showSettingDemoDayAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_demoday");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        demodayUpdated = isChecked;
                        WidgetSelected = "demodayUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        demodayUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_DEMODAY_UPDATE);
                        isCheckedSwitch = true;
                        switchDemoDayUpdate.setChecked(demodayUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        demodayUpdated = isChecked;
                        WidgetSelected = "demodayUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        demodayUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_DEMODAY_UPDATE);
                        isCheckedSwitch = true;
                        switchDemoDayUpdate.setChecked(demodayUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                demodayUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_DEMODAY_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchDemoDayUpdate.setChecked(demodayUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean webinarUpdated = false;

    public void showSettingWebinarAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_webinar");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        webinarUpdated = isChecked;
                        WidgetSelected = "webinarUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        webinarUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_WEBINAR_UPDATE);
                        isCheckedSwitch = true;
                        switchWebinarUpdate.setChecked(webinarUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        webinarUpdated = isChecked;
                        WidgetSelected = "webinarUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        webinarUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_WEBINAR_UPDATE);
                        isCheckedSwitch = true;
                        switchWebinarUpdate.setChecked(webinarUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                webinarUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_WEBINAR_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchWebinarUpdate.setChecked(webinarUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean meetupUpdated = false;

    public void showSettingMeetupAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_meetup");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        meetupUpdated = isChecked;
                        WidgetSelected = "meetupUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        meetupUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_MEETUP_UPDATE);
                        isCheckedSwitch = true;
                        switchMeetupUpdate.setChecked(meetupUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        meetupUpdated = isChecked;
                        WidgetSelected = "meetupUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        meetupUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_MEETUP_UPDATE);
                        isCheckedSwitch = true;
                        switchMeetupUpdate.setChecked(meetupUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                meetupUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_MEETUP_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchMeetupUpdate.setChecked(meetupUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean betaTestUpdated = false;

    public void showSettingBetaTestUpdateAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_betatest");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        betaTestUpdated = isChecked;
                        WidgetSelected = "betaTestUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        betaTestUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BETATEST_UPDATE);
                        isCheckedSwitch = true;
                        switchBetaTestUpdate.setChecked(betaTestUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        betaTestUpdated = isChecked;
                        WidgetSelected = "betaTestUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        betaTestUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BETATEST_UPDATE);
                        isCheckedSwitch = true;
                        switchBetaTestUpdate.setChecked(betaTestUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                betaTestUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BETATEST_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchBetaTestUpdate.setChecked(betaTestUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean boardMemberUpdated = false;

    public void showSettingBoardMemberUpdateAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_boardmember");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        boardMemberUpdated = isChecked;
                        WidgetSelected = "boardMemberUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        boardMemberUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BOARD_MEMBER_UPDATE);
                        isCheckedSwitch = true;
                        switchBoardMemberUpdate.setChecked(boardMemberUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        boardMemberUpdated = isChecked;
                        WidgetSelected = "boardMemberUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        boardMemberUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BOARD_MEMBER_UPDATE);
                        isCheckedSwitch = true;
                        switchBoardMemberUpdate.setChecked(boardMemberUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                boardMemberUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_BOARD_MEMBER_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchBoardMemberUpdate.setChecked(boardMemberUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean consultingUpdated = false;

    public void showSettingConsultingUpdateAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_consulting");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        consultingUpdated = isChecked;
                        WidgetSelected = "consultingUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        consultingUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONSULTING_UPDATE);
                        isCheckedSwitch = true;
                        switchConsultingUpdate.setChecked(consultingUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        consultingUpdated = isChecked;
                        WidgetSelected = "consultingUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        consultingUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONSULTING_UPDATE);
                        isCheckedSwitch = true;
                        switchConsultingUpdate.setChecked(consultingUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                consultingUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONSULTING_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchConsultingUpdate.setChecked(consultingUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean comunalAssetUpdated = false;

    public void showSettingCommunalAssetUpdateAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_communal");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        comunalAssetUpdated = isChecked;
                        WidgetSelected = "comunalAssetUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        comunalAssetUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_COMMUNAL_ASSET_UPDATE);
                        isCheckedSwitch = true;
                        switchCommunalAssetUpdate.setChecked(comunalAssetUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        comunalAssetUpdated = isChecked;
                        WidgetSelected = "comunalAssetUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        comunalAssetUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_COMMUNAL_ASSET_UPDATE);
                        isCheckedSwitch = true;
                        switchCommunalAssetUpdate.setChecked(comunalAssetUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                comunalAssetUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_COMMUNAL_ASSET_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchCommunalAssetUpdate.setChecked(comunalAssetUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean cendorserUpdated = false;

    public void showSettingEndorserUpdateAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_endorser");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        cendorserUpdated = isChecked;
                        WidgetSelected = "cendorserUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        cendorserUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_ENDORSER_UPDATE);
                        isCheckedSwitch = true;
                        switchEndorserUpdate.setChecked(cendorserUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        cendorserUpdated = isChecked;
                        WidgetSelected = "cendorserUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        cendorserUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_ENDORSER_UPDATE);
                        isCheckedSwitch = true;
                        switchEndorserUpdate.setChecked(cendorserUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                cendorserUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_ENDORSER_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchEndorserUpdate.setChecked(cendorserUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean earlyadopterUpdated = false;

    public void showSettingEarlyAdopterUpdateAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_earlyadopter");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        earlyadopterUpdated = isChecked;
                        WidgetSelected = "earlyadopterUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        earlyadopterUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_EARLY_ADOPTER_UPDATE);
                        isCheckedSwitch = true;
                        switchEarlyAdopterUpdate.setChecked(earlyadopterUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        earlyadopterUpdated = isChecked;
                        WidgetSelected = "earlyadopterUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        earlyadopterUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_EARLY_ADOPTER_UPDATE);
                        isCheckedSwitch = true;
                        switchEarlyAdopterUpdate.setChecked(earlyadopterUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                earlyadopterUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_EARLY_ADOPTER_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchEarlyAdopterUpdate.setChecked(earlyadopterUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean focusGroupUpdated = false;

    public void showSettingFocusGroupUpdateAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_focusgroup");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        focusGroupUpdated = isChecked;
                        WidgetSelected = "focusGroupUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        focusGroupUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FOCUS_GROUP_UPDATE);
                        isCheckedSwitch = true;
                        switchFocusGroupUpdate.setChecked(focusGroupUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        focusGroupUpdated = isChecked;
                        WidgetSelected = "focusGroupUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        focusGroupUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FOCUS_GROUP_UPDATE);
                        isCheckedSwitch = true;
                        switchFocusGroupUpdate.setChecked(focusGroupUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                focusGroupUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_FOCUS_GROUP_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchFocusGroupUpdate.setChecked(focusGroupUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean jobUpdated = false;

    public void showSettingJobUpdateAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_job");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        jobUpdated = isChecked;
                        WidgetSelected = "jobUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        jobUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_JOB_UPDATE);
                        isCheckedSwitch = true;
                        switchJobUpdate.setChecked(jobUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        jobUpdated = isChecked;
                        WidgetSelected = "jobUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        jobUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_JOB_UPDATE);
                        isCheckedSwitch = true;
                        switchJobUpdate.setChecked(jobUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                jobUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_JOB_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchJobUpdate.setChecked(jobUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean launchDealUpdated = false;

    public void showSettingLaunchDealUpdateAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_launchdeal");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        launchDealUpdated = isChecked;
                        WidgetSelected = "launchDealUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        launchDealUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_LAUNCH_DEAL_UPDATE);
                        isCheckedSwitch = true;
                        switchLaunchDealUpdate.setChecked(launchDealUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        launchDealUpdated = isChecked;
                        WidgetSelected = "launchDealUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        launchDealUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_LAUNCH_DEAL_UPDATE);
                        isCheckedSwitch = true;
                        switchLaunchDealUpdate.setChecked(launchDealUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                launchDealUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_LAUNCH_DEAL_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchLaunchDealUpdate.setChecked(launchDealUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    private boolean groupBuyingUpdated = false;

    public void showSettingGroupBuyingUpdateAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "feeds_purchaseorder");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        groupBuyingUpdated = isChecked;
                        WidgetSelected = "groupBuyingUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        groupBuyingUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_GROUP_BUYING_UPDATE);
                        isCheckedSwitch = true;
                        switchGroupBuyingUpdate.setChecked(groupBuyingUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        groupBuyingUpdated = isChecked;
                        WidgetSelected = "groupBuyingUpdated";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        groupBuyingUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_GROUP_BUYING_UPDATE);
                        isCheckedSwitch = true;
                        switchGroupBuyingUpdate.setChecked(groupBuyingUpdated);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                groupBuyingUpdated = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_GROUP_BUYING_UPDATE);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchGroupBuyingUpdate.setChecked(groupBuyingUpdated);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    public void showSettingConsultingAlert(String message, final boolean isChecked) {

        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());
        // Setting Dialog Message
        alertDialog.setMessage(message);

        // On pressing Settings button
        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();

                JSONObject roleObj = new JSONObject();
                try {
                    roleObj.put("user_id", ((HomeActivity) getActivity()).prefManager.getString(Constants.USER_ID));
                    roleObj.put("type", "consulting");
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                if (isChecked == true) {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        consultingChecked = isChecked;
                        WidgetSelected = "consulting";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.BE_BETA_TESTER_SETTING_TAG, Constants.BE_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        consultingChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONSULTING);
                        isCheckedSwitch = true;
                        switchConsulting.setChecked(consultingChecked);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }
                } else {

                    if (((HomeActivity) getActivity()).networkConnectivity.isOnline()) {
                        ((HomeActivity) getActivity()).showProgressDialog();

                        consultingChecked = isChecked;
                        WidgetSelected = "consulting";
                        Async a = new Async(getActivity(), (AsyncTaskCompleteListener<String>) getActivity(), Constants.UNREGISTER_BETA_TESTER_SETTING_TAG, Constants.UNREGISTER_BETA_TESTER_SETTING_URL, Constants.HTTP_POST, roleObj, "Home Activity");
                        a.execute();
                    } else {

                        consultingChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONSULTING);
                        isCheckedSwitch = true;
                        switchConsulting.setChecked(consultingChecked);
                        isCheckedSwitch = false;

                        ((HomeActivity) getActivity()).utilitiesClass.alertDialogSingleButton(getString(R.string.no_internet_connection));
                    }

                }
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

                consultingChecked = ((HomeActivity) getActivity()).prefManager.getBoolean(Constants.IS_CONSULTING);
                isCheckedSwitch = true;
                dialog.dismiss();
                switchConsulting.setChecked(consultingChecked);
                isCheckedSwitch = false;
                //((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PUBLIC_PROFILE_ON, profileChecked);

            }
        });

        // Showing Alert Message
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }


    @Override
    public void onTaskComplete(String result, String tag) {
        if (result.equalsIgnoreCase(Constants.NOINTERNET)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.check_internet), Toast.LENGTH_LONG).show();
        } else if (result.equalsIgnoreCase(Constants.SERVEREXCEPTION)) {
            ((HomeActivity) getActivity()).dismissProgressDialog();
            Toast.makeText(getActivity(), getString(R.string.server_down), Toast.LENGTH_LONG).show();
        } else {
            if (tag.equalsIgnoreCase(Constants.PROFILE_SETTING_TAG)) {

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {
                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONTRACTOR_PUBLIC_PROFILE_ON, profileChecked);

                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.SETTINGS_PREFS_TAG)) {
                try {
                    JSONObject jsonObject = new JSONObject(result);
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {


                        JSONObject funds = jsonObject.getJSONObject("setting_list");

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_NOTIFICATION_ON, funds.optBoolean("notification"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONTRACTOR_PUBLIC_PROFILE_ON, funds.optBoolean("public_profile"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_BETA_TESTER, funds.optBoolean("beta_tester"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_BOARD_MEMBER, funds.optBoolean("board_member"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_EARLY_ADOPTER, funds.optBoolean("early_adopter"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_ENDORSER, funds.optBoolean("endorsor"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_FOCUS_GROUP, funds.optBoolean("focus_group"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONSULTING, funds.optBoolean("consulting"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONNECTION_UPDATE, funds.optBoolean("feeds_profile"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_STARTUP_UPDATE, funds.optBoolean("feeds_startup"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_FUND_UPDATE, funds.optBoolean("feeds_fund"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CAMPAIGN_FOLLOWED_UPDATE, funds.optBoolean("feeds_campaign"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CAMPAIGN_COMMITED_UPDATE, funds.optBoolean("feeds_campaign_commited"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_SELF_IMPROVEMENT_UPDATE, funds.optBoolean("feeds_improvement"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CAREER_HELP_UPDATE, funds.optBoolean("feeds_career"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_ORGANIZATION_UPDATE, funds.optBoolean("feeds_organization"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_FORUM_UPDATE, funds.optBoolean("feeds_forum"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_GROUP_UPDATE, funds.optBoolean("feeds_group"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_HARDWARE_UPDATE, funds.optBoolean("feeds_hardware"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_SOFTWARE_UPDATE, funds.optBoolean("feeds_software"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_SERVICE_UPDATE, funds.optBoolean("feeds_service"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_AUDIOVIDEO_UPDATE, funds.optBoolean("feeds_audio"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_INFORMATION_UPDATE, funds.optBoolean("feeds_information"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PRODUCTIVITY_UPDATE, funds.optBoolean("feeds_productivity"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONFERENCE_UPDATE, funds.optBoolean("feeds_conference"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_DEMODAY_UPDATE, funds.optBoolean("feeds_demoday"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_MEETUP_UPDATE, funds.optBoolean("feeds_meetup"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_WEBINAR_UPDATE, funds.optBoolean("feeds_webinar"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_BETATEST_UPDATE, funds.optBoolean("feeds_betatest"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_BOARD_MEMBER_UPDATE, funds.optBoolean("feeds_boardmember"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_COMMUNAL_ASSET_UPDATE, funds.optBoolean("feeds_communal"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONSULTING_UPDATE, funds.optBoolean("feeds_consulting"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_EARLY_ADOPTER_UPDATE, funds.optBoolean("feeds_earlyadopter"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_ENDORSER_UPDATE, funds.optBoolean("feeds_endorser"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_FOCUS_GROUP_UPDATE, funds.optBoolean("feeds_focusgroup"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_JOB_UPDATE, funds.optBoolean("feeds_job"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_LAUNCH_DEAL_UPDATE, funds.optBoolean("feeds_launchdeal"));

                        ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_GROUP_BUYING_UPDATE, funds.optBoolean("feeds_purchaseorder"));

                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }

            } else if (tag.equalsIgnoreCase(Constants.BE_BETA_TESTER_SETTING_TAG)) {

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                        if (WidgetSelected.compareTo("beta_tester") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_BETA_TESTER, true);
                        } else if (WidgetSelected.compareTo("board_member") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_BOARD_MEMBER, true);
                        } else if (WidgetSelected.compareTo("early_adopter") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_EARLY_ADOPTER, true);
                        } else if (WidgetSelected.compareTo("endorser") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_ENDORSER, true);
                        } else if (WidgetSelected.compareTo("focus_group") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_FOCUS_GROUP, true);
                        } else if (WidgetSelected.compareTo("consulting") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONSULTING, true);
                        } else if (WidgetSelected.compareTo("connectionUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONNECTION_UPDATE, true);
                        } else if (WidgetSelected.compareTo("startupUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_STARTUP_UPDATE, true);
                        } else if (WidgetSelected.compareTo("fundsUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_FUND_UPDATE, true);
                        } else if (WidgetSelected.compareTo("campaignFollowedUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CAMPAIGN_FOLLOWED_UPDATE, true);
                        } else if (WidgetSelected.compareTo("campaignCommitedUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CAMPAIGN_COMMITED_UPDATE, true);
                        } else if (WidgetSelected.compareTo("selfImprovementUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_SELF_IMPROVEMENT_UPDATE, true);
                        } else if (WidgetSelected.compareTo("careerHelpUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CAREER_HELP_UPDATE, true);
                        } else if (WidgetSelected.compareTo("organizationUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_ORGANIZATION_UPDATE, true);
                        } else if (WidgetSelected.compareTo("forumUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_FORUM_UPDATE, true);
                        } else if (WidgetSelected.compareTo("GroupUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_GROUP_UPDATE, true);
                        } else if (WidgetSelected.compareTo("hardwareUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_HARDWARE_UPDATE, true);
                        } else if (WidgetSelected.compareTo("softwareUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_SOFTWARE_UPDATE, true);
                        } else if (WidgetSelected.compareTo("serviceUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_SERVICE_UPDATE, true);
                        } else if (WidgetSelected.compareTo("audioVideoUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_AUDIOVIDEO_UPDATE, true);
                        } else if (WidgetSelected.compareTo("informationUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_INFORMATION_UPDATE, true);
                        } else if (WidgetSelected.compareTo("productivityUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PRODUCTIVITY_UPDATE, true);
                        } else if (WidgetSelected.compareTo("conferenceUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONFERENCE_UPDATE, true);
                        } else if (WidgetSelected.compareTo("demodayUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_DEMODAY_UPDATE, true);
                        } else if (WidgetSelected.compareTo("webinarUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_WEBINAR_UPDATE, true);
                        } else if (WidgetSelected.compareTo("meetupUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_MEETUP_UPDATE, true);
                        } else if (WidgetSelected.compareTo("betaTestUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_BETATEST_UPDATE, true);
                        } else if (WidgetSelected.compareTo("boardMemberUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_BOARD_MEMBER_UPDATE, true);
                        } else if (WidgetSelected.compareTo("consultingUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONSULTING_UPDATE, true);
                        } else if (WidgetSelected.compareTo("comunalAssetUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_COMMUNAL_ASSET_UPDATE, true);
                        } else if (WidgetSelected.compareTo("earlyadopterUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_EARLY_ADOPTER_UPDATE, true);
                        } else if (WidgetSelected.compareTo("cendorserUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_ENDORSER_UPDATE, true);
                        } else if (WidgetSelected.compareTo("focusGroupUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_FOCUS_GROUP_UPDATE, true);
                        } else if (WidgetSelected.compareTo("jobUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_JOB_UPDATE, true);
                        } else if (WidgetSelected.compareTo("launchDealUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_LAUNCH_DEAL_UPDATE, true);
                        } else if (WidgetSelected.compareTo("groupBuyingUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_GROUP_BUYING_UPDATE, true);
                        }
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            } else if (tag.equalsIgnoreCase(Constants.UNREGISTER_BETA_TESTER_SETTING_TAG)) {

                try {
                    JSONObject jsonObject = new JSONObject(result);
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_SUCESS_STATUS_CODE)) {

                        if (WidgetSelected.compareTo("beta_tester") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_BETA_TESTER, false);
                        } else if (WidgetSelected.compareTo("board_member") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_BOARD_MEMBER, false);
                        } else if (WidgetSelected.compareTo("early_adopter") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_EARLY_ADOPTER, false);
                        } else if (WidgetSelected.compareTo("endorser") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_ENDORSER, false);
                        } else if (WidgetSelected.compareTo("focus_group") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_FOCUS_GROUP, false);
                        } else if (WidgetSelected.compareTo("consulting") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONSULTING, false);
                        } else if (WidgetSelected.compareTo("connectionUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONNECTION_UPDATE, false);
                        } else if (WidgetSelected.compareTo("startupUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_STARTUP_UPDATE, false);
                        } else if (WidgetSelected.compareTo("fundsUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_FUND_UPDATE, false);
                        } else if (WidgetSelected.compareTo("campaignFollowedUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CAMPAIGN_FOLLOWED_UPDATE, false);
                        } else if (WidgetSelected.compareTo("campaignCommitedUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CAMPAIGN_COMMITED_UPDATE, false);
                        } else if (WidgetSelected.compareTo("selfImprovementUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_SELF_IMPROVEMENT_UPDATE, false);
                        } else if (WidgetSelected.compareTo("careerHelpUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CAREER_HELP_UPDATE, false);
                        } else if (WidgetSelected.compareTo("organizationUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_ORGANIZATION_UPDATE, false);
                        } else if (WidgetSelected.compareTo("forumUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_FORUM_UPDATE, false);
                        } else if (WidgetSelected.compareTo("GroupUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_GROUP_UPDATE, false);
                        } else if (WidgetSelected.compareTo("hardwareUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_HARDWARE_UPDATE, false);
                        } else if (WidgetSelected.compareTo("softwareUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_SOFTWARE_UPDATE, false);
                        } else if (WidgetSelected.compareTo("serviceUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_SERVICE_UPDATE, false);
                        } else if (WidgetSelected.compareTo("audioVideoUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_AUDIOVIDEO_UPDATE, false);
                        } else if (WidgetSelected.compareTo("informationUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_INFORMATION_UPDATE, false);
                        } else if (WidgetSelected.compareTo("productivityUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_PRODUCTIVITY_UPDATE, false);
                        } else if (WidgetSelected.compareTo("conferenceUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONFERENCE_UPDATE, false);
                        } else if (WidgetSelected.compareTo("demodayUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_DEMODAY_UPDATE, false);
                        } else if (WidgetSelected.compareTo("webinarUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_WEBINAR_UPDATE, false);
                        } else if (WidgetSelected.compareTo("meetupUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_MEETUP_UPDATE, false);
                        } else if (WidgetSelected.compareTo("betaTestUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_BETATEST_UPDATE, false);
                        } else if (WidgetSelected.compareTo("boardMemberUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_BOARD_MEMBER_UPDATE, false);
                        } else if (WidgetSelected.compareTo("consultingUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_CONSULTING_UPDATE, false);
                        } else if (WidgetSelected.compareTo("comunalAssetUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_COMMUNAL_ASSET_UPDATE, false);
                        } else if (WidgetSelected.compareTo("earlyadopterUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_EARLY_ADOPTER_UPDATE, false);
                        } else if (WidgetSelected.compareTo("cendorserUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_ENDORSER_UPDATE, false);
                        } else if (WidgetSelected.compareTo("focusGroupUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_FOCUS_GROUP_UPDATE, false);
                        } else if (WidgetSelected.compareTo("jobUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_JOB_UPDATE, false);
                        } else if (WidgetSelected.compareTo("launchDealUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_LAUNCH_DEAL_UPDATE, false);
                        } else if (WidgetSelected.compareTo("groupBuyingUpdated") == 0) {
                            ((HomeActivity) getActivity()).prefManager.storeBoolean(Constants.IS_GROUP_BUYING_UPDATE, false);
                        }
                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    } else if (jsonObject.optString(Constants.RESPONSE_STATUS_CODE).equalsIgnoreCase(Constants.RESPONSE_ERROR_STATUS_CODE)) {

                        ((HomeActivity) getActivity()).dismissProgressDialog();
                    }
                } catch (JSONException e) {
                    ((HomeActivity) getActivity()).dismissProgressDialog();
                    e.printStackTrace();
                }
            }
        }
    }
}