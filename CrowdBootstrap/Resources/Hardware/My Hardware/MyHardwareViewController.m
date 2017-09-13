//
//  MyHardwareViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyHardwareViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyHardwareViewController ()

@end

@implementation MyHardwareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_Hardware_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_Hardware_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find Hardware
    //        if (selectedSegment == SEARCH_HARDWARE_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find Hardware
            if (selectedSegment == SEARCH_HARDWARE_SELECTED) {
                [self getFindHardwareWithSearchText:searchedString];
            } else
                [self getMyHardwareListWithSearchText:searchedString];
        } else {// My Hardware
            if (selectedSegment == MY_HARDWARE_SELECTED) {
                [self getMyHardwareListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_HARDWARE_SELECTED) {
                [self getArchiveHardwareList:searchedString];
            } else {
                [self getDeactivatedHardwareList:searchedString];
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
    [self.segmentControlMyHardwares setTitleTextAttributes:attributes
                                                  forState:UIControlStateNormal];
    [self.segmentControlSearchHardwares setTitleTextAttributes:attributes
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
    
    hardwaresArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyHardwares.hidden = true;
    addHardwareBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchHardwares setSelectedSegmentIndex:SEARCH_HARDWARE_SELECTED] ;
    [self.segmentControlMyHardwares setSelectedSegmentIndex:MY_HARDWARE_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get Hardware List
    [self getFindHardwareWithSearchText:searchedString];
}

-(void)configureSearchController {
    hardwareSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    hardwareSearchController.searchBar.placeholder = kSearchHardwarePlaceholder ;
    [hardwareSearchController.searchBar sizeToFit] ;
    hardwareSearchController.searchBar.text = searchedString;
    hardwareSearchController.searchResultsUpdater = self ;
    hardwareSearchController.dimsBackgroundDuringPresentation = NO ;
    hardwareSearchController.definesPresentationContext = YES ;
    hardwareSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = hardwareSearchController.searchBar ;
    hardwareSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [hardwaresArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Hardware
        if (selectedSegment == SEARCH_HARDWARE_SELECTED)
            [self getFindHardwareWithSearchText:searchedString] ; // Find Hardware
        else
            [self getMyHardwareListWithSearchText:searchedString] ; // My Hardware
    }
    else { // Hardware/Invest
        if (selectedSegment == MY_HARDWARE_SELECTED)
            [self getMyHardwareListWithSearchText:searchedString] ; // My Hardware
        else if (selectedSegment == ARCHIVE_HARDWARE_SELECTED)
            [self getArchiveHardwareList:searchedString] ; // Archived Hardware
        else
            [self getDeactivatedHardwareList:searchedString] ; // Deactivated Hardware
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [hardwaresArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [hardwareSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Hardware
        if (selectedSegment == SEARCH_HARDWARE_SELECTED)
            [self getFindHardwareWithSearchText:searchedString] ; // Find Hardware
        else
            [self getMyHardwareListWithSearchText:searchedString] ; // My Hardware
    }
    else { // Hardware/Invest
        if (selectedSegment == MY_HARDWARE_SELECTED)
            [self getMyHardwareListWithSearchText:searchedString] ; // My Hardware
        else if (selectedSegment == ARCHIVE_HARDWARE_SELECTED)
            [self getArchiveHardwareList:searchedString] ; // Archived Hardware
        else
            [self getDeactivatedHardwareList:searchedString] ; // Deactivated Hardware
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [hardwaresArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find Hardware
        selectedSegment = self.segmentControlSearchHardwares.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_HARDWARE_SELECTED) { //0
            [self getFindHardwareWithSearchText:searchedString] ; // Find Hardware
            self.segmentControlMyHardwares.hidden = true;
            addHardwareBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyHardwareListWithSearchText:searchedString] ; // My Hardware
            [self.segmentControlMyHardwares setSelectedSegmentIndex:MY_HARDWARE_SELECTED] ;
            self.segmentControlMyHardwares.hidden = false;
            addHardwareBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // Hardware/Invest
        selectedSegment = self.segmentControlMyHardwares.selectedSegmentIndex;
        self.segmentControlMyHardwares.hidden = false;
        addHardwareBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_HARDWARE_SELECTED) { //0
            [self getMyHardwareListWithSearchText:searchedString] ; // My Hardware
            addHardwareBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_HARDWARE_SELECTED) { //1
            addHardwareBtn.hidden = true;
            [self getArchiveHardwareList:searchedString ] ; // Archived Hardware
        }
        else { //2
            [self getDeactivatedHardwareList:searchedString] ; // Deactivated Hardware
            addHardwareBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveHardware_ClickAction:(id)sender {
    
    if(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""]) {
        hardwareID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kHardwareAPI_ID];
    }
    else {
        hardwareID = [[hardwaresArray objectAtIndex:[sender tag]] valueForKey: kHardwareAPI_ID];
    }
    [self archiveHardware:hardwareID];
}

- (IBAction)deactivateHardware_ClickAction:(id)sender {
    if(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""]) {
        hardwareID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kHardwareAPI_ID];
    }
    else {
        hardwareID = [[hardwaresArray objectAtIndex:[sender tag]] valueForKey: kHardwareAPI_ID];
    }
    [self deactivateHardware:hardwareID];
}

- (IBAction)deleteHardware_ClickAction:(id)sender {
    if(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""])
        hardwareID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kHardwareAPI_ID];
    else
        hardwareID = [[hardwaresArray objectAtIndex:[sender tag]] valueForKey: kHardwareAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
        [self activateHardware:hardwareID];
    else
        [self deleteHardware:hardwareID];
}

- (IBAction)createHardwareButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Hardware" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateHardwareIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeHardware_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""])
        hardwareID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kHardwareAPI_ID];
    else
        hardwareID = [[hardwaresArray objectAtIndex:[sender tag]] valueForKey: kHardwareAPI_ID];
    
    [self likeHardware:hardwareID];
}

- (IBAction)likeHardwareList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""])
        hardwareID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kHardwareAPI_ID];
    else
        hardwareID = [[hardwaresArray objectAtIndex:[sender tag]] valueForKey: kHardwareAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeHardwareList:hardwareID];
    }
}

- (IBAction)dislikeHardware_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""])
        hardwareID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kHardwareAPI_ID];
    else
        hardwareID = [[hardwaresArray objectAtIndex:[sender tag]] valueForKey: kHardwareAPI_ID];
    
    [self dislikeHardware:hardwareID];
}

- (IBAction)disLikeHardwareList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""])
        hardwareID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kHardwareAPI_ID];
    else
        hardwareID = [[hardwaresArray objectAtIndex:[sender tag]] valueForKey: kHardwareAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeHardwareList:hardwareID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kHardwareAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(hardwaresArray.count == totalItems)
                return hardwaresArray.count ;
            else
                return hardwaresArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kHardwareAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kHardwareAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kHardwareAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""]) {
            {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Hardwares] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kHardwareAPI_Hardware_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kHardwareAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kHardwareAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kHardwareAPI_Hardware_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kHardwareAPI_Hardware_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kHardwareAPI_Hardware_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Hardware
                    if (selectedSegment == SEARCH_HARDWARE_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Hardware/Invest
                    if (selectedSegment == MY_HARDWARE_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_HARDWARE_SELECTED) {
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
            if(indexPath.row == hardwaresArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Hardwares] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[hardwaresArray objectAtIndex:indexPath.row] valueForKey:kHardwareAPI_Hardware_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[hardwaresArray objectAtIndex:indexPath.row] valueForKey:kHardwareAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[hardwaresArray objectAtIndex:indexPath.row] valueForKey:kHardwareAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[hardwaresArray objectAtIndex:indexPath.row] valueForKey:kHardwareAPI_Hardware_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[hardwaresArray objectAtIndex:indexPath.row] valueForKey:kHardwareAPI_Hardware_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[hardwaresArray objectAtIndex:indexPath.row] valueForKey:kHardwareAPI_Hardware_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Hardware
                    if (selectedSegment == SEARCH_HARDWARE_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Hardware/Invest
                    if (selectedSegment == MY_HARDWARE_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_HARDWARE_SELECTED) {
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
        if (hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find Hardware
                if (selectedSegment == SEARCH_HARDWARE_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_HARDWARE_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_HARDWARE_SELECTED || selectedSegment == DEACTIVATED_HARDWARE_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // Hardware
                if (selectedSegment == MY_HARDWARE_SELECTED || selectedSegment == DEACTIVATED_HARDWARE_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == hardwaresArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find Hardware
                    if (selectedSegment == SEARCH_HARDWARE_SELECTED)
                        return 120;
                    else if (selectedSegment == ADD_HARDWARE_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_HARDWARE_SELECTED || selectedSegment == DEACTIVATED_HARDWARE_SELECTED)
                            return 145;
                        else
                            return 120 ;
                    }
                }
                else { // Hardware/Invest
                    if (selectedSegment == MY_HARDWARE_SELECTED || selectedSegment == DEACTIVATED_HARDWARE_SELECTED)
                        return 145;
                    else
                        return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == hardwaresArray.count) {
//            [self getMyHardwareListWithSearchText:searchedString] ; // My Hardware
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array ;
    if (hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""])
        array = [searchResults mutableCopy] ;
    else
        array = [hardwaresArray mutableCopy] ;
    
    if(indexPath.row != array.count) {
        
        [UtilityClass setHardwareDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Hardware" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditHardwareIdentifier] ;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
        
        [self.navigationController pushViewController:viewController animated:YES] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetHardwareViewEditing object:nil userInfo:dict];
    }
}

#pragma mark - Api Methods
-(void)getFindHardwareWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kHardwareAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kHardwareAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kHardwareAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchHardwaresWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kHardwareAPI_HardwareList]) {
                    totalItems = [[responseDict valueForKey:kHardwareAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [hardwaresArray removeAllObjects];
                    
                    if(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                    }
                    else {
                        [hardwaresArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                    }
                    lblNoHardwareAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoHardwareAvailable.hidden = false;
                if(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                }
                else {
                    hardwaresArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = hardwaresArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyHardwareListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kHardwareAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kHardwareAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kHardwareAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyHardwaresListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kHardwareAPI_HardwareList]) {
                    totalItems = [[responseDict valueForKey:kHardwareAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [hardwaresArray removeAllObjects];
                    
                    if(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                    }
                    else {
                        [hardwaresArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                    }
                    lblNoHardwareAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoHardwareAvailable.hidden = false;
                if(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                }
                else {
                    hardwaresArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = hardwaresArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveHardwareList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kHardwareAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kHardwareAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kHardwareAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveHardwaresListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kHardwareAPI_HardwareList]) {
                    totalItems = [[responseDict valueForKey:kHardwareAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [hardwaresArray removeAllObjects];
                    
                    if(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                    }
                    else {
                        [hardwaresArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                    }
                    lblNoHardwareAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoHardwareAvailable.hidden = false;
                if(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                }
                else {
                    hardwaresArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = hardwaresArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedHardwareList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kHardwareAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kHardwareAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kHardwareAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedHardwaresListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kHardwareAPI_HardwareList]) {
                    totalItems = [[responseDict valueForKey:kHardwareAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [hardwaresArray removeAllObjects];
                    
                    if(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                    }
                    else {
                        [hardwaresArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                    }
                    lblNoHardwareAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoHardwareAvailable.hidden = false;
                if(hardwareSearchController.active && ![hardwareSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                }
                else {
                    hardwaresArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kHardwareAPI_HardwareList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = hardwaresArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveHardware:(NSString *)hardwareId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kHardwareAPI_UserID] ;
        [dictParam setObject:hardwareId forKey:kHardwareAPI_HardwareID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveHardwareWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveHardware_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyHardwareListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateHardware:(NSString *)hardwareId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kHardwareAPI_UserID] ;
        [dictParam setObject:hardwareId forKey:kHardwareAPI_HardwareID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateHardwareWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedHardwareList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateHardware_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateHardware:(NSString *)hardwareId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kHardwareAPI_UserID] ;
        [dictParam setObject:hardwareId forKey:kHardwareAPI_HardwareID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateHardwareWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateHardware_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyHardwareListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteHardware:(NSString *)hardwareId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kHardwareAPI_UserID] ;
        [dictParam setObject:hardwareId forKey:kHardwareAPI_HardwareID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteHardwareWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteHardware_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyHardwareListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeHardware:(NSString *)hardwareId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kHardwareAPI_Hardware_LikedBy] ;
        [dictParam setObject:hardwareId forKey:kHardwareAPI_HardwareID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeHardwareWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kHardwareAPI_Hardware_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kHardwareAPI_Hardware_Dislikes]];
                
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

-(void)dislikeHardware:(NSString *)hardwareId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kHardwareAPI_Hardware_DislikedBy] ;
        [dictParam setObject:hardwareId forKey:kHardwareAPI_HardwareID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeHardwareWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kHardwareAPI_Hardware_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kHardwareAPI_Hardware_Dislikes]];
                
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

-(void)getLikeHardwareList:(NSString *)hardwareId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:hardwareId forKey:kHardwareAPI_HardwareID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kHardwareAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeHardwareListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kHardwareAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kHardwareAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kHardwareAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kHardwareAPI_UserList]] ;
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

-(void)getdisLikeHardwareList:(NSString *)hardwareId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:hardwareId forKey:kHardwareAPI_HardwareID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kHardwareAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeHardwareListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kHardwareAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kHardwareAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kHardwareAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kHardwareAPI_UserList]] ;
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
