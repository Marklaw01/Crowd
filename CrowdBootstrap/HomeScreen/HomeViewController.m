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
    
    NSMutableDictionary *dic = [[UtilityClass getLoggedInUserDetails] mutableCopy];

    userId = [[dic valueForKey:@"user_id"] intValue];
    NSLog(@"User ID : %d", userId);
    if (userId == 0) {
        [segmentedControl setWidth:0.01 forSegmentAtIndex:2];
        [segmentedControl setTitle:@"Start" forSegmentAtIndex:3];
    } else {
        [self addPushNotifications];
        [self loginWithQuickblox];
    }
    
    if (_isComingFromStart)
        [self resetViewAccordingToSelectedSegment:self.selectedIndex];
    else
        [self resetViewAccordingToSelectedSegment:0];
}

-(void)viewWillAppear:(BOOL)animated {
    [self revealViewSettings] ;
    [self navigationBarSettings] ;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void)addPushNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNotificationIconOnNavigationBar:) name:kNotificationIconOnNavigationBar
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
    if (userId == 0) {
//        [self.navigationController.navigationBar setHidden:NO];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back_Icon"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction:)];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = nil;
    } 
    self.title = @"Home" ;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
}

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

-(void)setNotificationIconOnNavigationBar:(NSNotification *) notification {
    if (userId > 0) {
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"notifications"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(navigateToNotification_Click:)forControlEvents:UIControlEventTouchUpInside];
    
        UILabel *lblNotificationCount = [[UILabel alloc]init];
    
        [UtilityClass setNotificationIconOnNavigationBar:button
                                lblNotificationCount:lblNotificationCount navItem:self.navigationItem];
    }
}

-(void)resetViewAccordingToSelectedSegment:(int)selectedSegment {
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segmentedControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UISegmentedControl class]]] setNumberOfLines:0];

    // hide all views
    homeInfoView.hidden = YES ;
    feedsView.hidden = YES ;
    newsView.hidden = YES ;
    networkingOptionsView.hidden = YES ;
    startView.hidden = YES ;

    [homeInfoView endEditing:YES] ;
    [feedsView endEditing:YES] ;
    [newsView endEditing:YES] ;
    [networkingOptionsView endEditing:YES] ;
    [startView endEditing:YES] ;

    [segmentedControl setSelectedSegmentIndex:selectedSegment] ;
    
    switch (selectedSegment) {
            
        case HOME_INFO_SELECTED: {
            homeInfoView.hidden = NO ;
            break;
        }
        case NEWS_SELECTED: {
            newsView.hidden = NO ;
            break;
        }
        case ALERTS_SELECTED: {
            feedsView.hidden = NO ;
            break;
        }
        case NETWORKING_OPTIONS_SELECTED: {
            if (userId == 0) {
                startView.hidden = NO ;
            } else {
                networkingOptionsView.hidden = NO ;
            }
            break;
        }
        default:
            break;
    }
}

-(void)loginWithQuickblox {
    QBUUser *qbUser = [QBUUser user]  ;
    
    NSMutableDictionary *dic = [[UtilityClass getLoggedInUserDetails] mutableCopy];
    ServicesManager *servicesManager = [ServicesManager instance];
    
    qbUser.email = [dic valueForKey:kLogInAPI_Email]; //emailTxtFld.text ;
    qbUser.password = [dic valueForKey:kLogInAPI_Password] ;
    
    [servicesManager logInWithUser:qbUser completion:^(BOOL success, NSString *errorMessage) {
        if (success) {
            
            NSLog(@"Quickblox Login Successfull %lu",[QBSession currentSession].currentUser.ID) ;
            [UtilityClass setLoggedInUserQuickBloxID:[QBSession currentSession].currentUser.ID] ;
   
        } else {
            NSLog(@"error: %@", errorMessage);
//            [UtilityClass hideHud] ;
//            [self presentViewController:[UtilityClass displayAlertMessage:errorMessage] animated:YES completion:nil] ;
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
