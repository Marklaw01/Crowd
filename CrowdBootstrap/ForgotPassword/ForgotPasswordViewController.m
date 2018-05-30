//
//  ForgotPasswordViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 06/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "LoginViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //securityQuestionsArray = [[NSMutableArray alloc] initWithObjects:@"Security Question 1",@"Security Question 2",@"Security Question 3",@"Security Question 4",@"Security Question 5", nil];
    
    [self resetUISettings] ;
    [self setTextFieldUI] ;
    [self addTxtFldLeftView] ;
     
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)addTxtFldLeftView{
    
    // email left view
    UIImageView *emailImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:EMAIL_IMAGE]] ;
    emailImg.frame = CGRectMake(10,7, 18, 18) ;
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, emailTextFld.frame.size.height)];
    [emailPaddingView addSubview:emailImg] ;
    emailTextFld.leftView = emailPaddingView;
    emailTextFld.leftViewMode = UITextFieldViewModeAlways ;
}


-(void)setTextFieldUI{
    [UtilityClass setTextFieldBorder:emailTextFld] ;
    [UtilityClass setTextFieldBorder:answerTxtFld] ;
}

-(void)resetUISettings{
    selectedSecurityQuesIndex = -1 ;
    previousSecurityQuesIndx = -1 ;
    answerCount = 1 ;
    [UtilityClass addMarginsOnTextField:emailTextFld] ;
    [UtilityClass addMarginsOnTextField:answerTxtFld] ;
    
    if (_isResendConfirmation) {
        [btnResetPassword setTitle:@"Resend Confirmation" forState:UIControlStateNormal];
    } else {
        [btnResetPassword setTitle:@"Reset Password" forState:UIControlStateNormal];
    }
}

-(void)navigateToLoginScreen{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kLoginIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

#pragma mark - Validation Methods
-(void)validateEmail{
    
    if(emailTextFld.text.length <1){
       // [self presentViewController:[UtilityClass displayAlertMessage:ALERT_EMAIL_BLANK] animated:YES completion:nil];
        [UtilityClass setTextFieldValidationBorder:emailTextFld] ;
        [self.tooltipManager addTooltipWithTargetView:emailTextFld hostView:self.view tooltipText:kAlert_EnterRegisteredEmail arrowDirection:JDFTooltipViewArrowDirectionUp width:emailTextFld.frame.size.width];
        [self.tooltipManager showNextTooltip] ;
        return ;
    }
    else
    {
        if(![UtilityClass NSStringIsValidEmail:emailTextFld.text]){
            //[self presentViewController:[UtilityClass displayAlertMessage:ALERT_VALID_EMAIL] animated:YES completion:nil];
            [UtilityClass setTextFieldValidationBorder:emailTextFld] ;
            [self.tooltipManager addTooltipWithTargetView:emailTextFld hostView:self.view tooltipText:kAlert_Valid_Email arrowDirection:JDFTooltipViewArrowDirectionUp width:emailTextFld.frame.size.width];
            [self.tooltipManager showNextTooltip] ;
            return ;
        }
        else{
            if([UtilityClass checkInternetConnection]){
                
                [UtilityClass showHudWithTitle:kHUDMessage_ForgotPassword] ;
                
                NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
                [dictParam setObject:emailTextFld.text forKey:kForgotPasswordAPI_Email] ;
                
                [ApiCrowdBootstrap getUserSecurityQuestionsWithParameters:dictParam success:^(NSDictionary *responseDict) {
                   
                    NSLog(@"responseDict: %@",responseDict) ;
                    
                    if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                        emailTextFld.hidden = YES ;
                        questionLbl.hidden = NO ;
                        answerTxtFld.hidden = NO ;
                        securityQuesDefaultLbl.hidden = NO ;
                        securityQuestionsArray = [NSArray arrayWithArray:[responseDict objectForKey:@"questionAnswers"]] ;
                        if(securityQuestionsArray.count >0){
                            selectedSecurityQuesIndex = 0 ;
                            questionLbl.text = [[securityQuestionsArray objectAtIndex:selectedSecurityQuesIndex] valueForKey:@"question"] ;
                        }
                        
                    }
                    else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)  {
                       
                        [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
                        [self navigateToLoginScreen] ;
                        //[self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                    }
                   // else [self presentViewController:[UtilityClass displayAlertMessage:kAlert_EmailNotRegistered] animated:YES completion:nil];
                    //[self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                    [UtilityClass hideHud] ;
                    
                } failure:^(NSError *error) {
                    [UtilityClass displayAlertMessage:error.description] ;
                    [UtilityClass hideHud] ;
                }] ;
            }
        }
    }
}

-(void)validateResendConfirmationEmail {
    
    if(emailTextFld.text.length <1){
        [UtilityClass setTextFieldValidationBorder:emailTextFld] ;
        [self.tooltipManager addTooltipWithTargetView:emailTextFld hostView:self.view tooltipText:kAlert_EnterRegisteredEmail arrowDirection:JDFTooltipViewArrowDirectionUp width:emailTextFld.frame.size.width];
        [self.tooltipManager showNextTooltip] ;
        return ;
    }
    else
    {
        if(![UtilityClass NSStringIsValidEmail:emailTextFld.text]){
            [UtilityClass setTextFieldValidationBorder:emailTextFld] ;
            [self.tooltipManager addTooltipWithTargetView:emailTextFld hostView:self.view tooltipText:kAlert_Valid_Email arrowDirection:JDFTooltipViewArrowDirectionUp width:emailTextFld.frame.size.width];
            [self.tooltipManager showNextTooltip] ;
            return ;
        }
        else {
            [self resendConfirmationMail];
        }
    }
}

-(void)validateAnswer{
    hasReachedMaxTrialLimit = FALSE ;
    if(answerTxtFld.text.length <1){
        [UtilityClass setTextFieldValidationBorder:answerTxtFld] ;
        [self.tooltipManager addTooltipWithTargetView:answerTxtFld hostView:self.view tooltipText:kAlert_BlankAnswer arrowDirection:JDFTooltipViewArrowDirectionUp width:answerTxtFld.frame.size.width];
        [self.tooltipManager showNextTooltip] ;
        return ;
    }
    else{
        
        if([answerTxtFld.text isEqualToString:[[securityQuestionsArray objectAtIndex:selectedSecurityQuesIndex] valueForKey:@"answer"]]){
            
            [self sendResetPasswordMail] ;
            //[self navigateToLoginScreen] ;
        }
        else{
            
            [self displayPopupMessage:kAlert_AnswerIncorrect];
            [self startTimer] ;
            
            if(securityQuestionsArray.count == kMaximumAnswerCount-1){
                if(selectedSecurityQuesIndex == 0)selectedSecurityQuesIndex ++ ;
                else selectedSecurityQuesIndex -- ;
            }
            else if(securityQuestionsArray.count > kMaximumAnswerCount-1){
                selectedSecurityQuesIndex ++ ;
            }
            answerCount ++ ;
            questionLbl.text = [[securityQuestionsArray objectAtIndex:selectedSecurityQuesIndex] valueForKey:@"question"];
            answerTxtFld.text = @"" ;
            
            /*
            if(answerCount == kMaximumAnswerCount){
                
                [self sendMaxLimitForResetPassword] ;
                
            }
            else{
                [self displayPopupMessage:kAlert_AnswerIncorrect];
                [self startTimer] ;
                
                if(securityQuestionsArray.count == kMaximumAnswerCount-1){
                    if(selectedSecurityQuesIndex == 0)selectedSecurityQuesIndex ++ ;
                    else selectedSecurityQuesIndex -- ;
                }
                else if(securityQuestionsArray.count > kMaximumAnswerCount-1){
                    selectedSecurityQuesIndex ++ ;
                }
                answerCount ++ ;
                questionLbl.text = [[securityQuestionsArray objectAtIndex:selectedSecurityQuesIndex] valueForKey:@"question"];
                answerTxtFld.text = @"" ;
            }
            
        */
        }
        
    }
}

#pragma mark - AlertController Methods
-(void)displayPopupMessage:(NSString*)messsage
{
    alertController = [UIAlertController alertControllerWithTitle:@"" message:messsage preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Timer Methods
- (void)_timerFired:(NSTimer *)timer {
    [self stopTimer] ;
    [self dismissViewControllerAnimated:YES completion:nil] ;
    if(hasReachedMaxTrialLimit)[self navigateToLoginScreen] ;
}

-(void)startTimer{
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.50f
                                                 target:self
                                               selector:@selector(_timerFired:)
                                               userInfo:nil
                                                repeats:YES];
    }
}

- (void)stopTimer {
    if ([timer isValid]) {
        [timer invalidate];
    }
    timer = nil;
}

#pragma mark - API Methods
-(void)sendResetPasswordMail{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_ForgotPassword] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:emailTextFld.text forKey:kResetPasswordMailAPI_Email] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap sendResetPasswordMailWithParameters:dictParam success:^(NSDictionary *responseDict) {
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                [UtilityClass showNotificationMessgae:kAlert_ResetPasswordMail withResultType:@"1" withDuration:1.5] ;
                [self navigateToLoginScreen] ;
            }
            else [self presentViewController:[UtilityClass displayAlertMessage:kAlert_EmailNotRegistered] animated:YES completion:nil];
            //[self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            [UtilityClass hideHud] ;
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)resendConfirmationMail{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_ForgotPassword] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:emailTextFld.text forKey:kResetPasswordMailAPI_Email] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap resendConfirmationMailWithParameters:dictParam success:^(NSDictionary *responseDict) {
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                [UtilityClass showNotificationMessgae:kAlert_ResendConfirmationMail withResultType:@"1" withDuration:1.5] ;
                [self navigateToLoginScreen] ;
            }
            else
                [self presentViewController:[UtilityClass displayAlertMessage:kAlert_EmailNotRegistered] animated:YES completion:nil];
            //[self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            [UtilityClass hideHud] ;
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)sendMaxLimitForResetPassword{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:emailTextFld.text forKey:kMaxLimitResetPaswordAPI_Email] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap sendMaxLimitResetPasswordWithParameters:dictParam success:^(NSDictionary *responseDict) {
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                //[self displayPopupMessage:kAlert_AnswerMaxLimit];
                 //[self displayPopupMessage:[responseDict valueForKey:@"message"]];
                hasReachedMaxTrialLimit = TRUE ;
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
                [self navigateToLoginScreen] ;
                //[self startTimer] ;
            }
            [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            [UtilityClass hideHud] ;
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - IBAction Methods
- (IBAction)resetPassword_ClickAction:(id)sender {
    
    [self.view endEditing:YES] ;
    
    [self setTextFieldUI] ;
    
    if(self.tooltipManager)self.tooltipManager = nil ;
    self.tooltipManager = [[JDFSequentialTooltipManager alloc] initWithHostView:self.view];
    self.tooltipManager.showsBackdropView = YES;
    [self.tooltipManager setBackdropTapActionEnabled:YES] ;
    [self.tooltipManager setShadowColourForAllTooltips:[UIColor redColor]] ;
   
    if (_isResendConfirmation) {
        [self validateResendConfirmationEmail];
    } else {
        if(emailTextFld.hidden == NO && questionLbl.hidden == YES)
            [self validateEmail] ;
        else
            [self validateAnswer] ;
    }
}

- (IBAction)Cancel_ClickAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    return YES ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UtilityClass setTextFieldBorder:textField] ;
    return YES ;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.tooltipManager hideAllTooltipsAnimated:YES] ;
    [UtilityClass setTextFieldBorder:textField] ;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.layer.borderColor == [[UIColor redColor] CGColor]) {
        [UtilityClass setTextFieldBorder:textField] ;
        [self.tooltipManager hideAllTooltipsAnimated:YES] ;
    }
    return YES ;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
