//
//  MySoftwaresViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MySoftwaresViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MySoftwaresViewController ()

@end

@implementation MySoftwaresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_Software_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_Software_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find Software
    //        if (selectedSegment == SEARCH_SOFTWARE_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find Software
            if (selectedSegment == SEARCH_SOFTWARE_SELECTED) {
                [self getFindSoftwareWithSearchText:searchedString];
            } else
                [self getMySoftwareListWithSearchText:searchedString];
        } else {// My Software
            if (selectedSegment == MY_SOFTWARE_SELECTED) {
                [self getMySoftwareListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_SOFTWARE_SELECTED) {
                [self getArchiveSoftwareList:searchedString];
            } else {
                [self getDeactivatedSoftwareList:searchedString];
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
    [self.segmentControlMySoftwares setTitleTextAttributes:attributes
                                                  forState:UIControlStateNormal];
    [self.segmentControlSearchSoftwares setTitleTextAttributes:attributes
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
    
    softwaresArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMySoftwares.hidden = true;
    addSoftwareBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchSoftwares setSelectedSegmentIndex:SEARCH_SOFTWARE_SELECTED] ;
    [self.segmentControlMySoftwares setSelectedSegmentIndex:MY_SOFTWARE_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get Software List
    [self getFindSoftwareWithSearchText:searchedString];
}

-(void)configureSearchController {
    softwareSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    softwareSearchController.searchBar.placeholder = kSearchSoftwarePlaceholder ;
    [softwareSearchController.searchBar sizeToFit] ;
    softwareSearchController.searchBar.text = searchedString;
    softwareSearchController.searchResultsUpdater = self ;
    softwareSearchController.dimsBackgroundDuringPresentation = NO ;
    softwareSearchController.definesPresentationContext = YES ;
    softwareSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = softwareSearchController.searchBar ;
    softwareSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [softwaresArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Software
        if (selectedSegment == SEARCH_SOFTWARE_SELECTED)
            [self getFindSoftwareWithSearchText:searchedString] ; // Find Software
        else
            [self getMySoftwareListWithSearchText:searchedString] ; // My Software
    }
    else { // Software/Invest
        if (selectedSegment == MY_SOFTWARE_SELECTED)
            [self getMySoftwareListWithSearchText:searchedString] ; // My Software
        else if (selectedSegment == ARCHIVE_SOFTWARE_SELECTED)
            [self getArchiveSoftwareList:searchedString] ; // Archived Software
        else
            [self getDeactivatedSoftwareList:searchedString] ; // Deactivated Software
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [softwaresArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [softwareSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Software
        if (selectedSegment == SEARCH_SOFTWARE_SELECTED)
            [self getFindSoftwareWithSearchText:searchedString] ; // Find Software
        else
            [self getMySoftwareListWithSearchText:searchedString] ; // My Software
    }
    else { // Software/Invest
        if (selectedSegment == MY_SOFTWARE_SELECTED)
            [self getMySoftwareListWithSearchText:searchedString] ; // My Software
        else if (selectedSegment == ARCHIVE_SOFTWARE_SELECTED)
            [self getArchiveSoftwareList:searchedString] ; // Archived Software
        else
            [self getDeactivatedSoftwareList:searchedString] ; // Deactivated Software
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [softwaresArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find Software
        selectedSegment = self.segmentControlSearchSoftwares.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_SOFTWARE_SELECTED) { //0
            [self getFindSoftwareWithSearchText:searchedString] ; // Find Software
            self.segmentControlMySoftwares.hidden = true;
            addSoftwareBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMySoftwareListWithSearchText:searchedString] ; // My Software
            [self.segmentControlMySoftwares setSelectedSegmentIndex:MY_SOFTWARE_SELECTED] ;
            self.segmentControlMySoftwares.hidden = false;
            addSoftwareBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // Software/Invest
        selectedSegment = self.segmentControlMySoftwares.selectedSegmentIndex;
        self.segmentControlMySoftwares.hidden = false;
        addSoftwareBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_SOFTWARE_SELECTED) { //0
            [self getMySoftwareListWithSearchText:searchedString] ; // My Software
            addSoftwareBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_SOFTWARE_SELECTED) { //1
            addSoftwareBtn.hidden = true;
            [self getArchiveSoftwareList:searchedString ] ; // Archived Software
        }
        else { //2
            [self getDeactivatedSoftwareList:searchedString] ; // Deactivated Software
            addSoftwareBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveSoftware_ClickAction:(id)sender {
    
    if(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""]) {
        softwareID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kSoftwareAPI_ID];
    }
    else {
        softwareID = [[softwaresArray objectAtIndex:[sender tag]] valueForKey: kSoftwareAPI_ID];
    }
    [self archiveSoftware:softwareID];
}

- (IBAction)deactivateSoftware_ClickAction:(id)sender {
    if(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""]) {
        softwareID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kSoftwareAPI_ID];
    }
    else {
        softwareID = [[softwaresArray objectAtIndex:[sender tag]] valueForKey: kSoftwareAPI_ID];
    }
    [self deactivateSoftware:softwareID];
}

- (IBAction)deleteSoftware_ClickAction:(id)sender {
    if(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""])
        softwareID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kSoftwareAPI_ID];
    else
        softwareID = [[softwaresArray objectAtIndex:[sender tag]] valueForKey: kSoftwareAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
        [self activateSoftware:softwareID];
    else
        [self deleteSoftware:softwareID];
}

- (IBAction)createSoftwareButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Softwares" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateSoftwareIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeSoftware_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""])
        softwareID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kSoftwareAPI_ID];
    else
        softwareID = [[softwaresArray objectAtIndex:[sender tag]] valueForKey: kSoftwareAPI_ID];
    
    [self likeSoftware:softwareID];
}

- (IBAction)likeSoftwareList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""])
        softwareID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kSoftwareAPI_ID];
    else
        softwareID = [[softwaresArray objectAtIndex:[sender tag]] valueForKey: kSoftwareAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeSoftwareList:softwareID];
    }
}

- (IBAction)dislikeSoftware_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""])
        softwareID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kSoftwareAPI_ID];
    else
        softwareID = [[softwaresArray objectAtIndex:[sender tag]] valueForKey: kSoftwareAPI_ID];
    
    [self dislikeSoftware:softwareID];
}

- (IBAction)disLikeSoftwareList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""])
        softwareID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kSoftwareAPI_ID];
    else
        softwareID = [[softwaresArray objectAtIndex:[sender tag]] valueForKey: kSoftwareAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeSoftwareList:softwareID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kSoftwareAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(softwaresArray.count == totalItems)
                return softwaresArray.count ;
            else
                return softwaresArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kSoftwareAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kSoftwareAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kSoftwareAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""]) {
            {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Softwares] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kSoftwareAPI_Software_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kSoftwareAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kSoftwareAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kSoftwareAPI_Software_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kSoftwareAPI_Software_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kSoftwareAPI_Software_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Software
                    if (selectedSegment == SEARCH_SOFTWARE_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Software/Invest
                    if (selectedSegment == MY_SOFTWARE_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_SOFTWARE_SELECTED) {
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
            if(indexPath.row == softwaresArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Softwares] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[softwaresArray objectAtIndex:indexPath.row] valueForKey:kSoftwareAPI_Software_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[softwaresArray objectAtIndex:indexPath.row] valueForKey:kSoftwareAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[softwaresArray objectAtIndex:indexPath.row] valueForKey:kSoftwareAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[softwaresArray objectAtIndex:indexPath.row] valueForKey:kSoftwareAPI_Software_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[softwaresArray objectAtIndex:indexPath.row] valueForKey:kSoftwareAPI_Software_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[softwaresArray objectAtIndex:indexPath.row] valueForKey:kSoftwareAPI_Software_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Software
                    if (selectedSegment == SEARCH_SOFTWARE_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Software/Invest
                    if (selectedSegment == MY_SOFTWARE_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_SOFTWARE_SELECTED) {
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
        if (softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find Software
                if (selectedSegment == SEARCH_SOFTWARE_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_SOFTWARE_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_SOFTWARE_SELECTED || selectedSegment == DEACTIVATED_SOFTWARE_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // Software
                if (selectedSegment == MY_SOFTWARE_SELECTED || selectedSegment == DEACTIVATED_SOFTWARE_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == softwaresArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find Software
                    if (selectedSegment == SEARCH_SOFTWARE_SELECTED)
                        return 120;
                    else if (selectedSegment == ADD_SOFTWARE_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_SOFTWARE_SELECTED || selectedSegment == DEACTIVATED_SOFTWARE_SELECTED)
                            return 145;
                        else
                            return 120 ;
                    }
                }
                else { // Software/Invest
                    if (selectedSegment == MY_SOFTWARE_SELECTED || selectedSegment == DEACTIVATED_SOFTWARE_SELECTED)
                        return 145;
                    else
                        return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == softwaresArray.count) {
//            [self getMySoftwareListWithSearchText:searchedString] ; // My Software
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblView) {
        
        NSMutableArray *array ;
        if (softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""])
            array = [searchResults mutableCopy] ;
        else
            array = [softwaresArray mutableCopy] ;
        
        if(indexPath.row != array.count) {
            
            [UtilityClass setSoftwareDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Softwares" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditSoftwareIdentifier] ;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
            
            [self.navigationController pushViewController:viewController animated:YES] ;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetSoftwareViewEditing object:nil userInfo:dict];
        }
    }
}

#pragma mark - Api Methods
-(void)getFindSoftwareWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSoftwareAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kSoftwareAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kSoftwareAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchSoftwaresWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kSoftwareAPI_SoftwareList]) {
                    totalItems = [[responseDict valueForKey:kSoftwareAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [softwaresArray removeAllObjects];
                    
                    if(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                    }
                    else {
                        [softwaresArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                    }
                    lblNoSoftwareAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoSoftwareAvailable.hidden = false;
                if(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                }
                else {
                    softwaresArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = softwaresArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMySoftwareListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSoftwareAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kSoftwareAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kSoftwareAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMySoftwaresListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kSoftwareAPI_SoftwareList]) {
                    totalItems = [[responseDict valueForKey:kSoftwareAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [softwaresArray removeAllObjects];
                    
                    if(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                    }
                    else {
                        [softwaresArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                    }
                    lblNoSoftwareAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoSoftwareAvailable.hidden = false;
                if(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                }
                else {
                    softwaresArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = softwaresArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveSoftwareList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSoftwareAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kSoftwareAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kSoftwareAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveSoftwaresListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kSoftwareAPI_SoftwareList]) {
                    totalItems = [[responseDict valueForKey:kSoftwareAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [softwaresArray removeAllObjects];
                    
                    if(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                    }
                    else {
                        [softwaresArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                    }
                    lblNoSoftwareAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoSoftwareAvailable.hidden = false;
                if(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                }
                else {
                    softwaresArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = softwaresArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedSoftwareList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSoftwareAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kSoftwareAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kSoftwareAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedSoftwaresListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kSoftwareAPI_SoftwareList]) {
                    totalItems = [[responseDict valueForKey:kSoftwareAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [softwaresArray removeAllObjects];
                    
                    if(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                    }
                    else {
                        [softwaresArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                    }
                    lblNoSoftwareAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoSoftwareAvailable.hidden = false;
                if(softwareSearchController.active && ![softwareSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                }
                else {
                    softwaresArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSoftwareAPI_SoftwareList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = softwaresArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveSoftware:(NSString *)softwareId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSoftwareAPI_UserID] ;
        [dictParam setObject:softwareId forKey:kSoftwareAPI_SoftwareID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveSoftwareWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveSoftware_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMySoftwareListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateSoftware:(NSString *)softwareId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSoftwareAPI_UserID] ;
        [dictParam setObject:softwareId forKey:kSoftwareAPI_SoftwareID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateSoftwareWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedSoftwareList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateSoftware_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateSoftware:(NSString *)softwareId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSoftwareAPI_UserID] ;
        [dictParam setObject:softwareId forKey:kSoftwareAPI_SoftwareID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateSoftwareWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateSoftware_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMySoftwareListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteSoftware:(NSString *)softwareId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSoftwareAPI_UserID] ;
        [dictParam setObject:softwareId forKey:kSoftwareAPI_SoftwareID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteSoftwareWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteSoftware_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMySoftwareListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeSoftware:(NSString *)softwareId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSoftwareAPI_Software_LikedBy] ;
        [dictParam setObject:softwareId forKey:kSoftwareAPI_SoftwareID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeSoftwareWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kSoftwareAPI_Software_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kSoftwareAPI_Software_Dislikes]];
                
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

-(void)dislikeSoftware:(NSString *)softwareId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSoftwareAPI_Software_DislikedBy] ;
        [dictParam setObject:softwareId forKey:kSoftwareAPI_SoftwareID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeSoftwareWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kSoftwareAPI_Software_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kSoftwareAPI_Software_Dislikes]];
                
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

-(void)getLikeSoftwareList:(NSString *)softwareId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:softwareId forKey:kSoftwareAPI_SoftwareID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kSoftwareAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeSoftwareListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kSoftwareAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kSoftwareAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSoftwareAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kSoftwareAPI_UserList]] ;
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

-(void)getdisLikeSoftwareList:(NSString *)softwareId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:softwareId forKey:kSoftwareAPI_SoftwareID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kSoftwareAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeSoftwareListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kSoftwareAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kSoftwareAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSoftwareAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kSoftwareAPI_UserList]] ;
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
