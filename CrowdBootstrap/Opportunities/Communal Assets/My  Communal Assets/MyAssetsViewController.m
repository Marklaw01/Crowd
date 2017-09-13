//
//  MyAssetsViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyAssetsViewController.h"

#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyAssetsViewController ()

@end

@implementation MyAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_CommunalAsset_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_CommunalAsset_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find Communal Asset
    //        if (selectedSegment == SEARCH_COMMUNAL_ASSET_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find Communal Asset
            if (selectedSegment == SEARCH_COMMUNAL_ASSET_SELECTED) {
                [self getFindCommunalAssetWithSearchText:searchedString];
            } else
                [self getMyCommunalAssetListWithSearchText:searchedString];
        } else {// My CommunalAsset
            if (selectedSegment == MY_COMMUNAL_ASSET_SELECTED) {
                [self getMyCommunalAssetListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_COMMUNAL_ASSET_SELECTED) {
                [self getArchiveCommunalAssetList:searchedString];
            } else {
                [self getDeactivatedCommunalAssetList:searchedString];
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
    [self.segmentControlMyCommunalAssets setTitleTextAttributes:attributes
                                                     forState:UIControlStateNormal];
    [self.segmentControlSearchCommunalAssets setTitleTextAttributes:attributes
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
    
    communalAssetsArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyCommunalAssets.hidden = true;
    addCommunalAssetBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchCommunalAssets setSelectedSegmentIndex:SEARCH_COMMUNAL_ASSET_SELECTED] ;
    [self.segmentControlMyCommunalAssets setSelectedSegmentIndex:MY_COMMUNAL_ASSET_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get My Communal Asset List
    [self getFindCommunalAssetWithSearchText:searchedString];
}

-(void)configureSearchController {
    communalAssetSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    communalAssetSearchController.searchBar.placeholder = kSearchCommunalAssetPlaceholder ;
    [communalAssetSearchController.searchBar sizeToFit] ;
    communalAssetSearchController.searchBar.text = searchedString;
    communalAssetSearchController.searchResultsUpdater = self ;
    communalAssetSearchController.dimsBackgroundDuringPresentation = NO ;
    communalAssetSearchController.definesPresentationContext = YES ;
    communalAssetSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = communalAssetSearchController.searchBar ;
    communalAssetSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [communalAssetsArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Communal Asset
        if (selectedSegment == SEARCH_COMMUNAL_ASSET_SELECTED)
            [self getFindCommunalAssetWithSearchText:searchedString] ; // Find Communal Asset
        else
            [self getMyCommunalAssetListWithSearchText:searchedString] ; // My Communal Asset
    }
    else { // Communal Asset
        if (selectedSegment == MY_COMMUNAL_ASSET_SELECTED)
            [self getMyCommunalAssetListWithSearchText:searchedString] ; // My Communal Asset
        else if (selectedSegment == ARCHIVE_COMMUNAL_ASSET_SELECTED)
            [self getArchiveCommunalAssetList:searchedString] ; // Archived Communal Asset
        else
            [self getDeactivatedCommunalAssetList:searchedString] ; // Deactivated Communal Asset
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [communalAssetsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [communalAssetSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Communal Asset
        if (selectedSegment == SEARCH_COMMUNAL_ASSET_SELECTED)
            [self getFindCommunalAssetWithSearchText:searchedString] ; // Find Communal Asset
        else
            [self getMyCommunalAssetListWithSearchText:searchedString] ; // My Communal Asset
    }
    else { // Communal Asset
        if (selectedSegment == MY_COMMUNAL_ASSET_SELECTED)
            [self getMyCommunalAssetListWithSearchText:searchedString] ; // My Communal Asset
        else if (selectedSegment == ARCHIVE_COMMUNAL_ASSET_SELECTED)
            [self getArchiveCommunalAssetList:searchedString] ; // Archived Communal Asset
        else
            [self getDeactivatedCommunalAssetList:searchedString] ; // Deactivated Communal Asset
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [communalAssetsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find Communal Asset
        selectedSegment = self.segmentControlSearchCommunalAssets.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_COMMUNAL_ASSET_SELECTED) { //0
            [self getFindCommunalAssetWithSearchText:searchedString] ; // Find Communal Asset
            self.segmentControlMyCommunalAssets.hidden = true;
            addCommunalAssetBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyCommunalAssetListWithSearchText:searchedString] ; // My Communal Asset
            [self.segmentControlMyCommunalAssets setSelectedSegmentIndex:MY_COMMUNAL_ASSET_SELECTED] ;
            self.segmentControlMyCommunalAssets.hidden = false;
            addCommunalAssetBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // Communal Asset
        selectedSegment = self.segmentControlMyCommunalAssets.selectedSegmentIndex;
        self.segmentControlMyCommunalAssets.hidden = false;
        addCommunalAssetBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_COMMUNAL_ASSET_SELECTED) { //0
            [self getMyCommunalAssetListWithSearchText:searchedString] ; // My Communal Asset
            addCommunalAssetBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_COMMUNAL_ASSET_SELECTED) { //1
            addCommunalAssetBtn.hidden = true;
            [self getArchiveCommunalAssetList:searchedString ] ; // Archived Communal Asset
        }
        else { //2
            [self getDeactivatedCommunalAssetList:searchedString] ; // Deactivated Communal Asset
            addCommunalAssetBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveCommunalAsset_ClickAction:(id)sender {
    
    if(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""]) {
        communalAssetID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kCommunalAssetAPI_ID];
    }
    else {
        communalAssetID = [[communalAssetsArray objectAtIndex:[sender tag]] valueForKey: kCommunalAssetAPI_ID];
    }
    [self archiveCommunalAsset:communalAssetID];
}

- (IBAction)deactivateCommunalAsset_ClickAction:(id)sender {
    if(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""]) {
        communalAssetID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kCommunalAssetAPI_ID];
    }
    else {
        communalAssetID = [[communalAssetsArray objectAtIndex:[sender tag]] valueForKey: kCommunalAssetAPI_ID];
    }
    [self deactivateCommunalAsset:communalAssetID];
}

- (IBAction)deleteCommunalAsset_ClickAction:(id)sender {
    if(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""])
        communalAssetID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kCommunalAssetAPI_ID];
    else
        communalAssetID = [[communalAssetsArray objectAtIndex:[sender tag]] valueForKey: kCommunalAssetAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
        [self activateCommunalAsset:communalAssetID];
    else
        [self deleteCommunalAsset:communalAssetID];
}

- (IBAction)createCommunalAssetButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CommunalAssets" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateCommunalAssetIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeCommunalAsset_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""])
        communalAssetID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kCommunalAssetAPI_ID];
    else
        communalAssetID = [[communalAssetsArray objectAtIndex:[sender tag]] valueForKey: kCommunalAssetAPI_ID];
    
    [self likeCommunalAsset:communalAssetID];
}

- (IBAction)likeCommunalAssetList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""])
        communalAssetID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kCommunalAssetAPI_ID];
    else
        communalAssetID = [[communalAssetsArray objectAtIndex:[sender tag]] valueForKey: kCommunalAssetAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeCommunalAssetList:communalAssetID];
    }
}

- (IBAction)dislikeCommunalAsset_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""])
        communalAssetID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kCommunalAssetAPI_ID];
    else
        communalAssetID = [[communalAssetsArray objectAtIndex:[sender tag]] valueForKey: kCommunalAssetAPI_ID];
    
    [self dislikeCommunalAsset:communalAssetID];
}

- (IBAction)disLikeCommunalAssetList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""])
        communalAssetID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kCommunalAssetAPI_ID];
    else
        communalAssetID = [[communalAssetsArray objectAtIndex:[sender tag]] valueForKey: kCommunalAssetAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdislikeCommunalAssetList:communalAssetID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kCommunalAssetAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(communalAssetsArray.count == totalItems)
                return communalAssetsArray.count ;
            else
                return communalAssetsArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""]) {
            FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CommunalAssets] ;
            
            cell.btnLikeCount.tag = indexPath.row;
            cell.btnDislikeCount.tag = indexPath.row;
            cell.btnLike.tag = indexPath.row;
            cell.btnDislike.tag = indexPath.row;
            cell.btnArchive.tag = indexPath.row;
            cell.btnDeactivate.tag = indexPath.row;
            cell.btnDelete.tag = indexPath.row;
            
            cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_Title]] ;
            cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_StartDate]];
            cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_Description]];
            
            [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_Likes]] forState:UIControlStateNormal];
            [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_Dislikes]] forState:UIControlStateNormal];
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            
            cell.imgView.layer.cornerRadius = 20;
            cell.imgView.clipsToBounds = YES;
            
            if (selectedSegmentControl == 100) { // Find Communal Asset
                if (selectedSegment == SEARCH_COMMUNAL_ASSET_SELECTED) {
                    cell.btnArchive.hidden = true;
                    cell.btnDeactivate.hidden = true;
                    cell.btnDelete.hidden = true;
                } else {
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                }
            }
            else { // Communal Asset
                if (selectedSegment == MY_COMMUNAL_ASSET_SELECTED) {
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                    [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                    cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                } else if (selectedSegment == DEACTIVATED_COMMUNAL_ASSET_SELECTED) {
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
            
            if(indexPath.row == communalAssetsArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CommunalAssets] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[communalAssetsArray objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[communalAssetsArray objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[communalAssetsArray objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[communalAssetsArray objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[communalAssetsArray objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[communalAssetsArray objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Communal Asset
                    if (selectedSegment == SEARCH_COMMUNAL_ASSET_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // My Communal Asset
                    if (selectedSegment == MY_COMMUNAL_ASSET_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_COMMUNAL_ASSET_SELECTED) {
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
        if (communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find Communal Asset
                if (selectedSegment == SEARCH_COMMUNAL_ASSET_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_COMMUNAL_ASSET_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_COMMUNAL_ASSET_SELECTED || selectedSegment == DEACTIVATED_COMMUNAL_ASSET_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // My Communal Asset
                if (selectedSegment == MY_COMMUNAL_ASSET_SELECTED || selectedSegment == DEACTIVATED_COMMUNAL_ASSET_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == communalAssetsArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find Communal Asset
                    if (selectedSegment == SEARCH_COMMUNAL_ASSET_SELECTED)
                        return 115;
                    else if (selectedSegment == ADD_COMMUNAL_ASSET_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_COMMUNAL_ASSET_SELECTED || selectedSegment == DEACTIVATED_COMMUNAL_ASSET_SELECTED)
                            return 145;
                        else
                            return 115 ;
                    }
                }
                else { // My Communal Asset
                    if (selectedSegment == MY_COMMUNAL_ASSET_SELECTED || selectedSegment == DEACTIVATED_COMMUNAL_ASSET_SELECTED)
                        return 145;
                    else
                        return 115 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == communalAssetsArray.count) {
//            [self getMyCommunalAssetListWithSearchText:searchedString] ; // My CommunalAsset
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array ;
    if (communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""])
        array = [searchResults mutableCopy] ;
    else
        array = [communalAssetsArray mutableCopy] ;
    
    if(indexPath.row != array.count) {
        
        [UtilityClass setCommunalAssetDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CommunalAssets" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditCommunalAssetIdentifier] ;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
        
        [self.navigationController pushViewController:viewController animated:YES] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetCommunalAssetViewEditing object:nil userInfo:dict];
    }
}

#pragma mark - Api Methods
-(void)getFindCommunalAssetWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kCommunalAssetAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kCommunalAssetAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchCommunalAssetsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kCommunalAssetAPI_AssetList]) {
                    totalItems = [[responseDict valueForKey:kCommunalAssetAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [communalAssetsArray removeAllObjects];
                    
                    if(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                    }
                    else {
                        [communalAssetsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                    }
                    lblNoCommunalAssetAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoCommunalAssetAvailable.hidden = false;
                if(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                }
                else {
                    communalAssetsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = communalAssetsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyCommunalAssetListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kCommunalAssetAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kCommunalAssetAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyCommunalAssetsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kCommunalAssetAPI_AssetList]) {
                    totalItems = [[responseDict valueForKey:kCommunalAssetAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [communalAssetsArray removeAllObjects];
                    
                    if(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                    }
                    else {
                        [communalAssetsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                    }
                    lblNoCommunalAssetAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoCommunalAssetAvailable.hidden = false;
                if(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                }
                else {
                    communalAssetsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = communalAssetsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveCommunalAssetList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kCommunalAssetAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kCommunalAssetAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveCommunalAssetsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kCommunalAssetAPI_AssetList]) {
                    totalItems = [[responseDict valueForKey:kCommunalAssetAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [communalAssetsArray removeAllObjects];
                    
                    if(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                    }
                    else {
                        [communalAssetsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                    }
                    lblNoCommunalAssetAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoCommunalAssetAvailable.hidden = false;
                if(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                }
                else {
                    communalAssetsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = communalAssetsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedCommunalAssetList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kCommunalAssetAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kCommunalAssetAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedCommunalAssetsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kCommunalAssetAPI_AssetList]) {
                    totalItems = [[responseDict valueForKey:kCommunalAssetAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [communalAssetsArray removeAllObjects];
                    
                    if(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                    }
                    else {
                        [communalAssetsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                    }
                    lblNoCommunalAssetAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoCommunalAssetAvailable.hidden = false;
                if(communalAssetSearchController.active && ![communalAssetSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                }
                else {
                    communalAssetsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCommunalAssetAPI_AssetList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = communalAssetsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveCommunalAsset:(NSString *)communalAssetId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_UserID] ;
        [dictParam setObject:communalAssetId forKey:kCommunalAssetAPI_AssetID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveCommunalAssetWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kArchiveCommunalAsset_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyCommunalAssetListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateCommunalAsset:(NSString *)communalAssetId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_UserID] ;
        [dictParam setObject:communalAssetId forKey:kCommunalAssetAPI_AssetID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateCommunalAssetWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedCommunalAssetList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateCommunalAsset_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateCommunalAsset:(NSString *)communalAssetId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_UserID] ;
        [dictParam setObject:communalAssetId forKey:kCommunalAssetAPI_AssetID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateCommunalAssetWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateCommunalAsset_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyCommunalAssetListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteCommunalAsset:(NSString *)communalAssetId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_UserID] ;
        [dictParam setObject:communalAssetId forKey:kCommunalAssetAPI_AssetID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteCommunalAssetWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteCommunalAsset_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyCommunalAssetListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeCommunalAsset:(NSString *)communalAssetId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_LikedBy] ;
        [dictParam setObject:communalAssetId forKey:kCommunalAssetAPI_AssetID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeCommunalAssetWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kCommunalAssetAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kCommunalAssetAPI_Dislikes]];
                
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

-(void)dislikeCommunalAsset:(NSString *)communalAssetId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_DislikedBy] ;
        [dictParam setObject:communalAssetId forKey:kCommunalAssetAPI_AssetID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeCommunalAssetWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kCommunalAssetAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kCommunalAssetAPI_Dislikes]];
                
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

-(void)getLikeCommunalAssetList:(NSString *)communalAssetId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:communalAssetId forKey:kCommunalAssetAPI_AssetID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kCommunalAssetAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeCommunalAssetListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kCommunalAssetAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kCommunalAssetAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_UserList]] ;
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

-(void)getdislikeCommunalAssetList:(NSString *)communalAssetId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:communalAssetId forKey:kCommunalAssetAPI_AssetID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kCommunalAssetAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeCommunalAssetListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kCommunalAssetAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kCommunalAssetAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_UserList]] ;
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
