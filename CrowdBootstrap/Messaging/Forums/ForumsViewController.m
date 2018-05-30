//
//  ForumsViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 13/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "ForumsViewController.h"
#import "SWRevealViewController.h"
#import "SWTableViewCell.h"
#import "MessagesTableViewCell.h"
#import "SearchStartupTableViewCell.h"
#import "ForumsListViewController.h"
#import "ForumsViewController.h"
#import "NotificationsTableViewCell.h"

@interface ForumsViewController ()

@end

@implementation ForumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addObserver];
    [self resetUISettings] ;
    [self revealViewSettings] ;
    [self navigationBarSettings] ;
    
}

-(void)viewWillAppear:(BOOL)animated{
    searchedString = @"" ;
    if(forumsArray) [forumsArray removeAllObjects] ;
    else forumsArray = [[NSMutableArray alloc] init] ;
    if(searchResults) [searchResults removeAllObjects] ;
    else searchResults = [[NSMutableArray alloc] init] ;
    [self updateUIAccordingToSelectedSegment] ;
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
    forumsArray = [[NSMutableArray alloc] init] ;
    searchResults = [[NSMutableArray alloc] init] ;
    searchedString = @"" ;
    forumLbl.text = kDefault_NoStartupAvailable ;
    addForumButton.hidden = YES ;
    [segmentedControl setSelectedSegmentIndex:STARTUPS_SELECTED] ;
    
}

-(void)navigationBarSettings{
    self.navigationItem.hidesBackButton = YES ;
    self.title = @"Forums" ;
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
    searchController.searchBar.placeholder = kSearchForumsPlaceholder ;
    [searchController.searchBar sizeToFit] ;
    searchController.searchResultsUpdater = self ;
    searchController.dimsBackgroundDuringPresentation = NO ;
    searchController.definesPresentationContext = YES ;
    searchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = searchController.searchBar ;
    searchController.searchBar.delegate = self ;
}

-(void)updateUIAccordingToSelectedSegment{
    [searchController dismissViewControllerAnimated:NO completion:nil] ;
    if(searchController)searchController = nil ;
    
    pageNo = 1 ;
    totalItems = 0 ;
    if(forumsArray) [forumsArray removeAllObjects] ;
    if(searchResults) [searchResults removeAllObjects] ;
    tblView.hidden = YES ;
    [tblView reloadData] ;
    
    switch (segmentedControl.selectedSegmentIndex) {
        case STARTUPS_SELECTED:
        {
            forumLbl.text = kDefault_NoStartupAvailable ;
            tblView.tableHeaderView = [[UIView alloc] init]  ;
            addForumButton.hidden = YES ;
            [self getStartupsList] ;
            break;
        }
        case FORUMS_SELECTED:
        {
            [self configureSearchController] ;
            forumLbl.text = kDefault_NoForumAvailable ;
            addForumButton.hidden = YES ;
            [self searchForumsWithSearchText:searchedString] ;
            
            break;
        }
        case MY_FORUMS_SELECTED:
        {
            forumLbl.text = kDefault_NoForumAvailable ;
            tblView.tableHeaderView = [[UIView alloc] init]  ;
            addForumButton.hidden = NO ;
            [self getMyForumsList] ;
            break;
        }
        default:
            break;
    }
}

#pragma mark - API Methofd
-(void)getStartupsList{
    
    if([UtilityClass checkInternetConnection]){
        
        if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kForumsAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kForumsAPI_PageNo] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getForumStartupsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kForumStartupsAPI_Startups]){
                    totalItems = [[responseDict valueForKey:kForumStartupsAPI_TotalItems] intValue] ;
                    forumsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kForumStartupsAPI_Startups]] ;
                    [tblView reloadData] ;
                    if(forumsArray.count <1)[tblView setHidden:YES] ;
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

-(void)searchForumsWithSearchText:(NSString*)searchText{
    
    if([UtilityClass checkInternetConnection]){
        
        //if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kForumSearchAPI_UserID] ;
        [dictParam setObject:searchText forKey:kForumSearchAPI_SearchText] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kForumsAPI_PageNo] ;
        [tblView setHidden:NO] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchForumsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
             NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                if([responseDict valueForKey:kMyForumAPI_Forums]){
                    totalItems = [[responseDict valueForKey:kMyForumAPI_TotalItems] intValue] ;
                    if(searchController.active && ![searchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMyForumAPI_Forums]] ;
                        if(searchResults.count <1)[tblView setHidden:YES] ;
                        else [tblView setHidden:NO] ;
                    }
                    else{
                        forumsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMyForumAPI_Forums]] ;
                        if(forumsArray.count <1)[tblView setHidden:YES] ;
                        else [tblView setHidden:NO] ;
                    }
                    [tblView reloadData] ;
                   
                    pageNo ++ ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ){
                if(searchController.active && ![searchController.searchBar.text isEqualToString:@""]){
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMyForumAPI_Forums]] ;
//                    if(searchResults.count <1)[tblView setHidden:YES] ;
//                    else [tblView setHidden:NO] ;
                }
                else{
                    forumsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMyForumAPI_Forums]] ;
                    //if(forumsArray.count <1)[tblView setHidden:YES] ;
                    //else [tblView setHidden:NO] ;
                }
                [tblView reloadData] ;
                
               // [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyForumsList{
    if([UtilityClass checkInternetConnection]){
        
        if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kForumsAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kForumsAPI_PageNo] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getMyForumsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kMyForumAPI_Forums]){
                    totalItems = [[responseDict valueForKey:kMyForumAPI_TotalItems] intValue] ;
                    forumsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMyForumAPI_Forums]] ;
                    [tblView reloadData] ;
                    if(forumsArray.count <1)[tblView setHidden:YES] ;
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

-(void)archiveDeleteForumWithIndexPath:(NSIndexPath*)cellIndexPath actionType:(int)shouldArchive{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[forumsArray objectAtIndex:cellIndexPath.row] valueForKey:kMyForumAPI_ForumID]] forKey:kArchiveForumAPI_ForumID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",shouldArchive] forKey:kArchiveForumAPI_Status] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveDeleteForumWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
             NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
               
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"]  withResultType:@"1" withDuration:1] ;
                
                [forumsArray removeObjectAtIndex:cellIndexPath.row];
                totalItems = totalItems-1 ;
                [tblView reloadData];
                if(forumsArray.count <1) tblView.hidden = YES ;
                else tblView.hidden = NO ;
            }
            //else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    searchedString = searchController.searchBar.text ;
    if(searchedString.length <1 || [searchedString isEqualToString:@" "]) return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [forumsArray removeAllObjects] ;
    [searchResults removeAllObjects];
    [self searchForumsWithSearchText:searchedString] ;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [forumsArray removeAllObjects] ;
    [searchResults removeAllObjects];
    [searchController setActive:NO] ;
    [self searchForumsWithSearchText:searchedString] ;
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    if (searchText == nil) {
        
        // If empty the search results are the same as the original data
        searchResults = [forumsArray  mutableCopy];
    } else {
        
        [searchResults removeAllObjects] ;
        for (NSDictionary *dict in forumsArray) {
            
            NSString *name = [NSString stringWithFormat:@"%@",[dict valueForKey:kMyForumAPI_ForumTitle]] ;
            if([name containsString:searchText]){
                [searchResults addObject:dict] ;
            }
        }
    }
    [tblView reloadData] ;
}


#pragma mark - IBAction Methods
- (IBAction)segControl_ValueChanged:(id)sender {
    
    [self updateUIAccordingToSelectedSegment] ;
}

- (IBAction)AddForum_ClickAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kAddForumIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(segmentedControl.selectedSegmentIndex == FORUMS_SELECTED && searchController.active && ![searchController.searchBar.text isEqualToString:@""]){
        return searchResults.count ;
    }
    else{
        if(forumsArray.count == totalItems) return forumsArray.count ;
        else return forumsArray.count+1 ;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(segmentedControl.selectedSegmentIndex == FORUMS_SELECTED && searchController.active && ![searchController.searchBar.text isEqualToString:@""]){
        NotificationsTableViewCell *cell = (NotificationsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:FORUM_SEARCH_FORUMS_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        if (searchResults.count > 0) {

        cell.titleLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kMyForumAPI_ForumTitle]] ;
        cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kMyForumAPI_ForumDesc]] ;
        cell.timeLbl.text = [UtilityClass formatDateFromString:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kMyForumAPI_ForumCreatedTime]]]  ;
        
        }
        return cell ;
    }
    else{
        
        if(indexPath.row == forumsArray.count){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
            [activityIndicator startAnimating];
            return cell ;
        }
        else{
            
            MessagesTableViewCell *cell = (MessagesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:FORUM_FORUMS_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            if(segmentedControl.selectedSegmentIndex == STARTUPS_SELECTED){
                
                SearchStartupTableViewCell *cell = (SearchStartupTableViewCell*)[tableView dequeueReusableCellWithIdentifier:FORUM_STARTUP_CELL_IDENTIFIER] ;
                cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                
                if (forumsArray.count > 0) {
                    cell.startupNameLbl.text = [NSString stringWithFormat:@"%@",[[forumsArray objectAtIndex:indexPath.row] valueForKey:kForumStartupsAPI_StartupName]] ;
                    cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[forumsArray objectAtIndex:indexPath.row] valueForKey:kForumStartupsAPI_Description]] ;
                }
                return cell ;
            }
            else{
                MessagesTableViewCell *cell = (MessagesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:FORUM_FORUMS_CELL_IDENTIFIER] ;
                cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                
                if (forumsArray.count > 0) {

                    cell.messageLbl.text = [NSString stringWithFormat:@"%@",[[forumsArray objectAtIndex:indexPath.row] valueForKey:kMyForumAPI_ForumTitle]] ;
                    cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[forumsArray objectAtIndex:indexPath.row] valueForKey:kMyForumAPI_ForumDesc]] ;
                    cell.timeLbl.text = [UtilityClass formatDateFromString:[NSString stringWithFormat:@"%@",[[forumsArray objectAtIndex:indexPath.row] valueForKey:kMyForumAPI_ForumCreatedTime]]]  ;
                }
                if(segmentedControl.selectedSegmentIndex == MY_FORUMS_SELECTED){
                    NSMutableArray *rightUtilityButtons = [NSMutableArray new] ;
                    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:76.0/255.0f green:76.0/255.0f blue:76.0/255.0f alpha:1] icon:[UIImage imageNamed:FORUM_CLOSE_IMAGE]] ;
                    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:18.0/255.0f green:89.0/255.0f blue:23.0/255.0f alpha:1] icon:[UIImage imageNamed:FORUM_ARCHIVE_IMAGE]] ;
                    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:197.0/255.0f green:4.0/255.0f blue:25.0/255.0f alpha:1] icon:[UIImage imageNamed:FORUM_DELETE_IMAGE]] ;
                    cell.rightUtilityButtons = rightUtilityButtons ;
                    cell.delegate = self ;
                }
                else cell.rightUtilityButtons = nil ;
                
                return cell ;
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(segmentedControl.selectedSegmentIndex == FORUMS_SELECTED && searchController.active && ![searchController.searchBar.text isEqualToString:@""]) return 90 ;
    else{
        if(indexPath.row == forumsArray.count) return 30 ;
        else return 90 ;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(!(segmentedControl.selectedSegmentIndex == FORUMS_SELECTED && searchController.active && ![searchController.searchBar.text isEqualToString:@""])){
        if(indexPath.row == forumsArray.count){
            if(segmentedControl.selectedSegmentIndex == STARTUPS_SELECTED) [self getStartupsList] ;
            else if(segmentedControl.selectedSegmentIndex == FORUMS_SELECTED) [self searchForumsWithSearchText:@""] ;
            else [self getMyForumsList] ;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if(segmentedControl.selectedSegmentIndex == FORUMS_SELECTED && searchController.active && ![searchController.searchBar.text isEqualToString:@""]){
        [UtilityClass setForumType:NO] ;
        [UtilityClass setForumDetails:(NSMutableDictionary*)[searchResults objectAtIndex:indexPath.row]] ;
         UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kForumDetailIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
    else if(indexPath.row != forumsArray.count){
        if(segmentedControl.selectedSegmentIndex == STARTUPS_SELECTED){
            [UtilityClass setForumDetails:(NSMutableDictionary*)[forumsArray objectAtIndex:indexPath.row]] ;
            ForumsListViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kForumsListIdentifier] ;
            viewController.startupDict = [NSMutableDictionary dictionaryWithDictionary:[forumsArray objectAtIndex:indexPath.row]] ;
            [self.navigationController pushViewController:viewController animated:YES] ;
        }
        else{
            if(segmentedControl.selectedSegmentIndex == MY_FORUMS_SELECTED)[UtilityClass setForumType:YES] ;
            else [UtilityClass setForumType:NO] ;
            [UtilityClass setForumDetails:(NSMutableDictionary*)[forumsArray objectAtIndex:indexPath.row]] ;
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kForumDetailIdentifier] ;
            [self.navigationController pushViewController:viewController animated:YES] ;
        }
    }
}

#pragma mark - SWTableView Delegate Methods
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    /*NSIndexPath *cellIndexPath = [tblView indexPathForCell:cell];
    
    [forumsArray removeObjectAtIndex:cellIndexPath.row];
    [tblView deleteRowsAtIndexPaths:@[cellIndexPath]
                   withRowAnimation:UITableViewRowAnimationAutomatic];*/
    
    NSIndexPath *cellIndexPath = [tblView indexPathForCell:cell];
    int actionType  ;
    NSString *message ;
    if(index == CLOSE){
        message = [NSString stringWithFormat:@"%@close this forum ?",kAlert_StartTeam] ;
        actionType = 3 ;
    }
    else if(index == ARCHIVE){
        message = [NSString stringWithFormat:@"%@archive this forum ?",kAlert_StartTeam] ;
        actionType = index ;
    }
    else{
        message = [NSString stringWithFormat:@"%@delete this forum ?",kAlert_StartTeam] ;
        actionType = index ;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [self archiveDeleteForumWithIndexPath:cellIndexPath actionType:actionType] ;
        
    }];
    UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [tblView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationRight] ;
    }];
    
    [alertController addAction:yes];
    [alertController addAction:no];
    
    [self presentViewController:alertController animated:YES completion:nil] ;
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
