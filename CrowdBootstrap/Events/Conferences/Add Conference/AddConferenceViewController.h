//
//  AddConferenceViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define CONFERENCE_TITLE_SECTION_INDEX           0
#define CONFERENCE_DESCRIPTION_SECTION_INDEX  1
#define CONFERENCE_START_DATE_SECTION_INDEX  2
#define CONFERENCE_END_DATE_SECTION_INDEX    3
#define CONFERENCE_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define CONFERENCE_KEYWORDS_SECTION_INDEX    5
#define CONFERENCE_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define CONFERENCE_IMAGE_SECTION_INDEX    7

enum {
    CONFERENCE_START_DATE_SELECTED,
    CONFERENCE_END_DATE_SELECTED
};

enum {
    CONFERENCE_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    CONFERENCE_KEYWORDS_SELECTED = 5,
    CONFERENCE_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddConference_SuccessMessage               @"Conference has been registered Successfully."
#define kNoTargetMarketKeywordsFoundMessage         @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage             @"No Interest Keywords Found"
#define kNoConferenceKeywordsFoundMessage           @"No Conference Keywords Found"


@interface AddConferenceViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    
    // Selected Keywords IDs
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedConferenceKeywordIds ;
    
    // Selected Keywords Names
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedConferenceKeywordNames ;
    
    NSMutableArray                           *searchResultsForKeywords;

    int                                       selectedKeywordType ;
    int                                       selectedDatePickerType ;
    
    NSString                                 *prevDueDate ;
    NSDateFormatter                          *dateFormatter ;
    UIImage                                  *chosenImage;
}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property UIView    *selectedItem;

@end
