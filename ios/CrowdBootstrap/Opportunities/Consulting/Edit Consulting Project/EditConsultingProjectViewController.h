//
//  EditConsultingProjectViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

// Like/Follow
#define CONSULTING_FOLLOW_SECTION_INDEX           0
// Title
#define CONSULTING_TITLE_SECTION_INDEX           1
//Description
#define CONSULTING_PROJECT_OVERVIEW_SECTION_INDEX  2
#define CONSULTING_DESCRIPTION_SECTION_INDEX  3
// Keywords
#define CONSULTING_TARGET_USER_KEYWORDS_SECTION_INDEX    4
#define CONSULTING_INTEREST_KEYWORDS_SECTION_INDEX  5
// Dates
#define CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SECTION_INDEX      6
#define CONSULTING_BID_INTENT_DEADLINE_DATE_SECTION_INDEX       7
#define CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SECTION_INDEX  8
#define CONSULTING_BID_COMMITMENT_DEADLINE_SECTION_INDEX        9
#define CONSULTING_QUESTION_DEADLINE_DATE_TIME_SECTION_INDEX    10
#define CONSULTING_ANSWER_TARGET_DATE_SECTION_INDEX             11
#define CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SECTION_INDEX  12
#define CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SECTION_INDEX  13
#define CONSULTING_PROJECT_AWARD_TARGET_DATE_SECTION_INDEX      14
#define CONSULTING_PROJECT_START_TARGET_DATE_SECTION_INDEX      15
#define CONSULTING_PROJECT_COMPLETE_TARGET_DATE_SECTION_INDEX   16
// Image
#define CONSULTING_IMAGE_SECTION_INDEX    17
//Documents
#define CONSULTING_DOCUMENT_SECTION_INDEX    18
#define CONSULTING_AUDIO_SECTION_INDEX       19
#define CONSULTING_VIDEO_SECTION_INDEX       20
#define CONSULTING_QUESTIONS_SECTION_INDEX       21
#define CONSULTING_FINALBID_SECTION_INDEX       22


enum {
    CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SELECTED,
    CONSULTING_BID_INTENT_DEADLINE_DATE_SELECTED,
    CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SELECTED,
    CONSULTING_BID_COMMITMENT_DEADLINE_SELECTED,
    CONSULTING_QUESTION_DEADLINE_DATE_TIME_SELECTED,
    CONSULTING_ANSWER_TARGET_DATE_SELECTED,
    CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SELECTED,
    CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SELECTED,
    CONSULTING_PROJECT_AWARD_TARGET_DATE_SELECTED,
    CONSULTING_PROJECT_START_TARGET_DATE_SELECTED,
    CONSULTING_PROJECT_COMPLETE_TARGET_DATE_SELECTED
};

enum {
    CONSULTING_TARGET_USER_KEYWORDS_SELECTED = 4,
    CONSULTING_INTEREST_KEYWORDS_SELECTED = 5
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kEditConsultingProject_SuccessMessage       @"Consulting Project has been updated Successfully."
#define kInviteContractor_SuccessMessage            @"Contractor has been invited Successfully."
#define kNoTargetUserKeywordsFoundMessage           @"No Target User Keywords Found"
#define kNoInterestKeywordsFoundMessage             @"No Interest Keywords Found"

@interface EditConsultingProjectViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView                      *popupTblView;
    IBOutlet UIView                           *popupView;
    IBOutlet UISearchBar                      *searchBarKeywords;
    
    IBOutlet UIView                           *consultingProjectDataView;
    IBOutlet UILabel                          *dataTitle;
    IBOutlet UIWebView                        *webView;
    
    IBOutlet UIDatePicker                     *datePickerView;
    IBOutlet UIView                           *datePickerViewContainer;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewUsers ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    
    // Search Users
    IBOutlet NSLayoutConstraint              *constraintTblViewTop;
    IBOutlet UIButton                        *btnSearchRecommUser;
    IBOutlet UISearchBar                     *searchBarUsers;
    IBOutlet UILabel                         *lblNoUserAvailable;
    IBOutlet UILabel                         *lblSearchContractor;

    // --- Variables ---
    NSMutableArray                            *sectionsArray ;
    NSMutableArray                            *arrayForBool;
    NSString                                  *audioFile ;
    NSString                                  *videoFile ;
    NSString                                  *docuementFile ;
    NSString                                  *questionFile ;
    NSString                                  *finalBidFile ;

    NSMutableDictionary                       *consultingProjectData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetUserKeywordsArray ;
    NSMutableArray                            *interestKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetUserKeywordsArray ;
    NSMutableArray                            *selectedInterestKeywordsArray ;
    
    // Selected Keywords Ids
    NSMutableArray                            *selectedTargetUserKeywordIds ;
    NSMutableArray                            *selectedInterestKeywordIds ;
    
    // Selected Keywords Names
    NSMutableArray                            *selectedTargetUserKeywordNames ;
    NSMutableArray                            *selectedInterestKeywordNames ;
    
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
    
    NSString                                  *userType;
    
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
