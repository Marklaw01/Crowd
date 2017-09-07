//
//  AddCampaignViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 11/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"
#import "TSCurrencyTextField.h"


enum{
    IMAGE_SELECTED,
    VIDEO_SELECTED
};


#define CHOOSE_STARTUP_DEFAULT_TEXT    @"Select Startup"
#define CAMPAIGN_CREATED_MESSAGE       @"Campaign has been created successfully."

@interface AddCampaignViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TLTagsControlDelegate>{
    
    
    IBOutlet UITextField               *campaignNameTxtFld;
    IBOutlet UITextField               *chooseStartupTxtFld;
    IBOutlet UITextField               *dueDateTxtFld;
    
    IBOutlet TSCurrencyTextField       *targetAmount;
    IBOutlet UITextView                *summaryTxtFld;
    IBOutlet UIButton                  *dropdownBtn ;
    IBOutlet UIButton                  *calendarBtn ;
    IBOutlet UILabel                   *videoNameLbl;
    IBOutlet UIButton                  *videoDeleteBtn;
    IBOutlet UIButton                  *keywordsBtn;
    IBOutlet TLTagsControl             *keywordsView;
    IBOutlet TLTagsControl             *campaignKeywordsView;
    IBOutlet UIButton                  *campaignKeywordsBtn;
    
    IBOutlet UIPickerView              *pickerView;
    IBOutlet UIView                    *pickerViewContainer;
    IBOutlet UIDatePicker              *datePickerView;
    IBOutlet UIView                    *datePickerViewContainer;
    IBOutlet UITableView               *popupTblView;
    IBOutlet UIView                    *popupView;
    IBOutlet UIToolbar                 *numberToolBar;
    IBOutlet UIImageView               *imageView;
    
    IBOutlet UIProgressView            *progressView;
    IBOutlet UILabel                   *progressLbl;
    
    NSData                             *imgData ;
    NSData                             *videoData ;
    NSMutableArray                     *keywordsArray ;
    NSMutableArray                     *campaignKeywordsArray ;
    NSMutableArray                     *selectedKeywordsArray ;
    NSMutableArray                     *selectedCampaignKeywordsArray ;
    NSMutableArray                     *startupsArray ;
    NSString                           *prevDueDate ;
    int                                selectedStartupIndex ;
    int                                selectedKeywordType ;
    
    NSDateFormatter                    *dateFormatter ;
}
@property UIView *selectedItem;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
