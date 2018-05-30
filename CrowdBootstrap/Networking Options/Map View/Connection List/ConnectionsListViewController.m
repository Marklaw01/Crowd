//
//  ConnectionsListViewController.m
//  CrowdBootstrap
//
//  Created by osx on 20/12/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "ConnectionsListViewController.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "BusinessCardDetailViewController.h"

@interface ConnectionsListViewController ()

@end

@implementation ConnectionsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetUISettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) awakeFromNib {
    [super awakeFromNib];
    [self addObserver];
}

#pragma mark - Custom Methods
- (void) addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNotificationIconOnNavigationBar:) name:kNotificationIconOnNavigationBar
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getConnectionsNotification:) name:kNotificationSendConnections
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

-(void)getConnectionsNotification:(NSNotification *)notification {
    if ([[notification name] isEqualToString:kNotificationSendConnections]) {
        NSDictionary *dict = notification.userInfo;
        _selectedDict = dict;
    }
}

#pragma mark - Custom Methods
-(void)resetUISettings {
    
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    usersArray = [[NSMutableArray alloc] init];
    
    // Hit Service to get User's List
    [self getBusinessConnections];
}

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return usersArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_User] ;
    cell.tag = indexPath.row;
    
    cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_UserName]] ;
    cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_UserStatement]];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_UserImage]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
    
    NSString *strConnectionId = [NSString stringWithFormat:@"%@", [[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_ConnectionId]];
    if ([strConnectionId isEqualToString:@""]) {
        cell.lblStatus.text = @"Not Connected";
    } else {
        cell.lblStatus.text = @"Connected";
    }
    cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
    cell.imgView.clipsToBounds = YES;
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *strCardId = [NSString stringWithFormat:@"%@", [[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_CardId]];
    if ([strCardId isEqualToString:@""]) {
        [self presentViewController:[UtilityClass displayAlertMessage:@"No Business Card Found!!"] animated:YES completion:nil];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NetworkingOptions" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kBusinessCardDetailIdentifier] ;
        
        NSDictionary *userDict = [usersArray objectAtIndex:indexPath.row];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendCardInfo object:@"CardDetail" userInfo:userDict];
        
        [self.navigationController pushViewController:viewController animated:true];
    }
}

#pragma mark - Api Methods
-(void)getBusinessConnections {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[_selectedDict valueForKey:kBusinessAPI_Latitude]] forKey:kBusinessAPI_Latitude] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[_selectedDict valueForKey:kBusinessAPI_Longitude]] forKey:kBusinessAPI_Longitude] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getUserListWithSameLatLongWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kBusinessAPI_UserList]) {
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBusinessAPI_UserList]] ;
                    [tblView reloadData] ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                usersArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBusinessAPI_UserList]] ;
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}
@end
