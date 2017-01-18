//
//  UtilityClass.m
//  Loop_Recording
//
//  Created by OSX on 19/02/15.
//  Copyright (c) 2015 trantor.com. All rights reserved.
//

#import "UtilityClass.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"

@implementation UtilityClass


#pragma mark - Color Codes
+(UIColor*)backgroundColor {
    return [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1] ;
}

+(UIColor*)textColor {
    return [UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1] ;
}

+(UIColor*)greenColor {
    return [UIColor colorWithRed:5.0/255.0 green:106.0/255.0 blue:31.0/255.0 alpha:1] ;
}

+(UIColor*)orangeColor {
    return [UIColor colorWithRed:234.0/255.0 green:155.0/255.0 blue:53.0/255.0 alpha:1]  ;
}

+(UIColor*)blueColor {
    return [UIColor colorWithRed:3.0/255.0 green:55.0/255.0 blue:92.0/255.0 alpha:1] ;
}


+(id)displayAlertMessage:(NSString*)messsage
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:messsage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    return alertController ;
}


#pragma mark - TWMessage Bar Remote Notification
/*+(TWMessageBarManager*)setUpTWMessageBar {
    
}*/


#pragma mark - Notification Status Message
+(CWStatusBarNotification*)setUpNotification:(NSString*)type
{
    CWStatusBarNotification *notifications = [CWStatusBarNotification new] ;
    notifications.notificationLabelBackgroundColor = [UIColor darkGrayColor] ;
    notifications.notificationLabelTextColor = [UIColor whiteColor] ;
    notifications.notificationLabelHeight = 35 ;
    notifications.notificationLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:15] ;
    notifications.notificationAnimationInStyle = 0;
    notifications.notificationAnimationOutStyle = 0;
    notifications.notificationStyle = CWNotificationStyleStatusBarNotification ;
    
    return notifications ;
}

+(void)showNotificationMessgae:(NSString*)message withResultType:(NSString*)type withDuration:(CGFloat)duration
{
    CWStatusBarNotification *notifications = [self setUpNotification:type] ;
    [notifications displayNotificationWithMessage:message forDuration:duration] ;
}

#pragma mark - HUD methods
+(void)showHudWithTitle:(NSString *)title {
    [self hideHud];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kAPPDELEGATE.window animated:YES];
    hud.dimBackground = NO;
    hud.labelText = title;
}

+(BOOL)hideHud {
    return [MBProgressHUD hideHUDForView:kAPPDELEGATE.window animated:YES];
}

#pragma mark - Device Token
+ (void)setDeviceToken:(NSString *)token {
    [kUSERDEFAULTS setValue:token forKey:kUD_DeviceToken];
    [kUSERDEFAULTS synchronize];
}
+ (NSString *)getDeviceToken{
    NSString *token = (NSString *) [kUSERDEFAULTS valueForKey:kUD_DeviceToken];
    return token;
}

#pragma mark - Email Validation
+(BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - Phone Validation
+(BOOL)NSStringIsValidPhone:(NSString *)checkString {
    NSString *phoneRegex = @"^(\([0-9]{3}\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}$" ;
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:checkString];
}

#pragma mark - TextField Validation
+(BOOL)checkForAlphaNumericChar:(NSString*)checkString {
    NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
    NSRange range = [checkString rangeOfCharacterFromSet:alphaSet];
    return (range.location != NSNotFound) ;
}

#pragma mark - Password Validation
/*+(BOOL)NSStringIsValidPassword:(NSString *)checkString{
    
   // NSString *passwordRegex = @"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,25}$" ;
    NSString *passwordRegex = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*(_|[^\w])).+$" ;
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:checkString];
}*/


+(BOOL)NSStringIsValidPassword:(NSString *)checkString{
    int numberofCharacters = 0;
    NSString *specialCharacterString = @"!~`@#$%^&*-+();:={}[],.<>?\\/\"\'";
    BOOL lowerCaseLetter,upperCaseLetter,digit,specialCharacter = 0;
    if([checkString length] >= 8)
    {
        for (int i = 0; i < [checkString length]; i++)
        {
            unichar c = [checkString characterAtIndex:i];
            if(!lowerCaseLetter)
            {
                lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!upperCaseLetter)
            {
                upperCaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!digit)
            {
                digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
        }
        if(!specialCharacter)
        {
            NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacterString] ;
            specialCharacter = [checkString.lowercaseString rangeOfCharacterFromSet:specialCharacterSet].length ;
        }
        if(specialCharacter && digit && lowerCaseLetter && upperCaseLetter) return YES ;
        
        else  return NO ;
        
    }
    else  return NO ;
   
    return NO ;
}

+(NSString*)convertTagsArrayToStringforArray:(NSMutableArray*)array withTagsArray:(NSArray*)tagsArray {
    NSString *tagsStr = @"" ;
    BOOL isFirstTag = YES ;
    for (NSDictionary *dict in tagsArray) {
        NSString *value = [dict valueForKey:@"name"] ;
        for (NSString *tag in array) {
            if([tag isEqualToString:value]) {
                if(isFirstTag) tagsStr = [dict valueForKey:@"id"] ;
                else tagsStr = [NSString stringWithFormat:@"%@,%@",tagsStr,[dict valueForKey:@"id"]] ;
                isFirstTag = NO ;
            }
        }
    }
    return tagsStr ;
}

+(NSString*)formatDateFromString:(NSString*)dateTimeString {
    NSString *dateStr  = @"" ;
    NSRange range = [dateTimeString rangeOfString:@"T"];
    if (range.location != NSNotFound)
    {
        NSArray *dateArray = [dateTimeString componentsSeparatedByString:@"T"] ;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@",[dateArray objectAtIndex:0]]] ;
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"MMM dd, yyyy"];
        return [formatter2 stringFromDate:date];
    }
    return dateStr ;
}

+(NSString*)formatTimeFromString:(NSString*)dateTimeString {
    NSString *timeStr  = @"" ;
    NSRange range = [dateTimeString rangeOfString:@"T"];
    if (range.location != NSNotFound)
    {
        NSArray *dateArray = [dateTimeString componentsSeparatedByString:@"T"] ;
        if(dateArray.count >1){
             NSString *str = [dateArray objectAtIndex:1] ;
             NSRange range2 = [str rangeOfString:@"+"];
            if (range2.location != NSNotFound){
                NSArray *timeArray = [str componentsSeparatedByString:@"+"] ;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"hh:mm:ss"];
                NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@",[timeArray objectAtIndex:0]]] ;
                NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
                [formatter2 setDateFormat:@"hh:mm a"];
                return [formatter2 stringFromDate:date];
            }
        }
    }
    return timeStr ;
}

+(NSString*)formatPhoneNumber:(NSString*)phone {
    NSString *phoneNumber = @"";
    NSRange range = [phone rangeOfString:@"1("];
    if (range.location != NSNotFound)
    {
        phone = [phone substringFromIndex:1] ;
        
    }
    return phoneNumber ;
}

+(NSString*)formatNumber:(NSString*)num {
    NSString *formattedStr = @"" ;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    [formatter setGroupingSeparator:@","] ;
    [formatter setGroupingSize:3] ;
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    
    float floatNum = [num floatValue] ;
    if(floatNum){
        formattedStr = [formatter stringFromNumber:[NSNumber numberWithFloat:floatNum]] ;
    }
    
    return formattedStr ;
}

+(int)getPickerViewSelectedIndexFromArray:(NSArray*)array forID:(NSString*)selectedID {
    int index = -1 ;
    for (int i=0 ; i<array.count ; i++) {
        if([[[array objectAtIndex:i] objectForKey:@"id"] intValue] == [selectedID intValue]){
            return i ;
        }
    }
    return index ;
}

#pragma mark - Text Field Methods
+(void)setTextFieldBorder:(UITextField*)textField
{
    textField.layer.borderColor=[[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
    textField.layer.borderWidth=1.0;
}

+(void)setTextFieldValidationBorder:(UITextField*)textField{
    textField.layer.borderColor=[[UIColor redColor]CGColor];
    textField.layer.borderWidth=1.0;
}

+(void)addMarginsOnTextField:(UITextField*)textField
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 10, textField.frame.size.height)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways ;
    textField.rightView = paddingView;
    textField.rightViewMode = UITextFieldViewModeAlways ;
}

+(void)addMarginsOnTextView:(UITextView*)textView {
    textView.contentInset = UIEdgeInsetsMake(0,7,0,10);
}

+(void)setButtonBorder:(UIButton*)button
{
    button.layer.borderColor=[[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
    button.layer.borderWidth=1.0;
}

+(void)setViewBorder:(UIView*)view
{
    view.layer.borderColor=[[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
    view.layer.borderWidth=1.0;
}

#pragma mark - Text View Methods
+(void)setTextViewBorder:(UITextView*)textView
{
    textView.layer.borderColor=[[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
    textView.layer.borderWidth=1.0;
}

#pragma mark - NSUser Defaults
+(NSInteger)GetUserType {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs integerForKey:kUserType] ;
}

+(void)setUserType:(int)userType {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setInteger:userType forKey:kUserType] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

+(BOOL)checkLogInStatus {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:LOGGED_IN] ;
}

+(void)setLogInStatus:(BOOL)isLoggedIn {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isLoggedIn forKey:LOGGED_IN ];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

+(NSString*)GetStartupViewMode {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:STARTUP_VIEW_MODE] ;
}

+(void)setStartupViewMode:(NSString*)startupViewType{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setValue:startupViewType forKey:STARTUP_VIEW_MODE] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

//Add Campaign
+(BOOL)GetAddCampaignMode {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:ADD_CAMPAIGN_MODE] ;
}

+(void)setAddCampaignMode:(BOOL)isEditable {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isEditable forKey:ADD_CAMPAIGN_MODE] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

//Add Note
+(BOOL)GetAddNoteMode {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:ADD_NOTES_MODE] ;
}

+(void)setAddNoteMode:(BOOL)isEditable {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isEditable forKey:ADD_NOTES_MODE] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}


//ChatUser Detail
+(NSString*)GetSelectedChatUserName {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:CHAT_USER_SELECTED_NAME] ;
}

+(void)setSelectedChatUserName:(NSString*)name {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setValue:name forKey:CHAT_USER_SELECTED_NAME] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

//Forum Type
+(BOOL)GetForumType {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:FORUM_TYPE] ;
}

+(void)setForumType:(BOOL)isMyForum {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isMyForum forKey:FORUM_TYPE];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

// Profile Selected Popup
+(NSString*)GetPopupTypeName {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return[prefs valueForKey:PROFILE_POPUP_NAME] ;
}

+(void)setPopupTypeName:(NSString*)popupType {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setValue:popupType forKey:PROFILE_POPUP_NAME] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

+(void)setTagsPopupData:(NSArray*)array {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setValue:array forKey:PROFILE_POPUP_ARRAY] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}
+(NSArray*)getTagsPopupData {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return[prefs valueForKey:PROFILE_POPUP_ARRAY] ;
}

+(void)setSelectedTagsPopupData:(NSArray*)array {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setValue:array forKey:PROFILE_POPUP_SELECTED_ARRAY] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}
+(NSArray*)getSelectedTagsPopupData {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return[prefs valueForKey:PROFILE_POPUP_SELECTED_ARRAY] ;
}

// Profile Selected Tags
+(NSMutableArray*)getSelectedTagsIndex {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return[prefs objectForKey:PROFILE_SELECTED_TAGS_INDEX] ;
}

+(void)setSelectedTagsIndex:(NSMutableArray*)array {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setObject:array forKey:PROFILE_SELECTED_TAGS_INDEX] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Check Internet Connection
+(BOOL)checkInternetConnection {
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alertNetNotFound = [[UIAlertView alloc]initWithTitle:@"No Internet" message:kAlert_NoInternetConnection delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertNetNotFound show];
        
        return NO ;
    }
    else return YES ;
}

#pragma mark - Login User Details
+(NSMutableDictionary*)getLoggedInUserDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kLoggedInUserInfo];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setLoggedInUserDetails:(NSMutableDictionary*)userDetailsDict{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:userDetailsDict] forKey:kLoggedInUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)getLoggedInUserID {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return (int)[prefs integerForKey:kLoggedInUserID] ;
}

+(void)setLoggedInUserID:(int)userID {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setInteger:(int)userID forKey:kLoggedInUserID] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

+(int)getLoggedInUserQuickBloxID {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return (int)[prefs integerForKey:kLoggedInUserQuickbloxID] ;
}

+(void)setLoggedInUserQuickBloxID:(int)quickbloxID {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setInteger:(int)quickbloxID forKey:kLoggedInUserQuickbloxID] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

//Update Selected Menu Title
+(NSString*)getSelectedMenuTitle {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return[prefs valueForKey:@"MenuTitle"] ;
}

+(void)setSelectedMenuTitle:(NSString*)title {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
   [prefs setValue:title forKey:@"MenuTitle"] ;
   [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Profile User Details
+(NSMutableDictionary*)getUserProfileDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserProfileInfo];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setUserProfileDetails:(NSMutableDictionary*)profileDetailsDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:profileDetailsDict] forKey:kUserProfileInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Profile Startups Details
+(NSMutableDictionary*)getProfileStartupsDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kProfileStartupInfo];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setProfileStartupsDetails:(NSMutableDictionary*)profileDetailsDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:profileDetailsDict] forKey:kProfileStartupInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Profile Image Change
+(BOOL)getProfileImageChangedStatus {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kProfileImageUpdate] ;
}

+(void)setProfileImageChangedStatus:(BOOL)isImageUpdated {
    [[NSUserDefaults standardUserDefaults] setBool:isImageUpdated forKey:kProfileImageUpdate];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Notifications Settings
+(NSString*)getNotificationSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kNotificationSettings] ;
}

+(void)setNotificationSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kNotificationSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Campaign Detail
+(NSMutableDictionary*)getCampaignDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCampaignDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setCampaignDetails:(NSMutableDictionary*)campaignDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:campaignDict] forKey:kCampaignDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Campaign Mode
+(BOOL)getCampaignMode {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kCampaignMode] ;
}

+(void)setCampaignMode:(BOOL)isMyCampaignMode {
    [[NSUserDefaults standardUserDefaults] setBool:isMyCampaignMode forKey:kCampaignMode];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Company Detail
+(NSMutableDictionary*)getCompanyDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCompanyDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setCompanyDetails:(NSMutableDictionary*)companyDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:companyDict] forKey:kCompanyDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Job Detail
+(NSMutableDictionary*)getJobDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kJobDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setJobDetails:(NSMutableDictionary*)jobDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:jobDict] forKey:kJobDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Startup Detail
+(NSMutableDictionary*)getStartupDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kStartupDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setStartupDetails:(NSMutableDictionary*)startupDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:startupDict] forKey:kStartupDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Startup Info Mode
+(BOOL)getStartupInfoMode {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kStartupInfoMode] ;
}

+(void)setStartupInfoMode:(BOOL)isSearchMode {
    [[NSUserDefaults standardUserDefaults] setBool:isSearchMode forKey:kStartupInfoMode];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Startup Type
+(int)getStartupType {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return (int)[prefs integerForKey:kStartupType] ;
}

+(void)setStartupType:(int)type {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setInteger:(int)type forKey:kStartupType] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Search Contractors Mode
+(BOOL)getSearchContractorMode {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kSearchContractorMode] ;
}

+(void)setSearchContractorMode:(BOOL)isSearchMode {
    [[NSUserDefaults standardUserDefaults] setBool:isSearchMode forKey:kSearchContractorMode];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Search Company Mode
+(BOOL)getSearchCompanyMode {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kSearchCompanyMode] ;
}

+(void)setSearchCompanyMode:(BOOL)isSearchMode {
    [[NSUserDefaults standardUserDefaults] setBool:isSearchMode forKey:kSearchCompanyMode];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Profile Mode
+(NSInteger)getProfileMode {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs integerForKey:kUserDefault_ProfileMode] ;
}

+(void)setProfileMode:(int)mode {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setInteger:mode forKey:kUserDefault_ProfileMode] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Contractor Detail
+(NSMutableDictionary*)getContractorDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefault_ContractorDetails];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setContractorDetails:(NSMutableDictionary*)dict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:dict] forKey:kUserDefault_ContractorDetails];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Team Member Role
+(NSString*)getTeamMemberRole {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kUserDefault_TeamMemberRole] ;
}

+(void)setTeamMemberRole:(NSString*)role {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setValue:role forKey:kUserDefault_TeamMemberRole] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Forum Detail
+(NSMutableDictionary*)getForumDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kForumDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setForumDetails:(NSMutableDictionary*)forumDict{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:forumDict] forKey:kForumDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Startup WorkOrder Type
+(BOOL)getStartupWorkOrderType {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kStartupWorkOrder] ;
}

+(void)setStartupWorkOrderType:(BOOL)isWorkOrderSelected {
    [[NSUserDefaults standardUserDefaults] setBool:isWorkOrderSelected forKey:kStartupWorkOrder];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Add Contractor Statusm
+(BOOL)getAddContractorStatus {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kAddContractorStatus] ;
}

+(void)setAdddContractorStatus:(BOOL)isContractorAdded {
    [[NSUserDefaults standardUserDefaults] setBool:isContractorAdded forKey:kAddContractorStatus];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - View Ent Profile Mode
+(BOOL)getViewEntProfileMode {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kViewEntProfileMode] ;
}

+(void)setViewEntProfileMode:(BOOL)isViewMode {
    [[NSUserDefaults standardUserDefaults] setBool:isViewMode forKey:kViewEntProfileMode];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Assign Work Units Mode
+(BOOL)getContAssignWorkUnitsMode {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kContWorkUnitsMode] ;
}

+(void)setContAssignWorkUnitsMode:(BOOL)isWorkUnitsMode {
    [[NSUserDefaults standardUserDefaults] setBool:isWorkUnitsMode forKey:kContWorkUnitsMode];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

+(void)setNotificationIconOnNavigationBar: (UIButton *)btnNotification lblNotificationCount:(UILabel *)lblCount navItem:(UINavigationItem *)navItem {
    
//    NSLog(@"Noti Count: %@",[AppDelegate appDelegate].strNotificationCount);
    // Set Notification Icon frame
    [btnNotification setFrame:CGRectMake(0, 0, 22, 26)];
    // Set Notification Count Font with Text
    [lblCount setFont:[UIFont fontWithName:@"Helvetica Neue" size:7]];
    lblCount.text = [NSString stringWithFormat:@"%@",[AppDelegate appDelegate].strNotificationCount];
    
    // Set Notification Count frame
    CGFloat lblWidth = lblCount.intrinsicContentSize.width;
    CGFloat lblHeight = lblCount.intrinsicContentSize.height;
    lblCount.frame = CGRectMake(12, 0, lblWidth+3, lblHeight+2);
    
    // Set Label Count's Layout
    lblCount.layer.masksToBounds = YES;
    lblCount.layer.cornerRadius = 3.0;
    [lblCount setTextAlignment:NSTextAlignmentCenter];
    [lblCount setTextColor:[UIColor blackColor]];
    
    [lblCount setBackgroundColor:[UIColor greenColor]];
    
    if ([[NSString stringWithFormat:@"%@",[AppDelegate appDelegate].strNotificationCount] isEqualToString: @""]) {
        lblCount.hidden = true;
    } else {
        lblCount.hidden = false;
    }

    [btnNotification addSubview:lblCount];

    // Add Navigation Right Bar Button as Notification Button
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btnNotification];
    navItem.rightBarButtonItem = barButton;
}

#pragma mark - Popup View
+(void)displayPopupWithContentView:(UIView*)contentView view:(UIView *)parentView {
    
    contentView.frame = CGRectMake(15.0, 0.0, parentView.frame.size.width-30, parentView.frame.size.height-20);
    parentView.backgroundColor = [UtilityClass backgroundColor];
    contentView.layer.cornerRadius = 12.0;
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        [parentView addSubview:contentView];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                contentView.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

@end
