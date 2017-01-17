//
//  AddCampaignViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 11/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "AddCampaignViewController.h"
#import "AddCampaignTableViewCell.h"
#import "PaymentsTableViewCell.h"
#import "KLCPopup.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>


@interface AddCampaignViewController ()

@end

@implementation AddCampaignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self resetUISettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)singleTap:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
    //if(chooseStartupTxtFld.isSelected){
        if( selectedStartupIndex == -1 ) chooseStartupTxtFld.text = @"" ;
        else  chooseStartupTxtFld.text = [[startupsArray objectAtIndex:selectedStartupIndex] valueForKey:@"name"] ;
        
    //}
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

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(chooseStartupTxtFld.isSelected) {
        if( selectedStartupIndex == -1 ) chooseStartupTxtFld.text = @"" ;
        else  chooseStartupTxtFld.text = [[startupsArray objectAtIndex:selectedStartupIndex] valueForKey:@"name"] ;

    }
    [self.view endEditing:YES];
}

#pragma mark - Custom Methods
-(void)resetUISettings {
    
    self.title = @"Add Campaign" ;
    
    [UtilityClass setTextFieldBorder:campaignNameTxtFld] ;
    [UtilityClass setTextFieldBorder:chooseStartupTxtFld] ;
    [UtilityClass setTextFieldBorder:dueDateTxtFld] ;
    [UtilityClass setTextFieldBorder:targetAmount] ;
    [UtilityClass setTextViewBorder:summaryTxtFld] ;
    
    [UtilityClass addMarginsOnTextField:campaignNameTxtFld] ;
    [UtilityClass addMarginsOnTextField:chooseStartupTxtFld] ;
    [UtilityClass addMarginsOnTextField:dueDateTxtFld] ;
    [UtilityClass addMarginsOnTextField:targetAmount] ;
    
    [self setKeywordsTagViewWithTagView:keywordsView withButton:keywordsBtn forArray:selectedKeywordsArray] ;
    [self setKeywordsTagViewWithTagView:campaignKeywordsView withButton:campaignKeywordsBtn forArray:selectedCampaignKeywordsArray] ;
    
    targetAmount.inputAccessoryView = numberToolBar ;
    
    
    chooseStartupTxtFld.inputView = pickerViewContainer ;
    targetAmount.placeholder = @"Target Amount" ;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    dueDateTxtFld.inputView = datePickerViewContainer ;
    [datePickerView setMinimumDate:[NSDate date]] ;
    
    [datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    dueDateTxtFld.text = [dateFormatter stringFromDate:[NSDate date]] ;
    
    // reset scrolling
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    selectedStartupIndex = -1 ;
    prevDueDate = @"" ;
    
    startupsArray = [[NSMutableArray alloc] init] ;
    keywordsArray = [[NSMutableArray alloc] init];
    campaignKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedCampaignKeywordsArray = [[NSMutableArray alloc] init] ;
    
    [self getKeywords] ;
    [self getCampaignKeywords] ;
    [self getStartupsList] ;
}

-(void)setKeywordsTagViewWithTagView:(TLTagsControl*)tagView withButton:(UIButton*)button forArray:(NSMutableArray*)array {
    [UtilityClass setButtonBorder:button] ;
    
    tagView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
    tagView.backgroundColor = [UIColor clearColor] ;
    
    if(array.count >0)[button setHidden:YES] ;
    else [button setHidden:NO] ;
    
    if(tagView == keywordsView){
        tagView.tagPlaceholder = @"Add Target Market" ;
        [button setTitle:@"Add Target Market" forState:UIControlStateNormal] ;
        tagView.tag = TARGET_MARKET_SELECTED ;
    }
    else{
        tagView.tagPlaceholder = @"Add Campaign Keywords" ;
        [button setTitle:@"Add Campaign Keywords" forState:UIControlStateNormal] ;
        tagView.tag = CAMPAIGN_KEYWORD_SELECTED ;
    }
   
    tagView.tags = [array mutableCopy];
    tagView.tagsDeleteButtonColor = [UIColor whiteColor];
    tagView.tagsTextColor = [UIColor whiteColor] ;
    tagView.mode = TLTagsControlModeEdit;
    [tagView setTapDelegate:self];
    [tagView setDeleteDelegate:self];
    
    tagView.tagsBackgroundColor = [UtilityClass orangeColor];
    
    [tagView reloadTagSubviews];
    
    UITapGestureRecognizer  *txtViewTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(txtViewTapped_Gesture:)];
    [tagView addGestureRecognizer:txtViewTapped];
}

-(void)openTagsPopup{
    [self.view endEditing:YES] ;
    [popupTblView reloadData] ;
    [UtilityClass displayPopupWithContentView:popupView view:self.view] ;
}

#pragma mark - API Methods
-(void)getKeywords{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        [ApiCrowdBootstrap getKeywords:^(NSDictionary *responseDict) {
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

-(void)getCampaignKeywords{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        [ApiCrowdBootstrap getCampaignKeywords:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                [campaignKeywordsArray removeAllObjects] ;
                if([responseDict objectForKey:@"keywords"]){
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:@"keywords"] mutableCopy]) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:[dict mutableCopy]] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        [campaignKeywordsArray addObject:obj] ;
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

-(void)getStartupsList{
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

-(void)addCampaign {
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_AddCampaign] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAddCampaignAPI_UserID] ;
        [dictParam setObject:campaignNameTxtFld.text forKey:kAddCampaignAPI_CampaignName] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:selectedStartupIndex] valueForKey:@"id"]] forKey:kAddCampaignAPI_StartupID] ;
        [dictParam setObject:summaryTxtFld.text forKey:kAddCampaignAPI_Summary] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",targetAmount.amount] forKey:kAddCampaignAPI_TargetAmount] ;
        [dictParam setObject:@"0" forKey:kAddCampaignAPI_FundRaisedSoFar] ;
        [dictParam setObject:dueDateTxtFld.text forKey:kAddCampaignAPI_DueDate] ;
        [dictParam setObject:[UtilityClass convertTagsArrayToStringforArray:selectedKeywordsArray withTagsArray:keywordsArray] forKey:kAddCampaignAPI_Keywords] ;
        [dictParam setObject:[UtilityClass convertTagsArrayToStringforArray:selectedCampaignKeywordsArray withTagsArray:campaignKeywordsArray] forKey:kAddCampaignAPI_CampaignKeywords] ;
        if(imgData)[dictParam setObject:imgData forKey:kAddCampaignAPI_CampaignImage] ;
        if(videoData)[dictParam setObject:videoData forKey:kAddCampaignAPI_Video] ;
        
         NSLog(@"dictParam: %@",dictParam) ;
        
        progressLbl.hidden = NO ;
        progressView.hidden = NO ;
        [ApiCrowdBootstrap addCampaignwithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            progressLbl.hidden = YES ;
            progressView.hidden = YES ;
            NSLog(@"responseDict >>>>> %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                // [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil] ;
                [UtilityClass showNotificationMessgae:CAMPAIGN_CREATED_MESSAGE withResultType:@"0" withDuration:1] ;
                [self.navigationController popViewControllerAnimated:YES] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
            
        } failure:^(NSError *error) {
            
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
            progressLbl.hidden = YES ;
            progressView.hidden = YES ;
            
        } progress:^(double progress) {
            // NSLog(@"progress %f",progress) ;
            progressView.progress = progress ;
            int prog = (int)progress*100;
            progressLbl.text = [NSString stringWithFormat:@"%d %@",prog,@"% Completed"] ;
        }] ;
    }
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

#pragma mark - DatePicker Value Changed
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    dueDateTxtFld.text = strDate;
}

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)Calendar_ClickAction:(id)sender {
    [datePickerView setDate:[dateFormatter dateFromString:dueDateTxtFld.text] animated:YES] ;
    [dueDateTxtFld becomeFirstResponder] ;
}

- (IBAction)openStartupPickerView_ClickAction:(id)sender {
    [chooseStartupTxtFld becomeFirstResponder] ;
    if(selectedStartupIndex != -1){
        int index = [UtilityClass getPickerViewSelectedIndexFromArray:startupsArray forID:[[startupsArray objectAtIndex:selectedStartupIndex] valueForKey:@"id"]] ;
        if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
        else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
    }
    else [pickerView selectRow:0 inComponent:0 animated:YES] ;
}

- (IBAction)Browse_ClickAction:(id)sender {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Choose From Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController.view setTintColor:[UtilityClass blueColor]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil] ;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:([sender tag] == IMAGE_SELECTED?@"Upload Image":@"Upload Video") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([sender tag] == IMAGE_SELECTED)[self displayImagePickerWithType:NO withMediaType:YES] ;
        else [self displayImagePickerWithType:NO withMediaType:NO] ;
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:([sender tag] == IMAGE_SELECTED?@"Take Picture":@"Record Video") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([sender tag] == IMAGE_SELECTED)[self displayImagePickerWithType:YES withMediaType:YES] ;
        else [self displayImagePickerWithType:YES withMediaType:NO] ;
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)CheckUncheck_ClickAction:(id)sender {
    UIButton *btn = (UIButton*)sender ;
    if([btn.accessibilityLabel isEqualToString:CHECK_IMAGE ]){ // Check
        [btn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = UNCHECK_IMAGE ;
        if(selectedKeywordType == TARGET_MARKET_SELECTED) [[keywordsArray objectAtIndex:btn.tag] setValue:@"0" forKey:@"isSelected"] ;
        else [[campaignKeywordsArray objectAtIndex:btn.tag] setValue:@"0" forKey:@"isSelected"] ;
        
    }
    else{ // Uncheck
        
        [btn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = CHECK_IMAGE ;
        if(selectedKeywordType == TARGET_MARKET_SELECTED)[[keywordsArray objectAtIndex:btn.tag] setValue:@"1" forKey:@"isSelected"] ;
        else [[campaignKeywordsArray objectAtIndex:btn.tag] setValue:@"1" forKey:@"isSelected"] ;
    }
}

- (IBAction)DeleteVideo_ClickAction:(id)sender {
    videoNameLbl.text = @"" ;
    videoDeleteBtn.hidden = YES ;
    videoData = nil ;
}


- (IBAction)Submit_ClickAction:(id)sender {
    
    if(![self validateTextField:campaignNameTxtFld withMessage:campaignNameTxtFld.placeholder]) return ;
    else if(![self validateTextField:chooseStartupTxtFld withMessage:chooseStartupTxtFld.placeholder] || selectedStartupIndex == -1) return ;
    else if(selectedKeywordsArray.count < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_CampaignTargetMarketdRequired] animated:YES completion:nil] ;
        return ;
    }
    else if(selectedCampaignKeywordsArray.count < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_CampaignKeywordRequired] animated:YES completion:nil] ;
        return ;
    }
    else if(![self validateTextField:dueDateTxtFld withMessage:dueDateTxtFld.placeholder]) return ;
    else if(![self validateTextField:targetAmount withMessage:targetAmount.placeholder]) return ;
    else if(![self validateTextView:summaryTxtFld withMessage:@"Summary"]) return ;
    else [self addCampaign] ;
    
}

#pragma mark - Validation Methods
-(BOOL)validateTextField:(UITextField*)textField withMessage:(NSString*)message{
    if(textField.text.length < 1){
        [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"%@ Required",message]] animated:YES completion:nil] ;
        return NO ;
    }
    return YES ;
}

-(BOOL)validateTextView:(UITextView*)textView withMessage:(NSString*)message{
    if(textView.text.length < 1){
        [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"%@ Required",message]] animated:YES completion:nil] ;
        return NO ;
    }
    return YES ;
}

#pragma mark - Image Picker Methods
-(void)displayImagePickerWithType:(BOOL)isCameraMode withMediaType:(BOOL)isImageSelected{
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
    if(isImageSelected) picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    else picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie,(NSString *)kUTTypeVideo, nil];
    [self.navigationController presentViewController:picker animated:YES completion:nil] ;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"info>> %@",info) ;
    if([info[UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]){
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        imageView.image = chosenImage;
        imgData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1);
    }
    else{
        
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
            NSString *moviePath = [videoUrl path];
            
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
            }
            videoData = [NSData dataWithContentsOfFile:moviePath] ;
            
            videoNameLbl.text = @"Campaign Video" ;
            videoDeleteBtn.hidden = NO ;
            
            /*AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
            NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
            AVAssetTrack *track = [tracks objectAtIndex:0];
            
            CGSize mediaSize = track.naturalSize;*/
            
            
           // NSLog(@"mediaSize: %@",mediaSize.) ;
        }
    }
}

#pragma mark - ToolBar Buttons Action
- (IBAction)NumberToolBar_ClickAction:(id)sender {
    [targetAmount resignFirstResponder] ;
    [summaryTxtFld becomeFirstResponder] ;
}

- (IBAction)toolbarButtons_ClickAction:(id)sender {
    [chooseStartupTxtFld resignFirstResponder] ;
    if([sender tag] == DONE_CLICKED) {
        if([pickerView selectedRowInComponent:0] == 0) {
            chooseStartupTxtFld.text = @"" ;
            selectedStartupIndex = -1 ;
        }
        else {
            chooseStartupTxtFld.text = [[startupsArray objectAtIndex:[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] ;
            selectedStartupIndex = (int)[pickerView selectedRowInComponent:0]-1 ;
        }
    }
    else {
        if( selectedStartupIndex == -1 ) chooseStartupTxtFld.text = @"" ;
        else  chooseStartupTxtFld.text = [[startupsArray objectAtIndex:selectedStartupIndex] valueForKey:@"name"] ;
    }
}

- (IBAction)DatePickerToolbarButtons_ClickAction:(id)sender {
    [dueDateTxtFld resignFirstResponder] ;
    if([sender tag] == DONE_CLICKED) {
    }
    else{
        dueDateTxtFld.text = prevDueDate ;
    }
}

#pragma mark - Keywords Popup Buttons Action
- (IBAction)AddTag_ClickAction:(id)sender {
    selectedKeywordType = (int)[sender tag] ;
    [self openTagsPopup] ;
}

- (IBAction)OK_ClickAction:(id)sender {
//    [popupView dismissPresentingPopup] ;
    [popupView removeFromSuperview];
    if(selectedKeywordType == TARGET_MARKET_SELECTED) {
        [selectedKeywordsArray removeAllObjects] ;
        for (NSMutableDictionary *obj in keywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"])
                [selectedKeywordsArray addObject:[obj valueForKey:@"name"]] ;
        }
        [self setKeywordsTagViewWithTagView:keywordsView withButton:keywordsBtn forArray:selectedKeywordsArray] ;
    }
    else{
        [selectedCampaignKeywordsArray removeAllObjects] ;
        for (NSMutableDictionary *obj in campaignKeywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"])[selectedCampaignKeywordsArray addObject:[obj valueForKey:@"name"]] ;
        }
        
        [self setKeywordsTagViewWithTagView:campaignKeywordsView withButton:campaignKeywordsBtn forArray:selectedCampaignKeywordsArray] ;
    }
   
}

#pragma mark - Tap Gesture
- (void)txtViewTapped_Gesture:(id )sender {
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    selectedKeywordType = (int)[tapRecognizer.view tag] ;
    [self openTagsPopup] ;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(selectedKeywordType == TARGET_MARKET_SELECTED) return keywordsArray.count ;
    else return campaignKeywordsArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaymentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keywordsCell"] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    NSDictionary *dict ;
    if(selectedKeywordType == TARGET_MARKET_SELECTED)
        dict = [keywordsArray objectAtIndex:indexPath.row] ;
    else
        dict = [campaignKeywordsArray objectAtIndex:indexPath.row] ;
    
    cell.companyNameLbl.text = [dict valueForKey:@"name"] ;
    cell.checkboxBtn.tag = indexPath.row ;
    if([[NSString stringWithFormat:@"%@",[dict valueForKey:@"isSelected"]] isEqualToString:@"0" ]) { // Check
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
    if(selectedKeywordType == TARGET_MARKET_SELECTED) return @"Target Market" ;
    return @"Campaign Keywords" ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == popupTblView) {
        PaymentsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
        [self CheckUncheck_ClickAction:cell.checkboxBtn] ;
    }
}

#pragma mark - Picker View Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1 ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return startupsArray.count+1 ;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(row == 0)return CHOOSE_STARTUP_DEFAULT_TEXT ;
    else return [[startupsArray objectAtIndex:row-1] valueForKey:@"name"] ;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(row == 0)chooseStartupTxtFld.text = @"" ;
    else chooseStartupTxtFld.text = [[startupsArray objectAtIndex:row-1] valueForKey:@"name"] ;
}

#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

-(void)tagsControl:(UIView *)tag withTagControlIndex:(NSInteger)tagControlIndex removedFromIndex:(NSInteger)index {
    NSLog(@"index: %ld control: %ld", (long)index,(long)tagControlIndex);
    [tag removeFromSuperview];
    
    if(tagControlIndex == TARGET_MARKET_SELECTED) {
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedKeywordsArray objectAtIndex:index]] ;
        for (int i=0; i<keywordsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[keywordsArray objectAtIndex:i] valueForKey:@"name"]] ;
            if([keywordName isEqualToString:selectedName]){
                [[keywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedKeywordsArray removeObjectAtIndex:index] ;
        [self setKeywordsTagViewWithTagView:keywordsView withButton:keywordsBtn forArray:selectedKeywordsArray] ;
    }
    else{
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedCampaignKeywordsArray objectAtIndex:index]] ;
        for (int i=0; i<campaignKeywordsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[campaignKeywordsArray objectAtIndex:i] valueForKey:@"name"]] ;
            if([keywordName isEqualToString:selectedName]){
                [[campaignKeywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedCampaignKeywordsArray removeObjectAtIndex:index] ;
        [self setKeywordsTagViewWithTagView:campaignKeywordsView withButton:campaignKeywordsBtn forArray:selectedCampaignKeywordsArray] ;
    }
}


#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
    if([textField isEqual:campaignNameTxtFld])
        [chooseStartupTxtFld becomeFirstResponder] ;
    else if([textField isEqual:chooseStartupTxtFld])
        [dueDateTxtFld becomeFirstResponder] ;
    else if([textField isEqual:dueDateTxtFld])
        [targetAmount becomeFirstResponder] ;
    else if([textField isEqual:targetAmount])
        [summaryTxtFld becomeFirstResponder] ;
    else {
    }
    
    return YES ;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if([textField isEqual:dueDateTxtFld])prevDueDate = dueDateTxtFld.text ;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    _selectedItem = nil ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _selectedItem = textField ;
    if([textField isEqual:campaignNameTxtFld]) return YES;
    else if([textField isEqual:chooseStartupTxtFld]) {
        if(selectedStartupIndex != -1) {
            int index = [UtilityClass getPickerViewSelectedIndexFromArray:startupsArray forID:[[startupsArray objectAtIndex:selectedStartupIndex] valueForKey:@"id"]] ;
            if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
            else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
        }
        else [pickerView selectRow:0 inComponent:0 animated:YES] ;
        return YES;
    }
    else if([textField isEqual:dueDateTxtFld]) {
         [datePickerView setDate:[dateFormatter dateFromString:textField.text] animated:YES] ;
        return YES;
    }
    else if([textField isEqual:targetAmount]) return YES ;
    else   return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES ;
}


#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    
    [self moveToOriginalFrame] ;
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    _selectedItem=textView;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    _selectedItem = nil ;
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
    if (!CGRectContainsPoint(aRect, self.selectedItem.frame.origin )) {
        [self.scrollView scrollRectToVisible:self.selectedItem.frame animated:YES];
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

@end
