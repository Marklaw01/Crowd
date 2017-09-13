//
//  AddConsultingProjectViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "AddConsultingProjectViewController.h"

#import "KLCPopup.h"
#import "TextFieldTableViewCell.h"
#import "KeywordsTableViewCell.h"
#import "CommitTableViewCell.h"
#import "DescriptionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "PaymentsTableViewCell.h"
#import "FollowCampaignTableViewCell.h"
#import "GraphicTableViewCell.h"
#import "DobTableViewCell.h"

@interface AddConsultingProjectViewController ()

@end

@implementation AddConsultingProjectViewController

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
    
    consultingProjectData = [[UtilityClass getConsultingDetails] mutableCopy];
    NSLog(@"Consulting Data: %@",consultingProjectData) ;
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = @"Consulting Projects";
    [self initializeSectionArray] ;
}

-(void)initializeSectionArray {
    
    NSArray *fieldsArray = @[@"Consulting Project Title", @"Project Overview", @"Description/Conditions", @"Target User Keywords", @"Interest Keywords", @"Target Date to Distribute Project Overview", @"Deadline for Intent to Bid", @"Target Date to Distribute Project Requirements", @"Deadline for Commitment to Bid", @"Deadline for Questions", @"Target Date for Answers", @"Deadline for Proposals", @"Target Date for Bidder Presentations", @"Target Date to Award the Project", @"Target Project Start Date", @"Target Project End Date", @"Upload Image"] ;
    
    NSArray *parametersArray = @[kConsultingAPI_Title,
                                 kConsultingAPI_Overview,
                                 kConsultingAPI_Description,
                                 kAddConsultingAPI_Target_User_Keywords,
                                 kAddConsultingAPI_InterestKeywords,
                                 kConsultingAPI_Project_Overview_Date,
                                 kConsultingAPI_Bid_Intent_Deadline_Date,
                                 kConsultingAPI_Req_Dist_Date,
                                 kConsultingAPI_Bid_Comm_Deadline_Date,
                                 kConsultingAPI_Ques_Deadline_Date,
                                 kConsultingAPI_Answer_Target_Date,
                                 kConsultingAPI_Proposal_Submit_Date,
                                 kConsultingAPI_Bidder_Pres_Date,
                                 kConsultingAPI_Project_Award_Date,
                                 kConsultingAPI_Project_Start_Date,
                                 kConsultingAPI_Project_Complete_Date,
                                 kConsultingAPI_Image] ;
    
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
    targetUserKeywordsArray = [[NSMutableArray alloc] init] ;
    interestKeywordsArray = [[NSMutableArray alloc] init] ;
    
    selectedTargetUserKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedInterestKeywordsArray = [[NSMutableArray alloc] init] ;
    
    selectedTargetUserKeywordIds = [[NSMutableArray alloc] init] ;
    selectedInterestKeywordIds = [[NSMutableArray alloc] init] ;
    
    selectedTargetUserKeywordNames = [[NSMutableArray alloc] init] ;
    selectedInterestKeywordNames = [[NSMutableArray alloc] init] ;
    
    searchResultsForKeywords = [[NSMutableArray alloc] init];
    
    prevDueDate       = @"" ;
    
    selectedDatePickerType = -1 ;
    selectedKeywordType = -1;
    
    [datePickerView setMinimumDate:[NSDate date]] ;
    [datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm a"];
    
    [self getConsultingInterestKeywordsList];
    [self getTargetUserKeywordsList];
    
    [self.tblView reloadData] ;
}

- (void)checkKeywordsListFound:(int)keywordType {
    switch (keywordType) {
        case 3:
        {
            if (targetUserKeywordsArray.count > 0)
                [self openTagsPopup] ;
            else
                [self presentViewController:[UtilityClass displayAlertMessage:kNoTargetUserKeywordsFoundMessage] animated:YES completion:nil];
        }
            break;
        case 4:
        {
            if (interestKeywordsArray.count > 0)
                [self openTagsPopup] ;
            else
                [self presentViewController:[UtilityClass displayAlertMessage:kNoInterestKeywordsFoundMessage] animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Tap gesture
- (void)txtViewTapped_Gesture:(UITapGestureRecognizer *)gestureRecognizer {
    selectedKeywordType = (int)[gestureRecognizer.view tag] ;
    [self checkKeywordsListFound:selectedKeywordType];
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

-(NSMutableArray*)resetTagIdsArrayWithData:(NSArray*)array {
    NSMutableArray *tagsArray = [[NSMutableArray alloc] init] ;
    for (NSDictionary *obj in array) {
        [tagsArray addObject:[obj valueForKey:@"id"]] ;
    }
    return tagsArray ;
}

-(NSString*)convertTagsArrayToStringforArray:(NSMutableArray*)array withTagsArray:(NSArray*)tagsArray tagType:(NSString *)type {
    NSString *tagsStr = @"" ;
    BOOL isFirstTag = YES ;
    
    if ([type isEqualToString:@"targetuser"]) {
        for (NSDictionary *dict in tagsArray) {
            NSString *value = [dict valueForKey:kConsultingAPI_Target_User_ID] ;
            for (NSString *obj in array) {
                NSString *selectedValue = [obj valueForKey:kConsultingAPI_Target_User_ID] ;
                if([selectedValue intValue] == [value intValue]){
                    if(isFirstTag)
                        tagsStr = [dict valueForKey:kConsultingAPI_Target_User_ID] ;
                    else tagsStr = [NSString stringWithFormat:@"%@,%@",tagsStr,[dict valueForKey:kConsultingAPI_Target_User_ID]] ;
                    isFirstTag = NO ;
                }
            }
        }
    } else if ([type isEqualToString:@"interest"]) {
        for (NSDictionary *dict in tagsArray) {
            NSString *value = [dict valueForKey:kConsultingAPI_Interest_ID] ;
            for (NSString *obj in array) {
                NSString *selectedValue = [obj valueForKey:kConsultingAPI_Interest_ID] ;
                if([selectedValue intValue] == [value intValue]){
                    if(isFirstTag) tagsStr = [dict valueForKey:kConsultingAPI_Interest_ID] ;
                    else tagsStr = [NSString stringWithFormat:@"%@,%@",tagsStr,[dict valueForKey:kConsultingAPI_Interest_ID]] ;
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
    [self checkKeywordsListFound:selectedKeywordType];
}

- (IBAction)CheckUncheck_ClickAction:(id)sender {
    UIButton *btn = (UIButton*)sender ;
    if([btn.accessibilityLabel isEqualToString:CHECK_IMAGE ]) { // Check
        [btn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = UNCHECK_IMAGE ;
        
        NSDictionary *dictKeyword = [[NSDictionary alloc] init];
        
        if (![searchBarKeywords.text isEqualToString:@""])
            dictKeyword = [searchResultsForKeywords objectAtIndex:btn.tag];
        else {
            if(selectedKeywordType == CONSULTING_INTEREST_KEYWORDS_SELECTED)
                dictKeyword = [interestKeywordsArray objectAtIndex:btn.tag];
            else
                dictKeyword = [targetUserKeywordsArray objectAtIndex:btn.tag];
        }
        [dictKeyword setValue:@"0" forKey:@"isSelected"];
    }
    else{ // Uncheck
        [btn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = CHECK_IMAGE ;
        NSDictionary *dictKeyword = [[NSDictionary alloc] init];
        
        if (![searchBarKeywords.text isEqualToString:@""])
            dictKeyword = [searchResultsForKeywords objectAtIndex:btn.tag];
        else {
            if(selectedKeywordType == CONSULTING_INTEREST_KEYWORDS_SELECTED)
                dictKeyword = [interestKeywordsArray objectAtIndex:btn.tag];
            else
                dictKeyword = [targetUserKeywordsArray objectAtIndex:btn.tag];
        }
        [dictKeyword setValue:@"1" forKey:@"isSelected"];
    }
}

- (IBAction)OK_ClickAction:(id)sender {
    [popupView removeFromSuperview];
    searchBarKeywords.text = @"";
    
    if(selectedKeywordType == CONSULTING_INTEREST_KEYWORDS_SELECTED) {
        [selectedInterestKeywordsArray removeAllObjects] ;
        [selectedInterestKeywordNames removeAllObjects];
        [selectedInterestKeywordIds removeAllObjects];
        
        for (NSMutableDictionary *obj in interestKeywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"]) {
                [selectedInterestKeywordsArray addObject:obj] ;
                [selectedInterestKeywordNames addObject:[obj valueForKey:kConsultingAPI_Interest_Name]] ;
                [selectedInterestKeywordIds addObject:[obj valueForKey:kConsultingAPI_Interest_ID]] ;
            }
        }
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:CONSULTING_INTEREST_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
    } else {
        [selectedTargetUserKeywordsArray removeAllObjects] ;
        [selectedTargetUserKeywordNames removeAllObjects];
        [selectedTargetUserKeywordIds removeAllObjects];
        
        for (NSMutableDictionary *obj in targetUserKeywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"]) {
                [selectedTargetUserKeywordsArray addObject:obj] ;
                [selectedTargetUserKeywordNames addObject:[obj valueForKey:kConsultingAPI_Target_User_Name]] ;
                [selectedTargetUserKeywordIds addObject:[obj valueForKey:kConsultingAPI_Target_User_ID]] ;
            }
        }
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:CONSULTING_TARGET_USER_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
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
    
    if(tagControlIndex == CONSULTING_INTEREST_KEYWORDS_SELECTED) {
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedInterestKeywordNames objectAtIndex:index]] ;
        for (int i=0; i<interestKeywordsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[interestKeywordsArray objectAtIndex:i] valueForKey:kConsultingAPI_Interest_Name]] ;
            if([keywordName isEqualToString:selectedName]){
                [[interestKeywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedInterestKeywordsArray removeObjectAtIndex:index] ;
        [selectedInterestKeywordNames removeObjectAtIndex:index];
        [selectedInterestKeywordIds removeObjectAtIndex:index];
        
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:CONSULTING_INTEREST_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
    } else {
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedTargetUserKeywordNames objectAtIndex:index]] ;
        for (int i=0; i<targetUserKeywordsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[targetUserKeywordsArray objectAtIndex:i] valueForKey:kConsultingAPI_Target_User_Name]] ;
            if([keywordName isEqualToString:selectedName]){
                [[targetUserKeywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedTargetUserKeywordsArray removeObjectAtIndex:index] ;
        [selectedTargetUserKeywordNames removeObjectAtIndex:index];
        [selectedTargetUserKeywordIds removeObjectAtIndex:index];
        
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:CONSULTING_TARGET_USER_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
    }
}

-(void)navigateToScreenWithViewIdentifier:(NSString *)viewIdentifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:viewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [UtilityClass setComingFrom_Consulting_AddEditScreen:NO];
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)Calender_ClickAction:(id)sender {
    DobTableViewCell *cell;
    
    if ([sender tag] == CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SECTION_INDEX)
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SECTION_INDEX]] ;
    else if ([sender tag] == CONSULTING_BID_INTENT_DEADLINE_DATE_SECTION_INDEX)
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_BID_INTENT_DEADLINE_DATE_SECTION_INDEX]] ;
    else if ([sender tag] == CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SECTION_INDEX)
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SECTION_INDEX]] ;
    else if ([sender tag] == CONSULTING_BID_COMMITMENT_DEADLINE_SECTION_INDEX)
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_BID_COMMITMENT_DEADLINE_SECTION_INDEX]] ;
    else if ([sender tag] == CONSULTING_QUESTION_DEADLINE_DATE_TIME_SECTION_INDEX)
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_QUESTION_DEADLINE_DATE_TIME_SECTION_INDEX]] ;
    else if ([sender tag] == CONSULTING_ANSWER_TARGET_DATE_SECTION_INDEX)
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_ANSWER_TARGET_DATE_SECTION_INDEX]] ;
    else if ([sender tag] == CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SECTION_INDEX)
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SECTION_INDEX]] ;
    else if ([sender tag] == CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SECTION_INDEX)
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SECTION_INDEX]] ;
    else if ([sender tag] == CONSULTING_PROJECT_AWARD_TARGET_DATE_SECTION_INDEX)
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_AWARD_TARGET_DATE_SECTION_INDEX]] ;
    else if ([sender tag] == CONSULTING_PROJECT_START_TARGET_DATE_SECTION_INDEX)
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_START_TARGET_DATE_SECTION_INDEX]] ;
    else
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_COMPLETE_TARGET_DATE_SECTION_INDEX]];
    
    if (![cell.textFld.text isEqualToString:@""])
        [datePickerView setDate:[dateFormatter dateFromString:cell.textFld.text] animated:YES] ;
    else
        [datePickerView setMinimumDate:[NSDate date]] ;
    
    [cell.textFld becomeFirstResponder] ;
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

- (IBAction)Submit_ClickAction:(id)sender {
 
    // Title
    if(![self validatetextFieldsWithSectionIndex:CONSULTING_TITLE_SECTION_INDEX]) return ;
    // Overview
    else if(![self validatetextFieldsWithSectionIndex:CONSULTING_PROJECT_OVERVIEW_SECTION_INDEX]) return ;
    // Description
    else if(![self validatetextFieldsWithSectionIndex:CONSULTING_DESCRIPTION_SECTION_INDEX]) return ;
    // Keywords
    else if(selectedInterestKeywordsArray.count < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_InterestKeywordRequired] animated:YES completion:nil] ;
        return ;
    }
    else if(selectedTargetUserKeywordsArray.count < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_TargetKeywordRequired] animated:YES completion:nil] ;
        return ;
    }
    // Date fields
    else if(![self validatetextFieldsWithSectionIndex:CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:CONSULTING_BID_INTENT_DEADLINE_DATE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:CONSULTING_BID_COMMITMENT_DEADLINE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:CONSULTING_QUESTION_DEADLINE_DATE_TIME_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:CONSULTING_ANSWER_TARGET_DATE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:CONSULTING_PROJECT_AWARD_TARGET_DATE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:CONSULTING_PROJECT_START_TARGET_DATE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:CONSULTING_PROJECT_COMPLETE_TARGET_DATE_SECTION_INDEX]) return ;
    // if validation is successful, hit api to register consulting project
    else [self createConsulting] ;
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
    
    if(isCameraMode)
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    else
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if(isImageSelected)
        picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    else
        picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie,(NSString *)kUTTypeVideo, nil];
    
    [self.navigationController presentViewController:picker animated:YES completion:nil] ;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    GraphicTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_IMAGE_SECTION_INDEX]] ;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"info>> %@",info) ;
    if([info[UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        chosenImage = info[UIImagePickerControllerEditedImage];
        cell.graphicImg.image = chosenImage;
        imgData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1);
    }
    else {
        
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
            NSString *moviePath = [videoUrl path];
            
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
            }
            videoData = [NSData dataWithContentsOfFile:moviePath] ;
        }
    }
}

#pragma mark - ToolBar Buttons Action
- (IBAction)DatePickerToolbarButtons_ClickAction:(id)sender {
    DobTableViewCell *cell;
    
    if([sender tag] == DONE_CLICKED) {
        if(selectedDatePickerType == CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
        else if(selectedDatePickerType == CONSULTING_BID_INTENT_DEADLINE_DATE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_BID_INTENT_DEADLINE_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:CONSULTING_BID_INTENT_DEADLINE_DATE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
        else if(selectedDatePickerType == CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
        else if(selectedDatePickerType == CONSULTING_BID_COMMITMENT_DEADLINE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_BID_COMMITMENT_DEADLINE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:CONSULTING_BID_COMMITMENT_DEADLINE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
        else if(selectedDatePickerType == CONSULTING_QUESTION_DEADLINE_DATE_TIME_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_QUESTION_DEADLINE_DATE_TIME_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:CONSULTING_QUESTION_DEADLINE_DATE_TIME_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
        else if(selectedDatePickerType == CONSULTING_ANSWER_TARGET_DATE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_ANSWER_TARGET_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:CONSULTING_ANSWER_TARGET_DATE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
        else if(selectedDatePickerType == CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
        else if(selectedDatePickerType == CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
        else if(selectedDatePickerType == CONSULTING_PROJECT_AWARD_TARGET_DATE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_AWARD_TARGET_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:CONSULTING_PROJECT_AWARD_TARGET_DATE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
        else if(selectedDatePickerType == CONSULTING_PROJECT_START_TARGET_DATE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_START_TARGET_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:CONSULTING_PROJECT_START_TARGET_DATE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
        else {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_COMPLETE_TARGET_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            [cell.textFld setText:[dateFormatter stringFromDate:datePickerView.date]];
            [[sectionsArray objectAtIndex:CONSULTING_PROJECT_COMPLETE_TARGET_DATE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
    }
    else {
        if(selectedDatePickerType == CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate;
        }
        else if(selectedDatePickerType == CONSULTING_BID_INTENT_DEADLINE_DATE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_BID_INTENT_DEADLINE_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate;
        }
        else if(selectedDatePickerType == CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate ;
        }
        else if(selectedDatePickerType == CONSULTING_BID_COMMITMENT_DEADLINE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_BID_COMMITMENT_DEADLINE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate;
        }
        else if(selectedDatePickerType == CONSULTING_QUESTION_DEADLINE_DATE_TIME_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_QUESTION_DEADLINE_DATE_TIME_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate;
        }
        else if(selectedDatePickerType == CONSULTING_ANSWER_TARGET_DATE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_ANSWER_TARGET_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate;
        }
        else if(selectedDatePickerType == CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate;
        }
        else if(selectedDatePickerType == CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate;
        }
        else if(selectedDatePickerType == CONSULTING_PROJECT_AWARD_TARGET_DATE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_AWARD_TARGET_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate;
        }
        else if(selectedDatePickerType == CONSULTING_PROJECT_START_TARGET_DATE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_START_TARGET_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate;
        }
        else {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_COMPLETE_TARGET_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate ;
        }
    }
}

#pragma mark - SearchBar Delegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //    if(searchText.length < 1 || [searchText isEqualToString:@" "])
    //        return ;
    [searchResultsForKeywords removeAllObjects] ;
    
    switch (selectedKeywordType) {
        case 3: // Target Keywords
        {
            for(NSDictionary *keywordDict in targetUserKeywordsArray)
            {
                NSString *keywordName = [keywordDict objectForKey:@"name"];
                NSRange range = [keywordName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if(range.location != NSNotFound)
                    [searchResultsForKeywords addObject:keywordDict];
            }
            NSLog(@"Target Results: %@",searchResultsForKeywords);
        }
            break;
        case 4: // Interest Keywords
        {
            for(NSDictionary *keywordDict in interestKeywordsArray)
            {
                NSString *keywordName = [keywordDict objectForKey:@"name"];
                NSRange range = [keywordName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if(range.location != NSNotFound)
                    [searchResultsForKeywords addObject:keywordDict];
            }
            NSLog(@"Interest Results: %@",searchResultsForKeywords);
        }
            break;
            
        default:
            break;
    }
    [popupTblView reloadData] ;
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
    
    if (textField.tag == CONSULTING_TITLE_SECTION_INDEX) {
        _selectedItem = textField ;
    } else {
        if(textField.tag == CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SECTION_INDEX)
            selectedDatePickerType = CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SELECTED;
        else if(textField.tag == CONSULTING_BID_INTENT_DEADLINE_DATE_SECTION_INDEX)
            selectedDatePickerType = CONSULTING_BID_INTENT_DEADLINE_DATE_SELECTED;
        else if(textField.tag == CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SECTION_INDEX)
            selectedDatePickerType = CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SELECTED;
        else if(textField.tag == CONSULTING_BID_COMMITMENT_DEADLINE_SECTION_INDEX)
            selectedDatePickerType = CONSULTING_BID_COMMITMENT_DEADLINE_SELECTED;
        else if(textField.tag == CONSULTING_QUESTION_DEADLINE_DATE_TIME_SECTION_INDEX)
            selectedDatePickerType = CONSULTING_QUESTION_DEADLINE_DATE_TIME_SELECTED;
        else if(textField.tag == CONSULTING_ANSWER_TARGET_DATE_SECTION_INDEX)
            selectedDatePickerType = CONSULTING_ANSWER_TARGET_DATE_SELECTED;
        else if(textField.tag == CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SECTION_INDEX)
            selectedDatePickerType = CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SELECTED;
        else if(textField.tag == CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SECTION_INDEX)
            selectedDatePickerType = CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SELECTED;
        else if(textField.tag == CONSULTING_PROJECT_AWARD_TARGET_DATE_SECTION_INDEX)
            selectedDatePickerType = CONSULTING_PROJECT_AWARD_TARGET_DATE_SELECTED;
        else if(textField.tag == CONSULTING_PROJECT_START_TARGET_DATE_SECTION_INDEX)
            selectedDatePickerType = CONSULTING_PROJECT_START_TARGET_DATE_SELECTED;
        else
            selectedDatePickerType = CONSULTING_PROJECT_COMPLETE_TARGET_DATE_SELECTED;
    }
    
    /* Validation for Assignment Start/End Date Time
     
     DobTableViewCell *startDatecell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_ASSIGNMENT_START_DATE_TIME_SECTION_INDEX]] ;
     
     NSDate *startDate = [dateFormatter dateFromString:startDatecell.textFld.text]; // start date
     if(startDate == nil)
     [self presentViewController:[UtilityClass displayAlertMessage:@"Please select the Assignmnt Start Date Time first."] animated:YES completion:nil];
     else
     [datePickerView setMinimumDate:startDate] ;
     
     */
    
    return YES ;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == CONSULTING_TITLE_SECTION_INDEX) {
        _selectedItem = nil ;
    } else {
        /* Condition for Assignment Start/End Date Time
        if(textField.tag == CONSULTING_ASSIGNMENT_START_DATE_TIME_SECTION_INDEX) {
            DobTableViewCell *endDatecell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_ASSIGNMENT_END_DATE_TIME_SECTION_INDEX]] ;
            NSDate *endDate = [dateFormatter dateFromString:endDatecell.textFld.text]; // end date
            if(endDate != nil)
                endDatecell.textFld.text = @"";
        }
        */
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
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _selectedItem = nil ;
    
    if (textView.tag == CONSULTING_PROJECT_OVERVIEW_SECTION_INDEX) {
        if([textView.text isEqualToString:@"Project Overview"] && textView.textColor == [UIColor lightGrayColor]){
            textView.text = @"" ;
            textView.textColor = [UtilityClass textColor] ;
        }
    } else {
        if([textView.text isEqualToString:@"Description/Conditions"] && textView.textColor == [UIColor lightGrayColor]){
            textView.text = @"" ;
            textView.textColor = [UtilityClass textColor] ;
        }
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
    
    if (textView.tag == CONSULTING_PROJECT_OVERVIEW_SECTION_INDEX) {
        if([textView.text isEqualToString:@""]) {
            textView.text = @"Project Overview" ;
            textView.textColor = [UIColor lightGrayColor] ;
        }
    } else {
        if([textView.text isEqualToString:@""]) {
            textView.text = @"Description/Conditions" ;
            textView.textColor = [UIColor lightGrayColor] ;
        }
    }
    
    if ([textView.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        CGPoint buttonPosition = [textView convertPoint:CGPointZero
                                                 toView: self.tblView];
        NSIndexPath *indexPath = [self.tblView indexPathForRowAtPoint:buttonPosition];
        
        [self.tblView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
    }
    [[sectionsArray objectAtIndex:textView.tag] setValue:[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"value"] ;
    
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

-(void)moveToOriginalFrame {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tblView.contentInset = contentInsets;
    self.tblView.scrollIndicatorInsets = contentInsets;
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

#pragma mark - DatePicker Value Changed
- (void)datePickerChanged:(UIDatePicker *)datePicker {
    
    DobTableViewCell *cell;
    
    if(selectedDatePickerType == CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SELECTED) {
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SECTION_INDEX]] ;
    }
    else if(selectedDatePickerType == CONSULTING_BID_INTENT_DEADLINE_DATE_SELECTED) {
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_BID_INTENT_DEADLINE_DATE_SECTION_INDEX]] ;
    }
    else if(selectedDatePickerType == CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SELECTED) {
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SECTION_INDEX]] ;
    }
    else if(selectedDatePickerType == CONSULTING_BID_COMMITMENT_DEADLINE_SELECTED) {
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_BID_COMMITMENT_DEADLINE_SECTION_INDEX]] ;
    }
    else if(selectedDatePickerType == CONSULTING_QUESTION_DEADLINE_DATE_TIME_SELECTED) {
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_QUESTION_DEADLINE_DATE_TIME_SECTION_INDEX]] ;
    }
    else if(selectedDatePickerType == CONSULTING_ANSWER_TARGET_DATE_SELECTED) {
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_ANSWER_TARGET_DATE_SECTION_INDEX]] ;
    }
    else if(selectedDatePickerType == CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SELECTED) {
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SECTION_INDEX]] ;
    }
    else if(selectedDatePickerType == CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SELECTED) {
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SECTION_INDEX]] ;
    }
    else if(selectedDatePickerType == CONSULTING_PROJECT_AWARD_TARGET_DATE_SELECTED) {
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_AWARD_TARGET_DATE_SECTION_INDEX]] ;
    }
    else if(selectedDatePickerType == CONSULTING_PROJECT_START_TARGET_DATE_SELECTED) {
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_START_TARGET_DATE_SECTION_INDEX]] ;
    }
    else {
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_PROJECT_COMPLETE_TARGET_DATE_SECTION_INDEX]] ;
    }
    
    [cell.textFld setText:[dateFormatter stringFromDate:datePicker.date]];

//    if (selectedDatePickerType == CONSULTING_START_DATE_SELECTED)
//        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_START_DATE_SECTION_INDEX]] ;
//    else
//        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CONSULTING_END_DATE_SECTION_INDEX]] ;
//    
//    [cell.textFld setText:[dateFormatter stringFromDate:datePicker.date]];
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - API Methods
-(void)getConsultingInterestKeywordsList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        [ApiCrowdBootstrap getConsultingIndustryKeywordsList:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"response : %@", responseDict);
                [interestKeywordsArray removeAllObjects] ;
                if([responseDict objectForKey:kConsultingAPI_Interest_List]) {
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:kConsultingAPI_Interest_List] mutableCopy]) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:[dict mutableCopy]] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        [interestKeywordsArray addObject:obj] ;
                    }
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode) {
                //                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getTargetUserKeywordsList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_UserID] ;
        
        [ApiCrowdBootstrap getConsultingTargetMarketKeywordsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"response : %@", responseDict);
                [targetUserKeywordsArray removeAllObjects] ;
                if([responseDict objectForKey:kConsultingAPI_Target_User_List]) {
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:kConsultingAPI_Target_User_List] mutableCopy]) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:[dict mutableCopy]] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        [targetUserKeywordsArray addObject:obj] ;
                    }
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode) {
                //                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)createConsulting {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConsultingAPI_UserID] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:CONSULTING_TITLE_SECTION_INDEX] valueForKey:@"value"] forKey:kConsultingAPI_Title] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:CONSULTING_DESCRIPTION_SECTION_INDEX] valueForKey:@"value"] forKey:kConsultingAPI_Description] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:CONSULTING_PROJECT_OVERVIEW_SECTION_INDEX] valueForKey:@"value"] forKey:kConsultingAPI_Overview] ;

        // Dates
        [dictParam setObject:[[sectionsArray objectAtIndex:CONSULTING_PROJECT_OVERVIEW_DATE_TIME_SECTION_INDEX] valueForKey:@"value"] forKey:kConsultingAPI_Project_Overview_Date] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:CONSULTING_BID_INTENT_DEADLINE_DATE_SECTION_INDEX] valueForKey:@"value"] forKey:kConsultingAPI_Bid_Intent_Deadline_Date] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:CONSULTING_REQUIREMENT_DISTRIBUTION_DATE_SECTION_INDEX] valueForKey:@"value"] forKey:kConsultingAPI_Req_Dist_Date] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:CONSULTING_BID_COMMITMENT_DEADLINE_SECTION_INDEX] valueForKey:@"value"] forKey:kConsultingAPI_Bid_Comm_Deadline_Date] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:CONSULTING_QUESTION_DEADLINE_DATE_TIME_SECTION_INDEX] valueForKey:@"value"] forKey:kConsultingAPI_Ques_Deadline_Date] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:CONSULTING_ANSWER_TARGET_DATE_SECTION_INDEX] valueForKey:@"value"] forKey:kConsultingAPI_Answer_Target_Date] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:CONSULTING_PROPOSAL_SUBMIT_DEADLINE_DATE_SECTION_INDEX] valueForKey:@"value"] forKey:kConsultingAPI_Proposal_Submit_Date] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:CONSULTING_BIDDER_PRESENTATION_DATE_TIME_SECTION_INDEX] valueForKey:@"value"] forKey:kConsultingAPI_Bidder_Pres_Date] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:CONSULTING_PROJECT_AWARD_TARGET_DATE_SECTION_INDEX] valueForKey:@"value"] forKey:kConsultingAPI_Project_Award_Date] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:CONSULTING_PROJECT_START_TARGET_DATE_SECTION_INDEX] valueForKey:@"value"] forKey:kConsultingAPI_Project_Start_Date] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:CONSULTING_PROJECT_COMPLETE_TARGET_DATE_SECTION_INDEX] valueForKey:@"value"] forKey:kConsultingAPI_Project_Complete_Date] ;
        
        // Keywords
        [dictParam setObject:[self convertTagsArrayToStringforArray:selectedInterestKeywordsArray withTagsArray:interestKeywordsArray tagType:@"interest"] forKey:kAddConsultingAPI_InterestKeywords] ;
        [dictParam setObject:[self convertTagsArrayToStringforArray:selectedTargetUserKeywordsArray withTagsArray:targetUserKeywordsArray tagType:@"targetuser"] forKey:kAddConsultingAPI_Target_User_Keywords] ;
        
        // Image
        if(imgData)
            [dictParam setObject:imgData forKey:kConsultingAPI_Image] ;
        else
            [dictParam setObject:@"" forKey:kConsultingAPI_Image] ;
        
        // Documents
        [dictParam setObject:@"" forKey:kConsultingAPI_Document] ;
        [dictParam setObject:@"" forKey:kConsultingAPI_Audio] ;
        [dictParam setObject:@"" forKey:kConsultingAPI_Video] ;
        [dictParam setObject:@"" forKey:kConsultingAPI_Question] ;
        [dictParam setObject:@"" forKey:kConsultingAPI_FinalBid] ;

        NSLog(@"dictParam: %@",dictParam) ;
        CommitTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionsArray.count]] ;
        
        cell.progressLbl.hidden = NO ;
        cell.progressView.hidden = NO ;
        
        [ApiCrowdBootstrap addConsultingWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            cell.progressLbl.hidden = YES ;
            cell.progressView.hidden = YES ;
            
            NSLog(@"responseDict >>>>> %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kAddConsultingProject_SuccessMessage withResultType:@"0" withDuration:1] ;
                [UtilityClass setComingFrom_Consulting_AddEditScreen:YES];
                [self.navigationController popViewControllerAnimated:YES] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
            cell.progressLbl.hidden = YES ;
            cell.progressView.hidden = YES ;
            
        } progress:^(double progress) {
            // NSLog(@"progress %f",progress) ;
            cell.progressView.progress = progress ;
            int prog = (int)progress*100;
            cell.progressLbl.text = [NSString stringWithFormat:@"%d %@",prog,@"% Completed"] ;
        }] ;
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == popupTblView) {
        if (![searchBarKeywords.text isEqualToString:@""])
            return searchResultsForKeywords.count ;
        else {
            if(selectedKeywordType == CONSULTING_INTEREST_KEYWORDS_SELECTED)
                return interestKeywordsArray.count ;
            else
                return targetUserKeywordsArray.count ;
        }
    } else {
        if(section <= CONSULTING_PROJECT_COMPLETE_TARGET_DATE_SECTION_INDEX || section == sectionsArray.count)
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
        
        NSDictionary *dictKeyword = [[NSDictionary alloc] init];
        
        if(selectedKeywordType == CONSULTING_INTEREST_KEYWORDS_SELECTED) {
            if (![searchBarKeywords.text isEqualToString:@""])
                dictKeyword = [searchResultsForKeywords objectAtIndex:indexPath.row];
            else
                dictKeyword = [interestKeywordsArray objectAtIndex:indexPath.row];
            
            cell.companyNameLbl.text = [dictKeyword valueForKey:kConsultingAPI_Interest_Name] ;
            if ([selectedInterestKeywordIds containsObject:[dictKeyword valueForKey:kConsultingAPI_Interest_ID]]) {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
                [dictKeyword setValue:@"1" forKey:@"isSelected"] ;
            } else {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
                [dictKeyword setValue:@"0" forKey:@"isSelected"] ;
            }
        }
        else {
            if (![searchBarKeywords.text isEqualToString:@""])
                dictKeyword = [searchResultsForKeywords objectAtIndex:indexPath.row];
            else
                dictKeyword = [targetUserKeywordsArray objectAtIndex:indexPath.row];
            
            cell.companyNameLbl.text = [dictKeyword valueForKey:kConsultingAPI_Target_User_Name] ;
            if ([selectedTargetUserKeywordIds containsObject:[dictKeyword valueForKey:kConsultingAPI_Target_User_ID]]) {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
                [dictKeyword setValue:@"1" forKey:@"isSelected"] ;
            } else {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
                [dictKeyword setValue:@"0" forKey:@"isSelected"] ;
            }
        }
        
        return cell ;
    } else {
        if(indexPath.section == sectionsArray.count) {
            CommitTableViewCell *cell = (CommitTableViewCell*)[tableView dequeueReusableCellWithIdentifier:SUBMIT_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            return cell ;
        }
        else if(indexPath.section == CONSULTING_INTEREST_KEYWORDS_SECTION_INDEX || indexPath.section == CONSULTING_TARGET_USER_KEYWORDS_SECTION_INDEX) {
            KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KEYWORDS_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [UtilityClass setButtonBorder:cell.button] ;
            cell.tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1] CGColor];
            cell.tagsScrollView.backgroundColor = [UIColor clearColor] ;
            cell.tagsScrollView.tag = indexPath.section ;
            cell.button.tag = indexPath.section ;
            cell.plusBtn.tag = indexPath.section ;
            
            NSMutableArray *tags ;
            if(indexPath.section == CONSULTING_INTEREST_KEYWORDS_SECTION_INDEX)
                tags = [selectedInterestKeywordNames mutableCopy] ;
            else
                tags = [selectedTargetUserKeywordNames mutableCopy] ;
            
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
        else if(indexPath.section == CONSULTING_DESCRIPTION_SECTION_INDEX || indexPath.section == CONSULTING_PROJECT_OVERVIEW_SECTION_INDEX) {
            DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DESCRIPTION_CELL_IDENTIFIER] ;
            
            cell.fieldNameLbl.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"];
            cell.descriptionTxtView.tag = indexPath.section ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            [UtilityClass setTextViewBorder:cell.descriptionTxtView] ;
            
            NSString *descText = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
            
            if(descText.length < 1 || [descText isEqualToString:@""]) {
                cell.descriptionTxtView.textColor = [UIColor lightGrayColor] ;
                cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] ;
            }
            else {
                cell.descriptionTxtView.textColor = [UtilityClass textColor] ;
                cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
            }
            return cell ;
        }
        else if(indexPath.section == CONSULTING_IMAGE_SECTION_INDEX) {
            
            GraphicTableViewCell *cell = (GraphicTableViewCell*)[tableView dequeueReusableCellWithIdentifier:IMAGES_CELL_IDENTIFIER] ;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            if (chosenImage != nil)
                cell.graphicImg.image = chosenImage;
            else {
                NSString *imgUrlStr = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]];
                NSURL *url = [NSURL URLWithString:[imgUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                [cell.graphicImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:kCampainDetail_DefaultImage]] ;
            }
            
            return cell ;
        }
        else if(indexPath.section == CONSULTING_TITLE_SECTION_INDEX) {
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
        } else {
            DobTableViewCell *cell = (DobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Startups] ;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [UtilityClass setTextFieldBorder:cell.textFld] ;
            [UtilityClass addMarginsOnTextField:cell.textFld] ;
            
            cell.fieldNameLbl.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"];
            cell.textFld.placeholder = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            cell.textFld.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"] ;
            cell.textFld.tag = indexPath.section ;
            cell.dropdownBtn.tag = indexPath.section ;
            cell.textFld.inputView = datePickerViewContainer ;
            
            return cell ;
        }
    }
}

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
        if(indexPath.section == CONSULTING_TITLE_SECTION_INDEX)
            return 75;
        else if(indexPath.section == CONSULTING_DESCRIPTION_SECTION_INDEX || indexPath.section == CONSULTING_PROJECT_OVERVIEW_SECTION_INDEX )
            return 121 ;
        else if(indexPath.section == CONSULTING_IMAGE_SECTION_INDEX)
            return 155 ;
        else if(indexPath.section == CONSULTING_INTEREST_KEYWORDS_SECTION_INDEX || indexPath.section == CONSULTING_TARGET_USER_KEYWORDS_SECTION_INDEX)
            return 70 ;
        else if(indexPath.section == sectionsArray.count)
            return 95;
        else
            return 65;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section <= CONSULTING_PROJECT_COMPLETE_TARGET_DATE_SECTION_INDEX || section == sectionsArray.count)return 0;
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
