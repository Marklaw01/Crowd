//
//  ContactsViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 25/05/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "ContactsViewController.h"
#import "SWRevealViewController.h"
#import "NotificationsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DialogTableViewCell.h"
#import "ChatViewController.h"
#import "KLCPopup.h"
#import "PaymentsTableViewCell.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController
static NSString *const kTestUsersDefaultPassword = @"x6Bt0VDy5";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addObserver];
    [self resetUISettings] ;
}
-(void)viewWillAppear:(BOOL)animated {
    [_tblView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kChatUserViewIdentifier]) {
        ChatViewController *chatViewController = segue.destinationViewController;
        chatViewController.dialog = sender;
    }
}*/

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
    _tblView.hidden = YES ;
    allUsersArray = [[NSMutableArray alloc] init] ;
    contactsArray = [[NSMutableArray alloc] init] ;
    //chatUsersArray = [[NSMutableArray alloc] init] ;
    _tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    popupTblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    NoChatsAvailableLbl.text = DEFAULT_NO_CHATS_AVAILABLE ;
    [UtilityClass addMarginsOnTextField:groupNameTxtFld] ;
    [UtilityClass setTextFieldBorder:groupNameTxtFld] ;
    chatButton.hidden = YES ;
    chatImage.hidden = YES ;
    
    chatButton.layer.cornerRadius = 21.5;
    chatButton.clipsToBounds = YES;
    
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    [self quickBloxSettings] ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    //[self SegmentControl_ValueChanged:nil] ;
    //[self getContactsList] ;
}

-(void)navigationBarSettings{
    self.navigationItem.hidesBackButton = YES ;
    self.title = @"Chat" ;
}


-(void)revealViewSettings{
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    menuBarBtn.target = self.revealViewController;
    menuBarBtn.action = @selector(revealToggle:);
    
    // Set the gesture
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (IBAction)CheckUncheck_ClickAction:(id)sender {
    UIButton *btn = (UIButton*)sender ;
    if([btn.accessibilityLabel isEqualToString:CHECK_IMAGE ]){ // Check
        [btn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = UNCHECK_IMAGE ;
        [[allUsersArray objectAtIndex:btn.tag] setValue:@"0" forKey:@"isSelected"] ;
    }
    else{ // Uncheck
        
        [btn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = CHECK_IMAGE ;
        [[allUsersArray objectAtIndex:btn.tag] setValue:@"1" forKey:@"isSelected"] ;
    }
}


-(void)updateUsersArray{
    
    for (NSDictionary *userObj in contactsArray) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
        [dict setValue:[userObj objectForKey:kGetContactsAPI_QuickbloxID] forKey:@"quickblox_id"] ;
        [dict setValue:[userObj objectForKey:kGetContactsAPI_UserName] forKey:@"name"] ;
        [dict setValue:@"0" forKey:@"isSelected"] ;
        [allUsersArray addObject:dict] ;
    }
}


-(void)getSelectedUsersForGroupArray{
    if(selectedUsersForGroup) [selectedUsersForGroup removeAllObjects] ;
    else selectedUsersForGroup = [[NSMutableArray alloc] init] ;
    
    for (NSDictionary *dict in allUsersArray) {
        NSString *isSelected = [NSString stringWithFormat:@"%@",[dict valueForKey:@"isSelected"]] ;
        if([isSelected isEqualToString:@"1"]){
            
           // [selectedUsersForGroup addObject:[NSString stringWithFormat:@"%d",[[dict valueForKey:@"quickblox_id"] intValue]]] ;
            QBUUser *user = [QBUUser user];
            user.ID = [[dict valueForKey:@"quickblox_id"] intValue]  ;
            [selectedUsersForGroup addObject:user] ;
            
        }
    }
    QBUUser *loggedInUser = [QBUUser user];
    loggedInUser.ID = [UtilityClass getLoggedInUserQuickBloxID] ;
    [selectedUsersForGroup addObject:loggedInUser] ;
    //[selectedUsersForGroup addObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserQuickBloxID]]] ;
}


#pragma mark - QuickBlox Methods
-(void)quickBloxSettings{
    [[ServicesManager instance].chatService addDelegate:self];
    self.observerDidBecomeActive = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                                                     object:nil queue:[NSOperationQueue mainQueue]
                                                                                 usingBlock:^(NSNotification *note) {
                                                                                   /*  if (![[QBChat instance] isConnected]) {
                                                                                         [UtilityClass showHudWithTitle:NSLocalizedString(@"SA_STR_CONNECTING_TO_CHAT", nil)] ;
                                                                                         
                                                                                      
                                                                                     }*/
                                                                                 }];
    
    if ([ServicesManager instance].isAuthorized) {
        [self loadDialogs];
    }
    else {
        ServicesManager *servicesManager = [ServicesManager instance];
        NSLog(@"currentUser: %@",servicesManager.currentUser) ;
        if (servicesManager.currentUser != nil) {
            // loggin in with previous user
            servicesManager.currentUser.password = [[UtilityClass getLoggedInUserDetails] valueForKey:kLogInAPI_Password];
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
            [servicesManager logInWithUser:servicesManager.currentUser completion:^(BOOL success, NSString *errorMessage) {
                if (success) {
                    NSLog(@"success") ;
                    [UtilityClass hideHud] ;
                  /*  __typeof(self) strongSelf = weakSelf;
                   // [strongSelf registerForRemoteNotifications];
                    //[SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SA_STR_LOGGED_IN", nil)];
                    
                    if (servicesManager.notificationService.pushDialogID == nil) {
                       // [strongSelf performSegueWithIdentifier:kGoToDialogsSegueIdentifier sender:nil];
                    }
                    else {
                       // [servicesManager.notificationService handlePushNotificationWithDelegate:self];
                    }*/
                    
                } else {
                    NSLog(@"error %@",errorMessage)  ;
                    [UtilityClass hideHud] ;
                   // [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"SA_STR_ERROR", nil)];
                }
            }];
        }

    }
}


- (void)loadDialogs {
    NSLog(@"%@", [ServicesManager instance].lastActivityDate);
    
    if ([ServicesManager instance].lastActivityDate != nil) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [[ServicesManager instance].chatService fetchDialogsUpdatedFromDate:[ServicesManager instance].lastActivityDate andPageLimit:kDialogsPageLimit iterationBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, BOOL *stop) {
            //
             NSLog(@"dialogs >> %@",self.dialogs) ;
            [UtilityClass hideHud] ;
            
            if(segmentControl.selectedSegmentIndex == CHATS_SELECTED){
               
                if(self.dialogs.count >0)_tblView.hidden = NO ;
                else _tblView.hidden = YES ;
                [_tblView reloadData] ;
            }
            //[weakSelf.tblView reloadData];
        } completionBlock:^(QBResponse *response) {
            //
            if ([ServicesManager instance].isAuthorized && response.success) {
                [ServicesManager instance].lastActivityDate = [NSDate date];
            }
        }];
    }
    else {
       // [SVProgressHUD showWithStatus:NSLocalizedString(@"SA_STR_LOADING_DIALOGS", nil) maskType:SVProgressHUDMaskTypeClear];
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [[ServicesManager instance].chatService allDialogsWithPageLimit:kDialogsPageLimit extendedRequest:nil iterationBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, BOOL *stop) {
            NSLog(@"dialogObjects >> %@",dialogObjects) ;
            [UtilityClass hideHud] ;
            if(segmentControl.selectedSegmentIndex == CHATS_SELECTED){
                if(self.dialogs.count >0)_tblView.hidden = NO ;
                else _tblView.hidden = YES ;
                [_tblView reloadData] ;
            }
            
            //[weakSelf.tblView reloadData];
        } completion:^(QBResponse *response) {
            if ([ServicesManager instance].isAuthorized) {
                if (response.success) {
                    NSLog(@"response >> %@",response) ;
                    //[SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SA_STR_COMPLETED", nil)];
                    [ServicesManager instance].lastActivityDate = [NSDate date];
                }
                else {
                    [UtilityClass displayAlertMessage:NSLocalizedString(@"SA_STR_FAILED_LOAD_DIALOGS", nil)] ;
                   // [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"SA_STR_FAILED_LOAD_DIALOGS", nil)];
                }
            }
        }];
    }
}

- (NSArray *)dialogs {
    // Retrieving dialogs sorted by updatedAt date from memory storage.
    return [ServicesManager.instance.chatService.dialogsMemoryStorage dialogsSortByUpdatedAtWithAscending:NO];
}

/*
#pragma mark - KLC popup
-(void)displayKLCPopupWithContentView:(UIView*)contentView{
    
    contentView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width-30, self.view.frame.size.height-20);
    contentView.backgroundColor = [UtilityClass backgroundColor];
    contentView.layer.cornerRadius = 12.0;
    
    KLCPopupLayout layout = KLCPopupLayoutMake((KLCPopupHorizontalLayout)KLCPopupHorizontalLayoutCenter,
                                               (KLCPopupVerticalLayout)KLCPopupVerticalLayoutCenter);
    
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView
                                            showType:(KLCPopupShowType)KLCPopupShowTypeBounceInFromTop
                                         dismissType:(KLCPopupDismissType)KLCPopupDismissTypeBounceOutToBottom
                                            maskType:(KLCPopupMaskType)KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:YES
                               dismissOnContentTouch:NO];
    
    [popup showWithLayout:layout];
}
*/

#pragma mark - SegmentControl Value Change Method
- (IBAction)SegmentControl_ValueChanged:(id)sender {
    
    //if(contactsArray) [contactsArray removeAllObjects] ;
    _tblView.hidden = YES ;
    pageNo = 1 ;
    totalNumberOfPages = 0 ;
    if(segmentControl.selectedSegmentIndex == CHATS_SELECTED){
        chatButton.hidden = YES ;
        chatImage.hidden = YES ;
        NoChatsAvailableLbl.text = DEFAULT_NO_CHATS_AVAILABLE ;
        [self loadDialogs] ;
        //[self retrieveQuickbloxChatUsers] ;
    }
    else{
        chatButton.hidden = NO ;
        chatImage.hidden = NO ;
        NoChatsAvailableLbl.text = DEFAULT_NO_CONTACTS_AVAILABLE;
        [self getContactsList] ;
    }
}

#pragma mark - IBAction Methods
- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    
}

- (IBAction)CreateGroup_ClickAction:(id)sender {
    //[popupView dismissPresentingPopup] ;
    if(groupNameTxtFld.text.length < 1){
        [UtilityClass showNotificationMessgae:VALIDATION_GROUP_NAME_REQUIRED withResultType:@"1" withDuration:1] ;
        return ;
    }
    else{
        [self getSelectedUsersForGroupArray] ;
        if(selectedUsersForGroup.count < MIN_GROUP_CHAT_MEM_REQ){
            [UtilityClass showNotificationMessgae:VALIDATION__GROUP_CHAT withResultType:@"1" withDuration:1] ;
            return ;
        }
        [self createGroup] ;
       
    }
}

- (IBAction)Cancel_ClickAction:(id)sender {
     [popupView removeFromSuperview] ;
}

- (IBAction)groupButton_ClickAction:(id)sender {
    if(allUsersArray) [allUsersArray removeAllObjects] ;
    else allUsersArray = [[NSMutableArray alloc] init] ;
    /*if(segmentControl.selectedSegmentIndex == CHATS_SELECTED)[self getContactsList] ;
    else [self updateUsersArray] ;*/
    groupNameTxtFld.text = @"" ;
    [self updateUsersArray] ;
    [self.view endEditing:YES] ;
    [popupTblView reloadData] ;
    [UtilityClass displayPopupWithContentView:popupView view:self.view] ;
}

#pragma mark - QuickBlox Methods
-(void)createGroup{
    
    NSLog(@"selectedUsersForGroup: %@",selectedUsersForGroup) ;
    
    [UtilityClass showHudWithTitle:kHUDMessage_CreateGroup] ;
    [ServicesManager.instance.chatService createGroupChatDialogWithName:groupNameTxtFld.text photo:nil occupants:selectedUsersForGroup completion:^(QBResponse * _Nonnull response, QBChatDialog * _Nullable createdDialog) {
        if(response && createdDialog){
            [UtilityClass hideHud] ;
            NSLog(@"Success %@",createdDialog.name);
            [UtilityClass setSelectedChatUserName:createdDialog.name] ;
            [UtilityClass showNotificationMessgae:kAlert_GroupCreatedSuccess withResultType:@"1" withDuration:1] ;
            [popupView dismissPresentingPopup] ;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ChatViewController *viewController = (ChatViewController*)[storyboard instantiateViewControllerWithIdentifier:kChatUserViewIdentifier] ;
            viewController.dialog = createdDialog ;
            NSLog(@"qbChatDialog: %@",createdDialog) ;
            [self.navigationController pushViewController:viewController animated:YES] ;
        }
    }] ;
    
}

#pragma mark - API Methods
-(void)getContactsList{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kGetContactsAPI_UserID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getContactsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if(contactsArray)[contactsArray removeAllObjects] ;
                if([responseDict valueForKey:kGetContactsAPI_Users]){
                    contactsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kGetContactsAPI_Users]] ;
                    //[self updateUsersArray] ;
                    [_tblView reloadData] ;
                    if(contactsArray.count <1)[_tblView setHidden:YES] ;
                    else [_tblView setHidden:NO] ;
                }
            }
            //else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - Table View Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _tblView){
        if(segmentControl.selectedSegmentIndex == CHATS_SELECTED) return self.dialogs.count ;
        else return contactsArray.count ;
    }
    else return allUsersArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _tblView){
        if(segmentControl.selectedSegmentIndex == CHATS_SELECTED){
            
            DialogTableViewCell *cell = (DialogTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Chats] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            QBChatDialog *qbChatDialog = (QBChatDialog*)[self.dialogs objectAtIndex:indexPath.row] ;
            cell.dialogNameLabel.text = qbChatDialog.name;
            cell.lastMessageTextLabel.text = qbChatDialog.lastMessageText ;
            cell.lastUpdatedTimeLabel.text = [dateFormatter stringFromDate:qbChatDialog.updatedAt] ;
            if(qbChatDialog.unreadMessagesCount > 0){
                cell.unreadCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)qbChatDialog.unreadMessagesCount] ;
                cell.unreadContainerView.hidden = NO ;
            }
            else cell.unreadContainerView.hidden = YES ;
            
            if(qbChatDialog.type == QBChatDialogTypeGroup || qbChatDialog.type == QBChatDialogTypePublicGroup){
                cell.dialogImageView.hidden = NO ;
                cell.userImageLbl.hidden = YES ;
                cell.dialogImageView.layer.cornerRadius = 21.5;
                cell.dialogImageView.clipsToBounds = YES;
            }
            else{
                cell.dialogImageView.hidden = YES ;
                cell.userImageLbl.hidden = NO ;
                cell.userImageLbl.layer.cornerRadius = 21.5;
                cell.userImageLbl.clipsToBounds = YES;
                if(qbChatDialog.name.length>0)cell.userImageLbl.text = [qbChatDialog.name substringWithRange:NSMakeRange(0, 1)] ;
                else cell.userImageLbl.text = @"" ;
            }
            return cell ;
        }
        else{
            NotificationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Contacts] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            cell.titleLbl.text = [[contactsArray objectAtIndex:indexPath.row] valueForKey:kGetContactsAPI_UserName];
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[[contactsArray objectAtIndex:indexPath.row] valueForKey:kGetContactsAPI_UserImage]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            cell.imgView.layer.cornerRadius = 21.5;
            cell.imgView.clipsToBounds = YES;
            return cell ;
        }
    }
    else{
        PaymentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keywordsCell"] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.companyNameLbl.text = [[allUsersArray objectAtIndex:indexPath.row] valueForKey:@"name"] ;
        cell.checkboxBtn.tag = indexPath.row ;
        if([[NSString stringWithFormat:@"%@",[[allUsersArray objectAtIndex:indexPath.row] valueForKey:@"isSelected"]] isEqualToString:@"0" ]){ // Check
            [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
            cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
        }
        else{ // Uncheck
            
            [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
            cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
        }
        return cell ;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _tblView){
        if(segmentControl.selectedSegmentIndex == CHATS_SELECTED) return 65 ;
        else return 60 ;
    }
    else return 50 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _tblView){
        
        if(segmentControl.selectedSegmentIndex == CHATS_SELECTED){
            QBChatDialog *qbChatDialog = (QBChatDialog*)[self.dialogs objectAtIndex:indexPath.row] ;
            [UtilityClass setSelectedChatUserName:qbChatDialog.name] ;
            
            //QBChatDialog *dialog = self.dialogs[indexPath.row];
            
            //[self performSegueWithIdentifier:kChatUserViewIdentifier sender:dialog];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ChatViewController *viewController = (ChatViewController*)[storyboard instantiateViewControllerWithIdentifier:kChatUserViewIdentifier] ;
            viewController.dialog = qbChatDialog ;
            NSLog(@"qbChatDialog: %@",qbChatDialog) ;
            [self.navigationController pushViewController:viewController animated:YES] ;
        }
        else{
            [UtilityClass setSelectedChatUserName:[[contactsArray objectAtIndex:indexPath.row] valueForKey:kGetContactsAPI_UserName]] ;
            QBUUser *user = [QBUUser user];
            user.ID = [[[contactsArray objectAtIndex:indexPath.row] valueForKey:kGetContactsAPI_QuickbloxID] intValue];
            //user.ID = 13519879 ;
            user.login = [[contactsArray objectAtIndex:indexPath.row] valueForKey:kGetContactsAPI_UserName] ;
            NSLog(@"qbUser: %@",user) ;
            
            [ServicesManager.instance.chatService createPrivateChatDialogWithOpponent:user completion:^(QBResponse *response, QBChatDialog *createdDialog) {
                if (!response.success && createdDialog == nil) {
                    NSLog(@"errror >> %@", response.error) ;
                }
                else {
                    NSLog(@"Success >> ") ;
                    [UtilityClass setSelectedChatUserName:createdDialog.name] ;
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ChatViewController *viewController = (ChatViewController*)[storyboard instantiateViewControllerWithIdentifier:kChatUserViewIdentifier] ;
                    viewController.dialog = createdDialog ;
                    NSLog(@"qbChatDialog: %@",createdDialog) ;
                    [self.navigationController pushViewController:viewController animated:YES] ;
                }
            }];
        }
    }
    else{
        PaymentsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
        [self CheckUncheck_ClickAction:cell.checkboxBtn] ;
    }
   
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    return YES ;
}

#pragma mark -
#pragma mark Chat Service Delegate

- (void)chatService:(QMChatService *)chatService didAddChatDialogsToMemoryStorage:(NSArray *)chatDialogs {
    [self.tblView reloadData];
}

- (void)chatService:(QMChatService *)chatService didAddChatDialogToMemoryStorage:(QBChatDialog *)chatDialog {
    [self.tblView reloadData];
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogInMemoryStorage:(QBChatDialog *)chatDialog {
    [self.tblView reloadData];
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogsInMemoryStorage:(NSArray *)dialogs {
    [self.tblView reloadData];
}

- (void)chatService:(QMChatService *)chatService didReceiveNotificationMessage:(QBChatMessage *)message createDialog:(QBChatDialog *)dialog {
    [self.tblView reloadData];
}

- (void)chatService:(QMChatService *)chatService didAddMessageToMemoryStorage:(QBChatMessage *)message forDialogID:(NSString *)dialogID {
    [self.tblView reloadData];
}

- (void)chatService:(QMChatService *)chatService didAddMessagesToMemoryStorage:(NSArray *)messages forDialogID:(NSString *)dialogID {
    [self.tblView reloadData];
}

- (void)chatService:(QMChatService *)chatService didDeleteChatDialogWithIDFromMemoryStorage:(NSString *)chatDialogID {
    [self.tblView reloadData];
}

#pragma mark - QMChatConnectionDelegate

- (void)chatServiceChatDidConnect:(QMChatService *)chatService {
    NSLog(NSLocalizedString(@"SA_STR_CONNECTED", nil)) ;
   // [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SA_STR_CONNECTED", nil) maskType:SVProgressHUDMaskTypeClear];
    [self loadDialogs];
}

- (void)chatServiceChatDidReconnect:(QMChatService *)chatService {
    NSLog(NSLocalizedString(@"SA_STR_RECONNECTED", nil) ) ;
    //[SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SA_STR_RECONNECTED", nil) maskType:SVProgressHUDMaskTypeClear];
    [self loadDialogs];
}

- (void)chatServiceChatDidAccidentallyDisconnect:(QMChatService *)chatService {
    NSLog(NSLocalizedString(@"SA_STR_DISCONNECTED", nil)) ;
    //[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"SA_STR_DISCONNECTED", nil)];
}

- (void)chatService:(QMChatService *)chatService chatDidNotConnectWithError:(NSError *)error {
     NSLog(@"%@",[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"SA_STR_DID_NOT_CONNECT_ERROR", nil), [error localizedDescription]]) ;
    //[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"SA_STR_DID_NOT_CONNECT_ERROR", nil), [error localizedDescription]]];
}

- (void)chatServiceChatDidFailWithStreamError:(NSError *)error {
      NSLog(@"%@",[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"SA_STR_FAILED_TO_CONNECT_WITH_ERROR", nil), [error localizedDescription]]) ;
    //[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"SA_STR_FAILED_TO_CONNECT_WITH_ERROR", nil), [error localizedDescription]]];
}


/**
 *  Creates a chat with name
 *  If name is empty, then "login1_login2, login3, login4" string will be used as a chat name, where login1 is
 *  a dialog creator(owner)
 *
 *  @param name       chat name, can be nil
 *  @param completion completion block
 */

/*- (void)createChatWithName:(NSString *)name completion:(void(^)(QBChatDialog *dialog))completion {
    NSMutableIndexSet *selectedUsersIndexSet = [NSMutableIndexSet indexSet];
    [self.tblView.indexPathsForSelectedRows enumerateObjectsUsingBlock:^(NSIndexPath* obj, NSUInteger idx, BOOL *stop) {
        [selectedUsersIndexSet addIndex:obj.row];
    }];
    
    //NSArray *selectedUsers = [self.dataSource.users objectsAtIndexes:selectedUsersIndexSet];
    
    if (name == nil) {
        // Creating private chat dialog.
        
        
        
        [ServicesManager.instance.chatService createPrivateChatDialogWithOpponent:selectedUsers.firstObject completion:^(QBResponse *response, QBChatDialog *createdDialog) {
            if (!response.success && createdDialog == nil) {
                if (completion) {
                    completion(nil);
                }
            }
            else {
                if (completion) {
                    completion(createdDialog);
                }
            }
        }];
    } else if (selectedUsers.count > 1) {
        if (name == nil || [[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            name = [NSString stringWithFormat:@"%@_", [QBSession currentSession].currentUser.login];
            for (QBUUser *user in selectedUsers) {
                name = [NSString stringWithFormat:@"%@%@,", name, user.login];
            }
            name = [name substringToIndex:name.length - 1]; // remove last , (comma)
        }
        
        [SVProgressHUD showWithStatus:NSLocalizedString(@"SA_STR_LOADING", nil) maskType:SVProgressHUDMaskTypeClear];
        
        // Creating group chat dialog.
        [ServicesManager.instance.chatService createGroupChatDialogWithName:name photo:nil occupants:selectedUsers completion:^(QBResponse *response, QBChatDialog *createdDialog) {
            if (response.success) {
                // Notifying users about created dialog.
                [[ServicesManager instance].chatService sendSystemMessageAboutAddingToDialog:createdDialog toUsersIDs:createdDialog.occupantIDs completion:^(NSError *error) {
                    //
                    if (completion) {
                        completion(createdDialog);
                    }
                }];
            } else {
                if (completion) {
                    completion(nil);
                }
            }
        }];
    } else {
        assert("no given users");
    }
}*/



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
