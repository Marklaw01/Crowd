//
//  LoginViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 06/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDFTooltips.h"

#define EMAIL_IMAGE @"Login_email"
#define PASSWORD_IMAGE @"Login_password"

enum{
    HOME_SELECTED,
    SIGNUP_SELECTED,
    FORGOT_PASSWORD_SELECTED,
    RESEND_CONFIRMATION_SELECTED,
    ABOUT_SELECTED
};


@interface LoginViewController : UIViewController<UITextFieldDelegate>{
    
     IBOutlet UITextField *emailTxtFld;
     IBOutlet UITextField *passwordTxtFld;
    
    BOOL isResendConfirmation;
}
@property (nonatomic, strong) JDFSequentialTooltipManager *tooltipManager;
- (IBAction)btnAboutCorwdClicked:(id)sender;

@end
