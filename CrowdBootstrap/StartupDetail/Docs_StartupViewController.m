//
//  Docs_StartupViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 20/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "Docs_StartupViewController.h"
#import "StartupDocsTableViewCell.h"

@interface Docs_StartupViewController ()

@end

@implementation Docs_StartupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self resetUISettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    self.tblView.hidden = YES ;
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    startupDocsArray = [[NSMutableArray alloc] init] ;
    searchResults = [[NSMutableArray alloc] init] ;
    
    [self.searchDisplayController.searchResultsTableView registerClass:[StartupDocsTableViewCell class]
                                                forCellReuseIdentifier:kCellIdentifier_Docs];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startupDocsDataNotification:)
                                                 name:kNotificationStartupDocs
                                               object:nil];
    
    uploadButton.hidden = ([UtilityClass getStartupType] == COMPLETEED_SELECTED ? YES : NO) ;
        
    
    
    //[self configureSearchController] ;
}

/*-(void)configureSearchController{
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil] ;
    searchController.searchBar.placeholder = kSearchDocumentPlaceholder ;
    [searchController.searchBar sizeToFit] ;
    searchController.searchResultsUpdater = self ;
    searchController.dimsBackgroundDuringPresentation = NO ;
    searchController.definesPresentationContext = YES ;
    searchController.hidesNavigationBarDuringPresentation = YES ;
    self.definesPresentationContext = YES ;
    self.tblView.tableHeaderView = searchController.searchBar ;
}*/

#pragma mark - IBAction Methods
- (IBAction)DownloadDoc_ClickAction:(id)sender {
    
     NSString* filePath = [[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[startupDocsArray objectAtIndex:[sender tag]] valueForKey:kStartupDocsAPI_DownloadLink]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"filePath: %@",filePath) ;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:filePath]];
   /* [ApiCrowdBootstrap downloadStartupDocsFilesWithPath:filePath success:^(NSDictionary *responseDict) {
        
    } failure:^(NSError *error) {
        [UtilityClass displayAlertMessage:error.description] ;
        [UtilityClass hideHud] ;

    }] ;*/
}


#pragma mark - Notifcation Methods
- (void)startupDocsDataNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationStartupDocs]){
        
        [self getStartupDocs] ;
    }
}

#pragma mark - Search Controller Methods
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
   /* NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    searchResults = [startupDocsArray filteredArrayUsingPredicate:resultPredicate] ;*/
    
    if (searchText == nil) {
        
        // If empty the search results are the same as the original data
        searchResults = [startupDocsArray  mutableCopy];
    } else {
        
        [searchResults removeAllObjects] ;
        for (NSDictionary *dict in startupDocsArray) {
            NSString *name = [NSString stringWithFormat:@"%@",[dict valueForKey:kStartupDocsAPI_DocName]] ;
            NSLog(@"name: %@ searchText: %@",name,searchText) ;
            if([[name lowercaseString] containsString:[searchText lowercaseString]]){
                [searchResults addObject:dict] ;
            }
        }
    }
    NSLog(@"searchResults: %@",searchResults) ;
}

#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    [self.tblView reloadData] ;
    return YES;
}

#pragma mark - API Methods
-(void)getStartupDocs{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupOverviewAPI_StartupID]] forKey:kStartupDocsAPI_StartupID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getStartupDocsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kStartupDocsAPI_FilesList]){
                    
                    startupDocsArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict valueForKey:kStartupDocsAPI_FilesList]] ;
                    
                    [self.tblView reloadData] ;
                    if(startupDocsArray.count <1)[self.tblView setHidden:YES] ;
                    else [self.tblView setHidden:NO] ;
                }
            }
            //else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
    
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) return searchResults.count ;
    else return startupDocsArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        StartupDocsTableViewCell *cell = (StartupDocsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Docs] ;
        // Date
        cell.dateLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kStartupDocsAPI_Date]] ;
        
        // User Name
        cell.usernameLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kStartupDocsAPI_UserName]] ;
        
        // Roadmap
        cell.roadmapLbl.text = [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kStartupDocsAPI_RoadmapName]] ;
        
        // Doc Name
        cell.docNameLbl.text =  [NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] valueForKey:kStartupDocsAPI_DocName]] ;
        
        NSLog(@"docNameLbl: %@ name: %@",cell.docNameLbl.text,[[searchResults objectAtIndex:indexPath.row] valueForKey:kStartupDocsAPI_DocName]) ;
        cell.downloadBtn.tag = (int)indexPath.row ;
        return cell ;
       
    }
    else{
        StartupDocsTableViewCell *cell = (StartupDocsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Docs] ;
        // Date
        cell.dateLbl.text = [NSString stringWithFormat:@"%@",[[startupDocsArray objectAtIndex:indexPath.row] valueForKey:kStartupDocsAPI_Date]] ;
        
        // User Name
        cell.usernameLbl.text = [NSString stringWithFormat:@"%@",[[startupDocsArray objectAtIndex:indexPath.row] valueForKey:kStartupDocsAPI_UserName]] ;
        
        // Roadmap
        cell.roadmapLbl.text = [NSString stringWithFormat:@"%@",[[startupDocsArray objectAtIndex:indexPath.row] valueForKey:kStartupDocsAPI_RoadmapName]] ;
        
        // Doc Name
        cell.docNameLbl.text =  [NSString stringWithFormat:@"%@",[[startupDocsArray objectAtIndex:indexPath.row] valueForKey:kStartupDocsAPI_DocName]] ;
        
        cell.downloadBtn.tag = (int)indexPath.row ;
        return cell ;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60 ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     UIView *headerView = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Header] ;
    return headerView ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35 ;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
