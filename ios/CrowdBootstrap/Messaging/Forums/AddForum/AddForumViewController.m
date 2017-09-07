//
//  AddForumViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 11/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "AddForumViewController.h"
#import "PaymentsTableViewCell.h"
#import "KLCPopup.h"

@interface AddForumViewController ()

@end

@implementation AddForumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)singleTap:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    self.title = @"Add Forum" ;
    [UtilityClass setTextFieldBorder:titleTxtFld] ;
    [UtilityClass setTextFieldBorder:startupTxtFld] ;
    [UtilityClass setTextViewBorder:descriptionTxtView] ;
    
    [UtilityClass addMarginsOnTextField:titleTxtFld] ;
    [UtilityClass addMarginsOnTextField:startupTxtFld] ;
    //[UtilityClass addMarginsOnTextView:descriptionTxtView] ;
    startupTxtFld.inputView = pickerViewContainer ;
    
    [self initializeTagsView] ;
    
    startupsArray         = [[NSMutableArray alloc] init] ;
    keywordsArray         = [[NSMutableArray alloc] init] ;
    selectedKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedStartupIndex = -1 ;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    [self getStartups] ;
    [self getForumKeywords] ;
    
}

-(void)initializeTagsView{
    
    [UtilityClass setButtonBorder:tagsButton] ;
    
    tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
    tagsScrollView.backgroundColor = [UIColor clearColor] ;
    
    NSMutableArray *tags ;
    tags = [selectedKeywordsArray mutableCopy] ;
    
    if(tags.count >0)[tagsButton setHidden:YES] ;
    else [tagsButton setHidden:NO] ;
    
    tagsScrollView.tagPlaceholder = @"Add Keywords" ;
    [tagsButton setTitle:@"Add Keywords" forState:UIControlStateNormal] ;
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

-(void)openTagsPopup{
    
    [self.view endEditing:YES] ;
    [popupTblView reloadData] ;
    [UtilityClass displayPopupWithContentView:popupView view:self.view] ;
}

#pragma mark - API Methods
-(void)getForumKeywords{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        [ApiCrowdBootstrap getForumKeywords:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                
                [keywordsArray removeAllObjects] ;
                if([responseDict objectForKey:@"keywords"]){
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:@"keywords"] mutableCopy]) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:[dict mutableCopy]] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        [keywordsArray addObject:obj] ;
                    }
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getStartups{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileUserStartupApi_UserID] ;
        [dictParam setObject:ENTREPRENEUR_TEXT forKey:kProfileUserStartupApi_UserType] ;
        
        [ApiCrowdBootstrap getUserStartupsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                if([responseDict objectForKey:kProfileUserStartupApi_StartupData]){
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

-(void)addForum{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_AddForum] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        
        // User ID
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAddForumAPI_UserID] ;
        
        // Startup ID
        if(selectedStartupIndex != -1)[dictParam setObject:[NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:selectedStartupIndex] valueForKey:@"id"]] forKey:kAddForumAPI_StartupID] ;
        else [dictParam setObject:@"0" forKey:kAddForumAPI_StartupID] ;
        
        // Title
        [dictParam setObject:titleTxtFld.text forKey:kAddForumAPI_Title] ;
        
        // Description
        [dictParam setObject:descriptionTxtView.text forKey:kAddForumAPI_Description] ;
        
        // Keywords
        [dictParam setObject:[UtilityClass convertTagsArrayToStringforArray:selectedKeywordsArray withTagsArray:keywordsArray] forKey:kAddForumAPI_Keywords] ;
        
        // Image
        if(imgData)[dictParam setObject:imgData forKey:kAddForumAPI_Image] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap addForumWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                [UtilityClass showNotificationMessgae:FORUM_CREATED_MESSAGE withResultType:@"0" withDuration:1] ;
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


#pragma mark - KLC popup
/*
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
#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)AddForum_ClickAction:(id)sender {

    if(titleTxtFld.text.length < 1){
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Forum_Title] animated:YES completion:nil] ;
        return ;
    }
    else if(selectedKeywordsArray.count < 1){
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Forum_Keyword] animated:YES completion:nil] ;
        return ;
    }
    else if(descriptionTxtView.text.length < kDescMinCharLength){
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Forum_Description] animated:YES completion:nil] ;
        return ;
    }
    else [self addForum] ;
}

- (IBAction)Browse_ClickAction:(id)sender {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Choose From Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController.view setTintColor:[UtilityClass blueColor]];
    [alertController addAction:[UIAlertAction actionWithTitle:kImagePicker_Cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil] ;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:kImagePicker_UploadImage style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self displayImagePickerWithType:NO] ;
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:kImagePicker_TakePicture style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self displayImagePickerWithType:YES] ;
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)OK_ClickAction:(id)sender {
//    [popupView dismissPresentingPopup] ;
    [popupView removeFromSuperview];

    [selectedKeywordsArray removeAllObjects] ;
    for (NSMutableDictionary *obj in keywordsArray) {
        NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
        if([isSelectedStr isEqualToString:@"1"])[selectedKeywordsArray addObject:[obj valueForKey:@"name"]] ;
    }
    [self initializeTagsView] ;
}

- (IBAction)checkUncheck_ClickAction:(UIButton*)sender {
    UIButton *btn = (UIButton*)sender ;
    if([btn.accessibilityLabel isEqualToString:CHECK_IMAGE ]){ // Check
        [btn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = UNCHECK_IMAGE ;
        [[keywordsArray objectAtIndex:btn.tag] setValue:@"0" forKey:@"isSelected"] ;
    }
    else{ // Uncheck
        
        [btn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = CHECK_IMAGE ;
        [[keywordsArray objectAtIndex:btn.tag] setValue:@"1" forKey:@"isSelected"] ;
    }
}

- (IBAction)AddTag_ClickAction:(id)sender {
    [self openTagsPopup] ;
}
- (IBAction)openPickerView_ClickAction:(id)sender {
    [startupTxtFld becomeFirstResponder] ;
}

#pragma mark - Toolbar Buttons Action
- (IBAction)ToolbarButtons_ClickAction:(id)sender {
    [startupTxtFld resignFirstResponder] ;
    
    if([sender tag] == DONE_CLICKED){
        if([pickerView selectedRowInComponent:0] == 0){
            startupTxtFld.text = @""  ;
            selectedStartupIndex = -1  ;
        }
        else{
            startupTxtFld.text = [[startupsArray objectAtIndex:[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"]  ;
            selectedStartupIndex = (int)[pickerView selectedRowInComponent:0]-1 ;
        }
    }
    else{
        if(selectedStartupIndex != -1) startupTxtFld.text = [[startupsArray objectAtIndex:selectedStartupIndex] valueForKey:@"name"]  ;
        else startupTxtFld.text = @"" ;
    }
}

#pragma mark - Tap gesture
- (void)txtViewTapped_Gesture:(UITapGestureRecognizer *)gestureRecognizer{
    [self openTagsPopup] ;
}

#pragma mark - ImagePicker Methods
-(void)displayImagePickerWithType:(BOOL)isCameraMode{
    [self dismissViewControllerAnimated:YES completion:nil] ;
    
    if (isCameraMode && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_NoCamera] animated:YES completion:nil] ;
        return ;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if(isCameraMode) picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    else picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    imageView.image = chosenImage ;
    
    imgData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1);
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    if(textField == titleTxtFld) [descriptionTxtView becomeFirstResponder] ;
    return YES ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
    _selectedItem=textField;
    return YES ;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder] ;
    _selectedItem = nil ;
    return YES ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _selectedItem=textView;
    return YES ;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder] ;
    _selectedItem = nil ;
    return YES ;
}

#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

-(void)tagsControl:(UIView *)tag withTagControlIndex:(NSInteger)tagControlIndex removedFromIndex:(NSInteger)index{
    NSLog(@"index: %ld control: %ld", (long)index,(long)tagControlIndex);
    [tag removeFromSuperview];
    NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedKeywordsArray objectAtIndex:index]] ;
    for (int i=0; i<keywordsArray.count; i++) {
        NSString *keywordName = [NSString stringWithFormat:@"%@",[[keywordsArray objectAtIndex:i] valueForKey:@"name"]] ;
        if([keywordName isEqualToString:selectedName]){
            [[keywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
            break ;
        }
    }
    [selectedKeywordsArray removeObjectAtIndex:index] ;
    
    [self initializeTagsView] ;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return keywordsArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keywordsCell"] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.companyNameLbl.text = [[keywordsArray objectAtIndex:indexPath.row] valueForKey:@"name"] ;
    cell.checkboxBtn.tag = indexPath.row ;
    if([[NSString stringWithFormat:@"%@",[[keywordsArray objectAtIndex:indexPath.row] valueForKey:@"isSelected"]] isEqualToString:@"0" ]){ // Check
        [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
    }
    else{ // Uncheck
        
        [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
    }
    return cell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Keywords" ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
    [self checkUncheck_ClickAction:cell.checkboxBtn] ;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // if you have index/header text in your tableview change your index text color
    UITableViewHeaderFooterView *headerIndexText = (UITableViewHeaderFooterView *)view;
    [headerIndexText.textLabel setTextColor:[UtilityClass blueColor]];
}

#pragma mark - Picker View Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1 ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return startupsArray.count+1 ;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(row == 0) return @"Select Startup" ;
    else return [[startupsArray objectAtIndex:row-1] valueForKey:@"name"] ;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(row == 0) startupTxtFld.text = @"" ;
    else startupTxtFld.text = [[startupsArray objectAtIndex:row-1] valueForKey:@"name"] ;
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
