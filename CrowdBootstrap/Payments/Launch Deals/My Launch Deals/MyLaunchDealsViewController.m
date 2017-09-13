//
//  MyLaunchDealsViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyLaunchDealsViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyLaunchDealsViewController ()

@end

@implementation MyLaunchDealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_LaunchDeal_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_LaunchDeal_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find LaunchDeal
    //        if (selectedSegment == SEARCH_LAUNCHDEAL_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find LaunchDeal
            if (selectedSegment == SEARCH_LAUNCHDEAL_SELECTED) {
                [self getFindLaunchDealWithSearchText:searchedString];
            } else
                [self getMyLaunchDealListWithSearchText:searchedString];
        } else {// My LaunchDeal
            if (selectedSegment == MY_LAUNCHDEAL_SELECTED) {
                [self getMyLaunchDealListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_LAUNCHDEAL_SELECTED) {
                [self getArchiveLaunchDealList:searchedString];
            } else {
                [self getDeactivatedLaunchDealList:searchedString];
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
    [self.segmentControlMyLaunchDeals setTitleTextAttributes:attributes
                                                  forState:UIControlStateNormal];
    [self.segmentControlSearchLaunchDeals setTitleTextAttributes:attributes
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
    
    launchDealsArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyLaunchDeals.hidden = true;
    addLaunchDealBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchLaunchDeals setSelectedSegmentIndex:SEARCH_LAUNCHDEAL_SELECTED] ;
    [self.segmentControlMyLaunchDeals setSelectedSegmentIndex:MY_LAUNCHDEAL_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get LaunchDeal List
    [self getFindLaunchDealWithSearchText:searchedString];
}

-(void)configureSearchController {
    launchDealSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    launchDealSearchController.searchBar.placeholder = kSearchLaunchDealPlaceholder ;
    [launchDealSearchController.searchBar sizeToFit] ;
    launchDealSearchController.searchBar.text = searchedString;
    launchDealSearchController.searchResultsUpdater = self ;
    launchDealSearchController.dimsBackgroundDuringPresentation = NO ;
    launchDealSearchController.definesPresentationContext = YES ;
    launchDealSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = launchDealSearchController.searchBar ;
    launchDealSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [launchDealsArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find LaunchDeal
        if (selectedSegment == SEARCH_LAUNCHDEAL_SELECTED)
            [self getFindLaunchDealWithSearchText:searchedString] ; // Find LaunchDeal
        else
            [self getMyLaunchDealListWithSearchText:searchedString] ; // My LaunchDeal
    }
    else { // LaunchDeal/Invest
        if (selectedSegment == MY_LAUNCHDEAL_SELECTED)
            [self getMyLaunchDealListWithSearchText:searchedString] ; // My LaunchDeal
        else if (selectedSegment == ARCHIVE_LAUNCHDEAL_SELECTED)
            [self getArchiveLaunchDealList:searchedString] ; // Archived LaunchDeal
        else
            [self getDeactivatedLaunchDealList:searchedString] ; // Deactivated LaunchDeal
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [launchDealsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [launchDealSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find LaunchDeal
        if (selectedSegment == SEARCH_LAUNCHDEAL_SELECTED)
            [self getFindLaunchDealWithSearchText:searchedString] ; // Find LaunchDeal
        else
            [self getMyLaunchDealListWithSearchText:searchedString] ; // My LaunchDeal
    }
    else { // LaunchDeal/Invest
        if (selectedSegment == MY_LAUNCHDEAL_SELECTED)
            [self getMyLaunchDealListWithSearchText:searchedString] ; // My LaunchDeal
        else if (selectedSegment == ARCHIVE_LAUNCHDEAL_SELECTED)
            [self getArchiveLaunchDealList:searchedString] ; // Archived LaunchDeal
        else
            [self getDeactivatedLaunchDealList:searchedString] ; // Deactivated LaunchDeal
    }
}

#pragma mark - IBAction Methods
- (IBAction)BackClick_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [launchDealsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find LaunchDeal
        selectedSegment = self.segmentControlSearchLaunchDeals.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_LAUNCHDEAL_SELECTED) { //0
            [self getFindLaunchDealWithSearchText:searchedString] ; // Find LaunchDeal
            self.segmentControlMyLaunchDeals.hidden = true;
            addLaunchDealBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyLaunchDealListWithSearchText:searchedString] ; // My LaunchDeal
            [self.segmentControlMyLaunchDeals setSelectedSegmentIndex:MY_LAUNCHDEAL_SELECTED] ;
            self.segmentControlMyLaunchDeals.hidden = false;
            addLaunchDealBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // LaunchDeal/Invest
        selectedSegment = self.segmentControlMyLaunchDeals.selectedSegmentIndex;
        self.segmentControlMyLaunchDeals.hidden = false;
        addLaunchDealBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_LAUNCHDEAL_SELECTED) { //0
            [self getMyLaunchDealListWithSearchText:searchedString] ; // My LaunchDeal
            addLaunchDealBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_LAUNCHDEAL_SELECTED) { //1
            addLaunchDealBtn.hidden = true;
            [self getArchiveLaunchDealList:searchedString ] ; // Archived LaunchDeal
        }
        else { //2
            [self getDeactivatedLaunchDealList:searchedString] ; // Deactivated LaunchDeal
            addLaunchDealBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveLaunchDeal_ClickAction:(id)sender {
    
    if(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""]) {
        launchDealID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kLaunchDealAPI_ID];
    }
    else {
        launchDealID = [[launchDealsArray objectAtIndex:[sender tag]] valueForKey: kLaunchDealAPI_ID];
    }
    [self archiveLaunchDeal:launchDealID];
}

- (IBAction)deactivateLaunchDeal_ClickAction:(id)sender {
    if(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""]) {
        launchDealID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kLaunchDealAPI_ID];
    }
    else {
        launchDealID = [[launchDealsArray objectAtIndex:[sender tag]] valueForKey: kLaunchDealAPI_ID];
    }
    [self deactivateLaunchDeal:launchDealID];
}

- (IBAction)deleteLaunchDeal_ClickAction:(id)sender {
    if(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""])
        launchDealID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kLaunchDealAPI_ID];
    else
        launchDealID = [[launchDealsArray objectAtIndex:[sender tag]] valueForKey: kLaunchDealAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
        [self activateLaunchDeal:launchDealID];
    else
        [self deleteLaunchDeal:launchDealID];
}

- (IBAction)createLaunchDealButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LaunchDeals" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateLaunchDealIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeLaunchDeal_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""])
        launchDealID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kLaunchDealAPI_ID];
    else
        launchDealID = [[launchDealsArray objectAtIndex:[sender tag]] valueForKey: kLaunchDealAPI_ID];
    
    [self likeLaunchDeal:launchDealID];
}

- (IBAction)likeLaunchDealList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""])
        launchDealID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kLaunchDealAPI_ID];
    else
        launchDealID = [[launchDealsArray objectAtIndex:[sender tag]] valueForKey: kLaunchDealAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeLaunchDealList:launchDealID];
    }
}

- (IBAction)dislikeLaunchDeal_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""])
        launchDealID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kLaunchDealAPI_ID];
    else
        launchDealID = [[launchDealsArray objectAtIndex:[sender tag]] valueForKey: kLaunchDealAPI_ID];
    
    [self dislikeLaunchDeal:launchDealID];
}

- (IBAction)disLikeLaunchDealList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""])
        launchDealID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kLaunchDealAPI_ID];
    else
        launchDealID = [[launchDealsArray objectAtIndex:[sender tag]] valueForKey: kLaunchDealAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeLaunchDealList:launchDealID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kLaunchDealAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(launchDealsArray.count == totalItems)
                return launchDealsArray.count ;
            else
                return launchDealsArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kLaunchDealAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kLaunchDealAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kLaunchDealAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""]) {
            {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LaunchDeals] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kLaunchDealAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kLaunchDealAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kLaunchDealAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kLaunchDealAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kLaunchDealAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kLaunchDealAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find LaunchDeal
                    if (selectedSegment == SEARCH_LAUNCHDEAL_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // LaunchDeal/Invest
                    if (selectedSegment == MY_LAUNCHDEAL_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_LAUNCHDEAL_SELECTED) {
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
            if(indexPath.row == launchDealsArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LaunchDeals] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[launchDealsArray objectAtIndex:indexPath.row] valueForKey:kLaunchDealAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[launchDealsArray objectAtIndex:indexPath.row] valueForKey:kLaunchDealAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[launchDealsArray objectAtIndex:indexPath.row] valueForKey:kLaunchDealAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[launchDealsArray objectAtIndex:indexPath.row] valueForKey:kLaunchDealAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[launchDealsArray objectAtIndex:indexPath.row] valueForKey:kLaunchDealAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[launchDealsArray objectAtIndex:indexPath.row] valueForKey:kLaunchDealAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find LaunchDeal
                    if (selectedSegment == SEARCH_LAUNCHDEAL_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // LaunchDeal/Invest
                    if (selectedSegment == MY_LAUNCHDEAL_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_LAUNCHDEAL_SELECTED) {
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
        if (launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find LaunchDeal
                if (selectedSegment == SEARCH_LAUNCHDEAL_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_LAUNCHDEAL_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_LAUNCHDEAL_SELECTED || selectedSegment == DEACTIVATED_LAUNCHDEAL_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // LaunchDeal
                if (selectedSegment == MY_LAUNCHDEAL_SELECTED || selectedSegment == DEACTIVATED_LAUNCHDEAL_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == launchDealsArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find LaunchDeal
                    if (selectedSegment == SEARCH_LAUNCHDEAL_SELECTED)
                        return 120;
                    else if (selectedSegment == ADD_LAUNCHDEAL_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_LAUNCHDEAL_SELECTED || selectedSegment == DEACTIVATED_LAUNCHDEAL_SELECTED)
                            return 145;
                        else
                            return 120 ;
                    }
                }
                else { // LaunchDeal/Invest
                    if (selectedSegment == MY_LAUNCHDEAL_SELECTED || selectedSegment == DEACTIVATED_LAUNCHDEAL_SELECTED)
                        return 145;
                    else
                        return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == launchDealsArray.count) {
//            [self getMyLaunchDealListWithSearchText:searchedString] ; // My LaunchDeal
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array ;
    if (launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""])
        array = [searchResults mutableCopy] ;
    else
        array = [launchDealsArray mutableCopy] ;
    
    if(indexPath.row != array.count) {
        
        [UtilityClass setLaunchDealDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LaunchDeals" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditLaunchDealIdentifier] ;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
        
        [self.navigationController pushViewController:viewController animated:YES] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetLaunchDealViewEditing object:nil userInfo:dict];
    }
}

#pragma mark - Api Methods
-(void)getFindLaunchDealWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kLaunchDealAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kLaunchDealAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kLaunchDealAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchLaunchDealWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kLaunchDealAPI_LaunchDealList]) {
                    totalItems = [[responseDict valueForKey:kLaunchDealAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [launchDealsArray removeAllObjects];
                    
                    if(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                    }
                    else {
                        [launchDealsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                    }
                    lblNoLaunchDealAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoLaunchDealAvailable.hidden = false;
                if(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                }
                else {
                    launchDealsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = launchDealsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyLaunchDealListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kLaunchDealAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kLaunchDealAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kLaunchDealAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyLaunchDealListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kLaunchDealAPI_LaunchDealList]) {
                    totalItems = [[responseDict valueForKey:kLaunchDealAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [launchDealsArray removeAllObjects];
                    
                    if(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                    }
                    else {
                        [launchDealsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                    }
                    lblNoLaunchDealAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoLaunchDealAvailable.hidden = false;
                if(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                }
                else {
                    launchDealsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = launchDealsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveLaunchDealList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kLaunchDealAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kLaunchDealAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kLaunchDealAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveLaunchDealListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kLaunchDealAPI_LaunchDealList]) {
                    totalItems = [[responseDict valueForKey:kLaunchDealAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [launchDealsArray removeAllObjects];
                    
                    if(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                    }
                    else {
                        [launchDealsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                    }
                    lblNoLaunchDealAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoLaunchDealAvailable.hidden = false;
                if(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                }
                else {
                    launchDealsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = launchDealsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedLaunchDealList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kLaunchDealAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kLaunchDealAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kLaunchDealAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedLaunchDealListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kLaunchDealAPI_LaunchDealList]) {
                    totalItems = [[responseDict valueForKey:kLaunchDealAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [launchDealsArray removeAllObjects];
                    
                    if(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                    }
                    else {
                        [launchDealsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                    }
                    lblNoLaunchDealAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoLaunchDealAvailable.hidden = false;
                if(launchDealSearchController.active && ![launchDealSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                }
                else {
                    launchDealsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kLaunchDealAPI_LaunchDealList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = launchDealsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveLaunchDeal:(NSString *)launchDealId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kLaunchDealAPI_UserID] ;
        [dictParam setObject:launchDealId forKey:kLaunchDealAPI_LaunchDealID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveLaunchDealWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveLaunchDeal_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyLaunchDealListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateLaunchDeal:(NSString *)launchDealId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kLaunchDealAPI_UserID] ;
        [dictParam setObject:launchDealId forKey:kLaunchDealAPI_LaunchDealID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateLaunchDealWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedLaunchDealList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateLaunchDeal_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateLaunchDeal:(NSString *)launchDealId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kLaunchDealAPI_UserID] ;
        [dictParam setObject:launchDealId forKey:kLaunchDealAPI_LaunchDealID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateLaunchDealWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateLaunchDeal_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyLaunchDealListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteLaunchDeal:(NSString *)launchDealId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kLaunchDealAPI_UserID] ;
        [dictParam setObject:launchDealId forKey:kLaunchDealAPI_LaunchDealID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteLaunchDealWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteLaunchDeal_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyLaunchDealListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeLaunchDeal:(NSString *)launchDealId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kLaunchDealAPI_LikedBy] ;
        [dictParam setObject:launchDealId forKey:kLaunchDealAPI_LaunchDealID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeLaunchDealWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kLaunchDealAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kLaunchDealAPI_Dislikes]];
                
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

-(void)dislikeLaunchDeal:(NSString *)launchDealId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kLaunchDealAPI_DislikedBy] ;
        [dictParam setObject:launchDealId forKey:kLaunchDealAPI_LaunchDealID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeLaunchDealWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kLaunchDealAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kLaunchDealAPI_Dislikes]];
                
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

-(void)getLikeLaunchDealList:(NSString *)launchDealId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:launchDealId forKey:kLaunchDealAPI_LaunchDealID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kLaunchDealAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeLaunchDealListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kLaunchDealAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kLaunchDealAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kLaunchDealAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kLaunchDealAPI_UserList]] ;
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

-(void)getdisLikeLaunchDealList:(NSString *)launchDealId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:launchDealId forKey:kLaunchDealAPI_LaunchDealID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kLaunchDealAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeLaunchDealListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kLaunchDealAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kLaunchDealAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kLaunchDealAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kLaunchDealAPI_UserList]] ;
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
