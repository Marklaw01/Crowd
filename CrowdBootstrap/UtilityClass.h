//
//  UtilityClass.h
//  Loop_Recording
//
//  Created by OSX on 19/02/15.
//  Copyright (c) 2015 trantor.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CWStatusBarNotification.h"

@interface UtilityClass : NSObject

+(id)displayAlertMessage:(NSString*)messsage ;

#pragma mark - Color Codes
+(UIColor*)backgroundColor ;
+(UIColor*)textColor ;
+(UIColor*)greenColor ;
+(UIColor*)orangeColor ;
+(UIColor*)blueColor ;

#pragma mark - Notification Status Message
+(CWStatusBarNotification*)setUpNotification:(NSString*)type ;
+(void)showNotificationMessgae:(NSString*)message withResultType:(NSString*)type withDuration:(CGFloat)duration ;

#pragma mark - HUD methods
+(void)showHudWithTitle:(NSString *)title ;
+(BOOL)hideHud ;

#pragma mark - Check if come from Add/Edit Screen
#pragma mark Funds
+(BOOL)checkIsComingFrom_Funds_AddEditScreen;
+(void)setComingFrom_Funds_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Beta Tester
+(BOOL)checkIsComingFrom_BetaTester_AddEditScreen;
+(void)setComingFrom_BetaTester_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Board Member
+(BOOL)checkIsComingFrom_BoardMember_AddEditScreen;
+(void)setComingFrom_BoardMember_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Communal Asset
+(BOOL)checkIsComingFrom_CommunalAsset_AddEditScreen;
+(void)setComingFrom_CommunalAsset_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Consulting
+(BOOL)checkIsComingFrom_Consulting_AddEditScreen;
+(void)setComingFrom_Consulting_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Early Adopter
+(BOOL)checkIsComingFrom_EarlyAdopter_AddEditScreen;
+(void)setComingFrom_EarlyAdopter_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Endorsor
+(BOOL)checkIsComingFrom_Endorsor_AddEditScreen;
+(void)setComingFrom_Endorsor_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Focus Group
+(BOOL)checkIsComingFrom_FocusGroup_AddEditScreen;
+(void)setComingFrom_FocusGroup_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Hardware
+(BOOL)checkIsComingFrom_Hardware_AddEditScreen;
+(void)setComingFrom_Hardware_AddEditScreen:(BOOL)isFromAddEditScreen ;

#pragma mark Software
+(BOOL)checkIsComingFrom_Software_AddEditScreen;
+(void)setComingFrom_Software_AddEditScreen:(BOOL)isFromAddEditScreen ;

#pragma mark Services
+(BOOL)checkIsComingFrom_Service_AddEditScreen;
+(void)setComingFrom_Service_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Audio Video
+(BOOL)checkIsComingFrom_AudioVideo_AddEditScreen;
+(void)setComingFrom_AudioVideo_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Information
+(BOOL)checkIsComingFrom_Information_AddEditScreen;
+(void)setComingFrom_Information_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Productivity
+(BOOL)checkIsComingFrom_Productivity_AddEditScreen;
+(void)setComingFrom_Productivity_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Group
+(BOOL)checkIsComingFrom_Group_AddEditScreen;
+(void)setComingFrom_Group_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Webinar
+(BOOL)checkIsComingFrom_Webinar_AddEditScreen;
+(void)setComingFrom_Webinar_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Meet Up
+(BOOL)checkIsComingFrom_MeetUp_AddEditScreen;
+(void)setComingFrom_MeetUp_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Demo Day
+(BOOL)checkIsComingFrom_DemoDay_AddEditScreen;
+(void)setComingFrom_DemoDay_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Conference
+(BOOL)checkIsComingFrom_Conference_AddEditScreen;
+(void)setComingFrom_Conference_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Career Advancement
+(BOOL)checkIsComingFrom_Career_AddEditScreen;
+(void)setComingFrom_Career_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Self Improvement
+(BOOL)checkIsComingFrom_Improvement_AddEditScreen;
+(void)setComingFrom_Improvement_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Launch Deals
+(BOOL)checkIsComingFrom_LaunchDeal_AddEditScreen;
+(void)setComingFrom_LaunchDeal_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark Group Buying/Purchase Order
+(BOOL)checkIsComingFrom_PurchaseOrder_AddEditScreen;
+(void)setComingFrom_PurchaseOrder_AddEditScreen:(BOOL)isFromAddEditScreen;

#pragma mark - Device Token
+(void)setDeviceToken:(NSString *)token ;
+(NSString *)getDeviceToken ;

#pragma mark - Email Validation
+(BOOL) NSStringIsValidEmail:(NSString *)checkString ;

#pragma mark - Phone Validation
+(BOOL)NSStringIsValidPhone:(NSString *)checkString ;

#pragma mark - Password Validation
+(BOOL)NSStringIsValidPassword:(NSString *)checkString ;

#pragma mark - TextField Validation
+(BOOL)checkForAlphaNumericChar:(NSString*)checkString ;

+(NSString*)convertTagsArrayToStringforArray:(NSMutableArray*)array withTagsArray:(NSArray*)tagsArray ;
+(NSString*)formatDateFromString:(NSString*)dateTimeString ;
+(NSString*)formatTimeFromString:(NSString*)dateTimeString ;
+(NSString*)formatPhoneNumber:(NSString*)phone ;
+(NSString*)formatNumber:(NSString*)num ;
+(int)getPickerViewSelectedIndexFromArray:(NSArray*)array forID:(NSString*)selectedID ;

#pragma mark - Text Field Methods
+(void)setTextFieldBorder:(UITextField*)textField ;
+(void)setTextFieldValidationBorder:(UITextField*)textField ;
+(void)setButtonBorder:(UIButton*)button ;
+(void)setViewBorder:(UIView*)view ;
+(void)addMarginsOnTextField:(UITextField*)textField ;
+(void)addMarginsOnTextView:(UITextView*)textView ;

#pragma mark - Text View Methods
+(void)setTextViewBorder:(UITextView*)textView ;

#pragma mark - NSUser Defaults
//User type
+(NSInteger)GetUserType ;
+(void)setUserType:(int)userType ;

// check login
+(BOOL)checkLogInStatus ;
+(void)setLogInStatus:(BOOL)isLoggedIn;

+(int)getLoggedInUserQuickBloxID ;
+(void)setLoggedInUserQuickBloxID:(int)quickbloxID ;

+(NSString*)GetStartupViewMode ;
+(void)setStartupViewMode:(NSString*)startupViewType ;

//Add Campaign
+(BOOL)GetAddCampaignMode ;
+(void)setAddCampaignMode:(BOOL)isEditable ;

//Add Note
+(BOOL)GetAddNoteMode ;
+(void)setAddNoteMode:(BOOL)isEditable ;

//ChatUser Detail
+(NSString*)GetSelectedChatUserName;
+(void)setSelectedChatUserName:(NSString*)name ;

//Forum Type
+(BOOL)GetForumType ;
+(void)setForumType:(BOOL)isMyForum ;

// Profile Selected Popup
+(NSString*)GetPopupTypeName ;
+(void)setPopupTypeName:(NSString*)popupType ;

+(void)setTagsPopupData:(NSArray*)array ;
+(NSArray*)getTagsPopupData ;

+(void)setSelectedTagsPopupData:(NSArray*)array ;
+(NSArray*)getSelectedTagsPopupData ;

// Profile Selected Tags
+(NSMutableArray*)getSelectedTagsIndex ;
+(void)setSelectedTagsIndex:(NSMutableArray*)array;

#pragma mark - Check Internet Connection
+(BOOL)checkInternetConnection ;

#pragma mark - Settings Details
+(NSMutableDictionary*)getUserSettingDetails;
+(void)setUserSettingDetails:(NSMutableDictionary*)userDetailsDict;

#pragma mark - Login User Details
+(NSMutableDictionary*)getLoggedInUserDetails ;
+(void)setLoggedInUserDetails:(NSMutableDictionary*)userDetailsDict ;

+(int)getLoggedInUserID ;
+(void)setLoggedInUserID:(int)userID ;

//Update Selected Menu Title
+(NSString*)getSelectedMenuTitle;
+(void)setSelectedMenuTitle:(NSString*)title ;

#pragma mark - Profile User Details
+(NSMutableDictionary*)getUserProfileDetails ;
+(void)setUserProfileDetails:(NSMutableDictionary*)profileDetailsDict ;

#pragma mark - Profile Startups Details
+(NSMutableDictionary*)getProfileStartupsDetails ;
+(void)setProfileStartupsDetails:(NSMutableDictionary*)profileDetailsDict ;

#pragma mark - Profile Image Change
+(BOOL)getProfileImageChangedStatus ;
+(void)setProfileImageChangedStatus:(BOOL)isImageUpdated;

#pragma mark - Notification Settings
+(NSString*)getNotificationSettings ;
+(void)setNotificationSettings:(NSString*)isEnabled;

#pragma mark - Public Profile Settings
+(NSString*)getPublicProfileSettings;
+(void)setPublicProfileSettings:(NSString*)isEnabled;

#pragma mark - Beta Tester Settings
+(NSString*)getBetaTesterSettings;
+(void)setBetaTesterSettings:(NSString*)isEnabled;

#pragma mark - Board Member Settings
+(NSString*)getBoardMemberSettings;
+(void)setBoardMemberSettings:(NSString*)isEnabled;

#pragma mark - Communal Asset Settings
+(NSString*)getConsultingSettings;
+(void)setConsultingSettings:(NSString*)isEnabled;

#pragma mark - Early Adopter Settings
+(NSString*)getEarlyAdopterSettings;
+(void)setEarlyAdopterSettings:(NSString*)isEnabled;

#pragma mark - Endorser Settings
+(NSString*)getEndorserSettings;
+(void)setEndorserSettings:(NSString*)isEnabled;

#pragma mark - Focus Group Settings
+(NSString*)getFocusGroupSettings;
+(void)setFocusGroupSettings:(NSString*)isEnabled;

#pragma mark - Audio/Video Settings
+(NSString*)getAudioVideoUpdatesSettings;
+(void)setAudioVideoUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Beta Test Updates Settings
+(NSString*)getBetaTestUpdatesSettings;
+(void)setBetaTestUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Board Member Updates Settings
+(NSString*)getBoardMemberUpdatesSettings;
+(void)setBoardMemberUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Campaign Followed Updates Settings
+(NSString*)getCampaignFollowedUpdatesSettings;
+(void)setCampaignFollowedUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Campaign Committed Updates Settings
+(NSString*)getCampaignCommittedUpdatesSettings;
+(void)setCampaignCommittedUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Career Updates Settings
+(NSString*)getCareerUpdatesSettings;
+(void)setCareerUpdatesSettings:(NSString*)isEnabled ;

#pragma mark - Communal Asset Updates Settings
+(NSString*)getCommunalAssetUpdatesSettings;
+(void)setCommunalAssetUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Conference Updates Settings
+(NSString*)getConferenceUpdatesSettings;
+(void)setConferenceUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Connection Updates Settings
+(NSString*)getConnectionUpdatesSettings;
+(void)setConnectionUpdatesSettings:(NSString*)isEnabled ;

#pragma mark - Consulting Updates Settings
+(NSString*)getConsultingUpdatesSettings;
+(void)setConsultingUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Demo Day Updates Settings
+(NSString*)getDemoDayUpdatesSettings;
+(void)setDemoDayUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Early Edopter Updates Settings
+(NSString*)getEarlyAdopterUpdatesSettings;
+(void)setEarlyAdopterUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Endorsor Updates Settings
+(NSString*)getEndorsorUpdatesSettings;
+(void)setEndorsorUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Focus Group Updates Settings
+(NSString*)getFocusGroupUpdatesSettings;
+(void)setFocusGroupUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Forum Updates Settings
+(NSString*)getForumUpdatesSettings;
+(void)setForumUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Fund Updates Settings
+(NSString*)getFundUpdatesSettings;
+(void)setFundUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Group Updates Settings
+(NSString*)getGroupUpdatesSettings;
+(void)setGroupUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Group Buying Updates Settings
+(NSString*)getGroupBuyingUpdatesSettings;
+(void)setGroupBuyingUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Hardware Updates Settings
+(NSString*)getHardwareUpdatesSettings;
+(void)setHardwareUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Information Updates Settings
+(NSString*)getInformationUpdatesSettings;
+(void)setInformationUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Job Updates Settings
+(NSString*)getJobUpdatesSettings;
+(void)setJobUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Launch Deal Updates Settings
+(NSString*)getLaunchDealUpdatesSettings;
+(void)setLaunchDealUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Meetup Updates Settings
+(NSString*)getMeetupUpdatesSettings;
+(void)setMeetupUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Organization Updates Settings
+(NSString*)getOrganizationUpdatesSettings;
+(void)setOrganizationUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Productivity Updates Settings
+(NSString*)getProductivityUpdatesSettings;
+(void)setProductivityUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Self Improvement Updates Settings
+(NSString*)getSelfImprovementUpdatesSettings;
+(void)setSelfImprovementUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Service Updates Settings
+(NSString*)getServiceUpdatesSettings;
+(void)setServiceUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Software Updates Settings
+(NSString*)getSoftwareUpdatesSettings;
+(void)setSoftwareUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Startup Updates Settings
+(NSString*)getStartupUpdatesSettings;
+(void)setStartupUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Webinar Updates Settings
+(NSString*)getWebinarUpdatesSettings;
+(void)setWebinarUpdatesSettings:(NSString*)isEnabled;

#pragma mark - Campaign Detail
+(NSMutableDictionary*)getCampaignDetails ;
+(void)setCampaignDetails:(NSMutableDictionary*)campaignDict ;

#pragma mark - Campaign Mode Mode
+(BOOL)getCampaignMode ;
+(void)setCampaignMode:(BOOL)isMyCampaignMode ;

#pragma mark - Company Detail
+(NSMutableDictionary*)getCompanyDetails;
+(void)setCompanyDetails:(NSMutableDictionary*)companyDict;

#pragma mark - Job Detail
+(NSMutableDictionary*)getJobDetails;
+(void)setJobDetails:(NSMutableDictionary*)jobDict;

#pragma mark - Funds Detail
+(NSMutableDictionary*)getFundsDetails;
+(void)setFundsDetails:(NSMutableDictionary*)fundDict;

#pragma mark - Beta Tests Detail
+(NSMutableDictionary*)getBetaTestDetails;
+(void)setBetaTestDetails:(NSMutableDictionary*)betaTestDict;

#pragma mark - Board Member Detail
+(NSMutableDictionary*)getBoardMemberDetails;
+(void)setBoardMemberDetails:(NSMutableDictionary*)boardMemberDict;

#pragma mark - Communal Asset Detail
+(NSMutableDictionary*)getCommunalAssetDetails;
+(void)setCommunalAssetDetails:(NSMutableDictionary*)communalAssetDict;

#pragma mark - Consulting Detail
+(NSMutableDictionary*)getConsultingDetails;
+(void)setConsultingDetails:(NSMutableDictionary*)consultingDict;

#pragma mark - Early Adopter Detail
+(NSMutableDictionary*)getEarlyAdopterDetails;
+(void)setEarlyAdopterDetails:(NSMutableDictionary*)earlyAdopterDict;

#pragma mark - Endorsor Detail
+(NSMutableDictionary*)getEndorsorDetails;
+(void)setEndorsorDetails:(NSMutableDictionary*)endorsorDict;

#pragma mark - Focus Group Detail
+(NSMutableDictionary*)getFocusGroupDetails;
+(void)setFocusGroupDetails:(NSMutableDictionary*)focusGroupDict;

#pragma mark - Hardware Detail
+(NSMutableDictionary*)getHardwareDetails;
+(void)setHardwareDetails:(NSMutableDictionary*)hardwareDict;

#pragma mark - Software Detail
+(NSMutableDictionary*)getSoftwareDetails;
+(void)setSoftwareDetails:(NSMutableDictionary*)softwareDict;

#pragma mark - Service Detail
+(NSMutableDictionary*)getServiceDetails;
+(void)setServiceDetails:(NSMutableDictionary*)serviceDict;

#pragma mark - Audio Video Detail
+(NSMutableDictionary*)getAudioVideoDetails;
+(void)setAudioVideoDetails:(NSMutableDictionary*)audioVideoDict;

#pragma mark - Information Detail
+(NSMutableDictionary*)getInformationDetails;
+(void)setInformationDetails:(NSMutableDictionary*)informationDict;

#pragma mark - Productivity Detail
+(NSMutableDictionary*)getProductivityDetails;
+(void)setProductivityDetails:(NSMutableDictionary*)productivityDict;

#pragma mark - Group Detail
+(NSMutableDictionary*)getGroupDetails;
+(void)setGroupDetails:(NSMutableDictionary*)groupDict;

#pragma mark - Webinar Detail
+(NSMutableDictionary*)getWebinarDetails;
+(void)setWebinarDetails:(NSMutableDictionary*)webinarDict;

#pragma mark - Meet Up Detail
+(NSMutableDictionary*)getMeetUpDetails;
+(void)setMeetUpDetails:(NSMutableDictionary*)meetUpDict;

#pragma mark - Demo Day Detail
+(NSMutableDictionary*)getDemoDayDetails;
+(void)setDemoDayDetails:(NSMutableDictionary*)demoDayDict;

#pragma mark - Conference Detail
+(NSMutableDictionary*)getConferenceDetails;
+(void)setConferenceDetails:(NSMutableDictionary*)conferenceDict;

#pragma mark - Career Detail
+(NSMutableDictionary*)getCareerDetails;
+(void)setCareerDetails:(NSMutableDictionary*)careerDict;

#pragma mark - Improvement Tool Detail
+(NSMutableDictionary*)getImprovementToolDetails;
+(void)setImprovementToolDetails:(NSMutableDictionary*)improvementToolDict;

#pragma mark - Launch Deal Detail
+(NSMutableDictionary*)getLaunchDealDetails;
+(void)setLaunchDealDetails:(NSMutableDictionary*)launchDealDict;

#pragma mark - Group Buying/Purchase Order Detail
+(NSMutableDictionary*)getPurchaseOrderDetails;
+(void)setPurchaseOrderDetails:(NSMutableDictionary*)purchaseOrderDict;

#pragma mark - Startup Detail
+(NSMutableDictionary*)getStartupDetails ;
+(void)setStartupDetails:(NSMutableDictionary*)startupDict ;

#pragma mark - Startup Info Mode
+(BOOL)getStartupInfoMode ;
+(void)setStartupInfoMode:(BOOL)isSearchMode ;

#pragma mark - Startup Type
+(int)getStartupType ;
+(void)setStartupType:(int)type ;

#pragma mark - Search Contractors Mode
+(BOOL)getSearchContractorMode ;
+(void)setSearchContractorMode:(BOOL)isSearchMode ;

#pragma mark - Search Company Mode
+(BOOL)getSearchCompanyMode;
+(void)setSearchCompanyMode:(BOOL)isSearchMode;

#pragma mark - Profile Mode
+(NSInteger)getProfileMode ;
+(void)setProfileMode:(int)mode ;

#pragma mark - Contractor Detail
+(NSMutableDictionary*)getContractorDetails ;
+(void)setContractorDetails:(NSMutableDictionary*)dict ;

#pragma mark - Team Member Role
+(NSString*)getTeamMemberRole ;
+(void)setTeamMemberRole:(NSString*)roleID ;

#pragma mark - Forum Detail
+(NSMutableDictionary*)getForumDetails ;
+(void)setForumDetails:(NSMutableDictionary*)forumDict ;

#pragma mark - Startup WorkOrder Type
+(BOOL)getStartupWorkOrderType ;
+(void)setStartupWorkOrderType:(BOOL)isWorkOrderSelected ;

#pragma mark - Add Contractor Status
+(BOOL)getAddContractorStatus ;
+(void)setAdddContractorStatus:(BOOL)isContractorAdded ;

#pragma mark - View Ent Profile Mode
+(BOOL)getViewEntProfileMode ;
+(void)setViewEntProfileMode:(BOOL)isViewMode;

#pragma mark - Assign Work Units Mode
+(BOOL)getContAssignWorkUnitsMode ;
+(void)setContAssignWorkUnitsMode:(BOOL)isWorkUnitsMode ;

#pragma mark - Set Notification Icon on Nav Bar
+(void)setNotificationIconOnNavigationBar: (UIButton *)btnNotification lblNotificationCount:(UILabel *)lblCount navItem:(UINavigationItem *)navItem;

#pragma mark - Popup View
+(void)displayPopupWithContentView:(UIView*)contentView view:(UIView *)parentView;
@end
