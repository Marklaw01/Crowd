//
//  NewsViewController.h
//  
//
//  Created by Shikha on 13/09/17.
//
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_News                 @"newsCell"

@interface NewsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    // IBOutlets
    IBOutlet UITableView        *tblView;
    IBOutlet UILabel            *lblNoNewsAvailable;

    // Variables
    UIRefreshControl            *refreshControl;
    NSMutableArray              *newsArray;
    NSInteger                   totalItems ;
    int                         pageNo ;
    BOOL                        isPullToRefresh;

}

@end
