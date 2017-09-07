//
//  AddForumViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 11/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"

#define kValidation_Forum_Title            @"Title Required."
#define kValidation_Forum_Description      @"Description field have to be at least 10 characters."
#define kValidation_Forum_Keyword          @"Please select at least one keyword."
#define FORUM_CREATED_MESSAGE              @"Forum has been created successfully."

#define kDescMinCharLength                 10 

@interface AddForumViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TLTagsControlDelegate>{
    
    IBOutlet UITextField               *titleTxtFld;
    IBOutlet UITextField               *startupTxtFld;
    IBOutlet UITextView                *descriptionTxtView;
    IBOutlet UIImageView               *imageView;
    IBOutlet UIButton                  *addForumBtn;
    
    
    IBOutlet UITableView               *popupTblView;
    IBOutlet UIView                    *popupView;
    
    IBOutlet TLTagsControl             *tagsScrollView;
    IBOutlet UIButton                  *tagsButton;
    IBOutlet UIView                    *pickerViewContainer;
    IBOutlet UIPickerView              *pickerView;
    
    NSMutableArray                     *startupsArray ;
    NSMutableArray                     *keywordsArray ;
    NSMutableArray                     *selectedKeywordsArray ;
    int                                selectedStartupIndex ;
    
    NSData                             *imgData ;
}


@property UIView                                  *selectedItem;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
