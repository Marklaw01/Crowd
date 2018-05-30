//
//  Timesheet_StartupViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 20/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCMultiSortTableView.h"
#import "HCSStarRatingView.h"

enum {
    WORKUNITS_DATE_SELECTED,
    WORKORDER_DATE_SELECTED
};

#define kSelectDeliverableDefault                 @"Select Deliverable"
#define kValidation_DeliverableReq                @"Deliverable Required"
#define kValidation_DateReq                       @"Date Required"
#define kValidation_WorkUnitsReq                  @"Work Units Required"
#define kValidation_Work_Comment                  @"Comment Box should not be empty"

@interface WorkOrder_ContractorViewController : UIViewController<XCMultiTableViewDataSource,XCMultiTableViewDelegate, UITextFieldDelegate> {
    
    IBOutlet UIView                               *workOrderView;
    IBOutlet UIToolbar                            *numberToolBar;
    IBOutlet UIDatePicker                         *datePickerView;
    IBOutlet UIView                               *datePickerViewContainer;
    IBOutlet UIButton                             *updateButton ;
    IBOutlet UIButton                             *downloadButton ;
    UITextField                                   *changeDateTxtFld ;
    
    
    IBOutlet UILabel *noWorkOrderLbl;
    
    // Comment View
    IBOutlet UIView *commentView;
    IBOutlet UITextView *enterpreneurCommentTxtVw;
    IBOutlet HCSStarRatingView *ratingsView;
    IBOutlet UITextView *contractorCommentTxtVw;
    IBOutlet UIButton *submitBtn;
    
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
    
    NSDictionary                                    *responseDictionary;
    
    // GridView
    NSMutableArray                                *headData;
    NSMutableArray                                *leftTableData;
    NSMutableArray                                *rightTableData;
    NSMutableArray                                *datesArray ;
}

@property UIView                                 *selectedItem;

@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;

@property(nonatomic,strong) NSDictionary *dictionaryIDs;

@end
