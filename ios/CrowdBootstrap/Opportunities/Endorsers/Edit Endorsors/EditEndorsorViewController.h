//
//  EditEndorsorViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define ENDORSOR_FOLLOW_SECTION_INDEX           0
#define ENDORSOR_TITLE_SECTION_INDEX           1
#define ENDORSOR_DESCRIPTION_SECTION_INDEX  2
#define ENDORSOR_START_DATE_SECTION_INDEX  3
#define ENDORSOR_END_DATE_SECTION_INDEX    4
#define ENDORSOR_TARGET_MARKET_KEYWORDS_SECTION_INDEX    5
#define ENDORSOR_KEYWORDS_SECTION_INDEX    6
#define ENDORSOR_INDUSTRY_KEYWORDS_SECTION_INDEX  7
#define ENDORSOR_IMAGE_SECTION_INDEX       8
#define ENDORSOR_DOCUMENT_SECTION_INDEX    9
#define ENDORSOR_AUDIO_SECTION_INDEX       10
#define ENDORSOR_VIDEO_SECTION_INDEX       11

enum {
    ENDORSOR_START_DATE_SELECTED,
    ENDORSOR_END_DATE_SELECTED
};

enum {
    ENDORSOR_TARGET_MARKET_KEYWORDS_SELECTED = 5,
    ENDORSOR_KEYWORDS_SELECTED = 6,
    ENDORSOR_INDUSTRY_KEYWORDS_SELECTED = 7
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kEditEndorsor_SuccessMessage           @"Endorsor has been updated Successfully."
#define kNoTargetMarketKeywordsFoundMessage    @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage        @"No Interest Keywords Found"
#define kNoEndorsorKeywordsFoundMessage        @"No Endorsor Keywords Found"

@interface EditEndorsorViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView                      *popupTblView;
    IBOutlet UIView                           *popupView;
    IBOutlet UISearchBar                      *searchBarKeywords;

    IBOutlet UIView                           *endorsorDataView;
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
    
    NSMutableDictionary                       *endorsorData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *endorsorKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedEndorsorKeywordsArray ;
    
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedEndorsorKeywordIds ;
    
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedEndorsorKeywordNames ;
    
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
