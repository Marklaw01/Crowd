//
//  AddWebinarViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define WEBINAR_TITLE_SECTION_INDEX           0
#define WEBINAR_DESCRIPTION_SECTION_INDEX  1
#define WEBINAR_START_DATE_SECTION_INDEX  2
#define WEBINAR_END_DATE_SECTION_INDEX    3
#define WEBINAR_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define WEBINAR_KEYWORDS_SECTION_INDEX    5
#define WEBINAR_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define WEBINAR_IMAGE_SECTION_INDEX    7

enum {
    WEBINAR_START_DATE_SELECTED,
    WEBINAR_END_DATE_SELECTED
};

enum {
    WEBINAR_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    WEBINAR_KEYWORDS_SELECTED = 5,
    WEBINAR_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddWebinar_SuccessMessage               @"Webinar has been registered Successfully."
#define kNoTargetMarketKeywordsFoundMessage      @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage          @"No Interest Keywords Found"
#define kNoWebinarKeywordsFoundMessage           @"No Webinar Keywords Found"


@interface AddWebinarViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    NSMutableDictionary                       *webinarData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *webinarKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedWebinarKeywordsArray ;
    
    // Selected Keywords IDs
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedWebinarKeywordIds ;
    
    // Selected Keywords Names
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedWebinarKeywordNames ;
    
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
