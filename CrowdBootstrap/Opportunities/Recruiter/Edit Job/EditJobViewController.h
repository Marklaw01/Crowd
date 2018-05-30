//
//  EditJobViewController.h
//  CrowdBootstrap
//
//  Created by osx on 10/01/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"

#define JOB_CHOOSE_COMPANY_SECTION_INDEX            0
#define JOB_INDUSTRY_KEYWORDS_SECTION_INDEX         1
#define JOB_COUNTRY_SECTION_INDEX                   2
#define JOB_STATE_SECTION_INDEX                     3
#define JOB_TITLE_SECTION_INDEX                     4
#define JOB_ROLE_SECTION_INDEX                      5
#define JOB_TYPE_SECTION_INDEX                      6
#define JOB_MIN_WORK_NPS_SECTION_INDEX              7
#define JOB_LOCATION_SECTION_INDEX                  8
#define JOB_TRAVEL_SECTION_INDEX                    9
#define JOB_START_DATE_SECTION_INDEX                10
#define JOB_END_DATE_SECTION_INDEX                  11
#define JOB_SKILLS_SECTION_INDEX                    12
#define JOB_REQUIREMENT_SECTION_INDEX               13
#define JOB_POSTING_KEYWORDS_SECTION_INDEX          14
#define JOB_SUMMARY_SECTION_INDEX                   15
#define JOB_DOCUMENT_SECTION_INDEX                  16
#define JOB_AUDIO_SECTION_INDEX                     17
#define JOB_VIDEO_SECTION_INDEX                     18

enum {
    JOB_CHOOSE_COMPANY_SELECTED,
    JOB_COUNTRY_SELECTED,
    JOB_STATE_SELECTED,
    JOB_TYPE_SELECTED
};

enum {
    JOB_START_DATE_SELECTED,
    JOB_END_DATE_SELECTED
};

enum {
    INDUSTRY_KEYWORDS_SELECTED = 1,
    SKILLS_SELECTED = 12,
    JOB_POSTING_KEYWORDS_SELECTED = 14
};

#define kEditJob_SuccessMessage             @"Job has been updated Successfully."
#define kActivateJob_SuccessMessage         @"Job activated Successfully."


@interface EditJobViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIPickerViewDataSource,UIPickerViewDelegate, TLTagsControlDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView                      *popupTblView;
    IBOutlet UIView                           *popupView;
    
    IBOutlet UIView                           *jobDataView;
    IBOutlet UILabel                          *dataTitle;
    IBOutlet UIWebView                        *webView;
    
    IBOutlet UIPickerView                     *pickerVw;
    IBOutlet UIView                           *pickerViewContainer;
    IBOutlet UIDatePicker                     *datePickerView;
    IBOutlet UIView                           *datePickerViewContainer;
    
    // --- Variables ---
    NSMutableArray                            *sectionsArray ;
    NSMutableArray                            *arrayForBool;
    NSString                                  *audioFile ;
    NSString                                  *videoFile ;
    NSString                                  *docuementFile ;
    
    // Industry/Job Posting/Skills Keywords Array
    NSMutableArray                            *industryKeywordsArray ;
    NSMutableArray                            *jobPostingKeywordsArray ;
    NSMutableArray                            *skillsArray ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedJobPostingKeywordsArray ;
    NSMutableArray                            *selectedSkillsArray ;
    int                                       selectedKeywordType ;
    NSMutableDictionary                       *jobData ;
    
    // Country/State/Job Type/Company Array
    NSMutableArray                           *basicArray ;
    NSMutableArray                           *countryArray ;
    NSMutableArray                           *statesArray ;
    NSMutableArray                           *jobTypeArray ;
    NSMutableArray                           *companiesArray ;
    NSString                                 *selectedCountryID ;
    NSString                                 *selectedStateID ;
    NSString                                 *selectedJobTypeID ;
    NSString                                 *selectedCompanyID ;
    int                                      selectedPickerViewType ;
    int                                      selectedDatePickerType ;
    
    NSString                                 *prevDueDate ;
    NSDateFormatter                          *dateFormatter ;
    NSInteger                                selectedSegment;

}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property UIView    *selectedItem;

@end
