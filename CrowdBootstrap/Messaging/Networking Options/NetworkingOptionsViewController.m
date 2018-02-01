//
//  NetworkingOptionsViewController.m
//  
//
//  Created by Shikha on 07/11/17.
//
//

#import "NetworkingOptionsViewController.h"
#import "SWRevealViewController.h"
#import "AddBusinessCardViewController.h"

@interface NetworkingOptionsViewController ()

@end

@implementation NetworkingOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addObserver];
//    [self navigationBarSettings] ;
//    [self revealViewSettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
/*
- (void) addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNotificationIconOnNavigationBar:)name:kNotificationIconOnNavigationBar
                                               object:nil];
}

-(void)setNotificationIconOnNavigationBar:(NSNotification *) notification {
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"notifications"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navigateToNotification_Click:)forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblNotificationCount = [[UILabel alloc]init];
    
    [UtilityClass setNotificationIconOnNavigationBar:button
                                lblNotificationCount:lblNotificationCount navItem:self.navigationItem];
}

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content {
    self.title = viewTitle ;
}

-(void)navigationBarSettings {
    self.navigationItem.hidesBackButton = YES ;
}

-(void)revealViewSettings {
    menuBarBtn.target = self.revealViewController;
    menuBarBtn.action = @selector(revealToggle:);
    
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
}
*/
- (void)createSessionToLinkedIn {
    NSArray *permissions = [NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, nil];
    [LISDKSessionManager createSessionWithAuth:permissions state:nil showGoToAppStoreDialog:YES successBlock:^(NSString *returnState)
     {
        NSLog(@"%s","success called!");
        LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
        NSLog(@"Session : %@", session.description);
        // Get LinkedIn Info
        [self fetchLinkedInData];
     } errorBlock:^(NSError *error)
     {
//         [[LISDKAPIHelper sharedInstance] cancelCalls];
         [LISDKSessionManager clearSession];

         NSLog(@"%s","error called!");
     }];
}

- (void)fetchLinkedInData {
//    [[LISDKAPIHelper sharedInstance] getRequest:@"https://api.linkedin.com/v1/people/~"
//                                        success:^(LISDKAPIResponse *response)
     [[LISDKAPIHelper sharedInstance] getRequest:@"https://api.linkedin.com/v1/people/~:(id,email-address,first-name,last-name,formatted-name,picture-url,siteStandardProfileRequest,headline)?format=json"
                                         success:^(LISDKAPIResponse *response)
    {
        NSData* data = [response.data dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"LinkedIn Response: %@", dictResponse);
        
        // go to business card screen
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NetworkingOptions" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kAddBusinessCardIdentifier] ;
        
        NSArray *arrVC = self.navigationController.viewControllers;
        NSLog(@"nav arr: %@", arrVC);
        if ([arrVC containsObject:@"AddBusinessCardViewController"]) {
            [self.navigationController popViewControllerAnimated:true];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:viewController animated:true];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendLinkedInInfo object:@"LinkedInDetail" userInfo:dictResponse];
        });

 
    } error:^(LISDKAPIError *apiError)
    {
        NSLog(@"Error : %@", apiError);
    }];
}


#pragma mark - IBAction Methods
- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)addContact_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NetworkingOptions" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kAddContactIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)socialMediaConnect_Click:(id)sender {
    [self createSessionToLinkedIn];
}

@end
