//
//  AddEarlyAdopterViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define EARLY_ADOPTER_TITLE_SECTION_INDEX           0
#define EARLY_ADOPTER_DESCRIPTION_SECTION_INDEX  1
#define EARLY_ADOPTER_START_DATE_SECTION_INDEX  2
#define EARLY_ADOPTER_END_DATE_SECTION_INDEX    3
#define EARLY_ADOPTER_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define EARLY_ADOPTER_KEYWORDS_SECTION_INDEX    5
#define EARLY_ADOPTER_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define EARLY_ADOPTER_IMAGE_SECTION_INDEX    7

enum {
    EARLY_ADOPTER_START_DATE_SELECTED,
    EARLY_ADOPTER_END_DATE_SELECTED
};

enum {
    EARLY_ADOPTER_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    EARLY_ADOPTER_KEYWORDS_SELECTED = 5,
    EARLY_ADOPTER_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddEarlyAdopter_SuccessMessage            @"Early Adopter has been added Successfully."
#define kNoTargetMarketKeywordsFoundMessage        @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage            @"No Interest Keywords Found"
#define kNoEarlyAdopterKeywordsFoundMessage        @"No Early Adopter Keywords Found"

@interface AddEarlyAdopterViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    NSMutableDictionary                       *earlyAdopterData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *earlyAdopterKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;

    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedEarlyAdopterKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;

    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedEarlyAdopterKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;

    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedEarlyAdopterKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
   
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
