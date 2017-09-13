//
//  RateViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 19/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "RateViewController.h"
#import "HCSStarRatingView.h"
#import "KLCPopup.h"
#import "PaymentsTableViewCell.h"

@interface RateViewController ()

@end

@implementation RateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetUISettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil] ;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil] ;
}

#pragma mark - Custom Methods
-(void)resetUISettings {
    
    self.title = @"Rate Contractor" ;
    deliverablesArray = [[NSMutableArray alloc] init] ;
    selectedDeliverablesArray = [[NSMutableArray alloc] init] ;
    [self initializeDeliverableTagsView] ;
    [ratingsView setValue:0] ;
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    [UtilityClass setTextViewBorder:descriptionTextView] ;
    [UtilityClass setTextFieldBorder:timestampTxtFld] ;
    
    [UtilityClass addMarginsOnTextField:timestampTxtFld] ;
    
    selectedRoadmapIndex = -1 ;
    prevDueDate = @"" ;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    timestampTxtFld.text = [dateFormatter stringFromDate:[NSDate date]] ;
    
    timestampTxtFld.inputView = datePickerViewContainer ;
    [datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self getDeliverables] ;
}

-(void)initializeDeliverableTagsView {
    
    [UtilityClass setButtonBorder:tagsButton] ;
    
    tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
    tagsScrollView.backgroundColor = [UIColor clearColor] ;
    
    NSMutableArray *tags ;
    tags = [selectedDeliverablesArray mutableCopy] ;
    
    if(tags.count >0)[tagsButton setHidden:YES] ;
    else [tagsButton setHidden:NO] ;
    
    tagsScrollView.tagPlaceholder = @"Add Deliverable" ;
    [tagsButton setTitle:@"Add Deliverable" forState:UIControlStateNormal] ;
    tagsScrollView.tags = [tags mutableCopy];
    tagsScrollView.tagsDeleteButtonColor = [UIColor whiteColor];
    tagsScrollView.tagsTextColor = [UIColor whiteColor] ;
    tagsScrollView.mode = TLTagsControlModeEdit;
    [tagsScrollView setTapDelegate:self];
    [tagsScrollView setDeleteDelegate:self];
    
    tagsScrollView.tagsBackgroundColor = [UtilityClass orangeColor];
    
    [tagsScrollView reloadTagSubviews];
    
    UITapGestureRecognizer  *txtViewTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(txtViewTapped_Gesture:)];
    [tagsScrollView addGestureRecognizer:txtViewTapped];
}

-(void)openTagsPopup {
    [self.view endEditing:YES] ;
    [popupTblView reloadData] ;
    [UtilityClass displayPopupWithContentView:popupView view:self.view] ;
}

/*
#pragma mark - KLC popup
-(void)displayKLCPopupWithContentView:(UIView*)contentView{
    
    contentView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width-30, self.view.frame.size.height-20);
    contentView.backgroundColor = [UtilityClass backgroundColor];
    contentView.layer.cornerRadius = 12.0;
    
    KLCPopupLayout layout = KLCPopupLayoutMake((KLCPopupHorizontalLayout)KLCPopupHorizontalLayoutCenter,
                                               (KLCPopupVerticalLayout)KLCPopupVerticalLayoutCenter);
    
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView
                                            showType:(KLCPopupShowType)KLCPopupShowTypeBounceInFromTop
                                         dismissType:(KLCPopupDismissType)KLCPopupDismissTypeBounceOutToBottom
                                            maskType:(KLCPopupMaskType)KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:YES
                               dismissOnContentTouch:NO];
    
    [popup showWithLayout:layout];
}
*/
#pragma mark - API Methods
-(void)getDeliverables{
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [ApiCrowdBootstrap getDeliverables:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                if([responseDict objectForKey:kDeliverablesAPI_Deliverables]){
                    
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

-(void)addRatings{
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getContractorDetails] valueForKey:kRecommendedContAPI_ContractorID]] forKey:kAddRatingsAPI_GivenTo] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAddRatingsAPI_GivenBy] ;
        NSString *userType = ([UtilityClass GetUserType] == ENTREPRENEUR?ENTREPRENEUR_TEXT:CONTRACTOR_TEXT) ;
        [dictParam setObject:userType forKey:kAddRatingsAPI_UserType] ;
        [dictParam setObject:descriptionTextView.text forKey:kAddRatingsAPI_Description] ;
        [dictParam setObject:[NSString stringWithFormat:@"%f",ratingsView.value] forKey:kAddRatingsAPI_RatingStar] ;
        [dictParam setObject:[UtilityClass convertTagsArrayToStringforArray:selectedDeliverablesArray withTagsArray:deliverablesArray] forKey:kAddRatingsAPI_Deliverable] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap addRatingWithParameters:dictParam success:^(NSDictionary *responseDict) {
            NSLog(@"responseDict: %@",responseDict) ;
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                //[UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
                [self.navigationController popViewControllerAnimated:YES] ;
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

#pragma mark - IBAction Methods
- (IBAction)StarRating_ValueChanged:(HCSStarRatingView*)sender {
     NSLog(@"Changed rating to %.1f", sender.value);
}

- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)Done_ClickAction:(id)sender {
    
    if(descriptionTextView.text.length < 10){
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Rating_Description] animated:YES completion:nil] ;
        return ;
    }
    else if(timestampTxtFld.text.length < 1){
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Rating_TimeStamp] animated:YES completion:nil] ;
        return ;
    }
    else if(selectedDeliverablesArray.count == 0){
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Rating_Devlierable] animated:YES completion:nil] ;
        return ;
    }
   /* else if(ratingsView.value == 0){
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Rating_Rating] animated:YES completion:nil] ;
        return ;
    }*/
    else{
        [self addRatings] ;
    }
}

- (IBAction)openPickerView_ClickAction:(id)sender {
   [timestampTxtFld becomeFirstResponder] ;
}

- (IBAction)AddTag_ClickAction:(id)sender {
    [self openTagsPopup] ;
}

- (IBAction)CheckUncheck_ClickAction:(id)sender {
    UIButton *btn = (UIButton*)sender ;
    if([btn.accessibilityLabel isEqualToString:CHECK_IMAGE ]){ // Check
        [btn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = UNCHECK_IMAGE ;
        [[deliverablesArray objectAtIndex:btn.tag] setValue:@"0" forKey:@"isSelected"] ;
    }
    else{ // Uncheck
        [self uncheckAllDeliverables] ;
        [btn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = CHECK_IMAGE ;
        [[deliverablesArray objectAtIndex:btn.tag] setValue:@"1" forKey:@"isSelected"] ;
    }
}

-(void)uncheckAllDeliverables{
    for (NSMutableDictionary *dict in deliverablesArray) {
        [dict setValue:@"0" forKey:@"isSelected"] ;
    }
    [popupTblView reloadData] ;
}

- (IBAction)Ok_ClickAction:(id)sender {
//    [popupView dismissPresentingPopup] ;
    [popupView removeFromSuperview];
    [selectedDeliverablesArray removeAllObjects] ;
    for (NSMutableDictionary *obj in deliverablesArray) {
        NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
        if([isSelectedStr isEqualToString:@"1"])[selectedDeliverablesArray addObject:[obj valueForKey:@"name"]] ;
    }
    [self initializeDeliverableTagsView] ;
}


#pragma mark - Toolbar Buttons Methods
- (IBAction)DatePickerToolbar_ClickAction:(id)sender {
    [timestampTxtFld resignFirstResponder] ;
    if([sender tag] == DONE_CLICKED) {
    }
    else{
        timestampTxtFld.text = prevDueDate ;
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

-(void)tagsControl:(UIView *)tag withTagControlIndex:(NSInteger)tagControlIndex removedFromIndex:(NSInteger)index{
    NSLog(@"index: %ld control: %ld", (long)index,(long)tagControlIndex);
    [tag removeFromSuperview];
    NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedDeliverablesArray objectAtIndex:index]] ;
    for (int i=0; i<deliverablesArray.count; i++) {
        NSString *deliverableName = [NSString stringWithFormat:@"%@",[[deliverablesArray objectAtIndex:i] valueForKey:@"name"]] ;
        if([deliverableName isEqualToString:selectedName]){
            [[deliverablesArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
            break ;
        }
    }
    [selectedDeliverablesArray removeObjectAtIndex:index] ;
    
    [self initializeDeliverableTagsView] ;
    
}

#pragma mark - DatePicker Value Changed
- (void)datePickerChanged:(UIDatePicker *)datePicker {
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    timestampTxtFld.text = strDate;
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
    return YES ;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _selectedItem = textField ;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    _selectedItem = nil ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [timestampTxtFld becomeFirstResponder] ;
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    _selectedItem=textView;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    _selectedItem = nil ;
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
    return @"Deliverables" ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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

#pragma mark - keyoboard actions
- (void)keyboardDidShow:(NSNotification *)notification {
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
    if (!CGRectContainsPoint(aRect, self.selectedItem.frame.origin )) {
        if(![_selectedItem isKindOfClass:[UITableView class]])[self.scrollView scrollRectToVisible:self.selectedItem.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    [self moveToOriginalFrame];
}

-(void)moveToOriginalFrame {
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
