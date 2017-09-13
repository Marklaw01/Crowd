//
//  AddEndorsorViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define ENDORSOR_TITLE_SECTION_INDEX           0
#define ENDORSOR_DESCRIPTION_SECTION_INDEX  1
#define ENDORSOR_START_DATE_SECTION_INDEX  2
#define ENDORSOR_END_DATE_SECTION_INDEX    3
#define ENDORSOR_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define ENDORSOR_KEYWORDS_SECTION_INDEX    5
#define ENDORSOR_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define ENDORSOR_IMAGE_SECTION_INDEX    7

enum {
    ENDORSOR_START_DATE_SELECTED,
    ENDORSOR_END_DATE_SELECTED
};

enum {
    ENDORSOR_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    ENDORSOR_KEYWORDS_SELECTED = 5,
    ENDORSOR_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddEndorsor_SuccessMessage            @"Endorser has been created Successfully."
#define kNoTargetMarketKeywordsFoundMessage    @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage        @"No Interest Keywords Found"
#define kNoEndorsorKeywordsFoundMessage        @"No Endorser Keywords Found"


@interface AddEndorsorViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    NSMutableDictionary                       *endorsorData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *endorsorKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedEndorsorKeywordsArray ;
    
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedEndorsorKeywordIds ;

    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedEndorsorKeywordNames ;
    
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
