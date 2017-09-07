//
//  EditCampaignViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 11/04/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "EditCampaignViewController.h"
#import "CampaignDocumentTableViewCell.h"
#import "GraphicTableViewCell.h"
#import "KLCPopup.h"
#import "KeywordsTableViewCell.h"
#import "DescriptionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommitTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "DobTableViewCell.h"
#import "KLCPopup.h"
#import "PaymentsTableViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UploadVideoTableViewCell.h"
#import "CampaignAmountTableViewCell.h"

@interface EditCampaignViewController ()

@end

@implementation EditCampaignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetUISetiings] ;
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

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   /* if(chooseStartupTxtFld.isSelected){
        if( selectedStartupIndex == -1 ) chooseStartupTxtFld.text = @"" ;
        else  chooseStartupTxtFld.text = [[startupsArray objectAtIndex:selectedStartupIndex] valueForKey:@"name"] ;
        
    }*/
    
    [self.view endEditing:YES];
}

- (void)singleTap:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
    
}


#pragma mark - Custom Methods
-(void)resetUISetiings{
    
    campaignData = [[UtilityClass getCampaignDetails] mutableCopy];
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = [NSString stringWithFormat:@"%@",[campaignData valueForKey:kCampaignsAPI_CampaignName]] ;
   
    [datePickerView setMinimumDate:[NSDate date]] ;
    
    [datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.tblView addGestureRecognizer:singleTapGestureRecognizer];
    
    [self initializeSectionArray] ;
   
}

-(void)initializeSectionArray{
    
    NSArray *fieldsArray = @[@"Name",@"Startup Name",@"Target Market",@"Campaign Keyword",@"Due Date",@"Target Amount",@"Summary",@"Campaign Image",@"View Document",@"Play Audio",@"Play Video",@"Upload"] ;
    NSArray *parametersArray = @[kCampaignDetailAPI_CampaignName,kCampaignDetailAPI_StartupName,kCampaignDetailAPI_Keywords,kCampaignDetailAPI_CampaignKeywords,kCampaignDetailAPI_DueDate,kCampaignDetailAPI_TargetAmount,kCampaignDetailAPI_Summary,kCampaignDetailAPI_CampaignImage,kCampaignDetailAPI_DocumentsList,kCampaignDetailAPI_AudiosList,kCampaignDetailAPI_VideosList,@"Upload"] ;
    
    sectionsArray = [[NSMutableArray alloc] init] ;
    for (int i=0; i<fieldsArray.count ; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
        [dict setValue:[parametersArray objectAtIndex:i] forKey:@"key"] ;
        [dict setValue:@"" forKey:@"value"] ;
        [dict setValue:[fieldsArray objectAtIndex:i] forKey:@"field"] ;
        
        [sectionsArray addObject:dict] ;
    }
    
    arrayForBool = [[NSMutableArray alloc] init] ;
    for (int i=0; i<[sectionsArray count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    
    keywordsArray = [[NSMutableArray alloc] init] ;
    campaignKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedCampaignKeywordsArray = [[NSMutableArray alloc] init] ;
    audiosArray = [[NSMutableArray alloc] init] ;
    videosArray = [[NSMutableArray alloc] init] ;
    docuementsArray = [[NSMutableArray alloc] init] ;
    deletedFiles  = [[NSMutableArray alloc] init] ;
    prevDueDate       = @"" ;
    selectedStartupID = @"" ;
    [self getKeywords] ;
    [self getCampaignKeywords] ;
    [self getStartupsList] ;
    [self getCampaignDetail] ;
    
}

-(NSMutableArray*)resetTagsArrayWithData:(NSArray*)array{
    NSMutableArray *tagsArray = [[NSMutableArray alloc] init] ;
    for (NSDictionary *obj in array) {
        [tagsArray addObject:[obj valueForKey:@"name"]] ;
    }
    return tagsArray ;
}


-(void)resetPopupArray:(NSMutableArray*)mainArray forSelectedArray:(NSMutableArray *)selectedArray{
    
    for (int i=0; i<mainArray.count; i++) {
        NSString *tagName = [[mainArray objectAtIndex:i] valueForKey:@"name"] ;
        for (NSString *selectedTagName in selectedArray) {
            if([selectedTagName isEqualToString:tagName]){
                [[mainArray objectAtIndex:i] setValue:@"1" forKey:@"isSelected"] ;
            }
        }
    }
    
}

-(void)openTagsPopup{
    [self.view endEditing:YES] ;
    if(selectedKeywordType == TARGET_MARKET_SELECTED)[self resetPopupArray:keywordsArray forSelectedArray:selectedKeywordsArray] ;
    else [self resetPopupArray:campaignKeywordsArray forSelectedArray:selectedCampaignKeywordsArray] ;
    [popupTblView reloadData] ;
    [UtilityClass displayPopupWithContentView:popupView view:self.view] ;
}

#pragma mark - ToolBar Buttons Action
- (IBAction)NumberToolBar_ClickAction:(id)sender {
    CampaignAmountTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_TARGET_AMOUNT_INDEX]] ;
    [cell.txtField resignFirstResponder] ;
    
    DescriptionTableViewCell *descriptioncell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_SUMMARY_SECTION_INDEX]] ;
    [descriptioncell.descriptionTxtView becomeFirstResponder] ;
}

- (IBAction)toolbarButtons_ClickAction:(id)sender {
     DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_STARTUP_SECTION_INDEX]] ;
    [cell.textFld resignFirstResponder] ;
    if([sender tag] == DONE_CLICKED){
        if([pickerView selectedRowInComponent:0] == 0){
            cell.textFld.text = @"" ;
            selectedStartupID = @"" ;
            
            [[sectionsArray objectAtIndex:EDIT_CAMPAIGN_STARTUP_SECTION_INDEX] setValue:@"" forKey:@"value"] ;
        }
        
        else{
            cell.textFld.text = [[startupsArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] ;
            selectedStartupID = [[startupsArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"id"]  ;
            
            [[sectionsArray objectAtIndex:EDIT_CAMPAIGN_STARTUP_SECTION_INDEX] setValue:[[startupsArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] forKey:@"value"] ;
        }
    }
    else{
        if([pickerView selectedRowInComponent:0] == 0)cell.textFld.text = @"" ;
        else cell.textFld.text = [[sectionsArray objectAtIndex:EDIT_CAMPAIGN_STARTUP_SECTION_INDEX] valueForKey:@"value"]  ;
    }
}

- (IBAction)DatePickerToolbarButtons_ClickAction:(id)sender {
    DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_DUEDATE_SECTION_INDEX]] ;
    [cell.textFld resignFirstResponder] ;
    
    if([sender tag] == DONE_CLICKED){
        prevDueDate = [[sectionsArray objectAtIndex:EDIT_CAMPAIGN_DUEDATE_SECTION_INDEX] valueForKey:@"value"] ;
        [[sectionsArray objectAtIndex:EDIT_CAMPAIGN_DUEDATE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
    }
    
    else{
        cell.textFld.text = [[sectionsArray objectAtIndex:EDIT_CAMPAIGN_DUEDATE_SECTION_INDEX] valueForKey:@"value"] ;
    }
    
    [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_DUEDATE_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationNone] ;
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
    DobTableViewCell *cell ;
    cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_DUEDATE_SECTION_INDEX]] ;
    cell.textFld.text = strDate;
}

#pragma mark - Tap gesture
- (void)txtViewTapped_Gesture:(id)sender{
    
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    NSLog(@"tag: %d",[tapRecognizer.view tag]) ;
    if([tapRecognizer.view tag] == EDIT_CAMPAIGN_TARGET_MARKET_SECTION_INDEX) selectedKeywordType = TARGET_MARKET_SELECTED ;
    else selectedKeywordType = CAMPAIGN_KEYWORD_SELECTED ;
    [self openTagsPopup] ;
}

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)AddTag_ClickAction:(id)sender {
    NSLog(@"tag: %d",[sender tag]) ;
    if([sender tag] == EDIT_CAMPAIGN_TARGET_MARKET_SECTION_INDEX) selectedKeywordType = TARGET_MARKET_SELECTED ;
    else selectedKeywordType = CAMPAIGN_KEYWORD_SELECTED ;
    
    [self openTagsPopup] ;
}

- (IBAction)CheckUncheck_ClickAction:(id)sender {
    UIButton *btn = (UIButton*)sender ;
    if([btn.accessibilityLabel isEqualToString:CHECK_IMAGE ]){ // Check
        [btn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = UNCHECK_IMAGE ;
        if(selectedKeywordType == TARGET_MARKET_SELECTED)[[keywordsArray objectAtIndex:btn.tag] setValue:@"0" forKey:@"isSelected"] ;
        else [[campaignKeywordsArray objectAtIndex:btn.tag] setValue:@"0" forKey:@"isSelected"] ;
    }
    else{ // Uncheck
        
        [btn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = CHECK_IMAGE ;
        if(selectedKeywordType == TARGET_MARKET_SELECTED)[[keywordsArray objectAtIndex:btn.tag] setValue:@"1" forKey:@"isSelected"] ;
        else [[campaignKeywordsArray objectAtIndex:btn.tag] setValue:@"1" forKey:@"isSelected"] ;
    }
}

- (IBAction)Ok_ClickAction:(id)sender {
//    [popupView dismissPresentingPopup] ;
    [popupView removeFromSuperview];
    if(selectedKeywordType == TARGET_MARKET_SELECTED){
        [selectedKeywordsArray removeAllObjects] ;
        for (NSMutableDictionary *obj in keywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"])[selectedKeywordsArray addObject:[obj valueForKey:@"name"]] ;
        }
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_TARGET_MARKET_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
    }
    else{
        [selectedCampaignKeywordsArray removeAllObjects] ;
        for (NSMutableDictionary *obj in campaignKeywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"])[selectedCampaignKeywordsArray addObject:[obj valueForKey:@"name"]] ;
        }
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_CAMP_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
    }
    
}

- (IBAction)DeleteDoc_ClickAction:(UIButton*)button {
    
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:[button.accessibilityValue intValue] inSection:button.tag] ;
    [self.tblView beginUpdates] ;
    if(button.tag == EDIT_CAMPAIGN_DOCUMENTS_SECTION_INDEX){
        if([docuementsArray objectAtIndex:cellIndexPath.row]){
            [deletedFiles addObject:[[docuementsArray objectAtIndex:cellIndexPath.row] valueForKey:@"file"]] ;
            [docuementsArray removeObjectAtIndex:cellIndexPath.row];
            [self.tblView deleteRowsAtIndexPaths:@[cellIndexPath]
                           withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    else if(button.tag == EDIT_CAMPAIGN_AUIDIOS_SECTION_INDEX){
        if([audiosArray objectAtIndex:cellIndexPath.row]){
            [deletedFiles addObject:[[audiosArray objectAtIndex:cellIndexPath.row] valueForKey:@"file"]] ;
            [audiosArray removeObjectAtIndex:cellIndexPath.row];
        }
    }
    else{
        if([videosArray objectAtIndex:cellIndexPath.row]){
            [deletedFiles addObject:[[videosArray objectAtIndex:cellIndexPath.row] valueForKey:@"file"]] ;
            [videosArray removeObjectAtIndex:cellIndexPath.row];
        }
    }
    [self.tblView deleteRowsAtIndexPaths:@[cellIndexPath]
                        withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tblView endUpdates] ;
    
   // [self performSelector:@selector(resetChooseSecurityQuesCell) withObject:nil afterDelay:0.2] ;
    
    /*CampaignDocumentTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:button.tag]] ;
    if(button.tag == EDIT_CAMPAIGN_DOCUMENTS_SECTION_INDEX){
        [docuementsArray removeObjectAtIndex:cell.lbl.tag]  ;
      
    }
    else if(button.tag == EDIT_CAMPAIGN_AUIDIOS_SECTION_INDEX){
         [audiosArray removeObjectAtIndex:cell.lbl.tag]  ;
    }
    else{
         [videosArray removeObjectAtIndex:cell.lbl.tag]  ;
    }
    [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:cell.btn.tag]] withRowAnimation:UITableViewRowAnimationAutomatic] ;*/
}


- (IBAction)Dropdown_ClickAction:(id)sender {
    
    DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_STARTUP_SECTION_INDEX]] ;
    [cell.textFld becomeFirstResponder] ;
    
    int index = [UtilityClass getPickerViewSelectedIndexFromArray:startupsArray forID:selectedStartupID] ;
    if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
    else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
    
}

- (IBAction)Calender_ClickAction:(id)sender {
    
    DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_DUEDATE_SECTION_INDEX]] ;
    [datePickerView setDate:[dateFormatter dateFromString:cell.textFld.text] animated:YES] ;
    [cell.textFld becomeFirstResponder] ;
}

- (IBAction)Submit_ClickAction:(id)sender {
    
    if(![self validatetextFieldsWithSectionIndex:EDIT_CAMPAIGN_NAME_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:EDIT_CAMPAIGN_STARTUP_SECTION_INDEX]) return ;
    else if(selectedKeywordsArray.count < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_CampaignTargetMarketdRequired] animated:YES completion:nil] ;
        return ;
    }
    else if(selectedCampaignKeywordsArray.count < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_CampaignKeywordRequired] animated:YES completion:nil] ;
        return ;
    }
    else if(![self validatetextFieldsWithSectionIndex:EDIT_CAMPAIGN_DUEDATE_SECTION_INDEX]) return ;
    else if(![self validatetextTargetAmountWithSectionIndex:EDIT_CAMPAIGN_TARGET_AMOUNT_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:EDIT_CAMPAIGN_SUMMARY_SECTION_INDEX]) return ;
    else [self updateCampaignDetails] ;
    
}

- (IBAction)ViewContractors_ClickAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kViewContractorIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)Upload_ClickAction:(id)sender {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Choose From Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController.view setTintColor:[UtilityClass blueColor]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil] ;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:([sender tag] == CAMPAIGN_IMAGE_SELECTED?@"Upload Image":@"Upload Video") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([sender tag] == CAMPAIGN_IMAGE_SELECTED)[self displayImagePickerWithType:NO withMediaType:YES] ;
        else [self displayImagePickerWithType:NO withMediaType:NO] ;
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:([sender tag] == CAMPAIGN_IMAGE_SELECTED?@"Take Picture":@"Record Video") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([sender tag] == CAMPAIGN_IMAGE_SELECTED)[self displayImagePickerWithType:YES withMediaType:YES] ;
        else [self displayImagePickerWithType:YES withMediaType:NO] ;
    }]];
    
     [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)deleteVideo_ClickAction:(id)sender {
    UploadVideoTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_UPLOAD_SECTION_INDEX]] ;
    cell.fileName.text = @"" ;
    cell.deleteBtn.hidden = YES ;
    videoData = nil ;
}

#pragma mark - Validation Methods
-(BOOL)validatetextFieldsWithSectionIndex:(int)section{
    
    NSString *value = [[sectionsArray objectAtIndex:section] valueForKey:@"value"] ;
    NSLog(@"value: %@",value) ;
    if(value.length < 1 ){
        [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"%@%@",[[sectionsArray objectAtIndex:section] valueForKey:@"field"],kAlert_SignUp_BlankField]] animated:YES completion:nil];
        return NO ;
    }
    return YES ;
}

-(BOOL)validatetextTargetAmountWithSectionIndex:(int)section{
    
    //[NSNumber numberWithFloat:[[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"] floatValue]]
    if([[[sectionsArray objectAtIndex:EDIT_CAMPAIGN_TARGET_AMOUNT_INDEX] valueForKey:@"value"] intValue]){
        if([[[sectionsArray objectAtIndex:EDIT_CAMPAIGN_TARGET_AMOUNT_INDEX] valueForKey:@"value"] intValue] == 0){
            [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"%@%@",[[sectionsArray objectAtIndex:section] valueForKey:@"field"],kAlert_SignUp_BlankField]] animated:YES completion:nil];
            return NO ;
        }
        return YES ;
    }
    else{
        [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"%@%@",[[sectionsArray objectAtIndex:section] valueForKey:@"field"],kAlert_SignUp_BlankField]] animated:YES completion:nil];
        return NO ;
    }
}

-(NSString*)convertTagsArrayToStringforArray:(NSMutableArray*)array withTagsArray:(NSArray*)tagsArray{
    NSString *tagsStr = @"" ;
    BOOL isFirstTag = YES ;
    for (NSDictionary *dict in tagsArray) {
        NSString *value = [dict valueForKey:@"name"] ;
        for (NSString *tag in array) {
            if([tag isEqualToString:value]){
                if(isFirstTag) tagsStr = [dict valueForKey:@"id"] ;
                else tagsStr = [NSString stringWithFormat:@"%@,%@",tagsStr,[dict valueForKey:@"id"]] ;
                isFirstTag = NO ;
            }
        }
    }
    return tagsStr ;
}

-(NSString *)getDeletedFilesString{
    NSString *str = @"" ;
    for(int i=0 ;i<deletedFiles.count ; i++) {
        if(i == 0) str = [deletedFiles objectAtIndex:i] ;
        else str = [NSString stringWithFormat:@"%@,%@",str,[deletedFiles objectAtIndex:i]] ;
    }
    return str ;
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
        GraphicTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_IMAGES_SECTION_INDEX]] ;
        cell.graphicImg.image = chosenImage;
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
            
            UploadVideoTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_UPLOAD_SECTION_INDEX]] ;
            cell.fileName.text = @"Campaign Video" ;
            cell.deleteBtn.hidden = NO ;
            
            /*AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
             NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
             AVAssetTrack *track = [tracks objectAtIndex:0];
             
             CGSize mediaSize = track.naturalSize;*/
            
            
            // NSLog(@"mediaSize: %@",mediaSize.) ;
        }
        
    }
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
                    for (NSMutableDictionary *dict in (NSArray*)[[responseDict objectForKey:@"keywords"] mutableCopy]) {
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
                    for (NSMutableDictionary *dict in (NSArray*)[[responseDict objectForKey:@"keywords"] mutableCopy]) {
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

-(void)getCampaignDetail{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCampaignDetailAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[campaignData valueForKey:kCampaignsAPI_CampaignID]] forKey:kCampaignDetailAPI_CampaignID] ;
        [ApiCrowdBootstrap getCampaignDetailwithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                if([responseDict valueForKey:kCampaignDetailAPI_CampaignDetail]){
                    NSDictionary *dict = [responseDict valueForKey:kCampaignDetailAPI_CampaignDetail] ;
                    for ( int i=0; i<sectionsArray.count ; i++ ) {
                        NSString *key = [[sectionsArray objectAtIndex:i] valueForKey:@"key"] ;
                        if(i != EDIT_CAMPAIGN_TARGET_MARKET_SECTION_INDEX && i != EDIT_CAMPAIGN_CAMP_KEYWORDS_SECTION_INDEX && i != EDIT_CAMPAIGN_AUIDIOS_SECTION_INDEX  && i != EDIT_CAMPAIGN_VIDEOS_SECTION_INDEX && i != EDIT_CAMPAIGN_DOCUMENTS_SECTION_INDEX && i != EDIT_CAMPAIGN_UPLOAD_SECTION_INDEX){
                            if([dict valueForKey:key])  [[sectionsArray objectAtIndex:i] setValue:[dict valueForKey:key] forKey:@"value"] ;
                        }
                    }
                    
                    if([dict objectForKey:kCampaignDetailAPI_Keywords])
                        selectedKeywordsArray = [self resetTagsArrayWithData:[dict objectForKey:kCampaignDetailAPI_Keywords]] ;
                    
                    if([dict objectForKey:kCampaignDetailAPI_CampaignKeywords])
                        selectedCampaignKeywordsArray = [self resetTagsArrayWithData:[dict objectForKey:kCampaignDetailAPI_CampaignKeywords]] ;
                    
                    if([dict objectForKey:kCampaignDetailAPI_AudiosList])
                        audiosArray = [NSMutableArray arrayWithArray:(NSArray*)[dict objectForKey:kCampaignDetailAPI_AudiosList]] ;
                    
                    if([dict objectForKey:kCampaignDetailAPI_VideosList])
                        videosArray = [NSMutableArray arrayWithArray:(NSArray*)[dict objectForKey:kCampaignDetailAPI_VideosList]] ;
                    
                    if([dict objectForKey:kCampaignDetailAPI_DocumentsList])
                        docuementsArray = [NSMutableArray arrayWithArray:(NSArray*)[dict objectForKey:kCampaignDetailAPI_DocumentsList]] ;
                    
                    if([dict valueForKey:kCampaignDetailAPI_StartupID])
                        selectedStartupID = [dict valueForKey:kCampaignDetailAPI_StartupID] ;
                    
                    NSLog(@"sectionsArray >> %@",sectionsArray) ;
                    
                    [_tblView reloadData] ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)updateCampaignDetails{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_UpdateCampaign] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%@",[campaignData valueForKey:kCampaignsAPI_CampaignID]] forKey:kEditCampaignAPI_CampaignID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kEditCampaignAPI_UserID] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:EDIT_CAMPAIGN_NAME_SECTION_INDEX] valueForKey:@"value"] forKey:kEditCampaignAPI_CampaignName] ;
        [dictParam setObject:selectedStartupID forKey:kEditCampaignAPI_StartupID] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:EDIT_CAMPAIGN_SUMMARY_SECTION_INDEX] valueForKey:@"value"] forKey:kEditCampaignAPI_Summary] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:EDIT_CAMPAIGN_TARGET_AMOUNT_INDEX] valueForKey:@"value"] forKey:kEditCampaignAPI_TargetAmount] ;
        [dictParam setObject:@"0" forKey:kEditCampaignAPI_FundRaisedSoFar] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:EDIT_CAMPAIGN_DUEDATE_SECTION_INDEX] valueForKey:@"value"] forKey:kEditCampaignAPI_DueDate] ;
        [dictParam setObject:[self convertTagsArrayToStringforArray:selectedKeywordsArray withTagsArray:keywordsArray] forKey:kEditCampaignAPI_Keywords] ;
        [dictParam setObject:[self convertTagsArrayToStringforArray:selectedCampaignKeywordsArray withTagsArray:campaignKeywordsArray] forKey:kEditCampaignAPI_CampaignKeywords] ;
        [dictParam setObject:[self getDeletedFilesString] forKey:kEditCampaignAPI_DeletedFiles] ;
        if(imgData)[dictParam setObject:imgData forKey:kEditCampaignAPI_CampaignImage] ;
        if(videoData)[dictParam setObject:videoData forKey:kEditCampaignAPI_Video] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        CommitTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionsArray.count]] ;
        cell.progressView.hidden = NO ;
        cell.progressLbl.hidden = NO ;
        [ApiCrowdBootstrap editCampaignwithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            cell.progressView.hidden = YES ;
            cell.progressLbl.hidden = YES ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                // [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil] ;
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"0" withDuration:1] ;
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
           // else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
            cell.progressView.hidden = YES ;
            cell.progressLbl.hidden = YES ;
            
        } progress:^(double progress) {
            cell.progressView.progress = progress ;
            int prog = (int)progress*100;
            cell.progressLbl.text = [NSString stringWithFormat:@"%d %@",prog,@"% Completed"] ;
            
        }] ;
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tblView){
        if(section <= EDIT_CAMPAIGN_SUMMARY_SECTION_INDEX || section == sectionsArray.count)return 1;
        else{
            if( section == EDIT_CAMPAIGN_IMAGES_SECTION_INDEX){
                if ([[arrayForBool objectAtIndex:section] boolValue]) return 1;
                else return 0 ;
            }
            else if(section == EDIT_CAMPAIGN_DOCUMENTS_SECTION_INDEX ){
                if ([[arrayForBool objectAtIndex:section] boolValue]) return docuementsArray.count;
                else  return 0 ;
            }
            else if(section == EDIT_CAMPAIGN_AUIDIOS_SECTION_INDEX){
                if ([[arrayForBool objectAtIndex:section] boolValue]) return audiosArray.count;
                else  return 0 ;
            }
            else{
                if ([[arrayForBool objectAtIndex:section] boolValue]) return videosArray.count;
                else  return 0 ;
            }
        }
    }
    else{
        if(selectedKeywordType == TARGET_MARKET_SELECTED) return keywordsArray.count ;
        else return campaignKeywordsArray.count ;
    }
   
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.tblView){
        if(indexPath.section == EDIT_CAMPAIGN_UPLOAD_SECTION_INDEX){
            UploadVideoTableViewCell *cell = (UploadVideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"UploadCell"] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            cell.fileName.text = @"" ;
            cell.deleteBtn.hidden = YES ;
            return cell ;
        }
        else if(indexPath.section == sectionsArray.count){
            CommitTableViewCell *cell = (CommitTableViewCell*)[tableView dequeueReusableCellWithIdentifier:SUBMIT_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            return cell ;
        }
        else if(indexPath.section ==  EDIT_CAMPAIGN_TARGET_AMOUNT_INDEX){
            CampaignAmountTableViewCell *cell = (CampaignAmountTableViewCell*)[tableView dequeueReusableCellWithIdentifier:AMOUNT_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            cell.fieldNameLbl.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            cell.txtField.placeholder = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            if([[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]floatValue]){
                 cell.txtField.amount = [NSNumber numberWithFloat:[[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"] floatValue]] ;
            }
            cell.txtField.tag = indexPath.section ;
            [UtilityClass setTextFieldBorder:cell.txtField] ;
            [UtilityClass addMarginsOnTextField:cell.txtField] ;
            cell.txtField.keyboardType = UIKeyboardTypeDecimalPad ;
            cell.txtField.inputAccessoryView = numberToolBar ;
            return cell ;
        }
        else if(indexPath.section == EDIT_CAMPAIGN_NAME_SECTION_INDEX || indexPath.section == EDIT_CAMPAIGN_TARGET_AMOUNT_INDEX ){
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TEXTFIELD__CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            cell.fieldNameLbl.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            cell.textFld.placeholder = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            cell.textFld.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"] ;
            cell.textFld.tag = indexPath.section ;
            [UtilityClass setTextFieldBorder:cell.textFld] ;
            [UtilityClass addMarginsOnTextField:cell.textFld] ;
            
            if(indexPath.section == EDIT_CAMPAIGN_NAME_SECTION_INDEX){
                cell.textFld.keyboardType = UIKeyboardTypeAlphabet ;
            }
            else{
                cell.textFld.keyboardType = UIKeyboardTypeDecimalPad ;
                cell.textFld.inputAccessoryView = numberToolBar ;
            }
            
            return cell ;
            
        }
        else if(indexPath.section == EDIT_CAMPAIGN_STARTUP_SECTION_INDEX ){
            
            DobTableViewCell *cell = (DobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Startups] ;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            cell.fieldNameLbl.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            [UtilityClass setTextFieldBorder:cell.textFld] ;
            [UtilityClass addMarginsOnTextField:cell.textFld] ;
            
            cell.textFld.placeholder =[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            cell.textFld.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"] ;
            cell.textFld.tag = indexPath.section ;
            cell.dropdownBtn.tag = indexPath.section ;
            cell.textFld.inputView = pickerViewContainer ;
            
            return cell ;
        }
        else if(indexPath.section == EDIT_CAMPAIGN_DUEDATE_SECTION_INDEX ){
            
            DobTableViewCell *cell = (DobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"DueDateCell"] ;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            cell.fieldNameLbl.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            [UtilityClass setTextFieldBorder:cell.textFld] ;
            [UtilityClass addMarginsOnTextField:cell.textFld] ;
            
            cell.textFld.placeholder =[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            cell.textFld.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"] ;
            cell.textFld.tag = indexPath.section ;
            cell.dropdownBtn.tag = indexPath.section ;
            cell.textFld.inputView = datePickerViewContainer ;
            
            return cell ;
        }
        else if(indexPath.section == EDIT_CAMPAIGN_TARGET_MARKET_SECTION_INDEX || indexPath.section == EDIT_CAMPAIGN_CAMP_KEYWORDS_SECTION_INDEX){
            KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KEYWORDS_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [UtilityClass setButtonBorder:cell.button] ;
            
            cell.tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
            cell.tagsScrollView.backgroundColor = [UIColor clearColor] ;
            cell.tagsScrollView.tag = indexPath.section ;
            cell.button.tag = indexPath.section ;
            cell.plusBtn.tag = indexPath.section ;
            
            cell.titleLbl.text =  [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            
            NSMutableArray *tags ;
            if(indexPath.section == EDIT_CAMPAIGN_TARGET_MARKET_SECTION_INDEX)tags = [selectedKeywordsArray mutableCopy] ;
            else tags = [selectedCampaignKeywordsArray mutableCopy] ;
            
            if(tags.count >0)[cell.button setHidden:YES] ;
            else [cell.button setHidden:NO] ;
            
            cell.tagsScrollView.tagPlaceholder = [NSString stringWithFormat:@"Add %@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] ;
            [cell.button setTitle:[NSString stringWithFormat:@"Add %@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] forState:UIControlStateNormal] ;
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
        
        else if(indexPath.section == EDIT_CAMPAIGN_SUMMARY_SECTION_INDEX){
            DescriptionTableViewCell *cell = (DescriptionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:SUMMARY_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            cell.fieldNameLbl.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            cell.descriptionTxtView.tag = indexPath.section ;
            [UtilityClass setTextViewBorder:cell.descriptionTxtView] ;
            [UtilityClass addMarginsOnTextView:cell.descriptionTxtView] ;
            /*NSString *summaryText = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
            if(summaryText.length < 1 || [summaryText isEqualToString:@""] || [summaryText isEqualToString:@" "]){
                cell.descriptionTxtView.textColor = [UIColor lightGrayColor] ;
                cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] ;
            }
            else{
                cell.descriptionTxtView.textColor = [UtilityClass textColor] ;
                cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
            }*/
            
            cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
            return cell ;
        }
        else if(indexPath.section == EDIT_CAMPAIGN_IMAGES_SECTION_INDEX){
            GraphicTableViewCell *cell = (GraphicTableViewCell*)[tableView dequeueReusableCellWithIdentifier:IMAGES_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            NSLog(@"camp image: %@",[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]]) ;
            NSString* imgUrl = [[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [cell.graphicImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:kCampainDetail_DefaultImage]] ;
            
            return cell ;
        }
        else{
            CampaignDocumentTableViewCell *cell = (CampaignDocumentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:PLAY_AUDIO_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            cell.btn.tag = indexPath.section;
            cell.btn.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row] ;
            if(indexPath.section == EDIT_CAMPAIGN_DOCUMENTS_SECTION_INDEX) cell.lbl.text = [NSString stringWithFormat:@"Document %d",indexPath.row+1] ;
            else if(indexPath.section == EDIT_CAMPAIGN_AUIDIOS_SECTION_INDEX) cell.lbl.text = [NSString stringWithFormat:@"Audio %d",indexPath.row+1] ;
            else cell.lbl.text = cell.lbl.text = [NSString stringWithFormat:@"Video %d",indexPath.row+1] ;
            /*if(indexPath.section == EDIT_CAMPAIGN_DOCUMENTS_SECTION_INDEX) cell.lbl.text = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[docuementsArray objectAtIndex:indexPath.row] valueForKey:@"file"]] ;
            else if(indexPath.section == EDIT_CAMPAIGN_AUIDIOS_SECTION_INDEX) cell.lbl.text = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[audiosArray objectAtIndex:indexPath.row] valueForKey:@"file"]] ;
            else cell.lbl.text = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[videosArray objectAtIndex:indexPath.row] valueForKey:@"file"]] ;*/
            NSLog(@"data: %@",cell.lbl.text) ;
            return cell ;
        }
    }
    else{
        PaymentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keywordsCell"] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        NSDictionary *dict ;
        if(selectedKeywordType == TARGET_MARKET_SELECTED)dict = [keywordsArray objectAtIndex:indexPath.row] ;
        else dict = [campaignKeywordsArray objectAtIndex:indexPath.row] ;
        cell.companyNameLbl.text = [dict valueForKey:@"name"] ;
        cell.checkboxBtn.tag = indexPath.row ;
        if([[NSString stringWithFormat:@"%@",[dict valueForKey:@"isSelected"]] isEqualToString:@"0" ]){ // Check
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.tblView) return sectionsArray.count+1 ;
    else return 1 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tblView) {
        if(indexPath.section == EDIT_CAMPAIGN_TARGET_MARKET_SECTION_INDEX || indexPath.section == EDIT_CAMPAIGN_CAMP_KEYWORDS_SECTION_INDEX || indexPath.section == sectionsArray.count) return 70 ;
        else if(indexPath.section == EDIT_CAMPAIGN_UPLOAD_SECTION_INDEX )return 100 ;
        else if(indexPath.section == EDIT_CAMPAIGN_SUMMARY_SECTION_INDEX) return 130 ;
        else if(indexPath.section == EDIT_CAMPAIGN_IMAGES_SECTION_INDEX )return 150 ;
        else if(indexPath.section == EDIT_CAMPAIGN_DOCUMENTS_SECTION_INDEX || indexPath.section == EDIT_CAMPAIGN_AUIDIOS_SECTION_INDEX || indexPath.section == EDIT_CAMPAIGN_VIDEOS_SECTION_INDEX )return 45 ;
        else if(indexPath.section == sectionsArray.count) return 45 ;
        else return 75 ;
    }
    else return 50 ;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView == self.tblView ){
        if(section <= EDIT_CAMPAIGN_SUMMARY_SECTION_INDEX || section == EDIT_CAMPAIGN_UPLOAD_SECTION_INDEX || section == sectionsArray.count)return 0;
        // else if (section == EDIT_CAMPAIGN_IMAGES_SECTION_INDEX || section == EDIT_CAMPAIGN_UPLOAD_SECTION_INDEX) return 30 ;
        else return 45 ;
    }
    else return 45 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tblView){
        UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,45)];
        sectionView.tag=section;
        
        // Background view
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, tableView.frame.size.width,35)];
        bgView.backgroundColor=[UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1];
        
        // Title Label
        UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.tblView.frame.size.width-20, 35)];
        viewLabel.backgroundColor=[UIColor clearColor];
        viewLabel.textColor = [UIColor colorWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1];
        viewLabel.font=[UIFont systemFontOfSize:15];
        viewLabel.text=[[sectionsArray objectAtIndex:section] valueForKey:@"field"];
        
        // Expand-Collapse icon
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(self.tblView.frame.size.width-34,viewLabel.frame.origin.y+viewLabel.frame.size.height/2-7 ,14, 14)];
        if ([[arrayForBool objectAtIndex:section] boolValue]) imgView.image = [UIImage imageNamed:COLLAPSE_SECTION_IMAGE] ;
        else imgView.image = [UIImage imageNamed:EXPAND_SECTION_IMAGE] ;
        
        [sectionView addSubview:bgView] ;
        [sectionView addSubview:viewLabel];
        [sectionView addSubview:imgView];
        
        /********** Add UITapGestureRecognizer to SectionView   **************/
        UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
        [sectionView addGestureRecognizer:headerTapped];
        
        return  sectionView;
    }
    else{
        UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,45)];
        sectionView.tag=section;
        
        // Background view
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, tableView.frame.size.width,35)];
        bgView.backgroundColor=[UtilityClass backgroundColor];
        
        // Title Label
        UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.tblView.frame.size.width-20, 35)];
        viewLabel.backgroundColor=[UIColor clearColor];
        viewLabel.textColor = [UtilityClass blueColor];
        viewLabel.font=[UIFont systemFontOfSize:15];
        if(selectedKeywordType == TARGET_MARKET_SELECTED)viewLabel.text= @"Target Market";
        else viewLabel.text= @"Campaign Keywords";
        
        [sectionView addSubview:bgView] ;
        [sectionView addSubview:viewLabel];
        
        return sectionView ;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5 ;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tblView ){
        if(indexPath.section >= EDIT_CAMPAIGN_DOCUMENTS_SECTION_INDEX && indexPath.section < EDIT_CAMPAIGN_UPLOAD_SECTION_INDEX){
            
            NSString *filePath ;
            if(indexPath.section == EDIT_CAMPAIGN_DOCUMENTS_SECTION_INDEX) {
                filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[docuementsArray objectAtIndex:indexPath.row] valueForKey:@"file"]] ;
                dataTitle.text = @"Document" ;
            }
            else if(indexPath.section == EDIT_CAMPAIGN_AUIDIOS_SECTION_INDEX) {
                filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[audiosArray objectAtIndex:indexPath.row] valueForKey:@"file"]] ;
                dataTitle.text = @"Audio" ;
            }
            else {
                filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[videosArray objectAtIndex:indexPath.row] valueForKey:@"file"]] ;
                dataTitle.text = @"Video" ;
            }
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:filePath]];
            
            /*  NSString* htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
             [webView loadHTMLString:htmlString baseURL:nil];
             
             campaignDataView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width-30, self.view.frame.size.height-20);
             campaignDataView.backgroundColor = [UtilityClass backgroundColor];
             campaignDataView.layer.cornerRadius = 12.0;
             
             KLCPopupLayout layout = KLCPopupLayoutMake((KLCPopupHorizontalLayout)KLCPopupHorizontalLayoutCenter,
             (KLCPopupVerticalLayout)KLCPopupVerticalLayoutCenter);
             
             KLCPopup* popup = [KLCPopup popupWithContentView:campaignDataView
             showType:(KLCPopupShowType)KLCPopupShowTypeBounceInFromTop
             dismissType:(KLCPopupDismissType)KLCPopupDismissTypeBounceOutToBottom
             maskType:(KLCPopupMaskType)KLCPopupMaskTypeDimmed
             dismissOnBackgroundTouch:YES
             dismissOnContentTouch:NO];
             
             [popup showWithLayout:layout];*/
        }
    }
    else {
        PaymentsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
        [self CheckUncheck_ClickAction:cell.checkboxBtn] ;
    }
   
}

#pragma mark - Table header gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[sectionsArray count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.tblView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

-(void)tagsControl:(UIView *)tag withTagControlIndex:(NSInteger)tagControlIndex removedFromIndex:(NSInteger)index{
    NSLog(@"index: %ld control: %ld", (long)index,(long)tagControlIndex);
    [tag removeFromSuperview];
    if(tagControlIndex == EDIT_CAMPAIGN_TARGET_MARKET_SECTION_INDEX){
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedKeywordsArray objectAtIndex:index]] ;
        for (int i=0; i<keywordsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[keywordsArray objectAtIndex:i] valueForKey:@"name"]] ;
            if([keywordName isEqualToString:selectedName]){
                [[keywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedKeywordsArray removeObjectAtIndex:index] ;
        
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_TARGET_MARKET_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationNone] ;
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
        
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_CAMP_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationNone] ;
    }
}

#pragma mark -  TSTextField Methods
- (IBAction) amountChanged: (TSCurrencyTextField*) sender
{
    // This could just as easily be _amountLabel.text = sender.text.
    // But we want to demonstrate the amount property here.
   [[sectionsArray objectAtIndex:EDIT_CAMPAIGN_TARGET_AMOUNT_INDEX] setValue: [NSString stringWithFormat:@"%@",[sender amount]] forKey:@"value"] ;
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
    DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_STARTUP_SECTION_INDEX]] ;
    if(row == 0)cell.textFld.text = @"" ;
    else cell.textFld.text = [[startupsArray objectAtIndex:row-1] valueForKey:@"name"] ;
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    
    if([textField tag] == EDIT_CAMPAIGN_NAME_SECTION_INDEX ){
       CampaignAmountTableViewCell * cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_TARGET_AMOUNT_INDEX]] ;
        [cell.txtField becomeFirstResponder] ;
    }
    return YES ;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    _selectedItem = nil ;
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField.tag == EDIT_CAMPAIGN_STARTUP_SECTION_INDEX){
        int index = [UtilityClass getPickerViewSelectedIndexFromArray:startupsArray forID:selectedStartupID] ;
        if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
        else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
    }
    else if(textField.tag == EDIT_CAMPAIGN_DUEDATE_SECTION_INDEX){
        DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:EDIT_CAMPAIGN_DUEDATE_SECTION_INDEX]] ;
        [datePickerView setDate:[dateFormatter dateFromString:cell.textFld.text] animated:YES] ;
    }
    
    return YES ;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
   /* if([textField tag] == EDIT_CAMPAIGN_TARGET_AMOUNT_INDEX){
        if([string rangeOfString: @"."].location != NSNotFound && [textField.text rangeOfString: @"."].location != NSNotFound) {
            return NO ;
        }
    }*/
     [[sectionsArray objectAtIndex:textField.tag] setValue:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"value"] ;
    return YES ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [[sectionsArray objectAtIndex:textView.tag] setValue:[textView.text stringByReplacingCharactersInRange:range withString:text] forKey:@"value"] ;
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    /*if([textView.text isEqualToString:@"Summary"] && textView.textColor == [UIColor lightGrayColor]){
        textView.text = @"" ;
        textView.textColor = [UtilityClass textColor] ;
    }*/
    _selectedItem = nil ;
    
    CGPoint pointInTable = [textView.superview convertPoint:textView.frame.origin toView:self.tblView];
    CGPoint contentOffset = self.tblView.contentOffset;
    
    contentOffset.y = (pointInTable.y - textView.inputAccessoryView.frame.size.height);
    
    [self.tblView setContentOffset:contentOffset animated:YES];
    
    return YES ;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    
   /* if([textView.text isEqualToString:@""]){
        textView.text = @"Summary" ;
        textView.textColor = [UIColor lightGrayColor] ;
    }*/
    
    _selectedItem = nil ;
    
    if ([textView.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        CGPoint buttonPosition = [textView convertPoint:CGPointZero
                                                 toView: self.tblView];
        NSIndexPath *indexPath = [self.tblView indexPathForRowAtPoint:buttonPosition];
        
        [self.tblView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
    }
    return YES;
}


#pragma mark - Keyoboard Actions
- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // If you are using Xcode 6 or iOS 7.0, you may need this line of code. There was a bug when you
    // rotated the device to landscape. It reported the keyboard as the wrong size as if it was still in portrait mode.
    //kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.tblView.contentInset = contentInsets;
    self.tblView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.selectedItem.frame.origin ) ) {
        if(![_selectedItem isKindOfClass:[UITableView class]])[self.tblView scrollRectToVisible:self.selectedItem.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    [self moveToOriginalFrame] ;
}

-(void)moveToOriginalFrame{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tblView.contentInset = contentInsets;
    self.tblView.scrollIndicatorInsets = contentInsets;
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
