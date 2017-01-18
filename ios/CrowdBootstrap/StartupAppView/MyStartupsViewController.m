//
//  MyStartupsViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 23/08/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "MyStartupsViewController.h"
#import "SWRevealViewController.h"
#import "SearchStartupTableViewCell.h"

@interface MyStartupsViewController ()

@end

@implementation MyStartupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(void)resetUISettings{
    startupsArray = [[NSMutableArray alloc] init] ;
    tblView.hidden = YES ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    pageNo = 1 ;
    totalItems = 0 ;
    
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    [self getMyStartupsList] ;
}

-(void)navigationBarSettings {
    self.navigationItem.hidesBackButton = YES ;
    self.title = @"" ;
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

#pragma mark - Public Methods
-(void)getMyStartupListForType:(BOOL)isUploadApp{
    
    self.title = (isUploadApp == YES?@"Upload Application":@"Upload Profile") ;
    isUploadAppSelected = isUploadApp ;
}

#pragma mark - API Methods
-(void)getMyStartupsList{
    if([UtilityClass checkInternetConnection]){
        
        if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupsAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",MY_STARTUPS_SELECTED] forKey:kStartupsAPI_StartupType] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kStartupsAPI_PageNo] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getStartupsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kStartupsAPI_Startups]){
                    totalItems = [[responseDict valueForKey:kStartupsAPI_TotalItems] intValue] ;
                    for (NSDictionary *dict in (NSArray*)[responseDict valueForKey:kStartupsAPI_Startups]) {
                        [startupsArray addObject:dict] ;
                    }
                    [tblView reloadData] ;
                    if(startupsArray.count <1)[tblView setHidden:YES] ;
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

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(startupsArray.count == totalItems) return startupsArray.count ;
    else return startupsArray.count+1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == startupsArray.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
        [activityIndicator startAnimating];
        return cell ;
    }
    else{
        SearchStartupTableViewCell *cell = (SearchStartupTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_StartupsList] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.startupNameLbl.text = [NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_StartupName]] ;
        cell.entrepreneurNameLbl.text = [NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_EntrepreneurName]] ;
        cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[startupsArray objectAtIndex:indexPath.row] valueForKey:kStartupsAPI_StartupDesc]] ;
        
        return cell ;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == startupsArray.count) return 30 ;
    else return 100 ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == startupsArray.count){
        [self getMyStartupsList] ;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != startupsArray.count){
        [UtilityClass setStartupType:MY_STARTUPS_SELECTED] ;
        [UtilityClass setStartupDetails:(NSMutableDictionary*)[startupsArray objectAtIndex:indexPath.row]] ;
        
        NSString *viewIdentifier = (isUploadAppSelected == YES?kSubmitAppViewIdentifier:kStartupProfileViewIdentifier) ;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:viewIdentifier] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
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
