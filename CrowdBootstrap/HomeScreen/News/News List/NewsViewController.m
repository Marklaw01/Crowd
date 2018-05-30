//
//  NewsViewController.m
//  
//
//  Created by Shikha on 13/09/17.
//
//

#import "NewsViewController.h"
#import "FeedsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NewsDetailViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetUISettings];
    [self pullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void)pullToRefresh {
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, 0, 0)];
    [tblView insertSubview:refreshView atIndex:0];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor redColor];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull To Refresh"];
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
    refreshControl.attributedTitle = refreshString;
    
    [refreshView addSubview:refreshControl];
}

- (void)refreshData {
    [self resetUISettings];
    isPullToRefresh = true;
    [refreshControl endRefreshing];
}

-(void)resetUISettings {
    newsArray = [[NSMutableArray alloc] init];
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    isPullToRefresh = false;

    pageNo = 1;
    totalItems = 0 ;
    
    [self getNewsList];
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(newsArray.count == totalItems)
        return newsArray.count ;
    else
        return newsArray.count+1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %ld", (long)indexPath.row);
    if(indexPath.row == newsArray.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
        [activityIndicator startAnimating];
        return cell ;
    }
    else {
        FeedsTableViewCell *cell = (FeedsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_News] ;
        
        cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[newsArray objectAtIndex:indexPath.row] valueForKey:kNewsAPI_Title]] ;
        cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[newsArray objectAtIndex:indexPath.row] valueForKey:kNewsAPI_Desc]];
        cell.lblDate.text = [NSString stringWithFormat:@"%@",[[newsArray objectAtIndex:indexPath.row] valueForKey:kNewsAPI_Date]];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == newsArray.count)
        return 30;
    else {
        return 140;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *newsDict = [newsArray objectAtIndex:indexPath.row];
    NSString *news_link = [NSString stringWithFormat:@"%@",[newsDict valueForKey:kNewsAPI_Link]] ;
    
    // Redirect to news detail screen where link will be opened in webview
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsDetailViewController *viewController = (NewsDetailViewController*)[storyboard instantiateViewControllerWithIdentifier:kNewsDetailIdentifier];
    viewController.strLink = news_link;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == newsArray.count) {
        [self getNewsList] ;
    }
}

#pragma mark - Api Methods
-(void)getNewsList {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kNewsAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getNewsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kNewsAPI_List]) {
                    totalItems = [[responseDict valueForKey:kNewsAPI_TotalItems] integerValue] ;
                    
                    if (isPullToRefresh == true) {
                        [newsArray removeAllObjects];
                        isPullToRefresh = false;
                    }
                    
                    [newsArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kNewsAPI_List]] ;
                    
                    
                    lblNoNewsAvailable.hidden = true;
                    [tblView reloadData] ;
                    pageNo++ ;
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kNewsAPI_List]] ;
                    
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                lblNoNewsAvailable.hidden = false;
                newsArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kNewsAPI_List]] ;
                totalItems = 0;
                
                [tblView reloadData] ;
            }
        } failure:^(NSError *error) {
            totalItems = newsArray.count;
            [tblView reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

@end
