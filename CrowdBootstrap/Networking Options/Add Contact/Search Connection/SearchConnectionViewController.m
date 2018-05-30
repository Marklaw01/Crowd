//
//  SearchConnectionViewController.m
//  CrowdBootstrap
//
//  Created by Shikha on 07/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "SearchConnectionViewController.h"
#import "UIImageView+WebCache.h"
#import "UserFundTableViewCell.h"
#import "BusinessCardDetailViewController.h"

@interface SearchConnectionViewController ()

@end

@implementation SearchConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetUISettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    pageNo = 1;
}

#pragma mark - Custom Methods
-(void)resetUISettings {
    
    // Set previous selected Search Text
    if ([kUSERDEFAULTS valueForKey:@"SearchText"] != nil)
        searchedString = [kUSERDEFAULTS valueForKey:@"SearchText"];
    else
        searchedString = @""  ;
    
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    usersArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init] ;
    
    pageNo = 1;
    totalItems = 0 ;
    
    [self configureSearchController];
    
    // Hit Service to get User's List
    [self searchBusinessConnection:searchedString];
}

-(void)configureSearchController {
    userSearchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    userSearchController.searchBar.placeholder = kSearchUserPlaceholder ;
    [userSearchController.searchBar sizeToFit] ;
    userSearchController.searchBar.text = searchedString;
    userSearchController.searchResultsUpdater = self ;
    userSearchController.dimsBackgroundDuringPresentation = NO ;
    userSearchController.definesPresentationContext = YES ;
    userSearchController.hidesNavigationBarDuringPresentation = NO ;
    self.definesPresentationContext = YES ;
    tblView.tableHeaderView = userSearchController.searchBar ;
    userSearchController.searchBar.delegate = self ;
}

#pragma mark - Search Controller Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchedString = searchController.searchBar.text ;
    
    if(searchedString.length < 1 || [searchedString isEqualToString:@" "])
        return ;
    
    pageNo = 1 ;
    totalItems = 0 ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [tblView reloadData] ;
    
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    // Hit Service to get User's List
    [self searchBusinessConnection:searchedString];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchedString = @"" ;
    pageNo = 1 ;
    totalItems = 0 ;
    [usersArray removeAllObjects] ;
    [searchResults removeAllObjects] ;
    [userSearchController setActive:NO] ;
    
    [self.navigationController.navigationBar setHidden:false];
    [kUSERDEFAULTS setValue:searchedString forKey:@"SearchText"];
    [kUSERDEFAULTS synchronize];
    
    // Hit Service to get User's List
    [self searchBusinessConnection:searchedString];
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (userSearchController.active && ![userSearchController.searchBar.text isEqualToString:@""])
        return searchResults.count ;
    else {
        if(usersArray.count == totalItems)
            return usersArray.count ;
        else
            return usersArray.count+1 ;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    if (userSearchController.active && ![userSearchController.searchBar.text isEqualToString:@""]) {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_User] ;
        cell.tag = indexPath.row;

        cell.lblName.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_Name]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_Bio]];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResults objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_UserImage]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
        
        NSString *strConnectStatus = [[searchResults objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_ConnectionStatus];
        if ([strConnectStatus isEqualToString:@""]) {
            cell.lblStatus.text = @"Not Connected";
        } else {
            cell.lblStatus.text = @"Connected";
        }
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
        cell.imgView.clipsToBounds = YES;
        
        return cell;
    } else {
        if(indexPath.row == usersArray.count) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
            [activityIndicator startAnimating];
            return cell ;
        } else {
            UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_User] ;
            cell.tag = indexPath.row;
            
            cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_Name]] ;
            cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_Bio]];
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_UserImage]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            
            NSString *strConnectStatus = [NSString stringWithFormat:@"%@", [[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_ConnectionStatus]];
            if ([strConnectStatus isEqualToString:@""]) {
                cell.lblStatus.text = @"Not Connected";
            } else {
                cell.lblStatus.text = @"Connected";
            }
            cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
            cell.imgView.clipsToBounds = YES;
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *userDict = [[NSDictionary alloc] init];
    NSString *strConnectStatus;
    
    if (userSearchController.active && ![userSearchController.searchBar.text isEqualToString:@""]) {
        userDict = [searchResults objectAtIndex:indexPath.row];
        strConnectStatus = [NSString stringWithFormat:@"%@", [[searchResults objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_CardId]];

    } else {
        userDict = [usersArray objectAtIndex:indexPath.row];
        strConnectStatus = [NSString stringWithFormat:@"%@", [[usersArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_CardId]];
    }

    if ([strConnectStatus isEqualToString:@""]) {
        [self presentViewController:[UtilityClass displayAlertMessage:@"No Business Card Found!!"] animated:YES completion:nil];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NetworkingOptions" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kBusinessCardDetailIdentifier] ;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendUserInfo object:@"UserDetail" userInfo:userDict];
        
        [self.navigationController pushViewController:viewController animated:true];
    }
}

#pragma mark - Api Methods
-(void)searchBusinessConnection:(NSString *)searchText {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kBusinessAPI_PageNo] ;
        [dictParam setObject:searchText forKey:kBusinessAPI_SearchText] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap searchBusinessConnectionWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kBusinessAPI_ConnectionList]) {
                    totalItems = [[responseDict valueForKey:kBusinessAPI_TotalItems] integerValue] ;
                    [searchResults removeAllObjects];
                    [usersArray removeAllObjects];
                    
                    if(userSearchController.active && ![userSearchController.searchBar.text isEqualToString:@""]){
                        searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBusinessAPI_ConnectionList]] ;
                    }
                    else {
                        [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBusinessAPI_ConnectionList]] ;
                    }
                    lblNoUsersAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kBusinessAPI_ConnectionList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoUsersAvailable.hidden = false;
                if(userSearchController.active && ![userSearchController.searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBusinessAPI_ConnectionList]] ;
                }
                else {
                    usersArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBusinessAPI_ConnectionList]] ;
                }
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = usersArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}
@end
