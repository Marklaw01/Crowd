//
//  FeedsViewController.h
//  CrowdBootstrap
//
//  Created by Shikha on 22/05/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_Feeds                 @"feedsCell"

@interface FeedsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    // IBOutlets
    IBOutlet UITableView        *tblView;
    IBOutlet UILabel            *lblNoFeedsAvailable;
    IBOutlet UIButton           *btnAddFeed;

    // Variables
    UIRefreshControl            *refreshControl;
    NSMutableArray              *feedsArray;
    NSMutableArray              *attachmentsArray;
    NSInteger                   totalItems ;
    int                         pageNo ;
    
    NSString                    *strAttachment1;
    NSString                    *strAttachment2;
    NSString                    *strAttachment3;
    NSString                    *strAttachment4;

    BOOL                        isPullToRefresh;
}

@end
