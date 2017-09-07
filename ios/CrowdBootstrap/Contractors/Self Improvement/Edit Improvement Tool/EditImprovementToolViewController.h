//
//  EditImprovementToolViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define IMPROVEMENT_FOLLOW_SECTION_INDEX           0
#define IMPROVEMENT_TITLE_SECTION_INDEX           1
#define IMPROVEMENT_DESCRIPTION_SECTION_INDEX  2
#define IMPROVEMENT_START_DATE_SECTION_INDEX  3
#define IMPROVEMENT_END_DATE_SECTION_INDEX    4
#define IMPROVEMENT_TARGET_MARKET_KEYWORDS_SECTION_INDEX    5
#define IMPROVEMENT_KEYWORDS_SECTION_INDEX    6
#define IMPROVEMENT_INDUSTRY_KEYWORDS_SECTION_INDEX  7
#define IMPROVEMENT_IMAGE_SECTION_INDEX       8
#define IMPROVEMENT_DOCUMENT_SECTION_INDEX    9
#define IMPROVEMENT_AUDIO_SECTION_INDEX       10
#define IMPROVEMENT_VIDEO_SECTION_INDEX       11

enum {
    IMPROVEMENT_START_DATE_SELECTED,
    IMPROVEMENT_END_DATE_SELECTED
};

enum {
    IMPROVEMENT_TARGET_MARKET_KEYWORDS_SELECTED = 5,
    IMPROVEMENT_KEYWORDS_SELECTED = 6,
    IMPROVEMENT_INDUSTRY_KEYWORDS_SELECTED = 7
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kEditImprovementTool_SuccessMessage             @"Improvement Tool has been updated Successfully."
#define kNoTargetMarketKeywordsFoundMessage             @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage                 @"No Interest Keywords Found"
#define kNoImprovementToolKeywordsFoundMessage          @"No Improvement Tool Keywords Found"

@interface EditImprovementToolViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView                      *popupTblView;
    IBOutlet UIView                           *popupView;
    IBOutlet UISearchBar                      *searchBarKeywords;
    
    IBOutlet UIView                           *improvementToolDataView;
    IBOutlet UILabel                          *dataTitle;
    IBOutlet UIWebView                        *webView;
    
    IBOutlet UIDatePicker                     *datePickerView;
    IBOutlet UIView                           *datePickerViewContainer;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewUsers ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
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
    
    NSMutableDictionary                       *improvementToolData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *improvementToolKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedImprovementToolKeywordsArray ;
    
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedImprovementToolKeywordIds ;
    
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedImprovementToolKeywordNames ;
    
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
