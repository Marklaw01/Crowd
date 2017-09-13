//
//  MyFocusGroupsViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_FocusGroups    @"focusGroupCell"
#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kArchiveFocusGroup_SuccessMessage          @"Focus Group has been archived Successfully."
#define kDeactivateFocusGroup_SuccessMessage       @"Focus Group has been deactivated Successfully."
#define kDeleteFocusGroup_SuccessMessage           @"Focus Group has been deleted Successfully."
#define kActivateFocusGroup_SuccessMessage         @"Focus Group has been activated Successfully."


@interface MyFocusGroupsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addFocusGroupBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoFocusGroupAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
    __weak IBOutlet NSLayoutConstraint       *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *focusGroupSearchController ;
    NSMutableArray                           *focusGroupsArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *focusGroupID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyFocusGroups;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchFocusGroups;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
