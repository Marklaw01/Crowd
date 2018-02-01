//
//  ManageGroupsViewController.m
//  CrowdBootstrap
//
//  Created by Shikha on 09/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "ManageGroupsViewController.h"

@interface ManageGroupsViewController ()

@end

@implementation ManageGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];

    groupArray = [[NSMutableArray alloc] init];
    
    [self getBusinessConnectionTypeList];
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

#pragma mark - Cell Delegate Methods
- (void)saveGroupName:(NSString *)text tag:(NSInteger)tag {
    NSMutableDictionary *dictGroup = [[NSMutableDictionary alloc] init];
    [dictGroup addEntriesFromDictionary:groupArray[tag]];
    [dictGroup setValue:text forKey:kBusinessAPI_Name];

    groupArray[tag] = dictGroup;
    NSLog(@"Group Array: %@", groupArray);
}

- (void)saveGroupDesc:(NSString *)text tag:(NSInteger)tag {
    NSMutableDictionary *dictGroup = [[NSMutableDictionary alloc] init];
    [dictGroup addEntriesFromDictionary:groupArray[tag]];
    [dictGroup setObject:text forKey:kBusinessAPI_Description];
    groupArray[tag] = dictGroup;

    NSLog(@"Group Array: %@", groupArray);
}

- (void)deleteGroup:(NSInteger)tag {
    NSMutableDictionary *dict = [groupArray objectAtIndex:tag];
    if (dict == nil) {
        [groupArray removeObjectAtIndex:tag];
        [tblViewGroups beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
        [tblViewGroups deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tblViewGroups endUpdates];
        
        [tblViewGroups reloadData];
    } else {
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure you want to delete this group?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [groupArray removeObjectAtIndex:tag];
            [tblViewGroups beginUpdates];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
            [tblViewGroups deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tblViewGroups endUpdates];
            
            [tblViewGroups reloadData];
        }];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertcontroller addAction:yesAction];
        [alertcontroller addAction:noAction];
        
        [self presentViewController: alertcontroller animated: YES completion: nil];
    }
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

- (IBAction)btnAddGroupClicked:(id)sender {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [groupArray addObject:dict];
    NSLog(@"Group Array Count: %lu", (unsigned long)groupArray.count);
    
    [tblViewGroups beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:groupArray.count-1 inSection:0];
    
    [tblViewGroups insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [tblViewGroups reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tblViewGroups endUpdates];
}

- (IBAction)btnSaveClicked:(id)sender {
    
    [self.view endEditing:true];
    
    NSLog(@"Group Array: %@", groupArray);

    // update Key "id" as an auto increment in group array
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i =0; i< groupArray.count; i++) {
        NSMutableDictionary *dictGroup = [[NSMutableDictionary alloc] init];
        [dictGroup addEntriesFromDictionary:groupArray[i]];

        NSArray *keys = [dictGroup allKeys];
        for (int j = 0 ; j < [keys count]; j++)
        {
            if ([keys containsObject:@"id"]) {
                if ([keys[j] isEqualToString:@"id"])
                    [dictGroup setValue:[NSNumber numberWithInt:i+1] forKey:keys[j]];
            } else {
                [dictGroup setValue:[NSNumber numberWithInt:i+1] forKey:@"id"];
            }
        }
        [arr addObject:dictGroup];
    }
    NSLog(@"Group Data: %@", arr);
    
    //Hit API to save groups
    [self addBusinessUserGroup:arr];
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return groupArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    
    GroupTableViewCell *cell = (GroupTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Group] ;
    
    cell.delegate = self;
    cell.txtGroupName.tag = indexPath.row;
    cell.txtVwGroupDesc.tag = indexPath.row;
    cell.btnDelete.tag = indexPath.row;
    
    cell.txtGroupName.text = [groupArray[indexPath.row] valueForKey:kBusinessAPI_Name];
    cell.txtVwGroupDesc.text = [groupArray[indexPath.row] valueForKey:kBusinessAPI_Description];
    
    if([cell.txtVwGroupDesc.text isEqualToString:@""]) {
        cell.txtVwGroupDesc.text = @"Group Description" ;
        cell.txtVwGroupDesc.textColor = [UIColor lightGrayColor] ;
    }
    
    return cell;
}

#pragma mark - API Methods
-(void)getBusinessConnectionTypeList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getBusinessConnectionTypeListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kBusinessAPI_ConnectionType]) {
                    [groupArray removeAllObjects];
                    
                    [groupArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBusinessAPI_ConnectionType]] ;
                }
                
                [tblViewGroups reloadData];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                
                groupArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBusinessAPI_ConnectionType]] ;
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

- (void)addBusinessUserGroup:(NSMutableArray *)groupData {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        [dictParam setObject:groupData forKey:kBusinessAPI_GroupData] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap addBusinessUserGroupWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                [self presentViewController:[UtilityClass displayAlertMessage:@"Successfully saved."] animated:YES completion:nil];
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
