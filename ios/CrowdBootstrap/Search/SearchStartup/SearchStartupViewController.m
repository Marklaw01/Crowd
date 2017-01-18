//
//  SearchStartupViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 08/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "SearchStartupViewController.h"
#import "SWRevealViewController.h"
#import "SearchStartupTableViewCell.h"
#import "Info_StartupViewController.h"

@interface SearchStartupViewController ()

@end

@implementation SearchStartupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    tblView.hidden = NO ;
    pageNo = 1 ;
    totalItems = 0 ;
    searchedString = @"" ;
    [self configureSearchController] ;
    [self getStartupsListWithSearchText:@""] ;
}

-(void)navigationBarSettings{
    self.navigationItem.hidesBackButton = YES ;
    self.title = @"Search Startups" ;
}

-(void)revealViewSettings{
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    menuBarBtn.target = self.revealViewController;
    menuBarBtn.action = @selector(revealToggle:);
    
    // Set the gesture
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
}

-(void)configureSearchController{
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    searchController.searchBar.placeholder = kSearchBarPlaceholder ;
    [searchController.searchBar sizeToFit] ;
    searchController.searchResultsUpdater = self ;
    searchController.dimsBackgroundDuringPresentation = NO ;
    searchController.definesPresentationContext = YES ;
    searchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = searchController.searchBar ;
    searchController.searchBar.delegate = self ;
}

#pragma mark - API Methods
-(void)getStartupsListWithSearchText:(NSString*)searchText{
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

#pragma mark - IBAction Methods
- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length <1 || [searchedString isEqualToString:@" "]) return ;
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
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [searchController setActive:NO] ;
    [self getStartupsListWithSearchText:searchedString] ;
    
}


- (void)filterContentForSearchText:(NSString*)searchText
{
    if (searchText == nil) {
        
        // If empty the search results are the same as the original data
        searchResults = [startupsArray  mutableCopy];
    } else {
        
        [searchResults removeAllObjects] ;
        for (NSDictionary *dict in startupsArray) {
            NSString *name = [NSString stringWithFormat:@"%@",[dict valueForKey:kStartupsAPI_StartupName]] ;
            NSLog(@"name: %@ searchText: %@",name,searchText) ;
            if([[name lowercaseString] containsString:[searchText lowercaseString]]){
                [searchResults addObject:dict] ;
            }
        }
    }
    NSLog(@"searchResults: %@",searchResults) ;
    [tblView reloadData] ;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (searchController.active && ![searchController.searchBar.text isEqualToString:@""]) {
        return [searchResults count];
        
    }
    else{
        if(startupsArray.count == totalItems) return startupsArray.count ;
        else return startupsArray.count+1 ;
    }
   
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (searchController.active && ![searchController.searchBar.text isEqualToString:@""]){
        SearchStartupTableViewCell *cell = (SearchStartupTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SearchStartup] ;
        cell.startupNameLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_StartupName]] ;
        cell.entrepreneurNameLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_EntrepreneurName]] ;
        cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_StartupDesc]] ;
        
        return cell ;
    }
    else{
        if(indexPath.row == startupsArray.count){
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
            [activityIndicator startAnimating];
            return cell ;
        }
        else{
            SearchStartupTableViewCell *cell = (SearchStartupTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SearchStartup] ;
            cell.startupNameLbl.text = [NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_StartupName]] ;
            cell.entrepreneurNameLbl.text = [NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_EntrepreneurName]] ;
            cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_StartupDesc]] ;
            
            return cell ;
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if (searchController.active && ![searchController.searchBar.text isEqualToString:@""]) return 100 ;
    else{
        if(indexPath.row == startupsArray.count) return 30 ;
        else return 100 ;
    }
   
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!(searchController.active && ![searchController.searchBar.text isEqualToString:@""])){
        if(indexPath.row == startupsArray.count){
            [self getStartupsListWithSearchText:@""] ;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *array ;
    if (searchController.active && ![searchController.searchBar.text isEqualToString:@""]) array = [searchResults mutableCopy] ;
    else array = [startupsArray mutableCopy] ;
    if(indexPath.row != array.count){
        [UtilityClass setStartupDetails:(NSMutableDictionary*)[array objectAtIndex:indexPath.row]] ;
        [UtilityClass setStartupInfoMode:YES] ;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Info_StartupViewController *viewController = (Info_StartupViewController*)[storyboard instantiateViewControllerWithIdentifier:kStartupOverviewViewIdentifier] ;
        [viewController getStartupInfoForSearch] ;
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
