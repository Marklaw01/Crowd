//
//  PostJobViewController.m
//  CrowdBootstrap
//
//  Created by osx on 10/01/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "PostJobViewController.h"
#import "KLCPopup.h"
#import "TextFieldTableViewCell.h"
#import "KeywordsTableViewCell.h"
#import "CommitTableViewCell.h"
#import "DescriptionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DobTableViewCell.h"
#import "PaymentsTableViewCell.h"

@interface PostJobViewController ()

@end

@implementation PostJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetUISettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings {
    
    jobData = [[UtilityClass getJobDetails] mutableCopy];
    NSLog(@"Job Data: %@",jobData) ;
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = @"Add Job";
    //[NSString stringWithFormat:@"%@",[jobData valueForKey:kSearchJobAPI_Job_Title]] ;
    [self initializeSectionArray] ;
}

-(void)initializeSectionArray {
    
    NSArray *fieldsArray = @[@"Choose Company", @"Industry Keywords", @"Select Country", @"Select State", @"Job Title", @"Role", @"Select Job Type", @"Minimum Work NPS", @"Location", @"Travel", @"Start Date", @"End Date", @"Skills", @"Requirements", @"Job Posting Keywords", @"Summary"] ;
    NSArray *parametersArray = @[kJobDetailAPI_CompanyName, kJobDetailAPI_IndustryKeywords, kJobDetailAPI_Country, kJobDetailAPI_State, kJobDetailAPI_JobTitle, kJobDetailAPI_JobRole, kJobDetailAPI_JobType, kJobDetailAPI_MINWORK_NPS, kJobDetailAPI_Location, kJobDetailAPI_Travel, kJobDetailAPI_StartDate, kJobDetailAPI_EndDate, kJobDetailAPI_Skills, kJobDetailAPI_Requirement, kJobDetailAPI_PostingKeywords, kJobDetailAPI_Summary] ;
    
    sectionsArray = [[NSMutableArray alloc] init] ;
    for (int i=0; i<fieldsArray.count ; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
        [dict setValue:[parametersArray objectAtIndex:i] forKey:@"key"] ;
        [dict setValue:@"" forKey:@"value"] ;
        [dict setValue:[fieldsArray objectAtIndex:i] forKey:@"field"] ;
        
        [sectionsArray addObject:dict] ;
    }
    
    arrayForBool = [[NSMutableArray alloc] init] ;
    for (int i = 0; i < [sectionsArray count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    
    skillsArray = [[NSMutableArray alloc] init] ;
    industryKeywordsArray = [[NSMutableArray alloc] init] ;
    jobPostingKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedSkillsArray = [[NSMutableArray alloc] init] ;
    selectedIndustryKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedJobPostingKeywordsArray = [[NSMutableArray alloc] init] ;
    
    selectedCountryID = @"" ;
    selectedStateID   = @"" ;
    selectedCompanyID = @"";
    selectedJobTypeID = @"";
    prevDueDate       = @"" ;

    selectedPickerViewType = -1 ;
    selectedDatePickerType = -1 ;
    selectedKeywordType = -1;
    
    [datePickerView setMinimumDate:[NSDate date]] ;
    [datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];

    [self getHiredCompaniesList];
    [self getCountriesList];
    [self getJobTypeList];
    [self getJobIndustryLists];
    [self getJobPostingKeywords];
    [self getJobSkills];
    
    [self.tblView reloadData] ;
}

#pragma mark - Tap gesture
- (void)txtViewTapped_Gesture:(UITapGestureRecognizer *)gestureRecognizer {
    selectedKeywordType = (int)[gestureRecognizer.view tag] ;
    [self openTagsPopup] ;
}

-(void)openTagsPopup {
    [self.view endEditing:YES] ;
    [popupTblView reloadData] ;
    [UtilityClass displayPopupWithContentView:popupView view:self.view] ;
}

-(NSMutableArray*)resetTagsArrayWithData:(NSArray*)array {
    NSMutableArray *tagsArray = [[NSMutableArray alloc] init] ;
    for (NSDictionary *obj in array) {
        [tagsArray addObject:[obj valueForKey:@"name"]] ;
    }
    return tagsArray ;
}

-(NSString*)convertTagsArrayToStringforArray:(NSMutableArray*)array withTagsArray:(NSArray*)tagsArray tagType:(NSString *)type {
    NSString *tagsStr = @"" ;
    BOOL isFirstTag = YES ;
    if ([type isEqualToString:@"industry"]) {
        for (NSDictionary *dict in tagsArray) {
            NSString *value = [dict valueForKey:@"job_industry_name"] ;
            for (NSString *tag in array) {
                if([tag isEqualToString:value]){
                    if(isFirstTag) tagsStr = [dict valueForKey:@"job_industry_id"] ;
                    else tagsStr = [NSString stringWithFormat:@"%@,%@",tagsStr,[dict valueForKey:@"job_industry_id"]] ;
                    isFirstTag = NO ;
                }
            }
        }
    } else if ([type isEqualToString:@"posting"]) {
        for (NSDictionary *dict in tagsArray) {
            NSString *value = [dict valueForKey:@"company_keyword_name"] ;
            for (NSString *tag in array) {
                if([tag isEqualToString:value]){
                    if(isFirstTag) tagsStr = [dict valueForKey:@"company_keyword_id"] ;
                    else tagsStr = [NSString stringWithFormat:@"%@,%@",tagsStr,[dict valueForKey:@"company_keyword_id"]] ;
                    isFirstTag = NO ;
                }
            }
        }
    } else if ([type isEqualToString:@"skills"]) {
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
    }
    
    return tagsStr ;
}

#pragma mark - Keywords Popup Buttons Action
- (IBAction)AddTag_ClickAction:(id)sender {
    selectedKeywordType = (int)[sender tag] ;
    [self openTagsPopup] ;
}

- (IBAction)CheckUncheck_ClickAction:(id)sender {
    UIButton *btn = (UIButton*)sender ;
    if([btn.accessibilityLabel isEqualToString:CHECK_IMAGE ]) { // Check
        [btn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = UNCHECK_IMAGE ;
        if(selectedKeywordType == INDUSTRY_KEYWORDS_SELECTED) [[industryKeywordsArray objectAtIndex:btn.tag] setValue:@"0" forKey:@"isSelected"] ;
        else if (selectedKeywordType == JOB_POSTING_KEYWORDS_SELECTED) [[jobPostingKeywordsArray objectAtIndex:btn.tag] setValue:@"0" forKey:@"isSelected"];
        else [[skillsArray objectAtIndex:btn.tag] setValue:@"0" forKey:@"isSelected"] ;
    }
    else{ // Uncheck
        [btn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = CHECK_IMAGE ;
        if(selectedKeywordType == INDUSTRY_KEYWORDS_SELECTED) [[industryKeywordsArray objectAtIndex:btn.tag] setValue:@"1" forKey:@"isSelected"] ;
        else if (selectedKeywordType == JOB_POSTING_KEYWORDS_SELECTED) [[jobPostingKeywordsArray objectAtIndex:btn.tag] setValue:@"1" forKey:@"isSelected"];
        else [[skillsArray objectAtIndex:btn.tag] setValue:@"1" forKey:@"isSelected"] ;
    }
}

- (IBAction)OK_ClickAction:(id)sender {
    [popupView removeFromSuperview];

    if(selectedKeywordType == INDUSTRY_KEYWORDS_SELECTED) {
        [selectedIndustryKeywordsArray removeAllObjects] ;

        for (NSMutableDictionary *obj in industryKeywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"])
                [selectedIndustryKeywordsArray addObject:[obj valueForKey:@"job_industry_name"]] ;
        }
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:JOB_INDUSTRY_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;

    } else if(selectedKeywordType == JOB_POSTING_KEYWORDS_SELECTED) {
        [selectedJobPostingKeywordsArray removeAllObjects];

        for (NSMutableDictionary *obj in jobPostingKeywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"])
                [selectedJobPostingKeywordsArray addObject:[obj valueForKey:@"company_keyword_name"]] ;
        }
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:JOB_POSTING_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;

    } else {
        [selectedSkillsArray removeAllObjects] ;
        for (NSMutableDictionary *obj in skillsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"])
                [selectedSkillsArray addObject:[obj valueForKey:@"name"]] ;
        }
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:JOB_SKILLS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
    }
}

#pragma mark - Validation Methods
-(BOOL)validatetextFieldsWithSectionIndex:(int)section {
    
    NSString *value = [[sectionsArray objectAtIndex:section] valueForKey:@"value"] ;
    NSLog(@"value: %@",value) ;
    if(value.length < 1 ){
        [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"%@%@",[[sectionsArray objectAtIndex:section] valueForKey:@"field"],kAlert_SignUp_BlankField]] animated:YES completion:nil];
        return NO ;
    }
    return YES ;
}

#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

-(void)tagsControl:(UIView *)tag withTagControlIndex:(NSInteger)tagControlIndex removedFromIndex:(NSInteger)index {
    NSLog(@"index: %ld control: %ld", (long)index,(long)tagControlIndex);
    [tag removeFromSuperview];
    
    if(tagControlIndex == INDUSTRY_KEYWORDS_SELECTED) {
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedIndustryKeywordsArray objectAtIndex:index]] ;
        for (int i=0; i<industryKeywordsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[industryKeywordsArray objectAtIndex:i] valueForKey:@"job_industry_name"]] ;
            if([keywordName isEqualToString:selectedName]){
                [[industryKeywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedIndustryKeywordsArray removeObjectAtIndex:index] ;
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:JOB_INDUSTRY_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
    } else if(tagControlIndex == JOB_POSTING_KEYWORDS_SELECTED) {
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedJobPostingKeywordsArray objectAtIndex:index]] ;
        for (int i=0; i<jobPostingKeywordsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[jobPostingKeywordsArray objectAtIndex:i] valueForKey:@"company_keyword_name"]] ;
            if([keywordName isEqualToString:selectedName]){
                [[jobPostingKeywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedJobPostingKeywordsArray removeObjectAtIndex:index] ;
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:JOB_POSTING_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
    }
    else{
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedSkillsArray objectAtIndex:index]] ;
        for (int i=0; i<skillsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[skillsArray objectAtIndex:i] valueForKey:@"name"]] ;
            if([keywordName isEqualToString:selectedName]){
                [[skillsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedSkillsArray removeObjectAtIndex:index] ;
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:JOB_SKILLS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
    }
}

-(void)navigateToScreenWithViewIdentifier:(NSString *)viewIdentifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:viewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

#pragma mark - Picker View Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1 ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(selectedPickerViewType == JOB_COUNTRY_SELECTED)
        return countryArray.count+1 ;
    else if(selectedPickerViewType == JOB_STATE_SELECTED)
        return statesArray.count+1 ;
    else if(selectedPickerViewType == JOB_CHOOSE_COMPANY_SELECTED)
        return companiesArray.count+1 ;
    else
        return jobTypeArray.count+1;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if(selectedPickerViewType == JOB_COUNTRY_SELECTED) {
        if(row == 0)
            return [[sectionsArray objectAtIndex:JOB_COUNTRY_SECTION_INDEX] valueForKey:@"field"] ;
        else
            return [[countryArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    else if(selectedPickerViewType == JOB_STATE_SELECTED) {
        if(row == 0)
            return [[sectionsArray objectAtIndex:JOB_STATE_SECTION_INDEX] valueForKey:@"field"] ;
        else
            return [[statesArray objectAtIndex:row-1] valueForKey:@"name"];
    }
    else if(selectedPickerViewType == JOB_CHOOSE_COMPANY_SELECTED) {
        if(row == 0)
            return [[sectionsArray objectAtIndex:JOB_CHOOSE_COMPANY_SECTION_INDEX] valueForKey:@"field"] ;
        else
            return [[companiesArray objectAtIndex:row-1] valueForKey:@"company_name"];
    }
    else {
        if(row == 0)
            return [[sectionsArray objectAtIndex:JOB_TYPE_SECTION_INDEX] valueForKey:@"field"] ;
        else
            return [[jobTypeArray objectAtIndex:row-1] valueForKey:@"job_type_name"];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(selectedPickerViewType == JOB_COUNTRY_SELECTED) {
        DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:JOB_COUNTRY_SECTION_INDEX]] ;

        if(row == 0)cell.textFld.text = @"" ;
        else cell.textFld.text = [[countryArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    else if(selectedPickerViewType == JOB_STATE_SELECTED) {
        DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:JOB_STATE_SECTION_INDEX]] ;
        
        if(row == 0)cell.textFld.text = @"" ;
        else cell.textFld.text = [[statesArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    else if(selectedPickerViewType == JOB_CHOOSE_COMPANY_SELECTED) {
        DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:JOB_CHOOSE_COMPANY_SECTION_INDEX]] ;

        if(row == 0)cell.textFld.text = @"" ;
        else cell.textFld.text = [[companiesArray objectAtIndex:row-1] valueForKey:@"company_name"] ;
    }
    else {
        DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:JOB_TYPE_SECTION_INDEX]] ;
        
        if(row == 0)cell.textFld.text = @"" ;
        else cell.textFld.text = [[jobTypeArray objectAtIndex:row-1] valueForKey:@"job_type_name"] ;
    }
}

#pragma mark - API Methods
-(void)getCountriesList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [ApiCrowdBootstrap getCountries:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"Country Response : %@", responseDict);
                countryArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:@"country"]] ;
                [pickerView reloadAllComponents];
            }
            else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
            
        }] ;
    }
}

-(void)getStatesListWithCountryID:(int)countryID {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",countryID] forKey:kCitiesAPI_CountryID] ;
        NSLog(@"dict : %@", dictParam);
        
        [ApiCrowdBootstrap getCitiesWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                NSLog(@"States Response : %@", responseDict);
                statesArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:@"state"]] ;
                [pickerView reloadAllComponents] ;
            }
            else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getJobTypeList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [ApiCrowdBootstrap getJobTypeList:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                NSLog(@"Job Type Response : %@", responseDict);
                jobTypeArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:@"job_type_list"]] ;
                [pickerView reloadAllComponents];
            }
            else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
            
        }] ;
    }
}

-(void)getHiredCompaniesList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait];
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSearchJobAPI_UserID];
        NSLog(@"dictParam: %@",dictParam);
        
        [ApiCrowdBootstrap getHiredCompaniesList:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud];
            NSLog(@"responseDict: %@",responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                NSLog(@"Company Response : %@", responseDict);
                companiesArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:@"company_list"]];
                [pickerView reloadAllComponents];
            }
            else
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud];
        }] ;
    }
}

-(void)getJobIndustryLists {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        [ApiCrowdBootstrap getJobIndustryLists:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"response : %@", responseDict);
                [industryKeywordsArray removeAllObjects] ;
                if([responseDict objectForKey:@"job_industry_list"]) {
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:@"job_industry_list"] mutableCopy]) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:[dict mutableCopy]] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        [industryKeywordsArray addObject:obj] ;
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

-(void)getJobPostingKeywords {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        [ApiCrowdBootstrap getCompanyKeywordList:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"response : %@", responseDict);
                [jobPostingKeywordsArray removeAllObjects] ;
                if([responseDict objectForKey:@"company_keyword_list"]) {
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:@"company_keyword_list"] mutableCopy]) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:[dict mutableCopy]] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        [jobPostingKeywordsArray addObject:obj] ;
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

-(void)getJobSkills {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        [ApiCrowdBootstrap getSQKCCPE:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"response : %@", responseDict);
                [skillsArray removeAllObjects] ;
                if([responseDict objectForKey:@"skills"]) {
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:@"skills"] mutableCopy]) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:[dict mutableCopy]] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        [skillsArray addObject:obj] ;
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

-(void)addJob {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_UpdateCampaign] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAddJobAPI_UserID] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:JOB_SUMMARY_SECTION_INDEX] valueForKey:@"value"] forKey:kAddJobAPI_Summary] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:JOB_TITLE_SECTION_INDEX] valueForKey:@"value"] forKey:kAddJobAPI_JobTitle] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:JOB_ROLE_SECTION_INDEX] valueForKey:@"value"] forKey:kAddJobAPI_JobRole] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:JOB_TRAVEL_SECTION_INDEX] valueForKey:@"value"] forKey:kAddJobAPI_Travel] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:JOB_LOCATION_SECTION_INDEX] valueForKey:@"value"] forKey:kAddJobAPI_Location] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:JOB_REQUIREMENT_SECTION_INDEX] valueForKey:@"value"] forKey:kAddJobAPI_Requirement] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:JOB_MIN_WORK_NPS_SECTION_INDEX] valueForKey:@"value"] forKey:kAddJobAPI_MINWORK_NPS] ;

        [dictParam setObject:selectedCountryID forKey:kAddJobAPI_CountryID] ;
        [dictParam setObject:selectedStateID forKey:kAddJobAPI_StateID] ;
        [dictParam setObject:selectedCompanyID forKey:kAddJobAPI_CompanyID] ;
        [dictParam setObject:selectedJobTypeID forKey:kAddJobAPI_JobTypeID] ;

        [dictParam setObject:[[sectionsArray objectAtIndex:JOB_START_DATE_SECTION_INDEX] valueForKey:@"value"] forKey:kAddJobAPI_StartDate] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:JOB_END_DATE_SECTION_INDEX] valueForKey:@"value"] forKey:kAddJobAPI_EndDate] ;

        [dictParam setObject:[self convertTagsArrayToStringforArray:selectedIndustryKeywordsArray withTagsArray:industryKeywordsArray tagType:@"industry"] forKey:kAddJobAPI_IndustryKeywords] ;
        [dictParam setObject:[self convertTagsArrayToStringforArray:selectedJobPostingKeywordsArray withTagsArray:jobPostingKeywordsArray tagType:@"posting"] forKey:kAddJobAPI_PostingKeywords] ;
        [dictParam setObject:[self convertTagsArrayToStringforArray:selectedSkillsArray withTagsArray:skillsArray tagType:@"skills"] forKey:kAddJobAPI_Skills] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap addJobWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                [UtilityClass showNotificationMessgae:kAddJob_SuccessMessage withResultType:@"0" withDuration:1] ;
                [self.navigationController popViewControllerAnimated:YES] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - IBAction Methods
- (IBAction)Submit_ClickAction:(id)sender {

    if(![self validatetextFieldsWithSectionIndex:JOB_CHOOSE_COMPANY_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:JOB_COUNTRY_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:JOB_STATE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:JOB_TITLE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:JOB_ROLE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:JOB_TYPE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:JOB_MIN_WORK_NPS_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:JOB_LOCATION_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:JOB_TRAVEL_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:JOB_START_DATE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:JOB_END_DATE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:JOB_REQUIREMENT_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:JOB_SUMMARY_SECTION_INDEX]) return ;

    else if(selectedIndustryKeywordsArray.count < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_IndustryKeywordRequired] animated:YES completion:nil] ;
        return ;
    }
    else if(selectedJobPostingKeywordsArray.count < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_JobPostingKeywordRequired] animated:YES completion:nil] ;
        return ;
    }
    else if(selectedSkillsArray.count < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_SkillsKeywordRequired] animated:YES completion:nil] ;
        return ;
    }
    else [self addJob] ;
}

- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)DropdownButton_ClickAction:(id)sender {
    [pickerViewContainer setHidden:NO];
    int index = 0;
    if ([sender tag] == JOB_CHOOSE_COMPANY_SECTION_INDEX) {
        selectedPickerViewType = JOB_CHOOSE_COMPANY_SELECTED;
        index = [UtilityClass getPickerViewSelectedIndexFromArray:companiesArray forID:selectedCompanyID] ;
    }
    else if ([sender tag] == JOB_COUNTRY_SECTION_INDEX) {
        selectedPickerViewType = JOB_COUNTRY_SELECTED;
        index = [UtilityClass getPickerViewSelectedIndexFromArray:countryArray forID:selectedCountryID] ;
    }
    else if ([sender tag] == JOB_STATE_SECTION_INDEX) {
        selectedPickerViewType = JOB_STATE_SELECTED;
        index = [UtilityClass getPickerViewSelectedIndexFromArray:statesArray forID:selectedStateID] ;
    }
    else {
        selectedPickerViewType = JOB_TYPE_SELECTED;
        index = [UtilityClass getPickerViewSelectedIndexFromArray:jobTypeArray forID:selectedJobTypeID] ;
    }

    if(index == -1)
        [pickerView selectRow:0 inComponent:0 animated:YES] ;
    else
        [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
    
    [pickerView reloadAllComponents] ;
}

#pragma mark - DatePicker Value Changed
- (void)datePickerChanged:(UIDatePicker *)datePicker {
    DobTableViewCell *cell;
    if (selectedDatePickerType == JOB_START_DATE_SELECTED) {
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:JOB_START_DATE_SECTION_INDEX]] ;
    } else
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:JOB_END_DATE_SECTION_INDEX]] ;
    
    [cell.textFld setText:[dateFormatter stringFromDate:datePicker.date]];
}

#pragma mark - Table header gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i = 0; i < [sectionsArray count]; i++) {
            if (indexPath.section == i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.tblView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - ToolBar Buttons Action
- (IBAction)toolbarButtons_ClickAction:(id)sender {
    if(selectedPickerViewType == JOB_COUNTRY_SELECTED) {
        DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:JOB_COUNTRY_SECTION_INDEX]] ;
        [cell.textFld resignFirstResponder] ;

        if([sender tag] == DONE_CLICKED) {
            if([pickerView selectedRowInComponent:0] == 0) {
                cell.textFld.text = @"" ;
                selectedCountryID = @"" ;
                
                [[sectionsArray objectAtIndex:JOB_COUNTRY_SECTION_INDEX] setValue:@"" forKey:@"value"] ;
            }
            else {
                cell.textFld.text = [[countryArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] ;
                selectedCountryID = [[countryArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"id"]  ;
                
                [[sectionsArray objectAtIndex:JOB_COUNTRY_SECTION_INDEX] setValue:[[countryArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] forKey:@"value"] ;
            }
        }
        else {
            if([pickerView selectedRowInComponent:0] == 0)cell.textFld.text = @"" ;
            else cell.textFld.text = [[sectionsArray objectAtIndex:JOB_COUNTRY_SECTION_INDEX] valueForKey:@"value"]  ;
        }
    }
    else if(selectedPickerViewType == JOB_STATE_SELECTED) {
        DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:JOB_STATE_SECTION_INDEX]] ;
        
        [cell.textFld resignFirstResponder] ;
        
        if([sender tag] == DONE_CLICKED) {
            if([pickerView selectedRowInComponent:0] == 0) {
                cell.textFld.text = @"" ;
                selectedStateID = @"" ;
                
                [[sectionsArray objectAtIndex:JOB_STATE_SECTION_INDEX] setValue:@"" forKey:@"value"] ;
            }
            else {
                cell.textFld.text = [[statesArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] ;
                selectedStateID = [[statesArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"id"]  ;
                
                [[sectionsArray objectAtIndex:JOB_STATE_SECTION_INDEX] setValue:[[statesArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] forKey:@"value"] ;
            }
        }
        else {
            if([pickerView selectedRowInComponent:0] == 0)cell.textFld.text = @"" ;
            else cell.textFld.text = [[sectionsArray objectAtIndex:JOB_STATE_SECTION_INDEX] valueForKey:@"value"]  ;
        }
    }
    else if(selectedPickerViewType == JOB_CHOOSE_COMPANY_SELECTED) {
        DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:JOB_CHOOSE_COMPANY_SECTION_INDEX]] ;
        
        [cell.textFld resignFirstResponder] ;
        
        if([sender tag] == DONE_CLICKED) {
            if([pickerView selectedRowInComponent:0] == 0) {
                cell.textFld.text = @"" ;
                selectedCompanyID = @"" ;
                
                [[sectionsArray objectAtIndex:JOB_CHOOSE_COMPANY_SECTION_INDEX] setValue:@"" forKey:@"value"] ;
            }
            else {
                cell.textFld.text = [[companiesArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"company_name"] ;
                selectedCompanyID = [[companiesArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"company_id"]  ;
                
                [[sectionsArray objectAtIndex:JOB_CHOOSE_COMPANY_SECTION_INDEX] setValue:[[companiesArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"company_name"] forKey:@"value"] ;
            }
        }
        else {
            if([pickerView selectedRowInComponent:0] == 0)cell.textFld.text = @"" ;
            else cell.textFld.text = [[sectionsArray objectAtIndex:JOB_CHOOSE_COMPANY_SECTION_INDEX] valueForKey:@"value"]  ;
        }

    }
    else {
        DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:JOB_TYPE_SECTION_INDEX]] ;
        
        [cell.textFld resignFirstResponder] ;
        
        if([sender tag] == DONE_CLICKED) {
            if([pickerView selectedRowInComponent:0] == 0) {
                cell.textFld.text = @"" ;
                selectedJobTypeID = @"" ;
                
                [[sectionsArray objectAtIndex:JOB_TYPE_SECTION_INDEX] setValue:@"" forKey:@"value"] ;
            }
            else {
                cell.textFld.text = [[jobTypeArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"job_type_name"] ;
                selectedJobTypeID = [[jobTypeArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"job_type_id"]  ;
                
                [[sectionsArray objectAtIndex:JOB_TYPE_SECTION_INDEX] setValue:[[jobTypeArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"job_type_name"] forKey:@"value"] ;
            }
        }
        else {
            if([pickerView selectedRowInComponent:0] == 0)cell.textFld.text = @"" ;
            else cell.textFld.text = [[sectionsArray objectAtIndex:JOB_TYPE_SECTION_INDEX] valueForKey:@"value"]  ;
        }
    }
}

- (IBAction)DatePickerToolbarButtons_ClickAction:(id)sender {
    if([sender tag] == DONE_CLICKED) {
        if(selectedDatePickerType == JOB_START_DATE_SELECTED) {
            DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:JOB_START_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:JOB_START_DATE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
        else {
            DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:JOB_END_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:JOB_END_DATE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
    }
    else {
        if(selectedDatePickerType == JOB_START_DATE_SELECTED) {
            DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:JOB_START_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate ;
        }
        else {
            DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:JOB_END_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate ;
        }
    }
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
    return YES ;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    _selectedItem = nil ;
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(textField.tag == JOB_COUNTRY_SECTION_INDEX || textField.tag == JOB_CHOOSE_COMPANY_SECTION_INDEX || textField.tag == JOB_STATE_SECTION_INDEX || textField.tag == JOB_TYPE_SECTION_INDEX) {
        
        int index = 0;
        if (textField.tag == JOB_COUNTRY_SECTION_INDEX) {
            selectedPickerViewType = JOB_COUNTRY_SELECTED ;
            index = [UtilityClass getPickerViewSelectedIndexFromArray:countryArray forID:selectedCountryID] ;
            if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
            else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
        }
        else if (textField.tag == JOB_STATE_SECTION_INDEX) {
            NSString *countryID = [NSString stringWithFormat:@"%@",selectedCountryID] ;
            if( [countryID isEqualToString:@""] || [countryID isEqualToString:@"0"]) {
                [self presentViewController:[UtilityClass displayAlertMessage:kSelectCountryDefaultText] animated:YES completion:nil] ;
                [textField resignFirstResponder] ;
                return NO ;
            }
            else {
                [self getStatesListWithCountryID:[selectedCountryID intValue]] ;
                selectedPickerViewType = JOB_STATE_SELECTED ;
                int index = [UtilityClass getPickerViewSelectedIndexFromArray:statesArray forID:selectedStateID] ;
                if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
                else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
            }
        }
        else if (textField.tag == JOB_TYPE_SECTION_INDEX) {
            selectedPickerViewType = JOB_TYPE_SELECTED ;
            index = [UtilityClass getPickerViewSelectedIndexFromArray:jobTypeArray forID:selectedJobTypeID] ;
            if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
            else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
        }
        else {
            selectedPickerViewType = JOB_CHOOSE_COMPANY_SELECTED ;
            index = [UtilityClass getPickerViewSelectedIndexFromArray:companiesArray forID:selectedCompanyID]
            ;
            if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
            else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
        }
    }
    else if(textField.tag == JOB_START_DATE_SECTION_INDEX || textField.tag == JOB_END_DATE_SECTION_INDEX) {
        if(textField.tag == JOB_START_DATE_SECTION_INDEX) {
            selectedDatePickerType = JOB_START_DATE_SELECTED;
        }
        else {
            selectedDatePickerType = JOB_END_DATE_SELECTED;
        }
    }
    else {
        _selectedItem = textField ;
    }
    
    return YES ;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _selectedItem = nil ;
    
    if(textField.tag == JOB_START_DATE_SECTION_INDEX || textField.tag == JOB_END_DATE_SECTION_INDEX) {
        prevDueDate = textField.text ;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [[sectionsArray objectAtIndex:textField.tag] setValue:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"value"] ;
    return YES ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [[sectionsArray objectAtIndex:textView.tag] setValue:[textView.text stringByReplacingCharactersInRange:range withString:text] forKey:@"value"] ;
    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
    }
    
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _selectedItem = nil ;
    
    if([textView.text isEqualToString:@"Description"] && textView.textColor == [UIColor lightGrayColor]){
        textView.text = @"" ;
        textView.textColor = [UtilityClass textColor] ;
    }
    
    CGPoint pointInTable = [textView.superview convertPoint:textView.frame.origin toView:self.tblView];
    CGPoint contentOffset = self.tblView.contentOffset;
    
    contentOffset.y = (pointInTable.y - textView.inputAccessoryView.frame.size.height);
    
    [self.tblView setContentOffset:contentOffset animated:YES];
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
                                                 toView: self.tblView];
        NSIndexPath *indexPath = [self.tblView indexPathForRowAtPoint:buttonPosition];
        
        [self.tblView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
    }
    return YES ;
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

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == popupTblView) {
        if(selectedKeywordType == INDUSTRY_KEYWORDS_SELECTED)
            return industryKeywordsArray.count ;
        else if (selectedKeywordType == JOB_POSTING_KEYWORDS_SELECTED)
            return jobPostingKeywordsArray.count ;
        else
            return skillsArray.count ;
    } else {
        if(section <= JOB_POSTING_KEYWORDS_SECTION_INDEX || section == sectionsArray.count)
            return 1;
        else {
            if ([[arrayForBool objectAtIndex:section] boolValue])
                return 1;
            else
                return 0 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == popupTblView) {
        PaymentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keywordsCell"] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.checkboxBtn.tag = indexPath.row ;

        if(selectedKeywordType == INDUSTRY_KEYWORDS_SELECTED) {
            cell.companyNameLbl.text = [[industryKeywordsArray objectAtIndex:indexPath.row] valueForKey:@"job_industry_name"] ;
            
            if ([selectedIndustryKeywordsArray containsObject:[[industryKeywordsArray objectAtIndex:indexPath.row] valueForKey:@"job_industry_name"]]) {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
                [[industryKeywordsArray objectAtIndex:indexPath.row] setValue:@"1" forKey:@"isSelected"] ;
            } else {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
                [[industryKeywordsArray objectAtIndex:indexPath.row] setValue:@"0" forKey:@"isSelected"] ;
            }
        }
        else if (selectedKeywordType == JOB_POSTING_KEYWORDS_SELECTED) {
            cell.companyNameLbl.text = [[jobPostingKeywordsArray objectAtIndex:indexPath.row] valueForKey:@"company_keyword_name"] ;
            
            if ([selectedJobPostingKeywordsArray containsObject:[[jobPostingKeywordsArray objectAtIndex:indexPath.row] valueForKey:@"company_keyword_name"]]) {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
                [[jobPostingKeywordsArray objectAtIndex:indexPath.row] setValue:@"1" forKey:@"isSelected"] ;
            } else {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
                [[jobPostingKeywordsArray objectAtIndex:indexPath.row] setValue:@"0" forKey:@"isSelected"] ;
            }
        }
        else
        {
            cell.companyNameLbl.text = [[skillsArray objectAtIndex:indexPath.row] valueForKey:@"name"] ;
            
            if ([selectedSkillsArray containsObject:[[skillsArray objectAtIndex:indexPath.row] valueForKey:@"name"]]) {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
                [[skillsArray objectAtIndex:indexPath.row] setValue:@"1" forKey:@"isSelected"] ;
            } else {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
                [[skillsArray objectAtIndex:indexPath.row] setValue:@"0" forKey:@"isSelected"] ;
            }
        }
        return cell ;
    } else {
        if(indexPath.section == sectionsArray.count) {
            CommitTableViewCell *cell = (CommitTableViewCell*)[tableView dequeueReusableCellWithIdentifier:SUBMIT_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            return cell ;
        }
        else if(indexPath.section == JOB_INDUSTRY_KEYWORDS_SECTION_INDEX || indexPath.section == JOB_POSTING_KEYWORDS_SECTION_INDEX || indexPath.section == JOB_SKILLS_SECTION_INDEX) {
            KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KEYWORDS_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [UtilityClass setButtonBorder:cell.button] ;
            cell.tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1] CGColor];
            cell.tagsScrollView.backgroundColor = [UIColor clearColor] ;
            cell.tagsScrollView.tag = indexPath.section ;
            cell.button.tag = indexPath.section ;
            cell.plusBtn.tag = indexPath.section ;
            
            NSMutableArray *tags ;
            if(indexPath.section == JOB_INDUSTRY_KEYWORDS_SECTION_INDEX)
                tags = [selectedIndustryKeywordsArray mutableCopy] ;
            else if(indexPath.section == JOB_POSTING_KEYWORDS_SECTION_INDEX)
                tags = [selectedJobPostingKeywordsArray mutableCopy] ;
            else
                tags = [selectedSkillsArray mutableCopy] ;
            
            if(tags.count > 0)
                [cell.button setHidden:YES] ;
            else
                [cell.button setHidden:NO] ;
            cell.titleLbl.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] ;
            cell.tagsScrollView.tagPlaceholder = @"" ;
            [cell.button setTitle:[NSString stringWithFormat:@"No %@ Added",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] forState:UIControlStateNormal] ;
            cell.tagsScrollView.tags = [tags mutableCopy];
            cell.tagsScrollView.tagsDeleteButtonColor = [UIColor whiteColor];
            cell.tagsScrollView.tagsTextColor = [UIColor whiteColor] ;
            cell.tagsScrollView.mode = TLTagsControlModeEdit;
            [cell.tagsScrollView setTapDelegate:self];
            [cell.tagsScrollView setDeleteDelegate:self];

            cell.tagsScrollView.tagsBackgroundColor = [UtilityClass orangeColor];
            
            [cell.tagsScrollView reloadTagSubviews];
            
            UITapGestureRecognizer  *txtViewTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(txtViewTapped_Gesture:)];
            txtViewTapped.accessibilityValue = [NSString stringWithFormat:@"%ld",indexPath.section];
            [cell.tagsScrollView addGestureRecognizer:txtViewTapped];

            return cell ;
        }
        else if(indexPath.section == JOB_SUMMARY_SECTION_INDEX) {
            DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DESCRIPTION_CELL_IDENTIFIER] ;
            cell.descriptionTxtView.tag = indexPath.section ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            [UtilityClass setTextViewBorder:cell.descriptionTxtView] ;
            
            NSString *descText = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
            
            if(descText.length < 1 || [descText isEqualToString:@""] || [descText isEqualToString:@" "]) {
                cell.descriptionTxtView.textColor = [UIColor lightGrayColor] ;
                cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] ;
            }
            else{
                cell.descriptionTxtView.textColor = [UtilityClass textColor] ;
                cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
            }
            return cell ;
        }
        else if(indexPath.section == JOB_CHOOSE_COMPANY_SECTION_INDEX || indexPath.section == JOB_COUNTRY_SECTION_INDEX || indexPath.section == JOB_STATE_SECTION_INDEX || indexPath.section == JOB_TYPE_SECTION_INDEX) {
            
            DobTableViewCell *cell = (DobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Startups] ;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [UtilityClass setTextFieldBorder:cell.textFld] ;
            [UtilityClass addMarginsOnTextField:cell.textFld] ;
            
            cell.textFld.placeholder =[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            cell.textFld.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"] ;
            cell.textFld.tag = indexPath.section ;
            cell.dropdownBtn.tag = indexPath.section ;
            [cell.dropdownBtn setBackgroundImage:[UIImage imageNamed:@"Signup_dropdown"] forState:UIControlStateNormal];
            cell.textFld.inputView = pickerViewContainer ;
            
            return cell ;
        }
        else if(indexPath.section == JOB_START_DATE_SECTION_INDEX || indexPath.section == JOB_END_DATE_SECTION_INDEX) {
            
            DobTableViewCell *cell = (DobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Startups] ;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [UtilityClass setTextFieldBorder:cell.textFld] ;
            [UtilityClass addMarginsOnTextField:cell.textFld] ;
            
            cell.textFld.placeholder =[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            cell.textFld.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"] ;
            cell.textFld.tag = indexPath.section ;
            cell.dropdownBtn.tag = indexPath.section ;
            [cell.dropdownBtn setBackgroundImage:[UIImage imageNamed:@"Calender"] forState:UIControlStateNormal];
            cell.textFld.inputView = datePickerViewContainer ;
            
            return cell ;
        }
        else {
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TEXTFIELD__CELL_IDENTIFIER] ;
            [UtilityClass setTextFieldBorder:cell.textFld] ;
            [UtilityClass addMarginsOnTextField:cell.textFld] ;
            cell.fieldNameLbl.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            cell.fieldNameLbl.hidden = false;
            
            cell.textFld.placeholder = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] ;
            cell.textFld.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone ;
            cell.textFld.tag = indexPath.section ;
            cell.textFld.delegate = self ;
            
            return cell ;
        }
    }
}

// if(indexPath.section <= JOB_REQUIREMENT_SECTION_INDEX && indexPath.section != JOB_INDUSTRY_KEYWORDS_SECTION_INDEX && indexPath.section != JOB_POSTING_KEYWORDS_SECTION_INDEX && indexPath.section != JOB_SKILLS_SECTION_INDEX && indexPath.section != JOB_CHOOSE_COMPANY_SECTION_INDEX && indexPath.section != JOB_COUNTRY_SECTION_INDEX && indexPath.section != JOB_STATE_SECTION_INDEX && indexPath.section != JOB_TYPE_SECTION_INDEX)

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == popupTblView)
        return 1;
    else
        return sectionsArray.count+1 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == popupTblView) {
        PaymentsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
        [self CheckUncheck_ClickAction:cell.checkboxBtn] ;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == popupTblView)
        return 50 ;
    else {
        if(indexPath.section == JOB_CHOOSE_COMPANY_SECTION_INDEX || indexPath.section == JOB_COUNTRY_SECTION_INDEX || indexPath.section == JOB_STATE_SECTION_INDEX || indexPath.section == JOB_TYPE_SECTION_INDEX || indexPath.section == JOB_START_DATE_SECTION_INDEX || indexPath.section == JOB_END_DATE_SECTION_INDEX) {
            return 40;
        }
        else if(indexPath.section == JOB_SUMMARY_SECTION_INDEX)
            return 100 ;
        else if(indexPath.section == JOB_INDUSTRY_KEYWORDS_SECTION_INDEX || indexPath.section == JOB_POSTING_KEYWORDS_SECTION_INDEX || indexPath.section == JOB_SKILLS_SECTION_INDEX || indexPath.section == sectionsArray.count)
            return 70 ;
        else
            return 75;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section <= JOB_POSTING_KEYWORDS_SECTION_INDEX || section == sectionsArray.count)return 0;
    else return 45 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,45)];
    sectionView.tag = section;
    
    // Background view
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, tableView.frame.size.width,35)];
    bgView.backgroundColor = [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1];
    
    // Title Label
    UILabel *viewLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.tblView.frame.size.width-20, 35)];
    viewLabel.backgroundColor = [UIColor clearColor];
    viewLabel.textColor = [UIColor colorWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1];
    viewLabel.font = [UIFont systemFontOfSize:15];
    viewLabel.text = [[sectionsArray objectAtIndex:section] valueForKey:@"field"];
    
    // Expand-Collapse icon
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.tblView.frame.size.width-34,viewLabel.frame.origin.y+viewLabel.frame.size.height/2-7 ,14, 14)];
    if ([[arrayForBool objectAtIndex:section] boolValue])
        imageView.image = [UIImage imageNamed:COLLAPSE_SECTION_IMAGE] ;
    else
        imageView.image = [UIImage imageNamed:EXPAND_SECTION_IMAGE] ;
    
    [sectionView addSubview:bgView] ;
    [sectionView addSubview:viewLabel];
    [sectionView addSubview:imageView];
    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    
    return  sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5 ;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

@end
