//
//  SearchContractorViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 08/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "SearchContractorViewController.h"
#import "SWRevealViewController.h"
#import "SearchContractorTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "PublicProfileViewController.h"

@interface SearchContractorViewController ()

@end

@implementation SearchContractorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserver];
    [self resetUISettings] ;
    if(self.startupID)
        [self resetNavigationBarsettings] ;
    else {
        [self navigationBarSettings] ;
         [self revealViewSettings] ;
    }
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
    
    searchedString = @""  ;
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    [formatter setGroupingSeparator:@","] ;
    [formatter setGroupingSize:3] ;
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    contractorsArray = [[NSMutableArray alloc] init] ;
    searchResults = [[NSMutableArray alloc] init] ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //tblView.hidden = YES ;
    pageNo = 1 ;
    totalItems = 0 ;
    [self configureSearchController] ;
    if(self.startupID)
        [self getContractorsList] ;
    else
        [self searchContractorWithSearchText:@""] ;
} 

-(void)configureSearchController {
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    searchController.searchBar.placeholder = kSearchContractorPlaceholder ;
    [searchController.searchBar sizeToFit] ;
    searchController.searchResultsUpdater = self ;
    searchController.dimsBackgroundDuringPresentation = NO ;
    searchController.definesPresentationContext = YES ;
    searchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = searchController.searchBar ;
    searchController.searchBar.delegate = self ;
}

-(void)navigationBarSettings {
    self.navigationItem.hidesBackButton = YES ;
    self.title = kTitle_SearchContractor ;
}

-(void)resetNavigationBarsettings {
   self.title = kTitle_RecommendedContractor ;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back_Icon"] style:UIBarButtonItemStylePlain target:self action:@selector(BackButton_ClickAction)] ;
    self.navigationItem.leftBarButtonItem = backButton ;
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

-(NSString*)getSkillsFromArray:(NSArray*)array{
    NSString* skillsStr = @"" ;
    
    for (int i = 0; i<array.count; i++) {
        NSString *name = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i]valueForKey:@"name"]] ;
        if(i == 0) skillsStr = name ;
        else skillsStr = [NSString stringWithFormat:@"%@, %@",skillsStr,name] ;
    }
    return skillsStr ;
}

#pragma mark - API Methods
-(void)getContractorsList {
    if([UtilityClass checkInternetConnection]){
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:self.startupID forKey:kRecommendedContAPI_StartupID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kRecommendedContAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kRecommendedContAPI_PageNo] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getRecommendedContractorsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
               // NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kRecommendedContAPI_Contractors]){
                     totalItems = [[responseDict valueForKey:kRecommendedContAPI_TotalItems] intValue] ;
                    
                    [contractorsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kRecommendedContAPI_Contractors]] ;
                    [tblView reloadData] ;
                    if(contractorsArray.count <1)[tblView setHidden:YES] ;
                    else [tblView setHidden:NO] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kRecommendedContAPI_Contractors]] ;
                    
                     NSLog(@"totalItems: %d count: %lu",totalItems ,(unsigned long)arr.count) ;
                }
            }
            //else  if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            totalItems = contractorsArray.count ;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)searchContractorWithSearchText:(NSString*)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        //if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSearchContAPI_UserID] ;
        [dictParam setObject:searchText forKey:kSearchContAPI_SearchText] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kSearchContAPI_PageNo] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap searchContractorsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kRecommendedContAPI_Contractors]) {
                   /* totalItems = [[responseDict valueForKey:kRecommendedContAPI_TotalItems] intValue] ;
                    //contractorsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kRecommendedContAPI_Contractors]] ;
                    [contractorsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kRecommendedContAPI_Contractors]] ;
                    [tblView reloadData] ;
                    if(contractorsArray.count <1)[tblView setHidden:YES] ;
                    else [tblView setHidden:NO] ;
                    pageNo ++ ;*/
                    
                    totalItems = [[responseDict valueForKey:kRecommendedContAPI_TotalItems] intValue] ;
                    if(searchController.active && ![searchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kRecommendedContAPI_Contractors]] ;
                        //if(searchResults.count <1)[tblView setHidden:YES] ;
                       // else [tblView setHidden:NO] ;
                    }
                    else {
                        //contractorsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kRecommendedContAPI_Contractors]] ;
                        [contractorsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kRecommendedContAPI_Contractors]] ;
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
                    contractorsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kRecommendedContAPI_Contractors]] ;
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

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
   
    searchedString = searchController.searchBar.text ;
    if(searchedString.length <1 || [searchedString isEqualToString:@" "]) return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [contractorsArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    [self searchContractorWithSearchText:searchedString] ;
    
    //[self filterContentForSearchText:searchString];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [contractorsArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [searchController setActive:NO] ;
    [self searchContractorWithSearchText:searchedString] ;
    
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    if (searchText == nil) {
        
        // If empty the search results are the same as the original data
        searchResults = [contractorsArray  mutableCopy];
    } else {
        
        [searchResults removeAllObjects] ;
        for (NSDictionary *dict in contractorsArray) {
            //NSLog(@"dict: %@",dict) ;
            BOOL isIncluded = NO ;
            NSString *name = [NSString stringWithFormat:@"%@",[dict valueForKey:kRecommendedContAPI_Contractor_Name]] ;
           //  NSLog(@"name: %@ searchText: %@",name,searchText) ;
            if([[name lowercaseString] containsString:[searchText lowercaseString]]){
                [searchResults addObject:dict] ;
                isIncluded = YES ;
            }
            NSArray *skillsArr = [NSArray arrayWithArray:[dict valueForKey:kRecommendedContAPI_Keywords]] ;
            for (NSDictionary *obj in skillsArr) {
                NSString *skillName = [NSString stringWithFormat:@"%@",[obj valueForKey:@"name"]] ;
                if([[skillName lowercaseString] containsString:[searchText lowercaseString]] && isIncluded == NO){
                    [searchResults addObject:dict] ;
                    isIncluded = YES ;
                }
            }
        }
    }
    [tblView reloadData] ;
}

#pragma mark - IBAction Methods
- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    
}

-(void)BackButton_ClickAction{
    [self.navigationController popViewControllerAnimated:YES] ;
}


#pragma mark - SearchBar Delegate Method
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (searchController.active && ![searchController.searchBar.text isEqualToString:@""]) return searchResults.count ;
    else {
        if(contractorsArray.count == totalItems) return contractorsArray.count ;
        else return contractorsArray.count+1 ;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (searchController.active && ![searchController.searchBar.text isEqualToString:@""]){
        SearchContractorTableViewCell *cell = (SearchContractorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SearchContractor] ;
        cell.nameLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Contractor_Name]] ;
        NSString *rateStr = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Rate]]  ;
        if(![rateStr isEqualToString:@""] && ![rateStr isEqualToString:@" "]){
            float rate = [[[searchResults objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Rate] floatValue] ;
            cell.rateLbl.text = [NSString stringWithFormat:@"$%@/HR",[formatter stringFromNumber:[NSNumber numberWithDouble:rate]]] ;
        }
        else cell.rateLbl.text = @"$0/HR" ;
        cell.skillLbl.text = [self getSkillsFromArray: (NSArray*)[[searchResults objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Keywords]] ;
        cell.followerBtn.hidden = YES;
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        cell.imgView.layer.cornerRadius = 17.5;
        cell.imgView.clipsToBounds = YES;
        
        return cell ;
    }
    else {
        if(indexPath.row == contractorsArray.count){
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
            [activityIndicator startAnimating];
            return cell ;
        }
        else{
            SearchContractorTableViewCell *cell = (SearchContractorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SearchContractor] ;
            cell.nameLbl.text = [NSString stringWithFormat:@"%@",[[contractorsArray objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Contractor_Name]] ;
            NSString *rateStr = [NSString stringWithFormat:@"%@",[[contractorsArray objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Rate]]  ;
            if(![rateStr isEqualToString:@""] && ![rateStr isEqualToString:@" "]){
                float rate = [[[contractorsArray objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Rate] floatValue] ;
                cell.rateLbl.text = [NSString stringWithFormat:@"$%@/HR",[formatter stringFromNumber:[NSNumber numberWithDouble:rate]]] ;
            }
            else cell.rateLbl.text = @"$0/HR" ;
            //cell.skillLbl.text = [NSString stringWithFormat:@"%@",[[contractorsArray objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Bio]] ;
            cell.skillLbl.text = [self getSkillsFromArray: (NSArray*)[[contractorsArray objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Keywords]] ;
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[[contractorsArray objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            cell.imgView.layer.cornerRadius = 17.5;
            cell.imgView.clipsToBounds = YES;
            
            return cell ;
        }
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (searchController.active && ![searchController.searchBar.text isEqualToString:@""]) return 100 ;
    else{
        if(indexPath.row == contractorsArray.count) return 30 ;
        else return 100 ;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!(searchController.active && ![searchController.searchBar.text isEqualToString:@""])) {
        if(indexPath.row == contractorsArray.count){
            if(self.startupID)
                [self getContractorsList] ;
            else
                [self searchContractorWithSearchText:@""] ;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array ;
    if (searchController.active && ![searchController.searchBar.text isEqualToString:@""]) array = [searchResults mutableCopy] ;
    else array = [contractorsArray mutableCopy] ;
    
    if(indexPath.row != array.count) {
        
        if([UtilityClass getContAssignWorkUnitsMode] == NO) {
            if([[[array objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Is_Profile_Pubilc] intValue] && [[[array objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Is_Profile_Pubilc] intValue] == 1) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:[NSString stringWithFormat:@"%@",[[array objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_ContractorID]] forKey:kRecommendedContAPI_ContractorID] ;
                [dict setValue:[NSString stringWithFormat:@"%@",[[array objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Contractor_Name]] forKey:kRecommendedContAPI_Contractor_Name] ;
                [dict setValue:[NSString stringWithFormat:@"%@",[[array objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Rate]] forKey:kRecommendedContAPI_Rate] ;
                [dict setValue:TEAM_TYPE_CONTRACTOR forKey:kStartupTeamAPI_MemberRole] ;
                
                if(self.startupID) {
                    [dict setValue:self.startupID forKey:kRecommendedContAPI_StartupID] ;
                    viewController.profileMode = [NSString stringWithFormat:@"%d",PROFILE_MODE_RECOMMENDED] ;
                    [UtilityClass setProfileMode:PROFILE_MODE_RECOMMENDED] ;
                }
                else{
                    [dict setValue:@"" forKey:kRecommendedContAPI_StartupID] ;
                    viewController.profileMode = [NSString stringWithFormat:@"%d",PROFILE_MODE_SEARCH] ;
                    [UtilityClass setViewEntProfileMode:NO] ;
                    [UtilityClass setUserType:CONTRACTOR] ;
                    [UtilityClass setProfileMode:PROFILE_MODE_SEARCH] ;
                }
                
                [UtilityClass setContractorDetails:[dict mutableCopy]] ;
                NSLog(@"getContractorDetails: %@",[UtilityClass getContractorDetails]) ;
                
                [self.navigationController pushViewController:viewController animated:YES] ;
            }
            else{
                [self presentViewController:[UtilityClass displayAlertMessage:kAlert_UserPrivateProfile] animated:YES completion:nil] ;
            }
        }
        else{
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSString stringWithFormat:@"%@",[[array objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_ContractorID]] forKey:kRecommendedContAPI_ContractorID] ;
            [dict setValue:[NSString stringWithFormat:@"%@",[[array objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Contractor_Name]] forKey:kRecommendedContAPI_Contractor_Name] ;
            [dict setValue:[NSString stringWithFormat:@"%@",[[array objectAtIndex:indexPath.row] valueForKey:kRecommendedContAPI_Rate]] forKey:kRecommendedContAPI_Rate] ;
            [dict setValue:TEAM_TYPE_CONTRACTOR forKey:kStartupTeamAPI_MemberRole] ;
            [dict setValue:@"" forKey:kRecommendedContAPI_StartupID] ;
            [UtilityClass setContractorDetails:[dict mutableCopy]] ;
            [UtilityClass setViewEntProfileMode:NO] ;
            [UtilityClass setUserType:CONTRACTOR] ;
            [UtilityClass setProfileMode:PROFILE_MODE_SEARCH] ;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kAddContractorIdentifier] ;
            [self.navigationController pushViewController:viewController animated:YES] ;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)  :(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
