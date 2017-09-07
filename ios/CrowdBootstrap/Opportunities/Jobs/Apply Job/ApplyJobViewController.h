//
//  ApplyJobViewController.h
//  CrowdBootstrap
//
//  Created by osx on 28/12/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kApplyJob_SuccessMessage          @"Job applied Successfully."

#define kCellIndex_JobTitle                 0
#define kCellIndex_JobPostedBy              1
#define kCellIndex_JobDesc                  2
#define kCellIndex_JobCoverLetter           3
#define kCellIndex_JobExperience            4
#define kCellIndex_AddExperience            5
#define kCellIndex_JobSubmit                6

@interface ApplyJobViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView *tblView ;
    __weak IBOutlet NSLayoutConstraint *constraintTblViewTop;
    
    IBOutlet UITableView            *popupTblView;
    IBOutlet UIView                 *popupView;

    NSMutableArray                  *sectionsArray ;
    NSMutableArray                  *arrayForBool;
    NSMutableArray                  *experienceListArray ;
    NSMutableArray                  *keywordsArray;
    NSMutableDictionary             *jobDetails;
    NSString                        *jobExperienceId;
}

@property UIView *selectedItem;

@end
