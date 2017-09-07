//
//  EditBoardMemberViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define BOARD_MEMBER_FOLLOW_SECTION_INDEX           0
#define BOARD_MEMBER_TITLE_SECTION_INDEX           1
#define BOARD_MEMBER_DESCRIPTION_SECTION_INDEX  2
#define BOARD_MEMBER_START_DATE_SECTION_INDEX  3
#define BOARD_MEMBER_END_DATE_SECTION_INDEX    4
#define BOARD_MEMBER_TARGET_MARKET_KEYWORDS_SECTION_INDEX    5
#define BOARD_MEMBER_KEYWORDS_SECTION_INDEX    6
#define BOARD_MEMBER_INDUSTRY_KEYWORDS_SECTION_INDEX    7
#define BOARD_MEMBER_IMAGE_SECTION_INDEX       8
#define BOARD_MEMBER_DOCUMENT_SECTION_INDEX    9
#define BOARD_MEMBER_AUDIO_SECTION_INDEX       10
#define BOARD_MEMBER_VIDEO_SECTION_INDEX       11

enum {
    BOARD_MEMBER_START_DATE_SELECTED,
    BOARD_MEMBER_END_DATE_SELECTED
};

enum {
    BOARD_MEMBER_TARGET_MARKET_KEYWORDS_SELECTED = 5,
    BOARD_MEMBER_KEYWORDS_SELECTED = 6,
    BOARD_MEMBER_INDUSTRY_KEYWORDS_SELECTED = 7
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kCellIdentifier_UserProfile    @"userProfileCell"

#define kEditBoardMember_SuccessMessage           @"Board Member has been updated Successfully."
#define kNoTargetMarketKeywordsFoundMessage       @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage           @"No Interest Keywords Found"
#define kNoBoardMemberKeywordsFoundMessage        @"No Board Member Keywords Found"

@interface EditBoardMemberViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView                      *popupTblView;
    IBOutlet UIView                           *popupView;
    IBOutlet UISearchBar                      *searchBarKeywords;

    IBOutlet UIView                           *boardMemberDataView;
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
    
    // Selected Keywords Ids
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedBoardMemberKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    
    // Selected Keywords Names
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedBoardMemberKeywordNames ;
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
