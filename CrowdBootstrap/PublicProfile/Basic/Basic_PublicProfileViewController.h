//
//  Basic_PublicProfileViewController.h
//  CrowdBootstrap
//
//  Created by RICHA on 14/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_DynamicCell           @"DynamicTableViewCell"

#define BASIC_PROF_BIO_CELL_INDEX             0

@interface Basic_PublicProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray                            *basicProfileArray ;
}
@property (strong, nonatomic) IBOutlet UITableView *tblView;

@end
