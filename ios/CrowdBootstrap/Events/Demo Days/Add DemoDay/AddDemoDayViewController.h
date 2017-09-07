//
//  AddDemoDayViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define DEMODAY_TITLE_SECTION_INDEX           0
#define DEMODAY_DESCRIPTION_SECTION_INDEX  1
#define DEMODAY_START_DATE_SECTION_INDEX  2
#define DEMODAY_END_DATE_SECTION_INDEX    3
#define DEMODAY_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define DEMODAY_KEYWORDS_SECTION_INDEX    5
#define DEMODAY_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define DEMODAY_IMAGE_SECTION_INDEX    7

enum {
    DEMODAY_START_DATE_SELECTED,
    DEMODAY_END_DATE_SELECTED
};

enum {
    DEMODAY_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    DEMODAY_KEYWORDS_SELECTED = 5,
    DEMODAY_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddDemoDay_SuccessMessage               @"Demo Day has been registered Successfully."
#define kNoTargetMarketKeywordsFoundMessage      @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage          @"No Interest Keywords Found"
#define kNoDemoDayKeywordsFoundMessage           @"No Demo Day Keywords Found"


@interface AddDemoDayViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    
    // Selected Keywords IDs
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedDemoDayKeywordIds ;
    
    // Selected Keywords Names
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedDemoDayKeywordNames ;
    
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
