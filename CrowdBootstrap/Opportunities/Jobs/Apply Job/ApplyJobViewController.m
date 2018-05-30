//
//  ApplyJobViewController.m
//  CrowdBootstrap
//
//  Created by osx on 28/12/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "ApplyJobViewController.h"
#import "TextFieldTableViewCell.h"
#import "DescriptionTableViewCell.h"
#import "SearchContractorTableViewCell.h"
#import "KLCPopup.h"
#import "KeywordsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommitTableViewCell.h"
#import "PaymentsTableViewCell.h"

@interface ApplyJobViewController ()

@end

@implementation ApplyJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetUISettings] ;
    [self resetNavigationBarsettings];
}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self getExperienceList];
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil] ;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}

-(void)resetNavigationBarsettings {
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back_Icon"] style:UIBarButtonItemStylePlain target:self action:@selector(BackButton_ClickAction)] ;
    self.navigationItem.leftBarButtonItem = backButton ;
}

-(void)resetUISettings {
    
    jobDetails = [[UtilityClass getJobDetails] mutableCopy];
    NSLog(@"Job Data: %@",jobDetails) ;
    self.title = @"Apply for Job";
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [tblView addGestureRecognizer:singleTapGestureRecognizer];
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    constraintTblViewTop.constant = -20;
    [self initializeSectionArray] ;
}

-(void)initializeSectionArray {
    
    sectionsArray         = [[NSMutableArray alloc] init] ;
    experienceListArray   = [[NSMutableArray alloc] init] ;
    
    NSArray *fieldsArray = @[@"Job Title",@"Posted By",@"Description",@"Cover Letter",@"Experience"] ;
    NSArray *parametersArray = @[kApplyJob_JobTitle, kApplyJob_PostedBy, kApplyJob_Summary, kApplyJob_CoverLetter, kApplyJob_Experience] ;
    
    for (int i = 0; i < fieldsArray.count ; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
        if (i == 0) {
            [dict setValue:[parametersArray objectAtIndex:i] forKey:@"key"] ;
            [dict setValue:[NSString stringWithFormat:@"%@",[jobDetails valueForKey:kJobDetailAPI_JobTitle]] forKey:@"value"] ;
            [dict setValue:[fieldsArray objectAtIndex:i] forKey:@"field"] ;
        } else if (i == 1) {
            [dict setValue:[parametersArray objectAtIndex:i] forKey:@"key"] ;
            [dict setValue:[NSString stringWithFormat:@"%@",[jobDetails valueForKey:kJobDetailAPI_PostedBy]] forKey:@"value"] ;
            [dict setValue:[fieldsArray objectAtIndex:i] forKey:@"field"] ;
        } else {
            [dict setValue:[parametersArray objectAtIndex:i] forKey:@"key"] ;
            [dict setValue:@"" forKey:@"value"] ;
            [dict setValue:[fieldsArray objectAtIndex:i] forKey:@"field"] ;
        }
        
        [sectionsArray addObject:dict] ;
    }
    
    arrayForBool = [[NSMutableArray alloc] init] ;
    for (int i = 0; i < [sectionsArray count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    
    [tblView reloadData] ;
}

#pragma mark - IBAction Methods
-(void)BackButton_ClickAction {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)addExperience_ClickAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kAddExperienceIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)Submit_ClickAction:(id)sender {
    
    if(![self validatetextFieldsWithSectionIndex:kCellIndex_JobDesc]) return ;
    else if(![self validatetextFieldsWithSectionIndex:kCellIndex_JobCoverLetter]) return ;
    else
        [self applyJob] ;
}

#pragma mark - Validation Methods
-(BOOL)validatetextFieldsWithSectionIndex:(int)index {
    /*
    if(value.length < 10) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_Validation_Startup_Description] animated:YES completion:nil];
        return NO ;
    }
     */
    NSString *value = [[sectionsArray objectAtIndex:index] valueForKey:@"value"] ;
    if(value.length < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"%@ %@",[[sectionsArray objectAtIndex:index] valueForKey:@"field"],kAlert_SignUp_BlankField]] animated:YES completion:nil];
        return NO ;
    }
    
    return YES ;
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
        [tblView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == tblView) {
        if(section == kCellIndex_JobExperience) {
            if ([[arrayForBool objectAtIndex:section] boolValue])
                return experienceListArray.count ;
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
        return sectionsArray.count+2;
    }
    else return 1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Section: %ld", (long)indexPath.section);
    if(tableView == tblView) {
        if(indexPath.section == kCellIndex_JobDesc || indexPath.section == kCellIndex_JobCoverLetter) {
            DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DESCRIPTION_CELL_IDENTIFIER] ;
            
            [UtilityClass setTextViewBorder:cell.descriptionTxtView] ;
            [UtilityClass addMarginsOnTextView:cell.descriptionTxtView] ;
            cell.fieldNameLbl.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone ;
            cell.descriptionTxtView.tag = indexPath.section ;
            cell.descriptionTxtView.returnKeyType = UIReturnKeyNext ;
            return cell ;
        } else if(indexPath.section == kCellIndex_JobExperience) {
            SearchContractorTableViewCell *cell = (SearchContractorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Experience] ;
            cell.nameLbl.text = [NSString stringWithFormat:@"%@",[[experienceListArray objectAtIndex:indexPath.row] valueForKey:kUserExperienceAPI_JobTitle]] ;
            cell.rateLbl.text = [NSString stringWithFormat:@"%@",[[experienceListArray objectAtIndex:indexPath.row] valueForKey:kUserExperienceAPI_StartDate]]  ;
            cell.skillLbl.text = [NSString stringWithFormat:@"%@",[[experienceListArray objectAtIndex:indexPath.row] valueForKey:kUserExperienceAPI_CompanyName]]  ;
            cell.followerBtn.hidden = YES;
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[experienceListArray objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Company_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            cell.imgView.layer.cornerRadius = 17.5;
            cell.imgView.clipsToBounds = YES;
            
            return cell ;
        } else if(indexPath.section == kCellIndex_AddExperience) {
            CommitTableViewCell *cell = (CommitTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AddExperience] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            return cell ;
        } else if(indexPath.section == kCellIndex_JobSubmit) {
            CommitTableViewCell *cell = (CommitTableViewCell*)[tableView dequeueReusableCellWithIdentifier:SUBMIT_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            return cell ;
        }
        else {
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TEXTFIELD__CELL_IDENTIFIER] ;
            [UtilityClass setTextFieldBorder:cell.textFld] ;
            [UtilityClass addMarginsOnTextField:cell.textFld] ;
            cell.fieldNameLbl.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            cell.fieldNameLbl.hidden = false;
            if (indexPath.section == kCellIndex_JobTitle) {
                cell.textFld.enabled = false;
            }
            cell.textFld.placeholder = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] ;
            cell.textFld.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone ;
            cell.textFld.tag = indexPath.section ;
            cell.textFld.delegate = self ;
            
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
        else { // Uncheck
            
            [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
            cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
        }
        return cell ;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == tblView) {
        if(indexPath.section == kCellIndex_JobDesc || indexPath.section == kCellIndex_JobCoverLetter) return 120 ;
        else if(indexPath.section == kCellIndex_JobExperience)
            return 100 ;
        else if(indexPath.section == kCellIndex_AddExperience || indexPath.section == kCellIndex_JobSubmit)
            return 45 ;
        else
            return 75 ;
    }
    else {
        return 50 ;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(tableView == tblView) {
        if(section == kCellIndex_JobExperience)
            return 45;
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
        //if(section == ROADMAP_SECTION_INDEX){
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
        if ([[arrayForBool objectAtIndex:section] boolValue])
            imgView.image = [UIImage imageNamed:COLLAPSE_SECTION_IMAGE] ;
        else
            imgView.image = [UIImage imageNamed:EXPAND_SECTION_IMAGE] ;
        
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // if you have index/header text in your tableview change your index text color
    if(tblView == popupTblView) {
        UITableViewHeaderFooterView *headerIndexText = (UITableViewHeaderFooterView *)view;
        [headerIndexText.textLabel setTextColor:[UtilityClass blueColor]];
    }
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
    
    if (textField.tag == kCellIndex_JobPostedBy) {
        DescriptionTableViewCell *cell =  [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kCellIndex_JobDesc]] ;
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

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder] ;
    _selectedItem = nil ;
    return YES;
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
        if(textView.tag == kCellIndex_JobDesc) {
            DescriptionTableViewCell *cell =  [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kCellIndex_JobCoverLetter]] ;
            [cell.descriptionTxtView becomeFirstResponder] ;
            return NO ;
        }
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _selectedItem = nil ;
    
    CGPoint pointInTable = [textView.superview convertPoint:textView.frame.origin toView:tblView];
    CGPoint contentOffset = tblView.contentOffset;
    
    contentOffset.y = (pointInTable.y - textView.inputAccessoryView.frame.size.height);
    
    [tblView setContentOffset:contentOffset animated:YES];
    return YES ;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
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

-(void)moveToOriginalFrame {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    tblView.contentInset = contentInsets;
    tblView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - API Methods
-(void)getExperienceList {
    
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kJobDetailAPI_UserID] ;
         NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getExperienceListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                
                if([responseDict objectForKey:kUserExperienceAPI_UserExperienceList])
                    experienceListArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:kUserExperienceAPI_UserExperienceList]] ;
                
                if([responseDict objectForKey:kUserExperienceAPI_ExperienceID])
                    jobExperienceId = [NSString stringWithFormat:@"%@", [responseDict objectForKey:kUserExperienceAPI_ExperienceID]] ;
                
                [tblView reloadData] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)applyJob {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kJobDetailAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[jobDetails valueForKey:kApplyJob_JobID]] forKey:kApplyJob_JobID] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:kCellIndex_JobTitle] valueForKey:@"value"] forKey:kApplyJob_Name] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:kCellIndex_JobDesc] valueForKey:@"value"] forKey:kApplyJob_Summary] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:kCellIndex_JobCoverLetter] valueForKey:@"value"] forKey:kApplyJob_CoverLetterText] ;
        if (jobExperienceId != nil)
            [dictParam setObject:jobExperienceId forKey:kApplyJob_JobExperienceID] ;
        else
            [dictParam setObject:@"" forKey:kApplyJob_JobExperienceID] ;

//        NSArray *arrDoc = [[NSArray alloc] init];
//        [dictParam setObject:arrDoc forKey:kApplyJob_CoverLetterDoc];
//
//        NSArray *arrResume = [[NSArray alloc] init];
//        [dictParam setObject:arrResume forKey:kApplyJob_Resume];
        NSLog(@"Params : %@", dictParam);

        [ApiCrowdBootstrap applyJobWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {

                [UtilityClass showNotificationMessgae:kApplyJob_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode )
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}
 
@end
