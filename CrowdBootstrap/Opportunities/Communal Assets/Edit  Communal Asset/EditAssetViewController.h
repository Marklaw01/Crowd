//
//  EditAssetViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define COMMUNAL_ASSET_FOLLOW_SECTION_INDEX           0
#define COMMUNAL_ASSET_TITLE_SECTION_INDEX           1
#define COMMUNAL_ASSET_DESCRIPTION_SECTION_INDEX  2
#define COMMUNAL_ASSET_START_DATE_SECTION_INDEX  3
#define COMMUNAL_ASSET_END_DATE_SECTION_INDEX    4
#define COMMUNAL_ASSET_TARGET_MARKET_KEYWORDS_SECTION_INDEX    5
#define COMMUNAL_ASSET_KEYWORDS_SECTION_INDEX    6
#define COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SECTION_INDEX    7
#define COMMUNAL_ASSET_IMAGE_SECTION_INDEX       8
#define COMMUNAL_ASSET_DOCUMENT_SECTION_INDEX    9
#define COMMUNAL_ASSET_AUDIO_SECTION_INDEX       10
#define COMMUNAL_ASSET_VIDEO_SECTION_INDEX       11

enum {
    COMMUNAL_ASSET_START_DATE_SELECTED,
    COMMUNAL_ASSET_END_DATE_SELECTED
};

enum {
    COMMUNAL_ASSET_TARGET_MARKET_KEYWORDS_SELECTED = 5,
    COMMUNAL_ASSET_KEYWORDS_SELECTED = 6,
    COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SELECTED = 7
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kEditCommunalAsset_SuccessMessage           @"Communal Asset has been updated Successfully."
#define kNoTargetMarketKeywordsFoundMessage         @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage             @"No Interest Keywords Found"
#define kNoCommunalAssetKeywordsFoundMessage        @"No Communal Asset Keywords Found"

@interface EditAssetViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView                      *popupTblView;
    IBOutlet UIView                           *popupView;
    IBOutlet UISearchBar                      *searchBarKeywords;
    
    IBOutlet UIView                           *communalAssetDataView;
    IBOutlet UILabel                          *dataTitle;
    IBOutlet UIWebView                        *webView;
    
    IBOutlet UIDatePicker                     *datePickerView;
    IBOutlet UIView                           *datePickerViewContainer;
    
    // Pop-Up View
    IBOutlet UITableView                     *tblViewUsers ;
    IBOutlet UIView                          *viewPopUp ;
    IBOutlet UILabel                         *lblPeople;
    IBOutlet UIImageView                     *imgVwPeople;
    
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
    
    NSMutableDictionary                       *communalAssetData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *communalAssetKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedCommunalAssetKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    
    // Selected Keywords Ids
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedCommunalAssetKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    
    // Selected Keywords Names
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedCommunalAssetKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    
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
