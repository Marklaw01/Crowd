//
//  AddNoteViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 18/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "AddNoteViewController.h"
#import "CDTestEntity.h"

@interface AddNoteViewController ()

@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"selectedEntity: %@",self.selectedEntity) ;
    [self resetUISettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)singleTap:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    [UtilityClass setTextFieldBorder:selectStartupTxtFld] ;
    [UtilityClass addMarginsOnTextField:selectStartupTxtFld] ;
    [UtilityClass setTextFieldBorder:titleTxtFld] ;
    [UtilityClass addMarginsOnTextField:titleTxtFld] ;
    [UtilityClass setTextViewBorder:descriptionTxtView] ;
    [UtilityClass addMarginsOnTextView:descriptionTxtView] ;
    
    selectStartupTxtFld.inputView = pickerViewContainer ;
    selectedStartupIndex   = -1 ;
    startupsArray = [[NSMutableArray alloc] init] ;
    
    if([UtilityClass GetAddNoteMode] == YES)[self setEditableMode:YES] ;
    else [self setEditableMode:NO] ;
    [self getStartupsList] ;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
     if([UtilityClass GetAddNoteMode] == YES){
     self.title = @"Add Note" ;
     }
     else {
         if(self.selectedEntity){
             self.title = self.selectedEntity.note_title ;
         }
         else self.title = @"Note" ;
        // int index = [self getSelectedStartupNameWithID:]
     //self.title = [NSString stringWithFormat:@"%@",[startupsArray objectAtIndex:[]]]] ;
    
     }
}

-(int)getSelectedStartupNameWithID:(NSString*)selectedID{
    int index = -1 ;
    for (int i=0; i<startupsArray.count ;i++) {
        NSString *startupID = [NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:i] valueForKey:kProfileUserStartupApi_StartupID]] ;
        if([startupID isEqualToString:selectedID]) return i ;
    }
    return index ;
}

-(void)setEditableMode:(BOOL)isEditable{
    selectStartupTxtFld.enabled = isEditable ;
    titleTxtFld.enabled = isEditable ;
    descriptionTxtView.editable = isEditable ;
    dropdownBtn.hidden = !isEditable ;
    if(isEditable)[saveBtn setTitle:NOTE_SAVE_BUTTON forState:UIControlStateNormal] ;
    else [saveBtn setTitle:NOTE_EDIT_BUTTON forState:UIControlStateNormal] ;
    if([UtilityClass GetAddNoteMode] == NO){
        dropdownBtn.hidden = YES ;
        selectStartupTxtFld.enabled = NO ;
    }
}

-(void)displaySelectedNoteDetails{
    if(self.selectedEntity){
        
        int index = [self getSelectedStartupNameWithID:self.selectedEntity.note_startupid] ;
        if(index != -1){
            selectStartupTxtFld.text = [NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:index] valueForKey:kProfileUserStartupApi_StartupName]] ;;
            [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
        }
        else{
            [pickerView selectRow:0 inComponent:0 animated:YES] ;
        }
        selectedStartupIndex = index ;
        titleTxtFld.text = self.selectedEntity.note_title ;
        descriptionTxtView.text = self.selectedEntity.note_desc ;
         [self setEditableMode:NO] ;
    }
}

#pragma mark - Api Methods
-(void)getStartupsList{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileUserStartupApi_UserID] ;
        
        [ApiCrowdBootstrap getNotesStartupListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
           // NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                if([responseDict objectForKey:kProfileUserStartupApi_StartupData]){
                    startupsArray = [NSMutableArray arrayWithArray:(NSArray*)[[responseDict objectForKey:kProfileUserStartupApi_StartupData] mutableCopy]] ;
                    [pickerView reloadAllComponents] ;
                    
                    if([UtilityClass GetAddNoteMode] == NO)[self displaySelectedNoteDetails] ;
                    
                }
            }
            //else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - Validation Methods
-(BOOL)validateInputFields{
    if(selectedStartupIndex == -1){
        [self presentViewController:[UtilityClass displayAlertMessage:SELECT_STARTUP_DEFAULT] animated:YES completion:nil] ;
        return NO;
    }
    else if (titleTxtFld.text.length <1){
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Note_Title] animated:YES completion:nil] ;
        return NO;
    }
    else if (descriptionTxtView.text.length <1){
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Note_Desc] animated:YES completion:nil] ;
        return NO;
    }
    return YES ;
}

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)Save_ClickAction:(UIButton*)button {
    if([UtilityClass GetAddNoteMode] == NO){
        if([button.titleLabel.text isEqualToString:NOTE_EDIT_BUTTON]){
            [self setEditableMode:YES] ;
        }
        else{
            if(![self validateInputFields]) return ;
            [self updateNote] ;
        }
    }
    else{
        if(![self validateInputFields]) return ;
        [self insertNote] ;
    }
}

- (IBAction)toolbarButtons_ClickAction:(id)sender {
    [selectStartupTxtFld resignFirstResponder] ;
    
    if([sender tag] == DONE_CLICKED){
        if([pickerView selectedRowInComponent:0] == 0){
            selectStartupTxtFld.text = @""  ;
            selectedStartupIndex = -1 ;
        }
        else{
            selectStartupTxtFld.text = [[startupsArray objectAtIndex:[pickerView selectedRowInComponent:0]-1] valueForKey:kProfileUserStartupApi_StartupName]  ;
            selectedStartupIndex = (int)[pickerView selectedRowInComponent:0]-1 ;
        }
        
    }
    else{
        
        if(selectedStartupIndex != -1) selectStartupTxtFld.text = [[startupsArray objectAtIndex:selectedStartupIndex] valueForKey:kProfileUserStartupApi_StartupName]  ;
        else selectStartupTxtFld.text = @"" ;
        
    }
}

- (IBAction)SelectStartup_ClickAction:(id)sender {
    [selectStartupTxtFld becomeFirstResponder] ;
    if(selectedStartupIndex != -1){
        int index = [UtilityClass getPickerViewSelectedIndexFromArray:startupsArray forID:[NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:selectedStartupIndex] valueForKey:kProfileUserStartupApi_StartupID]]] ;
        if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
        else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
    }
    else [pickerView selectRow:0 inComponent:0 animated:YES] ;
}

#pragma mark - CoreData Methods
- (void)insertNote
{
    // create insert instance of CoreData
    CDTestEntity *insertEntity = [[AppDelegate appDelegate].coreDataManager createInsertEntityWithClassName:NOTES_ENTITY];
    
    // set auto increment id
    [[AppDelegate appDelegate].coreDataManager autoIncrementIDWithEntityClass:NOTES_ENTITY
                                             success:^(NSInteger new_create_id)
     {
         insertEntity.id = @(new_create_id) ;
     }
                                              failed:^(NSError *error)
     {
         
     }];
    
    // add etcetera value
    insertEntity.note_desc  = descriptionTxtView.text ;
    insertEntity.note_title = titleTxtFld.text;
    insertEntity.note_startupid = [NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:selectedStartupIndex] valueForKey:@"id"]] ;
    insertEntity.note_date = [dateFormatter stringFromDate:[NSDate date]] ;
    // save insert data
    [[AppDelegate appDelegate].coreDataManager save];
    
    [UtilityClass showNotificationMessgae:ALERT_NOTE_ADDED withResultType:@"1" withDuration:1] ;
    [self.navigationController popViewControllerAnimated:YES] ;
    
}

-(void)updateNote{
    [[AppDelegate appDelegate].coreDataManager fetchWithEntity:NOTES_ENTITY
                            Predicate:nil
                              success:^(NSArray *fetchLists)
     {
         // update
         
         CDTestEntity *updateEntity = (CDTestEntity*)self.selectedEntity ;
         updateEntity.note_title = titleTxtFld.text ;
         updateEntity.note_desc = descriptionTxtView.text ;
         updateEntity.note_startupid = [NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:selectedStartupIndex] valueForKey:@"id"]] ;
         updateEntity.note_date = [dateFormatter stringFromDate:[NSDate date]] ;
         [[AppDelegate appDelegate].coreDataManager save];
         
     }
                               failed:^(NSError *error)
     {
         
     }];
    
    [UtilityClass showNotificationMessgae:ALERT_NOTE_ADDED withResultType:@"1" withDuration:1] ;
    [self.navigationController popViewControllerAnimated:YES] ;

}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - Picker View Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1 ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return startupsArray.count+1 ;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(row == 0) return SELECT_STARTUP_DEFAULT ;
    else return [[startupsArray objectAtIndex:row-1] valueForKey:kProfileUserStartupApi_StartupName] ;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(row == 0) selectStartupTxtFld.text = @"" ;
    else selectStartupTxtFld.text = [[startupsArray objectAtIndex:row-1]valueForKey:kProfileUserStartupApi_StartupName] ;
}

#pragma mark - Text Field Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    if(textField == titleTxtFld) [descriptionTxtView becomeFirstResponder] ;
    return YES ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField == selectStartupTxtFld){
        if(selectedStartupIndex != -1){
            int index = [UtilityClass getPickerViewSelectedIndexFromArray:startupsArray forID:[NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:selectedStartupIndex] valueForKey:kProfileUserStartupApi_StartupID]]] ;
            if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
            else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
        }
        else [pickerView selectRow:0 inComponent:0 animated:YES] ;
    }
    
    return YES ;
}

#pragma mark - TextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [_scrollView scrollRectToVisible:textView.frame animated:YES];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [_scrollView scrollRectToVisible:textView.frame animated:YES];
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
