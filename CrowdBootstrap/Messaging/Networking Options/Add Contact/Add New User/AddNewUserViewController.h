//
//  AddNewUserViewController.h
//  CrowdBootstrap
//
//  Created by Shikha on 07/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>

@interface AddNewUserViewController : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, G8TesseractDelegate>
{
    __weak IBOutlet UIImageView *imgVwBusinessCard;

    __weak IBOutlet UITextField *txtFieldName;
    __weak IBOutlet UITextField *txtFieldPhone;
    __weak IBOutlet UITextField *txtFieldEmail;
    __weak IBOutlet UITextField *txtFieldConnectionType;
    __weak IBOutlet UITextView *txtViewNote;
    
    // Picker View
    __weak IBOutlet UIView                         *pickerViewContainer;
    __weak IBOutlet UIPickerView                   *pickerView;

    // Variables
    NSMutableArray                         *connectionTypeArray ;
    NSString                               *selectedConnectionTypeID ;

    UIImage                                *chosenImage;
    NSData                                 *imgData ;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property UIView *selectedItem;

@end
