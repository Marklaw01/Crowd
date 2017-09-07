//
//  HomeInfoViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 06/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//
@import GoogleMobileAds;

#import "HomeInfoViewController.h"
#import "InfoViewController.h"
#import "KLCPopup.h"
#import "LeanStartupRoadmapViewController.h"
#import "YTVideoViewViewController.h"

@interface HomeInfoViewController ()

@end

@implementation HomeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //selectedUserType = CONTRACTOR ;
    [UtilityClass setUserType:CONTRACTOR] ;
    [self resetToggleButton:(int)[UtilityClass GetUserType]];
    [self setNeedsStatusBarAppearanceUpdate];
    [self addPushNotifications] ;
    
    // Request for BannerView
    self.bannerView.adUnitID = @"ca-app-pub-8861665785664393/1507873861"; // new one
//    self.bannerView.adUnitID = @"ca-app-pub-8877526086007040/4416451611"; // old one
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)addPushNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushNotification:)
                                                 name:kNotificationPush_Message
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushNotification:)
                                                 name:kNotificationPush_ReportAbuse
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushNotification:)
                                                 name:kNotificationPush_CommentForum
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushNotification:)
                                                 name:kNotificationPush_AddTeamMember
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushNotification:)
                                                 name:kNotificationPush_CommitCampaign
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushNotification:)
                                                 name:kNotificationPush_UncommitCampaign
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushNotification:)
                                                 name:kNotificationPush_FollowCampaign
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushNotification:)
                                                 name:kNotificationPush_UnfollowCampaign
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushNotification:)
                                                 name:kNotificationPush_RateUser
                                               object:nil];
}

-(void)resetToggleButton:(int)userType {
    if(userType == ENTREPRENEUR){
        [toggleImageView setImage:[UIImage imageNamed:ENTREPRENEUR_SELECTED_IMAGE]] ;
        descTxtView.text = ENTREPRENEUR_DESCRIPTION ;
        //independntContBtn.hidden = YES ;
    }
    else {
        [toggleImageView setImage:[UIImage imageNamed:CONTRACTOR_SELECTED_IMAGE]] ;
        descTxtView.text = CONTRACTOR_DESCRIPTION ;
        independntContBtn.hidden = NO ;
    }
    [UtilityClass setUserType:userType] ;
}

#pragma mark - IBAction Method
- (IBAction)openPopup_Click:(id)sender {
    
     NSString *htmlFile;
    if([sender tag] == HOW_IT_WORKS_SELECTED){
        popupTitleLbl.text = HOW_IT_WORKS_TITLE ;
        htmlFile = [[NSBundle mainBundle] pathForResource:HOW_IT_WORKS ofType:@"html"];
    }
    else{
        popupTitleLbl.text = INDEPENDENT_CONTRACTORS_TITLE ;
        htmlFile = [[NSBundle mainBundle] pathForResource:INDEPENDENT_CONTRACTORS ofType:@"html"];
        
      /*  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kIndependentContractorViewIdentifier] ;
        [self presentViewController:viewController animated:YES completion:nil] ;*/
    }
    
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [popupWebView loadHTMLString:htmlString baseURL:nil];
    
    //popupView.frame = CGRectMake(10.0, 0.0, self.view.frame.size.width-20, self.view.frame.size.height-30);
    //popupView.layer.cornerRadius = 12.0;
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        [popupView setHidden:NO];
        independntContBtn.userInteractionEnabled = NO;
        expalinerVideoBtn.userInteractionEnabled = NO;
        leanStartupBtn.userInteractionEnabled = NO;
        howItWorkBtn.userInteractionEnabled = NO;

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            popupView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                popupView.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    /*
    KLCPopupLayout layout = KLCPopupLayoutMake((KLCPopupHorizontalLayout)KLCPopupHorizontalLayoutCenter,
                                               (KLCPopupVerticalLayout)KLCPopupVerticalLayoutCenter);
    
    KLCPopup* popup = [KLCPopup popupWithContentView:popupView
                                            showType:(KLCPopupShowType)KLCPopupShowTypeBounceInFromTop
                                         dismissType:(KLCPopupDismissType)KLCPopupDismissTypeBounceOutToBottom
                                            maskType:(KLCPopupMaskType)KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:YES
                               dismissOnContentTouch:NO];
    
    [popup showWithLayout:layout];
    */
}

- (IBAction)ChangeUserType_ClickAction:(id)sender {
    selectedUserType = (int)[sender tag] ;
    [self resetToggleButton:selectedUserType] ;
}

- (IBAction)openInfoScreen_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoViewController *viewController = (InfoViewController*)[storyboard instantiateViewControllerWithIdentifier:kInfoIdentifier] ;
    
    switch ([sender tag]) {
        case VISION_SELECTED:{
            viewController.infoTitle = VISION_TITLE ;
            viewController.infoDescription = VISION_DESCRIPTION ;
            viewController.infoImage = VISION_IMAGE ;
            break ;
        }
        case MISSION_SELECTED:{
            viewController.infoTitle = MISSION_TITLE ;
            viewController.infoDescription = MISSION_DESCRIPTION ;
            viewController.infoImage = MISSION_IMAGE ;
            break ;
        }
        case VALUES_SELECTED:{
            viewController.infoTitle = VALUES_TITLE ;
            viewController.infoDescription = VALUES_DESCRIPTION ;
            viewController.infoImage = VALUES_IMAGE ;
            break ;
        }
        default:
            break;
    }
    [self presentViewController:viewController animated:YES completion:nil] ;
}

- (IBAction)ClosePopup_ClickAction:(id)sender {
    //[KLCPopup dismissAllPopups] ;
//    [popupView dismissPresentingPopup] ;
    [popupView setHidden:YES];
    independntContBtn.userInteractionEnabled = YES;
    expalinerVideoBtn.userInteractionEnabled = YES;
    leanStartupBtn.userInteractionEnabled = YES;
    howItWorkBtn.userInteractionEnabled = YES;
}

- (IBAction)ExplainerVideo_ClickAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:EXPLAINER_VIDEO_LINK]];
}

#pragma mark - WebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // Opening in safari
    [[UIApplication sharedApplication] openURL:request.URL];
    return YES ;
}

#pragma mark - Push Notifications
- (void)pushNotification:(NSNotification *) notification
{
    
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([[notification name] isEqualToString:kNotificationPush_AddTeamMember]){
        
        NSLog(@"kNotificationPush_AddTeamMember called >>>> %@",[AppDelegate appDelegate].pushTagValueDict ) ;
        
        NSString *valuesStr = [NSString stringWithFormat:@"%@",[[AppDelegate appDelegate].pushTagValueDict valueForKey:@"extra_message"]] ;
        
        NSRange range = [valuesStr rangeOfString:@","];
        if (range.location != NSNotFound){
            NSArray *arr = [valuesStr componentsSeparatedByString:@","] ;
            if(arr.count == 5){
                UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Do you want to work with this team?" message:[NSString stringWithFormat:@"Entrepreneur %@ has offered you to work as %@ in Startup %@ approving %@ Work Units with an hourly rate of $%@. Do you want to be a member of this Startup?",[arr objectAtIndex:0],[arr objectAtIndex:1],[arr objectAtIndex:2],[arr objectAtIndex:3],[arr objectAtIndex:4]] preferredStyle:UIAlertControllerStyleAlert];
                [alertController.view setTintColor:[UtilityClass blueColor]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil] ;
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self updateTeamMemberStatusWithStatus:@"1" withStartupID:[NSString stringWithFormat:@"%@",[[AppDelegate appDelegate].pushTagValueDict valueForKey:@"startup_id"]] andNotificationID:[NSString stringWithFormat:@"%@",[[AppDelegate appDelegate].pushTagValueDict valueForKey:@"notification_id"]]] ;
                    //[self updateTeamMemberStatusWithStatus:@"1" withStartupID:[NSString stringWithFormat:@"%@",[[AppDelegate appDelegate].pushTagValueDict valueForKey:@"startup_id"]]] ;
                    //[self dismissViewControllerAnimated:YES completion:nil] ;
                    
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                     [self updateTeamMemberStatusWithStatus:@"3" withStartupID:[NSString stringWithFormat:@"%@",[[AppDelegate appDelegate].pushTagValueDict valueForKey:@"startup_id"]] andNotificationID:[NSString stringWithFormat:@"%@",[[AppDelegate appDelegate].pushTagValueDict valueForKey:@"notification_id"]]] ;
                    //[self updateTeamMemberStatusWithStatus:@"3" withStartupID:[NSString stringWithFormat:@"%@",[[AppDelegate appDelegate].pushTagValueDict valueForKey:@"startup_id"]]] ;
                    //[self dismissViewControllerAnimated:YES completion:nil] ;
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil] ;
            }
        }
    }
    else if ([[notification name] isEqualToString:kNotificationPush_CommentForum] || [[notification name] isEqualToString:kNotificationPush_ReportAbuse]){
        
        NSLog(@"kNotificationPush_CommentForum called >>>> %@",[AppDelegate appDelegate].pushTagValueDict) ;
        if([AppDelegate appDelegate].pushTagValueDict){
            NSMutableDictionary *forumDict = [[NSMutableDictionary alloc] init] ;
           if([[AppDelegate appDelegate].pushTagValueDict valueForKey:@"forum_id"]) [forumDict setValue:[[AppDelegate appDelegate].pushTagValueDict valueForKey:@"forum_id"] forKey:kMyForumAPI_ForumID] ;
           if([[AppDelegate appDelegate].pushTagValueDict valueForKey:@"forum_name"]) [forumDict setValue:[[AppDelegate appDelegate].pushTagValueDict valueForKey:@"forum_name"] forKey:kMyForumAPI_ForumTitle] ;
            NSLog(@"dict: %@",forumDict) ;
            [UtilityClass setForumType:YES] ;
            [UtilityClass setForumDetails:(NSMutableDictionary*)forumDict] ;
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kForumDetailIdentifier] ;
            [self.navigationController pushViewController:viewController animated:YES] ;
        }
    }
    
    else if ([[notification name] isEqualToString:kNotificationPush_CommitCampaign] || [[notification name] isEqualToString:kNotificationPush_UncommitCampaign]){
        
        NSLog(@"kNotificationPush_CommitCampaign called >>>> ") ;
        if([AppDelegate appDelegate].pushTagValueDict){
            [UtilityClass setCampaignMode:YES] ;
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)[AppDelegate appDelegate].pushTagValueDict] ;
            [UtilityClass setCampaignDetails:dict] ;
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kViewContractorIdentifier] ;
            [self.navigationController pushViewController:viewController animated:YES] ;
        }
    }
    
    else if ([[notification name] isEqualToString:kNotificationPush_Message]){
        
        NSLog(@"kNotificationPush_Message called >>>> ") ;
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kMessagesIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
    
    // Follow / Unfollow Camapaign
    else if([[notification name] isEqualToString:kNotificationPush_FollowCampaign] || [[notification name] isEqualToString:kNotificationPush_UnfollowCampaign]){
        
        if([AppDelegate appDelegate].pushTagValueDict){
            [UtilityClass setCampaignMode:YES] ;
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)[AppDelegate appDelegate].pushTagValueDict] ;
            [UtilityClass setCampaignDetails:dict] ;
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditCampaignViewIdentifier] ;
            [self.navigationController pushViewController:viewController animated:YES] ;
        }
    }
    
    // Rate User
    else if([[notification name] isEqualToString:kNotificationPush_RateUser]){
        
        NSLog(@"kNotificationPush_RateUser called >>>> ") ;
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
    
    [AppDelegate appDelegate].pushTagValueDict = nil ;
    [AppDelegate appDelegate].selectedTag = nil ;
}

#pragma mark - API Methods
-(void)updateTeamMemberStatusWithStatus:(NSString*)status withStartupID:(NSString*)startupID andNotificationID:(NSString*)notificationID{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupTeamAPI_UserID] ;
        [dictParam setObject:startupID forKey:kStartupTeamAPI_StartupID] ;
        [dictParam setObject:notificationID forKey:@"notification_id"] ;
        [dictParam setObject:status forKey:kStartupTeamMemberStatusAPI_Status] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupTeamMemberStatusAPI_LoginUserID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap updateStartupTeamMemberStatusWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
                [self dismissViewControllerAnimated:YES completion:nil] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

//- (void)bannerViewDidLoadAd:(ADBannerView *)banner
//{
//    NSLog(@"bannerViewDidLoadAd") ;
//    bannerView.hidden = NO ;
//}
//
//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
//{
//    NSLog(@"Failed to retrieve ad");
//}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"LeanRoadMapVC"]) {
        LeanStartupRoadmapViewController *destViewcontroller = [segue destinationViewController];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        destViewcontroller.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        [UIView commitAnimations];
    }
}

- (IBAction)btnLeadRoadMapClicked:(id)sender {
    [self performSegueWithIdentifier:@"LeanRoadMapVC" sender:self];
}

@end
