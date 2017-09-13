//
//  SearchStartupViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 08/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_SearchStartup    @"searchStartupCell"

@interface SearchStartupViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate>{
    
    IBOutlet UIBarButtonItem              *menuBarBtn;
    IBOutlet UITableView                  *tblView;
    
    UISearchController                    *searchController ;
    
    NSMutableArray                        *startupsArray ;
    NSMutableArray                        *searchResults ;
    NSString                              *searchedString ;
    int                                   totalItems ;
    int                                   pageNo ;
}


@end
