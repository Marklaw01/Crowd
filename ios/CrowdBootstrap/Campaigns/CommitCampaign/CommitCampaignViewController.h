//
//  CommitCampaignViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 25/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSCurrencyTextField.h"

enum CONTRIBUTION_TYPE{
    PUBLIC_SELECTED,
    PRIVATE_SELECTED
};

#define TIME_PERIOD_DEFAULT            @"Select Time Period"
#define kValidation_Commit_Amount      @"Amount Required"
#define kValidation_Commit_TimePeriod  @"Time Period Required"

@interface CommitCampaignViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>{
    
    IBOutlet TSCurrencyTextField   *amountTxtFld;
    IBOutlet UITextField           *timePeriodTxtFld;
    IBOutlet UIButton              *publicBtn;
    IBOutlet UIButton              *privateBtn;
    IBOutlet UILabel               *amountLeftLbl;
    
    IBOutlet UIPickerView          *pickerView;
    IBOutlet UIView                *pickerViewContainer;
    IBOutlet UIToolbar             *numberToolBar;
    
   
    
    NSArray                        *timePeriodArray ;
    int                            selectedTimePeriodIndex ;
    float                          amountLeft ;
    NSNumber                       *amountNum ;
    NSNumberFormatter              *formatter ;
}

@end
