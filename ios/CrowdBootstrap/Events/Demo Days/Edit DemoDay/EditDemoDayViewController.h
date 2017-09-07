//
//  EditDemoDayViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define DEMODAY_FOLLOW_SECTION_INDEX           0
#define DEMODAY_TITLE_SECTION_INDEX           1
#define DEMODAY_DESCRIPTION_SECTION_INDEX  2
#define DEMODAY_START_DATE_SECTION_INDEX  3
#define DEMODAY_END_DATE_SECTION_INDEX    4
#define DEMODAY_TARGET_MARKET_KEYWORDS_SECTION_INDEX    5
#define DEMODAY_KEYWORDS_SECTION_INDEX    6
#define DEMODAY_INDUSTRY_KEYWORDS_SECTION_INDEX  7
#define DEMODAY_IMAGE_SECTION_INDEX       8
#define DEMODAY_DOCUMENT_SECTION_INDEX    9
#define DEMODAY_AUDIO_SECTION_INDEX       10
#define DEMODAY_VIDEO_SECTION_INDEX       11

enum {
    DEMODAY_START_DATE_SELECTED,
    DEMODAY_END_DATE_SELECTED
};

enum {
    DEMODAY_TARGET_MARKET_KEYWORDS_SELECTED = 5,
    DEMODAY_KEYWORDS_SELECTED = 6,
    DEMODAY_INDUSTRY_KEYWORDS_SELECTED = 7
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kEditDemoDay_SuccessMessage           @"DemoDay has been updated Successfully."
#define kNoTargetMarketKeywordsFoundMessage       @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage           @"No Interest Keywords Found"
#define kNoDemoDayKeywordsFoundMessage        @"No DemoDay Keywords Found"

@interface EditDemoDayViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView                      *popupTblView;
    IBOutlet UIView                           *popupView;
    IBOutlet UISearchBar                      *searchBarKeywords;

    IBOutlet UIView                           *demoDayDataView;
    IBOutlet UILabel                          *dataTitle;
    IBOutlet UIWebView                        *webView;
    
    IBOutlet UIDatePicker                     *datePickerView;
    IBOutlet UIView                           *datePickerViewContainer;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewUsers ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    
    // Search Recommended Users
    IBOutlet NSLayoutConstraint              *constraintTblViewTop;
    IBOutlet UIButton                        *btnSearchRecommUser;
    IBOutlet UISearchBar                     *searchBarUsers;
    IBOutlet UILabel                         *lblNoUserAvailable;
    
    // --- Variables ---
    NSMutableArray                            *sectionsArray ;
    NSMutableArray                            *arrayForBool;
    NSString                                  *audioFile ;
    NSString                                  *videoFile ;
    NSString                                  *docuementFile ;
    
    NSMutableDictionary                       *demoDayData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *demoDayKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedDemoDayKeywordsArray ;
    
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedDemoDayKeywordIds ;
    
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedDemoDayKeywordNames ;
    
    int                                       selectedKeywordType ;
    int                                       selectedDatePickerType ;
    int                                       isFollowed ;
    int                                       isLiked ;
    
    // Commitments
    int                                       isCommited ;
    NSString                                  *noOfcommit ;
    NSInteger                                 totalItems ;
    NSMutableArray                            *usersArray ;
    int                                       rowIndex ;
    int                                       pageNo ;
    
    NSMutableArray                           *searchResultsForRegisteredUsers ;
    NSMutableArray                           *searchResultsForKeywords;

    NSString                                 *prevDueDate ;
    NSDateFormatter                          *dateFormatter ;
    UIImage                                  *chosenImage;
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property UIView    *selectedItem;

@end
