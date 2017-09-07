//
//  NotificationsViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 13/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "NotificationsViewController.h"
#import "SWRevealViewController.h"
#import "NotificationsTableViewCell.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tblView.estimatedRowHeight = 110 ;
    tblView.rowHeight = UITableViewAutomaticDimension ;
    
    [tblView setNeedsLayout] ;
    [tblView layoutIfNeeded] ;
    
    [self resetUISettings] ;
    [self navigationBarSettings] ;
//    [self revealViewSettings] ;
    [self updateNotificationCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings {
    if(notificationsArray)[notificationsArray removeAllObjects] ;
    else notificationsArray = [[NSMutableArray alloc] init] ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblView.hidden = YES ;
    pageNo = 1 ;
    totalItems = 0 ;
    
    [self getNotificationsList] ;
}

-(void)navigationBarSettings {
    self.title = @"Notifications" ;
}

#pragma mark - Public Methods
-(void)refreshUIContentWithTitle:(NSString*)viewTitle {
    self.title = viewTitle ;
    self.navigationItem.hidesBackButton = YES ;
    
    // Set Menu Bar Button Item
    UIImage *image = [UIImage imageNamed:@"menu.png"];
    UIBarButtonItem *menuBarBtn = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    
    // Set the gesture
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
    
    self.navigationItem.leftBarButtonItem = menuBarBtn;
}

/*
-(void)revealViewSettings {
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    menuBarBtn.target = self.revealViewController;
    menuBarBtn.action = @selector(revealToggle:);
    
    // Set the gesture
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
   // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}
*/

#pragma mark - API Methods
-(void)getNotificationsList {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kNotificationsAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kNotificationsAPI_PageNo] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getNotificationsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kNotificationsAPI_Notifications]){
                    totalItems = [[responseDict valueForKey:kNotificationsAPI_TotalItems] intValue] ;
                    for (NSDictionary *dict in (NSArray*)[responseDict valueForKey:kNotificationsAPI_Notifications]) {
                        [notificationsArray addObject:dict] ;
                    }
                    //notificationsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kNotificationsAPI_Notifications]] ;
                    [tblView reloadData] ;
                    if(notificationsArray.count <1)[tblView setHidden:YES] ;
                    else [tblView setHidden:NO] ;
                    pageNo ++ ;
                }
            }
            //else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)updateNotificationCount {
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupTeamAPI_UserID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap updateNotificationCountWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"Success");
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

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
                [self resetUISettings] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)rejectConnectionWithStatus:(NSString*)status withUserID:(NSString*)userID andconnectionID:(NSString*)connectionID {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:userID forKey:kConnectUserAPI_UserID] ;
        [dictParam setObject:connectionID forKey:kConnectUserAPI_ConnectionID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap disconnectUserWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)acceptConnectionWithStatus:(NSString*)status withUserID:(NSString*)userID andconnectionID:(NSString*)connectionID {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:userID forKey:kConnectUserAPI_UserID] ;
        [dictParam setObject:connectionID forKey:kConnectUserAPI_ConnectionID] ;
        [dictParam setObject:status forKey:kConnectUserAPI_Status] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap acceptConnectionWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(notificationsArray.count == totalItems) return notificationsArray.count ;
    else return notificationsArray.count+1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == notificationsArray.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
        [activityIndicator startAnimating];
        return cell ;
    }
    else{
        NotificationsTableViewCell *cell = (NotificationsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MessagesCell] ;
        cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] valueForKey:kNotificationsAPI_Message]]  ;
        cell.timeLbl.text = [UtilityClass formatDateFromString:[NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] valueForKey:kNotificationsAPI_Time]]]  ;
        
        return cell ;
    }
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == notificationsArray.count) return 30 ;
    else return 110 ;
}*/

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == notificationsArray.count){
        [self getNotificationsList] ;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSLog(@"array >>> %@",[notificationsArray objectAtIndex:indexPath.row]) ;
    
    NSString *tag = [NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] valueForKey:kNotificationsAPI_Tags]] ;
    
    // Add Team Member
    if([tag isEqualToString:TAG_ADD_TEAM_MEMBER]){
        
        NSString *jsonString = [NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] valueForKey:kNotificationsAPI_Values]];
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:(NSDictionary*)json] ;
        NSLog(@"dict: %@",dict) ;
        NSString *status = [NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] valueForKey:@"status"]] ;
        if([status isEqualToString:@"1"]){
            [self presentViewController:[UtilityClass displayAlertMessage:kAlert_NotificationAlreadyAdded] animated:YES completion:nil] ;
             ;
        }
        else{
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Do you want to work with this team?" message:[NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] valueForKey:kNotificationsAPI_Message]] preferredStyle:UIAlertControllerStyleAlert];
            [alertController.view setTintColor:[UtilityClass blueColor]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil] ;
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self updateTeamMemberStatusWithStatus:@"1" withStartupID:[dict valueForKey:@"startup_id"] andNotificationID:[[notificationsArray objectAtIndex:indexPath.row] valueForKey:@"id"]] ;
                //[self updateTeamMemberStatusWithStatus:@"1" withStartupID:[dict valueForKey:@"startup_id"]] ;
                //[self dismissViewControllerAnimated:YES completion:nil] ;
                
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self updateTeamMemberStatusWithStatus:@"3" withStartupID:[dict valueForKey:@"startup_id"] andNotificationID:[[notificationsArray objectAtIndex:indexPath.row] valueForKey:@"id"]] ;
                // [self updateTeamMemberStatusWithStatus:@"3" withStartupID:[dict valueForKey:@"startup_id"]] ;
                //[self dismissViewControllerAnimated:YES completion:nil] ;
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil] ;
        }
    }
    
    
    // Comment Forum / Forum Report Abuse
    else if ([tag isEqualToString:TAG_COMMENT_FOURM] || [tag isEqualToString:TAG_REPORT_ABUSE_FORUM]){
        
        NSString *jsonString = [NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] valueForKey:kNotificationsAPI_Values]];
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:(NSDictionary*)json] ;
        NSMutableDictionary *forumDict = [[NSMutableDictionary alloc] init] ;
        [forumDict setValue:[dict valueForKey:@"forum_id"] forKey:kMyForumAPI_ForumID] ;
        [forumDict setValue:[dict valueForKey:@"forum_name"] forKey:kMyForumAPI_ForumTitle] ;
        NSLog(@"dict: %@",forumDict) ;
        [UtilityClass setForumType:YES] ;
        [UtilityClass setForumDetails:(NSMutableDictionary*)forumDict] ;
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kForumDetailIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
    
    // Commit / Uncommit Campaign
    else if ([tag isEqualToString:TAG_COMMIT_CAMPAIGN] || [tag isEqualToString:TAG_UNCOMMIT_CAMPAIGN]){
       
        NSString *jsonString = [NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] valueForKey:kNotificationsAPI_Values]];
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)json] ;
        NSLog(@"dict: %@",dict) ;
        [UtilityClass setCampaignMode:YES] ;
        [UtilityClass setCampaignDetails:dict] ;
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kViewContractorIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
    // Accept / Reject Connection
    else if ([tag isEqualToString:TAG_ADD_CONNECTION]) {
        
        NSString *jsonString = [NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] valueForKey:kNotificationsAPI_Values]];
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)json] ;
        NSLog(@"dict: %@",dict) ;
        
        NSString *status = [NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] valueForKey:@"status"]] ;
        if([status isEqualToString:@"1"]) {
            [self presentViewController:[UtilityClass displayAlertMessage:kAlert_NotificationAlreadyAdded] animated:YES completion:nil] ;
            ;
        } else {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Do you want to accept the connection?" message:[NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] valueForKey:kNotificationsAPI_Message]] preferredStyle:UIAlertControllerStyleAlert];
            [alertController.view setTintColor:[UtilityClass blueColor]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil] ;
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self acceptConnectionWithStatus:@"1" withUserID:[dict valueForKey:@"user_id"] andconnectionID:[dict valueForKey:@"connection_id"]];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Reject" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self rejectConnectionWithStatus:@"1" withUserID:[dict valueForKey:@"user_id"] andconnectionID:[dict valueForKey:@"connection_id"]];
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil] ;
        }
    }

    // Message
    else if([tag isEqualToString:TAG_MESSAGE]) {
       
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kMessagesIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
    
    // Follow / Unfollow Camapaign
    else if([tag isEqualToString:TAG_UNFOLLOW_CAMPAIGN] || [tag isEqualToString:TAG_FOLLOW_CAMPAIGN]) {
        
        NSString *jsonString = [NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] valueForKey:kNotificationsAPI_Values]];
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)json] ;
        NSLog(@"dict: %@",dict) ;
        [UtilityClass setCampaignMode:YES] ;
        [UtilityClass setCampaignDetails:dict] ;
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditCampaignViewIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
    
    // Rate User
    else if([tag isEqualToString:TAG_RATE_PROFILE]) {
        
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
}

@end
