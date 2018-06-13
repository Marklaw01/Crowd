//
//  GettingStartedViewController.m
//  CrowdBootstrap
//
//  Created by osx on 05/01/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "GettingStartedViewController.h"
#import "YTVideoViewViewController.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"

#define kEntrepreneurDesc @"If you are an Entrepreneur, click the menu option in the top left corner of the screen then select 'My Profile' to create your 'Entrepreneur' profile. Then select the 'Startup' option on the menu to submit your startup application and create a startup profile."

#define kExpertDesc @"If you are an Expert, click the menu option in the top left corner of the screen then select 'My Profile' to create your 'Contractor' profile. Then select the 'Contractors' option on the menu to start helping innovative startups."

#define kRecruiterDesc @"If you are a Recruiter, click the menu option in the top left corner of the screen then select 'My Profile' to create a profile. Then select the 'Opportunities' option on the menu to submit your job posting or search for job candidates whose job performance has been rated and validated by entrepreneurs."

#define kOrganizationDesc @"If you are an Organization, click the menu option in the top left corner of the screen then select the 'Organization' option. You can create a organization page to explain your offerings. You can also sponsor events or even sponsor your own accelerator to access innovative startups in your industry."


@interface GettingStartedViewController ()
{
    int userId;
}
@end

@implementation GettingStartedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self revealViewSettings];
    NSMutableDictionary *dic = [[UtilityClass getLoggedInUserDetails] mutableCopy];
    userId = [[dic valueForKey:@"user_id"] intValue];
    if (userId > 0) {
        [self saveDeviceToken];
        [segmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [segmentedControl setAlpha:1];
        constraintLogoTop.constant = 55;
    }
    else {
        constraintLogoTop.constant = 10;
        [segmentedControl setAlpha:0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)revealViewSettings {
    menuBarBtn.target = self.revealViewController;
    menuBarBtn.action = @selector(revealToggle:);
    
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
}

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content {
    self.title = viewTitle ;
}

#pragma mark - IBActions
- (IBAction)SegmentControl_ValueChanged:(id)sender {
    index = (int)segmentedControl.selectedSegmentIndex; //[NSNumber numberWithUnsignedInteger:segmentedControl.selectedSegmentIndex];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kHomeIdentifer] ;
    viewController.isComingFromStart = YES;
    viewController.selectedIndex = index;

    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)btnEntrepreneur_ClickAction:(id)sender {
    [self hideShowDescPopUp:kEntrepreneurDesc];
}

- (IBAction)btnExpert_ClickAction:(id)sender {
    [self hideShowDescPopUp:kExpertDesc];
}

- (IBAction)btnRecruiter_ClickAction:(id)sender {
    [self hideShowDescPopUp:kRecruiterDesc];
}

- (IBAction)btnSponsor_ClickAction:(id)sender {
    [self hideShowDescPopUp:kOrganizationDesc];
}

- (IBAction)btnHome_ClickAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kHomeIdentifer] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)btnGettingStarted_ClickAction:(id)sender {
    if (userId > 0) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YTVideoViewViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:kVideoViewIdentifier];

        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers: @[rootViewController] animated: NO];
        [rootViewController.view setUserInteractionEnabled:YES];
        [rootViewController refreshUIContentWithTitle:GETTING_STARTED_VIDEO_TITLE withContent:GETTING_STARTED_VIDEO_LINK] ;

        [self.revealViewController setFrontViewController:navController];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
    else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YTVideoViewViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kVideoViewIdentifier] ;
        [viewController.view setUserInteractionEnabled:YES];

        [viewController refreshUIContentWithTitle:GETTING_STARTED_VIDEO_TITLE withContent:GETTING_STARTED_VIDEO_LINK] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
}

- (IBAction)closePopUp_ClickAction:(id)sender {
    vwPopUp.hidden = true;
}

- (void)hideShowDescPopUp:(NSString *)strDesc {
    vwPopUp.hidden = false;
    txtViewDesc.text = strDesc;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
 
    if ([[segue identifier] isEqualToString:@"HomeVC"]) {
        HomeViewController *destViewcontroller = [segue destinationViewController];
        destViewcontroller.isComingFromStart = YES;
        destViewcontroller.selectedIndex = (int)index;
    }
}

- (void)saveDeviceToken {
    if([UtilityClass checkInternetConnection]) {
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupTeamAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[UtilityClass getDeviceToken]] forKey:kLogInAPI_AccessToken] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[UtilityClass getDeviceToken]] forKey:kLogInAPI_DeviceToken] ;
        [dictParam setObject:@"ios" forKey:kLogInAPI_DeviceType] ;
        
        NSLog(@"params: %@", dictParam);
        
        [ApiCrowdBootstrap saveDeviceTokenWithParameters:dictParam success:^(NSDictionary *responseDict) {
            NSLog(@"Success");

        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

@end
