//
//  AddAudioVideoViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTagsControl.h"

#define AUDIOVIDEO_TITLE_SECTION_INDEX           0
#define AUDIOVIDEO_DESCRIPTION_SECTION_INDEX  1
#define AUDIOVIDEO_START_DATE_SECTION_INDEX  2
#define AUDIOVIDEO_END_DATE_SECTION_INDEX    3
#define AUDIOVIDEO_TARGET_MARKET_KEYWORDS_SECTION_INDEX    4
#define AUDIOVIDEO_KEYWORDS_SECTION_INDEX    5
#define AUDIOVIDEO_INDUSTRY_KEYWORDS_SECTION_INDEX  6
#define AUDIOVIDEO_IMAGE_SECTION_INDEX    7

enum {
    AUDIOVIDEO_START_DATE_SELECTED,
    AUDIOVIDEO_END_DATE_SELECTED
};

enum {
    AUDIOVIDEO_TARGET_MARKET_KEYWORDS_SELECTED = 4,
    AUDIOVIDEO_KEYWORDS_SELECTED = 5,
    AUDIOVIDEO_INDUSTRY_KEYWORDS_SELECTED = 6
};

enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};

#define kAddAudioVideo_SuccessMessage            @"Audio/Video has been added Successfully."
#define kNoTargetMarketKeywordsFoundMessage      @"No Target Market Keywords Found"
#define kNoIndustryKeywordsFoundMessage          @"No Interest Keywords Found"
#define kNoAudioVideoKeywordsFoundMessage        @"No Audio/Video Keywords Found"


@interface AddAudioVideoViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TLTagsControlDelegate, UISearchBarDelegate>
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
    NSMutableDictionary                       *audioVideoData ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    
    // Keywords Array
    NSMutableArray                            *targetMarketKeywordsArray ;
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *audioVideoKeywordsArray ;
    
    // Selected Keywords Array
    NSMutableArray                            *selectedTargetMarketKeywordsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedAudioVideoKeywordsArray ;
    
    NSMutableArray                            *selectedTargetMarketKeywordIds ;
    NSMutableArray                            *selectedIndustryKeywordIds ;
    NSMutableArray                            *selectedAudioVideoKeywordIds ;
    
    NSMutableArray                            *selectedTargetMarketKeywordNames ;
    NSMutableArray                            *selectedIndustryKeywordNames ;
    NSMutableArray                            *selectedAudioVideoKeywordNames ;
    
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
