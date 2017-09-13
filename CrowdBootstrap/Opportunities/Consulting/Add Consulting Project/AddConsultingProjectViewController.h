//
//  AddConsultingProjectViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

// Title
#define CONSULTING_TITLE_SECTION_INDEX                          0
//Description
#define CONSULTING_PROJECT_OVERVIEW_SECTION_INDEX               1
#define CONSULTING_DESCRIPTION_SECTION_INDEX                    2
// Keywords
#define CONSULTING_TARGET_USER_KEYWORDS_SECTION_INDEX           3
#define CONSULTING_INTEREST_KEYWORDS_SECTION_INDEX              4
// Dates
#define CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SECTION_INDEX      5
#define CONSULTING_BID_INTENT_DEADLINE_DATE_SECTION_INDEX       6
#define CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SECTION_INDEX  7
#define CONSULTING_BID_COMMITMENT_DEADLINE_SECTION_INDEX        8
#define CONSULTING_QUESTION_DEADLINE_DATE_TIME_SECTION_INDEX    9
#define CONSULTING_ANSWER_TARGET_DATE_SECTION_INDEX             10
#define CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SECTION_INDEX  11
#define CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SECTION_INDEX  12
#define CONSULTING_PROJECT_AWARD_TARGET_DATE_SECTION_INDEX      13
#define CONSULTING_PROJECT_START_TARGET_DATE_SECTION_INDEX      14
#define CONSULTING_PROJECT_COMPLETE_TARGET_DATE_SECTION_INDEX   15
// Image
#define CONSULTING_IMAGE_SECTION_INDEX                          16


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
    CONSULTING_TARGET_USER_KEYWORDS_SELECTED = 3,
    CONSULTING_INTEREST_KEYWORDS_SELECTED = 4
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddConsultingProject_SuccessMessage         @"Consulting Project has been registered Successfully."
#define kNoTargetUserKeywordsFoundMessage            @"No Target User Keywords Found"
#define kNoInterestKeywordsFoundMessage              @"No Interest Keywords Found"


@interface AddConsultingProjectViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView                      *popupTblView;
    IBOutlet UIView                           *popupView;
    IBOutlet UISearchBar                      *searchBarKeywords;
    
    IBOutlet UIDatePicker                     *datePickerView;
    IBOutlet UIView                           *datePickerViewContainer;
    
    // --- Variables ---
    NSMutableArray                            *sectionsArray ;
    NSMutableArray                            *arrayForBool;
    NSMutableDictionary                       *consultingProjectData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetUserKeywordsArray ;
    NSMutableArray                            *interestKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetUserKeywordsArray ;
    NSMutableArray                            *selectedInterestKeywordsArray ;
    
    NSMutableArray                            *selectedTargetUserKeywordIds ;
    NSMutableArray                            *selectedInterestKeywordIds ;
    
    NSMutableArray                            *selectedTargetUserKeywordNames ;
    NSMutableArray                            *selectedInterestKeywordNames ;
    
    NSMutableArray                            *searchResultsForKeywords;
    
    int                                       selectedKeywordType ;
    int                                       selectedDatePickerType ;
    
    NSString                                 *prevDueDate ;
    NSDateFormatter                          *dateFormatter ;
    UIImage                                  *chosenImage;
}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property UIView    *selectedItem;

@end
