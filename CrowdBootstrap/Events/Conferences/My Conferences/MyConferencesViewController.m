//
//  MyConferencesViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyConferencesViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyConferencesViewController ()

@end

@implementation MyConferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_Conference_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_Conference_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find Conference
    //        if (selectedSegment == SEARCH_CONFERENCE_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find Conference
            if (selectedSegment == SEARCH_CONFERENCE_SELECTED) {
                [self getFindConferenceWithSearchText:searchedString];
            } else
                [self getMyConferenceListWithSearchText:searchedString];
        } else {// My Conference
            if (selectedSegment == MY_CONFERENCE_SELECTED) {
                [self getMyConferenceListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_CONFERENCE_SELECTED) {
                [self getArchiveConferenceList:searchedString];
            } else {
                [self getDeactivatedConferenceList:searchedString];
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
    [self.segmentControlMyConference setTitleTextAttributes:attributes
                                                forState:UIControlStateNormal];
    [self.segmentControlSearchConference setTitleTextAttributes:attributes
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
    
    conferenceArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyConference.hidden = true;
    addConferenceBtn.hidden = true;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchConference setSelectedSegmentIndex:SEARCH_CONFERENCE_SELECTED] ;
    [self.segmentControlMyConference setSelectedSegmentIndex:MY_CONFERENCE_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get My Conference List
    [self getFindConferenceWithSearchText:searchedString];
}

-(void)configureSearchController {
    conferenceSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    conferenceSearchController.searchBar.placeholder = kSearchConferencePlaceholder ;
    [conferenceSearchController.searchBar sizeToFit] ;
    conferenceSearchController.searchBar.text = searchedString;
    conferenceSearchController.searchResultsUpdater = self ;
    conferenceSearchController.dimsBackgroundDuringPresentation = NO ;
    conferenceSearchController.definesPresentationContext = YES ;
    conferenceSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = conferenceSearchController.searchBar ;
    conferenceSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [conferenceArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Conference
        if (selectedSegment == SEARCH_CONFERENCE_SELECTED)
            [self getFindConferenceWithSearchText:searchedString] ; // Find Conference
        else
            [self getMyConferenceListWithSearchText:searchedString] ; // My Conference
    }
    else { // Conference
        if (selectedSegment == MY_CONFERENCE_SELECTED)
            [self getMyConferenceListWithSearchText:searchedString] ; // My Conference
        else if (selectedSegment == ARCHIVE_CONFERENCE_SELECTED)
            [self getArchiveConferenceList:searchedString] ; // Archived Conference
        else
            [self getDeactivatedConferenceList:searchedString] ; // Deactivated Conference
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [conferenceArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [conferenceSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Conference
        if (selectedSegment == SEARCH_CONFERENCE_SELECTED)
            [self getFindConferenceWithSearchText:searchedString] ; // Find Conference
        else
            [self getMyConferenceListWithSearchText:searchedString] ; // My Conference
    }
    else { // Conference
        if (selectedSegment == MY_CONFERENCE_SELECTED)
            [self getMyConferenceListWithSearchText:searchedString] ; // My Conference
        else if (selectedSegment == ARCHIVE_CONFERENCE_SELECTED)
            [self getArchiveConferenceList:searchedString] ; // Archived Conference
        else
            [self getDeactivatedConferenceList:searchedString] ; // Deactivated Conference
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [conferenceArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find Conference
        selectedSegment = self.segmentControlSearchConference.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_CONFERENCE_SELECTED) { //0
            [self getFindConferenceWithSearchText:searchedString] ; // Find Conference
            self.segmentControlMyConference.hidden = true;
            addConferenceBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyConferenceListWithSearchText:searchedString] ; // My Conference
            [self.segmentControlMyConference setSelectedSegmentIndex:MY_CONFERENCE_SELECTED] ;
            self.segmentControlMyConference.hidden = false;
            addConferenceBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // Conference
        selectedSegment = self.segmentControlMyConference.selectedSegmentIndex;
        self.segmentControlMyConference.hidden = false;
        addConferenceBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_CONFERENCE_SELECTED) { //0
            [self getMyConferenceListWithSearchText:searchedString] ; // My Conference
            addConferenceBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_CONFERENCE_SELECTED) { //1
            addConferenceBtn.hidden = true;
            [self getArchiveConferenceList:searchedString ] ; // Archived Conference
        }
        else { //2
            [self getDeactivatedConferenceList:searchedString] ; // Deactivated Conference
            addConferenceBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveConference_ClickAction:(id)sender {
    
    if(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""]) {
        conferenceID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kConferenceAPI_ID];
    }
    else {
        conferenceID = [[conferenceArray objectAtIndex:[sender tag]] valueForKey: kConferenceAPI_ID];
    }
    [self archiveConference:conferenceID];
}

- (IBAction)deactivateConference_ClickAction:(id)sender {
    if(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""]) {
        conferenceID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kConferenceAPI_ID];
    }
    else {
        conferenceID = [[conferenceArray objectAtIndex:[sender tag]] valueForKey: kConferenceAPI_ID];
    }
    [self deactivateConference:conferenceID];
}

- (IBAction)deleteConference_ClickAction:(id)sender {
    if(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""])
        conferenceID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kConferenceAPI_ID];
    else
        conferenceID = [[conferenceArray objectAtIndex:[sender tag]] valueForKey: kConferenceAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
        [self activateConference:conferenceID];
    else
        [self deleteConference:conferenceID];
}

- (IBAction)createConferenceButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Conference" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateConferenceIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeConference_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""])
        conferenceID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kConferenceAPI_ID];
    else
        conferenceID = [[conferenceArray objectAtIndex:[sender tag]] valueForKey: kConferenceAPI_ID];
    
    [self likeConference:conferenceID];
}

- (IBAction)likeConferenceList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""])
        conferenceID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kConferenceAPI_ID];
    else
        conferenceID = [[conferenceArray objectAtIndex:[sender tag]] valueForKey: kConferenceAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeConferenceList:conferenceID];
    }
}

- (IBAction)dislikeConference_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""])
        conferenceID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kConferenceAPI_ID];
    else
        conferenceID = [[conferenceArray objectAtIndex:[sender tag]] valueForKey: kConferenceAPI_ID];
    
    [self dislikeConference:conferenceID];
}

- (IBAction)disLikeConferenceList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""])
        conferenceID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kConferenceAPI_ID];
    else
        conferenceID = [[conferenceArray objectAtIndex:[sender tag]] valueForKey: kConferenceAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeConferenceList:conferenceID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kConferenceAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(conferenceArray.count == totalItems)
                return conferenceArray.count ;
            else
                return conferenceArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kConferenceAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kConferenceAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kConferenceAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""]) {
            {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Conference] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kConferenceAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kConferenceAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kConferenceAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kConferenceAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kConferenceAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kConferenceAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Conference
                    if (selectedSegment == SEARCH_CONFERENCE_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // My Conference
                    if (selectedSegment == MY_CONFERENCE_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_CONFERENCE_SELECTED) {
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
            if(indexPath.row == conferenceArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Conference] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[conferenceArray objectAtIndex:indexPath.row] valueForKey:kConferenceAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[conferenceArray objectAtIndex:indexPath.row] valueForKey:kConferenceAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[conferenceArray objectAtIndex:indexPath.row] valueForKey:kConferenceAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[conferenceArray objectAtIndex:indexPath.row] valueForKey:kConferenceAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[conferenceArray objectAtIndex:indexPath.row] valueForKey:kConferenceAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[conferenceArray objectAtIndex:indexPath.row] valueForKey:kConferenceAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Conference
                    if (selectedSegment == SEARCH_CONFERENCE_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Conference
                    if (selectedSegment == MY_CONFERENCE_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_CONFERENCE_SELECTED) {
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
        if (conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find Conference
                if (selectedSegment == SEARCH_CONFERENCE_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_CONFERENCE_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_CONFERENCE_SELECTED || selectedSegment == DEACTIVATED_CONFERENCE_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // Conference
                if (selectedSegment == MY_CONFERENCE_SELECTED || selectedSegment == DEACTIVATED_CONFERENCE_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == conferenceArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find Conference
                    if (selectedSegment == SEARCH_CONFERENCE_SELECTED)
                        return 120;
                    else if (selectedSegment == ADD_CONFERENCE_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_CONFERENCE_SELECTED || selectedSegment == DEACTIVATED_CONFERENCE_SELECTED)
                            return 145;
                        else
                            return 120 ;
                    }
                }
                else { // Conference
                    if (selectedSegment == MY_CONFERENCE_SELECTED || selectedSegment == DEACTIVATED_CONFERENCE_SELECTED)
                        return 145;
                    else
                        return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == conferenceArray.count) {
//            [self getMyConferenceListWithSearchText:searchedString] ; // My Conference
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblView) {
        NSMutableArray *array ;
        if (conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""])
            array = [searchResults mutableCopy] ;
        else
            array = [conferenceArray mutableCopy] ;
        
        if(indexPath.row != array.count) {
            
            [UtilityClass setConferenceDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Conference" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditConferenceIdentifier] ;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
            
            [self.navigationController pushViewController:viewController animated:YES] ;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetConferenceViewEditing object:nil userInfo:dict];
        }
    }
}

#pragma mark - Api Methods
-(void)getFindConferenceWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConferenceAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConferenceAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kConferenceAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchConferenceWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kConferenceAPI_ConferenceList]) {
                    totalItems = [[responseDict valueForKey:kConferenceAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [conferenceArray removeAllObjects];
                    
                    if(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                    }
                    else {
                        [conferenceArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                    }
                    lblNoConferenceAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoConferenceAvailable.hidden = false;
                if(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                }
                else {
                    conferenceArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = conferenceArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyConferenceListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConferenceAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConferenceAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kConferenceAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyConferenceListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kConferenceAPI_ConferenceList]) {
                    totalItems = [[responseDict valueForKey:kConferenceAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [conferenceArray removeAllObjects];
                    
                    if(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                    }
                    else {
                        [conferenceArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                    }
                    lblNoConferenceAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoConferenceAvailable.hidden = false;
                if(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                }
                else {
                    conferenceArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = conferenceArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveConferenceList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConferenceAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConferenceAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kConferenceAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveConferenceListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kConferenceAPI_ConferenceList]) {
                    totalItems = [[responseDict valueForKey:kConferenceAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [conferenceArray removeAllObjects];
                    
                    if(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                    }
                    else {
                        [conferenceArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                    }
                    lblNoConferenceAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoConferenceAvailable.hidden = false;
                if(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                }
                else {
                    conferenceArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = conferenceArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedConferenceList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConferenceAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConferenceAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kConferenceAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedConferenceListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kConferenceAPI_ConferenceList]) {
                    totalItems = [[responseDict valueForKey:kConferenceAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [conferenceArray removeAllObjects];
                    
                    if(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                    }
                    else {
                        [conferenceArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                    }
                    lblNoConferenceAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoConferenceAvailable.hidden = false;
                if(conferenceSearchController.active && ![conferenceSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                }
                else {
                    conferenceArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConferenceAPI_ConferenceList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = conferenceArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveConference:(NSString *)conferenceId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConferenceAPI_UserID] ;
        [dictParam setObject:conferenceId forKey:kConferenceAPI_ConferenceID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveConferenceWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveConference_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyConferenceListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateConference:(NSString *)conferenceId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConferenceAPI_UserID] ;
        [dictParam setObject:conferenceId forKey:kConferenceAPI_ConferenceID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateConferenceWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedConferenceList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateConference_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateConference:(NSString *)conferenceId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConferenceAPI_UserID] ;
        [dictParam setObject:conferenceId forKey:kConferenceAPI_ConferenceID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateConferenceWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateConference_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyConferenceListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteConference:(NSString *)conferenceId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConferenceAPI_UserID] ;
        [dictParam setObject:conferenceId forKey:kConferenceAPI_ConferenceID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteConferenceWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteConference_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyConferenceListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeConference:(NSString *)conferenceId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConferenceAPI_LikedBy] ;
        [dictParam setObject:conferenceId forKey:kConferenceAPI_ConferenceID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeConferenceWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kConferenceAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kConferenceAPI_Dislikes]];
                
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

-(void)dislikeConference:(NSString *)conferenceId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConferenceAPI_DislikedBy] ;
        [dictParam setObject:conferenceId forKey:kConferenceAPI_ConferenceID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeConferenceWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kConferenceAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kConferenceAPI_Dislikes]];
                
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

-(void)getLikeConferenceList:(NSString *)conferenceId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:conferenceId forKey:kConferenceAPI_ConferenceID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConferenceAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeConferenceListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kConferenceAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kConferenceAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConferenceAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kConferenceAPI_UserList]] ;
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

-(void)getdisLikeConferenceList:(NSString *)conferenceId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:conferenceId forKey:kConferenceAPI_ConferenceID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConferenceAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeConferenceListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kConferenceAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kConferenceAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConferenceAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kConferenceAPI_UserList]] ;
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
