//
//  WorkOrder_EntrepreneurViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 11/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

enum{
    WORKORDER_DECLINE_STATUS,
    WORKORDER_ACCEPT_STATUS
    
};

#define HEADER_CELL_IDENTIFIER            @"HeaderCell"
#define WORK_ORDER_CELL_IDENTIFER         @"WorkOrderCell"

@interface WorkOrder_EntrepreneurViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate> {
    IBOutlet UITableView                  *tblView ;
    IBOutlet UIButton                     *downloadWorkOrderButton;
    
    NSMutableArray                        *workOrdersArray ;
}

@end
