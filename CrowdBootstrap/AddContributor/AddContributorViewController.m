//
//  AddContributorViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 19/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "AddContributorViewController.h"
#import "KLCPopup.h"
#import "PaymentsTableViewCell.h"

@interface AddContributorViewController ()

@end

@implementation AddContributorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"prof mode: %d",[UtilityClass getProfileMode] == PROFILE_MODE_SEARCH) ;
    [self resetUISettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    // set Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Custom Methods
-(void)resetUISettings {
    
    self.title = @"Add Contractor" ;
    
    [UtilityClass setTextFieldBorder:selectStartupTxtFld] ;
    [UtilityClass setTextFieldBorder:contractorNameTxtFld] ;
    [UtilityClass setTextFieldBorder:roleTxtFld] ;
    [UtilityClass setTextFieldBorder:hourlyRateTxtFld] ;
    [UtilityClass setTextFieldBorder:workUnitsAllocatedTxtFld] ;
    [UtilityClass setTextFieldBorder:workUnitsApprovedTxtFld] ;
    [UtilityClass setTextFieldBorder:targetCompletionDateTxtFld] ;
    
    [UtilityClass addMarginsOnTextField:selectStartupTxtFld] ;
    [UtilityClass addMarginsOnTextField:contractorNameTxtFld] ;
    [UtilityClass addMarginsOnTextField:roleTxtFld] ;
    [UtilityClass addMarginsOnTextField:hourlyRateTxtFld] ;
    [UtilityClass addMarginsOnTextField:workUnitsAllocatedTxtFld] ;
    [UtilityClass addMarginsOnTextField:workUnitsApprovedTxtFld] ;
    [UtilityClass addMarginsOnTextField:targetCompletionDateTxtFld] ;
    
    selectStartupTxtFld.inputView = pickerViewContainer ;
    roleTxtFld.inputView = pickerViewContainer ;
    targetCompletionDateTxtFld.inputView = datePickerViewContainer;
    hourlyRateTxtFld.inputAccessoryView = numberToolBar ;
    workUnitsAllocatedTxtFld.inputAccessoryView = numberToolBar ;
    workUnitsApprovedTxtFld.inputAccessoryView = numberToolBar ;
    selectedStarupIndex = -1 ;
    selectedRoleIndex = -1 ;
    contractorNameTxtFld.enabled = NO ;
    
    roleArray = [[NSMutableArray alloc] init] ;
    startupsArray = [[NSMutableArray alloc] init] ;
    deliverablesArray = [[NSMutableArray alloc] init] ;
    selectedDeliverablesArray = [[NSMutableArray alloc] init] ;
    
    // Number Formatter
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    [formatter setGroupingSeparator:@","] ;
    [formatter setGroupingSize:3] ;
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    
    // Date Formatter
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    [datePickerView setMinimumDate:[NSDate date]] ;
    [datePickerView setDatePickerMode: UIDatePickerModeDate] ;
    [datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    prevTargetDate       = @"" ;
    
    [workUnitsAllocatedTxtFld addTarget:self
                                 action:@selector(formatNumberIfNeeded:)
                       forControlEvents:UIControlEventEditingChanged];
    [workUnitsApprovedTxtFld addTarget:self
                                action:@selector(formatNumberIfNeeded:)
                      forControlEvents:UIControlEventEditingChanged];
    
    
    [self initializeDeliverableTagsView] ;
    [self setHourlyRateView] ;
    
    contractorNameTxtFld.text = [[UtilityClass getContractorDetails] valueForKey:kRecommendedContAPI_Contractor_Name] ;
    NSLog(@"rate %@",[UtilityClass getContractorDetails] ) ;
    hourlyRateTxtFld.amount = [formatter numberFromString:[NSString stringWithFormat:@"%@",[[UtilityClass getContractorDetails] valueForKey:kRecommendedContAPI_Rate]]];
    
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    if([UtilityClass getProfileMode] == PROFILE_MODE_SEARCH) {
        [self updateStartupViewAccordingToProfileType:NO] ;
        [self getStartups] ;
    }
    else {
        [self updateStartupViewAccordingToProfileType:YES] ;
    }
    [self getMemberRoles] ;
    [self getDeliverables] ;
}

-(void)setHourlyRateView {
    // Add right view on Hourly Rate
    UIView *paddingRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 35, 35)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 35)] ;
    lbl.text = @"/HR" ;
    lbl.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    lbl.textAlignment = NSTextAlignmentCenter ;
    [lbl setTextColor:[UtilityClass greenColor]] ;
    [paddingRightView addSubview:lbl] ;
    hourlyRateTxtFld.rightView = paddingRightView;
    hourlyRateTxtFld.rightViewMode = UITextFieldViewModeAlways;
}

-(void)updateStartupViewAccordingToProfileType:(BOOL)setHidden {
    selectStartupTxtFld.hidden = setHidden ;
    startupNameLbl.hidden = setHidden ;
    arrowButton.hidden = setHidden ;
}

-(void)initializeDeliverableTagsView {
    
    [UtilityClass setButtonBorder:tagsButton] ;
    
    tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
    tagsScrollView.backgroundColor = [UIColor clearColor] ;
    
    NSMutableArray *tags ;
    tags = [selectedDeliverablesArray mutableCopy] ;
    
    if(tags.count >0)[tagsButton setHidden:YES] ;
    else [tagsButton setHidden:NO] ;
    
    //tagsScrollView.tagPlaceholder = @"Add Roadmap Deliverable" ;
    [tagsButton setTitle:@"Add Roadmap Deliverable" forState:UIControlStateNormal] ;
    tagsScrollView.tags = [tags mutableCopy];
    tagsScrollView.tagsDeleteButtonColor = [UIColor whiteColor];
    tagsScrollView.tagsTextColor = [UIColor whiteColor] ;
    tagsScrollView.mode = TLTagsControlModeEdit;
    [tagsScrollView setTapDelegate:self];
    [tagsScrollView setDeleteDelegate:self];
    
    tagsScrollView.tagsBackgroundColor = [UtilityClass orangeColor];
    
    [tagsScrollView reloadTagSubviews];
    
    UITapGestureRecognizer  *txtViewTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(txtViewTapped_Gesture:)];
    [tagsScrollView addGestureRecognizer:txtViewTapped];
}

-(void)openTagsPopup {
    
    [self.view endEditing:YES] ;
    [popupTblView reloadData] ;
    [UtilityClass displayPopupWithContentView:popupView view:self.view] ;
}

#pragma mark - API Methods
-(void)addContractor {
    
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_AddContractor] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        // Contractor Id
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getContractorDetails] valueForKey:kRecommendedContAPI_ContractorID]] forKey:kAddContractorAPI_UserID] ;
        
        // Startup ID
        if([UtilityClass getProfileMode] == PROFILE_MODE_SEARCH) {
            [dictParam setObject:[NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:selectedStarupIndex] valueForKey:@"id"]]  forKey:kAddContractorAPI_StartupID] ;
        }
        else {
            [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getContractorDetails] valueForKey:kRecommendedContAPI_StartupID]] forKey:kAddContractorAPI_StartupID] ;
        }
        
        // Role ID
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[roleArray objectAtIndex:selectedRoleIndex] valueForKey:@"id"]] forKey:kAddContractorAPI_ContractorRoleID] ;
        
        // Hourly Rate
        [dictParam setObject:[NSString stringWithFormat:@"%@",hourlyRateTxtFld.amount] forKey:kAddContractorAPI_HourlyPrice] ;
        
        // Deliverables
        [dictParam setObject:[UtilityClass convertTagsArrayToStringforArray:selectedDeliverablesArray withTagsArray:deliverablesArray] forKey:kAddContractorAPI_RoadmapID] ;
        
        // Work Units Allocated
        [dictParam setObject:[workUnitsAllocatedTxtFld.text stringByReplacingOccurrencesOfString:@"," withString:@""] forKey:kAddContractorAPI_WorkUnitsAllocated] ;
        
        // Work Units Approved
        [dictParam setObject:[workUnitsApprovedTxtFld.text stringByReplacingOccurrencesOfString:@"," withString:@""] forKey:kAddContractorAPI_WorkUnitsApproved] ;
        
        // Target Completion Date
        [dictParam setObject:[NSString stringWithFormat:@"%@",targetCompletionDateTxtFld.text] forKey:kAddContractorAPI_TargetCompletionDate] ;
        
        // Hired By
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAddContractorAPI_HiredBy] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap addContractorWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"0" withDuration:1] ;
                //[self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil] ;
                [UtilityClass setAdddContractorStatus:YES] ;
                [self.navigationController popViewControllerAnimated:YES] ;
            }
            //else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"0" withDuration:1] ;
                [self.navigationController popViewControllerAnimated:YES] ;
            }
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getDeliverables {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [ApiCrowdBootstrap getDeliverables:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                if([responseDict objectForKey:kDeliverablesAPI_Deliverables]) {
                    
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:kDeliverablesAPI_Deliverables] mutableCopy]) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:[dict mutableCopy]] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        [deliverablesArray addObject:obj] ;
                    }
                }
            }
            //else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMemberRoles {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [ApiCrowdBootstrap getMemberRoles:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                
                if([responseDict objectForKey:kAddContractorAPI_Roles]) {
                    for (NSDictionary *dict in (NSArray*)[responseDict objectForKey:kAddContractorAPI_Roles]) {
                        NSString *roleID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]] ;
                        if(![roleID isEqualToString:@"1"]) {
                            if([UtilityClass getProfileMode] != PROFILE_MODE_RECOMMENDED) [roleArray addObject:dict] ;
                            else{
                                NSString *role = [NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]] ;
                                NSLog(@"role: %@",role) ;
                                if([[UtilityClass getTeamMemberRole] isEqualToString:TEAM_TYPE_ENTREPRENEUR]) {
                                    [roleArray addObject:dict] ;
                                }
                                else if([[UtilityClass getTeamMemberRole] isEqualToString:TEAM_TYPE_COFOUNDER]) {
                                    if([role isEqualToString:TEAM_TYPE_CONTRACTOR] || [role isEqualToString:TEAM_TYPE_TEAM_MEMEBER]) {
                                        [roleArray addObject:dict] ;
                                    }
                                }
                                else if([[UtilityClass getTeamMemberRole] isEqualToString:TEAM_TYPE_TEAM_MEMEBER]) {
                                    if([role isEqualToString:TEAM_TYPE_CONTRACTOR]) {
                                        [roleArray addObject:dict] ;
                                    }
                                }
                            }
                        }
                    }
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

-(void)getStartups {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileUserStartupApi_UserID] ;
        [dictParam setObject:ENTREPRENEUR_TEXT forKey:kProfileUserStartupApi_UserType] ;
        
        [ApiCrowdBootstrap getUserStartupsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                if([responseDict objectForKey:kProfileUserStartupApi_StartupData]) {
                    startupsArray = [NSMutableArray arrayWithArray:(NSArray*)[[responseDict objectForKey:kProfileUserStartupApi_StartupData] mutableCopy]] ;
                    
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

#pragma mark - Tap gesture
- (void)txtViewTapped_Gesture:(UITapGestureRecognizer *)gestureRecognizer {
    [self openTagsPopup] ;
}

#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

-(void)tagsControl:(UIView *)tag withTagControlIndex:(NSInteger)tagControlIndex removedFromIndex:(NSInteger)index {
    NSLog(@"index: %ld control: %ld", (long)index,(long)tagControlIndex);
    [tag removeFromSuperview];
    NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedDeliverablesArray objectAtIndex:index]] ;
    for (int i=0; i<deliverablesArray.count; i++) {
        NSString *deliverableName = [NSString stringWithFormat:@"%@",[[deliverablesArray objectAtIndex:i] valueForKey:@"name"]] ;
        if([deliverableName isEqualToString:selectedName]) {
            [[deliverablesArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
            break ;
        }
    }
    [selectedDeliverablesArray removeObjectAtIndex:index] ;
    
    [self initializeDeliverableTagsView] ;
    
}

#pragma mark - IBAction Methods
- (IBAction)AddTag_ClickAction:(id)sender {
    [self openTagsPopup] ;
}

- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)CalendarDate_ClickAction:(id)sender {
    if (![targetCompletionDateTxtFld.text isEqualToString:@""])
        [datePickerView setDate:[dateFormatter dateFromString:targetCompletionDateTxtFld.text] animated:YES] ;
    else
        [datePickerView setMinimumDate:[NSDate date]] ;
    [targetCompletionDateTxtFld becomeFirstResponder] ;
}

- (IBAction)Assign_ClickAction:(id)sender {
    
    if([UtilityClass getProfileMode] == PROFILE_MODE_SEARCH && selectedStarupIndex == -1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Contractor_Startup] animated:YES completion:nil] ;
        return ;
    }
    else if(selectedRoleIndex == -1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Contractor_Role] animated:YES completion:nil] ;
        return ;
    }
    else if(selectedDeliverablesArray.count == 0) {
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Contractor_Deliverable] animated:YES completion:nil] ;
        return ;
    }
    else if(hourlyRateTxtFld.amount == 0) {
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Contractor_Hours] animated:YES completion:nil] ;
        return ;
    }
    else if(workUnitsAllocatedTxtFld.text.length < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Contractor_Allocated] animated:YES completion:nil] ;
        return ;
    }
    else if(workUnitsApprovedTxtFld.text.length < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Contractor_Approved] animated:YES completion:nil] ;
        return ;
    }
    else if(targetCompletionDateTxtFld.text.length < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Target_Completion_Date] animated:YES completion:nil] ;
        return ;
    }
    
    else {
        
        int workUnitsAllocated = [[workUnitsAllocatedTxtFld.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
        int workUnitsApproved = [[workUnitsApprovedTxtFld.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] ;
        if( workUnitsApproved > workUnitsAllocated) {
            [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Contractor_AllocatedMax] animated:YES completion:nil] ;
            return ;
        }
        else{
            [self addContractor] ;
        }
        
    }
}

- (IBAction)openPickerView_ClickAction:(id)sender {
    selecedPickerViewType = (int)[sender tag] ;
    if(selecedPickerViewType == STARTUP_SELECTED)[selectStartupTxtFld becomeFirstResponder] ;
    else [roleTxtFld becomeFirstResponder] ;
    
}


- (IBAction)CheckUncheck_ClickAction:(id)sender {
    UIButton *btn = (UIButton*)sender ;
    if([btn.accessibilityLabel isEqualToString:CHECK_IMAGE ]){ // Check
        [btn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = UNCHECK_IMAGE ;
        [[deliverablesArray objectAtIndex:btn.tag] setValue:@"0" forKey:@"isSelected"] ;
    }
    else{ // Uncheck
        
        [btn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = CHECK_IMAGE ;
        [[deliverablesArray objectAtIndex:btn.tag] setValue:@"1" forKey:@"isSelected"] ;
    }
}

- (IBAction)Ok_ClickAction:(id)sender {
    //    [popupView dismissPresentingPopup] ;
    [popupView removeFromSuperview];
    [selectedDeliverablesArray removeAllObjects] ;
    for (NSMutableDictionary *obj in deliverablesArray) {
        NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
        if([isSelectedStr isEqualToString:@"1"])
            [selectedDeliverablesArray addObject:[obj valueForKey:@"name"]] ;
    }
    [self initializeDeliverableTagsView] ;
}

#pragma mark - Toolbar Buttons Methods
- (IBAction)NumberToolbarButtons_ClickAction:(id)sender {
    [self.view endEditing:YES] ;
}

- (IBAction)toolbarButtons_ClickAction:(id)sender {
    [selectStartupTxtFld resignFirstResponder] ;
    [roleTxtFld resignFirstResponder] ;
    
    if([sender tag] == DONE_CLICKED) {
        if(selecedPickerViewType == STARTUP_SELECTED) {
            
            if([pickerView selectedRowInComponent:0] == 0) {
                selectStartupTxtFld.text = @""  ;
                selectedStarupIndex = -1  ;
            }
            else {
                selectStartupTxtFld.text = [[startupsArray objectAtIndex:[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"]  ;
                selectedStarupIndex = (int)[pickerView selectedRowInComponent:0]-1 ;
            }
        }
        else{
            if([pickerView selectedRowInComponent:0] == 0) {
                roleTxtFld.text = @""  ;
                selectedRoleIndex = -1  ;
            }
            else {
                roleTxtFld.text = [[roleArray objectAtIndex:[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"]  ;
                selectedRoleIndex = (int)[pickerView selectedRowInComponent:0]-1 ;
            }
        }
    }
    else{
        if(selecedPickerViewType == STARTUP_SELECTED) {
            if(selectedStarupIndex != -1) selectStartupTxtFld.text = [[startupsArray objectAtIndex:selectedStarupIndex] valueForKey:@"name"]  ;
            else selectStartupTxtFld.text = @"" ;
        }
        else {
            if(selectedRoleIndex != -1) roleTxtFld.text = [[roleArray objectAtIndex:selectedRoleIndex] valueForKey:@"name"]  ;
            else roleTxtFld.text = @"" ;
        }
    }
}

- (IBAction)DatePickerToolbarButtons_ClickAction:(id)sender {
    [targetCompletionDateTxtFld resignFirstResponder] ;
    if([sender tag] == DONE_CLICKED) {
        targetCompletionDateTxtFld.text = [dateFormatter stringFromDate:datePickerView.date];
    }
    else {
        targetCompletionDateTxtFld.text = prevTargetDate;
    }
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Picker View Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1 ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(selecedPickerViewType == STARTUP_SELECTED) return startupsArray.count+1 ;
    else return roleArray.count+1 ;
    
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(selecedPickerViewType == STARTUP_SELECTED) {
        if(row == 0) return @"Select Startup" ;
        else return [[startupsArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    else {
        if(row == 0) return @"Select Role" ;
        else return [[roleArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(selecedPickerViewType == STARTUP_SELECTED) {
        if(row == 0) selectStartupTxtFld.text = @"" ;
        else selectStartupTxtFld.text = [[startupsArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    else{
        if(row == 0) roleTxtFld.text = @"" ;
        else roleTxtFld.text = [[roleArray objectAtIndex:row-1] valueForKey:@"name"]  ;
    }
}

#pragma mark - DatePicker Value Changed
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    if(selectedDatePickerType == TARGET_DATE_SELECTED) targetCompletionDateTxtFld.text = strDate;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return deliverablesArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaymentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keywordsCell"] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.companyNameLbl.text = [[deliverablesArray objectAtIndex:indexPath.row] valueForKey:@"name"] ;
    cell.checkboxBtn.tag = indexPath.row ;
    if([[NSString stringWithFormat:@"%@",[[deliverablesArray objectAtIndex:indexPath.row] valueForKey:@"isSelected"]] isEqualToString:@"0" ]) { // Check
        [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
    }
    else { // Uncheck
        
        [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
    }
    return cell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50 ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Roadmap Deliverables" ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == popupTblView) {
        PaymentsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
        [self CheckUncheck_ClickAction:cell.checkboxBtn] ;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // if you have index/header text in your tableview change your index text color
    UITableViewHeaderFooterView *headerIndexText = (UITableViewHeaderFooterView *)view;
    [headerIndexText.textLabel setTextColor:[UtilityClass blueColor]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30 ;
}

#pragma mark - TextField Delegate Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if([textField isEqual: targetCompletionDateTxtFld])
        prevTargetDate = targetCompletionDateTxtFld.text ;
    
    _selectedItem = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
    
    if([textField isEqual:hourlyRateTxtFld]) [workUnitsAllocatedTxtFld becomeFirstResponder];
    else if([textField isEqual:workUnitsAllocatedTxtFld]) [workUnitsApprovedTxtFld becomeFirstResponder] ;
    else
        [targetCompletionDateTxtFld becomeFirstResponder];
    return YES ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([textField isEqual:selectStartupTxtFld])selecedPickerViewType = STARTUP_SELECTED ;
    else if([textField isEqual:roleTxtFld]) selecedPickerViewType = ROLE_SELECTED ;
    else if([textField isEqual:targetCompletionDateTxtFld]) selectedDatePickerType = TARGET_DATE_SELECTED ;
    else if([textField isEqual:hourlyRateTxtFld]) doneBarButton.title = kToolbar_NextButton ;
    else if([textField isEqual:workUnitsAllocatedTxtFld]) doneBarButton.title = kToolbar_NextButton ;
    else if([textField isEqual:workUnitsApprovedTxtFld]) doneBarButton.title = kToolbar_DoneButton ;
    
    _selectedItem=textField;
    return YES ;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    _selectedItem = nil ;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == workUnitsAllocatedTxtFld || textField == workUnitsApprovedTxtFld) {
        NSRange illegalCharacterEntered = [string rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
        if ( illegalCharacterEntered.location != NSNotFound ) {
            return NO;
        }
    }
    
    return YES;
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

-(void)moveToOriginalFrame {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)formatNumberIfNeeded:(UITextField *)textField {
    // you'll need to strip the commas for the formatter to work properly
    NSString * currentTextWithoutCommas = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSNumber * numberFromString = [numberFormatter numberFromString:currentTextWithoutCommas];
    NSString * formattedNumberString = [numberFormatter stringFromNumber:numberFromString];
    
    textField.text = formattedNumberString;
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
