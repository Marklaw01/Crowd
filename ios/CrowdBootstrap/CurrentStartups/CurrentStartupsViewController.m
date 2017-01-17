//
//  CurrentStartupsViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 12/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "CurrentStartupsViewController.h"
#import "SWRevealViewController.h"
#import "SearchStartupTableViewCell.h"
#import "Info_StartupViewController.h"
#import "StartupDetailViewController.h"

@interface CurrentStartupsViewController ()

@end

@implementation CurrentStartupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addObserver];
    [self resetUISettings] ;
    [self navigationBarSettings] ;
    [self setSegmentControlSettings] ;
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

-(void)setNotificationIconOnNavigationBar:(NSNotification *) notification {
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"notifications"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navigateToNotification_Click:)forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblNotificationCount = [[UILabel alloc]init];
    
    [UtilityClass setNotificationIconOnNavigationBar:button
                                lblNotificationCount:lblNotificationCount navItem:self.navigationItem];
}

-(void)resetUISettings {
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    startupsArray = [[NSMutableArray alloc] init] ;
    searchResults = [[NSMutableArray alloc] init] ;
    
    tblView.hidden = YES ;
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
//    if(self.mode)
//        [segmentControl setSelectedSegmentIndex:MY_STARTUPS_SELECTED] ;
//    else
//        [segmentControl setSelectedSegmentIndex:CURRENT_SELECTED] ;
    
    [segmentControl setSelectedSegmentIndex:MY_STARTUPS_SELECTED] ;

    [self segmentControlValueChanged:nil]  ;
   // [self configureSearchController] ;
    // [self getStartupsList] ;
}

-(void)configureSearchController {
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    searchController.searchBar.placeholder = kSearchBarPlaceholder ;
    [searchController.searchBar sizeToFit] ;
    searchController.searchBar.delegate = self;
    searchController.searchResultsUpdater = self ;
    searchController.dimsBackgroundDuringPresentation = NO ;
    searchController.definesPresentationContext = YES ;
    searchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = searchController.searchBar ;
    shouldShowSearchResults = NO ;
}

-(void)navigationBarSettings {
    self.navigationItem.hidesBackButton = YES ;
    self.title = @"Startups" ;
}

-(void)revealViewSettings {
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    menuBarBtn.target = self.revealViewController;
    menuBarBtn.action = @selector(revealToggle:);
    
    // Set the gesture
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)setSegmentControlSettings {
  
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                
                                                           forKey:NSFontAttributeName];
    [segmentControl setTitleTextAttributes:attributes
                                  forState:UIControlStateNormal];
}

#pragma mark - API Methods
-(void)getStartupsList {
    if(segmentControl.selectedSegmentIndex == SEARCH_SELECTED)
        tblView.hidden = NO ;
    
    if([UtilityClass checkInternetConnection]){
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupsAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%ld",(long)segmentControl.selectedSegmentIndex] forKey:kStartupsAPI_StartupType] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kStartupsAPI_PageNo] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getStartupsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kStartupsAPI_Startups]) {
                    totalItems = [[responseDict valueForKey:kStartupsAPI_TotalItems] intValue] ;
                    for (NSDictionary *dict in (NSArray*)[responseDict valueForKey:kStartupsAPI_Startups]) {
                        [startupsArray addObject:dict] ;
                    }

                    [tblView reloadData] ;
                    if(segmentControl.selectedSegmentIndex == SEARCH_SELECTED)tblView.hidden = NO ;
                    else{
                        if(startupsArray.count < 1)
                            [tblView setHidden:YES] ;
                        else [tblView setHidden:NO] ;
                    }
                   
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


-(void)getStartupsListWithSearchText:(NSString*)searchText {
    tblView.hidden = NO ;
    if([UtilityClass checkInternetConnection]){
        
        //if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupsAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",SEARCH_SELECTED] forKey:kStartupsAPI_StartupType] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kStartupsAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kStartupsAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getStartupsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kStartupsAPI_Startups]){
                    /* totalItems = [[responseDict valueForKey:kStartupsAPI_TotalItems] intValue] ;
                     for (NSDictionary *dict in (NSArray*)[responseDict valueForKey:kStartupsAPI_Startups]) {
                     [startupsArray addObject:dict] ;
                     }
                     [tblView reloadData] ;
                     if(startupsArray.count <1)[tblView setHidden:YES] ;
                     else [tblView setHidden:NO] ;
                     pageNo ++ ;*/
                    
                    totalItems = [[responseDict valueForKey:kStartupsAPI_TotalItems] intValue] ;
                    if(searchController.active && ![searchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kStartupsAPI_Startups]] ;
                        //if(searchResults.count <1)[tblView setHidden:YES] ;
                        // else [tblView setHidden:NO] ;
                    }
                    else{
                        //contractorsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kRecommendedContAPI_Contractors]] ;
                        [startupsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kStartupsAPI_Startups]] ;
                        //if(contractorsArray.count <1)[tblView setHidden:YES] ;
                        // else [tblView setHidden:NO] ;
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
                    startupsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kStartupsAPI_Startups]] ;
                    //if(forumsArray.count <1)[tblView setHidden:YES] ;
                    //else [tblView setHidden:NO] ;
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


-(void)deleteStartupWithStartupId:(NSString*)startupID withCellIndexPath:(NSIndexPath*)cellIndexPath{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_DeleteStartup] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:startupID forKey:kStartupsAPI_StartupID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteStartupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
                
                if([startupsArray objectAtIndex:cellIndexPath.row]){
                    [startupsArray removeObjectAtIndex:cellIndexPath.row];
                    totalItems=totalItems-1 ;
                    [tblView reloadData] ;
                    if(startupsArray.count <1)[tblView setHidden:YES] ;
                    else [tblView setHidden:NO] ;
                    
                    /*[tblView deleteRowsAtIndexPaths:@[cellIndexPath ]
                                   withRowAnimation:UITableViewRowAnimationAutomatic];*/
                }
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
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "]) return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [startupsArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    [self getStartupsListWithSearchText:searchedString] ;
    
    /* NSString *searchString = searchController.searchBar.text ;
     [self filterContentForSearchText:searchString];*/
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    shouldShowSearchResults = NO ;
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [searchController setActive:NO] ;
    [self getStartupsListWithSearchText:searchedString] ;
}

/*- (void)filterContentForSearchText:(NSString*)searchText
{
    if (searchText == nil) {
        
        // If empty the search results are the same as the original data
        searchResults = [startupsArray  mutableCopy];
    } else {
        
        [searchResults removeAllObjects] ;
        for (NSDictionary *dict in startupsArray) {
            
            NSString *name = [NSString stringWithFormat:@"%@",[dict valueForKey:kStartupsAPI_StartupName]] ;
            if([[name lowercaseString] containsString:[searchText lowercaseString]]){
                [searchResults addObject:dict] ;
            }
        }
    }
    [tblView reloadData] ;
}*/

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    [searchController dismissViewControllerAnimated:NO completion:nil] ;
    if(searchController)searchController = nil ;
    
    pageNo = 1 ;
    totalItems = 0 ;
    [startupsArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if(segmentControl.selectedSegmentIndex == SEARCH_SELECTED) {
        [self configureSearchController] ;
         [self getStartupsListWithSearchText:@""] ;
    }
    else {
        tblView.tableHeaderView = [[UIView alloc] init]  ;
         [self getStartupsList] ;
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    
}

- (IBAction)DeleteStartup_ClickAction:(id)sender {
    
     NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    
     [self deleteStartupWithStartupId:[NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:[sender tag]] valueForKey:kStartupsAPI_StartupID]] withCellIndexPath:cellIndexPath] ;
}

#pragma mark - Search Bar Delegate Methods
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    shouldShowSearchResults = YES ;
    [tblView reloadData] ;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if(!shouldShowSearchResults){
        shouldShowSearchResults = YES ;
        [tblView reloadData] ;
    }
    [searchController.searchBar resignFirstResponder] ;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(segmentControl.selectedSegmentIndex == SEARCH_SELECTED && searchController.active && ![searchController.searchBar.text isEqualToString:@""]){
        return searchResults.count ;
    }
    else {
        if(startupsArray.count == totalItems)
            return startupsArray.count ;
        else
            return startupsArray.count+1 ;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(segmentControl.selectedSegmentIndex == SEARCH_SELECTED && searchController.active && ![searchController.searchBar.text isEqualToString:@""]) {
        SearchStartupTableViewCell *cell = (SearchStartupTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_StartupsList] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.startupNameLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_StartupName]] ;
        cell.entrepreneurNameLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_EntrepreneurName]] ;
        cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_StartupDesc]] ;
        if(segmentControl.selectedSegmentIndex == MY_STARTUPS_SELECTED) {
            cell.deleteButton.hidden = NO ;
            cell.arrowButton.hidden = YES ;
        }
        else {
            cell.deleteButton.hidden = YES ;
            cell.arrowButton.hidden = NO ;
        }
        cell.deleteButton.tag = indexPath.row ;
        
        return cell ;
    }
    else{
        if(indexPath.row == startupsArray.count) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
            [activityIndicator startAnimating];
            return cell ;
        }
        else {
            SearchStartupTableViewCell *cell = (SearchStartupTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_StartupsList] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            cell.startupNameLbl.text = [NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_StartupName]] ;
            cell.entrepreneurNameLbl.text = [NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_EntrepreneurName]] ;
            cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_StartupDesc]] ;
            if(segmentControl.selectedSegmentIndex == MY_STARTUPS_SELECTED) {
                cell.deleteButton.hidden = NO ;
                cell.arrowButton.hidden = YES ;
            }
            else{
                cell.deleteButton.hidden = YES ;
                cell.arrowButton.hidden = NO ;
            }
            cell.deleteButton.tag = indexPath.row ;
            
            return cell ;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(segmentControl.selectedSegmentIndex == SEARCH_SELECTED && searchController.active && ![searchController.searchBar.text isEqualToString:@""]) return 100 ;
    else {
        if(indexPath.row == startupsArray.count) return 30 ;
        else return 100 ;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!(segmentControl.selectedSegmentIndex == SEARCH_SELECTED && searchController.active && ![searchController.searchBar.text isEqualToString:@""])) {
        if(indexPath.row == startupsArray.count) {
            [self getStartupsList] ;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array ;
    if (segmentControl.selectedSegmentIndex == SEARCH_SELECTED && searchController.active && ![searchController.searchBar.text isEqualToString:@""]) array = [searchResults mutableCopy] ;
    else array = [startupsArray mutableCopy] ;
    
    if(indexPath.row != array.count) {
        [UtilityClass setStartupType:segmentControl.selectedSegmentIndex] ;
        [UtilityClass setStartupDetails:(NSMutableDictionary*)[array objectAtIndex:indexPath.row]] ;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if([UtilityClass getStartupWorkOrderType] == YES) {
             [UtilityClass setStartupInfoMode:NO] ;
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"WorkOrderView"] ;
            [self.navigationController pushViewController:viewController animated:YES] ;
        }
        else {
            if(segmentControl.selectedSegmentIndex == SEARCH_SELECTED) {
                [UtilityClass setStartupInfoMode:YES] ;
                Info_StartupViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kStartupOverviewViewIdentifier] ;
                [viewController getStartupInfoForSearch] ;
                [self.navigationController pushViewController:viewController animated:YES] ;
            }
            else {
                [UtilityClass setStartupInfoMode:NO] ;
                StartupDetailViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kStartupDetailIdentifier] ;
                // Save IDs in a dictionary
                NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
                NSString *isContractor = [[startupsArray objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_isContractor];
                if ([isContractor isEqualToString: @"true"]) {
                    NSString *startupTeamID = [[startupsArray objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_Startup_TeamID];
                    [dictParam setObject:startupTeamID forKey:kStartupWorkOrderContAPI_Startup_TeamID];
                    
                    NSString *enterpreneurID = [[startupsArray objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_EntrepreneurID];
                    [dictParam setObject:enterpreneurID forKey:kStartupWorkOrderContAPI_EnterpreneurID];
                    
                    NSString *contractorID = [NSString stringWithFormat:@"%d", [UtilityClass getLoggedInUserID]];
                    [dictParam setObject:contractorID forKey:kStartupWorkOrderContAPI_ContractorID];
                    
                    NSString *isEnterpreneur = [[startupsArray objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_isEntrepreneur];
                    [dictParam setObject:isEnterpreneur forKey:kStartupWorkOrderContAPI_IsEnterpreneur];
                    NSLog(@"dictparam: %@", dictParam);
                    
                    viewController.dictionaryIDs = dictParam;
                }
                
                [self.navigationController pushViewController:viewController animated:YES] ;
            }
        }
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
