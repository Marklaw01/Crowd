//
//  LoginViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 06/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "HomeViewController.h"
#import "ForgotPasswordViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetUISettings] ;
    [self addTxtFldLeftView] ;
    [self navigationBarSettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    [UtilityClass setTextFieldBorder:emailTxtFld] ;
    [UtilityClass setTextFieldBorder:passwordTxtFld] ;
}

-(void)navigationBarSettings{
    [self.navigationController setNavigationBarHidden:YES] ;
}

-(void)addTxtFldLeftView{
    
    // email left view
    UIImageView *emailImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:EMAIL_IMAGE]] ;
    emailImg.frame = CGRectMake(10,7, 18, 18) ;
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, emailTxtFld.frame.size.height)];
    [emailPaddingView addSubview:emailImg] ;
    emailTxtFld.leftView = emailPaddingView;
    emailTxtFld.leftViewMode = UITextFieldViewModeAlways ;
    
    // password left view
    UIImageView *passwordImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PASSWORD_IMAGE]] ;
    passwordImg.frame = CGRectMake(10,7, 18, 18) ;
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, passwordTxtFld.frame.size.height)];
    [passwordPaddingView addSubview:passwordImg] ;
    passwordTxtFld.leftView = passwordPaddingView;
    passwordTxtFld.leftViewMode = UITextFieldViewModeAlways ;
    
}

#pragma mark - Validation Methods
-(void)validateTextFields {
    
    [self resetUISettings] ;
    
    if(self.tooltipManager)self.tooltipManager = nil ;
    self.tooltipManager = [[JDFSequentialTooltipManager alloc] initWithHostView:self.view];
    self.tooltipManager.showsBackdropView = YES;
    [self.tooltipManager setBackdropTapActionEnabled:YES] ;
    [self.tooltipManager setShadowColourForAllTooltips:[UIColor redColor]] ;

    if(emailTxtFld.text.length <1) {
        [UtilityClass setTextFieldValidationBorder:emailTxtFld] ;
        [self.tooltipManager addTooltipWithTargetView:emailTxtFld hostView:self.view tooltipText:kAlert_Email_Blank arrowDirection:JDFTooltipViewArrowDirectionUp width:emailTxtFld.frame.size.width];
        [self.tooltipManager showNextTooltip] ;
        return ;
    }
    else if(![UtilityClass NSStringIsValidEmail:emailTxtFld.text]) {
        [UtilityClass setTextFieldValidationBorder:emailTxtFld] ;
        [self.tooltipManager addTooltipWithTargetView:emailTxtFld hostView:self.view tooltipText:kAlert_Valid_Email arrowDirection:JDFTooltipViewArrowDirectionUp width:emailTxtFld.frame.size.width];
        [self.tooltipManager showAllTooltips] ;
        return ;
    }
    else if(passwordTxtFld.text.length <1) {
        [UtilityClass setTextFieldValidationBorder:passwordTxtFld] ;
        [self.tooltipManager addTooltipWithTargetView:passwordTxtFld hostView:self.view tooltipText:kAlert_Password_Blank arrowDirection:JDFTooltipViewArrowDirectionUp width:passwordTxtFld.frame.size.width];
        [self.tooltipManager showNextTooltip] ;
        return ;
    }
    else{
        
        [self loginApi] ;
    }
}

#pragma mark - API Methods
-(void)loginApi {
   // if(![UtilityClass getDeviceToken]) return ;
    
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_LogIn] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:emailTxtFld.text forKey:kLogInAPI_Email] ;
        [dictParam setObject:passwordTxtFld.text forKey:kLogInAPI_Password] ;
        [dictParam setObject:@"" forKey:kLogInAPI_AccessToken] ; //[NSString stringWithFormat:@"%@",[UtilityClass getDeviceToken]]
        [dictParam setObject:@"" forKey:kLogInAPI_DeviceToken] ; // [NSString stringWithFormat:@"%@",[UtilityClass getDeviceToken]]
        [dictParam setObject:@"ios" forKey:kLogInAPI_DeviceType] ;
        
        [ApiCrowdBootstrap loginWithParameters:dictParam success:^(NSDictionary *responseDict) {
            //[UtilityClass hideHud] ;+
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                
                [UtilityClass hideHud] ;
                NSLog(@"Login Successful %lu",[QBSession currentSession].currentUser.ID) ;
                [UtilityClass setUserType:CONTRACTOR] ;
                [UtilityClass setLogInStatus:YES] ;
                
                [UtilityClass setLoggedInUserID:[[responseDict valueForKey:@"user_id"] intValue]] ;
                [UtilityClass setLoggedInUserQuickBloxID:[QBSession currentSession].currentUser.ID] ;
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[responseDict mutableCopy]] ;
                [dict setValue:[responseDict valueForKey:kLogInAPI_Quickblox_Password] forKey:kLogInAPI_Password] ;
                [UtilityClass setLoggedInUserDetails:[NSMutableDictionary dictionaryWithDictionary:dict]] ;
                [UtilityClass setNotificationSettings:@"true"] ;
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RevealView"] ;
                [AppDelegate appDelegate].window.rootViewController = viewController ;
                
                //[self.navigationController pushViewController:viewController animated:YES] ;
                [self presentViewController:viewController animated:YES completion:nil] ;
                
                
                /*
                QBUUser *qbUser = [QBUUser user]  ;
                qbUser.email = emailTxtFld.text ;
                qbUser.password = [responseDict valueForKey:kLogInAPI_Quickblox_Password] ;
                //qbUser.password = passwordTxtFld.text ;
                [UtilityClass showHudWithTitle:kHUDMessage_LogIn] ;
                [ServicesManager.instance logInWithUser:qbUser completion:^(BOOL success, NSString *errorMessage) {
                    if (success) {
                        //__typeof(self) strongSelf = weakSelf;
                        
                        [UtilityClass hideHud] ;
                        NSLog(@"Login Successfull %lu",[QBSession currentSession].currentUser.ID) ;
                        [UtilityClass setUserType:CONTRACTOR] ;
                        [UtilityClass setLogInStatus:YES] ;
                        
                        [UtilityClass setLoggedInUserID:[[responseDict valueForKey:@"user_id"] intValue]] ;
                        [UtilityClass setLoggedInUserQuickBloxID:[QBSession currentSession].currentUser.ID] ;
                        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[responseDict mutableCopy]] ;
                        [dict setValue:[responseDict valueForKey:kLogInAPI_Quickblox_Password] forKey:kLogInAPI_Password] ;
                        [UtilityClass setLoggedInUserDetails:[NSMutableDictionary dictionaryWithDictionary:dict]] ;
                        [UtilityClass setNotificationSettings:@"true"] ;
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RevealView"] ;
                        [AppDelegate appDelegate].window.rootViewController = viewController ;
                        
                        //[self.navigationController pushViewController:viewController animated:YES] ;
                        [self presentViewController:viewController animated:YES completion:nil] ;
                 
                    } else {
                        [UtilityClass hideHud] ;
                        [self presentViewController:[UtilityClass displayAlertMessage:@"error"] animated:YES completion:nil] ;
                    }
                }];
                 */
            
            }
            else{
                [UtilityClass hideHud] ;
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
            
            
        } failure:^(NSError *error) {
            NSLog(@"error %@", error.description);
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}


/*-(void)loginApi{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_LogIn] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:emailTxtFld.text forKey:kLogInAPI_Email] ;
        [dictParam setObject:passwordTxtFld.text forKey:kLogInAPI_Password] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[UtilityClass getDeviceToken]] forKey:kLogInAPI_AccessToken] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[UtilityClass getDeviceToken]] forKey:kLogInAPI_DeviceToken] ;
        [dictParam setObject:@"ios" forKey:kLogInAPI_DeviceType] ;
        
        [QBRequest logInWithUserEmail:emailTxtFld.text password:passwordTxtFld.text successBlock:^(QBResponse * _Nonnull response, QBUUser * _Nullable user) {
            
            NSLog(@"Login Successfull") ;
            [ApiCrowdBootstrap loginWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"responseDict %@", responseDict);
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                    
                    [UtilityClass setUserType:CONTRACTOR] ;
                    [UtilityClass setLogInStatus:YES] ;
                    
                    [UtilityClass setLoggedInUserID:[[responseDict valueForKey:@"user_id"] intValue]] ;
                    [UtilityClass setLoggedInUserDetails:[NSMutableDictionary dictionaryWithDictionary:responseDict]] ;
                    [UtilityClass setNotificationSettings:@"true"] ;
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RevealView"] ;
                    [AppDelegate appDelegate].window.rootViewController = viewController ;
                    
                    //[self.navigationController pushViewController:viewController animated:YES] ;
                    [self presentViewController:viewController animated:YES completion:nil] ;
                }
                else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                
                
            } failure:^(NSError *error) {
                NSLog(@"error %@", error.description);
                [UtilityClass displayAlertMessage:error.description] ;
                [UtilityClass hideHud] ;
            }] ;
            
        } errorBlock:^(QBResponse * _Nonnull response) {
            [UtilityClass displayAlertMessage:response.error.description] ;
            [UtilityClass hideHud] ;
        } ] ;
        
        
    }
}*/

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - IBAction Methods
- (IBAction)buttons_ClickAction:(id)sender {
   [emailTxtFld resignFirstResponder] ;
   [passwordTxtFld resignFirstResponder] ;
   // emailTxtFld.text = @"neelmani.karn@trantorinc.com" ;
   // passwordTxtFld.text = @"12345678" ;
   NSString *viewIdentifierName ;
    switch ([sender tag]) {
            
        case HOME_SELECTED:
            [self validateTextFields] ;
            return ;
            
        case SIGNUP_SELECTED:
            viewIdentifierName = kSignUpIdentifier ;
            break;
            
        case FORGOT_PASSWORD_SELECTED:
            viewIdentifierName = kForgotPasswordIdentifier ;
            break;
            
        default:
            break;
    }
    
    if(viewIdentifierName){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:viewIdentifierName] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField tag] == 1)[passwordTxtFld becomeFirstResponder] ;
    else [textField resignFirstResponder] ;
    if(textField == passwordTxtFld){
         [self validateTextFields] ;
    }
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
