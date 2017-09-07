//
//  AddFocusGroupViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define FOCUS_GROUP_TITLE_SECTION_INDEX           0
#define FOCUS_GROUP_DESCRIPTION_SECTION_INDEX  1
#define FOCUS_GROUP_START_DATE_SECTION_INDEX  2
#define FOCUS_GROUP_END_DATE_SECTION_INDEX    3
#define FOCUS_GROUP_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define FOCUS_GROUP_KEYWORDS_SECTION_INDEX    5
#define FOCUS_GROUP_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define FOCUS_GROUP_IMAGE_SECTION_INDEX    7

enum {
    FOCUS_GROUP_START_DATE_SELECTED,
    FOCUS_GROUP_END_DATE_SELECTED
};

enum {
    FOCUS_GROUP_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    FOCUS_GROUP_KEYWORDS_SELECTED = 5,
    FOCUS_GROUP_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddFocusGroup_SuccessMessage            @"Focus Group has been created Successfully."
#define kNoTargetMarketKeywordsFoundMessage      @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage          @"No Interest Keywords Found"
#define kNoFocusGroupKeywordsFoundMessage        @"No Focus Group Keywords Found"


@interface AddFocusGroupViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    NSMutableDictionary                       *focusGroupData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *focusGroupKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedFocusGroupKeywordsArray ;
    
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedFocusGroupKeywordIds ;

    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedFocusGroupKeywordNames ;
    
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
