//
//  ManageGroupsViewController.h
//  CrowdBootstrap
//
//  Created by Shikha on 09/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupTableViewCell.h"

#define kCellIdentifier_Group    @"GroupCellIdentifier"

@interface ManageGroupsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, GroupTableViewCellDelegate>
{
    // IBOutlets
    __weak IBOutlet UITableView *tblViewGroups;
    
    // Variables
    NSMutableArray *groupArray ;

}
@property UIView    *selectedItem;

@end
