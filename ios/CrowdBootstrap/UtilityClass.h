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
