//
//  Timesheet_StartupViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 20/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "WorkOrder_ContractorViewController.h"


@interface WorkOrder_ContractorViewController ()

@end

@implementation WorkOrder_ContractorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self resetUISettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

#pragma mark - Custom Methods
- (void)singleTap:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}

-(void)resetUISettings {
    workOrderView.hidden = YES ;
    
    daysArray = @[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"] ;
    totalWorkUnitsArray = @[@"Total",@"Remaining",@"Allocated"] ;
    deliverablesArray = [[NSMutableArray alloc] init] ;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    vertexText =  [formatter stringFromDate:[NSDate date]];
    
    [datePickerView setMaximumDate:[NSDate date]] ;
    [datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    prevDueDate = @"";
    selectedDeliverableIndex = -1 ;
    
    changeDateTxtFld = [[UITextField alloc] initWithFrame:CGRectMake(0, tableView.frame.origin.y, 1, 0)] ;
    [self.view addSubview:changeDateTxtFld] ;
    changeDateTxtFld.delegate = self ;
    changeDateTxtFld.inputView = datePickerViewContainer ;
    
    [UtilityClass setTextViewBorder:enterpreneurCommentTxtVw] ;
    [UtilityClass setTextViewBorder:contractorCommentTxtVw] ;
    [enterpreneurCommentTxtVw setEditable:NO];
    [ratingsView setUserInteractionEnabled:NO];
    
    if([UtilityClass getStartupType] == COMPLETEED_SELECTED)
        [self resetUIAccordingToStartupType:YES] ;
    else
        [self resetUIAccordingToStartupType:NO] ;
    
    // Get Workorder data for Current/Completed Startups
    if([UtilityClass getStartupWorkOrderType] == YES && !([UtilityClass getStartupType] == MY_STARTUPS_SELECTED))
        [self getWorkOrdersDataWithDate:[formatter stringFromDate:[NSDate date]]] ;

    // reset scrolling
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startupWorkOrderDataNotification:)
                                                 name:kNotificationStartupWorkOrderCont
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(NSString*)addWorkUnitsAccrodingToDeliverablesForDate:(NSMutableArray*)array forDelievreable:(NSString*)deliverableName {
    NSString *workUnits = @"0" ;
    for (int i=0; i<array.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] valueForKey:kStartupWorkOrderContAPI_DeliverableName]] ;
        if([str isEqualToString:deliverableName]) {
            workUnits = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] valueForKey:kStartupWorkOrderContAPI_WorkUnits]] ;
            return workUnits ;
        }
    }
    return workUnits ;
}

-(NSString*)getTotalHoursForDeliverable:(NSString*)deliverableName {
    int hoursLogged = 0 ;
    for (NSDictionary *dict in weeklyUpdateArray) {
        NSArray *deliverablesArrayForDate = [dict valueForKey:kStartupWorkOrderContAPI_Deliverables] ;
        for (NSDictionary *obj in deliverablesArrayForDate) {
            NSString *name = [obj valueForKey:kStartupWorkOrderContAPI_DeliverableName] ;
            if([name isEqualToString:deliverableName]){
                if(![[NSString stringWithFormat:@"%@",[obj valueForKey:kStartupWorkOrderContAPI_WorkUnits]] isEqualToString:@""] && ![[NSString stringWithFormat:@"%@",[obj valueForKey:kStartupWorkOrderContAPI_WorkUnits]] isEqualToString:@" "] )
                    hoursLogged = hoursLogged + [[obj valueForKey:kStartupWorkOrderContAPI_WorkUnits] intValue] ;
            }
        }
    }
    return [NSString stringWithFormat:@"%d",hoursLogged] ;
 }

-(NSString*)formatDateToString {
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    return stringFromDate ;
}

-(void)resetUIAccordingToStartupType:(BOOL)setHidden {
    updateButton.hidden = setHidden ;
    downloadButton.hidden = setHidden ;
}

-(void)renderGridView {
    
    // remove previous view
    for (UIView* b in workOrderView.subviews)
    {
        [b removeFromSuperview];
    }
    workOrderView.hidden = YES;
    
    if(deliverablesArray.count > 0) {
        // Update Deliverables Array
        headData = [[NSMutableArray alloc] init] ;
        for (NSDictionary *dict in deliverablesArray) {
            [headData addObject:[dict valueForKey:kStartupWorkOrderContAPI_DeliverableName]] ;
        }
        
        // Update Dates Array
        NSDate *dateTemp = [[NSDate alloc] init];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        datesArray = [[NSMutableArray alloc] init] ;
        for(int i = 0 ; i < weeklyUpdateArray.count ; i++) {
           /* if([daysArray objectAtIndex:i])[datesArray addObject:[NSString stringWithFormat:@"%@\n%@",[daysArray objectAtIndex:i],[[weeklyUpdateArray objectAtIndex:i] valueForKey:kStartupWorkOrderContAPI_Date]]] ;*/
            
            if([daysArray objectAtIndex:i]){
               // NSString *str = [NSString stringWithFormat:@"%@\n%@",[daysArray objectAtIndex:i],[[weeklyUpdateArray objectAtIndex:i] valueForKey:kStartupWorkOrderContAPI_Date]] ;
                
                NSString *str = [NSString stringWithFormat:@"%@",[[weeklyUpdateArray objectAtIndex:i] valueForKey:kStartupWorkOrderContAPI_Date]] ;
               
                dateTemp = [dateFormat dateFromString:str];
                [datesArray addObject: [NSString stringWithFormat:@"%@\n%@",[daysArray objectAtIndex:i],[formatter stringFromDate:dateTemp]]] ;
            }
        }
        [datesArray addObjectsFromArray:totalWorkUnitsArray] ;
        
        leftTableData = [NSMutableArray arrayWithCapacity:datesArray.count];
        NSMutableArray *one = [NSMutableArray arrayWithCapacity:datesArray.count];
        for (int i = 0; i < datesArray.count; i++) {
            [one addObject:[NSString stringWithFormat:@"%@", [datesArray objectAtIndex:i]]];
        }
        [leftTableData addObject:one];
        
        rightTableData = [NSMutableArray arrayWithCapacity:deliverablesArray.count];
        NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:deliverablesArray.count];
        for (int i = 0; i < datesArray.count; i++) {
            NSMutableArray *ary = [[NSMutableArray alloc] init] ;
            for (int j = 0; j < deliverablesArray.count; j++) {
                if(i < weeklyUpdateArray.count) {
                    [ary addObject:[self addWorkUnitsAccrodingToDeliverablesForDate:(NSMutableArray*) [[weeklyUpdateArray objectAtIndex:i] valueForKey:kStartupWorkOrderContAPI_Deliverables] forDelievreable:[[deliverablesArray objectAtIndex:j] valueForKey:kStartupWorkOrderContAPI_DeliverableName]]];
                }
                else {
                    // Total Hours
                    if(i == weeklyUpdateArray.count) {
                        [ary addObject:[self getTotalHoursForDeliverable:[[deliverablesArray objectAtIndex:j] valueForKey:kStartupWorkOrderContAPI_DeliverableName]]] ;
                    }
                    // Remaining Hours
                    else if(i == weeklyUpdateArray.count+1) {
                        if(j == 0) [ary addObject:[NSString stringWithFormat:@"%d",approvedHours-consumedHours]] ;
                        else [ary addObject:@"-"] ;
                    }
                    // Allocated Hours
                    else if(i == datesArray.count -1) {
                        if(j == 0) [ary addObject:[NSString stringWithFormat:@"%d",approvedHours]] ;
                        else [ary addObject:@"-"] ;
                    }
                }
            }
            [oneR addObject:ary];
        }
        
        [rightTableData addObject:oneR];
        
        XCMultiTableView *xctableView = [[XCMultiTableView alloc] initWithFrame:CGRectInset(workOrderView.bounds, 5.0f, 5.0f)];
        xctableView.leftHeaderEnable = YES;
        xctableView.leftHeaderWidth = 130 ;
        xctableView.normalSeperatorLineWidth = 0 ;
        xctableView.boldSeperatorLineWidth = 0 ;
        xctableView.datasource = self;
        xctableView.delegate = self;
        xctableView.isEditableEnable = NO ;
        [workOrderView addSubview:xctableView];
        
        if(weeklyUpdateArray.count > 0) {
            workOrderView.hidden = NO ;
            noWorkOrderLbl.hidden = YES ;
            commentView.hidden = NO;
        }
        else {
            workOrderView.hidden = YES ;
            commentView.hidden = YES;
            noWorkOrderLbl.hidden = NO ;
        }
        
        NSNumber *isContractorEditable = [responseDictionary valueForKey:@"is_editable"];
        if ([isContractorEditable isEqual:@(0)]) {
            [contractorCommentTxtVw setUserInteractionEnabled:NO];
            [submitBtn setUserInteractionEnabled:NO];
        } else {
            [contractorCommentTxtVw setUserInteractionEnabled:YES];
            [submitBtn setUserInteractionEnabled:YES];
        }
    }
}

/*-(void)renderGridView {
    
    headData = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4"]] ;
    datesArray = @[@"Mon\nFeb 22, 2016",@"Tue\nFeb 23, 2016",@"Wed\nFeb 24, 2016",@"Thu\nFeb 25, 2016",@"Fri\nFeb 26, 2016",@"Sat\nFeb 27, 2016",@"Sun\nFeb 28, 2016",@"Total",@"Remaining",@"Allocated"];
    
    leftTableData = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *one = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < datesArray.count; i++) {
        [one addObject:[NSString stringWithFormat:@"%@", [datesArray objectAtIndex:i]]];
    }
    [leftTableData addObject:one];
   
    
    rightTableData = [NSMutableArray arrayWithCapacity:10];
    
    NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < datesArray.count; i++) {
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
        for (int j = 0; j < 5; j++) {
            if (j == 1) {
                [ary addObject:[NSNumber numberWithInt:random() % 5]];
            }else if (j == 2) {
                [ary addObject:[NSNumber numberWithInt:random() % 10]];
            }
            else {
                [ary addObject:[NSString stringWithFormat:@"%d", i]];
            }
        }
        [oneR addObject:ary];
    }
    [rightTableData addObject:oneR];
    
    
    tableView = [[XCMultiTableView alloc] initWithFrame:CGRectInset(workOrderView.bounds, 5.0f, 5.0f)];
    tableView.leftHeaderEnable = YES;
    tableView.leftHeaderWidth = 130 ;
    tableView.normalSeperatorLineWidth = 0 ;
    tableView.boldSeperatorLineWidth = 0 ;
    tableView.datasource = self;
    tableView.delegate = self;
    [workOrderView addSubview:tableView];
    
    workOrderView.hidden = NO ;
    
}*/

#pragma mark - Notifcation Methods
- (void)startupWorkOrderDataNotification:(NSNotification *) notification
{
    self.dictionaryIDs = notification.object;
    
    if ([[notification name] isEqualToString:kNotificationStartupWorkOrderCont]) {
        
        [self getWorkOrdersDataWithDate:[formatter stringFromDate:[NSDate date]]] ;
    }
}

-(NSString*)getWeekdayFromDate:(NSString*)dateStr {
   
    NSDate *date = [formatter dateFromString:dateStr];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    
    NSInteger weekday = [components weekday];
    NSString *weekdayName = [formatter weekdaySymbols][weekday - 1];
    weekdayName = [weekdayName substringToIndex:3] ;
    return weekdayName ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    _selectedItem = textView;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    _selectedItem = nil ;
}

#pragma mark - Api Methods
-(void)getWorkOrdersDataWithDate:(NSString*)dateStr {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupWorkOrderContAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:kStartupWorkOrderContAPI_StartupID] ;
        [dictParam setObject:dateStr forKey:kStartupWorkOrderContAPI_Date] ;
        [dictParam setObject:[self getWeekdayFromDate:dateStr] forKey:kStartupWorkOrderContAPI_Day] ;
        [dictParam setObject:[self.dictionaryIDs valueForKey:kStartupWorkOrderContAPI_Startup_TeamID] forKey:kStartupWorkOrderContAPI_Startup_TeamID];
        [dictParam setObject:[self.dictionaryIDs valueForKey:kStartupWorkOrderContAPI_EnterpreneurID] forKey:kStartupWorkOrderContAPI_EnterpreneurID];
        [dictParam setObject:[self.dictionaryIDs valueForKey:kStartupWorkOrderContAPI_ContractorID] forKey:kStartupWorkOrderContAPI_ContractorID];
        [dictParam setObject:[self.dictionaryIDs valueForKey:kStartupWorkOrderContAPI_IsEnterpreneur] forKey:kStartupWorkOrderContAPI_IsEnterpreneur];

        //[dictParam setObject:@"12 Apr, 2016" forKey:kStartupWorkOrderContAPI_Date] ;
        //[dictParam setObject:@"Tue" forKey:kStartupWorkOrderContAPI_Day] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getStartupWorkOrderContractorWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            responseDictionary = responseDict;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
               
                // Save startup_team ID in User Defaults
                NSString *startup_teamID = [responseDict valueForKey:kStartupWorkOrderContAPI_Startup_TeamID];
                [[NSUserDefaults standardUserDefaults] setValue:startup_teamID forKey:kStartupWorkOrderContAPI_Startup_TeamID];
                
                // Set Rating/Comments for Contractor given by Enterpreneur
                [ratingsView setValue:[[responseDict valueForKey:@"entrepreneur_rating_star"] floatValue]] ;
                [contractorCommentTxtVw setText:[responseDict valueForKey:@"contractor_comment"]];
                [enterpreneurCommentTxtVw setText:[responseDict valueForKey:@"entrepreneur_comment"]];

                if([responseDict valueForKey:kStartupWorkOrderContAPI_AllocatedHours]){
                    allocatedHours = [[responseDict valueForKey:kStartupWorkOrderContAPI_AllocatedHours] intValue] ;
                }
                
                if([responseDict valueForKey:kStartupWorkOrderContAPI_ApprovedHours]) {
                    approvedHours = [[responseDict valueForKey:kStartupWorkOrderContAPI_ApprovedHours] intValue] ;
                }
                
                if([responseDict valueForKey:kStartupWorkOrderContAPI_ConsumedHours]) {
                    consumedHours = [[responseDict valueForKey:kStartupWorkOrderContAPI_ConsumedHours] intValue] ;
                }
                
                if([responseDict valueForKey:kStartupWorkOrderContAPI_MainDeliverable]) {
                    deliverablesArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict valueForKey:kStartupWorkOrderContAPI_MainDeliverable]] ;
                }
                
                if([responseDict valueForKey:kStartupWorkOrderContAPI_WeeklyUpdate]) {
                    weeklyUpdateArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict valueForKey:kStartupWorkOrderContAPI_WeeklyUpdate]] ;
                }
              
                [self renderGridView] ;
            }
            // else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

/*-(void)updateWorkOrder{
    if([UtilityClass checkInternetConnection]){
        
       [UtilityClass showHudWithTitle:kHUDMessage_UpdateWorkOrder] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        int approvedWorkUnits  = 0 ;
        int pendingWorkUnits   = 0 ;
        if(consumedHours > approvedHours){
            pendingWorkUnits = [workUnitsTxtFld.text intValue]  ;
            approvedWorkUnits = 0 ;
        }
        else{
            approvedHours = approvedHours - consumedHours ;
            int remainingWorkUnits = approvedHours - [workUnitsTxtFld.text intValue] ;
            
            if(remainingWorkUnits >= 0){
                approvedWorkUnits = [workUnitsTxtFld.text intValue] ;
                pendingWorkUnits = 0 ;
            }
            else{
                pendingWorkUnits = [workUnitsTxtFld.text intValue] - approvedHours ;
                approvedWorkUnits = approvedHours ;
            }
        }
        
        NSLog(@"pendingWorkUnits: %d approvedWorkUnits:%d",pendingWorkUnits,approvedWorkUnits) ;
        
        NSMutableDictionary *approvedDict = [[NSMutableDictionary alloc] init] ;
        if(approvedWorkUnits != 0){
            [approvedDict setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kUpdateWorkOrderAPI_UserID] ;
            [approvedDict setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:kUpdateWorkOrderAPI_StartupID] ;
            [approvedDict setObject:[NSString stringWithFormat:@"%@",[[deliverablesArray objectAtIndex:selectedDeliverableIndex] valueForKey:kStartupWorkOrderContAPI_DeliverableID]] forKey:kUpdateWorkOrderAPI_RoadmapID] ;
            [approvedDict setObject:dateTxtFld.text forKey:kUpdateWorkOrderAPI_Date] ;
            [approvedDict setObject:[NSString stringWithFormat:@"%d",approvedWorkUnits] forKey:kUpdateWorkOrderAPI_WorkUnits] ;
        }
        
        [dictParam setObject:approvedDict forKey:kUpdateWorkOrderAPI_Approved] ;
        
        NSMutableDictionary *pendingDict = [[NSMutableDictionary alloc] init] ;
        if(pendingWorkUnits != 0){
            [pendingDict setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kUpdateWorkOrderAPI_UserID] ;
            [pendingDict setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:kUpdateWorkOrderAPI_StartupID] ;
            [pendingDict setObject:[NSString stringWithFormat:@"%@",[[deliverablesArray objectAtIndex:selectedDeliverableIndex] valueForKey:kStartupWorkOrderContAPI_DeliverableID]] forKey:kUpdateWorkOrderAPI_RoadmapID] ;
            [pendingDict setObject:dateTxtFld.text forKey:kUpdateWorkOrderAPI_Date] ;
            [pendingDict setObject:[NSString stringWithFormat:@"%d",pendingWorkUnits]  forKey:kUpdateWorkOrderAPI_WorkUnits] ;
        }
        
        [dictParam setObject:pendingDict forKey:kUpdateWorkOrderAPI_Pending] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap updateStartupWorkOrderWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"0" withDuration:1] ;
                
                // refresh fields
                delierableLbl.text = kSelectDeliverableDefault ;
                selectedDeliverableIndex = -1 ;
                dateTxtFld.text = [formatter stringFromDate:[NSDate date]] ;
                workUnitsTxtFld.text = @"" ;
                
                [self getWorkOrdersDataWithDate:[formatter stringFromDate:datePickerView.date]] ;
                
            }
            // else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}*/

- (IBAction)DatePickerToolbarButtons_ClickAction:(id)sender {
    [changeDateTxtFld resignFirstResponder] ;
    
    if([sender tag] == DONE_CLICKED) {
        if(selectedDatePickerMode == WORKORDER_DATE_SELECTED) {
            vertexText = [formatter stringFromDate:datePickerView.date] ;
            [self getWorkOrdersDataWithDate:[formatter stringFromDate:datePickerView.date]] ;
        }
    }
}

-(void)addContractorComments {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        // Given To(Enterpreneur ID)
        [dictParam setObject:[responseDictionary valueForKey:kStartupWorkOrderContAPI_EnterpreneurID] forKey:kAddCommentAPI_GivenTo] ;
        // Given By(Contractor ID)
        [dictParam setObject:[responseDictionary valueForKey:kStartupWorkOrderContAPI_ContractorID] forKey:kAddCommentAPI_GivenBy] ;
        // Work Comment
        [dictParam setObject:contractorCommentTxtVw.text forKey:kAddCommentAPI_WorkComment] ;
        // Rating Star
        [dictParam setValue:@"0" forKey:kAddRatingsAPI_RatingStar] ;
        // Week No.
        [dictParam setObject:[responseDictionary valueForKey:kStartupWorkOrderContAPI_WeekNumber] forKey:kAddCommentAPI_WeekNo] ;
        //Startup ID
        [dictParam setObject:[responseDictionary valueForKey:kStartupWorkOrderContAPI_StartupID] forKey:kAddCommentAPI_StartupId] ;
        //Startup Team ID
        [dictParam setObject:[responseDictionary valueForKey:kStartupWorkOrderContAPI_Startup_TeamID] forKey:kAddCommentAPI_Startup_team_id] ;
        //Status
        [dictParam setObject:@"1" forKey:kAddCommentAPI_Status] ;
        //Is Enterpreneur/Contractor
        [dictParam setObject:@"0" forKey:kAddCommentAPI_IsEnterpreneur] ;

        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap submitWorkorderRatingsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            NSLog(@"responseDict: %@",responseDict) ;
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil] ;
            }
            else if([responseDict objectForKey:@"errors"]){
                NSDictionary *errorsData = (NSDictionary*)[responseDict objectForKey:@"errors"] ;
                NSString *errorStr = @"" ;
                for (NSString *value in [errorsData allValues]) {
                    errorStr = [NSString stringWithFormat:@"%@\n%@",errorStr,value] ;
                }
                if(![errorStr isEqualToString:@""])[self presentViewController:[UtilityClass displayAlertMessage:errorStr] animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - DatePicker Value Changed
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSString *strDate = [formatter stringFromDate:datePicker.date];
}

#pragma mark - IBAction Methods
- (IBAction)UpdateWorkOder_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"UpdateWorkOrder"] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    
    
    /*if(selectedDeliverableIndex == -1){
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_DeliverableReq] animated:YES completion:nil ];
        return ;
    }
    if(dateTxtFld.text.length < 1){
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_DateReq] animated:YES completion:nil ];
        return ;
    }
    if(workUnitsTxtFld.text.length < 1){
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_WorkUnitsReq] animated:YES completion:nil ];
        return ;
    }
    
    [self updateWorkOrder] ;*/
}

- (IBAction)DownloadWorkOrder_ClickAction:(id)sender {
    
}

- (IBAction)submitComment_ClickAction:(id)sender {
    if(contractorCommentTxtVw.text.length < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Work_Comment] animated:YES completion:nil] ;
        return ;
    } else {
        [self addContractorComments];
    }
}

- (IBAction)StarRating_ValueChanged:(HCSStarRatingView*)sender {
    NSLog(@"Changed rating to %.1f", sender.value);
}

#pragma mark - Vertex tapped gesture
-(void)vertexTapped:(NSString *)name{
    selectedDatePickerMode = WORKORDER_DATE_SELECTED ;
    [changeDateTxtFld becomeFirstResponder] ;
}

#pragma mark - XCMultiTableViewDataSource
- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView {
    return [headData copy];
}
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [leftTableData objectAtIndex:section];
}

- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [rightTableData objectAtIndex:section];
}

- (NSUInteger)numberOfSectionsInTableView:(XCMultiTableView *)tableView {
    return [leftTableData count];
}

- (AlignHorizontalPosition)tableView:(XCMultiTableView *)tableView inColumn:(NSInteger)column {
    return AlignHorizontalPositionCenter;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column {
    return 130 ;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section {
    if (section == 0) {
        return 60.0f;
    }else {
        return 60.0f;
    }
}

- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column {
    if(column == -1) return [UIColor lightGrayColor];
    else return [UIColor clearColor];
}

- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column {
    if (column == -1) {
        return [UtilityClass greenColor];
    }else  {
        return [UtilityClass blueColor];
    }
}

- (NSString *)vertexName {
    return vertexText ;
}

#pragma mark - XCMultiTableViewDelegate
- (void)tableViewWithType:(MultiTableViewType)tableViewType didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"section: %ld selectedIndexPath: %ld",(long)indexPath.section , (long)indexPath.row);
}

- (void) updateGridViewContent:(NSIndexPath *)indexPath withIndex:(int)index withContent:(NSString *)content {
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
