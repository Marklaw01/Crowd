//
//  SettingViewController.m
//  CrowdBootstrap
//
//  Created by Shikha on 06/07/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "SettingViewController.h"
#import "SWRevealViewController.h"
#import "SettingsTableViewCell.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

-(void)resetUISettings {
    
    sectionsArray = [[NSMutableArray alloc] init] ;

    [self getSettingsList];
    
    [self initializeSectionArray];
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    
    
    //    [tblView reloadData] ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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

-(void)initializeSectionArray {
    
    NSArray *fieldsArray = @[@"Notifications",
                             @"Make My Profile Public",
                             @"Register for Beta Tester opportunities",
                             @"Register for Board Member opportunities",
                             @"Register for Consulting opportunities",
                             @"Register for Early Adopter opportunities",
                             @"Register for Endorser opportunities",
                             @"Register for Focus Group opportunities",
                             @"Audio/Video Updates",
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
                             @"Webinar Updates"];
    
    NSArray *parametersArray = @[kProfileSetting_Notification,
                                 kProfileSetting_PublicProfile,
                                 kSettingAPI_BetaTester,
                                 kSettingAPI_BoardMember,
                                 kSettingAPI_Consulting,
                                 kSettingAPI_EarlyAdopter,
                                 kSettingAPI_Endorser,
                                 kSettingAPI_FocusGroup,
                                 kSettingAPI_Feeds_Audio,
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
                                 kSettingAPI_Feeds_Webinar] ;
    
    for (int i=0; i<fieldsArray.count ; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
        [dict setValue:[parametersArray objectAtIndex:i] forKey:@"key"] ;
        [dict setValue:@"" forKey:@"value"] ;
        [dict setValue:[fieldsArray objectAtIndex:i] forKey:@"field"] ;
        
        [sectionsArray addObject:dict] ;
    }
    NSLog(@"Section array: %@", sectionsArray);
}

#pragma mark - IBAction Methods
- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)switchStatusChange:(UISwitch *)sender {
    
    if((sender.tag) == PUBLIC_PROFILE_SECTION_INDEX) {
        NSString *msg = (sender.on ?@"public?":@"private?") ;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@%@",kAlert_Settings,msg] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            [self updateProfileSettingsWithStatus:sender.on apiTag:sender.tag] ;
            
        }];
        UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [sender setOn:!sender.on] ;
        }];
        
        [alertController addAction:yes];
        [alertController addAction:no];
        
        [self presentViewController:alertController animated:YES completion:nil] ;
    }
    else if((sender.tag) == NOTIFICATIONS_SECTION_INDEX) { // NOTIFICATIONS
        
        NSString *msg = (sender.on ?@"enable":@"disable") ;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@%@ notifications?",kAlert_StartTeam,msg] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            [self updateProfileSettingsWithStatus:sender.on apiTag:sender.tag] ;
            
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
            case BETA_TESTER_SECTION_INDEX: {
                if (sender.on == 1)
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_BetaTester preferredStyle:UIAlertControllerStyleAlert];
                else
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_NotABetaTester preferredStyle:UIAlertControllerStyleAlert];
            }
                break;
            case BOARD_MEMBER_SECTION_INDEX: {
                if (sender.on == 1)
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_BoardMember preferredStyle:UIAlertControllerStyleAlert];
                else
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_NotABoardMember preferredStyle:UIAlertControllerStyleAlert];
            }
                break;
            case CONSULTING_SECTION_INDEX: {
                if (sender.on == 1)
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_ConsultingProject preferredStyle:UIAlertControllerStyleAlert];
                else
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_NotAConsultingProject preferredStyle:UIAlertControllerStyleAlert];
            }
                break;
            case EARLY_ADOPTER_SECTION_INDEX: {
                if (sender.on == 1)
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_EarlyAdopter preferredStyle:UIAlertControllerStyleAlert];
                else
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_NotAEarlyAdopter preferredStyle:UIAlertControllerStyleAlert];
            }
                break;
            case ENDORSOR_SECTION_INDEX: {
                if (sender.on == 1)
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_Endorsor preferredStyle:UIAlertControllerStyleAlert];
                else
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_NotAEndorsor preferredStyle:UIAlertControllerStyleAlert];
            }
                break;
            case FOCUS_GROUP_SECTION_INDEX: {
                if (sender.on == 1)
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_FocusGroup preferredStyle:UIAlertControllerStyleAlert];
                else
                    alertController = [UIAlertController alertControllerWithTitle:@"" message: kAlert_NotAFocusGroup preferredStyle:UIAlertControllerStyleAlert];
            }
                break;
            default: { // All Feeds Updates
                NSString *str = [[sectionsArray objectAtIndex:sender.tag] valueForKey:@"field"];
                
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
-(void)getSettingsList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileSetting_UserID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getSettingsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                NSDictionary *settingListDict = [[responseDict valueForKey:kSettingsAPI_List] copy];

                for ( int i = 0; i < sectionsArray.count ; i++ ) {
                    NSString *key = [[sectionsArray objectAtIndex:i] valueForKey:@"key"] ;
                    if([settingListDict valueForKey:key])
                        [[sectionsArray objectAtIndex:i] setValue:[settingListDict valueForKey:key] forKey:@"value"] ;
                }
                NSLog(@"Section Array : %@", sectionsArray);
                [tblView reloadData] ;
            }
            else
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }];
    }
}

-(void)updateProfileSettingsWithStatus:(BOOL)isEnable apiTag:(NSUInteger)tag {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileSetting_UserID] ;
        
        if (tag == PUBLIC_PROFILE_SECTION_INDEX)
            [dictParam setObject:(isEnable == 1?@"true":@"false") forKey:kProfileSetting_PublicProfile] ;
        else
            [dictParam setObject:(isEnable == 1?@"true":@"false") forKey:kProfileSetting_Notification] ;
        
        NSLog(@"Params: %@", dictParam);
        
        [ApiCrowdBootstrap updateProfileSettingsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                [[sectionsArray objectAtIndex:tag] setValue:[NSString stringWithFormat:@"%d", isEnable] forKey:@"value"] ;
            }
            else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)updateSettingsWithStatus:(BOOL)isEnable apiTag:(NSUInteger)tag {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileSetting_UserID] ;
        
        NSString *key = [[sectionsArray objectAtIndex:tag] valueForKey:@"key"] ;
        [dictParam setObject:key forKey:@"type"] ;
        
        NSLog(@"Param Dict %@", dictParam);

        if (isEnable == 1) {
            [ApiCrowdBootstrap registerForRoleWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                    NSLog(@"responseDict %@", responseDict);
                    [[sectionsArray objectAtIndex:tag] setValue:[NSString stringWithFormat:@"%d", isEnable] forKey:@"value"] ;
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
                    [[sectionsArray objectAtIndex:tag] setValue:[NSString stringWithFormat:@"%d", isEnable] forKey:@"value"] ;
                }
                else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                
            } failure:^(NSError *error) {
                [UtilityClass displayAlertMessage:error.description] ;
                [UtilityClass hideHud] ;
            }] ;
        }
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;

    cell.settingsLbl.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"];
    cell.settingsSwitch.tag = indexPath.section;
    int isSelected = [[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"] intValue];

    if (isSelected == 1)
        [cell.settingsSwitch setOn:YES];
    else
        [cell.settingsSwitch setOn:NO];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == AUDIO_VIDEO_UPDATES_SECTION_INDEX)
        return 45;
    else
        return 0 ;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == AUDIO_VIDEO_UPDATES_SECTION_INDEX)
        return @"Enable/Disable 'What's New' Sources";
    else
        return @"";
}
@end
