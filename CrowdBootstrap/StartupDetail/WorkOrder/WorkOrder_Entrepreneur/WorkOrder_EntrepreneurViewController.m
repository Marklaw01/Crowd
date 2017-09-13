//
//  WorkOrder_EntrepreneurViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 11/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "WorkOrder_EntrepreneurViewController.h"
#import "MessagesTableViewCell.h"
#import "WorkOrderDetailViewController.h"

@interface WorkOrder_EntrepreneurViewController ()

@end

@implementation WorkOrder_EntrepreneurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self resetUISettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings {
    workOrdersArray = [[NSMutableArray alloc] init] ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblView.hidden = YES ;
    downloadWorkOrderButton.hidden = YES ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startupWorkOrderDataNotification:)
                                                 name:kNotificationStartupWorkOrderEnt
                                               object:nil];
}

#pragma mark - Notifcation Methods
- (void)startupWorkOrderDataNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationStartupWorkOrderEnt]){
        
         [self getWorkOrdersData] ;
    }
}

#pragma mark - Api Methods
-(void)getWorkOrdersData {
    
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kStartupWorkOrderAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:kStartupWorkOrderAPI_StartupID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getStartupWorkOrderEntrepreneurWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                if([responseDict valueForKey:@"approvalList"]){
                    [workOrdersArray removeAllObjects] ;
                    workOrdersArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict valueForKey:@"approvalList"]] ;
                    
                    [tblView reloadData] ;
                    
                    if(workOrdersArray.count == 0){
                        tblView.hidden = YES ;
                        downloadWorkOrderButton.hidden = YES ;
                    }
                    else{
                        tblView.hidden = NO ;
                        downloadWorkOrderButton.hidden = NO ;
                    }
                }
            }
           // else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)updateWorkOrderStatusWithStatus:(NSString*)status withIndexPath:(NSIndexPath*)cellIndexPath {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[workOrdersArray objectAtIndex:cellIndexPath.row] valueForKey:kStartupWorkOrderAPI_UserID]] forKey:kStartupWorkOrderAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[workOrdersArray objectAtIndex:cellIndexPath.row] valueForKey:kStartupWorkorderAPI_WeekNo]] forKey:kStartupWorkorderAPI_WeekNo] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:kStartupWorkOrderAPI_StartupID] ;

        NSLog(@"dictParam: %@",dictParam) ;
        if ([status isEqualToString:@"1"]) {
            [ApiCrowdBootstrap updateStartupWorkOrderStatusAcceptedWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"respos %@",responseDict) ;
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                    
                    [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
                    [self getWorkOrdersData] ;

//                    [workOrdersArray removeObjectAtIndex:cellIndexPath.row] ;
//                    [tblView deleteRowsAtIndexPaths:@[cellIndexPath]
//                                   withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }
                else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                
            } failure:^(NSError *error) {
                [UtilityClass displayAlertMessage:error.description] ;
                [UtilityClass hideHud] ;
            }] ;
        } else if ([status isEqualToString:@"0"]) {
            [ApiCrowdBootstrap updateStartupWorkOrderStatusRejectedWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"respos %@",responseDict) ;
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                    
                    [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
                    
                    [workOrdersArray removeObjectAtIndex:cellIndexPath.row] ;
                    [tblView deleteRowsAtIndexPaths:@[cellIndexPath]
                                   withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }
                else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                
            } failure:^(NSError *error) {
                [UtilityClass displayAlertMessage:error.description] ;
                [UtilityClass hideHud] ;
            }] ;
        }
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return workOrdersArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //SWTableViewCell *cell = (SWTableViewCell*)[tableView dequeueReusableCellWithIdentifier:WORK_ORDER_CELL_IDENTIFER] ;
    MessagesTableViewCell *cell = (MessagesTableViewCell*)[tblView dequeueReusableCellWithIdentifier:WORK_ORDER_CELL_IDENTIFER] ;
    NSString *firstName = [[workOrdersArray objectAtIndex:indexPath.row] valueForKey:kStartupWorkOrderAPI_MemberFirstName];
    NSString *lastName = [[workOrdersArray objectAtIndex:indexPath.row] valueForKey:kStartupWorkOrderAPI_MemberLastName];
    
    cell.messageLbl.text = [NSString stringWithFormat:@"%@ %@",firstName, lastName] ;
    cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[workOrdersArray objectAtIndex:indexPath.row] valueForKey:kStartupWorkOrderAPI_Date]] ;
    cell.workUnitsLbl.text = [NSString stringWithFormat:@"%@",[[workOrdersArray objectAtIndex:indexPath.row] valueForKey:kStartupWorkOrderAPI_WorkUnits]] ;
    
    NSNumber *status = [[workOrdersArray objectAtIndex:indexPath.row] valueForKey:@"status"];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new] ;
    
    if ([status isEqual:@(1)]) {
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:18.0/255.0f green:89.0/255.0f blue:23.0/255.0f alpha:1] icon:[UIImage imageNamed:WORK_ORDER_ACCEPT_ICON]] ;
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:197.0/255.0f green:4.0/255.0f blue:25.0/255.0f alpha:1] icon:[UIImage imageNamed:WORK_ORDER_REJECT_ICON]] ;
        
        cell.rightUtilityButtons = rightUtilityButtons ;
    }
    
    cell.delegate = self ;
    return cell ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Save IDs in a dictionary
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    
    NSString *startupID = [[workOrdersArray objectAtIndex:indexPath.row] valueForKey:kStartupWorkOrderAPI_StartupID];
    [dictParam setObject:startupID forKey:kStartupWorkOrderAPI_StartupID];

    NSString *startupTeamID = [[workOrdersArray objectAtIndex:indexPath.row] valueForKey:kStartupWorkOrderAPI_StartupTeamID];
    [dictParam setObject:startupTeamID forKey:kStartupWorkOrderAPI_StartupTeamID];
    
    NSString *contractorID = [[workOrdersArray objectAtIndex:indexPath.row] valueForKey:kStartupWorkOrderAPI_ContractorID];
    [dictParam setObject:contractorID forKey:kStartupWorkOrderAPI_ContractorID];
    
    NSString *entrepreneurID = [NSString stringWithFormat:@"%d", [UtilityClass getLoggedInUserID]];
    [dictParam setObject:entrepreneurID forKey:kStartupWorkOrderAPI_EntrepreneurID];
    
    NSString *weekNumber = [[workOrdersArray objectAtIndex:indexPath.row] valueForKey:kStartupWorkorderAPI_WeekNo];
    [dictParam setObject:weekNumber forKey:kStartupWorkorderAPI_WeekNo];

    NSLog(@"dictparam: %@", dictParam);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WorkOrderDetailViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kStartupWorkOrderDetailEntIdentifier] ;
    viewController.dictionaryIDs = dictParam;
    
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:kNotificationStartupWorkOrderDetailEnt
//     object:dictParam];

    [self.navigationController pushViewController:viewController animated:YES] ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40 ;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [tableView dequeueReusableCellWithIdentifier:HEADER_CELL_IDENTIFIER] ;
    return headerView ;
}

#pragma mark - SWRevealTableViewCell Delegate Methods
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [tblView indexPathForCell:cell];
   
    NSString *message = (index == 0 ? WORK_ORDER_ACCEPT_TEXT:WORK_ORDER_REJECT_TEXT) ;
   
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@%@ this contractor ?",kAlert_StartTeam,message] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        NSString *isAccepted = (index == 0 ? [NSString stringWithFormat:@"%d",WORKORDER_ACCEPT_STATUS]:[NSString stringWithFormat:@"%d",WORKORDER_DECLINE_STATUS]) ;
        [self updateWorkOrderStatusWithStatus:isAccepted withIndexPath:cellIndexPath] ;
    }];
    UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [tblView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationRight] ;
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
