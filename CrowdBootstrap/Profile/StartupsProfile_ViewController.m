//
//  StartupsProfile_ViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 19/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "StartupsProfile_ViewController.h"
#import "ProfieStartupsTableViewCell.h"

@interface StartupsProfile_ViewController ()

@end

@implementation StartupsProfile_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetSettingsUI] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetSettingsUI{
    startupsArray = [[NSMutableArray alloc] init] ;
    [self resetArrayForDropdown] ;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStartupProfileNotification:)
                                                 name:kNotificationStartupProfile
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getUpdatedStartupsNotification:)
                                                 name:kNotificationProfileUpdatedStartups
                                               object:nil];
}

-(void)resetArrayForDropdown{
    arrayForBool = [[NSMutableArray alloc] init] ;
    for (int i=0; i<[startupsArray count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
}

#pragma mark - IBAction Methods
- (IBAction)AddStartup_ClickAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kProfileAddStartupViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}


#pragma mark - Notifcation Methods
- (void)updateStartupProfileNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationStartupProfile]){
        
        //[self initializeProfessionalProfileArray] ;
        startupsArray = [NSMutableArray arrayWithArray:(NSArray*)[[UtilityClass getProfileStartupsDetails] mutableCopy]] ;
        [self resetArrayForDropdown] ;
        
        [tblView reloadData] ;
        
        if(startupsArray.count >0)[tblView setHidden:NO] ;
        else [tblView setHidden:YES] ;
       
    }
}

- (void)getUpdatedStartupsNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationProfileUpdatedStartups]){
        [self getStartupsProfileData] ;
    }
}

#pragma mark - Api Methods
-(void)getStartupsProfileData{
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileAPI_UserID] ;
    if([UtilityClass GetUserType] == CONTRACTOR)[dictParam setObject:CONTRACTOR_TEXT forKey:kProfileAPI_UserType] ;
    else [dictParam setObject:ENTREPRENEUR_TEXT forKey:kProfileAPI_UserType] ;
    NSLog(@"dictParam: %@",dictParam) ;
    [startupsArray removeAllObjects] ;
    [ApiCrowdBootstrap getProfielUserStartupsWithParameters:dictParam success:^(NSDictionary *responseDict) {
         NSLog(@"responseDict :%@",responseDict) ;
        [UtilityClass hideHud] ;
        if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
           
            [UtilityClass setProfileStartupsDetails:[responseDict valueForKey:kProfileAPI_StartupInformation]] ;
            startupsArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict valueForKey:kProfileAPI_StartupInformation]] ;
            [self resetArrayForDropdown] ;
            
            [tblView reloadData] ;
            
            if(startupsArray.count >0)[tblView setHidden:NO] ;
            else [tblView setHidden:YES] ;
        }
        else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode){
            [tblView reloadData] ;
            
            if(startupsArray.count >0)[tblView setHidden:NO] ;
            else [tblView setHidden:YES] ;
        }
        // else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
    } failure:^(NSError *error) {
        
        [UtilityClass displayAlertMessage:error.description] ;
        [UtilityClass hideHud] ;
        
    }] ;
}

#pragma mark - Table header gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[startupsArray count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [tblView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

#pragma mark - TableView Delegate Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[arrayForBool objectAtIndex:section] boolValue]) return 1;
    else return 0 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfieStartupsTableViewCell *cell = (ProfieStartupsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Startups] ;
    cell.startupDescription.text = [[startupsArray objectAtIndex:indexPath.section] valueForKey:kProfileUserStartupApi_StartupDesc] ;
    
    return cell ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return startupsArray.count ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,45)];
    sectionView.tag=section;
    
    // Background view
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, tableView.frame.size.width,35)];
    bgView.backgroundColor=[UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1];
    
    // Title Label
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, tblView.frame.size.width-20, 35)];
    viewLabel.backgroundColor=[UIColor clearColor];
    viewLabel.textColor = [UIColor colorWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1];
    viewLabel.font=[UIFont systemFontOfSize:15];
    viewLabel.text=[[startupsArray objectAtIndex:section] valueForKey:kProfileUserStartupApi_StartupName];
    
    // Expand-Collapse icon
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(tblView.frame.size.width-34,viewLabel.frame.origin.y+viewLabel.frame.size.height/2-7 ,14, 14)];
    if ([[arrayForBool objectAtIndex:section] boolValue]) imgView.image = [UIImage imageNamed:COLLAPSE_SECTION_IMAGE] ;
    else imgView.image = [UIImage imageNamed:EXPAND_SECTION_IMAGE] ;
    
    [sectionView addSubview:bgView] ;
    [sectionView addSubview:viewLabel];
    [sectionView addSubview:imgView];
    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    
    return  sectionView;
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