//
//  Team_StartupViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 20/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "Team_StartupViewController.h"
#import "SWTableViewCell.h"
#import "MessagesTableViewCell.h"
#import "TeamMessageViewController.h"
#import "SearchContractorViewController.h"
#import "PublicProfileViewController.h"
#import "ChatViewController.h"

@interface Team_StartupViewController ()

@end

@implementation Team_StartupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetUISettings] ;
    [self quickBloxSettings] ;
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [self getStartupTeamData] ;
}

#pragma mark - Custom Methods
-(void)resetUISettings {
    
    rolesArray = @[TEAM_TYPE_COFOUNDER,TEAM_TYPE_TEAM_MEMEBER,TEAM_TYPE_CONTRACTOR] ;
    sectionsArray = [[NSMutableArray alloc] init] ;
    searchResults = [[NSMutableArray alloc] init] ;
    dialogsArray = [[NSArray alloc] init] ;
    loggedInUserRole = @"" ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startupTeamDataNotification:)
                                                 name:kNotificationStartupTeam
                                               object:nil];
    
    
    // Check for Startup Type -- If completed startup - disable
    if([UtilityClass getStartupType] == COMPLETEED_SELECTED) {
        groupchatButton.userInteractionEnabled = NO ;
        groupchatButton.alpha = 0.7;
        recommendedContractorButton.userInteractionEnabled = NO ;
        recommendedContractorButton.alpha = 0.7;
        
    }
    else{
        groupchatButton.userInteractionEnabled = YES ;
        groupchatButton.alpha = 1;
        recommendedContractorButton.userInteractionEnabled = YES ;
        recommendedContractorButton.alpha = 1;
    }
    
    
    //[self configureSearchController] ;

}

/*-(void)configureSearchController{
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    searchController.searchBar.placeholder = kSearchBarPlaceholder ;
    [searchController.searchBar sizeToFit] ;
    searchController.searchResultsUpdater = self ;
    searchController.dimsBackgroundDuringPresentation = NO ;
    searchController.definesPresentationContext = YES ;
    searchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = searchController.searchBar ;
}*/

#pragma mark - Notifcation Methods
- (void)startupTeamDataNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationStartupTeam]) {
        
        [self getStartupTeamData] ;
    }
}

#pragma mark - API Methods
-(void)getStartupTeamData {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupTeamAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:kStartupTeamAPI_StartupID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getStartupTeamWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                
                if(sectionsArray)[sectionsArray removeAllObjects] ;
                else sectionsArray = [[NSMutableArray alloc] init] ;
                
                if([responseDict valueForKey:kStartupTeamAPI_LoggedInRoleID]) {
                     loggedInUserRoleID = [[responseDict valueForKey:kStartupTeamAPI_LoggedInRoleID] intValue] ;
                }
                // Add Entrepreneur's Details
                if([responseDict valueForKey:kStartupTeamAPI_Entrepreneur]) {
                    NSDictionary *entrepreneurDict = [responseDict valueForKey:kStartupTeamAPI_Entrepreneur] ;
                    NSMutableDictionary *obj = [[NSMutableDictionary alloc] init] ;
                    [obj setValue:TEAM_TYPE_ENTREPRENEUR forKey:@"role"] ;
                    NSMutableArray *membersArray = [[NSMutableArray alloc] init] ;
                    NSMutableDictionary *teamDict = [[NSMutableDictionary alloc] init] ;
                    [teamDict setValue:[entrepreneurDict valueForKey:kStartupTeamAPI_EntrepreneurName] forKey:kStartupTeamAPI_MemberName] ;
                    [teamDict setValue:[entrepreneurDict valueForKey:kStartupTeamAPI_EntrepreneurBio] forKey:kStartupTeamAPI_MemberBio] ;
                    [teamDict setValue:[entrepreneurDict valueForKey:kStartupTeamAPI_EntrepreneurEmail] forKey:kStartupTeamAPI_MemberEmail] ;
                    [teamDict setValue:@"1" forKey:kStartupTeamAPI_MemberStatus] ;
                    [teamDict setValue:TEAM_TYPE_ENTREPRENEUR forKey:kStartupTeamAPI_MemberRole] ;
                    [teamDict setValue:[entrepreneurDict valueForKey:kStartupTeamAPI_EntrepreneurID] forKey:kStartupTeamAPI_TeamMemberID] ;
                    [teamDict setValue:[entrepreneurDict valueForKey:kStartupTeamAPI_QuickbloxID] forKey:kStartupTeamAPI_QuickbloxID] ;
                    [teamDict setValue:[entrepreneurDict valueForKey:kRecommendedContAPI_Is_Profile_Pubilc] forKey:kRecommendedContAPI_Is_Profile_Pubilc] ;
                    [membersArray addObject:teamDict] ;
                    [obj setObject:membersArray forKey:@"team"] ;
                    [sectionsArray addObject:obj] ;
                    
                    
                    if([[entrepreneurDict valueForKey:kStartupTeamAPI_EntrepreneurID] intValue] == [UtilityClass getLoggedInUserID]){
                        loggedInUserRole = TEAM_TYPE_ENTREPRENEUR ;
                    }
                }
                
                // Add Team Members Details
                if([responseDict valueForKey:kStartupTeamAPI_TeamMember]){
                   
                    for (NSString *teamType in rolesArray) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] init] ;
                        [obj setValue:teamType forKey:@"role"] ;
                        NSMutableArray *membersArray = [[NSMutableArray alloc] init] ;
                        for (NSDictionary *dict in [responseDict valueForKey:kStartupTeamAPI_TeamMember]) {
                            // get Member Role
                            NSString *memberRole = [NSString stringWithFormat:@"%@",[dict valueForKey:kStartupTeamAPI_MemberRole]] ;
                            if([memberRole isEqualToString:teamType]) {
                                [membersArray addObject:dict] ;
                            }
                            
                            // get startup_teamID
//                            NSString *startup_TeamID = [NSString stringWithFormat:@"%@",[dict valueForKey:kStartupTeamAPI_Startup_TeamID]] ;

                            // get Logged In User Role
                            if([[dict valueForKey:kStartupTeamAPI_TeamMemberID] intValue] == [UtilityClass getLoggedInUserID]){
                                loggedInUserRole = memberRole ;
                            }
                        }
                        [obj setObject:membersArray forKey:@"team"] ;
                        [sectionsArray addObject:obj] ;
                    }
                    
                    if([loggedInUserRole isEqualToString:TEAM_TYPE_CONTRACTOR])recommendedContractorButton.hidden = YES ;
                    else recommendedContractorButton.hidden = NO ;
                    
                    [tblView reloadData] ;
                    
                }
              
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)updateTeamMemberStatusWithStatus:(NSString*)status withIndexPath:(NSIndexPath*)cellIndexPath {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[[[sectionsArray objectAtIndex:cellIndexPath.section] objectForKey:@"team"] objectAtIndex:cellIndexPath.row] objectForKey:kStartupTeamAPI_TeamMemberID]] forKey:kStartupTeamAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:kStartupTeamAPI_StartupID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[[[sectionsArray objectAtIndex:cellIndexPath.section] objectForKey:@"team"] objectAtIndex:cellIndexPath.row] objectForKey:kStartupTeamAPI_Startup_TeamID]] forKey:kStartupTeamAPI_Startup_TeamID] ;

        [dictParam setObject:status forKey:kStartupTeamMemberStatusAPI_Status] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupTeamMemberStatusAPI_LoginUserID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap updateStartupTeamMemberStatusWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                
                if([status intValue] == MEMBER_REMOVED) {
                    [UtilityClass showNotificationMessgae:[NSString stringWithFormat:@"%@ removed.",[[sectionsArray objectAtIndex:cellIndexPath.section] valueForKey:@"role"]] withResultType:@"1" withDuration:1] ;
                    NSLog(@"cellIndexPath: %ld  section: %ld",(long)cellIndexPath.row,cellIndexPath.section) ;
                    //[tblView beginUpdates] ;
                    if([[[sectionsArray objectAtIndex:cellIndexPath.section] objectForKey:@"team"] objectAtIndex:cellIndexPath.row]) {
                        [[[sectionsArray objectAtIndex:cellIndexPath.section] objectForKey:@"team"] removeObjectAtIndex:cellIndexPath.row] ;
                        [tblView reloadData] ;
                        /*[tblView deleteRowsAtIndexPaths:@[cellIndexPath]
                                       withRowAnimation:UITableViewRowAnimationAutomatic];*/
                    }
                    //[tblView endUpdates] ;
                }
                else {
                     [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
                    NSMutableArray *teamArray = [[NSMutableArray arrayWithArray:[[sectionsArray objectAtIndex:cellIndexPath.section]objectForKey:@"team"]] mutableCopy] ;
                    NSMutableDictionary *teamDict = (NSMutableDictionary*)[[teamArray objectAtIndex:cellIndexPath.row] mutableCopy] ;
                    [teamDict setValue:status forKey:kStartupTeamAPI_MemberStatus] ;
                    [teamArray replaceObjectAtIndex:cellIndexPath.row withObject:teamDict] ;
                    [[sectionsArray objectAtIndex:cellIndexPath.section] setObject:teamArray forKey:@"team"] ;
                    
                    [tblView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationRight] ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

/*#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = searchController.searchBar.text ;
    [self filterContentForSearchText:searchString];
    
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    if (searchText == nil) {
        
        // If empty the search results are the same as the original data
        searchResults = [sectionsArray  mutableCopy];
    } else {
        
        [searchResults removeAllObjects] ;
        for (NSDictionary *dict in sectionsArray) {
            
            NSString *name = [NSString stringWithFormat:@"%@",[dict valueForKey:kStartupsAPI_StartupName]] ;
            if([name containsString:searchText]){
                [searchResults addObject:dict] ;
            }
        }
    }
    [tblView reloadData] ;
}*/


#pragma mark - Cell Buttons Methods
- (IBAction)Chat_ClickAction:(UIButton*)button {
    if([UtilityClass getStartupType] != COMPLETEED_SELECTED){
        NSMutableArray *teamArr = [NSMutableArray arrayWithArray:[[sectionsArray objectAtIndex:button.tag] objectForKey:@"team"]] ;
        NSLog(@"selected uer: %@",[teamArr objectAtIndex:[button.accessibilityValue intValue]]) ;
        
        [UtilityClass setSelectedChatUserName:[NSString stringWithFormat:@"%@",[[teamArr objectAtIndex:[button.accessibilityValue intValue]] valueForKey:kStartupTeamAPI_MemberName]] ] ;
        if([[[teamArr objectAtIndex:[button.accessibilityValue intValue]] valueForKey:kStartupTeamAPI_QuickbloxID]intValue]){
            QBUUser *user = [QBUUser user];
            user.ID = [[[teamArr objectAtIndex:[button.accessibilityValue intValue]] valueForKey:kStartupTeamAPI_QuickbloxID]intValue]  ;
            user.login = [NSString stringWithFormat:@"%@",[[teamArr objectAtIndex:[button.accessibilityValue intValue]] valueForKey:kStartupTeamAPI_MemberName]] ;
            NSLog(@"qbUser: %@",user) ;
            
            [ServicesManager.instance.chatService createPrivateChatDialogWithOpponent:user completion:^(QBResponse *response, QBChatDialog *createdDialog) {
                if (!response.success && createdDialog == nil) {
                    NSLog(@"errror >> ") ;
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
    }
}

- (IBAction)Email_ClickAction:(UIButton*)button {
    
    if([UtilityClass getStartupType] != COMPLETEED_SELECTED){
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
            [composeViewController setMailComposeDelegate:self];
            composeViewController.mailComposeDelegate = self ;
            composeViewController.title = @"Email" ;
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[[sectionsArray objectAtIndex:button.tag] objectForKey:@"team"] objectAtIndex:[button.accessibilityValue intValue]]] ;
            [composeViewController setToRecipients:@[[NSString stringWithFormat:@"%@",[dict valueForKey:kStartupTeamAPI_MemberEmail]]]];
            [composeViewController setCcRecipients:@[]] ;
            [composeViewController setBccRecipients:@[]] ;
            [self presentViewController:composeViewController animated:YES completion:nil];
        }
        else{
            [self presentViewController:[UtilityClass displayAlertMessage:kAlert_TeamEmailError] animated:YES completion:nil];
        }
    }
}

- (IBAction)Message_ClickAction:(UIButton*)button {
    if([UtilityClass getStartupType] != COMPLETEED_SELECTED){
        NSLog(@"loggedInUserRoleID: %d",loggedInUserRoleID) ;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        /*NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: [[[[sectionsArray objectAtIndex:button.tag] objectForKey:@"team"] objectAtIndex:[button.accessibilityValue intValue]] mutableCopy]] ;
         [dict setValue:[NSString stringWithFormat:@"%d",loggedInUserRoleID]  forKey:kStartupTeamMesageAPI_RoleID] ;*/
        TeamMessageViewController *viewController = (TeamMessageViewController*)[storyboard instantiateViewControllerWithIdentifier:kTeamMessageIdentifier] ;
        viewController.dict = [[[sectionsArray objectAtIndex:button.tag] objectForKey:@"team"] objectAtIndex:[button.accessibilityValue intValue]] ;
        [UtilityClass setTeamMemberRole:[NSString stringWithFormat:@"%d",loggedInUserRoleID]] ;
        // viewController.roleID = [NSString stringWithFormat:@"%d",loggedInUserRoleID] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
}

#pragma mark - IBAction Methods
- (IBAction)RecommendedContractors_ClickAction:(id)sender {
    [UtilityClass setSearchContractorMode:NO] ;
    [UtilityClass setTeamMemberRole:loggedInUserRole] ;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchContractorViewController *viewController = (SearchContractorViewController*)[storyboard instantiateViewControllerWithIdentifier:kSearchContractorViewIdentifier] ;
    viewController.startupID = [NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)GroupChat_ClickAction:(id)sender {
    if(!occupantIDsArray) {
        occupantIDsArray = [[NSMutableArray alloc] init] ;
        quickbloxIDsArray = [[NSMutableArray alloc] init] ;
        
        for (NSDictionary *dict in sectionsArray) {
            NSArray *teamArray = [NSArray arrayWithArray:(NSArray*)[dict objectForKey:@"team"]] ;
            for (NSDictionary *userDict in teamArray) {
                if([[userDict valueForKey:kStartupTeamAPI_QuickbloxID] intValue]){
                    [quickbloxIDsArray addObject:[userDict valueForKey:kStartupTeamAPI_QuickbloxID] ] ;
                    QBUUser *user = [QBUUser user];
                    user.ID = [[userDict valueForKey:kStartupTeamAPI_QuickbloxID] intValue];
                    user.email = [userDict valueForKey:kStartupTeamAPI_MemberEmail] ;
                    [occupantIDsArray addObject:user] ;
                }
            }
        }
    }
    if(occupantIDsArray.count < MIN_TEAM_NUMBER_GROUPCHAT) {
        [self presentViewController:[UtilityClass displayAlertMessage:VALIDATION_GROUP_CHAT] animated:YES completion:nil]
         ;
        return ;
        
    }
    [UtilityClass setSelectedChatUserName:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupName]]] ;
    
    
    // Check if Group already exists
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
    [dict setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:@"startup_id"] ;
    [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
    [QBRequest objectsWithClassName:QUICKBLOX_CUSTOM_CLASS extendedRequest:dict successBlock:^(QBResponse * _Nonnull response, NSArray<QBCOCustomObject *> * _Nullable objects, QBResponsePage * _Nullable page) {
        [UtilityClass hideHud] ;
        NSLog(@"Success  : %@", objects) ;
        // Create New Group
        if(objects.count == 0){
            [self createNewGroupForTeam] ;
        }
        
        // Update Existing Group
        else{
            
            QBCOCustomObject *customObj = [objects lastObject] ;
            NSLog(@"startup_id: %@ dialogID: %@",[customObj.fields valueForKey:@"startup_id"],[customObj.fields valueForKey:@"dialog_id"]) ;
            NSString *dialogID = [NSString stringWithFormat:@"%@",[customObj.fields valueForKey:@"dialog_id"]] ;
            if(dialogID){
                
               /* QBChatDialog *updateDialog = [[QBChatDialog alloc] initWithDialogID:dialogID type:QBChatDialogTypeGroup];
                updateDialog.pushOccupantsIDs = quickbloxIDsArray;
                
                [QBRequest updateDialog:updateDialog successBlock:^(QBResponse *responce, QBChatDialog *dialog) {
                    NSLog(@"resp: %@, dialog: %@",responce,dialog) ;
                    if(dialog){
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        
                        teamchatDialog = dialog ;
                        
                        ChatViewController *viewController = (ChatViewController*)[storyboard instantiateViewControllerWithIdentifier:kChatUserViewIdentifier] ;
                        viewController.dialog = dialog ;
                        
                        [self.navigationController pushViewController:viewController animated:YES] ;
                    }
                    else{
                        [UtilityClass showNotificationMessgae:@"You don't have appropriate permissions to perform this operation" withResultType:@"1" withDuration:1] ;
                    }
                    
                } errorBlock:^(QBResponse *response) {
                     NSLog(@"resp: %@",response.error.reasons) ;
                    [UtilityClass showNotificationMessgae:@"You don't have appropriate permissions to perform this operation." withResultType:@"1" withDuration:1] ;
                }];*/
                
                
                [ServicesManager.instance.chatService fetchDialogWithID:dialogID completion:^(QBChatDialog * _Nullable dialog) {
                    [UtilityClass hideHud] ;
                 
                   
                    dialog.occupantIDs = quickbloxIDsArray ;
                     NSLog(@"dialog: %@ ",dialog) ;
                    
                    [QBRequest updateDialog:dialog successBlock:^(QBResponse * _Nonnull response, QBChatDialog * _Nullable chatDialog) {
                        NSLog(@" chatDialog: %@",chatDialog) ;
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        
                        teamchatDialog = dialog ;
                        
                        ChatViewController *viewController = (ChatViewController*)[storyboard instantiateViewControllerWithIdentifier:kChatUserViewIdentifier] ;
                        viewController.dialog = dialog ;
                        
                        [self.navigationController pushViewController:viewController animated:YES] ;
                        
                    } errorBlock:^(QBResponse * _Nonnull response) {
                        NSLog(@"response:%@ ",response.error.reasons) ;
                        
                        [UtilityClass showNotificationMessgae:@"You don't have appropriate permissions to perform this operation." withResultType:@"1" withDuration:1] ;
                    }] ;
                    
                    /*[ServicesManager.instance.chatService joinOccupantsWithIDs:quickbloxIDsArray toChatDialog:dialog completion:^(QBResponse * _Nonnull response, QBChatDialog * _Nullable updatedDialog) {
                        if(updatedDialog){
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            
                            teamchatDialog = updatedDialog ;
                            
                            ChatViewController *viewController = (ChatViewController*)[storyboard instantiateViewControllerWithIdentifier:kChatUserViewIdentifier] ;
                            viewController.dialog = updatedDialog ;
                            
                            [self.navigationController pushViewController:viewController animated:YES] ;
                        }
                        else{
                            [UtilityClass showNotificationMessgae:@"You don't have appropriate permissions to perform this operation." withResultType:@"1" withDuration:1] ;
                        }
                        NSLog(@"updatedDialog: %@ response: %@",response,response.error.reasons) ;
                        
                    }] ;*/
                    
                }] ;
            }
           
           // NSLog(@"dialogs: %@",dialogsArray) ;
          //  QBChatDialog *dialog
         /*   if(dialogs){
                for (QBChatDialog *chatDialog in dialogs) {
                    NSLog(@"chatDialog: %@",chatDialog) ;
                   // if(chatDialog)
                }
            }*/
         
            [self updateExistingGroup] ;
        }
        
    } errorBlock:^(QBResponse * _Nonnull response) {
         [UtilityClass hideHud] ;
        NSLog(@"Error: %@",response.error.description) ;
    }] ;
    
   /* [UtilityClass setSelectedChatUserName:@"Group Chat"] ;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kChatUserViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;*/
}

-(void)createNewGroupForTeam{
    
    [UtilityClass showHudWithTitle:kHUDMessage_CreateGroup] ;
  
    [ServicesManager.instance.chatService createGroupChatDialogWithName:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupName]]  photo:nil occupants:occupantIDsArray completion:^(QBResponse * _Nonnull response, QBChatDialog * _Nullable createdDialog) {
        if(response && createdDialog){
            
            // Save Startup id in Custom Object
            QBCOCustomObject *object = [QBCOCustomObject customObject];
            object.className = QUICKBLOX_CUSTOM_CLASS;
            // Object fields
            [object.fields setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:@"startup_id"];
            [object.fields setObject:createdDialog.ID forKey:@"dialog_id"];
            
            [QBRequest createObject:object successBlock:^(QBResponse *response, QBCOCustomObject *object) {
                // do something when object is successfully created on a server
                [UtilityClass hideHud] ;
                [UtilityClass setSelectedChatUserName:createdDialog.name] ;
                [UtilityClass showNotificationMessgae:kAlert_GroupCreatedSuccess withResultType:@"1" withDuration:1] ;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                teamchatDialog = createdDialog ;
                
                ChatViewController *viewController = (ChatViewController*)[storyboard instantiateViewControllerWithIdentifier:kChatUserViewIdentifier] ;
                viewController.dialog = createdDialog ;
                
                NSLog(@"qbChatDialog: %@",createdDialog) ;
                [self.navigationController pushViewController:viewController animated:YES] ;
                
            } errorBlock:^(QBResponse *response) {
                // error handling
                [UtilityClass hideHud] ;
                NSLog(@"Response error: %@", [response.error description]);
            }];
        }
    }] ;
}

-(void)updateExistingGroup{
   // [UtilityClass showHudWithTitle:kHUDMessage_CreateGroup] ;
   // [ServicesManager.instance.chatService ]
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *teamArr = [NSMutableArray arrayWithArray:[[sectionsArray objectAtIndex:section] objectForKey:@"team"]] ;
    if(teamArr.count ==0)return 1 ;
    else return teamArr.count ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionsArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *teamArr = [NSMutableArray arrayWithArray:[[sectionsArray objectAtIndex:indexPath.section] objectForKey:@"team"]] ;
    if(teamArr.count != 0){
        MessagesTableViewCell *cell = (MessagesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"teamCell"] ;
        
        NSMutableArray *teamArr = [NSMutableArray arrayWithArray:[[sectionsArray objectAtIndex:indexPath.section] objectForKey:@"team"]] ;
        cell.messageLbl.text = [NSString stringWithFormat:@"%@",[[teamArr objectAtIndex:indexPath.row] valueForKey:kStartupTeamAPI_MemberName]] ;
        cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[teamArr objectAtIndex:indexPath.row] valueForKey:kStartupTeamAPI_MemberBio]] ;
        NSString *role = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"role"]] ;
        cell.chatBtn.tag = indexPath.section ;
        cell.chatBtn.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row] ;
        cell.messageBtn.tag = indexPath.section ;
        cell.messageBtn.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row] ;
        cell.emailBtn.tag = indexPath.section ;
        cell.emailBtn.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row] ;
        
        float buttonAlpha = ([UtilityClass getStartupType] == COMPLETEED_SELECTED ? 0.7 : 1) ;
        cell.chatBtn.alpha = buttonAlpha ;
        cell.messageBtn.alpha = buttonAlpha ;
        cell.emailBtn.alpha = buttonAlpha ;
        
       
        if([UtilityClass getStartupType] != COMPLETEED_SELECTED){
            // Update Cell Swipable according to member role
            if(![role isEqualToString:TEAM_TYPE_ENTREPRENEUR]){
                
                NSString *isSuspended = [NSString stringWithFormat:@"%@",[[teamArr objectAtIndex:indexPath.row] valueForKey:kStartupTeamAPI_MemberStatus]] ;
                if([loggedInUserRole isEqualToString:TEAM_TYPE_ENTREPRENEUR]){
                    
                    [self updateCellAccordingToUserRoleForCell:cell withMemberStatus:isSuspended] ;
                }
                else if([loggedInUserRole isEqualToString:TEAM_TYPE_COFOUNDER]){
                    if([role isEqualToString:TEAM_TYPE_TEAM_MEMEBER] || [role isEqualToString:TEAM_TYPE_CONTRACTOR]){
                        [self updateCellAccordingToUserRoleForCell:cell withMemberStatus:isSuspended] ;
                    }
                }
                else if([loggedInUserRole isEqualToString:TEAM_TYPE_TEAM_MEMEBER]){
                    if([role isEqualToString:TEAM_TYPE_CONTRACTOR]){
                        [self updateCellAccordingToUserRoleForCell:cell withMemberStatus:isSuspended] ;
                    }
                }
            }
        }
       
         // Disable chat/message/email option if member is logged in user
        if([[[teamArr objectAtIndex:indexPath.row] valueForKey:kStartupTeamAPI_TeamMemberID] intValue] == [UtilityClass getLoggedInUserID]){
            cell.chatBtn.hidden = YES ;
            cell.messageBtn.hidden = YES ;
            cell.emailBtn.hidden = YES ;
        }
        
        return cell ;
    }
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] ;
        cell.contentView.backgroundColor = [UtilityClass backgroundColor] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.textLabel.text = [NSString stringWithFormat:@"No %@ Available",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"role"]] ;
        cell.textLabel.textAlignment = NSTextAlignmentCenter ;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15] ;
        cell.textLabel.textColor = [UtilityClass blueColor] ;
        return cell ;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *teamArr = [NSMutableArray arrayWithArray:[[sectionsArray objectAtIndex:indexPath.section] objectForKey:@"team"]] ;
    if(teamArr.count == 0) return 35 ;
    else return 80 ;
}

/*-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[sectionsArray objectAtIndex:section] valueForKey:@"role"] ;
}*/

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 35)] ;
    sectionView.backgroundColor = [UIColor darkGrayColor] ;
    
    // Add shadow
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:sectionView.bounds];
    sectionView.layer.masksToBounds = NO;
    sectionView.layer.shadowColor = [UIColor blackColor].CGColor;
    sectionView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    sectionView.layer.shadowOpacity = 0.5f;
    sectionView.layer.shadowPath = shadowPath.CGPath;
    
    UILabel *sectionLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, sectionView.frame.size.width-20, sectionView.frame.size.height)] ;
    sectionLbl.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:section] valueForKey:@"role"]] ;
    sectionLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:17] ;
    sectionLbl.textColor = [UIColor whiteColor] ;
    [sectionView addSubview:sectionLbl] ;
    return sectionView ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([UtilityClass getStartupType] != COMPLETEED_SELECTED){
        NSMutableArray *teamArr = [NSMutableArray arrayWithArray:[[sectionsArray objectAtIndex:indexPath.section] objectForKey:@"team"]] ;
        if(teamArr.count > 0){
            if([[[teamArr objectAtIndex:indexPath.row] objectForKey:kStartupTeamAPI_TeamMemberID] intValue] != [UtilityClass getLoggedInUserID] ){
                NSLog(@"teamArr: %@",[teamArr objectAtIndex:indexPath.row]) ;
                
                if([[[teamArr objectAtIndex:indexPath.row] objectForKey:kRecommendedContAPI_Is_Profile_Pubilc] intValue] && [[[teamArr objectAtIndex:indexPath.row] objectForKey:kRecommendedContAPI_Is_Profile_Pubilc] intValue] == 1){
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:[NSString stringWithFormat:@"%@",[[teamArr objectAtIndex:indexPath.row] objectForKey:kStartupTeamAPI_TeamMemberID]] forKey:kRecommendedContAPI_ContractorID] ;
                    [dict setObject:[NSString stringWithFormat:@"%@",[[teamArr objectAtIndex:indexPath.row] objectForKey:kStartupTeamAPI_MemberName]] forKey:kRecommendedContAPI_Contractor_Name] ;
                    [dict setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:kStartupOverviewAPI_StartupID] ;
                    [dict setObject:[NSString stringWithFormat:@"%@",[[teamArr objectAtIndex:indexPath.row] objectForKey:kStartupTeamAPI_MemberRole]] forKey:kStartupTeamAPI_MemberRole] ;
                    NSLog(@"dict: %@",dict) ;
                    [UtilityClass setContractorDetails:dict] ;
                    [UtilityClass setProfileMode:PROFILE_MODE_TEAM] ;
                    NSString *memberRole = [NSString stringWithFormat:@"%@",[[teamArr objectAtIndex:indexPath.row] valueForKey:kStartupTeamAPI_MemberRole]] ;
                    if([memberRole isEqualToString:TEAM_TYPE_ENTREPRENEUR]) [UtilityClass setUserType:ENTREPRENEUR] ;
                    else [UtilityClass setUserType:CONTRACTOR] ;
                    viewController.profileMode = [NSString stringWithFormat:@"%d",PROFILE_MODE_TEAM] ;
                    
                    [self.navigationController pushViewController:viewController animated:YES] ;
                }
                else{
                    [self presentViewController:[UtilityClass displayAlertMessage:kAlert_UserPrivateProfile] animated:YES completion:nil] ;
                }
                
            }
        }
    }
   
    
}

-(MessagesTableViewCell*)updateCellAccordingToUserRoleForCell:(MessagesTableViewCell*)cell withMemberStatus:(NSString*)isSuspended{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new] ;
    if([isSuspended intValue] == MEMBER_SUSPENDED){
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:18.0/255.0f green:89.0/255.0f blue:23.0/255.0f alpha:1] icon:[UIImage imageNamed:TEAM_RESUME_ICON]] ;
    }
    else{
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:18.0/255.0f green:89.0/255.0f blue:23.0/255.0f alpha:1] icon:[UIImage imageNamed:TEAM_SUSPEND_ICON]] ;
    }
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:197.0/255.0f green:4.0/255.0f blue:25.0/255.0f alpha:1] icon:[UIImage imageNamed:TEAM_REMOVE_ICON]] ;
    //  }
    cell.rightUtilityButtons = rightUtilityButtons ;
    cell.delegate = self ;
    return cell ;
}

/*- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // if you have index/header text in your tableview change your index text color
    UITableViewHeaderFooterView *headerIndexText = (UITableViewHeaderFooterView *)view;
    [headerIndexText.textLabel setTextColor:[UIColor whiteColor]];
}*/

#pragma mark - SWRevealTableViewCell Delegate Methods
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [tblView indexPathForCell:cell];
    NSMutableArray *teamArr = [NSMutableArray arrayWithArray:[[sectionsArray objectAtIndex:cellIndexPath.section] objectForKey:@"team"]] ;
    
    NSString *message ;
    if(index == 0){
        NSString *suspendedText = [NSString stringWithFormat:@"%@",[[teamArr objectAtIndex:cellIndexPath.row] valueForKey:kStartupTeamAPI_MemberStatus]] ;
        suspendedText = ([suspendedText intValue] == MEMBER_SUSPENDED?TEAM_RESUME_TEXT:TEAM_SUSPEND_TEXT) ;
        message = [NSString stringWithFormat:@"%@%@ this %@ ?",kAlert_StartTeam,suspendedText,[[sectionsArray objectAtIndex:cellIndexPath.section] valueForKey:@"role"]] ;
    }
    else{
        message = [NSString stringWithFormat:@"%@ remove this %@ ?",kAlert_StartTeam,[[sectionsArray objectAtIndex:cellIndexPath.section] valueForKey:@"role"]] ;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        NSString *isSuspended = [NSString stringWithFormat:@"%@",[[teamArr objectAtIndex:cellIndexPath.row] valueForKey:kStartupTeamAPI_MemberStatus]] ;
        // Suspend / Resume
        if(index == 0){
            
            isSuspended = ([isSuspended intValue] == MEMBER_SUSPENDED?[NSString stringWithFormat:@"%d",MEMBER_RESUMED]:[NSString stringWithFormat:@"%d",MEMBER_SUSPENDED]) ;
            
        }
        // Remove
        else isSuspended = [NSString stringWithFormat:@"%d",MEMBER_REMOVED] ;
        
         /*if([[[sectionsArray objectAtIndex:cellIndexPath.section] objectForKey:@"team"] objectAtIndex:cellIndexPath.row]){
              [tblView beginUpdates] ;
             [[[sectionsArray objectAtIndex:cellIndexPath.section] objectForKey:@"team"] removeObjectAtIndex:cellIndexPath.row] ;
             [tblView deleteRowsAtIndexPaths:@[cellIndexPath]
                           withRowAnimation:UITableViewRowAnimationAutomatic];
             [tblView endUpdates] ;
        }*/
        
        [self updateTeamMemberStatusWithStatus:isSuspended withIndexPath:cellIndexPath] ;
        
    }];
    UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
         [tblView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationRight] ;
    }];
    
    [alertController addAction:yes];
    [alertController addAction:no];
    
    [self presentViewController:alertController animated:YES completion:nil] ;
    
}

#pragma mark - MFMailComposer Delegate Methods
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/*#pragma mark -
#pragma mark Chat Service Delegate

- (void)chatService:(QMChatService *)chatService didAddChatDialogsToMemoryStorage:(NSArray *)chatDialogs {
   // [self.tblView reloadData];
}

- (void)chatService:(QMChatService *)chatService didAddChatDialogToMemoryStorage:(QBChatDialog *)chatDialog {
   // [self.tblView reloadData];
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogInMemoryStorage:(QBChatDialog *)chatDialog {
    //[self.tblView reloadData];
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogsInMemoryStorage:(NSArray *)dialogs {
   // [self.tblView reloadData];
}

- (void)chatService:(QMChatService *)chatService didReceiveNotificationMessage:(QBChatMessage *)message createDialog:(QBChatDialog *)dialog {
   // [self.tblView reloadData];
}

- (void)chatService:(QMChatService *)chatService didAddMessageToMemoryStorage:(QBChatMessage *)message forDialogID:(NSString *)dialogID {
    //[self.tblView reloadData];
}

- (void)chatService:(QMChatService *)chatService didAddMessagesToMemoryStorage:(NSArray *)messages forDialogID:(NSString *)dialogID {
   // [self.tblView reloadData];
}

- (void)chatService:(QMChatService *)chatService didDeleteChatDialogWithIDFromMemoryStorage:(NSString *)chatDialogID {
    //[self.tblView reloadData];
}

#pragma mark - QMChatConnectionDelegate
- (void)chatServiceChatDidConnect:(QMChatService *)chatService {
    NSLog(NSLocalizedString(@"SA_STR_CONNECTED", nil)) ;
    [self loadDialogs];
}

- (void)chatServiceChatDidReconnect:(QMChatService *)chatService {
    NSLog(NSLocalizedString(@"SA_STR_RECONNECTED", nil) ) ;
    [self loadDialogs];
}

- (void)chatServiceChatDidAccidentallyDisconnect:(QMChatService *)chatService {
    NSLog(NSLocalizedString(@"SA_STR_DISCONNECTED", nil)) ;
}

- (void)chatService:(QMChatService *)chatService chatDidNotConnectWithError:(NSError *)error {
    NSLog(@"%@",[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"SA_STR_DID_NOT_CONNECT_ERROR", nil), [error localizedDescription]]) ;
}

- (void)chatServiceChatDidFailWithStreamError:(NSError *)error {
    NSLog(@"%@",[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"SA_STR_FAILED_TO_CONNECT_WITH_ERROR", nil), [error localizedDescription]]) ;
}*/


#pragma mark - Quickblox Methods
-(void)quickBloxSettings{
    [[ServicesManager instance].chatService addDelegate:self];
    self.observerDidBecomeActive = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                                                     object:nil queue:[NSOperationQueue mainQueue]
                                                                                 usingBlock:^(NSNotification *note) {
                                                                                  /*   if (![[QBChat instance] isConnected]) {
                                                                                         [UtilityClass showHudWithTitle:NSLocalizedString(@"SA_STR_CONNECTING_TO_CHAT", nil)] ;
                                                                                     }*/
                                                                                 }];
    
    if ([ServicesManager instance].isAuthorized) {
        //[self loadDialogs];
    }
    else{
        
        ServicesManager *servicesManager = [ServicesManager instance];
        NSLog(@"currentUser: %@",servicesManager.currentUser) ;
        if (servicesManager.currentUser != nil) {
            // loggin in with previous user
            servicesManager.currentUser.password = [[UtilityClass getLoggedInUserDetails] valueForKey:kLogInAPI_Password];
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
            [servicesManager logInWithUser:servicesManager.currentUser completion:^(BOOL success, NSString *errorMessage) {
                if (success) {
                    [UtilityClass hideHud] ;
                } else {
                    NSLog(@"error %@",errorMessage)  ;
                    [UtilityClass hideHud] ;
                }
            }];
        }
        
    }
}


/*- (void)loadDialogs {
    
    if ([ServicesManager instance].lastActivityDate != nil) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [[ServicesManager instance].chatService fetchDialogsUpdatedFromDate:[ServicesManager instance].lastActivityDate andPageLimit:kDialogsPageLimit iterationBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, BOOL *stop) {
            //
            NSLog(@"dialogs >> %@",self.dialogs) ;
            
            dialogsArray = [NSArray arrayWithArray:self.dialogs] ;
            [UtilityClass hideHud] ;
          
            //[weakSelf.tblView reloadData];
        } completionBlock:^(QBResponse *response) {
            //
            if ([ServicesManager instance].isAuthorized && response.success) {
                [ServicesManager instance].lastActivityDate = [NSDate date];
            }
        }];
    }
    else {
        // [SVProgressHUD showWithStatus:NSLocalizedString(@"SA_STR_LOADING_DIALOGS", nil) maskType:SVProgressHUDMaskTypeClear];
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [[ServicesManager instance].chatService allDialogsWithPageLimit:kDialogsPageLimit extendedRequest:nil iterationBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, BOOL *stop) {
            NSLog(@"dialogObjects >> %@",dialogObjects) ;
            [UtilityClass hideHud] ;
            
            //[weakSelf.tblView reloadData];
        } completion:^(QBResponse *response) {
            if ([ServicesManager instance].isAuthorized) {
                if (response.success) {
                    NSLog(@"response >> %@",response) ;
                    //[SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SA_STR_COMPLETED", nil)];
                    [ServicesManager instance].lastActivityDate = [NSDate date];
                }
                else {
                    [UtilityClass displayAlertMessage:NSLocalizedString(@"SA_STR_FAILED_LOAD_DIALOGS", nil)] ;
                    // [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"SA_STR_FAILED_LOAD_DIALOGS", nil)];
                }
            }
        }];
    }
}

- (NSArray *)dialogs {
    // Retrieving dialogs sorted by updatedAt date from memory storage.
    return [ServicesManager.instance.chatService.dialogsMemoryStorage dialogsSortByUpdatedAtWithAscending:NO];
}*/

/*#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kChatUserViewIdentifier]) {
        ChatViewController *viewController = segue.destinationViewController;
        viewController.dialog = teamchatDialog ;
       // viewController.dialog = ;
    }
}*/


@end
