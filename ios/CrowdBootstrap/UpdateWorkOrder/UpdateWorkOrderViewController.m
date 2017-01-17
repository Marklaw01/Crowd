//
//  UpdateWorkOrderViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 31/08/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "UpdateWorkOrderViewController.h"

@interface UpdateWorkOrderViewController ()

@end

@implementation UpdateWorkOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self resetUISettings] ;
    [self getWorkOrdersDataWithDate:[formatter stringFromDate:[NSDate date]]] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)singleTap:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}

#pragma mark - Custom Methods
-(void)resetUISettings {
    
    self.title = [NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupsAPI_StartupName]] ;
    
    workOrderView.hidden = YES ;
    daysArray = @[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"] ;
    totalWorkUnitsArray = @[@"Total",@"Remaining",@"Allocated"] ;
    deliverablesArray = [[NSMutableArray alloc] init] ;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    vertexText =  [formatter stringFromDate:[NSDate date]];
    
    [UtilityClass setTextFieldBorder:deliverableTxtFld] ;
    [UtilityClass setTextFieldBorder:dateTxtFld] ;
    [UtilityClass setTextFieldBorder:workUnitsTxtFld] ;
    
    [UtilityClass addMarginsOnTextField:deliverableTxtFld] ;
    // [UtilityClass addMarginsOnTextField:dateTxtFld] ;
    [UtilityClass addMarginsOnTextField:workUnitsTxtFld] ;
    
    [dateTxtFld setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [workUnitsTxtFld setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    workUnitsTxtFld.inputAccessoryView = numberToolBar ;
    deliverableTxtFld.inputView = pickerViewContainer ;
    dateTxtFld.inputView = datePickerViewContainer ;
    [datePickerView setMaximumDate:[NSDate date]] ;
    [datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    prevDueDate = @"";
    selectedDeliverableIndex = -1 ;
    dateTxtFld.text = [formatter stringFromDate:[NSDate date]] ;
    
    changeDateTxtFld = [[UITextField alloc] initWithFrame:CGRectMake(0, tableView.frame.origin.y, 1, 0)] ;
    changeDateTxtFld.backgroundColor = [UIColor yellowColor] ;
    [self.view addSubview:changeDateTxtFld] ;
    //changeDateTxtFld.delegate = self ;
    changeDateTxtFld.inputView = datePickerViewContainer ;
    
    
    if([UtilityClass getStartupType] == COMPLETEED_SELECTED) [self resetUIAccordingToStartupType:YES] ;
    else [self resetUIAccordingToStartupType:NO] ;
    
    
    // reset scrolling
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startupWorkOrderDataNotification:)
                                                 name:kNotificationStartupWorkOrderCont
                                               object:nil];
    
}

/*-(NSString*)addWorkUnitsAccrodingToDeliverablesForDate:(NSMutableArray*)array forDelievreable:(NSString*)deliverableName{
 NSString *workUnits = @"0" ;
 for (int i=0; i<array.count; i++) {
 NSString *str = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] valueForKey:kStartupWorkOrderContAPI_DeliverableName]] ;
 if([str isEqualToString:deliverableName]) {
 workUnits = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] valueForKey:kStartupWorkOrderContAPI_WorkUnits]] ;
 return workUnits ;
 }
 }
 return workUnits ;
 }*/

-(NSString*)addWorkUnitsAccrodingToDeliverablesForDate:(NSMutableArray*)array forDelievreable:(NSString*)deliverableName{
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

-(NSString*)getTotalHoursForDeliverable:(NSString*)deliverableName{
    int hoursLogged = 0 ;
    for (NSDictionary *dict in weeklyUpdateArray) {
        NSArray *deliverablesArrayForDate = [dict valueForKey:kStartupWorkOrderContAPI_Deliverables] ;
        for (NSDictionary *obj in deliverablesArrayForDate) {
            NSString *name = [obj valueForKey:kStartupWorkOrderContAPI_DeliverableName] ;
            if([name isEqualToString:deliverableName]){
                if(![[NSString stringWithFormat:@"%@",[obj valueForKey:kStartupWorkOrderContAPI_WorkUnits]] isEqualToString:@""] && ![[NSString stringWithFormat:@"%@",[obj valueForKey:kStartupWorkOrderContAPI_WorkUnits]] isEqualToString:@" "] ) hoursLogged = hoursLogged + [[obj valueForKey:kStartupWorkOrderContAPI_WorkUnits] intValue] ;
            }
        }
    }
    return [NSString stringWithFormat:@"%d",hoursLogged] ;
}

-(NSString*)formatDateToString{
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    return stringFromDate ;
}

-(void)resetUIAccordingToStartupType:(BOOL)setHidden{
    dateTxtFld.hidden = setHidden ;
    deliverableTxtFld.hidden = setHidden ;
    delierableLbl.hidden = setHidden ;
    workUnitsTxtFld.hidden = setHidden ;
    updateButton.hidden = setHidden ;
}

-(void)renderGridView{
    
    // remove previous view
    for (UIView* b in workOrderView.subviews)
    {
        [b removeFromSuperview];
    }
    workOrderView.hidden = YES;
    
    if(deliverablesArray.count >0){
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
        for(int i=0 ; i<weeklyUpdateArray.count ; i++){
            /* if([daysArray objectAtIndex:i])[datesArray addObject:[NSString stringWithFormat:@"%@\n%@",[daysArray objectAtIndex:i],[[weeklyUpdateArray objectAtIndex:i] valueForKey:kStartupWorkOrderContAPI_Date]]] ;*/
            
            if([daysArray objectAtIndex:i]){
                // NSString *str = [NSString stringWithFormat:@"%@\n%@",[daysArray objectAtIndex:i],[[weeklyUpdateArray objectAtIndex:i] valueForKey:kStartupWorkOrderContAPI_Date]] ;
                
                NSString *str = [NSString stringWithFormat:@"%@",[[weeklyUpdateArray objectAtIndex:i] valueForKey:kStartupWorkOrderContAPI_Date]] ;
                
                dateTemp = [dateFormat dateFromString:str];
                [datesArray addObject: [NSString stringWithFormat:@"%@\n%@",[daysArray objectAtIndex:i],[formatter stringFromDate:dateTemp]]] ;
                
            }
        }
        //[datesArray addObjectsFromArray:totalWorkUnitsArray] ;
        
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
                if(i < weeklyUpdateArray.count){
                    [ary addObject:[self addWorkUnitsAccrodingToDeliverablesForDate:(NSMutableArray*) [[weeklyUpdateArray objectAtIndex:i] valueForKey:kStartupWorkOrderContAPI_Deliverables] forDelievreable:[[deliverablesArray objectAtIndex:j] valueForKey:kStartupWorkOrderContAPI_DeliverableName]]];
                }
                else{
                    // Total Hours
                    if(i == weeklyUpdateArray.count){
                        [ary addObject:[self getTotalHoursForDeliverable:[[deliverablesArray objectAtIndex:j] valueForKey:kStartupWorkOrderContAPI_DeliverableName]]] ;
                    }
                    
                    // Remaining Hours
                    else if(i == weeklyUpdateArray.count+1) {
                        if(j == 0) [ary addObject:[NSString stringWithFormat:@"%d",allocatedHours-consumedHours]] ;
                        else [ary addObject:@"-"] ;
                    }
                    
                    // Allocated Hours
                    else if(i == datesArray.count -1){
                        if(j == 0) [ary addObject:[NSString stringWithFormat:@"%d",allocatedHours]] ;
                        else [ary addObject:@"-"] ;
                    }
                }
                
            }
            [oneR addObject:ary];
        }
        
        [rightTableData addObject:oneR];
        
        XCMultiTableView *xcTableView = [[XCMultiTableView alloc] initWithFrame:CGRectInset(workOrderView.bounds, 5.0f, 5.0f)];
        xcTableView.leftHeaderEnable = YES;
        xcTableView.leftHeaderWidth = 130 ;
        xcTableView.normalSeperatorLineWidth = 0 ;
        xcTableView.boldSeperatorLineWidth = 0 ;
        xcTableView.datasource = self;
        xcTableView.delegate = self;
        xcTableView.isEditableEnable = YES ;
        [workOrderView addSubview:xcTableView];
        
        if(weeklyUpdateArray.count >0)workOrderView.hidden = NO ;
        else workOrderView.hidden = YES ;
        
        
    }
    
}

/*-(void)renderGridView{
 
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
    if ([[notification name] isEqualToString:kNotificationStartupWorkOrderCont]){
        
        [self getWorkOrdersDataWithDate:[formatter stringFromDate:[NSDate date]]] ;
    }
}

-(NSString*)getWeekdayFromDate:(NSString*)dateStr{
    
    NSDate *date = [formatter dateFromString:dateStr];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    
    NSInteger weekday = [components weekday];
    NSString *weekdayName = [formatter weekdaySymbols][weekday - 1];
    weekdayName = [weekdayName substringToIndex:3] ;
    return weekdayName ;
}

#pragma mark - Api Methods
-(void)getWorkOrdersDataWithDate:(NSString*)dateStr{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupWorkOrderContAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:kStartupWorkOrderContAPI_StartupID] ;
        [dictParam setObject:dateStr forKey:kStartupWorkOrderContAPI_Date] ;
        [dictParam setObject:[self getWeekdayFromDate:dateStr] forKey:kStartupWorkOrderContAPI_Day] ;
        NSString *startup_TeamID = [[NSUserDefaults standardUserDefaults] valueForKey:kStartupWorkOrderContAPI_Startup_TeamID];
        [dictParam setObject:startup_TeamID forKey:@"startup_team_id"];

        
        //[dictParam setObject:@"12 Apr, 2016" forKey:kStartupWorkOrderContAPI_Date] ;
        //[dictParam setObject:@"Tue" forKey:kStartupWorkOrderContAPI_Day] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getSavedStartupWorkOrderContractorWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                
                if([responseDict valueForKey:kStartupWorkOrderContAPI_AllocatedHours]){
                    allocatedHours = [[responseDict valueForKey:kStartupWorkOrderContAPI_AllocatedHours] intValue] ;
                }
                
                if([responseDict valueForKey:kStartupWorkOrderContAPI_ApprovedHours]){
                    approvedHours = [[responseDict valueForKey:kStartupWorkOrderContAPI_ApprovedHours] intValue] ;
                }
                
                if([responseDict valueForKey:kStartupWorkOrderContAPI_ConsumedHours]){
                    consumedHours = [[responseDict valueForKey:kStartupWorkOrderContAPI_ConsumedHours] intValue] ;
                }
                
                if([responseDict valueForKey:kStartupWorkOrderContAPI_MainDeliverable]){
                    deliverablesArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict valueForKey:kStartupWorkOrderContAPI_MainDeliverable]] ;
                    [pickerView reloadAllComponents] ;
                }
                
                if([responseDict valueForKey:kStartupWorkOrderContAPI_WeeklyUpdate]){
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

-(void)updateWorkOrder {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_UpdateWorkOrder] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        int approvedWorkUnits  = 0 ;
        int pendingWorkUnits   = 0 ;
        if(consumedHours > approvedHours) {
            pendingWorkUnits = [workUnitsTxtFld.text intValue]  ;
            approvedWorkUnits = 0 ;
        }
        else {
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
}

-(void)saveSubmitWorkOrder:(NSMutableDictionary*)dictParam {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [ApiCrowdBootstrap saveSubmitWorkOrderContractorWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
            }
            // else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
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
    if(selectedDatePickerMode == WORKUNITS_DATE_SELECTED) dateTxtFld.text = strDate;
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

- (IBAction)Calendar_ClickAction:(id)sender {
    [dateTxtFld becomeFirstResponder] ;
}

- (IBAction)OpenPickerView_ClickAction:(id)sender {
    [deliverableTxtFld becomeFirstResponder] ;
}

- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)SubmitWorkOder_Click:(id)sender {
   
    [self.view endEditing:YES] ;
    
    NSMutableArray *workUnitsArray = [[NSMutableArray alloc] init] ;
    NSArray *data = [NSArray arrayWithArray:[rightTableData objectAtIndex:0]] ;
    for (int i=0; i<data.count-3 ; i++) {
        for (int j=0; j<deliverablesArray.count; j++) {
           // NSLog(@"arr: %@ ",[[data objectAtIndex:i] objectAtIndex:j]) ;
            NSMutableDictionary *obj = [[NSMutableDictionary alloc] init] ;
            [obj setValue:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupsAPI_StartupID]] forKey:@"startup_id"] ;
            [obj setValue:[[weeklyUpdateArray objectAtIndex:i] valueForKey:@"date"] forKey:@"date"] ;
            [obj setValue:[[data objectAtIndex:i] objectAtIndex:j] forKey:@"work_units"] ;
            [obj setValue:[[deliverablesArray objectAtIndex:j] valueForKey:kStartupWorkOrderContAPI_DeliverableID] forKey:@"deliverable_id"] ;
            [workUnitsArray addObject:obj] ;
            
        }
    }
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    [dictParam setObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]] forKey:@"is_submitted"] ;
    NSString *startup_TeamID = [[NSUserDefaults standardUserDefaults] valueForKey:kStartupWorkOrderContAPI_Startup_TeamID];
    [dictParam setObject:startup_TeamID forKey:@"startup_team_id"];
    [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:@"user_id"] ;
    [dictParam setObject:workUnitsArray forKey:@"Work_order_array"] ;
    [dictParam setObject:[[UtilityClass getStartupDetails] valueForKey:kStartupsAPI_StartupID] forKey:@"main_startupid"] ;

    NSLog(@"dictParam: %@",dictParam) ;
    [self saveSubmitWorkOrder:dictParam] ;
}

#pragma mark - ToolBar Buttons Methods
- (IBAction)NumberToolBar_ClickAction:(id)sender {
    [workUnitsTxtFld resignFirstResponder] ;
}

- (IBAction)toolbarButtons_ClickAction:(id)sender {
    [deliverableTxtFld resignFirstResponder] ;
    
    if([sender tag] == DONE_CLICKED){
        if([pickerView selectedRowInComponent:0] == 0){
            delierableLbl.text = kSelectDeliverableDefault  ;
            selectedDeliverableIndex = -1 ;
        }
        else{
            delierableLbl.text = [[deliverablesArray objectAtIndex:[pickerView selectedRowInComponent:0]-1] valueForKey:kStartupWorkOrderContAPI_DeliverableName] ;
            selectedDeliverableIndex = (int)[pickerView selectedRowInComponent:0]-1 ;
        }
    }
    else{
        if(selectedDeliverableIndex != -1) delierableLbl.text = [[deliverablesArray objectAtIndex:selectedDeliverableIndex] valueForKey:kStartupWorkOrderContAPI_DeliverableName]  ;
        else delierableLbl.text = kSelectDeliverableDefault ;
        
    }
}

- (IBAction)DatePickerToolbarButtons_ClickAction:(id)sender {
   // [dateTxtFld resignFirstResponder] ;
    [changeDateTxtFld resignFirstResponder] ;
    
    if([sender tag] == DONE_CLICKED){
        if(selectedDatePickerMode == WORKORDER_DATE_SELECTED){
            vertexText = [formatter stringFromDate:datePickerView.date] ;
            NSLog(@"date: %@",datePickerView.date) ;
            [self getWorkOrdersDataWithDate:[formatter stringFromDate:datePickerView.date]] ;
        }
    }
    else{
       // dateTxtFld.text = prevDueDate ;
    }
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    return YES ;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _selectedItem = textField ;
    if([textField isEqual:dateTxtFld])prevDueDate = dateTxtFld.text ;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _selectedItem = nil ;
}

#pragma mark - Picker View Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1 ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return deliverablesArray.count+1 ;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(row == 0) return kSelectDeliverableDefault ;
    else return [[deliverablesArray objectAtIndex:row-1] valueForKey:kStartupWorkOrderContAPI_DeliverableName] ;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(row == 0) delierableLbl.text = kSelectDeliverableDefault ;
    else delierableLbl.text = [[deliverablesArray objectAtIndex:row-1] valueForKey:kStartupWorkOrderContAPI_DeliverableName] ;
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

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == dateTxtFld)selectedDatePickerMode = WORKUNITS_DATE_SELECTED ;
    else if(textField == changeDateTxtFld)selectedDatePickerMode = WORKORDER_DATE_SELECTED ;
    return YES ;
}

-(void)updateGridViewContent:(NSIndexPath *)indexPath withIndex:(int)index withContent:(NSString *)content{
    NSLog(@"row :%ld section: %ld index: %d content: %@",(long)indexPath.row,(long)indexPath.section,index,content) ;
    
    NSMutableArray *ary = [[rightTableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [ary setObject:content atIndexedSubscript:index] ;
    
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
