//
//  SearchCampaignViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 24/08/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "SearchCampaignViewController.h"
#import "SWRevealViewController.h"
#import "CampaignsTableViewCell.h"

@interface SearchCampaignViewController ()

@end

@implementation SearchCampaignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addObserver];
    [self resetUISettings] ;
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
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

-(void)resetUISettings {
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    campaignsArray = [[NSMutableArray alloc] init] ;
    searchResults = [[NSMutableArray alloc] init] ;
    tblView.hidden = NO ;
    pageNo = 1 ;
    totalItems = 0 ;
    searchedString = @"" ;
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    [formatter setGroupingSeparator:@","] ;
    [formatter setGroupingSize:3] ;
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    
    [self configureSearchController] ;
    [self getCampaignsWithSearchText:@""] ;
}

-(void)navigationBarSettings {
    self.navigationItem.hidesBackButton = YES ;
    self.title = @"Search Campaigns" ;
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

-(void)configureSearchController {
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    searchController.searchBar.placeholder = kCampaignSearchBarPlaceholder ;
    [searchController.searchBar sizeToFit] ;
    searchController.searchResultsUpdater = self ;
    searchController.dimsBackgroundDuringPresentation = NO ;
    searchController.definesPresentationContext = YES ;
    searchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = searchController.searchBar ;
    searchController.searchBar.delegate = self ;
}

#pragma mark - IBAction Methods
- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    
}

#pragma mark - API methods
-(void)getCampaignsWithSearchText:(NSString*)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        //if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSearchCampaignAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kSearchCampaignAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kSearchCampaignAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap searchCampaignsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:@"campaign_list"]){
                    totalItems = [[responseDict valueForKey:kCampaignsAPI_TotalItems] intValue] ;
                    if(searchController.active && ![searchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:@"campaign_list"]] ;
                    }
                    else{
                        [campaignsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:@"campaign_list"]] ;
                    }
                    [tblView reloadData] ;
                    pageNo ++ ;
                    
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ){
                if(searchController.active && ![searchController.searchBar.text isEqualToString:@""]){
                    /*searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMyForumAPI_Forums]] ;
                     if(searchResults.count <1)[tblView setHidden:YES] ;
                     else [tblView setHidden:NO] ;*/
                }
                else{
                    campaignsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:@"campaign_list"]] ;
                }
                [tblView reloadData] ;
                
                // [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
            
            //else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
    
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length <1 || [searchedString isEqualToString:@" "]) return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [campaignsArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    [self getCampaignsWithSearchText:searchedString] ;
    
    /* NSString *searchString = searchController.searchBar.text ;
     [self filterContentForSearchText:searchString];*/
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [campaignsArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [searchController setActive:NO] ;
    [self getCampaignsWithSearchText:searchedString] ;
    
}


#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (searchController.active && ![searchController.searchBar.text isEqualToString:@""]) {
        return [searchResults count];
        
    }
    else{
        if(campaignsArray.count == totalItems) return campaignsArray.count ;
        else return campaignsArray.count+1 ;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (searchController.active && ![searchController.searchBar.text isEqualToString:@""]){
        CampaignsTableViewCell *cell = (CampaignsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"campaignsCell"] ;
        cell.campaignNameLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_CampaignName]] ;
        cell.startupNameLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_StartupName]];
        cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_Description]];
        cell.dueDateLbl.text = [NSString stringWithFormat:@"Due Date - %@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_DueDate]];
        float targetAmount = [[[searchResults objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_TargetAmount] floatValue] ;
        cell.targetAmountLbl.text = [NSString stringWithFormat:@"Target Amount $%@",[formatter stringFromNumber:[NSNumber numberWithDouble:targetAmount]]] ;
        float fundRaised = [[[searchResults objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_FundRaised] floatValue] ;
        cell.fundsRaisedLbl.text = [NSString stringWithFormat:@"Fund Raised So Far: $%@",[formatter stringFromNumber:[NSNumber numberWithDouble:fundRaised]]] ;
        
        return cell ;
    }
    else{
        if(indexPath.row == campaignsArray.count){
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
            [activityIndicator startAnimating];
            return cell ;
        }
        else{
            CampaignsTableViewCell *cell = (CampaignsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"campaignsCell"] ;
            cell.campaignNameLbl.text = [NSString stringWithFormat:@"%@",[[campaignsArray objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_CampaignName]] ;
            cell.startupNameLbl.text = [NSString stringWithFormat:@"%@",[[campaignsArray objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_StartupName]];
            cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[campaignsArray objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_Description]];
            cell.dueDateLbl.text = [NSString stringWithFormat:@"Due Date - %@",[[campaignsArray objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_DueDate]];
            float targetAmount = [[[campaignsArray objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_TargetAmount] floatValue] ;
            cell.targetAmountLbl.text = [NSString stringWithFormat:@"Target Amount $%@",[formatter stringFromNumber:[NSNumber numberWithDouble:targetAmount]]] ;
            float fundRaised = [[[campaignsArray objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_FundRaised] floatValue] ;
            cell.fundsRaisedLbl.text = [NSString stringWithFormat:@"Fund Raised So Far: $%@",[formatter stringFromNumber:[NSNumber numberWithDouble:fundRaised]]] ;
            
            return cell ;
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (searchController.active && ![searchController.searchBar.text isEqualToString:@""]) return 180 ;
    else{
        if(indexPath.row == campaignsArray.count) return 30 ;
        else return 180 ;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!(searchController.active && ![searchController.searchBar.text isEqualToString:@""])){
        if(indexPath.row == campaignsArray.count){
            [self getCampaignsWithSearchText:@""] ;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *array ;
    if (searchController.active && ![searchController.searchBar.text isEqualToString:@""]) array = [searchResults mutableCopy] ;
    else array = [campaignsArray mutableCopy] ;
    if(indexPath.row != array.count){
        
        [UtilityClass setCampaignMode:NO] ;
        
        [UtilityClass setCampaignDetails:(NSMutableDictionary*)[array objectAtIndex:indexPath.row]] ;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCampaignDetailIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
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
