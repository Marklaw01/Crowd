//
//  JobDetailViewController.h
//  CrowdBootstrap
//
//  Created by osx on 26/12/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JOB_FOLLOW_SECTION_INDEX           0
#define JOB_COMPANY_NAME_SECTION_INDEX           1
#define JOB_INDUSTRY_KEYWORDS_SECTION_INDEX  2
#define JOB_TITLE_SECTION_INDEX  3
#define JOB_ROLE_SECTION_INDEX  4
#define JOB_TYPE_SECTION_INDEX  5
#define JOB_MIN_WORK_NPS_SECTION_INDEX    6
#define JOB_LOCATION_SECTION_INDEX    7
#define JOB_STATE_SECTION_INDEX    8
#define JOB_TRAVEL_SECTION_INDEX    9
#define JOB_START_DATE_SECTION_INDEX    10
#define JOB_END_DATE_SECTION_INDEX    11
#define JOB_SKILLS_SECTION_INDEX    12
#define JOB_REQUIREMENT_SECTION_INDEX    13
#define JOB_POSTING_KEYWORDS_SECTION_INDEX    14
#define JOB_SUMMARY_SECTION_INDEX        15
#define JOB_COMPANY_IMAGE_SECTION_INDEX         16
#define JOB_DOCUMENT_SECTION_INDEX      17
#define JOB_AUDIO_SECTION_INDEX        18
#define JOB_VIDEO_SECTION_INDEX         19


@interface JobDetailViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIView                           *imgPopupView ;
    IBOutlet UIScrollView                     *scrollView;
    IBOutlet UIImageView                      *imgView;
    
    IBOutlet UIView                           *jobDataView;
    IBOutlet UILabel                          *dataTitle;
    IBOutlet UIWebView                        *webView;
    
    // --- Variables ---
    NSMutableArray                            *sectionsArray ;
    NSMutableArray                            *arrayForBool;
    NSString                                  *audioFile ;
    NSString                                  *videoFile ;
    NSString                                  *docuementFile ;
    NSMutableArray                            *selectedIndustryKeywordsArray ;
    NSMutableArray                            *selectedJobPostingKeywordsArray ;
    NSMutableArray                            *selectedSkilsArray ;
    NSMutableDictionary                       *jobData ;
    int                                       isFollowed ;

}
@property (strong, nonatomic) IBOutlet UITableView *tblView;

@end
