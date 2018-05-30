//
//  MyBetaTestsViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyBetaTestsViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyBetaTestsViewController ()

@end

@implementation MyBetaTestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_BetaTester_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_BetaTester_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find Beta Test
    //        if (selectedSegment == SEARCH_BETA_TEST_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find Beta Test
            if (selectedSegment == SEARCH_BETA_TEST_SELECTED) {
                [self getFindBetaTestWithSearchText:searchedString];
            } else
                [self getMyBetaTestListWithSearchText:searchedString];
        } else {// My Beta Test
            if (selectedSegment == MY_BETA_TEST_SELECTED) {
                [self getMyBetaTestListWithSearchText:searchedString];
            } else if (selectedSegment == ARCHIVE_BETA_TEST_SELECTED) {
                [self getArchiveBetaTestList:searchedString];
            } else {
                [self getDeactivatedBetaTestList:searchedString];
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
    [self.segmentControlMyBetaTests setTitleTextAttributes:attributes
                                              forState:UIControlStateNormal];
    [self.segmentControlSearchBetaTests setTitleTextAttributes:attributes
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
    
    betaTestsArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyBetaTests.hidden = true;
    addBetaTestBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchBetaTests setSelectedSegmentIndex:SEARCH_BETA_TEST_SELECTED] ;
    [self.segmentControlMyBetaTests setSelectedSegmentIndex:MY_BETA_TEST_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get BetaTest List
    [self getFindBetaTestWithSearchText:searchedString];
}

-(void)configureSearchController {
    betaTestSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    betaTestSearchController.searchBar.placeholder = kSearchBetaTestPlaceholder ;
    [betaTestSearchController.searchBar sizeToFit] ;
    betaTestSearchController.searchBar.text = searchedString;
    betaTestSearchController.searchResultsUpdater = self ;
    betaTestSearchController.dimsBackgroundDuringPresentation = NO ;
    betaTestSearchController.definesPresentationContext = YES ;
    betaTestSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = betaTestSearchController.searchBar ;
    betaTestSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
    return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [betaTestsArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find BetaTest
        if (selectedSegment == SEARCH_BETA_TEST_SELECTED)
        [self getFindBetaTestWithSearchText:searchedString] ; // Find BetaTest
        else
        [self getMyBetaTestListWithSearchText:searchedString] ; // My BetaTest
    }
    else { // BetaTest/Invest
        if (selectedSegment == MY_BETA_TEST_SELECTED)
        [self getMyBetaTestListWithSearchText:searchedString] ; // My BetaTest
        else if (selectedSegment == ARCHIVE_BETA_TEST_SELECTED)
        [self getArchiveBetaTestList:searchedString] ; // Archived BetaTest
        else
        [self getDeactivatedBetaTestList:searchedString] ; // Deactivated BetaTest
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [betaTestsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [betaTestSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find BetaTest
        if (selectedSegment == SEARCH_BETA_TEST_SELECTED)
        [self getFindBetaTestWithSearchText:searchedString] ; // Find BetaTest
        else
        [self getMyBetaTestListWithSearchText:searchedString] ; // My BetaTest
    }
    else { // BetaTest/Invest
        if (selectedSegment == MY_BETA_TEST_SELECTED)
        [self getMyBetaTestListWithSearchText:searchedString] ; // My BetaTest
        else if (selectedSegment == ARCHIVE_BETA_TEST_SELECTED)
        [self getArchiveBetaTestList:searchedString] ; // Archived BetaTest
        else
        [self getDeactivatedBetaTestList:searchedString] ; // Deactivated BetaTest
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [betaTestsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find BetaTest
        selectedSegment = self.segmentControlSearchBetaTests.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_BETA_TEST_SELECTED) { //0
            [self getFindBetaTestWithSearchText:searchedString] ; // Find BetaTest
            self.segmentControlMyBetaTests.hidden = true;
            addBetaTestBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyBetaTestListWithSearchText:searchedString] ; // My BetaTest
            [self.segmentControlMyBetaTests setSelectedSegmentIndex:MY_BETA_TEST_SELECTED] ;
            self.segmentControlMyBetaTests.hidden = false;
            addBetaTestBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // BetaTest/Invest
        selectedSegment = self.segmentControlMyBetaTests.selectedSegmentIndex;
        self.segmentControlMyBetaTests.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_BETA_TEST_SELECTED) { //0
            [self getMyBetaTestListWithSearchText:searchedString] ; // My BetaTest
            addBetaTestBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_BETA_TEST_SELECTED) { //1
            addBetaTestBtn.hidden = true;
            [self getArchiveBetaTestList:searchedString ] ; // Archived BetaTest
        }
        else { //2
            [self getDeactivatedBetaTestList:searchedString] ; // Deactivated BetaTest
            addBetaTestBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveBetaTest_ClickAction:(id)sender {
    
    if(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""]) {
        betaTestID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kBetaTestAPI_ID];
    }
    else {
        betaTestID = [[betaTestsArray objectAtIndex:[sender tag]] valueForKey: kBetaTestAPI_ID];
    }
    [self archiveBetaTest:betaTestID];
}

- (IBAction)deactivateBetaTest_ClickAction:(id)sender {
    if(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""]) {
        betaTestID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kBetaTestAPI_ID];
    }
    else {
        betaTestID = [[betaTestsArray objectAtIndex:[sender tag]] valueForKey: kBetaTestAPI_ID];
    }
    [self deactivateBetaTest:betaTestID];
}

- (IBAction)deleteBetaTest_ClickAction:(id)sender {
    if(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""])
    betaTestID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kBetaTestAPI_ID];
    else
    betaTestID = [[betaTestsArray objectAtIndex:[sender tag]] valueForKey: kBetaTestAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
    [self activateBetaTest:betaTestID];
    else
    [self deleteBetaTest:betaTestID];
}

- (IBAction)createBetaTestButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BetaTesting" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateBetaTestIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeBetaTest_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""])
        betaTestID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kBetaTestAPI_ID];
    else
        betaTestID = [[betaTestsArray objectAtIndex:[sender tag]] valueForKey: kBetaTestAPI_ID];
    
    [self likeBetaTest:betaTestID];
}

- (IBAction)likeBetaTestList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    
    if(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""])
        betaTestID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kBetaTestAPI_ID];
    else
        betaTestID = [[betaTestsArray objectAtIndex:[sender tag]] valueForKey: kBetaTestAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeBetaTestList:betaTestID];
    }
}

- (IBAction)dislikeBetaTest_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""])
    betaTestID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kBetaTestAPI_ID];
    else
    betaTestID = [[betaTestsArray objectAtIndex:[sender tag]] valueForKey: kBetaTestAPI_ID];
    
    [self dislikeBetaTest:betaTestID];
}

- (IBAction)disLikeBetaTestList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""])
    betaTestID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kBetaTestAPI_ID];
    else
    betaTestID = [[betaTestsArray objectAtIndex:[sender tag]] valueForKey: kBetaTestAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeBetaTestList:betaTestID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kBetaTestAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(betaTestsArray.count == totalItems)
                return betaTestsArray.count ;
            else
                return betaTestsArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kBetaTestAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kBetaTestAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kBetaTestAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        
        if (betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""]) {
            FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_BetaTests] ;
            
            cell.btnLikeCount.tag = indexPath.row;
            cell.btnDislikeCount.tag = indexPath.row;
            cell.btnLike.tag = indexPath.row;
            cell.btnDislike.tag = indexPath.row;
            cell.btnArchive.tag = indexPath.row;
            cell.btnDeactivate.tag = indexPath.row;
            cell.btnDelete.tag = indexPath.row;
            
            cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kBetaTestAPI_BetaTest_Title]] ;
            cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kBetaTestAPI_StartDate]];
            cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kBetaTestAPI_Description]];
            
            [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kBetaTestAPI_BetaTest_Likes]] forState:UIControlStateNormal];
            [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kBetaTestAPI_BetaTest_Dislikes]] forState:UIControlStateNormal];
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kBetaTestAPI_BetaTest_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            
            cell.imgView.layer.cornerRadius = 20;
            cell.imgView.clipsToBounds = YES;
            
            if (selectedSegmentControl == 100) { // Find Beta Test
                if (selectedSegment == SEARCH_BETA_TEST_SELECTED) {
                    cell.btnArchive.hidden = true;
                    cell.btnDeactivate.hidden = true;
                    cell.btnDelete.hidden = true;
                } else {
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                }
            }
            else { // My Beta Test
                if (selectedSegment == MY_BETA_TEST_SELECTED) {
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                    [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                    cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                } else if (selectedSegment == DEACTIVATED_BETA_TEST_SELECTED) {
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
        } else {
            if(indexPath.row == betaTestsArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_BetaTests] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[betaTestsArray objectAtIndex:indexPath.row] valueForKey:kBetaTestAPI_BetaTest_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[betaTestsArray objectAtIndex:indexPath.row] valueForKey:kBetaTestAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[betaTestsArray objectAtIndex:indexPath.row] valueForKey:kBetaTestAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[betaTestsArray objectAtIndex:indexPath.row] valueForKey:kBetaTestAPI_BetaTest_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[betaTestsArray objectAtIndex:indexPath.row] valueForKey:kBetaTestAPI_BetaTest_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[betaTestsArray objectAtIndex:indexPath.row] valueForKey:kBetaTestAPI_BetaTest_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Beta Test
                    if (selectedSegment == SEARCH_BETA_TEST_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // My Beta Test
                    if (selectedSegment == MY_BETA_TEST_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_BETA_TEST_SELECTED) {
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
        if (betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find BetaTest
                if (selectedSegment == SEARCH_BETA_TEST_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_BETA_TEST_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_BETA_TEST_SELECTED || selectedSegment == DEACTIVATED_BETA_TEST_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // My BetaTest
                if (selectedSegment == MY_BETA_TEST_SELECTED || selectedSegment == DEACTIVATED_BETA_TEST_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == betaTestsArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find BetaTest
                    if (selectedSegment == SEARCH_BETA_TEST_SELECTED)
                        return 120;
                    else if (selectedSegment == ADD_BETA_TEST_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_BETA_TEST_SELECTED || selectedSegment == DEACTIVATED_BETA_TEST_SELECTED)
                            return 145;
                        else
                            return 120 ;
                    }
                }
                else { // BetaTest/Invest
                    if (selectedSegment == MY_BETA_TEST_SELECTED || selectedSegment == DEACTIVATED_BETA_TEST_SELECTED)
                        return 145;
                    else
                        return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == betaTestsArray.count) {
//            [UtilityClass hideHud];
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblView) {
        NSMutableArray *array ;
        if (betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""])
            array = [searchResults mutableCopy] ;
        else
            array = [betaTestsArray mutableCopy] ;
        
        if(indexPath.row != array.count) {
            
            [UtilityClass setBetaTestDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BetaTesting" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditBetaTestIdentifier] ;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
            
            [self.navigationController pushViewController:viewController animated:YES] ;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetBetaTestViewEditing object:nil userInfo:dict];
        }
    }
}

#pragma mark - Api Methods
-(void)getFindBetaTestWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBetaTestAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kBetaTestAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kBetaTestAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchBetaTestsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kBetaTestAPI_FindBetaTestList]) {
                    totalItems = [[responseDict valueForKey:kBetaTestAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [betaTestsArray removeAllObjects];
                    
                    if(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBetaTestAPI_FindBetaTestList]] ;
                    }
                    else {
                        [betaTestsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBetaTestAPI_FindBetaTestList]] ;
                    }
                    lblNoBetaTestAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kBetaTestAPI_FindBetaTestList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode) {
                lblNoBetaTestAvailable.hidden = false;
                if(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBetaTestAPI_FindBetaTestList]] ;
                }
                else {
                    betaTestsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBetaTestAPI_FindBetaTestList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = betaTestsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyBetaTestListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBetaTestAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kBetaTestAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kBetaTestAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyBetaTestsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kBetaTestAPI_BetaTestList]) {
                    totalItems = [[responseDict valueForKey:kBetaTestAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [betaTestsArray removeAllObjects];
                    
                    if(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBetaTestAPI_BetaTestList]] ;
                    }
                    else {
                        [betaTestsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBetaTestAPI_BetaTestList]] ;
                    }
                    lblNoBetaTestAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kBetaTestAPI_BetaTestList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode) {
                lblNoBetaTestAvailable.hidden = false;
                if(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBetaTestAPI_FindBetaTestList]] ;
                }
                else {
                    betaTestsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBetaTestAPI_BetaTestList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = betaTestsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveBetaTestList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBetaTestAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kBetaTestAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kBetaTestAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveBetaTestsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kBetaTestAPI_BetaTestList]) {
                    totalItems = [[responseDict valueForKey:kBetaTestAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [betaTestsArray removeAllObjects];
                    
                    if(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBetaTestAPI_BetaTestList]] ;
                    }
                    else {
                        [betaTestsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBetaTestAPI_BetaTestList]] ;
                    }
                    lblNoBetaTestAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kBetaTestAPI_BetaTestList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode) {
                lblNoBetaTestAvailable.hidden = false;
                if(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBetaTestAPI_FindBetaTestList]] ;
                }
                else {
                    betaTestsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBetaTestAPI_BetaTestList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = betaTestsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedBetaTestList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBetaTestAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kBetaTestAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kBetaTestAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedBetaTestsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kBetaTestAPI_BetaTestList]) {
                    totalItems = [[responseDict valueForKey:kBetaTestAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [betaTestsArray removeAllObjects];
                    
                    if(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBetaTestAPI_BetaTestList]] ;
                    }
                    else {
                        [betaTestsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBetaTestAPI_BetaTestList]] ;
                    }
                    lblNoBetaTestAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kBetaTestAPI_BetaTestList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode) {
                lblNoBetaTestAvailable.hidden = false;
                if(betaTestSearchController.active && ![betaTestSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBetaTestAPI_FindBetaTestList]] ;
                }
                else {
                    betaTestsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBetaTestAPI_BetaTestList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = betaTestsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveBetaTest:(NSString *)betaTestId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBetaTestAPI_UserID] ;
        [dictParam setObject:betaTestId forKey:kBetaTestAPI_BetaID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveBetaTestWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveBetaTest_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyBetaTestListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateBetaTest:(NSString *)betaTestId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBetaTestAPI_UserID] ;
        [dictParam setObject:betaTestId forKey:kBetaTestAPI_BetaID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateBetaTestWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                [UtilityClass showNotificationMessgae:kActivateBetaTest_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getDeactivatedBetaTestList:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateBetaTest:(NSString *)betaTestId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBetaTestAPI_UserID] ;
        [dictParam setObject:betaTestId forKey:kBetaTestAPI_BetaID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateBetaTestWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateBetaTest_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyBetaTestListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteBetaTest:(NSString *)betaTestId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBetaTestAPI_UserID] ;
        [dictParam setObject:betaTestId forKey:kBetaTestAPI_BetaID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteBetaTestWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteBetaTest_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyBetaTestListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeBetaTest:(NSString *)betaTestId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBetaTestAPI_BetaTest_LikedBy] ;
        [dictParam setObject:betaTestId forKey:kBetaTestAPI_BetaTestID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeBetaTestWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kBetaTestAPI_BetaTest_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kBetaTestAPI_BetaTest_Dislikes]];
                
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

-(void)dislikeBetaTest:(NSString *)betaTestId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBetaTestAPI_BetaTest_DislikedBy] ;
        [dictParam setObject:betaTestId forKey:kBetaTestAPI_BetaTestID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeBetaTestWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kBetaTestAPI_BetaTest_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kBetaTestAPI_BetaTest_Dislikes]];
                
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

-(void)getLikeBetaTestList:(NSString *)betaTestId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:betaTestId forKey:kBetaTestAPI_BetaTestID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kBetaTestAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeBetaTestListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kBetaTestAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kBetaTestAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBetaTestAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kBetaTestAPI_UserList]] ;
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

-(void)getdisLikeBetaTestList:(NSString *)betaTestId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:betaTestId forKey:kBetaTestAPI_BetaTestID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kBetaTestAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeBetaTestListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kBetaTestAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kBetaTestAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBetaTestAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kBetaTestAPI_UserList]] ;
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
