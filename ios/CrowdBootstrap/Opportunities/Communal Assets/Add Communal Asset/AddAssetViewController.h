//
//  AddAssetViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define COMMUNAL_ASSET_TITLE_SECTION_INDEX           0
#define COMMUNAL_ASSET_DESCRIPTION_SECTION_INDEX  1
#define COMMUNAL_ASSET_START_DATE_SECTION_INDEX  2
#define COMMUNAL_ASSET_END_DATE_SECTION_INDEX    3
#define COMMUNAL_ASSET_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define COMMUNAL_ASSET_KEYWORDS_SECTION_INDEX    5
#define COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define COMMUNAL_ASSET_IMAGE_SECTION_INDEX    7

enum {
    COMMUNAL_ASSET_START_DATE_SELECTED,
    COMMUNAL_ASSET_END_DATE_SELECTED
};

enum {
    COMMUNAL_ASSET_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    COMMUNAL_ASSET_KEYWORDS_SELECTED = 5,
    COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddCommunalAsset_SuccessMessage            @"Communal Asset has been added Successfully."
#define kNoTargetMarketKeywordsFoundMessage         @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage             @"No Interest Keywords Found"
#define kNoCommunalAssetKeywordsFoundMessage        @"No Communal Asset Keywords Found"


@interface AddAssetViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    NSMutableDictionary                       *communalAssetData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *communalAssetKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedCommunalAssetKeywordsArray ;
    
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedCommunalAssetKeywordIds ;
    
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedCommunalAssetKeywordNames ;
    
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
