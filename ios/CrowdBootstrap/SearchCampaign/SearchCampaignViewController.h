//
//  SearchCampaignViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 24/08/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCampaignViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate>{
    IBOutlet UIBarButtonItem              *menuBarBtn;
    IBOutlet UITableView                  *tblView ;
    
    UISearchController                    *searchController ;
    
    
    NSMutableArray                        *campaignsArray ;
    NSMutableArray                        *searchResults ;
    NSString                              *searchedString ;
    int                                   totalItems ;
    int                                   pageNo ;
    NSNumberFormatter                    *formatter ;
}

@end
