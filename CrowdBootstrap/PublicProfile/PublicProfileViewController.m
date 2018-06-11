//
//  PublicProfileViewController.m
//  CrowdBootstrap
//
//  Created by RICHA on 14/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "PublicProfileViewController.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "ChatViewController.h"

@interface PublicProfileViewController ()

@end

@implementation PublicProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
}

/*-(void)viewDidDisappear:(BOOL)animated {
    [UtilityClass setProfileMode:PROFILE_MODE_MY_PROFILE] ;
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self addObserver];
    [self resetUISettings] ;
    [self revealViewSettings] ;
    [self navigationBarSettings] ;
    [self resetToggleButton:(int)[UtilityClass GetUserType]] ;
    [self getPublicProfileData] ;
}

#pragma mark - Custom Methods
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

-(void)revealViewSettings {
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    menuBarBtn.target = self.revealViewController;
    menuBarBtn.action = @selector(revealToggle:);
    
    // Set the gesture
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
}

-(void)navigationBarSettings {
    if(self.profileMode) {
        self.title = @"Public Profile" ;
        [self resetNavigationBarsettings] ;
    }
   else self.title = @"Public Profile" ;
}

-(void)resetUISettings {
    
    if(!self.profileMode)
        [UtilityClass setProfileMode:PROFILE_MODE_MY_PROFILE] ;
    
    if([UtilityClass getProfileMode] == PROFILE_MODE_TEAM ){
        NSString *role = [[[UtilityClass getContractorDetails] mutableCopy] valueForKey:kStartupTeamAPI_MemberRole] ;
        if(role){
            if([role isEqualToString:TEAM_TYPE_ENTREPRENEUR])[UtilityClass setUserType:ENTREPRENEUR] ;
            else [UtilityClass setUserType:CONTRACTOR] ;
        }
    }
    else if([UtilityClass getProfileMode] == PROFILE_MODE_SEARCH ) {
       // [UtilityClass setUserType:ENTREPRENEUR] ;
        NSLog(@"getViewEntProfileMode: %d",[UtilityClass getViewEntProfileMode]) ;
        if([UtilityClass getViewEntProfileMode] == YES) [UtilityClass setUserType:ENTREPRENEUR] ;
        else  [UtilityClass setUserType:CONTRACTOR] ;
    }
    else [UtilityClass setUserType:CONTRACTOR] ;
    
     NSLog(@"GetUserType: %ld",(long)[UtilityClass GetUserType]) ;

    profileImageView.layer.cornerRadius = 50;
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.borderWidth = 2.0f;
    profileImageView.layer.borderColor = [UtilityClass greenColor].CGColor;
    
    starView.userInteractionEnabled = NO ;
    
    if([UtilityClass getProfileMode] == PROFILE_MODE_RECOMMENDED || [UtilityClass getProfileMode] == PROFILE_MODE_SEARCH || [UtilityClass getProfileMode] == PROFILE_MODE_TEAM){
        [self hideShowButtonsAccordingToProfileMode:YES] ;
    }
    else [self hideShowButtonsAccordingToProfileMode:NO] ;
}

-(void)resetNavigationBarsettings {
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back_Icon"] style:UIBarButtonItemStylePlain target:self action:@selector(BackButton_ClickAction)] ;
    self.navigationItem.leftBarButtonItem = backButton ;
}

-(void)hideShowButtonsAccordingToProfileMode:(BOOL)setHidden {
    [toggleImageView setHidden:setHidden] ;
    [entButton setHidden:setHidden] ;
    [contButton setHidden:setHidden] ;
    [chatButton setHidden:!setHidden] ;
    [followButton setHidden:!setHidden] ;
    if ([UtilityClass getProfileMode] == PROFILE_MODE_TEAM)
        [connectButton setHidden:setHidden] ;
    else
        [connectButton setHidden:!setHidden] ;
}

-(void)resetToggleButton:(int)userType {
    
    if(userType == ENTREPRENEUR) {
        [toggleImageView setImage:[UIImage imageNamed:ENTREPRENEUR_SELECTED_IMAGE]] ;
        hoursTxtFld.hidden = YES ;
    }
    else {
        [toggleImageView setImage:[UIImage imageNamed:CONTRACTOR_SELECTED_IMAGE]] ;
        hoursTxtFld.hidden = NO ;
    }
    
    [UtilityClass setUserType:userType] ;
}

-(void)updatePubilcProfileUI {
    
    switch (segmentControl.selectedSegmentIndex) {
        case PROFILE_BASIC_SELECTED: {
            basicView.hidden = NO ;
            professionalView.hidden = YES ;
            startupsView.hidden = YES ;
            
            [self getPublicProfileData] ;
            
            break;
        }
        case PROFILE_PROFESSIONAL_SELECTED:{
            basicView.hidden = YES ;
            professionalView.hidden = NO ;
            startupsView.hidden = YES ;
            
            [self getPublicProfileData] ;
            
            break;
        }
        case PROFILE_STARTUPS_SELECTED:{
            basicView.hidden = YES ;
            professionalView.hidden = YES ;
            startupsView.hidden = NO ;
            
            [self getPublicProfileData] ;
            
            break;
        }
            
        default:
            break;
    }
    
}

#pragma mark - IBAction Methods
-(void)BackButton_ClickAction{
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)Award_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kAwardViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)Chat_ClickAction:(id)sender {
    
    if(quickBloxID){
        [UtilityClass setSelectedChatUserName:userNameTxtFld.text] ;
        QBUUser *user = [QBUUser user];
        user.ID = quickBloxID ;
        user.login = userNameTxtFld.text ;
        NSLog(@"qbUser: %@",user) ;
        
        [ServicesManager.instance.chatService createPrivateChatDialogWithOpponent:user completion:^(QBResponse *response, QBChatDialog *createdDialog) {
            if (!response.success && createdDialog == nil) {
                NSLog(@"errror >> %@", response.error) ;
            }
            else {
                NSLog(@"Success >> ") ;
                [UtilityClass setSelectedChatUserName:createdDialog.name] ;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ChatViewController *viewController = (ChatViewController*)[storyboard instantiateViewControllerWithIdentifier:kChatUserViewIdentifier] ;
                viewController.dialog = createdDialog ;
                NSLog(@"qbChatDialog: %@",createdDialog) ;
                [self.navigationController pushViewController:viewController animated:YES] ;
            }
        }];
    }
    
   /* [UtilityClass setSelectedChatUserName:userNameTxtFld.text] ;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kChatUserViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;*/
}

- (IBAction)FollowButton_ClickAction:(UIButton*)button {
    
    NSString *status  = ([button.titleLabel.text isEqualToString:FOLLOW_TEXT]?@"1":@"0") ;
    [self followUnfollowUserWithStatus:status] ;
}

- (IBAction)BusinessCardButton_ClickAction:(UIButton*)button {
    
    // Redirect to Business Card Details Screen
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NetworkingOptions" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kBusinessCardDetailIdentifier] ;
        
    NSString *strCardId = [NSString stringWithFormat:@"%@",[profileDict valueForKey:kBusinessAPI_CardId]];
    if ([strCardId isEqualToString:@""]) {
        [self presentViewController:[UtilityClass displayAlertMessage:@"No Business Card Found!!"] animated:YES completion:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendProfileInfo object:@"PublicProfile" userInfo:profileDict];
        [self.navigationController pushViewController:viewController animated:true];
    }
}

- (IBAction)connectButton_ClickAction:(UIButton*)button {
    
    NSString *btnText = button.titleLabel.text;
    
    if ([btnText isEqualToString:CONNECT_TEXT]) {
        [self connectUser] ;
    } else if ([btnText isEqualToString:DISCONNECT_TEXT]) {
        [self disconnectUser];
    } else if ([btnText isEqualToString:RESPOND_TEXT]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want to accept the connection request?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            // Accept the Connection
            [self acceptConnection];
        }];
        UIAlertAction* no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            // Reject Connection
            [self disconnectUser];
        }];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:yes];
        [alertController addAction:no];
        [alertController addAction:cancel];

        [self presentViewController:alertController animated:YES completion:nil] ;
    } else {
        [self disconnectUser];
    }
    /*
    NSString *status  = ([button.titleLabel.text isEqualToString:CONNECT_TEXT]?@"1":@"0") ;
    if ([status isEqualToString:@"1"])
        [self connectUser] ;
    else {
        if ([button.titleLabel.text isEqualToString:REQUEST_SENT_TEXT]) {
            
        } else
            [self disconnectUser];
    }
     */
}

- (IBAction)segmentedControl_ValueChanged:(id)sender {
    [self updatePubilcProfileUI] ;
}

- (IBAction)ChangeUserType_ClickAction:(id)sender {
    selectedUserType = (int)[sender tag] ;
    [self resetToggleButton:selectedUserType] ;
    [self updatePubilcProfileUI] ;
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

#pragma mark - API Methods
-(void)getPublicProfileData {
    
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        if((int)segmentControl.selectedSegmentIndex == PROFILE_STARTUPS_SELECTED)
            [self getStartupsProfileData] ;
        else
            [self getBasicProfProfileData] ;
    }
}

-(void)getBasicProfProfileData {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    if([UtilityClass getProfileMode] == PROFILE_MODE_RECOMMENDED || [UtilityClass getProfileMode] == PROFILE_MODE_SEARCH || [UtilityClass getProfileMode] == PROFILE_MODE_TEAM) {
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getContractorDetails] valueForKey:kRecommendedContAPI_ContractorID]] forKey:kProfileAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileAPI_LoggedIn_UserID] ;
    }
    else {
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileAPI_LoggedIn_UserID] ;
    }
    
    NSLog(@"GetUserType: %d",[UtilityClass getLoggedInUserID]) ;
    [ApiCrowdBootstrap getProfileWithType:(int)segmentControl.selectedSegmentIndex forUserType:[UtilityClass GetUserType] withParameters:dictParam success:^(NSDictionary *responseDict) {
        
        [UtilityClass hideHud] ;
        
        if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
            NSLog(@"responseDict: %@",responseDict) ;
            
            profileDict = [NSDictionary dictionaryWithDictionary:responseDict];
            
            // Get QuickBlox ID
           if([[responseDict objectForKey:kProfileAPI_QuickbloxID] intValue])
               quickBloxID = [[responseDict objectForKey:kProfileAPI_QuickbloxID] intValue] ;
            
            // Get Connection ID
            if([[responseDict objectForKey:kProfileAPI_connectionID] intValue])
                connectionID = [[responseDict objectForKey:kProfileAPI_connectionID] intValue] ;
            
            // Get Business Card ID
//            if([[responseDict objectForKey:kBusinessAPI_CardId] intValue])
//                businessCardID = [[responseDict objectForKey:kBusinessAPI_CardId] intValue] ;
//
//            // Get Connection Type ID
//            if([[responseDict objectForKey:kBusinessAPI_ConnectionId] intValue])
//                connectionTypeID = [[responseDict objectForKey:kBusinessAPI_ConnectionId] intValue] ;

            // Update Profile Info
            userNameTxtFld.text = [responseDict objectForKey:kProfileAPI_Name] ;
            
            NSLog(@"img >> %@",[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[responseDict valueForKey:kProfileAPI_Image]]) ;
            
            [profileImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[responseDict valueForKey:kProfileAPI_Image]]] placeholderImage:[UIImage imageNamed:kImage_ProfilePicDefault]] ;
            
            if([UtilityClass GetUserType] == CONTRACTOR)
                hoursTxtFld.text = [NSString stringWithFormat:@"$%@/HR",[UtilityClass formatNumber:[responseDict objectForKey:kProfileAPI_PerHourRate]]];
            else hoursTxtFld.text = @"$0/HR" ;
            
            // Check Follow/Unfollow
            if([[responseDict objectForKey:kProfileAPI_isFollowing] intValue] == 0) {
                [followButton setTitle:FOLLOW_TEXT forState:UIControlStateNormal] ;
                [followButton setBackgroundImage:[UIImage imageNamed:FOLLOW_BUTTON_ICON] forState:UIControlStateNormal] ;
            }
            else {
                [followButton setTitle:UNFOLLOW_TEXT forState:UIControlStateNormal] ;
                [followButton setBackgroundImage:[UIImage imageNamed:UNFOLLOW_BUTTON_ICON] forState:UIControlStateNormal] ;
            }
            
            // Check Connection Status
            if([[responseDict objectForKey:kProfileAPI_connectionReceived] intValue] == 1 && [[responseDict objectForKey:kProfileAPI_connectionSent] intValue] == 0 && [[responseDict objectForKey:kProfileAPI_connectionStatus] intValue] == 0) {
                [connectButton setTitle:RESPOND_TEXT forState:UIControlStateNormal] ;
            } else if([[responseDict objectForKey:kProfileAPI_connectionReceived] intValue] == 1 && [[responseDict objectForKey:kProfileAPI_connectionSent] intValue] == 0 && [[responseDict objectForKey:kProfileAPI_connectionStatus] intValue] == 1) {
                    [connectButton setTitle:DISCONNECT_TEXT forState:UIControlStateNormal] ;
            }
            else if([[responseDict objectForKey:kProfileAPI_connectionReceived] intValue] == 0 && [[responseDict objectForKey:kProfileAPI_connectionSent] intValue] == 1 && [[responseDict objectForKey:kProfileAPI_connectionStatus] intValue] == 0) {
                    [connectButton setTitle:REQUEST_SENT_TEXT forState:UIControlStateNormal] ;
            } else if([[responseDict objectForKey:kProfileAPI_connectionReceived] intValue] == 0 && [[responseDict objectForKey:kProfileAPI_connectionSent] intValue] == 1 && [[responseDict objectForKey:kProfileAPI_connectionStatus] intValue] == 1) {
                [connectButton setTitle:DISCONNECT_TEXT forState:UIControlStateNormal] ;
            } else if([[responseDict objectForKey:kProfileAPI_connectionReceived] intValue] == 0 && [[responseDict objectForKey:kProfileAPI_connectionSent] intValue] == 0 && [[responseDict objectForKey:kProfileAPI_connectionStatus] intValue] == 0) {
                [connectButton setTitle:CONNECT_TEXT forState:UIControlStateNormal] ;
            }
            
            if([responseDict objectForKey:kProfileAPI_Rating]){
                starView.value = [[responseDict objectForKey:kProfileAPI_Rating] floatValue] ;
            }
            
            if(segmentControl.selectedSegmentIndex == PROFILE_BASIC_SELECTED) {
                [UtilityClass setUserProfileDetails:[responseDict valueForKey:kProfileAPI_BasicInformation] ] ;
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kNotificationBasicProfile
                 object:self];
            }
            
            else if(segmentControl.selectedSegmentIndex == PROFILE_PROFESSIONAL_SELECTED) {
                [UtilityClass setUserProfileDetails:[responseDict valueForKey:kProfileAPI_ProfessionalInformation] ] ;
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kNotificationProfessionalProfile
                 object:self];
            }
            
            else {
                [UtilityClass setUserProfileDetails:[responseDict valueForKey:kProfileAPI_StartupInformation]] ;
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kNotificationStartupProfile
                 object:self];
            }
        }
        else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        
    } failure:^(NSError *error) {
        
        [UtilityClass displayAlertMessage:error.description] ;
        [UtilityClass hideHud] ;
        
    }] ;
}

-(void)getStartupsProfileData {
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    if([UtilityClass getProfileMode] == PROFILE_MODE_RECOMMENDED || [UtilityClass getProfileMode] == PROFILE_MODE_SEARCH || [UtilityClass getProfileMode] == PROFILE_MODE_TEAM) {
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getContractorDetails] valueForKey:kRecommendedContAPI_ContractorID]] forKey:kProfileAPI_UserID] ;
        if([UtilityClass getProfileMode] == PROFILE_MODE_TEAM ) {
            NSString *role = [[UtilityClass getCampaignDetails] valueForKey:kStartupTeamAPI_MemberRole] ;
            if(role) {
                if([role isEqualToString:TEAM_TYPE_ENTREPRENEUR])[dictParam setObject:ENTREPRENEUR_TEXT forKey:kProfileAPI_UserType] ;
                else [dictParam setObject:CONTRACTOR_TEXT forKey:kProfileAPI_UserType] ;
            }
        }
        else [dictParam setObject:CONTRACTOR_TEXT forKey:kProfileAPI_UserType] ;
    }
    else{
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileAPI_UserID] ;
        if([UtilityClass GetUserType] == CONTRACTOR)[dictParam setObject:CONTRACTOR_TEXT forKey:kProfileAPI_UserType] ;
        else [dictParam setObject:ENTREPRENEUR_TEXT forKey:kProfileAPI_UserType] ;
    }
    
    [ApiCrowdBootstrap getProfielUserStartupsWithParameters:dictParam success:^(NSDictionary *responseDict) {
        
        [UtilityClass hideHud] ;
        if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
           
            [UtilityClass setProfileStartupsDetails:[responseDict valueForKey:kProfileAPI_StartupInformation]] ;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotificationStartupProfile
             object:self];
            
        }
       // else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
    } failure:^(NSError *error) {
        
        [UtilityClass displayAlertMessage:error.description] ;
        [UtilityClass hideHud] ;
        
    }] ;
}

-(void)followUnfollowUserWithStatus:(NSString*)status {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFollowUserAPI_FollowedBy] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getContractorDetails] valueForKey:kRecommendedContAPI_ContractorID]] forKey:kFollowUserAPI_UserID] ;
        [dictParam setObject:status forKey:kFollowUserAPI_Status] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap followUnfollowUserWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([status isEqualToString:@"1" ]){
                    [followButton setTitle:UNFOLLOW_TEXT forState:UIControlStateNormal] ;
                    [followButton setBackgroundImage:[UIImage imageNamed:UNFOLLOW_BUTTON_ICON] forState:UIControlStateNormal] ;
                }
                else{
                    [followButton setTitle:FOLLOW_TEXT forState:UIControlStateNormal] ;
                    [followButton setBackgroundImage:[UIImage imageNamed:FOLLOW_BUTTON_ICON] forState:UIControlStateNormal] ;
                }
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];

            }
            //else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)connectUser {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConnectUserAPI_ConnectionBy] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getContractorDetails] valueForKey:kRecommendedContAPI_ContractorID]] forKey:kConnectUserAPI_ConnectionTo] ;
        [dictParam setObject:@"0" forKey:kConnectUserAPI_Status] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap connectUserWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                [connectButton setTitle:REQUEST_SENT_TEXT forState:UIControlStateNormal] ;
                connectionID = [[responseDict objectForKey:kProfileAPI_connectionID] intValue] ;
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)disconnectUser {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConnectUserAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",connectionID] forKey:kConnectUserAPI_ConnectionID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap disconnectUserWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
               [connectButton setTitle:CONNECT_TEXT forState:UIControlStateNormal] ;
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)acceptConnection {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConnectUserAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",connectionID] forKey:kConnectUserAPI_ConnectionID] ;
        [dictParam setObject:@"1" forKey:kConnectUserAPI_Status] ;

        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap acceptConnectionWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                [connectButton setTitle:DISCONNECT_TEXT forState:UIControlStateNormal] ;
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

@end
