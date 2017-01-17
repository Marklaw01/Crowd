//
//  CompaniesViewController.h
//  CrowdBootstrap
//
//  Created by Shikha Singla on 22/11/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTitle_SearchCompany             @"Search Company"
#define kCellIdentifier_SearchCompany    @"searchCompanyCell"


@interface CompaniesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate>
{
    
    IBOutlet UIBarButtonItem               *menuBarBtn;
    IBOutlet UITableView                   *tblView;
    
    UISearchController                     *companySearchController ;
    
    NSNumberFormatter                      *formatter ;
    NSMutableArray                         *companiesArray ;
    NSMutableArray                         *searchResults ;
    NSString                               *searchedString ;
    int                                    totalItems ;
    int                                    pageNo ;
}

@property(nonatomic,strong)NSString       *startupID ;
@end
