//
//  ForumDetailViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 15/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "ForumDetailViewController.h"
#import "NotificationsTableViewCell.h"
#import "PaymentsTableViewCell.h"
#import "KLCPopup.h"
#import "UIImageView+WebCache.h"
#import "RDRGrowingTextView.h"

@interface ForumDetailViewController ()

@end
static CGFloat const MaxToolbarHeight = 200.0f;

@implementation ForumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    commentsTblView.estimatedRowHeight = 90 ;
    commentsTblView.rowHeight = UITableViewAutomaticDimension ;
    
    [commentsTblView setNeedsLayout] ;
    [commentsTblView layoutIfNeeded] ;
    
    popupTblView.rowHeight = 50 ;
    [self resetUISettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)singleTap:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil] ;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil] ;
}


#pragma mark - Custom Methods
-(void)resetUISettings{
    
    commentsArray = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init] ;
    reportAbuseArray = [[NSMutableArray alloc] init] ;
    NSLog(@"getForumDetails >>> %@",[UtilityClass getForumDetails]) ;
    self.title = [NSString stringWithFormat:@"%@",[[UtilityClass getForumDetails] valueForKey:kMyForumAPI_ForumTitle] ];
    forumTitleLbl.text = [NSString stringWithFormat:@"%@",[[UtilityClass getForumDetails] valueForKey:kMyForumAPI_ForumTitle] ];
    reportForumTitleLbl.text = [NSString stringWithFormat:@"%@",[[UtilityClass getForumDetails] valueForKey:kMyForumAPI_ForumTitle] ];
    commentsTblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    popupTblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    [UtilityClass setTextViewBorder:descriptionTextView] ;
    [UtilityClass setTextFieldBorder:commentTxtFld] ;
    commentsTblView.layer.borderColor=[[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
    commentsTblView.layer.borderWidth=1.0;
    
    [UtilityClass addMarginsOnTextField:commentTxtFld] ;
    [UtilityClass setTextViewBorder:reportTxtView] ;
    [self renderTextViewToolBar] ;
    
    //descriptionTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive ;
    
    [self getForumDetail] ;
}

- (void )renderTextViewToolBar
{
   
    textViewToolBar = [UIToolbar new];
    
    /*UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [button setTitle:@"Done" forState:UIControlStateNormal] ;
    button.frame = CGRectMake(0, 0, 70, 30) ;
    button.layer.masksToBounds = YES;*/
    
    
    rdrTextView = [RDRGrowingTextView new];
    rdrTextView.font = [UIFont systemFontOfSize:17.0f];
    rdrTextView.textContainerInset = UIEdgeInsetsMake(4.0f, 3.0f, 3.0f, 3.0f);
    rdrTextView.layer.cornerRadius = 4.0f;
    rdrTextView.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:205.0f/255.0f alpha:1.0f].CGColor;
    rdrTextView.layer.borderWidth = 1.0f;
    rdrTextView.layer.masksToBounds = YES;
    rdrTextView.delegate = self ;
    
    //[textViewToolBar addSubview:button] ;
    [textViewToolBar addSubview:rdrTextView];
    
    //button.translatesAutoresizingMaskIntoConstraints = NO;
    rdrTextView.translatesAutoresizingMaskIntoConstraints = NO;
    textViewToolBar.translatesAutoresizingMaskIntoConstraints = NO;
   
    
    /*[textViewToolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[button]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    [textViewToolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[button]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];*/
    [textViewToolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[rdrTextView]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rdrTextView)]];
    [textViewToolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[rdrTextView]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rdrTextView)]];
    
    //[button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [rdrTextView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [textViewToolBar setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [textViewToolBar addConstraint:[NSLayoutConstraint constraintWithItem:textViewToolBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:MaxToolbarHeight]];
    
    reportTxtView.inputAccessoryView = textViewToolBar ;
    
}

-(void)displayForumInfo{
    if(forumsDetailDict){
        userNameLbl.text = [NSString stringWithFormat:@"Created By : %@",[forumsDetailDict valueForKey:kForumDetailAPI_ForumCreatedBy]] ;
        descriptionTextView.text = [NSString stringWithFormat:@"%@",[forumsDetailDict valueForKey:kForumDetailAPI_ForumDesc]] ;
         NSString* imgUrl = [[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[forumsDetailDict valueForKey:kForumDetailAPI_ForumImage]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:kImage_ForumPicDefault]] ;
        
        NSString *archiveCloseStatus = [NSString stringWithFormat:@"%@",[forumsDetailDict valueForKey:kForumDetailAPI_ArchivedClosedStatus]] ;
        
        if([archiveCloseStatus isEqualToString:kCloseForumStatus]){
            [self hideShowUIAccordingToStatus:YES] ;
        }
        else [self hideShowUIAccordingToStatus:NO] ;
        
        if([forumsDetailDict valueForKey:kForumDetailAPI_ForumComments]){
            if(commentsArray)[commentsArray removeAllObjects] ;
            
            NSArray *array = [NSArray arrayWithArray:(NSArray*)[forumsDetailDict valueForKey:kForumDetailAPI_ForumComments]] ;
            commentsArray = [NSMutableArray arrayWithArray:[[[array reverseObjectEnumerator] allObjects] mutableCopy]] ;
            
            if(![archiveCloseStatus isEqualToString:kCloseForumStatus] && [UtilityClass GetForumType] == YES && commentsArray.count < 1){
                reportAbuseBtn.hidden = YES ;
            }
            
          /*  NSArray *totalCommentsArray = (NSArray*)[forumsDetailDict valueForKey:kForumDetailAPI_ForumComments] ;
            if(totalCommentsArray.count <= COMMENTS_MAX_LIMIT) commentsArray = [NSMutableArray arrayWithArray:totalCommentsArray] ;
            else {
                for (int i=(int)totalCommentsArray.count-COMMENTS_MAX_LIMIT; i<totalCommentsArray.count; i++) {
                    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[totalCommentsArray objectAtIndex:i]] ;
                    [commentsArray addObject:dict] ;
                }
            }*/
           // commentsArray = [NSMutableArray arrayWithArray:(NSArray*)[forumsDetailDict valueForKey:kForumDetailAPI_ForumComments]] ;
            [commentsTblView reloadData] ;
            if(commentsArray.count < 1)commentsTblView.hidden = YES ;
            else commentsTblView.hidden = NO ;
            
            if(commentsArray.count < COMMENTS_MAX_LIMIT) viewCommentsBtn.hidden = YES ;
            else viewCommentsBtn.hidden = NO ;
           
            /*if(commentsArray.count > 5)viewCommentsBtn.hidden = YES ;
            else viewCommentsBtn.hidden = NO ;*/
        }
    }
}

-(void)hideShowUIAccordingToStatus:(BOOL)setHidden{
    reportAbuseBtn.hidden = setHidden ;
    postCommentBtn.hidden = setHidden ;
    commentTxtFld.hidden = setHidden ;
}

/*-(NSString*)formatDateFromString:(NSString*)dateTimeString{
    NSString *dateStr  = @"" ;
    NSRange range = [dateTimeString rangeOfString:@" "];
    if (range.location != NSNotFound)
    {
        NSArray *dateArray = [dateTimeString componentsSeparatedByString:@" "] ;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@",[dateArray objectAtIndex:0]]] ;
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"MMM dd, yyyy"];
        return [formatter2 stringFromDate:date];
    }
    return dateStr ;
}*/

-(BOOL)checkForUniqueUsersforUserID:(NSString*)userID{
    BOOL shouldIncludeUser = YES ;
    for (NSDictionary *dict in usersArray) {
        NSString *commentorID = [NSString stringWithFormat:@"%@",[dict valueForKey:kReportAbuseUsersAPI_UserID]] ;
        if([commentorID isEqualToString:userID]) return NO ;
    }
    return shouldIncludeUser ;
}

-(NSMutableArray*)getSelectedUsersIDs{
    NSMutableArray *array = [[NSMutableArray alloc ] init] ;
    if(usersArray.count < 1) return array ;
    for (int i = ([UtilityClass GetForumType] == YES ? 0 : 1); i<usersArray.count; i++) {
        NSString *isSelected = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:i] valueForKey:@"isSelected"]] ;
        if([isSelected isEqualToString:@"1"]){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
            [dict setValue:[NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:i] valueForKey:kReportAbuseUsersAPI_UserID]] forKey:@"userId"] ;
            [array addObject:dict] ;
        }
    }
    return array ;
}

#pragma mark - Validation Methods
-(BOOL)validateSelectedUsers{
    BOOL isValid = NO ;
    for (NSDictionary *dict in usersArray) {
        NSString *isSelected = [NSString stringWithFormat:@"%@",[dict valueForKey:@"isSelected"]] ;
        if([isSelected isEqualToString:@"1"]) return YES ;
    }
    return isValid ;
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

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)Post_ClickAction:(id)sender {
    if(commentTxtFld.text.length < 1){
        [self presentViewController:[UtilityClass displayAlertMessage:kValidation_Comments] animated:YES completion:nil] ;
        return ;
    }
    
    [self postComment] ;
}

- (IBAction)ReportAbuse_ClickAction:(id)sender {
    
    [self getUsersList] ;
    reportTxtView.text = @"" ;
    NSLog(@"GetForumType: %d",[UtilityClass GetForumType]) ;
    
    [UtilityClass displayPopupWithContentView:popupView view:self.view] ;
   
}

- (IBAction)Cancel_ClickAction:(id)sender {
    if([sender tag] == REPORT_BTN_CLICKED){
        if(![self validateSelectedUsers]){
            //[self presentViewController:[UtilityClass displayAlertMessage:kValidation_ReportAbuse_Users] animated:YES completion:nil] ;
            [UtilityClass showNotificationMessgae:kValidation_ReportAbuse_Users withResultType:@"1" withDuration:1] ;
            return ;
        }
        else if(reportTxtView.text.length < 1){
           // [self presentViewController:[UtilityClass displayAlertMessage:kValidation_ReportAbuse_Desc] animated:YES completion:nil] ;
            [UtilityClass showNotificationMessgae:kValidation_ReportAbuse_Desc withResultType:@"1" withDuration:1] ;
            return ;
        }
        [self reportAbuseApi] ;
    }
    else [popupView removeFromSuperview];
        //[popupView dismissPresentingPopup] ;
}

- (IBAction)checkUncheck_ClickAction:(UIButton*)sender {
    UIButton *btn = (UIButton*)sender ;
    if([btn.accessibilityLabel isEqualToString:CHECK_IMAGE ]){ // Check
        [btn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = UNCHECK_IMAGE ;
       [[usersArray objectAtIndex:btn.tag] setValue:@"0" forKey:@"isSelected"] ;
    }
    else{ // Uncheck
        
        [btn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = CHECK_IMAGE ;
        [[usersArray objectAtIndex:btn.tag] setValue:@"1" forKey:@"isSelected"] ;
    }
}

- (IBAction)ViewComment_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kForumCommentsViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}


#pragma mark - API Methods
-(void)getForumDetail{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getForumDetails] valueForKey:kMyForumAPI_ForumID]] forKey:kForumDetailAPI_ForumID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getForumDetailWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kForumDetailAPI_Forums]){
                    forumsDetailDict = [NSMutableDictionary dictionaryWithDictionary:[responseDict valueForKey:kForumDetailAPI_Forums]] ;
                    [self displayForumInfo] ;
                }
            }
            //else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)postComment{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_AddComment] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAddCommentAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getForumDetails] valueForKey:kMyForumAPI_ForumID]] forKey:kAddCommentAPI_ForumID] ;
        [dictParam setObject:commentTxtFld.text forKey:kAddCommentAPI_Comment] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap addForumCommentWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
                commentTxtFld.text = @"" ;
                [self getForumDetail] ;
            }
            else if([responseDict objectForKey:@"errors"]){
                NSDictionary *errorsData = (NSDictionary*)[responseDict objectForKey:@"errors"] ;
                NSString *errorStr = @"" ;
                for (NSString *value in [errorsData allValues]) {
                    errorStr = [NSString stringWithFormat:@"%@\n%@",errorStr,value] ;
                }
                if(![errorStr isEqualToString:@""])[self presentViewController:[UtilityClass displayAlertMessage:errorStr] animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)reportAbuseApi{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kReportAbuseAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getForumDetails] valueForKey:kMyForumAPI_ForumID]] forKey:kReportAbuseAPI_ForumID] ;
        [dictParam setObject:reportTxtView.text forKey:kReportAbuseAPI_Comment] ;
        [dictParam setObject:[NSArray arrayWithArray:[self getSelectedUsersIDs]] forKey:kReportAbuseAPI_ReportedUsers] ;
        if([UtilityClass GetForumType] == NO){
            if(usersArray.count > 0){
                NSString *isSelected = [NSString stringWithFormat:@"%@", [[usersArray objectAtIndex:0] valueForKey:@"isSelected"]] ;
                if([isSelected isEqualToString:@"1"]) [dictParam setObject:@"true" forKey:kReportAbuseAPI_isForumReported] ;
                else [dictParam setObject:@"false" forKey:kReportAbuseAPI_isForumReported] ;
            }
            else [dictParam setObject:@"false" forKey:kReportAbuseAPI_isForumReported] ;
        }
        else [dictParam setObject:@"false" forKey:kReportAbuseAPI_isForumReported] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap reportAbuseWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
             NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
               
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
//                [popupView dismissPresentingPopup] ;
                [popupView removeFromSuperview];
            }
            else if([responseDict objectForKey:@"errors"]){
                NSDictionary *errorsData = (NSDictionary*)[responseDict objectForKey:@"errors"] ;
                NSString *errorStr = @"" ;
                for (NSString *value in [errorsData allValues]) {
                    errorStr = [NSString stringWithFormat:@"%@\n%@",errorStr,value] ;
                }
                if(![errorStr isEqualToString:@""])[self presentViewController:[UtilityClass displayAlertMessage:errorStr] animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getUsersList{
    if([UtilityClass checkInternetConnection]){
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getForumDetails] valueForKey:kMyForumAPI_ForumID]] forKey:kReportAbuseUsersAPI_ForumID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getReportAbuseUsersListWithParameters:dictParam success:^(NSDictionary *responseDict) {
             NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
               
                if(usersArray)[usersArray removeAllObjects] ;
                if([responseDict valueForKey:kReportAbuseUsersAPI_Users]){
                    
                    if([UtilityClass GetForumType] == NO){
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
                        [dict setValue:@"0" forKey:@"isSelected"] ;
                        [usersArray addObject:dict] ;
                    }
                    
                    for (NSDictionary* dict in [responseDict valueForKey:kReportAbuseUsersAPI_Users]) {
                        NSMutableDictionary *obj = [NSMutableDictionary dictionaryWithDictionary:dict] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        
                        if([[dict valueForKey:kReportAbuseUsersAPI_UserID] intValue] != [UtilityClass getLoggedInUserID])[usersArray addObject:obj] ;
                    
                    }
                    [popupTblView reloadData] ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode){
                if([UtilityClass GetForumType] == NO){
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
                    [dict setValue:@"0" forKey:@"isSelected"] ;
                    [usersArray addObject:dict] ;
                }
                [popupTblView reloadData] ;
            }
            //else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
        }] ;
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == commentsTblView)return commentsArray.count ;
    return usersArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == commentsTblView){
        NotificationsTableViewCell *cell = (NotificationsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Comments] ;
        cell.titleLbl.text = [NSString stringWithFormat:@"%@",[[commentsArray objectAtIndex:indexPath.row] valueForKey:kForumDetailAPI_CommentedBy]] ;
        cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[commentsArray objectAtIndex:indexPath.row] valueForKey:kForumDetailAPI_CommentText]] ;
        cell.timeLbl.text = [UtilityClass formatDateFromString:[NSString stringWithFormat:@"%@",[[commentsArray objectAtIndex:indexPath.row] valueForKey:kForumDetailAPI_CommentedTime]]]  ;
        return cell ;
    }
    else{
        if(([UtilityClass GetForumType] == NO) && indexPath.row == 0){
            PaymentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Forums] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            cell.companyNameLbl.text = [NSString stringWithFormat:@"%@",[[UtilityClass getForumDetails] valueForKey:kMyForumAPI_ForumTitle]] ;
            if([[NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:@"isSelected"]] isEqualToString:@"0" ]){ // Check
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
            }
            else{ // Uncheck
                
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
            }
            return cell ;
        }
        else{
            PaymentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Users] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            cell.companyNameLbl.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kReportAbuseUsersAPI_UserName]] ;
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kReportAbuseUsersAPI_UserImage]]] placeholderImage:[UIImage imageNamed:kImage_UserPicDefault]] ;
            cell.imgView.layer.cornerRadius = 17.5;
            cell.imgView.clipsToBounds = YES;
            cell.checkboxBtn.tag = indexPath.row ;
            if([[NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:@"isSelected"]] isEqualToString:@"0" ]){ // Check
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
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if(tableView == commentsTblView)return 70 ;
     else return 50 ;
}*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == popupTblView){
        PaymentsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
        [self checkUncheck_ClickAction:cell.checkboxBtn] ;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // if you have index/header text in your tableview change your index text color
    UITableViewHeaderFooterView *headerIndexText = (UITableViewHeaderFooterView *)view;
    [headerIndexText.textLabel setTextColor:[UtilityClass blueColor]];
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    return YES ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _selectedItem=textField;
    return YES ;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder] ;
    _selectedItem = nil ;
    return YES ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        [reportTxtView resignFirstResponder] ;
    }
    
    if(textView == rdrTextView){
        reportTxtView.text = textView.text ;
    }
    
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _selectedItem=textView;
    return YES ;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder] ;
    _selectedItem = nil ;
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
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.selectedItem.frame.origin ) ) {
        if(![_selectedItem isKindOfClass:[UITableView class]])[self.scrollView scrollRectToVisible:self.selectedItem.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    [self moveToOriginalFrame] ;
}

-(void)moveToOriginalFrame{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
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
