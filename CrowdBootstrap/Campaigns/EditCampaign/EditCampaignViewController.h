//
//  EditCampaignViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 11/04/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"
#import "TSCurrencyTextField.h"

enum{
    CAMPAIGN_IMAGE_SELECTED,
    CAMPAIGN_VIDEO_SELECTED
};


#define EDIT_CAMPAIGN_NAME_SECTION_INDEX           0
#define EDIT_CAMPAIGN_STARTUP_SECTION_INDEX        1
#define EDIT_CAMPAIGN_TARGET_MARKET_SECTION_INDEX  2
#define EDIT_CAMPAIGN_CAMP_KEYWORDS_SECTION_INDEX  3
#define EDIT_CAMPAIGN_DUEDATE_SECTION_INDEX        4
#define EDIT_CAMPAIGN_TARGET_AMOUNT_INDEX          5
#define EDIT_CAMPAIGN_SUMMARY_SECTION_INDEX        6
#define EDIT_CAMPAIGN_IMAGES_SECTION_INDEX         7
#define EDIT_CAMPAIGN_DOCUMENTS_SECTION_INDEX      8
#define EDIT_CAMPAIGN_AUIDIOS_SECTION_INDEX        9
#define EDIT_CAMPAIGN_VIDEOS_SECTION_INDEX         10
#define EDIT_CAMPAIGN_UPLOAD_SECTION_INDEX         11


@interface EditCampaignViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TLTagsControlDelegate>{
    
    IBOutlet UIView                           *imgPopupView ;
    IBOutlet UIScrollView                     *scrollView;
    IBOutlet UIImageView                      *imgView;
    
    IBOutlet UIView                           *campaignDataView;
    IBOutlet UILabel                          *dataTitle;
    IBOutlet UIWebView                        *webView;
    
    IBOutlet UIDatePicker                     *datePickerView;
    IBOutlet UIView                           *datePickerViewContainer;
    IBOutlet UIPickerView                     *pickerView;
    IBOutlet UIView                           *pickerViewContainer;
    IBOutlet UITableView                      *popupTblView;
    IBOutlet UIView                           *popupView;
    IBOutlet UIToolbar                        *numberToolBar;
    
    NSMutableArray                            *sectionsArray ;
    NSMutableArray                            *arrayForBool;
    NSMutableArray                            *audiosArray ;
    NSMutableArray                            *videosArray ;
    NSMutableArray                            *docuementsArray ;
    NSMutableArray                            *selectedKeywordsArray ;
    NSMutableArray                            *selectedCampaignKeywordsArray ;
    NSMutableArray                            *keywordsArray ;
    NSMutableArray                            *campaignKeywordsArray ;
    NSMutableArray                            *startupsArray ;
    NSMutableArray                            *deletedFiles ;
    
    NSDictionary                              *campaignData ;
    NSString                                  *selectedStartupID ;
    NSString                                  *prevDueDate ;
    NSData                                    *imgData ;
    NSData                                    *videoData ;
    NSDateFormatter                           *dateFormatter ;
    int                                       selectedKeywordType ;
}

@property (strong, nonatomic) IBOutlet UITableView        *tblView;
@property UIView                                          *selectedItem;

@end
