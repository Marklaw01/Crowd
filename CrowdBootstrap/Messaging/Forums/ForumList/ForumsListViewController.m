//
//  ForumsListViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 15/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "ForumsListViewController.h"
#import "SWTableViewCell.h"
#import "MessagesTableViewCell.h"

@interface ForumsListViewController ()

@end

@implementation ForumsListViewController

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
-(void)resetUISettings{
    
    if(self.startupDict)self.title = [NSString stringWithFormat:@"%@",[self.startupDict valueForKey:kForumStartupsAPI_StartupName] ];
    tblView.hidden = YES ;
    forumsArray = [[NSMutableArray alloc] init] ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    pageNo = 1 ;
    totalItems = 0 ;
    
    [self getStartupForums] ;
}

#pragma mark - IBAction Methdos
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

#pragma mark - API Methods
-(void)getStartupForums{
    if([UtilityClass checkInternetConnection]){
        
        if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%@",[self.startupDict valueForKey:kForumStartupsAPI_StartupID]] forKey:kForumsAPI_StartupID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kForumsAPI_PageNo] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getStartupForumsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                if([responseDict valueForKey:kMyForumAPI_Forums]){
                    totalItems = [[responseDict valueForKey:kMyForumAPI_TotalItems] intValue] ;
                    forumsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kMyForumAPI_Forums]] ;
                    [tblView reloadData] ;
                    if(forumsArray.count <1)[tblView setHidden:YES] ;
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
    if(forumsArray.count == totalItems) return forumsArray.count ;
    else return forumsArray.count+1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == forumsArray.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
        [activityIndicator startAnimating];
        return cell ;
    }
    else{
        MessagesTableViewCell *cell = (MessagesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ForumList] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        cell.messageLbl.text = [NSString stringWithFormat:@"%@",[[forumsArray objectAtIndex:indexPath.row] valueForKey:kMyForumAPI_ForumTitle]] ;
        cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[forumsArray objectAtIndex:indexPath.row] valueForKey:kMyForumAPI_ForumDesc]] ;
        cell.timeLbl.text = [UtilityClass formatDateFromString:[NSString stringWithFormat:@"%@",[[forumsArray objectAtIndex:indexPath.row] valueForKey:kMyForumAPI_ForumCreatedTime]]]  ;
        return cell ;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == forumsArray.count) return 30 ;
    else return 90 ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == forumsArray.count){
        [self getStartupForums] ;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == forumsArray.count) return ;
    [UtilityClass setForumType:NO] ;
    [UtilityClass setForumDetails:(NSMutableDictionary*)[forumsArray objectAtIndex:indexPath.row]] ;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kForumDetailIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

#pragma mark - SWRevealTableViewCell Delegate Methods
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [tblView indexPathForCell:cell];
    
    [forumsArray removeObjectAtIndex:cellIndexPath.row];
    [tblView deleteRowsAtIndexPaths:@[cellIndexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
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
