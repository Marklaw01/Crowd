//
//  MyEarlyAdoptersViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyEarlyAdoptersViewController.h"

#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyEarlyAdoptersViewController ()

@end

@implementation MyEarlyAdoptersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_EarlyAdopter_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_EarlyAdopter_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find EarlyAdopter
    //        if (selectedSegment == SEARCH_SOFTWARE_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find EarlyAdopter
            if (selectedSegment == SEARCH_EARLY_ADOPTER_SELECTED) {
                [self getFindEarlyAdopterWithSearchText:searchedString];
            } else
                [self getMyEarlyAdopterListWithSearchText:searchedString];
        } else {// My EarlyAdopter
            if (selectedSegment == MY_EARLY_ADOPTER_SELECTED) {
                [self getMyEarlyAdopterListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_EARLY_ADOPTER_SELECTED) {
                [self getArchiveEarlyAdopterList:searchedString];
            } else {
                [self getDeactivatedEarlyAdopterList:searchedString];
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
    [self.segmentControlMyEarlyAdopters setTitleTextAttributes:attributes
                                              forState:UIControlStateNormal];
    [self.segmentControlSearchEarlyAdopters setTitleTextAttributes:attributes
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
    
    earlyAdoptersArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyEarlyAdopters.hidden = true;
    addEarlyAdopterBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchEarlyAdopters setSelectedSegmentIndex:SEARCH_EARLY_ADOPTER_SELECTED] ;
    [self.segmentControlMyEarlyAdopters setSelectedSegmentIndex:MY_EARLY_ADOPTER_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get My EarlyAdopter List
    [self getFindEarlyAdopterWithSearchText:searchedString];
}

-(void)configureSearchController {
    earlyAdopterSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    earlyAdopterSearchController.searchBar.placeholder = kSearchEarlyAdopterPlaceholder ;
    [earlyAdopterSearchController.searchBar sizeToFit] ;
    earlyAdopterSearchController.searchBar.text = searchedString;
    earlyAdopterSearchController.searchResultsUpdater = self ;
    earlyAdopterSearchController.dimsBackgroundDuringPresentation = NO ;
    earlyAdopterSearchController.definesPresentationContext = YES ;
    earlyAdopterSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = earlyAdopterSearchController.searchBar ;
    earlyAdopterSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [earlyAdoptersArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Early Adopter
        if (selectedSegment == SEARCH_EARLY_ADOPTER_SELECTED)
        [self getFindEarlyAdopterWithSearchText:searchedString] ; // Find Early Adopter
        else
        [self getMyEarlyAdopterListWithSearchText:searchedString] ; // My Early Adopter
    }
    else { // EarlyAdopter
        if (selectedSegment == MY_EARLY_ADOPTER_SELECTED)
        [self getMyEarlyAdopterListWithSearchText:searchedString] ; // My Early Adopter
        else if (selectedSegment == ARCHIVE_EARLY_ADOPTER_SELECTED)
        [self getArchiveEarlyAdopterList:searchedString] ; // Archived Early Adopter
        else
        [self getDeactivatedEarlyAdopterList:searchedString] ; // Deactivated Early Adopter
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [earlyAdoptersArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [earlyAdopterSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find EarlyAdopter
        if (selectedSegment == SEARCH_EARLY_ADOPTER_SELECTED)
        [self getFindEarlyAdopterWithSearchText:searchedString] ; // Find Early Adopter
        else
        [self getMyEarlyAdopterListWithSearchText:searchedString] ; // My Early Adopter
    }
    else { // EarlyAdopter/
        if (selectedSegment == MY_EARLY_ADOPTER_SELECTED)
        [self getMyEarlyAdopterListWithSearchText:searchedString] ; // My Early Adopter
        else if (selectedSegment == ARCHIVE_EARLY_ADOPTER_SELECTED)
        [self getArchiveEarlyAdopterList:searchedString] ; // Archived Early Adopter
        else
        [self getDeactivatedEarlyAdopterList:searchedString] ; // Deactivated Early Adopter
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [earlyAdoptersArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find EarlyAdopter
        selectedSegment = self.segmentControlSearchEarlyAdopters.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_EARLY_ADOPTER_SELECTED) { //0
            [self getFindEarlyAdopterWithSearchText:searchedString] ; // Find EarlyAdopter
            self.segmentControlMyEarlyAdopters.hidden = true;
            addEarlyAdopterBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyEarlyAdopterListWithSearchText:searchedString] ; // My EarlyAdopter
            [self.segmentControlMyEarlyAdopters setSelectedSegmentIndex:MY_EARLY_ADOPTER_SELECTED] ;
            self.segmentControlMyEarlyAdopters.hidden = false;
            addEarlyAdopterBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // EarlyAdopter/
        selectedSegment = self.segmentControlMyEarlyAdopters.selectedSegmentIndex;
        self.segmentControlMyEarlyAdopters.hidden = false;
        addEarlyAdopterBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_EARLY_ADOPTER_SELECTED) { //0
            [self getMyEarlyAdopterListWithSearchText:searchedString] ; // My EarlyAdopter
            addEarlyAdopterBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_EARLY_ADOPTER_SELECTED) { //1
            addEarlyAdopterBtn.hidden = true;
            [self getArchiveEarlyAdopterList:searchedString ] ; // Archived EarlyAdopter
        }
        else { //2
            [self getDeactivatedEarlyAdopterList:searchedString] ; // Deactivated EarlyAdopter
            addEarlyAdopterBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveEarlyAdopter_ClickAction:(id)sender {
    
    if(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""]) {
        earlyAdopterID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kEarlyAdopterAPI_ID];
    }
    else {
        earlyAdopterID = [[earlyAdoptersArray objectAtIndex:[sender tag]] valueForKey: kEarlyAdopterAPI_ID];
    }
    [self archiveEarlyAdopter:earlyAdopterID];
}

- (IBAction)deactivateEarlyAdopter_ClickAction:(id)sender {
    if(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""]) {
        earlyAdopterID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kEarlyAdopterAPI_ID];
    }
    else {
        earlyAdopterID = [[earlyAdoptersArray objectAtIndex:[sender tag]] valueForKey: kEarlyAdopterAPI_ID];
    }
    [self deactivateEarlyAdopter:earlyAdopterID];
}

- (IBAction)deleteEarlyAdopter_ClickAction:(id)sender {
    if(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""])
    earlyAdopterID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kEarlyAdopterAPI_ID];
    else
    earlyAdopterID = [[earlyAdoptersArray objectAtIndex:[sender tag]] valueForKey: kEarlyAdopterAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
    [self activateEarlyAdopter:earlyAdopterID];
    else
    [self deleteEarlyAdopter:earlyAdopterID];
}

- (IBAction)createEarlyAdopterButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"EarlyAdopters" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateEarlyAdopterIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeEarlyAdopter_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""])
    earlyAdopterID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kEarlyAdopterAPI_ID];
    else
    earlyAdopterID = [[earlyAdoptersArray objectAtIndex:[sender tag]] valueForKey: kEarlyAdopterAPI_ID];
    
    [self likeEarlyAdopter:earlyAdopterID];
}

- (IBAction)likeEarlyAdopterList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""])
    earlyAdopterID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kEarlyAdopterAPI_ID];
    else
    earlyAdopterID = [[earlyAdoptersArray objectAtIndex:[sender tag]] valueForKey: kEarlyAdopterAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeEarlyAdopterList:earlyAdopterID];
    }
}

- (IBAction)dislikeEarlyAdopter_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""])
    earlyAdopterID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kEarlyAdopterAPI_ID];
    else
    earlyAdopterID = [[earlyAdoptersArray objectAtIndex:[sender tag]] valueForKey: kEarlyAdopterAPI_ID];
    
    [self dislikeEarlyAdopter:earlyAdopterID];
}

- (IBAction)disLikeEarlyAdopterList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""])
    earlyAdopterID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kEarlyAdopterAPI_ID];
    else
    earlyAdopterID = [[earlyAdoptersArray objectAtIndex:[sender tag]] valueForKey: kEarlyAdopterAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdislikeEarlyAdopterList:earlyAdopterID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kEarlyAdopterAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(earlyAdoptersArray.count == totalItems)
                return earlyAdoptersArray.count ;
            else
                return earlyAdoptersArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kEarlyAdopterAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kEarlyAdopterAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kEarlyAdopterAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        
        if (earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""]) {
            FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_EarlyAdopters] ;
            
            cell.btnLikeCount.tag = indexPath.row;
            cell.btnDislikeCount.tag = indexPath.row;
            cell.btnLike.tag = indexPath.row;
            cell.btnDislike.tag = indexPath.row;
            cell.btnArchive.tag = indexPath.row;
            cell.btnDeactivate.tag = indexPath.row;
            cell.btnDelete.tag = indexPath.row;
            
            cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kEarlyAdopterAPI_EarlyAdopter_Title]] ;
            cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kEarlyAdopterAPI_StartDate]];
            cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kEarlyAdopterAPI_Description]];
            
            [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kEarlyAdopterAPI_EarlyAdopter_Likes]] forState:UIControlStateNormal];
            [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kEarlyAdopterAPI_EarlyAdopter_Dislikes]] forState:UIControlStateNormal];
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kEarlyAdopterAPI_EarlyAdopter_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            
            cell.imgView.layer.cornerRadius = 20;
            cell.imgView.clipsToBounds = YES;
            
            if (selectedSegmentControl == 100) { // Find EarlyAdopter
                if (selectedSegment == SEARCH_EARLY_ADOPTER_SELECTED) {
                    cell.btnArchive.hidden = true;
                    cell.btnDeactivate.hidden = true;
                    cell.btnDelete.hidden = true;
                } else {
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                }
            }
            else { // EarlyAdopter/
                if (selectedSegment == MY_EARLY_ADOPTER_SELECTED) {
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                    [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                    cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                } else if (selectedSegment == DEACTIVATED_EARLY_ADOPTER_SELECTED) {
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
            if(indexPath.row == earlyAdoptersArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_EarlyAdopters] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[earlyAdoptersArray objectAtIndex:indexPath.row] valueForKey:kEarlyAdopterAPI_EarlyAdopter_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[earlyAdoptersArray objectAtIndex:indexPath.row] valueForKey:kEarlyAdopterAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[earlyAdoptersArray objectAtIndex:indexPath.row] valueForKey:kEarlyAdopterAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[earlyAdoptersArray objectAtIndex:indexPath.row] valueForKey:kEarlyAdopterAPI_EarlyAdopter_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[earlyAdoptersArray objectAtIndex:indexPath.row] valueForKey:kEarlyAdopterAPI_EarlyAdopter_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[earlyAdoptersArray objectAtIndex:indexPath.row] valueForKey:kEarlyAdopterAPI_EarlyAdopter_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find EarlyAdopter
                    if (selectedSegment == SEARCH_EARLY_ADOPTER_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // EarlyAdopter/
                    if (selectedSegment == MY_EARLY_ADOPTER_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_EARLY_ADOPTER_SELECTED) {
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
        if (earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find EarlyAdopter
                if (selectedSegment == SEARCH_EARLY_ADOPTER_SELECTED)
                return 110;
                else if (selectedSegment == ADD_EARLY_ADOPTER_SELECTED)
                return 145;
                else {
                    if (selectedSegment == MY_EARLY_ADOPTER_SELECTED || selectedSegment == DEACTIVATED_EARLY_ADOPTER_SELECTED)
                    return 145;
                    else
                    return 110 ;
                }
            }
            else { // EarlyAdopter/
                if (selectedSegment == MY_EARLY_ADOPTER_SELECTED || selectedSegment == DEACTIVATED_EARLY_ADOPTER_SELECTED)
                return 145;
                else
                return 110 ;
            }
        }
        else {
            if(indexPath.row == earlyAdoptersArray.count)
            return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find EarlyAdopter
                    if (selectedSegment == SEARCH_EARLY_ADOPTER_SELECTED)
                    return 120;
                    else if (selectedSegment == ADD_EARLY_ADOPTER_SELECTED)
                    return 145;
                    else {
                        if (selectedSegment == MY_EARLY_ADOPTER_SELECTED || selectedSegment == DEACTIVATED_EARLY_ADOPTER_SELECTED)
                        return 145;
                        else
                        return 120 ;
                    }
                }
                else { // EarlyAdopter
                    if (selectedSegment == MY_EARLY_ADOPTER_SELECTED || selectedSegment == DEACTIVATED_EARLY_ADOPTER_SELECTED)
                    return 145;
                    else
                    return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == earlyAdoptersArray.count) {
//            [self getMyEarlyAdopterListWithSearchText:searchedString] ; // My EarlyAdopter
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array ;
    if (earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""])
    array = [searchResults mutableCopy] ;
    else
    array = [earlyAdoptersArray mutableCopy] ;
    
    if(indexPath.row != array.count) {
        
        [UtilityClass setEarlyAdopterDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"EarlyAdopters" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditEarlyAdopterIdentifier] ;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
        
        [self.navigationController pushViewController:viewController animated:YES] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetEarlyAdopterViewEditing object:nil userInfo:dict];
    }
}

#pragma mark - Api Methods
-(void)getFindEarlyAdopterWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEarlyAdopterAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kEarlyAdopterAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kEarlyAdopterAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchEarlyAdoptersWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]) {
                    totalItems = [[responseDict valueForKey:kEarlyAdopterAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [earlyAdoptersArray removeAllObjects];
                    
                    if(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                    }
                    else {
                        [earlyAdoptersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                    }
                    lblNoEarlyAdopterAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;

                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoEarlyAdopterAvailable.hidden = false;
                if(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                }
                else {
                    earlyAdoptersArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = earlyAdoptersArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyEarlyAdopterListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEarlyAdopterAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kEarlyAdopterAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kEarlyAdopterAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyEarlyAdoptersListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]) {
                    totalItems = [[responseDict valueForKey:kEarlyAdopterAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [earlyAdoptersArray removeAllObjects];
                    
                    if(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                    }
                    else {
                        [earlyAdoptersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                    }
                    lblNoEarlyAdopterAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoEarlyAdopterAvailable.hidden = false;
                if(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                }
                else {
                    earlyAdoptersArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = earlyAdoptersArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveEarlyAdopterList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEarlyAdopterAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kEarlyAdopterAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kEarlyAdopterAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveEarlyAdoptersListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]) {
                    totalItems = [[responseDict valueForKey:kEarlyAdopterAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [earlyAdoptersArray removeAllObjects];
                    
                    if(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                    }
                    else {
                        [earlyAdoptersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                    }
                    lblNoEarlyAdopterAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;

                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoEarlyAdopterAvailable.hidden = false;
                if(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                }
                else {
                    earlyAdoptersArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = earlyAdoptersArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedEarlyAdopterList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEarlyAdopterAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kEarlyAdopterAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kEarlyAdopterAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedEarlyAdoptersListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]) {
                    totalItems = [[responseDict valueForKey:kEarlyAdopterAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [earlyAdoptersArray removeAllObjects];
                    
                    if(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                    }
                    else {
                        [earlyAdoptersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                    }
                    lblNoEarlyAdopterAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;

                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoEarlyAdopterAvailable.hidden = false;
                if(earlyAdopterSearchController.active && ![earlyAdopterSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                }
                else {
                    earlyAdoptersArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopterList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = earlyAdoptersArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveEarlyAdopter:(NSString *)earlyAdopterId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEarlyAdopterAPI_UserID] ;
        [dictParam setObject:earlyAdopterId forKey:kEarlyAdopterAPI_EarlyAdopterID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveEarlyAdopterWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveEarlyAdopter_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyEarlyAdopterListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateEarlyAdopter:(NSString *)earlyAdopterId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEarlyAdopterAPI_UserID] ;
        [dictParam setObject:earlyAdopterId forKey:kEarlyAdopterAPI_EarlyAdopterID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateEarlyAdopterWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedEarlyAdopterList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateEarlyAdopter_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateEarlyAdopter:(NSString *)earlyAdopterId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEarlyAdopterAPI_UserID] ;
        [dictParam setObject:earlyAdopterId forKey:kEarlyAdopterAPI_EarlyAdopterID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateEarlyAdopterWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateEarlyAdopter_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyEarlyAdopterListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteEarlyAdopter:(NSString *)earlyAdopterId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEarlyAdopterAPI_UserID] ;
        [dictParam setObject:earlyAdopterId forKey:kEarlyAdopterAPI_EarlyAdopterID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteEarlyAdopterWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteEarlyAdopter_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyEarlyAdopterListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeEarlyAdopter:(NSString *)earlyAdopterId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEarlyAdopterAPI_EarlyAdopter_LikedBy] ;
        [dictParam setObject:earlyAdopterId forKey:kEarlyAdopterAPI_EarlyAdopterID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeEarlyAdopterWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopter_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopter_Dislikes]];
                
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

-(void)dislikeEarlyAdopter:(NSString *)earlyAdopterId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEarlyAdopterAPI_EarlyAdopter_DislikedBy] ;
        [dictParam setObject:earlyAdopterId forKey:kEarlyAdopterAPI_EarlyAdopterID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeEarlyAdopterWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopter_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kEarlyAdopterAPI_EarlyAdopter_Dislikes]];
                
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

-(void)getLikeEarlyAdopterList:(NSString *)earlyAdopterId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:earlyAdopterId forKey:kEarlyAdopterAPI_EarlyAdopterID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kEarlyAdopterAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeEarlyAdopterListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kEarlyAdopterAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kEarlyAdopterAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kEarlyAdopterAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kEarlyAdopterAPI_UserList]] ;
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

-(void)getdislikeEarlyAdopterList:(NSString *)earlyAdopterId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:earlyAdopterId forKey:kEarlyAdopterAPI_EarlyAdopterID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kEarlyAdopterAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeEarlyAdopterListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kEarlyAdopterAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kEarlyAdopterAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kEarlyAdopterAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kEarlyAdopterAPI_UserList]] ;
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
