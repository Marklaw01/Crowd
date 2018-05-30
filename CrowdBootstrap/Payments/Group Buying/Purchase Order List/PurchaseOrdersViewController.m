//
//  PurchaseOrdersViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "PurchaseOrdersViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface PurchaseOrdersViewController ()

@end

@implementation PurchaseOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
//    [self navigationBarSettings] ;
//    [self revealViewSettings] ;
    [UtilityClass setComingFrom_PurchaseOrder_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_PurchaseOrder_AddEditScreen];

    if (isComeFromAddEdit) {
        pageNo = 1;
            if (selectedSegment == SEARCH_PURCHASE_ORDER_SELECTED)
                [self getFindPurchaseOrderWithSearchText:searchedString];
            else
                [self getMyPurchaseOrderListWithSearchText:searchedString];
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
    [self.segmentControlSearchPurchaseOrder setTitleTextAttributes:attributes
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
    
    purchaseOrderArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    addPurchaseOrderBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchPurchaseOrder setSelectedSegmentIndex:SEARCH_PURCHASE_ORDER_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get Purchase Order List
    [self getFindPurchaseOrderWithSearchText:searchedString];
}

-(void)configureSearchController {
    purchaseOrderSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    purchaseOrderSearchController.searchBar.placeholder = kSearchPurchaseOrderPlaceholder ;
    [purchaseOrderSearchController.searchBar sizeToFit] ;
    purchaseOrderSearchController.searchBar.text = searchedString;
    purchaseOrderSearchController.searchResultsUpdater = self ;
    purchaseOrderSearchController.dimsBackgroundDuringPresentation = NO ;
    purchaseOrderSearchController.definesPresentationContext = YES ;
    purchaseOrderSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = purchaseOrderSearchController.searchBar ;
    purchaseOrderSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [purchaseOrderArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegment == SEARCH_PURCHASE_ORDER_SELECTED)
        [self getFindPurchaseOrderWithSearchText:searchedString] ; // Find PurchaseOrder
    else
        [self getMyPurchaseOrderListWithSearchText:searchedString] ; // My PurchaseOrder
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [purchaseOrderArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [purchaseOrderSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegment == SEARCH_PURCHASE_ORDER_SELECTED)
        [self getFindPurchaseOrderWithSearchText:searchedString] ; // Find PurchaseOrder
    else
        [self getMyPurchaseOrderListWithSearchText:searchedString] ; // My PurchaseOrder
}

#pragma mark- IBAction Methods
- (IBAction)BackClick_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)segmentControlValueChanged:(id)sender {
    
    pageNo = 1 ;
    totalItems = 0 ;
    [purchaseOrderArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    selectedSegment = self.segmentControlSearchPurchaseOrder.selectedSegmentIndex;
        
    if (selectedSegment == SEARCH_PURCHASE_ORDER_SELECTED) { //0
        [self getFindPurchaseOrderWithSearchText:searchedString] ; // Find PurchaseOrder
        addPurchaseOrderBtn.hidden = true;
        constraintTblViewTop.constant = 1;
    }
    else { //1
        [self getMyPurchaseOrderListWithSearchText:searchedString] ; // My PurchaseOrder
        addPurchaseOrderBtn.hidden = false;
        constraintTblViewTop.constant = 30;
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)createPurchaseOrderButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GroupBuying" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreatePurchaseOrderIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likePurchaseOrder_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(purchaseOrderSearchController.active && ![purchaseOrderSearchController.searchBar.text isEqualToString:@""])
        purchaseOrderID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kPurchaseOrderAPI_ID];
    else
        purchaseOrderID = [[purchaseOrderArray objectAtIndex:[sender tag]] valueForKey: kPurchaseOrderAPI_ID];
    
    [self likePurchaseOrder:purchaseOrderID];
}

- (IBAction)likePurchaseOrderList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(purchaseOrderSearchController.active && ![purchaseOrderSearchController.searchBar.text isEqualToString:@""])
        purchaseOrderID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kPurchaseOrderAPI_ID];
    else
        purchaseOrderID = [[purchaseOrderArray objectAtIndex:[sender tag]] valueForKey: kPurchaseOrderAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikePurchaseOrderList:purchaseOrderID];
    }
}

- (IBAction)dislikePurchaseOrder_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(purchaseOrderSearchController.active && ![purchaseOrderSearchController.searchBar.text isEqualToString:@""])
        purchaseOrderID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kPurchaseOrderAPI_ID];
    else
        purchaseOrderID = [[purchaseOrderArray objectAtIndex:[sender tag]] valueForKey: kPurchaseOrderAPI_ID];
    
    [self dislikePurchaseOrder:purchaseOrderID];
}

- (IBAction)disLikePurchaseOrderList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(purchaseOrderSearchController.active && ![purchaseOrderSearchController.searchBar.text isEqualToString:@""])
        purchaseOrderID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kPurchaseOrderAPI_ID];
    else
        purchaseOrderID = [[purchaseOrderArray objectAtIndex:[sender tag]] valueForKey: kPurchaseOrderAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikePurchaseOrderList:purchaseOrderID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kPurchaseOrderAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (purchaseOrderSearchController.active && ![purchaseOrderSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(purchaseOrderArray.count == totalItems)
                return purchaseOrderArray.count ;
            else
                return purchaseOrderArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kPurchaseOrderAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kPurchaseOrderAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kPurchaseOrderAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (purchaseOrderSearchController.active && ![purchaseOrderSearchController.searchBar.text isEqualToString:@""]) {
            {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PurchaseOrder] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kPurchaseOrderAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kPurchaseOrderAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kPurchaseOrderAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kPurchaseOrderAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kPurchaseOrderAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kPurchaseOrderAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                return cell ;
            }
        } else {
            if(indexPath.row == purchaseOrderArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PurchaseOrder] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[purchaseOrderArray objectAtIndex:indexPath.row] valueForKey:kPurchaseOrderAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[purchaseOrderArray objectAtIndex:indexPath.row] valueForKey:kPurchaseOrderAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[purchaseOrderArray objectAtIndex:indexPath.row] valueForKey:kPurchaseOrderAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[purchaseOrderArray objectAtIndex:indexPath.row] valueForKey:kPurchaseOrderAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[purchaseOrderArray objectAtIndex:indexPath.row] valueForKey:kPurchaseOrderAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[purchaseOrderArray objectAtIndex:indexPath.row] valueForKey:kPurchaseOrderAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                return cell ;
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblViewPopUp) {
        return 60;
    } else {
        if (purchaseOrderSearchController.active && ![purchaseOrderSearchController.searchBar.text isEqualToString:@""]) {
            return 110 ;

//            if (selectedSegmentControl == 100) { // Find PurchaseOrder
//                if (selectedSegment == SEARCH_PURCHASEORDER_SELECTED)
//                    return 110;
//                else if (selectedSegment == ADD_PURCHASEORDER_SELECTED)
//                    return 145;
//                else {
//                    if (selectedSegment == MY_PURCHASEORDER_SELECTED || selectedSegment == DEACTIVATED_PURCHASEORDER_SELECTED)
//                        return 145;
//                    else
//                        return 110 ;
//                }
//            }
        }
        else {
            if(indexPath.row == purchaseOrderArray.count)
                return 30 ;
            else {
                return 120 ;

//                if (selectedSegmentControl == 100) { // Find Purchase Order
//                    if (selectedSegment == SEARCH_PURCHASEORDER_SELECTED)
//                        return 120;
//                    else if (selectedSegment == ADD_PURCHASEORDER_SELECTED)
//                        return 145;
//                    else {
//                        if (selectedSegment == MY_PURCHASEORDER_SELECTED || selectedSegment == DEACTIVATED_PURCHASEORDER_SELECTED)
//                            return 145;
//                        else
//                            return 120 ;
//                    }
//                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(purchaseOrderSearchController.active && ![purchaseOrderSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == purchaseOrderArray.count) {
//            [self getMyPurchaseOrderListWithSearchText:searchedString] ; // My Purchase Order
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblView) {
        NSMutableArray *array ;
        if (purchaseOrderSearchController.active && ![purchaseOrderSearchController.searchBar.text isEqualToString:@""])
            array = [searchResults mutableCopy] ;
        else
            array = [purchaseOrderArray mutableCopy] ;
        
        if(indexPath.row != array.count) {
            
            [UtilityClass setPurchaseOrderDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GroupBuying" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditPurchaseOrderIdentifier] ;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
            
            [self.navigationController pushViewController:viewController animated:YES] ;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPurchaseOrderViewEditing object:nil userInfo:dict];
        }
    }
}

#pragma mark - Api Methods
-(void)getFindPurchaseOrderWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kPurchaseOrderAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kPurchaseOrderAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kPurchaseOrderAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchPurchaseOrderWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kPurchaseOrderAPI_OrderList]) {
                    totalItems = [[responseDict valueForKey:kPurchaseOrderAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [purchaseOrderArray removeAllObjects];
                    
                    if(purchaseOrderSearchController.active && ![purchaseOrderSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kPurchaseOrderAPI_OrderList]] ;
                    }
                    else {
                        [purchaseOrderArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kPurchaseOrderAPI_OrderList]] ;
                    }
                    lblNoPurchaseOrderAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kPurchaseOrderAPI_OrderList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoPurchaseOrderAvailable.hidden = false;
                if(purchaseOrderSearchController.active && ![purchaseOrderSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kPurchaseOrderAPI_OrderList]] ;
                }
                else {
                    purchaseOrderArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kPurchaseOrderAPI_OrderList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = purchaseOrderArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyPurchaseOrderListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kPurchaseOrderAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kPurchaseOrderAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kPurchaseOrderAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyPurchaseOrderListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kPurchaseOrderAPI_OrderList]) {
                    totalItems = [[responseDict valueForKey:kPurchaseOrderAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [purchaseOrderArray removeAllObjects];
                    
                    if(purchaseOrderSearchController.active && ![purchaseOrderSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kPurchaseOrderAPI_OrderList]] ;
                    }
                    else {
                        [purchaseOrderArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kPurchaseOrderAPI_OrderList]] ;
                    }
                    lblNoPurchaseOrderAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kPurchaseOrderAPI_OrderList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoPurchaseOrderAvailable.hidden = false;
                if(purchaseOrderSearchController.active && ![purchaseOrderSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kPurchaseOrderAPI_OrderList]] ;
                }
                else {
                    purchaseOrderArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kPurchaseOrderAPI_OrderList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = purchaseOrderArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likePurchaseOrder:(NSString *)purchaseOrderId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kPurchaseOrderAPI_LikedBy] ;
        [dictParam setObject:purchaseOrderId forKey:kPurchaseOrderAPI_GroupBuyingID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likePurchaseOrderWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kPurchaseOrderAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kPurchaseOrderAPI_Dislikes]];
                
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

-(void)dislikePurchaseOrder:(NSString *)purchaseOrderId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kPurchaseOrderAPI_DislikedBy] ;
        [dictParam setObject:purchaseOrderId forKey:kPurchaseOrderAPI_GroupBuyingID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikePurchaseOrderWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kPurchaseOrderAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kPurchaseOrderAPI_Dislikes]];
                
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

-(void)getLikePurchaseOrderList:(NSString *)purchaseOrderId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:purchaseOrderId forKey:kPurchaseOrderAPI_GroupBuyingID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kPurchaseOrderAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikePurchaseOrderListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kPurchaseOrderAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kPurchaseOrderAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kPurchaseOrderAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kPurchaseOrderAPI_UserList]] ;
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

-(void)getdisLikePurchaseOrderList:(NSString *)purchaseOrderId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:purchaseOrderId forKey:kPurchaseOrderAPI_GroupBuyingID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kPurchaseOrderAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikePurchaseOrderListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kPurchaseOrderAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kPurchaseOrderAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kPurchaseOrderAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kPurchaseOrderAPI_UserList]] ;
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
