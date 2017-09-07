//
//  EditFundViewController.h
//  CrowdBootstrap
//
//  Created by osx on 25/01/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define FUND_FOLLOW_SECTION_INDEX           0
#define FUND_TITLE_SECTION_INDEX           1
#define FUND_DESCRIPTION_SECTION_INDEX  2
#define FUND_MANAGERS_KEYWORDS_SECTION_INDEX    3
#define FUND_SPONSORS_KEYWORDS_SECTION_INDEX    4
#define FUND_INDUSTRY_KEYWORDS_SECTION_INDEX  5
#define FUND_PORTFOLIO_KEYWORDS_SECTION_INDEX  6
#define FUND_START_DATE_SECTION_INDEX  7
#define FUND_END_DATE_SECTION_INDEX    8
#define FUND_CLOSE_DATE_SECTION_INDEX    9
#define FUND_KEYWORDS_SECTION_INDEX    10
#define FUND_IMAGE_SECTION_INDEX    11
#define FUND_DOCUMENT_SECTION_INDEX                  12
#define FUND_AUDIO_SECTION_INDEX                     13
#define FUND_VIDEO_SECTION_INDEX                     14


enum {
    FUND_START_DATE_SELECTED,
    FUND_END_DATE_SELECTED,
    FUND_CLOSE_DATE_SELECTED
};

enum {
    FUND_MANAGERS_KEYWORDS_SELECTED = 3,
    FUND_SPONSORS_KEYWORDS_SELECTED = 4,
    FUND_INDUSTRY_KEYWORDS_SELECTED = 5,
    FUND_PORTFOLIO_KEYWORDS_SELECTED = 6,
    FUND_KEYWORDS_SELECTED = 10
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kEditFund_SuccessMessage    @"Fund updated Successfully."
#define kNoManagersListFoundMessage    @"No Manager List Found"
#define kNoSponsorsListFoundMessage    @"No Sponsor List Found"
#define kNoIndustryListFoundMessage    @"No Industry List Found"
#define kNoPortfolioListFoundMessage   @"No Portfolio List Found"
#define kNoKeywordsListFoundMessage    @"No Keywords List Found"

@interface EditFundViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView                      *popupTblView;
    IBOutlet UIView                           *popupView;
    IBOutlet UISearchBar                      *searchBarKeywords;

    IBOutlet UIView                           *fundDataView;
    IBOutlet UILabel                          *dataTitle;
    IBOutlet UIWebView                        *webView;

    IBOutlet UIDatePicker                     *datePickerView;
    IBOutlet UIView                           *datePickerViewContainer;
        
    // --- Variables ---
    NSMutableArray                            *sectionsArray ;
    NSMutableArray                            *arrayForBool;
    NSString                                  *audioFile ;
    NSString                                  *videoFile ;
    NSString                                  *docuementFile ;

    NSMutableDictionary                       *fundData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *managersKeywordsArray ;
    NSMutableArray                            *sponsorsKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *portfolioKeywordsArray ;
    NSMutableArray                            *keywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedManagersKeywordsArray ;
    NSMutableArray                            *selectedSponsorsKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedPortfolioKeywordsArray ;
    NSMutableArray                            *selectedKeywordsArray ;
    
    NSMutableArray                            *selectedManagersKeywordIds ;
    NSMutableArray                            *selectedSponsorsKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedPortfolioKeywordIds ;
    NSMutableArray                            *selectedKeywordIds ;

    NSMutableArray                            *selectedManagersKeywordNames ;
    NSMutableArray                            *selectedSponsorsKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedPortfolioKeywordNames ;
    NSMutableArray                            *selectedKeywordNames ;

    NSMutableArray                           *searchResultsForKeywords;

    int                                       selectedKeywordType ;
    int                                       selectedDatePickerType ;
    int                                       isFollowed ;
    int                                       isLiked ;
    
    NSString                                 *prevDueDate ;
    NSDateFormatter                          *dateFormatter ;
    NSInteger                                selectedSegment;
    NSInteger                                selectedSegmentControl;
    UIImage                                  *chosenImage;
}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property UIView    *selectedItem;


@end
