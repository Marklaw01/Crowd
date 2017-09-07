//
//  CommentsViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 05/05/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "CommentsViewController.h"
#import "NotificationsTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tblView.estimatedRowHeight = 100 ;
    tblView.rowHeight = UITableViewAutomaticDimension ;
    
    [tblView setNeedsLayout] ;
    [tblView layoutIfNeeded] ;
    [self resetUISettings] ;
    [self navigationBarSettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    commentsArray = [[NSMutableArray alloc] init] ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblView.hidden = YES ;
    pageNo = 1 ;
    totalItems = 0 ;
    
    [self getComments] ;
}

-(void)navigationBarSettings{
    self.navigationItem.hidesBackButton = YES ;
    self.title = @"Comments" ;
}

#pragma mark - IBAction Methods
- (IBAction)Back_ClickAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

#pragma mark - API Methods
-(void)getComments{
    if([UtilityClass checkInternetConnection]){
        
        if(pageNo == 1)[UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%@",[[UtilityClass getForumDetails] valueForKey:kMyForumAPI_ForumID]] forKey:kForumCommentAPI_ForumID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kForumCommentAPI_PageNo] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getForumCommentsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"responseDict: %@",responseDict) ;
                if([responseDict valueForKey:kForumCommentAPI_Comments]){
                    [commentsArray removeAllObjects] ;
                    totalItems = [[responseDict valueForKey:kForumCommentAPI_TotalItems] intValue] ;
                    for (NSMutableDictionary *dict in [responseDict valueForKey:kForumCommentAPI_Comments]) {
                        [commentsArray addObject:dict] ;
                    }
                    //commentsArray = [NSMutableArray arrayWithArray:[[[responseDict valueForKey:kForumCommentAPI_Comments] objectAtIndex:0] mutableCopy]] ;
                    [tblView reloadData] ;
                    if(commentsArray.count <1)[tblView setHidden:YES] ;
                    else [tblView setHidden:NO] ;
                    pageNo ++ ;
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
    if(commentsArray.count == totalItems) return commentsArray.count ;
    else return commentsArray.count+1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if(indexPath.row == commentsArray.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer_LoadMore forIndexPath:indexPath];
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
        [activityIndicator startAnimating];
        return cell ;
    }
    else{
        NotificationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Notification] ;
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[commentsArray objectAtIndex:indexPath.row] valueForKey:kForumCommentAPI_UserImage]]] placeholderImage:[UIImage imageNamed:kImage_UserPicDefault]] ;
        cell.imgView.layer.cornerRadius = 17.5;
        cell.imgView.clipsToBounds = YES;
        cell.titleLbl.text = [NSString stringWithFormat:@"%@",[[commentsArray objectAtIndex:indexPath.row] valueForKey:kForumCommentAPI_CommentedBy]];
        cell.descriptionLbl.text = [NSString stringWithFormat:@"%@",[[commentsArray objectAtIndex:indexPath.row] valueForKey:kForumCommentAPI_CommentText]];
        cell.timeLbl.text = [UtilityClass formatDateFromString:[NSString stringWithFormat:@"%@",[[commentsArray objectAtIndex:indexPath.row] valueForKey:kForumDetailAPI_CommentedTime]]]  ;
        
        return cell ;
    }
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == commentsArray.count) return 30 ;
    else return 90 ;
}*/

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == commentsArray.count){
        [self getComments] ;
    }
    
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
