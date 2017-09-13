//
//  AddBoardMemberViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define BOARD_MEMBER_TITLE_SECTION_INDEX           0
#define BOARD_MEMBER_DESCRIPTION_SECTION_INDEX  1
#define BOARD_MEMBER_START_DATE_SECTION_INDEX  2
#define BOARD_MEMBER_END_DATE_SECTION_INDEX    3
#define BOARD_MEMBER_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define BOARD_MEMBER_KEYWORDS_SECTION_INDEX    5
#define BOARD_MEMBER_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define BOARD_MEMBER_IMAGE_SECTION_INDEX    7

enum {
    BOARD_MEMBER_START_DATE_SELECTED,
    BOARD_MEMBER_END_DATE_SELECTED
};

enum {
    BOARD_MEMBER_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    BOARD_MEMBER_KEYWORDS_SELECTED = 5,
    BOARD_MEMBER_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddBoardMember_SuccessMessage            @"Board Member has been added Successfully."
#define kNoTargetMarketKeywordsFoundMessage       @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage           @"No Interest Keywords Found"
#define kNoBoardMemberKeywordsFoundMessage        @"No Board Member Keywords Found"

@interface AddBoardMemberViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    NSMutableDictionary                       *boardMemberData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *boardMemberKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;

    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedBoardMemberKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;

    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedBoardMemberKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;

    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedBoardMemberKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;

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
