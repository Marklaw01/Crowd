//
//  AddLaunchDealViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define LAUNCHDEAL_TITLE_SECTION_INDEX           0
#define LAUNCHDEAL_DESCRIPTION_SECTION_INDEX  1
#define LAUNCHDEAL_START_DATE_SECTION_INDEX  2
#define LAUNCHDEAL_END_DATE_SECTION_INDEX    3
#define LAUNCHDEAL_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define LAUNCHDEAL_KEYWORDS_SECTION_INDEX    5
#define LAUNCHDEAL_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define LAUNCHDEAL_IMAGE_SECTION_INDEX    7

enum {
    LAUNCHDEAL_START_DATE_SELECTED,
    LAUNCHDEAL_END_DATE_SELECTED
};

enum {
    LAUNCHDEAL_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    LAUNCHDEAL_KEYWORDS_SELECTED = 5,
    LAUNCHDEAL_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddLaunchDeal_SuccessMessage            @"Launch Deal has been added Successfully."
#define kNoTargetMarketKeywordsFoundMessage    @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage        @"No Interest Keywords Found"
#define kNoLaunchDealKeywordsFoundMessage        @"No Launch Deal Keywords Found"


@interface AddLaunchDealViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate>
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
    NSMutableDictionary                       *launchDealData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *launchDealKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedLaunchDealKeywordsArray ;
    
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedLaunchDealKeywordIds ;
    
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedLaunchDealKeywordNames ;
    
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
