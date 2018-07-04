//
//  YTVideoViewViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 23/08/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "YTVideoViewViewController.h"
#import "SWRevealViewController.h"

@interface YTVideoViewViewController ()

@end


@implementation YTVideoViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    NSMutableDictionary *dic = [[UtilityClass getLoggedInUserDetails] mutableCopy];
    
    userId = [[dic valueForKey:@"user_id"] intValue];
    NSLog(@"User ID : %d", userId);

    [self navigationBarSettings] ;
    
    if (userId > 0) {
        [self addObserver];
        [self revealViewSettings] ;
        self.navigationItem.hidesBackButton = YES ;
    }
    //[self playVideoWithId:@"http://www.youtube.com/watch?v=fDXWW5vX-64"] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void) addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNotificationIconOnNavigationBar:)name:kNotificationIconOnNavigationBar
                                               object:nil];
}

-(void)navigationBarSettings {
    if (userId == 0) {
        //        [self.navigationController.navigationBar setHidden:NO];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back_Icon"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction:)];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = nil;
    }
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

-(void)revealViewSettings{
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    menuBarBtn.target = self.revealViewController;
    menuBarBtn.action = @selector(revealToggle:);
    
    // Set the gesture
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
}

#pragma mark - IBAction Methods
- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

#pragma mark - Public Methods
-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content {
    self.title = viewTitle ;
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 };
    playerVw.delegate = self;
    [playerVw loadWithVideoId:content playerVars:playerVars];
    playerVw.backgroundColor = [UIColor clearColor] ;

//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",content]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
