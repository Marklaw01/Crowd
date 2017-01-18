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

-(void)resetUISettings{
    settingsArray = [[NSMutableArray alloc] init] ;
    NSMutableDictionary *notificationDict = [[NSMutableDictionary alloc] init] ;
    [notificationDict setValue:[UtilityClass getNotificationSettings] forKey:@"isSelected"] ;
    [notificationDict setValue:@"Notifications" forKey:@"name"] ;
    [settingsArray addObject:notificationDict] ;
    
    NSMutableDictionary *profileDict = [[NSMutableDictionary alloc] init] ;
    NSLog(@"isPublicProfile: %@",[[UtilityClass getLoggedInUserDetails]  valueForKey:@"isPublicProfile"]) ;
    NSString *isPublicProfile = [NSString stringWithFormat:@"%@",[[UtilityClass getLoggedInUserDetails]  valueForKey:@"isPublicProfile"]] ;
    [profileDict setValue:isPublicProfile forKey:@"isSelected"] ;
    //[profileDict setValue:([isPublicProfile isEqualToString:@"true"]?@"true":@"false") forKey:@"isSelected"] ;
    [profileDict setValue:@"Make My Profile Public" forKey:@"name"] ;
    
    [settingsArray addObject:profileDict] ;
    
    [tblView reloadData] ;
    
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSLog(@"settings >> %@",[UtilityClass getNotificationSettings] ) ;
   /* NSMutableDictionary *settingsDict = [[UtilityClass getSettingsDetails] mutableCopy] ;
    [settingsDict setValue:(!sender.on ==1?@"true":@"false") forKey:@"Notification"] ;
    
    [UtilityClass setSettingsDetails:settingsDict] ;*/
}

#pragma mark - IBAction Methods
- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    
}

- (IBAction)switchStatusChange:(UISwitch *)sender
{
    if(sender.tag == PUBLIC_PROFILE_SELECTED){
        
        NSString *msg = (sender.on ?@"public?":@"private?") ;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@%@",kAlert_Settings,msg] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            [self updateProfileSettingsWithStatus:sender.on] ;
            
        }];
        UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [sender setOn:!sender.on] ;
        }];
        
        [alertController addAction:yes];
        [alertController addAction:no];
        
        [self presentViewController:alertController animated:YES completion:nil] ;
    }
    else{ // NOTIFICATIONS
        
        NSString *msg = (sender.on ?@"enable":@"disable") ;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@%@ notifications?",kAlert_StartTeam,msg] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            if(sender.on == 1){
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kNotification_EnablePush
                 object:self];
                [UtilityClass setNotificationSettings:@"true"] ;
            }
            else{
                
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
        
        
       // [UtilityClass setNotificationSettings:(sender.on ==1?@"1":@"0")] ;
    }
   
}

#pragma mark - Api Methods
-(void)updateProfileSettingsWithStatus:(BOOL)isProfilePublic{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileSetting_UserID] ;
         [dictParam setObject:(isProfilePublic ==1?@"true":@"false") forKey:kProfileSetting_PublicProfile] ;
        
        [ApiCrowdBootstrap updateProfileSettingsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSMutableDictionary* userDict = [[UtilityClass getLoggedInUserDetails] mutableCopy] ;
                [userDict setValue:(isProfilePublic ==1?@"true":@"false") forKey:@"isPublicProfile"] ;
                NSLog(@"(userDict: %@",userDict) ;
                [UtilityClass setLoggedInUserDetails:userDict] ;
            }
            else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return settingsArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.settingsLbl.text = [[settingsArray objectAtIndex:indexPath.row] valueForKey:@"name"] ;
    cell.settingsSwitch.tag = indexPath.row ;
    NSString *isSelected = [NSString stringWithFormat:@"%@",[[settingsArray objectAtIndex:indexPath.row] valueForKey:@"isSelected"]] ;
    [cell.settingsSwitch setOn:([isSelected isEqualToString:@"true"]?YES:NO)] ;
    return cell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 ;
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
