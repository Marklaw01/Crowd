//
//  AddHardwareViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define HARDWARE_TITLE_SECTION_INDEX           0
#define HARDWARE_DESCRIPTION_SECTION_INDEX  1
#define HARDWARE_START_DATE_SECTION_INDEX  2
#define HARDWARE_END_DATE_SECTION_INDEX    3
#define HARDWARE_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define HARDWARE_KEYWORDS_SECTION_INDEX    5
#define HARDWARE_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define HARDWARE_IMAGE_SECTION_INDEX    7

enum {
    HARDWARE_START_DATE_SELECTED,
    HARDWARE_END_DATE_SELECTED
};

enum {
    HARDWARE_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    HARDWARE_KEYWORDS_SELECTED = 5,
    HARDWARE_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddHardware_SuccessMessage            @"Hardware has been added Successfully."
#define kNoTargetMarketKeywordsFoundMessage    @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage        @"No Interest Keywords Found"
#define kNoHardwareKeywordsFoundMessage        @"No Hardware Keywords Found"


@interface AddHardwareViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    NSMutableDictionary                       *hardwareData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *hardwareKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedHardwareKeywordsArray ;
    
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedHardwareKeywordIds ;
    
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedHardwareKeywordNames ;
    
    int                                       selectedKeywordType ;
    int                                       selectedDatePickerType ;
    
    NSMutableArray                           *searchResultsForKeywords;

    NSString                                 *prevDueDate ;
    NSDateFormatter                          *dateFormatter ;
    UIImage                                  *chosenImage;
}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property UIView    *selectedItem;

@end
