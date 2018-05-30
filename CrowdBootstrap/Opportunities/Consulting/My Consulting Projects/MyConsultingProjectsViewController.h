//
//  MyConsultingProjectsViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_Consulting    @"consultingCell"
#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kArchiveConsultingProject_SuccessMessage      @"Consulting Project has been archived Successfully."
#define kDeleteConsultingProject_SuccessMessage       @"Consulting Project has been deleted Successfully."
#define kOpenConsultingProject_SuccessMessage         @"Consulting Project has been opened Successfully."
#define kCloseConsultingProject_SuccessMessage        @"Consulting Project has been closed Successfully."
#define kAcceptConsultingProject_SuccessMessage       @"Consulting Project has been accepted Successfully."
#define kRejectConsultingProject_SuccessMessage       @"Consulting Project has been rejected Successfully."


@interface MyConsultingProjectsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addConsultingProjectBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoConsultingProjectAvailable;
    
    // Pop-Up View 
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    IBOutlet UISearchBar                     *searchBarUsers;
    IBOutlet UILabel                         *lblNoUserAvailable;
    IBOutlet UIButton                        *btnOk;
    
    __weak IBOutlet NSLayoutConstraint       *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *consultingProjectSearchController ;
    NSMutableArray                           *consultingProjectsArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *consultingProjectID;
    NSString                                 *invitationSenderID;

    NSMutableArray                           *usersArray ;
    NSMutableArray                           *searchResultsForUsers ;
    NSString                                 *selectedContractorID;

    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    NSIndexPath                              *lastSelectedIndexPath;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
    
    BOOL                                     isCloseConsulting;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyConsultingProjects;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchConsultingProjects;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
