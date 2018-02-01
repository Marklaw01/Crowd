//
//  AppDelegate.m
//  CrowdBootstrap
//
//  Created by OSX on 06/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "CDTestEntity.h"
#import "QMServicesManager.h"
#import <TWMessageBarManager/TWMessageBarManager.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <linkedin-sdk/LISDK.h>

// Live Quickblox Details
//const NSUInteger kApplicationID = 41172;
//NSString *const kAuthKey        = @"atp85LpFMSSk-My";
//NSString *const kAuthSecret     = @"xu5sSy6uPsf9BA5";
//NSString *const kAccountKey     = @"aNstpqyjBhYp2zTd4HFR";


// Staging Quickblox Details
//const NSUInteger kApplicationID = 32716;
//NSString *const kAuthKey        = @"GFZx5kekuYNsP7Z";
//NSString *const kAuthSecret     = @"mUJHuFX3m-uXu2x";
//NSString *const kAccountKey     = @"8RTz3Q7iLeGokw3MrzP5";

// Gagan Account Quickblox Details
//const NSUInteger kApplicationID = 67594;
//NSString *const kAuthKey        = @"aVE4hNYCmNYgOy3";
//NSString *const kAuthSecret     = @"PuLUxjKY7hfPqL7";
//NSString *const kAccountKey     = @"8RTz3Q7iLeGokw3MrzP5";

// Staging new Quickblox Details
const NSUInteger kApplicationID = 60018;
NSString *const kAuthKey        = @"nCM6zy5xEU4nT43";
NSString *const kAuthSecret     = @"bx6WyhWzRKDtspS";
NSString *const kAccountKey     = @"8RTz3Q7iLeGokw3MrzP5";

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Set QuickBlox credentials (You must create application in admin.quickblox.com)
    [QBSettings setApplicationID:kApplicationID];
    [QBSettings setAuthKey:kAuthKey];
    [QBSettings setAuthSecret:kAuthSecret];
    [QBSettings setAccountKey:kAccountKey];
    
    [QBSettings setAutoReconnectEnabled:YES];
    
    
//    [QBSettings setChatDNSLookupCacheEnabled:YES];
    
    // enabling carbons for chat
    [QBSettings setCarbonsEnabled:YES];
    
    // Enables Quickblox REST API calls debug console output
    [QBSettings setLogLevel:QBLogLevelNothing];
    
    // Enables detailed XMPP logging in console output
    [QBSettings enableXMPPLogging];
    
    // app was launched from push notification, handling it
    /*if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
     ServicesManager.instance.notificationService.pushDialogID = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey][kPushNotificationDialogIdentifierKey];
     }*/
    
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if([UtilityClass checkLogInStatus]){
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kRevealIdentifier] ;
        self.window.rootViewController = viewController ;
        
        [UtilityClass setStartupViewMode:ADD_STARTUP_TITLE] ;
        
        
        ServicesManager *servicesManager = [ServicesManager instance];
        
        if (servicesManager.currentUser != nil) {
            
           // NSLog(@"currentUser: %@",servicesManager.currentUser) ;
            // loggin in with previous user
            servicesManager.currentUser.password = [[UtilityClass getLoggedInUserDetails] valueForKey:kLogInAPI_Password];
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
            [servicesManager logInWithUser:servicesManager.currentUser completion:^(BOOL success, NSString *errorMessage) {
                if (success) {
                    
                    NSLog(@"Success") ;
                    [UtilityClass hideHud] ;
                } else {
                    
                    NSLog(@"Error: %@",errorMessage)  ;
                     [UtilityClass hideHud] ;
                }
            }];
        }
    }
    else {
        UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:kRootNavControllerIdentifier] ;
         self.window.rootViewController = navController ;
        [UtilityClass setNotificationSettings:@"true"] ;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    // other setup tasks here....
    [self startRemoteNotifications] ;
    
    [self checkInternetConnectivity] ;
    
    if (TARGET_OS_SIMULATOR)
        [UtilityClass setDeviceToken:kDefault_DeviceToken];
    
    [self initialCoreDataManager] ;
    
    [self addLocalNotifications] ;
    
    // Call Api Method to get Notification Count
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self
                                   selector:@selector(getNotificationCount) userInfo:nil repeats:YES];

    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
    
    return YES;
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event {
    
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            NSLog(@"AppDelegate PLAY remoteControlReceivedWithEvent");
            break;
        case UIEventSubtypeRemoteControlPause:
            NSLog(@"AppDelegate PAUSE UIEventSubtypeRemoteControlPause");
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            NSLog(@"AppDelegate NEXT UIEventSubtypeRemoteControlNextTrack");
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            NSLog(@"AppDelegate PREV UIEventSubtypeRemoteControlPreviousTrack");
            break;
        default:
            break;
    }
}

#pragma mark - Local Notifications
- (void)enableDisablePushNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotification_DisablePush]){
        NSLog(@"kNotification_DisablePush") ;
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    else if ([[notification name] isEqualToString:kNotification_EnablePush]){
        NSLog(@"kNotification_EnablePush") ;
        [self startRemoteNotifications] ;
    }
}

#pragma mark - Core Data Methods
- (void)initialCoreDataManager
{
    // initialize CoreData
    [CoreDataManager initSettingWithCoreDataName:@"CoreDataManager"
                                      sqliteName:@"CoreDataSqlite"];
    _coreDataManager = [CoreDataManager sharedInstance];
    
}

#pragma mark - Internet Connectivity
-(void)checkInternetConnectivity{
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    
    //Checking the Internet connection...
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
            UIAlertView *alertNetNotFound = [[UIAlertView alloc]initWithTitle:@"No Internet" message:kAlert_NoInternetConnection delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertNetNotFound show];
        }
    }];
}

#pragma mark - Custom Methods
-(void)startRemoteNotifications{
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

-(void)addLocalNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enableDisablePushNotification:)
                                                 name:kNotification_DisablePush
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enableDisablePushNotification:)
                                                 name:kNotification_EnablePush
                                               object:nil];
}

-(void)pushActionOnClick{
    if(self.selectedTag){
        if([self.selectedTag isEqualToString:TAG_MESSAGE]){
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotificationPush_Message
             object:self];
        }
        else if([self.selectedTag isEqualToString:TAG_COMMENT_FOURM]){
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotificationPush_CommentForum
             object:self];
        }
        else if([self.selectedTag isEqualToString:TAG_REPORT_ABUSE_FORUM]){
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotificationPush_ReportAbuse
             object:self];
        }
        else if([self.selectedTag isEqualToString:TAG_ADD_TEAM_MEMBER]){
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotificationPush_AddTeamMember
             object:self];
        }
        else if([self.selectedTag isEqualToString:TAG_COMMIT_CAMPAIGN]){
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotificationPush_CommitCampaign
             object:self];
        }
        else if([self.selectedTag isEqualToString:TAG_UNCOMMIT_CAMPAIGN]){
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotificationPush_UncommitCampaign
             object:self];
        }
        else if([self.selectedTag isEqualToString:TAG_FOLLOW_CAMPAIGN]){
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotificationPush_FollowCampaign
             object:self];
        }
        else if([self.selectedTag isEqualToString:TAG_UNFOLLOW_CAMPAIGN]) {
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotificationPush_UnfollowCampaign
             object:self];
        }
        else if([self.selectedTag isEqualToString:TAG_RATE_PROFILE]) {
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotificationPush_RateUser
             object:self];
        }
    }
}

#pragma mark - Remote Notfication Delegate Methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    NSString * deviceTokenString = [[[[devToken description]
                                      stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                     stringByReplacingOccurrencesOfString: @">" withString: @""]
                                    stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"the generated device token string is : %@",deviceTokenString);
    
    [UtilityClass setDeviceToken:deviceTokenString];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"Notification:%@",userInfo);
   // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // App is in UIApplicationStateActive (running in foreground)
    NSString *message = nil;
    id aps = [userInfo objectForKey:@"aps"];
    if ([aps isKindOfClass:[NSDictionary class]]) {
        id alert = [aps objectForKey:@"alert"];
        if ([alert isKindOfClass:[NSString class]]) {
            message = alert;
        }
        
        NSString *category = [NSString stringWithFormat:@"%@",[aps objectForKey:@"category"]] ;
        self.selectedTag = category ;
        
        if([category isEqualToString:TAG_ADD_TEAM_MEMBER]){
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)[aps objectForKey:@"values"]] ;
            [dict setValue:message forKey:@"message"] ;
            self.pushTagValueDict = [NSDictionary dictionaryWithDictionary:dict] ;
        }
        
        else if( [category isEqualToString:TAG_COMMENT_FOURM] || [category isEqualToString:TAG_REPORT_ABUSE_FORUM] || [category isEqualToString:TAG_COMMIT_CAMPAIGN] || [category isEqualToString:TAG_UNCOMMIT_CAMPAIGN] ){
            if([aps objectForKey:@"values"]){
                self.pushTagValueDict = [NSDictionary dictionaryWithDictionary:(NSDictionary*)[aps objectForKey:@"values"]] ;
                NSLog(@"pushTagValueDict: %@",self.pushTagValueDict) ;
            }
        }
        
        if (application.applicationState == UIApplicationStateActive && alert != nil) {
            // [UtilityClass showNotificationMessgae:alert withResultType:@"1" withDuration:2] ;
            
           /* UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
            [alertView show] ;*/
            
            [[TWMessageBarManager sharedInstance] hideAll];
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"" description:message type:TWMessageBarMessageTypeInfo];
            
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Notification"
                                                           description:message
                                                                  type:TWMessageBarMessageTypeInfo callback:^{
                                                                      NSLog(@"Message bar tapped!");
                                                                      [self pushActionOnClick] ;
                                                                  }];
        }
    }
    
   /* if ([application applicationState] != UIApplicationStateInactive){
        return;
    }
    
    NSString *dialogID = userInfo[kPushNotificationDialogIdentifierKey];
    if (dialogID == nil) {
        return;
    }
    
    NSString *dialogWithIDWasEntered = [ServicesManager instance].currentDialogID;
    if ([dialogWithIDWasEntered isEqualToString:dialogID]) return;
    
    ServicesManager.instance.notificationService.pushDialogID = dialogID;
    
    // calling dispatch async for push notification handling to have priority in main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        [ServicesManager.instance.notificationService handlePushNotificationWithDelegate:self];
    });*/
    
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification: (UILocalNotification *)notification {
    
   // [Utilities showAlertViewWithheading:nil message:@"Received Notification" alignLeft:FALSE];
}


/*-(void) checkInternetConnectivity {
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object:nil];
}

- (void) reachabilityChanged:(NSNotification *)note {
    
    NetworkStatus remoteHostStatus = [internetReach currentReachabilityStatus];
    
    if (remoteHostStatus == ReachableViaWiFi) { }
    else if(remoteHostStatus == NotReachable) {
        [Utilities showAlertViewWithheading:nil message:error_no_internet_connection alignLeft:FALSE];
    }
}*/

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    self.selectedTag = nil ;
    self.pushTagValueDict = nil ;
    
    
    application.applicationIconBadgeNumber = 0;
    
    // Logout from chat
    //
  /*  [[NSNotificationCenter defaultCenter]
     postNotificationName:kNotificationPush_QB_DisconnectChat
     object:self];*/

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    /*[[NSNotificationCenter defaultCenter]
     postNotificationName:kNotificationPush_QB_ConnectChat
     object:self];*/
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"applicationDidBecomeActive >> ") ;
    
    int userId = [UtilityClass getLoggedInUserID];
    
    if (userId > 0) {
        [self saveDeviceToken];
    }
    
    [self pushActionOnClick] ;
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Save Device Token
- (void)saveDeviceToken {
    if([UtilityClass checkInternetConnection]){
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupTeamAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[UtilityClass getDeviceToken]] forKey:kLogInAPI_AccessToken] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[UtilityClass getDeviceToken]] forKey:kLogInAPI_DeviceToken] ;
        [dictParam setObject:@"ios" forKey:kLogInAPI_DeviceType] ;
        
        NSLog(@"params: %@", dictParam);
        
        [ApiCrowdBootstrap saveDeviceTokenWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - NotificationServiceDelegate protocol

- (void)notificationServiceDidSucceedFetchingDialog:(QBChatDialog *)chatDialog {
   /* UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    
    ChatViewController *chatController = (ChatViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chatController.dialog = chatDialog;
    
    NSString *dialogWithIDWasEntered = [ServicesManager instance].currentDialogID;
    if (dialogWithIDWasEntered != nil) {
        // some chat already opened, return to dialogs view controller first
        [navigationController popViewControllerAnimated:NO];
    }
    
    [navigationController pushViewController:chatController animated:YES];*/
}

- (NSString *)getNotificationCount {
    NSString *strNotificationCount = [[NSString alloc] init];
    if([UtilityClass checkInternetConnection]){
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupTeamAPI_UserID] ;
        
        [ApiCrowdBootstrap getNotificationCountWithParameters:dictParam success:^(NSDictionary *responseDict) {
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                _strNotificationCount = [responseDict valueForKey:@"count"];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                NSLog(@"%@",[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]]);
                _strNotificationCount = @"";
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationIconOnNavigationBar object:_strNotificationCount];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
    
    return strNotificationCount;
}

- (BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([LISDKCallbackHandler shouldHandleUrl:url]) {
        return [LISDKCallbackHandler application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    else {
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        return handled;
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([LISDKCallbackHandler shouldHandleUrl:url]) {
        return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    else {
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
        return handled;
    }
    return YES;
}
@end
