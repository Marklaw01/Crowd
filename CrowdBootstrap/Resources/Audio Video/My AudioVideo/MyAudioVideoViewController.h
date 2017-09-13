//
//  MyAudioVideoViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_AudioVideos    @"audioVideoCell"
#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kArchiveAudioVideo_SuccessMessage          @"Audio/Video has been archived Successfully."
#define kDeactivateAudioVideo_SuccessMessage       @"Audio/Video has been deactivated Successfully."
#define kDeleteAudioVideo_SuccessMessage           @"Audio/Video has been deleted Successfully."
#define kActivateAudioVideo_SuccessMessage         @"Audio/Video has been activated Successfully."


@interface MyAudioVideoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    IBOutlet UIButton                        *addAudioVideoBtn;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoAudioVideoAvailable;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewPopUp ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
    __weak IBOutlet NSLayoutConstraint       *constraintTblViewTop;
    
    // --- Variables ---
    UISearchController                       *audioVideoSearchController ;
    NSMutableArray                           *audioVideoArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *audioVideoID;
    
    NSMutableArray                           *usersArray ;
    NSString                                 *likeCount ;
    NSString                                 *dislikeCount ;
    int                                      rowIndex ;
    
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlMyAudioVideos;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentControlSearchAudioVideos;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
