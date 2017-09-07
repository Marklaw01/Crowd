//
//  MyAssetsViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_CommunalAssets    @"communalAssetCell"
#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kArchiveCommunalAsset_SuccessMessage          @"Communal Asset has been archived Successfully."
#define kDeactivateCommunalAsset_SuccessMessage       @"Communal Asset has been deactivated Successfully."
#define kDeleteCommunalAsset_SuccessMessage           @"Communal Asset has been deleted Successfully."
#define kActivateCommunalAsset_SuccessMessage         @"Communal Asset has been activated Successfully."


@interface MyAssetsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addCommunalAssetBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoCommunalAssetAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
    __weak IBOutlet NSLayoutConstraint       *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *communalAssetSearchController ;
    NSMutableArray                           *communalAssetsArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *communalAssetID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyCommunalAssets;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchCommunalAssets;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
