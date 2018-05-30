//
//  MyFundsViewController.m
//  CrowdBootstrap
//
//  Created by osx on 20/01/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyFundsViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyFundsViewController ()

@end

@implementation MyFundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
}

//- (void)viewWillAppear:(BOOL)animated {
//    //    // Set previous selected Search Text
//    //    if ([kUSERDEFAULTS valueForKey:@"SearchText"] != nil)
//    //        searchedString = [kUSERDEFAULTS valueForKey:@"SearchText"];
//    //    else
//    //        searchedString = @""  ;
//    
//    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_Funds_AddEditScreen];
//    if (selectedSegmentControl == 100) { // Find Funds
//        if (selectedSegment == FINDFUNDS_SELECTED) {
//            isComeFromAddEdit = NO;
//        }
//    }
//    if (isComeFromAddEdit) {
//        pageNo = 1;
//        [self getMyFundsListWithSearchText:searchedString];
//    }
//}
//
- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_Funds_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find Beta Test
    //        if (selectedSegment == SEARCH_BETA_TEST_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find Beta Test
            if (selectedSegment == FINDFUNDS_SELECTED) {
                [self getFindFundsWithSearchText:searchedString];
            } else
                [self getMyFundsListWithSearchText:searchedString];
        } else {// My Beta Test
            if (selectedSegment == MYFUNDS_SELECTED) {
                [self getMyFundsListWithSearchText:searchedString];
            } else if (selectedSegment == ARCHIVE_FUNDS_SELECTED) {
                [self getArchiveFundsList:searchedString];
            } else {
                [self getDeactivatedFundsList:searchedString];
            }
        }
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

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content {
    self.title = viewTitle ;
}

-(void)navigationBarSettings {
    self.navigationItem.hidesBackButton = YES ;
}

-(void)revealViewSettings {
    menuBarBtn.target = self.revealViewController;
    menuBarBtn.action = @selector(revealToggle:);
    
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
}

-(void)setSegmentControlSettings {
    
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segmentControlMyFunds setTitleTextAttributes:attributes
                                              forState:UIControlStateNormal];
    [self.segmentControlFindFunds setTitleTextAttributes:attributes
                                                forState:UIControlStateNormal];
}

-(void)resetUISettings {
    
    // Set previous selected Search Text
    if ([kUSERDEFAULTS valueForKey:@"SearchText"] != nil)
        searchedString = [kUSERDEFAULTS valueForKey:@"SearchText"];
    else
        searchedString = @""  ;
    
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblViewPopUp.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    fundsArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];

    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyFunds.hidden = true;
    createFundBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlFindFunds setSelectedSegmentIndex:FINDFUNDS_SELECTED] ;
    [self.segmentControlMyFunds setSelectedSegmentIndex:MYFUNDS_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get Funds List
    [self getFindFundsWithSearchText:searchedString];
}

-(void)configureSearchController {
    fundSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    fundSearchController.searchBar.placeholder = kSearchFundPlaceholder ;
    [fundSearchController.searchBar sizeToFit] ;
    fundSearchController.searchBar.text = searchedString;
    fundSearchController.searchResultsUpdater = self ;
    fundSearchController.dimsBackgroundDuringPresentation = NO ;
    fundSearchController.definesPresentationContext = YES ;
    fundSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = fundSearchController.searchBar ;
    fundSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [fundsArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Funds
        if (selectedSegment == FINDFUNDS_SELECTED)
            [self getFindFundsWithSearchText:searchedString] ; // Find Funds
        else
            [self getMyFundsListWithSearchText:searchedString] ; // My Funds
    }
    else { // Fund/Invest
        if (selectedSegment == MYFUNDS_SELECTED)
            [self getMyFundsListWithSearchText:searchedString] ; // My Funds
        else if (selectedSegment == ARCHIVE_FUNDS_SELECTED)
            [self getArchiveFundsList:searchedString] ; // Archived Funds
        else
            [self getDeactivatedFundsList:searchedString] ; // Deactivated Funds
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [fundsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [fundSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Funds
        if (selectedSegment == FINDFUNDS_SELECTED)
            [self getFindFundsWithSearchText:searchedString] ; // Find Funds
        else
            [self getMyFundsListWithSearchText:searchedString] ; // My Funds
    }
    else { // Fund/Invest
        if (selectedSegment == MYFUNDS_SELECTED)
            [self getMyFundsListWithSearchText:searchedString] ; // My Funds
        else if (selectedSegment == ARCHIVE_FUNDS_SELECTED)
            [self getArchiveFundsList:searchedString] ; // Archived Funds
        else
            [self getDeactivatedFundsList:searchedString] ; // Deactivated Funds
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [fundsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find Funds
        selectedSegment = self.segmentControlFindFunds.selectedSegmentIndex;
        
        if (selectedSegment == FINDFUNDS_SELECTED) { //0
            [self getFindFundsWithSearchText:searchedString] ; // Find Funds
            self.segmentControlMyFunds.hidden = true;
            createFundBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyFundsListWithSearchText:searchedString] ; // My Funds
            [self.segmentControlMyFunds setSelectedSegmentIndex:MYFUNDS_SELECTED] ;
            self.segmentControlMyFunds.hidden = false;
            createFundBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // Fund/Invest
        selectedSegment = self.segmentControlMyFunds.selectedSegmentIndex;
        self.segmentControlMyFunds.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MYFUNDS_SELECTED) { //0
            [self getMyFundsListWithSearchText:searchedString] ; // My Funds
            createFundBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_FUNDS_SELECTED) { //1
            createFundBtn.hidden = true;
            [self getArchiveFundsList:searchedString ] ; // Archived Funds
        }
        else { //2
            [self getDeactivatedFundsList:searchedString] ; // Deactivated Funds
            createFundBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveFund_ClickAction:(id)sender {
    
    if(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""]) {
        fundID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kFundAPI_ID];
    }
    else {
        fundID = [[fundsArray objectAtIndex:[sender tag]] valueForKey: kFundAPI_ID];
    }
    [self archiveFund:fundID];
}

- (IBAction)deactivateFund_ClickAction:(id)sender {
    if(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""]) {
        fundID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kFundAPI_ID];
    }
    else {
        fundID = [[fundsArray objectAtIndex:[sender tag]] valueForKey: kFundAPI_ID];
    }
    [self deactivateFund:fundID];
}

- (IBAction)deleteFund_ClickAction:(id)sender {
    if(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""])
        fundID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kFundAPI_ID];
    else
        fundID = [[fundsArray objectAtIndex:[sender tag]] valueForKey: kFundAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
        [self activateFund:fundID];
    else
        [self deleteFund:fundID];
}

- (IBAction)createFundButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Funds" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateFundIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeFund_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""])
        fundID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kFundAPI_ID];
    else
        fundID = [[fundsArray objectAtIndex:[sender tag]] valueForKey: kFundAPI_ID];
    
    [self likeFund:fundID];
}

- (IBAction)likeFundList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;

    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""])
        fundID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kFundAPI_ID];
    else
        fundID = [[fundsArray objectAtIndex:[sender tag]] valueForKey: kFundAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeFundList:fundID];
    }
}

- (IBAction)dislikeFund_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;

    if(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""])
        fundID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kFundAPI_ID];
    else
        fundID = [[fundsArray objectAtIndex:[sender tag]] valueForKey: kFundAPI_ID];
    
    [self dislikeFund:fundID];
}

- (IBAction)disLikeFundList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;

    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];

    if(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""])
        fundID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kFundAPI_ID];
    else
        fundID = [[fundsArray objectAtIndex:[sender tag]] valueForKey: kFundAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;

    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeFundList:fundID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kFundAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
    viewController.profileMode = [NSString stringWithFormat:@"%d",PROFILE_MODE_SEARCH] ;
    [UtilityClass setViewEntProfileMode:NO] ;
    [UtilityClass setUserType:CONTRACTOR] ;
    [UtilityClass setProfileMode:PROFILE_MODE_SEARCH] ;
    
    [UtilityClass setContractorDetails:[dict mutableCopy]] ;
    NSLog(@"getContractorDetails: %@",[UtilityClass getContractorDetails]) ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)ok_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tblViewPopUp) {
        return usersArray.count;
    } else {
        if (fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(fundsArray.count == totalItems)
                return fundsArray.count ;
            else
                return fundsArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserFund] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kFundAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kFundAPI_User_Desc]];

        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kFundAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;

        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""]) {
            FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Funds] ;
            
            cell.btnLikeCount.tag = indexPath.row;
            cell.btnDislikeCount.tag = indexPath.row;
            cell.btnLike.tag = indexPath.row;
            cell.btnDislike.tag = indexPath.row;
            cell.btnArchive.tag = indexPath.row;
            cell.btnDeactivate.tag = indexPath.row;
            cell.btnDelete.tag = indexPath.row;
            
            cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kFundAPI_Fund_Title]] ;
            cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kFundAPI_StarDate]];
            cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kFundAPI_Description]];
            
            [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kFundAPI_Funds_Likes]] forState:UIControlStateNormal];
            [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kFundAPI_Funds_Dislikes]] forState:UIControlStateNormal];
            
            NSString *imgStr = [[searchResults objectAtIndex:indexPath.row] valueForKey:kFundAPI_Fund_Image];

            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,imgStr]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            
            cell.imgView.layer.cornerRadius = 20;
            cell.imgView.clipsToBounds = YES;
            
            if (selectedSegmentControl == 100) { // Find Funds
                if (selectedSegment == FINDFUNDS_SELECTED) {
                    cell.btnArchive.hidden = true;
                    cell.btnDeactivate.hidden = true;
                    cell.btnDelete.hidden = true;
                } else {
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                }
            }
            else { // Fund/Invest
                if (selectedSegment == MYFUNDS_SELECTED) {
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                    [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                    cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                } else if (selectedSegment == DEACTIVATED_FUNDS_SELECTED) {
                    cell.btnArchive.hidden = true;
                    cell.btnDeactivate.hidden = true;
                    cell.btnDelete.hidden = false;
                    [cell.btnDelete setTitle:@"Activate" forState:UIControlStateNormal];
                    cell.btnDelete.backgroundColor = [UIColor colorWithRed:9.0/255.0 green:89.0/255.0 blue:0.0/255.0 alpha:1.0f];
                } else {
                    cell.btnArchive.hidden = true;
                    cell.btnDeactivate.hidden = true;
                    cell.btnDelete.hidden = true;
                }
            }
            
            return cell ;
        }
        else {
            if(indexPath.row == fundsArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Funds] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[fundsArray objectAtIndex:indexPath.row] valueForKey:kFundAPI_Fund_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[fundsArray objectAtIndex:indexPath.row] valueForKey:kFundAPI_StarDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[fundsArray objectAtIndex:indexPath.row] valueForKey:kFundAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[fundsArray objectAtIndex:indexPath.row] valueForKey:kFundAPI_Funds_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[fundsArray objectAtIndex:indexPath.row] valueForKey:kFundAPI_Funds_Dislikes]] forState:UIControlStateNormal];
                
                NSString *imgStr = [[fundsArray objectAtIndex:indexPath.row] valueForKey:kFundAPI_Fund_Image];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,imgStr]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Funds
                    if (selectedSegment == FINDFUNDS_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Fund/Invest
                    if (selectedSegment == MYFUNDS_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_FUNDS_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Activate" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:9.0/255.0 green:89.0/255.0 blue:0.0/255.0 alpha:1.0f];
                    } else {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    }
                }
                
                return cell ;
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblViewPopUp) {
        return 60;
    } else {
        if (fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find Funds
                if (selectedSegment == FINDFUNDS_SELECTED)
                    return 110;
                else if (selectedSegment == FUND_INVEST_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MYFUNDS_SELECTED || selectedSegment == DEACTIVATED_FUNDS_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // Fund/Invest
                if (selectedSegment == MYFUNDS_SELECTED || selectedSegment == DEACTIVATED_FUNDS_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == fundsArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find Funds
                    if (selectedSegment == FINDFUNDS_SELECTED)
                        return 120;
                    else if (selectedSegment == FUND_INVEST_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MYFUNDS_SELECTED || selectedSegment == DEACTIVATED_FUNDS_SELECTED)
                            return 145;
                        else
                            return 120 ;
                    }
                }
                else { // Fund/Invest
                    if (selectedSegment == MYFUNDS_SELECTED || selectedSegment == DEACTIVATED_FUNDS_SELECTED)
                        return 145;
                    else
                        return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == fundsArray.count) {
//            [UtilityClass hideHud] ;
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblView) {
        NSMutableArray *array ;
        if (fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""])
            array = [searchResults mutableCopy] ;
        else
            array = [fundsArray mutableCopy] ;
        
        if(indexPath.row != array.count) {
            
            [UtilityClass setFundsDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Funds" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditFundIdentifier] ;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
            
            [self.navigationController pushViewController:viewController animated:YES] ;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetFundViewEditing object:nil userInfo:dict];
        }
    }
}

#pragma mark - Api Methods
-(void)getFindFundsWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFundAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kFundAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kFundAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getFindFundsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kFundAPI_FundList]) {
                    totalItems = [[responseDict valueForKey:kFundAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [fundsArray removeAllObjects];

                    if(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""]) {
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFundAPI_FundList]] ;
                    }
                    else {
                        [fundsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kFundAPI_FundList]] ;
                    }
                    lblNoFundsAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kFundAPI_FundList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoFundsAvailable.hidden = false;
                if(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFundAPI_FundList]] ;
                }
                else {
                    fundsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFundAPI_FundList]] ;
                }
                totalItems = 0;
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = fundsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyFundsListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFundAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kFundAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kFundAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyFundsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kFundAPI_FundList]) {
                    totalItems = [[responseDict valueForKey:kFundAPI_TotalItems] integerValue] ;

                    [searchResults removeAllObjects];
                    [fundsArray removeAllObjects];
                    
                    if(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFundAPI_FundList]] ;
                    }
                    else {
                        [fundsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kFundAPI_FundList]] ;
                    }
                    lblNoFundsAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kFundAPI_FundList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoFundsAvailable.hidden = false;
                if(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""]) {
                }
                else {
                    fundsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFundAPI_FundList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = fundsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveFundsList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFundAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kFundAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kFundAPI_SearchText] ;

        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveFundsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kFundAPI_FundList]) {
                    totalItems = [[responseDict valueForKey:kFundAPI_TotalItems] integerValue] ;

                    [searchResults removeAllObjects];
                    [fundsArray removeAllObjects];

                    if(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFundAPI_FundList]] ;
                    }
                    else {
                        [fundsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kFundAPI_FundList]] ;
                    }
                    lblNoFundsAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kFundAPI_FundList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoFundsAvailable.hidden = false;
                if(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""]) {
                    
                }
                else {
                    fundsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFundAPI_FundList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = fundsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedFundsList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFundAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kFundAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kFundAPI_SearchText] ;

        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedFundsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kFundAPI_FundList]) {
                    totalItems = [[responseDict valueForKey:kFundAPI_TotalItems] integerValue] ;

                    [searchResults removeAllObjects];
                    [fundsArray removeAllObjects];

                    if(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFundAPI_FundList]] ;
                    }
                    else {
                        [fundsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kFundAPI_FundList]] ;
                    }
                    lblNoFundsAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kFundAPI_FundList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoFundsAvailable.hidden = false;
                if(fundSearchController.active && ![fundSearchController.searchBar.text isEqualToString:@""]) {
                    
                }
                else {
                    fundsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFundAPI_FundList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = fundsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveFund:(NSString *)fundId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFundAPI_UserID] ;
        [dictParam setObject:fundId forKey:kFundAPI_FundID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveFundWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveFund_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyFundsListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateFund:(NSString *)fundId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFundAPI_UserID] ;
        [dictParam setObject:fundId forKey:kFundAPI_FundID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateFundWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedFundsList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateFund_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateFund:(NSString *)fundId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFundAPI_UserID] ;
        [dictParam setObject:fundId forKey:kFundAPI_FundID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateFundWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateFund_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyFundsListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteFund:(NSString *)fundId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFundAPI_UserID] ;
        [dictParam setObject:fundId forKey:kFundAPI_FundID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteFundWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteFund_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyFundsListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeFund:(NSString *)fundId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFundAPI_Fund_LikedBy] ;
        [dictParam setObject:fundId forKey:kFundAPI_FundID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeFundWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kFundAPI_Funds_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kFundAPI_Funds_Dislikes]];

                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
                FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
                [cell.btnLikeCount setTitle:likeCount forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:dislikeCount forState:UIControlStateNormal];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)dislikeFund:(NSString *)fundId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFundAPI_Fund_DislikedBy] ;
        [dictParam setObject:fundId forKey:kFundAPI_FundID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeFundWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kFundAPI_Funds_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kFundAPI_Funds_Dislikes]];

                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
                FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
                [cell.btnLikeCount setTitle:likeCount forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:dislikeCount forState:UIControlStateNormal];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getLikeFundList:(NSString *)fundId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:fundId forKey:kFundAPI_FundID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kFundAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeFundListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kFundAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kFundAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kFundAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kFundAPI_UserList]] ;
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode )
            {
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            totalItems = usersArray.count;
            [tblViewPopUp reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getdisLikeFundList:(NSString *)fundId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:fundId forKey:kFundAPI_FundID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kFundAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeFundListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kFundAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kFundAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];

                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kFundAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];

                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kFundAPI_UserList]] ;
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            {
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            totalItems = usersArray.count;
            [tblViewPopUp reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}
@end
