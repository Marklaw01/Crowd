//
//  MyProductivityViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyProductivityViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyProductivityViewController ()

@end

@implementation MyProductivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_Productivity_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_Productivity_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find Productivity
    //        if (selectedSegment == SEARCH_PRODUCTIVITY_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find Productivity
            if (selectedSegment == SEARCH_PRODUCTIVITY_SELECTED) {
                [self getFindProductivityWithSearchText:searchedString];
            } else
                [self getMyProductivityListWithSearchText:searchedString];
        } else {// My Productivity
            if (selectedSegment == MY_PRODUCTIVITY_SELECTED) {
                [self getMyProductivityListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_PRODUCTIVITY_SELECTED) {
                [self getArchiveProductivityList:searchedString];
            } else {
                [self getDeactivatedProductivityList:searchedString];
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
    [self.segmentControlMyProductivity setTitleTextAttributes:attributes
                                                    forState:UIControlStateNormal];
    [self.segmentControlSearchProductivity setTitleTextAttributes:attributes
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
    
    productivityArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyProductivity.hidden = true;
    addProductivityBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchProductivity setSelectedSegmentIndex:SEARCH_PRODUCTIVITY_SELECTED] ;
    [self.segmentControlMyProductivity setSelectedSegmentIndex:MY_PRODUCTIVITY_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get My Productivity List
    [self getFindProductivityWithSearchText:searchedString];
}

-(void)configureSearchController {
    productivitySearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    productivitySearchController.searchBar.placeholder = kSearchProductivityPlaceholder ;
    [productivitySearchController.searchBar sizeToFit] ;
    productivitySearchController.searchBar.text = searchedString;
    productivitySearchController.searchResultsUpdater = self ;
    productivitySearchController.dimsBackgroundDuringPresentation = NO ;
    productivitySearchController.definesPresentationContext = YES ;
    productivitySearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = productivitySearchController.searchBar ;
    productivitySearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [productivityArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Productivity
        if (selectedSegment == SEARCH_PRODUCTIVITY_SELECTED)
            [self getFindProductivityWithSearchText:searchedString] ; // Find Productivity
        else
            [self getMyProductivityListWithSearchText:searchedString] ; // My Productivity
    }
    else { // Productivity
        if (selectedSegment == MY_PRODUCTIVITY_SELECTED)
            [self getMyProductivityListWithSearchText:searchedString] ; // My Productivity
        else if (selectedSegment == ARCHIVE_PRODUCTIVITY_SELECTED)
            [self getArchiveProductivityList:searchedString] ; // Archived Productivity
        else
            [self getDeactivatedProductivityList:searchedString] ; // Deactivated Productivity
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [productivityArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [productivitySearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Productivity
        if (selectedSegment == SEARCH_PRODUCTIVITY_SELECTED)
            [self getFindProductivityWithSearchText:searchedString] ; // Find Productivity
        else
            [self getMyProductivityListWithSearchText:searchedString] ; // My Productivity
    }
    else { // Productivity
        if (selectedSegment == MY_PRODUCTIVITY_SELECTED)
            [self getMyProductivityListWithSearchText:searchedString] ; // My Productivity
        else if (selectedSegment == ARCHIVE_PRODUCTIVITY_SELECTED)
            [self getArchiveProductivityList:searchedString] ; // Archived Productivity
        else
            [self getDeactivatedProductivityList:searchedString] ; // Deactivated Productivity
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [productivityArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find Productivity
        selectedSegment = self.segmentControlSearchProductivity.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_PRODUCTIVITY_SELECTED) { //0
            [self getFindProductivityWithSearchText:searchedString] ; // Find Productivity
            self.segmentControlMyProductivity.hidden = true;
            addProductivityBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyProductivityListWithSearchText:searchedString] ; // My Productivity
            [self.segmentControlMyProductivity setSelectedSegmentIndex:MY_PRODUCTIVITY_SELECTED] ;
            self.segmentControlMyProductivity.hidden = false;
            addProductivityBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // Productivity
        selectedSegment = self.segmentControlMyProductivity.selectedSegmentIndex;
        self.segmentControlMyProductivity.hidden = false;
        addProductivityBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_PRODUCTIVITY_SELECTED) { //0
            [self getMyProductivityListWithSearchText:searchedString] ; // My Productivity
            addProductivityBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_PRODUCTIVITY_SELECTED) { //1
            addProductivityBtn.hidden = true;
            [self getArchiveProductivityList:searchedString ] ; // Archived Productivity
        }
        else { //2
            [self getDeactivatedProductivityList:searchedString] ; // Deactivated Productivity
            addProductivityBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveProductivity_ClickAction:(id)sender {
    
    if(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""]) {
        productivityID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kProductivityAPI_ID];
    }
    else {
        productivityID = [[productivityArray objectAtIndex:[sender tag]] valueForKey: kProductivityAPI_ID];
    }
    [self archiveProductivity:productivityID];
}

- (IBAction)deactivateProductivity_ClickAction:(id)sender {
    if(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""]) {
        productivityID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kProductivityAPI_ID];
    }
    else {
        productivityID = [[productivityArray objectAtIndex:[sender tag]] valueForKey: kProductivityAPI_ID];
    }
    [self deactivateProductivity:productivityID];
}

- (IBAction)deleteProductivity_ClickAction:(id)sender {
    if(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""])
        productivityID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kProductivityAPI_ID];
    else
        productivityID = [[productivityArray objectAtIndex:[sender tag]] valueForKey: kProductivityAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
        [self activateProductivity:productivityID];
    else
        [self deleteProductivity:productivityID];
}

- (IBAction)createProductivityButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Productivity" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateProductivityIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeProductivity_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""])
        productivityID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kProductivityAPI_ID];
    else
        productivityID = [[productivityArray objectAtIndex:[sender tag]] valueForKey: kProductivityAPI_ID];
    
    [self likeProductivity:productivityID];
}

- (IBAction)likeProductivityList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""])
        productivityID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kProductivityAPI_ID];
    else
        productivityID = [[productivityArray objectAtIndex:[sender tag]] valueForKey: kProductivityAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeProductivityList:productivityID];
    }
}

- (IBAction)dislikeProductivity_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""])
        productivityID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kProductivityAPI_ID];
    else
        productivityID = [[productivityArray objectAtIndex:[sender tag]] valueForKey: kProductivityAPI_ID];
    
    [self dislikeProductivity:productivityID];
}

- (IBAction)disLikeProductivityList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""])
        productivityID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kProductivityAPI_ID];
    else
        productivityID = [[productivityArray objectAtIndex:[sender tag]] valueForKey: kProductivityAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeProductivityList:productivityID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kProductivityAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(productivityArray.count == totalItems)
                return productivityArray.count ;
            else
                return productivityArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kProductivityAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kProductivityAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kProductivityAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""]) {
            {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Productivity] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kProductivityAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kProductivityAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kProductivityAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kProductivityAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kProductivityAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kProductivityAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Productivity
                    if (selectedSegment == SEARCH_PRODUCTIVITY_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // My Productivity
                    if (selectedSegment == MY_PRODUCTIVITY_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_PRODUCTIVITY_SELECTED) {
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
            if(indexPath.row == productivityArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Productivity] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[productivityArray objectAtIndex:indexPath.row] valueForKey:kProductivityAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[productivityArray objectAtIndex:indexPath.row] valueForKey:kProductivityAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[productivityArray objectAtIndex:indexPath.row] valueForKey:kProductivityAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[productivityArray objectAtIndex:indexPath.row] valueForKey:kProductivityAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[productivityArray objectAtIndex:indexPath.row] valueForKey:kProductivityAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[productivityArray objectAtIndex:indexPath.row] valueForKey:kProductivityAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Productivity
                    if (selectedSegment == SEARCH_PRODUCTIVITY_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Productivity
                    if (selectedSegment == MY_PRODUCTIVITY_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_PRODUCTIVITY_SELECTED) {
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
        if (productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find Productivity
                if (selectedSegment == SEARCH_PRODUCTIVITY_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_PRODUCTIVITY_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_PRODUCTIVITY_SELECTED || selectedSegment == DEACTIVATED_PRODUCTIVITY_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // Productivity
                if (selectedSegment == MY_PRODUCTIVITY_SELECTED || selectedSegment == DEACTIVATED_PRODUCTIVITY_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == productivityArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find Productivity
                    if (selectedSegment == SEARCH_PRODUCTIVITY_SELECTED)
                        return 120;
                    else if (selectedSegment == ADD_PRODUCTIVITY_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_PRODUCTIVITY_SELECTED || selectedSegment == DEACTIVATED_PRODUCTIVITY_SELECTED)
                            return 145;
                        else
                            return 120 ;
                    }
                }
                else { // Productivity
                    if (selectedSegment == MY_PRODUCTIVITY_SELECTED || selectedSegment == DEACTIVATED_PRODUCTIVITY_SELECTED)
                        return 145;
                    else
                        return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == productivityArray.count) {
//            [self getMyProductivityListWithSearchText:searchedString] ; // My Productivity
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblView) {
        NSMutableArray *array ;
        if (productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""])
            array = [searchResults mutableCopy] ;
        else
            array = [productivityArray mutableCopy] ;
        
        if(indexPath.row != array.count) {
            
            [UtilityClass setProductivityDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Productivity" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditProductivityIdentifier] ;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
            
            [self.navigationController pushViewController:viewController animated:YES] ;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetProductivityViewEditing object:nil userInfo:dict];
        }
    }
}

#pragma mark - Api Methods
-(void)getFindProductivityWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProductivityAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kProductivityAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kProductivityAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchProductivityWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kProductivityAPI_ProductivityList]) {
                    totalItems = [[responseDict valueForKey:kProductivityAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [productivityArray removeAllObjects];
                    
                    if(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                    }
                    else {
                        [productivityArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                    }
                    lblNoProductivityAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoProductivityAvailable.hidden = false;
                if(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                }
                else {
                    productivityArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = productivityArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyProductivityListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProductivityAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kProductivityAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kProductivityAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyProductivityListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kProductivityAPI_ProductivityList]) {
                    totalItems = [[responseDict valueForKey:kProductivityAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [productivityArray removeAllObjects];
                    
                    if(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                    }
                    else {
                        [productivityArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                    }
                    lblNoProductivityAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoProductivityAvailable.hidden = false;
                if(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                }
                else {
                    productivityArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = productivityArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveProductivityList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProductivityAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kProductivityAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kProductivityAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveProductivityListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kProductivityAPI_ProductivityList]) {
                    totalItems = [[responseDict valueForKey:kProductivityAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [productivityArray removeAllObjects];
                    
                    if(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                    }
                    else {
                        [productivityArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                    }
                    lblNoProductivityAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoProductivityAvailable.hidden = false;
                if(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                }
                else {
                    productivityArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = productivityArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedProductivityList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProductivityAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kProductivityAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kProductivityAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedProductivityListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kProductivityAPI_ProductivityList]) {
                    totalItems = [[responseDict valueForKey:kProductivityAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [productivityArray removeAllObjects];
                    
                    if(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                    }
                    else {
                        [productivityArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                    }
                    lblNoProductivityAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoProductivityAvailable.hidden = false;
                if(productivitySearchController.active && ![productivitySearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                }
                else {
                    productivityArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kProductivityAPI_ProductivityList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = productivityArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveProductivity:(NSString *)productivityId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProductivityAPI_UserID] ;
        [dictParam setObject:productivityId forKey:kProductivityAPI_ProductivityID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveProductivityWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveProductivity_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyProductivityListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateProductivity:(NSString *)productivityId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProductivityAPI_UserID] ;
        [dictParam setObject:productivityId forKey:kProductivityAPI_ProductivityID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateProductivityWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedProductivityList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateProductivity_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateProductivity:(NSString *)productivityId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProductivityAPI_UserID] ;
        [dictParam setObject:productivityId forKey:kProductivityAPI_ProductivityID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateProductivityWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateProductivity_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyProductivityListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteProductivity:(NSString *)productivityId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProductivityAPI_UserID] ;
        [dictParam setObject:productivityId forKey:kProductivityAPI_ProductivityID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteProductivityWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteProductivity_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyProductivityListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeProductivity:(NSString *)productivityId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProductivityAPI_LikedBy] ;
        [dictParam setObject:productivityId forKey:kProductivityAPI_ProductivityID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeProductivityWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kProductivityAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kProductivityAPI_Dislikes]];
                
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

-(void)dislikeProductivity:(NSString *)productivityId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProductivityAPI_DislikedBy] ;
        [dictParam setObject:productivityId forKey:kProductivityAPI_ProductivityID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeProductivityWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kProductivityAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kProductivityAPI_Dislikes]];
                
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

-(void)getLikeProductivityList:(NSString *)productivityId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:productivityId forKey:kProductivityAPI_ProductivityID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kProductivityAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeProductivityListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kProductivityAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kProductivityAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kProductivityAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kProductivityAPI_UserList]] ;
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

-(void)getdisLikeProductivityList:(NSString *)productivityId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:productivityId forKey:kProductivityAPI_ProductivityID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kProductivityAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeProductivityListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kProductivityAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kProductivityAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kProductivityAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kProductivityAPI_UserList]] ;
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
