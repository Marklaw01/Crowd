//
//  ContractorsListViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 25/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface ContractorsListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate> {
    IBOutlet UITableView        *tblView ;
    
    NSMutableArray              *contractorsArry ;
    NSNumberFormatter           *formatter ;
}

@end
