//
//  SettingsViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 13/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "SettingsViewController.h"
#import "SWRevealViewController.h"
#import "SettingsTableViewCell.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addObserver];
    [self resetUISettings] ;
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

-(void)setNotificationIconOnNavigationBar:(NSNotification *) notification {
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"notifications"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navigateToNotification_Click:)forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblNotificationCount = [[UILabel alloc]init];
    
    [UtilityClass setNotificationIconOnNavigationBar:button
                                lblNotificationCount:lblNotificationCount navItem:self.navigationItem];
}

-(void)navigationBarSettings {
    self.navigationItem.hidesBackButton = YES ;
    self.title = @"Settings" ;
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

-(void)resetUISettings {
    settingsArray = [[NSMutableArray alloc] init] ;
    [self getSettingsList];

    
    // Notifications
    NSMutableDictionary *notificationDict = [[NSMutableDictionary alloc] init] ;
    [notificationDict setValue:[UtilityClass getNotificationSettings] forKey:@"isSelected"] ;
    [notificationDict setValue:@"Notifications" forKey:@"name"] ;
    [settingsArray addObject:notificationDict] ;
    
    [self initializeSectionArray];
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    
    
//    [tblView reloadData] ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)initializeSectionArray {
    // Fields Title
    fields = @{@"" : @[@"Make My Profile Public",
                       @"Register for Beta Tester opportunities",
                       @"Register for Board Member opportunities",
                       @"Register for Consulting opportunities",
                       @"Register for Early Adopter opportunities",
                       @"Register for Endorser opportunities",
                       @"Register for Focus Group opportunities"],
    @"Enable/Disable 'What's New' Sources" : @[@"Audio/Video Updates",
                                               @"Beta Test Updates",
                                               @"Board Member Updates",
                                               @"Campaign Followed Updates",
                                               @"Campaign Committed Updates",
                                               @"Career Help Tool Updates",
                                               @"Communal Asset Updates",
                                               @"Conference Updates",
                                               @"Connections Updates",
                                               @"Consulting Updates",
                                               @"Demo Day Updates",
                                               @"Early Adopter Updates",
                                               @"Endorser Updates",
                                               @"Focus Group Updates",
                                               @"Forum Updates",
                                               @"Fund Updates",
                                               @"Group Updates",
                                               @"Group Buying Updates",
                                               @"Hardware Updates",
                                               @"Information Updates",
                                               @"Job Updates",
                                               @"Launch Deal Updates",
                                               @"Meetup Updates",
                                               @"Organization Updates",
                                               @"Productivity Updates",
                                               @"Self Improvement Tool Updates",
                                               @"Service Updates",
                                               @"Software Updates",
                                               @"Startup Updates",
                                               @"Webinar Updates"]} ;
    
    fieldsTitles = [[fields allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    arrSection1Fields = [fields objectForKey:[fieldsTitles objectAtIndex:0]];
    arrSection2Fields = [fields objectForKey:[fieldsTitles objectAtIndex:1]];
    
    allFieldTitlesArray = [[NSMutableArray alloc] init];
    [allFieldTitlesArray addObjectsFromArray:arrSection1Fields];
    [allFieldTitlesArray addObjectsFromArray:arrSection2Fields];

    // Bool Key for Switch Value
    dictionaryForBool = @{@"" : @[@"isPublicProfile",
                                  @"isBetaTester",
                                  @"isBoardMember",
                                  @"isConsultingProject",
                                  @"isEarlyAdopter",
                                  @"isEndorsor",
                                  @"isFocusGroup"] ,
    @"Enable/Disable 'What's New' Sources" : @[@"isAudioVideoUpdate",
                                               @"isBetaTestUpdate",
                                               @"isBoardMemberUpdate",
                                               @"isCampaignFollowedUpdate",
                                               @"isCampaignCommittedUpdate",
                                               @"isCareerHelpUpdate",
                                               @"isCommunalAssetUPdate",
                                               @"isConferenceUpdate",
                                               @"isConnectionUpdate",
                                               @"isConsultingUpdate",
                                               @"isDemodayUpdate",
                                               @"isEarlyAdopterUpdate",
                                               @"isEndorserUpdate",
                                               @"isFocusGroupUpdate",
                                               @"isForumUpdate",
                                               @"isFundUpdate",
                                               @"isGroupUpdate",
                                               @"isGroupBuyingUpdate",
                                               @"isHardwareUpdate",
                                               @"isInformationUpdate",
                                               @"isJobUpdate",
                                               @"isLaunchDealUpdate",
                                               @"isMeetupUpdate",
                                               @"isOrganizationUpdate",
                                               @"isProductivityUpdate",
                                               @"isSelfImprovementUpdate",
                                               @"isServiceUpdate",
                                               @"isSoftwareUpdate",
                                               @"isStartupUpdate",
                                               @"isWebinarUpdate"]};
    
    boolTitles = [[dictionaryForBool allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    NSArray *arrSection1Bool = [dictionaryForBool objectForKey:[boolTitles objectAtIndex:0]];
    NSArray *arrSection2Bool = [dictionaryForBool objectForKey:[boolTitles objectAtIndex:1]];
    
    allFieldBoolArray = [[NSMutableArray alloc] init];
    [allFieldBoolArray addObjectsFromArray:arrSection1Bool];
    [allFieldBoolArray addObjectsFromArray:arrSection2Bool];

    // Field Type
    dictionaryForType = @{@"" : @[kProfileSetting_PublicProfile,
                                  kSettingAPI_BetaTester,
                                  kSettingAPI_BoardMember,
                                  kSettingAPI_Consulting,
                                  kSettingAPI_EarlyAdopter,
                                  kSettingAPI_Endorser,
                                  kSettingAPI_FocusGroup],
    @"Enable/Disable 'What's New' Sources" : @[kSettingAPI_Feeds_Audio,
                                               kSettingAPI_Feeds_BetaTest,
                                               kSettingAPI_Feeds_BoardMember,
                                               kSettingAPI_Feeds_Followed_Campaign,
                                               kSettingAPI_Feeds_Commited_Campaign,
                                               kSettingAPI_Feeds_Career,
                                               kSettingAPI_Feeds_Communal,
                                               kSettingAPI_Feeds_Conference,
                                               kSettingAPI_Feeds_Profile,
                                               kSettingAPI_Feeds_Consulting,
                                               kSettingAPI_Feeds_Demoday,
                                               kSettingAPI_Feeds_EarlyAdopter,
                                               kSettingAPI_Feeds_Endorser,
                                               kSettingAPI_Feeds_FocusGroup,
                                               kSettingAPI_Feeds_Forum,
                                               kSettingAPI_Feeds_Fund,
                                               kSettingAPI_Feeds_Group,
                                               kSettingAPI_Feeds_PurchaseOrder,
                                               kSettingAPI_Feeds_Hardware,
                                               kSettingAPI_Feeds_Information,
                                               kSettingAPI_Feeds_Job,
                                               kSettingAPI_Feeds_LaunchDeal,
                                               kSettingAPI_Feeds_Meetup,
                                               kSettingAPI_Feeds_Organization,
                                               kSettingAPI_Feeds_Productivity,
                                               kSettingAPI_Feeds_SelfImprovement,
                                               kSettingAPI_Feeds_Service,
                                               kSettingAPI_Feeds_Software,
                                               kSettingAPI_Feeds_Startup,
                                               kSettingAPI_Feeds_Webinar]};
    
    typeTitles = [[dictionaryForType allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    // Make a common array containg dictionary for a particular field (defining field name and its switch value)
    for (int i=0; i<allFieldTitlesArray.count ; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
        [dict setValue:[NSString stringWithFormat:@"%@",[[UtilityClass getUserSettingDetails]  valueForKey:[allFieldBoolArray objectAtIndex:i]]] forKey:@"isSelected"] ;
        [dict setValue:[allFieldTitlesArray objectAtIndex:i] forKey:@"name"] ;
     
        [settingsArray addObject:dict] ;
    }
}

#pragma mark - IBAction Methods
- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)switchStatusChange:(UISwitch *)sender {
//    NSInteger section = (sender.tag)/1000;
//    NSInteger row = (sender.tag)%1000;
    
    if((sender.tag) == PUBLIC_PROFILE_SELECTED) {
        NSString *msg = (sender.on ?@"public?":@"private?") ;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@%@",kAlert_Settings,msg] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            [self updateProfileSettingsWithStatus:sender.on apiType:@"Profile"] ;
            
        }];
        UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [sender setOn:!sender.on] ;
        }];
        
        [alertController addAction:yes];
        [alertController addAction:no];
        
        [self presentViewController:alertController animated:YES completion:nil] ;
    }
    else if((sender.tag) == NOTIFICATIONS_SELECTED) { // NOTIFICATIONS
        
        NSString *msg = (sender.on ?@"enable":@"disable") ;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@%@ notifications?",kAlert_StartTeam,msg] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            [self updateProfileSettingsWithStatus:sender.on apiType:@"Notification"] ;

            if(sender.on == 1){
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kNotification_EnablePush
                 object:self];

                [UtilityClass setNotificationSettings:@"true"] ;
            }
            else {
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kNotification_DisablePush
                 object:self];
                [UtilityClass setNotificationSettings:@"false"] ;
            }
        }];
        UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [sender setOn:!sender.on] ;
        }];
        
        [alertController addAction:yes];
        [alertController addAction:no];
        
        [self presentViewController:alertController animated:YES completion:nil] ;
    }
    else {

        __block UIAlertController *alertController;
        switch ((sender.tag)) {
            case BETA_TESTER_SELECTED: {
                if (sender.on == 1)
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_BetaTester preferredStyle:UIAlertControllerStyleAlert];
                else
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_NotABetaTester preferredStyle:UIAlertControllerStyleAlert];
            }
                break;
            case BOARD_MEMBER_SELECTED: {
                if (sender.on == 1)
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_BoardMember preferredStyle:UIAlertControllerStyleAlert];
                else
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_NotABoardMember preferredStyle:UIAlertControllerStyleAlert];
            }
                break;
            case CONSULTING_PROJECT_SELECTED: {
                if (sender.on == 1)
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_ConsultingProject preferredStyle:UIAlertControllerStyleAlert];
                else
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_NotAConsultingProject preferredStyle:UIAlertControllerStyleAlert];
            }
                break;
            case EARLY_ADOPTER_SELECTED: {
                if (sender.on == 1)
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_EarlyAdopter preferredStyle:UIAlertControllerStyleAlert];
                else
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_NotAEarlyAdopter preferredStyle:UIAlertControllerStyleAlert];
            }
                break;
            case ENDORSOR_SELECTED: {
                if (sender.on == 1)
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_Endorsor preferredStyle:UIAlertControllerStyleAlert];
                else
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_NotAEndorsor preferredStyle:UIAlertControllerStyleAlert];
            }
                break;
            case FOCUS_GROUP_SELECTED: {
                if (sender.on == 1)
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_FocusGroup preferredStyle:UIAlertControllerStyleAlert];
                else
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_NotAFocusGroup preferredStyle:UIAlertControllerStyleAlert];
            }
            break;
            default: { // All Feeds Updates
                NSString *sectionTitle = [fieldsTitles objectAtIndex:1];
                NSArray *arr = [fields objectForKey:sectionTitle];
                NSString *str = [arr objectAtIndex:(sender.tag)%1000];
                
                if (sender.on == 1)
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: [NSString stringWithFormat:@"%@%@?", kAlertFeed_Update, str] preferredStyle:UIAlertControllerStyleAlert];
                else
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: [NSString stringWithFormat:@"%@%@?", kAlertFeed_NoUpdate, str] preferredStyle:UIAlertControllerStyleAlert];
            }
                break;
        }
        
        UIAlertAction* yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            [self updateSettingsWithStatus:sender.on apiTag:sender.tag] ;
        }];
        UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [sender setOn:!sender.on] ;
        }];
        
        [alertController addAction:yes];
        [alertController addAction:no];
        
        [self presentViewController:alertController animated:YES completion:nil] ;
    }
}

#pragma mark - Api Methods
-(void)updateProfileSettingsWithStatus:(BOOL)isEnable apiType:(NSString *)type {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileSetting_UserID] ;
        
        if ([type isEqualToString:@"Profile"])
            [dictParam setObject:(isEnable == 1?@"true":@"false") forKey:kProfileSetting_PublicProfile] ;
        else
            [dictParam setObject:(isEnable == 1?@"true":@"false") forKey:kProfileSetting_Notification] ;
        
        NSLog(@"Params: %@", dictParam);

        [ApiCrowdBootstrap updateProfileSettingsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSMutableDictionary* userDict = [[UtilityClass getUserSettingDetails] mutableCopy] ;
                [userDict setValue:(isEnable == 1?@"true":@"false") forKey:@"isPublicProfile"] ;
                NSLog(@"(userDict: %@",userDict) ;
                [UtilityClass setUserSettingDetails:userDict] ;
            }
            else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)updateSettingsWithStatus:(BOOL)isEnable apiTag:(NSUInteger)tag {// 1000
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileSetting_UserID] ;
        
        NSInteger section = tag/1000;
           //Row = tag%1000
        
        
        // Get Bool Key Array
        NSString *sectionName = [boolTitles objectAtIndex:tag/1000];
        NSArray *arrBool = [dictionaryForBool objectForKey:sectionName];

        // Get Field Type Array
        NSString *sectionTitle = [typeTitles objectAtIndex:tag/1000];
        NSArray *arr = [dictionaryForType objectForKey:sectionTitle];
        if (section == 0)
            [dictParam setObject:[arr objectAtIndex:(tag-1)%1000] forKey:@"type"] ;
        else
            [dictParam setObject:[arr objectAtIndex:tag%1000] forKey:@"type"] ;

        NSLog(@"Param Dict %@", dictParam);

        if (isEnable == 1) {
            [ApiCrowdBootstrap registerForRoleWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                    NSLog(@"responseDict %@", responseDict);
                    
                    NSMutableDictionary* userDict = [[UtilityClass getUserSettingDetails] mutableCopy] ;
                    if (section == 0)
                        [userDict setValue:(isEnable == 1?@"true":@"false") forKey:[arrBool objectAtIndex:(tag-1)%1000]] ;
                    else
                        [userDict setValue:(isEnable == 1?@"true":@"false") forKey:[arrBool objectAtIndex:tag%1000]] ;

                    [UtilityClass setUserSettingDetails:userDict] ;

                    NSLog(@"userDict: %@",userDict) ;
                }
                else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                
            } failure:^(NSError *error) {
                [UtilityClass displayAlertMessage:error.description] ;
                [UtilityClass hideHud] ;
            }] ;

        } else {
            [ApiCrowdBootstrap unregisterForRoleWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                    NSLog(@"responseDict %@", responseDict);
                    NSMutableDictionary* userDict = [[UtilityClass getUserSettingDetails] mutableCopy] ;
                    if (section == 0)
                        [userDict setValue:(isEnable == 1?@"true":@"false") forKey:[arrBool objectAtIndex:(tag-1)%1000]] ;
                    else
                        [userDict setValue:(isEnable == 1?@"true":@"false") forKey:[arrBool objectAtIndex:tag%1000]] ;
                    [UtilityClass setUserSettingDetails:userDict] ;
                    
                    NSLog(@"userDict: %@",userDict) ;
                }
                else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                
            } failure:^(NSError *error) {
                [UtilityClass displayAlertMessage:error.description] ;
                [UtilityClass hideHud] ;
            }] ;
        }
    }
}

-(void)getSettingsList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileSetting_UserID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getSettingsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSMutableArray *settingList = [[NSMutableArray alloc] init];
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                NSLog(@"responseDict %@", responseDict);
                if([responseDict valueForKey:kSettingsAPI_List]) {
                    [settingList addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSettingsAPI_List]] ;
                    
                    for (int i=0; i < settingList.count;i++) {
                        NSMutableDictionary *dict = [settingList objectAtIndex:i];
                        NSString *status = [NSString stringWithFormat:@"%@",[dict valueForKey:kSettingsAPI_Status]] ;
                        NSString *type = [NSString stringWithFormat:@"%@",[dict valueForKey:kSettingsAPI_Type]] ;

                        if ([type isEqualToString:@"notification"]) {
                            [UtilityClass setNotificationSettings:status];
                        } else if ([type isEqualToString:@"public_profile"]) {
                            [UtilityClass setPublicProfileSettings:status];
                        } else if ([type isEqualToString:@"beta_tester"]) {
                            [UtilityClass setBetaTesterSettings:status];
                        } else if ([type isEqualToString:@"board_member"]) {
                            [UtilityClass setBoardMemberSettings:status];
                        } else if ([type isEqualToString:@"consulting"]) {
                            [UtilityClass setConsultingSettings:status];
                        } else if ([type isEqualToString:@"early_adopter"]) {
                            [UtilityClass setEarlyAdopterSettings:status];
                        } else if ([type isEqualToString:@"endorsor"]) {
                            [UtilityClass setEndorsorUpdatesSettings:status];
                        } else if ([type isEqualToString:@"focus_group"]) {
                            [UtilityClass setFocusGroupSettings:status];
                        } else if ([type isEqualToString:@"feeds_audio"]) {
                            [UtilityClass setAudioVideoUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_betatest"]) {
                            [UtilityClass setBetaTestUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_boardmember"]) {
                            [UtilityClass setBoardMemberUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_campaign"]) {
                            [UtilityClass setCampaignFollowedUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_campaign_commited"]) {
                            [UtilityClass setCampaignCommittedUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_career"]) {
                            [UtilityClass setCareerUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_communal"]) {
                            [UtilityClass setCommunalAssetUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_conference"]) {
                            [UtilityClass setConferenceUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_profile"]) {
                            [UtilityClass setConnectionUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_consulting"]) {
                            [UtilityClass setConsultingUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_demoday"]) {
                            [UtilityClass setDemoDayUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_earlyadopter"]) {
                            [UtilityClass setEarlyAdopterUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_endorser"]) {
                            [UtilityClass setEndorsorUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_focusgroup"]) {
                            [UtilityClass setFocusGroupUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_forum"]) {
                            [UtilityClass setForumUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_fund"]) {
                            [UtilityClass setFundUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_group"]) {
                            [UtilityClass setGroupUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_purchaseorder"]) {
                            [UtilityClass setGroupBuyingUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_hardware"]) {
                            [UtilityClass setHardwareUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_information"]) {
                            [UtilityClass setInformationUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_job"]) {
                            [UtilityClass setJobUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_launchdeal"]) {
                            [UtilityClass setLaunchDealUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_meetup"]) {
                            [UtilityClass setMeetupUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_organization"]) {
                            [UtilityClass setOrganizationUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_productivity"]) {
                            [UtilityClass setProductivityUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_improvement"]) {
                            [UtilityClass setSelfImprovementUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_service"]) {
                            [UtilityClass setServiceUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_software"]) {
                            [UtilityClass setSoftwareUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_startup"]) {
                            [UtilityClass setStartupUpdatesSettings:status];
                        } else if ([type isEqualToString:@"feeds_webinar"]) {
                            [UtilityClass setWebinarUpdatesSettings:status];
                        }
                    }
                    
                    [tblView reloadData] ;
                }
            }
            else
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];

        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }];
    }
}

#pragma mark - TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return fieldsTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return arrSection1Fields.count+1;
    else
        return arrSection2Fields.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    cell.settingsSwitch.tag = indexPath.section*1000 + indexPath.row;
    NSString *isSelected = @"";
    NSString *type = @"";

    if (settingsArray.count > 0) {
        if (indexPath.section == 0) {

            // Settings Label
            if (indexPath.row == 0) {
                cell.settingsLbl.text = @"Notifications";
                isSelected = [NSString stringWithFormat:@"%@",[UtilityClass getNotificationSettings]];
//                isSelected = [NSString stringWithFormat:@"%@",[[settingsArray objectAtIndex:indexPath.row] valueForKey:kSettingsAPI_Status]] ;
            }
            else {
                NSString *sectionTitle = [fieldsTitles objectAtIndex:indexPath.section];
                NSArray *arr = [fields objectForKey:sectionTitle];
                NSString *str = [arr objectAtIndex:indexPath.row-1];
                cell.settingsLbl.text = str ;

                // Switch Value
                isSelected = [NSString stringWithFormat:@"%@",[[settingsArray objectAtIndex:indexPath.row] valueForKey:kSettingsAPI_Status]] ;
                type = [NSString stringWithFormat:@"%@",[[settingsArray objectAtIndex:indexPath.row] valueForKey:kSettingsAPI_Type]] ;

                /*
                 NSString *sectionName = [boolTitles objectAtIndex:indexPath.section];
                 NSArray *arrBool = [dictionaryForBool objectForKey:sectionName];
                 NSString *strBool = [arrBool objectAtIndex:indexPath.row-1];
                 isSelected = [NSString stringWithFormat:@"%@",[[UtilityClass getUserSettingDetails]  valueForKey:strBool]] ;
                 */
            }
        } else {
            NSString *sectionTitle = [fieldsTitles objectAtIndex:indexPath.section];
            NSArray *arr = [fields objectForKey:sectionTitle];
            NSString *str = [arr objectAtIndex:indexPath.row];
            cell.settingsLbl.text = str ;
            
//            NSArray *arrTags = [dictionaryForType objectForKey:sectionTitle];
//            NSString *strType = [arrTags objectAtIndex:(indexPath.row)%1000];

            // Switch Value
            isSelected = [NSString stringWithFormat:@"%@",[[settingsArray objectAtIndex:indexPath.row] valueForKey:kSettingsAPI_Status]] ;
            
            /*
             NSString *sectionName = [boolTitles objectAtIndex:indexPath.section];
             NSArray *arrBool = [dictionaryForBool objectForKey:sectionName];
             NSString *strBool = [arrBool objectAtIndex:indexPath.row];
             isSelected = [NSString stringWithFormat:@"%@",[[UtilityClass getUserSettingDetails]  valueForKey:strBool]] ;
             */
        }
    }
    
    if ([isSelected isEqualToString:@"1"] || [isSelected isEqualToString:@"true"])
        [cell.settingsSwitch setOn:YES];
     else
        [cell.settingsSwitch setOn:NO];
    
    return cell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50 ;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [fieldsTitles objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1)
        return 45;
    else
        return 0;
}

@end
