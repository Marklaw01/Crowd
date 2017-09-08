//
//  MyDemoDaysViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyDemoDaysViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyDemoDaysViewController ()

@end

@implementation MyDemoDaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_DemoDay_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_DemoDay_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find DemoDay
    //        if (selectedSegment == SEARCH_DEMODAY_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find DemoDay
            if (selectedSegment == SEARCH_DEMODAY_SELECTED) {
                [self getFindDemoDayWithSearchText:searchedString];
            } else
                [self getMyDemoDayListWithSearchText:searchedString];
        } else {// My DemoDay
            if (selectedSegment == MY_DEMODAY_SELECTED) {
                [self getMyDemoDayListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_DEMODAY_SELECTED) {
                [self getArchiveDemoDayList:searchedString];
            } else {
                [self getDeactivatedDemoDayList:searchedString];
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
    [self.segmentControlMyDemoDay setTitleTextAttributes:attributes
                                                forState:UIControlStateNormal];
    [self.segmentControlSearchDemoDay setTitleTextAttributes:attributes
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
    
    demoDayArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyDemoDay.hidden = true;
    addDemoDayBtn.hidden = TRUE;
    
    constraintTblViewTop.constant = 1;

    selectedSegmentControl = 100;
    [self.segmentControlSearchDemoDay setSelectedSegmentIndex:SEARCH_DEMODAY_SELECTED] ;
    [self.segmentControlMyDemoDay setSelectedSegmentIndex:MY_DEMODAY_SELECTED] ;
    
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get My DemoDay List
    [self getFindDemoDayWithSearchText:searchedString];
}

-(void)configureSearchController {
    demoDaySearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    demoDaySearchController.searchBar.placeholder = kSearchDemoDayPlaceholder ;
    [demoDaySearchController.searchBar sizeToFit] ;
    demoDaySearchController.searchBar.text = searchedString;
    demoDaySearchController.searchResultsUpdater = self ;
    demoDaySearchController.dimsBackgroundDuringPresentation = NO ;
    demoDaySearchController.definesPresentationContext = YES ;
    demoDaySearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = demoDaySearchController.searchBar ;
    demoDaySearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [demoDayArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find DemoDay
        if (selectedSegment == SEARCH_DEMODAY_SELECTED)
            [self getFindDemoDayWithSearchText:searchedString] ; // Find DemoDay
        else
            [self getMyDemoDayListWithSearchText:searchedString] ; // My DemoDay
    }
    else { // DemoDay
        if (selectedSegment == MY_DEMODAY_SELECTED)
            [self getMyDemoDayListWithSearchText:searchedString] ; // My DemoDay
        else if (selectedSegment == ARCHIVE_DEMODAY_SELECTED)
            [self getArchiveDemoDayList:searchedString] ; // Archived DemoDay
        else
            [self getDeactivatedDemoDayList:searchedString] ; // Deactivated DemoDay
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [demoDayArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [demoDaySearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find DemoDay
        if (selectedSegment == SEARCH_DEMODAY_SELECTED)
            [self getFindDemoDayWithSearchText:searchedString] ; // Find DemoDay
        else
            [self getMyDemoDayListWithSearchText:searchedString] ; // My DemoDay
    }
    else { // DemoDay
        if (selectedSegment == MY_DEMODAY_SELECTED)
            [self getMyDemoDayListWithSearchText:searchedString] ; // My DemoDay
        else if (selectedSegment == ARCHIVE_DEMODAY_SELECTED)
            [self getArchiveDemoDayList:searchedString] ; // Archived DemoDay
        else
            [self getDeactivatedDemoDayList:searchedString] ; // Deactivated DemoDay
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [demoDayArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find DemoDay
        selectedSegment = self.segmentControlSearchDemoDay.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_DEMODAY_SELECTED) { //0
            [self getFindDemoDayWithSearchText:searchedString] ; // Find DemoDay
            self.segmentControlMyDemoDay.hidden = true;
            addDemoDayBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyDemoDayListWithSearchText:searchedString] ; // My DemoDay
            [self.segmentControlMyDemoDay setSelectedSegmentIndex:MY_DEMODAY_SELECTED] ;
            self.segmentControlMyDemoDay.hidden = false;
            addDemoDayBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // DemoDay
        selectedSegment = self.segmentControlMyDemoDay.selectedSegmentIndex;
        self.segmentControlMyDemoDay.hidden = false;
        addDemoDayBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_DEMODAY_SELECTED) { //0
            [self getMyDemoDayListWithSearchText:searchedString] ; // My DemoDay
            addDemoDayBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_DEMODAY_SELECTED) { //1
            addDemoDayBtn.hidden = true;
            [self getArchiveDemoDayList:searchedString ] ; // Archived DemoDay
        }
        else { //2
            [self getDeactivatedDemoDayList:searchedString] ; // Deactivated DemoDay
            addDemoDayBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveDemoDay_ClickAction:(id)sender {
    
    if(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""]) {
        demoDayID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kDemoDayAPI_ID];
    }
    else {
        demoDayID = [[demoDayArray objectAtIndex:[sender tag]] valueForKey: kDemoDayAPI_ID];
    }
    [self archiveDemoDay:demoDayID];
}

- (IBAction)deactivateDemoDay_ClickAction:(id)sender {
    if(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""]) {
        demoDayID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kDemoDayAPI_ID];
    }
    else {
        demoDayID = [[demoDayArray objectAtIndex:[sender tag]] valueForKey: kDemoDayAPI_ID];
    }
    [self deactivateDemoDay:demoDayID];
}

- (IBAction)deleteDemoDay_ClickAction:(id)sender {
    if(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""])
        demoDayID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kDemoDayAPI_ID];
    else
        demoDayID = [[demoDayArray objectAtIndex:[sender tag]] valueForKey: kDemoDayAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
        [self activateDemoDay:demoDayID];
    else
        [self deleteDemoDay:demoDayID];
}

- (IBAction)createDemoDayButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DemoDays" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateDemoDayIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeDemoDay_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""])
        demoDayID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kDemoDayAPI_ID];
    else
        demoDayID = [[demoDayArray objectAtIndex:[sender tag]] valueForKey: kDemoDayAPI_ID];
    
    [self likeDemoDay:demoDayID];
}

- (IBAction)likeDemoDayList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""])
        demoDayID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kDemoDayAPI_ID];
    else
        demoDayID = [[demoDayArray objectAtIndex:[sender tag]] valueForKey: kDemoDayAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeDemoDayList:demoDayID];
    }
}

- (IBAction)dislikeDemoDay_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""])
        demoDayID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kDemoDayAPI_ID];
    else
        demoDayID = [[demoDayArray objectAtIndex:[sender tag]] valueForKey: kDemoDayAPI_ID];
    
    [self dislikeDemoDay:demoDayID];
}

- (IBAction)disLikeDemoDayList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""])
        demoDayID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kDemoDayAPI_ID];
    else
        demoDayID = [[demoDayArray objectAtIndex:[sender tag]] valueForKey: kDemoDayAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeDemoDayList:demoDayID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kDemoDayAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(demoDayArray.count == totalItems)
                return demoDayArray.count ;
            else
                return demoDayArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kDemoDayAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kDemoDayAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kDemoDayAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""]) {
            {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_DemoDay] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kDemoDayAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kDemoDayAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kDemoDayAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kDemoDayAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kDemoDayAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kDemoDayAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find DemoDay
                    if (selectedSegment == SEARCH_DEMODAY_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // My DemoDay
                    if (selectedSegment == MY_DEMODAY_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_DEMODAY_SELECTED) {
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
            if(indexPath.row == demoDayArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_DemoDay] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[demoDayArray objectAtIndex:indexPath.row] valueForKey:kDemoDayAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[demoDayArray objectAtIndex:indexPath.row] valueForKey:kDemoDayAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[demoDayArray objectAtIndex:indexPath.row] valueForKey:kDemoDayAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[demoDayArray objectAtIndex:indexPath.row] valueForKey:kDemoDayAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[demoDayArray objectAtIndex:indexPath.row] valueForKey:kDemoDayAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[demoDayArray objectAtIndex:indexPath.row] valueForKey:kDemoDayAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find DemoDay
                    if (selectedSegment == SEARCH_DEMODAY_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // DemoDay
                    if (selectedSegment == MY_DEMODAY_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_DEMODAY_SELECTED) {
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
        if (demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find DemoDay
                if (selectedSegment == SEARCH_DEMODAY_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_DEMODAY_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_DEMODAY_SELECTED || selectedSegment == DEACTIVATED_DEMODAY_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // DemoDay
                if (selectedSegment == MY_DEMODAY_SELECTED || selectedSegment == DEACTIVATED_DEMODAY_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == demoDayArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find DemoDay
                    if (selectedSegment == SEARCH_DEMODAY_SELECTED)
                        return 120;
                    else if (selectedSegment == ADD_DEMODAY_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_DEMODAY_SELECTED || selectedSegment == DEACTIVATED_DEMODAY_SELECTED)
                            return 145;
                        else
                            return 120 ;
                    }
                }
                else { // DemoDay
                    if (selectedSegment == MY_DEMODAY_SELECTED || selectedSegment == DEACTIVATED_DEMODAY_SELECTED)
                        return 145;
                    else
                        return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == demoDayArray.count) {
//            [self getMyDemoDayListWithSearchText:searchedString] ; // My DemoDay
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array ;
    if (demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""])
        array = [searchResults mutableCopy] ;
    else
        array = [demoDayArray mutableCopy] ;
    
    if(indexPath.row != array.count) {
        
        [UtilityClass setDemoDayDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DemoDays" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditDemoDayIdentifier] ;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
        
        [self.navigationController pushViewController:viewController animated:YES] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetDemoDayViewEditing object:nil userInfo:dict];
    }
}

#pragma mark - Api Methods
-(void)getFindDemoDayWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kDemoDayAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kDemoDayAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kDemoDayAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchDemoDayWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kDemoDayAPI_DemoDayList]) {
                    totalItems = [[responseDict valueForKey:kDemoDayAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [demoDayArray removeAllObjects];
                    
                    if(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                    }
                    else {
                        [demoDayArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                    }
                    lblNoDemoDayAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoDemoDayAvailable.hidden = false;
                if(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                }
                else {
                    demoDayArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = demoDayArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyDemoDayListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kDemoDayAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kDemoDayAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kDemoDayAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyDemoDayListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kDemoDayAPI_DemoDayList]) {
                    totalItems = [[responseDict valueForKey:kDemoDayAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [demoDayArray removeAllObjects];
                    
                    if(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                    }
                    else {
                        [demoDayArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                    }
                    lblNoDemoDayAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoDemoDayAvailable.hidden = false;
                if(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                }
                else {
                    demoDayArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = demoDayArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveDemoDayList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kDemoDayAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kDemoDayAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kDemoDayAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveDemoDayListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kDemoDayAPI_DemoDayList]) {
                    totalItems = [[responseDict valueForKey:kDemoDayAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [demoDayArray removeAllObjects];
                    
                    if(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                    }
                    else {
                        [demoDayArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                    }
                    lblNoDemoDayAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoDemoDayAvailable.hidden = false;
                if(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                }
                else {
                    demoDayArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = demoDayArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedDemoDayList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kDemoDayAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kDemoDayAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kDemoDayAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedDemoDayListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kDemoDayAPI_DemoDayList]) {
                    totalItems = [[responseDict valueForKey:kDemoDayAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [demoDayArray removeAllObjects];
                    
                    if(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                    }
                    else {
                        [demoDayArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                    }
                    lblNoDemoDayAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoDemoDayAvailable.hidden = false;
                if(demoDaySearchController.active && ![demoDaySearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                }
                else {
                    demoDayArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kDemoDayAPI_DemoDayList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = demoDayArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveDemoDay:(NSString *)demoDayId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kDemoDayAPI_UserID] ;
        [dictParam setObject:demoDayId forKey:kDemoDayAPI_DemoDayID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveDemoDayWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveDemoDay_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyDemoDayListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateDemoDay:(NSString *)demoDayId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kDemoDayAPI_UserID] ;
        [dictParam setObject:demoDayId forKey:kDemoDayAPI_DemoDayID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateDemoDayWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedDemoDayList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateDemoDay_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateDemoDay:(NSString *)demoDayId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kDemoDayAPI_UserID] ;
        [dictParam setObject:demoDayId forKey:kDemoDayAPI_DemoDayID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateDemoDayWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateDemoDay_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyDemoDayListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteDemoDay:(NSString *)demoDayId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kDemoDayAPI_UserID] ;
        [dictParam setObject:demoDayId forKey:kDemoDayAPI_DemoDayID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteDemoDayWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteDemoDay_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyDemoDayListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeDemoDay:(NSString *)demoDayId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kDemoDayAPI_LikedBy] ;
        [dictParam setObject:demoDayId forKey:kDemoDayAPI_DemoDayID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeDemoDayWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kDemoDayAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kDemoDayAPI_Dislikes]];
                
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

-(void)dislikeDemoDay:(NSString *)demoDayId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kDemoDayAPI_DislikedBy] ;
        [dictParam setObject:demoDayId forKey:kDemoDayAPI_DemoDayID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeDemoDayWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kDemoDayAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kDemoDayAPI_Dislikes]];
                
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

-(void)getLikeDemoDayList:(NSString *)demoDayId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:demoDayId forKey:kDemoDayAPI_DemoDayID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kDemoDayAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeDemoDayListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kDemoDayAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kDemoDayAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kDemoDayAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kDemoDayAPI_UserList]] ;
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

-(void)getdisLikeDemoDayList:(NSString *)demoDayId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:demoDayId forKey:kDemoDayAPI_DemoDayID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kDemoDayAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeDemoDayListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kDemoDayAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kDemoDayAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kDemoDayAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kDemoDayAPI_UserList]] ;
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