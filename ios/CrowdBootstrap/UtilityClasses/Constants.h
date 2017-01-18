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

enum {
    MYJOBS_SELECTED,
    ARCHIVED_JOB_SELECTED,
    DEACTIVATED_JOB_SELECTED,
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

#define kSelectCountryDefaultText                 @"Select Country"
#define kSelectStateDefaultText                 @"Select State"
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

#pragma mark - plist
#define kSignupElementsPlist                      @"SignUpElementsArray"

#pragma mark - html / video Links
#define EXPLAINER_VIDEO_LINK                      @"https://www.youtube.com/watch?v=t4qOmcKPsC0"
#define ACCREDITED_INVESTOR_HTML                  @"accredited_investor"
#define VENTURE_CAPITAL_LINK                      @"http://crowdbootstrap.com/contractors/venture-capital-apps"
#define ROADMAP_TEMPLATE_LINK                     @"http://crowdbootstrap.com/contractors/roadmap-template-apps"
#define PRIVACY_POLICY_LINK                       @"http://crowdbootstrap.com/users/privacy-policy"
#define TERMS_CONDITIONS_LINK                     @"http://crowdbootstrap.com/users/terms--and-conditions"


#pragma mark - Youtube Videos
#define ENT_VIDEO_LINK                            @"rzrUTei649c"
#define CONT_VIDEO_LINK                           @"pUmkBCFqqM0"
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
#define LEAN_STARTUP_ROADMAP_IMAGE                @"road"
#define kImage_ForumPicDefault                    @"forum_img.png"
#define kImage_UserPicDefault                     @"Chat_user"
#define kCampainDetail_DefaultImage               @"forum_img.png"
#define COMMIT_TEXT                               @"Commit"
#define UNCOMMIT_TEXT                             @"Uncommit"
#define kPlaceholderImage_Contractor              @"Chat_user"
#define WORK_ORDER_ACCEPT_ICON                    @"WorkOrder_Accept"
#define WORK_ORDER_REJECT_ICON                    @"WorkOrder_Reject"
#define WORK_ORDER_ACCEPT_TEXT                    @"Accept"
#define WORK_ORDER_REJECT_TEXT                    @"Reject"

#define MES_NOTIFICATION_TITLE                    @"Notifications"
#define CONNECTIONS_TITLE                         @"Connections"
#define SUGGEST_KEYWORDS_TITLE                    @"Suggest Keywords"

#define OPP_BETATESTERS_TITLE                     @"Beta Testers"
#define OPP_BETATESTERS_CONTENT                   @"If you are interested in being a beta tester, please input the types of products and businesses that may interest you. We will send you a list of opportunities that match your preference."
#define OPP_BOARDMEMBERS_TITLE                    @"Board Members"
#define OPP_BOARDMEMBERS_CONTENT                  @"If you are interested in being a Board Member, please input the types of products and businesses that may interest you. We will send you a list of opportunities that match your preference."
#define OPP_COMMUNALASSETS_TITLE                  @"Communal Assets"
#define OPP_COMMUNALASSETS_CONTENT                @"If you are interested in providing assets for communal use, please input a description of each asset and its use. We will add the assets to the communal portfolio."
#define OPP_CONSULTING_TITLE                      @"Consulting"
#define OPP_CONSULTING_CONTENT                    @"If you are interested in being part of a project team for a consulting assignment, please input your preferred role and the type of project that may interest you. We will send you a list of opportunities that match your preference."
#define OPP_EARLYADAPTORS_TITLE                   @"Early Adopters"
#define OPP_EARLYADAPTORS_CONTENT                 @"If you are interested in being an early adopter customer, please input the types of products and businesses that may interest you. We will send you a list of offerings that match your preference."
#define OPP_ENDORSERS_TITLE                       @"Endorsers"
#define OPP_ENDORSERS_CONTENT                     @"If you are interested in endorsing products or services, please input the types of products, services and businesses that may interest you. We will send you a list of purchasing opportunities that match your preference."
#define OPP_FOCUSGROUPS_TITLE                     @"Focus Groups"
#define OPP_FOCUSGROUPS_CONTENT                   @"If you are interested in participating in focus groups, please input the types of products, businesses and focus groups that may interest you. We will send you a list of opportunities that match your preference."
#define OPP_JOBS_TITLE                            @"Jobs"
#define OPP_RECRUITER_TITLE                       @"Recruiter"
#define OPP_RECRUITER_CONTENT                     @"If you are a job recruiter, please input information about the positions you are trying to fill. We will send you a list of candidates that match your requirements."

#define RES_HARDWARE_TITLE                        @"Hardware"
#define RES_HARDWARE_CONTENT                      @"Coming soon - A list of communal hardware modules that are available for use by Crowd Bootstrap startups."
#define RES_SOFTWARE_TITLE                        @"Software"
#define RES_SOFTWARE_CONTENT                      @"Coming soon - A list of communal software modules that are available for use by Crowd Bootstrap startups."
#define RES_SERVICES_TITLE                        @"Services"
#define RES_SERVICES_CONTENT                      @"Coming soon - A list of communal services that are available for use by Crowd Bootstrap startups."
#define RES_AUDIOVIDEO_TITLE                      @"Audio Video"
#define RES_AUDIOVIDEO_CONTENT                    @"Coming soon - A list of communal audio and video resources that are available for use by Crowd Bootstrap startups."
#define RES_INFORMATION_TITLE                     @"Information"
#define RES_INFORMATION_CONTENT                   @"Coming soon - A list of communal information resources that are available for use by Crowd Bootstrap startups."
#define RES_PRODUCTIVITY_TITLE                    @"Productivity"
#define RES_PRODUCTIVITY_CONTENT                  @"Coming soon - A list of productivity tools that are recommended by Crowd Bootstrap experts."

#define EVENT_CONFERENCES_TITLE                   @"Conferences"
#define EVENT_CONFERENCES_CONTENT                 @"Coming soon - A list of upcoming Crowd Bootstrap conferences."
#define EVENT_DEMODAYS_TITLE                      @"Demo Days"
#define EVENT_DEMODAYS_CONTENT                    @"Coming soon - A list of upcoming Crowd Bootstrap Demo Days."
#define EVENT_MEETUPS_TITLE                       @"Meet Ups"
#define EVENT_MEETUPS_CONTENT                     @"Coming soon - A list of upcoming Crowd Bootstrap Meetups."
#define EVENT_WEBINARS_TITLE                      @"Webinars"
#define EVENT_WEBINARS_CONTENT                    @"Coming soon - A list of upcoming Crowd Bootstrap Webinars."

#define STARTUP_FUNDS_TITLE                       @"Funds"
#define STARTUP_FUNDS_CONTENT                     @"Coming soon – Each startup is assigned to a fund that has a specific focus."
#define MESSAGE_GROUPS_TITLE                      @"Groups"
#define MESSAGE_GROUPS_CONTENT                    @"Coming soon – Users can create and manage group discussions and group activities."


#endif /* Constants_h */
