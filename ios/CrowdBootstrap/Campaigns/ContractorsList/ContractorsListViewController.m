//
//  ContractorsListViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 25/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "ContractorsListViewController.h"
#import "ContractorsCell.h"
#import "UIImageView+WebCache.h"

@interface ContractorsListViewController ()

@end

@implementation ContractorsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"getCampaignDetails: %@",[UtilityClass getCampaignDetails]) ;
    [self resetUISettings] ;
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    self.title = @"Contractors" ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblView.hidden = YES ;
    
    contractorsArry = [[NSMutableArray alloc] init] ;
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    [formatter setGroupingSeparator:@","] ;
    [formatter setGroupingSize:3] ;
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    
    [self getContractorsList] ;
}

#pragma mark - API Methods
-(void)getContractorsList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCampaignContractorAPI_UserID] ;
        [dictParam setObject:[[[UtilityClass getCampaignDetails] mutableCopy] valueForKey:kCampaignDetailAPI_CampaignID] forKey:kCampaignContractorAPI_CampaignID] ;
        [dictParam setObject:@"true" forKey:kCampaignContractorAPI_Status] ;
        
        [ApiCrowdBootstrap getCommittedContractorsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kCampaignContractorAPI_ContractorsList]){
                   contractorsArry = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCampaignContractorAPI_ContractorsList]] ;
                    [tblView reloadData] ;
                    
                    if(contractorsArry.count <1)[tblView setHidden:YES] ;
                    else [tblView setHidden:NO] ;
                }
            }
            //else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)rejectCommittedUserForCellIndexPath:(NSIndexPath*)cellIndexPath {
    
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCampaignContractorAPI_UserID] ;
        [dictParam setObject:[[[UtilityClass getCampaignDetails] mutableCopy] valueForKey:kCampaignDetailAPI_CampaignID] forKey:kCampaignContractorAPI_CampaignID] ;
        
        [ApiCrowdBootstrap rejectCommittedUserWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                [UtilityClass showNotificationMessgae:[responseDict valueForKey:@"message"] withResultType:@"1" withDuration:1] ;
                
                if([contractorsArry objectAtIndex:cellIndexPath.row]){
                    [contractorsArry removeObjectAtIndex:cellIndexPath.row];
                    [tblView reloadData] ;
                    
                    if(contractorsArry.count >0)tblView.hidden = NO ;
                    tblView.hidden = YES ;
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
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contractorsArry.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContractorsCell *cell = (ContractorsCell*)[tableView dequeueReusableCellWithIdentifier:@"contractorsCell"] ;
    cell.titleLbl.text = [NSString stringWithFormat:@"%@",[[contractorsArry objectAtIndex:indexPath.row] valueForKey:kCampaignContractorAPI_ContractorName]] ;
    if([[[contractorsArry objectAtIndex:indexPath.row] valueForKey:kCampaignContractorAPI_Status]intValue] == 0 || [[[contractorsArry objectAtIndex:indexPath.row] valueForKey:kCampaignContractorAPI_ContractorID]intValue] == [UtilityClass getLoggedInUserID] ||  [UtilityClass getCampaignMode] == YES ){
        
        float contribution = [[[contractorsArry objectAtIndex:indexPath.row] valueForKey:kCampaignContractorAPI_Contribution] floatValue] ;
        cell.timeLbl.text = [NSString stringWithFormat:@"$%@",[formatter stringFromNumber:[NSNumber numberWithDouble:contribution]]] ;
    }
    
     NSString* imgUrl = [[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[[contractorsArry objectAtIndex:indexPath.row] valueForKey:kCampaignContractorAPI_ContractorImage]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"imgUrl: %@",imgUrl) ;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"Chat_user"]] ;
    cell.imgView.layer.cornerRadius = 20;
    cell.imgView.clipsToBounds = YES;
    
    if([UtilityClass getCampaignMode] == YES){
        NSMutableArray *rightUtilityButtons = [NSMutableArray new] ;
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:197.0/255.0f green:4.0/255.0f blue:25.0/255.0f alpha:1] icon:[UIImage imageNamed:WORK_ORDER_REJECT_ICON]] ;
        cell.rightUtilityButtons = rightUtilityButtons ;
        cell.delegate = self ;

    }
    
    return cell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30 ;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [tableView dequeueReusableCellWithIdentifier:@"headerCell"] ;
    return headerView ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   /* UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;*/
}


#pragma mark - SWRevealTableViewCell Delegate Methods
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
   
    NSIndexPath *cellIndexPath = [tblView indexPathForCell:cell];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:kAlert_RejectContractorConfirmation preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self rejectCommittedUserForCellIndexPath:cellIndexPath] ;
        
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
