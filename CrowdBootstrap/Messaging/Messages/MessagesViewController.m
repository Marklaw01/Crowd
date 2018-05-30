//
//  MessagesViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 13/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "MessagesViewController.h"
#import "SWRevealViewController.h"
#import "SWTableViewCell.h"
#import "MessagesTableViewCell.h"

@interface MessagesViewController ()

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.messageTblView.estimatedRowHeight = 110 ;
    self.messageTblView.rowHeight = UITableViewAutomaticDimension ;
    
    [self.messageTblView setNeedsLayout] ;
    [self.messageTblView layoutIfNeeded] ;
    [self addObserver];
    [self resetUISettings] ;
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
    messagesArray = [[NSMutableArray alloc] init] ;
    self.messageTblView.hidden = YES ;
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    self.messageTblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    pageNo = 1 ;
    totalItems = 0 ;
    
    
    [self getMessagesList] ;
}

-(void)navigationBarSettings {
    self.navigationItem.hidesBackButton = YES ;
    self.title = @"Team Messages" ;
}

-(void)revealViewSettings{
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    menuBarBtn.target = self.revealViewController;
    menuBarBtn.action = @selector(revealToggle:);
    
    // Set the gesture
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
}

#pragma mark - IBAction Methods
- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    
}

#pragma mark - API Methods
-(void)getMessagesList {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kMessagesAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kMessagesAPI_PageNo] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getMessagesListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kMessagesAPI_Messages]){
                    totalItems = [[responseDict valueForKey:kMessagesAPI_TotalItems] intValue] ;
                    for (NSDictionary *dict in (NSArray*)[responseDict valueForKey:kMessagesAPI_Messages]) {
                        [messagesArray addObject:dict] ;
                    }
                    //messagesArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMessagesAPI_Messages]] ;
                    [self.messageTblView reloadData] ;
                    if(messagesArray.count <1)[self.messageTblView setHidden:YES] ;
                    else [self.messageTblView setHidden:NO] ;
                    pageNo ++ ;
                }
            }
            //else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)archiveDeleteMessagewithCellIndexPath:(NSIndexPath*)cellIndexPath withActionType:(int)shouldArchive {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[messagesArray objectAtIndex:cellIndexPath.row] valueForKey:kMessagesAPI_MessageID]] forKey:kArchiveMessageAPI_MessageID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",(shouldArchive==0?@"1":@"2")] forKey:kArchiveMessageAPI_Status] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap archiveDeleteMessageWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                NSLog(@"responseDict: %@",responseDict) ;
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"]  withResultType:@"1" withDuration:1] ;
                [messagesArray removeObjectAtIndex:cellIndexPath.row];
                totalItems = totalItems -1 ;
                [self.messageTblView reloadData] ;
                if(messagesArray.count <1)self.messageTblView.hidden = YES ;
                else self.messageTblView.hidden = NO ;
                /*[messageTblView deleteRowsAtIndexPaths:@[cellIndexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];*/
            }
            //else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(messagesArray.count == totalItems) return messagesArray.count ;
    else return messagesArray.count+1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        cell.sentByLbl.text = [NSString stringWithFormat:@"%@",[[messagesArray objectAtIndex:indexPath.row] valueForKey:kMessagesAPI_MessageSender]]  ;
        cell.dateLbl.text = [UtilityClass formatDateFromString:[NSString stringWithFormat:@"%@",[[messagesArray objectAtIndex:indexPath.row] valueForKey:kMessagesAPI_MessageTime]]]  ;
        
        NSMutableArray *rightUtilityButtons = [NSMutableArray new] ;
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:18.0/255.0f green:89.0/255.0f blue:23.0/255.0f alpha:1] icon:[UIImage imageNamed:FORUM_ARCHIVE_IMAGE]] ;
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:197.0/255.0f green:4.0/255.0f blue:25.0/255.0f alpha:1] icon:[UIImage imageNamed:FORUM_DELETE_IMAGE]] ;
        cell.rightUtilityButtons = rightUtilityButtons ;
        cell.delegate = self ;
       // [self setUpCell:cell atIndexPath:indexPath];
      
        return cell ;
    }
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == messagesArray.count) return 30 ;
    else return 110 ;
}*/

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static MessagesTableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        cell = [self.messageTblView dequeueReusableCellWithIdentifier:kCellIdentifier_MessagesCell];
    });
    
    [self setUpCell:cell atIndexPath:indexPath];
    
    return [self calculateHeightForConfiguredSizingCell:cell];
}*/

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == messagesArray.count){
        [self getMessagesList] ;
    }
    
}

# pragma mark - Cell Setup

- (void)setUpCell:(MessagesTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.messageLbl.text = [NSString stringWithFormat:@"%@",[[messagesArray objectAtIndex:indexPath.row] valueForKey:kMessagesAPI_MessageTitle]]  ;
    cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[messagesArray objectAtIndex:indexPath.row] valueForKey:kMessagesAPI_MessageDesc]]  ;
    cell.timeLbl.text = [UtilityClass formatTimeFromString:[NSString stringWithFormat:@"%@",[[messagesArray objectAtIndex:indexPath.row] valueForKey:kMessagesAPI_MessageTime]]]  ;
    cell.sentByLbl.text = [NSString stringWithFormat:@"%@",[[messagesArray objectAtIndex:indexPath.row] valueForKey:kMessagesAPI_MessageSender]]  ;
    cell.dateLbl.text = [UtilityClass formatDateFromString:[NSString stringWithFormat:@"%@",[[messagesArray objectAtIndex:indexPath.row] valueForKey:kMessagesAPI_MessageTime]]]  ;
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new] ;
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:18.0/255.0f green:89.0/255.0f blue:23.0/255.0f alpha:1] icon:[UIImage imageNamed:FORUM_ARCHIVE_IMAGE]] ;
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:197.0/255.0f green:4.0/255.0f blue:25.0/255.0f alpha:1] icon:[UIImage imageNamed:FORUM_DELETE_IMAGE]] ;
    cell.rightUtilityButtons = rightUtilityButtons ;
    cell.delegate = self ;
    
    
    
    cell.layer.borderColor=[[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
    cell.layer.borderWidth=1.0;
}


#pragma mark - SWRevealTableViewCell Delegate Methods
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    /*if(index == 0){ // archive
        
    }
    else{} //delete
    NSIndexPath *cellIndexPath = [messageTblView indexPathForCell:cell];
    
    [messagesArray removeObjectAtIndex:cellIndexPath.row];
    [messageTblView deleteRowsAtIndexPaths:@[cellIndexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];*/
    
    NSIndexPath *cellIndexPath = [self.messageTblView indexPathForCell:cell];
    
    NSString *message ;
    if(index == 0){
        message = [NSString stringWithFormat:@"%@archive this message?",kAlert_StartTeam] ;
    }
    else{
        message = [NSString stringWithFormat:@"%@delete this message?",kAlert_StartTeam] ;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        //[self updateTeamMemberStatusWithStatus:isSuspended withIndexPath:cellIndexPath] ;
       /* [messagesArray removeObjectAtIndex:cellIndexPath.row];
        [messageTblView deleteRowsAtIndexPaths:@[cellIndexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];*/
        [self archiveDeleteMessagewithCellIndexPath:cellIndexPath withActionType:index] ;
        
    }];
    UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.messageTblView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationRight] ;
    }];
    
    [alertController addAction:yes];
    [alertController addAction:no];
    
    [self presentViewController:alertController animated:YES completion:nil] ;
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
