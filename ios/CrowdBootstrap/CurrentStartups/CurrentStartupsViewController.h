//
//  CurrentStartupsViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 12/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CurrentStartupsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate,UISearchResultsUpdating> {
    
   IBOutlet UIBarButtonItem           *menuBarBtn;
   IBOutlet UISegmentedControl        *segmentControl;
   IBOutlet UITableView               *tblView;
    
   UISearchController                 *searchController ;
    
   NSMutableArray                     *startupsArray ;
   NSMutableArray                     *searchResults ;
   NSString                           *searchedString ;
   int                                pageNo ;
   int                                totalItems ;
   BOOL                               shouldShowSearchResults ;
}

@property (nonatomic, strong) NSString *mode ;

@end
