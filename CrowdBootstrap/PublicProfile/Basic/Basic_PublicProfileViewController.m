//
//  Basic_PublicProfileViewController.m
//  CrowdBootstrap
//
//  Created by RICHA on 14/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "Basic_PublicProfileViewController.h"
#import "DescriptionTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "DynamicTableViewCell.h"

@interface Basic_PublicProfileViewController ()

@end

@implementation Basic_PublicProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeBasicProfileArray] ;
    [self resetUISettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    if([UtilityClass getProfileMode] == PROFILE_MODE_RECOMMENDED || [UtilityClass getProfileMode] == PROFILE_MODE_SEARCH) {
        if([UtilityClass getAddContractorStatus] == YES) {
            addContractorBtn.alpha = 0.7 ;
            addContractorBtn.userInteractionEnabled = NO ;
        }
        else {
            addContractorBtn.alpha = 1 ;
            addContractorBtn.userInteractionEnabled = YES ;
        }
        [UtilityClass setAdddContractorStatus:NO] ;
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationBasicProfile object:nil];
}

#pragma mark - Custom Methods
-(void)initializeBasicProfileArray{
    
    NSArray *fieldsArray ;
    NSArray *parametersArray ;
    if([UtilityClass GetUserType] == CONTRACTOR){
        fieldsArray = @[@"Bio",@"Name",@"Email",@"Date of Birth",@"Phone Number",@"Country",@"State"] ;
        parametersArray = @[kBasicProfileAPI_Biodata,kBasicProfileAPI_Name,kBasicProfileAPI_Email,kBasicProfileAPI_Dob,kBasicProfileAPI_Phone,kBasicProfileAPI_Country,kBasicProfileAPI_City] ;
    }
    else{
        fieldsArray = @[@"Bio",@"Name",@"Email",@"Date of Birth",@"Phone Number",@"Country",@"State",@"My Interests"] ;
        
        parametersArray = @[kBasicProfileAPI_Biodata,kBasicProfileAPI_Name,kBasicProfileAPI_Email,kBasicProfileAPI_Dob,kBasicProfileAPI_Phone,kBasicProfileAPI_Country,kBasicProfileAPI_City,kBasicProfileAPI_Interest] ;
        
    }
    
    basicProfileArray = [[NSMutableArray alloc] init] ;
    for (int i=0; i<fieldsArray.count ; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
        [dict setValue:[parametersArray objectAtIndex:i] forKey:@"key"] ;
        [dict setValue:@"" forKey:@"value"] ;
        [dict setValue:[fieldsArray objectAtIndex:i] forKey:@"field"] ;
        
        [basicProfileArray addObject:dict] ;
    }
}

-(void)resetUISettings{
    
    if([UtilityClass getProfileMode] == PROFILE_MODE_TEAM ){
        NSString *role = [[[UtilityClass getContractorDetails] mutableCopy] valueForKey:kStartupTeamAPI_MemberRole] ;
        if(role){
            if([role isEqualToString:TEAM_TYPE_ENTREPRENEUR])[UtilityClass setUserType:ENTREPRENEUR] ;
            else [UtilityClass setUserType:CONTRACTOR] ;
        }
    }
    else [UtilityClass setUserType:CONTRACTOR] ;
    
    if([UtilityClass getProfileMode] == PROFILE_MODE_RECOMMENDED || [UtilityClass getProfileMode] == PROFILE_MODE_SEARCH  )
        addContractorBtn.hidden = NO ;
    else
        addContractorBtn.hidden = YES ;
    
    _tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBasicProfileNotification:)
                                                 name:kNotificationBasicProfile
                                               object:nil];
   
    
}

#pragma mark - Notifcation Methods
- (void)updateBasicProfileNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationBasicProfile]){
        
        if([UtilityClass getProfileMode] == PROFILE_MODE_RECOMMENDED || [UtilityClass getProfileMode] == PROFILE_MODE_SEARCH  )
            addContractorBtn.hidden = NO ;
        else
            addContractorBtn.hidden = YES ;

        [self initializeBasicProfileArray] ;
        
         NSDictionary *dict = [[UtilityClass getUserProfileDetails] mutableCopy] ;
         NSLog(@"dict: %@",dict) ;
        
        for ( int i=0; i<basicProfileArray.count ; i++ ) {
            NSString *key = [[basicProfileArray objectAtIndex:i] valueForKey:@"key"] ;
            if([dict valueForKey:key])  [[basicProfileArray objectAtIndex:i] setValue:[dict valueForKey:key] forKey:@"value"] ;
        }
        
        [_tblView reloadData] ;
    }
}

#pragma mark - IBAction Methods
- (IBAction)AddContractor_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddContributorViewController *viewController = (AddContributorViewController*)[storyboard instantiateViewControllerWithIdentifier:kAddContractorIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

# pragma mark - Cell Setup
- (void)setUpCell:(DynamicTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.label.text = [NSString stringWithFormat:@"%@: %@",[[basicProfileArray objectAtIndex:indexPath.section] valueForKey:@"field"],[[basicProfileArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
    cell.layer.borderColor=[[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
    cell.layer.borderWidth=1.0;
}


#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_DynamicCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    [self setUpCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static DynamicTableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        cell = [_tblView dequeueReusableCellWithIdentifier:kCellIdentifier_DynamicCell];
    });
    
    [self setUpCell:cell atIndexPath:indexPath];
    
    return [self calculateHeightForConfiguredSizingCell:cell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return basicProfileArray.count ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10 ;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
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
