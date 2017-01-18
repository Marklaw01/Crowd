//
//  ConnectionsViewController.m
//  CrowdBootstrap
//
//  Created by Shikha Singla on 08/11/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "SWRevealViewController.h"
#import "SearchContractorTableViewCell.h"
#import "MessagesTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ConnectionsViewController ()

@end

@implementation ConnectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlSettings];
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
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
    
    toTxtFld.enabled = NO ;
    
    [UtilityClass setTextFieldBorder:toTxtFld] ;
    [UtilityClass setTextFieldBorder:subjectTxtFld] ;
    [UtilityClass setTextViewBorder:messagetxtView] ;

    [UtilityClass addMarginsOnTextField:toTxtFld] ;
    [UtilityClass addMarginsOnTextField:subjectTxtFld] ;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    searchedString = @""  ;
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    [formatter setGroupingSeparator:@","] ;
    [formatter setGroupingSize:3] ;
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    
    connectionsArray = [[NSMutableArray alloc] init] ;
    messagesArray = [[NSMutableArray alloc] init] ;
    searchResults = [[NSMutableArray alloc] init] ;
    tblViewConnections.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    pageNo = 1 ;
    totalItems = 0 ;
    
    // Set My Connections Tab first
    [segmentControl setSelectedSegmentIndex:MY_CONNECTIONS_SELECTED] ;
    [self segmentControlValueChanged:nil]  ;
}

- (void)resetTextFields {
    toTxtFld.text = @"";
    subjectTxtFld.text = @"";
    messagetxtView.text = @"";
}

-(void)configureSearchController {
    connSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    connSearchController.searchBar.placeholder = kSearchConnectionPlaceholder ;
    [connSearchController.searchBar sizeToFit] ;
    connSearchController.searchResultsUpdater = self ;
    connSearchController.dimsBackgroundDuringPresentation = NO ;
    connSearchController.definesPresentationContext = YES ;
    connSearchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    tblViewConnections.tableHeaderView = connSearchController.searchBar ;
    connSearchController.searchBar.delegate = self ;
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
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

-(void)setSegmentControlSettings {
    
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                
                                                           forKey:NSFontAttributeName];
    [segmentControl setTitleTextAttributes:attributes
                                  forState:UIControlStateNormal];
}

#pragma mark - API Methods
#pragma mark Get Connections List
-(void)getConnectionsList {
    if([UtilityClass checkInternetConnection]){
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConnectionAPI_LoggedIn_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConnectionAPI_PageNo] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getMyConnectionsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                // NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kConnectionAPI_Connection_List]){
                    totalItems = [[responseDict valueForKey:kConnectionAPI_TotalItems] intValue] ;
                    
                    [connectionsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConnectionAPI_Connection_List]] ;
                    [tblViewConnections reloadData] ;
                    if(connectionsArray.count < 1)
                        [tblViewConnections setHidden:YES] ;
                    else
                        [tblViewConnections setHidden:NO] ;
                    
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kConnectionAPI_Connection_List]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                UILabel *lblNoRecords = (UILabel *)[self.view viewWithTag:100];
                lblNoRecords.text = @"No Connections Avaliable";
//                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            totalItems = connectionsArray.count ;
            [tblViewConnections reloadData] ;
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark Get Messages List
-(void)getMessagesList {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConnectionAPI_LoggedIn_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConnectionAPI_PageNo] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getMyMessagesWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                // NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kMessagesAPI_Messages]){
                    totalItems = [[responseDict valueForKey:kMessagesAPI_TotalItems] intValue] ;
                    
                    [messagesArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kMessagesAPI_Messages]] ;
                    [tblViewMessages reloadData] ;
                    if(messagesArray.count < 1)
                        [tblViewMessages setHidden:YES] ;
                    else
                        [tblViewMessages setHidden:NO] ;
                    
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kMessagesAPI_Messages]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
//                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                UILabel *lblNoRecords = (UILabel *)[self.view viewWithTag:100];
                [lblNoRecords setText:@"No Messages Avaliable"];
            }
        } failure:^(NSError *error) {
            totalItems = messagesArray.count ;
            [tblViewConnections reloadData] ;
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark Search Connections
-(void)searchConnectionWithSearchText:(NSString*)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        //if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kConnectionAPI_LoggedIn_UserID] ;
        [dictParam setObject:searchText forKey:kConnectionAPI_SearchText] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kConnectionAPI_PageNo] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap searchConnectionWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kConnectionAPI_Connection_List]) {
                    /* totalItems = [[responseDict valueForKey:kRecommendedContAPI_TotalItems] intValue] ;
                     //contractorsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kRecommendedContAPI_Contractors]] ;
                     [contractorsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kRecommendedContAPI_Contractors]] ;
                     [tblView reloadData] ;
                     if(contractorsArray.count <1)[tblView setHidden:YES] ;
                     else [tblView setHidden:NO] ;
                     pageNo ++ ;*/
                    
                    totalItems = [[responseDict valueForKey:kConnectionAPI_TotalItems] intValue] ;
                    if(connSearchController.active && ![connSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConnectionAPI_Connection_List]] ;
                        //if(searchResults.count <1)[tblView setHidden:YES] ;
                        // else [tblView setHidden:NO] ;
                    }
                    else{
                        //contractorsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kRecommendedContAPI_Contractors]] ;
                        [connectionsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kConnectionAPI_Connection_List]] ;
                        //if(contractorsArray.count <1)[tblView setHidden:YES] ;
                        // else [tblView setHidden:NO] ;
                    }
                    [tblViewConnections reloadData] ;
                    
                    pageNo ++ ;
                    
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ){
                if(connSearchController.active && ![connSearchController.searchBar.text isEqualToString:@""]){
                    /*searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMyForumAPI_Forums]] ;
                     if(searchResults.count <1)[tblView setHidden:YES] ;
                     else [tblView setHidden:NO] ;*/
                }
                else{
                    connectionsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kConnectionAPI_Connection_List]] ;
                    //if(forumsArray.count <1)[tblView setHidden:YES] ;
                    //else [tblView setHidden:NO] ;
                }
                [tblViewConnections reloadData] ;
                
                // [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
            //else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark Send Message to Connections
-(void)sendMessage {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_SendMessage] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupTeamMesageAPI_FromID] ;
        [dictParam setObject:contractorID forKey:kStartupTeamMesageAPI_ToID] ;
        [dictParam setObject:@"0" forKey:kStartupTeamMesageAPI_RoleID] ;
        [dictParam setObject:subjectTxtFld.text forKey:kStartupTeamMesageAPI_Subject] ;
        [dictParam setObject:messagetxtView.text forKey:kStartupTeamMesageAPI_Message] ;
        [dictParam setObject:@"connection" forKey:kStartupTeamMesageAPI_Msg_Type];

        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap startupTeamMessageWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
                [self resetTextFields];
                vwPopup.hidden = true;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - Validation Methods
-(BOOL)validateFieldsWithText:(NSString*)text withMessage:(NSString*)message{
    BOOL isValid = YES ;
    if(text.length < 1 || [text isEqualToString:@" "] || [text isEqualToString:@"\n"]){
        [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"%@%@",message,kAlert_SignUp_BlankField]] animated:YES completion:nil];
        return NO ;
    }
    return isValid ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "]) return ;
    pageNo = 1 ;
    totalItems = 0 ;
    [connectionsArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblViewConnections reloadData] ;
    [self searchConnectionWithSearchText:searchedString] ;
    
    //[self filterContentForSearchText:searchString];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [connectionsArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [connSearchController setActive:NO] ;
    [self searchConnectionWithSearchText:searchedString] ;
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    if (searchText == nil) {
        
        // If empty the search results are the same as the original data
        searchResults = [connectionsArray  mutableCopy];
    } else {
        
        [searchResults removeAllObjects] ;
        for (NSDictionary *dict in connectionsArray) {
            //NSLog(@"dict: %@",dict) ;
            BOOL isIncluded = NO ;
            NSString *name = [NSString stringWithFormat:@"%@",[dict valueForKey:kConnectionAPI_Contractor_Name]] ;
            //  NSLog(@"name: %@ searchText: %@",name,searchText) ;
            if([[name lowercaseString] containsString:[searchText lowercaseString]]){
                [searchResults addObject:dict] ;
                isIncluded = YES ;
            }
//            NSArray *skillsArr = [NSArray arrayWithArray:[dict valueForKey:kRecommendedContAPI_Keywords]] ;
//            for (NSDictionary *obj in skillsArr) {
//                NSString *skillName = [NSString stringWithFormat:@"%@",[obj valueForKey:@"name"]] ;
//                if([[skillName lowercaseString] containsString:[searchText lowercaseString]] && isIncluded == NO){
//                    [searchResults addObject:dict] ;
//                    isIncluded = YES ;
//                }
//            }
        }
    }
    [tblViewConnections reloadData] ;
}

#pragma mark - IBAction Methods
- (IBAction)segmentControlValueChanged:(id)sender {
    [connSearchController dismissViewControllerAnimated:NO completion:nil] ;
    if(connSearchController)
        connSearchController = nil ;
    
    pageNo = 1 ;
    totalItems = 0 ;
    [connectionsArray removeAllObjects] ;
    [messagesArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblViewConnections reloadData] ;
    [tblViewMessages reloadData] ;

    if(segmentControl.selectedSegmentIndex == MY_MESSAGES_SELECTED) {
//        [self getStartupsListWithSearchText:@""] ;
        tblViewMessages.hidden = false;
        tblViewConnections.hidden = true;
        
        [self getMessagesList];
        tblViewConnections.tableHeaderView = [[UIView alloc] init]  ;
    }
    else {
        tblViewMessages.hidden = true;
        tblViewConnections.hidden = false;
        
        [self getConnectionsList] ;
        [self configureSearchController] ;
    }
}

- (IBAction)showMessagePopup_ClickAction:(id)sender {
    vwPopup.hidden = false;
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag;
    if (connSearchController.active && ![connSearchController.searchBar.text isEqualToString:@""]) {
        contractorName = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:index] valueForKey:kConnectionAPI_Contractor_Name]];
        contractorID = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:index] valueForKey:kConnectionAPI_ContractorID]];
    } else {
        contractorName = [NSString stringWithFormat:@"%@",[[connectionsArray objectAtIndex:index] valueForKey:kConnectionAPI_Contractor_Name]];
        contractorID = [NSString stringWithFormat:@"%@",[[connectionsArray objectAtIndex:index] valueForKey:kConnectionAPI_ContractorID]];
    }
    toTxtFld.text = contractorName;
}

- (IBAction)sendMessageBtn_ClickAction:(id)sender {
    
    if(![self validateFieldsWithText:subjectTxtFld.text withMessage:@"Subject"])
        return;
    else if(![self validateFieldsWithText:messagetxtView.text withMessage:@"Message"])
        return ;
    [self sendMessage] ;
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    if (!CGRectContainsPoint(vwMessageFields.frame, touchLocation)) {
        vwPopup.hidden = true;
    } else
        [self.view endEditing:YES];
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _selectedItem = textField ;
    return YES ;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
    if([textField isEqual:toTxtFld])[subjectTxtFld becomeFirstResponder] ;
    else if([textField isEqual:subjectTxtFld])[messagetxtView becomeFirstResponder] ;
    
    return YES ;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    _selectedItem = nil ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
//        [self sendMessageBtn_ClickAction:nil] ;
    }
    
//    [self moveToOriginalFrame] ;
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    _selectedItem = textView;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    _selectedItem = nil ;
}

#pragma mark - SearchBar Delegate Method
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tblViewConnections) {
        if (connSearchController.active && ![connSearchController.searchBar.text isEqualToString:@""])
            return searchResults.count ;
        else {
            if(connectionsArray.count == totalItems) return connectionsArray.count ;
            else return connectionsArray.count+1 ;
        }
    } else {
        if(messagesArray.count == totalItems) return messagesArray.count ;
        else return messagesArray.count+1 ;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblViewConnections) { // Connections Tab
        if (connSearchController.active && ![connSearchController.searchBar.text isEqualToString:@""]){
            SearchContractorTableViewCell *cell = (SearchContractorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SearchContractor] ;
            cell.nameLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kConnectionAPI_Contractor_Name]] ;
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kConnectionAPI_Contractor_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            cell.imgView.layer.cornerRadius = 17.5;
            cell.imgView.clipsToBounds = YES;
            cell.sendMessageBtn.tag = indexPath.row;
            cell.followerBtn.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell ;
        }
        else {
            if(indexPath.row == connectionsArray.count) {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
                UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
                [activityIndicator startAnimating];
                return cell ;
            }
            else {
                SearchContractorTableViewCell *cell = (SearchContractorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SearchContractor] ;
                cell.nameLbl.text = [NSString stringWithFormat:@"%@",[[connectionsArray objectAtIndex:indexPath.row] valueForKey:kConnectionAPI_Contractor_Name]] ;
                
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[[connectionsArray objectAtIndex:indexPath.row] valueForKey:kConnectionAPI_Contractor_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
                cell.imgView.layer.cornerRadius = 17.5;
                cell.imgView.clipsToBounds = YES;
                cell.sendMessageBtn.tag = indexPath.row;
                
                return cell ;
            }
        }
    } else { // Messages Tab
        if(indexPath.row == messagesArray.count) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
            [activityIndicator startAnimating];
            return cell ;
        }
        else {
            MessagesTableViewCell *cell = (MessagesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MessagesCell] ;
            cell.messageLbl.text = [NSString stringWithFormat:@"%@",[[messagesArray objectAtIndex:indexPath.row] valueForKey:kMessagesAPI_MessageTitle]]  ;
            cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[messagesArray objectAtIndex:indexPath.row] valueForKey:kMessagesAPI_MessageDesc]]  ;
            cell.timeLbl.text = [UtilityClass formatTimeFromString:[NSString stringWithFormat:@"%@",[[messagesArray objectAtIndex:indexPath.row] valueForKey:kMessagesAPI_MessageTime]]]  ;
            cell.sentByLbl.text = [NSString stringWithFormat:@"From : %@",[[messagesArray objectAtIndex:indexPath.row] valueForKey:kMessagesAPI_MessageSender]]  ;
            cell.dateLbl.text = [UtilityClass formatDateFromString:[NSString stringWithFormat:@"%@",[[messagesArray objectAtIndex:indexPath.row] valueForKey:kMessagesAPI_MessageTime]]]  ;
            
            return cell ;
        }
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tblViewConnections) {
        if (connSearchController.active && ![connSearchController.searchBar.text isEqualToString:@""])
            return 100 ;
        else {
            if(indexPath.row == connectionsArray.count)
                return 30 ;
            else
                return 100 ;
        }
    } else {
        return 110;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblViewConnections) {
        if (!(connSearchController.active && ![connSearchController.searchBar.text isEqualToString:@""])) {
            if(indexPath.row == connectionsArray.count){
                [self getConnectionsList] ;
            }
        }
    } else {
        if(indexPath.row == messagesArray.count){
            [self getMessagesList] ;
        }
    }
}

@end
