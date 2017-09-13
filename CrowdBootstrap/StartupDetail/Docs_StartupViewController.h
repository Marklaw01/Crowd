//
//  Docs_StartupViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 20/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_Docs           @"docsCell"
#define kCellIdentifier_Header         @"headerView"


@interface Docs_StartupViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    //IBOutlet UITableView               *tblView ;
    IBOutlet UIButton                  *uploadButton ;
    
    UISearchController                 *searchController ;
    
    //NSFormatter                        *formatter ;
    NSMutableArray                     *startupDocsArray ;
    NSMutableArray                     *searchResults ;
}

@property (nonatomic, strong) IBOutlet UITableView *tblView;

@end
