//
//  CampaignDetailViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 25/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    VIEW_CONTRACTOR_SELECTED,
    COMMIT_SELECTED 
};

#define CAMPAIGN_NAME_SECTION_INDEX           0
#define CAMPAIGN_TARGET_MARKET_SECTION_INDEX  2
#define CAMPAIGN_CAMP_KEYWORDS_SECTION_INDEX  3
#define CAMPAIGN_TARGET_AMOUNT_SECTION_INDEX  5
#define CAMPAIGN_FUND_RAISED_SECTION_INDEX    6
#define CAMPAIGN_SUMMARY_SECTION_INDEX        7
#define CAMPAIGN_IMAGES_SECTION_INDEX         8
#define CAMPAIGN_DOCUMENTS_SECTION_INDEX      9
#define CAMPAIGN_AUIDIOS_SECTION_INDEX        10
#define CAMPAIGN_VIDEOS_SECTION_INDEX         11


@interface CampaignDetailViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate> {
   
    IBOutlet UIView                           *imgPopupView ;
    IBOutlet UIScrollView                     *scrollView;
    IBOutlet UIImageView                      *imgView;
    
    IBOutlet UIView                           *campaignDataView;
    IBOutlet UILabel                          *dataTitle;
    IBOutlet UIWebView                        *webView;
    
    NSMutableArray                            *sectionsArray ;
    NSMutableArray                            *arrayForBool;
    NSMutableArray                            *audiosArray ;
    NSMutableArray                            *videosArray ;
    NSMutableArray                            *docuementsArray ;
    NSMutableArray                            *selectedKeywordsArray ;
    NSMutableArray                            *selectedCampKeywordsArray ;
    NSMutableDictionary                       *campaignData ;
    int                                       isFollowed ;
    int                                       isCommitted ;
    NSNumberFormatter                         *formatter ;
}
@property (strong, nonatomic) IBOutlet UITableView *tblView;

@end
