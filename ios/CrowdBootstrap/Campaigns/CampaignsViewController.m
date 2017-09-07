//
//  CampaignsViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 13/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "CampaignsViewController.h"
#import "SWRevealViewController.h"
#import "CampaignsTableViewCell.h"

@interface CampaignsViewController ()

@end

@implementation CampaignsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addObserver];
    [self resetUISettings] ;
    [self setSegmentControlTitleSize] ;
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    
}

-(void)viewWillAppear:(BOOL)animated{
    if(campaignsArray) [campaignsArray removeAllObjects] ;
    else campaignsArray = [[NSMutableArray alloc] init] ;
    campaignsTblView.hidden = YES ;
    pageNo = 1 ;
    totalItems = 0 ;
    [self getCampaignsList] ;
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
   
    selectedCampaignType = RECOMMENDED_SELECTED ;
    originalTblViewHeight = campaignsTblView.frame.size.height ;
    campaignsTblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    campaignsTblView.hidden = YES ;
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    [formatter setGroupingSeparator:@","] ;
    [formatter setGroupingSize:3] ;
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
}

-(void)navigationBarSettings{
    self.navigationItem.hidesBackButton = YES ;
    self.title = @"Campaigns" ;
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

-(void)setSegmentControlTitleSize{
    UIFont *font = [UIFont boldSystemFontOfSize:9.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segmentedControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
}

#pragma mark - API Methods
-(void)getCampaignsList{
    if([UtilityClass checkInternetConnection]){
        
        if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCampaignsAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kCampaignsAPI_PageNo] ;
        [dictParam setObject:[NSString stringWithFormat:@"%ld",(long)segmentedControl.selectedSegmentIndex] forKey:kCampaignsAPI_CampaignType] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getCampaignsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
             NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
               
                if([responseDict valueForKey:kCampaignsAPI_Campaigns]){
                    totalItems = [[responseDict valueForKey:kCampaignsAPI_TotalItems] intValue] ;
                    //campaignsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCampaignsAPI_Campaigns]] ;
                    for (NSDictionary *dict in (NSArray*)[responseDict valueForKey:kCampaignsAPI_Campaigns]) {
                        [campaignsArray addObject:dict] ;
                    }
                    [campaignsTblView reloadData] ;
                    if(campaignsArray.count <1)[campaignsTblView setHidden:YES] ;
                    else [campaignsTblView setHidden:NO] ;
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

-(void)deleteCampaignWithCampaignId:(NSString*)campaignID withCellIndexPath:(NSIndexPath*)cellIndexPath {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_DeleteCampaign] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:campaignID forKey:kCampaignsAPI_CampaignID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap deleteCampaignWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
                
                if([campaignsArray objectAtIndex:cellIndexPath.row]){
                    [campaignsArray removeObjectAtIndex:cellIndexPath.row];
                    totalItems=totalItems-1 ;
                    [campaignsTblView reloadData] ;
                    
                    if(campaignsArray.count <1)[campaignsTblView setHidden:YES] ;
                    else [campaignsTblView setHidden:NO] ;
                    
                    /*[campaignsTblView deleteRowsAtIndexPaths:@[cellIndexPath ]
                                            withRowAnimation:UITableViewRowAnimationAutomatic];*/
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
- (IBAction)segControl_ValueChanged:(UISegmentedControl*)segmentControl {
    selectedCampaignType = (int)segmentControl.selectedSegmentIndex ;
    if(segmentControl.selectedSegmentIndex == MY_CAMPAIGNS_SELECTED)addCampaignBtn.hidden = NO ;
    else addCampaignBtn.hidden = YES ;
    /*if(segmentControl.selectedSegmentIndex == MY_CAMPAIGNS_SELECTED)[campaignsTblView setFrame:CGRectMake(campaignsTblView.frame.origin.x, campaignsTblView.frame.origin.y, campaignsTblView.frame.size.width, originalTblViewHeight)] ;
    else{
        [campaignsTblView setFrame:CGRectMake(campaignsTblView.frame.origin.x, campaignsTblView.frame.origin.y, campaignsTblView.frame.size.width, originalTblViewHeight+addCampaignBtn.frame.size.height+10)] ;
    }*/
    pageNo = 1 ;
    totalItems = 0 ;
    [campaignsArray removeAllObjects] ;
    [self getCampaignsList] ;
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    
}

- (IBAction)AddCampaign_ClickAction:(id)sender {
    [UtilityClass setAddCampaignMode:YES] ;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kAddCampaignIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)DeleteCampaign_ClickAction:(id)sender {
    
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    
    [self deleteCampaignWithCampaignId:[NSString stringWithFormat:@"%@",[[campaignsArray objectAtIndex:[sender tag]] valueForKey:kCampaignsAPI_CampaignID]] withCellIndexPath:cellIndexPath] ;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(campaignsArray.count == totalItems) return campaignsArray.count ;
    else return campaignsArray.count+1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == campaignsArray.count){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
        [activityIndicator startAnimating];
        return cell ;
    }
    else{
        CampaignsTableViewCell *cell = (CampaignsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"campaignsCell"] ;
        cell.campaignNameLbl.text = [NSString stringWithFormat:@"%@",[[campaignsArray objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_CampaignName]] ;
        cell.startupNameLbl.text = [NSString stringWithFormat:@"%@",[[campaignsArray objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_StartupName]];
        cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[campaignsArray objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_Description]];
        cell.dueDateLbl.text = [NSString stringWithFormat:@"Due Date - %@",[[campaignsArray objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_DueDate]];
        float targetAmount = [[[campaignsArray objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_TargetAmount] floatValue] ;
        cell.targetAmountLbl.text = [NSString stringWithFormat:@"Target Amount $%@",[formatter stringFromNumber:[NSNumber numberWithDouble:targetAmount]]] ;
        float fundRaised = [[[campaignsArray objectAtIndex:indexPath.row] valueForKey:kCampaignsAPI_FundRaised] floatValue] ;
        cell.fundsRaisedLbl.text = [NSString stringWithFormat:@"Fund Raised So Far: $%@",[formatter stringFromNumber:[NSNumber numberWithDouble:fundRaised]]] ;
        if(segmentedControl.selectedSegmentIndex == MY_CAMPAIGNS_SELECTED) cell.deleteButton.hidden = NO ;
        else cell.deleteButton.hidden = YES ;
        cell.deleteButton.tag = indexPath.row ;
       
        return cell ;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == campaignsArray.count) return 30 ;
    else return 180 ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == campaignsArray.count){
        [self getCampaignsList] ;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row != campaignsArray.count) {
        NSString *viewIdentifier = kCampaignDetailIdentifier ;
         if(selectedCampaignType == MY_CAMPAIGNS_SELECTED) {
             viewIdentifier = kEditCampaignViewIdentifier ;
             [UtilityClass setCampaignMode:YES] ;
         }
         else {
             viewIdentifier = kCampaignDetailIdentifier ;
             [UtilityClass setCampaignMode:NO] ;
         }
        
        [UtilityClass setCampaignDetails:(NSMutableDictionary*)[campaignsArray objectAtIndex:indexPath.row]] ;
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
