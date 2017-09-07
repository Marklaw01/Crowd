//
//  MyWebinarsViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyWebinarsViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyWebinarsViewController ()

@end

@implementation MyWebinarsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_Webinar_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_Webinar_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find Webinar
    //        if (selectedSegment == SEARCH_WEBINAR_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find Webinar
            if (selectedSegment == SEARCH_WEBINAR_SELECTED) {
                [self getFindWebinarWithSearchText:searchedString];
            } else
                [self getMyWebinarListWithSearchText:searchedString];
        } else {// My Webinar
            if (selectedSegment == MY_WEBINAR_SELECTED) {
                [self getMyWebinarListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_WEBINAR_SELECTED) {
                [self getArchiveWebinarList:searchedString];
            } else {
                [self getDeactivatedWebinarList:searchedString];
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
    [self.segmentControlMyWebinar setTitleTextAttributes:attributes
                                                forState:UIControlStateNormal];
    [self.segmentControlSearchWebinar setTitleTextAttributes:attributes
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
    
    webinarArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyWebinar.hidden = true;
    addWebinarBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchWebinar setSelectedSegmentIndex:SEARCH_WEBINAR_SELECTED] ;
    [self.segmentControlMyWebinar setSelectedSegmentIndex:MY_WEBINAR_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get My Webinar List
    [self getFindWebinarWithSearchText:searchedString];
}

-(void)configureSearchController {
    webinarSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    webinarSearchController.searchBar.placeholder = kSearchWebinarPlaceholder ;
    [webinarSearchController.searchBar sizeToFit] ;
    webinarSearchController.searchBar.text = searchedString;
    webinarSearchController.searchResultsUpdater = self ;
    webinarSearchController.dimsBackgroundDuringPresentation = NO ;
    webinarSearchController.definesPresentationContext = YES ;
    webinarSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = webinarSearchController.searchBar ;
    webinarSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [webinarArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Webinar
        if (selectedSegment == SEARCH_WEBINAR_SELECTED)
            [self getFindWebinarWithSearchText:searchedString] ; // Find Webinar
        else
            [self getMyWebinarListWithSearchText:searchedString] ; // My Webinar
    }
    else { // Webinar
        if (selectedSegment == MY_WEBINAR_SELECTED)
            [self getMyWebinarListWithSearchText:searchedString] ; // My Webinar
        else if (selectedSegment == ARCHIVE_WEBINAR_SELECTED)
            [self getArchiveWebinarList:searchedString] ; // Archived Webinar
        else
            [self getDeactivatedWebinarList:searchedString] ; // Deactivated Webinar
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [webinarArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [webinarSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Webinar
        if (selectedSegment == SEARCH_WEBINAR_SELECTED)
            [self getFindWebinarWithSearchText:searchedString] ; // Find Webinar
        else
            [self getMyWebinarListWithSearchText:searchedString] ; // My Webinar
    }
    else { // Webinar
        if (selectedSegment == MY_WEBINAR_SELECTED)
            [self getMyWebinarListWithSearchText:searchedString] ; // My Webinar
        else if (selectedSegment == ARCHIVE_WEBINAR_SELECTED)
            [self getArchiveWebinarList:searchedString] ; // Archived Webinar
        else
            [self getDeactivatedWebinarList:searchedString] ; // Deactivated Webinar
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [webinarArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find Webinar
        selectedSegment = self.segmentControlSearchWebinar.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_WEBINAR_SELECTED) { //0
            [self getFindWebinarWithSearchText:searchedString] ; // Find Webinar
            self.segmentControlMyWebinar.hidden = true;
            addWebinarBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyWebinarListWithSearchText:searchedString] ; // My Webinar
            [self.segmentControlMyWebinar setSelectedSegmentIndex:MY_WEBINAR_SELECTED] ;
            self.segmentControlMyWebinar.hidden = false;
            addWebinarBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // Webinar
        selectedSegment = self.segmentControlMyWebinar.selectedSegmentIndex;
        self.segmentControlMyWebinar.hidden = false;
        addWebinarBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_WEBINAR_SELECTED) { //0
            [self getMyWebinarListWithSearchText:searchedString] ; // My Webinar
            addWebinarBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_WEBINAR_SELECTED) { //1
            addWebinarBtn.hidden = true;
            [self getArchiveWebinarList:searchedString ] ; // Archived Webinar
        }
        else { //2
            [self getDeactivatedWebinarList:searchedString] ; // Deactivated Webinar
            addWebinarBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveWebinar_ClickAction:(id)sender {
    
    if(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""]) {
        webinarID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kWebinarAPI_ID];
    }
    else {
        webinarID = [[webinarArray objectAtIndex:[sender tag]] valueForKey: kWebinarAPI_ID];
    }
    [self archiveWebinar:webinarID];
}

- (IBAction)deactivateWebinar_ClickAction:(id)sender {
    if(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""]) {
        webinarID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kWebinarAPI_ID];
    }
    else {
        webinarID = [[webinarArray objectAtIndex:[sender tag]] valueForKey: kWebinarAPI_ID];
    }
    [self deactivateWebinar:webinarID];
}

- (IBAction)deleteWebinar_ClickAction:(id)sender {
    if(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""])
        webinarID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kWebinarAPI_ID];
    else
        webinarID = [[webinarArray objectAtIndex:[sender tag]] valueForKey: kWebinarAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
        [self activateWebinar:webinarID];
    else
        [self deleteWebinar:webinarID];
}

- (IBAction)createWebinarButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Webinars" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateWebinarIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeWebinar_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""])
        webinarID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kWebinarAPI_ID];
    else
        webinarID = [[webinarArray objectAtIndex:[sender tag]] valueForKey: kWebinarAPI_ID];
    
    [self likeWebinar:webinarID];
}

- (IBAction)likeWebinarList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""])
        webinarID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kWebinarAPI_ID];
    else
        webinarID = [[webinarArray objectAtIndex:[sender tag]] valueForKey: kWebinarAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeWebinarList:webinarID];
    }
}

- (IBAction)dislikeWebinar_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""])
        webinarID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kWebinarAPI_ID];
    else
        webinarID = [[webinarArray objectAtIndex:[sender tag]] valueForKey: kWebinarAPI_ID];
    
    [self dislikeWebinar:webinarID];
}

- (IBAction)disLikeWebinarList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""])
        webinarID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kWebinarAPI_ID];
    else
        webinarID = [[webinarArray objectAtIndex:[sender tag]] valueForKey: kWebinarAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeWebinarList:webinarID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kWebinarAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(webinarArray.count == totalItems)
                return webinarArray.count ;
            else
                return webinarArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kWebinarAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kWebinarAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kWebinarAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""]) {
            {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Webinar] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kWebinarAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kWebinarAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kWebinarAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kWebinarAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kWebinarAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kWebinarAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Webinar
                    if (selectedSegment == SEARCH_WEBINAR_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // My Webinar
                    if (selectedSegment == MY_WEBINAR_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_WEBINAR_SELECTED) {
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
            if(indexPath.row == webinarArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Webinar] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[webinarArray objectAtIndex:indexPath.row] valueForKey:kWebinarAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[webinarArray objectAtIndex:indexPath.row] valueForKey:kWebinarAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[webinarArray objectAtIndex:indexPath.row] valueForKey:kWebinarAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[webinarArray objectAtIndex:indexPath.row] valueForKey:kWebinarAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[webinarArray objectAtIndex:indexPath.row] valueForKey:kWebinarAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[webinarArray objectAtIndex:indexPath.row] valueForKey:kWebinarAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Webinar
                    if (selectedSegment == SEARCH_WEBINAR_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Webinar
                    if (selectedSegment == MY_WEBINAR_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_WEBINAR_SELECTED) {
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
        if (webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find Webinar
                if (selectedSegment == SEARCH_WEBINAR_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_WEBINAR_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_WEBINAR_SELECTED || selectedSegment == DEACTIVATED_WEBINAR_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // Webinar
                if (selectedSegment == MY_WEBINAR_SELECTED || selectedSegment == DEACTIVATED_WEBINAR_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == webinarArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find Webinar
                    if (selectedSegment == SEARCH_WEBINAR_SELECTED)
                        return 120;
                    else if (selectedSegment == ADD_WEBINAR_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_WEBINAR_SELECTED || selectedSegment == DEACTIVATED_WEBINAR_SELECTED)
                            return 145;
                        else
                            return 120 ;
                    }
                }
                else { // Webinar
                    if (selectedSegment == MY_WEBINAR_SELECTED || selectedSegment == DEACTIVATED_WEBINAR_SELECTED)
                        return 145;
                    else
                        return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == webinarArray.count) {
//            [self getMyWebinarListWithSearchText:searchedString] ; // My Webinar
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array ;
    if (webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""])
        array = [searchResults mutableCopy] ;
    else
        array = [webinarArray mutableCopy] ;
    
    if(indexPath.row != array.count) {
        
        [UtilityClass setWebinarDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Webinars" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditWebinarIdentifier] ;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
        
        [self.navigationController pushViewController:viewController animated:YES] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetWebinarViewEditing object:nil userInfo:dict];
    }
}

#pragma mark - Api Methods
-(void)getFindWebinarWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kWebinarAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kWebinarAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kWebinarAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchWebinarWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kWebinarAPI_WebinarList]) {
                    totalItems = [[responseDict valueForKey:kWebinarAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [webinarArray removeAllObjects];
                    
                    if(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                    }
                    else {
                        [webinarArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                    }
                    lblNoWebinarAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoWebinarAvailable.hidden = false;
                if(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                }
                else {
                    webinarArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = webinarArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyWebinarListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kWebinarAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kWebinarAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kWebinarAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyWebinarListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kWebinarAPI_WebinarList]) {
                    totalItems = [[responseDict valueForKey:kWebinarAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [webinarArray removeAllObjects];
                    
                    if(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                    }
                    else {
                        [webinarArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                    }
                    lblNoWebinarAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoWebinarAvailable.hidden = false;
                if(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                }
                else {
                    webinarArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = webinarArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveWebinarList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kWebinarAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kWebinarAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kWebinarAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveWebinarListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kWebinarAPI_WebinarList]) {
                    totalItems = [[responseDict valueForKey:kWebinarAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [webinarArray removeAllObjects];
                    
                    if(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                    }
                    else {
                        [webinarArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                    }
                    lblNoWebinarAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoWebinarAvailable.hidden = false;
                if(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                }
                else {
                    webinarArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = webinarArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedWebinarList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kWebinarAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kWebinarAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kWebinarAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedWebinarListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kWebinarAPI_WebinarList]) {
                    totalItems = [[responseDict valueForKey:kWebinarAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [webinarArray removeAllObjects];
                    
                    if(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                    }
                    else {
                        [webinarArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                    }
                    lblNoWebinarAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoWebinarAvailable.hidden = false;
                if(webinarSearchController.active && ![webinarSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                }
                else {
                    webinarArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kWebinarAPI_WebinarList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = webinarArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveWebinar:(NSString *)webinarId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kWebinarAPI_UserID] ;
        [dictParam setObject:webinarId forKey:kWebinarAPI_WebinarID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveWebinarWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveWebinar_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyWebinarListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateWebinar:(NSString *)webinarId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kWebinarAPI_UserID] ;
        [dictParam setObject:webinarId forKey:kWebinarAPI_WebinarID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateWebinarWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedWebinarList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateWebinar_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateWebinar:(NSString *)webinarId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kWebinarAPI_UserID] ;
        [dictParam setObject:webinarId forKey:kWebinarAPI_WebinarID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateWebinarWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateWebinar_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyWebinarListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteWebinar:(NSString *)webinarId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kWebinarAPI_UserID] ;
        [dictParam setObject:webinarId forKey:kWebinarAPI_WebinarID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteWebinarWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteWebinar_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyWebinarListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeWebinar:(NSString *)webinarId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kWebinarAPI_LikedBy] ;
        [dictParam setObject:webinarId forKey:kWebinarAPI_WebinarID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeWebinarWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kWebinarAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kWebinarAPI_Dislikes]];
                
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

-(void)dislikeWebinar:(NSString *)webinarId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kWebinarAPI_DislikedBy] ;
        [dictParam setObject:webinarId forKey:kWebinarAPI_WebinarID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeWebinarWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kWebinarAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kWebinarAPI_Dislikes]];
                
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

-(void)getLikeWebinarList:(NSString *)webinarId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:webinarId forKey:kWebinarAPI_WebinarID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kWebinarAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeWebinarListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kWebinarAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kWebinarAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kWebinarAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kWebinarAPI_UserList]] ;
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

-(void)getdisLikeWebinarList:(NSString *)webinarId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:webinarId forKey:kWebinarAPI_WebinarID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kWebinarAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeWebinarListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kWebinarAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kWebinarAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kWebinarAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kWebinarAPI_UserList]] ;
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
