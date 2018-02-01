//
//  ConnectionsListViewController.h
//  CrowdBootstrap
//
//  Created by osx on 20/12/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_User    @"userCell"

@interface ConnectionsListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    // --- IBOutlets ---
    IBOutlet UITableView                     *tblView ;
    
    // --- Variables ---
    NSMutableArray                           *usersArray ;
}
@property(nonatomic) NSDictionary *selectedDict;

@end
