//
//  AchievementAwardViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 20/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "AchievementAwardViewController.h"
#import "AwardTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface AchievementAwardViewController ()

@end

@implementation AchievementAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self resetUISettings] ;
}

-(void)viewWillAppear:(BOOL)animated{
    if(reviewsArray)[reviewsArray removeAllObjects] ;
    [self getUserRatingsList] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    self.title = @"Excellence Award" ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblView.hidden = YES ;
    reviewsArray = [[NSMutableArray alloc] init] ;
    
    if([UtilityClass getProfileMode] == PROFILE_MODE_TEAM) rateButton.hidden = NO ;
    else rateButton.hidden = YES ;
    
    [self getUserRatingsList] ;
}

#pragma mark - API Methods
-(void)getUserRatingsList{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        if([UtilityClass getProfileMode] == PROFILE_MODE_RECOMMENDED || [UtilityClass getProfileMode] == PROFILE_MODE_SEARCH || [UtilityClass getProfileMode] == PROFILE_MODE_TEAM)[dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getContractorDetails] valueForKey:kRecommendedContAPI_ContractorID]] forKey:kRatingsAPI_UserID] ;
        else [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kRatingsAPI_UserID] ;
        NSString *userType = ([UtilityClass GetUserType] == ENTREPRENEUR ? ENTREPRENEUR_TEXT : CONTRACTOR_TEXT) ;
        [dictParam setObject:userType forKey:kRatingsAPI_UserType] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getUserRatingsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kRatingsAPI_Ratings]){
                    reviewsArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict valueForKey:kRatingsAPI_Ratings]] ;
                    [tblView reloadData] ;
                    if(reviewsArray.count <1)[tblView setHidden:YES] ;
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

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)Rate_ClickAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kRateViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}


#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return reviewsArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AwardTableViewCell *cell = (AwardTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Review] ;
    cell.userNameLbl.text = [NSString stringWithFormat:@"%@",[[reviewsArray objectAtIndex:indexPath.row] valueForKey:kRatingsAPI_GivenbyName]] ;
    cell.reviewLbl.text = [NSString stringWithFormat:@"%@",[[reviewsArray objectAtIndex:indexPath.row] valueForKey:kRatingsAPI_Description]] ;
    [cell.userImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[[reviewsArray objectAtIndex:indexPath.row] valueForKey:kRatingsAPI_GivenbyImage]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
    cell.userImgView.layer.cornerRadius = 17.5;
    cell.userImgView.clipsToBounds = YES;
    NSString *ratings = [NSString stringWithFormat:@"%@",[[reviewsArray objectAtIndex:indexPath.row] valueForKey:kRatingsAPI_Rating]] ;
    if([ratings isEqualToString:@""] || [ratings isEqualToString:@" "]) cell.ratingsView.value = 0 ;
    else cell.ratingsView.value = [ratings floatValue] ;
    
    return cell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80 ;
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
