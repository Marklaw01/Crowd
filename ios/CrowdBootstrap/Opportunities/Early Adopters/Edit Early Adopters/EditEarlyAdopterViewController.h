//
//  EditEarlyAdopterViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define EARLY_ADOPTER_FOLLOW_SECTION_INDEX           0
#define EARLY_ADOPTER_TITLE_SECTION_INDEX           1
#define EARLY_ADOPTER_DESCRIPTION_SECTION_INDEX  2
#define EARLY_ADOPTER_START_DATE_SECTION_INDEX  3
#define EARLY_ADOPTER_END_DATE_SECTION_INDEX    4
#define EARLY_ADOPTER_TARGET_MARKET_KEYWORDS_SECTION_INDEX    5
#define EARLY_ADOPTER_KEYWORDS_SECTION_INDEX    6
#define EARLY_ADOPTER_INDUSTRY_KEYWORDS_SECTION_INDEX    7
#define EARLY_ADOPTER_IMAGE_SECTION_INDEX       8
#define EARLY_ADOPTER_DOCUMENT_SECTION_INDEX    9
#define EARLY_ADOPTER_AUDIO_SECTION_INDEX       10
#define EARLY_ADOPTER_VIDEO_SECTION_INDEX       11

enum {
    EARLY_ADOPTER_START_DATE_SELECTED,
    EARLY_ADOPTER_END_DATE_SELECTED
};

enum {
    EARLY_ADOPTER_TARGET_MARKET_KEYWORDS_SELECTED = 5,
    EARLY_ADOPTER_KEYWORDS_SELECTED = 6,
    EARLY_ADOPTER_INDUSTRY_KEYWORDS_SELECTED = 7
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kEditEarlyAdopter_SuccessMessage           @"Early Adopter has been updated Successfully."
#define kNoTargetMarketKeywordsFoundMessage        @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage            @"No Interest Keywords Found"
#define kNoEarlyAdopterKeywordsFoundMessage        @"No Early Adopter Keywords Found"

@interface EditEarlyAdopterViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView                      *popupTblView;
    IBOutlet UIView                           *popupView;
    IBOutlet UISearchBar                      *searchBarKeywords;

    IBOutlet UIView                           *earlyAdopterDataView;
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
    
    NSMutableDictionary                       *earlyAdopterData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *earlyAdopterKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedEarlyAdopterKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    
    // Selected Keywords Ids
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedEarlyAdopterKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    
    // Selected Keywords Names
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedEarlyAdopterKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    
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
