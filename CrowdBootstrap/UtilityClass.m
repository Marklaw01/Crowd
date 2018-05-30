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
    NSString *specialCharacterString = @"!~`@#$%^&*-+();:={}[],.<>?\\/\"\'";
    BOOL lowerCaseLetter = 0;
    BOOL upperCaseLetter = 0;
    BOOL digit = 0;
    BOOL specialCharacter = 0;
    
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

#pragma mark - Check if come from Add/Edit Screen
#pragma mark Recruiter/Jobs
+(BOOL)checkIsComingFrom_Job_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_Job_AddEdit] ;
}

+(void)setComingFrom_Job_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_Job_AddEdit ];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Funds
+(BOOL)checkIsComingFrom_Funds_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_Funds_AddEdit] ;
}

+(void)setComingFrom_Funds_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_Funds_AddEdit ];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Beta Tester
+(BOOL)checkIsComingFrom_BetaTester_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_BetaTester_AddEdit] ;
}

+(void)setComingFrom_BetaTester_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_BetaTester_AddEdit ];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Board Member
+(BOOL)checkIsComingFrom_BoardMember_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_BoardMember_AddEdit] ;
}

+(void)setComingFrom_BoardMember_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_BoardMember_AddEdit ];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Communal Asset
+(BOOL)checkIsComingFrom_CommunalAsset_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_CommunalAsset_AddEdit] ;
}

+(void)setComingFrom_CommunalAsset_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_CommunalAsset_AddEdit ];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Consulting
+(BOOL)checkIsComingFrom_Consulting_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_Consulting_AddEdit] ;
}

+(void)setComingFrom_Consulting_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_Consulting_AddEdit ];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Early Adopter
+(BOOL)checkIsComingFrom_EarlyAdopter_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_EarlyAdopter_AddEdit] ;
}

+(void)setComingFrom_EarlyAdopter_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_EarlyAdopter_AddEdit ];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Endorsor
+(BOOL)checkIsComingFrom_Endorsor_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_Endorsor_AddEdit] ;
}

+(void)setComingFrom_Endorsor_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_Endorsor_AddEdit ];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Focus Group
+(BOOL)checkIsComingFrom_FocusGroup_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_FocusGroup_AddEdit] ;
}

+(void)setComingFrom_FocusGroup_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_FocusGroup_AddEdit ];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Hardware
+(BOOL)checkIsComingFrom_Hardware_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_Hardware_AddEdit] ;
}

+(void)setComingFrom_Hardware_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_Hardware_AddEdit];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Software
+(BOOL)checkIsComingFrom_Software_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_Software_AddEdit] ;
}

+(void)setComingFrom_Software_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_Software_AddEdit];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Services
+(BOOL)checkIsComingFrom_Service_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_Service_AddEdit] ;
}

+(void)setComingFrom_Service_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_Service_AddEdit];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Audio Video
+(BOOL)checkIsComingFrom_AudioVideo_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_AudioVideo_AddEdit] ;
}

+(void)setComingFrom_AudioVideo_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_AudioVideo_AddEdit];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Information
+(BOOL)checkIsComingFrom_Information_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_Information_AddEdit] ;
}

+(void)setComingFrom_Information_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_Information_AddEdit];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Productivity
+(BOOL)checkIsComingFrom_Productivity_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_Productivity_AddEdit] ;
}

+(void)setComingFrom_Productivity_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_Productivity_AddEdit];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Group
+(BOOL)checkIsComingFrom_Group_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_Group_AddEdit] ;
}

+(void)setComingFrom_Group_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_Group_AddEdit];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Webinar
+(BOOL)checkIsComingFrom_Webinar_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_Webinar_AddEdit] ;
}

+(void)setComingFrom_Webinar_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_Webinar_AddEdit];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Meet Up
+(BOOL)checkIsComingFrom_MeetUp_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_MeetUp_AddEdit] ;
}

+(void)setComingFrom_MeetUp_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_MeetUp_AddEdit];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Demo Day
+(BOOL)checkIsComingFrom_DemoDay_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_DemoDay_AddEdit] ;
}

+(void)setComingFrom_DemoDay_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_DemoDay_AddEdit];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Conference
+(BOOL)checkIsComingFrom_Conference_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_Conference_AddEdit] ;
}

+(void)setComingFrom_Conference_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_Conference_AddEdit];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Career Advancement
+(BOOL)checkIsComingFrom_Career_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_Career_AddEdit] ;
}

+(void)setComingFrom_Career_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_Career_AddEdit];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Self Improvement
+(BOOL)checkIsComingFrom_Improvement_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_Improvement_AddEdit] ;
}

+(void)setComingFrom_Improvement_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_Improvement_AddEdit];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}


#pragma mark Launch Deals
+(BOOL)checkIsComingFrom_LaunchDeal_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_LaunchDeal_AddEdit] ;
}

+(void)setComingFrom_LaunchDeal_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_LaunchDeal_AddEdit];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark Group Buying
+(BOOL)checkIsComingFrom_PurchaseOrder_AddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs boolForKey:kComeFrom_PurchaseOrder_AddEdit] ;
}

+(void)setComingFrom_PurchaseOrder_AddEditScreen:(BOOL)isFromAddEditScreen {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    [prefs setBool:isFromAddEditScreen forKey:kComeFrom_PurchaseOrder_AddEdit];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
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

+(void)setStartupViewMode:(NSString*)startupViewType {
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

#pragma mark - Settings Details
+(NSMutableDictionary*)getUserSettingDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSettingInfo];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setUserSettingDetails:(NSMutableDictionary*)userDetailsDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:userDetailsDict] forKey:kUserSettingInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

#pragma mark - Public Profile Settings
+(NSString*)getPublicProfileSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kPublicProfileSettings] ;
}

+(void)setPublicProfileSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kPublicProfileSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Beta Tester Settings
+(NSString*)getBetaTesterSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kBetaTesterSettings] ;
}

+(void)setBetaTesterSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kBetaTesterSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Board Member Settings
+(NSString*)getBoardMemberSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kBoardMemberSettings] ;
}

+(void)setBoardMemberSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kBoardMemberSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Consulting Settings
+(NSString*)getConsultingSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kConsultingSettings] ;
}

+(void)setConsultingSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kConsultingSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Early Adopter Settings
+(NSString*)getEarlyAdopterSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kEarlyAdopterSettings] ;
}

+(void)setEarlyAdopterSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kEarlyAdopterSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Endorser Settings
+(NSString*)getEndorserSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kEndorserSettings] ;
}

+(void)setEndorserSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kEndorserSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Focus Group Settings
+(NSString*)getFocusGroupSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kFocusGroupSettings] ;
}

+(void)setFocusGroupSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kFocusGroupSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Audio/Video Settings
+(NSString*)getAudioVideoUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kAudioVideoUpdateSettings] ;
}

+(void)setAudioVideoUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kAudioVideoUpdateSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Beta Test Updates Settings
+(NSString*)getBetaTestUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kBetaTestUpdatesSettings] ;
}

+(void)setBetaTestUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kBetaTestUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Board Member Updates Settings
+(NSString*)getBoardMemberUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kBoardMemberUpdatesSettings] ;
}

+(void)setBoardMemberUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kBoardMemberUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Campaign Followed Updates Settings
+(NSString*)getCampaignFollowedUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kCampaignFollowedUpdatesSettings] ;
}

+(void)setCampaignFollowedUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kCampaignFollowedUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Campaign Committed Updates Settings
+(NSString*)getCampaignCommittedUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kCampaignCommittedUpdatesSettings] ;
}

+(void)setCampaignCommittedUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kCampaignCommittedUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Career Updates Settings
+(NSString*)getCareerUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kCareerUpdatesSettings] ;
}

+(void)setCareerUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kCareerUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Communal Asset Updates Settings
+(NSString*)getCommunalAssetUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kCommunalAssetUpdatesSettings] ;
}

+(void)setCommunalAssetUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kCommunalAssetUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Conference Updates Settings
+(NSString*)getConferenceUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kConferenceUpdatesSettings] ;
}

+(void)setConferenceUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kConferenceUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Connection Updates Settings
+(NSString*)getConnectionUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kConnectionUpdatesSettings] ;
}

+(void)setConnectionUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kConnectionUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Consulting Updates Settings
+(NSString*)getConsultingUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kConsultingUpdatesSettings] ;
}

+(void)setConsultingUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kConsultingUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Demo Day Updates Settings
+(NSString*)getDemoDayUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kDemoDayUpdatesSettings] ;
}

+(void)setDemoDayUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kDemoDayUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Early Edopter Updates Settings
+(NSString*)getEarlyAdopterUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kEarlyAdopterUpdatesSettings] ;
}

+(void)setEarlyAdopterUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kEarlyAdopterUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Endorsor Updates Settings
+(NSString*)getEndorsorUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kEndorsorUpdatesSettings] ;
}

+(void)setEndorsorUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kEndorsorUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Focus Group Updates Settings
+(NSString*)getFocusGroupUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kFocusGroupUpdatesSettings] ;
}

+(void)setFocusGroupUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kFocusGroupUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Forum Updates Settings
+(NSString*)getForumUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kForumUpdatesSettings] ;
}

+(void)setForumUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kForumUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Fund Updates Settings
+(NSString*)getFundUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kFundUpdatesSettings] ;
}

+(void)setFundUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kFundUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Group Updates Settings
+(NSString*)getGroupUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kGroupUpdatesSettings] ;
}

+(void)setGroupUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kGroupUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Group Buying Updates Settings
+(NSString*)getGroupBuyingUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kGroupBuyingUpdatesSettings] ;
}

+(void)setGroupBuyingUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kGroupBuyingUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Hardware Updates Settings
+(NSString*)getHardwareUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kHardwareUpdatesSettings] ;
}

+(void)setHardwareUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kHardwareUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Information Updates Settings
+(NSString*)getInformationUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kInformationUpdatesSettings] ;
}

+(void)setInformationUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kInformationUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Job Updates Settings
+(NSString*)getJobUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kJobUpdatesSettings] ;
}

+(void)setJobUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kJobUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Launch Deal Updates Settings
+(NSString*)getLaunchDealUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kLaunchDealUpdatesSettings] ;
}

+(void)setLaunchDealUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kLaunchDealUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Meetup Updates Settings
+(NSString*)getMeetupUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kMeetupUpdatesSettings] ;
}

+(void)setMeetupUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kMeetupUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Organization Updates Settings
+(NSString*)getOrganizationUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kOrganizationUpdatesSettings] ;
}

+(void)setOrganizationUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kOrganizationUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Productivity Updates Settings
+(NSString*)getProductivityUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kProductivityUpdatesSettings] ;
}

+(void)setProductivityUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kProductivityUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Self Improvement Updates Settings
+(NSString*)getSelfImprovementUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kSelfImprovementUpdatesSettings] ;
}

+(void)setSelfImprovementUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kSelfImprovementUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Service Updates Settings
+(NSString*)getServiceUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kServiceUpdatesSettings] ;
}

+(void)setServiceUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kServiceUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Software Updates Settings
+(NSString*)getSoftwareUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kSoftwareUpdatesSettings] ;
}

+(void)setSoftwareUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kSoftwareUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Startup Updates Settings
+(NSString*)getStartupUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kStartupUpdatesSettings] ;
}

+(void)setStartupUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kStartupUpdatesSettings];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

#pragma mark - Webinar Updates Settings
+(NSString*)getWebinarUpdatesSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults] ;
    return [prefs valueForKey:kWebinarUpdatesSettings] ;
}

+(void)setWebinarUpdatesSettings:(NSString*)isEnabled {
    [[NSUserDefaults standardUserDefaults] setValue:isEnabled forKey:kWebinarUpdatesSettings];
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

#pragma mark - Funds Detail
+(NSMutableDictionary*)getFundsDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kFundsDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setFundsDetails:(NSMutableDictionary*)fundDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:fundDict] forKey:kFundsDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Beta Tests Detail
+(NSMutableDictionary*)getBetaTestDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kBetaTestsDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setBetaTestDetails:(NSMutableDictionary*)betaTestDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:betaTestDict] forKey:kBetaTestsDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Board Member Detail
+(NSMutableDictionary*)getBoardMemberDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kBoardMemberDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setBoardMemberDetails:(NSMutableDictionary*)boardMemberDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:boardMemberDict] forKey:kBoardMemberDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Communal Asset Detail
+(NSMutableDictionary*)getCommunalAssetDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCommunalAssetDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setCommunalAssetDetails:(NSMutableDictionary*)communalAssetDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:communalAssetDict] forKey:kCommunalAssetDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Consulting Detail
+(NSMutableDictionary*)getConsultingDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kConsultingDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setConsultingDetails:(NSMutableDictionary*)consultingDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:consultingDict] forKey:kConsultingDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Early Adopter Detail
+(NSMutableDictionary*)getEarlyAdopterDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kEarlyAdopterDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setEarlyAdopterDetails:(NSMutableDictionary*)earlyAdopterDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:earlyAdopterDict] forKey:kEarlyAdopterDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Endorsor Detail
+(NSMutableDictionary*)getEndorsorDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kEndorsorDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setEndorsorDetails:(NSMutableDictionary*)endorsorDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:endorsorDict] forKey:kEndorsorDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Focus Group Detail
+(NSMutableDictionary*)getFocusGroupDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kFocusGroupDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setFocusGroupDetails:(NSMutableDictionary*)focusGroupDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:focusGroupDict] forKey:kFocusGroupDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Hardware Detail
+(NSMutableDictionary*)getHardwareDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kHardwareDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setHardwareDetails:(NSMutableDictionary*)hardwareDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:hardwareDict] forKey:kHardwareDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Software Detail
+(NSMutableDictionary*)getSoftwareDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kSoftwareDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setSoftwareDetails:(NSMutableDictionary*)softwareDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:softwareDict] forKey:kSoftwareDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Service Detail
+(NSMutableDictionary*)getServiceDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kServiceDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setServiceDetails:(NSMutableDictionary*)serviceDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:serviceDict] forKey:kServiceDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Audio Video Detail
+(NSMutableDictionary*)getAudioVideoDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kAudioVideoDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setAudioVideoDetails:(NSMutableDictionary*)audioVideoDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:audioVideoDict] forKey:kAudioVideoDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Information Detail
+(NSMutableDictionary*)getInformationDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kInformationDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setInformationDetails:(NSMutableDictionary*)informationDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:informationDict] forKey:kInformationDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Productivity Detail
+(NSMutableDictionary*)getProductivityDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kProductivityDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setProductivityDetails:(NSMutableDictionary*)productivityDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:productivityDict] forKey:kProductivityDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Group Detail
+(NSMutableDictionary*)getGroupDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kGroupDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setGroupDetails:(NSMutableDictionary*)groupDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:groupDict] forKey:kGroupDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Webinar Detail
+(NSMutableDictionary*)getWebinarDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kWebinarDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setWebinarDetails:(NSMutableDictionary*)webinarDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:webinarDict] forKey:kWebinarDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Meet Up Detail
+(NSMutableDictionary*)getMeetUpDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kMeetUpDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setMeetUpDetails:(NSMutableDictionary*)meetUpDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:meetUpDict] forKey:kMeetUpDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Demo Day Detail
+(NSMutableDictionary*)getDemoDayDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kDemoDayDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setDemoDayDetails:(NSMutableDictionary*)demoDayDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:demoDayDict] forKey:kDemoDayDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Conference Detail
+(NSMutableDictionary*)getConferenceDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kConferenceDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setConferenceDetails:(NSMutableDictionary*)conferenceDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:conferenceDict] forKey:kConferenceDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Career Detail
+(NSMutableDictionary*)getCareerDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCareerDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setCareerDetails:(NSMutableDictionary*)careerDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:careerDict] forKey:kCareerDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Improvement Tool Detail
+(NSMutableDictionary*)getImprovementToolDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kImprovementToolDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setImprovementToolDetails:(NSMutableDictionary*)improvementToolDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:improvementToolDict] forKey:kImprovementToolDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Launch Deal Detail
+(NSMutableDictionary*)getLaunchDealDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kLaunchDealDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setLaunchDealDetails:(NSMutableDictionary*)launchDealDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:launchDealDict] forKey:kLaunchDealDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Group Buying/Purchase Order Detail
+(NSMutableDictionary*)getPurchaseOrderDetails {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kPurchaseOrderDetail];
    return [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

+(void)setPurchaseOrderDetails:(NSMutableDictionary*)purchaseOrderDict {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:purchaseOrderDict] forKey:kPurchaseOrderDetail];
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
