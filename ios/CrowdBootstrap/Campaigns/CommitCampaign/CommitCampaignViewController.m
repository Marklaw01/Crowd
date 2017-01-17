//
//  CommitCampaignViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 25/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "CommitCampaignViewController.h"

@interface CommitCampaignViewController ()

@end

@implementation CommitCampaignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"getCampaignDetails >> %@",[UtilityClass getCampaignDetails]) ;
    [self resetUISettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    self.title = @"Commit Campaign" ;
    timePeriodArray = [[NSMutableArray alloc] init] ;
    
    [UtilityClass setTextFieldBorder:amountTxtFld] ;
    [UtilityClass setTextFieldBorder:timePeriodTxtFld] ;
    
    [UtilityClass addMarginsOnTextField:amountTxtFld] ;
    [UtilityClass addMarginsOnTextField:timePeriodTxtFld] ;
    
    publicBtn.accessibilityValue = RADIOBUTON_SELECTED ;
    privateBtn.accessibilityValue = RADIOBUTTON_UNSELECTED ;
    
    timePeriodTxtFld.inputView = pickerViewContainer ;
    amountTxtFld.inputAccessoryView = numberToolBar ;
    amountTxtFld.placeholder = @"Amount" ;
    selectedTimePeriodIndex = -1 ;
    amountLeft  = 0 ;
    amountNum  = 0 ;
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    [formatter setGroupingSeparator:@","] ;
    [formatter setGroupingSize:3] ;
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    
    [self displayAmountLeft] ;
    [self getTimePeriods] ;
}

-(void)displayAmountLeft{
    float targetAmount = [[[UtilityClass getCampaignDetails] valueForKey:kCampaignsAPI_TargetAmount] floatValue];
    float fundRaised = [[[UtilityClass getCampaignDetails] valueForKey:kCampaignsAPI_FundRaised] floatValue];
    if(targetAmount){
        //if(fundRaised ){
            
            if( targetAmount > fundRaised){
                amountLeft = targetAmount - fundRaised ;
                NSLog(@"amountLeft: %f",amountLeft) ;
            }
            
        //}
    }
    amountLeftLbl.text = [NSString stringWithFormat:@"$%@",[formatter stringFromNumber:[NSNumber numberWithDouble:amountLeft]]] ;
}

-(void)updateAmountLeftByAmount:(float)amount{
    
    float updatedAmount = amountLeft - amount ;
    amountLeftLbl.text = [NSString stringWithFormat:@"$%@",[formatter stringFromNumber:[NSNumber numberWithFloat:updatedAmount]]] ;
    
}

#pragma mark - API Methods
-(void)getTimePeriods{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        [ApiCrowdBootstrap getTimePeriods:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                if([responseDict objectForKey:@"DonationTimeperiods"]){
                    timePeriodArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:@"DonationTimeperiods"]] ;
                    [pickerView reloadAllComponents] ;
                }
            }
            //else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)commitCampaign{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommitAPI_UserID] ;
        [dictParam setObject:[[[UtilityClass getCampaignDetails] mutableCopy] valueForKey:kCampaignDetailAPI_CampaignID] forKey:kCommitAPI_campaignID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",amountTxtFld.amount] forKey:kCommitAPI_targetAmount] ;
        if(selectedTimePeriodIndex == -1)[dictParam setObject:@"0" forKey:kCommitAPI_timePeriod] ;
        else [dictParam setObject:[NSString stringWithFormat:@"%@",[[timePeriodArray objectAtIndex:selectedTimePeriodIndex]valueForKey:@"id"]] forKey:kCommitAPI_timePeriod] ;
        if([privateBtn.accessibilityValue isEqualToString:RADIOBUTON_SELECTED])[dictParam setObject:@"true" forKey:kCommitAPI_contributionPublic] ;
        else [dictParam setObject:@"false" forKey:kCommitAPI_contributionPublic] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap commitCampaignWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                // [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil] ;
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"0" withDuration:1] ;
                NSMutableDictionary *campaignDict = [[UtilityClass getCampaignDetails] mutableCopy] ;
                [campaignDict setValue:@"1" forKey:kCampaignDetailAPI_IsCommitted] ;
                [UtilityClass setCampaignDetails:campaignDict] ;
                [self.navigationController popViewControllerAnimated:YES] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - ToolBar Buttons Methods
- (IBAction)NumberToolBar_ClickAction:(id)sender {
    [amountTxtFld resignFirstResponder] ;
}

- (IBAction)toolbarButtons_ClickAction:(id)sender {
    [timePeriodTxtFld resignFirstResponder] ;
    
    if([sender tag] == DONE_CLICKED){
        if([pickerView selectedRowInComponent:0] == 0){
            timePeriodTxtFld.text = @"" ;
            selectedTimePeriodIndex = -1 ;
        }
        else{
            timePeriodTxtFld.text = [[timePeriodArray objectAtIndex:[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"]  ;
            selectedTimePeriodIndex = (int)[pickerView selectedRowInComponent:0]-1 ;
        }
    }
    else{
        if(selectedTimePeriodIndex != -1) timePeriodTxtFld.text = [[timePeriodArray objectAtIndex:selectedTimePeriodIndex] valueForKey:@"name"]  ;
        else timePeriodTxtFld.text = @"" ;
    }
}

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)openPickerView_ClickAction:(id)sender {
    [timePeriodTxtFld becomeFirstResponder] ;
    if(selectedTimePeriodIndex != -1){
        int index = [UtilityClass getPickerViewSelectedIndexFromArray:timePeriodArray forID:[[timePeriodArray objectAtIndex:selectedTimePeriodIndex] valueForKey:@"id"]] ;
        if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
        else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
    }
    else [pickerView selectRow:0 inComponent:0 animated:YES] ;
    
}
- (IBAction)RadioButton_ClickAction:(UIButton*)button {
    if(button.tag == PUBLIC_SELECTED){
        if([publicBtn.accessibilityValue isEqualToString:RADIOBUTON_SELECTED]){
            [publicBtn setBackgroundImage:[UIImage imageNamed:RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
            publicBtn.accessibilityValue = RADIOBUTTON_UNSELECTED ;
            [privateBtn setBackgroundImage:[UIImage imageNamed:RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
            privateBtn.accessibilityValue = RADIOBUTON_SELECTED ;
        }
        else{
            [publicBtn setBackgroundImage:[UIImage imageNamed:RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
            publicBtn.accessibilityValue = RADIOBUTON_SELECTED ;
            [privateBtn setBackgroundImage:[UIImage imageNamed:RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
            privateBtn.accessibilityValue = RADIOBUTTON_UNSELECTED ;
        }
    }
    else{
        if([privateBtn.accessibilityValue isEqualToString:RADIOBUTON_SELECTED]){
            [privateBtn setBackgroundImage:[UIImage imageNamed:RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
            privateBtn.accessibilityValue = RADIOBUTTON_UNSELECTED ;
            [publicBtn setBackgroundImage:[UIImage imageNamed:RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
            publicBtn.accessibilityValue = RADIOBUTON_SELECTED ;
        }
        else{
            [privateBtn setBackgroundImage:[UIImage imageNamed:RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
            privateBtn.accessibilityValue = RADIOBUTON_SELECTED ;
            [publicBtn setBackgroundImage:[UIImage imageNamed:RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
            publicBtn.accessibilityValue = RADIOBUTTON_UNSELECTED ;
        }
    }
}

- (IBAction)Cancel_ClickAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)Submit_ClickAction:(id)sender {
    [amountTxtFld resignFirstResponder] ;
    [timePeriodTxtFld resignFirstResponder] ;
    NSLog(@"amountTxtFld: %@",amountTxtFld.amount) ;
    if( [amountTxtFld.amount intValue] == 0){
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Commit_Amount] animated:YES completion:nil] ;
        return ;
    }
    else if(selectedTimePeriodIndex == -1){
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Commit_TimePeriod] animated:YES completion:nil] ;
        return ;
    }
    
    [self commitCampaign] ;
    
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(timePeriodTxtFld.isEditing){
        if(selectedTimePeriodIndex != -1) timePeriodTxtFld.text = [[timePeriodArray objectAtIndex:selectedTimePeriodIndex] valueForKey:@"name"]  ;
        else timePeriodTxtFld.text = @"" ;
    }
    
     [self.view endEditing:YES];
}
#pragma mark -  TSTextField Methods
- (IBAction) amountChanged: (TSCurrencyTextField*) sender
{
    // This could just as easily be _amountLabel.text = sender.text.
    // But we want to demonstrate the amount property here.
    float amountToSubtract = [amountTxtFld.amount floatValue] ;
    if(amountLeft >= amountToSubtract) [self updateAmountLeftByAmount:amountToSubtract] ;
    else {
        
        if(amountLeft - amountToSubtract <1) {
            
            amountTxtFld.amount = amountNum;
            
            return ;
        }
    }
    amountNum = amountTxtFld.amount ;
}

#pragma mark - Picker View Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1 ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return timePeriodArray.count+1 ;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(row == 0) return TIME_PERIOD_DEFAULT ;
    else return [[timePeriodArray objectAtIndex:row-1] valueForKey:@"name"] ;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(row == 0) timePeriodTxtFld.text = @"" ;
    else timePeriodTxtFld.text = [[timePeriodArray objectAtIndex:row-1] valueForKey:@"name"] ;
}

#pragma mark - TextField Delegate Methods8
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    return YES ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == timePeriodTxtFld){
        if(selectedTimePeriodIndex != -1){
            int index = [UtilityClass getPickerViewSelectedIndexFromArray:timePeriodArray forID:[[timePeriodArray objectAtIndex:selectedTimePeriodIndex] valueForKey:@"id"]] ;
            if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
            else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
        }
        else [pickerView selectRow:0 inComponent:0 animated:YES] ;
    }
    return YES ;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField == amountTxtFld){
        
        if([string rangeOfString: @"."].location != NSNotFound && [textField.text rangeOfString: @"."].location != NSNotFound) {
            return NO ;
        }
        else{
            NSString *amount = [NSString stringWithFormat:@"%@",amountTxtFld.amount] ;
            float amountToSubtract = [[amount stringByReplacingCharactersInRange:range withString:string] floatValue] ;
            NSLog(@"amountLeft: %f amountToSubtract: %f",amountLeft , amountToSubtract) ;
            if(amountLeft >= amountToSubtract) [self updateAmountLeftByAmount:amountToSubtract] ;
            else if(amountLeft - amountToSubtract > [amountLeftLbl.text floatValue]){
                
            }
            else return NO ;
        }
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
