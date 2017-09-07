//
//  MyInformationViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyInformationViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyInformationViewController ()

@end

@implementation MyInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_Information_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_Information_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find Information
    //        if (selectedSegment == SEARCH_INFORMATION_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find Information
            if (selectedSegment == SEARCH_INFORMATION_SELECTED) {
                [self getFindInformationWithSearchText:searchedString];
            } else
                [self getMyInformationListWithSearchText:searchedString];
        } else {// My Information
            if (selectedSegment == MY_INFORMATION_SELECTED) {
                [self getMyInformationListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_INFORMATION_SELECTED) {
                [self getArchiveInformationList:searchedString];
            } else {
                [self getDeactivatedInformationList:searchedString];
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
    [self.segmentControlMyInformation setTitleTextAttributes:attributes
                                                    forState:UIControlStateNormal];
    [self.segmentControlSearchInformation setTitleTextAttributes:attributes
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
    
    informationArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyInformation.hidden = true;
    addInformationBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchInformation setSelectedSegmentIndex:SEARCH_INFORMATION_SELECTED] ;
    [self.segmentControlMyInformation setSelectedSegmentIndex:MY_INFORMATION_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get My Information List
    [self getFindInformationWithSearchText:searchedString];
}

-(void)configureSearchController {
    informationSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    informationSearchController.searchBar.placeholder = kSearchInformationPlaceholder ;
    [informationSearchController.searchBar sizeToFit] ;
    informationSearchController.searchBar.text = searchedString;
    informationSearchController.searchResultsUpdater = self ;
    informationSearchController.dimsBackgroundDuringPresentation = NO ;
    informationSearchController.definesPresentationContext = YES ;
    informationSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = informationSearchController.searchBar ;
    informationSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [informationArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Information
        if (selectedSegment == SEARCH_INFORMATION_SELECTED)
            [self getFindInformationWithSearchText:searchedString] ; // Find Information
        else
            [self getMyInformationListWithSearchText:searchedString] ; // My Information
    }
    else { // Information
        if (selectedSegment == MY_INFORMATION_SELECTED)
            [self getMyInformationListWithSearchText:searchedString] ; // My Information
        else if (selectedSegment == ARCHIVE_INFORMATION_SELECTED)
            [self getArchiveInformationList:searchedString] ; // Archived Information
        else
            [self getDeactivatedInformationList:searchedString] ; // Deactivated Information
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [informationArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [informationSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Information
        if (selectedSegment == SEARCH_INFORMATION_SELECTED)
            [self getFindInformationWithSearchText:searchedString] ; // Find Information
        else
            [self getMyInformationListWithSearchText:searchedString] ; // My Information
    }
    else { // Information
        if (selectedSegment == MY_INFORMATION_SELECTED)
            [self getMyInformationListWithSearchText:searchedString] ; // My Information
        else if (selectedSegment == ARCHIVE_INFORMATION_SELECTED)
            [self getArchiveInformationList:searchedString] ; // Archived Information
        else
            [self getDeactivatedInformationList:searchedString] ; // Deactivated Information
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [informationArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find Information
        selectedSegment = self.segmentControlSearchInformation.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_INFORMATION_SELECTED) { //0
            [self getFindInformationWithSearchText:searchedString] ; // Find Information
            self.segmentControlMyInformation.hidden = true;
            addInformationBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyInformationListWithSearchText:searchedString] ; // My Information
            [self.segmentControlMyInformation setSelectedSegmentIndex:MY_INFORMATION_SELECTED] ;
            self.segmentControlMyInformation.hidden = false;
            addInformationBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // Information
        selectedSegment = self.segmentControlMyInformation.selectedSegmentIndex;
        self.segmentControlMyInformation.hidden = false;
        addInformationBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_INFORMATION_SELECTED) { //0
            [self getMyInformationListWithSearchText:searchedString] ; // My Information
            addInformationBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_INFORMATION_SELECTED) { //1
            addInformationBtn.hidden = true;
            [self getArchiveInformationList:searchedString ] ; // Archived Information
        }
        else { //2
            [self getDeactivatedInformationList:searchedString] ; // Deactivated Information
            addInformationBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveInformation_ClickAction:(id)sender {
    
    if(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""]) {
        informationID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kInformationAPI_ID];
    }
    else {
        informationID = [[informationArray objectAtIndex:[sender tag]] valueForKey: kInformationAPI_ID];
    }
    [self archiveInformation:informationID];
}

- (IBAction)deactivateInformation_ClickAction:(id)sender {
    if(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""]) {
        informationID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kInformationAPI_ID];
    }
    else {
        informationID = [[informationArray objectAtIndex:[sender tag]] valueForKey: kInformationAPI_ID];
    }
    [self deactivateInformation:informationID];
}

- (IBAction)deleteInformation_ClickAction:(id)sender {
    if(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""])
        informationID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kInformationAPI_ID];
    else
        informationID = [[informationArray objectAtIndex:[sender tag]] valueForKey: kInformationAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
        [self activateInformation:informationID];
    else
        [self deleteInformation:informationID];
}

- (IBAction)createInformationButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Information" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateInformationIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeInformation_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""])
        informationID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kInformationAPI_ID];
    else
        informationID = [[informationArray objectAtIndex:[sender tag]] valueForKey: kInformationAPI_ID];
    
    [self likeInformation:informationID];
}

- (IBAction)likeInformationList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""])
        informationID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kInformationAPI_ID];
    else
        informationID = [[informationArray objectAtIndex:[sender tag]] valueForKey: kInformationAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeInformationList:informationID];
    }
}

- (IBAction)dislikeInformation_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""])
        informationID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kInformationAPI_ID];
    else
        informationID = [[informationArray objectAtIndex:[sender tag]] valueForKey: kInformationAPI_ID];
    
    [self dislikeInformation:informationID];
}

- (IBAction)disLikeInformationList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""])
        informationID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kInformationAPI_ID];
    else
        informationID = [[informationArray objectAtIndex:[sender tag]] valueForKey: kInformationAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeInformationList:informationID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kInformationAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(informationArray.count == totalItems)
                return informationArray.count ;
            else
                return informationArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kInformationAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kInformationAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kInformationAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""]) {
            {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Information] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kInformationAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kInformationAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kInformationAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kInformationAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kInformationAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kInformationAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Information
                    if (selectedSegment == SEARCH_INFORMATION_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // My Information
                    if (selectedSegment == MY_INFORMATION_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_INFORMATION_SELECTED) {
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
            if(indexPath.row == informationArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Information] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[informationArray objectAtIndex:indexPath.row] valueForKey:kInformationAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[informationArray objectAtIndex:indexPath.row] valueForKey:kInformationAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[informationArray objectAtIndex:indexPath.row] valueForKey:kInformationAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[informationArray objectAtIndex:indexPath.row] valueForKey:kInformationAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[informationArray objectAtIndex:indexPath.row] valueForKey:kInformationAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[informationArray objectAtIndex:indexPath.row] valueForKey:kInformationAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Information
                    if (selectedSegment == SEARCH_INFORMATION_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Information
                    if (selectedSegment == MY_INFORMATION_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_INFORMATION_SELECTED) {
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
        if (informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find Information
                if (selectedSegment == SEARCH_INFORMATION_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_INFORMATION_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_INFORMATION_SELECTED || selectedSegment == DEACTIVATED_INFORMATION_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // Information
                if (selectedSegment == MY_INFORMATION_SELECTED || selectedSegment == DEACTIVATED_INFORMATION_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == informationArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find Information
                    if (selectedSegment == SEARCH_INFORMATION_SELECTED)
                        return 120;
                    else if (selectedSegment == ADD_INFORMATION_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_INFORMATION_SELECTED || selectedSegment == DEACTIVATED_INFORMATION_SELECTED)
                            return 145;
                        else
                            return 120 ;
                    }
                }
                else { // Information
                    if (selectedSegment == MY_INFORMATION_SELECTED || selectedSegment == DEACTIVATED_INFORMATION_SELECTED)
                        return 145;
                    else
                        return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == informationArray.count) {
//            [self getMyInformationListWithSearchText:searchedString] ; // My Information
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array ;
    if (informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""])
        array = [searchResults mutableCopy] ;
    else
        array = [informationArray mutableCopy] ;
    
    if(indexPath.row != array.count) {
        
        [UtilityClass setInformationDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Information" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditInformationIdentifier] ;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
        
        [self.navigationController pushViewController:viewController animated:YES] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetInformationViewEditing object:nil userInfo:dict];
    }
}

#pragma mark - Api Methods
-(void)getFindInformationWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kInformationAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kInformationAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kInformationAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchInformationWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kInformationAPI_InformationList]) {
                    totalItems = [[responseDict valueForKey:kInformationAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [informationArray removeAllObjects];
                    
                    if(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kInformationAPI_InformationList]] ;
                    }
                    else {
                        [informationArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kInformationAPI_InformationList]] ;
                    }
                    lblNoInformationAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kInformationAPI_InformationList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoInformationAvailable.hidden = false;
                if(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kInformationAPI_InformationList]] ;
                }
                else {
                    informationArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kInformationAPI_InformationList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = informationArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyInformationListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kInformationAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kInformationAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kInformationAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyInformationListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kInformationAPI_InformationList]) {
                    totalItems = [[responseDict valueForKey:kInformationAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [informationArray removeAllObjects];
                    
                    if(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kInformationAPI_InformationList]] ;
                    }
                    else {
                        [informationArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kInformationAPI_InformationList]] ;
                    }
                    lblNoInformationAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kInformationAPI_InformationList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoInformationAvailable.hidden = false;
                if(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kInformationAPI_InformationList]] ;
                }
                else {
                    informationArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kInformationAPI_InformationList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = informationArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveInformationList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kInformationAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kInformationAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kInformationAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveInformationListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kInformationAPI_InformationList]) {
                    totalItems = [[responseDict valueForKey:kInformationAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [informationArray removeAllObjects];
                    
                    if(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kInformationAPI_InformationList]] ;
                    }
                    else {
                        [informationArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kInformationAPI_InformationList]] ;
                    }
                    lblNoInformationAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kInformationAPI_InformationList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoInformationAvailable.hidden = false;
                if(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kInformationAPI_InformationList]] ;
                }
                else {
                    informationArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kInformationAPI_InformationList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = informationArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedInformationList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kInformationAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kInformationAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kInformationAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedInformationListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kInformationAPI_InformationList]) {
                    totalItems = [[responseDict valueForKey:kInformationAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [informationArray removeAllObjects];
                    
                    if(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kInformationAPI_InformationList]] ;
                    }
                    else {
                        [informationArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kInformationAPI_InformationList]] ;
                    }
                    lblNoInformationAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kInformationAPI_InformationList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoInformationAvailable.hidden = false;
                if(informationSearchController.active && ![informationSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kInformationAPI_InformationList]] ;
                }
                else {
                    informationArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kInformationAPI_InformationList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = informationArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveInformation:(NSString *)informationId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kInformationAPI_UserID] ;
        [dictParam setObject:informationId forKey:kInformationAPI_InformationID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveInformationWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveInformation_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyInformationListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateInformation:(NSString *)informationId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kInformationAPI_UserID] ;
        [dictParam setObject:informationId forKey:kInformationAPI_InformationID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateInformationWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedInformationList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateInformation_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateInformation:(NSString *)informationId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kInformationAPI_UserID] ;
        [dictParam setObject:informationId forKey:kInformationAPI_InformationID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateInformationWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateInformation_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyInformationListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteInformation:(NSString *)informationId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kInformationAPI_UserID] ;
        [dictParam setObject:informationId forKey:kInformationAPI_InformationID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteInformationWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteInformation_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyInformationListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeInformation:(NSString *)informationId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kInformationAPI_LikedBy] ;
        [dictParam setObject:informationId forKey:kInformationAPI_InformationID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeInformationWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kInformationAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kInformationAPI_Dislikes]];
                
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

-(void)dislikeInformation:(NSString *)informationId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kInformationAPI_DislikedBy] ;
        [dictParam setObject:informationId forKey:kInformationAPI_InformationID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeInformationWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kInformationAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kInformationAPI_Dislikes]];
                
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

-(void)getLikeInformationList:(NSString *)informationId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:informationId forKey:kInformationAPI_InformationID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kInformationAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeInformationListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kInformationAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kInformationAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kInformationAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kInformationAPI_UserList]] ;
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

-(void)getdisLikeInformationList:(NSString *)informationId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:informationId forKey:kInformationAPI_InformationID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kInformationAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeInformationListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kInformationAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kInformationAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kInformationAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kInformationAPI_UserList]] ;
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
