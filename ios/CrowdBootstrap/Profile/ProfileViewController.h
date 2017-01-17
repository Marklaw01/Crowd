//
//  ProfileViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 12/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSCurrencyTextField.h"

@interface ProfileViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    IBOutlet UIBarButtonItem          *menuBarBtn;
    IBOutlet UIView                   *basicView;
    IBOutlet UIView                   *professionalView;
    IBOutlet UIView                   *startupsView;
    IBOutlet UISegmentedControl       *segmentControl;
    IBOutlet UIImageView              *profileImageView;
    IBOutlet UITextField              *userNameTxtFld;
    IBOutlet TSCurrencyTextField      *hoursTxtFld;
    IBOutlet UIImageView              *toggleImageView;
    IBOutlet UIProgressView           *progressView;
    IBOutlet UILabel                  *progressLbl;
    IBOutlet UIButton                 *editBtn;
    IBOutlet UITableView              *popupTblView;
    IBOutlet UIView                   *popupView;
    IBOutlet UIView                   *accreditedPopupView;
    IBOutlet UIWebView                *accreditedWebView;
    
    IBOutlet UIToolbar                *toolBar;
    
    NSNumberFormatter                 *formatter ;
    NSMutableArray                    *popupArray ;
    int                               selectedUserType ;
}

@end
