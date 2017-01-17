//
//  UpdateWorkOrderViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 31/08/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCMultiSortTableView.h"

enum {
    WORKUNITS_DATE_SELECTED,
    WORKORDER_DATE_SELECTED
};

#define kSelectDeliverableDefault                 @"Select Deliverable"
#define kValidation_DeliverableReq                @"Deliverable Required"
#define kValidation_DateReq                       @"Date Required"
#define kValidation_WorkUnitsReq                  @"Work Units Required"


@interface UpdateWorkOrderViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,XCMultiTableViewDataSource,XCMultiTableViewDelegate>{
    
    IBOutlet UILabel                              *delierableLbl;
    IBOutlet UIView                               *workOrderView;
    IBOutlet UITextField                          *deliverableTxtFld;
    IBOutlet UITextField                          *dateTxtFld;
    IBOutlet UITextField                          *workUnitsTxtFld;
    IBOutlet UIToolbar                            *numberToolBar;
    IBOutlet UIPickerView                         *pickerView;
    IBOutlet UIView                               *pickerViewContainer;
    IBOutlet UIDatePicker                         *datePickerView;
    IBOutlet UIView                               *datePickerViewContainer;
    IBOutlet UIButton                             *updateButton ;
    UITextField                                   *changeDateTxtFld ;
    
    XCMultiTableView                              *tableView ;
    NSDateFormatter                               *formatter ;
    NSArray                                       *daysArray ;
    NSArray                                       *totalWorkUnitsArray ;
    NSMutableArray                                *weeklyUpdateArray ;
    NSMutableArray                                *deliverablesArray;
    NSString                                      *prevDueDate ;
    NSString                                      *vertexText ;
    int                                           selectedDeliverableIndex ;
    int                                           totalHours ;
    int                                           allocatedHours ;
    int                                           consumedHours ;
    int                                           approvedHours ;
    int                                           selectedDatePickerMode ;
    
    
    // GridView
    NSMutableArray                                *headData;
    NSMutableArray                                *leftTableData;
    NSMutableArray                                *rightTableData;
    NSMutableArray                                *datesArray ;
    
}

@property UIView                                 *selectedItem;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;

@end
