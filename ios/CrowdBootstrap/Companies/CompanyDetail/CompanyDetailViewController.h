//
//  CompanyDetailViewController.h
//  CrowdBootstrap
//
//  Created by Shikha Singla on 22/11/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COMPANY_NAME_SECTION_INDEX           0
#define COMPANY_KEYWORDS_SECTION_INDEX       1
#define COMPANY_SUMMARY_SECTION_INDEX        2
#define COMPANY_IMAGES_SECTION_INDEX         3
#define COMPANY_DOCUMENTS_SECTION_INDEX      4
#define COMPANY_AUIDIOS_SECTION_INDEX        5
#define COMPANY_VIDEOS_SECTION_INDEX         6

@interface CompanyDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    IBOutlet UIView                           *imgPopupView ;
    IBOutlet UIScrollView                     *scrollView;
    IBOutlet UIImageView                      *imgView;
    
    IBOutlet UIView                           *companyDataView;
    IBOutlet UILabel                          *dataTitle;
    IBOutlet UIWebView                        *webView;
    
    NSMutableArray                            *sectionsArray ;
    NSMutableArray                            *arrayForBool;
    NSString                                  *audioFile ;
    NSString                                  *videoFile ;
    NSString                                  *docuementFile ;
    NSMutableArray                            *selectedCompanyKeywordsArray ;
    NSMutableDictionary                       *companyData ;

}

@property (strong, nonatomic) IBOutlet UITableView *tblView;

@end
