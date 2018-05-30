//
//  MyBoardMembersViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyBoardMembersViewController.h"

#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyBoardMembersViewController ()

@end

@implementation MyBoardMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_BoardMember_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_BoardMember_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find BoardMember
    //        if (selectedSegment == SEARCH_BOARD_MEMBER_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find BoardMember
            if (selectedSegment == SEARCH_BOARD_MEMBER_SELECTED) {
                [self getFindBoardMemberWithSearchText:searchedString];
            } else
                [self getMyBoardMemberListWithSearchText:searchedString];
        } else {// My BoardMember
            if (selectedSegment == MY_BOARD_MEMBER_SELECTED) {
                [self getMyBoardMemberListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_BOARD_MEMBER_SELECTED) {
                [self getArchiveBoardMemberList:searchedString];
            } else {
                [self getDeactivatedBoardMemberList:searchedString];
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
    [self.segmentControlMyBoardMembers setTitleTextAttributes:attributes
                                              forState:UIControlStateNormal];
    [self.segmentControlSearchBoardMembers setTitleTextAttributes:attributes
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
    
    boardMembersArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyBoardMembers.hidden = true;
    addBoardMemberBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchBoardMembers setSelectedSegmentIndex:SEARCH_BOARD_MEMBER_SELECTED] ;
    [self.segmentControlMyBoardMembers setSelectedSegmentIndex:MY_BOARD_MEMBER_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get My BoardMember List
    [self getFindBoardMemberWithSearchText:searchedString];
}

-(void)configureSearchController {
    boardMemberSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    boardMemberSearchController.searchBar.placeholder = kSearchBoardMemberPlaceholder ;
    [boardMemberSearchController.searchBar sizeToFit] ;
    boardMemberSearchController.searchBar.text = searchedString;
    boardMemberSearchController.searchResultsUpdater = self ;
    boardMemberSearchController.dimsBackgroundDuringPresentation = NO ;
    boardMemberSearchController.definesPresentationContext = YES ;
    boardMemberSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = boardMemberSearchController.searchBar ;
    boardMemberSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
    return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [boardMembersArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find BoardMember
        if (selectedSegment == SEARCH_BOARD_MEMBER_SELECTED)
        [self getFindBoardMemberWithSearchText:searchedString] ; // Find BoardMember
        else
        [self getMyBoardMemberListWithSearchText:searchedString] ; // My BoardMember
    }
    else { // BoardMember/Invest
        if (selectedSegment == MY_BOARD_MEMBER_SELECTED)
        [self getMyBoardMemberListWithSearchText:searchedString] ; // My BoardMember
        else if (selectedSegment == ARCHIVE_BOARD_MEMBER_SELECTED)
        [self getArchiveBoardMemberList:searchedString] ; // Archived BoardMember
        else
        [self getDeactivatedBoardMemberList:searchedString] ; // Deactivated BoardMember
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [boardMembersArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [boardMemberSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find BoardMember
        if (selectedSegment == SEARCH_BOARD_MEMBER_SELECTED)
        [self getFindBoardMemberWithSearchText:searchedString] ; // Find BoardMember
        else
        [self getMyBoardMemberListWithSearchText:searchedString] ; // My BoardMember
    }
    else { // BoardMember/Invest
        if (selectedSegment == MY_BOARD_MEMBER_SELECTED)
        [self getMyBoardMemberListWithSearchText:searchedString] ; // My BoardMember
        else if (selectedSegment == ARCHIVE_BOARD_MEMBER_SELECTED)
        [self getArchiveBoardMemberList:searchedString] ; // Archived BoardMember
        else
        [self getDeactivatedBoardMemberList:searchedString] ; // Deactivated BoardMember
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [boardMembersArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find BoardMember
        selectedSegment = self.segmentControlSearchBoardMembers.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_BOARD_MEMBER_SELECTED) { //0
            [self getFindBoardMemberWithSearchText:searchedString] ; // Find BoardMember
            self.segmentControlMyBoardMembers.hidden = true;
            addBoardMemberBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyBoardMemberListWithSearchText:searchedString] ; // My BoardMember
            [self.segmentControlMyBoardMembers setSelectedSegmentIndex:MY_BOARD_MEMBER_SELECTED] ;
            self.segmentControlMyBoardMembers.hidden = false;
            addBoardMemberBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // BoardMember/Invest
        selectedSegment = self.segmentControlMyBoardMembers.selectedSegmentIndex;
        self.segmentControlMyBoardMembers.hidden = false;
        addBoardMemberBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_BOARD_MEMBER_SELECTED) { //0
            [self getMyBoardMemberListWithSearchText:searchedString] ; // My BoardMember
            addBoardMemberBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_BOARD_MEMBER_SELECTED) { //1
            addBoardMemberBtn.hidden = true;
            [self getArchiveBoardMemberList:searchedString ] ; // Archived BoardMember
        }
        else { //2
            [self getDeactivatedBoardMemberList:searchedString] ; // Deactivated BoardMember
            addBoardMemberBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveBoardMember_ClickAction:(id)sender {
    
    if(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""]) {
        boardMemberID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kBoardMemberAPI_ID];
    }
    else {
        boardMemberID = [[boardMembersArray objectAtIndex:[sender tag]] valueForKey: kBoardMemberAPI_ID];
    }
    [self archiveBoardMember:boardMemberID];
}

- (IBAction)deactivateBoardMember_ClickAction:(id)sender {
    if(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""]) {
        boardMemberID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kBoardMemberAPI_ID];
    }
    else {
        boardMemberID = [[boardMembersArray objectAtIndex:[sender tag]] valueForKey: kBoardMemberAPI_ID];
    }
    [self deactivateBoardMember:boardMemberID];
}

- (IBAction)deleteBoardMember_ClickAction:(id)sender {
    if(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""])
    boardMemberID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kBoardMemberAPI_ID];
    else
    boardMemberID = [[boardMembersArray objectAtIndex:[sender tag]] valueForKey: kBoardMemberAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
    [self activateBoardMember:boardMemberID];
    else
    [self deleteBoardMember:boardMemberID];
}

- (IBAction)createBoardMemberButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BoardMembers" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateBoardMemberIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeBoardMember_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""])
        boardMemberID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kBoardMemberAPI_ID];
    else
        boardMemberID = [[boardMembersArray objectAtIndex:[sender tag]] valueForKey: kBoardMemberAPI_ID];
    
    [self likeBoardMember:boardMemberID];
}

- (IBAction)likeBoardMemberList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""])
    boardMemberID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kBoardMemberAPI_ID];
    else
    boardMemberID = [[boardMembersArray objectAtIndex:[sender tag]] valueForKey: kBoardMemberAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeBoardMemberList:boardMemberID];
    }
}

- (IBAction)dislikeBoardMember_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""])
    boardMemberID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kBoardMemberAPI_ID];
    else
    boardMemberID = [[boardMembersArray objectAtIndex:[sender tag]] valueForKey: kBoardMemberAPI_ID];
    
    [self dislikeBoardMember:boardMemberID];
}

- (IBAction)disLikeBoardMemberList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""])
    boardMemberID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kBoardMemberAPI_ID];
    else
    boardMemberID = [[boardMembersArray objectAtIndex:[sender tag]] valueForKey: kBoardMemberAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdislikeBoardMemberList:boardMemberID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kBoardMemberAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(boardMembersArray.count == totalItems)
                return boardMembersArray.count ;
            else
                return boardMembersArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kBoardMemberAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kBoardMemberAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kBoardMemberAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""]) {
            FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_BoardMembers] ;
            
            cell.btnLikeCount.tag = indexPath.row;
            cell.btnDislikeCount.tag = indexPath.row;
            cell.btnLike.tag = indexPath.row;
            cell.btnDislike.tag = indexPath.row;
            cell.btnArchive.tag = indexPath.row;
            cell.btnDeactivate.tag = indexPath.row;
            cell.btnDelete.tag = indexPath.row;
            
            cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kBoardMemberAPI_BoardMember_Title]] ;
            cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kBoardMemberAPI_StartDate]];
            cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kBoardMemberAPI_Description]];
            
            [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kBoardMemberAPI_BoardMember_Likes]] forState:UIControlStateNormal];
            [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kBoardMemberAPI_BoardMember_Dislikes]] forState:UIControlStateNormal];
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kBoardMemberAPI_BoardMember_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            
            cell.imgView.layer.cornerRadius = 20;
            cell.imgView.clipsToBounds = YES;
            
            if (selectedSegmentControl == 100) { // Find BoardMember
                if (selectedSegment == SEARCH_BOARD_MEMBER_SELECTED) {
                    cell.btnArchive.hidden = true;
                    cell.btnDeactivate.hidden = true;
                    cell.btnDelete.hidden = true;
                } else {
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                }
            }
            else { // BoardMember/Invest
                if (selectedSegment == MY_BOARD_MEMBER_SELECTED) {
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                    [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                    cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                } else if (selectedSegment == DEACTIVATED_BOARD_MEMBER_SELECTED) {
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
        
        if(indexPath.row == boardMembersArray.count) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
            [activityIndicator startAnimating];
            return cell ;
        } else {
            FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_BoardMembers] ;
            
            cell.btnLikeCount.tag = indexPath.row;
            cell.btnDislikeCount.tag = indexPath.row;
            cell.btnLike.tag = indexPath.row;
            cell.btnDislike.tag = indexPath.row;
            cell.btnArchive.tag = indexPath.row;
            cell.btnDeactivate.tag = indexPath.row;
            cell.btnDelete.tag = indexPath.row;

            cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[boardMembersArray objectAtIndex:indexPath.row] valueForKey:kBoardMemberAPI_BoardMember_Title]] ;
            cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[boardMembersArray objectAtIndex:indexPath.row] valueForKey:kBoardMemberAPI_StartDate]];
            cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[boardMembersArray objectAtIndex:indexPath.row] valueForKey:kBoardMemberAPI_Description]];
            
            [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[boardMembersArray objectAtIndex:indexPath.row] valueForKey:kBoardMemberAPI_BoardMember_Likes]] forState:UIControlStateNormal];
            [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[boardMembersArray objectAtIndex:indexPath.row] valueForKey:kBoardMemberAPI_BoardMember_Dislikes]] forState:UIControlStateNormal];
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[boardMembersArray objectAtIndex:indexPath.row] valueForKey:kBoardMemberAPI_BoardMember_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            
            cell.imgView.layer.cornerRadius = 20;
            cell.imgView.clipsToBounds = YES;
            
            if (selectedSegmentControl == 100) { // Find Board Member
                if (selectedSegment == SEARCH_BOARD_MEMBER_SELECTED) {
                    cell.btnArchive.hidden = true;
                    cell.btnDeactivate.hidden = true;
                    cell.btnDelete.hidden = true;
                } else {
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                }
            }
            else { // My Board Member
                if (selectedSegment == MY_BOARD_MEMBER_SELECTED) {
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                    [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                    cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                } else if (selectedSegment == DEACTIVATED_BOARD_MEMBER_SELECTED) {
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
        if (boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find Board Member
                if (selectedSegment == SEARCH_BOARD_MEMBER_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_BOARD_MEMBER_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_BOARD_MEMBER_SELECTED || selectedSegment == DEACTIVATED_BOARD_MEMBER_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // My Board Member
                if (selectedSegment == MY_BOARD_MEMBER_SELECTED || selectedSegment == DEACTIVATED_BOARD_MEMBER_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == boardMembersArray.count)
            return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find Board Member
                    if (selectedSegment == SEARCH_BOARD_MEMBER_SELECTED)
                        return 115;
                    else if (selectedSegment == ADD_BOARD_MEMBER_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_BOARD_MEMBER_SELECTED || selectedSegment == DEACTIVATED_BOARD_MEMBER_SELECTED)
                            return 145;
                        else
                            return 115 ;
                    }
                }
                else { // My Board Member
                    if (selectedSegment == MY_BOARD_MEMBER_SELECTED || selectedSegment == DEACTIVATED_BOARD_MEMBER_SELECTED)
                        return 145;
                    else
                        return 115 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == boardMembersArray.count) {
//            [self getMyBoardMemberListWithSearchText:searchedString] ; // My BoardMember
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblView) {
        NSMutableArray *array ;
        if (boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""])
            array = [searchResults mutableCopy] ;
        else
            array = [boardMembersArray mutableCopy] ;
        
        if(indexPath.row != array.count) {
            
            [UtilityClass setBoardMemberDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BoardMembers" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditBoardMemberIdentifier] ;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
            
            [self.navigationController pushViewController:viewController animated:YES] ;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetBoardMemberViewEditing object:nil userInfo:dict];
        }
    }
}

#pragma mark - Api Methods
-(void)getFindBoardMemberWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBoardMemberAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kBoardMemberAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kBoardMemberAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchBoardMembersWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kBoardMemberAPI_BoardMemberList]) {
                    totalItems = [[responseDict valueForKey:kBoardMemberAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [boardMembersArray removeAllObjects];
                    
                    if(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                    }
                    else {
                        [boardMembersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                    }
                    lblNoBoardMemberAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoBoardMemberAvailable.hidden = false;
                if(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                }
                else {
                    boardMembersArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = boardMembersArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyBoardMemberListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBoardMemberAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kBoardMemberAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kBoardMemberAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyBoardMembersListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kBoardMemberAPI_BoardMemberList]) {
                    totalItems = [[responseDict valueForKey:kBoardMemberAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [boardMembersArray removeAllObjects];
                    
                    if(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                    }
                    else {
                        [boardMembersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                    }
                    lblNoBoardMemberAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;

                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoBoardMemberAvailable.hidden = false;
                if(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                }
                else {
                    boardMembersArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = boardMembersArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveBoardMemberList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBoardMemberAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kBoardMemberAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kBoardMemberAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveBoardMembersListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kBoardMemberAPI_BoardMemberList]) {
                    totalItems = [[responseDict valueForKey:kBoardMemberAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [boardMembersArray removeAllObjects];
                    
                    if(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                    }
                    else {
                        [boardMembersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                    }
                    lblNoBoardMemberAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;

                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoBoardMemberAvailable.hidden = false;
                if(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                }
                else {
                    boardMembersArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = boardMembersArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedBoardMemberList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBoardMemberAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kBoardMemberAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kBoardMemberAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedBoardMembersListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kBoardMemberAPI_BoardMemberList]) {
                    totalItems = [[responseDict valueForKey:kBoardMemberAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [boardMembersArray removeAllObjects];
                    
                    if(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                    }
                    else {
                        [boardMembersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                    }
                    lblNoBoardMemberAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;

                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoBoardMemberAvailable.hidden = false;
                if(boardMemberSearchController.active && ![boardMemberSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                }
                else {
                    boardMembersArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBoardMemberAPI_BoardMemberList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = boardMembersArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveBoardMember:(NSString *)boardMemberId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBoardMemberAPI_UserID] ;
        [dictParam setObject:boardMemberId forKey:kBoardMemberAPI_BoardMemberID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveBoardMemberWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveBoardMember_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyBoardMemberListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateBoardMember:(NSString *)boardMemberId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBoardMemberAPI_UserID] ;
        [dictParam setObject:boardMemberId forKey:kBoardMemberAPI_BoardMemberID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateBoardMemberWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedBoardMemberList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateBoardMember_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateBoardMember:(NSString *)boardMemberId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBoardMemberAPI_UserID] ;
        [dictParam setObject:boardMemberId forKey:kBoardMemberAPI_BoardMemberID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateBoardMemberWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateBoardMember_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyBoardMemberListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteBoardMember:(NSString *)boardMemberId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBoardMemberAPI_UserID] ;
        [dictParam setObject:boardMemberId forKey:kBoardMemberAPI_BoardMemberID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteBoardMemberWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteBoardMember_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyBoardMemberListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeBoardMember:(NSString *)boardMemberId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBoardMemberAPI_BoardMember_LikedBy] ;
        [dictParam setObject:boardMemberId forKey:kBoardMemberAPI_BoardMemberID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeBoardMemberWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kBoardMemberAPI_BoardMember_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kBoardMemberAPI_BoardMember_Dislikes]];
                
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

-(void)dislikeBoardMember:(NSString *)boardMemberId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBoardMemberAPI_BoardMember_DislikedBy] ;
        [dictParam setObject:boardMemberId forKey:kBoardMemberAPI_BoardMemberID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeBoardMemberWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kBoardMemberAPI_BoardMember_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kBoardMemberAPI_BoardMember_Dislikes]];
                
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

-(void)getLikeBoardMemberList:(NSString *)boardMemberId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:boardMemberId forKey:kBoardMemberAPI_BoardMemberID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kBoardMemberAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeBoardMemberListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kBoardMemberAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kBoardMemberAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBoardMemberAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kBoardMemberAPI_UserList]] ;
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

-(void)getdislikeBoardMemberList:(NSString *)boardMemberId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:boardMemberId forKey:kBoardMemberAPI_BoardMemberID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kBoardMemberAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeBoardMemberListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kBoardMemberAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kBoardMemberAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBoardMemberAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kBoardMemberAPI_UserList]] ;
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
