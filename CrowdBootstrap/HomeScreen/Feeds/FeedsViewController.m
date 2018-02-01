//
//  FeedsViewController.m
//  CrowdBootstrap
//
//  Created by Shikha on 22/05/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "FeedsViewController.h"

#import "FeedsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "PublicProfileViewController.h"
#import "Info_StartupViewController.h"
#import "StartupDetailViewController.h"

@interface FeedsViewController ()

@end

@implementation FeedsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self pullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    feedsArray = [[NSMutableArray alloc] init];
    attachmentsArray = [[NSMutableArray alloc] init];
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    isPullToRefresh = false;

    [self resetUISettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void)pullToRefresh {
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, 0, 0)];
    [tblView insertSubview:refreshView atIndex:0];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor redColor];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull To Refresh"];
     [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
     refreshControl.attributedTitle = refreshString;
    
    [refreshView addSubview:refreshControl];
}

- (void)refreshData {
    [self resetUISettings];
    isPullToRefresh = true;
    [refreshControl endRefreshing];
}

-(void)resetUISettings {
    pageNo = 1;
    totalItems = 0 ;
    
    btnAddFeed.layer.cornerRadius = btnAddFeed.frame.size.width/2;
    
    [self getFeedsList];
}

#pragma mark - IBAction Methods
- (IBAction)btnAttachment1Clicked:(id)sender {
    
    NSDictionary *feedDict = [feedsArray objectAtIndex:[sender tag]];
    NSArray *arrAttachment = [feedDict valueForKey:@"arrOfAttachments"];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", CROWDBOOTSTRAP_BASE_URL, [arrAttachment objectAtIndex:0]];
    NSLog(@"Attachment 1 Url : %@",strUrl);
    
    NSDictionary *options = @{UIApplicationOpenURLOptionsSourceApplicationKey : @YES};
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[strUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"]] options:options completionHandler:nil];
}

- (IBAction)btnAttachment2Clicked:(id)sender {
    NSDictionary *feedDict = [feedsArray objectAtIndex:[sender tag]];
    NSArray *arrAttachment = [feedDict valueForKey:@"arrOfAttachments"];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", CROWDBOOTSTRAP_BASE_URL, [arrAttachment objectAtIndex:1]];
    NSLog(@"Attachment 2 Url : %@",strUrl);
    
    NSDictionary *options = @{UIApplicationOpenURLOptionsSourceApplicationKey : @YES};
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[strUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"]] options:options completionHandler:nil];
}

- (IBAction)btnAttachment3Clicked:(id)sender {
    NSDictionary *feedDict = [feedsArray objectAtIndex:[sender tag]];
    NSArray *arrAttachment = [feedDict valueForKey:@"arrOfAttachments"];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", CROWDBOOTSTRAP_BASE_URL, [arrAttachment objectAtIndex:2]];
    NSLog(@"Attachment 3 Url : %@",strUrl);
    
    NSDictionary *options = @{UIApplicationOpenURLOptionsSourceApplicationKey : @YES};
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[strUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"]] options:options completionHandler:nil];
}

- (IBAction)btnAttachment4Clicked:(id)sender {
    NSDictionary *feedDict = [feedsArray objectAtIndex:[sender tag]];
    NSArray *arrAttachment = [feedDict valueForKey:@"arrOfAttachments"];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", CROWDBOOTSTRAP_BASE_URL, [arrAttachment objectAtIndex:3]];
    NSLog(@"Attachment 4 Url : %@",strUrl);
    
    NSDictionary *options = @{UIApplicationOpenURLOptionsSourceApplicationKey : @YES};
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[strUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"]] options:options completionHandler:nil];
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(feedsArray.count == totalItems)
        return feedsArray.count ;
    else
        return feedsArray.count+1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    if(indexPath.row == feedsArray.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
        [activityIndicator startAnimating];
        return cell ;
    }
    else {
        FeedsTableViewCell *cell = (FeedsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Feeds] ;
        
        cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[feedsArray objectAtIndex:indexPath.row] valueForKey:kFeedsAPI_Title]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[feedsArray objectAtIndex:indexPath.row] valueForKey:kFeedsAPI_SenderBio]];
        cell.lblMsg.text = [NSString stringWithFormat:@"Message: %@",[[feedsArray objectAtIndex:indexPath.row] valueForKey:kFeedsAPI_Message]];
        cell.lblDate.text = [NSString stringWithFormat:@"%@",[[feedsArray objectAtIndex:indexPath.row] valueForKey:kFeedsAPI_Date]];
        
        NSMutableArray *arrAttachments = [[feedsArray objectAtIndex:indexPath.row] valueForKey:@"arrOfAttachments"];
        NSInteger count = arrAttachments.count;
        
        if (count == 1) {
            cell.btnAttachment1.hidden = false;
            cell.btnAttachment2.hidden = true;
            cell.btnAttachment3.hidden = true;
            cell.btnAttachment4.hidden = true;
        } else if (count == 2) {
            cell.btnAttachment1.hidden = false;
            cell.btnAttachment2.hidden = false;
            cell.btnAttachment3.hidden = true;
            cell.btnAttachment4.hidden = true;
        } else if (count == 3) {
            cell.btnAttachment1.hidden = false;
            cell.btnAttachment2.hidden = false;
            cell.btnAttachment3.hidden = false;
            cell.btnAttachment4.hidden = true;
        } else if (count == 4) {
            cell.btnAttachment1.hidden = false;
            cell.btnAttachment2.hidden = false;
            cell.btnAttachment3.hidden = false;
            cell.btnAttachment4.hidden = false;
        } else {
            cell.btnAttachment1.hidden = true;
            cell.btnAttachment2.hidden = true;
            cell.btnAttachment3.hidden = true;
            cell.btnAttachment4.hidden = true;
        }
        
        cell.btnAttachment1.tag = indexPath.row;
        cell.btnAttachment2.tag = indexPath.row;
        cell.btnAttachment3.tag = indexPath.row;
        cell.btnAttachment4.tag = indexPath.row;
        
        NSLog(@"%ld", (long)cell.btnAttachment1.tag);
        NSString *imgStr = [[feedsArray objectAtIndex:indexPath.row] valueForKey:kFeedsAPI_Image];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,imgStr]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
        cell.imgView.clipsToBounds = YES;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *recordID = [[[feedsArray objectAtIndex:indexPath.row] valueForKey:kFeedsAPI_Data] valueForKey:kFeedsAPI_RecordID];
    NSString *senderID = [[[feedsArray objectAtIndex:indexPath.row] valueForKey:kFeedsAPI_Data] valueForKey:kFeedsAPI_SenderID];
    NSString *teamID = [[[feedsArray objectAtIndex:indexPath.row] valueForKey:kFeedsAPI_Data] valueForKey:kFeedsAPI_TeamID];
    NSString *title = [[feedsArray objectAtIndex:indexPath.row] valueForKey:kFeedsAPI_Title];
    NSString *type = [[feedsArray objectAtIndex:indexPath.row] valueForKey:kFeedsAPI_Type];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    if ([type isEqualToString:@"feeds_profile"]) {
        [dictParam setObject:senderID forKey:@"id"] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileAPI_LoggedIn_UserID] ;
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setContractorDetails:[dictParam mutableCopy]] ;
        [UtilityClass setViewEntProfileMode:NO] ;
        [UtilityClass setUserType:CONTRACTOR] ;
        [UtilityClass setProfileMode:PROFILE_MODE_SEARCH] ;

        PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
        viewController.profileMode = [NSString stringWithFormat:@"%d",PROFILE_MODE_SEARCH] ;

        [self.navigationController pushViewController:viewController animated:YES] ;

    } else if ([type isEqualToString:@"feeds_startup_updated"] || [type isEqualToString:@"feeds_startup_added"]) {
        
        [dictParam setObject:senderID forKey:kStartupsAPI_EntrepreneurID] ;
        [dictParam setObject:recordID forKey:kStartupOverviewAPI_StartupID] ;
        [dictParam setObject:title forKey:kStartupsAPI_StartupName] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFeedsAPI_UserID] ;
        NSLog(@"Params : %@", dictParam);

        [UtilityClass setStartupDetails:dictParam] ;
        [UtilityClass setStartupInfoMode:YES] ;

        Info_StartupViewController *viewController = (Info_StartupViewController*)[storyboard instantiateViewControllerWithIdentifier:kStartupOverviewViewIdentifier] ;
        [viewController getStartupInfoForSearch] ;
        [self.navigationController pushViewController:viewController animated:YES] ;

    } else if ([type isEqualToString:@"feeds_startup_member_added"] || [type isEqualToString:@"feeds_startup_completed_assignment"]) { // Current Startup Detail(StartupDetailVC)
        
        [dictParam setObject:senderID forKey:kStartupsAPI_EntrepreneurID] ;
        [dictParam setObject:recordID forKey:kStartupOverviewAPI_StartupID] ;
        [dictParam setObject:title forKey:kStartupsAPI_StartupName] ;
        [dictParam setObject:teamID forKey:kStartupsAPI_Startup_TeamID];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFeedsAPI_UserID] ;
        [dictParam setObject:@"true" forKey:@"isComeFromFeeds"] ;
        NSLog(@"Params : %@", dictParam);

        [UtilityClass setStartupDetails:dictParam] ;
        [UtilityClass setStartupInfoMode:NO] ;

        StartupDetailViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kStartupDetailIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_fund_added"] || [type isEqualToString:@"feeds_fund_following"]) { // Funds Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAddFundAPI_UserID] ;
        [dictParam setObject:recordID forKey:kFundAPI_ID] ;
        [dictParam setObject:title forKey:kFundDetailAPI_FundTitle] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setFundsDetails:dictParam];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Funds" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditFundIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetFundViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;

    } else if ([type isEqualToString:@"feeds_campaign_added"] || [type isEqualToString:@"feeds_campaign_following"] || [type isEqualToString:@"feeds_campaign_commited"]) { // Campaign Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCampaignDetailAPI_UserID] ;
        [dictParam setObject:recordID forKey:kCampaignsAPI_CampaignID] ;
        [dictParam setObject:title forKey:kCampaignsAPI_CampaignName] ;
        NSLog(@"Params : %@", dictParam);

        [UtilityClass setCampaignMode:YES] ;
        [UtilityClass setCampaignDetails:dictParam];
        
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCampaignDetailIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;

    } else if ([type isEqualToString:@"feeds_improvement_added"] || [type isEqualToString:@"feeds_improvement_following"]) { // Improvement Detail
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kImprovementToolAPI_UserID] ;
        [dictParam setObject:recordID forKey:kImprovementToolAPI_ID] ;
        [dictParam setObject:title forKey:kImprovementToolAPI_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);

        [UtilityClass setImprovementToolDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SelfImprovement" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditImprovementToolIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetImprovementViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_career_added"] || [type isEqualToString:@"feeds_career_following"]) { // Career Help Detail
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCareerAPI_UserID] ;
        [dictParam setObject:recordID forKey:kCareerAPI_ID] ;
        [dictParam setObject:title forKey:kCareerAPI_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setCareerDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Career" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditCareerIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetCareerViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_organization_added"] || [type isEqualToString:@"feeds_organization_updated"]) { // Organization Detail
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCompanyDetailAPI_UserID] ;
        [dictParam setObject:recordID forKey:kCompanyDetailAPI_CompanyID] ;
        [dictParam setObject:title forKey:kSearchCompanyAPI_Company_Name] ;

        NSLog(@"Params : %@", dictParam);
        [UtilityClass setCompanyDetails:dictParam] ;
        
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCompanyDetailIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_forum_added"] || [type isEqualToString:@"feeds_forum_message"]) { // Forum Detail
        [dictParam setObject:recordID forKey:kMyForumAPI_ForumID] ;
        [dictParam setObject:title forKey:kMyForumAPI_ForumTitle] ;
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setForumDetails:dictParam] ;

        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kForumDetailIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_group_added"] || [type isEqualToString:@"feeds_group_following"]) { // Group Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kGroupAPI_UserID] ;
        [dictParam setObject:recordID forKey:kGroupAPI_ID] ;
        [dictParam setObject:title forKey:kGroupAPI_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setGroupDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditGroupIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetGroupViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_hardware_added"] || [type isEqualToString:@"feeds_hardware_following"]) { // Hardware Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kHardwareAPI_UserID] ;
        [dictParam setObject:recordID forKey:kHardwareAPI_ID] ;
        [dictParam setObject:title forKey:kHardwareAPI_Hardware_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setHardwareDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Hardware" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditHardwareIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetHardwareViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_software_added"] || [type isEqualToString:@"feeds_software_following"]) { // Software Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSoftwareAPI_UserID] ;
        [dictParam setObject:recordID forKey:kSoftwareAPI_ID] ;
        [dictParam setObject:title forKey:kSoftwareAPI_Software_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setSoftwareDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Softwares" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditSoftwareIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetSoftwareViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_service_added"] || [type isEqualToString:@"feeds_service_following"]) { // Service Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kServiceAPI_UserID] ;
        [dictParam setObject:recordID forKey:kServiceAPI_ID] ;
        [dictParam setObject:title forKey:kServiceAPI_Service_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setServiceDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Services" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditServiceIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetServiceViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_audio_added"] || [type isEqualToString:@"feeds_audio_following"]) { // Audio Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAudioVideoAPI_UserID] ;
        [dictParam setObject:recordID forKey:kAudioVideoAPI_ID] ;
        [dictParam setObject:title forKey:kAudioVideoAPI_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setAudioVideoDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AudioVideo" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditAudioVideoIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetAudioVideoViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_information_added"] || [type isEqualToString:@"feeds_information_following"]) { // Information Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kInformationAPI_UserID] ;
        [dictParam setObject:recordID forKey:kInformationAPI_ID] ;
        [dictParam setObject:title forKey:kInformationAPI_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setInformationDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Information" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditInformationIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetInformationViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_productivity_added"] || [type isEqualToString:@"feeds_productivity_following"]) { // Productivity Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProductivityAPI_UserID] ;
        [dictParam setObject:recordID forKey:kProductivityAPI_ID] ;
        [dictParam setObject:title forKey:kProductivityAPI_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setProductivityDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Productivity" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditProductivityIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetProductivityViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_conference_added"] || [type isEqualToString:@"feeds_conference_following"]) { // Conference Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConferenceAPI_UserID] ;
        [dictParam setObject:recordID forKey:kConferenceAPI_ID] ;
        [dictParam setObject:title forKey:kConferenceAPI_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setConferenceDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Conference" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditConferenceIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetConferenceViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_demoday_added"] || [type isEqualToString:@"feeds_demoday_following"]) { // Information Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kDemoDayAPI_UserID] ;
        [dictParam setObject:recordID forKey:kDemoDayAPI_ID] ;
        [dictParam setObject:title forKey:kDemoDayAPI_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setDemoDayDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DemoDays" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditDemoDayIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetDemoDayViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_meetup_added"] || [type isEqualToString:@"feeds_meetup_following"]) { // Meetup Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kMeetUpAPI_UserID] ;
        [dictParam setObject:recordID forKey:kMeetUpAPI_ID] ;
        [dictParam setObject:title forKey:kMeetUpAPI_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setMeetUpDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MeetUps" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditMeetUpIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetMeetUpViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_webinar_added"] || [type isEqualToString:@"feeds_webinar_following"]) { // Webinar Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kWebinarAPI_UserID] ;
        [dictParam setObject:recordID forKey:kWebinarAPI_ID] ;
        [dictParam setObject:title forKey:kWebinarAPI_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setWebinarDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Webinars" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditWebinarIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetWebinarViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_betatest_added"] || [type isEqualToString:@"feeds_betatest_following"]) { // Beta Test Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBetaTestAPI_UserID] ;
        [dictParam setObject:recordID forKey:kBetaTestAPI_ID] ;
        [dictParam setObject:title forKey:kBetaTestAPI_BetaTest_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setBetaTestDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BetaTesting" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditBetaTestIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetBetaTestViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_boardmember_added"] || [type isEqualToString:@"feeds_boardmember_following"]) { // Board Member Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBoardMemberAPI_UserID] ;
        [dictParam setObject:recordID forKey:kBoardMemberAPI_ID] ;
        [dictParam setObject:title forKey:kBoardMemberAPI_BoardMember_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setBoardMemberDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BoardMembers" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditBoardMemberIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetBoardMemberViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_communal_added"] || [type isEqualToString:@"feeds_communal_following"]) { // Communal Asset Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_UserID] ;
        [dictParam setObject:recordID forKey:kCommunalAssetAPI_ID] ;
        [dictParam setObject:title forKey:kCommunalAssetAPI_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setCommunalAssetDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CommunalAssets" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditCommunalAssetIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetCommunalAssetViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_consulting_added"] || [type isEqualToString:@"feeds_consulting_following"]) { // Consulting Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_UserID] ;
        [dictParam setObject:recordID forKey:kConsultingAPI_ID] ;
        [dictParam setObject:title forKey:kConsultingAPI_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setConsultingDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Consulting" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditConsultingIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetConsultingViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_earlyadopter_added"] || [type isEqualToString:@"feeds_earlyadopter_following"]) { // Early Adopter Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEarlyAdopterAPI_UserID] ;
        [dictParam setObject:recordID forKey:kEarlyAdopterAPI_ID] ;
        [dictParam setObject:title forKey:kEarlyAdopterAPI_EarlyAdopter_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setEarlyAdopterDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"EarlyAdopters" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditEarlyAdopterIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetEarlyAdopterViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_endorser_added"] || [type isEqualToString:@"feeds_endorser_following"]) { // Endorser Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEndorsorAPI_UserID] ;
        [dictParam setObject:recordID forKey:kEndorsorAPI_ID] ;
        [dictParam setObject:title forKey:kEndorsorAPI_Endorsor_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setEndorsorDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Endorsors" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditEndorsorIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetEndorsorViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_focusgroup_added"] || [type isEqualToString:@"feeds_focusgroup_following"]) { // Focus Group Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFocusGroupAPI_UserID] ;
        [dictParam setObject:recordID forKey:kFocusGroupAPI_ID] ;
        [dictParam setObject:title forKey:kFocusGroupAPI_FocusGroup_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setFocusGroupDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FocusGroups" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditFocusGroupIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetFocusGroupViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_job_added"] || [type isEqualToString:@"feeds_job_following"]) { // Job Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kJobDetailAPI_UserID] ;
        [dictParam setObject:recordID forKey:kJobDetailAPI_JobID] ;
        [dictParam setObject:title forKey:kJobDetailAPI_JobTitle] ;
        NSLog(@"Params : %@", dictParam);

        [UtilityClass setJobDetails:dictParam] ;
        
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kJobDetailIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_launchdeal_added"] || [type isEqualToString:@"feeds_launchdeal_following"]) { // Launch Deal Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kLaunchDealAPI_UserID] ;
        [dictParam setObject:recordID forKey:kLaunchDealAPI_ID] ;
        [dictParam setObject:title forKey:kLaunchDealAPI_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setLaunchDealDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LaunchDeals" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditLaunchDealIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetLaunchDealViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
        
    } else if ([type isEqualToString:@"feeds_purchaseorder_added"] || [type isEqualToString:@"feeds_purchaseorder_following"]) { // Purchase Order Detail
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kPurchaseOrderAPI_UserID] ;
        [dictParam setObject:recordID forKey:kPurchaseOrderAPI_ID] ;
        [dictParam setObject:title forKey:kPurchaseOrderAPI_Title] ;
        [dictParam setObject:@"0" forKey:@"segment"];
        [dictParam setObject:@"100" forKey:@"segmentControl"];
        NSLog(@"Params : %@", dictParam);
        
        [UtilityClass setPurchaseOrderDetails:dictParam] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GroupBuying" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditPurchaseOrderIdentifier] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPurchaseOrderViewEditing object:nil userInfo:dictParam];
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == feedsArray.count)
        return 30;
    else {
        FeedsTableViewCell *cell = (FeedsTableViewCell *)[self tableView:tblView cellForRowAtIndexPath:indexPath];
        if (cell.btnAttachment1.isHidden == true)
            return 107;
        else if ((cell.btnAttachment1.isHidden == false) && (cell.btnAttachment3.isHidden == true))
            return 125;
        else
            return 140;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == feedsArray.count) {
        [self getFeedsList] ;
    }
}

#pragma mark - Api Methods
-(void)getFeedsList {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        NSMutableDictionary *dic = [[UtilityClass getLoggedInUserDetails] mutableCopy];
        int userId = [[dic valueForKey:@"user_id"] intValue];
        if (userId > 0) {
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFeedsAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kFeedsAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getFeedsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kFeedsAPI_List]) {
                    totalItems = [[responseDict valueForKey:kFeedsAPI_TotalItems] integerValue] ;
                    
                    if (isPullToRefresh == true) {
                        [feedsArray removeAllObjects];
                        isPullToRefresh = false;
                    }
                    
                    [feedsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kFeedsAPI_List]] ;
                    for (int i=0; i<feedsArray.count ; i++) {
                        attachmentsArray = [[NSMutableArray alloc] init];
                        
                        strAttachment1 = [[feedsArray objectAtIndex:i] valueForKey:kFeedsAPI_File1];
                        strAttachment2 = [[feedsArray objectAtIndex:i] valueForKey:kFeedsAPI_File2];
                        strAttachment3 = [[feedsArray objectAtIndex:i] valueForKey:kFeedsAPI_File3];
                        strAttachment4 = [[feedsArray objectAtIndex:i] valueForKey:kFeedsAPI_File4];

                        if (![strAttachment1 isEqualToString:@""])
                            [attachmentsArray addObject:strAttachment1];
                        if (![strAttachment2 isEqualToString:@""])
                            [attachmentsArray addObject:strAttachment2];
                        if (![strAttachment3 isEqualToString:@""])
                            [attachmentsArray addObject:strAttachment3];
                        if (![strAttachment4 isEqualToString:@""])
                            [attachmentsArray addObject:strAttachment4];

                        NSMutableDictionary *tempDict = [[feedsArray objectAtIndex:i] mutableCopy];
                        [tempDict setValue:attachmentsArray forKey:@"arrOfAttachments"];
                        [feedsArray replaceObjectAtIndex:i withObject:tempDict];
                    }
                    
                    lblNoFeedsAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kFeedsAPI_List]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoFeedsAvailable.hidden = false;
                feedsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFeedsAPI_List]] ;
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = feedsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
    }
}

@end
