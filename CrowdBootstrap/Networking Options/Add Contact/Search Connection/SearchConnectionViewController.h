//
//  SearchConnectionViewController.h
//  CrowdBootstrap
//
//  Created by Shikha on 07/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_User    @"userCell"

@interface SearchConnectionViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoUsersAvailable;

    // --- Variables ---
    UISearchController                       *userSearchController ;
    NSMutableArray                           *usersArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;


}
@end
