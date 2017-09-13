//
//  ArchivedForumsViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 16/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchivedForumsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UIBarButtonItem       *menuBarBtn;
    IBOutlet UITableView           *tblView ;
    
    NSMutableArray                 *forumssArray ;
    int                            pageNo ;
    int                            totalItems ;
}

@end
