//
//  AddProductivityViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define PRODUCTIVITY_TITLE_SECTION_INDEX           0
#define PRODUCTIVITY_DESCRIPTION_SECTION_INDEX  1
#define PRODUCTIVITY_START_DATE_SECTION_INDEX  2
#define PRODUCTIVITY_END_DATE_SECTION_INDEX    3
#define PRODUCTIVITY_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define PRODUCTIVITY_KEYWORDS_SECTION_INDEX    5
#define PRODUCTIVITY_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define PRODUCTIVITY_IMAGE_SECTION_INDEX    7

enum {
    PRODUCTIVITY_START_DATE_SELECTED,
    PRODUCTIVITY_END_DATE_SELECTED
};

enum {
    PRODUCTIVITY_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    PRODUCTIVITY_KEYWORDS_SELECTED = 5,
    PRODUCTIVITY_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddProductivity_SuccessMessage            @"Productivity has been added Successfully."
#define kNoTargetMarketKeywordsFoundMessage        @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage            @"No Interest Keywords Found"
#define kNoProductivityKeywordsFoundMessage        @"No Productivity Keywords Found"


@interface AddProductivityViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    NSMutableDictionary                       *productivityData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *productivityKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedProductivityKeywordsArray ;
    
    // Selected Keywords IDs
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedProductivityKeywordIds ;
    
    // Selected Keywords Names
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedProductivityKeywordNames ;
    
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
