//
//  AddServiceViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define SERVICE_TITLE_SECTION_INDEX           0
#define SERVICE_DESCRIPTION_SECTION_INDEX  1
#define SERVICE_START_DATE_SECTION_INDEX  2
#define SERVICE_END_DATE_SECTION_INDEX    3
#define SERVICE_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define SERVICE_KEYWORDS_SECTION_INDEX    5
#define SERVICE_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define SERVICE_IMAGE_SECTION_INDEX    7

enum {
    SERVICE_START_DATE_SELECTED,
    SERVICE_END_DATE_SELECTED
};

enum {
    SERVICE_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    SERVICE_KEYWORDS_SELECTED = 5,
    SERVICE_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddService_SuccessMessage            @"Service has been added Successfully."
#define kNoTargetMarketKeywordsFoundMessage      @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage          @"No Interest Keywords Found"
#define kNoServiceKeywordsFoundMessage        @"No Service Keywords Found"


@interface AddServiceViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    NSMutableDictionary                       *serviceData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *serviceKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedServiceKeywordsArray ;
    
    // Selected Keywords IDs
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedServiceKeywordIds ;
    
    // Selected Keywords Names
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedServiceKeywordNames ;
    
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
