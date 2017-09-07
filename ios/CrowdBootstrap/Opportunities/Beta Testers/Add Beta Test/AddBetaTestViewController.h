//
//  AddBetaTestViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define BETA_TEST_TITLE_SECTION_INDEX           0
#define BETA_TEST_DESCRIPTION_SECTION_INDEX  1
#define BETA_TEST_START_DATE_SECTION_INDEX  2
#define BETA_TEST_END_DATE_SECTION_INDEX    3
#define BETA_TEST_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define BETA_TESTING_KEYWORDS_SECTION_INDEX    5
#define BETA_TEST_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define BETA_TEST_IMAGE_SECTION_INDEX    7

enum {
    BETA_TEST_START_DATE_SELECTED,
    BETA_TEST_END_DATE_SELECTED
};

enum {
    BETA_TEST_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    BETA_TESTING_KEYWORDS_SELECTED = 5,
    BETA_TEST_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddBetaTest_SuccessMessage            @"Beta Test has been created Successfully."
#define kNoTargetMarketKeywordsFoundMessage    @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage        @"No Interest Keywords Found"
#define kNoBetaTestKeywordsFoundMessage        @"No Beta Testing Keywords Found"


@interface AddBetaTestViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    NSMutableDictionary                       *betaTestData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *betaTestingkeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedBetaTestingkeywordsArray ;
    
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedBetaTestingkeywordIds ;

    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedBetaTestingkeywordNames ;
    
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
