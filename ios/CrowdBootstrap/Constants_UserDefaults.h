//
//  Constants_UserDefaults.h
//  CrowdBootstrap
//
//  Created by OSX on 22/03/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#ifndef Constants_UserDefaults_h
#define Constants_UserDefaults_h


#endif /* Constants_UserDefaults_h */
#define kUD_DeviceToken                           @"DEVICE_TOKEN"
#define kUserType                                 @"UserType"
#define LOGGED_IN                                 @"isLoggedIn"
#define STARTUP_VIEW_MODE                         @"StartupViewMode"
#define FORUM_TYPE                                @"ForumType"
#define CAMPAIGN_SELECTED_INDEX                   @"CampaignSelectedIndex"
#define STARTUP_SELECTED_INDEX                    @"StartupSelectedIndex"
#define NOTE_STARTUP_SELECTED_INDEX               @"NoteStartupSelectedIndex"
#define FORUM_SELECTED_NAME                       @"ForumSelectedName"
#define PROFILE_POPUP_NAME                        @"ProfilePopupArray"
#define PROFILE_POPUP_ARRAY                       @"ProfilePopupName"
#define PROFILE_POPUP_SELECTED_ARRAY              @"ProfilePopupSelectedArray"
#define PROFILE_SELECTED_TAGS_INDEX               @"ProfileSelectedTagsIndex"
#define NOTE_SELECTED_INDEX                       @"NoteSelectedIndex"
#define CHAT_USER_SELECTED_NAME                   @"ChatUsereSelectedName"
#define ADD_CAMPAIGN_MODE                         @"AddCampaignMode"
#define ADD_NOTES_MODE                            @"AddNotesMode"
#define STARTUP_DETAIL_MODE                       @"StartupDetailMode"
#define kProfileImageUpdate                       @"ProfileImageUpdate"
#define kStartupInfoMode                          @"StartupInfoMode"
#define kSearchContractorMode                     @"SearchContractorMode"
#define kSearchCompanyMode                        @"SearchCompanyMode"
#define kLoggedInUserInfo                         @"loggedInUserInfo"
#define kLoggedInUserID                           @"loggedInUserID"
#define kLoggedInUserQuickbloxID                  @"loggedInUserQuickbloxID"
#define kUserProfileInfo                          @"userProfileInfo"
#define kProfileStartupInfo                       @"profileStartupsInfo"
#define kNotificationSettings                     @"NotificationSettings"
#define kCampaignDetail                           @"CampaignDetail"
#define kCompanyDetail                            @"CompanyDetail"
#define kJobDetail                                @"JobDetail"
#define kStartupDetail                            @"StartupDetail"
#define kUserDefault_ProfileMode                  @"ProfileMode"
#define kUserDefault_ContractorDetails            @"ContractorDetails"
#define kUserDefault_TeamMemberRole               @"TeamMemberRole"
#define kForumDetail                              @"ForumDetail"
#define kCampaignMode                             @"CampaignMode"
#define kStartupType                              @"StartupType"
#define kStartupWorkOrder                         @"StartupWorkOrder"
#define kAddContractorStatus                      @"AddContractorStatus"
#define kViewEntProfileMode                       @"ViewEntProfileMode"
#define kContWorkUnitsMode                        @"ContWorkUnitsMode"


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPAD_PRO (IS_IPAD && SCREEN_MAX_LENGTH == 1366.0)
