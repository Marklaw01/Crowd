//
//  StartupDocs_StartupViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 20/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "StartupDocs_StartupViewController.h"

@interface StartupDocs_StartupViewController ()

@end

@implementation StartupDocs_StartupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetUISettings] ;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)singleTap:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}

#pragma mark - Notifcation Methods
- (void)startupRoadmapDocsDataNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationStartupRoadmapDocs]){
        
        [self getRoadmapDocsStatus] ;
    }
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    [UtilityClass setTextFieldBorder:prevRoadmapTextFld] ;
    [UtilityClass setTextFieldBorder:currentRoadmapTxtFld] ;
    [UtilityClass setTextFieldBorder:nextStepTxtFld] ;
    [UtilityClass setViewBorder:approveStartupView] ;
    [UtilityClass setButtonBorder:fileNameBtn] ;
    
    [UtilityClass addMarginsOnTextField:prevRoadmapTextFld] ;
    [UtilityClass addMarginsOnTextField:currentRoadmapTxtFld] ;
    [UtilityClass addMarginsOnTextField:nextStepTxtFld] ;
    
    currentRoadmapTxtFld.inputView = pickerViewContainer ;
    selectedRoadmapIndex = -1 ;
    currentRoadmapTxtFld.placeholder = kDeliverable_Default ;
    
    yesBtn.accessibilityValue = STARTUP_RADIOBUTTON_UNSELECTED ;
    noBtn.accessibilityValue = STARTUP_RADIOBUTON_SELECTED ;
    
    deliverablesArray = [[NSMutableArray alloc] init] ;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startupRoadmapDocsDataNotification:)
                                                 name:kNotificationStartupRoadmapDocs
                                               object:nil];
    
    [self getDeliverables] ;
    
}

#pragma mark - API Methods
-(void)getDeliverables{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [ApiCrowdBootstrap getDeliverables:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                if([responseDict objectForKey:kDeliverablesAPI_Deliverables]){
                    
                    deliverablesArray = [NSMutableArray arrayWithArray:[responseDict objectForKey:kDeliverablesAPI_Deliverables]] ;
                    [pickerView reloadAllComponents] ;
                }
            }
            //else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getRoadmapDocsStatus{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:@"70" forKey:kRoadmapDocsAPI_StartupID] ;
        //[dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:kRoadmapDocsAPI_StartupID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getStartupRoadmapDocsStatusWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                NSArray *completedRoadmapsArray = (NSArray*)[responseDict valueForKey:kRoadmapDocsAPI_CompletedRoadmaps] ;
                if(completedRoadmapsArray.count > 0){
                    for (int i=0; i<completedRoadmapsArray.count ; i++) {
                        NSString *completedRoadmapID = @"" ;
                        if([NSString stringWithFormat:@"%@",[[completedRoadmapsArray objectAtIndex:i]valueForKey:kRoadmapDocsAPI_RoadmapID]]){
                             completedRoadmapID = [NSString stringWithFormat:@"%@",[[completedRoadmapsArray objectAtIndex:i]valueForKey:kRoadmapDocsAPI_RoadmapID]]  ;
                        }
                        if(i == 0)  prevRoadmapTextFld.text = [[completedRoadmapsArray objectAtIndex:i] valueForKey:kRoadmapDocsAPI_RoadmapName] ;
                        else if(i == 1)  nextStepTxtFld.text = [[completedRoadmapsArray objectAtIndex:i] valueForKey:kRoadmapDocsAPI_RoadmapName] ;
                        NSMutableArray *roadmapsArray = [NSMutableArray arrayWithArray:deliverablesArray] ;
                         for (int j=0; j<roadmapsArray.count ; j++) {
                           NSString *roadmapID = [NSString stringWithFormat:@"%@",[[roadmapsArray objectAtIndex:j]valueForKey:@"id"]]  ;
                             NSLog(@"deliverablesArray: %@",deliverablesArray) ;
                            if([roadmapID isEqualToString:completedRoadmapID] && [deliverablesArray objectAtIndex:j]){
                               [deliverablesArray removeObjectAtIndex:j] ;
                                break ;
                            }
                        }
                    }
                    [pickerView reloadAllComponents] ;
                }
                
            }
            //else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - IBAction Methods
- (IBAction)SubmitApp_ClickAction:(id)sender {
}

- (IBAction)UploadStartup_ClickAction:(id)sender {
}

- (IBAction)browseFile_ClickAction:(id)sender {
}

- (IBAction)Completed_ClickAction:(UIButton*)button {
    if(button.tag == YES_SELETCED){
        if([yesBtn.accessibilityValue isEqualToString:STARTUP_RADIOBUTON_SELECTED]){
            [yesBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
            yesBtn.accessibilityValue = STARTUP_RADIOBUTTON_UNSELECTED ;
            [noBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
            noBtn.accessibilityValue = STARTUP_RADIOBUTON_SELECTED ;
        }
        else{
            [yesBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
            yesBtn.accessibilityValue = STARTUP_RADIOBUTON_SELECTED ;
            [noBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
            noBtn.accessibilityValue = STARTUP_RADIOBUTTON_UNSELECTED ;
        }
    }
    else{
        if([noBtn.accessibilityValue isEqualToString:STARTUP_RADIOBUTON_SELECTED]){
            [noBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
            noBtn.accessibilityValue = STARTUP_RADIOBUTTON_UNSELECTED ;
            [yesBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
            yesBtn.accessibilityValue = STARTUP_RADIOBUTON_SELECTED ;
        }
        else{
            [noBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
            noBtn.accessibilityValue = STARTUP_RADIOBUTON_SELECTED ;
            [yesBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
            yesBtn.accessibilityValue = STARTUP_RADIOBUTTON_UNSELECTED ;
        }
    }
}

- (IBAction)openPickerView_ClickAction:(id)sender {
    [currentRoadmapTxtFld becomeFirstResponder] ;
}

#pragma mark - Toolbar Buttons Methods
- (IBAction)toolbarButtons_ClickAction:(id)sender {
    [currentRoadmapTxtFld resignFirstResponder] ;
    
    if([sender tag] == DONE_CLICKED){
        if([pickerView selectedRowInComponent:0] == 0){
            currentRoadmapTxtFld.text = @"" ;
            selectedRoadmapIndex = -1 ;
        }
        else{
            currentRoadmapTxtFld.text = [[deliverablesArray objectAtIndex:[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"]  ;
            selectedRoadmapIndex = (int)[pickerView selectedRowInComponent:0]-1 ;
        }
        
    }
    else{
        if(selectedRoadmapIndex != -1) currentRoadmapTxtFld.text = [[deliverablesArray objectAtIndex:selectedRoadmapIndex] valueForKey:@"name"]  ;
        else currentRoadmapTxtFld.text = @"" ;
    }
}

#pragma mark - Picker View Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1 ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return deliverablesArray.count+1 ;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(row == 0) return kDeliverable_Default ;
    else return [[deliverablesArray objectAtIndex:row-1] valueForKey:@"name"] ;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(row == 0) currentRoadmapTxtFld.text = @"" ;
    else currentRoadmapTxtFld.text = [[deliverablesArray objectAtIndex:row-1] valueForKey:@"name"] ;
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    return NO ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _selectedItem = textField ;
    return YES ;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
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
