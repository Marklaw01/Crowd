//
//  ProfessionalProfile_ViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 19/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "ProfessionalProfile_ViewController.h"
#import "TextFieldTableViewCell.h"
#import "DobTableViewCell.h"
#import "AccreditedTableViewCell.h"
#import "KeywordsTableViewCell.h"
#import "DescriptionTableViewCell.h"
#import "TLTagsControl.h"

@interface ProfessionalProfile_ViewController ()

@end

@implementation ProfessionalProfile_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetUISettings] ;
    [self initializeProfessionalProfileArray] ;
    [self getSQKCCPE] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationProfessionalProfile object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationProfileUpdatedTextView object:nil];
}

#pragma mark - Notifcation Methods
- (void)updateProfessionalProfileNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationProfessionalProfile]){
        
        [self initializeProfessionalProfileArray] ;
        profileDict = [[[UtilityClass getUserProfileDetails] valueForKey:kProfileAPI_ProfessionalInformation] mutableCopy] ;
        NSLog(@"profileDict: %@",profileDict) ;
        for ( int i=0; i<profProfileArray.count ; i++ ) {
            NSString *key = [[profProfileArray objectAtIndex:i] valueForKey:@"key"] ;
            if([UtilityClass GetUserType] == CONTRACTOR){
                if(i != kContProfKeywordsCellIndex && i != kContProfQualificationsCellIndex && i != kContProfCertificationsCellIndex && i != kContProfSkillsCellIndex){
                    if([profileDict valueForKey:key]){
                        NSString *value = [NSString stringWithFormat:@"%@",[profileDict valueForKey:key]] ;
                        if([value isEqualToString:@""] || [value isEqualToString:@" "]) [[profProfileArray objectAtIndex:i] setValue:@"" forKey:@"value"] ;
                        else [[profProfileArray objectAtIndex:i] setValue:[profileDict valueForKey:key] forKey:@"value"] ;
                    }
                }
            }
            else{
                if(i != kEntProfKeywordsCellIndex && i != kEntProfQualificationsCellIndex && i != kEntProfSkillsCellIndex ){
                    if([profileDict valueForKey:key]) {
                        NSString *value = [NSString stringWithFormat:@"%@",[profileDict valueForKey:key]] ;
                        if([value isEqualToString:@""] || [value isEqualToString:@" "]) [[profProfileArray objectAtIndex:i] setValue:@"" forKey:@"value"] ;
                        else [[profProfileArray objectAtIndex:i] setValue:[profileDict valueForKey:key] forKey:@"value"] ;
                    }
                }
            }
        }
        
        selectedKeywordsArray       = [self resetTagsArrayWithData:[profileDict objectForKey:kProfProfileAPI_Keywords]] ;
        selectedCertificationsArray = [self resetTagsArrayWithData:[profileDict objectForKey:kProfProfileAPI_Certifications]] ;
        selectedSkillsArray         = [self resetTagsArrayWithData:[profileDict objectForKey:kProfProfileAPI_Skills]] ;
        selectedQualificationsArray = [self resetTagsArrayWithData:[profileDict objectForKey:kProfProfileAPI_Qualifications]] ;
        selectedPreferredStartupArray = [self resetTagsArrayWithData:[profileDict objectForKey:kProfProfileAPI_PreferredStartup]] ;
        
        if([profileDict valueForKey:kProfProfileAPI_ExperienceID]) selectedExperienceID = [profileDict valueForKey:kProfProfileAPI_ExperienceID] ;
        if([profileDict valueForKey:kProfProfileAPI_ContractorTypeID]) selectedContractorTypeID = [profileDict valueForKey:kProfProfileAPI_ContractorTypeID] ;
        
        [tblView reloadData] ;
    }
}

- (void)updateTextViewNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationProfileUpdatedTextView]){
        
        NSMutableArray *arr = [[UtilityClass getSelectedTagsIndex] mutableCopy] ;
        if([UtilityClass GetUserType] == CONTRACTOR){
            if(arr.count >0){
                if(selectedTextViewIndex == kContProfKeywordsCellIndex){
                    selectedKeywordsArray = arr ;
                    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kContProfKeywordsCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
                    
                }
                else if(selectedTextViewIndex == kContProfQualificationsCellIndex){
                    selectedQualificationsArray = arr ;
                    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kContProfQualificationsCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
                    
                }
                else if(selectedTextViewIndex == kContProfSkillsCellIndex){
                    selectedSkillsArray = arr ;
                    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kContProfSkillsCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
                }
                else if(selectedTextViewIndex == kContProfStartupStageCellIndex){
                    selectedPreferredStartupArray = arr ;
                    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kContProfStartupStageCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
                }
                else {
                    selectedCertificationsArray = arr ;
                    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kContProfCertificationsCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
                }
            }
        }
        else{
            if(arr.count >0){
                if(selectedTextViewIndex == kEntProfKeywordsCellIndex){
                    selectedKeywordsArray = arr ;
                    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kEntProfKeywordsCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
                }
                else if(selectedTextViewIndex == kEntProfQualificationsCellIndex){
                    selectedQualificationsArray = arr ;
                    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kEntProfQualificationsCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
                }
                else{
                    selectedSkillsArray = arr ;
                    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kEntProfSkillsCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
                }
            }
        }
    }
}

- (void)hideKeypadNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationProfileHideKeypad]){
        [self.view endEditing:YES] ;
        [pickerViewContainer setHidden:YES] ;
    }
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    
    experienceArray               = @[] ;
    contractorTypeArray           = @[] ;
    keywordsArray                 = @[] ;
    qualificationsArray           = @[] ;
    certificationsArray           = @[] ;
    skillsArray                   = @[] ;
    startupsArray                 = @[] ;
    
    selectedKeywordsArray         = [[NSMutableArray alloc] init] ;
    selectedCertificationsArray   = [[NSMutableArray alloc] init] ;
    selectedQualificationsArray   = [[NSMutableArray alloc] init] ;
    selectedSkillsArray           = [[NSMutableArray alloc] init] ;
    selectedPreferredStartupArray = [[NSMutableArray alloc] init] ;
    
    selectedExperienceID        = @"" ;
    selectedContractorTypeID    = @"" ;
    
    [pickerViewContainer setHidden:YES] ;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [tblView addGestureRecognizer:singleTapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateProfessionalProfileNotification:)
                                                 name:kNotificationProfessionalProfile
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTextViewNotification:)
                                                 name:kNotificationProfileUpdatedTextView
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideKeypadNotification:)
                                                 name:kNotificationProfileHideKeypad
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

-(void)initializeProfessionalProfileArray{
    
    selectedKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedCertificationsArray = [[NSMutableArray alloc] init] ;
    selectedSkillsArray = [[NSMutableArray alloc] init] ;
    selectedQualificationsArray = [[NSMutableArray alloc] init] ;
    
    NSArray *fieldsArray ;
    NSArray *parametersArray ;
    if([UtilityClass GetUserType] == CONTRACTOR){
        fieldsArray = @[@"Experience",@"Keywords",@"Qualifications",@"Certifications",@"Skills",@"Industry Focus",@"Preferred Startup Stage",@"Contractor Type",@"Accredited Investor"] ;
        parametersArray = @[kProfProfileAPI_Experience,kProfProfileAPI_Keywords,kProfProfileAPI_Qualifications,kProfProfileAPI_Certifications,kProfProfileAPI_Skills,kProfProfileAPI_IndustryFocus,kProfProfileAPI_PreferredStartup,kProfProfileAPI_ContractorType,kProfProfileAPI_AccreditedInvestor] ;
    }
    else{
        fieldsArray = @[@"Company Name",@"Link to Company's website",@"Description",@"Keywords",@"Qualifications",@"Skills",@"Industry Focus"] ;
        
        parametersArray = @[kProfProfileAPI_CompnayName,kProfProfileAPI_WebsiteLink,kProfProfileAPI_Description,kProfProfileAPI_Keywords,kProfProfileAPI_Qualifications,kProfProfileAPI_Skills,kProfProfileAPI_IndustryFocus] ;
    }
    
    profProfileArray = [[NSMutableArray alloc] init] ;
    for (int i=0; i<fieldsArray.count ; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
        [dict setValue:[parametersArray objectAtIndex:i] forKey:@"key"] ;
        [dict setValue:@"" forKey:@"value"] ;
        [dict setValue:[fieldsArray objectAtIndex:i] forKey:@"field"] ;
        
        [profProfileArray addObject:dict] ;
    }
}

-(void)openTagsPopupWithTypeIndex:(int)index{
    [self.view endEditing:YES] ;
    
    [UtilityClass setPopupTypeName:[[profProfileArray objectAtIndex:index] valueForKey:@"field"]] ;
    if([UtilityClass GetUserType] == CONTRACTOR){
        if(index == kContProfKeywordsCellIndex){
            [UtilityClass setTagsPopupData:keywordsArray] ;
            [UtilityClass setSelectedTagsPopupData:selectedKeywordsArray] ;
        }
        else if(index == kContProfQualificationsCellIndex){
            [UtilityClass setTagsPopupData:qualificationsArray] ;
            [UtilityClass setSelectedTagsPopupData:selectedQualificationsArray] ;
        }
        else if(index == kContProfCertificationsCellIndex){
            [UtilityClass setTagsPopupData:certificationsArray] ;
            [UtilityClass setSelectedTagsPopupData:selectedCertificationsArray] ;
        }
        else if(index == kContProfSkillsCellIndex){
            [UtilityClass setTagsPopupData:skillsArray] ;
            [UtilityClass setSelectedTagsPopupData:selectedSkillsArray] ;
        }
        else{
            [UtilityClass setTagsPopupData:startupsArray] ;
            [UtilityClass setSelectedTagsPopupData:selectedPreferredStartupArray] ;
        }
    }
    else{
        if(index == kEntProfKeywordsCellIndex){
            [UtilityClass setTagsPopupData:keywordsArray] ;
            [UtilityClass setSelectedTagsPopupData:selectedKeywordsArray] ;
        }
        else if(index == kEntProfQualificationsCellIndex){
            [UtilityClass setTagsPopupData:qualificationsArray] ;
            [UtilityClass setSelectedTagsPopupData:selectedQualificationsArray] ;
        }
        else{
            [UtilityClass setTagsPopupData:skillsArray] ;
            [UtilityClass setSelectedTagsPopupData:selectedSkillsArray] ;
        }
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kNotificationProfilePopUp
     object:self];
}

-(NSMutableArray*)resetTagsArrayWithData:(NSArray*)array{
    NSMutableArray *tagsArray = [[NSMutableArray alloc] init] ;
    for (NSDictionary *obj in array) {
        [tagsArray addObject:[obj valueForKey:@"name"]] ;
    }
    return tagsArray ;
}

-(void)disablePriceTextField{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kNotificationProfileDisablePriceTextField
     object:self];
}

-(NSString*)getPerHourRate{
    NSString *str = [NSString stringWithFormat:@"%@",[[UtilityClass getUserProfileDetails] valueForKey:kProfileAPI_PerHourRate]] ;
    if([str isEqualToString:@""] || [str isEqualToString:@" "])return @"0.00" ;
    /* else if([str rangeOfString: @"."].location != NSNotFound){
     double Rate_int1 = [str doubleValue];
     
     NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
     [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
     [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
     [formatter setMaximumFractionDigits:2];
     
     return [formatter stringFromNumber:[NSNumber numberWithDouble:Rate_int1]];
     }*/
    else return str ;
}

#pragma mark - Update Profile Methods
-(NSString *)getCellTextFieldValueForCellIndex:(int)index{
    NSString *value = [[profProfileArray objectAtIndex:index] valueForKey:@"value"] ;
    if([value isEqualToString:@" "]) return @"" ;
    else return value ;
}

-(NSMutableDictionary*)getProfessionalProfileUpdatedData{
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfEditProfileAPI_UserID] ;
    [dictParam setObject:[UtilityClass convertTagsArrayToStringforArray:selectedKeywordsArray withTagsArray:keywordsArray] forKey:kProfEditProfileAPI_Keywords] ;
    [dictParam setObject:[UtilityClass convertTagsArrayToStringforArray:selectedQualificationsArray withTagsArray:qualificationsArray] forKey:kProfEditProfileAPI_Qualifications] ;
    [dictParam setObject:[UtilityClass convertTagsArrayToStringforArray:selectedSkillsArray withTagsArray:skillsArray] forKey:kProfEditProfileAPI_Skills] ;
    [dictParam setObject:[UtilityClass convertTagsArrayToStringforArray:selectedPreferredStartupArray withTagsArray:startupsArray] forKey:kProfEditProfileAPI_StartupStage] ;
    
    // Get First and Last Name
    NSString *fullName = [[UtilityClass getUserProfileDetails] valueForKey:kProfileAPI_Name] ;
    NSRange range = [fullName rangeOfString:@" "];
    NSString *firstName = @"" ;
    NSString *lastName = @"" ;
    if(range.location != NSNotFound){
        firstName = [fullName substringToIndex:range.location] ;
        lastName = [fullName substringFromIndex:range.location+1] ;
    }
    else{
        firstName = fullName ;
    }
    [dictParam setObject:firstName forKey:kProfEditProfileAPI_FirstName] ;
    [dictParam setObject:lastName forKey:kProfEditProfileAPI_LastName] ;
    
    if([UtilityClass getProfileImageChangedStatus])[dictParam setObject:[[UtilityClass getUserProfileDetails] objectForKey:kProfileAPI_Image] forKey:kProfEditProfileAPI_Image] ;
    
    if([UtilityClass GetUserType] == CONTRACTOR){
        
        [dictParam setObject:[self getPerHourRate] forKey:kProfEditProfileAPI_Price] ;
        
        NSString *experienceID = [NSString stringWithFormat:@"%@",selectedExperienceID] ;
        if([experienceID isEqualToString:@""] || [experienceID isEqualToString:@" "])experienceID = @"0" ;
        [dictParam setObject:experienceID forKey:kProfEditProfileAPI_ExperienceID] ;
        
        [dictParam setObject:[UtilityClass convertTagsArrayToStringforArray:selectedCertificationsArray withTagsArray:certificationsArray] forKey:kProfEditProfileAPI_Certifications] ;
        
        /* NSString *startupID = [NSString stringWithFormat:@"%@",selectedStartupID] ;
         if([startupID isEqualToString:@""] || [startupID isEqualToString:@" "])startupID = @"0" ;
         [dictParam setObject:startupID forKey:kProfEditProfileAPI_StartupStage] ;*/
        
        NSString *contractorTypeID = [NSString stringWithFormat:@"%@",selectedContractorTypeID] ;
        if([contractorTypeID isEqualToString:@""] || [contractorTypeID isEqualToString:@" "])contractorTypeID = @"0" ;
        [dictParam setObject:contractorTypeID forKey:kProfEditProfileAPI_ContributorType] ;
        
        NSString *accreditedInvestor = [NSString stringWithFormat:@"%@",[[profProfileArray objectAtIndex:kContProfAccreditedCellIndex] valueForKey:@"value"]]   ;
        NSLog(@"accreditedInvestor: %@",accreditedInvestor) ;
        if([accreditedInvestor isEqualToString:@""] || [accreditedInvestor isEqualToString:@" "])[dictParam setObject:@"0" forKey:kProfEditProfileAPI_AccreditedInvestor] ;
        
        else [dictParam setObject:accreditedInvestor forKey:kProfEditProfileAPI_AccreditedInvestor] ;
        
        //[dictParam setObject:[self getCellTextFieldValueForCellIndex:kContProfAccreditedCellIndex] forKey:kProfEditProfileAPI_AccreditedInvestor] ;
        [dictParam setObject:[self getCellTextFieldValueForCellIndex:kContProfSkillsCellIndex+1] forKey:kProfEditProfileAPI_IndustryFocus] ;
        
    }
    else{
        
        [dictParam setObject:[self getCellTextFieldValueForCellIndex:0] forKey:kProfEditProfileAPI_CompanyName] ;
        [dictParam setObject:[self getCellTextFieldValueForCellIndex:kEntProfDescriptionCellIndex-1] forKey:kProfEditProfileAPI_WebsiteLink] ;
        [dictParam setObject:[self getCellTextFieldValueForCellIndex:kEntProfDescriptionCellIndex] forKey:kProfEditProfileAPI_Description] ;
        [dictParam setObject:[self getCellTextFieldValueForCellIndex:kEntProfSkillsCellIndex+1] forKey:kProfEditProfileAPI_IndustryFocus] ;
        
    }
    
    return dictParam ;
}

/*-(NSString*)convertTagsArrayToStringforArray:(NSMutableArray*)array{
 NSString *tagsStr = @"" ;
 for (int i=0; i<array.count; i++) {
 if(i==0) tagsStr = [array objectAtIndex:i] ;
 else tagsStr = [NSString stringWithFormat:@"%@,%@",tagsStr,[array objectAtIndex:i]] ;
 }
 return tagsStr ;
 }*/

#pragma mark - Tap gesture
- (void)singleTap:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
    [pickerViewContainer setHidden:YES] ;
}

- (void)txtViewTapped_Gesture:(UITapGestureRecognizer *)gestureRecognizer{
    
    selectedTextViewIndex = (int)gestureRecognizer.view.tag ;
    [self openTagsPopupWithTypeIndex:(int)gestureRecognizer.view.tag] ;
    
}

#pragma mark - IBAction Methods
- (IBAction)Submit_ClickAction:(id)sender {
    
    [self disablePriceTextField] ;
    
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_UpdateProfile] ;
        
        NSMutableDictionary *dictParam = [self getProfessionalProfileUpdatedData] ;
        
        NSLog(@"dictParam>>  %@",dictParam) ;
        [ApiCrowdBootstrap updateProfileWithType:PROFILE_PROFESSIONAL_SELECTED forUserType:(int)[UtilityClass GetUserType] withParameters:dictParam success:^(NSDictionary *responseDict) {
            NSLog(@"responseDict %@", responseDict);
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                //[self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                [UtilityClass showNotificationMessgae:kAlert_ProfileUpdate withResultType:@"1" withDuration:1] ;
                
                if([UtilityClass GetUserType] == CONTRACTOR){
                    NSMutableDictionary *loggedInUserDict = [[UtilityClass getLoggedInUserDetails]mutableCopy] ;
                    [loggedInUserDict setObject:[responseDict objectForKey:kProfEditProfileAPI_Image] forKey:kLogInAPI_UserImage] ;
                    [UtilityClass setLoggedInUserDetails:loggedInUserDict] ;
                }
                
                NSMutableDictionary *dict = [[UtilityClass getUserProfileDetails] mutableCopy] ;
                [dict setObject:[responseDict objectForKey:kProfileAPI_Complete] forKey:kProfileAPI_Complete] ;
                [UtilityClass setUserProfileDetails:dict] ;
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kNotificationProfileCompletionUpdate
                 object:self];
            }
            else {
                //[self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                if([responseDict objectForKey:@"errors"]){
                    NSDictionary *errorsData = (NSDictionary*)[responseDict objectForKey:@"errors"] ;
                    NSString *errorStr = @"" ;
                    for (NSString *value in [errorsData allValues]) {
                        errorStr = [NSString stringWithFormat:@"%@\n%@",errorStr,value] ;
                    }
                    if(![errorStr isEqualToString:@""])[self presentViewController:[UtilityClass displayAlertMessage:errorStr] animated:YES completion:nil];
                }
            }
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

- (IBAction)AddTag_ClickAction:(id)sender {
    selectedTextViewIndex = (int)[sender tag] ;
    [self openTagsPopupWithTypeIndex:(int)[sender tag]] ;
}

- (IBAction)AccreditedInvestor_ClickAction:(id)sender {
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kNotificationProfileAcreditedInvestrPopup
     object:self];
}

- (IBAction)RadioButtons_ClickAction:(UIButton*)button {
    
    AccreditedTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kContProfAccreditedCellIndex inSection:0]] ;
    if(button.tag == YES_SELETCED){
        if([cell.yesBtn.accessibilityValue isEqualToString:STARTUP_RADIOBUTON_SELECTED]){
            [cell.yesBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
            cell.yesBtn.accessibilityValue = STARTUP_RADIOBUTTON_UNSELECTED ;
            [cell.noBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
            cell.noBtn.accessibilityValue = STARTUP_RADIOBUTON_SELECTED ;
            [[profProfileArray objectAtIndex:kContProfAccreditedCellIndex] setValue:@"0" forKey:@"value"] ;
        }
        else{
            [cell.yesBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
            cell.yesBtn.accessibilityValue = STARTUP_RADIOBUTON_SELECTED ;
            [cell.noBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
            cell.noBtn.accessibilityValue = STARTUP_RADIOBUTTON_UNSELECTED ;
            [[profProfileArray objectAtIndex:kContProfAccreditedCellIndex] setValue:@"1" forKey:@"value"] ;
        }
    }
    else{
        if([cell.noBtn.accessibilityValue isEqualToString:STARTUP_RADIOBUTON_SELECTED]){
            [cell.noBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
            cell.noBtn.accessibilityValue = STARTUP_RADIOBUTTON_UNSELECTED ;
            [cell.yesBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
            cell.yesBtn.accessibilityValue = STARTUP_RADIOBUTON_SELECTED ;
            [[profProfileArray objectAtIndex:kContProfAccreditedCellIndex] setValue:@"1" forKey:@"value"] ;
        }
        else{
            [cell.noBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
            cell.noBtn.accessibilityValue = STARTUP_RADIOBUTON_SELECTED ;
            [cell.yesBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
            cell.yesBtn.accessibilityValue = STARTUP_RADIOBUTTON_UNSELECTED ;
            [[profProfileArray objectAtIndex:kContProfAccreditedCellIndex] setValue:@"0" forKey:@"value"] ;
        }
    }
}

- (IBAction)DropdownButton_ClickAction:(id)sender {
    
    [pickerViewContainer setHidden:NO] ;
    
    // DobTableViewCell *cell = [tblView dequeueReusableCellWithIdentifier:kProfExperienceCellIdentifier] ;
    // [cell.textFld becomeFirstResponder] ;
    
    if([UtilityClass GetUserType] == CONTRACTOR){
        
        if([sender tag] == kContProfExperienceCellIndex) selectedPickerViewType = PROFILE_PROF_EXPERIENCE_SELECTED ;
        else selectedPickerViewType = PROFILE_PROF_CONTRACTOR_TYPE_SELECTED ;
        
        if([sender tag] == kContProfExperienceCellIndex) {
            selectedPickerViewType = PROFILE_PROF_EXPERIENCE_SELECTED ;
            int index = [UtilityClass getPickerViewSelectedIndexFromArray:experienceArray forID:selectedExperienceID] ;
            if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
            else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
            
        }
        
        else if([sender tag] == kContProfContractorTypeCellIndex) {
            selectedPickerViewType = PROFILE_PROF_CONTRACTOR_TYPE_SELECTED ;
            int index = [UtilityClass getPickerViewSelectedIndexFromArray:contractorTypeArray forID:selectedContractorTypeID] ;
            if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
            else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
        }
        
        [pickerView reloadAllComponents] ;
    }
}

#pragma mark - Toolbar Buttons Methods
- (IBAction)PickerToolbarButtons_ClickAction:(id)sender {
    [pickerViewContainer setHidden:YES] ;
    
    
    DobTableViewCell *cell ;
    if(selectedPickerViewType == PROFILE_PROF_EXPERIENCE_SELECTED)cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kContProfExperienceCellIndex inSection:0]] ;
    
    else cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kContProfContractorTypeCellIndex inSection:0]] ;
    
    [cell.textFld resignFirstResponder] ;
    
    [pickerViewContainer setHidden:YES] ;
    
    if([sender tag] == DONE_CLICKED){
        
        if(selectedPickerViewType == PROFILE_PROF_EXPERIENCE_SELECTED){
            if([pickerView selectedRowInComponent:0] == 0){
                // cell.textFld.text = @""  ;
                selectedExperienceID = @"" ;
                [[profProfileArray objectAtIndex:kContProfExperienceCellIndex] setValue:@"" forKey:@"value"] ;
            }
            else{
                //cell.textFld.text = [[experienceArray objectAtIndex:[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"]  ;
                selectedExperienceID = [[experienceArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"id"]  ;
                
                [[profProfileArray objectAtIndex:kContProfExperienceCellIndex] setValue:[[experienceArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] forKey:@"value"] ;
            }
        }
        
        else{
            if([pickerView selectedRowInComponent:0] == 0){
                // cell.textFld.text = @""  ;
                selectedContractorTypeID = @"" ;
                
                [[profProfileArray objectAtIndex:kContProfContractorTypeCellIndex] setValue:@"" forKey:@"value"] ;
            }
            else{
                // cell.textFld.text = [[contractorTypeArray objectAtIndex:[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"]  ;
                selectedContractorTypeID = [[contractorTypeArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"id"]  ;
                
                [[profProfileArray objectAtIndex:kContProfContractorTypeCellIndex] setValue:[[contractorTypeArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] forKey:@"value"] ;
            }
        }
    }
    else{
        
        if(selectedPickerViewType == PROFILE_PROF_EXPERIENCE_SELECTED){
            if([pickerView selectedRowInComponent:0] == 0) cell.textFld.text = @"" ;
            else cell.textFld.text = [[profProfileArray objectAtIndex:kContProfExperienceCellIndex] valueForKey:@"value"] ;
        }
        else{
            if([pickerView selectedRowInComponent:0] == 0) cell.textFld.text = @"" ;
            else  cell.textFld.text = [[profProfileArray objectAtIndex:kContProfContractorTypeCellIndex] valueForKey:@"value"] ;
        }
    }
    selectedPickerViewType = -1 ;
    [pickerView reloadAllComponents] ;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return profProfileArray.count+1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([UtilityClass GetUserType] == CONTRACTOR){
        
        if(indexPath.row == kContProfExperienceCellIndex  || indexPath.row == kContProfContractorTypeCellIndex){
            DobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfExperienceCellIdentifier] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            cell.fieldNameLbl.text = [NSString stringWithFormat:@"%@",[[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"]] ;
            [UtilityClass setTextFieldBorder:cell.textFld] ;
            [UtilityClass addMarginsOnTextField:cell.textFld] ;
            cell.textFld.tag = indexPath.row ;
            cell.dropdownBtn.tag = indexPath.row ;
            cell.tag = indexPath.row ;
            //cell.textFld.inputView = pickerViewContainer ;
            
            cell.textFld.placeholder = [NSString stringWithFormat:@"Select %@",[[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"]]  ;
            NSString *value = [NSString stringWithFormat:@"%@",[[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"value"]];
            if(![value isEqualToString:@""] && ![value isEqualToString:@" "])cell.textFld.text = [NSString stringWithFormat:@"%@",[[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"value"]]  ;
            else cell.textFld.text = @""  ;
            return cell ;
        }
        else if(indexPath.row == kContProfKeywordsCellIndex || indexPath.row == kContProfQualificationsCellIndex || indexPath.row == kContProfCertificationsCellIndex || indexPath.row == kContProfSkillsCellIndex || indexPath.row == kContProfStartupStageCellIndex){
            KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfKeywordsCellIdentifer] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [UtilityClass setButtonBorder:cell.button] ;
            
            cell.tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
            cell.tagsScrollView.backgroundColor = [UIColor clearColor] ;
            cell.tagsScrollView.tag = indexPath.row ;
            cell.button.tag = indexPath.row ;
            cell.plusBtn.tag = indexPath.row ;
            
            cell.titleLbl.text =  [[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"] ;
            
            NSMutableArray *tags ;
            if(indexPath.row == kContProfKeywordsCellIndex)tags = [selectedKeywordsArray mutableCopy] ;
            else if(indexPath.row == kContProfQualificationsCellIndex)tags = [selectedQualificationsArray mutableCopy] ;
            else if(indexPath.row == kContProfCertificationsCellIndex)tags = [selectedCertificationsArray mutableCopy] ;
            else if(indexPath.row == kContProfSkillsCellIndex)tags = [selectedSkillsArray mutableCopy] ;
            else tags = [selectedPreferredStartupArray mutableCopy] ;
            
            if(tags.count >0)[cell.button setHidden:YES] ;
            else [cell.button setHidden:NO] ;
            
            cell.tagsScrollView.tagPlaceholder = @"" ;
            [cell.button setTitle:[NSString stringWithFormat:@"Add %@",[[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"]] forState:UIControlStateNormal] ;
            cell.tagsScrollView.tags = [tags mutableCopy];
            cell.tagsScrollView.tagsDeleteButtonColor = [UIColor whiteColor];
            cell.tagsScrollView.tagsTextColor = [UIColor whiteColor] ;
            cell.tagsScrollView.mode = TLTagsControlModeEdit;
            [cell.tagsScrollView setTapDelegate:self];
            [cell.tagsScrollView setDeleteDelegate:self];
            
            // UIColor *blueBackgroundColor = [UIColor colorWithRed:75.0/255.0 green:186.0/255.0 blue:251.0/255.0 alpha:1];
            cell.tagsScrollView.tagsBackgroundColor = [UtilityClass orangeColor];
            
            [cell.tagsScrollView reloadTagSubviews];
            
            UITapGestureRecognizer  *txtViewTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(txtViewTapped_Gesture:)];
            [cell.tagsScrollView addGestureRecognizer:txtViewTapped];
            
            return cell ;
        }
        else if(indexPath.row == kContProfAccreditedCellIndex){
            AccreditedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfAccreditedCellIdentifier] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            if([[[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"value"] intValue] == 1){
                [cell.yesBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
                cell.yesBtn.accessibilityValue = STARTUP_RADIOBUTON_SELECTED ;
                [cell.noBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
                cell.noBtn.accessibilityValue = STARTUP_RADIOBUTTON_UNSELECTED ;
            }
            else{
                [cell.yesBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
                cell.yesBtn.accessibilityValue = STARTUP_RADIOBUTTON_UNSELECTED ;
                [cell.noBtn setBackgroundImage:[UIImage imageNamed:STARTUP_RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
                cell.noBtn.accessibilityValue = STARTUP_RADIOBUTON_SELECTED ;
            }
            return cell ;
        }
        else if(indexPath.row == profProfileArray.count){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfSubmitCellIdentifier] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            return cell ;
        }
        else{
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfTextFieldCellIdentifier] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            cell.fieldNameLbl.text = [NSString stringWithFormat:@"%@",[[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"]] ;
            [UtilityClass setTextFieldBorder:cell.textFld] ;
            [UtilityClass addMarginsOnTextField:cell.textFld] ;
            cell.textFld.tag = indexPath.row ;
            cell.textFld.placeholder = [[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"];
            cell.textFld.text = [[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"value"];
            cell.textFld.returnKeyType = UIReturnKeyDone ;
            return cell ;
        }
    }
    else{
        if(indexPath.row == kEntProfDescriptionCellIndex){
            DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfDescriptionCellIdentifier] ;
            cell.descriptionTxtView.tag = indexPath.row ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            [UtilityClass setTextViewBorder:cell.descriptionTxtView] ;
            cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"value"]]  ;
            return cell ;
        }
        else if(indexPath.row == kEntProfKeywordsCellIndex || indexPath.row == kEntProfQualificationsCellIndex || indexPath.row == kEntProfSkillsCellIndex){
            KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfKeywordsCellIdentifer] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [UtilityClass setButtonBorder:cell.button] ;
            
            cell.tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
            cell.tagsScrollView.backgroundColor = [UIColor clearColor] ;
            cell.tagsScrollView.tag = indexPath.row ;
            cell.button.tag = indexPath.row ;
            cell.plusBtn.tag = indexPath.row ;
            
            cell.titleLbl.text =  [[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"] ;
            
            NSMutableArray *tags ;
            if(indexPath.row == kEntProfKeywordsCellIndex)tags = [selectedKeywordsArray mutableCopy] ;
            else if(indexPath.row == kEntProfQualificationsCellIndex)tags = [selectedQualificationsArray mutableCopy] ;
            else tags = [selectedSkillsArray mutableCopy] ;
            
            if(tags.count >0)[cell.button setHidden:YES] ;
            else [cell.button setHidden:NO] ;
            
            cell.tagsScrollView.tagPlaceholder = @"" ;
            [cell.button setTitle:[NSString stringWithFormat:@"Add %@",[[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"]] forState:UIControlStateNormal] ;
            cell.tagsScrollView.tags = [tags mutableCopy];
            cell.tagsScrollView.tagsDeleteButtonColor = [UIColor whiteColor];
            cell.tagsScrollView.tagsTextColor = [UIColor whiteColor] ;
            cell.tagsScrollView.mode = TLTagsControlModeEdit;
            [cell.tagsScrollView setTapDelegate:self];
            [cell.tagsScrollView setDeleteDelegate:self];
            
            // UIColor *blueBackgroundColor = [UIColor colorWithRed:75.0/255.0 green:186.0/255.0 blue:251.0/255.0 alpha:1];
            cell.tagsScrollView.tagsBackgroundColor = [UtilityClass orangeColor];
            
            [cell.tagsScrollView reloadTagSubviews];
            
            UITapGestureRecognizer  *txtViewTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(txtViewTapped_Gesture:)];
            [cell.tagsScrollView addGestureRecognizer:txtViewTapped];
            
            return cell ;
        }
        else if(indexPath.row == profProfileArray.count){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfSubmitCellIdentifier] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            return cell ;
        }
        else{
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfTextFieldCellIdentifier] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            cell.fieldNameLbl.text = [NSString stringWithFormat:@"%@",[[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"]] ;
            cell.textFld.tag = indexPath.row ;
            [UtilityClass setTextFieldBorder:cell.textFld] ;
            [UtilityClass addMarginsOnTextField:cell.textFld] ;
            cell.textFld.placeholder = [NSString stringWithFormat:@"%@",[[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"]]  ;
            cell.textFld.text = [NSString stringWithFormat:@"%@",[[profProfileArray objectAtIndex:indexPath.row] valueForKey:@"value"]]  ;
            if(indexPath.row == profProfileArray.count-1)cell.textFld.returnKeyType = UIReturnKeyDone ;
            else cell.textFld.returnKeyType = UIReturnKeyNext ;
            return cell ;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([UtilityClass GetUserType]  == CONTRACTOR){
        if(indexPath.row == kContProfAccreditedCellIndex) return 80 ;
        else if(indexPath.row == kContProfKeywordsCellIndex || indexPath.row == kContProfQualificationsCellIndex || indexPath.row == kContProfCertificationsCellIndex || indexPath.row == kContProfSkillsCellIndex || indexPath.row == kContProfStartupStageCellIndex) return 70 ;
        else if(indexPath.row == profProfileArray.count) return 45 ;
        else return 75 ;
    }
    else{
        if(indexPath.row == kEntProfDescriptionCellIndex) return 100 ;
        else if(indexPath.row == kEntProfKeywordsCellIndex || indexPath.row == kEntProfQualificationsCellIndex || indexPath.row == kEntProfSkillsCellIndex ) return 70 ;
        else if(indexPath.row == profProfileArray.count) return 45 ;
        else return 75 ;
    }
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [pickerViewContainer setHidden:YES] ;
    
    [self disablePriceTextField] ;
    
    if(selectedPickerViewType == PROFILE_PROF_EXPERIENCE_SELECTED){
        DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kContProfExperienceCellIndex inSection:0]] ;
        [cell.textFld resignFirstResponder] ;
        cell.textFld.text = [[profProfileArray objectAtIndex:kContProfExperienceCellIndex] valueForKey:@"value"] ;
    }
    
    else if(selectedPickerViewType == PROFILE_PROF_CONTRACTOR_TYPE_SELECTED){
        DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kContProfContractorTypeCellIndex inSection:0]] ;
        [cell.textFld resignFirstResponder] ;
        cell.textFld.text = [[profProfileArray objectAtIndex:kContProfContractorTypeCellIndex] valueForKey:@"value"] ;
    }
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    TextFieldTableViewCell *cell ;
    if([UtilityClass GetUserType] == ENTREPRENEUR){
        
        if([textField tag] == 0){
            cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] ;
            [cell.textFld becomeFirstResponder] ;
        }
        else if([textField tag] == 1){
            DescriptionTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kEntProfDescriptionCellIndex inSection:0]] ;
            [cell.descriptionTxtView becomeFirstResponder] ;
        }
    }
    
    return YES ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _selectedItem = textField ;
    if([UtilityClass GetUserType] == CONTRACTOR){
        if(textField.tag == kContProfExperienceCellIndex) {
            selectedPickerViewType = PROFILE_PROF_EXPERIENCE_SELECTED ;
            int index = [UtilityClass getPickerViewSelectedIndexFromArray:experienceArray forID:selectedExperienceID] ;
            if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
            else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
            
        }
        
        else if(textField.tag == kContProfContractorTypeCellIndex) {
            selectedPickerViewType = PROFILE_PROF_CONTRACTOR_TYPE_SELECTED ;
            int index = [UtilityClass getPickerViewSelectedIndexFromArray:contractorTypeArray forID:selectedContractorTypeID] ;
            if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
            else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
        }
    }
    return YES ;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    _selectedItem = nil ;
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [[profProfileArray objectAtIndex:textField.tag] setValue:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"value"] ;
    
    return YES ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [[profProfileArray objectAtIndex:textView.tag] setValue:[textView.text stringByReplacingCharactersInRange:range withString:text] forKey:@"value"] ;
    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        TextFieldTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:profProfileArray.count-1 inSection:0]] ;
        [cell.textFld becomeFirstResponder] ;
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


#pragma mark - Picker View Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1 ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(selectedPickerViewType == PROFILE_PROF_EXPERIENCE_SELECTED)return experienceArray.count+1 ;
    else return contractorTypeArray.count+1 ;
}



/*-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
 
 if(selectedPickerViewType == PROFILE_PROF_EXPERIENCE_SELECTED){
 if(row == 0) return [NSString stringWithFormat:@"Select %@",[[profProfileArray objectAtIndex:kContProfExperienceCellIndex] valueForKey:@"field"]] ;
 else return [[experienceArray objectAtIndex:row-1] valueForKey:@"name"] ;
 }
 
 else if(selectedPickerViewType == PROFILE_PROF_STARTUP_SELECTED){
 if(row == 0) return [NSString stringWithFormat:@"Select %@",[[profProfileArray objectAtIndex:kContProfStartupStageCellIndex] valueForKey:@"field"]] ;
 else return [[startupArray objectAtIndex:row-1] valueForKey:@"name"] ;
 }
 
 else {
 if(row == 0) return [NSString stringWithFormat:@"Select %@",[[profProfileArray objectAtIndex:kContProfContractorTypeCellIndex] valueForKey:@"field"]] ;
 else return [[contractorTypeArray objectAtIndex:row-1] valueForKey:@"name"] ;
 }
 }*/

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    DobTableViewCell *cell ;
    if(selectedPickerViewType == PROFILE_PROF_EXPERIENCE_SELECTED){
        cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kContProfExperienceCellIndex inSection:0]] ;
        if(row == 0) cell.textFld.text = @"" ;
        else cell.textFld.text = [[experienceArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    
    else{
        cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kContProfContractorTypeCellIndex inSection:0]] ;
        if(row == 0) cell.textFld.text = @"" ;
        else cell.textFld.text = [[contractorTypeArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0,0,pickerView.frame.size.width,40);
    label.textColor = [UtilityClass textColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:18 ];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0 ;
    
    if(selectedPickerViewType == PROFILE_PROF_EXPERIENCE_SELECTED){
        if(row == 0) label.text = [NSString stringWithFormat:@"Select %@",[[profProfileArray objectAtIndex:kContProfExperienceCellIndex] valueForKey:@"field"]] ;
        else label.text = [[experienceArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    
    else {
        if(row == 0) label.text = [NSString stringWithFormat:@"Select %@",[[profProfileArray objectAtIndex:kContProfContractorTypeCellIndex] valueForKey:@"field"]] ;
        else label.text = [[contractorTypeArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    return label;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30 ;
}

#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

-(void)tagsControl:(UIView *)tag withTagControlIndex:(NSInteger)tagControlIndex removedFromIndex:(NSInteger)index{
    NSLog(@"index: %ld control: %ld", (long)index,(long)tagControlIndex);
    [tag removeFromSuperview];
    //[selectedKeywordsArray removeObjectAtIndex:index];
    
    if([UtilityClass GetUserType] == CONTRACTOR){
        if(tagControlIndex == kContProfKeywordsCellIndex){
            [selectedKeywordsArray removeObjectAtIndex:index] ;
            [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kContProfKeywordsCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone] ;
            
        }
        else if(tagControlIndex == kContProfQualificationsCellIndex){
            [selectedQualificationsArray removeObjectAtIndex:index] ;
            [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kContProfQualificationsCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone] ;
            
        }
        else if(tagControlIndex == kContProfSkillsCellIndex){
            [selectedSkillsArray removeObjectAtIndex:index] ;
            [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kContProfSkillsCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone] ;
            
        }
        else if(tagControlIndex == kContProfStartupStageCellIndex){
            [selectedPreferredStartupArray removeObjectAtIndex:index] ;
            [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kContProfStartupStageCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone] ;
            
        }
        else {
            [selectedCertificationsArray removeObjectAtIndex:index] ;
            [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kContProfCertificationsCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone] ;
            
        }
    }
    else{
        if(tagControlIndex == kEntProfKeywordsCellIndex){
            [selectedKeywordsArray removeObjectAtIndex:index] ;
            [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kEntProfKeywordsCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone] ;
            
        }
        else if(tagControlIndex == kEntProfQualificationsCellIndex){
            [selectedQualificationsArray removeObjectAtIndex:index] ;
            [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kEntProfQualificationsCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone] ;
            
        }
        else{
            [selectedSkillsArray removeObjectAtIndex:index] ;
            [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kEntProfSkillsCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone] ;
        }
    }
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

#pragma mark - API Methods
-(void)getSQKCCPE{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [ApiCrowdBootstrap getSQKCCPE:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                // experienceArray = [NSArray arrayWithArray:(NSArray*)[responseDict objectForKey:kProfProfileAPI_ExperiencesList]] ;
                experienceArray = [[NSArray alloc] initWithArray:(NSArray*)[responseDict objectForKey:kProfProfileAPI_ExperiencesList]] ;
                contractorTypeArray = [NSArray arrayWithArray:(NSArray*)[responseDict objectForKey:kProfProfileAPI_ContractorTypesList]] ;
                
                keywordsArray = [NSArray arrayWithArray:(NSArray*)[responseDict objectForKey:kProfProfileAPI_KeywordsList]] ;
                qualificationsArray = [NSArray arrayWithArray:(NSArray*)[responseDict objectForKey:kProfProfileAPI_QualificationsList]] ;
                certificationsArray = [NSArray arrayWithArray:(NSArray*)[responseDict objectForKey:kProfProfileAPI_CertificationsList]] ;
                skillsArray = [NSArray arrayWithArray:(NSArray*)[responseDict objectForKey:kProfProfileAPI_SkillsList]] ;
                startupsArray = [NSArray arrayWithArray:(NSArray*)[responseDict objectForKey:kProfProfileAPI_PrefferedStartupsList]] ;
                
                [pickerView reloadAllComponents] ;
            }
            else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
            
        }] ;
    }
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
