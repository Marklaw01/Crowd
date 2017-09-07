//
//  ForumsListViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 15/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface ForumsListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>{
    IBOutlet UITableView                      *tblView ;
    
    NSMutableArray                            *forumsArray ;
    int                                       pageNo ;
    int                                       totalItems ;
}

@property(strong, nonatomic)NSMutableDictionary   *startupDict ;

@end
