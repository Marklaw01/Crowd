//
//  HomeViewController.m
//  CrowdBootstrap
//
//  Created by Shikha on 22/05/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

#pragma mark - View LifeCycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self addPushNotifications];
    
    [self loginWithQuickblox];
}

-(void)viewWillAppear:(BOOL)animated {
    [self revealViewSettings] ;
    [self navigationBarSettings] ;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void)addPushNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNotificationIconOnNavigationBar:)name:kNotificationIconOnNavigationBar
                                               object:nil];
}

-(void)revealViewSettings {
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    menuBarBtn.target = self.revealViewController;
    menuBarBtn.action = @selector(revealToggle:);
    
    // Set the gesture
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)navigationBarSettings {
    // [self.navigationController.navigationBar setHidden:NO];
    // self.navigationController.navigationItem.hidesBackButton = true;
    self.title = @"Home" ;
}

-(void)setNotificationIconOnNavigationBar:(NSNotification *) notification {
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"notifications"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navigateToNotification_Click:)forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblNotificationCount = [[UILabel alloc]init];
    
    [UtilityClass setNotificationIconOnNavigationBar:button
                                lblNotificationCount:lblNotificationCount navItem:self.navigationItem];
}

-(void)resetViewAccordingToSelectedSegment:(int)selectedSegment {
    // hide all views
    homeInfoView.hidden = YES ;
    feedsView.hidden = YES ;
    
    [homeInfoView endEditing:YES] ;
    [feedsView endEditing:YES] ;
    [segmentedControl setSelectedSegmentIndex:selectedSegment] ;
    
    switch (selectedSegment) {
            
        case FEEDS_SELECTED:{
            feedsView.hidden = NO ;
            break;
        }
        case INFO_SELECTED:{
            homeInfoView.hidden = NO ;
            break;
        }
        default:
            break;
    }
}

-(void)loginWithQuickblox {
    QBUUser *qbUser = [QBUUser user]  ;
    NSMutableDictionary *dic = [[UtilityClass getLoggedInUserDetails] mutableCopy];
    
    qbUser.email = [dic valueForKey:kLogInAPI_Email]; //emailTxtFld.text ;
    qbUser.password = [dic valueForKey:kLogInAPI_Password] ;
    //qbUser.password = passwordTxtFld.text ;
    [UtilityClass showHudWithTitle:kHUDMessage_LogIn] ;
    [ServicesManager.instance logInWithUser:qbUser completion:^(BOOL success, NSString *errorMessage) {
        if (success) {
            //__typeof(self) strongSelf = weakSelf;
            
            [UtilityClass hideHud] ;
            NSLog(@"Quickblox Login Successfull %lu",[QBSession currentSession].currentUser.ID) ;
//            [UtilityClass setUserType:CONTRACTOR] ;
//            [UtilityClass setLogInStatus:YES] ;
            
//            [UtilityClass setLoggedInUserID:[[responseDict valueForKey:@"user_id"] intValue]] ;
//            [UtilityClass setLoggedInUserQuickBloxID:[QBSession currentSession].currentUser.ID] ;
//            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[responseDict mutableCopy]] ;
//            [dict setValue:[responseDict valueForKey:kLogInAPI_Quickblox_Password] forKey:kLogInAPI_Password] ;
//            [UtilityClass setLoggedInUserDetails:[NSMutableDictionary dictionaryWithDictionary:dict]] ;
//            [UtilityClass setNotificationSettings:@"true"] ;
            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RevealView"] ;
//            [AppDelegate appDelegate].window.rootViewController = viewController ;
//            
//            //[self.navigationController pushViewController:viewController animated:YES] ;
//            [self presentViewController:viewController animated:YES completion:nil] ;
            
        } else {
            [UtilityClass hideHud] ;
            [self presentViewController:[UtilityClass displayAlertMessage:@"error"] animated:YES completion:nil] ;
        }
    }];
}

#pragma mark - IBAction Methods
- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)SegmentControl_ValueChanged:(id)sender {
    [self resetViewAccordingToSelectedSegment:(int)segmentedControl.selectedSegmentIndex] ;
}

@end
