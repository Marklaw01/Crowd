//
//  MyFundsViewController.h
//  CrowdBootstrap
//
//  Created by osx on 20/01/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_Funds    @"fundsCell"
#define kCellIdentifier_UserFund    @"userFundCell"

#define kArchiveFund_SuccessMessage          @"Fund has been archived Successfully."
#define kDeactivateFund_SuccessMessage       @"Fund has been deactivated Successfully."
#define kDeleteFund_SuccessMessage           @"Fund has been deleted Successfully."
#define kActivateFund_SuccessMessage         @"Fund has been activated Successfully."

@interface MyFundsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *createFundBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoFundsAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;

    __weak IBOutlet NSLayoutConstraint *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *fundSearchController ;
    NSMutableArray                           *fundsArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *fundID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;

    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyFunds;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlFindFunds;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
