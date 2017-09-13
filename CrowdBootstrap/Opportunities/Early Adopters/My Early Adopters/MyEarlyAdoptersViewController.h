//
//  MyEarlyAdoptersViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_EarlyAdopters    @"earlyAdopterCell"
#define kCellIdentifier_UserProfile      @"userProfileCell"

#define kArchiveEarlyAdopter_SuccessMessage          @"Early Adopter has been archived Successfully."
#define kDeactivateEarlyAdopter_SuccessMessage       @"Early Adopter has been deactivated Successfully."
#define kDeleteEarlyAdopter_SuccessMessage           @"Early Adopter has been deleted Successfully."
#define kActivateEarlyAdopter_SuccessMessage         @"Early Adopter has been activated Successfully."


@interface MyEarlyAdoptersViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addEarlyAdopterBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoEarlyAdopterAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
    __weak IBOutlet NSLayoutConstraint       *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *earlyAdopterSearchController ;
    NSMutableArray                           *earlyAdoptersArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *earlyAdopterID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyEarlyAdopters;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchEarlyAdopters;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
