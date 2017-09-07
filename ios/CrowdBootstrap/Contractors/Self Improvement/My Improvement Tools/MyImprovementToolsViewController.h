//
//  MyImprovementToolsViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_ImprovementTools    @"improvementCell"
#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kArchiveImprovementTool_SuccessMessage          @"Improvement Tool has been archived Successfully."
#define kDeactivateImprovementTool_SuccessMessage       @"Improvement Tool has been deactivated Successfully."
#define kDeleteImprovementTool_SuccessMessage           @"Improvement Tool has been deleted Successfully."
#define kActivateImprovementTool_SuccessMessage         @"Improvement Tool has been activated Successfully."


@interface MyImprovementToolsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addImprovementToolBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoImprovementToolAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
    __weak IBOutlet NSLayoutConstraint       *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *improvementToolSearchController ;
    NSMutableArray                           *improvementToolsArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *improvementID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyImprovementTools;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchImprovementTools;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
