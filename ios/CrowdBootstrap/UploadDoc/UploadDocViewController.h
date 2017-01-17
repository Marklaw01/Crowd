//
//  UploadDocViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 22/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CHECKBOX_SELECTED @"ShoppingCart_check"
#define CHECKBOX_UNSELECTED @"ShoppingCart_uncheck"
#define RADIOBUTON_SELECTED @"upload_radioBtn"
#define RADIOBUTTON_UNSELECTED @"upload_radiobtnUnselected"
#define ROADMAP_DEFAULT_TEXT @"Select Roadmap"

enum RADIO_BUTTON_SELECTED {
    SELECT_ALL,
    DESELECT_ALL
};

@interface UploadDocViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate> {
    
    IBOutlet UITextField *fileNameTxtFld;
    IBOutlet UIButton *selectAllBtn;
    IBOutlet UIButton *deselectAllBtn;
    IBOutlet UITextField *roadmapTxtFld;
    IBOutlet UIButton *publicBtn;
    IBOutlet UITableView *contractorsTblView;
    IBOutlet UIView *pickerViewContainer;
    IBOutlet UIPickerView *pickerView ;
    
    
    NSMutableArray *contractorsArray ;
    NSMutableArray *roadmapArray ;
    int selectedRoadmapIndex ;
}

@end
