//
//  EditConferenceViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define CONFERENCE_FOLLOW_SECTION_INDEX           0
#define CONFERENCE_TITLE_SECTION_INDEX           1
#define CONFERENCE_DESCRIPTION_SECTION_INDEX  2
#define CONFERENCE_START_DATE_SECTION_INDEX  3
#define CONFERENCE_END_DATE_SECTION_INDEX    4
#define CONFERENCE_TARGET_MARKET_KEYWORDS_SECTION_INDEX    5
#define CONFERENCE_KEYWORDS_SECTION_INDEX    6
#define CONFERENCE_INDUSTRY_KEYWORDS_SECTION_INDEX  7
#define CONFERENCE_IMAGE_SECTION_INDEX       8
#define CONFERENCE_DOCUMENT_SECTION_INDEX    9
#define CONFERENCE_AUDIO_SECTION_INDEX       10
#define CONFERENCE_VIDEO_SECTION_INDEX       11

enum {
    CONFERENCE_START_DATE_SELECTED,
    CONFERENCE_END_DATE_SELECTED
};

enum {
    CONFERENCE_TARGET_MARKET_KEYWORDS_SELECTED = 5,
    CONFERENCE_KEYWORDS_SELECTED = 6,
    CONFERENCE_INDUSTRY_KEYWORDS_SELECTED = 7
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kEditConference_SuccessMessage            @"Conference has been updated Successfully."
#define kNoTargetMarketKeywordsFoundMessage       @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage           @"No Interest Keywords Found"
#define kNoConferenceKeywordsFoundMessage         @"No Conference Keywords Found"

@interface EditConferenceViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView                      *popupTblView;
    IBOutlet UIView                           *popupView;
    IBOutlet UISearchBar                      *searchBarKeywords;

    IBOutlet UIView                           *conferenceDataView;
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
    
    NSMutableDictionary                       *conferenceData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *conferenceKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedConferenceKeywordsArray ;
    
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedConferenceKeywordIds ;
    
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedConferenceKeywordNames ;
    
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
