//
//  ArchivedForumsViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 16/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "ArchivedForumsViewController.h"
#import "SWRevealViewController.h"
#import "MessagesTableViewCell.h"

@interface ArchivedForumsViewController ()

@end

@implementation ArchivedForumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addObserver];
    [self resetUISettings] ;
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

-(void)resetUISettings{
    forumssArray = [[NSMutableArray alloc] init] ;
    tblView.hidden = YES ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    pageNo = 1 ;
    totalItems = 0 ;
    
    [self getArchivedForumsList] ;
}

-(void)navigationBarSettings{
    self.navigationItem.hidesBackButton = YES ;
    self.title = @"Archived Forums" ;
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

-(void)getArchivedForumsList{
    if([UtilityClass checkInternetConnection]){
        
        if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kMessagesAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kMessagesAPI_PageNo] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getArchivedForumsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kMyForumAPI_Forums]){
                    totalItems = [[responseDict valueForKey:kMyForumAPI_TotalItems] intValue] ;
                    for (NSDictionary *dict in (NSArray*)[responseDict valueForKey:kMyForumAPI_Forums]) {
                        [forumssArray addObject:dict] ;
                    }
                   // forumssArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMyForumAPI_Forums]] ;
                    [tblView reloadData] ;
                    if(forumssArray.count <1)[tblView setHidden:YES] ;
                    else [tblView setHidden:NO] ;
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

#pragma mark - IBAction Methods
- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    
}


#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(forumssArray.count == totalItems) return forumssArray.count ;
    else return forumssArray.count+1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == forumssArray.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
        [activityIndicator startAnimating];
        return cell ;
    }
    else{
        MessagesTableViewCell *cell = (MessagesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ForumList] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        cell.messageLbl.text = [NSString stringWithFormat:@"%@",[[forumssArray objectAtIndex:indexPath.row] valueForKey:kMyForumAPI_ForumTitle]] ;
        cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[forumssArray objectAtIndex:indexPath.row] valueForKey:kMyForumAPI_ForumDesc]] ;
        cell.timeLbl.text = [UtilityClass formatDateFromString:[NSString stringWithFormat:@"%@",[[forumssArray objectAtIndex:indexPath.row] valueForKey:kMyForumAPI_ForumCreatedTime]]]  ;
        
        return cell ;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == forumssArray.count) return 30 ;
    else return 90 ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == forumssArray.count){
        [self getArchivedForumsList] ;
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
