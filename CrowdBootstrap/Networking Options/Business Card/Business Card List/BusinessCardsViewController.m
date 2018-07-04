//
//  BusinessCardsViewController.m
//  CrowdBootstrap
//
//  Created by Shikha on 10/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "BusinessCardsViewController.h"
#import "UserFundTableViewCell.h"
#import "BusinessCardDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "AddBusinessCardViewController.h"

@interface BusinessCardsViewController ()

@end

@implementation BusinessCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    
    cardsArray = [[NSMutableArray alloc] init];
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedIndex = -1;
}

- (void)viewWillAppear:(BOOL)animated {
    [self getBusinessCardList];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddBusinessCardIdentifier"]) {
        AddBusinessCardViewController *viewController = segue.destinationViewController;
        viewController.strBusinessCardScreenType = @"Add";
    }
    else if ([segue.identifier isEqualToString:@"ViewBusinessCardIdentifier"]) {
        AddBusinessCardViewController *viewController = segue.destinationViewController;
        viewController.selectedCardId = [[cardsArray objectAtIndex:[sender tag]] valueForKey:kBusinessAPI_CardId];
        viewController.strBusinessCardScreenType = @"Edit";
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

- (IBAction)selectBusinessCard_Click:(id)sender {
    NSInteger tag = [sender tag];
    selectedIndex = tag;

    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Do you want to select this card as your public business card?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController.view setTintColor:[UtilityClass blueColor]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSString *cardId = [[cardsArray objectAtIndex:selectedIndex] valueForKey:kBusinessAPI_CardId];
        // Hit Api to activate the selected Business Card, then hit api to get card list and reload table
        [self activateBusinessCard: cardId];
        UserFundTableViewCell *selectedCell = [tblView cellForRowAtIndexPath:indexpath];
        [selectedCell.btnRadio setImage:[UIImage imageNamed:@"radio_fill"] forState:UIControlStateNormal];

    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)deleteBusinessCard_Click:(id)sender {
    NSInteger tag = [sender tag];
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to delete this card?" message:nil  preferredStyle:UIAlertControllerStyleAlert];
    [alertController.view setTintColor:[UtilityClass blueColor]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSString *cardId = [NSString stringWithFormat:@"%@", [[cardsArray objectAtIndex:tag] valueForKey:kBusinessAPI_CardId]];
        // Hit Api to delete the selected Business Card, then hit api to get card list and reload table
        [self deleteBusinessCard:cardId];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
    
#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cardsArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Card] ;
    
    cell.btnRadio.tag = indexPath.row;
    cell.btnDelete.tag = indexPath.row;
    cell.tag = indexPath.row;
    
    cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
    cell.imgView.clipsToBounds = YES;

    cell.lblName.text = [NSString stringWithFormat:@"Business Card %ld",indexPath.row+1];
    cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[cardsArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_UserBio]];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[cardsArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_CardImage]]] placeholderImage:[UIImage imageNamed:kImage_ProfilePicDefault]] ;

    int status = [[[cardsArray objectAtIndex:indexPath.row] valueForKey:kBusinessAPI_Status] intValue];
    if (status == 1) {
        [cell.btnRadio setImage:[UIImage imageNamed:@"radio_fill"] forState:UIControlStateNormal];
    } else {
        [cell.btnRadio setImage:[UIImage imageNamed:@"radio_blank"] forState:UIControlStateNormal];
    }
    
    return cell;
}

#pragma mark - Api Methods
-(void)getBusinessCardList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getBusinessCardListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kBusinessAPI_CardList]) {
                    [cardsArray removeAllObjects];

                    [cardsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBusinessAPI_CardList]] ;
                    lblNoCardsAvailable.hidden = true;
                    [tblView reloadData] ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoCardsAvailable.hidden = false;

                cardsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBusinessAPI_CardList]] ;
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)activateBusinessCard:(NSString *)cardId {
    if([UtilityClass checkInternetConnection]) {
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        [dictParam setObject:cardId forKey:kBusinessAPI_CardId] ;
        [dictParam setObject:@"1" forKey:kBusinessAPI_Status] ;

        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap activateBusinessCardWithParameters:dictParam success:^(NSDictionary *responseDict) {
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                [self getBusinessCardList];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description];
        }] ;
    }
}

-(void)deleteBusinessCard:(NSString *)cardId {
    if([UtilityClass checkInternetConnection]) {
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:cardId forKey:kBusinessAPI_CardId] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap deleteBusinessCardWithParameters:dictParam success:^(NSDictionary *responseDict) {
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                [self getBusinessCardList];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description];
        }] ;
    }
}
@end
