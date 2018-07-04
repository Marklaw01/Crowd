//
//  NewUsersViewController.h
//  CrowdBootstrap
//
//  Created by osx on 27/06/18.
//  Copyright © 2018 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_User    @"userCell"

@interface NewUsersViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    // --- IBOutlets ---
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoUsersAvailable;
    
    IBOutlet UIView                          *viewImgPopup ;
    IBOutlet UIImageView                     *imgViewPopup;

    // --- Variables ---
    NSMutableArray                           *usersArray ;
    UIRefreshControl                         *refreshControl;
    BOOL                                     isPullToRefresh;

    
    
    NSUInteger                               selectedCardIndex;
}
@property NSInteger                                totalItems ;
@property int                                      pageNo ;
- (void)getNewBusinessUsers;
@end
