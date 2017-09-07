//
//  AddNoteViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 18/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"
#import "CDTestEntity.h"

#define SELECT_STARTUP_DEFAULT  @"Select Startup"
#define kValidation_Note_Title  @"Title Required."
#define kValidation_Note_Desc   @"Description Required."
#define NOTE_SAVE_BUTTON        @"Save"
#define NOTE_EDIT_BUTTON        @"Edit"
#define ALERT_NOTE_ADDED        @"Note updated successfully."

@interface AddNoteViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>{
    
    IBOutlet UITextField         *selectStartupTxtFld;
    
    IBOutlet UITextField         *titleTxtFld;
    IBOutlet UITextView          *descriptionTxtView;
    IBOutlet UIPickerView        *pickerView;
    IBOutlet UIView              *pickerViewContainer;
    IBOutlet UIScrollView        *scrollView;
    IBOutlet UIButton            *saveBtn;
    IBOutlet UIButton            *dropdownBtn ;
    
    NSMutableArray               *startupsArray ;
    int                          selectedStartupIndex ;
    NSDateFormatter              *dateFormatter ;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) CDTestEntity *selectedEntity;

@end
