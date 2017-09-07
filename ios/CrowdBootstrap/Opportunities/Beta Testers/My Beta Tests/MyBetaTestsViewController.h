//
//  MyBetaTestsViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_BetaTests    @"betaTestCell"
#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kArchiveBetaTest_SuccessMessage          @"Beta Test has been archived Successfully."
#define kDeactivateBetaTest_SuccessMessage       @"Beta Test has been deactivated Successfully."
#define kDeleteBetaTest_SuccessMessage           @"Beta Test has been deleted Successfully."
#define kActivateBetaTest_SuccessMessage         @"Beta Test has been activated Successfully."


@interface MyBetaTestsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addBetaTestBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoBetaTestAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
    __weak IBOutlet NSLayoutConstraint *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *betaTestSearchController ;
    NSMutableArray                           *betaTestsArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *betaTestID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyBetaTests;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchBetaTests;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
