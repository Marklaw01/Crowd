//
//  RateViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 19/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"
#import "HCSStarRatingView.h"

#define STARTUP_SECTION_CELL_INDEX      3

#define kValidation_Rating_Description  @"Description field have to be at least 10 characters."
#define kValidation_Rating_TimeStamp    @"TimeStamp Required."
#define kValidation_Rating_Devlierable  @"Please add deliverable."
#define kValidation_Rating_Rating       @"Please add ratings."


@interface RateViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,TLTagsControlDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UITextView                *descriptionTextView;
    IBOutlet UITextField               *timestampTxtFld;
    IBOutlet UIDatePicker              *datePickerView;
    IBOutlet UIView                    *datePickerViewContainer;
    IBOutlet UITableView               *popupTblView;
    IBOutlet UIView                    *popupView;
    IBOutlet TLTagsControl             *tagsScrollView;
    IBOutlet UIButton                  *tagsButton;
    IBOutlet HCSStarRatingView         *ratingsView;
    
    NSDateFormatter                    *dateFormatter ;
    
    NSMutableArray                     *deliverablesArray ;
    NSMutableArray                     *selectedDeliverablesArray ;
    NSString                           *prevDueDate ;
    int                                selectedRoadmapIndex ;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property UIView                                  *selectedItem;


@end
