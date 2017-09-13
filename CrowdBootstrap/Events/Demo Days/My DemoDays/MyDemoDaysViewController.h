//
//  MyDemoDaysViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_DemoDay                 @"demoDayCell"
#define kCellIdentifier_UserProfile             @"userProfileCell"

#define kArchiveDemoDay_SuccessMessage          @"Demo Day has been archived Successfully."
#define kDeactivateDemoDay_SuccessMessage       @"Demo Day has been deactivated Successfully."
#define kDeleteDemoDay_SuccessMessage           @"Demo Day has been deleted Successfully."
#define kActivateDemoDay_SuccessMessage         @"Demo Day has been activated Successfully."


@interface MyDemoDaysViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addDemoDayBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoDemoDayAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
    __weak IBOutlet NSLayoutConstraint       *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *demoDaySearchController ;
    NSMutableArray                           *demoDayArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *demoDayID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyDemoDay;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchDemoDay;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
