//
//  MenuViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 12/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "AddStartupViewController.h"
#import "UserTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "SearchContractorViewController.h"
#import "CDTestEntity.h"
#import "Opportunities ViewController.h"
#import "EventsViewController.h"
#import "ResourcesViewController.h"
#import "YTVideoViewViewController.h"
#import "MyStartupsViewController.h"
#import "SearchContractorViewController.h"
#import "CurrentStartupsViewController.h"
#import "NotificationsViewController.h"
#import "ConnectionsViewController.h"
#import "SuggestKeywordsViewController.h"
#import "CompaniesViewController.h"
#import "JobListViewController.h"
#import "RecruiterViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // menuArray = @[@"userIdentifier",@"homeIdentifier",@"profileIdentifier",@"startupIdentifier",@"addStartupIdentifier",@"searchStartupIdentifier",@"searchContributorIdentifier",@"workOrdersIdentifier",@"chatIdentifier",@"notesIdentifier",@"viewProfileIdentifier",@"messagesdentifier",@"archivedNotIdentifier",@"settingsIdentifier",@"forumsIdentifier",@"archivedForumsIdentifier",@"campaignsIdentifier",@"paymentIdentifier",@"logoutIdentifier"];
    
    menuArray = @[@"userIdentifier", @"homeIdentifier", @"My Profile", @"Startups", @"Contractors", @"Organizations", @"Messaging",@
                  "Resources", @"Events", @"Opportunities", @"paymentIdentifier", @"logoutIdentifier"];
    
    profileArray = @[@"entrepreneurVideoIdentifier", @"profileIdentifier", @"connectionsIdentifier", @"suggestKeywordsIdentifier", @"settingsIdentifier"] ;
    
    startupArray = @[@"roadmapVideoIdentifier",@"addStartupIdentifier",@"startupApplicationIdentifier",@"startupProfileIdentifier",@"currentStartupsIdentifier",@"fundsIdentifier",@"campaignsIdentifier",@"searchCampaignsIdentifier",@"manageWorkOrdersIdentifier"] ;
    contractorsArray = @[@"contractorVideoIdentifier",@"searchContributorIdentifier",@"viewProfileIdentifier",@"workOrdersIdentifier"] ;
    
    organizationsArray = @[@"organizationVideoIdentifier",@"searchOrganizationIdentifier"] ;
    
    messagesArray = @[@"archivedForumsIdentifier",@"archivedNotIdentifier",@"notificationsIdentifier",@"chatIdentifier",@"forumsIdentifier",@"groupsIdentifier",@"messagesdentifier",@"notesIdentifier"] ;
    resourcesArray = @[@"hardwareIdentifier",@"softwareIdentifier",@"servicesIdentifier",@"audioVideoIdentifier",@"informationIdentifier",@"productivityIdentifier"] ;
    eventsArray = @[@"conferencesIdentifier",@"demoDaysIdentifier",@"meetUpsIdentifier",@"webinarsIdentifier"] ;
    opportunitiesArray = @[kMenuIdentifier_BetaTesters,kMenuIdentifier_boardMembers,kMenuIdentifier_communalAssets,kMenuIdentifier_Consulting,kMenuIdentifier_earlyAdaptors,kMenuIdentifier_endorsers,kMenuIdentifier_focusGroups,kMenuIdentifier_jobs,kMenuIdentifier_recruiter] ;
    
    arrayForBool = [[NSMutableArray alloc] init] ;
    for (int i=0; i<[menuArray count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone] ;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    [self.revealViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self addObserver];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated] ;
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
    
    [self removeObserver];
}

#pragma mark - Custom Methods
- (void) addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(referAFriend:) name:kNotification_ReferAFriend
                                               object:nil];
}

- (void) removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) referAFriend:(NSNotification *)notification {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Crowd Bootstrap Invitation"];
        
        NSString *strMailContent = [NSString stringWithFormat:@"\n[Name]:\n\nCrowd Bootstrap helps entrepreneurs accelerate their journey from a startup idea to initial revenues. It is a free App that enables you to benefit as an entrepreneur or help as an expert.\n\nPlease click the following link to sign-up and help an entrepreneur realize their dream.\n\nlink : http://crowdbootstrap.com/\n\nRegards,\n\nThe Crowd Bootstrap Team"];
        [mail setMessageBody:strMailContent isHTML:NO];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

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

-(void)logoutUser {
   
  /*  [[QMServicesManager instance] logoutWithCompletion:^{
        NSLog(@"Logged out from QuickBlox ") ;
        // Logged out from QuickBlox
        
    }];*/
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kLogOutAPI_UserID] ;
    [dictParam setObject:[NSString stringWithFormat:@"%@",[UtilityClass getDeviceToken]] forKey:kLogOutAPI_AccessToken] ;
    [dictParam setObject:[NSString stringWithFormat:@"%@",[UtilityClass getDeviceToken]] forKey:kLogOutAPI_DeviceToken] ;
    [dictParam setObject:@"ios" forKey:kLogOutAPI_DeviceType] ;
    
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_LogOut] ;
        [ApiCrowdBootstrap logoutWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"message"] isEqualToString:@"Success"] )  {
                
                [UtilityClass setLogInStatus:NO] ;
                
                [UtilityClass setLoggedInUserID:-1] ;
                [UtilityClass setLoggedInUserDetails:nil] ;
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:kRootNavControllerIdentifier] ;
               // [self presentViewController:navController animated:YES completion:nil] ;
                
                [self removeAllNotes] ;
                
                [AppDelegate appDelegate].window.rootViewController = navController ;
                
            }
            else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }];
    }
}

#pragma mark - Core Data Methods
-(void)removeAllNotes{
    [[AppDelegate appDelegate].coreDataManager fetchWithEntity:NOTES_ENTITY
                            Predicate:nil
                              success:^(NSArray *fetchLists)
     {
         // delete entity
         for (CDTestEntity *deleteEntity in fetchLists)
         {
             [[AppDelegate appDelegate].coreDataManager deleteWithEntity:deleteEntity];
         }
         
     }
                               failed:^(NSError *error)
     {
         
     }];
}

#pragma mark - Table header gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[menuArray count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [tblView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == kMyProfielSectionCellIndex){
        if ([[arrayForBool objectAtIndex:section] boolValue]) return profileArray.count ;
        else  return 0 ;
    }
    else if(section == kStartupSectionCellIndex){
        if ([[arrayForBool objectAtIndex:section] boolValue]) return startupArray.count ;
        else  return 0 ;
    }
    else if(section == kContractorSectionCellIndex){
        if ([[arrayForBool objectAtIndex:section] boolValue]) return contractorsArray.count ;
        else  return 0 ;
    }
    else if(section == kOrganizationSectionCellIndex){
        if ([[arrayForBool objectAtIndex:section] boolValue]) return organizationsArray.count ;
        else  return 0 ;
    }
    else if(section == kMessagesSectionCellIndex){
        if ([[arrayForBool objectAtIndex:section] boolValue]) return messagesArray.count ;
        else  return 0 ;
    }
    else if(section == kResourcesSectionCellIndex){
        if ([[arrayForBool objectAtIndex:section] boolValue]) return resourcesArray.count ;
        else  return 0 ;
    }
    else if(section == kEventsSectionCellIndex){
        if ([[arrayForBool objectAtIndex:section] boolValue]) return eventsArray.count ;
        else  return 0 ;
    }
    else if(section == kOpportunitiesSectionCellIndex){
        if ([[arrayForBool objectAtIndex:section] boolValue]) return opportunitiesArray.count ;
        else  return 0 ;
    }

    else return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return menuArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier ;
    if(indexPath.section == 0){
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[menuArray objectAtIndex:indexPath.section] forIndexPath:indexPath];
        
        NSMutableDictionary *dict = [[UtilityClass getLoggedInUserDetails] mutableCopy] ;
        
        cell.userNameLbl.text = [NSString stringWithFormat:@"%@ %@",[dict valueForKey:kLogInAPI_FirstName],[dict valueForKey:kLogInAPI_LastName]] ;
        [cell.userImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[dict valueForKey:kLogInAPI_UserImage]]] placeholderImage:[UIImage imageNamed:kImage_ProfilePicDefault]] ;
      
        cell.userImgView.layer.cornerRadius = 60;
        cell.userImgView.clipsToBounds = YES;
        
        cell.userImgView.layer.borderWidth = 2.0f;
        cell.userImgView.layer.borderColor = [UtilityClass greenColor].CGColor;
        
        return cell ;
    }
    else {
        if(indexPath.section == kMyProfielSectionCellIndex)
            CellIdentifier = [profileArray objectAtIndex:indexPath.row];
        else if(indexPath.section == kStartupSectionCellIndex)
            CellIdentifier = [startupArray objectAtIndex:indexPath.row];
        else if(indexPath.section == kContractorSectionCellIndex)
            CellIdentifier = [contractorsArray objectAtIndex:indexPath.row];
        else if(indexPath.section == kOrganizationSectionCellIndex)
            CellIdentifier = [organizationsArray objectAtIndex:indexPath.row];
        else if(indexPath.section == kMessagesSectionCellIndex)
            CellIdentifier = [messagesArray objectAtIndex:indexPath.row];
        else if(indexPath.section == kResourcesSectionCellIndex)
            CellIdentifier = [resourcesArray objectAtIndex:indexPath.row];
        else if(indexPath.section == kEventsSectionCellIndex)
            CellIdentifier = [eventsArray objectAtIndex:indexPath.row];
        else if(indexPath.section == kOpportunitiesSectionCellIndex)
            CellIdentifier = [opportunitiesArray objectAtIndex:indexPath.row];
        else
            CellIdentifier = [menuArray objectAtIndex:indexPath.section];
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UtilityClass greenColor];
        [cell setSelectedBackgroundView:bgColorView];
        
        return cell ;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //if(section == ROADMAP_SECTION_INDEX){
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    sectionView.backgroundColor = [UIColor colorWithRed:3.0f/255.0f green:55.0f/255.0f blue:92.0f/255.0f alpha:1];
    sectionView.tag = section;
    
//    [cell setSelectedBackgroundView:bgColorView];
    
    // Menu icon
     UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20,10 ,32, 31)];
    if(section == kMyProfielSectionCellIndex)
        imgView.image = [UIImage imageNamed:kMyProfileSectionIcon] ;
    else if(section == kStartupSectionCellIndex)
        imgView.image = [UIImage imageNamed:kStartupSectionIcon] ;
    else if(section == kContractorSectionCellIndex)
        imgView.image = [UIImage imageNamed:kContractorSectionIcon] ;
    else if(section == kOrganizationSectionCellIndex)
        imgView.image = [UIImage imageNamed:kOrganizationSectionIcon] ;
    else if(section == kMessagesSectionCellIndex)
        imgView.image = [UIImage imageNamed:kMessagesSectionIcon] ;
    else if(section == kResourcesSectionCellIndex)
        imgView.image = [UIImage imageNamed:kResourcesSectionIcon] ;
    else if(section == kEventsSectionCellIndex)
        imgView.image = [UIImage imageNamed:kEventsSectionIcon] ;
    else if(section == kOpportunitiesSectionCellIndex)
        imgView.image = [UIImage imageNamed:kOpportunitiesSectionIcon] ;
    
    // Title Label
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(68,10,142, 31)];
    viewLabel.textColor = [UIColor whiteColor];
    viewLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:15];
    viewLabel.text=[menuArray objectAtIndex:section];
    
    [sectionView addSubview:imgView];
    [sectionView addSubview:viewLabel];
    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    
    return  sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) return 180 ;
    else return 50 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == kMyProfielSectionCellIndex || section == kStartupSectionCellIndex || section == kContractorSectionCellIndex || section == kOrganizationSectionCellIndex || section == kMessagesSectionCellIndex || section == kResourcesSectionCellIndex || section == kEventsSectionCellIndex|| section == kOpportunitiesSectionCellIndex)return 45 ;
    else return 0 ;
}

/*-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *sectionView = [tableView dequeueReusableCellWithIdentifier:[menuArray objectAtIndex:section]] ;
    

 UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    
    return  sectionView;
}*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: //User Info
            break;
            
        case 1: //Home
            break;
            
        case 2: //My Profile
            break;
            
        case 3: //Startups
        {
            if(indexPath.row  == 4) {
                [UtilityClass setStartupWorkOrderType:NO] ;
            }
            break;
        }
            
        case 4: //Contractors
        {
            if(indexPath.row == 1) {
                [UtilityClass setSearchContractorMode:YES] ;
            }
            else if(indexPath.row  == 2) {
               [UtilityClass setProfileMode:PROFILE_MODE_MY_PROFILE] ;
            }
            else if(indexPath.row  == 3) {
                [UtilityClass setStartupWorkOrderType:YES] ;
            }
             break ;
        }
         
        case 5: //Companies
        {
            if(indexPath.row == 1) {
                [UtilityClass setSearchCompanyMode:YES] ;
            }
            break ;
        }
            
        case 6: //Messaging
            break ;
            
        case 7: //Resources
        {
            //[UtilityClass setSelectedMenuTitle:@"test"] ;
            break ;
        }
            
        case 8: //Events
        {
            //[UtilityClass setSelectedMenuTitle:@"test"] ;
            break ;
        }
            
        case 9: //Opportunities
        {
            break ;
        }
            
        case 10: //Shopping Cart
            break;
            
        case 11: //Logout
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:kAlert_Logout preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                
            [self logoutUser] ;
              /*// Logout
                [UtilityClass setLogInStatus:NO] ;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:kRootNavControllerIdentifier] ;
                [self presentViewController:navController animated:YES completion:nil] ;*/
                
            }];
            UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                
            }];
            
            [alertController addAction:yes];
            [alertController addAction:no];
            
            [self presentViewController:alertController animated:YES completion:nil] ;
            
            break;
        }
       
        default:
            break;
    }
}

#pragma mark - IBAction Methods
-(void)LoginAlert_ClickAction {
    
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
    
    // Code for Segue
    
    // Set the title of navigation bar by using the menu items
    /*NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
     UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
     destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];*/
    
    // Set the photo if it navigates to the PhotoView
    /*if ([segue.identifier isEqualToString:@"openJournal"]) {
     
     PhotoViewController *photoController = (PhotoViewController*)segue.destinationViewController;
     NSString *photoFilename = [NSString stringWithFormat:@"%@_photo.jpg", [_menuItems objectAtIndex:indexPath.row]];
     photoController.photoFilename = photoFilename;
     }*/
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        
        //[UtilityClass setProfileMode:PROFILE_MODE_MY_PROFILE] ;
        
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [dvc.view setUserInteractionEnabled:YES];
           // [self.revealViewController removeOverlayButton];
            
            // Messaging
            if([dvc isKindOfClass:[NotificationsViewController class]]) {
                NotificationsViewController *viewController = (NotificationsViewController*)dvc;
                
                if([sender isKindOfClass:[UITableViewCell class]]) {
                    UITableViewCell *cell = (UITableViewCell *)sender ;
                    NSString *selectedCellIdentifier = cell.reuseIdentifier ;
                    
                    if([selectedCellIdentifier isEqualToString:@"notificationsIdentifier"]) {
                        [viewController refreshUIContentWithTitle:MES_NOTIFICATION_TITLE];
                    }
                }
            }
            
            // Resources
            if([dvc isKindOfClass:[ResourcesViewController class]]) {
                ResourcesViewController *viewController = (ResourcesViewController*)dvc;
                
                if([sender isKindOfClass:[UITableViewCell class]]) {
                    UITableViewCell *cell = (UITableViewCell *)sender ;
                    NSString *selectedCellIdentifier = cell.reuseIdentifier ;
                    
                    if([selectedCellIdentifier isEqualToString:@"hardwareIdentifier"]) {
                        [viewController refreshUIContentWithTitle:RES_HARDWARE_TITLE withContent:RES_HARDWARE_CONTENT] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:@"softwareIdentifier"]) {
                        [viewController refreshUIContentWithTitle:RES_SOFTWARE_TITLE withContent:RES_SOFTWARE_CONTENT] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:@"servicesIdentifier"]){
                        [viewController refreshUIContentWithTitle:RES_SERVICES_TITLE withContent:RES_SERVICES_CONTENT] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:@"audioVideoIdentifier"]){
                        [viewController refreshUIContentWithTitle:RES_AUDIOVIDEO_TITLE withContent:RES_AUDIOVIDEO_CONTENT] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:@"informationIdentifier"]){
                        [viewController refreshUIContentWithTitle:RES_INFORMATION_TITLE withContent:RES_INFORMATION_CONTENT] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:@"productivityIdentifier"]){
                        [viewController refreshUIContentWithTitle:RES_PRODUCTIVITY_TITLE withContent:RES_PRODUCTIVITY_CONTENT] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:@"fundsIdentifier"]){
                        [viewController refreshUIContentWithTitle:STARTUP_FUNDS_TITLE withContent:STARTUP_FUNDS_CONTENT] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:@"groupsIdentifier"]){
                        [viewController refreshUIContentWithTitle:MESSAGE_GROUPS_TITLE withContent:MESSAGE_GROUPS_CONTENT] ;
                    }
                }
            }
            
            // Events
            else if([dvc isKindOfClass:[EventsViewController class]]){
                EventsViewController *viewController = (EventsViewController*)dvc;
                
                if([sender isKindOfClass:[UITableViewCell class]]){
                    UITableViewCell *cell = (UITableViewCell *)sender ;
                    NSString *selectedCellIdentifier = cell.reuseIdentifier ;
                    
                    if([selectedCellIdentifier isEqualToString:@"conferencesIdentifier"]){
                        [viewController refreshUIContentWithTitle:EVENT_CONFERENCES_TITLE withContent:EVENT_CONFERENCES_CONTENT] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:@"demoDaysIdentifier"]){
                       [viewController refreshUIContentWithTitle:EVENT_DEMODAYS_TITLE withContent:EVENT_DEMODAYS_CONTENT] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:@"meetUpsIdentifier"]){
                       [viewController refreshUIContentWithTitle:EVENT_MEETUPS_TITLE withContent:EVENT_MEETUPS_CONTENT] ;
                    }
                    else if([selectedCellIdentifier isEqualToString:@"webinarsIdentifier"]){
                       [viewController refreshUIContentWithTitle:EVENT_WEBINARS_TITLE withContent:EVENT_WEBINARS_CONTENT] ;
                    }
                    
                    // Others
                    
                    else if([selectedCellIdentifier isEqualToString:@"searchCampaignsIdentifier"]){
                        [viewController refreshUIContentWithTitle:@"Search Campaigns" withContent:@""] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:@"manageWorkOrdersIdentifier"]){
                        [viewController refreshUIContentWithTitle:@"Manage Work Orders" withContent:@""] ;
                    }
                    
                }
            }
            
            // Opportunities
            else if([dvc isKindOfClass:[Opportunities_ViewController class]]){
                Opportunities_ViewController *viewController = (Opportunities_ViewController*)dvc;
                
                if([sender isKindOfClass:[UITableViewCell class]]){
                    UITableViewCell *cell = (UITableViewCell *)sender ;
                    NSString *selectedCellIdentifier = cell.reuseIdentifier ;
                    
                    if([selectedCellIdentifier isEqualToString:kMenuIdentifier_BetaTesters]) {
                        [viewController refreshUIContentWithTitle:OPP_BETATESTERS_TITLE withContent:OPP_BETATESTERS_CONTENT] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:kMenuIdentifier_boardMembers]) {
                        [viewController refreshUIContentWithTitle:OPP_BOARDMEMBERS_TITLE withContent:OPP_BOARDMEMBERS_CONTENT] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:kMenuIdentifier_Consulting]) {
                        [viewController refreshUIContentWithTitle:OPP_CONSULTING_TITLE withContent:OPP_CONSULTING_CONTENT] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:kMenuIdentifier_earlyAdaptors]) {
                        [viewController refreshUIContentWithTitle:OPP_EARLYADAPTORS_TITLE withContent:OPP_EARLYADAPTORS_CONTENT] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:kMenuIdentifier_endorsers]) {
                        [viewController refreshUIContentWithTitle:OPP_ENDORSERS_TITLE withContent:OPP_ENDORSERS_CONTENT] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:kMenuIdentifier_focusGroups]) {
                        [viewController refreshUIContentWithTitle:OPP_FOCUSGROUPS_TITLE withContent:OPP_FOCUSGROUPS_CONTENT] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:kMenuIdentifier_communalAssets]){
                        [viewController refreshUIContentWithTitle:OPP_COMMUNALASSETS_TITLE withContent:OPP_COMMUNALASSETS_CONTENT] ;
                    }
                    
                }
            }
            
            // YouTube Videos
            else if([dvc isKindOfClass:[YTVideoViewViewController class]]){
                YTVideoViewViewController *viewController = (YTVideoViewViewController*)dvc;
                
                if([sender isKindOfClass:[UITableViewCell class]]){
                    UITableViewCell *cell = (UITableViewCell *)sender ;
                    NSString *selectedCellIdentifier = cell.reuseIdentifier ;
                    
                    if([selectedCellIdentifier isEqualToString:@"entrepreneurVideoIdentifier"]) {
                        [viewController refreshUIContentWithTitle:@"Entrepreneur Video" withContent:ENT_VIDEO_LINK] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:@"roadmapVideoIdentifier"]) {
                        [viewController refreshUIContentWithTitle:@"Roadmap Video" withContent:ROADMAP_VIDEO_LINK] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:@"contractorVideoIdentifier"]) {
                        [viewController refreshUIContentWithTitle:@"Contractor Video" withContent:CONT_VIDEO_LINK] ;
                    }
                    
                    else if([selectedCellIdentifier isEqualToString:@"organizationVideoIdentifier"]) {
                        [viewController refreshUIContentWithTitle:@"Organization Video" withContent:CONT_VIDEO_LINK] ;
                    }
                }
            }
            
            // Startup / Workorder
            else if([dvc isKindOfClass:[CurrentStartupsViewController class]]) {
                
                if([sender isKindOfClass:[UITableViewCell class]]) {
                    UITableViewCell *cell = (UITableViewCell *)sender ;
                    NSString *selectedCellIdentifier = cell.reuseIdentifier ;
                    
                    if([selectedCellIdentifier isEqualToString:@"currentStartupsIdentifier"]) {
                        [UtilityClass setStartupWorkOrderType:NO] ;
                    }
                    else if([selectedCellIdentifier isEqualToString:@"workOrdersIdentifier"]) {
                        [UtilityClass setStartupWorkOrderType:YES] ;
                    }
                }
            }
            
            // Connections
            else if([dvc isKindOfClass:[ConnectionsViewController class]]) {
                ConnectionsViewController *viewController = (ConnectionsViewController*)dvc;

                if([sender isKindOfClass:[UITableViewCell class]]) {
                    UITableViewCell *cell = (UITableViewCell *)sender ;
                    NSString *selectedCellIdentifier = cell.reuseIdentifier ;
                    
                    if([selectedCellIdentifier isEqualToString:@"connectionsIdentifier"]) {
                        [viewController refreshUIContentWithTitle:CONNECTIONS_TITLE withContent:@""] ;
                    }
                }
            }
            
            // Suggest Keywords
            else if([dvc isKindOfClass:[SuggestKeywordsViewController class]]) {
                SuggestKeywordsViewController *viewController = (SuggestKeywordsViewController*)dvc;
                
                if([sender isKindOfClass:[UITableViewCell class]]) {
                    UITableViewCell *cell = (UITableViewCell *)sender ;
                    NSString *selectedCellIdentifier = cell.reuseIdentifier ;
                    
                    if([selectedCellIdentifier isEqualToString:@"suggestKeywordsIdentifier"]) {
                        [viewController refreshUIContentWithTitle:SUGGEST_KEYWORDS_TITLE withContent:@""] ;
                    }
                }
            }
            
            // Assign WorkUnits / Search Contractor
            else if([dvc isKindOfClass:[SearchContractorViewController class]]){
                
                if([sender isKindOfClass:[UITableViewCell class]]){
                    UITableViewCell *cell = (UITableViewCell *)sender ;
                    NSString *selectedCellIdentifier = cell.reuseIdentifier ;
                    
                    if([selectedCellIdentifier isEqualToString:@"searchContributorIdentifier"]){
                        [UtilityClass setContAssignWorkUnitsMode:NO] ;
                    }
                    else if([selectedCellIdentifier isEqualToString:@"manageWorkOrdersIdentifier"]){
                        [UtilityClass setContAssignWorkUnitsMode:YES] ;
                    }
                }
            }
            
            // Search Company
            else if([dvc isKindOfClass:[CompaniesViewController class]]){
                
                if([sender isKindOfClass:[UITableViewCell class]]){
                    UITableViewCell *cell = (UITableViewCell *)sender ;
                    NSString *selectedCellIdentifier = cell.reuseIdentifier ;
                    
                    if([selectedCellIdentifier isEqualToString:@"searchOrganizationIdentifier"]){

                    }
                    
                }
            }
            
            // Jobs
            else if([dvc isKindOfClass:[JobListViewController class]]) {
                JobListViewController *viewController = (JobListViewController*)dvc;
                
                if([sender isKindOfClass:[UITableViewCell class]]) {
                    UITableViewCell *cell = (UITableViewCell *)sender ;
                    NSString *selectedCellIdentifier = cell.reuseIdentifier ;
                    
                    if([selectedCellIdentifier isEqualToString:kMenuIdentifier_jobs]) {
                        [viewController refreshUIContentWithTitle:OPP_JOBS_TITLE withContent:@""] ;
                    }
                }
            }
            
            // Jobs
            else if([dvc isKindOfClass:[RecruiterViewController class]]) {
                RecruiterViewController *viewController = (RecruiterViewController *)dvc;
                
                if([sender isKindOfClass:[UITableViewCell class]]) {
                    UITableViewCell *cell = (UITableViewCell *)sender ;
                    NSString *selectedCellIdentifier = cell.reuseIdentifier ;
                    
                    if([selectedCellIdentifier isEqualToString:kMenuIdentifier_recruiter]) {
                        [viewController refreshUIContentWithTitle:OPP_RECRUITER_TITLE withContent:@""] ;
                    }
                }
            }
            
            // Upload Application / Profile
            else if([dvc isKindOfClass:[MyStartupsViewController class]]){
                MyStartupsViewController *viewController = (MyStartupsViewController*)dvc;
                
                if([sender isKindOfClass:[UITableViewCell class]]){
                    UITableViewCell *cell = (UITableViewCell *)sender ;
                    NSString *selectedCellIdentifier = cell.reuseIdentifier ;
                    
                    if([selectedCellIdentifier isEqualToString:@"startupApplicationIdentifier"]){
                        [viewController getMyStartupListForType:YES] ;
                    }
                    else if([selectedCellIdentifier isEqualToString:@"startupProfileIdentifier"]){
                        [viewController getMyStartupListForType:NO] ;
                    }
                    
                    
                }
            }
            
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
        };
    }
    
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
