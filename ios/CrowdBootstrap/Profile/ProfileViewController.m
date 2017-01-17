//
//  ProfileViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 12/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "PaymentsTableViewCell.h"
#import "KLCPopup.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UtilityClass setUserType:CONTRACTOR] ;
    [self addObserver];
    [self revealViewSettings] ;
    [self navigationBarSettings] ;
    [self resetUISettings] ;
    [self resetToggleButton:(int)[UtilityClass GetUserType]] ;
    [self displayAccreditedInvestorInfo] ;
    [self getProfileData] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
}

/*-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationProfilePopUp object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationProfileAcreditedInvestrPopup object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationProfileCompletionUpdate object:nil];
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationProfileCompletionUpdate object:nil];
    
}*/


#pragma mark - Custom Methods
- (void) addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNotificationIconOnNavigationBar:)name:kNotificationIconOnNavigationBar
                                               object:nil];
}

-(void)setNotificationIconOnNavigationBar:(NSNotification *) notification {
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"notifications"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navigateToNotification_Click:)forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblNotificationCount = [[UILabel alloc]init];
    
    [UtilityClass setNotificationIconOnNavigationBar:button
                                lblNotificationCount:lblNotificationCount navItem:self.navigationItem];
}

-(void)revealViewSettings {
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    menuBarBtn.target = self.revealViewController;
    menuBarBtn.action = @selector(revealToggle:);
    
    // Set the gesture
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
   // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)navigationBarSettings {
    self.title = @"My Profile" ;
}

-(void)resetUISettings {
   // hoursTxtFld.currencyPrefix = @"$";
   // hoursTxtFld.decimalCount = 2;
    popupArray = [[NSMutableArray alloc] init] ;
    [UtilityClass setProfileImageChangedStatus:NO] ;
    
    //[UtilityClass setTextFieldBorder:userNameTxtFld] ;
    [UtilityClass addMarginsOnTextField:userNameTxtFld] ;
    userNameTxtFld.userInteractionEnabled = NO ;
    [UtilityClass addMarginsOnTextField:hoursTxtFld] ;
    hoursTxtFld.inputAccessoryView = toolBar ;
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:2];
    
    [self setHourlyRateView] ;
    
    profileImageView.layer.cornerRadius = 50;
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.borderWidth = 2.0f;
    profileImageView.layer.borderColor = [UtilityClass greenColor].CGColor;
    profileImageView.userInteractionEnabled = YES ;
    UITapGestureRecognizer  *imageTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped_Gesture:)];
    [profileImageView addGestureRecognizer:imageTapped];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openPopupNotification:)
                                                 name:kNotificationProfilePopUp
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openAccreditedInvestorPopupNotification:)
                                                 name:kNotificationProfileAcreditedInvestrPopup
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateProfileCompletionNotifiation:)
                                                 name:kNotificationProfileCompletionUpdate
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disablePriceTextFieldNotification:)
                                                 name:kNotificationProfileDisablePriceTextField
                                               object:nil];
}


-(void)setHourlyRateView {
    // Add left view on Hourly Rate
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 15, 35)];
    UILabel *dolarLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 35)] ;
    dolarLbl.text = @"$" ;
    dolarLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    dolarLbl.textAlignment = NSTextAlignmentCenter ;
    [dolarLbl setTextColor:[UtilityClass greenColor]] ;
    [paddingView addSubview:dolarLbl] ;
   // hoursTxtFld.leftView = paddingView;
    //hoursTxtFld.leftViewMode = UITextFieldViewModeAlways;
    
    // Add right view on Hourly Rate
    UIView *paddingRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 35, 35)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 35)] ;
    lbl.text = @"/HR" ;
    lbl.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    lbl.textAlignment = NSTextAlignmentCenter ;
    [lbl setTextColor:[UtilityClass greenColor]] ;
    [paddingRightView addSubview:lbl] ;
    hoursTxtFld.rightView = paddingRightView;
    hoursTxtFld.rightViewMode = UITextFieldViewModeAlways;
}

-(void)resetToggleButton:(int)userType {
    [hoursTxtFld resignFirstResponder] ;
    if(userType == ENTREPRENEUR){
        [toggleImageView setImage:[UIImage imageNamed:ENTREPRENEUR_SELECTED_IMAGE]] ;
        [self resetHoursFieldAccordingToUserType:YES] ;
    }
    else{
        [toggleImageView setImage:[UIImage imageNamed:CONTRACTOR_SELECTED_IMAGE]] ;
        [self resetHoursFieldAccordingToUserType:NO] ;
    }
    [UtilityClass setUserType:userType] ;
}

-(void)resetHoursFieldAccordingToUserType:(BOOL)isContractor {
    editBtn.hidden = isContractor ;
    hoursTxtFld.hidden = isContractor ;
    hoursTxtFld.enabled = isContractor ;
    if(isContractor){
        [UtilityClass setTextFieldBorder:hoursTxtFld] ;
        hoursTxtFld.backgroundColor = [UIColor whiteColor] ;
    }
    else{
        hoursTxtFld.layer.borderWidth=0;
        hoursTxtFld.backgroundColor = [UIColor clearColor] ;
    }
}

-(void)displayAccreditedInvestorInfo {
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:ACCREDITED_INVESTOR_HTML ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [accreditedWebView loadHTMLString:htmlString baseURL:nil];
    
}
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
-(void)updateProfileUI{
    [hoursTxtFld resignFirstResponder] ;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kNotificationProfileHideKeypad
     object:self];
    
     hoursTxtFld.layer.borderWidth=0;
    hoursTxtFld.backgroundColor = [UIColor clearColor] ;
    switch (segmentControl.selectedSegmentIndex) {
        case PROFILE_BASIC_SELECTED:{
            basicView.hidden = NO ;
            professionalView.hidden = YES ;
            startupsView.hidden = YES ;
           
            if([UtilityClass GetUserType] == CONTRACTOR) {
                editBtn.hidden = NO ;
                hoursTxtFld.hidden = NO ;
                hoursTxtFld.enabled = YES ;
               
            }
            else {
                editBtn.hidden = YES ;
                hoursTxtFld.hidden = YES ;
                hoursTxtFld.enabled = NO ;
            }
            
            [self getProfileData] ;
            
            break;
        }
        case PROFILE_PROFESSIONAL_SELECTED:{
            basicView.hidden = YES ;
            professionalView.hidden = NO ;
            startupsView.hidden = YES ;
            
            if([UtilityClass GetUserType] == CONTRACTOR) {
                editBtn.hidden = NO ;
                hoursTxtFld.hidden = NO ;
                hoursTxtFld.enabled = YES ;
            }
            else {
                editBtn.hidden = YES ;
                hoursTxtFld.hidden = YES ;
                hoursTxtFld.enabled = NO ;
            }
            
            [self getProfileData] ;
            
            break;
        }
        case PROFILE_STARTUPS_SELECTED:{
            basicView.hidden = YES ;
            professionalView.hidden = YES ;
            startupsView.hidden = NO ;
            editBtn.hidden = YES ;
            hoursTxtFld.enabled = NO ;
            if([UtilityClass GetUserType] == CONTRACTOR) {
                
                hoursTxtFld.hidden = NO ;
            }
            else {
                editBtn.hidden = YES ;
                hoursTxtFld.hidden = YES ;
            }
            
            [self getProfileData] ;
            
            break;
        }
            
        default:
            break;
    }
    
}

-(void)resetPopupArray{
    [popupArray removeAllObjects] ;
    NSArray *tagsArray = [[UtilityClass getTagsPopupData] mutableCopy] ;
    NSArray *selectedDataArray = [[UtilityClass getSelectedTagsPopupData] mutableCopy] ;
    for (NSDictionary *obj in tagsArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:obj] ;
        [dict setValue:@"0" forKey:@"isSelected"] ;
        NSString *tagName = [obj valueForKey:@"name"] ;
        for (NSString *selectedTagName in selectedDataArray) {
            if([ selectedTagName isEqualToString:tagName]){
                [dict setValue:@"1" forKey:@"isSelected"] ;
            }
        }
        [popupArray addObject:dict] ;
    }
}

#pragma mark - ToolBar Buttons Methods
- (IBAction)toolbarButtons_ClickAction:(id)sender{
    [hoursTxtFld resignFirstResponder] ;
    editBtn.hidden = NO ;
    hoursTxtFld.hidden = NO ;
    hoursTxtFld.enabled = YES ;
    hoursTxtFld.backgroundColor = [UIColor clearColor] ;
    hoursTxtFld.layer.borderWidth=0;
}

#pragma mark - Tap gesture
- (void)imageTapped_Gesture:(UITapGestureRecognizer *)gestureRecognizer{
    
    if(segmentControl.selectedSegmentIndex != PROFILE_STARTUPS_SELECTED){
        // selectedTextViewIndex = (int)gestureRecognizer.view.tag ;
        
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
    
}

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
    //[[AppDelegate appDelegate].window]
    [self.navigationController presentViewController:picker animated:YES completion:nil] ;
    //[self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    profileImageView.image = chosenImage;
    
    NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1);
    
    NSMutableDictionary *dict = [[UtilityClass getUserProfileDetails] mutableCopy] ;
    [dict setObject:imageData forKey:kProfileAPI_Image] ;
    
    [UtilityClass setProfileImageChangedStatus:YES] ;
    
    [UtilityClass setUserProfileDetails:dict] ;
    
}

#pragma mark - Notifcation Methods
- (void) openPopupNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationProfilePopUp]){
        
        [KLCPopup dismissAllPopups] ;
//        [popupView dismissPresentingPopup] ;
        [popupView removeFromSuperview];
        
        [self resetPopupArray] ;
        [popupTblView reloadData] ;
        
        [UtilityClass displayPopupWithContentView:popupView view:self.view] ;
        
    }
}

- (void) openAccreditedInvestorPopupNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationProfileAcreditedInvestrPopup]){
        
        [KLCPopup dismissAllPopups] ;
//        [popupView dismissPresentingPopup] ;
        [popupView removeFromSuperview];
        
        accreditedPopupView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width-30, self.view.frame.size.height-20);
        accreditedPopupView.backgroundColor = [UtilityClass backgroundColor];
        accreditedPopupView.layer.cornerRadius = 12.0;
        
        [UIView animateWithDuration:0.3/1.5 animations:^{
            [self.view addSubview:accreditedPopupView];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                accreditedPopupView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3/2 animations:^{
                    accreditedPopupView.transform = CGAffineTransformIdentity;
                }];
            }];
        }];
    }
}

- (void) updateProfileCompletionNotifiation:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationProfileCompletionUpdate]){
        [self updateProfileCompletion] ;
    }
}

-(void)updateProfileCompletion{
    userNameTxtFld.text = [[UtilityClass getUserProfileDetails] objectForKey:kProfileAPI_Name] ;
    progressLbl.text = [NSString stringWithFormat:@"%@%@",[[UtilityClass getUserProfileDetails] objectForKey:kProfileAPI_Complete],@"% completed"];
    float progress = (float)[[[UtilityClass getUserProfileDetails] objectForKey:kProfileAPI_Complete] intValue]/100 ;
    [progressView setProgress:progress] ;
}

-(void)disablePriceTextFieldNotification:(NSNotification*)notification{
    if ([[notification name] isEqualToString:kNotificationProfileDisablePriceTextField]){
        [hoursTxtFld resignFirstResponder] ;
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentedControl_ValueChanged:(id)sender {
     [self updateProfileUI] ;
}

- (IBAction)ChangeUserType_ClickAction:(id)sender {
    selectedUserType = (int)[sender tag] ;
    [self resetToggleButton:selectedUserType] ;
    [self updateProfileUI] ;
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    
}


- (IBAction)EditButton_ClickAction:(id)sender {
    hoursTxtFld.enabled = YES ;
    [UtilityClass setTextFieldBorder:hoursTxtFld] ;
    hoursTxtFld.backgroundColor = [UIColor whiteColor] ;
    editBtn.hidden = YES ;
    [hoursTxtFld becomeFirstResponder] ;
}

#pragma mark - Popup Button Methods
- (IBAction)OK_ClickAction:(id)sender {
    
//    [popupView dismissPresentingPopup] ;
    [popupView removeFromSuperview];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init] ;
    for (NSMutableDictionary *obj in popupArray) {
        NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
        if([isSelectedStr isEqualToString:@"1"])[arr addObject:[obj valueForKey:@"name"]] ;
    }
    
    [UtilityClass setSelectedTagsIndex:arr] ;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kNotificationProfileUpdatedTextView
     object:self];
}

- (IBAction)HideAccreditedPopup_ClickAction:(id)sender {
//    [accreditedPopupView dismissPresentingPopup] ;
    [accreditedPopupView removeFromSuperview];
}

#pragma mark - TblView Cell Button Methods
- (IBAction)checkUncheck_ClickAction:(UIButton*)sender {
    
    UIButton *btn = (UIButton*)sender ;
    if([btn.accessibilityLabel isEqualToString:CHECK_IMAGE ]){ // Check
        [btn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = UNCHECK_IMAGE ;
        [[popupArray objectAtIndex:btn.tag] setValue:@"0" forKey:@"isSelected"] ;
    }
    else{ // Uncheck
        
        [btn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = CHECK_IMAGE ;
       [[popupArray objectAtIndex:btn.tag] setValue:@"1" forKey:@"isSelected"] ;
    }
}

#pragma mark -  TSTextField Methods
- (IBAction) amountChanged: (TSCurrencyTextField*) sender
{
    // This could just as easily be _amountLabel.text = sender.text.
    // But we want to demonstrate the amount property here.
    NSMutableDictionary *profileDict = [[UtilityClass getUserProfileDetails] mutableCopy] ;
    [profileDict setObject:[NSString stringWithFormat:@"%@",hoursTxtFld.amount] forKey:kProfileAPI_PerHourRate] ;
    [UtilityClass setUserProfileDetails:profileDict] ;
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //textField.text = [NSString stringWithFormat:@"%@",[[UtilityClass getUserProfileDetails] objectForKey:kProfileAPI_PerHourRate]] ;
    return YES ;
}

/*-(void)textFieldDidEndEditing:(UITextField *)textField{
    double Rate_int1 = [hoursTxtFld.text doubleValue];
    textField.text = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithDouble:Rate_int1]]] ;
    textField.text = [NSString stringWithFormat:@"$%@/HR",[formatter stringFromNumber:[NSNumber numberWithDouble:Rate_int1]]] ;
}*/

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    return YES ;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == hoursTxtFld){
        
        /*if([string rangeOfString: @"."].location != NSNotFound && [textField.text rangeOfString: @"."].location != NSNotFound) {
            return NO ;
        }
        
        double Rate_int1 = [[textField.text stringByReplacingCharactersInRange:range withString:string] doubleValue];
        NSMutableDictionary *profileDict = [[UtilityClass getUserProfileDetails] mutableCopy] ;
        [profileDict setObject:[formatter stringFromNumber:[NSNumber numberWithDouble:Rate_int1]] forKey:kProfileAPI_PerHourRate] ;
        [UtilityClass setUserProfileDetails:profileDict] ;*/
    }
    return YES ;
}


#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return popupArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keywordsCell"] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.companyNameLbl.text = [[popupArray objectAtIndex:indexPath.row] valueForKey:@"name"] ;
    cell.checkboxBtn.tag = indexPath.row ;
    if([[NSString stringWithFormat:@"%@",[[popupArray objectAtIndex:indexPath.row] valueForKey:@"isSelected"]] isEqualToString:@"0" ]){ // Check
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
    return [UtilityClass GetPopupTypeName] ;
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


#pragma mark - API Methods
-(void)getProfileData{
    
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        if((int)segmentControl.selectedSegmentIndex == PROFILE_STARTUPS_SELECTED)  [self getStartupsProfileData] ;
        
        else [self getBasicProfProfileData] ;
    }
}

-(void)getBasicProfProfileData{
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileAPI_UserID] ;
    [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileAPI_LoggedIn_UserID] ;
    
    [ApiCrowdBootstrap getProfileWithType:(int)segmentControl.selectedSegmentIndex forUserType:(int)[UtilityClass GetUserType] withParameters:dictParam success:^(NSDictionary *responseDict) {
        
        [UtilityClass hideHud] ;
        if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
            // Update Profile Info
            NSLog(@"responseDict: %@",responseDict) ;
            userNameTxtFld.text = [responseDict objectForKey:kProfileAPI_Name] ;
            
            [profileImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[responseDict valueForKey:kProfileAPI_Image]]] placeholderImage:[UIImage imageNamed:kImage_ProfilePicDefault]] ;
            
            if([UtilityClass GetUserType] == CONTRACTOR){
                NSString *price = [NSString stringWithFormat:@"%@",[responseDict objectForKey:kProfileAPI_PerHourRate]] ;
               /* if([price isEqualToString:@""] || [price isEqualToString:@" "])hoursTxtFld.text = @"0" ;
                else {
                    float hours = [[responseDict objectForKey:kProfileAPI_PerHourRate]floatValue] ;
                    if(hours){
                         hoursTxtFld.text = [formatter stringFromNumber:[NSNumber numberWithFloat:hours]];
                    }
                }*/
                if([price isEqualToString:@""] || [price isEqualToString:@" "])hoursTxtFld.amount = 0 ;
                else {
                    float hours = [[responseDict objectForKey:kProfileAPI_PerHourRate]floatValue] ;
                    if(hours){
                        NSString *str = [formatter stringFromNumber:[NSNumber numberWithFloat:hours]] ;
                        hoursTxtFld.amount = [formatter numberFromString:str];
                    }
                }
            }
            //else hoursTxtFld.text = @"" ;
            
            [UtilityClass setProfileImageChangedStatus:NO] ;
            [UtilityClass setUserProfileDetails:[(NSMutableDictionary*)responseDict mutableCopy] ] ;
            [self updateProfileCompletion] ;
            
            // Update Logged in User Image
            if([UtilityClass GetUserType] == CONTRACTOR){
                NSMutableDictionary *loggedInUserDict = [[UtilityClass getLoggedInUserDetails]mutableCopy] ;
                [loggedInUserDict setObject:[responseDict objectForKey:kProfileAPI_Image] forKey:kLogInAPI_UserImage] ;
                [UtilityClass setLoggedInUserDetails:loggedInUserDict] ;
            }
            
            if(segmentControl.selectedSegmentIndex == PROFILE_BASIC_SELECTED) {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kNotificationBasicProfile
                 object:self];
            }
            
            else if(segmentControl.selectedSegmentIndex == PROFILE_PROFESSIONAL_SELECTED) {
                //[UtilityClass setUserProfileDetails:[(NSMutableDictionary*)[responseDict valueForKey:kProfileAPI_ProfessionalInformation] mutableCopy]] ;
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kNotificationProfessionalProfile
                 object:self];
            }
            
            else {
                //[UtilityClass setUserProfileDetails:[(NSMutableDictionary*)[responseDict valueForKey:kProfileAPI_StartupInformation] mutableCopy]] ;
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kNotificationStartupProfile
                 object:self];
            }
            
        }
        else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        
    } failure:^(NSError *error) {
        
        [UtilityClass displayAlertMessage:error.description] ;
        [UtilityClass hideHud] ;
        
    }] ;
    
}

-(void)getStartupsProfileData{
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileAPI_UserID] ;
    if([UtilityClass GetUserType] == CONTRACTOR)[dictParam setObject:CONTRACTOR_TEXT forKey:kProfileAPI_UserType] ;
    else [dictParam setObject:ENTREPRENEUR_TEXT forKey:kProfileAPI_UserType] ;
    
    [ApiCrowdBootstrap getProfielUserStartupsWithParameters:dictParam success:^(NSDictionary *responseDict) {
        
        [UtilityClass hideHud] ;
        if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
            
            [UtilityClass setProfileStartupsDetails:[responseDict valueForKey:kProfileAPI_StartupInformation]] ;
            [UtilityClass setProfileImageChangedStatus:NO] ;
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotificationStartupProfile
             object:self];
            
        }
       // else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
    } failure:^(NSError *error) {
        
        [UtilityClass displayAlertMessage:error.description] ;
        [UtilityClass hideHud] ;
        
    }] ;
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
