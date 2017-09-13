//
//  AddPurchaseOrderViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define PURCHASE_ORDER_TITLE_SECTION_INDEX           0
#define PURCHASE_ORDER_DESCRIPTION_SECTION_INDEX  1
#define PURCHASE_ORDER_START_DATE_SECTION_INDEX  2
#define PURCHASE_ORDER_END_DATE_SECTION_INDEX    3
#define PURCHASE_ORDER_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define PURCHASE_ORDER_KEYWORDS_SECTION_INDEX    5
#define PURCHASE_ORDER_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define PURCHASE_ORDER_IMAGE_SECTION_INDEX    7

enum {
    PURCHASE_ORDER_START_DATE_SELECTED,
    PURCHASE_ORDER_END_DATE_SELECTED
};

enum {
    PURCHASE_ORDER_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    PURCHASE_ORDER_KEYWORDS_SELECTED = 5,
    PURCHASE_ORDER_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddPurchaseOrder_SuccessMessage            @"Purchase Order has been added Successfully."
#define kNoTargetMarketKeywordsFoundMessage         @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage             @"No Interest Keywords Found"
#define kNoPurchaseOrderKeywordsFoundMessage        @"No Purchase Order Keywords Found"


@interface AddPurchaseOrderViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    NSMutableDictionary                       *purchaseOrderData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *purchaseOrderKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedPurchaseOrderKeywordsArray ;
    
    // Selected Keywords IDs
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedPurchaseOrderKeywordIds ;
    
    // Selected Keywords Names
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedPurchaseOrderKeywordNames ;
    
    NSMutableArray                            *searchResultsForKeywords;
    int                                       selectedKeywordType ;
    int                                       selectedDatePickerType ;
    
    NSString                                 *prevDueDate ;
    NSDateFormatter                          *dateFormatter ;
    UIImage                                   *chosenImage;
}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property UIView    *selectedItem;

@end
