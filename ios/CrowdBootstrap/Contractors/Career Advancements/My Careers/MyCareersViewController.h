//
//  MyCareersViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_Career                 @"careerCell"
#define kCellIdentifier_UserProfile             @"userProfileCell"

#define kArchiveCareer_SuccessMessage          @"Career has been archived Successfully."
#define kDeactivateCareer_SuccessMessage       @"Career has been deactivated Successfully."
#define kDeleteCareer_SuccessMessage           @"Career has been deleted Successfully."
#define kActivateCareer_SuccessMessage         @"Career has been activated Successfully."


@interface MyCareersViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addCareerBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoCareerAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
    __weak IBOutlet NSLayoutConstraint       *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *careerSearchController ;
    NSMutableArray                           *careerArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *careerID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyCareer;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchCareer;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
