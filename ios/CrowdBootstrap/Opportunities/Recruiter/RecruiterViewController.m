//
//  RecruiterViewController.m
//  CrowdBootstrap
//
//  Created by osx on 09/01/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "RecruiterViewController.h"
#import "SWRevealViewController.h"
#import "SearchContractorTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommitTableViewCell.h"

@interface RecruiterViewController ()

@end

@implementation RecruiterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [self initializeBasicArray];
    
}

- (void)viewWillAppear:(BOOL)animated {
    // Hit Service to get Countries List
    [self getCountriesList] ;
    
    // Hit Service to get My Jobs List
    [self getMyJobList];
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
}

-(void)setSegmentControlSettings {
    
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                
                                                           forKey:NSFontAttributeName];
    [segmentControl setTitleTextAttributes:attributes
                                  forState:UIControlStateNormal];
}

-(void)resetUISettings {
    selectedCountryID = @"" ;
    selectedStateID    = @"" ;
    selectedPickerViewType = -1 ;
    searchedString = @""  ;
    
    [UtilityClass setTextFieldBorder:textFldCountry] ;
    [UtilityClass setTextFieldBorder:textFldState] ;
    [UtilityClass addMarginsOnTextField:textFldCountry] ;
    [UtilityClass addMarginsOnTextField:textFldState] ;
    
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

    pageNo = 1 ;
    totalItems = 0 ;
    
    [segmentControl setSelectedSegmentIndex:MYJOBS_SELECTED] ;
    [self configureSearchController];
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
    jobSearchController.searchResultsUpdater = self ;
    jobSearchController.dimsBackgroundDuringPresentation = NO ;
    jobSearchController.definesPresentationContext = YES ;
    jobSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = jobSearchController.searchBar ;
    jobSearchController.searchBar.delegate = self ;
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [pickerViewContainer setHidden:YES] ;
    if(selectedPickerViewType == COUNTRY_SELECTED) {
        [textFldCountry resignFirstResponder] ;
        textFldCountry.text = [[basicArray objectAtIndex:BASIC_COUNTRY_INDEX] valueForKey:@"value"]  ;
    }
    else if(selectedPickerViewType == STATE_SELECTED) {
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
        selectedPickerViewType = COUNTRY_SELECTED ;
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
        else {
            [self getStatesListWithCountryID:[selectedCountryID intValue]] ;
            selectedPickerViewType = STATE_SELECTED ;
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
    if(selectedPickerViewType == COUNTRY_SELECTED)
        return countryArray.count+1 ;
    else
        return statesArray.count+1 ;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if(selectedPickerViewType == COUNTRY_SELECTED){
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

-(void)getMyJobList {
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
        
        [ApiCrowdBootstrap getMyJobListsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                // NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kSearchJobAPI_JobList]) {
                    totalItems = [[responseDict valueForKey:kSearchJobAPI_TotalItems] integerValue] ;
                    
                    [jobArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSearchJobAPI_JobList]] ;
                    [tblView reloadData] ;
                    if(jobArray.count < 1)
                        [tblView setHidden:YES] ;
                    else
                        [tblView setHidden:NO] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kSearchJobAPI_JobList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            //else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            totalItems = jobArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getMyJobListWithSearchText:(NSString*)searchText {
    if([UtilityClass checkInternetConnection]) {
        
//        if(pageNo == 1)
//            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
    
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSearchJobAPI_UserID] ;
        [dictParam setObject:searchText forKey:kSearchJobAPI_SearchText] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kSearchJobAPI_PageNo] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",selectedCountryID] forKey:kSearchJobAPI_CountryID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",selectedStateID] forKey:kSearchJobAPI_StateID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getMyJobListsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kSearchJobAPI_JobList]) {
                    totalItems = [[responseDict valueForKey:kSearchJobAPI_TotalItems] integerValue] ;
                    if(jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSearchJobAPI_JobList]] ;
                    }
                    else {
                        [jobArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSearchJobAPI_JobList]] ;
                    }
                    
                    [tblView reloadData] ;
                    pageNo ++ ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ){
                if(jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""]){
                    
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

-(void)getArchivedJobWithSearchText:(NSString*)searchText {
    if([UtilityClass checkInternetConnection]) {
        
//        if(pageNo == 1)
//            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSearchJobAPI_UserID] ;
        [dictParam setObject:searchText forKey:kSearchJobAPI_SearchText] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kSearchJobAPI_PageNo] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",selectedCountryID] forKey:kSearchJobAPI_CountryID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",selectedStateID] forKey:kSearchJobAPI_StateID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getArchivedJobListsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kSearchJobAPI_JobList]){
                    totalItems = [[responseDict valueForKey:kSearchJobAPI_TotalItems] intValue] ;
                    if(jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSearchJobAPI_JobList]] ;
                    }
                    else {
                        [jobArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSearchJobAPI_JobList]] ;
                    }
                    
                    [tblView reloadData] ;
                    pageNo ++ ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                if(jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""]){
                    
                }
                else{
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

-(void)getDeActivatedJobWithSearchText:(NSString*)searchText {
    if([UtilityClass checkInternetConnection]) {
        
//        if(pageNo == 1)
//            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kSearchJobAPI_UserID] ;
        [dictParam setObject:searchText forKey:kSearchJobAPI_SearchText] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kSearchJobAPI_PageNo] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",selectedCountryID] forKey:kSearchJobAPI_CountryID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",selectedStateID] forKey:kSearchJobAPI_StateID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getDeactivatedJobListsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kSearchJobAPI_JobList]){
                    totalItems = [[responseDict valueForKey:kSearchJobAPI_TotalItems] intValue] ;
                    if(jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kSearchJobAPI_JobList]] ;
                    }
                    else {
                        [jobArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kSearchJobAPI_JobList]] ;
                    }
                    
                    [tblView reloadData] ;
                    pageNo ++ ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                if(jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""]) {
                    
                }
                else{
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

-(void)archiveJob:(NSString *)jobId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;

        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:jobId forKey:kSearchJobAPI_JobID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveJobWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                
                [UtilityClass showNotificationMessgae:kArchiveMessageAPI_Status withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode )
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deactivateJob:(NSString *)jobId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;

        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:jobId forKey:kSearchJobAPI_JobID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deActivateJobWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeactivateJob_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteJob:(NSString *)jobId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;

        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:jobId forKey:kSearchJobAPI_JobID] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteJobWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
                [UtilityClass showNotificationMessgae:kDeleteJob_SuccessMessage withResultType:@"0" withDuration:1] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
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
    if (selectedSegment == MYJOBS_SELECTED)
        [self getMyJobListWithSearchText:searchedString] ;
    else if (selectedSegment == ARCHIVED_JOB_SELECTED)
        [self getArchivedJobWithSearchText:searchedString] ;
    else
        [self getDeActivatedJobWithSearchText:searchedString] ;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [jobArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [jobSearchController setActive:NO] ;
    if (selectedSegment == MYJOBS_SELECTED)
        [self getMyJobListWithSearchText:searchedString] ;
    else if (selectedSegment == ARCHIVED_JOB_SELECTED)
        [self getArchivedJobWithSearchText:searchedString] ;
    else
        [self getDeActivatedJobWithSearchText:searchedString] ;
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegment = segmentControl.selectedSegmentIndex;
    
//        [jobSearchController dismissViewControllerAnimated:NO completion:nil] ;
//        if(jobSearchController)
//            jobSearchController = nil ;
    
    pageNo = 1 ;
    totalItems = 0 ;
    [jobArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;

//    [self configureSearchController] ;

    switch (selectedSegment) {
        case MYJOBS_SELECTED:
            [self getMyJobListWithSearchText:searchedString] ;
            break;
        case ARCHIVED_JOB_SELECTED:
            [self getArchivedJobWithSearchText:searchedString] ;
            break;
        case DEACTIVATED_JOB_SELECTED:
            [self getDeActivatedJobWithSearchText:searchedString] ;
            break;
        default:
            break;
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)DropdownCountryButton_ClickAction:(id)sender {
    [pickerViewContainer setHidden:NO] ;
    
    selectedPickerViewType = COUNTRY_SELECTED ;
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
            
            selectedPickerViewType = STATE_SELECTED ;
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
        
        if(selectedPickerViewType == COUNTRY_SELECTED) {
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
            }
        }
    }
    else {
        
        if (selectedPickerViewType == COUNTRY_SELECTED) {
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

- (IBAction)archiveJob_ClickAction:(id)sender {
    
    if(jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""]){
        jobID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kSearchJobAPI_JobID];
    }
    else {
        jobID = [[jobArray objectAtIndex:[sender tag]] valueForKey: kSearchJobAPI_JobID];
    }
    [self archiveJob:jobID];
}

- (IBAction)deactivateJob_ClickAction:(id)sender {
    if(jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""]){
        jobID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kSearchJobAPI_JobID];
    }
    else {
        jobID = [[jobArray objectAtIndex:[sender tag]] valueForKey: kSearchJobAPI_JobID];
    }
    [self deactivateJob:jobID];
}

- (IBAction)deleteJob_ClickAction:(id)sender {
    if(jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""]){
        jobID = [[searchResults objectAtIndex:[sender tag]] valueForKey: kSearchJobAPI_JobID];
    }
    else {
        jobID = [[jobArray objectAtIndex:[sender tag]] valueForKey: kSearchJobAPI_JobID];
    }
    
    [self deleteJob:jobID];
}

- (IBAction)postJobButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kPostJobIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
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
    NSLog(@"row: %ld", indexPath.row);
    
    if (jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""]) {
        SearchContractorTableViewCell *cell = (SearchContractorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SearchContractor] ;
        cell.nameLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Job_Title]] ;
        cell.rateLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_StarDate]]  ;
        cell.skillLbl.text = [NSString stringWithFormat:@"%@, %@, %@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Company_Name], [[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_State], [[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Country]]  ;
        cell.followerBtn.titleLabel.text = [NSString stringWithFormat:@"%@ Follower",[[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Followers]] ;
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Company_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        cell.imgView.layer.cornerRadius = 15;
        cell.imgView.clipsToBounds = YES;
        
        cell.followerBtn.hidden = NO;
        cell.stackView.hidden = NO;
        
        cell.archiveBtn.tag = indexPath.row;
        cell.deactivateBtn.tag = indexPath.row;
        cell.deleteBtn.tag = indexPath.row;
        
        return cell ;
    } else {
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
            cell.followerBtn.titleLabel.text = [NSString stringWithFormat:@"%@ Follower",[[jobArray objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Followers]] ;
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[jobArray objectAtIndex:indexPath.row] valueForKey:kSearchJobAPI_Company_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            
            cell.imgView.layer.cornerRadius = 15;
            cell.imgView.clipsToBounds = YES;
            
            cell.followerBtn.hidden = NO;
            cell.stackView.hidden = NO;
            
            cell.archiveBtn.tag = indexPath.row;
            cell.deactivateBtn.tag = indexPath.row;
            cell.deleteBtn.tag = indexPath.row;
            
            return cell ;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""]) {
        if (selectedSegment == MYJOBS_SELECTED)
            return 140;
        else
            return 100 ;
    }
    else {
        if(indexPath.row == jobArray.count)
            return 30 ;
        else {
            if (selectedSegment == MYJOBS_SELECTED)
                return 140;
            else
                return 100;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!(jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""])) {
        if(indexPath.row == jobArray.count) {
            [self getMyJobListWithSearchText:@""] ;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array ;
    if (jobSearchController.active && ![jobSearchController.searchBar.text isEqualToString:@""])
        array = [searchResults mutableCopy] ;
    else
        array = [jobArray mutableCopy] ;
    
    if(indexPath.row != array.count) {
        
        [UtilityClass setJobDetails:(NSMutableDictionary *)[jobArray objectAtIndex:indexPath.row]] ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kEditJobIdentifier] ;
        
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
}

@end
