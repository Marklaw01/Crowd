//
//  ManageNotesViewController.m
//  CrowdBootstrap
//
//  Created by Shikha on 10/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "ManageNotesViewController.h"
#import "UserFundTableViewCell.h"

@interface ManageNotesViewController ()

@end

@implementation ManageNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    notesArray = [[NSMutableArray alloc] init];
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    totalItems = 0 ;
    pageNo = 1;
    [self getBusinessCardNotesList];

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
    
    if(notesArray.count == totalItems)
        return notesArray.count ;
    else
        return notesArray.count+1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    if(indexPath.row == notesArray.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
        [activityIndicator startAnimating];
        return cell ;
    }
    else {
        UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Note] ;
        cell.lblName.text = [NSString stringWithFormat:@"Note %ld",indexPath.row+1];
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[notesArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_NoteDesc]];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NetworkingOptions" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kBusinessCardDetailIdentifier] ;
    
    NSDictionary *notesDict = [[NSDictionary alloc] init];
    notesDict = [notesArray objectAtIndex:indexPath.row];

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendNotesInfo object:@"NotesDetail" userInfo:notesDict];
    
    [self.navigationController pushViewController:viewController animated:true];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == notesArray.count) {
        [self getBusinessCardNotesList] ;
    }
}

#pragma mark - Api Methods
-(void)getBusinessCardNotesList {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;

        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        if ([_selectedCardId isEqualToString:@""] || _selectedCardId == nil) {
            [dictParam setObject:@"" forKey:kBusinessAPI_CardId] ;
        } else {
            [dictParam setObject:_selectedCardId forKey:kBusinessAPI_CardId] ;
        }
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kBusinessAPI_PageNo] ;

        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getBusinessCardNotesListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kBusinessAPI_CardList]) {
                    totalItems = [[responseDict valueForKey:kBusinessAPI_TotalItems] integerValue] ;
                    
                    if (notesArray.count >= totalItems) {
                        [notesArray removeAllObjects];
                        [notesArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBusinessAPI_CardList]] ;
                    } else {
                        [notesArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBusinessAPI_CardList]] ;
                    }
                    
//                    [notesArray removeAllObjects];
//
//                    [notesArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBusinessAPI_CardList]] ;
                    lblNoNotesAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;

                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kBusinessAPI_CardList]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoNotesAvailable.hidden = false;
                
                notesArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBusinessAPI_CardList]] ;
                totalItems = 0;

                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = notesArray.count;

            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

@end
