//
//  AddSoftwareViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define SOFTWARE_TITLE_SECTION_INDEX           0
#define SOFTWARE_DESCRIPTION_SECTION_INDEX  1
#define SOFTWARE_START_DATE_SECTION_INDEX  2
#define SOFTWARE_END_DATE_SECTION_INDEX    3
#define SOFTWARE_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define SOFTWARE_KEYWORDS_SECTION_INDEX    5
#define SOFTWARE_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define SOFTWARE_IMAGE_SECTION_INDEX    7

enum {
    SOFTWARE_START_DATE_SELECTED,
    SOFTWARE_END_DATE_SELECTED
};

enum {
    SOFTWARE_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    SOFTWARE_KEYWORDS_SELECTED = 5,
    SOFTWARE_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddSoftware_SuccessMessage            @"Software has been added Successfully."
#define kNoTargetMarketKeywordsFoundMessage    @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage        @"No Interest Keywords Found"
#define kNoSoftwareKeywordsFoundMessage        @"No Software Keywords Found"


@interface AddSoftwareViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    NSMutableDictionary                       *softwareData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *softwareKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedSoftwareKeywordsArray ;
    
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedSoftwareKeywordIds ;
    
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedSoftwareKeywordNames ;
    
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
