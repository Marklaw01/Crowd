//
//  MyMeetUpsViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyMeetUpsViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyMeetUpsViewController ()

@end

@implementation MyMeetUpsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_MeetUp_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_MeetUp_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find MeetUp
    //        if (selectedSegment == SEARCH_MEETUP_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find MeetUp
            if (selectedSegment == SEARCH_MEETUP_SELECTED) {
                [self getFindMeetUpWithSearchText:searchedString];
            } else
                [self getMyMeetUpListWithSearchText:searchedString];
        } else {// My MeetUp
            if (selectedSegment == MY_MEETUP_SELECTED) {
                [self getMyMeetUpListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_MEETUP_SELECTED) {
                [self getArchiveMeetUpList:searchedString];
            } else {
                [self getDeactivatedMeetUpList:searchedString];
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
    [self.segmentControlMyMeetUp setTitleTextAttributes:attributes
                                                forState:UIControlStateNormal];
    [self.segmentControlSearchMeetUp setTitleTextAttributes:attributes
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
    
    meetUpArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyMeetUp.hidden = true;
    addMeetUpBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchMeetUp setSelectedSegmentIndex:SEARCH_MEETUP_SELECTED] ;
    [self.segmentControlMyMeetUp setSelectedSegmentIndex:MY_MEETUP_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get My MeetUp List
    [self getFindMeetUpWithSearchText:searchedString];
}

-(void)configureSearchController {
    meetUpSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    meetUpSearchController.searchBar.placeholder = kSearchMeetUpPlaceholder ;
    [meetUpSearchController.searchBar sizeToFit] ;
    meetUpSearchController.searchBar.text = searchedString;
    meetUpSearchController.searchResultsUpdater = self ;
    meetUpSearchController.dimsBackgroundDuringPresentation = NO ;
    meetUpSearchController.definesPresentationContext = YES ;
    meetUpSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = meetUpSearchController.searchBar ;
    meetUpSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [meetUpArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find MeetUp
        if (selectedSegment == SEARCH_MEETUP_SELECTED)
            [self getFindMeetUpWithSearchText:searchedString] ; // Find MeetUp
        else
            [self getMyMeetUpListWithSearchText:searchedString] ; // My MeetUp
    }
    else { // MeetUp
        if (selectedSegment == MY_MEETUP_SELECTED)
            [self getMyMeetUpListWithSearchText:searchedString] ; // My MeetUp
        else if (selectedSegment == ARCHIVE_MEETUP_SELECTED)
            [self getArchiveMeetUpList:searchedString] ; // Archived MeetUp
        else
            [self getDeactivatedMeetUpList:searchedString] ; // Deactivated MeetUp
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [meetUpArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [meetUpSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find MeetUp
        if (selectedSegment == SEARCH_MEETUP_SELECTED)
            [self getFindMeetUpWithSearchText:searchedString] ; // Find MeetUp
        else
            [self getMyMeetUpListWithSearchText:searchedString] ; // My MeetUp
    }
    else { // MeetUp
        if (selectedSegment == MY_MEETUP_SELECTED)
            [self getMyMeetUpListWithSearchText:searchedString] ; // My MeetUp
        else if (selectedSegment == ARCHIVE_MEETUP_SELECTED)
            [self getArchiveMeetUpList:searchedString] ; // Archived MeetUp
        else
            [self getDeactivatedMeetUpList:searchedString] ; // Deactivated MeetUp
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [meetUpArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find MeetUp
        selectedSegment = self.segmentControlSearchMeetUp.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_MEETUP_SELECTED) { //0
            [self getFindMeetUpWithSearchText:searchedString] ; // Find MeetUp
            self.segmentControlMyMeetUp.hidden = true;
            addMeetUpBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyMeetUpListWithSearchText:searchedString] ; // My MeetUp
            [self.segmentControlMyMeetUp setSelectedSegmentIndex:MY_MEETUP_SELECTED] ;
            self.segmentControlMyMeetUp.hidden = false;
            addMeetUpBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // MeetUp
        selectedSegment = self.segmentControlMyMeetUp.selectedSegmentIndex;
        self.segmentControlMyMeetUp.hidden = false;
        addMeetUpBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_MEETUP_SELECTED) { //0
            [self getMyMeetUpListWithSearchText:searchedString] ; // My MeetUp
            addMeetUpBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_MEETUP_SELECTED) { //1
            addMeetUpBtn.hidden = true;
            [self getArchiveMeetUpList:searchedString ] ; // Archived MeetUp
        }
        else { //2
            [self getDeactivatedMeetUpList:searchedString] ; // Deactivated MeetUp
            addMeetUpBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveMeetUp_ClickAction:(id)sender {
    
    if(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""]) {
        meetUpID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kMeetUpAPI_ID];
    }
    else {
        meetUpID = [[meetUpArray objectAtIndex:[sender tag]] valueForKey: kMeetUpAPI_ID];
    }
    [self archiveMeetUp:meetUpID];
}

- (IBAction)deactivateMeetUp_ClickAction:(id)sender {
    if(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""]) {
        meetUpID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kMeetUpAPI_ID];
    }
    else {
        meetUpID = [[meetUpArray objectAtIndex:[sender tag]] valueForKey: kMeetUpAPI_ID];
    }
    [self deactivateMeetUp:meetUpID];
}

- (IBAction)deleteMeetUp_ClickAction:(id)sender {
    if(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""])
        meetUpID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kMeetUpAPI_ID];
    else
        meetUpID = [[meetUpArray objectAtIndex:[sender tag]] valueForKey: kMeetUpAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
        [self activateMeetUp:meetUpID];
    else
        [self deleteMeetUp:meetUpID];
}

- (IBAction)createMeetUpButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MeetUps" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateMeetUpIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeMeetUp_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""])
        meetUpID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kMeetUpAPI_ID];
    else
        meetUpID = [[meetUpArray objectAtIndex:[sender tag]] valueForKey: kMeetUpAPI_ID];
    
    [self likeMeetUp:meetUpID];
}

- (IBAction)likeMeetUpList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""])
        meetUpID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kMeetUpAPI_ID];
    else
        meetUpID = [[meetUpArray objectAtIndex:[sender tag]] valueForKey: kMeetUpAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeMeetUpList:meetUpID];
    }
}

- (IBAction)dislikeMeetUp_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""])
        meetUpID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kMeetUpAPI_ID];
    else
        meetUpID = [[meetUpArray objectAtIndex:[sender tag]] valueForKey: kMeetUpAPI_ID];
    
    [self dislikeMeetUp:meetUpID];
}

- (IBAction)disLikeMeetUpList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""])
        meetUpID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kMeetUpAPI_ID];
    else
        meetUpID = [[meetUpArray objectAtIndex:[sender tag]] valueForKey: kMeetUpAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeMeetUpList:meetUpID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kMeetUpAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(meetUpArray.count == totalItems)
                return meetUpArray.count ;
            else
                return meetUpArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kMeetUpAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kMeetUpAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kMeetUpAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""]) {
            {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MeetUp] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kMeetUpAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kMeetUpAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kMeetUpAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kMeetUpAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kMeetUpAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kMeetUpAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find MeetUp
                    if (selectedSegment == SEARCH_MEETUP_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // My MeetUp
                    if (selectedSegment == MY_MEETUP_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_MEETUP_SELECTED) {
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
            if(indexPath.row == meetUpArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MeetUp] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[meetUpArray objectAtIndex:indexPath.row] valueForKey:kMeetUpAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[meetUpArray objectAtIndex:indexPath.row] valueForKey:kMeetUpAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[meetUpArray objectAtIndex:indexPath.row] valueForKey:kMeetUpAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[meetUpArray objectAtIndex:indexPath.row] valueForKey:kMeetUpAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[meetUpArray objectAtIndex:indexPath.row] valueForKey:kMeetUpAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[meetUpArray objectAtIndex:indexPath.row] valueForKey:kMeetUpAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find MeetUp
                    if (selectedSegment == SEARCH_MEETUP_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // MeetUp
                    if (selectedSegment == MY_MEETUP_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_MEETUP_SELECTED) {
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
        if (meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find MeetUp
                if (selectedSegment == SEARCH_MEETUP_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_MEETUP_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_MEETUP_SELECTED || selectedSegment == DEACTIVATED_MEETUP_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // MeetUp
                if (selectedSegment == MY_MEETUP_SELECTED || selectedSegment == DEACTIVATED_MEETUP_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == meetUpArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find MeetUp
                    if (selectedSegment == SEARCH_MEETUP_SELECTED)
                        return 120;
                    else if (selectedSegment == ADD_MEETUP_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_MEETUP_SELECTED || selectedSegment == DEACTIVATED_MEETUP_SELECTED)
                            return 145;
                        else
                            return 120 ;
                    }
                }
                else { // MeetUp
                    if (selectedSegment == MY_MEETUP_SELECTED || selectedSegment == DEACTIVATED_MEETUP_SELECTED)
                        return 145;
                    else
                        return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == meetUpArray.count) {
//            [self getMyMeetUpListWithSearchText:searchedString] ; // My MeetUp
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array ;
    if (meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""])
        array = [searchResults mutableCopy] ;
    else
        array = [meetUpArray mutableCopy] ;
    
    if(indexPath.row != array.count) {
        
        [UtilityClass setMeetUpDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MeetUps" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditMeetUpIdentifier] ;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
        
        [self.navigationController pushViewController:viewController animated:YES] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetMeetUpViewEditing object:nil userInfo:dict];
    }
}

#pragma mark - Api Methods
-(void)getFindMeetUpWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kMeetUpAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kMeetUpAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kMeetUpAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchMeetUpWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kMeetUpAPI_MeetUpList]) {
                    totalItems = [[responseDict valueForKey:kMeetUpAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [meetUpArray removeAllObjects];
                    
                    if(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                    }
                    else {
                        [meetUpArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                    }
                    lblNoMeetUpAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoMeetUpAvailable.hidden = false;
                if(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                }
                else {
                    meetUpArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = meetUpArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyMeetUpListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kMeetUpAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kMeetUpAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kMeetUpAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyMeetUpListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kMeetUpAPI_MeetUpList]) {
                    totalItems = [[responseDict valueForKey:kMeetUpAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [meetUpArray removeAllObjects];
                    
                    if(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                    }
                    else {
                        [meetUpArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                    }
                    lblNoMeetUpAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoMeetUpAvailable.hidden = false;
                if(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                }
                else {
                    meetUpArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = meetUpArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveMeetUpList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kMeetUpAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kMeetUpAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kMeetUpAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveMeetUpListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kMeetUpAPI_MeetUpList]) {
                    totalItems = [[responseDict valueForKey:kMeetUpAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [meetUpArray removeAllObjects];
                    
                    if(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                    }
                    else {
                        [meetUpArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                    }
                    lblNoMeetUpAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoMeetUpAvailable.hidden = false;
                if(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                }
                else {
                    meetUpArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = meetUpArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedMeetUpList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kMeetUpAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kMeetUpAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kMeetUpAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedMeetUpListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kMeetUpAPI_MeetUpList]) {
                    totalItems = [[responseDict valueForKey:kMeetUpAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [meetUpArray removeAllObjects];
                    
                    if(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                    }
                    else {
                        [meetUpArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                    }
                    lblNoMeetUpAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoMeetUpAvailable.hidden = false;
                if(meetUpSearchController.active && ![meetUpSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                }
                else {
                    meetUpArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMeetUpAPI_MeetUpList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = meetUpArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveMeetUp:(NSString *)meetUpId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kMeetUpAPI_UserID] ;
        [dictParam setObject:meetUpId forKey:kMeetUpAPI_MeetUpID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveMeetUpWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveMeetUp_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyMeetUpListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateMeetUp:(NSString *)meetUpId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kMeetUpAPI_UserID] ;
        [dictParam setObject:meetUpId forKey:kMeetUpAPI_MeetUpID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateMeetUpWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedMeetUpList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateMeetUp_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateMeetUp:(NSString *)meetUpId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kMeetUpAPI_UserID] ;
        [dictParam setObject:meetUpId forKey:kMeetUpAPI_MeetUpID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateMeetUpWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateMeetUp_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyMeetUpListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteMeetUp:(NSString *)meetUpId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kMeetUpAPI_UserID] ;
        [dictParam setObject:meetUpId forKey:kMeetUpAPI_MeetUpID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteMeetUpWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteMeetUp_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyMeetUpListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeMeetUp:(NSString *)meetUpId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kMeetUpAPI_LikedBy] ;
        [dictParam setObject:meetUpId forKey:kMeetUpAPI_MeetUpID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeMeetUpWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kMeetUpAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kMeetUpAPI_Dislikes]];
                
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

-(void)dislikeMeetUp:(NSString *)meetUpId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kMeetUpAPI_DislikedBy] ;
        [dictParam setObject:meetUpId forKey:kMeetUpAPI_MeetUpID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeMeetUpWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kMeetUpAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kMeetUpAPI_Dislikes]];
                
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

-(void)getLikeMeetUpList:(NSString *)meetUpId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:meetUpId forKey:kMeetUpAPI_MeetUpID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kMeetUpAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeMeetUpListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kMeetUpAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kMeetUpAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kMeetUpAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kMeetUpAPI_UserList]] ;
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

-(void)getdisLikeMeetUpList:(NSString *)meetUpId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:meetUpId forKey:kMeetUpAPI_MeetUpID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kMeetUpAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeMeetUpListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kMeetUpAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kMeetUpAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kMeetUpAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kMeetUpAPI_UserList]] ;
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
