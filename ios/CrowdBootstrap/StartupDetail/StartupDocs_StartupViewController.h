//
//  StartupDocs_StartupViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 20/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kDeliverable_Default  @"Select Deliverable"


@interface StartupDocs_StartupViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>{
    
    IBOutlet UIView              *approveStartupView;
    IBOutlet UITextField         *prevRoadmapTextFld;
    IBOutlet UITextField         *currentRoadmapTxtFld;
    IBOutlet UIButton            *fileNameBtn;
    IBOutlet UIButton            *yesBtn;
    IBOutlet UIButton            *noBtn;
    IBOutlet UITextField         *nextStepTxtFld;
    IBOutlet UIView              *pickerViewContainer;
    IBOutlet UIPickerView        *pickerView ;
    
    NSMutableArray               *deliverablesArray ;
    int                          selectedRoadmapIndex ;
}

@property UIView                                  *selectedItem;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end
