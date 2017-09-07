//
//  MyGroupsViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyGroupsViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyGroupsViewController ()

@end

@implementation MyGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_Group_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_Group_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find Group
    //        if (selectedSegment == SEARCH_GROUP_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find Group
            if (selectedSegment == SEARCH_GROUP_SELECTED) {
                [self getFindGroupWithSearchText:searchedString];
            } else
                [self getMyGroupListWithSearchText:searchedString];
        } else {// My Group
            if (selectedSegment == MY_GROUP_SELECTED) {
                [self getMyGroupListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_GROUP_SELECTED) {
                [self getArchiveGroupList:searchedString];
            } else {
                [self getDeactivatedGroupList:searchedString];
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
    [self.segmentControlMyGroup setTitleTextAttributes:attributes
                                                    forState:UIControlStateNormal];
    [self.segmentControlSearchGroup setTitleTextAttributes:attributes
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
    
    groupArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyGroup.hidden = true;
    addGroupBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchGroup setSelectedSegmentIndex:SEARCH_GROUP_SELECTED] ;
    [self.segmentControlMyGroup setSelectedSegmentIndex:MY_GROUP_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get My Group List
    [self getFindGroupWithSearchText:searchedString];
}

-(void)configureSearchController {
    groupSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    groupSearchController.searchBar.placeholder = kSearchGroupPlaceholder ;
    [groupSearchController.searchBar sizeToFit] ;
    groupSearchController.searchBar.text = searchedString;
    groupSearchController.searchResultsUpdater = self ;
    groupSearchController.dimsBackgroundDuringPresentation = NO ;
    groupSearchController.definesPresentationContext = YES ;
    groupSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = groupSearchController.searchBar ;
    groupSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [groupArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Group
        if (selectedSegment == SEARCH_GROUP_SELECTED)
            [self getFindGroupWithSearchText:searchedString] ; // Find Group
        else
            [self getMyGroupListWithSearchText:searchedString] ; // My Group
    }
    else { // Group
        if (selectedSegment == MY_GROUP_SELECTED)
            [self getMyGroupListWithSearchText:searchedString] ; // My Group
        else if (selectedSegment == ARCHIVE_GROUP_SELECTED)
            [self getArchiveGroupList:searchedString] ; // Archived Group
        else
            [self getDeactivatedGroupList:searchedString] ; // Deactivated Group
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [groupArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [groupSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Group
        if (selectedSegment == SEARCH_GROUP_SELECTED)
            [self getFindGroupWithSearchText:searchedString] ; // Find Group
        else
            [self getMyGroupListWithSearchText:searchedString] ; // My Group
    }
    else { // Group
        if (selectedSegment == MY_GROUP_SELECTED)
            [self getMyGroupListWithSearchText:searchedString] ; // My Group
        else if (selectedSegment == ARCHIVE_GROUP_SELECTED)
            [self getArchiveGroupList:searchedString] ; // Archived Group
        else
            [self getDeactivatedGroupList:searchedString] ; // Deactivated Group
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [groupArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find Group
        selectedSegment = self.segmentControlSearchGroup.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_GROUP_SELECTED) { //0
            [self getFindGroupWithSearchText:searchedString] ; // Find Group
            self.segmentControlMyGroup.hidden = true;
            addGroupBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyGroupListWithSearchText:searchedString] ; // My Group
            [self.segmentControlMyGroup setSelectedSegmentIndex:MY_GROUP_SELECTED] ;
            self.segmentControlMyGroup.hidden = false;
            addGroupBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // Group
        selectedSegment = self.segmentControlMyGroup.selectedSegmentIndex;
        self.segmentControlMyGroup.hidden = false;
        addGroupBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_GROUP_SELECTED) { //0
            [self getMyGroupListWithSearchText:searchedString] ; // My Group
            addGroupBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_GROUP_SELECTED) { //1
            addGroupBtn.hidden = true;
            [self getArchiveGroupList:searchedString ] ; // Archived Group
        }
        else { //2
            [self getDeactivatedGroupList:searchedString] ; // Deactivated Group
            addGroupBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveGroup_ClickAction:(id)sender {
    
    if(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""]) {
        groupID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kGroupAPI_ID];
    }
    else {
        groupID = [[groupArray objectAtIndex:[sender tag]] valueForKey: kGroupAPI_ID];
    }
    [self archiveGroup:groupID];
}

- (IBAction)deactivateGroup_ClickAction:(id)sender {
    if(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""]) {
        groupID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kGroupAPI_ID];
    }
    else {
        groupID = [[groupArray objectAtIndex:[sender tag]] valueForKey: kGroupAPI_ID];
    }
    [self deactivateGroup:groupID];
}

- (IBAction)deleteGroup_ClickAction:(id)sender {
    if(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""])
        groupID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kGroupAPI_ID];
    else
        groupID = [[groupArray objectAtIndex:[sender tag]] valueForKey: kGroupAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
        [self activateGroup:groupID];
    else
        [self deleteGroup:groupID];
}

- (IBAction)createGroupButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateGroupIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeGroup_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""])
        groupID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kGroupAPI_ID];
    else
        groupID = [[groupArray objectAtIndex:[sender tag]] valueForKey: kGroupAPI_ID];
    
    [self likeGroup:groupID];
}

- (IBAction)likeGroupList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""])
        groupID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kGroupAPI_ID];
    else
        groupID = [[groupArray objectAtIndex:[sender tag]] valueForKey: kGroupAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeGroupList:groupID];
    }
}

- (IBAction)dislikeGroup_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""])
        groupID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kGroupAPI_ID];
    else
        groupID = [[groupArray objectAtIndex:[sender tag]] valueForKey: kGroupAPI_ID];
    
    [self dislikeGroup:groupID];
}

- (IBAction)disLikeGroupList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""])
        groupID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kGroupAPI_ID];
    else
        groupID = [[groupArray objectAtIndex:[sender tag]] valueForKey: kGroupAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeGroupList:groupID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kGroupAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(groupArray.count == totalItems)
                return groupArray.count ;
            else
                return groupArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kGroupAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kGroupAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kGroupAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""]) {
            {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Group] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kGroupAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kGroupAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kGroupAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kGroupAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kGroupAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kGroupAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Group
                    if (selectedSegment == SEARCH_GROUP_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // My Group
                    if (selectedSegment == MY_GROUP_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_GROUP_SELECTED) {
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
        } else {
            if(indexPath.row == groupArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Group] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[groupArray objectAtIndex:indexPath.row] valueForKey:kGroupAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[groupArray objectAtIndex:indexPath.row] valueForKey:kGroupAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[groupArray objectAtIndex:indexPath.row] valueForKey:kGroupAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[groupArray objectAtIndex:indexPath.row] valueForKey:kGroupAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[groupArray objectAtIndex:indexPath.row] valueForKey:kGroupAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[groupArray objectAtIndex:indexPath.row] valueForKey:kGroupAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Group
                    if (selectedSegment == SEARCH_GROUP_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Group
                    if (selectedSegment == MY_GROUP_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_GROUP_SELECTED) {
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
        if (groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find Group
                if (selectedSegment == SEARCH_GROUP_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_GROUP_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_GROUP_SELECTED || selectedSegment == DEACTIVATED_GROUP_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // Group
                if (selectedSegment == MY_GROUP_SELECTED || selectedSegment == DEACTIVATED_GROUP_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == groupArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find Group
                    if (selectedSegment == SEARCH_GROUP_SELECTED)
                        return 120;
                    else if (selectedSegment == ADD_GROUP_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_GROUP_SELECTED || selectedSegment == DEACTIVATED_GROUP_SELECTED)
                            return 145;
                        else
                            return 120 ;
                    }
                }
                else { // Group
                    if (selectedSegment == MY_GROUP_SELECTED || selectedSegment == DEACTIVATED_GROUP_SELECTED)
                        return 145;
                    else
                        return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == groupArray.count) {
//            [self getMyGroupListWithSearchText:searchedString] ; // My Group
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array ;
    if (groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""])
        array = [searchResults mutableCopy] ;
    else
        array = [groupArray mutableCopy] ;
    
    if(indexPath.row != array.count) {
        
        [UtilityClass setGroupDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditGroupIdentifier] ;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
        
        [self.navigationController pushViewController:viewController animated:YES] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetGroupViewEditing object:nil userInfo:dict];
    }
}

#pragma mark - Api Methods
-(void)getFindGroupWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kGroupAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kGroupAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kGroupAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchGroupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kGroupAPI_GroupList]) {
                    totalItems = [[responseDict valueForKey:kGroupAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [groupArray removeAllObjects];
                    
                    if(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kGroupAPI_GroupList]] ;
                    }
                    else {
                        [groupArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kGroupAPI_GroupList]] ;
                    }
                    lblNoGroupAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kGroupAPI_GroupList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoGroupAvailable.hidden = false;
                if(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kGroupAPI_GroupList]] ;
                }
                else {
                    groupArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kGroupAPI_GroupList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = groupArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyGroupListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kGroupAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kGroupAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kGroupAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyGroupListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kGroupAPI_GroupList]) {
                    totalItems = [[responseDict valueForKey:kGroupAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [groupArray removeAllObjects];
                    
                    if(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kGroupAPI_GroupList]] ;
                    }
                    else {
                        [groupArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kGroupAPI_GroupList]] ;
                    }
                    lblNoGroupAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kGroupAPI_GroupList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoGroupAvailable.hidden = false;
                if(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kGroupAPI_GroupList]] ;
                }
                else {
                    groupArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kGroupAPI_GroupList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = groupArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveGroupList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kGroupAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kGroupAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kGroupAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveGroupListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kGroupAPI_GroupList]) {
                    totalItems = [[responseDict valueForKey:kGroupAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [groupArray removeAllObjects];
                    
                    if(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kGroupAPI_GroupList]] ;
                    }
                    else {
                        [groupArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kGroupAPI_GroupList]] ;
                    }
                    lblNoGroupAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kGroupAPI_GroupList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoGroupAvailable.hidden = false;
                if(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kGroupAPI_GroupList]] ;
                }
                else {
                    groupArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kGroupAPI_GroupList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = groupArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedGroupList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kGroupAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kGroupAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kGroupAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedGroupListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kGroupAPI_GroupList]) {
                    totalItems = [[responseDict valueForKey:kGroupAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [groupArray removeAllObjects];
                    
                    if(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kGroupAPI_GroupList]] ;
                    }
                    else {
                        [groupArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kGroupAPI_GroupList]] ;
                    }
                    lblNoGroupAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kGroupAPI_GroupList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoGroupAvailable.hidden = false;
                if(groupSearchController.active && ![groupSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kGroupAPI_GroupList]] ;
                }
                else {
                    groupArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kGroupAPI_GroupList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = groupArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveGroup:(NSString *)groupId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kGroupAPI_UserID] ;
        [dictParam setObject:groupId forKey:kGroupAPI_GroupID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveGroupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveGroup_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyGroupListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateGroup:(NSString *)groupId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kGroupAPI_UserID] ;
        [dictParam setObject:groupId forKey:kGroupAPI_GroupID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateGroupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedGroupList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateGroup_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateGroup:(NSString *)groupId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kGroupAPI_UserID] ;
        [dictParam setObject:groupId forKey:kGroupAPI_GroupID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateGroupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateGroup_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyGroupListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteGroup:(NSString *)groupId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kGroupAPI_UserID] ;
        [dictParam setObject:groupId forKey:kGroupAPI_GroupID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteGroupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteGroup_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyGroupListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeGroup:(NSString *)groupId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kGroupAPI_LikedBy] ;
        [dictParam setObject:groupId forKey:kGroupAPI_GroupID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeGroupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kGroupAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kGroupAPI_Dislikes]];
                
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

-(void)dislikeGroup:(NSString *)groupId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kGroupAPI_DislikedBy] ;
        [dictParam setObject:groupId forKey:kGroupAPI_GroupID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeGroupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kGroupAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kGroupAPI_Dislikes]];
                
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

-(void)getLikeGroupList:(NSString *)groupId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:groupId forKey:kGroupAPI_GroupID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kGroupAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeGroupListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kGroupAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kGroupAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kGroupAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kGroupAPI_UserList]] ;
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

-(void)getdisLikeGroupList:(NSString *)groupId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:groupId forKey:kGroupAPI_GroupID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kGroupAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeGroupListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kGroupAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kGroupAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kGroupAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kGroupAPI_UserList]] ;
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
