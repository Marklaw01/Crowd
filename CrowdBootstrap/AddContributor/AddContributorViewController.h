//
//  AddContributorViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 19/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"
#import "TSCurrencyTextField.h"

enum PICKER_VIEW_TYPE{
    STARTUP_SELECTED,
    ROLE_SELECTED,
    TARGET_DATE_SELECTED
};

#define kToolbar_NextButton                 @"Next"
#define kToolbar_DoneButton                 @"Done"

#define kValidation_Contractor_Startup      @"Startup Required."
#define kValidation_Contractor_Role         @"Role Required."
#define kValidation_Contractor_Deliverable  @"Please select at least one roadmap deliverables."
#define kValidation_Contractor_Hours        @"Hourly Rate Required."
#define kValidation_Contractor_Allocated    @"Work Units Allocated Required."
#define kValidation_Contractor_Approved     @"Work Units Approved Required."
#define kValidation_Contractor_AllocatedMax @"Work Units Approved should not exceed Work Units Allocated."
#define kValidation_Target_Completion_Date     @"Target Completion Date Required."

@interface AddContributorViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,TLTagsControlDelegate>{
    
    IBOutlet UITextField               *selectStartupTxtFld;
    IBOutlet UITextField               *contractorNameTxtFld;
    IBOutlet UITextField               *roleTxtFld;
    IBOutlet UITextField               *workUnitsAllocatedTxtFld;
    IBOutlet UITextField               *workUnitsApprovedTxtFld;
    IBOutlet UITextField               *targetCompletionDateTxtFld;
    IBOutlet UIView                    *pickerViewContainer;
    IBOutlet UIPickerView              *pickerView;
    IBOutlet UIDatePicker              *datePickerView;
    IBOutlet UIView                    *datePickerViewContainer;
    IBOutlet UIButton                  *assignBtn ;
    IBOutlet UITableView               *popupTblView;
    IBOutlet UIView                    *popupView;
    IBOutlet TLTagsControl             *tagsScrollView;
    IBOutlet UIToolbar                 *numberToolBar;
    IBOutlet UIBarButtonItem           *doneBarButton;
    IBOutlet UIButton                  *arrowButton;
    IBOutlet UILabel                   *startupNameLbl;
    IBOutlet UIButton                  *tagsButton ;
    IBOutlet TSCurrencyTextField       *hourlyRateTxtFld;
    
    NSMutableArray                     *startupsArray ;
    NSMutableArray                     *roleArray ;
    NSMutableArray                     *deliverablesArray ;
    NSMutableArray                     *selectedDeliverablesArray ;
    int                                selectedStarupIndex ;
    int                                selectedRoleIndex ;
    int                                selecedPickerViewType ;
    int                                selectedDatePickerType ;
    NSString                           *prevTargetDate ;
    NSNumberFormatter                  *formatter ;
    NSDateFormatter                    *dateFormatter ;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property UIView *selectedItem;


@end
