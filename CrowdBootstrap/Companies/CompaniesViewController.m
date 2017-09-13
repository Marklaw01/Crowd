//
//  CompaniesViewController.m
//  CrowdBootstrap
//
//  Created by Shikha Singla on 22/11/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "CompaniesViewController.h"
#import "SWRevealViewController.h"
#import "SearchContractorTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface CompaniesViewController ()

@end

@implementation CompaniesViewController

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
    
    searchedString = @""  ;
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    [formatter setGroupingSeparator:@","] ;
    [formatter setGroupingSize:3] ;
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    companiesArray = [[NSMutableArray alloc] init] ;
    searchResults = [[NSMutableArray alloc] init] ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //tblView.hidden = YES ;
    pageNo = 1 ;
    totalItems = 0 ;
    [self configureSearchController] ;
//    if(self.startupID)
//        [self getContractorsList] ;
//    else
        [self searchCompanyWithSearchText:@""] ;
}

-(void)configureSearchController {
    companySearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    companySearchController.searchBar.placeholder = kSearchOrganizationPlaceholder ;
    [companySearchController.searchBar sizeToFit] ;
    companySearchController.searchResultsUpdater = self ;
    companySearchController.dimsBackgroundDuringPresentation = NO ;
    companySearchController.definesPresentationContext = YES ;
    companySearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = companySearchController.searchBar ;
    companySearchController.searchBar.delegate = self ;
}

-(void)navigationBarSettings {
    self.navigationItem.hidesBackButton = YES ;
    self.title = kTitle_SearchCompany;
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

-(void)searchCompanyWithSearchText:(NSString*)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        //if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSearchCompanyAPI_UserID] ;
        [dictParam setObject:searchText forKey:kSearchCompanyAPI_SearchText] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kSearchCompanyAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap searchCompaniesWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kSearchCompanyAPI_Company_list]){
                    /* totalItems = [[responseDict valueForKey:kRecommendedContAPI_TotalItems] intValue] ;
                     //contractorsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kRecommendedContAPI_Contractors]] ;
                     [contractorsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kRecommendedContAPI_Contractors]] ;
                     [tblView reloadData] ;
                     if(contractorsArray.count <1)[tblView setHidden:YES] ;
                     else [tblView setHidden:NO] ;
                     pageNo ++ ;*/
                    
                    totalItems = [[responseDict valueForKey:kSearchCompanyAPI_TotalItems] intValue] ;
                    if(companySearchController.active && ![companySearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSearchCompanyAPI_Company_list]] ;
                        //if(searchResults.count <1)[tblView setHidden:YES] ;
                        // else [tblView setHidden:NO] ;
                    }
                    else{
                        //contractorsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kRecommendedContAPI_Contractors]] ;
                        [companiesArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSearchCompanyAPI_Company_list]] ;
                        //if(contractorsArray.count <1)[tblView setHidden:YES] ;
                        // else [tblView setHidden:NO] ;
                    }
                    [tblView reloadData] ;
                    
                    pageNo ++ ;
                    
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ){
                if(companySearchController.active && ![companySearchController.searchBar.text isEqualToString:@""]){
                    /*searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMyForumAPI_Forums]] ;
                     if(searchResults.count <1)[tblView setHidden:YES] ;
                     else [tblView setHidden:NO] ;*/
                }
                else{
                    companiesArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSearchCompanyAPI_Company_list]] ;
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
    [companiesArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    [self searchCompanyWithSearchText:searchedString] ;
    
    //[self filterContentForSearchText:searchString];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [companiesArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [companySearchController setActive:NO] ;
    [self searchCompanyWithSearchText:searchedString] ;
}

#pragma mark - IBAction Methods
- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (companySearchController.active && ![companySearchController.searchBar.text isEqualToString:@""]) return searchResults.count ;
    else {
        if(companiesArray.count == totalItems) return companiesArray.count ;
        else return companiesArray.count+1 ;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (companySearchController.active && ![companySearchController.searchBar.text isEqualToString:@""]) {
        SearchContractorTableViewCell *cell = (SearchContractorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SearchCompany] ;
        cell.nameLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchCompanyAPI_Company_Name]] ;
        cell.skillLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchCompanyAPI_Company_Desc]];

        cell.rateLbl.hidden = true;
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchCompanyAPI_Company_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        cell.imgView.layer.cornerRadius = 17.5;
        cell.imgView.clipsToBounds = YES;
        
        return cell ;
    }
    else {
        if(indexPath.row == companiesArray.count) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
            [activityIndicator startAnimating];
            return cell ;
        }
        else {
            SearchContractorTableViewCell *cell = (SearchContractorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SearchCompany] ;
            cell.nameLbl.text = [NSString stringWithFormat:@"%@",[[companiesArray objectAtIndex:indexPath.row] valueForKey:kSearchCompanyAPI_Company_Name]] ;
            cell.skillLbl.text = [NSString stringWithFormat:@"%@",[[companiesArray objectAtIndex:indexPath.row] valueForKey:kSearchCompanyAPI_Company_Desc]];
            cell.rateLbl.hidden = true;

            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[[companiesArray objectAtIndex:indexPath.row] valueForKey:kSearchCompanyAPI_Company_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            cell.imgView.layer.cornerRadius = 17.5;
            cell.imgView.clipsToBounds = YES;
            
            return cell ;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (companySearchController.active && ![companySearchController.searchBar.text isEqualToString:@""]) return 100 ;
    else{
        if(indexPath.row == companiesArray.count) return 30 ;
        else return 100 ;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!(companySearchController.active && ![companySearchController.searchBar.text isEqualToString:@""])) {
        if(indexPath.row == companiesArray.count) {
//            if(self.startupID)
//                [self getContractorsList] ;
//            else
                [self searchCompanyWithSearchText:@""] ;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row != companiesArray.count) {
        NSString *viewIdentifier = kCompanyDetailIdentifier ;
        
        [UtilityClass setCompanyDetails:(NSMutableDictionary*)[companiesArray objectAtIndex:indexPath.row]] ;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:viewIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
    
//    NSMutableArray *array ;
//    if (companySearchController.active && ![companySearchController.searchBar.text isEqualToString:@""])
//        array = [searchResults mutableCopy] ;
//    else
//        array = [companiesArray mutableCopy] ;
//    NSLog(@"Selected Company : %@", [[array objectAtIndex:indexPath.row] valueForKey:kSearchCompanyAPI_Company_Name]);
}

@end
