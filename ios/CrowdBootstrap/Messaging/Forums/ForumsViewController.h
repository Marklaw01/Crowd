//
//  ForumsViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 13/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

#define FORUM_STARTUP_CELL_IDENTIFIER          @"startupCell"
#define FORUM_FORUMS_CELL_IDENTIFIER           @"forumsCell"
#define FORUM_SEARCH_FORUMS_CELL_IDENTIFIER    @"searchForumsCell"

#define kDefault_NoForumAvailable              @"No Forum Available"
#define kDefault_NoStartupAvailable            @"No Startup Available"
#define kSearchForumsPlaceholder               @"Search by forum name"


enum SELECTED_VIEW{
    STARTUPS_SELECTED,
    FORUMS_SELECTED,
    MY_FORUMS_SELECTED
};

enum {
    CLOSE,
    ARCHIVE,
    DELETE
};

@interface ForumsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,UISearchResultsUpdating,UISearchBarDelegate>{
    IBOutlet UIBarButtonItem                  *menuBarBtn ;
    IBOutlet UISegmentedControl               *segmentedControl ;
    IBOutlet UITableView                      *tblView ;
    IBOutlet UILabel                          *forumLbl;
    
    IBOutlet UIButton *addForumButton;
    UISearchController                        *searchController ;
    
    NSMutableArray                            *forumsArray ;
    NSMutableArray                            *searchResults ;
    NSString                                  *searchedString ;
    int                                       pageNo ;
    int                                       totalItems ;
}

@end
