//
//  ForgotPasswordViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 06/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDFTooltips.h"

#define kMaximumAnswerCount            3

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate> {
    
   IBOutlet UITextField *emailTextFld;
   IBOutlet UITextField *answerTxtFld;
   IBOutlet UIButton *btnResetPassword;
    
   IBOutlet UILabel *securityQuesDefaultLbl;
   IBOutlet UILabel *questionLbl;
    
    UIAlertController *alertController ;
    
    NSArray *securityQuestionsArray ;
    int selectedSecurityQuesIndex ;
    int previousSecurityQuesIndx ;
    int answerCount ;
    BOOL hasReachedMaxTrialLimit ;
    
    NSTimer *timer ;
    
    
}
@property (nonatomic, strong) JDFSequentialTooltipManager *tooltipManager;
@property(nonatomic) BOOL isResendConfirmation;

@end
