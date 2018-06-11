//
//  SubmitApplicationViewController.m
//  CrowdBootstrap
//
//  Created by RICHA on 14/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "SubmitApplicationViewController.h"
#import "SubmitAppTableViewCell.h"


@interface SubmitApplicationViewController ()

@end

@implementation SubmitApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Startup Questionnaire" ;
    
    tblView.estimatedRowHeight = 110 ;
    tblView.rowHeight = UITableViewAutomaticDimension ;
    
    [tblView setNeedsLayout] ;
    [tblView layoutIfNeeded] ;
    
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
-(void)resetUISettings{
    cofoundersArray = [[NSMutableArray alloc] init] ;
    arrayForBool = [[NSMutableArray alloc] init] ;
    /* NSString *plistPath = [[NSBundle mainBundle] pathForResource:kStartupQuestions_plist ofType:@"plist"];
     sectionsArray = [NSMutableArray arrayWithContentsOfFile:plistPath] ;
     
     arrayForBool = [[NSMutableArray alloc] init] ;
     for (int i=0; i<[sectionsArray count]; i++) {
     if(i == 1){
     cofounderDict = [NSMutableDictionary dictionaryWithDictionary:[sectionsArray objectAtIndex:i]] ;
     cofoundersArray = [NSMutableArray arrayWithObject:cofounderDict] ;
     }
     [arrayForBool addObject:[NSNumber numberWithBool:NO]];
     }*/
    
    sectionsArray = [[NSMutableArray alloc] init] ;
    titleArray = @[@"above", @"cofounders", @"below", @"belowA", @"belowB", @"belowC", @"belowD"] ;
    
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [tblView addGestureRecognizer:singleTapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self getQuesApplication] ;
}

#pragma mark - IBAction Methods
- (IBAction)Submit_ClickAction:(id)sender {
    [self SubmitApplicationWithTYpe:[sender tag]] ;
}

- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)PlusButton_ClickAction:(UIButton*)button {
    
    for (NSMutableDictionary *dict in [cofounderDict objectForKey:@"questions"]) {
        [dict setValue:@"" forKey:@"answer"] ;
    }
    [cofoundersArray addObject:cofounderDict] ;
    NSLog(@"cofoundersArray: %@",cofoundersArray) ;
    /*[tblView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cofoundersArray.count-1 inSection:[button tag]]]withRowAnimation:UITableViewRowAnimationAutomatic];
    [tblView endUpdates] ;
    
    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[button.accessibilityValue intValue] inSection:button.tag]] withRowAnimation:UITableViewRowAnimationNone] ;*/
    
    [tblView reloadData] ;
}

- (IBAction)MinusButton_ClickAction:(UIButton*)button {
    
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:[button.accessibilityValue intValue] inSection:[button tag]];
    [tblView beginUpdates] ;
    
    if([cofoundersArray objectAtIndex:cellIndexPath.row]) {
        [cofoundersArray removeObjectAtIndex:cellIndexPath.row];
        [tblView deleteRowsAtIndexPaths:@[cellIndexPath]
                       withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [tblView endUpdates] ;
    
    [tblView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone] ;
}

#pragma mark - API Methods
-(void)getQuesApplication {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:kStartupTeamAPI_StartupID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:@"user_id"] ;
        
         NSLog(@"dictParam %@", dictParam);
        [ApiCrowdBootstrap getStartupApplicationQuesWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                
                // Check application is already submitted or not
                _isApplicationSubmitted = [[responseDict valueForKey:@"is_submited"] integerValue];
                
                if (_isApplicationSubmitted == 0) {
                    lblSubmittedError.hidden = YES;
                    constraintTblVwTopToMainView.priority = UILayoutPriorityDefaultHigh;
                    constraintTblVwTopToLblSubmitted.priority = UILayoutPriorityDefaultLow;
                }
                else if (_isApplicationSubmitted == 1) {
                    lblSubmittedError.hidden = NO;
                    constraintTblVwTopToMainView.priority = UILayoutPriorityDefaultLow;
                    constraintTblVwTopToLblSubmitted.priority = UILayoutPriorityDefaultHigh;
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[responseDict valueForKey:@"questions"]] ;
                NSMutableArray *cofoudnerData = [[NSMutableArray alloc] init] ;
                
                for (NSString *title in titleArray) {
                    NSMutableDictionary *parentDict = [[NSMutableDictionary alloc] init] ;
                    [parentDict setValue:title forKey:@"section"] ;
                    NSMutableArray *arry = [[NSMutableArray alloc] init] ;
                    if([title isEqualToString:@"cofounders"]) {
                        if([[dict objectForKey:title] isKindOfClass:[NSArray class]]) {
                            cofoudnerData = [NSMutableArray arrayWithArray:[dict objectForKey:title]] ;
                        }
                    }
                    else {
                        NSArray *keys = [[dict objectForKey:title] allKeys];
                        keys = [keys sortedArrayUsingComparator:^(id a, id b) {
                            return [a compare:b options:NSNumericSearch];
                        }];
                        
                        NSLog(@"%@",keys);
                        for (NSString *key in keys) {
                            NSMutableDictionary *childDict = [[NSMutableDictionary alloc] init] ;
                            [childDict setValue:key forKey:@"question"] ;
                            [childDict setValue:[[dict objectForKey:title] valueForKey:key] forKey:@"answer"] ;
                            [arry addObject:childDict] ;
                        }
                    }
                    [parentDict setObject:arry forKey:@"questions"] ;
                    [sectionsArray addObject:parentDict] ;
                    
                    /* */
                }
                
                //NSLog(@"questionsArray: %@",sectionsArray) ;
                // Cofounder Data
                for (NSMutableDictionary *dict in cofoudnerData) {
                    NSMutableDictionary *parentDict = [[NSMutableDictionary alloc] init] ;
                    NSMutableDictionary *parenCofounderDict = [[NSMutableDictionary alloc] init] ;
                    NSMutableArray *arry = [[NSMutableArray alloc] init] ;
                    NSMutableArray *coFoudnersArry = [[NSMutableArray alloc] init] ;
                    for (NSString *key in [dict allKeys]) {
                        NSMutableDictionary *childDict = [[NSMutableDictionary alloc] init] ;
                        [childDict setValue:key forKey:@"question"] ;
                        [childDict setValue:[dict valueForKey:key] forKey:@"answer"] ;
                        [arry addObject:childDict] ;
                        
                        // cofounder dict
                        NSMutableDictionary *coDict = [[NSMutableDictionary alloc] init] ;
                        [coDict setValue:key forKey:@"question"] ;
                        [coDict setValue:@"" forKey:@"answer"] ;
                        [coFoudnersArry addObject:childDict] ;
                    }
                    [parentDict setValue:arry forKey:@"questions"] ;
                    [parenCofounderDict setValue:arry forKey:@"questions"] ;
                    if(!cofounderDict){
                        cofounderDict = [NSMutableDictionary dictionaryWithDictionary:parenCofounderDict] ;
                    }
                    [cofoundersArray addObject:parentDict] ;
                }
                
                for (int i=0; i<[sectionsArray count]; i++) {
                    /*if(i == 1){
                     cofounderDict = [NSMutableDictionary dictionaryWithDictionary:[sectionsArray objectAtIndex:i]] ;
                     cofoundersArray = [NSMutableArray arrayWithObject:cofounderDict] ;
                     }*/
                    [arrayForBool addObject:[NSNumber numberWithBool:NO]];
                }
                
                [tblView reloadData] ;
                
            }
            //else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)SubmitApplicationWithTYpe:(BOOL)isSubmitted {
    
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:kStartupTeamAPI_StartupID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",isSubmitted] forKey:@"is_submited"] ;
        [dictParam setObject:[self getQuestionsDict] forKey:@"questions"] ;
        
        NSLog(@"dictParam %@", dictParam);
        
        [ApiCrowdBootstrap submitStartupQuestionaireWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
                [self.navigationController popViewControllerAnimated:YES ] ;
            }
            //else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(NSMutableDictionary*)getQuestionsDict {
    NSMutableDictionary *mainDict = [[NSMutableDictionary alloc] init] ;
    for (NSMutableDictionary *dict in sectionsArray) {
        NSMutableDictionary *parentDict = [[NSMutableDictionary alloc] init] ;
        NSString *title = [NSString stringWithFormat:@"%@",[dict valueForKey:@"section"]] ;
        if(![title isEqualToString:@"cofounders"]){
            NSArray *questionsArray = [NSArray arrayWithArray:[dict objectForKey:@"questions"]] ;
            for (NSDictionary *childDict in questionsArray) {
                [parentDict setValue:[childDict valueForKey:@"answer"] forKey:[childDict valueForKey:@"question"]] ;
            }
            [mainDict setObject:parentDict forKey:title] ;
        }
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init] ;
    for (NSDictionary *dict in cofoundersArray) {
        NSMutableDictionary *parentDict = [[NSMutableDictionary alloc] init] ;
        NSArray *questionsArray = [NSArray arrayWithArray:[dict objectForKey:@"questions"]] ;
        for (NSDictionary *childDict in questionsArray) {
            [parentDict setValue:[childDict valueForKey:@"answer"] forKey:[childDict valueForKey:@"question"]] ;
        }
        [array addObject:parentDict] ;
    }
    [mainDict setObject:array forKey:@"cofounders"] ;
    
    return mainDict ;
}

#pragma mark - Table header gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i = 0; i < [sectionsArray count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [tblView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == sectionsArray.count) return 1 ;
    else {
        /*NSArray *questionsArray = [[sectionsArray objectAtIndex:section] objectForKey:@"questions"] ;
         if(section == 1){
         if ([[arrayForBool objectAtIndex:section] boolValue]) return cofoundersArray.count;
         else return 0 ;
         }
         else return questionsArray.count ;*/
        // if(sectionsArray.count >0){
        NSString *title = [[sectionsArray objectAtIndex:section] valueForKey:@"section"] ;
        if([title isEqualToString:@"cofounders"]) {
            if ([[arrayForBool objectAtIndex:section] boolValue])
                return cofoundersArray.count ;
            else
                return 0 ;
        }
        else {
            NSArray *questionsArray = [[sectionsArray objectAtIndex:section] objectForKey:@"questions"] ;
            return questionsArray.count ;
        }
        // }
        //else return 0 ;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionsArray.count+1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title  ;
    if(sectionsArray.count > 0 && indexPath.section != sectionsArray.count)
        title = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"section"] ;
    else title = @"" ;
    
    if(indexPath.section == sectionsArray.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BUTTON_CELL_IDENTIFIER] ;
        return cell ;
    }
    
    else if([title isEqualToString:@"cofounders"]) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.backgroundColor = [UIColor colorWithRed:127.0f/255.0f green:153.0f/255.0f blue:178.0f/255.0f alpha:1];
        int yPos = 0 ;
        NSArray *array = [NSArray arrayWithArray:[[cofoundersArray objectAtIndex:indexPath.row] valueForKey:@"questions"]] ;
        for (int i = 0; i < array.count; i++) {
            // Label
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, yPos, cell.frame.size.width-20, 30)] ;
            lbl.numberOfLines = 2 ;
            lbl.textColor = [UIColor colorWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1];
            lbl.font = [UIFont systemFontOfSize:11];
            lbl.text = [[array objectAtIndex:i] valueForKey:@"question"];
            yPos = yPos+lbl.frame.size.height ;
            
            // TextField
            UITextField *textFld = [[UITextField alloc] initWithFrame:CGRectMake(10, yPos, cell.frame.size.width-20, 35)] ;
            textFld.textColor = [UIColor colorWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1];
            textFld.font = [UIFont systemFontOfSize:14];
            textFld.backgroundColor = [UIColor whiteColor] ;
            textFld.delegate = self ;
            textFld.text = [[array objectAtIndex:i] valueForKey:@"answer"];
            [UtilityClass setTextFieldBorder:textFld] ;
            [UtilityClass addMarginsOnTextField:textFld] ;
            
            yPos = textFld.frame.origin.y+textFld.frame.size.height+10 ;
            
            textFld.tag = i ;
            textFld.accessibilityValue = [NSString stringWithFormat:@"%ld",indexPath.section] ;
            textFld.accessibilityIdentifier = [NSString stringWithFormat:@"%ld",indexPath.row] ;
            
            [cell addSubview:lbl] ;
            [cell addSubview:textFld] ;
        }
        
        // Minus Button
        UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        minusBtn.frame = CGRectMake(cell.frame.size.width-30, yPos, 20, 20) ;
        [minusBtn setBackgroundImage:[UIImage imageNamed:@"Minus_Icon"] forState:UIControlStateNormal] ;
        minusBtn.tag = indexPath.section ;
        minusBtn.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row] ;
        [minusBtn addTarget:self action:@selector(MinusButton_ClickAction:) forControlEvents:UIControlEventTouchUpInside] ;
        
        // Plus Button
        UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        plusBtn.frame = CGRectMake(cell.frame.size.width-30, yPos, 20, 20) ;
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"Plus_Icon"] forState:UIControlStateNormal] ;
        plusBtn.tag = indexPath.section ;
        minusBtn.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row] ;
        [plusBtn addTarget:self action:@selector(PlusButton_ClickAction:) forControlEvents:UIControlEventTouchUpInside] ;
        
        [cell addSubview:minusBtn] ;
        [cell addSubview:plusBtn] ;
        
        if(cofoundersArray.count == 1) {
            plusBtn.hidden = NO ;
            minusBtn.hidden= YES ;
        }
        else{
            if(indexPath.row == cofoundersArray.count-1) {
                plusBtn.hidden = NO ;
                minusBtn.hidden = YES ;
            }
            else{
                plusBtn.hidden = YES ;
                minusBtn.hidden = NO ;
            }
        }
        
        return cell ;
    }
    else {
        
        SubmitAppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SUBMITAPP_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        NSArray *questionsArray = [[sectionsArray objectAtIndex:indexPath.section] objectForKey:@"questions"] ;
        [cell.sectionLbl sizeToFit] ;
        
        if(indexPath.section%2 == 0) {
            cell.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:214.0f/255.0f blue:224.0f/255.0f alpha:1];
        }
        else cell.backgroundColor = [UIColor colorWithRed:127.0f/255.0f green:153.0f/255.0f blue:178.0f/255.0f alpha:1];
        
        cell.sectionLbl.text = [[questionsArray objectAtIndex:indexPath.row] valueForKey:@"question"] ;
        cell.textFld.text = [[questionsArray objectAtIndex:indexPath.row] valueForKey:@"answer"] ;
        
        [UtilityClass setTextFieldBorder:cell.textFld] ;
        [UtilityClass addMarginsOnTextField:cell.textFld] ;
        cell.textFld.tag = indexPath.row ;
        cell.textFld.accessibilityValue = [NSString stringWithFormat:@"%ld",indexPath.section] ;
        
        return cell ;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 1) return 45 ;
    else return 10 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title  ;
    if(sectionsArray.count > 0 && indexPath.section != sectionsArray.count)
        title = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"section"]  ;
    else title = @"" ;
    
    if(indexPath.section == sectionsArray.count) return 45 ;
    else if([title isEqualToString:@"cofounders"]) {
        NSArray *array = [NSArray arrayWithArray:[[cofoundersArray objectAtIndex:indexPath.row] valueForKey:@"questions"]] ;
        return 77*array.count ;
    }
    else return 80 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title  ;
    if(sectionsArray.count > 0 && section != sectionsArray.count) title = [[sectionsArray objectAtIndex:section] valueForKey:@"section"] ;
    else title = @"" ;
    
    if([title isEqualToString:@"cofounders"]) {
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,45)];
        sectionView.tag = section;
        
        // Background view
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, tableView.frame.size.width,35)];
        bgView.backgroundColor = [UIColor colorWithRed:127.0f/255.0f green:153.0f/255.0f blue:178.0f/255.0f alpha:1];
        
        // Title Label
        UILabel *viewLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, tblView.frame.size.width-20, 35)];
        viewLabel.backgroundColor = [UIColor clearColor];
        viewLabel.textColor = [UIColor colorWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1];
        viewLabel.font = [UIFont systemFontOfSize:14];
        viewLabel.text = @"Who are your Co Founders" ;
        //viewLabel.text=[sectionsArray objectAtIndex:section];
        
        // Expand-Collapse icon
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(tblView.frame.size.width-34,viewLabel.frame.origin.y+viewLabel.frame.size.height/2-7 ,14, 14)];
        if ([[arrayForBool objectAtIndex:section] boolValue]) imgView.image = [UIImage imageNamed:COLLAPSE_SECTION_IMAGE] ;
        else imgView.image = [UIImage imageNamed:EXPAND_SECTION_IMAGE] ;
        
        [sectionView addSubview:bgView] ;
        [sectionView addSubview:viewLabel];
        [sectionView addSubview:imgView];
        
        UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
        [sectionView addGestureRecognizer:headerTapped];
        
        return  sectionView;
    }
    else{
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,10)];
        sectionView.tag = section;
        sectionView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1];
        return sectionView ;
    }
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    return NO ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _selectedItem = textField ;
    return YES ;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _selectedItem = nil ;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string] ;
    // NSString *sectionName = [sectionsArray objectAtIndex:ind]
    if([textField.accessibilityValue intValue] == 1){
        
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:[textField.accessibilityIdentifier intValue] inSection:[textField.accessibilityValue intValue]] ;
        
        [[[[cofoundersArray objectAtIndex:cellIndexPath.row] objectForKey:@"questions"] objectAtIndex:textField.tag] setValue:str forKey:@"answer"] ;
    }
    else {
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:textField.tag inSection:[textField.accessibilityValue intValue]] ;
        
        [[[[sectionsArray objectAtIndex:cellIndexPath.section] objectForKey:@"questions"] objectAtIndex:cellIndexPath.row] setValue:str forKey:@"answer"] ;
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
