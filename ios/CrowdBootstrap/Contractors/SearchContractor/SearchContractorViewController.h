//
//  SearchContractorViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 08/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTitle_SearchContractor             @"Search Contractor"
#define kTitle_RecommendedContractor        @"Recommended\nContractor"

#define kCellIdentifier_SearchContractor    @"searchContractorCell"


@interface SearchContractorViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate>{
    
    IBOutlet UIBarButtonItem               *menuBarBtn;
    IBOutlet UITableView                   *tblView;
    
    UISearchController                     *searchController ;
    
    NSNumberFormatter                      *formatter ;
    NSMutableArray                         *contractorsArray ;
    NSMutableArray                         *searchResults ;
    NSString                               *searchedString ;
    int                                    totalItems ;
    int                                    pageNo ;
}

@property(nonatomic,strong)NSString       *startupID ;

@end
