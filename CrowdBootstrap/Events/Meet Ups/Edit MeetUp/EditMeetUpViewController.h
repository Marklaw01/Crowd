//
//  EditMeetUpViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define MEETUP_FOLLOW_SECTION_INDEX           0
#define MEETUP_TITLE_SECTION_INDEX           1
#define MEETUP_DESCRIPTION_SECTION_INDEX  2
#define MEETUP_START_DATE_SECTION_INDEX  3
#define MEETUP_END_DATE_SECTION_INDEX    4
#define MEETUP_TARGET_MARKET_KEYWORDS_SECTION_INDEX    5
#define MEETUP_KEYWORDS_SECTION_INDEX    6
#define MEETUP_INDUSTRY_KEYWORDS_SECTION_INDEX  7
#define MEETUP_ADD_FORUM_SECTION_INDEX  8
#define MEETUP_ACCESS_SECTION_INDEX  9
#define MEETUP_NOTIFICATION_SECTION_INDEX  10
#define MEETUP_IMAGE_SECTION_INDEX       11
#define MEETUP_DOCUMENT_SECTION_INDEX    12
#define MEETUP_AUDIO_SECTION_INDEX       13
#define MEETUP_VIDEO_SECTION_INDEX       14

enum {
    MEETUP_START_DATE_SELECTED,
    MEETUP_END_DATE_SELECTED
};

enum {
    MEETUP_ADD_FORUM_SELECTED,
    MEETUP_ACCESS_SELECTED,
    MEETUP_NOTIFICATION_SELECTED
};

enum {
    MEETUP_TARGET_MARKET_KEYWORDS_SELECTED = 5,
    MEETUP_KEYWORDS_SELECTED = 6,
    MEETUP_INDUSTRY_KEYWORDS_SELECTED = 7
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kEditMeetUp_SuccessMessage                @"Meet Up has been updated Successfully."
#define kNoTargetMarketKeywordsFoundMessage       @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage           @"No Interest Keywords Found"
#define kNoMeetUpKeywordsFoundMessage             @"No Meet Up Keywords Found"

@interface EditMeetUpViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate, UIPickerViewDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView                      *popupTblView;
    IBOutlet UIView                           *popupView;
    IBOutlet UISearchBar                      *searchBarKeywords;

    IBOutlet UIView                           *meetUpDataView;
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
    
    // Picker View
    IBOutlet UIView                          *pickerViewContainer;
    IBOutlet UIPickerView                    *pickerView;

    // --- Variables ---
    NSMutableArray                            *sectionsArray ;
    NSMutableArray                            *arrayForBool;
    NSString                                  *audioFile ;
    NSString                                  *videoFile ;
    NSString                                  *docuementFile ;
    
    NSMutableDictionary                       *meetUpData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *meetUpKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedMeetUpKeywordsArray ;
    
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedMeetUpKeywordIds ;
    
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedMeetUpKeywordNames ;
    
    NSMutableArray                            *forumsArray;
    NSString                                  *selectedForumID ;
    NSMutableArray                            *accessLevelArray;
    NSString                                  *selectedAccessLevel ;
    NSMutableArray                            *notificationArray;
    NSString                                  *selectedNotification ;

    int                                       selectedKeywordType ;
    int                                       selectedDatePickerType ;
    int                                       selectedPickerType ;
    NSString                                  *prevValue ;
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
