//
//  Info_StartupViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 20/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "Info_StartupViewController.h"
#import "TextFieldTableViewCell.h"
#import "DescriptionTableViewCell.h"
#import "RoadmapTableViewCell.h"
#import "AddStartupButtonTableViewCell.h"
#import "PaymentsTableViewCell.h"
#import "GraphicTableViewCell.h"
#import "KLCPopup.h"
#import "KeywordsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "PublicProfileViewController.h"

@interface Info_StartupViewController ()

@end

@implementation Info_StartupViewController

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
}

#pragma mark - Custom Methods
-(void)popUpScrollViewSettings {
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 6.0;
    scrollView.contentSize = CGSizeMake(imgView.frame.size.width, imgView.frame.size.height);
    scrollView.delegate = self;
}

-(void)resetNavigationBarsettings {
    self.title = [NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupsAPI_StartupName]] ;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back_Icon"] style:UIBarButtonItemStylePlain target:self action:@selector(BackButton_ClickAction)] ;
    self.navigationItem.leftBarButtonItem = backButton ;
}

-(void)resetUISettings {
    
    NSLog(@"getStartupDetails: %@",[UtilityClass getStartupDetails]) ;
    
    if([[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupsAPI_isEntrepreneur]] isEqualToString:@"true"]) {
        isEntrepreneur = YES ;
        isEditModeEnabled = YES ;
    }
    else {
        isEntrepreneur = NO ;
        isEditModeEnabled = NO ;
    }
    if([UtilityClass getStartupInfoMode] == YES) [self resetNavigationBarsettings] ;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [tblView addGestureRecognizer:singleTapGestureRecognizer];
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startupOverviewDataNotification:)
                                                 name:kNotificationStartupOverview
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideKeypadNotification:)
                                                 name:kNotificationStartupDisableTextField
                                               object:nil];
    
    
    
    [self initializeSectionArray] ;
    [self popUpScrollViewSettings] ;
    [self resetFieldsAccordingToEditMode] ;
}

-(void)initializeSectionArray {
    
    sectionsArray         = [[NSMutableArray alloc] init] ;
    keywordsArray         = [[NSMutableArray alloc] init] ;
    selectedKeywordsArray = [[NSMutableArray alloc] init] ;
    roadmapArray          = [[NSMutableArray alloc] init] ;
    
    NSArray *fieldsArray = @[@"Startup Name",@"Description",@"Roadmap Graphic",@"Roadmap Deliverables",@"Next Step",@"Keywords",@"Support Required"] ;
    NSArray *parametersArray = @[kStartupOverviewAPI_StartupName,kStartupOverviewAPI_StartupDesc,kStartupOverviewAPI_RoadmapGraphic,kStartupOverviewAPI_RoadmapDeliverable,kStartupOverviewAPI_NextStep,kStartupOverviewAPI_Keywords,kStartupOverviewAPI_SupportRequired] ;
    
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
    
    [tblView reloadData] ;
    
    [self getKeywords] ;
}

-(NSMutableArray*)resetTagsArrayWithData:(NSArray*)array{
    NSMutableArray *tagsArray = [[NSMutableArray alloc] init] ;
    for (NSDictionary *obj in array) {
        [tagsArray addObject:[obj valueForKey:@"name"]] ;
    }
    return tagsArray ;
}

-(void)openTagsPopup {
    
    [self.view endEditing:YES] ;
    [self resetPopupArray] ;
    [popupTblView reloadData] ;
    [UtilityClass displayPopupWithContentView:popupView view:self.view] ;
}

-(void)resetPopupArray{
    
    for (int i=0; i<keywordsArray.count; i++) {
        NSString *tagName = [[keywordsArray objectAtIndex:i] valueForKey:@"name"] ;
        for (NSString *selectedTagName in selectedKeywordsArray) {
            if([selectedTagName isEqualToString:tagName]){
                [[keywordsArray objectAtIndex:i] setValue:@"1" forKey:@"isSelected"] ;
            }
        }
    }
}

-(void)resetFieldsAccordingToEditMode{
    NSLog(@"isEditModeEnabled: %d",isEditModeEnabled) ;
    for (int i = 0; i<sectionsArray.count; i++) {
        if(i != kCellIndex_OverviewDeliverables )
        {
            NSLog(@"i: %d secdtion: %@",i,[sectionsArray objectAtIndex:i]) ;
            if(i == kCellIndex_OverviewDesc){
                DescriptionTableViewCell *cell = (DescriptionTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]] ;
                cell.descriptionTxtView.editable = isEditModeEnabled ;
            }
            
            else if(i == kCellIndex_OverviewStartupName || i == kCellIndex_OverviewSupportReq){
                TextFieldTableViewCell *cell = (TextFieldTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]] ;
                cell.textFld.enabled = isEditModeEnabled ;
                cell.textFld.userInteractionEnabled = YES ;
            }
        }
    }
    [tblView reloadData] ;
}

-(NSMutableDictionary*)getStartupOverviewDict{
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:kUpdateStartupAPI_StartupID] ;
    
    [dictParam setObject:[NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:kCellIndex_OverviewStartupName] valueForKey:@"value"]] forKey:kUpdateStartupAPI_StartupName] ;
    
    [dictParam setObject:[NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:kCellIndex_OverviewDesc] valueForKey:@"value"]] forKey:kUpdateStartupAPI_Description] ;
    
    [dictParam setObject:[NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:kCellIndex_OverviewNextStep] valueForKey:@"value"]] forKey:kUpdateStartupAPI_NextStep] ;
    
    [dictParam setObject:[self convertTagsArrayToStringforArray:selectedKeywordsArray withTagsArray:keywordsArray] forKey:kUpdateStartupAPI_Keywords] ;
    
    [dictParam setObject:[NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:kCellIndex_OverviewSupportReq] valueForKey:@"value"]] forKey:kUpdateStartupAPI_SupportRequired] ;
    
    [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kUpdateStartupAPI_UserID] ;
    
    if(imageData)[dictParam setObject:imageData forKey:kUpdateStartupAPI_RoadmapGraphic] ;
    
    return dictParam ;
}

#pragma mark - Validation Methods
-(BOOL)validatetextFieldsWithSectionIndex:(int)section{
    
    NSString *value = [[sectionsArray objectAtIndex:section] valueForKey:@"value"] ;
    if(section == kCellIndex_OverviewDesc){
        if(value.length < 10 ){
            [self presentViewController:[UtilityClass displayAlertMessage:kAlert_Validation_Startup_Description] animated:YES completion:nil];
            return NO ;
        }
    }
    else{
        if(value.length < 1 ){
            [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"%@%@",[[sectionsArray objectAtIndex:section] valueForKey:@"field"],kAlert_SignUp_BlankField]] animated:YES completion:nil];
            return NO ;
        }
    }
    
    return YES ;
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

#pragma mark - Tap gesture
- (void)txtViewTapped_Gesture:(UITapGestureRecognizer *)gestureRecognizer{
    [self openTagsPopup] ;
}

#pragma mark - Public Methods
-(void)getStartupInfoForSearch {
    [self getStartupOverviewData] ;
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
#pragma mark - Notifcation Methods
- (void)startupOverviewDataNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationStartupOverview]){
        
        [self getStartupOverviewData] ;
    }
}

- (void)hideKeypadNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationStartupDisableTextField]){
        
        [self.view endEditing:YES] ;
    }
}


#pragma mark - API Methods
-(void)getKeywords{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        [ApiCrowdBootstrap getStartupKeywords:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                
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


-(void)getStartupOverviewData {
    
    //[self resetUISettings] ;
    //[self initializeSectionArray] ;
    if(imageData) imageData = nil ;
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupOverviewAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:kStartupsAPI_StartupID] ;
       // NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getStartupOverviewWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
           if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
               
               for ( int i=0; i<sectionsArray.count ; i++ ) {
                   NSString *key = [[sectionsArray objectAtIndex:i] valueForKey:@"key"] ;
                   if(i != kCellIndex_OverviewRoadmapGraphic && i != kCellIndex_OverviewDeliverables  && i != kCellIndex_OverviewKeywords ){
                       if([responseDict valueForKey:key])
                        [[sectionsArray objectAtIndex:i] setValue:[responseDict valueForKey:key] forKey:@"value"] ;
                   }
               }
               
               strFundedBy = [responseDict valueForKey:@"funded_by"];
               strFundCreator = [responseDict valueForKey:@"fund_creator"];
               
               strStartupProfileLink = [responseDict valueForKey:@"startup_profile_file"];
               // Save it locally
               [kUSERDEFAULTS setValue:strStartupProfileLink forKey:@"StartupProfileLink"];

               if([responseDict objectForKey:kStartupOverviewAPI_RoadmapGraphic])
                [[sectionsArray objectAtIndex:kCellIndex_OverviewRoadmapGraphic] setValue:[responseDict objectForKey:kStartupOverviewAPI_RoadmapGraphic] forKey:@"value"];
               
               if([responseDict objectForKey:kStartupOverviewAPI_Keywords])
                selectedKeywordsArray = [self resetTagsArrayWithData:[responseDict objectForKey:kStartupOverviewAPI_Keywords]] ;
               
               if([responseDict objectForKey:kStartupOverviewAPI_RoadmapDeliverable])
                   roadmapArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:kStartupOverviewAPI_RoadmapDeliverable]] ;
               
               [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[sectionsArray objectAtIndex:kCellIndex_OverviewRoadmapGraphic] valueForKey:@"value"]]] placeholderImage:[UIImage imageNamed:kImage_GraphicPicDefault]] ;
               
               [tblView reloadData] ;
               //[tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:kCellIndex_OverviewRoadmapGraphic]] withRowAnimation:UITableViewRowAnimationNone] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)updateStartupOverview {
    
    if(![self validatetextFieldsWithSectionIndex:kCellIndex_OverviewStartupName]) return ;
    else if(![self validatetextFieldsWithSectionIndex:kCellIndex_OverviewDesc]) return ;
    else if(selectedKeywordsArray.count < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_Validation_Startup_Keyword] animated:YES completion:nil] ;
        return ;
    }
    else if(![self validatetextFieldsWithSectionIndex:kCellIndex_OverviewSupportReq]) return ;
    
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_UpdateStartup] ;
        [self getStartupOverviewDict] ;
        NSMutableDictionary *dictParam = [self getStartupOverviewDict] ;
         NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap updateStartupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
             NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                 [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"0" withDuration:1] ;
                
                // Update Startup Name on Navigation Bar
                NSMutableDictionary *startupDetails = (NSMutableDictionary*)[UtilityClass getStartupDetails] ;
                [startupDetails setValue:[[sectionsArray objectAtIndex:kCellIndex_OverviewStartupName] valueForKey:@"value"] forKey:kStartupsAPI_StartupName] ;
                [UtilityClass setStartupDetails:startupDetails] ;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateStartupName
                 object:self];
                
                [self resetFieldsAccordingToEditMode] ;
            }
            else if([responseDict objectForKey:@"errors"]) {
                NSDictionary *errorsData = (NSDictionary*)[responseDict objectForKey:@"errors"] ;
                NSString *errorStr = @"" ;
                for (NSString *value in [errorsData allValues]) {
                    errorStr = [NSString stringWithFormat:@"%@\n%@",errorStr,value] ;
                }
                if(![errorStr isEqualToString:@""])[self presentViewController:[UtilityClass displayAlertMessage:errorStr] animated:YES completion:nil];
            }
            
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass showNotificationMessgae:@"Startup updated successfully." withResultType:@"1" withDuration:1];
            
            // Update Startup Name on Navigation Bar
            NSMutableDictionary *startupDetails = (NSMutableDictionary*)[UtilityClass getStartupDetails] ;
            [startupDetails setValue:[[sectionsArray objectAtIndex:kCellIndex_OverviewStartupName] valueForKey:@"value"] forKey:kStartupsAPI_StartupName] ;
            [UtilityClass setStartupDetails:startupDetails] ;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateStartupName
                                                                object:self];
            
            [self resetFieldsAccordingToEditMode] ;
            
           // [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - IBAction Methods
-(void)BackButton_ClickAction{
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)AddTag_ClickAction:(id)sender {
     if(isEditModeEnabled != NO)[self openTagsPopup] ;
}

- (IBAction)CloseImgPopupView_ClickAction:(id)sender {
//    [imgPopupView dismissPresentingPopup] ;
    [imgPopupView removeFromSuperview];
}

- (IBAction)EditRoadmap_ClickAction:(id)sender {
    
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

- (IBAction)Edit_ClickAction:(UIButton*)button {
    if([UtilityClass getStartupInfoMode] == YES){
        
        NSLog(@"getStartupDetails: %@",[UtilityClass getStartupDetails]) ;
       
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupsAPI_EntrepreneurID]] forKey:kRecommendedContAPI_ContractorID] ;
        [dict setValue:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupsAPI_EntrepreneurName]] forKey:kRecommendedContAPI_Contractor_Name] ;
        [dict setValue:TEAM_TYPE_ENTREPRENEUR forKey:kStartupTeamAPI_MemberRole] ;
        [UtilityClass setContractorDetails:[dict mutableCopy]] ;
        
        viewController.profileMode = [NSString stringWithFormat:@"%d",PROFILE_MODE_SEARCH] ;
        [UtilityClass setUserType:ENTREPRENEUR] ;
        [UtilityClass setViewEntProfileMode:YES] ;
        [UtilityClass setProfileMode:PROFILE_MODE_SEARCH] ;
        
        NSLog(@"GetUserType: %ld",(long)[UtilityClass GetUserType]) ;
        
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
    else{
        //isEditModeEnabled = !isEditModeEnabled ;
       /* if([button.titleLabel.text isEqualToString:INFO_EDIT_BUTTON] && isEditModeEnabled == YES) [self resetFieldsAccordingToEditMode] ;
        else [self updateStartupOverview] ;*/
        
        [self updateStartupOverview] ;
    }
}

- (IBAction)OK_ClickAction:(id)sender {
//    [popupView dismissPresentingPopup] ;
    [popupView removeFromSuperview];
    if(selectedKeywordsArray.count>0)[selectedKeywordsArray removeAllObjects] ;
    for (NSMutableDictionary *obj in keywordsArray) {
        NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
        if([isSelectedStr isEqualToString:@"1"])[selectedKeywordsArray addObject:[obj valueForKey:@"name"]] ;
    }
    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:kCellIndex_OverviewKeywords]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
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
    GraphicTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kCellIndex_OverviewRoadmapGraphic]] ;
    cell.graphicImg.image = chosenImage ;
    imgView.image = chosenImage ;
    
    imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1);
}

#pragma mark - Table header gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[sectionsArray count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [tblView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

- (void)graphicTappedAction:(UITapGestureRecognizer *)gestureRecognizer{
    
    imgPopupView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width-5, 250);
    imgPopupView.backgroundColor = [UIColor clearColor];
    //imgPopupView.layer.cornerRadius = 12.0;
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        [self.view addSubview:imgPopupView];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            imgPopupView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                imgPopupView.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    
    /*
    KLCPopupLayout layout = KLCPopupLayoutMake((KLCPopupHorizontalLayout)KLCPopupHorizontalLayoutCenter,
                                               (KLCPopupVerticalLayout)KLCPopupVerticalLayoutCenter);
    
    KLCPopup* popup = [KLCPopup popupWithContentView:imgPopupView
                                            showType:(KLCPopupShowType)KLCPopupShowTypeBounceIn
                                         dismissType:(KLCPopupDismissType)KLCPopupDismissTypeBounceOut
                                            maskType:(KLCPopupMaskType)KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:YES
                               dismissOnContentTouch:NO];
    
    [popup showWithLayout:layout];
     */
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == tblView) {
        if(section == kCellIndex_OverviewRoadmapGraphic) {
            if ([[arrayForBool objectAtIndex:section] boolValue]) {
                if(isEntrepreneur == YES && isEditModeEnabled == YES) return 2;
                else return 1 ;
            }
            else  return 0 ;
        }
        else if(section == kCellIndex_OverviewDeliverables) {
            if ([[arrayForBool objectAtIndex:section] boolValue]) {
                 return roadmapArray.count ;
            }
            else  return 0 ;
        }
        else return 1;
    }
    else {
        return keywordsArray.count ;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == tblView) {
        if([UtilityClass getStartupInfoMode] == YES) return sectionsArray.count+1 ;
        else{
            if(isEntrepreneur == YES) return sectionsArray.count+1 ;
            else return sectionsArray.count ;
        }
    }
   else return 1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == tblView) {
        if(indexPath.section == sectionsArray.count) {
            AddStartupButtonTableViewCell *cell = (AddStartupButtonTableViewCell*)[tableView dequeueReusableCellWithIdentifier:EDIT_CELL_IDENTIFIER] ;
            if([UtilityClass getStartupInfoMode] == YES){
                 [cell.button setTitle:INFO_VIEW_ENT_PROFILE_BUTTON forState:UIControlStateNormal] ;
            }
            else {
                //if(isEditModeEnabled == NO) [cell.button setTitle:INFO_EDIT_BUTTON forState:UIControlStateNormal] ;
               // else [cell.button setTitle:INFO_SUBMIT_BUTTON forState:UIControlStateNormal] ;
                [cell.button setTitle:INFO_SUBMIT_BUTTON forState:UIControlStateNormal] ;
            }
            
            cell.selectionStyle = UITableViewCellSeparatorStyleNone ;
            return cell ;
        }
        else if(indexPath.section == kCellIndex_OverviewDesc) {
            DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DESCRIPTION_CELL_IDENTIFIER] ;
            
            [UtilityClass setTextViewBorder:cell.descriptionTxtView] ;
            [UtilityClass addMarginsOnTextView:cell.descriptionTxtView] ;
            cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone ;
            cell.descriptionTxtView.tag = indexPath.section ;
            cell.descriptionTxtView.returnKeyType = UIReturnKeyNext ;
            return cell ;
        }
        else if(indexPath.section == kCellIndex_OverviewRoadmapGraphic) {
            if(indexPath.row >0 && isEntrepreneur == YES && isEditModeEnabled == YES) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EDIT_ROADMAP_CELL_IDENTIFIER] ;
                cell.selectionStyle = UITableViewCellSeparatorStyleNone ;
                return cell ;
            }
            else {
                GraphicTableViewCell *cell = (GraphicTableViewCell*)[tableView dequeueReusableCellWithIdentifier:ROADMAP_GRAPHIC_CELL_IDENTIFIER] ;
                cell.selectionStyle = UITableViewCellSeparatorStyleNone ;
                if(!imageData){
                    NSString* imgUrl = [[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [cell.graphicImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:kImage_GraphicPicDefault]] ;
                }
                else cell.graphicImg.image = imgView.image ;
                
                UITapGestureRecognizer  *graphicTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(graphicTappedAction:)];
                cell.graphicImg.userInteractionEnabled = YES ;
                [cell.graphicImg addGestureRecognizer:graphicTapped];
                
                return cell ;
            }
        }
        else if(indexPath.section == kCellIndex_OverviewDeliverables) {
            RoadmapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ROADMAP_CELL_IDENTIFIER] ;
            cell.roadmapLbl.text = [NSString stringWithFormat:@"%@",[[roadmapArray objectAtIndex:indexPath.row] valueForKey:kStartupOverviewAPI_DeliverableName]] ;
            if (![[[roadmapArray objectAtIndex:indexPath.row] valueForKey:kStartupOverviewAPI_DeliverableLink] isEqualToString:@""]) {
//                cell.backgroundColor = [UIColor colorWithRed:5.0/255.0 green:106.0/255.0 blue:31.0/255.0 alpha:1.0f];
                [cell.contentView setBackgroundColor:[UIColor colorWithRed:5.0/255.0 green:106.0/255.0 blue:31.0/255.0 alpha:1.0f]];
                cell.roadmapLbl.textColor = [UIColor whiteColor];
            } else {
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.roadmapLbl.textColor = [UIColor blackColor];
            }
            cell.selectionStyle = UITableViewCellSeparatorStyleNone ;
            return cell ;
        }
        else if(indexPath.section == kCellIndex_OverviewKeywords) {
            KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KEYWORDS_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [UtilityClass setButtonBorder:cell.button] ;
            
            cell.tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
            cell.tagsScrollView.backgroundColor = [UIColor clearColor] ;
            cell.tagsScrollView.tag = indexPath.row ;
            cell.button.tag = indexPath.row ;
            cell.plusBtn.tag = indexPath.row ;
            
            NSMutableArray *tags ;
            tags = [selectedKeywordsArray mutableCopy] ;
            
            if(tags.count >0)[cell.button setHidden:YES] ;
            else [cell.button setHidden:NO] ;
            
            if(isEntrepreneur == YES && isEditModeEnabled == YES) cell.plusBtn.hidden = NO ;
            else cell.plusBtn.hidden = YES ;
            
            cell.tagsScrollView.tagPlaceholder = @"" ;
            if(isEditModeEnabled == NO)[cell.button setTitle:[NSString stringWithFormat:@"No %@ Added",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] forState:UIControlStateNormal] ;
            else [cell.button setTitle:[NSString stringWithFormat:@"Add %@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] forState:UIControlStateNormal] ;
            cell.tagsScrollView.tags = [tags mutableCopy];
            cell.tagsScrollView.tagsDeleteButtonColor = [UIColor whiteColor];
            cell.tagsScrollView.tagsTextColor = [UIColor whiteColor] ;
            if(isEditModeEnabled == NO) cell.tagsScrollView.mode = TLTagsControlModeList;
            else  cell.tagsScrollView.mode = TLTagsControlModeEdit;
            [cell.tagsScrollView setTapDelegate:self];
            [cell.tagsScrollView setDeleteDelegate:self];
            
            cell.tagsScrollView.tagsBackgroundColor = [UtilityClass orangeColor];
            
            [cell.tagsScrollView reloadTagSubviews];
            
            UITapGestureRecognizer  *txtViewTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(txtViewTapped_Gesture:)];
            if(isEditModeEnabled != NO) [cell.tagsScrollView addGestureRecognizer:txtViewTapped];
            return cell ;
        }
        else {
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TEXTFIELD__CELL_IDENTIFIER] ;
            [UtilityClass setTextFieldBorder:cell.textFld] ;
            [UtilityClass addMarginsOnTextField:cell.textFld] ;
            cell.fieldNameLbl.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            cell.textFld.placeholder = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] ;
            cell.textFld.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone ;
            cell.textFld.tag = indexPath.section ;
            cell.textFld.delegate = self ;
            
            if (indexPath.section == kCellIndex_OverviewSupportReq) {
                if ([strFundedBy isEqualToString:@""])
                    cell.fundedByLbl.hidden = true;
                else {
                    cell.fundedByLbl.text = [NSString stringWithFormat:@"Funded By : %@", strFundedBy];
                    cell.fundedByLbl.hidden = false;
                }
            }
            else
                cell.fundedByLbl.hidden = true;
            
            if(indexPath.section == kCellIndex_OverviewStartupName)
                cell.textFld.returnKeyType = UIReturnKeyNext ;
            else
                cell.textFld.returnKeyType = UIReturnKeyDone ; ;
            return cell ;
        }
    }
    else {
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == tblView) {
        if(indexPath.section == kCellIndex_OverviewDesc) return 120 ;
        else if(indexPath.section == kCellIndex_OverviewRoadmapGraphic) {
            if(indexPath.row > 0 && isEntrepreneur == YES ) return 45 ;
            else return 100 ;
        }
        else if(indexPath.section == kCellIndex_OverviewDeliverables) return 35 ;
        else if(indexPath.section == kCellIndex_OverviewKeywords) return 70 ;
        else if(indexPath.section == sectionsArray.count) return 45 ;
        else if (indexPath.section == kCellIndex_OverviewSupportReq) return 90;
        else return 75 ;
    }
    else {
        return 50 ;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(tableView == tblView) {
        if(section == kCellIndex_OverviewRoadmapGraphic || section == kCellIndex_OverviewDeliverables)return 45;
        else return 0 ;
    }
    else return 30 ;
   
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(tableView == popupTblView) {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 30)] ;
        sectionView.backgroundColor = [UIColor colorWithRed:226.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1] ;
        
        UILabel *sectionLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, sectionView.frame.size.width-40, sectionView.frame.size.height)] ;
        sectionLbl.backgroundColor = [UIColor clearColor] ;
        sectionLbl.text = @"Keywords" ;
        sectionLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:18] ;
        sectionLbl.textColor = [UtilityClass blueColor] ;
        [sectionView addSubview:sectionLbl] ;
        return sectionView ;
    }
    else {
        //if(section == ROADMAP_SECTION_INDEX) {
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,45)];
        sectionView.backgroundColor = [UIColor clearColor] ;
        sectionView.tag = section;
        
        // Background view
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, tableView.frame.size.width,35)];
        bgView.backgroundColor = [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1];
        
        /*UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:sectionView.bounds];
         sectionView.layer.masksToBounds = NO;
         sectionView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
         sectionView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
         sectionView.layer.shadowOpacity = 0.5f;
         sectionView.layer.shadowPath = shadowPath.CGPath;*/
        
        // Title Label
        UILabel *viewLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, tblView.frame.size.width-20, 35)];
        viewLabel.backgroundColor = [UIColor clearColor];
        viewLabel.textColor = [UtilityClass textColor];
        viewLabel.font = [UIFont systemFontOfSize:15];
        viewLabel.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:section] valueForKey:@"field"]];
        
        // Expand-Collapse icon
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(tblView.frame.size.width-34,viewLabel.frame.origin.y+viewLabel.frame.size.height/2-7 ,14, 14)];
        if ([[arrayForBool objectAtIndex:section] boolValue]) imgView.image = [UIImage imageNamed:COLLAPSE_SECTION_IMAGE] ;
        else imgView.image = [UIImage imageNamed:EXPAND_SECTION_IMAGE] ;
        
        [sectionView addSubview:bgView] ;
        [sectionView addSubview:viewLabel];
        [sectionView addSubview:imgView];
        
        /********** Add UITapGestureRecognizer to SectionView   **************/
        UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
        [sectionView addGestureRecognizer:headerTapped];
        
        return  sectionView;
        /* }
         else{
         UIView *sectionView = [tableView dequeueReusableCellWithIdentifier:EDIT_CELL_IDENTIFIER] ;
         return sectionView ;
         }*/
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   if(tableView == tblView) return @"" ;
   else return @"Keywords" ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == popupTblView) {
        PaymentsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
        [self checkUncheck_ClickAction:cell.checkboxBtn] ;
    }
    else {
        if(indexPath.section == kCellIndex_OverviewDeliverables) {
            
            NSLog(@"link: %@",[[NSString stringWithFormat:@"%@",[[roadmapArray objectAtIndex:indexPath.row] valueForKey:kStartupOverviewAPI_DeliverableLink]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]) ;
            
            NSString* link = [[NSString stringWithFormat:@"%@",[[roadmapArray objectAtIndex:indexPath.row] valueForKey:kStartupOverviewAPI_DeliverableLink]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            if([link isEqualToString:@""] || [link isEqualToString:@" "]) return ;
         NSString *filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,link] ;
           
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:filePath]];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // if you have index/header text in your tableview change your index text color
    if(tblView == popupTblView) {
        UITableViewHeaderFooterView *headerIndexText = (UITableViewHeaderFooterView *)view;
        [headerIndexText.textLabel setTextColor:[UtilityClass blueColor]];
    }
}

#pragma mark - ScrollView Delegate Methods
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imgView ;
}


#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

-(void)tagsControl:(UIView *)tag withTagControlIndex:(NSInteger)tagControlIndex removedFromIndex:(NSInteger)index {
    NSLog(@"index: %ld control: %ld", (long)index,(long)tagControlIndex);
    [tag removeFromSuperview];
    NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedKeywordsArray objectAtIndex:index]] ;
    for (int i=0; i<keywordsArray.count; i++) {
        NSString *keywordName = [NSString stringWithFormat:@"%@",[[keywordsArray objectAtIndex:i] valueForKey:@"name"]] ;
        if([keywordName isEqualToString:selectedName]) {
            [[keywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
            break ;
        }
    }
    [selectedKeywordsArray removeObjectAtIndex:index] ;
    
    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:kCellIndex_OverviewKeywords]] withRowAnimation:UITableViewRowAnimationNone] ;
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
   
    if(textField.tag == 0) {
        DescriptionTableViewCell *cell =  [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kCellIndex_OverviewDesc]] ;
        [cell.descriptionTxtView becomeFirstResponder] ;
        return NO ;
    }
    //else if(textField.tag == sectionsArray.count -2)return YES ;
    
    return YES ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    _selectedItem = textField ;
    
    return YES ;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    _selectedItem = nil ;
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    [[sectionsArray objectAtIndex:textField.tag] setValue:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"value"] ;
    
    return YES ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [[sectionsArray objectAtIndex:textView.tag] setValue:[textView.text stringByReplacingCharactersInRange:range withString:text] forKey:@"value"] ;
    
    if([text isEqualToString:@"\n"]){
         [textView resignFirstResponder];
        if(textView.tag == kCellIndex_OverviewDesc){
            TextFieldTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kCellIndex_OverviewSupportReq]] ;
            [cell.textFld becomeFirstResponder] ;
            return NO ;
            
        }
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _selectedItem = nil ;
    
    CGPoint pointInTable = [textView.superview convertPoint:textView.frame.origin toView:tblView];
    CGPoint contentOffset = tblView.contentOffset;
    
    contentOffset.y = (pointInTable.y - textView.inputAccessoryView.frame.size.height);
    
    [tblView setContentOffset:contentOffset animated:YES];
    return YES ;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    _selectedItem = nil ;
    
    if ([textView.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        CGPoint buttonPosition = [textView convertPoint:CGPointZero
                                                 toView: tblView];
        NSIndexPath *indexPath = [tblView indexPathForRowAtPoint:buttonPosition];
        
        [tblView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
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
