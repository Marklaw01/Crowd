//
//  MyConsultingProjectsViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyConsultingProjectsViewController.h"

#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyConsultingProjectsViewController ()

@end

@implementation MyConsultingProjectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_Consulting_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_Consulting_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find Consulting
    //        if (selectedSegment == SEARCH_CONSULTING_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find Consulting
            if (selectedSegment == SEARCH_CONSULTING_SELECTED) {
                [self getFindConsultingWithSearchText:searchedString];
            } else
                [self getMyConsultingListWithSearchText:searchedString];
        } else {// My Consulting
            if (selectedSegment == MY_CONSULTING_SELECTED) {
                [self getMyConsultingListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_CONSULTING_SELECTED) {
                [self getArchiveConsultingList:searchedString];
            } else if (selectedSegment == CLOSED_CONSULTING_SELECTED) {
                [self getClosedConsultingList:searchedString];
            } else {
                [self getInvitationConsultingList:searchedString];
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
    
    UIFont *font = [UIFont boldSystemFontOfSize:11.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segmentControlMyConsultingProjects setTitleTextAttributes:attributes
                                                       forState:UIControlStateNormal];
    [self.segmentControlSearchConsultingProjects setTitleTextAttributes:attributes
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
    
    consultingProjectsArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    searchResultsForUsers = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyConsultingProjects.hidden = true;
    addConsultingProjectBtn.hidden = true;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchConsultingProjects setSelectedSegmentIndex:SEARCH_CONSULTING_SELECTED] ;
    [self.segmentControlMyConsultingProjects setSelectedSegmentIndex:MY_CONSULTING_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get Consulting List
    [self getFindConsultingWithSearchText:searchedString];
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    [_segmentControlMyConsultingProjects setUserInteractionEnabled:true];
    [_segmentControlSearchConsultingProjects setUserInteractionEnabled:true];
}

-(void)configureSearchController {
    consultingProjectSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    consultingProjectSearchController.searchBar.placeholder = kSearchConsultingPlaceholder ;
    [consultingProjectSearchController.searchBar sizeToFit] ;
    consultingProjectSearchController.searchBar.text = searchedString;
    consultingProjectSearchController.searchResultsUpdater = self ;
    consultingProjectSearchController.dimsBackgroundDuringPresentation = NO ;
    consultingProjectSearchController.definesPresentationContext = YES ;
    consultingProjectSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = consultingProjectSearchController.searchBar ;
    consultingProjectSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [consultingProjectsArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Consulting
        if (selectedSegment == SEARCH_CONSULTING_SELECTED)
            [self getFindConsultingWithSearchText:searchedString] ; // Find Consulting
        else
            [self getMyConsultingListWithSearchText:searchedString] ; // My Consulting
    }
    else { // Consulting
        if (selectedSegment == MY_CONSULTING_SELECTED)
            [self getMyConsultingListWithSearchText:searchedString] ; // My Consulting
        else if (selectedSegment == ARCHIVE_CONSULTING_SELECTED)
            [self getArchiveConsultingList:searchedString] ; // Archived Consulting
        else if (selectedSegment == CLOSED_CONSULTING_SELECTED)
            [self getClosedConsultingList:searchedString];// Closed Consulting
        else
            [self getInvitationConsultingList:searchedString]; // Invitation Consulting
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [consultingProjectsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [consultingProjectSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find Consulting
        if (selectedSegment == SEARCH_CONSULTING_SELECTED)
            [self getFindConsultingWithSearchText:searchedString] ; // Find Consulting
        else
            [self getMyConsultingListWithSearchText:searchedString] ; // My Consulting
    }
    else { // Consulting
        if (selectedSegment == MY_CONSULTING_SELECTED)
            [self getMyConsultingListWithSearchText:searchedString] ; // My Consulting
        else if (selectedSegment == ARCHIVE_CONSULTING_SELECTED)
            [self getArchiveConsultingList:searchedString] ; // Archived Consulting
        else if (selectedSegment == CLOSED_CONSULTING_SELECTED)
            [self getClosedConsultingList:searchedString];// Closed Consulting
        else
            [self getInvitationConsultingList:searchedString]; // Invitation Consulting
    }
}

#pragma mark - SearchBar Delegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //    if(searchText.length < 1 || [searchText isEqualToString:@" "])
    //        return ;
    if([searchBar tag] == 20) {
        pageNo = 1 ;
        totalItems = 0 ;
        [usersArray removeAllObjects] ;
        [searchResultsForUsers removeAllObjects] ;
        [tblViewPopUp reloadData] ;
        
        [self getConsultingCommitmentList:searchText consultingID:consultingProjectID];
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [consultingProjectsArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find Consulting
        selectedSegment = self.segmentControlSearchConsultingProjects.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_CONSULTING_SELECTED) { //0
            [self getFindConsultingWithSearchText:searchedString] ; // Find Consulting
            self.segmentControlMyConsultingProjects.hidden = true;
            addConsultingProjectBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyConsultingListWithSearchText:searchedString] ; // My Consulting
            [self.segmentControlMyConsultingProjects setSelectedSegmentIndex:MY_CONSULTING_SELECTED] ;
            self.segmentControlMyConsultingProjects.hidden = false;
            addConsultingProjectBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // Consulting
        selectedSegment = self.segmentControlMyConsultingProjects.selectedSegmentIndex;
        self.segmentControlMyConsultingProjects.hidden = false;
        addConsultingProjectBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_CONSULTING_SELECTED) { //0
            [self getMyConsultingListWithSearchText:searchedString] ; // My Consulting
            addConsultingProjectBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_CONSULTING_SELECTED) { //1
            addConsultingProjectBtn.hidden = true;
            [self getArchiveConsultingList:searchedString ] ; // Archived Consulting
        }
        else if (selectedSegment == CLOSED_CONSULTING_SELECTED){ //2
            [self getClosedConsultingList:searchedString] ; // Closed Consulting
            addConsultingProjectBtn.hidden = true;
        } else { //3
            [self getInvitationConsultingList:searchedString] ; // Invitation Consulting
            addConsultingProjectBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveConsulting_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];

    if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""]) {
        consultingProjectID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kConsultingAPI_ID];
        invitationSenderID = [[searchResults objectAtIndex:[sender tag]] valueForKey: @"sender_id"];

    }
    else {
        consultingProjectID = [[consultingProjectsArray objectAtIndex:[sender tag]] valueForKey: kConsultingAPI_ID];
        invitationSenderID = [[consultingProjectsArray objectAtIndex:[sender tag]] valueForKey: @"sender_id"];
    }
    
    if (selectedSegmentControl == 200 && selectedSegment == 3) // Accept Invitation
        [self acceptConsultingInvitation:consultingProjectID senderId:invitationSenderID];
    else // Archive Invitation
        [self archiveConsulting:consultingProjectID];
}

- (IBAction)closeConsulting_ClickAction:(id)sender {

    if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""]) {
        consultingProjectID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kConsultingAPI_ID];
    }
    else {
        consultingProjectID = [[consultingProjectsArray objectAtIndex:[sender tag]] valueForKey: kConsultingAPI_ID];
    }
    
    pageNo = 1;
    searchBarUsers.hidden = false;
    lblPeople.hidden = true;
    imgVwPeople.hidden = true;
    
    [self getConsultingCommitmentList:searchedString consultingID:consultingProjectID];
}

- (IBAction)deleteConsulting_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];

    if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""]) {
        consultingProjectID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kConsultingAPI_ID];
        invitationSenderID = [[searchResults objectAtIndex:[sender tag]] valueForKey: @"sender_id"];
    }
    else {
        consultingProjectID = [[consultingProjectsArray objectAtIndex:[sender tag]] valueForKey: kConsultingAPI_ID];
        invitationSenderID = [[consultingProjectsArray objectAtIndex:[sender tag]] valueForKey: @"sender_id"];
    }
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)// Open Invitation
        [self openConsulting:consultingProjectID];
    else if (selectedSegmentControl == 200 && selectedSegment == 3)  // Reject Invitation
        [self rejectConsultingInvitation:consultingProjectID senderId:invitationSenderID];
    else // Delete Invitation
        [self deleteConsulting:consultingProjectID];
}

- (IBAction)createConsultingButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Consulting" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateConsultingIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeConsulting_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""])
        consultingProjectID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kConsultingAPI_ID];
    else
        consultingProjectID = [[consultingProjectsArray objectAtIndex:[sender tag]] valueForKey: kConsultingAPI_ID];
    
    [self likeConsulting:consultingProjectID];
}

- (IBAction)likeConsultingList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    searchBarUsers.hidden = true;
    lblPeople.hidden = false;
    imgVwPeople.hidden = false;

    if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""])
        consultingProjectID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kConsultingAPI_ID];
    else
        consultingProjectID = [[consultingProjectsArray objectAtIndex:[sender tag]] valueForKey: kConsultingAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeConsultingList:consultingProjectID];
    }
}

- (IBAction)dislikeConsulting_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""])
        consultingProjectID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kConsultingAPI_ID];
    else
        consultingProjectID = [[consultingProjectsArray objectAtIndex:[sender tag]] valueForKey: kConsultingAPI_ID];
    
    [self dislikeConsulting:consultingProjectID];
}

- (IBAction)disLikeConsultingList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    searchBarUsers.hidden = true;
    lblPeople.hidden = false;
    imgVwPeople.hidden = false;
    
    if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""])
        consultingProjectID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kConsultingAPI_ID];
    else
        consultingProjectID = [[consultingProjectsArray objectAtIndex:[sender tag]] valueForKey: kConsultingAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdislikeConsultingList:consultingProjectID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(![searchBarUsers.text isEqualToString:@""])
        [dict setValue:[[searchResultsForUsers objectAtIndex:[sender tag]] valueForKey:kConsultingAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    else
        [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kConsultingAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
    viewController.profileMode = [NSString stringWithFormat:@"%d",PROFILE_MODE_SEARCH] ;
    [UtilityClass setViewEntProfileMode:NO] ;
    [UtilityClass setUserType:CONTRACTOR] ;
    [UtilityClass setProfileMode:PROFILE_MODE_SEARCH] ;
    
    [UtilityClass setContractorDetails:[dict mutableCopy]] ;
    NSLog(@"getContractorDetails: %@",[UtilityClass getContractorDetails]) ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)ok_ClickAction:(id)sender {
    if ([btnOk.titleLabel.text isEqualToString:@"Close Without Awarding"])
        [self closeConsulting:consultingProjectID];
    else {
    }
    
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    [_segmentControlMyConsultingProjects setUserInteractionEnabled:true];
    [_segmentControlSearchConsultingProjects setUserInteractionEnabled:true];
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tblViewPopUp) {
        if (![searchBarUsers.text isEqualToString:@""])
            return searchResultsForUsers.count ;
        else
            return usersArray.count;
    } else {
        if (consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(consultingProjectsArray.count == totalItems)
                return consultingProjectsArray.count ;
            else
                return consultingProjectsArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        tableView.allowsMultipleSelection = NO;

        if (![searchBarUsers.text isEqualToString:@""]) {
            UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
            cell.lblName.text = [NSString stringWithFormat:@"%@",[[searchResultsForUsers objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_User_Name]] ;
            cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResultsForUsers objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_User_Desc]];
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResultsForUsers objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            
            cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
            cell.imgView.clipsToBounds = YES;
            
            cell.btnViewProfile.tag = indexPath.row;
            
            return cell;
        } else {
            UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
            cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_User_Name]] ;
            cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_User_Desc]];
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            
            cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
            cell.imgView.clipsToBounds = YES;
            
            cell.btnViewProfile.tag = indexPath.row;
            
            return cell;
        }
    } else {
        if (consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""]) {
            FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Consulting] ;
            
            cell.btnLikeCount.tag = indexPath.row;
            cell.btnDislikeCount.tag = indexPath.row;
            cell.btnLike.tag = indexPath.row;
            cell.btnDislike.tag = indexPath.row;
            cell.btnArchive.tag = indexPath.row;
            cell.btnDeactivate.tag = indexPath.row;
            cell.btnDelete.tag = indexPath.row;
            
            cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_Title]] ;
            cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_Project_Start_Date]];
            cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_Description]];
            
            /* award_status :
             ** 0=> Not Awarded(Open)
             ** 1=> Awarded(Closed)
             ** 2=> Upcoming
             */
            if ([[[searchResults objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_AwardStatus] intValue] == 0)
                cell.lblAwardStatus.text = @"Status: Not Awarded";
            else if ([[[searchResults objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_AwardStatus] intValue] == 1)
                cell.lblAwardStatus.text = @"Status: Awarded";
            else
                cell.lblAwardStatus.text = @"Status: Upcoming";

            [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_Likes]] forState:UIControlStateNormal];
            [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_Dislikes]] forState:UIControlStateNormal];
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            
            cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
            cell.imgView.clipsToBounds = YES;
            
            if (selectedSegmentControl == 100) { // Find Consulting
                if (selectedSegment == SEARCH_CONSULTING_SELECTED) {
                    cell.btnArchive.hidden = true;
                    cell.btnDeactivate.hidden = true;
                    cell.btnDelete.hidden = true;
                    cell.lblAwardStatus.hidden = false;
                    cell.lblWinningBidder.hidden = true;
                    cell.lblInvitationSender.hidden = true;

                    cell.constraintLblStatusTop.constant = 21;
                } else {
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                    cell.lblAwardStatus.hidden = true;
                    cell.lblWinningBidder.hidden = true;
                    cell.lblInvitationSender.hidden = true;
                }
            }
            else { // My Consulting
                if (selectedSegment == MY_CONSULTING_SELECTED) { // My Assignment
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = false;
                    cell.btnDelete.hidden = false;
                    cell.lblAwardStatus.hidden = true;
                    cell.lblWinningBidder.hidden = true;
                    cell.lblInvitationSender.hidden = true;

                    [cell.btnArchive setTitle:@"Archive" forState:UIControlStateNormal];
                    [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                    cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                } else if (selectedSegment == CLOSED_CONSULTING_SELECTED) { // Closed
                    cell.btnArchive.hidden = true;
                    cell.btnDeactivate.hidden = true;
                    cell.btnDelete.hidden = false;
                    cell.lblAwardStatus.hidden = true;
                    cell.lblInvitationSender.hidden = true;

                    if (![[[searchResults objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_WinningBidder] isEqualToString:@""]) {
                        cell.lblWinningBidder.text = [NSString stringWithFormat:@"Winning Bidder: %@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_WinningBidder]];
                        cell.lblWinningBidder.hidden = false;
                    } else
                        cell.lblWinningBidder.hidden = true;
                    
                    [cell.btnDelete setTitle:@"Open" forState:UIControlStateNormal];
                    cell.btnDelete.backgroundColor = [UIColor colorWithRed:9.0/255.0 green:89.0/255.0 blue:0.0/255.0 alpha:1.0f];
                } else if (selectedSegment == ARCHIVE_CONSULTING_SELECTED) { // Archived
                    cell.btnArchive.hidden = true;
                    cell.btnDeactivate.hidden = true;
                    cell.btnDelete.hidden = true;
                    cell.lblAwardStatus.hidden = true;
                    cell.lblWinningBidder.hidden = true;
                    cell.lblInvitationSender.hidden = true;

                } else {                                    // Invitation
                    cell.btnArchive.hidden = false;
                    cell.btnDeactivate.hidden = true;
                    cell.btnDelete.hidden = false;
                    cell.lblAwardStatus.hidden = false;
                    cell.lblWinningBidder.hidden = true;
                    cell.lblInvitationSender.hidden = false;

                    cell.lblInvitationSender.text = [NSString stringWithFormat:@"Invitation sent from %@",[[searchResults objectAtIndex:indexPath.row] valueForKey:@"sender_name"]];
                    
                    cell.constraintLblStatusTop.constant = 0;
                    
                    [cell.btnArchive setTitle:@"Accept" forState:UIControlStateNormal];
                    [cell.btnDelete setTitle:@"Reject" forState:UIControlStateNormal];
                    cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                }
            }
            
            return cell ;
        } else {
            
            if(indexPath.row == consultingProjectsArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Consulting] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[consultingProjectsArray objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[consultingProjectsArray objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_Project_Start_Date]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[consultingProjectsArray objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_Description]];
                
                /* award_status :
                 ** 0=> Not Awarded(Open)
                 ** 1=> Awarded(Closed)
                 ** 2=> Upcoming
                 */
                if ([[[consultingProjectsArray objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_AwardStatus] intValue] == 0)
                    cell.lblAwardStatus.text = @"Status: Not Awarded";
                else if ([[[consultingProjectsArray objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_AwardStatus] intValue] == 1)
                    cell.lblAwardStatus.text = @"Status: Awarded";
                else
                    cell.lblAwardStatus.text = @"Status: Upcoming";
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[consultingProjectsArray objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[consultingProjectsArray objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[consultingProjectsArray objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Consulting
                    if (selectedSegment == SEARCH_CONSULTING_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                        cell.lblAwardStatus.hidden = false;
                        cell.lblWinningBidder.hidden = true;
                        cell.lblInvitationSender.hidden = true;

                        cell.constraintLblStatusTop.constant = 21;

                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        cell.lblAwardStatus.hidden = true;
                        cell.lblWinningBidder.hidden = true;
                        cell.lblInvitationSender.hidden = true;
                    }
                }
                else { // My Consulting
                    if (selectedSegment == MY_CONSULTING_SELECTED) { // My Assignment
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        cell.lblAwardStatus.hidden = true;
                        cell.lblWinningBidder.hidden = true;
                        cell.lblInvitationSender.hidden = true;

                        [cell.btnArchive setTitle:@"Archive" forState:UIControlStateNormal];
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == CLOSED_CONSULTING_SELECTED) { // Closed
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = false;
                        cell.lblAwardStatus.hidden = true;
                        cell.lblInvitationSender.hidden = true;

                        if (![[[consultingProjectsArray objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_WinningBidder] isEqualToString:@""]) {
                            cell.lblWinningBidder.text = [NSString stringWithFormat:@"Winning Bidder: %@",[[consultingProjectsArray objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_WinningBidder]];
                            cell.lblWinningBidder.hidden = false;
                        } else
                            cell.lblWinningBidder.hidden = true;
                        
                        [cell.btnDelete setTitle:@"Open" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:9.0/255.0 green:89.0/255.0 blue:0.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == ARCHIVE_CONSULTING_SELECTED) { // Archived
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                        cell.lblAwardStatus.hidden = true;
                        cell.lblWinningBidder.hidden = true;
                        cell.lblInvitationSender.hidden = true;
                    } else {                                    // Invitation
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = false;
                        cell.lblAwardStatus.hidden = false;
                        cell.lblWinningBidder.hidden = true;
                        cell.lblInvitationSender.hidden = false;
                        
                        cell.lblInvitationSender.text = [NSString stringWithFormat:@"Invitation sent from %@",[[consultingProjectsArray objectAtIndex:indexPath.row] valueForKey:@"sender_name"]];

                        cell.constraintLblStatusTop.constant = 0;
                        
                        [cell.btnArchive setTitle:@"Accept" forState:UIControlStateNormal];
                        [cell.btnDelete setTitle:@"Reject" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
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
        if (consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find Consulting
                return 145;
            }
            else { // My Consulting
                if (selectedSegment == ARCHIVE_CONSULTING_SELECTED)
                    return 110;
                else if (selectedSegment == INVITATION_CONSULTING_SELECTED || selectedSegment == CLOSED_CONSULTING_SELECTED)
                    return 175;
                else
                    return 145 ;
            }
        }
        else {
            if(indexPath.row == consultingProjectsArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find Consulting
                    return 145 ;
                }
                else { // My Consulting
                    if (selectedSegment == ARCHIVE_CONSULTING_SELECTED)
                        return 115;
                    else if (selectedSegment == INVITATION_CONSULTING_SELECTED || selectedSegment == CLOSED_CONSULTING_SELECTED)
                        return 175;
                    else
                        return 145 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == consultingProjectsArray.count) {
//            [self getMyConsultingListWithSearchText:searchedString] ; // My Consulting
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblView) {
        NSMutableArray *array ;
        if (consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""])
            array = [searchResults mutableCopy] ;
        else
            array = [consultingProjectsArray mutableCopy] ;
        
        if(indexPath.row != array.count) {
            
            [UtilityClass setConsultingDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Consulting" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditConsultingIdentifier] ;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
            
            [self.navigationController pushViewController:viewController animated:YES] ;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetConsultingViewEditing object:nil userInfo:dict];
        }
    } else {
        if(lastSelectedIndexPath) {
            UserFundTableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastSelectedIndexPath];
            lastCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UserFundTableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath] ;
        currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        lastSelectedIndexPath = indexPath;
        
        selectedContractorID = [[usersArray objectAtIndex:indexPath.row] valueForKey:kConsultingAPI_User_ID];
    }
}

#pragma mark - Api Methods
-(void)getFindConsultingWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConsultingAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kConsultingAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchConsultingWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kConsultingAPI_ConsultingList]) {
                    totalItems = [[responseDict valueForKey:kConsultingAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [consultingProjectsArray removeAllObjects];
                    
                    if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                    }
                    else {
                        [consultingProjectsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                    }
                    lblNoConsultingProjectAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoConsultingProjectAvailable.hidden = false;
                if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                }
                else {
                    consultingProjectsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = consultingProjectsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyConsultingListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConsultingAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kConsultingAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyConsultingListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kConsultingAPI_ConsultingList]) {
                    totalItems = [[responseDict valueForKey:kConsultingAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [consultingProjectsArray removeAllObjects];
                    
                    if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                    }
                    else {
                        [consultingProjectsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                    }
                    lblNoConsultingProjectAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoConsultingProjectAvailable.hidden = false;
                if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                }
                else {
                    consultingProjectsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = consultingProjectsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveConsultingList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConsultingAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kConsultingAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveConsultingListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kConsultingAPI_ConsultingList]) {
                    totalItems = [[responseDict valueForKey:kConsultingAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [consultingProjectsArray removeAllObjects];
                    
                    if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                    }
                    else {
                        [consultingProjectsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                    }
                    lblNoConsultingProjectAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoConsultingProjectAvailable.hidden = false;
                if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                }
                else {
                    consultingProjectsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = consultingProjectsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getClosedConsultingList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConsultingAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kConsultingAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getClosedConsultingListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kConsultingAPI_ConsultingList]) {
                    totalItems = [[responseDict valueForKey:kConsultingAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [consultingProjectsArray removeAllObjects];
                    
                    if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                    }
                    else {
                        [consultingProjectsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                    }
                    lblNoConsultingProjectAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoConsultingProjectAvailable.hidden = false;
                if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                }
                else {
                    consultingProjectsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_ConsultingList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = consultingProjectsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getInvitationConsultingList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConsultingAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kConsultingAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getInvitationConsultingListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kConsultingAPI_InvitationList]) {
                    totalItems = [[responseDict valueForKey:kConsultingAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [consultingProjectsArray removeAllObjects];
                    
                    if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_InvitationList]] ;
                    }
                    else {
                        [consultingProjectsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_InvitationList]] ;
                    }
                    lblNoConsultingProjectAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_InvitationList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoConsultingProjectAvailable.hidden = false;
                if(consultingProjectSearchController.active && ![consultingProjectSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_InvitationList]] ;
                }
                else {
                    consultingProjectsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_InvitationList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = consultingProjectsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveConsulting:(NSString *)consultingProjectId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_UserID] ;
        [dictParam setObject:consultingProjectId forKey:kConsultingAPI_ConsultingID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveConsultingWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kArchiveConsultingProject_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyConsultingListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)openConsulting:(NSString *)consultingProjectId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_UserID] ;
        [dictParam setObject:consultingProjectId forKey:kConsultingAPI_ConsultingID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap openConsultingWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getClosedConsultingList:searchedString];
                [UtilityClass showNotificationMessgae:kOpenConsultingProject_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)closeConsulting:(NSString *)consultingProjectId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_UserID] ;
        [dictParam setObject:consultingProjectId forKey:kConsultingAPI_ConsultingID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",selectedContractorID] forKey:@"contractor_id"] ;

        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap closeConsultingWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kCloseConsultingProject_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyConsultingListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getConsultingCommitmentList:(NSString *)searchText consultingID:(NSString *)consultingProjectId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConsultingAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kConsultingAPI_SearchText] ;
        [dictParam setObject:consultingProjectId forKey:kConsultingAPI_ConsultingID] ;

        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getConsultingCommitmentListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kConsultingAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kConsultingAPI_TotalItems] integerValue] ;
                    
                    [usersArray removeAllObjects];
                    [searchResultsForUsers removeAllObjects];
                    
                    if(![searchBarUsers.text isEqualToString:@""]){
                        searchResultsForUsers = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_UserList]] ;
                    }
                    else {
                        [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_UserList]] ;
                    }
                    
                    lblNoUserAvailable.hidden = true;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_UserList]] ;
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
            {
                if(![searchBarUsers.text isEqualToString:@""])
                    searchResultsForUsers = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_UserList]] ;
                else
                    usersArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConsultingAPI_UserList]] ;
                
                lblNoUserAvailable.hidden = false;
            }
            [viewPopUp setHidden:false];
            [btnOk setTitle:@"Close Without Awarding" forState:UIControlStateNormal];
            
            [tblView setUserInteractionEnabled:false];
            [_segmentControlMyConsultingProjects setUserInteractionEnabled:false];
            [_segmentControlSearchConsultingProjects setUserInteractionEnabled:false];

            [tblViewPopUp reloadData] ;
            [searchBarUsers resignFirstResponder];

        } failure:^(NSError *error) {
            totalItems = usersArray.count;
            [tblViewPopUp reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteConsulting:(NSString *)consultingProjectId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_UserID] ;
        [dictParam setObject:consultingProjectId forKey:kConsultingAPI_ConsultingID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteConsultingWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteConsultingProject_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyConsultingListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeConsulting:(NSString *)consultingProjectId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_LikedBy] ;
        [dictParam setObject:consultingProjectId forKey:kConsultingAPI_ConsultingID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeConsultingWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kConsultingAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kConsultingAPI_Dislikes]];
                
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

-(void)dislikeConsulting:(NSString *)consultingProjectId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_DislikedBy] ;
        [dictParam setObject:consultingProjectId forKey:kConsultingAPI_ConsultingID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeConsultingWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kConsultingAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kConsultingAPI_Dislikes]];
                
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

-(void)getLikeConsultingList:(NSString *)consultingProjectId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:consultingProjectId forKey:kConsultingAPI_ConsultingID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConsultingAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeConsultingListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kConsultingAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kConsultingAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [btnOk setTitle:@"OK" forState:UIControlStateNormal];

                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_UserList]] ;
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

-(void)getdislikeConsultingList:(NSString *)consultingProjectId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:consultingProjectId forKey:kConsultingAPI_ConsultingID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConsultingAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeConsultingListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kConsultingAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kConsultingAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [btnOk setTitle:@"OK" forState:UIControlStateNormal];

                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kConsultingAPI_UserList]] ;
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

-(void)acceptConsultingInvitation:(NSString *)consultingProjectId senderId:(NSString *)senderID {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_UserID] ;
        [dictParam setObject:consultingProjectId forKey:kConsultingAPI_ConsultingID] ;
        [dictParam setObject:senderID forKey:kConsultingAPI_InvitationSentBy] ;

        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap acceptConsultingInvitationWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kAcceptConsultingProject_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getInvitationConsultingList:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)rejectConsultingInvitation:(NSString *)consultingProjectId senderId:(NSString *)senderID {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_UserID] ;
        [dictParam setObject:consultingProjectId forKey:kConsultingAPI_ConsultingID] ;
        [dictParam setObject:senderID forKey:kConsultingAPI_InvitationSentBy] ;

        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap rejectConsultingInvitationWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kRejectConsultingProject_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getInvitationConsultingList:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

@end
