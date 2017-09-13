//
//  BasicProfile_ViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 19/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "BasicProfile_ViewController.h"
#import "DescriptionTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "DobTableViewCell.h"
#import "PhoneTableViewCell.h"

@interface BasicProfile_ViewController ()

@end

@implementation BasicProfile_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self resetUISettings] ;
    [self initializeBasicProfileArray] ;
    [self getCountriesList] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationBasicProfile object:nil];
}

- (void)singleTap:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
    [pickerViewContainer setHidden:YES] ;
    [self disablePriceTextField] ;
  /*  if(selectedPickerViewType == PROFILE_COUNTRY_SELECTED){
        DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_COUNTRY_CELL_INDEX inSection:0]] ;
        [cell.textFld resignFirstResponder] ;
       cell.textFld.text = [[basicProfileArray objectAtIndex:BASIC_COUNTRY_CELL_INDEX] valueForKey:@"value"]  ;
    }
    else if(selectedPickerViewType == PROFILE_CITY_SELECTED){
        DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_CITY_CELL_INDEX inSection:0]] ;
        [cell.textFld resignFirstResponder] ;
        cell.textFld.text = [[basicProfileArray objectAtIndex:BASIC_CITY_CELL_INDEX] valueForKey:@"value"]  ;
    }*/
}

#pragma mark - Notifcation Methods
- (void)updateBasicProfileNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationBasicProfile]){
        
       NSLog(@"GetUserType: %d",[UtilityClass GetUserType])  ;
        
        [self initializeBasicProfileArray] ;
        
        NSDictionary *dict = [[[UtilityClass getUserProfileDetails] valueForKey:kProfileAPI_BasicInformation] mutableCopy] ;
        for ( int i=0; i<basicProfileArray.count ; i++ ) {
            NSString *key = [[basicProfileArray objectAtIndex:i] valueForKey:@"key"] ;
            if([dict valueForKey:key]){
                NSString *value = [NSString stringWithFormat:@"%@",[dict valueForKey:key]] ;
                if([value isEqualToString:@""] || [value isEqualToString:@" "]) [[basicProfileArray objectAtIndex:i] setValue:@"" forKey:@"value"] ;
                else [[basicProfileArray objectAtIndex:i] setValue:value forKey:@"value"] ;
            }
        }
        if([dict valueForKey:kBasicProfileAPI_CountryID]) selectedCountryID = [dict valueForKey:kBasicProfileAPI_CountryID] ;
        if([dict valueForKey:kBasicProfileAPI_CityID]) selectedCityID = [dict valueForKey:kBasicProfileAPI_CityID] ;
        //if([dict valueForKey:kBasicProfileAPI_Phone])[self splitPhoneNumner:[dict valueForKey:kBasicProfileAPI_Phone]] ;
        //if([dict valueForKey:kBasicProfileAPI_Phone])[self splitPhoneNumner:@"1(800)555-1212"] ;
        
        [tblView reloadData] ;
    }
}

/*-(void)splitPhoneNumner:(NSString*)phone{
    NSRange range = [phone rangeOfString:@"1("];
    if (range.location != NSNotFound)
    {
        phone = [phone substringFromIndex:2] ;
        NSLog(@"phone: %@",phone) ;
        NSRange range1 = [phone rangeOfString:@")"];
        if (range1.location != NSNotFound){
            NSArray *arr1 = [phone componentsSeparatedByString:@")"] ;
            if(arr1.count > 1){
                phoneValue1 = [NSString stringWithFormat:@"%@",[arr1 objectAtIndex:0]] ;
                NSString *str = [NSString stringWithFormat:@"%@",[arr1 objectAtIndex:1]] ;
                NSRange range2 = [str rangeOfString:@"-"];
                if (range2.location != NSNotFound){
                    NSArray *arr2 = [str componentsSeparatedByString:@"-"] ;
                    if(arr2.count >1){
                        phoneValue2 = [NSString stringWithFormat:@"%@",[arr2 objectAtIndex:0]] ;
                        phoneValue3 = [NSString stringWithFormat:@"%@",[arr2 objectAtIndex:1]] ;
                    }
                }
            }
        }
    }
}*/

- (void)hideKeypadNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationProfileHideKeypad]){
        [self.view endEditing:YES] ;
        [pickerViewContainer setHidden:YES] ;
    }
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    selectedCountryID = @"" ;
    selectedCityID    = @"" ;
    prevDueDate       = @"" ;
    selectedPickerViewType = -1 ;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    [datePickerView setMaximumDate:[NSDate date]] ;
    [datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [pickerViewContainer setHidden:YES] ;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [tblView addGestureRecognizer:singleTapGestureRecognizer];
    
    
    countryArray = [[NSMutableArray alloc] init] ;
    cityArray = [[NSMutableArray alloc] init] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBasicProfileNotification:)
                                                 name:kNotificationBasicProfile
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

-(void)initializeBasicProfileArray{
    
    NSArray *fieldsArray ;
    NSArray *parametersArray ;
    if([UtilityClass GetUserType] == CONTRACTOR){
        fieldsArray = @[@"Bio",@"Name",@"Email",@"Date of Birth",@"Phone Number",@"Country",@"State"] ;
        parametersArray = @[kBasicProfileAPI_Biodata,kBasicProfileAPI_Name,kBasicProfileAPI_Email,kBasicProfileAPI_Dob,kBasicProfileAPI_Phone,kBasicProfileAPI_Country,kBasicProfileAPI_City] ;
    }
    else{
        fieldsArray = @[@"Bio",@"Name",@"Email",@"Date of Birth",@"Phone Number",@"Country",@"State",@"My Interests"] ;
        
        parametersArray = @[kBasicProfileAPI_Biodata,kBasicProfileAPI_Name,kBasicProfileAPI_Email,kBasicProfileAPI_Dob,kBasicProfileAPI_Phone,kBasicProfileAPI_Country,kBasicProfileAPI_City,kBasicProfileAPI_Interest] ;
        
    }
    
    basicProfileArray = [[NSMutableArray alloc] init] ;
    for (int i=0; i<fieldsArray.count ; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
        [dict setValue:[parametersArray objectAtIndex:i] forKey:@"key"] ;
        [dict setValue:@"" forKey:@"value"] ;
        [dict setValue:[fieldsArray objectAtIndex:i] forKey:@"field"] ;
        
        [basicProfileArray addObject:dict] ;
    }
    
    /*// add Country / City ID
    [self addCountryCityIDToBasicDatawithKey:kBasicEditProfileAPI_CountryID] ;
    [self addCountryCityIDToBasicDatawithKey:kBasicEditProfileAPI_CityID] ;*/
    
}
-(void)addCountryCityIDToBasicDatawithKey:(NSString*)key{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
    [dict setValue:key forKey:@"key"] ;
    [dict setValue:@"" forKey:@"value"] ;
    [dict setValue:@"" forKey:@"field"] ;
    [basicProfileArray addObject:dict] ;
}

-(NSString *)getCellTextFieldValueForCellIndex:(int)index{
    if([basicProfileArray objectAtIndex:index]) return [[basicProfileArray objectAtIndex:index] valueForKey:@"value"] ;
    else return @"" ;
}

-(NSString*)getPerHourRate{
    NSString *str = [NSString stringWithFormat:@"%@",[[UtilityClass getUserProfileDetails] valueForKey:kProfileAPI_PerHourRate]] ;
    NSLog(@"str: %@",str) ;
    if([str isEqualToString:@""] || [str isEqualToString:@" "])return @"0.00" ;
    /*else if([str rangeOfString: @"."].location != NSNotFound){
        double Rate_int1 = [str doubleValue];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
        [formatter setMaximumFractionDigits:2];
        
        return [formatter stringFromNumber:[NSNumber numberWithDouble:Rate_int1]];
    }*/
    else return str ;
}

-(NSMutableDictionary*)getBasicProfileUpdatedData{
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBasicEditProfileAPI_UserID] ;
    [dictParam setObject:[self getCellTextFieldValueForCellIndex:BASIC_BIO_CELL_INDEX] forKey:kBasicEditProfileAPI_Bio] ;
    
    // Get First and Last Name
    NSString *fullName = [self getCellTextFieldValueForCellIndex:BASIC_BIO_CELL_INDEX+1] ;
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
    [dictParam setObject:firstName forKey:kBasicEditProfileAPI_FirstName] ;
    [dictParam setObject:lastName forKey:kBasicEditProfileAPI_LastName] ;
    [dictParam setObject:[self getCellTextFieldValueForCellIndex:BASIC_EMAIL_CELL_INDEX] forKey:kBasicEditProfileAPI_Email] ;
    [dictParam setObject:[self getCellTextFieldValueForCellIndex:BASIC_DOB_CELL_INDEX] forKey:kBasicEditProfileAPI_Dob] ;
    NSString *countryID = [NSString stringWithFormat:@"%@",selectedCountryID] ;
    if([countryID isEqualToString:@""] || [countryID isEqualToString:@" "])countryID = @"0" ;
    [dictParam setObject:countryID forKey:kBasicEditProfileAPI_CountryID] ;
    NSString *cityID = [NSString stringWithFormat:@"%@",selectedCityID] ;
    if([cityID isEqualToString:@""] || [cityID isEqualToString:@" "])cityID = @"0" ;
    [dictParam setObject:cityID forKey:kBasicEditProfileAPI_CityID] ;
   
    
    //NSString *phone = [[basicProfileArray objectAtIndex:BASIC_PHONE_CELL_INDEX] valueForKey:@"value"] ;
    PhoneTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_PHONE_CELL_INDEX inSection:0]] ;
    NSString *phone = cell.textField.text ;
    NSLog(@"phone: %d",phone.length) ;
    if(phone.length > 0 && ![phone isEqualToString:@""] && ![phone isEqualToString:@" "] && (phone.length < PHONE_MIN_LENGTH || phone.length > PHONE_MAX_LENGTH )){
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_SignUp_PhoneNotValid] animated:YES completion:nil] ;
        return nil ;
    }
    else [dictParam setObject:phone forKey:kBasicEditProfileAPI_Phone] ;
    
    if([UtilityClass GetUserType] == ENTREPRENEUR)[dictParam setObject:[self getCellTextFieldValueForCellIndex:BASIC_CITY_CELL_INDEX+1] forKey:kBasicEditProfileAPI_Interests]
        ;
    else {
        NSLog(@"getPerHourRate: %@",[self getPerHourRate] );
        [dictParam setObject:[self getPerHourRate] forKey:kBasicEditProfileAPI_Price] ;
    }
   if([UtilityClass getProfileImageChangedStatus]) [dictParam setObject:[[UtilityClass getUserProfileDetails] objectForKey:kProfileAPI_Image] forKey:kBasicEditProfileAPI_Image] ;
    return dictParam ;
}

-(void)disablePriceTextField{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kNotificationProfileDisablePriceTextField
     object:self];
}

-(BOOL)validateNameField{
    NSString *value = [[basicProfileArray objectAtIndex:BASIC_BIO_CELL_INDEX+1] valueForKey:@"value"] ;
    if(value.length < 1 ){
        [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"%@%@",[[basicProfileArray objectAtIndex:BASIC_BIO_CELL_INDEX+1] valueForKey:@"field"],kAlert_SignUp_BlankField]] animated:YES completion:nil];
        return NO ;
    }
    return YES ;
}


#pragma mark - DatePicker Value Changed
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_DOB_CELL_INDEX inSection:0]] ;
    cell.textFld.text = strDate;
}

#pragma mark - IBAction Methods
- (IBAction)Submit_ClickAction:(id)sender {
    [self.view endEditing:YES] ;
    [self disablePriceTextField] ;
    if(![self validateNameField])return ;
    [self updateBasicProfile] ;
}

- (IBAction)Calender_ClickAction:(id)sender {
    DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_DOB_CELL_INDEX inSection:0]] ;
    [datePickerView setDate:[dateFormatter dateFromString:cell.textFld.text] animated:YES] ;
    [cell.textFld becomeFirstResponder] ;
}

- (IBAction)DropdownButton_ClickAction:(id)sender {
    [pickerViewContainer setHidden:NO] ;
    
    if([sender tag] == BASIC_COUNTRY_CELL_INDEX) {
        
        DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_COUNTRY_CELL_INDEX inSection:0]] ;
        [cell.textFld becomeFirstResponder] ;
        selectedPickerViewType = PROFILE_COUNTRY_SELECTED ;
        int index = [UtilityClass getPickerViewSelectedIndexFromArray:countryArray forID:selectedCountryID] ;
        if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
        else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
    }
    else{
        
        NSString *countryID = [NSString stringWithFormat:@"%@",selectedCountryID] ;
        NSLog(@"countryID: %@",countryID) ;
        if( [countryID isEqualToString:@""] || [countryID isEqualToString:@"0"]){
            [self presentViewController:[UtilityClass displayAlertMessage:kSelectCountryDefaultText] animated:YES completion:nil] ;
        }
        else{
            if([selectedCountryID intValue]){
                [self getCitisListWithCountryID:[selectedCountryID intValue]] ;
                
                selectedPickerViewType = PROFILE_CITY_SELECTED ;
                int index = [UtilityClass getPickerViewSelectedIndexFromArray:cityArray forID:selectedCityID] ;
                if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
                else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
                [pickerView reloadAllComponents] ;
                [pickerViewContainer setHidden:NO] ;
            }
        }
    }
    
    [pickerView reloadAllComponents] ;
}

#pragma mark - ToolBar Buttons Methods
- (IBAction)NumberTooBarButtons_ClickAction:(id)sender {
    PhoneTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_PHONE_CELL_INDEX inSection:0]] ;
     [cell.textField resignFirstResponder] ;
    if([sender tag] == DONE_CLICKED) {
        [[basicProfileArray objectAtIndex:BASIC_PHONE_CELL_INDEX] setValue:cell.textField.text forKey:@"value"] ;
    }
}

- (IBAction)DatePickerToolbarButtons_ClickAction:(id)sender {
    DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_DOB_CELL_INDEX inSection:0]] ;
    [cell.textFld resignFirstResponder] ;
    
    if([sender tag] == DONE_CLICKED) {
        prevDueDate = [[basicProfileArray objectAtIndex:BASIC_DOB_CELL_INDEX] valueForKey:@"value"] ;
        [[basicProfileArray objectAtIndex:BASIC_DOB_CELL_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
    }
    
    else{
        cell.textFld.text = [[basicProfileArray objectAtIndex:BASIC_DOB_CELL_INDEX] valueForKey:@"value"] ;
    }
    
    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:BASIC_DOB_CELL_INDEX inSection:0]] withRowAnimation:UITableViewRowAnimationNone] ;
}

- (IBAction)PickerToolbarButtons_ClickAction:(id)sender {
    
    [pickerViewContainer setHidden:YES] ;
    if([sender tag] == DONE_CLICKED){
       
        if(selectedPickerViewType == PROFILE_COUNTRY_SELECTED) {
            DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_COUNTRY_CELL_INDEX inSection:0]] ;
            [cell.textFld resignFirstResponder] ;
            
            if([pickerView selectedRowInComponent:0] == 0){
                cell.textFld.text = @"" ;
                selectedCountryID = @"" ;
                
                [[basicProfileArray objectAtIndex:BASIC_COUNTRY_CELL_INDEX] setValue:@"" forKey:@"value"] ;
            }
            
            else {
                cell.textFld.text = [[countryArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] ;
                selectedCountryID = [[countryArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"id"]  ;
                
                [[basicProfileArray objectAtIndex:BASIC_COUNTRY_CELL_INDEX] setValue:[[countryArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] forKey:@"value"] ;
            }
            
            DobTableViewCell *cityCell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_CITY_CELL_INDEX inSection:0]] ;
            cityCell.textFld.text = @"" ;
            selectedCityID = @"" ;
            
            [[basicProfileArray objectAtIndex:BASIC_CITY_CELL_INDEX] setValue:@"" forKey:@"value"] ;
            [[basicProfileArray objectAtIndex:BASIC_CITY_CELL_INDEX] setValue:@"" forKey:@"id"] ;
        }
        
        else{
            DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_CITY_CELL_INDEX inSection:0]] ;
            [cell.textFld resignFirstResponder] ;
            
            if([pickerView selectedRowInComponent:0] == 0){
                cell.textFld.text = @"" ;
                selectedCityID = @"" ;
                
                [[basicProfileArray objectAtIndex:BASIC_CITY_CELL_INDEX] setValue:@"" forKey:@"value"] ;
                [[basicProfileArray objectAtIndex:BASIC_CITY_CELL_INDEX] setValue:@"" forKey:@"id"] ;
            }
            
            else{
                cell.textFld.text = [[cityArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] ;
                selectedCityID = [[cityArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"id"];
                
                [[basicProfileArray objectAtIndex:BASIC_CITY_CELL_INDEX] setValue:[[cityArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] forKey:@"value"] ;
            }
        }
    }
    else{
        
        if(selectedPickerViewType == PROFILE_COUNTRY_SELECTED){
            DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_COUNTRY_CELL_INDEX inSection:0]] ;
            [cell.textFld resignFirstResponder] ;
            if([pickerView selectedRowInComponent:0] == 0)cell.textFld.text = @"" ;
            else cell.textFld.text = [[basicProfileArray objectAtIndex:BASIC_COUNTRY_CELL_INDEX] valueForKey:@"value"]  ;
        }
        
        else{
            DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_CITY_CELL_INDEX inSection:0]] ;
            [cell.textFld resignFirstResponder] ;
            if([pickerView selectedRowInComponent:0] == 0)cell.textFld.text = @"" ;
            else cell.textFld.text = [[basicProfileArray objectAtIndex:BASIC_CITY_CELL_INDEX] valueForKey:@"value"]  ;
        }
    }
    selectedPickerViewType = -1 ;
    [pickerView reloadAllComponents] ;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return basicProfileArray.count+1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == BASIC_BIO_CELL_INDEX){
        DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BASIC_BIO_CELL_IDENTIFIER] ;
        cell.descriptionTxtView.tag = indexPath.row ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.fieldNameLbl.text = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"]] ;
        [UtilityClass setTextViewBorder:cell.descriptionTxtView] ;
        
        NSString *bioText = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"value"]] ;
        
        if(bioText.length < 1 || [bioText isEqualToString:@""] || [bioText isEqualToString:@" "]){
            cell.descriptionTxtView.textColor = [UIColor lightGrayColor] ;
            cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"]] ;
        }
        else{
            cell.descriptionTxtView.textColor = [UtilityClass textColor] ;
            cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"value"]] ;
        }
        return cell ;
    }
    else if(indexPath.row == BASIC_DOB_CELL_INDEX){
        DobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BASIC_DOB_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.fieldNameLbl.text = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"]] ;
        cell.textFld.tag = indexPath.row ;
        cell.dropdownBtn.tag = indexPath.row ;
        [UtilityClass setTextFieldBorder:cell.textFld] ;
        [UtilityClass addMarginsOnTextField:cell.textFld] ;
        cell.textFld.inputView = datePickerViewContainer ;
        
        NSString *value = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"value"]];
        if(![value isEqualToString:@""] && ![value isEqualToString:@" "])cell.textFld.text = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"value"]]  ;
        else cell.textFld.text = @""  ;
        
        return cell ;
    }
    else if(indexPath.row == BASIC_COUNTRY_CELL_INDEX || indexPath.row == BASIC_CITY_CELL_INDEX){
        DobTableViewCell *cell = (DobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:BASIC_COUNTRY_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.fieldNameLbl.text = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"]] ;
        [UtilityClass setTextFieldBorder:cell.textFld] ;
        [UtilityClass addMarginsOnTextField:cell.textFld] ;
        //cell.textFld.inputView = pickerViewContainer ;
        cell.textFld.tag = indexPath.row ;
        cell.dropdownBtn.tag = indexPath.row ;
        cell.textFld.userInteractionEnabled = NO ;
        
        cell.textFld.placeholder = [NSString stringWithFormat:@"Select %@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"]] ;
        
        NSString *value = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"value"]];
        if(![value isEqualToString:@""] && ![value isEqualToString:@" "])cell.textFld.text = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"value"]]  ;
        else cell.textFld.text = @""  ;
        
        return cell ;
    }
    else if(indexPath.row == basicProfileArray.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BASIC_SUBMIT_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
    }
    else if(indexPath.row == BASIC_PHONE_CELL_INDEX){
        PhoneTableViewCell *cell = (PhoneTableViewCell*)[tableView dequeueReusableCellWithIdentifier:BASIC_PHONE_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.fieldNameLbl.text = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"]] ;
        [UtilityClass setTextFieldBorder:cell.textField] ;
        [UtilityClass addMarginsOnTextField:cell.textField] ;
        
        cell.textField.keyboardType = UIKeyboardTypeNumberPad ;
        cell.textField.inputAccessoryView = numberToolbar ;
        cell.textField.tag = indexPath.row ;
        [cell.textField.formatter setDefaultOutputPattern:@"1 (###) ###-####"];
        cell.textField.text = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"value"]]  ;
        
       
        //[cell.textField.formatter addOutputPattern:@"+# (###) ###-####" forRegExp:@"^1\\d*$" imagePath:@"SHSPhoneImage.bundle/flag_ru"];
        //[cell.textField.formatter addOutputPattern:@"+# (###) ###-####" forRegExp:@"^2\\d*$" imagePath:@"SHSPhoneImage.bundle/flag_ua"];
        
        return cell ;
    }
    else{
        TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BASIC_TEXTFIELD_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.fieldNameLbl.text = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"]] ;
        
        cell.textFld.tag = indexPath.row ;
        [UtilityClass setTextFieldBorder:cell.textFld] ;
        [UtilityClass addMarginsOnTextField:cell.textFld] ;
        
        cell.textFld.placeholder = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"field"]] ;
        
        NSString *value = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"value"]];
        if(![value isEqualToString:@""] && ![value isEqualToString:@" "])cell.textFld.text = [NSString stringWithFormat:@"%@",[[basicProfileArray objectAtIndex:indexPath.row] valueForKey:@"value"]]  ;
        else cell.textFld.text = @""  ;
         cell.textFld.userInteractionEnabled = YES ;
        
        if(indexPath.row == BASIC_EMAIL_CELL_INDEX){
            cell.textFld.keyboardType = UIKeyboardTypeEmailAddress ;
            cell.textFld.userInteractionEnabled = NO ;
        }
        else if(indexPath.row == BASIC_PHONE_CELL_INDEX){
            cell.textFld.keyboardType = UIKeyboardTypeNumberPad ;
            cell.textFld.inputAccessoryView = numberToolbar ;
         }
        
        if(indexPath.row == basicProfileArray.count-1) cell.textFld.returnKeyType = UIReturnKeyDone ;
        else cell.textFld.returnKeyType = UIReturnKeyNext ;
           
        return cell ;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == BASIC_BIO_CELL_INDEX) return 130 ;
    else if(indexPath.row == basicProfileArray.count) return 45 ;
    else return 75 ;
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [pickerViewContainer setHidden:YES] ;
    [self disablePriceTextField] ;
    if(selectedPickerViewType == PROFILE_COUNTRY_SELECTED){
        DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_COUNTRY_CELL_INDEX inSection:0]] ;
        [cell.textFld resignFirstResponder] ;
        cell.textFld.text = [[basicProfileArray objectAtIndex:BASIC_COUNTRY_CELL_INDEX] valueForKey:@"value"]  ;
    }
    else if(selectedPickerViewType == PROFILE_CITY_SELECTED){
        DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_CITY_CELL_INDEX inSection:0]] ;
        [cell.textFld resignFirstResponder] ;
        cell.textFld.text = [[basicProfileArray objectAtIndex:BASIC_CITY_CELL_INDEX] valueForKey:@"value"]  ;
    }
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
   
    if([textField tag] == BASIC_EMAIL_CELL_INDEX -1){
       PhoneTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_PHONE_CELL_INDEX inSection:0]] ;
        [cell.textField becomeFirstResponder] ;
    }
    else if([textField tag] == BASIC_PHONE_CELL_INDEX && [UtilityClass GetUserType] == ENTREPRENEUR){
        TextFieldTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:basicProfileArray.count-1 inSection:0]] ;
        [cell.textFld becomeFirstResponder] ;
    }
    return YES ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _selectedItem = textField ;
     [pickerViewContainer setHidden:YES] ;
    if(textField.tag == BASIC_DOB_CELL_INDEX){
         DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_DOB_CELL_INDEX inSection:0]] ;
        [datePickerView setDate:[dateFormatter dateFromString:cell.textFld.text] animated:YES] ;
    }
    if(textField.tag == BASIC_COUNTRY_CELL_INDEX){
        selectedPickerViewType = PROFILE_COUNTRY_SELECTED ;
        int index = [UtilityClass getPickerViewSelectedIndexFromArray:countryArray forID:selectedCountryID] ;
        if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
        else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
    }
    else if(textField.tag == BASIC_CITY_CELL_INDEX) {
        NSString *countryID = [NSString stringWithFormat:@"%@",selectedCountryID] ;
        if( [countryID isEqualToString:@""] || [countryID isEqualToString:@"0"]){
            [self presentViewController:[UtilityClass displayAlertMessage:kSelectCountryDefaultText] animated:YES completion:nil] ;
            [textField resignFirstResponder] ;
            return NO ;
        }
        else{
            [self getCitisListWithCountryID:[selectedCountryID intValue]] ;
            selectedPickerViewType = PROFILE_CITY_SELECTED ;
            int index = [UtilityClass getPickerViewSelectedIndexFromArray:cityArray forID:selectedCityID] ;
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
   if([textField tag] != BASIC_PHONE_CELL_INDEX) [[basicProfileArray objectAtIndex:textField.tag] setValue:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"value"] ;
    
    // Phone Validation
    if([textField tag] == BASIC_PHONE_CELL_INDEX){
        
       /* NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= 10 || returnKey;*/
        
    }
    
    return YES ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [[basicProfileArray objectAtIndex:textView.tag] setValue:[textView.text stringByReplacingCharactersInRange:range withString:text] forKey:@"value"] ;
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        TextFieldTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_BIO_CELL_INDEX+1 inSection:0]] ;
        [cell.textFld becomeFirstResponder] ;
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
 
    if([textView.text isEqualToString:@"Bio"] && textView.textColor == [UIColor lightGrayColor]){
        textView.text = @"" ;
        textView.textColor = [UtilityClass textColor] ;
    }
    _selectedItem = nil ;
    
    CGPoint pointInTable = [textView.superview convertPoint:textView.frame.origin toView:tblView];
    CGPoint contentOffset = tblView.contentOffset;
    
    contentOffset.y = (pointInTable.y - textView.inputAccessoryView.frame.size.height);
    
    [tblView setContentOffset:contentOffset animated:YES];
    
    return YES ;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    
    if([textView.text isEqualToString:@""]){
        textView.text = @"Bio" ;
        textView.textColor = [UIColor lightGrayColor] ;
    }
    
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
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1 ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(selectedPickerViewType == PROFILE_COUNTRY_SELECTED)return countryArray.count+1 ;
    else return cityArray.count+1 ;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if(selectedPickerViewType == PROFILE_COUNTRY_SELECTED){
         if(row == 0) return [NSString stringWithFormat:@"Select %@",[[basicProfileArray objectAtIndex:BASIC_COUNTRY_CELL_INDEX] valueForKey:@"field"]] ;
        else return [[countryArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    else {
        if(row == 0) return [NSString stringWithFormat:@"Select %@",[[basicProfileArray objectAtIndex:BASIC_CITY_CELL_INDEX] valueForKey:@"field"]] ;
        else return [[cityArray objectAtIndex:row-1] valueForKey:@"name"];
    }
}

/*-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
   
    if(selectedPickerViewType == PROFILE_COUNTRY_SELECTED){
        DobTableViewCell *cell = (DobTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_COUNTRY_CELL_INDEX inSection:0]] ;
        if(row == 0) cell.textFld.text = @"" ;
        else cell.textFld.text = [[countryArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    else {
        DobTableViewCell *cell = (DobTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_CITY_CELL_INDEX inSection:0]] ;
        if(row == 0) cell.textFld.text = @"" ;
        else cell.textFld.text = [[cityArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
}*/

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
-(void)getCountriesList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [ApiCrowdBootstrap getCountries:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                countryArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:@"country"]] ;
                for (int i=0; i<countryArray.count; i++) {
                    
                    if([[[countryArray objectAtIndex:i] valueForKey:@"id"] intValue] == US_COUNTRY_ID) {
                        DobTableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BASIC_COUNTRY_CELL_INDEX inSection:0]] ;
                        cell.textFld.text = [[countryArray objectAtIndex:i] valueForKey:@"name"] ;
                        selectedCountryID = [[countryArray objectAtIndex:i] valueForKey:@"id"]  ;
                        
                        [[basicProfileArray objectAtIndex:BASIC_COUNTRY_CELL_INDEX] setValue:[[countryArray objectAtIndex:i] valueForKey:@"name"] forKey:@"value"] ;
                    }
                }
            }
            else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
            
        }] ;
    }
}

-(void)getCitisListWithCountryID:(int)countryID{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",countryID] forKey:kCitiesAPI_CountryID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getCitiesWithParameters:dictParam success:^(NSDictionary *responseDict) {
            NSLog(@"responseDictL %@",responseDict) ;
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                cityArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:@"state"]] ;
                NSLog(@"cityArrayL %@",cityArray) ;
                [pickerView reloadAllComponents] ;
                int index = [UtilityClass getPickerViewSelectedIndexFromArray:cityArray forID:selectedCityID] ;
                if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
                else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
            }
            else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)updateBasicProfile{
    if([UtilityClass checkInternetConnection]){
        
        NSMutableDictionary *dictParam = [self getBasicProfileUpdatedData] ;
        NSLog(@"dictParam: %@",dictParam) ;
        if(dictParam == nil) return ;
        [UtilityClass showHudWithTitle:kHUDMessage_UpdateProfile] ;
        [ApiCrowdBootstrap updateProfileWithType:PROFILE_BASIC_SELECTED forUserType:(int)[UtilityClass GetUserType] withParameters:dictParam success:^(NSDictionary *responseDict) {
            NSLog(@"responseDict %@", responseDict);
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
               // [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                [UtilityClass showNotificationMessgae:kAlert_ProfileUpdate withResultType:@"1" withDuration:1] ;
                
                NSMutableDictionary *profileDict = [[UtilityClass getUserProfileDetails] mutableCopy] ;
                [profileDict setObject:[responseDict objectForKey:kProfileAPI_Complete] forKey:kProfileAPI_Complete] ;
                NSString *fullName = [NSString stringWithFormat:@"%@ %@",[dictParam objectForKey:kBasicEditProfileAPI_FirstName],[dictParam objectForKey:kBasicEditProfileAPI_LastName] ] ;
                [profileDict setObject:fullName forKey:kProfileAPI_Name] ;
                [UtilityClass setUserProfileDetails:profileDict] ;
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kNotificationProfileCompletionUpdate
                 object:self];
            }
            else{
                
                // [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
