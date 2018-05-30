//
//  SuggestKeywordsViewController.m
//  CrowdBootstrap
//
//  Created by Shikha Singla on 11/11/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "SuggestKeywordsViewController.h"
#import "SWRevealViewController.h"
#import "SuggestKeywordsTableViewCell.h"

@interface SuggestKeywordsViewController ()

@end

@implementation SuggestKeywordsViewController

#pragma mark - LifeCycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addObserver];
    [self resetUISettings] ;
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
}

- (void) viewWillAppear:(BOOL)animated {
    // Get Suggest Keywords List
    [self getSuggestKeywordsList];
    
    // Get Suggest Keyword Type List
    [self getSuggestKeywordTypeList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

-(void)resetUISettings {
    
    // Set Borders And Margins to Text Fields
    [UtilityClass setTextFieldBorder:txtFieldKeywordName] ;
    [UtilityClass setTextFieldBorder:txtFieldKeywordType] ;
    
    [UtilityClass addMarginsOnTextField:txtFieldKeywordName] ;
    [UtilityClass addMarginsOnTextField:txtFieldKeywordType] ;
    
    txtFieldKeywordType.inputView = pickerViewContainer ;
    selectedKeywordTypeIndex = -1 ;
    
    // Initialize Array
    keywordsArray = [[NSMutableArray alloc] init] ;
    keywordsTypeArray = [[NSMutableArray alloc] init] ;
}

- (void)resetTextFields {
    txtFieldKeywordName.text = @"";
    txtFieldKeywordType.text = @"";
}

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content {
    self.title = viewTitle ;
}

-(void)navigationBarSettings {
    self.navigationItem.hidesBackButton = YES ;
}

-(void)revealViewSettings {
    menuBarBtn.target = self.revealViewController;
    menuBarBtn.action = @selector(revealToggle:);
    
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - TableView Datasource & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return keywordsArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SuggestKeywordsTableViewCell *cell = (SuggestKeywordsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SuggestKeywords] ;
    
     cell.nameLbl.text = [NSString stringWithFormat:@"%@",[[keywordsArray objectAtIndex:indexPath.row] valueForKey:kSuggestKeywordsAPI_keyword_name]] ;
     cell.typeLbl.text = [NSString stringWithFormat:@"%@",[[keywordsArray objectAtIndex:indexPath.row] valueForKey:kSuggestKeywordsAPI_keyword_type_name]] ;
    NSString *status = [NSString stringWithFormat:@"%@",[[keywordsArray objectAtIndex:indexPath.row] valueForKey:kSuggestKeywordsAPI_keyword_status]];
    if ([status isEqualToString:@"0"]) {
        cell.statusLbl.text = @"Pending" ;
    } else if ([status isEqualToString:@"1"]) {
        cell.statusLbl.text = @"Accepted" ;
    } else {
        cell.statusLbl.text = @"Not Accepted";
    }
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new] ;
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:197.0/255.0f green:4.0/255.0f blue:25.0/255.0f alpha:1] icon:[UIImage imageNamed:FORUM_DELETE_IMAGE]] ;
    
    cell.rightUtilityButtons = rightUtilityButtons ;
    cell.delegate = self ;
    
    cell.selected = YES;
    return cell ;
}

- (BOOL) swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    if (state == kCellStateLeft) {
        return false;
    }
    return true;
}

#pragma mark - --- API Methods ---
#pragma mark Get Suggest Keywords List
-(void)getSuggestKeywordsList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSuggestKeywordsAPI_UserID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getSuggestKeywordListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kSuggestKeywordsAPI_suggest_keyword_list]) {
                    totalItems = [[responseDict valueForKey:kSuggestKeywordsAPI_TotalItems] intValue] ;
                    
                    [keywordsArray removeAllObjects];
                    [keywordsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSuggestKeywordsAPI_suggest_keyword_list]] ;
                    
                    [tblViewSuggestKeywords reloadData] ;
                    if(keywordsArray.count < 1)
                        [tblViewSuggestKeywords setHidden:YES] ;
                    else
                        [tblViewSuggestKeywords setHidden:NO] ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kSuggestKeywordsAPI_suggest_keyword_list]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark Add Suggest Keywords
-(void)addSuggestKeywords {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSuggestKeywordsAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",txtFieldKeywordName.text] forKey:kSuggestKeywordsAPI_keyword_name] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",selectedKeywordTypeID] forKey:kSuggestKeywordsAPI_keyword_type_id] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap addSuggestKeywordsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
                // Refresh the list
                [self getSuggestKeywordsList];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark Delete Suggest Keywords
-(void)deleteSuggestKeywords: (NSString *)keywordID {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSuggestKeywordsAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",keywordID] forKey:kSuggestKeywordsAPI_KeywordID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteSuggestKeywordsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                [UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] ;
                [self getSuggestKeywordsList];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark Get Suggest Keyword Type List
-(void)getSuggestKeywordTypeList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getKeywordTypeListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                if([responseDict valueForKey:kSuggestKeywordsAPI_keyword_type_list]){
                    totalItems = [[responseDict valueForKey:kSuggestKeywordsAPI_TotalItems] intValue] ;
                    
                    [keywordsTypeArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSuggestKeywordsAPI_keyword_type_list]] ;
                    
                    [pickerView reloadAllComponents] ;
                    int index = [UtilityClass getPickerViewSelectedIndexFromArray:keywordsTypeArray forID:selectedKeywordTypeID] ;
                    if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
                    else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - Validation Methods
-(BOOL)validateFieldsWithText:(NSString*)text withMessage:(NSString*)message {
    BOOL isValid = YES ;
    if(text.length < 1 || [text isEqualToString:@" "] || [text isEqualToString:@"\n"]){
        [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"%@%@",message,kAlert_SignUp_BlankField]] animated:YES completion:nil];
        return NO ;
    }
    return isValid ;
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

#pragma mark - SWRevealTableViewCell Delegate Methods
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [tblViewSuggestKeywords indexPathForCell:cell];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@ delete this Keyword ?",kAlert_StartTeam] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [self deleteSuggestKeywords:[[keywordsArray objectAtIndex:cellIndexPath.row] valueForKey:kSuggestKeywordsAPI_KeywordID]] ;
    }];
    UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [tblViewSuggestKeywords reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationRight] ;
    }];
    
    [alertController addAction:yes];
    [alertController addAction:no];
    
    [self presentViewController:alertController animated:YES completion:nil] ;
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _selectedItem = textField ;
    [pickerViewContainer setHidden:YES] ;

    if (textField == txtFieldKeywordType) {
        [pickerViewContainer setHidden:NO] ;
        int index = [UtilityClass getPickerViewSelectedIndexFromArray:keywordsTypeArray forID:selectedKeywordTypeID] ;
        if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
        else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
    }
    return YES ;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
    if([textField isEqual:txtFieldKeywordName])[txtFieldKeywordType becomeFirstResponder] ;
    _selectedItem = nil;
    
    return YES ;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    _selectedItem = nil ;
}

#pragma mark - Picker View Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1 ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return keywordsTypeArray.count+1 ;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if(row == 0)
        return [NSString stringWithFormat:@"Select Keyword Type"] ;
    else
        return [[keywordsTypeArray objectAtIndex:row-1] valueForKey:@"keyword_type_name"] ;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) txtFieldKeywordType.text = @"";
    else txtFieldKeywordType.text = [[keywordsTypeArray objectAtIndex:row-1] valueForKey:@"keyword_type_name"];
}

#pragma mark - IBActions
- (IBAction)PickerToolbarButtons_ClickAction:(id)sender {
    [txtFieldKeywordType resignFirstResponder];

    if([sender tag] == DONE_CLICKED){
        if([pickerView selectedRowInComponent:0] == 0){
            txtFieldKeywordType.text = @""  ;
            selectedKeywordTypeID = @""  ;
            selectedKeywordTypeIndex = -1  ;
        }
        else {
            txtFieldKeywordType.text = [[keywordsTypeArray objectAtIndex:[pickerView selectedRowInComponent:0]-1] valueForKey:@"keyword_type_name"]  ;
            selectedKeywordTypeIndex = (int)[pickerView selectedRowInComponent:0]-1 ;
            selectedKeywordTypeID = [[keywordsTypeArray objectAtIndex:selectedKeywordTypeIndex] valueForKey:@"keyword_type_id"]  ;
        }
    } else {
        if(selectedKeywordTypeIndex != -1)
            txtFieldKeywordType.text = [[keywordsTypeArray objectAtIndex:selectedKeywordTypeIndex] valueForKey:@"keyword_type_name"]  ;
        else txtFieldKeywordType.text = @"" ;
    }
}

- (IBAction)DropdownButton_ClickAction:(id)sender {
    [txtFieldKeywordType becomeFirstResponder] ;
}

- (IBAction)addKeyword_ClickAction:(id)sender {
    if(![self validateFieldsWithText:txtFieldKeywordName.text withMessage:@"Keyword Name"])
        return;
    else if(![self validateFieldsWithText:txtFieldKeywordType.text withMessage:@"Keyword Type"])
        return;
    [self addSuggestKeywords];
}
@end
