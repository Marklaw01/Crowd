//
//  AddMeetUpViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define MEETUP_TITLE_SECTION_INDEX           0
#define MEETUP_DESCRIPTION_SECTION_INDEX  1
#define MEETUP_START_DATE_SECTION_INDEX  2
#define MEETUP_END_DATE_SECTION_INDEX    3
#define MEETUP_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define MEETUP_KEYWORDS_SECTION_INDEX    5
#define MEETUP_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define MEETUP_ADD_FORUM_SECTION_INDEX  7
#define MEETUP_ACCESS_SECTION_INDEX  8
#define MEETUP_NOTIFICATION_SECTION_INDEX  9
#define MEETUP_IMAGE_SECTION_INDEX    10

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
    MEETUP_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    MEETUP_KEYWORDS_SELECTED = 5,
    MEETUP_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddMeetUp_SuccessMessage                @"Meet Up has been registered Successfully."
#define kNoTargetMarketKeywordsFoundMessage      @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage          @"No Interest Keywords Found"
#define kNoMeetUpKeywordsFoundMessage            @"No Meet Up Keywords Found"


@interface AddMeetUpViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate, UIPickerViewDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView                      *popupTblView;
    IBOutlet UIView                           *popupView;
    IBOutlet UISearchBar                      *searchBarKeywords;

    // DatePicker View
    IBOutlet UIDatePicker                     *datePickerView;
    IBOutlet UIView                           *datePickerViewContainer;
    
    // Picker View
    IBOutlet UIView                          *pickerViewContainer;
    IBOutlet UIPickerView                    *pickerView;

    // --- Variables ---
    NSMutableArray                            *sectionsArray ;
    NSMutableArray                            *arrayForBool;
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
    
    // Selected Keywords IDs
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedMeetUpKeywordIds ;
    
    // Selected Keywords Names
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedMeetUpKeywordNames ;
    
    NSMutableArray                            *searchResultsForKeywords;
    
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

    NSString                                 *prevDueDate ;
    NSDateFormatter                          *dateFormatter ;
    UIImage                                  *chosenImage;
}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property UIView    *selectedItem;

@end
