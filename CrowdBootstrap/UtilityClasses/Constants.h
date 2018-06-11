//
//  Constants.h
//  CrowdBootstrap
//
//  Created by OSX on 06/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "AppDelegate.h"

#ifndef Constants_h
#define Constants_h

enum UserTypes{
    ENTREPRENEUR,
    CONTRACTOR
};

enum TOOLBAR_BUTTONS{
    DONE_CLICKED,
    CANCEL_CLICKED
};

enum{
    ADD_STARTUP_VIEW_MODE,
    STARTUP_DETAIL_VIEW_MODE
};

enum PROFILE_SELECTED {
    PROFILE_BASIC_SELECTED,
    PROFILE_PROFESSIONAL_SELECTED,
    PROFILE_STARTUPS_SELECTED
};

enum STARTUP_RADIO_BUTTON_SELECTED {
    YES_SELETCED,
    NO_SELETCED
};

enum {
    PROFILE_MODE_MY_PROFILE,
    PROFILE_MODE_SEARCH,
    PROFILE_MODE_RECOMMENDED,
    PROFILE_MODE_TEAM
};

enum {
    CURRENT_SELECTED,
    COMPLETEED_SELECTED,
    SEARCH_SELECTED,
    MY_STARTUPS_SELECTED
};

enum {
    MY_CONNECTIONS_SELECTED,
    MY_MESSAGES_SELECTED
};

enum {
    TARGET_MARKET_SELECTED,
    CAMPAIGN_KEYWORD_SELECTED
};

// Recruiter
enum {
    MYJOBS_SELECTED,
    ARCHIVED_JOB_SELECTED,
    DEACTIVATED_JOB_SELECTED
};

// Funds
enum {
    FINDFUNDS_SELECTED,
    FUND_INVEST_SELECTED
};

enum {
    MYFUNDS_SELECTED,
    ARCHIVE_FUNDS_SELECTED,
    DEACTIVATED_FUNDS_SELECTED
};

// Beta Testers
enum {
    SEARCH_BETA_TEST_SELECTED,
    ADD_BETA_TEST_SELECTED
};

enum {
    MY_BETA_TEST_SELECTED,
    ARCHIVE_BETA_TEST_SELECTED,
    DEACTIVATED_BETA_TEST_SELECTED
};

// Board Members
enum {
    SEARCH_BOARD_MEMBER_SELECTED,
    ADD_BOARD_MEMBER_SELECTED
};

enum {
    MY_BOARD_MEMBER_SELECTED,
    ARCHIVE_BOARD_MEMBER_SELECTED,
    DEACTIVATED_BOARD_MEMBER_SELECTED
};

// Communal Assets
enum {
    SEARCH_COMMUNAL_ASSET_SELECTED,
    ADD_COMMUNAL_ASSET_SELECTED
};

enum {
    MY_COMMUNAL_ASSET_SELECTED,
    ARCHIVE_COMMUNAL_ASSET_SELECTED,
    DEACTIVATED_COMMUNAL_ASSET_SELECTED
};

// Consulting Projects
enum {
    SEARCH_CONSULTING_SELECTED,
    ADD_CONSULTING_SELECTED
};

enum {
    MY_CONSULTING_SELECTED,
    ARCHIVE_CONSULTING_SELECTED,
    CLOSED_CONSULTING_SELECTED,
    INVITATION_CONSULTING_SELECTED
};

// Early Adopters
enum {
    SEARCH_EARLY_ADOPTER_SELECTED,
    ADD_EARLY_ADOPTER_SELECTED
};

enum {
    MY_EARLY_ADOPTER_SELECTED,
    ARCHIVE_EARLY_ADOPTER_SELECTED,
    DEACTIVATED_EARLY_ADOPTER_SELECTED
};

// Endorsors
enum {
    SEARCH_ENDORSOR_SELECTED,
    ADD_ENDORSOR_SELECTED
};

enum {
    MY_ENDORSOR_SELECTED,
    ARCHIVE_ENDORSOR_SELECTED,
    DEACTIVATED_ENDORSOR_SELECTED
};

// Focus Groups
enum {
    SEARCH_FOCUS_GROUP_SELECTED,
    ADD_FOCUS_GROUP_SELECTED
};

enum {
    MY_FOCUS_GROUP_SELECTED,
    ARCHIVE_FOCUS_GROUP_SELECTED,
    DEACTIVATED_FOCUS_GROUP_SELECTED
};

// Hardware
enum {
    SEARCH_HARDWARE_SELECTED,
    ADD_HARDWARE_SELECTED
};

enum {
    MY_HARDWARE_SELECTED,
    ARCHIVE_HARDWARE_SELECTED,
    DEACTIVATED_HARDWARE_SELECTED
};

// Softwares
enum {
    SEARCH_SOFTWARE_SELECTED,
    ADD_SOFTWARE_SELECTED
};

enum {
    MY_SOFTWARE_SELECTED,
    ARCHIVE_SOFTWARE_SELECTED,
    DEACTIVATED_SOFTWARE_SELECTED
};

// Services
enum {
    SEARCH_SERVICE_SELECTED,
    ADD_SERVICE_SELECTED
};

enum {
    MY_SERVICE_SELECTED,
    ARCHIVE_SERVICE_SELECTED,
    DEACTIVATED_SERVICE_SELECTED
};

// Audio Video
enum {
    SEARCH_AUDIOVIDEO_SELECTED,
    ADD_AUDIOVIDEO_SELECTED
};

enum {
    MY_AUDIOVIDEO_SELECTED,
    ARCHIVE_AUDIOVIDEO_SELECTED,
    DEACTIVATED_AUDIOVIDEO_SELECTED
};

// Information
enum {
    SEARCH_INFORMATION_SELECTED,
    ADD_INFORMATION_SELECTED
};

enum {
    MY_INFORMATION_SELECTED,
    ARCHIVE_INFORMATION_SELECTED,
    DEACTIVATED_INFORMATION_SELECTED
};

// Productivity
enum {
    SEARCH_PRODUCTIVITY_SELECTED,
    ADD_PRODUCTIVITY_SELECTED
};

enum {
    MY_PRODUCTIVITY_SELECTED,
    ARCHIVE_PRODUCTIVITY_SELECTED,
    DEACTIVATED_PRODUCTIVITY_SELECTED
};

// Group
enum {
    SEARCH_GROUP_SELECTED,
    ADD_GROUP_SELECTED
};

enum {
    MY_GROUP_SELECTED,
    ARCHIVE_GROUP_SELECTED,
    DEACTIVATED_GROUP_SELECTED
};

// Webinar
enum {
    SEARCH_WEBINAR_SELECTED,
    ADD_WEBINAR_SELECTED
};

enum {
    MY_WEBINAR_SELECTED,
    ARCHIVE_WEBINAR_SELECTED,
    DEACTIVATED_WEBINAR_SELECTED
};

// Meet Up
enum {
    SEARCH_MEETUP_SELECTED,
    ADD_MEETUP_SELECTED
};

enum {
    MY_MEETUP_SELECTED,
    ARCHIVE_MEETUP_SELECTED,
    DEACTIVATED_MEETUP_SELECTED
};

// Demo Day
enum {
    SEARCH_DEMODAY_SELECTED,
    ADD_DEMODAY_SELECTED
};

enum {
    MY_DEMODAY_SELECTED,
    ARCHIVE_DEMODAY_SELECTED,
    DEACTIVATED_DEMODAY_SELECTED
};

// Conference
enum {
    SEARCH_CONFERENCE_SELECTED,
    ADD_CONFERENCE_SELECTED
};

enum {
    MY_CONFERENCE_SELECTED,
    ARCHIVE_CONFERENCE_SELECTED,
    DEACTIVATED_CONFERENCE_SELECTED
};

// Career Advancement
enum {
    SEARCH_CAREER_SELECTED,
    ADD_CAREER_SELECTED
};

enum {
    MY_CAREER_SELECTED,
    ARCHIVE_CAREER_SELECTED,
    DEACTIVATED_CAREER_SELECTED
};

// Self Improvement
enum {
    SEARCH_IMPROVEMENT_SELECTED,
    ADD_IMPROVEMENT_SELECTED
};

enum {
    MY_IMPROVEMENT_SELECTED,
    ARCHIVE_IMPROVEMENT_SELECTED,
    DEACTIVATED_IMPROVEMENT_SELECTED
};


// Launch Deals
enum {
    SEARCH_LAUNCHDEAL_SELECTED,
    ADD_LAUNCHDEAL_SELECTED
};

enum {
    MY_LAUNCHDEAL_SELECTED,
    ARCHIVE_LAUNCHDEAL_SELECTED,
    DEACTIVATED_LAUNCHDEAL_SELECTED
};

// Group Buying/Purchase Order
enum {
    SEARCH_PURCHASE_ORDER_SELECTED,
    ADD_PURCHASE_ORDER_SELECTED
};

// Search User/ Add New User
enum {
    SEARCH_USER_SELECTED,
    ADD_NEW_USER_SELECTED
};

#define kQuickblox_ApplicationID                  41172;
#define kQuickblox_AuthKey                        @"atp85LpFMSSk-My";
#define kQuickblox_AuthSecret                     @"xu5sSy6uPsf9BA5";
#define kQuickblox_AccountKey                     @"aNstpqyjBhYp2zTd4HFR";

#define QUICKBLOX_CUSTOM_CLASS                    @"CustomDialogClass"

#define kYouTube_ApiKey                           @"AIzaSyCfcDtlizrhXkemNWoARkxno1HOkownmMI"

//#define PASSWORD_REGEX_PATTERN                    @"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,25}$";
#define PASSWORD_REGEX_PATTERN                    @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*(_|[^\w])).+$";
#define PHONE_MAX_LENGTH                          16
#define PHONE_MIN_LENGTH                          16

#define US_COUNTRY_ID                             231

#define NOTES_ENTITY                              @"CDTestEntity"
#define kAPPDELEGATE                              [AppDelegate appDelegate]
#define kUSERDEFAULTS                             [NSUserDefaults standardUserDefaults]

#pragma mark - Text
#define ENTREPRENEUR_TEXT                         @"ENTREPRENEUR"
#define CONTRACTOR_TEXT                           @"CONTRACTOR"
#define FOLLOW_TEXT                               @"Follow"
#define UNFOLLOW_TEXT                             @"Unfollow"
#define CONNECT_TEXT                              @"Connect"
#define DISCONNECT_TEXT                           @"Disconnect"
#define REQUEST_SENT_TEXT                         @"Request Sent"
#define RESPOND_TEXT                              @"Respond"
#define LIKE_TEXT                                 @"Like"
#define UNLIKE_TEXT                               @"Unlike"
#define COMMIT_TEXT                               @"Commit"
#define UNCOMMIT_TEXT                             @"UnCommit"

#define kSelectCountryDefaultText                 @"Select Country"
#define kSelectStateDefaultText                   @"Select State"
#define kImagePicker_Cancel                       @"Cancel"
#define kImagePicker_UploadImage                  @"Upload Image"
#define kImagePicker_TakePicture                  @"Take Picture"

#define TEAM_TYPE_ENTREPRENEUR                    @"Entrepreneur"
#define TEAM_TYPE_COFOUNDER                       @"Co-founder"
#define TEAM_TYPE_TEAM_MEMEBER                    @"Team-member"
#define TEAM_TYPE_CONTRACTOR                      @"Contractor"
#define kSearchBarPlaceholder                     @"Search by startup name"
#define kSearchContractorPlaceholder              @"Search by contractor name or keywords."
#define kSearchDocumentPlaceholder                @"Search by document name"
#define kCampaignSearchBarPlaceholder             @"Search by campaign name"
#define kSearchConnectionPlaceholder              @"Search by connection name or keywords."
#define kSearchOrganizationPlaceholder            @"Search by organization name or keywords."
#define kSearchJobPlaceholder                     @"Search by Job Title or keywords."
#define kSearchFundPlaceholder                    @"Search by Fund Title or keywords."
#define kSearchBetaTestPlaceholder                @"Search by Beta Test Title or keywords."
#define kSearchBoardMemberPlaceholder             @"Search by Board Member Title or keywords."
#define kSearchCommunalAssetPlaceholder           @"Search by Communal Asset Title or keywords."
#define kSearchConsultingPlaceholder              @"Search by Consulting Project Title or keywords."
#define kSearchEarlyAdopterPlaceholder            @"Search by Early Adopter Title or keywords."
#define kSearchEndorsorPlaceholder                @"Search by Endorser Title or keywords."
#define kSearchFocusGroupPlaceholder              @"Search by Focus Group Title or keywords."
#define kSearchHardwarePlaceholder                @"Search by Hardware Title or keywords."
#define kSearchSoftwarePlaceholder                @"Search by Software Title or keywords."
#define kSearchServicePlaceholder                 @"Search by Service Title or keywords."
#define kSearchAudioVideoPlaceholder              @"Search by Audio Video Title or keywords."
#define kSearchInformationPlaceholder             @"Search by Information Title or keywords."
#define kSearchProductivityPlaceholder            @"Search by Productivity Title or keywords."
#define kSearchGroupPlaceholder                   @"Search by Group Title or keywords."
#define kSearchWebinarPlaceholder                 @"Search by Webinar Title or keywords."
#define kSearchMeetUpPlaceholder                  @"Search by Meet Up Title or keywords."
#define kSearchDemoDayPlaceholder                 @"Search by Demo Day Title or keywords."
#define kSearchConferencePlaceholder              @"Search by Conference Title or keywords."
#define kSearchCareerPlaceholder                  @"Search by Career Title or keywords."
#define kSearchLaunchDealPlaceholder              @"Search by LaunchDeal Title or keywords."
#define kSearchImprovementPlaceholder             @"Search by Improvement Title or keywords."
#define kSearchPurchaseOrderPlaceholder           @"Search by Purchase Order Title or keywords."
#define kSearchUserPlaceholder                    @"Search Users by name"

#pragma mark - plist
#define kSignupElementsPlist                      @"SignUpElementsArray"

#pragma mark - html / video Links
#define EXPLAINER_VIDEO_LINK                      @"https://www.youtube.com/watch?v=t4qOmcKPsC0"
#define ACCREDITED_INVESTOR_HTML                  @"accredited_investor"
#define VENTURE_CAPITAL_LINK                      @"http://crowdbootstrap.com/contractors/venture-capital-apps"
#define LICENSE_LINK                              @"https://creativecommons.org/licenses/by-nc-sa/4.0/"
#define ROADMAP_TEMPLATE_LINK                     @"http://stage.crowdbootstrap.com/img/sampledoc/0.0_Lean_Startup_Roadmap_Template_v8.0.pdf"
#define PRIVACY_POLICY_LINK                       @"http://crowdbootstrap.com/users/privacy-policy"
#define TERMS_CONDITIONS_LINK                     @"http://crowdbootstrap.com/users/terms--and-conditions"


#pragma mark - Youtube Videos
#define ENT_VIDEO_LINK                            @"rzrUTei649c"
#define CONT_VIDEO_LINK                           @"pUmkBCFqqM0" //@"TWH_aV6WinY"
#define ROADMAP_VIDEO_LINK                        @"hvyULGzoqFM"
#define ENT_VIDEO_LINK                            @"rzrUTei649c"
#define GETTING_STARTED_VIDEO_LINK                @"Q9tYHQnb7xI"


#pragma mark - Images
#define FORUM_ARCHIVE_IMAGE                       @"Forum_archive"
#define FORUM_DELETE_IMAGE                        @"Forum_delete"
#define FORUM_CLOSE_IMAGE                         @"Forum_close"
#define SEARCH_ARROW_IMAGE                        @"Search_arrow"
#define RADIOBUTON_SELECTED                       @"upload_radioBtn"
#define RADIOBUTTON_UNSELECTED                    @"upload_radiobtnUnselected"
#define EXPAND_SECTION_IMAGE                      @"expand"
#define COLLAPSE_SECTION_IMAGE                    @"collapse"
#define CHECK_IMAGE                               @"ShoppingCart_check"
#define UNCHECK_IMAGE                             @"ShoppingCart_uncheck"
#define ENTREPRENEUR_SELECTED_IMAGE               @"Home_EntrepreneurToggleBtn"
#define CONTRACTOR_SELECTED_IMAGE                 @"Home_ContractorToggleBtn"
#define FOLLOW_BUTTON_ICON                        @"Campaign_follow"
#define UNFOLLOW_BUTTON_ICON                      @"Campaign_unfollow"
#define STARTUP_RADIOBUTON_SELECTED               @"upload_radioBtn"
#define STARTUP_RADIOBUTTON_UNSELECTED            @"upload_radiobtnUnselected"
#define kImage_ProfilePicDefault                  @"Profile_userDefaultImg"
#define kImage_GraphicPicDefault                  @"RoadmapGraphic.png"
#define kPlaceholderImage_Logo                    @"Default.png"
#define LEAN_STARTUP_ROADMAP_IMAGE                @"road"
#define kImage_ForumPicDefault                    @"forum_img.png"
#define kImage_UserPicDefault                     @"Chat_user"
#define kCampainDetail_DefaultImage               @"forum_img.png"
#define APPLY_TEXT                                @"Click here to apply."
#define UNAPPLY_TEXT                              @"Thank you. You have applied."
#define RES_APPLY_TEXT                            @"Click here to register your interest."
#define RES_UNAPPLY_TEXT                          @"Thank you. You have registered your interest."
#define SUBMIT_TEXT                               @"Submit"
#define ACTIVATE_TEXT                             @"Activate"

#define kPlaceholderImage_Contractor              @"Chat_user"
#define WORK_ORDER_ACCEPT_ICON                    @"WorkOrder_Accept"
#define WORK_ORDER_REJECT_ICON                    @"WorkOrder_Reject"
#define WORK_ORDER_ACCEPT_TEXT                    @"Accept"
#define WORK_ORDER_REJECT_TEXT                    @"Reject"

#define MES_NOTIFICATION_TITLE                    @"Notifications"
#define CONNECTIONS_TITLE                         @"Connections"
#define SUGGEST_KEYWORDS_TITLE                    @"Suggest Keywords"

#define CON_SELF_IMPROVEMENT_TITLE                @"Self Improvement"
#define CON_CAREER_ADVANCEMENT_TITLE              @"Career Help"

#define OPP_BETATESTERS_TITLE                     @"Beta Testers"
#define OPP_BOARDMEMBERS_TITLE                    @"Board Members"
#define OPP_COMMUNALASSETS_TITLE                  @"Communal Assets"
#define OPP_COMMUNALASSETS_CONTENT                @"If you are interested in providing assets for communal use, please input a description of each asset and its use. We will add the assets to the communal portfolio."
#define OPP_CONSULTING_TITLE                      @"Consulting"
#define OPP_CONSULTING_CONTENT                    @"If you are interested in being part of a project team for a consulting assignment, please input your preferred role and the type of project that may interest you. We will send you a list of opportunities that match your preference."
#define OPP_EARLYADAPTORS_TITLE                   @"Early Adopters"
#define OPP_ENDORSERS_TITLE                       @"Endorsers"
#define OPP_FOCUSGROUPS_TITLE                     @"Focus Groups"
#define OPP_JOBS_TITLE                            @"Jobs"
#define OPP_RECRUITER_TITLE                       @"Recruiter"

#define RES_HARDWARE_TITLE                        @"Hardware"
#define RES_SOFTWARE_TITLE                        @"Software"
#define RES_SERVICES_TITLE                        @"Services"
#define RES_AUDIOVIDEO_TITLE                      @"Audio/Video"
#define RES_INFORMATION_TITLE                     @"Information"
#define RES_PRODUCTIVITY_TITLE                    @"Productivity Tools"

#define EVENT_CONFERENCES_TITLE                   @"Conferences"
#define EVENT_DEMODAYS_TITLE                      @"Demo Days"
#define EVENT_MEETUPS_TITLE                       @"Meet Ups"
#define EVENT_WEBINARS_TITLE                      @"Webinars"

#define STARTUP_FUNDS_TITLE                       @"Funds"
#define MESSAGE_GROUPS_TITLE                      @"Groups"
#define NETWORKING_OPTIONS_TITLE                  @"Networking Options"
#define START_TITLE                               @"Start"

#define GETTING_STARTED_VIDEO_TITLE               @"Getting Started Video"

#endif /* Constants_h */
