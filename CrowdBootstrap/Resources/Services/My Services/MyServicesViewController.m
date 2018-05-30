//
//  MyServicesViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyServicesViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyServicesViewController ()

@end

@implementation MyServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_Service_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_Service_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find Service
    //        if (selectedSegment == SEARCH_SERVICE_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find Service
            if (selectedSegment == SEARCH_SERVICE_SELECTED) {
                [self getFindServiceWithSearchText:searchedString];
            } else
                [self getMyServiceListWithSearchText:searchedString];
        } else {// My Service
            if (selectedSegment == MY_SERVICE_SELECTED) {
                [self getMyServiceListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_SERVICE_SELECTED) {
                [self getArchiveServiceList:searchedString];
            } else {
                [self getDeactivatedServiceList:searchedString];
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
    [self.segmentControlMyService setTitleTextAttributes:attributes
                                                forState:UIControlStateNormal];
    [self.segmentControlSearchService setTitleTextAttributes:attributes
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
    
    serviceArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyService.hidden = true;
    addServiceBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchService setSelectedSegmentIndex:SEARCH_SERVICE_SELECTED] ;
    [self.segmentControlMyService setSelectedSegmentIndex:MY_SERVICE_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get My Service List
    [self getFindServiceWithSearchText:searchedString];
}

-(void)configureSearchController {
    serviceSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    serviceSearchController.searchBar.placeholder = kSearchServicePlaceholder ;
    [serviceSearchController.searchBar sizeToFit] ;
    serviceSearchController.searchBar.text = searchedString;
    serviceSearchController.searchResultsUpdater = self ;
    serviceSearchController.dimsBackgroundDuringPresentation = NO ;
    serviceSearchController.definesPresentationContext = YES ;
    serviceSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = serviceSearchController.searchBar ;
    serviceSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [serviceArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Service
        if (selectedSegment == SEARCH_SERVICE_SELECTED)
            [self getFindServiceWithSearchText:searchedString] ; // Find Service
        else
            [self getMyServiceListWithSearchText:searchedString] ; // My Service
    }
    else { // Service
        if (selectedSegment == MY_SERVICE_SELECTED)
            [self getMyServiceListWithSearchText:searchedString] ; // My Service
        else if (selectedSegment == ARCHIVE_SERVICE_SELECTED)
            [self getArchiveServiceList:searchedString] ; // Archived Service
        else
            [self getDeactivatedServiceList:searchedString] ; // Deactivated Service
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [serviceArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [serviceSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Service
        if (selectedSegment == SEARCH_SERVICE_SELECTED)
            [self getFindServiceWithSearchText:searchedString] ; // Find Service
        else
            [self getMyServiceListWithSearchText:searchedString] ; // My Service
    }
    else { // Service
        if (selectedSegment == MY_SERVICE_SELECTED)
            [self getMyServiceListWithSearchText:searchedString] ; // My Service
        else if (selectedSegment == ARCHIVE_SERVICE_SELECTED)
            [self getArchiveServiceList:searchedString] ; // Archived Service
        else
            [self getDeactivatedServiceList:searchedString] ; // Deactivated Service
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [serviceArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find Service
        selectedSegment = self.segmentControlSearchService.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_SERVICE_SELECTED) { //0
            [self getFindServiceWithSearchText:searchedString] ; // Find Service
            self.segmentControlMyService.hidden = true;
            addServiceBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyServiceListWithSearchText:searchedString] ; // My Service
            [self.segmentControlMyService setSelectedSegmentIndex:MY_SERVICE_SELECTED] ;
            self.segmentControlMyService.hidden = false;
            addServiceBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // Service
        selectedSegment = self.segmentControlMyService.selectedSegmentIndex;
        self.segmentControlMyService.hidden = false;
        addServiceBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_SERVICE_SELECTED) { //0
            [self getMyServiceListWithSearchText:searchedString] ; // My Service
            addServiceBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_SERVICE_SELECTED) { //1
            addServiceBtn.hidden = true;
            [self getArchiveServiceList:searchedString ] ; // Archived Service
        }
        else { //2
            [self getDeactivatedServiceList:searchedString] ; // Deactivated Service
            addServiceBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveService_ClickAction:(id)sender {
    
    if(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""]) {
        serviceID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kServiceAPI_ID];
    }
    else {
        serviceID = [[serviceArray objectAtIndex:[sender tag]] valueForKey: kServiceAPI_ID];
    }
    [self archiveService:serviceID];
}

- (IBAction)deactivateService_ClickAction:(id)sender {
    if(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""]) {
        serviceID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kServiceAPI_ID];
    }
    else {
        serviceID = [[serviceArray objectAtIndex:[sender tag]] valueForKey: kServiceAPI_ID];
    }
    [self deactivateService:serviceID];
}

- (IBAction)deleteService_ClickAction:(id)sender {
    if(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""])
        serviceID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kServiceAPI_ID];
    else
        serviceID = [[serviceArray objectAtIndex:[sender tag]] valueForKey: kServiceAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
        [self activateService:serviceID];
    else
        [self deleteService:serviceID];
}

- (IBAction)createServiceButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Services" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateServiceIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeService_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""])
        serviceID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kServiceAPI_ID];
    else
        serviceID = [[serviceArray objectAtIndex:[sender tag]] valueForKey: kServiceAPI_ID];
    
    [self likeService:serviceID];
}

- (IBAction)likeServiceList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""])
        serviceID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kServiceAPI_ID];
    else
        serviceID = [[serviceArray objectAtIndex:[sender tag]] valueForKey: kServiceAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeServiceList:serviceID];
    }
}

- (IBAction)dislikeService_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""])
        serviceID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kServiceAPI_ID];
    else
        serviceID = [[serviceArray objectAtIndex:[sender tag]] valueForKey: kServiceAPI_ID];
    
    [self dislikeService:serviceID];
}

- (IBAction)disLikeServiceList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""])
        serviceID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kServiceAPI_ID];
    else
        serviceID = [[serviceArray objectAtIndex:[sender tag]] valueForKey: kServiceAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeServiceList:serviceID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kServiceAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(serviceArray.count == totalItems)
                return serviceArray.count ;
            else
                return serviceArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kServiceAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kServiceAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kServiceAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""]) {
            {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Service] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kServiceAPI_Service_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kServiceAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kServiceAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kServiceAPI_Service_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kServiceAPI_Service_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kServiceAPI_Service_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Service
                    if (selectedSegment == SEARCH_SERVICE_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // My Service
                    if (selectedSegment == MY_SERVICE_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_SERVICE_SELECTED) {
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
            if(indexPath.row == serviceArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Service] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[serviceArray objectAtIndex:indexPath.row] valueForKey:kServiceAPI_Service_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[serviceArray objectAtIndex:indexPath.row] valueForKey:kServiceAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[serviceArray objectAtIndex:indexPath.row] valueForKey:kServiceAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[serviceArray objectAtIndex:indexPath.row] valueForKey:kServiceAPI_Service_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[serviceArray objectAtIndex:indexPath.row] valueForKey:kServiceAPI_Service_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[serviceArray objectAtIndex:indexPath.row] valueForKey:kServiceAPI_Service_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Service
                    if (selectedSegment == SEARCH_SERVICE_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Service
                    if (selectedSegment == MY_SERVICE_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_SERVICE_SELECTED) {
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
        if (serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find Service
                if (selectedSegment == SEARCH_SERVICE_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_SERVICE_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_SERVICE_SELECTED || selectedSegment == DEACTIVATED_SERVICE_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // Service
                if (selectedSegment == MY_SERVICE_SELECTED || selectedSegment == DEACTIVATED_SERVICE_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == serviceArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find Service
                    if (selectedSegment == SEARCH_SERVICE_SELECTED)
                        return 120;
                    else if (selectedSegment == ADD_SERVICE_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_SERVICE_SELECTED || selectedSegment == DEACTIVATED_SERVICE_SELECTED)
                            return 145;
                        else
                            return 120 ;
                    }
                }
                else { // Service
                    if (selectedSegment == MY_SERVICE_SELECTED || selectedSegment == DEACTIVATED_SERVICE_SELECTED)
                        return 145;
                    else
                        return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == serviceArray.count) {
//            [self getMyServiceListWithSearchText:searchedString] ; // My Service
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblView) {
        
        NSMutableArray *array ;
        if (serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""])
            array = [searchResults mutableCopy] ;
        else
            array = [serviceArray mutableCopy] ;
        
        if(indexPath.row != array.count) {
            
            [UtilityClass setServiceDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Services" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditServiceIdentifier] ;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
            
            [self.navigationController pushViewController:viewController animated:YES] ;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetServiceViewEditing object:nil userInfo:dict];
        }
    }
}

#pragma mark - Api Methods
-(void)getFindServiceWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kServiceAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kServiceAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kServiceAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchServiceWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kServiceAPI_ServiceList]) {
                    totalItems = [[responseDict valueForKey:kServiceAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [serviceArray removeAllObjects];
                    
                    if(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                    }
                    else {
                        [serviceArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                    }
                    lblNoServiceAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoServiceAvailable.hidden = false;
                if(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                }
                else {
                    serviceArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = serviceArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyServiceListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kServiceAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kServiceAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kServiceAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyServiceListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kServiceAPI_ServiceList]) {
                    totalItems = [[responseDict valueForKey:kServiceAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [serviceArray removeAllObjects];
                    
                    if(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                    }
                    else {
                        [serviceArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                    }
                    lblNoServiceAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoServiceAvailable.hidden = false;
                if(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                }
                else {
                    serviceArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = serviceArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveServiceList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kServiceAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kServiceAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kServiceAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveServiceListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kServiceAPI_ServiceList]) {
                    totalItems = [[responseDict valueForKey:kServiceAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [serviceArray removeAllObjects];
                    
                    if(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                    }
                    else {
                        [serviceArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                    }
                    lblNoServiceAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoServiceAvailable.hidden = false;
                if(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                }
                else {
                    serviceArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = serviceArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedServiceList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kServiceAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kServiceAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kServiceAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedServiceListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kServiceAPI_ServiceList]) {
                    totalItems = [[responseDict valueForKey:kServiceAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [serviceArray removeAllObjects];
                    
                    if(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                    }
                    else {
                        [serviceArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                    }
                    lblNoServiceAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoServiceAvailable.hidden = false;
                if(serviceSearchController.active && ![serviceSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                }
                else {
                    serviceArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kServiceAPI_ServiceList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = serviceArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveService:(NSString *)serviceId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kServiceAPI_UserID] ;
        [dictParam setObject:serviceId forKey:kServiceAPI_ServiceID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveServiceWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveService_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyServiceListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateService:(NSString *)serviceId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kServiceAPI_UserID] ;
        [dictParam setObject:serviceId forKey:kServiceAPI_ServiceID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateServiceWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedServiceList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateService_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateService:(NSString *)serviceId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kServiceAPI_UserID] ;
        [dictParam setObject:serviceId forKey:kServiceAPI_ServiceID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateServiceWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateService_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyServiceListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteService:(NSString *)serviceId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kServiceAPI_UserID] ;
        [dictParam setObject:serviceId forKey:kServiceAPI_ServiceID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteServiceWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteService_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyServiceListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeService:(NSString *)serviceId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kServiceAPI_Service_LikedBy] ;
        [dictParam setObject:serviceId forKey:kServiceAPI_ServiceID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeServiceWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kServiceAPI_Service_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kServiceAPI_Service_Dislikes]];
                
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

-(void)dislikeService:(NSString *)serviceId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kServiceAPI_Service_DislikedBy] ;
        [dictParam setObject:serviceId forKey:kServiceAPI_ServiceID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeServiceWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kServiceAPI_Service_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kServiceAPI_Service_Dislikes]];
                
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

-(void)getLikeServiceList:(NSString *)serviceId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:serviceId forKey:kServiceAPI_ServiceID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kServiceAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeServiceListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kServiceAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kServiceAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kServiceAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kServiceAPI_UserList]] ;
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

-(void)getdisLikeServiceList:(NSString *)serviceId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:serviceId forKey:kServiceAPI_ServiceID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kServiceAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeServiceListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kServiceAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kServiceAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kServiceAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kServiceAPI_UserList]] ;
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
