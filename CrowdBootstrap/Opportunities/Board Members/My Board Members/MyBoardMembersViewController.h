//
//  MyBoardMembersViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_BoardMembers    @"boardMemberCell"
#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kArchiveBoardMember_SuccessMessage          @"Board Member has been archived Successfully."
#define kDeactivateBoardMember_SuccessMessage       @"Board Member has been deactivated Successfully."
#define kDeleteBoardMember_SuccessMessage           @"Board Member has been deleted Successfully."
#define kActivateBoardMember_SuccessMessage         @"Board Member has been activated Successfully."


@interface MyBoardMembersViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addBoardMemberBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoBoardMemberAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
    __weak IBOutlet NSLayoutConstraint       *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *boardMemberSearchController ;
    NSMutableArray                           *boardMembersArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *boardMemberID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyBoardMembers;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchBoardMembers;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
