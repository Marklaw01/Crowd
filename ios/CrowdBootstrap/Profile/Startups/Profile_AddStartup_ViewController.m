//
//  Profile_AddStartup_ViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 28/03/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "Profile_AddStartup_ViewController.h"
#import "ProfileAddStartupTableViewCell.h"

@interface Profile_AddStartup_ViewController ()

@end

@implementation Profile_AddStartup_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self resetUISettings] ;
    [self getStartupsList] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    self.title = @"Profile" ;
    startupsArray = [[NSMutableArray alloc] init] ;
}

#pragma mark - IBAction Methods
- (IBAction)Submit_ClickAction:(id)sender {
   /* if(startupsArray.count <1) return ;
    else{
      
        }*/
    NSString *str = @"" ;
    for (NSMutableDictionary *dict in startupsArray) {
        NSString *isSelected = [dict valueForKey:kProfileUserStartupApi_StartupIsSelected] ;
        if([isSelected isEqualToString:@"true"]){
            if([str isEqualToString:@""]) str = [NSString stringWithFormat:@"%@",[dict valueForKey:kProfileUserStartupApi_StartupID]] ;
            else str = [NSString stringWithFormat:@"%@,%@",str,[NSString stringWithFormat:@"%@",[dict valueForKey:kProfileUserStartupApi_StartupID]]] ;
        }
    }
    
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileUserStartupApi_UserID] ;
        if([UtilityClass GetUserType] == CONTRACTOR)[dictParam setObject:CONTRACTOR_TEXT forKey:kProfileUserStartupApi_UserType] ;
        else [dictParam setObject:ENTREPRENEUR_TEXT forKey:kProfileUserStartupApi_UserType] ;
        [dictParam setObject:str forKey:kProfileAddStartupApi_StartupID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap addStartupsToProfileWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                //[self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kNotificationProfileUpdatedStartups
                 object:self];
                [self.navigationController popViewControllerAnimated:YES] ;
                
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}


- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)checkUncheck_ClickAction:(UIButton*)sender {
    UIButton *btn = (UIButton*)sender ;
    //if([btn backgroundImageForState:UIControlStateNormal] == checkImg)
    if([btn.accessibilityLabel isEqualToString:CHECK_IMAGE ]){ // Check
        [btn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = UNCHECK_IMAGE ;
        NSMutableDictionary *dict = [[startupsArray objectAtIndex:btn.tag] mutableCopy];
        [dict setValue:@"false" forKey:kProfileUserStartupApi_StartupIsSelected] ;
        [startupsArray replaceObjectAtIndex:btn.tag withObject:dict] ;
    }
    else{ // Uncheck
        [btn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = CHECK_IMAGE ;
        NSMutableDictionary *dict = [[startupsArray objectAtIndex:btn.tag] mutableCopy];
        [dict setValue:@"true" forKey:kProfileUserStartupApi_StartupIsSelected] ;
        [startupsArray replaceObjectAtIndex:btn.tag withObject:dict] ;
    }
}

#pragma mark - Api Methods
-(void)getStartupsList{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileUserStartupApi_UserID] ;
        if([UtilityClass GetUserType] == CONTRACTOR)[dictParam setObject:CONTRACTOR_TEXT forKey:kProfileUserStartupApi_UserType] ;
        else [dictParam setObject:ENTREPRENEUR_TEXT forKey:kProfileUserStartupApi_UserType] ;
       
        [ApiCrowdBootstrap getUserStartupsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                if([responseDict objectForKey:kProfileUserStartupApi_StartupData]){
                    startupsArray = [NSMutableArray arrayWithArray:(NSArray*)[[responseDict objectForKey:kProfileUserStartupApi_StartupData] mutableCopy]] ;
                   
                    
                    [tblView reloadData] ;
                    
                    if(startupsArray.count >0){
                        [tblView setHidden:NO] ;
                        submitButton.hidden = NO ;
                    }
                    else {
                        [tblView setHidden:YES] ;
                        submitButton.hidden = YES ;
                    }
                }
            }
            //else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return startupsArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileAddStartupTableViewCell *cell = (ProfileAddStartupTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ProfileAddStartup] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.checkboxButton.tag = indexPath.row ;
    cell.titleLbl.text = [[startupsArray objectAtIndex:indexPath.row] valueForKey:kProfileUserStartupApi_StartupName] ;
    cell.descriptionLbl.text = [[startupsArray objectAtIndex:indexPath.row] valueForKey:kProfileUserStartupApi_StartupDesc] ;
    NSString *isSelected = [[startupsArray objectAtIndex:indexPath.row] valueForKey:kProfileUserStartupApi_StartupIsSelected] ;
    if([isSelected isEqualToString:@"false"] ){
       cell.checkboxButton.accessibilityLabel = UNCHECK_IMAGE ;
       [cell.checkboxButton setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
    }
    else{
      cell.checkboxButton.accessibilityLabel = CHECK_IMAGE ;
      [cell.checkboxButton setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
    }
   
    return cell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileAddStartupTableViewCell *cell = (ProfileAddStartupTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] ;
    [self checkUncheck_ClickAction:cell.checkboxButton] ;
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
