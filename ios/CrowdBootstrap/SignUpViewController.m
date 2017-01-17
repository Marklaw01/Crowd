//
//  SignUpViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 06/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "SignUpViewController.h"
#import "TextFieldTableViewCell.h"
#import "ChooseSecurityQuesTableViewCell.h"
#import "EnterSecurityQuesTableViewCell.h"
#import "DobTableViewCell.h"
#import "PaymentsTableViewCell.h"
#import "PhoneTableViewCell.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <linkedin-sdk/LISDK.h>

static NSString * const kClientId = @"502919930015-7na0abn25duqcvgqn81e1ptuuo8s9jul.apps.googleusercontent.com";

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view, typically from a nib.
    
    [self resetUISettings] ;
    [self getSecurityQuestions] ;
    [self getCountriesList] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)singleTap:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
     [securityQuesView setHidden:YES] ;
  /*  if(selectedPickerViewType == kCountrySelected ){
        DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kCountryIndex]] ;
        [cell.textFld resignFirstResponder] ;
        cell.textFld.text = [[sectionsArray objectAtIndex:kCountryIndex] valueForKey:@"value"]  ;
    }
    else if(selectedPickerViewType == kCountrySelected ){
        DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kStateIndex]] ;
        [cell.textFld resignFirstResponder] ;
        cell.textFld.text = [[sectionsArray objectAtIndex:kStateIndex] valueForKey:@"value"]  ;
    }
    else if(selectedPickerViewType == kSecurityQuesSelected ){
        ChooseSecurityQuesTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedCellIndex inSection:kChooseSecurityQuesIndex]] ;
        [cell.securityQuesTxtFld resignFirstResponder] ;
        NSString *ques = [[chooseSecurityQuesArray objectAtIndex:selectedCellIndex] valueForKey:@"question"]  ;
        if(ques.length <1){
            cell.securityQuesTxtFld.placeholder = kSelectSecurityQuesDefaultText ;
            cell.securityQuesLbl.text = @"" ;
        }
        else {
            cell.securityQuesTxtFld.placeholder = @"" ;
            cell.securityQuesLbl.text = ques;
        }
    }*/
     selectedPickerViewType = -1 ;
}

-(void)viewDidDisappear:(BOOL)animated{
    [UtilityClass setStartupViewMode:ADD_STARTUP_TITLE] ;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil] ;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil] ;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - Custom Methods
-(void)resetUISettings {
   // sectionsArray = [[NSMutableArray alloc] initWithObjects:@"First Name",@"Last Name",@"User Name",@"Email",@"Date of Birth",@"Phone Number",@"City",@"Country",@"Best Availability",@"Password",@"Confirm Password",@"Choose Security Question",@"OR",@"Enter Security Question",@"Terms",@"Validation",@"Sign Up", nil] ;
    
    NSString *path               = [[NSBundle mainBundle] pathForResource:kSignupElementsPlist ofType:@"plist"];
    sectionsArray                = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    chooseSecurityQuesArray      = [NSMutableArray arrayWithArray:[[sectionsArray objectAtIndex:kChooseSecurityQuesIndex] objectForKey:@"value"]] ;
    enterSecurityQuesArray       = [NSMutableArray arrayWithArray:[[sectionsArray objectAtIndex:kEnterSecurityQuesIndex] objectForKey:@"value"]] ;
    
    tblView.tableFooterView      = [[UIView alloc] initWithFrame:CGRectZero];
    
    selectedSecurityQuesIndex    = -1 ;
    selectedCellIndex            = -1 ;
    prevDueDate                  = @"" ;
    phoneNumberStr               = @"" ;
    selectedCountryID            = @"" ;
    selectedStateID              = @"" ;
    isTermsSelected              = 0 ;
    blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet] ;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [tblView addGestureRecognizer:singleTapGestureRecognizer];
    
    [datePickerView setMaximumDate:[NSDate date]] ;
    [datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)resetTableViewCell {
    for (int i=0; i<enterSecurityQuesArray.count; i++) {
        EnterSecurityQuesTableViewCell *cell = (EnterSecurityQuesTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:kEnterSecurityQuesIndex]] ;
        if(enterSecurityQuesArray.count == 1){
            cell.plusBtn.hidden= NO ;
            cell.minusBtn.hidden= YES ;
        }
        else{
            if(i == enterSecurityQuesArray.count-1){
                cell.plusBtn.hidden = NO ;
                cell.minusBtn.hidden = YES ;
            }
            else{
                cell.plusBtn.hidden = YES ;
                cell.minusBtn.hidden = NO ;
            }
        }
    }
}
-(void)resetChooseSecurityQuesCell{
    for (int i=0; i<chooseSecurityQuesArray.count; i++) {
        ChooseSecurityQuesTableViewCell *cell = (ChooseSecurityQuesTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:kChooseSecurityQuesIndex]] ;
        if(chooseSecurityQuesArray.count == 1) {
            cell.plusBtn.hidden= NO ;
            cell.minusBtn.hidden= YES ;
        }
        else{
            if(i == chooseSecurityQuesArray.count-1) {
                cell.plusBtn.hidden = NO ;
                cell.minusBtn.hidden = YES ;
            }
            else{
                cell.plusBtn.hidden = YES ;
                cell.minusBtn.hidden = NO ;
            }
        }
    }
}

#pragma mark - Validation Methods
-(BOOL)validatetextFieldsWithSectionIndex:(int)section {
    
    NSString *value = [[sectionsArray objectAtIndex:section] valueForKey:@"value"] ;
    if(value.length < 1 ){
        [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"%@%@",[[sectionsArray objectAtIndex:section] valueForKey:@"item"],kAlert_SignUp_BlankField]] animated:YES completion:nil];
       // [[sectionsArray objectAtIndex:section] setValue:@"0" forKey:@"isValid"] ;
       // [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone] ;
       // [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES] ;
        
       // CGRect rect = (CGRect)[tblView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]] ;
        
        //validationPopupView.frame = CGRectMake(rect.origin.x,rect.size.height+rect.origin.y, rect.size.width, 30);
        
        /*[UIView transitionFromView:self.view
                            toView:validationPopupView
                          duration:2
                           options:animationTransitionType
                        completion:^(BOOL finished){
                            [view2 removeFromSuperview];
                        }];*/
        
      //  [self.view addSubview:validationPopupView] ;
        
        return NO ;
    }
    return YES ;
}

-(BOOL)validateEmail {
    
    NSString *value = [[sectionsArray objectAtIndex:kEmailIndex] valueForKey:@"value"] ;
    if([UtilityClass NSStringIsValidEmail:value])return YES ;
    else {
        
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_Valid_Email] animated:YES completion:nil];
        return NO ;
    }
}

-(BOOL)validatePassword {
    
    NSString *value = [[sectionsArray objectAtIndex:kPasswordIndex] valueForKey:@"value"] ;
    if([UtilityClass NSStringIsValidPassword:value])return YES ;
    else {
        
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_SignUp_PasswordNotValid] animated:YES completion:nil];
        return NO ;
    }
}

-(BOOL)validateSecurityQuestion {
    if(chooseSecurityQuesArray.count > 0) {
        NSString *question = [[chooseSecurityQuesArray objectAtIndex:0] valueForKey:@"question"] ;
        NSString *answer   = [[chooseSecurityQuesArray objectAtIndex:0] valueForKey:@"answer"] ;
        if(question.length < 1 || answer.length < 1) {
            
            [self presentViewController:[UtilityClass displayAlertMessage:kAlert_SignUp_SecurityQuestionNotSelected] animated:YES completion:nil];
            return NO ;
        }
        else return YES ;
    }
    else{
        
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_SignUp_SecurityQuestionNotSelected] animated:YES completion:nil];
        return NO ;
    }
}

-(BOOL)validatePasswordMatching {
    
    NSString *password = [[sectionsArray objectAtIndex:kPasswordIndex] valueForKey:@"value"] ;
    NSString *confirmPassword = [[sectionsArray objectAtIndex:kConfirmPasswordIndex] valueForKey:@"value"] ;
    if([password isEqualToString:confirmPassword]) return YES ;
    else {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_SignUp_PasswordNotMatching] animated:YES completion:nil];
        return NO ;
    }
}

-(NSMutableArray*)setSecurityQuestionDictParamForApiWithArray:(NSMutableArray*)array withType:(BOOL)isChooseSecurityQues {
    NSMutableArray *paramArray = [[NSMutableArray alloc] init] ;
    for (NSDictionary *obj in array) {
        NSString *question = [obj valueForKey:@"question"] ;
        NSString *answer   = [obj valueForKey:@"answer"] ;
        if(question.length > 1 && answer.length > 1 ) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
            if(isChooseSecurityQues)[dict setValue:[obj valueForKey:@"id"] forKey:@"id"] ;
            else [dict setValue:[obj valueForKey:@"question"] forKey:@"id"] ;
            [dict setValue:answer forKey:@"answer"] ;
            [paramArray addObject:dict] ;
        }
    }
    return paramArray ;
}

#pragma mark - API Methods
-(void)getCountriesList {
    if([UtilityClass checkInternetConnection])  {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [ApiCrowdBootstrap getCountries:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                countryArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:@"country"]] ;
                for (int i=0; i<countryArray.count; i++) {
                    
                    if([[[countryArray objectAtIndex:i] valueForKey:@"id"] intValue] == US_COUNTRY_ID) {
                        DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kCountryIndex]] ;
                        cell.textFld.text = [[countryArray objectAtIndex:i] valueForKey:@"name"] ;
                        selectedCountryID = [[countryArray objectAtIndex:i] valueForKey:@"id"] ;
                        
                        [[sectionsArray objectAtIndex:kCountryIndex] setValue:[[countryArray objectAtIndex:i] valueForKey:@"name"] forKey:@"value"] ;
                        [[sectionsArray objectAtIndex:kCountryIndex] setValue:[[countryArray objectAtIndex:i] valueForKey:@"id"] forKey:@"id"] ;
                    }
                }
            }
            else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
            
        }] ;
    }
}

-(void)getStatesListWithCountryID:(int)countryID {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",countryID] forKey:kCitiesAPI_CountryID] ;
        
        [ApiCrowdBootstrap getCitiesWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                statesArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:@"state"]] ;
                [pickerView reloadAllComponents] ;
            }
            else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getSecurityQuestions {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [ApiCrowdBootstrap getSecurityuestions:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
               // NSLog(@"responseDict: %@",responseDict) ;
                securityQuestionsArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:@"question"]] ;
            }
            else {
                
                if([responseDict objectForKey:@"errors"]) {
                    NSString *errorMessage = @"" ;
                    NSArray *errorsArray = [responseDict objectForKey:@"errors"] ;
                    for (int i=0; i<errorsArray.count; i++) {
                        errorMessage = [NSString stringWithFormat:@"%@\n%@",errorMessage,[[errorsArray objectAtIndex:i] allKeys]] ;
                    }
                    
                    NSLog(@"errorMessage: %@",errorMessage) ;
                }
                //[self presentViewController:[UtilityClass displayAlertMessage:errorMessage] animated:YES completion:nil];
                //[self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
            
        }] ;
    }
}


-(void)registerUser{
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    [dictParam setObject:[[sectionsArray objectAtIndex:kFirstNameIndex] valueForKey:@"value"] forKey:kSignUpAPI_FirstName] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kLastNameIndex] valueForKey:@"value"] forKey:kSignUpAPI_LastName] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kUsernameIndex] valueForKey:@"value"] forKey:kSignUpAPI_Username] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kEmailIndex] valueForKey:@"value"] forKey:kSignUpAPI_Email] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kDobIndex] valueForKey:@"value"] forKey:kSignUpAPI_DateOfBirth] ;
    NSString *phone = phoneNumberStr ;
    if(phone.length > 0 && ![phone isEqualToString:@""] && ![phone isEqualToString:@" "] && (phone.length < PHONE_MIN_LENGTH || phone.length > PHONE_MAX_LENGTH )){
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_SignUp_PhoneNotValid] animated:YES completion:nil] ;
        return ;
    }
    else [dictParam setObject:phone forKey:kSignUpAPI_Phone] ;
    
    // [dictParam setObject:[[sectionsArray objectAtIndex:kCountryIndex] valueForKey:@"value"] forKey:kSignUpAPI_Country] ;
    //  [dictParam setObject:[[sectionsArray objectAtIndex:kStateIndex] valueForKey:@"value"] forKey:kSignUpAPI_State] ;
    [dictParam setObject:selectedCountryID forKey:kSignUpAPI_Country] ;
    [dictParam setObject:selectedStateID forKey:kSignUpAPI_State] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kCityIndex] valueForKey:@"value"] forKey:kSignUpAPI_City] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kBestAvailabilityIndex] valueForKey:@"value"] forKey:kSignUpAPI_BestAvailability] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kPasswordIndex] valueForKey:@"value"] forKey:kSignUpAPI_Password] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kConfirmPasswordIndex] valueForKey:@"value"] forKey:kSignUpAPI_ConfirmPassword] ;
    [dictParam setObject:[self setSecurityQuestionDictParamForApiWithArray:chooseSecurityQuesArray withType:YES] forKey:kSignUpAPI_ChooseSeurityQues] ;
    [dictParam setObject:[self setSecurityQuestionDictParamForApiWithArray:enterSecurityQuesArray withType:NO] forKey:kSignUpAPI_EnterSecurityQues] ;
    [dictParam setObject:[self setSecurityQuestionDictParamForApiWithArray:enterSecurityQuesArray withType:NO] forKey:kSignUpAPI_EnterSecurityQues] ;
    [dictParam setObject:[NSString stringWithFormat:@"%d",isTermsSelected] forKey:kSignUpAPI_Terms] ;
    
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_SignUp] ;
        
        [ApiCrowdBootstrap registerUserWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"Api responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                
                //[UtilityClass showNotificationMessgae:@"User Added Successfully." withResultType:@"1" withDuration:1] ;
                [UtilityClass showNotificationMessgae:kAlert_SignUpConfirmation withResultType:@"1" withDuration:1.5] ;
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kLoginIdentifier] ;
                [self.navigationController pushViewController:viewController animated:YES] ;
            }
            else {
                [UtilityClass hideHud] ;
                // [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                if([responseDict objectForKey:@"errors"]){
                    NSDictionary *errorsData = (NSDictionary*)[responseDict objectForKey:@"errors"] ;
                    NSString *errorStr = @"" ;
                    for (NSString *value in [errorsData allValues]) {
                        errorStr = [NSString stringWithFormat:@"%@\n%@",errorStr,value] ;
                    }
                    if(![errorStr isEqualToString:@""])[self presentViewController:[UtilityClass displayAlertMessage:errorStr] animated:YES completion:nil];
                }
            }
            
        } failure:^(NSError *error) {
           
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

/*  With Quickblox Sign up
 
 -(void)registerUser{
 
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    [dictParam setObject:[[sectionsArray objectAtIndex:kFirstNameIndex] valueForKey:@"value"] forKey:kSignUpAPI_FirstName] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kLastNameIndex] valueForKey:@"value"] forKey:kSignUpAPI_LastName] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kUsernameIndex] valueForKey:@"value"] forKey:kSignUpAPI_Username] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kEmailIndex] valueForKey:@"value"] forKey:kSignUpAPI_Email] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kDobIndex] valueForKey:@"value"] forKey:kSignUpAPI_DateOfBirth] ;
    NSString *phone = phoneNumberStr ;
    if(phone.length > 0 && ![phone isEqualToString:@""] && ![phone isEqualToString:@" "] && (phone.length < PHONE_MIN_LENGTH || phone.length > PHONE_MAX_LENGTH )){
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_SignUp_PhoneNotValid] animated:YES completion:nil] ;
        return ;
    }
    else [dictParam setObject:phone forKey:kSignUpAPI_Phone] ;
    
   // [dictParam setObject:[[sectionsArray objectAtIndex:kCountryIndex] valueForKey:@"value"] forKey:kSignUpAPI_Country] ;
  //  [dictParam setObject:[[sectionsArray objectAtIndex:kStateIndex] valueForKey:@"value"] forKey:kSignUpAPI_State] ;
    [dictParam setObject:selectedCountryID forKey:kSignUpAPI_Country] ;
    [dictParam setObject:selectedStateID forKey:kSignUpAPI_State] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kCityIndex] valueForKey:@"value"] forKey:kSignUpAPI_City] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kBestAvailabilityIndex] valueForKey:@"value"] forKey:kSignUpAPI_BestAvailability] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kPasswordIndex] valueForKey:@"value"] forKey:kSignUpAPI_Password] ;
    [dictParam setObject:[[sectionsArray objectAtIndex:kConfirmPasswordIndex] valueForKey:@"value"] forKey:kSignUpAPI_ConfirmPassword] ;
    [dictParam setObject:[self setSecurityQuestionDictParamForApiWithArray:chooseSecurityQuesArray withType:YES] forKey:kSignUpAPI_ChooseSeurityQues] ;
    [dictParam setObject:[self setSecurityQuestionDictParamForApiWithArray:enterSecurityQuesArray withType:NO] forKey:kSignUpAPI_EnterSecurityQues] ;
    [dictParam setObject:[self setSecurityQuestionDictParamForApiWithArray:enterSecurityQuesArray withType:NO] forKey:kSignUpAPI_EnterSecurityQues] ;
    
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_SignUp] ;
        
        QBUUser *qbUser = [QBUUser user];
        qbUser.password = [NSString stringWithFormat:@"%@",[dictParam objectForKey:kSignUpAPI_Password]];
        qbUser.email = [NSString stringWithFormat:@"%@",[dictParam objectForKey:kSignUpAPI_Email]];
        qbUser.login = [NSString stringWithFormat:@"%@",[dictParam objectForKey:kSignUpAPI_Username]] ;
        qbUser.fullName = [NSString stringWithFormat:@"%@ %@",[dictParam objectForKey:kSignUpAPI_FirstName],[dictParam objectForKey:kSignUpAPI_LastName]] ;
        NSLog(@"qbUser: %@",qbUser) ;
        
        
        [QBRequest signUp:qbUser successBlock:^(QBResponse *response, QBUUser *user)    {
            
            NSLog(@"Response Sucesss>>> = %@", response );
            [dictParam setObject:[NSString stringWithFormat:@"%lu",(unsigned long)user.ID] forKey:kSignUpAPI_QuickBloxID] ;
            // NSLog(@"params: %@",dictParam) ;
            [ApiCrowdBootstrap registerUserWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"Api responseDict: %@",responseDict) ;
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                    
                    //[UtilityClass showNotificationMessgae:@"User Added Successfully." withResultType:@"1" withDuration:1] ;
                    [UtilityClass showNotificationMessgae:kAlert_SignUpConfirmation withResultType:@"1" withDuration:1.5] ;
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kLoginIdentifier] ;
                    [self.navigationController pushViewController:viewController animated:YES] ;
                    
                }
                else{
                     ServicesManager *servicesManager = [ServicesManager instance];
                    
                    QBUUser *qbUser = [QBUUser user];
                    qbUser.password = [NSString stringWithFormat:@"%@",[dictParam objectForKey:kSignUpAPI_Password]];
                    qbUser.email = [NSString stringWithFormat:@"%@",[dictParam objectForKey:kSignUpAPI_Email]];
                    
                    [ServicesManager.instance logInWithUser:qbUser completion:^(BOOL success, NSString * _Nullable errorMessage) {
                        NSLog(@"userL %@ currentUser: %@",user ,servicesManager.currentUser) ;
                        if (servicesManager.currentUser != nil){
                        }
                        [QBRequest deleteCurrentUserWithSuccessBlock:^(QBResponse * _Nonnull response) {
                            NSLog(@"delete respone >> %@",response.error.reasons) ;
                        } errorBlock:^(QBResponse * _Nonnull response) {
                            NSLog(@"delete error >> %@",response.error.reasons) ;
                        }] ;
                    }] ;

                    [UtilityClass hideHud] ;
                    // [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                    if([responseDict objectForKey:@"errors"]){
                        NSDictionary *errorsData = (NSDictionary*)[responseDict objectForKey:@"errors"] ;
                        NSString *errorStr = @"" ;
                        for (NSString *value in [errorsData allValues]) {
                            errorStr = [NSString stringWithFormat:@"%@\n%@",errorStr,value] ;
                        }
                        if(![errorStr isEqualToString:@""])[self presentViewController:[UtilityClass displayAlertMessage:errorStr] animated:YES completion:nil];
                    }
                }
                
            } failure:^(NSError *error) {
                //[QBUUser deleteUserWithID:48456 delegate:self];
                 ServicesManager *servicesManager = [ServicesManager instance];
                QBUUser *qbUser = [QBUUser user];
                qbUser.password = [NSString stringWithFormat:@"%@",[dictParam objectForKey:kSignUpAPI_Password]];
                qbUser.email = [NSString stringWithFormat:@"%@",[dictParam objectForKey:kSignUpAPI_Email]];
                
                [ServicesManager.instance logInWithUser:qbUser completion:^(BOOL success, NSString * _Nullable errorMessage) {
                    NSLog(@"userL %@ currentUser: %@",user ,servicesManager.currentUser) ;
                    if (servicesManager.currentUser != nil){
                        
                    }
                    [QBRequest deleteCurrentUserWithSuccessBlock:^(QBResponse * _Nonnull response) {
                        NSLog(@"delete respone >> %@",response) ;
                    } errorBlock:^(QBResponse * _Nonnull response) {
                        NSLog(@"delete error >> %@",response) ;
                    }] ;
                }] ;
                
                [UtilityClass displayAlertMessage:error.description] ;
                [UtilityClass hideHud] ;
            }] ;
            
        } errorBlock:^(QBResponse *response) {
            [UtilityClass hideHud] ;
            NSLog(@"response: %@",response.error.reasons) ;
            NSDictionary *errorsDict = (NSDictionary*) response.error.reasons ;
            if(errorsDict){
                NSString *errorStr = @"" ;
                for (NSString *value in [errorsDict allValues]) {
                    
                    errorStr = [NSString stringWithFormat:@"%@\n%@",errorStr,value] ;
                    if ([errorStr rangeOfString:kValidationAlreadyTaken].location != NSNotFound) {
                        [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"Email %@.",kValidationAlreadyTaken]] animated:YES completion:nil];
                    }
                }
                if(![errorStr isEqualToString:@""])[self presentViewController:[UtilityClass displayAlertMessage:errorStr] animated:YES completion:nil];
            }
            else{
                [UtilityClass displayAlertMessage:response.error.error.description] ;
                [UtilityClass hideHud] ;
            }
        }];
    }
}*/

#pragma mark - IBAction Methods
- (IBAction)Cancel_ClickAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kLoginIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)SignUp_ClickAction:(id)sender {
     NSLog(@"phoneNumberStr: %@",phoneNumberStr) ;
   /* UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kLoginIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;*/
    
    // initialize tool tip
   // [self resetUISettings] ;
    
    /*if(self.tooltipManager)self.tooltipManager = nil ;
    self.tooltipManager = [[JDFSequentialTooltipManager alloc] initWithHostView:self.view];
    self.tooltipManager.showsBackdropView = YES;
    [self.tooltipManager setBackdropTapActionEnabled:YES] ;
    [self.tooltipManager setShadowColourForAllTooltips:[UIColor redColor]] ;*/
    
    // Mandatory Fields
    if (![self validatetextFieldsWithSectionIndex:kFirstNameIndex])            return ;
    else if (![self validatetextFieldsWithSectionIndex:kLastNameIndex])        return ;
    else if (![self validatetextFieldsWithSectionIndex:kUsernameIndex])        return ;
    else if (![self validatetextFieldsWithSectionIndex:kEmailIndex])           return ;
    else if (![self validateEmail])                                            return ;
    else if (![self validatetextFieldsWithSectionIndex:kPasswordIndex])        return ;
    else if (![self validatePassword])                                         return ;
    else if (![self validatetextFieldsWithSectionIndex:kConfirmPasswordIndex]) return ;
    else if (![self validatePasswordMatching])                                 return ;
    else if (![self validateSecurityQuestion])                                 return ;
    else if (isTermsSelected == 0) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_Agreement] animated:YES completion:nil] ;
        return ;
    }
    else [self registerUser] ;
}

#pragma mark - TableView Buttons IBAction
- (IBAction)openPickerView_ClickAction:(id)sender {
     [securityQuesView setHidden:NO] ;
    
    ChooseSecurityQuesTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:kChooseSecurityQuesIndex]] ;
    [cell.securityQuesTxtFld becomeFirstResponder] ;
    selectedCellIndex = (int)[sender tag];
    selectedPickerViewType = kSecurityQuesSelected ;
    [pickerView reloadAllComponents] ;
}

- (IBAction)Dropdown_ClickAction:(id)sender {
    [securityQuesView setHidden:NO] ;
    
    if([sender tag] == kCountryIndex) {
        selectedPickerViewType = kCountrySelected ;
        DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kCountryIndex]] ;
        [cell.textFld becomeFirstResponder] ;
       
        /*NSString *countryID = [NSString stringWithFormat:@"%@",[[countryArray objectAtIndex:selectedCountryIndex] valueForKey:@"id"]] ;
        int index = [UtilityClass getPickerViewSelectedIndexFromArray:countryArray forID:countryID] ;
        if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
        else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;*/
    }
    else {
        
        if([[NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:kCountryIndex] valueForKey:@"id"]] isEqualToString:@""]) {
            [self presentViewController:[UtilityClass displayAlertMessage:kSelectCountryDefaultText] animated:YES completion:nil] ;
        }
        else{
            selectedPickerViewType = kStateSelected ;
            [self getStatesListWithCountryID:[[[sectionsArray objectAtIndex:kCountryIndex] valueForKey:@"id"] intValue]] ;
            
            DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kStateIndex]] ;
            [cell.textFld becomeFirstResponder] ;
            
          /*  NSString *cityID = [NSString stringWithFormat:@"%@",[[cityArray objectAtIndex:selectedCityIndex] valueForKey:@"id"]] ;
            int index = [UtilityClass getPickerViewSelectedIndexFromArray:cityArray forID:cityID] ;
            if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
            else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;*/
        }
    }
     [pickerView reloadAllComponents] ;
}

- (IBAction)TAndC_ClickAction:(id)sender {
    
    // Clear Cache of WebView
    [webViewPopup loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    // Set Title
    lblTitle.text = @"Terms and Conditions";
    
    // Set description on Webview
    NSURL *url = [NSURL URLWithString:TERMS_CONDITIONS_LINK];
    [webViewPopup loadRequest:[NSURLRequest requestWithURL:url]];
    
    vwPopup.hidden = false;
}

- (IBAction)PrivacyPolicy_ClickAction:(id)sender {
    // Clear Cache of WebView
    [webViewPopup loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    // Set Title
    lblTitle.text = @"Privacy Policy";

    // Set description on Webview
    NSURL *url = [NSURL URLWithString:PRIVACY_POLICY_LINK];
    [webViewPopup loadRequest:[NSURLRequest requestWithURL:url]];
    
    vwPopup.hidden = false;
}

// Hide Pop-Up
- (IBAction)closePopup_ClickAction:(id)sender {
    vwPopup.hidden = true;
}

- (IBAction)Agree_ClickAction:(id)sender {
    UIButton *agreeBtn = (UIButton*)sender ;
    if(isTermsSelected == 1){ // Check
        [agreeBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        agreeBtn.accessibilityLabel = UNCHECK_IMAGE ;
        isTermsSelected = 0 ;
    }
    else{
        [agreeBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        agreeBtn.accessibilityLabel = CHECK_IMAGE ;
         isTermsSelected = 1 ;
    }
}

- (IBAction)Calender_ClickAction:(id)sender {
    
    DobTableViewCell *cell ;
    if([sender tag] == kDobIndex) {
        
        cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kDobIndex]] ;
        selectedDatePickerType = kDobSelected ;
        datePickerView.datePickerMode = UIDatePickerModeDate ;
    }
    else{
        
        cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kBestAvailabilityIndex]] ;
        selectedDatePickerType = kBestAvailabilitySelected ;
        datePickerView.datePickerMode = UIDatePickerModeTime ;
    }
    [cell.textFld becomeFirstResponder] ;
}

#pragma mark - Social Sharing Action Methods
- (IBAction)facebookShare_ClickAction:(id)sender {
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"http://crowdbootstrap.com"];
    FBSDKShareLinkContent *sharecontent = [[FBSDKShareLinkContent alloc] init];
    sharecontent.contentURL = [NSURL URLWithString:@"http://crowdbootstrap.com"];
    [FBSDKShareDialog showFromViewController:self
                                 withContent:sharecontent
                                    delegate:nil];
}

- (IBAction)googleShare_ClickAction:(id)sender {
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.scopes = @[@"https://www.googleapis.com/auth/plus.login"];
    signIn.delegate = self;
    signIn.clientID = kClientId;
    [signIn trySilentAuthentication];
    
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
    
    // This line will fill out the title, description, and thumbnail from
    // the URL that you are sharing and includes a link to that URL.
    [shareBuilder setURLToShare:[NSURL URLWithString:@"http://crowdbootstrap.com"]];
    
    [shareBuilder open];
}

- (IBAction)linkedInShare_ClickAction:(id)sender {
    
    NSArray *permissions = [NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_W_SHARE_PERMISSION, nil];
    [LISDKSessionManager createSessionWithAuth:permissions state:nil showGoToAppStoreDialog:YES successBlock:^(NSString *returnState)
     {
         NSLog(@"%s","success called!");
         LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
         NSLog(@"Session : %@", session.description);
         // Post to Linked In
         [self postToLinkedIn];

     } errorBlock:^(NSError *error)
     {
         NSLog(@"%s","error called!");
     }];
    
}

- (void)postToLinkedIn {
    NSString *url = @"https://api.linkedin.com/v1/people/~/shares";
    //    NSString *payload = [NSString initWithString:@"
    //                         {
    //                         \"comment\":\"Check out developer.linkedin.com! http://linkd.in/1FC2PyG\",
    //                         \"visibility\":{ \"code\":\"anyone\" }
    //                         }"];
    //
    NSString *strShareContent = [NSString stringWithFormat:@"{\n\"comment\":\"http://crowdbootstrap.com\", \n\"visibility\": {\n\"code\": \"anyone\"\n}\n}"];
    NSLog(@"%@",strShareContent);

//    NSString *strShareContent = @"{\"visibility\":[{\"code\":\"anyone\"}],\"comment\":\"Check out developer.linkedin.com! http://linkd.in/1FC2PyG\"}";
    
//    NSDictionary * visibilityDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"anyone", nil] forKeys:[NSArray arrayWithObjects:@"code", nil]];
//
//    NSDictionary * postDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"http://crowdbootstrap.com", visibilityDict, @"Crowd Bootstrap Invitation", @"Crowd Bootstrap helps entrepreneurs accelerate their journey from a startup idea to initial revenues. It is a free App that enables you to benefit as an entrepreneur or help as an expert.Please click the following link to sign-up and help an entrepreneur realize their dream.", nil] forKeys:[NSArray arrayWithObjects:@"comment", @"visibility", @"title", @"description", nil]];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *resultAsString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//   
//    NSLog(@"jsonData as string:\n%@", resultAsString);
    
    if ([LISDKSessionManager hasValidSession]) {
        [[LISDKAPIHelper sharedInstance] postRequest:url stringBody:strShareContent
                                             success:^(LISDKAPIResponse *response) {
                                                 // do something with response
                                                 NSData* data = [response.data dataUsingEncoding:NSUTF8StringEncoding];
                                                 NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                 NSLog(@"LinkedIn Response : %@", dictResponse);
                                             }
                                               error:^(LISDKAPIError *apiError) {
                                                   // do something with error
                                                   NSLog(@"Error  : %@", apiError.description);
                                               }];
    }
}

#pragma mark - Plus/Minus Cell Button Methods
- (IBAction)PlusButton_ClickAction:(UIButton*)button {
    
    [tblView beginUpdates] ;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"" forKey:@"id"] ;
    [dict setValue:@"" forKey:@"question"] ;
    [dict setValue:@"" forKey:@"answer"] ;
    [chooseSecurityQuesArray addObject:dict] ;
    [tblView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:chooseSecurityQuesArray.count-1 inSection:kChooseSecurityQuesIndex]]withRowAnimation:UITableViewRowAnimationAutomatic];
    [tblView endUpdates] ;
    
    [self performSelector:@selector(resetChooseSecurityQuesCell) withObject:nil afterDelay:0.2] ;
}

- (IBAction)MinusButton_ClickAction:(UIButton*)button {
    
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:[button tag] inSection:kChooseSecurityQuesIndex];
    [tblView beginUpdates] ;
    if([chooseSecurityQuesArray objectAtIndex:cellIndexPath.row]) {
        [chooseSecurityQuesArray removeObjectAtIndex:cellIndexPath.row];
        [tblView deleteRowsAtIndexPaths:@[cellIndexPath]
                       withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [tblView endUpdates] ;
    
    [self performSelector:@selector(resetChooseSecurityQuesCell) withObject:nil afterDelay:0.2] ;
}

- (IBAction)EnterSecurity_PlusButton_Click:(UIButton*)button {
    
    [tblView beginUpdates] ;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"" forKey:@"question"] ;
    [dict setValue:@"" forKey:@"answer"] ;
    [enterSecurityQuesArray addObject:dict] ;
    [tblView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:enterSecurityQuesArray.count-1 inSection:kEnterSecurityQuesIndex]]withRowAnimation:UITableViewRowAnimationAutomatic];
    [tblView endUpdates] ;
    
    [self performSelector:@selector(resetTableViewCell) withObject:nil afterDelay:0.2] ;
}

- (IBAction)EnterSecurity_MinusButton_Click:(UIButton*)button {
    
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:[button tag] inSection:kEnterSecurityQuesIndex];
    [tblView beginUpdates] ;
    if([enterSecurityQuesArray objectAtIndex:cellIndexPath.row]){
        [enterSecurityQuesArray removeObjectAtIndex:cellIndexPath.row];
        [tblView deleteRowsAtIndexPaths:@[cellIndexPath]
                       withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [tblView endUpdates] ;
    
    [self performSelector:@selector(resetTableViewCell) withObject:nil afterDelay:0.2] ;
}

#pragma mark - ToolBar Buttons Methods
- (IBAction)phoneToolbarButtons_ClickAction:(id)sender {
    PhoneTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kPhoneIndex]] ;
    [cell.textField resignFirstResponder] ;
    if([sender tag] == DONE_CLICKED) [[sectionsArray objectAtIndex:kPhoneIndex] setValue:cell.textField.text forKey:@"value"] ;
}

- (IBAction)toolbarButtons_ClickAction:(id)sender {
    [securityQuesView setHidden:YES] ;
    
    if([sender tag] == DONE_CLICKED) {
        if(selectedPickerViewType == kCountrySelected || selectedPickerViewType == kStateSelected) {
            
            if(selectedPickerViewType == kCountrySelected) {
                DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kCountryIndex]] ;
                [cell.textFld resignFirstResponder] ;
                if([pickerView selectedRowInComponent:0] == 0) {
                    cell.textFld.text = @"" ;
                    selectedCountryID = @"" ;
                    
                    [[sectionsArray objectAtIndex:kCountryIndex] setValue:@"" forKey:@"value"] ;
                    [[sectionsArray objectAtIndex:kCountryIndex] setValue:@"" forKey:@"id"] ;
                }
                else{
                    cell.textFld.text = [[countryArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] ;
                    selectedCountryID  = [[countryArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"id"] ;
                    
                    [[sectionsArray objectAtIndex:kCountryIndex] setValue:[[countryArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] forKey:@"value"] ;
                    [[sectionsArray objectAtIndex:kCountryIndex] setValue:[[countryArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"id"] forKey:@"id"] ;
                }
                
                DobTableViewCell *cityCell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kStateIndex]] ;
                cityCell.textFld.text = @"" ;
                selectedStateID = @"" ;
                
                [[sectionsArray objectAtIndex:kStateIndex] setValue:@"" forKey:@"value"] ;
                [[sectionsArray objectAtIndex:kStateIndex] setValue:@"" forKey:@"id"] ;
            }
            else {
                DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kStateIndex]] ;
                [cell.textFld resignFirstResponder] ;
                if([pickerView selectedRowInComponent:0] == 0) {
                    cell.textFld.text = @"" ;
                    selectedStateID = @"" ;
                    
                    [[sectionsArray objectAtIndex:kStateIndex] setValue:@"" forKey:@"value"] ;
                    [[sectionsArray objectAtIndex:kStateIndex] setValue:@"" forKey:@"id"] ;
                }
                else {
                    cell.textFld.text = [[statesArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] ;
                    selectedStateID =  [[statesArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"id"]  ;
                    
                    [[sectionsArray objectAtIndex:kStateIndex] setValue:[[statesArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] forKey:@"value"] ;
                    [[sectionsArray objectAtIndex:kStateIndex] setValue:[[statesArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"id"] forKey:@"id"] ;
                }
            }
        }
        else{
            ChooseSecurityQuesTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedCellIndex inSection:kChooseSecurityQuesIndex]] ;
            [cell.securityQuesTxtFld resignFirstResponder] ;
            if([pickerView selectedRowInComponent:0] == 0) {
                cell.securityQuesTxtFld.text = @"" ;
                selectedSecurityQuesIndex = -1 ;
                cell.securityQuesLbl.text = @"" ;
                
                [[chooseSecurityQuesArray objectAtIndex:selectedCellIndex] setValue:@"" forKey:@"question"] ;
                [[chooseSecurityQuesArray objectAtIndex:selectedCellIndex] setValue:@"" forKey:@"id"] ;
            }
            else {
                cell.securityQuesTxtFld.text = @"" ;
                cell.securityQuesLbl.text = [[securityQuestionsArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] ;
                selectedSecurityQuesIndex = (int)[pickerView selectedRowInComponent:0] ;
                
                [[chooseSecurityQuesArray objectAtIndex:selectedCellIndex] setValue:[[securityQuestionsArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] forKey:@"question"] ;
                [[chooseSecurityQuesArray objectAtIndex:selectedCellIndex] setValue:[[securityQuestionsArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"id"] forKey:@"id"] ;
            }
        }
    }
    else {
        if(selectedPickerViewType == kCountrySelected || selectedPickerViewType == kStateSelected) {
            if(selectedPickerViewType == kCountrySelected) {
                DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kCountryIndex]] ;
                [cell.textFld resignFirstResponder] ;
                if([pickerView selectedRowInComponent:0] == 0)cell.textFld.text = @"" ;
                else cell.textFld.text = [[sectionsArray objectAtIndex:kCountryIndex] valueForKey:@"value"]  ;
            }
            else {
                DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedCellIndex inSection:kStateIndex]] ;
                [cell.textFld resignFirstResponder] ;
                if([pickerView selectedRowInComponent:0] == 0)cell.textFld.text = @"" ;
                else cell.textFld.text = [[sectionsArray objectAtIndex:kStateIndex] valueForKey:@"value"]  ;
            }
        }
        else {
            ChooseSecurityQuesTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedCellIndex inSection:kChooseSecurityQuesIndex]] ;
            [cell.securityQuesTxtFld resignFirstResponder] ;
            if([pickerView selectedRowInComponent:0] == 0){
                cell.securityQuesTxtFld.text = @"" ;
                cell.securityQuesLbl.text = @"" ;
            }
            else {
                cell.securityQuesTxtFld.text = @"" ;
                cell.securityQuesLbl.text = [[chooseSecurityQuesArray objectAtIndex:selectedCellIndex] valueForKey:@"question"]  ;
            }
        }
    }
    selectedPickerViewType = -1 ;
    [pickerView reloadAllComponents] ;
}

- (IBAction)DatePickerToolbarButtons_ClickAction:(id)sender {
    
    if([sender tag] == DONE_CLICKED) {
        if(selectedDatePickerType == kDobSelected) {
            DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kDobIndex]] ;
            [cell.textFld resignFirstResponder] ;
            
            prevDueDate = [[sectionsArray objectAtIndex:kDobIndex] valueForKey:@"value"] ;
            [[sectionsArray objectAtIndex:kDobIndex] setValue:cell.textFld.text forKey:@"value"] ;
            [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:kDobIndex]] withRowAnimation:UITableViewRowAnimationNone] ;
        }
        else {
            DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kBestAvailabilityIndex]] ;
            [cell.textFld resignFirstResponder] ;
            
            prevDueDate = [[sectionsArray objectAtIndex:kBestAvailabilityIndex] valueForKey:@"value"] ;
            [[sectionsArray objectAtIndex:kBestAvailabilityIndex] setValue:cell.textFld.text forKey:@"value"] ;
            [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:kBestAvailabilityIndex]] withRowAnimation:UITableViewRowAnimationNone] ;
        }
    }
    else {
        if(selectedDatePickerType == kDobSelected) {
            DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kDobIndex]] ;
            [cell.textFld resignFirstResponder] ;
            
            cell.textFld.text = [[sectionsArray objectAtIndex:kDobIndex] valueForKey:@"value"] ;
            [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:kDobIndex]] withRowAnimation:UITableViewRowAnimationNone] ;
        }
        else {
            DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kBestAvailabilityIndex]] ;
            [cell.textFld resignFirstResponder] ;
            
            cell.textFld.text = [[sectionsArray objectAtIndex:kBestAvailabilityIndex] valueForKey:@"value"] ;
            [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:kBestAvailabilityIndex]] withRowAnimation:UITableViewRowAnimationNone] ;
        }
    }
}

#pragma mark - DatePicker Value Changed
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(selectedDatePickerType == kDobSelected)[dateFormatter setDateFormat:@"MMM dd, yyyy"];
    else [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    DobTableViewCell *cell ;
    if(selectedDatePickerType == kDobSelected) cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kDobIndex]] ;
    
    else cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kBestAvailabilityIndex]] ;
    cell.textFld.text = strDate;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == kChooseSecurityQuesIndex)
        return chooseSecurityQuesArray.count ;
    else if(section == kEnterSecurityQuesIndex)
        return enterSecurityQuesArray.count ;
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == kPhoneIndex) {
        PhoneTableViewCell *cell = (PhoneTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kPhoneCellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        [UtilityClass setTextFieldBorder:cell.textField] ;
        [UtilityClass addMarginsOnTextField:cell.textField] ;
        
        cell.textField.keyboardType = UIKeyboardTypeNumberPad ;
        cell.textField.inputAccessoryView = phoneToolBar ;
        cell.textField.tag = indexPath.section ;
        [cell.textField.formatter setDefaultOutputPattern:@"1 (###) ###-####"];
        cell.textField.delegate = self ;
        if(phoneNumberStr)cell.textField.text = phoneNumberStr ;
        
        return cell ;
    }
    else if(indexPath.section == kChooseSecurityQuesIndex) {
        ChooseSecurityQuesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChooseSecurityQuesCellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        //cell.securityQuesTxtFld.inputView = securityQuesView ;
        cell.securityQuesTxtFld.tag = indexPath.section ;
        cell.answerTxtFld.tag = indexPath.section ;
        cell.securityQuesLbl.tag = indexPath.section ;
        cell.securityQuesTxtFld.userInteractionEnabled = NO ;
        [UtilityClass setTextFieldBorder:cell.securityQuesTxtFld] ;
        [UtilityClass setTextFieldBorder:cell.answerTxtFld] ;
        
        [UtilityClass addMarginsOnTextField:cell.securityQuesTxtFld] ;
        [UtilityClass addMarginsOnTextField:cell.answerTxtFld] ;
        
        cell.plusBtn.tag = indexPath.row ;
        cell.minusBtn.tag = indexPath.row ;
        cell.dropdownBtn.tag = indexPath.row ;
        
        cell.securityQuesTxtFld.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row] ;
        cell.answerTxtFld.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row] ;
        
        cell.securityQuesTxtFld.placeholder = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"item"] ;
        cell.answerTxtFld.placeholder = @"Answer" ;
        
        NSString *question = [[chooseSecurityQuesArray objectAtIndex:indexPath.row] valueForKey:@"question"] ;
        if(question.length < 1 ) {
            cell.securityQuesLbl.text = @"" ;
            cell.securityQuesTxtFld.placeholder = kSelectSecurityQuesDefaultText ;
        }
        else {
            cell.securityQuesLbl.text = question;
            cell.securityQuesTxtFld.placeholder = @"" ;
        }
        cell.answerTxtFld.text = [[chooseSecurityQuesArray objectAtIndex:indexPath.row] valueForKey:@"answer"];
        
        if(chooseSecurityQuesArray.count == 1){
            cell.plusBtn.hidden= NO ;
            cell.minusBtn.hidden= YES ;
        }
        else{
            if(indexPath.row == chooseSecurityQuesArray.count-1){
                cell.plusBtn.hidden = NO ;
                cell.minusBtn.hidden = YES ;
            }
            else{
                cell.plusBtn.hidden = YES ;
                cell.minusBtn.hidden = NO ;
            }
        }
        return cell ;
    }
    else if(indexPath.section == kORIndex){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kORCellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
        
    }
    else if(indexPath.section == kEnterSecurityQuesIndex){
        EnterSecurityQuesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEnterSecurityQuesCellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        [UtilityClass setTextFieldBorder:cell.securityQuesTxtFld] ;
        [UtilityClass setTextFieldBorder:cell.answerTxtFld] ;
        
        [UtilityClass addMarginsOnTextField:cell.securityQuesTxtFld] ;
        [UtilityClass addMarginsOnTextField:cell.answerTxtFld] ;
        cell.securityQuesTxtFld.tag = indexPath.section ;
        cell.answerTxtFld.tag = indexPath.section ;
        cell.securityQuesTxtFld.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row] ;
        cell.answerTxtFld.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row] ;
        
        cell.plusBtn.tag = indexPath.row ;
        cell.minusBtn.tag = indexPath.row ;
        
        cell.securityQuesTxtFld.placeholder = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"item"] ;
        cell.answerTxtFld.placeholder = @"Answer" ;
        
        cell.securityQuesTxtFld.text = [[enterSecurityQuesArray objectAtIndex:indexPath.row] valueForKey:@"question"];
        cell.answerTxtFld.text = [[enterSecurityQuesArray objectAtIndex:indexPath.row] valueForKey:@"answer"];
        
        if(enterSecurityQuesArray.count == 1){
            cell.plusBtn.hidden= NO ;
            cell.minusBtn.hidden= YES ;
        }
        else{
            if(indexPath.row == enterSecurityQuesArray.count-1){
                cell.plusBtn.hidden = NO ;
                cell.minusBtn.hidden = YES ;
            }
            else{
                cell.plusBtn.hidden = YES ;
                cell.minusBtn.hidden = NO ;
            }
        }
        return cell ;
    }
    else if (indexPath.section == kCountryIndex || indexPath.section == kStateIndex){
        DobTableViewCell *cell = (DobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCountryCellIdentifier] ;
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        [UtilityClass setTextFieldBorder:cell.textFld] ;
        [UtilityClass addMarginsOnTextField:cell.textFld] ;
       // cell.textFld.inputView = securityQuesView ;
        cell.textFld.userInteractionEnabled = NO ;
        
        cell.textFld.placeholder = [NSString stringWithFormat:@"Select %@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"item"]] ;
        cell.textFld.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"] ;
        cell.textFld.tag = indexPath.section ;
        cell.dropdownBtn.tag = indexPath.section ;
        return cell ;
    }
    else if (indexPath.section == kDobIndex ){
        DobTableViewCell *cell = (DobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kDobCellIdentifier] ;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        [UtilityClass setTextFieldBorder:cell.textFld] ;
        [UtilityClass addMarginsOnTextField:cell.textFld] ;
        
        cell.textFld.placeholder =[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"item"] ;
        cell.textFld.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"] ;
        cell.textFld.tag = indexPath.section ;
        cell.dropdownBtn.tag = indexPath.section ;
        
        cell.textFld.inputView = datePickerViewContainer ;
        if(indexPath.section == kDobIndex)datePickerView.datePickerMode = UIDatePickerModeDate ;
        else datePickerView.datePickerMode = UIDatePickerModeTime ;
        
        return cell ;
    }
    else if(indexPath.section == kTermsIndex){
        PaymentsTableViewCell *cell = (PaymentsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kTermsCellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
       // [cell.checkboxBtn ]
        
        if(isTermsSelected == 0){ // Check
            [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
            cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
        }
        else{
            [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
            cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
        }
        
        return cell ;
    }
    else if(indexPath.section == kValidationIndex) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kValidationCellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
    }
    else if(indexPath.section == kReferFriendIndex) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReferFriendCellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
    }
    else if(indexPath.section == kSignupIndex){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSignupCellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
    }
    else {
        TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextFieldCellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.textFld.placeholder = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"item"] ;
        cell.textFld.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"] ;
        cell.textFld.tag = indexPath.section ;
        [UtilityClass setTextFieldBorder:cell.textFld] ;
        [UtilityClass addMarginsOnTextField:cell.textFld] ;
        if(indexPath.section == kPasswordIndex || indexPath.section == kConfirmPasswordIndex)cell.textFld.secureTextEntry = YES ;
        if(indexPath.section == kEmailIndex)cell.textFld.keyboardType = UIKeyboardTypeEmailAddress ;
        else if(indexPath.section == kPhoneIndex){
            cell.textFld.keyboardType = UIKeyboardTypeNumberPad ;
            cell.textFld.inputAccessoryView = phoneToolBar ;
        }
        else if(indexPath.section == kFirstNameIndex || indexPath.section == kLastNameIndex ) cell.textFld.keyboardType = UIKeyboardTypeAlphabet ;
        else cell.textFld.keyboardType = UIKeyboardTypeDefault ;
        
        return cell ;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == kChooseSecurityQuesIndex) return 110;
    else if(indexPath.section == kORIndex) return 30;
    else if(indexPath.section == kEnterSecurityQuesIndex) return 110;
    else if(indexPath.section == kValidationIndex) return 50;
    else if(indexPath.section == kTermsIndex) return 70;
    else return 45 ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionsArray.count ;
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
    return NO ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
     [securityQuesView setHidden:YES] ;
    
    
    selectedCellIndex = (int)textField.tag ;
    _selectedItem = textField ;
    
    if([textField tag] == kCountryIndex) {
        selectedPickerViewType = kCountrySelected ;
        int index = [UtilityClass getPickerViewSelectedIndexFromArray:countryArray forID:selectedCountryID] ;
        if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
        else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
        
    }
    else if([textField tag] == kStateIndex) {
        if([[NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:kCountryIndex] valueForKey:@"id"]] isEqualToString:@""]){
            [self presentViewController:[UtilityClass displayAlertMessage:kSelectCountryDefaultText] animated:YES completion:nil] ;
            [textField resignFirstResponder] ;
            return NO ;
        }
        else{
            NSLog(@"country id: %d",[[[sectionsArray objectAtIndex:kCountryIndex] valueForKey:@"id"] intValue]) ;
            [self getStatesListWithCountryID:[[[sectionsArray objectAtIndex:kCountryIndex] valueForKey:@"id"] intValue]] ;
             selectedPickerViewType = kStateSelected ;
            int index = [UtilityClass getPickerViewSelectedIndexFromArray:statesArray forID:selectedStateID] ;
            if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
            else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
        }
    }
    else if([textField tag] == kChooseSecurityQuesIndex) {
        ChooseSecurityQuesTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[textField.accessibilityValue intValue] inSection:kChooseSecurityQuesIndex]] ;
        if(textField == cell.securityQuesTxtFld ) {
            selectedCellIndex = [textField.accessibilityValue intValue] ;
            selectedPickerViewType = kSecurityQuesSelected ;
        }
    }
    else if([textField tag] == kDobIndex) {
        selectedDatePickerType = kDobSelected ;
        datePickerView.datePickerMode = UIDatePickerModeDate ;
    }
    else if([textField tag] == kBestAvailabilityIndex) {
        selectedDatePickerType = kBestAvailabilitySelected ;
        datePickerView.datePickerMode = UIDatePickerModeTime ;
    }
    
    return YES ;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    _selectedItem = nil ;
    
    if([textField tag] == kPhoneIndex) {
        PhoneTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[textField tag] inSection:kPhoneIndex]] ;
        [[sectionsArray objectAtIndex:textField.tag] setValue:cell.textField.text forKey:@"value"] ;
    }
    return YES ;
}

/*-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //[self.tooltipManager hideAllTooltipsAnimated:YES] ;
    [UtilityClass setTextFieldBorder:textField] ;
    [[sectionsArray objectAtIndex:[textField tag]] setValue:@"1" forKey:@"isValid"] ;
    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:textField.tag]] withRowAnimation:UITableViewRowAnimationNone] ;
}*/


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
   /* if(textField.layer.borderColor == [[UIColor redColor] CGColor]) {
        [UtilityClass setTextFieldBorder:textField] ;
        //[self.tooltipManager hideAllTooltipsAnimated:YES] ;
    }*/
    if([textField tag] == kEnterSecurityQuesIndex){
        EnterSecurityQuesTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[textField.accessibilityValue intValue] inSection:kEnterSecurityQuesIndex]] ;
        
        if(textField == cell.securityQuesTxtFld) [[enterSecurityQuesArray objectAtIndex:[textField.accessibilityValue intValue]] setValue:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"question"] ;
        
        else [[enterSecurityQuesArray objectAtIndex:[textField.accessibilityValue intValue]] setValue:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"answer"] ;
    }
    else if([textField tag] == kChooseSecurityQuesIndex){
        ChooseSecurityQuesTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[textField.accessibilityValue intValue] inSection:kChooseSecurityQuesIndex]] ;
        
        if(textField == cell.answerTxtFld) [[chooseSecurityQuesArray objectAtIndex:[textField.accessibilityValue intValue]] setValue:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"answer"] ;
    }
    else{
        
        // Phone Validation
        if([textField tag] == kPhoneIndex){
          NSLog(@"text: %@",textField.text) ;
        [[sectionsArray objectAtIndex:textField.tag] setValue:textField.text forKey:@"value"] ;
            phoneNumberStr = textField.text ;
            // Check for backspace
            if ([string isEqualToString:@""]) {
                //  your actions for deleteBackward actions
                return YES ;
            }
            
            /*[[sectionsArray objectAtIndex:textField.tag] setValue:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"value"] ;*/
            
            NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string] ;
            if(str.length > PHONE_MAX_LENGTH) return YES ;
           // phoneNumberStr = [textField.text stringByReplacingCharactersInRange:range withString:string] ;
           // NSLog(@"str: %@",str) ;
            
            /* BOOL isValid = newLength <= PHONE_MAX_LENGTH || returnKey;
            if(isValid)[[sectionsArray objectAtIndex:textField.tag] setValue:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"value"] ;
            return isValid ;*/
        }
        
        else [[sectionsArray objectAtIndex:textField.tag] setValue:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"value"] ;
    }
   
    return YES ;
}

#pragma mark - Picker View Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1 ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(selectedPickerViewType == kCountrySelected) return countryArray.count+1 ;
    else if(selectedPickerViewType == kStateSelected) return statesArray.count+1 ;
    else return securityQuestionsArray.count+1 ;
}

/*-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if( selectedPickerViewType == kCountrySelected ){
         DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kCountryIndex]] ;
        if(row == 0) cell.textFld.text = @"" ;
        else cell.textFld.text = [[countryArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    
    else if( selectedPickerViewType == kStateSelected ){
        DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kStateIndex]] ;
        if(row == 0) cell.textFld.text = @"" ;
        else cell.textFld.text = [[statesArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    
    else {
        ChooseSecurityQuesTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedCellIndex inSection:kChooseSecurityQuesIndex]] ;
        if(row == 0) {
            cell.securityQuesTxtFld.placeholder = kSelectSecurityQuesDefaultText ;
            cell.securityQuesLbl.text = @"" ;
        }
        else {
            cell.securityQuesTxtFld.placeholder = @"" ;
            cell.securityQuesLbl.text = [[securityQuestionsArray objectAtIndex:row-1] valueForKey:@"name"] ;
        }
    }
    
}*/

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10,0,pickerView.frame.size.width-20,70);
    label.textColor = [UtilityClass textColor];
    if(selectedPickerViewType == kCountrySelected || selectedPickerViewType == kStateSelected) label.font = [UIFont fontWithName:@"HelveticaNeue" size:16 ];
    else label.font = [UIFont fontWithName:@"HelveticaNeue" size:12 ];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0 ;
    if(selectedPickerViewType == kCountrySelected){
        if(row == 0) label.text = [NSString stringWithFormat:@"%@ %@",kSelectDefaultText,[[sectionsArray objectAtIndex:kCountryIndex] valueForKey:@"item"]] ;
        else label.text = [[countryArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    
    else if(selectedPickerViewType == kStateSelected){
        if(row == 0) label.text = [NSString stringWithFormat:@"%@ %@",kSelectDefaultText,[[sectionsArray objectAtIndex:kStateIndex] valueForKey:@"item"]] ;
        else label.text = [[statesArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    
    else{
        if(row == 0) label.text = kSelectSecurityQuesDefaultText ;
        else label.text = [[securityQuestionsArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    
    return label;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    if(selectedPickerViewType == kCountrySelected || selectedPickerViewType == kStateSelected)return 30 ;
    else return 70 ;
}

#pragma mark - Keyoboard Actions
- (void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // If you are using Xcode 6 or iOS 7.0, you may need this line of code. There was a bug when you
    // rotated the device to landscape. It reported the keyboard as the wrong size as if it was still in portrait mode.
    //kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    tblView.contentInset = contentInsets;
    tblView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.selectedItem.frame.origin ) ) {
        if(![_selectedItem isKindOfClass:[UITableView class]])[tblView scrollRectToVisible:self.selectedItem.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    [self moveToOriginalFrame] ;
}

-(void)moveToOriginalFrame {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    tblView.contentInset = contentInsets;
    tblView.scrollIndicatorInsets = contentInsets;
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
