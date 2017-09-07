//
//  MyAudioVideoViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MyAudioVideoViewController.h"
#import "SWRevealViewController.h"
#import "FundsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface MyAudioVideoViewController ()

@end

@implementation MyAudioVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [UtilityClass setComingFrom_AudioVideo_AddEditScreen:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL isComeFromAddEdit = [UtilityClass checkIsComingFrom_AudioVideo_AddEditScreen];
    //    if (selectedSegmentControl == 100) { // Find AudioVideo
    //        if (selectedSegment == SEARCH_AUDIOVIDEO_SELECTED) {
    //            isComeFromAddEdit = NO;
    //        }
    //    }
    if (isComeFromAddEdit) {
        pageNo = 1;
        if (selectedSegmentControl == 100) { // Find AudioVideo
            if (selectedSegment == SEARCH_AUDIOVIDEO_SELECTED) {
                [self getFindAudioVideoWithSearchText:searchedString];
            } else
                [self getMyAudioVideoListWithSearchText:searchedString];
        } else {// My AudioVideo
            if (selectedSegment == MY_AUDIOVIDEO_SELECTED) {
                [self getMyAudioVideoListWithSearchText:searchedString];
            }
            else if (selectedSegment == ARCHIVE_AUDIOVIDEO_SELECTED) {
                [self getArchiveAudioVideoList:searchedString];
            } else {
                [self getDeactivatedAudioVideoList:searchedString];
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
    [self.segmentControlMyAudioVideos setTitleTextAttributes:attributes
                                                  forState:UIControlStateNormal];
    [self.segmentControlSearchAudioVideos setTitleTextAttributes:attributes
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
    
    audioVideoArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init];
    
    pageNo = 1;
    totalItems = 0 ;
    likeCount = 0;
    dislikeCount = 0;
    rowIndex = 0;
    
    self.segmentControlMyAudioVideos.hidden = true;
    addAudioVideoBtn.hidden = TRUE;
    
    selectedSegmentControl = 100;
    constraintTblViewTop.constant = 1;
    [self.segmentControlSearchAudioVideos setSelectedSegmentIndex:SEARCH_AUDIOVIDEO_SELECTED] ;
    [self.segmentControlMyAudioVideos setSelectedSegmentIndex:MY_AUDIOVIDEO_SELECTED] ;
    [self configureSearchController];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Hit Service to get My AudioVideo List
    [self getFindAudioVideoWithSearchText:searchedString];
}

-(void)configureSearchController {
    audioVideoSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    audioVideoSearchController.searchBar.placeholder = kSearchAudioVideoPlaceholder ;
    [audioVideoSearchController.searchBar sizeToFit] ;
    audioVideoSearchController.searchBar.text = searchedString;
    audioVideoSearchController.searchResultsUpdater = self ;
    audioVideoSearchController.dimsBackgroundDuringPresentation = NO ;
    audioVideoSearchController.definesPresentationContext = YES ;
    audioVideoSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = audioVideoSearchController.searchBar ;
    audioVideoSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [audioVideoArray removeAllObjects] ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find AudioVideo
        if (selectedSegment == SEARCH_AUDIOVIDEO_SELECTED)
            [self getFindAudioVideoWithSearchText:searchedString] ; // Find AudioVideo
        else
            [self getMyAudioVideoListWithSearchText:searchedString] ; // My AudioVideo
    }
    else { // AudioVideo
        if (selectedSegment == MY_AUDIOVIDEO_SELECTED)
            [self getMyAudioVideoListWithSearchText:searchedString] ; // My AudioVideo
        else if (selectedSegment == ARCHIVE_AUDIOVIDEO_SELECTED)
            [self getArchiveAudioVideoList:searchedString] ; // Archived AudioVideo
        else
            [self getDeactivatedAudioVideoList:searchedString] ; // Deactivated AudioVideo
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [audioVideoArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [audioVideoSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    if (selectedSegmentControl == 100) { // Find AudioVideo
        if (selectedSegment == SEARCH_AUDIOVIDEO_SELECTED)
            [self getFindAudioVideoWithSearchText:searchedString] ; // Find AudioVideo
        else
            [self getMyAudioVideoListWithSearchText:searchedString] ; // My AudioVideo
    }
    else { // AudioVideo
        if (selectedSegment == MY_AUDIOVIDEO_SELECTED)
            [self getMyAudioVideoListWithSearchText:searchedString] ; // My AudioVideo
        else if (selectedSegment == ARCHIVE_AUDIOVIDEO_SELECTED)
            [self getArchiveAudioVideoList:searchedString] ; // Archived AudioVideo
        else
            [self getDeactivatedAudioVideoList:searchedString] ; // Deactivated AudioVideo
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegmentControl = [sender tag];
    
    pageNo = 1 ;
    totalItems = 0 ;
    [audioVideoArray removeAllObjects] ;
    [usersArray removeAllObjects];
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    if (selectedSegmentControl == 100) { // Find AudioVideo
        selectedSegment = self.segmentControlSearchAudioVideos.selectedSegmentIndex;
        
        if (selectedSegment == SEARCH_AUDIOVIDEO_SELECTED) { //0
            [self getFindAudioVideoWithSearchText:searchedString] ; // Find AudioVideo
            self.segmentControlMyAudioVideos.hidden = true;
            addAudioVideoBtn.hidden = true;
            constraintTblViewTop.constant = 1;
        }
        else { //1
            [self getMyAudioVideoListWithSearchText:searchedString] ; // My AudioVideo
            [self.segmentControlMyAudioVideos setSelectedSegmentIndex:MY_AUDIOVIDEO_SELECTED] ;
            self.segmentControlMyAudioVideos.hidden = false;
            addAudioVideoBtn.hidden = false;
            constraintTblViewTop.constant = 30;
        }
    }
    else { // AudioVideo
        selectedSegment = self.segmentControlMyAudioVideos.selectedSegmentIndex;
        self.segmentControlMyAudioVideos.hidden = false;
        addAudioVideoBtn.hidden = false;
        constraintTblViewTop.constant = 30;
        
        if (selectedSegment == MY_AUDIOVIDEO_SELECTED) { //0
            [self getMyAudioVideoListWithSearchText:searchedString] ; // My AudioVideo
            addAudioVideoBtn.hidden = false;
        }
        else if (selectedSegment == ARCHIVE_AUDIOVIDEO_SELECTED) { //1
            addAudioVideoBtn.hidden = true;
            [self getArchiveAudioVideoList:searchedString ] ; // Archived AudioVideo
        }
        else { //2
            [self getDeactivatedAudioVideoList:searchedString] ; // Deactivated AudioVideo
            addAudioVideoBtn.hidden = true;
        }
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)archiveAudioVideo_ClickAction:(id)sender {
    
    if(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""]) {
        audioVideoID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kAudioVideoAPI_ID];
    }
    else {
        audioVideoID = [[audioVideoArray objectAtIndex:[sender tag]] valueForKey: kAudioVideoAPI_ID];
    }
    [self archiveAudioVideo:audioVideoID];
}

- (IBAction)deactivateAudioVideo_ClickAction:(id)sender {
    if(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""]) {
        audioVideoID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kAudioVideoAPI_ID];
    }
    else {
        audioVideoID = [[audioVideoArray objectAtIndex:[sender tag]] valueForKey: kAudioVideoAPI_ID];
    }
    [self deactivateAudioVideo:audioVideoID];
}

- (IBAction)deleteAudioVideo_ClickAction:(id)sender {
    if(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""])
        audioVideoID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kAudioVideoAPI_ID];
    else
        audioVideoID = [[audioVideoArray objectAtIndex:[sender tag]] valueForKey: kAudioVideoAPI_ID];
    
    if (selectedSegmentControl == 200 && selectedSegment == 2)
        [self activateAudioVideo:audioVideoID];
    else
        [self deleteAudioVideo:audioVideoID];
}

- (IBAction)createAudioVideoButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AudioVideo" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kCreateAudioVideoIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)likeAudioVideo_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    
    if(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""])
        audioVideoID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kAudioVideoAPI_ID];
    else
        audioVideoID = [[audioVideoArray objectAtIndex:[sender tag]] valueForKey: kAudioVideoAPI_ID];
    
    [self likeAudioVideo:audioVideoID];
}

- (IBAction)likeAudioVideoList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    lblPeople.text = @"People Who Liked";
    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    if(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""])
        audioVideoID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kAudioVideoAPI_ID];
    else
        audioVideoID = [[audioVideoArray objectAtIndex:[sender tag]] valueForKey: kAudioVideoAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    likeCount = cell.btnLikeCount.titleLabel.text;
    
    if ([likeCount integerValue] > 0) {
        [self getLikeAudioVideoList:audioVideoID];
    }
}

- (IBAction)dislikeAudioVideo_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    
    if(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""])
        audioVideoID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kAudioVideoAPI_ID];
    else
        audioVideoID = [[audioVideoArray objectAtIndex:[sender tag]] valueForKey: kAudioVideoAPI_ID];
    
    [self dislikeAudioVideo:audioVideoID];
}

- (IBAction)disLikeAudioVideoList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)button.tag;
    pageNo = 1;
    
    lblPeople.text = @"People Who Disliked";
    imgVwPeople.image = [UIImage imageNamed:@"dislike_blue"];
    
    if(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""])
        audioVideoID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kAudioVideoAPI_ID];
    else
        audioVideoID = [[audioVideoArray objectAtIndex:[sender tag]] valueForKey: kAudioVideoAPI_ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    FundsTableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    dislikeCount = cell.btnDislikeCount.titleLabel.text;
    
    if ([dislikeCount integerValue] > 0) {
        [self getdisLikeAudioVideoList:audioVideoID];
    }
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kAudioVideoAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
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
        if (audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(audioVideoArray.count == totalItems)
                return audioVideoArray.count ;
            else
                return audioVideoArray.count+1 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (tableView == tblViewPopUp) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kAudioVideoAPI_User_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kAudioVideoAPI_User_Desc]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kAudioVideoAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;;
        cell.imgView.clipsToBounds = YES;
        
        cell.btnViewProfile.tag = indexPath.row;
        
        return cell;
        
    } else {
        if (audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""]) {
            {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AudioVideos] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kAudioVideoAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kAudioVideoAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kAudioVideoAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kAudioVideoAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kAudioVideoAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kAudioVideoAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Audio/Video
                    if (selectedSegment == SEARCH_AUDIOVIDEO_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // My Audio/Video
                    if (selectedSegment == MY_AUDIOVIDEO_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_AUDIOVIDEO_SELECTED) {
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
            if(indexPath.row == audioVideoArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            } else {
                FundsTableViewCell *cell = (FundsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AudioVideos] ;
                
                cell.btnLikeCount.tag = indexPath.row;
                cell.btnDislikeCount.tag = indexPath.row;
                cell.btnLike.tag = indexPath.row;
                cell.btnDislike.tag = indexPath.row;
                cell.btnArchive.tag = indexPath.row;
                cell.btnDeactivate.tag = indexPath.row;
                cell.btnDelete.tag = indexPath.row;
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[audioVideoArray objectAtIndex:indexPath.row] valueForKey:kAudioVideoAPI_Title]] ;
                cell.lblPostedOn.text = [NSString stringWithFormat:@"%@",[[audioVideoArray objectAtIndex:indexPath.row] valueForKey:kAudioVideoAPI_StartDate]];
                cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[audioVideoArray objectAtIndex:indexPath.row] valueForKey:kAudioVideoAPI_Description]];
                
                [cell.btnLikeCount setTitle:[NSString stringWithFormat:@"%@",[[audioVideoArray objectAtIndex:indexPath.row] valueForKey:kAudioVideoAPI_Likes]] forState:UIControlStateNormal];
                [cell.btnDislikeCount setTitle:[NSString stringWithFormat:@"%@",[[audioVideoArray objectAtIndex:indexPath.row] valueForKey:kAudioVideoAPI_Dislikes]] forState:UIControlStateNormal];
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[audioVideoArray objectAtIndex:indexPath.row] valueForKey:kAudioVideoAPI_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                
                cell.imgView.layer.cornerRadius = 20;
                cell.imgView.clipsToBounds = YES;
                
                if (selectedSegmentControl == 100) { // Find Audio/Video
                    if (selectedSegment == SEARCH_AUDIOVIDEO_SELECTED) {
                        cell.btnArchive.hidden = true;
                        cell.btnDeactivate.hidden = true;
                        cell.btnDelete.hidden = true;
                    } else {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                    }
                }
                else { // Audio/Video
                    if (selectedSegment == MY_AUDIOVIDEO_SELECTED) {
                        cell.btnArchive.hidden = false;
                        cell.btnDeactivate.hidden = false;
                        cell.btnDelete.hidden = false;
                        [cell.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
                        cell.btnDelete.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:0.0/255.0 blue:2.0/255.0 alpha:1.0f];
                    } else if (selectedSegment == DEACTIVATED_AUDIOVIDEO_SELECTED) {
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
        if (audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""]) {
            
            if (selectedSegmentControl == 100) { // Find Audio/Video
                if (selectedSegment == SEARCH_AUDIOVIDEO_SELECTED)
                    return 110;
                else if (selectedSegment == ADD_AUDIOVIDEO_SELECTED)
                    return 145;
                else {
                    if (selectedSegment == MY_AUDIOVIDEO_SELECTED || selectedSegment == DEACTIVATED_AUDIOVIDEO_SELECTED)
                        return 145;
                    else
                        return 110 ;
                }
            }
            else { // Audio/Video
                if (selectedSegment == MY_AUDIOVIDEO_SELECTED || selectedSegment == DEACTIVATED_AUDIOVIDEO_SELECTED)
                    return 145;
                else
                    return 110 ;
            }
        }
        else {
            if(indexPath.row == audioVideoArray.count)
                return 30 ;
            else {
                if (selectedSegmentControl == 100) { // Find Audio/Video
                    if (selectedSegment == SEARCH_AUDIOVIDEO_SELECTED)
                        return 120;
                    else if (selectedSegment == ADD_AUDIOVIDEO_SELECTED)
                        return 145;
                    else {
                        if (selectedSegment == MY_AUDIOVIDEO_SELECTED || selectedSegment == DEACTIVATED_AUDIOVIDEO_SELECTED)
                            return 145;
                        else
                            return 120 ;
                    }
                }
                else { // Audio/Video
                    if (selectedSegment == MY_AUDIOVIDEO_SELECTED || selectedSegment == DEACTIVATED_AUDIOVIDEO_SELECTED)
                        return 145;
                    else
                        return 120 ;
                }
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""])) {
//        if(indexPath.row == audioVideoArray.count) {
//            [self getMyAudioVideoListWithSearchText:searchedString] ; // My Audio/Video
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array ;
    if (audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""])
        array = [searchResults mutableCopy] ;
    else
        array = [audioVideoArray mutableCopy] ;
    
    if(indexPath.row != array.count) {
        
        [UtilityClass setAudioVideoDetails:(NSMutableDictionary *)[array objectAtIndex:indexPath.row]] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AudioVideo" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditAudioVideoIdentifier] ;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegment] forKey:@"segment"];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)selectedSegmentControl] forKey:@"segmentControl"];
        
        [self.navigationController pushViewController:viewController animated:YES] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetAudioVideoViewEditing object:nil userInfo:dict];
    }
}

#pragma mark - Api Methods
-(void)getFindAudioVideoWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAudioVideoAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kAudioVideoAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kAudioVideoAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getSearchAudioVideosWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kAudioVideoAPI_AudioVideoList]) {
                    totalItems = [[responseDict valueForKey:kAudioVideoAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [audioVideoArray removeAllObjects];
                    
                    if(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                    }
                    else {
                        [audioVideoArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                    }
                    lblNoAudioVideoAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoAudioVideoAvailable.hidden = false;
                if(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                }
                else {
                    audioVideoArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = audioVideoArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyAudioVideoListWithSearchText:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAudioVideoAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kAudioVideoAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kAudioVideoAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getMyAudioVideosListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kAudioVideoAPI_AudioVideoList]) {
                    totalItems = [[responseDict valueForKey:kAudioVideoAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [audioVideoArray removeAllObjects];
                    
                    if(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                    }
                    else {
                        [audioVideoArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                    }
                    lblNoAudioVideoAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoAudioVideoAvailable.hidden = false;
                if(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                }
                else {
                    audioVideoArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = audioVideoArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getArchiveAudioVideoList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAudioVideoAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kAudioVideoAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kAudioVideoAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getArchiveAudioVideosListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kAudioVideoAPI_AudioVideoList]) {
                    totalItems = [[responseDict valueForKey:kAudioVideoAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [audioVideoArray removeAllObjects];
                    
                    if(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                    }
                    else {
                        [audioVideoArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                    }
                    lblNoAudioVideoAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoAudioVideoAvailable.hidden = false;
                if(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                }
                else {
                    audioVideoArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = audioVideoArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeactivatedAudioVideoList:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAudioVideoAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kAudioVideoAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kAudioVideoAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDeactivatedAudioVideosListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kAudioVideoAPI_AudioVideoList]) {
                    totalItems = [[responseDict valueForKey:kAudioVideoAPI_TotalItems] integerValue] ;
                    
                    [searchResults removeAllObjects];
                    [audioVideoArray removeAllObjects];
                    
                    if(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                    }
                    else {
                        [audioVideoArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                    }
                    lblNoAudioVideoAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoAudioVideoAvailable.hidden = false;
                if(audioVideoSearchController.active && ![audioVideoSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                }
                else {
                    audioVideoArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kAudioVideoAPI_AudioVideoList]] ;
                }
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = audioVideoArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveAudioVideo:(NSString *)audioVideoId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAudioVideoAPI_UserID] ;
        [dictParam setObject:audioVideoId forKey:kAudioVideoAPI_AudioVideoID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveAudioVideoWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                
                [UtilityClass showNotificationMessgae:kArchiveAudioVideo_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyAudioVideoListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateAudioVideo:(NSString *)audioVideoId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAudioVideoAPI_UserID] ;
        [dictParam setObject:audioVideoId forKey:kAudioVideoAPI_AudioVideoID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap activateAudioVideoWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                pageNo = 1;
                [self getDeactivatedAudioVideoList:searchedString];
                [UtilityClass showNotificationMessgae:kActivateAudioVideo_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateAudioVideo:(NSString *)audioVideoId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAudioVideoAPI_UserID] ;
        [dictParam setObject:audioVideoId forKey:kAudioVideoAPI_AudioVideoID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateAudioVideoWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateAudioVideo_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyAudioVideoListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteAudioVideo:(NSString *)audioVideoId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAudioVideoAPI_UserID] ;
        [dictParam setObject:audioVideoId forKey:kAudioVideoAPI_AudioVideoID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteAudioVideoWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteAudioVideo_SuccessMessage withResultType:@"0" withDuration:1] ;
                pageNo = 1;
                [self getMyAudioVideoListWithSearchText:searchedString];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)likeAudioVideo:(NSString *)audioVideoId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAudioVideoAPI_LikedBy] ;
        [dictParam setObject:audioVideoId forKey:kAudioVideoAPI_AudioVideoID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap likeAudioVideoWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kAudioVideoAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kAudioVideoAPI_Dislikes]];
                
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

-(void)dislikeAudioVideo:(NSString *)audioVideoId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAudioVideoAPI_DislikedBy] ;
        [dictParam setObject:audioVideoId forKey:kAudioVideoAPI_AudioVideoID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap dislikeAudioVideoWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                likeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kAudioVideoAPI_Likes]];
                dislikeCount = [NSString stringWithFormat:@"%@",[responseDict valueForKey:kAudioVideoAPI_Dislikes]];
                
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

-(void)getLikeAudioVideoList:(NSString *)audioVideoId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:audioVideoId forKey:kAudioVideoAPI_AudioVideoID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kAudioVideoAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getLikeAudioVideoListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kAudioVideoAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kAudioVideoAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kAudioVideoAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kAudioVideoAPI_UserList]] ;
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

-(void)getdisLikeAudioVideoList:(NSString *)audioVideoId {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:audioVideoId forKey:kAudioVideoAPI_AudioVideoID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kAudioVideoAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getDislikeAudioVideoListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kAudioVideoAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kAudioVideoAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kAudioVideoAPI_UserList]] ;
                    [tblViewPopUp reloadData] ;
                    [viewPopUp setHidden:false];
                    [tblView setUserInteractionEnabled:false];
                    
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kAudioVideoAPI_UserList]] ;
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
