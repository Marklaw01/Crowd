//
//  NewUsersViewController.m
//  CrowdBootstrap
//
//  Created by osx on 27/06/18.
//  Copyright © 2018 trantor.com. All rights reserved.
//

#import "NewUsersViewController.h"
#import "NewUserTableViewCell.h"
#import "AddNewUserViewController.h"
#import "UIImageView+WebCache.h"

@interface NewUsersViewController ()

@end

@implementation NewUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [self resetUISettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings {
    usersArray = [[NSMutableArray alloc] init];
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _totalItems = 0 ;
    _pageNo = 1;
    
    selectedCardIndex = -1;
    [self getNewBusinessUsers];
}

- (void)pullToRefresh {
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, 0, 0)];
    [tblView insertSubview:refreshView atIndex:0];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor redColor];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull To Refresh"];
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
    refreshControl.attributedTitle = refreshString;
    
    [refreshView addSubview:refreshControl];
}

- (void)refreshData {
    [self resetUISettings];
    isPullToRefresh = true;
    [refreshControl endRefreshing];
}

- (void)businessCardImageTappedAction {
    
    [imgViewPopup sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:selectedCardIndex] valueForKey:kBusinessAPI_UserImage]]] placeholderImage:[UIImage imageNamed:kCampainDetail_DefaultImage]] ;

    [UIView animateWithDuration:0.3/1.5 animations:^{
        viewImgPopup.hidden = false;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            viewImgPopup.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                viewImgPopup.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

#pragma mark - IBActions Methods
- (IBAction)CloseImgPopupView_ClickAction:(id)sender {
    viewImgPopup.hidden = true;
}

- (IBAction)deleteBusinessContact_Click:(id)sender {
    NSInteger tag = [sender tag];
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to delete this contact?" message:nil  preferredStyle:UIAlertControllerStyleAlert];
    [alertController.view setTintColor:[UtilityClass blueColor]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSString *contactId = [NSString stringWithFormat:@"%@", [[usersArray objectAtIndex:tag] valueForKey:@"contact_id"]];
        // Hit Api to delete the Business Contact, then hit api to get users list and reload table
        [self deleteBusinessContact:contactId];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(usersArray.count == _totalItems)
        return usersArray.count ;
    else
        return usersArray.count+1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    if(indexPath.row == usersArray.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
        [activityIndicator startAnimating];
        return cell ;
    }
    else {
        NewUserTableViewCell *cell = (NewUserTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_User] ;
        cell.btnDelete.tag = indexPath.row;

        cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_Name]] ;
        cell.lblPhone.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_Phone]] ;
        cell.lblEmail.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_Email]] ;
        cell.lblConnectionType.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_ConnType]] ;
        cell.txtVwNote.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_Note]] ;

        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_UserImage]]] placeholderImage:[UIImage imageNamed:kCampainDetail_DefaultImage]] ;

        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
        cell.imgView.clipsToBounds = YES;

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    selectedCardIndex = indexPath.row;
    [self businessCardImageTappedAction];
    [tblView deselectRowAtIndexPath:indexPath animated:NO];
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NetworkingOptions" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kAddNewUserIdentifier] ;
    
    NSDictionary *usersDict = [[NSDictionary alloc] init];
    usersDict = [usersArray objectAtIndex:indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendUserInfo object:@"usersDetail" userInfo:usersDict];
    
    [self.navigationController pushViewController:viewController animated:true];
     */
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == usersArray.count) {
        [self getNewBusinessUsers] ;
    }
}

#pragma mark - Api Methods
-(void)getNewBusinessUsers {
    if([UtilityClass checkInternetConnection]) {
        
        if(_pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",_pageNo] forKey:kBusinessAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getNewBusinessUsersWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kBusinessAPI_CardList]) {
                    _totalItems = [[responseDict valueForKey:kBusinessAPI_TotalItems] integerValue] ;
                    if (_totalItems == 0) {
                        lblNoUsersAvailable.hidden = false;
                        
                        usersArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBusinessAPI_CardList]] ;
                        [tblView reloadData] ;
                    }
                    else {
                        if (usersArray.count >= _totalItems) {
                            [usersArray removeAllObjects];
                            [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBusinessAPI_CardList]] ;
                        } else {
                            [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBusinessAPI_CardList]] ;
                        }

                        lblNoUsersAvailable.hidden = true;
                        [tblView reloadData] ;
                        _pageNo++ ;
                        
                        NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kBusinessAPI_CardList]] ;
                        NSLog(@"_totalItems: %ld count: %lu",(long)_totalItems ,(unsigned long)arr.count) ;
                    }
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoUsersAvailable.hidden = false;
                
                usersArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBusinessAPI_CardList]] ;
                _totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            _totalItems = usersArray.count;
            
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)deleteBusinessContact:(NSString *)contactId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;

        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:contactId forKey:@"contact_id"] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap deleteBusinessContactWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;

            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                _totalItems = 0;
                _pageNo = 1;
                [self getNewBusinessUsers];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

@end
