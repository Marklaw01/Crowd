//
//  MyImprovementToolsViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyImprovementToolsViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyImprovementToolsViewController ()

@end

@implementation MyImprovementToolsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_Improvement_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_Improvement_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find Improvement
    //        if (selectedSegment == SEARCH_IMPROVEMENT_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find Improvement
            if (selectedSegment == SEARCH_IMPROVEMENT_SELECTED) {
                [self getFindImprovementWithSearchText:searchedString];
            } else
                [self getMyImprovementListWithSearchText:searchedString];
        } else {// My Improvement
            if (selectedSegment == MY_IMPROVEMENT_SELECTED) {
                [self getMyImprovementListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_IMPROVEMENT_SELECTED) {
                [self getArchiveImprovementList:searchedString];
            } else {
                [self getDeactivatedImprovementList:searchedString];
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
    [self.segmentControlMyImprovementTools setTitleTextAttributes:attributes
                                                  forState:UIControlStateNormal];
    [self.segmentControlSearchImprovementTools setTitleTextAttributes:attributes
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
    
    improvementToolsArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyImprovementTools.hidden = true;
    addImprovementToolBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchImprovementTools setSelectedSegmentIndex:SEARCH_IMPROVEMENT_SELECTED] ;
    [self.segmentControlMyImprovementTools setSelectedSegmentIndex:MY_IMPROVEMENT_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get Improvement List
    [self getFindImprovementWithSearchText:searchedString];
}

-(void)configureSearchController {
    improvementToolSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    improvementToolSearchController.searchBar.placeholder = kSearchImprovementPlaceholder ;
    [improvementToolSearchController.searchBar sizeToFit] ;
    improvementToolSearchController.searchBar.text = searchedString;
    improvementToolSearchController.searchResultsUpdater = self ;
    improvementToolSearchController.dimsBackgroundDuringPresentation = NO ;
    improvementToolSearchController.definesPresentationContext = YES ;
    improvementToolSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = improvementToolSearchController.searchBar ;
    improvementToolSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [improvementToolsArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Improvement
        if (selectedSegment == SEARCH_IMPROVEMENT_SELECTED)
            [self getFindImprovementWithSearchText:searchedString] ; // Find Improvement
        else
            [self getMyImprovementListWithSearchText:searchedString] ; // My Improvement
    }
    else { // Improvement/Invest
        if (selectedSegment == MY_IMPROVEMENT_SELECTED)
            [self getMyImprovementListWithSearchText:searchedString] ; // My Improvement
        else if (selectedSegment == ARCHIVE_IMPROVEMENT_SELECTED)
            [self getArchiveImprovementList:searchedString] ; // Archived Improvement
        else
            [self getDeactivatedImprovementList:searchedString] ; // Deactivated Improvement
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [improvementToolsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [improvementToolSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Improvement
        if (selectedSegment == SEARCH_IMPROVEMENT_SELECTED)
            [self getFindImprovementWithSearchText:searchedString] ; // Find Improvement
        else
            [self getMyImprovementListWithSearchText:searchedString] ; // My Improvement
    }
    else { // Improvement/Invest
        if (selectedSegment == MY_IMPROVEMENT_SELECTED)
            [self getMyImprovementListWithSearchText:searchedString] ; // My Improvement
        else if (selectedSegment == ARCHIVE_IMPROVEMENT_SELECTED)
            [self getArchiveImprovementList:searchedString] ; // Archived Improvement
        else
            [self getDeactivatedImprovementList:searchedString] ; // Deactivated Improvement
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [improvementToolsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find Improvement
        selectedSegment = self.segmentControlSearchImprovementTools.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_IMPROVEMENT_SELECTED) { //0
            [self getFindImprovementWithSearchText:searchedString] ; // Find Improvement
            self.segmentControlMyImprovementTools.hidden = true;
            addImprovementToolBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyImprovementListWithSearchText:searchedString] ; // My Improvement
            [self.segmentControlMyImprovementTools setSelectedSegmentIndex:MY_IMPROVEMENT_SELECTED] ;
            self.segmentControlMyImprovementTools.hidden = false;
            addImprovementToolBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // Improvement/Invest
        selectedSegment = self.segmentControlMyImprovementTools.selectedSegmentIndex;
        self.segmentControlMyImprovementTools.hidden = false;
        addImprovementToolBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_IMPROVEMENT_SELECTED) { //0
            [self getMyImprovementListWithSearchText:searchedString] ; // My Improvement
            addImprovementToolBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_IMPROVEMENT_SELECTED) { //1
            addImprovementToolBtn.hidden = true;
            [self getArchiveImprovementList:searchedString ] ; // Archived Improvement
        }
        else { //2
            [self getDeactivatedImprovementList:searchedString] ; // Deactivated Improvement
            addImprovementToolBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveImprovement_ClickAction:(id)sender {
    
    if(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""]) {
        improvementID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kImprovementToolAPI_ID];
    }
    else {
        improvementID = [[improvementToolsArray objectAtIndex:[sender tag]] valueForKey: kImprovementToolAPI_ID];
    }
    [self archiveImprovement:improvementID];
}

- (IBAction)deactivateImprovement_ClickAction:(id)sender {
    if(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""]) {
        improvementID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kImprovementToolAPI_ID];
    }
    else {
        improvementID = [[improvementToolsArray objectAtIndex:[sender tag]] valueForKey: kImprovementToolAPI_ID];
    }
    [self deactivateImprovement:improvementID];
}

- (IBAction)deleteImprovement_ClickAction:(id)sender {
    if(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""])
        improvementID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kImprovementToolAPI_ID];
    else
        improvementID = [[improvementToolsArray objectAtIndex:[sender tag]] valueForKey: kImprovementToolAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
        [self activateImprovement:improvementID];
    else
        [self deleteImprovement:improvementID];
}

- (IBAction)createImprovementButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SelfImprovement" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateImprovementToolIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeImprovement_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""])
        improvementID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kImprovementToolAPI_ID];
    else
        improvementID = [[improvementToolsArray objectAtIndex:[sender tag]] valueForKey: kImprovementToolAPI_ID];
    
    [self likeImprovement:improvementID];
}

- (IBAction)likeImprovementList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""])
        improvementID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kImprovementToolAPI_ID];
    else
        improvementID = [[improvementToolsArray objectAtIndex:[sender tag]] valueForKey: kImprovementToolAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeImprovementList:improvementID];
    }
}

- (IBAction)dislikeImprovement_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""])
        improvementID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kImprovementToolAPI_ID];
    else
        improvementID = [[improvementToolsArray objectAtIndex:[sender tag]] valueForKey: kImprovementToolAPI_ID];
    
    [self dislikeImprovement:improvementID];
}

- (IBAction)disLikeImprovementList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""])
        improvementID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kImprovementToolAPI_ID];
    else
        improvementID = [[improvementToolsArray objectAtIndex:[sender tag]] valueForKey: kImprovementToolAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeImprovementList:improvementID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kImprovementToolAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(improvementToolsArray.count == totalItems)
                return improvementToolsArray.count ;
            else
                return improvementToolsArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kImprovementToolAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kImprovementToolAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kImprovementToolAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""]) {
            {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ImprovementTools] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kImprovementToolAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kImprovementToolAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kImprovementToolAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kImprovementToolAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kImprovementToolAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kImprovementToolAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Improvement
                    if (selectedSegment == SEARCH_IMPROVEMENT_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Improvement/Invest
                    if (selectedSegment == MY_IMPROVEMENT_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_IMPROVEMENT_SELECTED) {
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
            if(indexPath.row == improvementToolsArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ImprovementTools] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[improvementToolsArray objectAtIndex:indexPath.row] valueForKey:kImprovementToolAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[improvementToolsArray objectAtIndex:indexPath.row] valueForKey:kImprovementToolAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[improvementToolsArray objectAtIndex:indexPath.row] valueForKey:kImprovementToolAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[improvementToolsArray objectAtIndex:indexPath.row] valueForKey:kImprovementToolAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[improvementToolsArray objectAtIndex:indexPath.row] valueForKey:kImprovementToolAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[improvementToolsArray objectAtIndex:indexPath.row] valueForKey:kImprovementToolAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Improvement
                    if (selectedSegment == SEARCH_IMPROVEMENT_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Improvement/Invest
                    if (selectedSegment == MY_IMPROVEMENT_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_IMPROVEMENT_SELECTED) {
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
        if (improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find Improvement
                if (selectedSegment == SEARCH_IMPROVEMENT_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_IMPROVEMENT_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_IMPROVEMENT_SELECTED || selectedSegment == DEACTIVATED_IMPROVEMENT_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // Improvement
                if (selectedSegment == MY_IMPROVEMENT_SELECTED || selectedSegment == DEACTIVATED_IMPROVEMENT_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == improvementToolsArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find Improvement
                    if (selectedSegment == SEARCH_IMPROVEMENT_SELECTED)
                        return 120;
                    else if (selectedSegment == ADD_IMPROVEMENT_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_IMPROVEMENT_SELECTED || selectedSegment == DEACTIVATED_IMPROVEMENT_SELECTED)
                            return 145;
                        else
                            return 120 ;
                    }
                }
                else { // Improvement/Invest
                    if (selectedSegment == MY_IMPROVEMENT_SELECTED || selectedSegment == DEACTIVATED_IMPROVEMENT_SELECTED)
                        return 145;
                    else
                        return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == improvementToolsArray.count) {
//            [self getMyImprovementListWithSearchText:searchedString] ; // My Improvement
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblView) {
        NSMutableArray *array ;
        if (improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""])
            array = [searchResults mutableCopy] ;
        else
            array = [improvementToolsArray mutableCopy] ;
        
        if(indexPath.row != array.count) {
            
            [UtilityClass setImprovementToolDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SelfImprovement" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditImprovementToolIdentifier] ;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
            
            [self.navigationController pushViewController:viewController animated:YES] ;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetImprovementViewEditing object:nil userInfo:dict];
        }
    }
}

#pragma mark - Api Methods
-(void)getFindImprovementWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kImprovementToolAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kImprovementToolAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kImprovementToolAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchImprovementsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kImprovementToolAPI_List]) {
                    totalItems = [[responseDict valueForKey:kImprovementToolAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [improvementToolsArray removeAllObjects];
                    
                    if(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kImprovementToolAPI_List]] ;
                    }
                    else {
                        [improvementToolsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kImprovementToolAPI_List]] ;
                    }
                    lblNoImprovementToolAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kImprovementToolAPI_List]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoImprovementToolAvailable.hidden = false;
                if(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kImprovementToolAPI_List]] ;
                }
                else {
                    improvementToolsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kImprovementToolAPI_List]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = improvementToolsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyImprovementListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kImprovementToolAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kImprovementToolAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kImprovementToolAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyImprovementsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kImprovementToolAPI_List]) {
                    totalItems = [[responseDict valueForKey:kImprovementToolAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [improvementToolsArray removeAllObjects];
                    
                    if(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kImprovementToolAPI_List]] ;
                    }
                    else {
                        [improvementToolsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kImprovementToolAPI_List]] ;
                    }
                    lblNoImprovementToolAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kImprovementToolAPI_List]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoImprovementToolAvailable.hidden = false;
                if(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kImprovementToolAPI_List]] ;
                }
                else {
                    improvementToolsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kImprovementToolAPI_List]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = improvementToolsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveImprovementList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kImprovementToolAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kImprovementToolAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kImprovementToolAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveImprovementsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kImprovementToolAPI_List]) {
                    totalItems = [[responseDict valueForKey:kImprovementToolAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [improvementToolsArray removeAllObjects];
                    
                    if(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kImprovementToolAPI_List]] ;
                    }
                    else {
                        [improvementToolsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kImprovementToolAPI_List]] ;
                    }
                    lblNoImprovementToolAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kImprovementToolAPI_List]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoImprovementToolAvailable.hidden = false;
                if(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kImprovementToolAPI_List]] ;
                }
                else {
                    improvementToolsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kImprovementToolAPI_List]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = improvementToolsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedImprovementList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kImprovementToolAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kImprovementToolAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kImprovementToolAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedImprovementsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kImprovementToolAPI_List]) {
                    totalItems = [[responseDict valueForKey:kImprovementToolAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [improvementToolsArray removeAllObjects];
                    
                    if(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kImprovementToolAPI_List]] ;
                    }
                    else {
                        [improvementToolsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kImprovementToolAPI_List]] ;
                    }
                    lblNoImprovementToolAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kImprovementToolAPI_List]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoImprovementToolAvailable.hidden = false;
                if(improvementToolSearchController.active && ![improvementToolSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kImprovementToolAPI_List]] ;
                }
                else {
                    improvementToolsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kImprovementToolAPI_List]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = improvementToolsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveImprovement:(NSString *)improvementId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kImprovementToolAPI_UserID] ;
        [dictParam setObject:improvementId forKey:kImprovementToolAPI_ImprovementID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveImprovementWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveImprovementTool_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyImprovementListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateImprovement:(NSString *)improvementId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kImprovementToolAPI_UserID] ;
        [dictParam setObject:improvementId forKey:kImprovementToolAPI_ImprovementID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateImprovementWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedImprovementList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateImprovementTool_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateImprovement:(NSString *)improvementId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kImprovementToolAPI_UserID] ;
        [dictParam setObject:improvementId forKey:kImprovementToolAPI_ImprovementID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateImprovementWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateImprovementTool_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyImprovementListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteImprovement:(NSString *)improvementId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kImprovementToolAPI_UserID] ;
        [dictParam setObject:improvementId forKey:kImprovementToolAPI_ImprovementID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteImprovementWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteImprovementTool_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyImprovementListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeImprovement:(NSString *)improvementId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kImprovementToolAPI_LikedBy] ;
        [dictParam setObject:improvementId forKey:kImprovementToolAPI_ImprovementID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeImprovementWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kImprovementToolAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kImprovementToolAPI_Dislikes]];
                
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

-(void)dislikeImprovement:(NSString *)improvementId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kImprovementToolAPI_DislikedBy] ;
        [dictParam setObject:improvementId forKey:kImprovementToolAPI_ImprovementID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeImprovementWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kImprovementToolAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kImprovementToolAPI_Dislikes]];
                
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

-(void)getLikeImprovementList:(NSString *)improvementId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:improvementId forKey:kImprovementToolAPI_ImprovementID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kImprovementToolAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeImprovementListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kImprovementToolAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kImprovementToolAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kImprovementToolAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kImprovementToolAPI_UserList]] ;
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

-(void)getdisLikeImprovementList:(NSString *)improvementId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:improvementId forKey:kImprovementToolAPI_ImprovementID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kImprovementToolAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeImprovementListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kImprovementToolAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kImprovementToolAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kImprovementToolAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kImprovementToolAPI_UserList]] ;
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
