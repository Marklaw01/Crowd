//
//  AddExperiencesViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/01/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "AddExperiencesViewController.h"
#import "KeywordsTableViewCell.h"
#import "SubmitAppTableViewCell.h"
#import "PaymentsTableViewCell.h"
#import "KLCPopup.h"

@interface AddExperiencesViewController ()

@end

@implementation AddExperiencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Add Experience" ;
    
    tblView.estimatedRowHeight = 110 ;
    tblView.rowHeight = UITableViewAutomaticDimension ;
    
    [tblView setNeedsLayout] ;
    [tblView layoutIfNeeded] ;
    
    [self resetUISettings] ;
    
    [self getJobRoles];
    [self getExperienceList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}

#pragma mark - Custom Methods
-(void)resetUISettings {
    
    // Initialize Array
    experienceArray = [[NSMutableArray alloc] init] ;
    selectedKeywordsArray = [[NSMutableArray alloc] init] ;
    keywordsArray = [[NSMutableArray alloc] init];
    selectedJobRoleArray = [[NSMutableArray alloc] init];
    
    fieldsArray = @[@"Company Name", @"Job Title", @"Start Date", @"End Date", @"Company URL", @"Job Role", @"Job Duties", @"Achievments"];
    parametersArray = @[kJobDetailAPI_CompanyName, kJobDetailAPI_JobTitle, kJobDetailAPI_StartDate,kJobDetailAPI_EndDate, kJobDetailAPI_CompanyUrl, kJobDetailAPI_JobRoleID, kJobDetailAPI_JobDuties, kJobDetailAPI_Achievments];
    
    // Tap Gesture
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [tblView addGestureRecognizer:singleTapGestureRecognizer];
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Add Observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Date Picker Initialization
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    [datePickerView setMinimumDate:[NSDate date]] ;
    
    startDate = @"";
    endDate = @"";
    prevDueDate = @"" ;
    
    [datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Tap gesture
- (void)txtViewTapped_Gesture:(UITapGestureRecognizer *)gestureRecognizer {
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

#pragma mark - Keywords Popup Buttons Action
- (IBAction)AddTag_ClickAction:(id)sender {
    [self openTagsPopup] ;
}

- (IBAction)OK_ClickAction:(id)sender {
    [popupView removeFromSuperview];
    [selectedJobRoleArray removeAllObjects];
    [selectedKeywordsArray removeAllObjects] ;
    
    for (NSMutableDictionary *obj in keywordsArray) {
        NSMutableDictionary *dicFinal = [[NSMutableDictionary alloc] init];

        NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
        if([isSelectedStr isEqualToString:@"1"]) {
            [dicFinal setValue:[obj valueForKey:@"job_role_name"] forKey:@"name"];
            [dicFinal setValue:[obj valueForKey:@"job_role_id"] forKey:@"id"];

            if (![selectedKeywordsArray containsObject:[obj valueForKey:@"job_role_name"]]) {
                [selectedKeywordsArray addObject:[obj valueForKey:@"job_role_name"]] ;
                [selectedJobRoleArray addObject:dicFinal];
            } else {
                [selectedJobRoleArray removeObject:dicFinal];
                [selectedKeywordsArray removeObject:[obj valueForKey:@"job_role_name"]] ;
            }
        }
    }
    
    NSArray *array = [NSArray arrayWithArray:[[experienceArray objectAtIndex:[txtViewTapped.accessibilityValue integerValue]] valueForKey:@"questions"]] ;
    NSDictionary *oldQuesDict = [array objectAtIndex:5];
    NSMutableDictionary *newQuesDict = [[NSMutableDictionary alloc] init];
    [newQuesDict addEntriesFromDictionary:oldQuesDict];

//    NSMutableArray *ansArray = [[NSMutableArray alloc] init];
//    for (NSString *strName in selectedKeywordsArray) {
//        NSMutableDictionary *dicKeywordName = [[NSMutableDictionary alloc] init];
//        [dicKeywordName setValue:strName forKey:@"name"];
//        [ansArray addObject:dicKeywordName];
//    }
    
    if ([[oldQuesDict valueForKey:@"answer"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[oldQuesDict valueForKey:@"answer"]];
        [arr removeAllObjects];
        [arr addObjectsFromArray:selectedJobRoleArray];
        NSLog(@"arr: %@", arr);
        [newQuesDict setObject:arr forKey:@"answer"];

    } else {
        [newQuesDict setObject:selectedJobRoleArray forKey:@"answer"];
    }
    
    [[[experienceArray objectAtIndex:[txtViewTapped.accessibilityValue integerValue]] valueForKey:@"questions"] replaceObjectAtIndex:5 withObject:newQuesDict];
    
    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kCellIndex_JobRole inSection:[txtViewTapped.accessibilityValue integerValue]]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
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
        NSString *keywordName = [NSString stringWithFormat:@"%@",[[keywordsArray objectAtIndex:i] valueForKey:@"job_role_name"]] ;
        if([keywordName isEqualToString:selectedName]){
            [[keywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
            break ;
        }
    }
    [selectedKeywordsArray removeObjectAtIndex:index] ;
    [selectedJobRoleArray removeObjectAtIndex:index];
    
    NSArray *array = [NSArray arrayWithArray:[[experienceArray objectAtIndex:[txtViewTapped.accessibilityValue integerValue]] valueForKey:@"questions"]] ;
    NSDictionary *oldQuesDict = [array objectAtIndex:5];
    NSMutableDictionary *newQuesDict = [[NSMutableDictionary alloc] init];
    [newQuesDict addEntriesFromDictionary:oldQuesDict];
    
//    NSMutableArray *ansArray = [[NSMutableArray alloc] init];
//    for (NSString *strName in selectedKeywordsArray) {
//        NSMutableDictionary *dicKeywordName = [[NSMutableDictionary alloc] init];
//        [dicKeywordName setValue:strName forKey:@"name"];
//        [ansArray addObject:dicKeywordName];
//    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[oldQuesDict valueForKey:@"answer"]];
    [arr removeAllObjects];
    [arr addObjectsFromArray:selectedJobRoleArray];
    NSLog(@"arr: %@", arr);
    
    [newQuesDict setObject:arr forKey:@"answer"];
    [[[experienceArray objectAtIndex:[txtViewTapped.accessibilityValue integerValue]] valueForKey:@"questions"] replaceObjectAtIndex:5 withObject:newQuesDict];
    
    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kCellIndex_JobRole inSection:[txtViewTapped.accessibilityValue integerValue]]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
}

#pragma mark - DatePicker Value Changed
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentDatePickerTag inSection:[currentSection intValue]];
    UITableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    
    UITextField *activeTextField = (UITextField*)[cell viewWithTag:currentDatePickerTag]; //gets text field what is currently being edited
    [activeTextField setText:[dateFormatter stringFromDate:datePicker.date]];
    
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:[activeTextField.accessibilityIdentifier intValue] inSection:[activeTextField.accessibilityValue intValue]] ;
    
    [[[[experienceArray objectAtIndex:cellIndexPath.section] objectForKey:@"questions"] objectAtIndex:activeTextField.tag] setValue:activeTextField.text forKey:@"answer"] ;
}

#pragma mark - IBAction Methods
- (IBAction)Submit_ClickAction:(id)sender {
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    NSMutableArray *arrExpDetails = [[NSMutableArray alloc] init];

    for (NSDictionary *dict in experienceArray) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        for (NSDictionary *quesDict in [dict valueForKey:@"questions"]) {

            if ([[quesDict valueForKey:@"question"] isEqualToString:kUserExperienceAPI_JobRoleID]) {
                
                if ([[quesDict valueForKey:@"answer"] isKindOfClass:[NSArray class]]) {
                    NSMutableString *strJobRoleIDs = [[NSMutableString alloc] init];
                    
                    for (int  i=0; i<[[quesDict valueForKey:@"answer"] count]; i++) {
                        NSString *strId = [[[quesDict valueForKey:@"answer"] objectAtIndex:i] valueForKey:@"id"];
                        if (i == [[quesDict valueForKey:@"answer"] count]-1) {
                            [strJobRoleIDs appendString:[NSString stringWithFormat:@"%@",strId]];
                            NSLog(@"strIds : %@", strJobRoleIDs);
                        } else {
                            [strJobRoleIDs appendString:[NSString stringWithFormat:@"%@,",strId]];
                            NSLog(@"strIds : %@", strJobRoleIDs);
                        }
                    }
//                    for (NSDictionary *jobRoleDict in [quesDict valueForKey:@"answer"]) {
//                        NSString *strId = [jobRoleDict valueForKey:@"id"];
//                        
//                        [strJobRoleIDs appendString:[NSString stringWithFormat:@"%@, ",strId]];
//                        NSLog(@"strIds : %@", strJobRoleIDs);
//                    }
                    [dic setValue:strJobRoleIDs forKey:[quesDict valueForKey:@"question"]];
                } else 
                    [dic setValue:@"" forKey:[quesDict valueForKey:@"question"]];
            } else
                [dic setValue:[quesDict valueForKey:@"answer"] forKey:[quesDict valueForKey:@"question"]];
        }
        [arrExpDetails addObject:dic];
        [dictParam setObject:arrExpDetails forKey:kAddExperienceAPI_ExperienceDetails] ;
    }
    
    NSLog(@"Params : %@", dictParam);
    if (arrExpDetails.count > 0)
        [self addExperience:arrExpDetails];
}

- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)PlusButton_ClickAction:(UIButton*)button {
    NSMutableDictionary *parentDict = [[NSMutableDictionary alloc] init] ;
    NSMutableArray *arry = [[NSMutableArray alloc] init] ;
    
    for (NSString *key in parametersArray) {
        NSMutableDictionary *childDict = [[NSMutableDictionary alloc] init] ;
        [childDict setValue:key forKey:@"question"] ;
        [childDict setValue:@"" forKey:@"answer"] ;
        [arry addObject:childDict] ;
    }
    [parentDict setValue:arry forKey:@"questions"] ;
    
    [experienceArray addObject:parentDict] ;
    NSLog(@"Experience Array: %@",experienceArray) ;
    
    [tblView reloadData] ;
}

- (IBAction)MinusButton_ClickAction:(UIButton*)button {
    
    NSLog(@"accessibility value: %@, tag: %ld", button.accessibilityValue, button.tag);
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:[button.accessibilityValue intValue] inSection:[button tag]];
    [tblView beginUpdates] ;
    
    if([experienceArray objectAtIndex:cellIndexPath.section]) {
        [experienceArray removeObjectAtIndex:cellIndexPath.section];
        [tblView deleteSections:[NSIndexSet indexSetWithIndex:cellIndexPath.section]
               withRowAnimation:UITableViewRowAnimationFade];
    }
    [tblView endUpdates] ;
}

- (IBAction)DatePickerToolbarButtons_ClickAction:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentDatePickerTag inSection:[currentSection intValue]];
    UITableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    
    UITextField *txtFldDate = (UITextField*)[cell viewWithTag:currentDatePickerTag]; //gets text field what is currently being edited
    [txtFldDate resignFirstResponder] ;
    
    if([sender tag] == DONE_CLICKED) {
        txtFldDate.text = [dateFormatter stringFromDate:datePickerView.date];
    }
    else
        txtFldDate.text = prevDueDate ;
    
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:[txtFldDate.accessibilityIdentifier intValue] inSection:[txtFldDate.accessibilityValue intValue]] ;
    
    [[[[experienceArray objectAtIndex:cellIndexPath.section] objectForKey:@"questions"] objectAtIndex:txtFldDate.tag] setValue:txtFldDate.text forKey:@"answer"] ;
}

- (IBAction)CheckUncheck_ClickAction:(id)sender {
    UIButton *btn = (UIButton*)sender ;
    if([btn.accessibilityLabel isEqualToString:CHECK_IMAGE ]) { // Check
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

#pragma mark - Api Methods
-(void)getJobRoles {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        [ApiCrowdBootstrap getJobRoles:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"response : %@", responseDict);
                [keywordsArray removeAllObjects] ;
                if([responseDict objectForKey:@"job_role_list"]) {
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:@"job_role_list"] mutableCopy]) {
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

-(void)getExperienceList {
    
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]]
 forKey:kJobDetailAPI_UserID] ;
         NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap editExperiencesWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                NSMutableArray *experienceData = [[NSMutableArray alloc] init] ;
                
                if([responseDict objectForKey:kUserExperienceAPI_UserExperienceList])
                    experienceData = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:kUserExperienceAPI_UserExperienceList]] ;
                
                if ([responseDict objectForKey:kUserExperienceAPI_ExperienceID]) {
                    jobExperienceID = [responseDict objectForKey:kUserExperienceAPI_ExperienceID];
                }
                
                // Experience Data
                for (NSMutableDictionary *dict in experienceData) {
                    NSMutableDictionary *parentDict = [[NSMutableDictionary alloc] init] ;
                    NSMutableDictionary *parenExperienceDict = [[NSMutableDictionary alloc] init] ;
                    NSMutableArray *arry = [[NSMutableArray alloc] init] ;
                    for (NSString *key in parametersArray) {
                        NSMutableDictionary *childDict = [[NSMutableDictionary alloc] init] ;
                        [childDict setValue:key forKey:@"question"] ;
                        [childDict setValue:[dict valueForKey:key] forKey:@"answer"] ;
                        [arry addObject:childDict] ;
                    }
                    [parentDict setValue:arry forKey:@"questions"] ;
                    [parenExperienceDict setValue:arry forKey:@"questions"] ;
                    if(!experienceDic) {
                        experienceDic = [NSMutableDictionary dictionaryWithDictionary:parenExperienceDict] ;
                    }
                    [experienceArray addObject:parentDict] ;
                }
                
                NSLog(@"experience: %@", experienceArray);
                
                [tblView reloadData] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}


-(void)addExperience: (NSMutableArray *)arrExpDetails {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kUserExperienceAPI_UserID] ;
        [dictParam setObject:jobExperienceID forKey:kUserExperienceAPI_ExperienceID] ;
        [dictParam setObject:arrExpDetails forKey:kAddExperienceAPI_ExperienceDetails] ;

        NSLog(@"Params : %@", dictParam);
        
        [ApiCrowdBootstrap addExperienceWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                
                [UtilityClass showNotificationMessgae:kAddExperience_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == popupTblView)
        return 1;
    else
        return experienceArray.count+1 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == popupTblView)
        return keywordsArray.count ;
    else {
        if(section == experienceArray.count)
            return 1;
        else
            return parametersArray.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Section : %ld Row: %ld", (long)indexPath.section, (long)indexPath.row);
    if(tableView == popupTblView) {
        PaymentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keywordsCell"] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        cell.companyNameLbl.text = [[keywordsArray objectAtIndex:indexPath.row] valueForKey:@"job_role_name"] ;
        cell.checkboxBtn.tag = indexPath.row ;
        if ([selectedKeywordsArray containsObject:[[keywordsArray objectAtIndex:indexPath.row] valueForKey:@"job_role_name"]]) {
            [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
            cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
            [[keywordsArray objectAtIndex:indexPath.row] setValue:@"1" forKey:@"isSelected"] ;
        } else {
            [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
            cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
            [[keywordsArray objectAtIndex:indexPath.row] setValue:@"0" forKey:@"isSelected"] ;
        }
        /*
        if([[NSString stringWithFormat:@"%@",[[keywordsArray objectAtIndex:indexPath.row] valueForKey:@"isSelected"]] isEqualToString:@"0" ]) { // Check
            [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
            cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
        }
        else { // Uncheck
        
            [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
            cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
        }
         */
        return cell ;
    } else {
        if(indexPath.section == experienceArray.count) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SAVE_BUTTON_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            return cell ;
        }
        else {
            if(indexPath.row == kCellIndex_JobRole) {
                
                 KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KEYWORDS_CELL_IDENTIFIER] ;
                 cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                 cell.backgroundColor = [UIColor colorWithRed:127.0f/255.0f green:153.0f/255.0f blue:178.0f/255.0f alpha:1] ;
                 [UtilityClass setButtonBorder:cell.button] ;
                 cell.tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1] CGColor];
                 cell.tagsScrollView.backgroundColor = [UIColor clearColor] ;
                 cell.tagsScrollView.tag = indexPath.row ;
                 cell.button.tag = indexPath.row ;
                 cell.plusBtn.tag = indexPath.row ;
                 
                 NSArray *array = [NSArray arrayWithArray:[[experienceArray objectAtIndex:indexPath.section] valueForKey:@"questions"]] ;
                NSDictionary *quesDict = [array objectAtIndex:indexPath.row];
                
                 if ([[quesDict objectForKey:@"answer"] isKindOfClass:[NSArray class]]) {
                     selectedJobRoleArray = [[quesDict objectForKey:@"answer"] mutableCopy];
                     selectedKeywordsArray = [self resetTagsArrayWithData:[quesDict objectForKey:@"answer"]] ;
                 } else {
                     selectedKeywordsArray = [[NSMutableArray alloc] init];
                 }
                
                NSMutableArray *tags;
                tags = [selectedKeywordsArray mutableCopy] ;
                 
                 if(tags.count > 0)
                     [cell.button setHidden:YES] ;
                 else
                     [cell.button setHidden:NO] ;
                
                cell.titleLbl.text = [NSString stringWithFormat:@"%@",[fieldsArray objectAtIndex:indexPath.row] ] ;
                cell.tagsScrollView.tagPlaceholder = @"" ;
                [cell.button setTitle:[NSString stringWithFormat:@"No %@ Added",[fieldsArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal] ;
                cell.tagsScrollView.tags = [tags mutableCopy];
                cell.tagsScrollView.tagsDeleteButtonColor = [UIColor whiteColor];
                cell.tagsScrollView.tagsTextColor = [UIColor whiteColor] ;
                cell.tagsScrollView.mode = TLTagsControlModeEdit;
                [cell.tagsScrollView setTapDelegate:self];
                [cell.tagsScrollView setDeleteDelegate:self];

                cell.tagsScrollView.tagsBackgroundColor = [UtilityClass orangeColor];
                [cell.tagsScrollView reloadTagSubviews];
                
                txtViewTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(txtViewTapped_Gesture:)];
                txtViewTapped.accessibilityValue = [NSString stringWithFormat:@"%ld",indexPath.section];
                [cell.tagsScrollView addGestureRecognizer:txtViewTapped];

                 return cell ;
            }
            else {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] ;
                cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                cell.backgroundColor = [UIColor colorWithRed:127.0f/255.0f green:153.0f/255.0f blue:178.0f/255.0f alpha:1];
                int yPos = -10 ;
                
                if (experienceArray.count > 0) {
                    NSArray *array = [NSArray arrayWithArray:[[experienceArray objectAtIndex:indexPath.section] valueForKey:@"questions"]] ;
                    NSDictionary *quesDict = [array objectAtIndex:indexPath.row];
                    
                    // Label
                    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, yPos, cell.frame.size.width, 35)] ;
                    lbl.numberOfLines = 2 ;
                    lbl.textColor = [UIColor colorWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1];
                    lbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0f];
                    lbl.text = [NSString stringWithFormat:@"%@",[fieldsArray objectAtIndex:indexPath.row]] ;
                    yPos = yPos+lbl.frame.size.height ;
                    
                    // TextField
                    UITextField *textFld = [[UITextField alloc] initWithFrame:CGRectMake(10, yPos, cell.frame.size.width, 35)] ;
                    textFld.textColor = [UIColor colorWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1];
                    textFld.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0f];
                    textFld.backgroundColor = [UIColor whiteColor] ;
                    textFld.delegate = self ;
                    textFld.tag = indexPath.row ;
                    
                    if ((indexPath.row == kCellIndex_JobDuties)  || (indexPath.row == kCellIndex_Acheivments)) {
                        if ([[quesDict valueForKey:@"answer"] isKindOfClass:[NSString class]]) {
                            textFld.text = @"";
                        } else { }
                    }
                    else if (indexPath.row == kCellIndex_StartDate) {
                        textFld.inputView = datePickerViewContainer ;
                        if ([[quesDict valueForKey:@"answer"] isEqualToString:@""])
                            textFld.text = startDate;
                        else
                            textFld.text = [quesDict valueForKey:@"answer"];
                    }
                    else if (indexPath.row == kCellIndex_EndDate) {
                        textFld.inputView = datePickerViewContainer ;
                        if ([[quesDict valueForKey:@"answer"] isEqualToString:@""])
                            textFld.text = endDate;
                        else
                            textFld.text = [quesDict valueForKey:@"answer"];
                    } else
                        textFld.text = [quesDict valueForKey:@"answer"];
                    
                    [UtilityClass setTextFieldBorder:textFld] ;
                    [UtilityClass addMarginsOnTextField:textFld] ;
                    
                    yPos = textFld.frame.origin.y+textFld.frame.size.height+10 ;
                    
                    textFld.accessibilityValue = [NSString stringWithFormat:@"%ld",indexPath.section] ;
                    textFld.accessibilityIdentifier = [NSString stringWithFormat:@"%ld",indexPath.row] ;
                    
                    [cell addSubview:lbl] ;
                    [cell addSubview:textFld] ;
                }
                
                // Plus Button
                UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
                plusBtn.frame = CGRectMake(cell.frame.size.width-30, yPos, 20, 20) ;
                [plusBtn setBackgroundImage:[UIImage imageNamed:@"Plus_Icon"] forState:UIControlStateNormal] ;
                plusBtn.tag = indexPath.section ;
                plusBtn.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.section] ;
                [plusBtn addTarget:self action:@selector(PlusButton_ClickAction:) forControlEvents:UIControlEventTouchUpInside] ;
                
                // Minus Button
                UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
                minusBtn.frame = CGRectMake(plusBtn.frame.origin.x-30, yPos, 20, 20) ;
                [minusBtn setBackgroundImage:[UIImage imageNamed:@"Minus_Icon"] forState:UIControlStateNormal] ;
                minusBtn.tag = indexPath.section ;
                minusBtn.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.section] ;
                [minusBtn addTarget:self action:@selector(MinusButton_ClickAction:) forControlEvents:UIControlEventTouchUpInside] ;
                
                [cell addSubview:minusBtn] ;
                [cell addSubview:plusBtn] ;
                
                if (indexPath.row == parametersArray.count-1) {
                    if(experienceArray.count >= 1) {
                        plusBtn.hidden = NO ;
                        minusBtn.hidden = NO ;
                    }
                    else {
                        plusBtn.hidden = NO ;
                    }
                } else {
                    plusBtn.hidden = YES ;
                    minusBtn.hidden = YES ;
                }
                return cell ;
            }
        }
    }
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
        if(indexPath.section == experienceArray.count)
            return 45 ;
        else {
            if (experienceArray.count > 0) {
                if(indexPath.row == kCellIndex_JobRole)
                    return 70;
                else {
                    return 90;
                }
            }
            else return 0;
        }
    }
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
    return NO ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _selectedItem = textField ;
    return YES ;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _selectedItem = nil ;
    currentDatePickerTag = textField.tag;
    currentSection = textField.accessibilityValue;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentDatePickerTag inSection:[currentSection intValue]];
    UITableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    
    UITextField *activeTextField = (UITextField*)[cell viewWithTag:currentDatePickerTag]; //gets text field what is currently being edited
    
    if([textField isEqual:activeTextField])
        prevDueDate = textField.text ;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string] ;
    
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:[textField.accessibilityIdentifier intValue] inSection:[textField.accessibilityValue intValue]] ;
        
    [[[[experienceArray objectAtIndex:cellIndexPath.section] objectForKey:@"questions"] objectAtIndex:textField.tag] setValue:str forKey:@"answer"] ;
    
    return YES ;
}

#pragma mark - keyboard actions
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

-(void)moveToOriginalFrame {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    tblView.contentInset = contentInsets;
    tblView.scrollIndicatorInsets = contentInsets;
}

@end
