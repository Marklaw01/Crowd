//
//  MyFocusGroupsViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyFocusGroupsViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyFocusGroupsViewController ()

@end

@implementation MyFocusGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_FocusGroup_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_FocusGroup_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find FocusGroup
    //        if (selectedSegment == SEARCH_SOFTWARE_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find FocusGroup
            if (selectedSegment == SEARCH_FOCUS_GROUP_SELECTED) {
                [self getFindFocusGroupWithSearchText:searchedString];
            } else
                [self getMyFocusGroupListWithSearchText:searchedString];
        } else {// My FocusGroup
            if (selectedSegment == MY_FOCUS_GROUP_SELECTED) {
                [self getMyFocusGroupListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_FOCUS_GROUP_SELECTED) {
                [self getArchiveFocusGroupList:searchedString];
            } else {
                [self getDeactivatedFocusGroupList:searchedString];
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
    [self.segmentControlMyFocusGroups setTitleTextAttributes:attributes
                                              forState:UIControlStateNormal];
    [self.segmentControlSearchFocusGroups setTitleTextAttributes:attributes
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
    
    focusGroupsArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyFocusGroups.hidden = true;
    addFocusGroupBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchFocusGroups setSelectedSegmentIndex:SEARCH_FOCUS_GROUP_SELECTED] ;
    [self.segmentControlMyFocusGroups setSelectedSegmentIndex:MY_FOCUS_GROUP_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get My FocusGroup List
    [self getFindFocusGroupWithSearchText:searchedString];
}

-(void)configureSearchController {
    focusGroupSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    focusGroupSearchController.searchBar.placeholder = kSearchFocusGroupPlaceholder ;
    [focusGroupSearchController.searchBar sizeToFit] ;
    focusGroupSearchController.searchBar.text = searchedString;
    focusGroupSearchController.searchResultsUpdater = self ;
    focusGroupSearchController.dimsBackgroundDuringPresentation = NO ;
    focusGroupSearchController.definesPresentationContext = YES ;
    focusGroupSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = focusGroupSearchController.searchBar ;
    focusGroupSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
    return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [focusGroupsArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find FocusGroup
        if (selectedSegment == SEARCH_FOCUS_GROUP_SELECTED)
        [self getFindFocusGroupWithSearchText:searchedString] ; // Find FocusGroup
        else
        [self getMyFocusGroupListWithSearchText:searchedString] ; // My FocusGroup
    }
    else { // FocusGroup/Invest
        if (selectedSegment == MY_FOCUS_GROUP_SELECTED)
        [self getMyFocusGroupListWithSearchText:searchedString] ; // My FocusGroup
        else if (selectedSegment == ARCHIVE_FOCUS_GROUP_SELECTED)
        [self getArchiveFocusGroupList:searchedString] ; // Archived FocusGroup
        else
        [self getDeactivatedFocusGroupList:searchedString] ; // Deactivated FocusGroup
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [focusGroupsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [focusGroupSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find FocusGroup
        if (selectedSegment == SEARCH_FOCUS_GROUP_SELECTED)
        [self getFindFocusGroupWithSearchText:searchedString] ; // Find FocusGroup
        else
        [self getMyFocusGroupListWithSearchText:searchedString] ; // My FocusGroup
    }
    else { // FocusGroup/Invest
        if (selectedSegment == MY_FOCUS_GROUP_SELECTED)
        [self getMyFocusGroupListWithSearchText:searchedString] ; // My FocusGroup
        else if (selectedSegment == ARCHIVE_FOCUS_GROUP_SELECTED)
        [self getArchiveFocusGroupList:searchedString] ; // Archived FocusGroup
        else
        [self getDeactivatedFocusGroupList:searchedString] ; // Deactivated FocusGroup
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [focusGroupsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find FocusGroup
        selectedSegment = self.segmentControlSearchFocusGroups.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_FOCUS_GROUP_SELECTED) { //0
            [self getFindFocusGroupWithSearchText:searchedString] ; // Find FocusGroup
            self.segmentControlMyFocusGroups.hidden = true;
            addFocusGroupBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyFocusGroupListWithSearchText:searchedString] ; // My FocusGroup
            [self.segmentControlMyFocusGroups setSelectedSegmentIndex:MY_FOCUS_GROUP_SELECTED] ;
            self.segmentControlMyFocusGroups.hidden = false;
            addFocusGroupBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // FocusGroup/Invest
        selectedSegment = self.segmentControlMyFocusGroups.selectedSegmentIndex;
        self.segmentControlMyFocusGroups.hidden = false;
        addFocusGroupBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_FOCUS_GROUP_SELECTED) { //0
            [self getMyFocusGroupListWithSearchText:searchedString] ; // My FocusGroup
            addFocusGroupBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_FOCUS_GROUP_SELECTED) { //1
            addFocusGroupBtn.hidden = true;
            [self getArchiveFocusGroupList:searchedString ] ; // Archived FocusGroup
        }
        else { //2
            [self getDeactivatedFocusGroupList:searchedString] ; // Deactivated FocusGroup
            addFocusGroupBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveFocusGroup_ClickAction:(id)sender {
    
    if(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""]) {
        focusGroupID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kFocusGroupAPI_ID];
    }
    else {
        focusGroupID = [[focusGroupsArray objectAtIndex:[sender tag]] valueForKey: kFocusGroupAPI_ID];
    }
    [self archiveFocusGroup:focusGroupID];
}

- (IBAction)deactivateFocusGroup_ClickAction:(id)sender {
    if(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""]) {
        focusGroupID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kFocusGroupAPI_ID];
    }
    else {
        focusGroupID = [[focusGroupsArray objectAtIndex:[sender tag]] valueForKey: kFocusGroupAPI_ID];
    }
    [self deactivateFocusGroup:focusGroupID];
}

- (IBAction)deleteFocusGroup_ClickAction:(id)sender {
    if(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""])
    focusGroupID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kFocusGroupAPI_ID];
    else
    focusGroupID = [[focusGroupsArray objectAtIndex:[sender tag]] valueForKey: kFocusGroupAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
    [self activateFocusGroup:focusGroupID];
    else
    [self deleteFocusGroup:focusGroupID];
}

- (IBAction)createFocusGroupButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FocusGroups" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateFocusGroupIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeFocusGroup_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""])
    focusGroupID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kFocusGroupAPI_ID];
    else
    focusGroupID = [[focusGroupsArray objectAtIndex:[sender tag]] valueForKey: kFocusGroupAPI_ID];
    
    [self likeFocusGroup:focusGroupID];
}

- (IBAction)likeFocusGroupList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""])
    focusGroupID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kFocusGroupAPI_ID];
    else
    focusGroupID = [[focusGroupsArray objectAtIndex:[sender tag]] valueForKey: kFocusGroupAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeFocusGroupList:focusGroupID];
    }
}

- (IBAction)dislikeFocusGroup_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""])
    focusGroupID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kFocusGroupAPI_ID];
    else
    focusGroupID = [[focusGroupsArray objectAtIndex:[sender tag]] valueForKey: kFocusGroupAPI_ID];
    
    [self dislikeFocusGroup:focusGroupID];
}

- (IBAction)disLikeFocusGroupList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""])
    focusGroupID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kFocusGroupAPI_ID];
    else
    focusGroupID = [[focusGroupsArray objectAtIndex:[sender tag]] valueForKey: kFocusGroupAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeFocusGroupList:focusGroupID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kFocusGroupAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(focusGroupsArray.count == totalItems)
                return focusGroupsArray.count ;
            else
                return focusGroupsArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kFocusGroupAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kFocusGroupAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kFocusGroupAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""]) {
            FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_FocusGroups] ;
            
            cell.btnLikeCount.tag = indexPath.row;
            cell.btnDislikeCount.tag = indexPath.row;
            cell.btnLike.tag = indexPath.row;
            cell.btnDislike.tag = indexPath.row;
            cell.btnArchive.tag = indexPath.row;
            cell.btnDeactivate.tag = indexPath.row;
            cell.btnDelete.tag = indexPath.row;
            
            cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kFocusGroupAPI_FocusGroup_Title]] ;
            cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kFocusGroupAPI_StartDate]];
            cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kFocusGroupAPI_Description]];
            
            [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kFocusGroupAPI_FocusGroup_Likes]] forState:UIControlStateNormal];
            [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kFocusGroupAPI_FocusGroup_Dislikes]] forState:UIControlStateNormal];
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kFocusGroupAPI_FocusGroup_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            
            cell.imgView.layer.cornerRadius = 20;
            cell.imgView.clipsToBounds = YES;
            
            if (selectedSegmentControl == 100) { // Find FocusGroup
                if (selectedSegment == SEARCH_FOCUS_GROUP_SELECTED) {
                    cell.btnArchive.hidden = true;
                    cell.btnDeactivate.hidden = true;
                    cell.btnDelete.hidden = true;
                } else {
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                }
            }
            else { // FocusGroup/Invest
                if (selectedSegment == MY_FOCUS_GROUP_SELECTED) {
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                    [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                    cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                } else if (selectedSegment == DEACTIVATED_FOCUS_GROUP_SELECTED) {
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
            if(indexPath.row == focusGroupsArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_FocusGroups] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[focusGroupsArray objectAtIndex:indexPath.row] valueForKey:kFocusGroupAPI_FocusGroup_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[focusGroupsArray objectAtIndex:indexPath.row] valueForKey:kFocusGroupAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[focusGroupsArray objectAtIndex:indexPath.row] valueForKey:kFocusGroupAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[focusGroupsArray objectAtIndex:indexPath.row] valueForKey:kFocusGroupAPI_FocusGroup_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[focusGroupsArray objectAtIndex:indexPath.row] valueForKey:kFocusGroupAPI_FocusGroup_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[focusGroupsArray objectAtIndex:indexPath.row] valueForKey:kFocusGroupAPI_FocusGroup_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find FocusGroup
                    if (selectedSegment == SEARCH_FOCUS_GROUP_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // FocusGroup/Invest
                    if (selectedSegment == MY_FOCUS_GROUP_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_FOCUS_GROUP_SELECTED) {
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
        if (focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find FocusGroup
                if (selectedSegment == SEARCH_FOCUS_GROUP_SELECTED)
                return 110;
                else if (selectedSegment == ADD_FOCUS_GROUP_SELECTED)
                return 145;
                else {
                    if (selectedSegment == MY_FOCUS_GROUP_SELECTED || selectedSegment == DEACTIVATED_FOCUS_GROUP_SELECTED)
                    return 145;
                    else
                    return 110 ;
                }
            }
            else { // FocusGroup/Invest
                if (selectedSegment == MY_FOCUS_GROUP_SELECTED || selectedSegment == DEACTIVATED_FOCUS_GROUP_SELECTED)
                return 145;
                else
                return 110 ;
            }
        }
        else {
            if(indexPath.row == focusGroupsArray.count)
            return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find FocusGroup
                    if (selectedSegment == SEARCH_FOCUS_GROUP_SELECTED)
                    return 120;
                    else if (selectedSegment == ADD_FOCUS_GROUP_SELECTED)
                    return 145;
                    else {
                        if (selectedSegment == MY_FOCUS_GROUP_SELECTED || selectedSegment == DEACTIVATED_FOCUS_GROUP_SELECTED)
                        return 145;
                        else
                        return 120 ;
                    }
                }
                else { // FocusGroup/Invest
                    if (selectedSegment == MY_FOCUS_GROUP_SELECTED || selectedSegment == DEACTIVATED_FOCUS_GROUP_SELECTED)
                    return 145;
                    else
                    return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == focusGroupsArray.count) {
//            [self getMyFocusGroupListWithSearchText:searchedString] ; // My FocusGroup
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblView) {
        NSMutableArray *array ;
        if (focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""])
            array = [searchResults mutableCopy] ;
        else
            array = [focusGroupsArray mutableCopy] ;
        
        if(indexPath.row != array.count) {
            
            [UtilityClass setFocusGroupDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FocusGroups" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditFocusGroupIdentifier] ;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
            
            [self.navigationController pushViewController:viewController animated:YES] ;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetFocusGroupViewEditing object:nil userInfo:dict];
        }
    }
    
}

#pragma mark - Api Methods
-(void)getFindFocusGroupWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFocusGroupAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kFocusGroupAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kFocusGroupAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchFocusGroupsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kFocusGroupAPI_FocusGroupList]) {
                    totalItems = [[responseDict valueForKey:kFocusGroupAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [focusGroupsArray removeAllObjects];
                    
                    if(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                    }
                    else {
                        [focusGroupsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                    }
                    lblNoFocusGroupAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;

                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoFocusGroupAvailable.hidden = false;
                if(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                }
                else {
                    focusGroupsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = focusGroupsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyFocusGroupListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFocusGroupAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kFocusGroupAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kFocusGroupAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyFocusGroupsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kFocusGroupAPI_FocusGroupList]) {
                    totalItems = [[responseDict valueForKey:kFocusGroupAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [focusGroupsArray removeAllObjects];
                    
                    if(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                    }
                    else {
                        [focusGroupsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                    }
                    lblNoFocusGroupAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoFocusGroupAvailable.hidden = false;
                if(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""]){
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                }
                else {
                    focusGroupsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = focusGroupsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveFocusGroupList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFocusGroupAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kFocusGroupAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kFocusGroupAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveFocusGroupsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kFocusGroupAPI_FocusGroupList]) {
                    totalItems = [[responseDict valueForKey:kFocusGroupAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [focusGroupsArray removeAllObjects];
                    
                    if(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                    }
                    else {
                        [focusGroupsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                    }
                    lblNoFocusGroupAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoFocusGroupAvailable.hidden = false;
                if(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""]){
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                }
                else {
                    focusGroupsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = focusGroupsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedFocusGroupList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFocusGroupAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kFocusGroupAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kFocusGroupAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedFocusGroupsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kFocusGroupAPI_FocusGroupList]) {
                    totalItems = [[responseDict valueForKey:kFocusGroupAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [focusGroupsArray removeAllObjects];
                    
                    if(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                    }
                    else {
                        [focusGroupsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                    }
                    lblNoFocusGroupAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoFocusGroupAvailable.hidden = false;
                if(focusGroupSearchController.active && ![focusGroupSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                }
                else {
                    focusGroupsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kFocusGroupAPI_FocusGroupList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = focusGroupsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveFocusGroup:(NSString *)focusGroupId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFocusGroupAPI_UserID] ;
        [dictParam setObject:focusGroupId forKey:kFocusGroupAPI_FocusGroupID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveFocusGroupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveFocusGroup_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyFocusGroupListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateFocusGroup:(NSString *)focusGroupId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFocusGroupAPI_UserID] ;
        [dictParam setObject:focusGroupId forKey:kFocusGroupAPI_FocusGroupID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateFocusGroupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedFocusGroupList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateFocusGroup_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateFocusGroup:(NSString *)focusGroupId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFocusGroupAPI_UserID] ;
        [dictParam setObject:focusGroupId forKey:kFocusGroupAPI_FocusGroupID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateFocusGroupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateFocusGroup_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyFocusGroupListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteFocusGroup:(NSString *)focusGroupId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFocusGroupAPI_UserID] ;
        [dictParam setObject:focusGroupId forKey:kFocusGroupAPI_FocusGroupID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteFocusGroupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteFocusGroup_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyFocusGroupListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeFocusGroup:(NSString *)focusGroupId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFocusGroupAPI_FocusGroup_LikedBy] ;
        [dictParam setObject:focusGroupId forKey:kFocusGroupAPI_FocusGroupID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeFocusGroupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kFocusGroupAPI_FocusGroup_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kFocusGroupAPI_FocusGroup_Dislikes]];
                
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

-(void)dislikeFocusGroup:(NSString *)focusGroupId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFocusGroupAPI_FocusGroup_DislikedBy] ;
        [dictParam setObject:focusGroupId forKey:kFocusGroupAPI_FocusGroupID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeFocusGroupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kFocusGroupAPI_FocusGroup_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kFocusGroupAPI_FocusGroup_Dislikes]];
                
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

-(void)getLikeFocusGroupList:(NSString *)focusGroupId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:focusGroupId forKey:kFocusGroupAPI_FocusGroupID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kFocusGroupAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeFocusGroupListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kFocusGroupAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kFocusGroupAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kFocusGroupAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kFocusGroupAPI_UserList]] ;
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

-(void)getdisLikeFocusGroupList:(NSString *)focusGroupId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:focusGroupId forKey:kFocusGroupAPI_FocusGroupID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kFocusGroupAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeFocusGroupListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kFocusGroupAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kFocusGroupAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kFocusGroupAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kFocusGroupAPI_UserList]] ;
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
