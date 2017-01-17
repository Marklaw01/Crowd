//
//  WorkOrderDetailViewController.m
//  CrowdBootstrap
//
//  Created by Shikha Singla on 04/11/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "WorkOrderDetailViewController.h"

@interface WorkOrderDetailViewController ()

@end

@implementation WorkOrderDetailViewController

#pragma mark - View LifeCycle Methods
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
    [contractorCommentTxtVw setEditable:NO];
    
    // reset scrolling
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    // Hit Api to get Workorder Details
    [self getWorkOrdersDetails: [formatter stringFromDate:[NSDate date]]] ;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(startupWorkOrderDataNotification:) name:kNotificationStartupWorkOrderDetailEnt
//                                               object:nil];
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
                if(![[NSString stringWithFormat:@"%@",[obj valueForKey:kStartupWorkOrderContAPI_WorkUnits]] isEqualToString:@""] && ![[NSString stringWithFormat:@"%@",[obj valueForKey:kStartupWorkOrderContAPI_WorkUnits]] isEqualToString:@" "] ) hoursLogged = hoursLogged + [[obj valueForKey:kStartupWorkOrderContAPI_WorkUnits] intValue] ;
            }
        }
    }
    return [NSString stringWithFormat:@"%d",hoursLogged] ;
}

-(NSString*)formatDateToString {
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    return stringFromDate ;
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
                    else if(i == datesArray.count -1){
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
            commentView.hidden = NO;
        }
        else {
            workOrderView.hidden = YES ;
            commentView.hidden = YES;
        }
        
        NSNumber *isEntrepreneurEditable = [responseDictionary valueForKey:@"is_editable"];
        if ([isEntrepreneurEditable isEqual:@(0)]) {
            [enterpreneurCommentTxtVw setUserInteractionEnabled:NO];
            [submitBtn setUserInteractionEnabled:NO];
        } else {
            [enterpreneurCommentTxtVw setUserInteractionEnabled:YES];
            [submitBtn setUserInteractionEnabled:YES];
        }
    }
}

#pragma mark - Notifcation Methods
//- (void)startupWorkOrderDataNotification:(NSNotification *) notification
//{
//    self.dictionaryIDs = notification.object;
//    
//    if ([[notification name] isEqualToString:kNotificationStartupWorkOrderCont]) {
//        
//        [self getWorkOrdersDetails: [formatter stringFromDate:[NSDate date]]] ;
//    }
//}

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
-(void)getWorkOrdersDetails:(NSString*)dateStr  {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[self.dictionaryIDs valueForKey:kStartupWorkOrderAPI_StartupID] forKey:kStartupWorkOrderAPI_StartupID];

        [dictParam setObject:[self.dictionaryIDs valueForKey:kStartupWorkOrderAPI_StartupTeamID] forKey:kStartupWorkOrderAPI_StartupTeamID];

        [dictParam setObject:[self.dictionaryIDs valueForKey:kStartupWorkOrderAPI_EntrepreneurID] forKey:kStartupWorkOrderAPI_EntrepreneurID] ;
        
        [dictParam setObject:[self.dictionaryIDs valueForKey:kStartupWorkOrderAPI_ContractorID] forKey:kStartupWorkOrderAPI_ContractorID];
        
        [dictParam setObject:[self.dictionaryIDs valueForKey:kStartupWorkorderAPI_WeekNo] forKey:kStartupWorkorderAPI_WeekNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getStartupWorkOrderDetailEntrepreneurWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            responseDictionary = responseDict;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
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
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

- (IBAction)DatePickerToolbarButtons_ClickAction:(id)sender {
//    [changeDateTxtFld resignFirstResponder] ;
//    
//    if([sender tag] == DONE_CLICKED) {
//        if(selectedDatePickerMode == WORKORDER_DATE_SELECTED) {
//            vertexText = [formatter stringFromDate:datePickerView.date] ;
//            [self getWorkOrdersDetails:[formatter stringFromDate:datePickerView.date]] ;
//        }
//    }
}

-(void)addEntrepreneurComments {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        // Given To(Contractor ID)
        [dictParam setObject:[responseDictionary valueForKey:kStartupWorkOrderAPI_ContractorID] forKey:kAddCommentAPI_GivenTo] ;
        // Given By(Entrepreneur ID)
        [dictParam setObject:[responseDictionary valueForKey:kStartupWorkOrderAPI_EntrepreneurID] forKey:kAddCommentAPI_GivenBy] ;
        // Work Comment
        [dictParam setObject:enterpreneurCommentTxtVw.text forKey:kAddCommentAPI_WorkComment] ;
        // Rating Star
        [dictParam setValue:[NSString stringWithFormat:@"%.1f",ratingsView.value] forKey:kAddRatingsAPI_RatingStar] ;
        // Week No.
        [dictParam setObject:[responseDictionary valueForKey:kStartupWorkorderAPI_WeekNo] forKey:kAddCommentAPI_WeekNo] ;
        //Startup ID
        [dictParam setObject:[responseDictionary valueForKey:kStartupWorkOrderAPI_StartupID] forKey:kAddCommentAPI_StartupId] ;
        //Startup Team ID
        [dictParam setObject:[responseDictionary valueForKey:kStartupWorkOrderAPI_StartupTeamID] forKey:kAddCommentAPI_Startup_team_id] ;
        //Status
        [dictParam setObject:@"1" forKey:kAddCommentAPI_Status] ;
        //Is Enterpreneur/Contractor
        [dictParam setObject:@"1" forKey:kAddCommentAPI_IsEnterpreneur] ;
        
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
- (IBAction)submitComment_ClickAction:(id)sender {
    if(enterpreneurCommentTxtVw.text.length < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Work_Comment] animated:YES completion:nil] ;
        return ;
    } else {
        [self addEntrepreneurComments];
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
