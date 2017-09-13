//
//  MyEndorsorsViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_Endorsors    @"endorsorCell"
#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kArchiveEndorsor_SuccessMessage          @"Endorsor has been archived Successfully."
#define kDeactivateEndorsor_SuccessMessage       @"Endorsor has been deactivated Successfully."
#define kDeleteEndorsor_SuccessMessage           @"Endorsor has been deleted Successfully."
#define kActivateEndorsor_SuccessMessage         @"Endorsor has been activated Successfully."


@interface MyEndorsorsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addEndorsorBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoEndorsorAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
    __weak IBOutlet NSLayoutConstraint       *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *endorsorSearchController ;
    NSMutableArray                           *endorsorsArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *endorsorID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyEndorsors;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchEndorsors;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
