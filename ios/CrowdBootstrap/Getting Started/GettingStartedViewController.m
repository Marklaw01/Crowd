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


#define kEntrepreneurDesc @"If you are an Entrepreneur, click the menu option in the top left corner of the screen then select 'My Profile' to create your 'Entrepreneur' profile. Then select the 'Startup' option on the menu to submit your startup application and create a startup profile."

#define kExpertDesc @"If you are an Expert, click the menu option in the top left corner of the screen then select 'My Profile' to create your 'Contractor' profile. Then select the 'Contractors' option on the menu to start helping innovative startups."

#define kRecruiterDesc @"If you are a Recruiter, click the menu option in the top left corner of the screen then select 'My Profile' to create a profile. Then select the 'Opportunities' option on the menu to submit your job posting or search for job candidates whose job performance has been rated and validated by entrepreneurs."

#define kOrganizationDesc @"If you are an Organization, click the menu option in the top left corner of the screen then select the 'Organization' option. You can create a organization page to explain your offerings. You can also sponsor events or even sponsor your own accelerator to access innovative startups in your industry."


@interface GettingStartedViewController ()

@end

@implementation GettingStartedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
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

- (IBAction)closePopUp_ClickAction:(id)sender {
    vwPopUp.hidden = true;
}

- (void)hideShowDescPopUp:(NSString *)strDesc {
    vwPopUp.hidden = false;
    txtViewDesc.text = strDesc;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {

        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO];
            [dvc.view setUserInteractionEnabled:YES];

            if([dvc isKindOfClass:[YTVideoViewViewController class]]) {
                YTVideoViewViewController *viewController = (YTVideoViewViewController*)dvc;
                [viewController refreshUIContentWithTitle:@"Getting Started Video" withContent:GETTING_STARTED_VIDEO_LINK] ;
            }
            
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
        };
    }
}
@end
