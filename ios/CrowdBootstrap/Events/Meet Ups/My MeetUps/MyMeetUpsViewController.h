//
//  MyMeetUpsViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_MeetUp                  @"meetUpCell"
#define kCellIdentifier_UserProfile             @"userProfileCell"

#define kArchiveMeetUp_SuccessMessage          @"Meet Up has been archived Successfully."
#define kDeactivateMeetUp_SuccessMessage       @"Meet Up has been deactivated Successfully."
#define kDeleteMeetUp_SuccessMessage           @"Meet Up has been deleted Successfully."
#define kActivateMeetUp_SuccessMessage         @"Meet Up has been activated Successfully."


@interface MyMeetUpsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addMeetUpBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoMeetUpAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
    __weak IBOutlet NSLayoutConstraint       *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *meetUpSearchController ;
    NSMutableArray                           *meetUpArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *meetUpID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyMeetUp;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchMeetUp;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
