//
//  AddImprovementToolViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define IMPROVEMENT_TITLE_SECTION_INDEX           0
#define IMPROVEMENT_DESCRIPTION_SECTION_INDEX  1
#define IMPROVEMENT_START_DATE_SECTION_INDEX  2
#define IMPROVEMENT_END_DATE_SECTION_INDEX    3
#define IMPROVEMENT_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define IMPROVEMENT_KEYWORDS_SECTION_INDEX    5
#define IMPROVEMENT_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define IMPROVEMENT_IMAGE_SECTION_INDEX    7

enum {
    IMPROVEMENT_START_DATE_SELECTED,
    IMPROVEMENT_END_DATE_SELECTED
};

enum {
    IMPROVEMENT_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    IMPROVEMENT_KEYWORDS_SELECTED = 5,
    IMPROVEMENT_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddImprovementTool_SuccessMessage            @"Improvement Tool has been added Successfully."
#define kNoTargetMarketKeywordsFoundMessage           @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage               @"No Interest Keywords Found"
#define kNoImprovementToolKeywordsFoundMessage        @"No Improvement Tool Keywords Found"


@interface AddImprovementToolViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    NSMutableDictionary                       *improvementToolData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *improvementToolKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedImprovementToolKeywordsArray ;
    
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedImprovementToolKeywordIds ;
    
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedImprovementToolKeywordNames ;
    
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
