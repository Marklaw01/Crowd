//
//  MyEndorsorsViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyEndorsorsViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyEndorsorsViewController ()

@end

@implementation MyEndorsorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_Endorsor_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_Endorsor_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find Endorsor
    //        if (selectedSegment == SEARCH_SOFTWARE_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find Endorsor
            if (selectedSegment == SEARCH_ENDORSOR_SELECTED) {
                [self getFindEndorsorWithSearchText:searchedString];
            } else
                [self getMyEndorsorListWithSearchText:searchedString];
        } else {// My Endorsor
            if (selectedSegment == MY_ENDORSOR_SELECTED) {
                [self getMyEndorsorListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_ENDORSOR_SELECTED) {
                [self getArchiveEndorsorList:searchedString];
            } else {
                [self getDeactivatedEndorsorList:searchedString];
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
    [self.segmentControlMyEndorsors setTitleTextAttributes:attributes
                                              forState:UIControlStateNormal];
    [self.segmentControlSearchEndorsors setTitleTextAttributes:attributes
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
    
    endorsorsArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyEndorsors.hidden = true;
    addEndorsorBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchEndorsors setSelectedSegmentIndex:SEARCH_ENDORSOR_SELECTED] ;
    [self.segmentControlMyEndorsors setSelectedSegmentIndex:MY_ENDORSOR_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get My Endorsor List
    [self getFindEndorsorWithSearchText:searchedString];
}

-(void)configureSearchController {
    endorsorSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    endorsorSearchController.searchBar.placeholder = kSearchEndorsorPlaceholder ;
    [endorsorSearchController.searchBar sizeToFit] ;
    endorsorSearchController.searchBar.text = searchedString;
    endorsorSearchController.searchResultsUpdater = self ;
    endorsorSearchController.dimsBackgroundDuringPresentation = NO ;
    endorsorSearchController.definesPresentationContext = YES ;
    endorsorSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = endorsorSearchController.searchBar ;
    endorsorSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
    return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [endorsorsArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Endorsor
        if (selectedSegment == SEARCH_ENDORSOR_SELECTED)
        [self getFindEndorsorWithSearchText:searchedString] ; // Find Endorsor
        else
        [self getMyEndorsorListWithSearchText:searchedString] ; // My Endorsor
    }
    else { // Endorsor/Invest
        if (selectedSegment == MY_ENDORSOR_SELECTED)
        [self getMyEndorsorListWithSearchText:searchedString] ; // My Endorsor
        else if (selectedSegment == ARCHIVE_ENDORSOR_SELECTED)
        [self getArchiveEndorsorList:searchedString] ; // Archived Endorsor
        else
        [self getDeactivatedEndorsorList:searchedString] ; // Deactivated Endorsor
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [endorsorsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [endorsorSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Endorsor
        if (selectedSegment == SEARCH_ENDORSOR_SELECTED)
        [self getFindEndorsorWithSearchText:searchedString] ; // Find Endorsor
        else
        [self getMyEndorsorListWithSearchText:searchedString] ; // My Endorsor
    }
    else { // Endorsor/Invest
        if (selectedSegment == MY_ENDORSOR_SELECTED)
        [self getMyEndorsorListWithSearchText:searchedString] ; // My Endorsor
        else if (selectedSegment == ARCHIVE_ENDORSOR_SELECTED)
        [self getArchiveEndorsorList:searchedString] ; // Archived Endorsor
        else
        [self getDeactivatedEndorsorList:searchedString] ; // Deactivated Endorsor
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [endorsorsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find Endorsor
        selectedSegment = self.segmentControlSearchEndorsors.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_ENDORSOR_SELECTED) { //0
            [self getFindEndorsorWithSearchText:searchedString] ; // Find Endorsor
            self.segmentControlMyEndorsors.hidden = true;
            addEndorsorBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyEndorsorListWithSearchText:searchedString] ; // My Endorsor
            [self.segmentControlMyEndorsors setSelectedSegmentIndex:MY_ENDORSOR_SELECTED] ;
            self.segmentControlMyEndorsors.hidden = false;
            addEndorsorBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // Endorsor/Invest
        selectedSegment = self.segmentControlMyEndorsors.selectedSegmentIndex;
        self.segmentControlMyEndorsors.hidden = false;
        addEndorsorBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_ENDORSOR_SELECTED) { //0
            [self getMyEndorsorListWithSearchText:searchedString] ; // My Endorsor
            addEndorsorBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_ENDORSOR_SELECTED) { //1
            addEndorsorBtn.hidden = true;
            [self getArchiveEndorsorList:searchedString ] ; // Archived Endorsor
        }
        else { //2
            [self getDeactivatedEndorsorList:searchedString] ; // Deactivated Endorsor
            addEndorsorBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveEndorsor_ClickAction:(id)sender {
    
    if(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""]) {
        endorsorID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kEndorsorAPI_ID];
    }
    else {
        endorsorID = [[endorsorsArray objectAtIndex:[sender tag]] valueForKey: kEndorsorAPI_ID];
    }
    [self archiveEndorsor:endorsorID];
}

- (IBAction)deactivateEndorsor_ClickAction:(id)sender {
    if(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""]) {
        endorsorID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kEndorsorAPI_ID];
    }
    else {
        endorsorID = [[endorsorsArray objectAtIndex:[sender tag]] valueForKey: kEndorsorAPI_ID];
    }
    [self deactivateEndorsor:endorsorID];
}

- (IBAction)deleteEndorsor_ClickAction:(id)sender {
    if(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""])
    endorsorID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kEndorsorAPI_ID];
    else
    endorsorID = [[endorsorsArray objectAtIndex:[sender tag]] valueForKey: kEndorsorAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
    [self activateEndorsor:endorsorID];
    else
    [self deleteEndorsor:endorsorID];
}

- (IBAction)createEndorsorButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Endorsors" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateEndorsorIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeEndorsor_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""])
    endorsorID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kEndorsorAPI_ID];
    else
    endorsorID = [[endorsorsArray objectAtIndex:[sender tag]] valueForKey: kEndorsorAPI_ID];
    
    [self likeEndorsor:endorsorID];
}

- (IBAction)likeEndorsorList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""])
    endorsorID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kEndorsorAPI_ID];
    else
    endorsorID = [[endorsorsArray objectAtIndex:[sender tag]] valueForKey: kEndorsorAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeEndorsorList:endorsorID];
    }
}

- (IBAction)dislikeEndorsor_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""])
    endorsorID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kEndorsorAPI_ID];
    else
    endorsorID = [[endorsorsArray objectAtIndex:[sender tag]] valueForKey: kEndorsorAPI_ID];
    
    [self dislikeEndorsor:endorsorID];
}

- (IBAction)disLikeEndorsorList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""])
    endorsorID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kEndorsorAPI_ID];
    else
    endorsorID = [[endorsorsArray objectAtIndex:[sender tag]] valueForKey: kEndorsorAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeEndorsorList:endorsorID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kEndorsorAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(endorsorsArray.count == totalItems)
                return endorsorsArray.count ;
            else
                return endorsorsArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kEndorsorAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kEndorsorAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kEndorsorAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""]) {
            {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Endorsors] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kEndorsorAPI_Endorsor_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kEndorsorAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kEndorsorAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kEndorsorAPI_Endorsor_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kEndorsorAPI_Endorsor_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kEndorsorAPI_Endorsor_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Endorsor
                    if (selectedSegment == SEARCH_ENDORSOR_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Endorsor/Invest
                    if (selectedSegment == MY_ENDORSOR_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_ENDORSOR_SELECTED) {
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
            if(indexPath.row == endorsorsArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Endorsors] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[endorsorsArray objectAtIndex:indexPath.row] valueForKey:kEndorsorAPI_Endorsor_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[endorsorsArray objectAtIndex:indexPath.row] valueForKey:kEndorsorAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[endorsorsArray objectAtIndex:indexPath.row] valueForKey:kEndorsorAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[endorsorsArray objectAtIndex:indexPath.row] valueForKey:kEndorsorAPI_Endorsor_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[endorsorsArray objectAtIndex:indexPath.row] valueForKey:kEndorsorAPI_Endorsor_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[endorsorsArray objectAtIndex:indexPath.row] valueForKey:kEndorsorAPI_Endorsor_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Endorsor
                    if (selectedSegment == SEARCH_ENDORSOR_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Endorsor/Invest
                    if (selectedSegment == MY_ENDORSOR_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_ENDORSOR_SELECTED) {
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
        if (endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find Endorsor
                if (selectedSegment == SEARCH_ENDORSOR_SELECTED)
                return 110;
                else if (selectedSegment == ADD_ENDORSOR_SELECTED)
                return 145;
                else {
                    if (selectedSegment == MY_ENDORSOR_SELECTED || selectedSegment == DEACTIVATED_ENDORSOR_SELECTED)
                    return 145;
                    else
                    return 110 ;
                }
            }
            else { // Endorsor/Invest
                if (selectedSegment == MY_ENDORSOR_SELECTED || selectedSegment == DEACTIVATED_ENDORSOR_SELECTED)
                return 145;
                else
                return 110 ;
            }
        }
        else {
            if(indexPath.row == endorsorsArray.count)
            return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find Endorsor
                    if (selectedSegment == SEARCH_ENDORSOR_SELECTED)
                    return 120;
                    else if (selectedSegment == ADD_ENDORSOR_SELECTED)
                    return 145;
                    else {
                        if (selectedSegment == MY_ENDORSOR_SELECTED || selectedSegment == DEACTIVATED_ENDORSOR_SELECTED)
                        return 145;
                        else
                        return 120 ;
                    }
                }
                else { // Endorsor/Invest
                    if (selectedSegment == MY_ENDORSOR_SELECTED || selectedSegment == DEACTIVATED_ENDORSOR_SELECTED)
                    return 145;
                    else
                    return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == endorsorsArray.count) {
//            [self getMyEndorsorListWithSearchText:searchedString] ; // My Endorsor
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblView) {
        NSMutableArray *array ;
        if (endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""])
            array = [searchResults mutableCopy] ;
        else
            array = [endorsorsArray mutableCopy] ;
        
        if(indexPath.row != array.count) {
            
            [UtilityClass setEndorsorDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Endorsors" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditEndorsorIdentifier] ;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
            
            [self.navigationController pushViewController:viewController animated:YES] ;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetEndorsorViewEditing object:nil userInfo:dict];
        }
    }
}

#pragma mark - Api Methods
-(void)getFindEndorsorWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEndorsorAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kEndorsorAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kEndorsorAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchEndorsorsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kEndorsorAPI_EndorsorList]) {
                    totalItems = [[responseDict valueForKey:kEndorsorAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [endorsorsArray removeAllObjects];
                    
                    if(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                    }
                    else {
                        [endorsorsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                    }
                    lblNoEndorsorAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;

                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoEndorsorAvailable.hidden = false;
                if(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                }
                else {
                    endorsorsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = endorsorsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyEndorsorListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEndorsorAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kEndorsorAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kEndorsorAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyEndorsorsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kEndorsorAPI_EndorsorList]) {
                    totalItems = [[responseDict valueForKey:kEndorsorAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [endorsorsArray removeAllObjects];
                    
                    if(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                    }
                    else {
                        [endorsorsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                    }
                    lblNoEndorsorAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoEndorsorAvailable.hidden = false;
                if(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                }
                else {
                    endorsorsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = endorsorsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveEndorsorList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEndorsorAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kEndorsorAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kEndorsorAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveEndorsorsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kEndorsorAPI_EndorsorList]) {
                    totalItems = [[responseDict valueForKey:kEndorsorAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [endorsorsArray removeAllObjects];
                    
                    if(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                    }
                    else {
                        [endorsorsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                    }
                    lblNoEndorsorAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoEndorsorAvailable.hidden = false;
                if(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                }
                else {
                    endorsorsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = endorsorsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedEndorsorList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEndorsorAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kEndorsorAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kEndorsorAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedEndorsorsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kEndorsorAPI_EndorsorList]) {
                    totalItems = [[responseDict valueForKey:kEndorsorAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [endorsorsArray removeAllObjects];
                    
                    if(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                    }
                    else {
                        [endorsorsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                    }
                    lblNoEndorsorAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoEndorsorAvailable.hidden = false;
                if(endorsorSearchController.active && ![endorsorSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                }
                else {
                    endorsorsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEndorsorAPI_EndorsorList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = endorsorsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveEndorsor:(NSString *)endorsorId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEndorsorAPI_UserID] ;
        [dictParam setObject:endorsorId forKey:kEndorsorAPI_EndorsorID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveEndorsorWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveEndorsor_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyEndorsorListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateEndorsor:(NSString *)endorsorId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEndorsorAPI_UserID] ;
        [dictParam setObject:endorsorId forKey:kEndorsorAPI_EndorsorID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateEndorsorWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedEndorsorList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateEndorsor_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateEndorsor:(NSString *)endorsorId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEndorsorAPI_UserID] ;
        [dictParam setObject:endorsorId forKey:kEndorsorAPI_EndorsorID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateEndorsorWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateEndorsor_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyEndorsorListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteEndorsor:(NSString *)endorsorId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEndorsorAPI_UserID] ;
        [dictParam setObject:endorsorId forKey:kEndorsorAPI_EndorsorID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteEndorsorWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteEndorsor_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyEndorsorListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeEndorsor:(NSString *)endorsorId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEndorsorAPI_Endorsor_LikedBy] ;
        [dictParam setObject:endorsorId forKey:kEndorsorAPI_EndorsorID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeEndorsorWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kEndorsorAPI_Endorsor_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kEndorsorAPI_Endorsor_Dislikes]];
                
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

-(void)dislikeEndorsor:(NSString *)endorsorId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEndorsorAPI_Endorsor_DislikedBy] ;
        [dictParam setObject:endorsorId forKey:kEndorsorAPI_EndorsorID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeEndorsorWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kEndorsorAPI_Endorsor_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kEndorsorAPI_Endorsor_Dislikes]];
                
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

-(void)getLikeEndorsorList:(NSString *)endorsorId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:endorsorId forKey:kEndorsorAPI_EndorsorID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kEndorsorAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeEndorsorListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kEndorsorAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kEndorsorAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kEndorsorAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kEndorsorAPI_UserList]] ;
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

-(void)getdisLikeEndorsorList:(NSString *)endorsorId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:endorsorId forKey:kEndorsorAPI_EndorsorID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kEndorsorAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeEndorsorListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kEndorsorAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kEndorsorAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kEndorsorAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kEndorsorAPI_UserList]] ;
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
