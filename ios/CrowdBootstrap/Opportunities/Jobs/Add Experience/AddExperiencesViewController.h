//
//  AddExperiencesViewController.h
//  CrowdBootstrap
//
//  Created by osx on 03/01/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"

#define SAVE_BUTTON_CELL_IDENTIFIER      @"SaveButtonCell"
#define kAddExperience_SuccessMessage    @"Experience added Successfully."

#define kCellIndex_CompanyName              0
#define kCellIndex_JobTitle                 1
#define kCellIndex_StartDate                2
#define kCellIndex_EndDate                  3
#define kCellIndex_CompanyUrl               4
#define kCellIndex_JobRole                  5
#define kCellIndex_JobDuties                6
#define kCellIndex_Acheivments              7

@interface AddExperiencesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, TLTagsControlDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView *tblView ;
    // Date Picker
    IBOutlet UIDatePicker              *datePickerView;
    IBOutlet UIView                    *datePickerViewContainer;
    
    // Job Role Keywords
    IBOutlet UITableView               *popupTblView;
    IBOutlet UIView                    *popupView;

    // --- Variables ---
    NSMutableDictionary                *experienceDic ;
    NSMutableArray                     *experienceArray;
    NSArray                            *parametersArray;
    NSArray                            *fieldsArray;
    NSMutableArray                     *keywordsArray;
    NSMutableArray                     *selectedKeywordsArray ;
    NSMutableArray                     *selectedJobRoleArray ;
    NSString                           *jobExperienceID;
    
    // Date Picker
    NSDateFormatter                    *dateFormatter ;
    NSString                           *startDate;
    NSString                           *endDate;
    NSInteger                          currentDatePickerTag;
    NSString                           *currentSection;
    NSString                           *prevDueDate;
    UITapGestureRecognizer             *txtViewTapped;
}

@property UIView *selectedItem;

@end
