//
//  CreateFundViewController.h
//  CrowdBootstrap
//
//  Created by osx on 24/01/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define FUND_TITLE_SECTION_INDEX           0
#define FUND_DESCRIPTION_SECTION_INDEX  1
#define FUND_MANAGERS_KEYWORDS_SECTION_INDEX    2
#define FUND_SPONSORS_KEYWORDS_SECTION_INDEX    3
#define FUND_INDUSTRY_KEYWORDS_SECTION_INDEX  4
#define FUND_PORTFOLIO_KEYWORDS_SECTION_INDEX  5
#define FUND_START_DATE_SECTION_INDEX  6
#define FUND_END_DATE_SECTION_INDEX    7
#define FUND_CLOSE_DATE_SECTION_INDEX    8
#define FUND_KEYWORDS_SECTION_INDEX    9
#define FUND_IMAGE_SECTION_INDEX    10


enum {
    FUND_START_DATE_SELECTED,
    FUND_END_DATE_SELECTED,
    FUND_CLOSE_DATE_SELECTED
};

enum {
    FUND_MANAGERS_KEYWORDS_SELECTED = 2,
    FUND_SPONSORS_KEYWORDS_SELECTED = 3,
    FUND_INDUSTRY_KEYWORDS_SELECTED = 4,
    FUND_PORTFOLIO_KEYWORDS_SELECTED = 5,
    FUND_KEYWORDS_SELECTED = 9
};

enum {
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kCreateFund_SuccessMessage     @"Fund created Successfully."
#define kNoManagersListFoundMessage    @"No Manager List Found"
#define kNoSponsorsListFoundMessage    @"No Sponsor List Found"
#define kNoIndustryListFoundMessage    @"No Industry List Found"
#define kNoPortfolioListFoundMessage   @"No Portfolio List Found"
#define kNoKeywordsListFoundMessage    @"No Keywords List Found"

@interface CreateFundViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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

    NSString                                 *prevDueDate ;
    NSDateFormatter                          *dateFormatter ;
    UIImage                                  *chosenImage;
}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property UIView    *selectedItem;
@end
