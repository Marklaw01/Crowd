//
//  BusinessCardDetailViewController.h
//  CrowdBootstrap
//
//  Created by Shikha on 10/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessCardDetailViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    // IBOutlets
    __weak IBOutlet UIImageView *imgVwUser;
    __weak IBOutlet UILabel *lblUsername;
    __weak IBOutlet UITextView *txtVwUserBio;
    __weak IBOutlet UITextView *txtVwUserInterest;
    __weak IBOutlet UITextView *txtVwUserStatement;
    __weak IBOutlet UIImageView *imgVwBusinessCard;
    __weak IBOutlet UIButton *btnLinkedInInfo;
    __weak IBOutlet UILabel *lblAddNotes;
    __weak IBOutlet UITextView *txtVwNotes;
    __weak IBOutlet UIButton *btnConnect;
    __weak IBOutlet UIButton *btnViewNotes;
    __weak IBOutlet UIButton *btnAddNote;
    __weak IBOutlet UITextField *txtConnectionType;
    __weak IBOutlet UIButton *btnSave;

    // Picker View
    __weak IBOutlet UIView *pickerViewContainer;
    __weak IBOutlet UIPickerView *pickerView;
    
    // Constraints
//    __weak IBOutlet NSLayoutConstraint *constraintContentHeight;
    
    // Variables
    NSMutableArray *connectionTypeArray ;
    NSString *selectedConnectionTypeID ;
    UIImage *chosenImage;
    NSData *imgData ;
    NSDictionary *dictBusinessCard;
    
//    CGPoint lastOffset;
//    CGFloat kbHeight;
}
@property(nonatomic) NSString *selectedCardId;
@property(nonatomic) NSString *strBusinessCardScreenType;
@property(nonatomic) NSDictionary *selectedUserDict;
@property(nonatomic) NSDictionary *selectedNoteDict;
@property(nonatomic) NSDictionary *selectedCardDict;
@property(nonatomic) NSDictionary *selectedProfileDict;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property UIView *selectedItem;

@end
