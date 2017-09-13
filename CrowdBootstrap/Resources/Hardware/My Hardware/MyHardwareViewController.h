//
//  MyHardwareViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_Hardwares    @"hardwareCell"
#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kArchiveHardware_SuccessMessage          @"Hardware has been archived Successfully."
#define kDeactivateHardware_SuccessMessage       @"Hardware has been deactivated Successfully."
#define kDeleteHardware_SuccessMessage           @"Hardware has been deleted Successfully."
#define kActivateHardware_SuccessMessage         @"Hardware has been activated Successfully."


@interface MyHardwareViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addHardwareBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoHardwareAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
    __weak IBOutlet NSLayoutConstraint       *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *hardwareSearchController ;
    NSMutableArray                           *hardwaresArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *hardwareID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyHardwares;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchHardwares;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
