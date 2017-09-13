//
//  AddCareerViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define CAREER_TITLE_SECTION_INDEX           0
#define CAREER_DESCRIPTION_SECTION_INDEX  1
#define CAREER_START_DATE_SECTION_INDEX  2
#define CAREER_END_DATE_SECTION_INDEX    3
#define CAREER_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define CAREER_KEYWORDS_SECTION_INDEX    5
#define CAREER_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define CAREER_IMAGE_SECTION_INDEX    7

enum {
    CAREER_START_DATE_SELECTED,
    CAREER_END_DATE_SELECTED
};

enum {
    CAREER_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    CAREER_KEYWORDS_SELECTED = 5,
    CAREER_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddCareer_SuccessMessage                   @"Career has been added Successfully."
#define kNoTargetMarketKeywordsFoundMessage         @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage             @"No Interest Keywords Found"
#define kNoCareerKeywordsFoundMessage               @"No Career Keywords Found"


@interface AddCareerViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    NSMutableDictionary                       *careerData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *careerKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedCareerKeywordsArray ;
    
    // Selected Keywords IDs
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedCareerKeywordIds ;
    
    // Selected Keywords Names
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedCareerKeywordNames ;
    
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
