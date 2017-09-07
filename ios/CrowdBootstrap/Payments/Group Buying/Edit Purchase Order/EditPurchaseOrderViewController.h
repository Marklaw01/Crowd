//
//  EditPurchaseOrderViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define PURCHASE_ORDER_FOLLOW_SECTION_INDEX           0
#define PURCHASE_ORDER_TITLE_SECTION_INDEX           1
#define PURCHASE_ORDER_DESCRIPTION_SECTION_INDEX  2
#define PURCHASE_ORDER_START_DATE_SECTION_INDEX  3
#define PURCHASE_ORDER_END_DATE_SECTION_INDEX    4
#define PURCHASE_ORDER_TARGET_MARKET_KEYWORDS_SECTION_INDEX    5
#define PURCHASE_ORDER_KEYWORDS_SECTION_INDEX    6
#define PURCHASE_ORDER_INDUSTRY_KEYWORDS_SECTION_INDEX  7
#define PURCHASE_ORDER_IMAGE_SECTION_INDEX       8
#define PURCHASE_ORDER_DOCUMENT_SECTION_INDEX    9
#define PURCHASE_ORDER_AUDIO_SECTION_INDEX    10
#define PURCHASE_ORDER_VIDEO_SECTION_INDEX    11

enum {
    PURCHASE_ORDER_START_DATE_SELECTED,
    PURCHASE_ORDER_END_DATE_SELECTED
};

enum {
    PURCHASE_ORDER_TARGET_MARKET_KEYWORDS_SELECTED = 5,
    PURCHASE_ORDER_KEYWORDS_SELECTED = 6,
    PURCHASE_ORDER_INDUSTRY_KEYWORDS_SELECTED = 7
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kEditPurchaseOrder_SuccessMessage         @"Purchase Order has been updated Successfully."
#define kNoTargetMarketKeywordsFoundMessage       @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage           @"No Interest Keywords Found"
#define kNoPurchaseOrderKeywordsFoundMessage      @"No Purchase Order Keywords Found"

@interface EditPurchaseOrderViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView                      *popupTblView;
    IBOutlet UIView                           *popupView;
    IBOutlet UISearchBar                      *searchBarKeywords;
    
    IBOutlet UIView                           *purchaseOrderDataView;
    IBOutlet UILabel                          *dataTitle;
    IBOutlet UIWebView                        *webView;
    
    IBOutlet UIDatePicker                     *datePickerView;
    IBOutlet UIView                           *datePickerViewContainer;

    // Pop-Up View
    IBOutlet UITableView                     *tblViewUsers ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    
    // Search Recommended Users
    IBOutlet NSLayoutConstraint              *constraintTblViewTop;
    IBOutlet UIButton                        *btnSearchRecommUser;
    IBOutlet UISearchBar                     *searchBarUsers;
    IBOutlet UILabel                         *lblNoUserAvailable;
    
    // --- Variables ---
    NSMutableArray                            *sectionsArray ;
    NSMutableArray                            *arrayForBool;
    NSString                                  *audioFile ;
    NSString                                  *videoFile ;
    NSString                                  *docuementFile ;
    
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
    
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedPurchaseOrderKeywordIds ;
    
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedPurchaseOrderKeywordNames ;
    
    int                                       selectedKeywordType ;
    int                                       selectedDatePickerType ;
    int                                       isFollowed ;
    int                                       isLiked ;
    
    // Commitments
    int                                       isCommited ;
    NSString                                  *noOfcommit ;
    NSInteger                                 totalItems ;
    NSMutableArray                            *usersArray ;
    int                                       rowIndex ;
    int                                       pageNo ;
    
    NSMutableArray                           *searchResultsForRegisteredUsers ;
    NSMutableArray                           *searchResultsForKeywords;
    
    NSString                                 *prevDueDate ;
    NSDateFormatter                          *dateFormatter ;
    UIImage                                  *chosenImage;
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property UIView    *selectedItem;

@end
