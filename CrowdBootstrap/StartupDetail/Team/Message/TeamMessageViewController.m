//
//  TeamMessageViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 09/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "TeamMessageViewController.h"

@interface TeamMessageViewController ()

@end

@implementation TeamMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"roleID: %@",self.roleID) ;
    [self resetUISettings] ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil] ;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil] ;
}

#pragma mark - Custom Methods
-(void)resetUISettings {
    
    self.title = @"Message" ;
    toTxtFld.enabled = NO ;
    
    [UtilityClass setTextFieldBorder:toTxtFld] ;
    [UtilityClass setTextFieldBorder:subjectTxtFld] ;
    [UtilityClass setTextViewBorder:messagetxtView] ;
    
    [UtilityClass addMarginsOnTextField:toTxtFld] ;
    [UtilityClass addMarginsOnTextField:subjectTxtFld] ;
    //[UtilityClass addMarginsOnTextView:messagetxtView] ;
    
    if(self.dict){
        toTxtFld.text = [NSString stringWithFormat:@"%@",[self.dict valueForKey:kStartupTeamAPI_MemberName]] ;
    }
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)singleTap:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}

#pragma mark - API Methods
-(void)sendMessage {
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_SendMessage] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupTeamMesageAPI_FromID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[self.dict valueForKey:kStartupTeamAPI_TeamMemberID]] forKey:kStartupTeamMesageAPI_ToID] ;
        //if(self.roleID)[dictParam setObject:self.roleID forKey:kStartupTeamMesageAPI_RoleID] ;
        [dictParam setObject:[UtilityClass getTeamMemberRole] forKey:kStartupTeamMesageAPI_RoleID] ;
        [dictParam setObject:subjectTxtFld.text forKey:kStartupTeamMesageAPI_Subject] ;
        [dictParam setObject:messagetxtView.text forKey:kStartupTeamMesageAPI_Message] ;
        [dictParam setObject:@"team" forKey:kStartupTeamMesageAPI_Msg_Type];
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap startupTeamMessageWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
                [self.navigationController popViewControllerAnimated:YES] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}


#pragma mark - Validation Methods
-(BOOL)validateFieldsWithText:(NSString*)text withMessage:(NSString*)message{
    BOOL isValid = YES ;
    if(text.length <1 || [text isEqualToString:@" "] || [text isEqualToString:@"\n"]){
         [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"%@%@",message,kAlert_SignUp_BlankField]] animated:YES completion:nil];
        return NO ;
    }
    return isValid ;
}

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)SendMessage_ClickAction:(id)sender {
    
    if(![self validateFieldsWithText:subjectTxtFld.text withMessage:@"Subject"])
        return;
    else if(![self validateFieldsWithText:messagetxtView.text withMessage:@"Message"])
        return ;
    [self sendMessage] ;
}


#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _selectedItem = textField ;
    return YES ;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    if([textField isEqual:toTxtFld])[subjectTxtFld becomeFirstResponder] ;
    else if([textField isEqual:subjectTxtFld])[messagetxtView becomeFirstResponder] ;
    
    return YES ;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _selectedItem = nil ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]){
         [textView resignFirstResponder];
        [self SendMessage_ClickAction:nil] ;
    }
    
    [self moveToOriginalFrame] ;
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    _selectedItem=textView;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    _selectedItem = nil ;
}

#pragma mark - keyoboard actions
- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // If you are using Xcode 6 or iOS 7.0, you may need this line of code. There was a bug when you
    // rotated the device to landscape. It reported the keyboard as the wrong size as if it was still in portrait mode.
    //kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.selectedItem.frame.origin ) ) {
        if(![_selectedItem isKindOfClass:[UITableView class]])[self.scrollView scrollRectToVisible:self.selectedItem.frame animated:YES];
    }
    
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    [self moveToOriginalFrame] ;
}

-(void)moveToOriginalFrame{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
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
