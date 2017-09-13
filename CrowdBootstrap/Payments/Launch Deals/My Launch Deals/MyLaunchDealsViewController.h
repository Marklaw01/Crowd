//
//  MyLaunchDealsViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_LaunchDeals    @"launchDealCell"
#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kArchiveLaunchDeal_SuccessMessage          @"Launch Deal has been archived Successfully."
#define kDeactivateLaunchDeal_SuccessMessage       @"Launch Deal has been deactivated Successfully."
#define kDeleteLaunchDeal_SuccessMessage           @"Launch Deal has been deleted Successfully."
#define kActivateLaunchDeal_SuccessMessage         @"Launch Deal has been activated Successfully."


@interface MyLaunchDealsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addLaunchDealBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoLaunchDealAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
    __weak IBOutlet NSLayoutConstraint       *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *launchDealSearchController ;
    NSMutableArray                           *launchDealsArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *launchDealID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyLaunchDeals;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchLaunchDeals;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
