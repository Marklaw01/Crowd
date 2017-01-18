//
//  AddStartupViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 07/04/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "AddStartupViewController.h"
#import "SWRevealViewController.h"
#import "TextFieldTableViewCell.h"
#import "DescriptionTableViewCell.h"
#import "KeywordsTableViewCell.h"
#import "KLCPopup.h"
#import "PaymentsTableViewCell.h"
#import "CurrentStartupsViewController.h"

@interface AddStartupViewController ()

@end

@implementation AddStartupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetUISettings] ;
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [UtilityClass setStartupViewMode:ADD_STARTUP_TITLE] ;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil] ;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil] ;
    
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

- (void)singleTap:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}

#pragma mark - Custom Methods
-(void)initializeArray{
    
    addStartupArray       = [[NSMutableArray alloc] init] ;
    keywordsArray         = [[NSMutableArray alloc] init] ;
    selectedKeywordsArray = [[NSMutableArray alloc] init] ;
    
    NSArray *fieldsArray = @[@"Startup Name",@"Description",@"Keywords",@"Support Required"] ;
    NSArray *parametersArray = @[kAddStartupAPI_Name,kAddStartupAPI_Description,kAddStartupAPI_Keywords,kAddStartupAPI_SupportRequired] ;
   
    for (int i=0; i<fieldsArray.count ; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
        [dict setValue:[parametersArray objectAtIndex:i] forKey:@"key"] ;
        [dict setValue:@"" forKey:@"value"] ;
        [dict setValue:[fieldsArray objectAtIndex:i] forKey:@"field"] ;
        
        [addStartupArray addObject:dict] ;
    }
   
    [tblView reloadData] ;
}

-(void)resetUISettings{
    
    [self initializeArray] ;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [tblView addGestureRecognizer:singleTapGestureRecognizer];
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self getKeywords] ;
}

-(void)navigationBarSettings{
    self.navigationItem.hidesBackButton = YES ;
    self.title = ADD_STARTUP_TITLE ;
}

-(void)revealViewSettings{
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    menuBarBtn.target = self.revealViewController;
    menuBarBtn.action = @selector(revealToggle:);
    
    // Set the gesture
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)openTagsPopup{
    [self.view endEditing:YES] ;
    [popupTblView reloadData] ;
    [UtilityClass displayPopupWithContentView:popupView view:self.view] ;
}

#pragma mark - Api Methods
-(void)getKeywords {
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        [ApiCrowdBootstrap getStartupKeywords:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"response : %@", responseDict);
                [keywordsArray removeAllObjects] ;
                if([responseDict objectForKey:@"startup_keywords"]){
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:@"startup_keywords"] mutableCopy]) {
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

-(void)addStartup{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAddStartupAPI_UserID] ;
        [dictParam setObject:[[addStartupArray objectAtIndex:kAddStartupName_CellIndex] valueForKey:@"value"] forKey:kAddStartupAPI_Name] ;
        [dictParam setObject:[[addStartupArray objectAtIndex:kAddStartupDescription_CellIndex] valueForKey:@"value"] forKey:kAddStartupAPI_Description] ;
        [dictParam setObject:[UtilityClass convertTagsArrayToStringforArray:selectedKeywordsArray withTagsArray:keywordsArray] forKey:kAddStartupAPI_Keywords] ;
        [dictParam setObject:[[addStartupArray objectAtIndex:kAddStartupSupportReq_CellIndex] valueForKey:@"value"] forKey:kAddStartupAPI_SupportRequired] ;
        [ApiCrowdBootstrap addStartupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                //[self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil] ;
                [UtilityClass showNotificationMessgae:kAddStartup_SuccessMessage withResultType:@"0" withDuration:1] ;
              
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                CurrentStartupsViewController *viewController = (CurrentStartupsViewController*)[storyboard instantiateViewControllerWithIdentifier:kCurrentStartupsIdentifier] ;
                viewController.mode = @"1" ;
                [self.navigationController pushViewController:viewController animated:YES] ;
                
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
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
#pragma mark - Tap gesture
- (void)txtViewTapped_Gesture:(UITapGestureRecognizer *)gestureRecognizer{
    [self openTagsPopup] ;
}

#pragma mark - IBAction Methods
- (IBAction)AddTag_ClickAction:(id)sender {
    [self openTagsPopup] ;
}

- (IBAction)Submit_ClickAction:(id)sender {
    
    if(![self validatetextFieldsWithSectionIndex:kAddStartupName_CellIndex]) return ;
    else if(![UtilityClass checkForAlphaNumericChar:[[addStartupArray objectAtIndex:kAddStartupName_CellIndex] valueForKey:@"value"]]){
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_Validation_StartupNotValid] animated:YES completion:nil] ;
        return ;
    }
    else if(![self validatetextFieldsWithSectionIndex:kAddStartupDescription_CellIndex]) return ;
    else if(selectedKeywordsArray.count < 1){
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_Validation_Startup_Keyword] animated:YES completion:nil] ;
        return ;
    }
    else if(![self validatetextFieldsWithSectionIndex:kAddStartupSupportReq_CellIndex]) return ;
    
    [self addStartup] ;
}

- (IBAction)CheckUncheck_ClickAction:(id)sender {
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

- (IBAction)Ok_ClickAction:(id)sender {
//    [popupView dismissPresentingPopup] ;
    [popupView removeFromSuperview];

    [selectedKeywordsArray removeAllObjects] ;
    for (NSMutableDictionary *obj in keywordsArray) {
        NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
        if([isSelectedStr isEqualToString:@"1"])[selectedKeywordsArray addObject:[obj valueForKey:@"name"]] ;
    }
     [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kAddStartupKeywords_CellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
}
#pragma mark - Validation Methods
-(BOOL)validatetextFieldsWithSectionIndex:(int)index{
    
    NSString *value = [[addStartupArray objectAtIndex:index] valueForKey:@"value"] ;
    if(index == kAddStartupDescription_CellIndex){
        if(value.length < 10){
            [self presentViewController:[UtilityClass displayAlertMessage:kAlert_Validation_Startup_Description] animated:YES completion:nil];
            return NO ;
        }
    }
    else{
        if(value.length < 1){
            if(index == kAddStartupSupportReq_CellIndex){
                 [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"Support is%@.",kAlert_SignUp_BlankField]] animated:YES completion:nil];
            }
            else{
                 [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"%@ is%@.",[[addStartupArray objectAtIndex:index] valueForKey:@"field"],kAlert_SignUp_BlankField]] animated:YES completion:nil];
            }
           
            return NO ;
        }
    }
    
    return YES ;
}

#pragma mark - Table View Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == tblView)return addStartupArray.count+1 ;
    else return keywordsArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == tblView){
        if(indexPath.row == addStartupArray.count){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddStartupSubmit_CellIdentifier] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            return cell ;
        }
        
        else if(indexPath.row == kAddStartupDescription_CellIndex){
            DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddStartupDesc_CellIdentifier] ;
            cell.descriptionTxtView.tag = indexPath.row ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            cell.descriptionTxtView.returnKeyType = UIReturnKeyNext ;
            [UtilityClass setTextViewBorder:cell.descriptionTxtView] ;
            
            NSString *descText = [NSString stringWithFormat:@"%@",[[addStartupArray objectAtIndex:indexPath.row] valueForKey:@"value"]] ;
            
            if(descText.length < 1 || [descText isEqualToString:@""] || [descText isEqualToString:@" "]){
                cell.descriptionTxtView.textColor = [UIColor lightGrayColor] ;
                cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[addStartupArray objectAtIndex:indexPath.row] valueForKey:@"field"]] ;
            }
            else{
                cell.descriptionTxtView.textColor = [UtilityClass textColor] ;
                cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[addStartupArray objectAtIndex:indexPath.row] valueForKey:@"value"]] ;
            }
            return cell ;
        }
        
        else if(indexPath.row == kAddStartupKeywords_CellIndex){
            KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddStartupKeywrods_CellIdentifier] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [UtilityClass setButtonBorder:cell.button] ;
            
            cell.tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
            cell.tagsScrollView.backgroundColor = [UIColor clearColor] ;
            cell.tagsScrollView.tag = indexPath.row ;
            cell.button.tag = indexPath.row ;
            cell.plusBtn.tag = indexPath.row ;
            
            cell.titleLbl.text =  [[addStartupArray objectAtIndex:indexPath.row] valueForKey:@"field"] ;
            
            NSMutableArray *tags ;
            tags = [selectedKeywordsArray mutableCopy] ;
            
            if(tags.count >0)[cell.button setHidden:YES] ;
            else [cell.button setHidden:NO] ;
            
            cell.tagsScrollView.tagPlaceholder = @"" ;
            [cell.button setTitle:[NSString stringWithFormat:@"Add %@",[[addStartupArray objectAtIndex:indexPath.row] valueForKey:@"field"]] forState:UIControlStateNormal] ;
            cell.tagsScrollView.tags = [tags mutableCopy];
            cell.tagsScrollView.tagsDeleteButtonColor = [UIColor whiteColor];
            cell.tagsScrollView.tagsTextColor = [UIColor whiteColor] ;
            cell.tagsScrollView.mode = TLTagsControlModeEdit;
            [cell.tagsScrollView setTapDelegate:self];
            [cell.tagsScrollView setDeleteDelegate:self];
            
            cell.tagsScrollView.tagsBackgroundColor = [UtilityClass orangeColor];
            
            [cell.tagsScrollView reloadTagSubviews];
            
            UITapGestureRecognizer  *txtViewTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(txtViewTapped_Gesture:)];
            [cell.tagsScrollView addGestureRecognizer:txtViewTapped];
            return cell ;
        }
        else{
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddStartupTextField_CellIdentifier] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            [UtilityClass setTextFieldBorder:cell.textFld] ;
            [UtilityClass addMarginsOnTextField:cell.textFld] ;
            cell.textFld.tag = indexPath.row ;
            cell.textFld.placeholder = [[addStartupArray objectAtIndex:indexPath.row] valueForKey:@"field"];
            cell.textFld.text = [[addStartupArray objectAtIndex:indexPath.row] valueForKey:@"value"];
            if(indexPath.row == kAddStartupName_CellIndex)cell.textFld.returnKeyType = UIReturnKeyNext ;
            else cell.textFld.returnKeyType = UIReturnKeyDone ;
            return cell ;
        }
    }
    else{
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
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == tblView){
        if(indexPath.row == kAddStartupDescription_CellIndex) return 100 ;
        else if(indexPath.row == kAddStartupKeywords_CellIndex) return 70 ;
        else return 45 ;
    }
    else return 50 ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Keywords" ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == popupTblView){
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
    if(tableView == tblView) return 0 ;
    else return 30 ;
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
    
    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kAddStartupKeywords_CellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone] ;
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
    if(textField.tag == kAddStartupName_CellIndex){
        DescriptionTableViewCell *cell = (DescriptionTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kAddStartupDescription_CellIndex inSection:0]] ;
        [cell.descriptionTxtView becomeFirstResponder] ;
    }
    return YES ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _selectedItem = textField ;
    return YES ;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder] ;
    _selectedItem = nil ;
    return YES ;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    [[addStartupArray objectAtIndex:textField.tag] setValue:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"value"] ;
    
    return YES ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
     [[addStartupArray objectAtIndex:textView.tag] setValue:[textView.text stringByReplacingCharactersInRange:range withString:text] forKey:@"value"] ;
    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        TextFieldTableViewCell *cell = (TextFieldTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kAddStartupSupportReq_CellIndex inSection:0]] ;
        [cell.textFld becomeFirstResponder] ;
    }
    
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _selectedItem = nil ;
    
    if([textView.text isEqualToString:@"Description"] && textView.textColor == [UIColor lightGrayColor]){
        textView.text = @"" ;
        textView.textColor = [UtilityClass textColor] ;
    }
    
    CGPoint pointInTable = [textView.superview convertPoint:textView.frame.origin toView:tblView];
    CGPoint contentOffset = tblView.contentOffset;
    
    contentOffset.y = (pointInTable.y - textView.inputAccessoryView.frame.size.height);
    
    [tblView setContentOffset:contentOffset animated:YES];
    return YES ;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder] ;
    _selectedItem = nil ;
    
    if([textView.text isEqualToString:@""]){
        textView.text = @"Description" ;
        textView.textColor = [UIColor lightGrayColor] ;
    }
    
    if ([textView.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        CGPoint buttonPosition = [textView convertPoint:CGPointZero
                                                 toView: tblView];
        NSIndexPath *indexPath = [tblView indexPathForRowAtPoint:buttonPosition];
        
        [tblView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
    }
    return YES ;
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
    tblView.contentInset = contentInsets;
    tblView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.selectedItem.frame.origin ) ) {
        if(![_selectedItem isKindOfClass:[UITableView class]])[tblView scrollRectToVisible:self.selectedItem.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    [self moveToOriginalFrame] ;
}

-(void)moveToOriginalFrame{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    tblView.contentInset = contentInsets;
    tblView.scrollIndicatorInsets = contentInsets;
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
