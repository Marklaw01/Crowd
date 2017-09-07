//
//  MyConferencesViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_Conference                 @"conferenceCell"
#define kCellIdentifier_UserProfile             @"userProfileCell"

#define kArchiveConference_SuccessMessage          @"Conference has been archived Successfully."
#define kDeactivateConference_SuccessMessage       @"Conference has been deactivated Successfully."
#define kDeleteConference_SuccessMessage           @"Conference has been deleted Successfully."
#define kActivateConference_SuccessMessage         @"Conference has been activated Successfully."


@interface MyConferencesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addConferenceBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoConferenceAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
    __weak IBOutlet NSLayoutConstraint       *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *conferenceSearchController ;
    NSMutableArray                           *conferenceArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *conferenceID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyConference;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchConference;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
