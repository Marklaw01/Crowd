//
//  MyGroupsViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_Group    @"groupCell"
#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kArchiveGroup_SuccessMessage          @"Group has been archived Successfully."
#define kDeactivateGroup_SuccessMessage       @"Group has been deactivated Successfully."
#define kDeleteGroup_SuccessMessage           @"Group has been deleted Successfully."
#define kActivateGroup_SuccessMessage         @"Group has been activated Successfully."


@interface MyGroupsViewController   : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addGroupBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoGroupAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
    __weak IBOutlet NSLayoutConstraint       *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *groupSearchController ;
    NSMutableArray                           *groupArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *groupID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyGroup;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchGroup;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
