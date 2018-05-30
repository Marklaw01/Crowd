//
//  JobListViewController.m
//  CrowdBootstrap
//
//  Created by osx on 23/12/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "JobListViewController.h"
#import "SWRevealViewController.h"
#import "SearchContractorTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface JobListViewController ()

@end

@implementation JobListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [self addObserver];
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [self resetUISettings] ;
    [self initializeBasicArray];
    
    // Hit Service to get Countries List
    [self getCountriesList] ;
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

- (void)singleTap:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
    [pickerViewContainer setHidden:YES] ;
    [jobSearchController.searchBar resignFirstResponder];
}

-(void)resetUISettings {
//    selectedCountryID = @"" ;
//    selectedStateID    = @"" ;
//    searchedString = @""  ;

    // Set previous selected Country
    if ([kUSERDEFAULTS valueForKey:@"Country"] != nil) {
        textFldCountry.text = [kUSERDEFAULTS valueForKey:@"Country"];
        selectedCountryID =  [kUSERDEFAULTS valueForKey:@"CountryID"];
    } else {
        selectedCountryID = @"" ;
    }
    
    // Set previous selected State
    if ([kUSERDEFAULTS valueForKey:@"State"] != nil) {
        textFldState.text = [kUSERDEFAULTS valueForKey:@"State"];
        selectedStateID =  [kUSERDEFAULTS valueForKey:@"StateID"];
    } else
        selectedStateID    = @"" ;

    // Set previous selected Search Text
    if ([kUSERDEFAULTS valueForKey:@"SearchText"] != nil)
        searchedString = [kUSERDEFAULTS valueForKey:@"SearchText"];
    else
        searchedString = @""  ;
    
    [UtilityClass setTextFieldBorder:textFldCountry] ;
    [UtilityClass setTextFieldBorder:textFldState] ;
    [UtilityClass addMarginsOnTextField:textFldCountry] ;
    [UtilityClass addMarginsOnTextField:textFldState] ;
    
    pageNo = 1 ;
    totalItems = 0 ;
    selectedPickerViewType = -1 ;

    [self configureSearchController] ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [pickerViewContainer setHidden:YES] ;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [tblView addGestureRecognizer:singleTapGestureRecognizer];
    
    jobArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    countryArray = [[NSMutableArray alloc] init] ;
    statesArray = [[NSMutableArray alloc] init] ;
    
    [self searchJobWithSearchText:searchedString];
}

-(void)initializeBasicArray {
    
    NSArray *fieldsArray = @[@"Country",@"State"] ;
    NSArray *parametersArray = @[kBasicProfileAPI_Country,kBasicProfileAPI_State] ;
    
    basicArray = [[NSMutableArray alloc] init] ;
    for (int i= 0; i < fieldsArray.count ; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
        [dict setValue:[parametersArray objectAtIndex:i] forKey:@"key"] ;
        [dict setValue:@"" forKey:@"value"] ;
        [dict setValue:[fieldsArray objectAtIndex:i] forKey:@"field"] ;
        
        [basicArray addObject:dict] ;
    }
}

-(void)configureSearchController {
    jobSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    jobSearchController.searchBar.placeholder = kSearchJobPlaceholder ;
    [jobSearchController.searchBar sizeToFit] ;
    jobSearchController.searchBar.text = searchedString;
    jobSearchController.searchResultsUpdater = self ;
    jobSearchController.dimsBackgroundDuringPresentation = NO ;
    jobSearchController.definesPresentationContext = YES ;
    jobSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = NO ;
    tblView.tableHeaderView = jobSearchController.searchBar ;
    jobSearchController.searchBar.delegate = self ;
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
    [pickerViewContainer setHidden:YES] ;
    [jobSearchController.searchBar resignFirstResponder];
    
    if(selectedPickerViewType == PROFILE_COUNTRY_SELECTED) {
        [textFldCountry resignFirstResponder] ;
        textFldCountry.text = [[basicArray objectAtIndex:BASIC_COUNTRY_INDEX] valueForKey:@"value"]  ;
    }
    else if(selectedPickerViewType == PROFILE_STATE_SELECTED) {
        [textFldState resignFirstResponder] ;
        textFldState.text = [[basicArray objectAtIndex:BASIC_STATE_INDEX] valueForKey:@"value"]  ;
    }
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
    return YES ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _selectedItem = textField ;
    [pickerViewContainer setHidden:YES] ;
    
    if(textField.tag == BASIC_COUNTRY_INDEX) {
        selectedPickerViewType = PROFILE_COUNTRY_SELECTED ;
        int index = [UtilityClass getPickerViewSelectedIndexFromArray:countryArray forID:selectedCountryID] ;
        if(index == -1)
            [pickerView selectRow:0 inComponent:0 animated:YES] ;
        else
            [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
    }
    else if(textField.tag == BASIC_STATE_INDEX) {
        NSString *countryID = [NSString stringWithFormat:@"%@",selectedCountryID] ;
        if( [countryID isEqualToString:@""] || [countryID isEqualToString:@"0"]) {
            [self presentViewController:[UtilityClass displayAlertMessage:kSelectCountryDefaultText] animated:YES completion:nil] ;
            [textField resignFirstResponder] ;
            return NO ;
        }
        else{
            [self getStatesListWithCountryID:[selectedCountryID intValue]] ;
            selectedPickerViewType = PROFILE_STATE_SELECTED ;
            int index = [UtilityClass getPickerViewSelectedIndexFromArray:statesArray forID:selectedStateID] ;
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

#pragma mark - Picker View Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1 ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(selectedPickerViewType == PROFILE_COUNTRY_SELECTED)
        return countryArray.count+1 ;
    else
        return statesArray.count+1 ;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if(selectedPickerViewType == PROFILE_COUNTRY_SELECTED){
        if(row == 0)
            return [NSString stringWithFormat:@"Select %@",[[basicArray objectAtIndex:BASIC_COUNTRY_INDEX] valueForKey:@"field"]] ;
        else
            return [[countryArray objectAtIndex:row-1] valueForKey:@"name"] ;
    }
    else {
        if(row == 0)
            return [NSString stringWithFormat:@"Select %@",[[basicArray objectAtIndex:BASIC_STATE_INDEX] valueForKey:@"field"]] ;
        else
            return [[statesArray objectAtIndex:row-1] valueForKey:@"name"];
    }
}

#pragma mark - API Methods
-(void)getCountriesList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [ApiCrowdBootstrap getCountries:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                countryArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:@"country"]] ;
                [pickerView reloadAllComponents];
//                for (int i = 0; i < countryArray.count; i++) {
//                    
//                    if([[[countryArray objectAtIndex:i] valueForKey:@"id"] intValue] == US_COUNTRY_ID) {
//                        textFldCountry.text = [[countryArray objectAtIndex:i] valueForKey:@"name"] ;
//                        selectedCountryID = [[countryArray objectAtIndex:i] valueForKey:@"id"] ;
//                        
//                        [[basicArray objectAtIndex:BASIC_COUNTRY_INDEX] setValue:[[countryArray objectAtIndex:i] valueForKey:@"name"] forKey:@"value"] ;
//                        [[basicArray objectAtIndex:BASIC_COUNTRY_INDEX] setValue:[[countryArray objectAtIndex:i] valueForKey:@"id"] forKey:@"id"] ;
//                    }
//                }
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
        
        [ApiCrowdBootstrap getCitiesWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
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

-(void)getJobList {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSearchJobAPI_UserID] ;
        [dictParam setObject:@"" forKey:kSearchJobAPI_SearchText] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kSearchJobAPI_PageNo] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",selectedCountryID] forKey:kSearchJobAPI_CountryID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",selectedStateID] forKey:kSearchJobAPI_StateID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap searchJobWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                // NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kSearchJobAPI_JobList]){
                    totalItems = [[responseDict valueForKey:kSearchJobAPI_TotalItems] intValue] ;
                    
                    [jobArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSearchJobAPI_JobList]] ;
                    [tblView reloadData] ;
                    if(jobArray.count < 1)
                        [tblView setHidden:YES] ;
                    else
                        [tblView setHidden:NO] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kSearchJobAPI_JobList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode )
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            totalItems = jobArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)searchJobWithSearchText:(NSString*)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        //if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSearchJobAPI_UserID] ;
        [dictParam setObject:searchText forKey:kSearchJobAPI_SearchText] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kSearchJobAPI_PageNo] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",selectedCountryID] forKey:kSearchJobAPI_CountryID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",selectedStateID] forKey:kSearchJobAPI_StateID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap searchJobWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kSearchJobAPI_JobList]){
                    totalItems = [[responseDict valueForKey:kSearchJobAPI_TotalItems] intValue] ;
                    if(jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSearchJobAPI_JobList]] ;
                    }
                    else {
                        [jobArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSearchJobAPI_JobList]] ;
                    }
                    lblNoJobsFound.hidden = true;

                    [tblView reloadData] ;
                    pageNo ++ ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                NSLog(@"responseDict: %@",responseDict) ;
                lblNoJobsFound.hidden = false;
                if(jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""]) {

                }
                else {
                    jobArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSearchJobAPI_JobList]] ;
                }
                [tblView reloadData] ;
            }
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [jobArray removeAllObjects] ;
    [searchResults removeAllObjects] ;

    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    [self searchJobWithSearchText:searchedString] ;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [jobArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [jobSearchController setActive:NO] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];

    [self searchJobWithSearchText:searchedString] ;
}

#pragma mark - IBActions Methods
- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)DropdownCountryButton_ClickAction:(id)sender {
    [pickerViewContainer setHidden:NO] ;
    
    selectedPickerViewType = PROFILE_COUNTRY_SELECTED ;
    int index = [UtilityClass getPickerViewSelectedIndexFromArray:countryArray forID:selectedCountryID] ;
    if(index == -1)
        [pickerView selectRow:0 inComponent:0 animated:YES] ;
    else
        [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
    
    [pickerView reloadAllComponents] ;
}

- (IBAction)DropdownStateButton_ClickAction:(id)sender {
    [pickerViewContainer setHidden:NO] ;
    
    NSString *countryID = [NSString stringWithFormat:@"%@",selectedCountryID] ;
    NSLog(@"countryID: %@",countryID) ;
    if( [countryID isEqualToString:@""] || [countryID isEqualToString:@"0"]) {
        [self presentViewController:[UtilityClass displayAlertMessage:kSelectCountryDefaultText] animated:YES completion:nil] ;
    }
    else {
        if([selectedCountryID intValue]) {
            [self getStatesListWithCountryID:[selectedCountryID intValue]] ;
            
            selectedPickerViewType = PROFILE_STATE_SELECTED ;
            int index = [UtilityClass getPickerViewSelectedIndexFromArray:statesArray forID:selectedStateID] ;
            if(index == -1)[pickerView selectRow:0 inComponent:0 animated:YES] ;
            else [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
            [pickerView reloadAllComponents] ;
            [pickerViewContainer setHidden:NO] ;
        }
    }
    
    [pickerView reloadAllComponents] ;
}

- (IBAction)PickerToolbarButtons_ClickAction:(id)sender {
    
    [pickerViewContainer setHidden:YES] ;
    if([sender tag] == DONE_CLICKED) {
        
        if(selectedPickerViewType == PROFILE_COUNTRY_SELECTED) {
            [textFldCountry resignFirstResponder] ;
            
            if([pickerView selectedRowInComponent:0] == 0) {
                textFldCountry.text = @"" ;
                selectedCountryID = @"" ;
                
                [[basicArray objectAtIndex:BASIC_COUNTRY_INDEX] setValue:@"" forKey:@"value"] ;
            }
            
            else {
                textFldCountry.text = [[countryArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] ;
                selectedCountryID = [[countryArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"id"]  ;
                
                [[basicArray objectAtIndex:BASIC_COUNTRY_INDEX] setValue:[[countryArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] forKey:@"value"] ;
            }
            
            textFldState.text = @"" ;
            selectedStateID = @"" ;
            
            [[basicArray objectAtIndex:BASIC_STATE_INDEX] setValue:@"" forKey:@"value"] ;
            [[basicArray objectAtIndex:BASIC_STATE_INDEX] setValue:@"" forKey:@"id"] ;
            
            // Save Country in user defaults
            [kUSERDEFAULTS setValue:textFldCountry.text forKey:@"Country"];
            [kUSERDEFAULTS setValue:selectedCountryID forKey:@"CountryID"];

            [kUSERDEFAULTS setValue:textFldState.text forKey:@"State"];
            [kUSERDEFAULTS setValue:selectedStateID forKey:@"StateID"];
            [kUSERDEFAULTS synchronize];
        }
        
        else {
            [textFldState resignFirstResponder] ;
            
            if([pickerView selectedRowInComponent:0] == 0) {
                textFldState.text = @"" ;
                selectedStateID = @"" ;
                
                [[basicArray objectAtIndex:BASIC_STATE_INDEX] setValue:@"" forKey:@"value"] ;
                [[basicArray objectAtIndex:BASIC_STATE_INDEX] setValue:@"" forKey:@"id"] ;
            }
            else {
                textFldState.text = [[statesArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] ;
                selectedStateID = [[statesArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"id"];
                
                [[basicArray objectAtIndex:BASIC_STATE_INDEX] setValue:[[statesArray objectAtIndex:(int)[pickerView selectedRowInComponent:0]-1] valueForKey:@"name"] forKey:@"value"] ;
                
                // Save State in user defaults
                [kUSERDEFAULTS setValue:textFldState.text forKey:@"State"];
                [kUSERDEFAULTS setValue:selectedStateID forKey:@"StateID"];
                [kUSERDEFAULTS synchronize];
            }
        }
    }
    else {
        
        if (selectedPickerViewType == PROFILE_COUNTRY_SELECTED) {
            [textFldCountry resignFirstResponder] ;
            if([pickerView selectedRowInComponent:0] == 0)
                textFldCountry.text = @"" ;
            else
                textFldCountry.text = [[basicArray objectAtIndex:BASIC_COUNTRY_INDEX] valueForKey:@"value"]  ;
        }
        else {
            [textFldState resignFirstResponder] ;
            if([pickerView selectedRowInComponent:0] == 0)
                textFldState.text = @"" ;
            else
                textFldState.text = [[basicArray objectAtIndex:BASIC_STATE_INDEX] valueForKey:@"value"]  ;
        }
    }
    selectedPickerViewType = -1 ;
    [pickerView reloadAllComponents] ;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""])
        return searchResults.count ;
    else {
        if(jobArray.count == totalItems)
            return jobArray.count ;
        else
            return jobArray.count+1 ;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""]) {
        SearchContractorTableViewCell *cell = (SearchContractorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SearchContractor] ;
        cell.nameLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Job_Title]] ;
        cell.rateLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_StarDate]]  ;
        cell.skillLbl.text = [NSString stringWithFormat:@"%@, %@, %@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Company_Name], [[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_State], [[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Country]]  ;
        cell.followerBtn.hidden = NO;
        cell.followerBtn.titleLabel.text = [NSString stringWithFormat:@"%@ Follower",[[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Followers]]  ;
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Company_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        cell.imgView.layer.cornerRadius = 17.5;
        cell.imgView.clipsToBounds = YES;
        
        return cell ;
    }
    else {
        if(indexPath.row == jobArray.count) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
            [activityIndicator startAnimating];
            return cell ;
        }
        else {
            SearchContractorTableViewCell *cell = (SearchContractorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SearchContractor] ;
            cell.nameLbl.text = [NSString stringWithFormat:@"%@",[[jobArray objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Job_Title]] ;
            cell.rateLbl.text = [NSString stringWithFormat:@"%@",[[jobArray objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_StarDate]]  ;
            cell.skillLbl.text = [NSString stringWithFormat:@"%@, %@, %@",[[jobArray objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Company_Name], [[jobArray objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_State], [[jobArray objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Country]]  ;
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[jobArray objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Company_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            
            cell.imgView.layer.cornerRadius = 15;
            cell.imgView.clipsToBounds = YES;
            
            return cell ;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""])
        return 120 ;
    else{
        if(indexPath.row == jobArray.count)
            return 30 ;
        else
            return 100 ;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!(jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""])) {
        if(indexPath.row == jobArray.count) {
            [self searchJobWithSearchText:@""] ;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSMutableArray *array ;
    if (jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""])
        array = [searchResults mutableCopy] ;
    else
        array = [jobArray mutableCopy] ;
    
    if (jobSearchController.active)
        [jobSearchController setActive:NO] ;

    if(indexPath.row != array.count) {
        
        [UtilityClass setJobDetails:(NSMutableDictionary*)[array objectAtIndex:indexPath.row]] ;

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kJobDetailIdentifier] ;
        [self.navigationController.navigationBar setHidden:NO];

        [self.navigationController pushViewController:viewController animated:YES] ;
    }
}

@end
