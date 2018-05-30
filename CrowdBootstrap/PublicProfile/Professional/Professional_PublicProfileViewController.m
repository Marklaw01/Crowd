//
//  Professional_PublicProfileViewController.m
//  CrowdBootstrap
//
//  Created by RICHA on 14/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "Professional_PublicProfileViewController.h"
#import "DescriptionTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "KeywordsTableViewCell.h"
#import "DynamicTableViewCell.h"
#import "AddContributorViewController.h"

@interface Professional_PublicProfileViewController ()

@end

@implementation Professional_PublicProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeProfessionalProfileArray] ;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationProfessionalProfile object:nil];
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    
    if([UtilityClass getProfileMode] == PROFILE_MODE_TEAM ){
        NSString *role = [[[UtilityClass getContractorDetails] mutableCopy] valueForKey:kStartupTeamAPI_MemberRole] ;
        if(role) {
            if([role isEqualToString:TEAM_TYPE_ENTREPRENEUR])
                [UtilityClass setUserType:ENTREPRENEUR] ;
            else
                [UtilityClass setUserType:CONTRACTOR] ;
        }
    }
    else [UtilityClass setUserType:CONTRACTOR] ;
    
    if([UtilityClass getProfileMode] == PROFILE_MODE_RECOMMENDED || [UtilityClass getProfileMode] == PROFILE_MODE_SEARCH  )
        addContractorBtn.hidden = NO ;
    else
        addContractorBtn.hidden = YES ;
    
    _tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateProfessionalProfileNotification:)
                                                 name:kNotificationProfessionalProfile
                                               object:nil];
}

-(void)initializeProfessionalProfileArray{
    
    selectedKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedCertificationsArray = [[NSMutableArray alloc] init] ;
    selectedSkillsArray = [[NSMutableArray alloc] init] ;
    selectedQualificationsArray = [[NSMutableArray alloc] init] ;
    selectedPreferredStartupArray = [[NSMutableArray alloc] init] ;
    
    NSArray *fieldsArray ;
    NSArray *parametersArray ;
    if([UtilityClass GetUserType] == CONTRACTOR){
        fieldsArray = @[@"Experience",@"Keywords",@"Qualifications",@"Certifications",@"Skills",@"Industry Focus",@"Preferred Startup Stage",@"Contractor Type"] ;
        parametersArray = @[kProfProfileAPI_Experience,kProfProfileAPI_Keywords,kProfProfileAPI_Qualifications,kProfProfileAPI_Certifications,kProfProfileAPI_Skills,kProfProfileAPI_IndustryFocus,kProfProfileAPI_PreferredStartup,kProfProfileAPI_ContractorType] ;
    }
    else{
        fieldsArray = @[@"Company Name",@"Link to Company's website",@"Description",@"Keywords",@"Qualifications",@"Skills",@"Industry Focus"] ;
        
        parametersArray = @[kProfProfileAPI_CompnayName,kProfProfileAPI_WebsiteLink,kProfProfileAPI_Description,kProfProfileAPI_Keywords,kProfProfileAPI_Qualifications,kProfProfileAPI_Skills,kProfProfileAPI_IndustryFocus] ;
    }
    
    profProfileArray = [[NSMutableArray alloc] init] ;
    for (int i=0; i<fieldsArray.count ; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
        [dict setValue:[parametersArray objectAtIndex:i] forKey:@"key"] ;
        [dict setValue:@"" forKey:@"value"] ;
        [dict setValue:[fieldsArray objectAtIndex:i] forKey:@"field"] ;
        
        [profProfileArray addObject:dict] ;
    }
}

-(NSMutableArray*)resetTagsArrayWithData:(NSArray*)array{
    NSMutableArray *tagsArray = [[NSMutableArray alloc] init] ;
    for (NSDictionary *obj in array) {
        [tagsArray addObject:[obj valueForKey:@"name"]] ;
    }
    return tagsArray ;
}

#pragma mark - IBAction Methods
- (IBAction)AddContractor_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddContributorViewController *viewController = (AddContributorViewController*)[storyboard instantiateViewControllerWithIdentifier:kAddContractorIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

#pragma mark - Notifcation Methods
- (void)updateProfessionalProfileNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationProfessionalProfile]){
        
        if([UtilityClass getProfileMode] == PROFILE_MODE_RECOMMENDED || [UtilityClass getProfileMode] == PROFILE_MODE_SEARCH  )
            addContractorBtn.hidden = NO ;
        else
            addContractorBtn.hidden = YES ;

        [self initializeProfessionalProfileArray] ;
        NSDictionary *dict = [[UtilityClass getUserProfileDetails] mutableCopy] ;
        for ( int i=0; i<profProfileArray.count ; i++ ) {
            NSString *key = [[profProfileArray objectAtIndex:i] valueForKey:@"key"] ;
            if([UtilityClass GetUserType] == CONTRACTOR){
                if(i != kContPublicProfKeywordsCellIndex && i != kContPublicProfQualificationsCellIndex && i != kContPublicProfCertificationsCellIndex && i != kContPublicProfSkillsCellIndex){
                     if([dict valueForKey:key])  [[profProfileArray objectAtIndex:i] setValue:[dict valueForKey:key] forKey:@"value"] ;
                }
            }
            else{
                if(i != kEntPublicProfKeywordsCellIndex && i != kEntPublicProfQualificationsCellIndex && i != kEntPublicProfSkillsCellIndex ){
                    if([dict valueForKey:key])  [[profProfileArray objectAtIndex:i] setValue:[dict valueForKey:key] forKey:@"value"] ;
                }
            }
        }
        
        selectedKeywordsArray = [self resetTagsArrayWithData:[dict objectForKey:kProfProfileAPI_Keywords]] ;
        selectedCertificationsArray = [self resetTagsArrayWithData:[dict objectForKey:kProfProfileAPI_Certifications]] ;
        selectedSkillsArray = [self resetTagsArrayWithData:[dict objectForKey:kProfProfileAPI_Skills]] ;
        selectedQualificationsArray = [self resetTagsArrayWithData:[dict objectForKey:kProfProfileAPI_Qualifications]] ;
        selectedPreferredStartupArray = [self resetTagsArrayWithData:[dict objectForKey:kProfProfileAPI_PreferredStartup]] ;
        
        [_tblView reloadData] ;
       
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([UtilityClass GetUserType] == CONTRACTOR){
        
       if(indexPath.section == kContPublicProfKeywordsCellIndex || indexPath.section == kContPublicProfQualificationsCellIndex || indexPath.section == kContPublicProfCertificationsCellIndex || indexPath.section == kContPublicProfSkillsCellIndex || indexPath.section == kContPublicProfPreferredStartupCellIndex){
            
            KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PROFESSIONAL_PROF_KEYWORDS_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [UtilityClass setButtonBorder:cell.button] ;
            cell.tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
            cell.tagsScrollView.backgroundColor = [UIColor clearColor] ;
            cell.tagsScrollView.tag = indexPath.row ;
            cell.button.tag = indexPath.row ;
            cell.plusBtn.tag = indexPath.row ;
            
            cell.titleLbl.text =  [[profProfileArray objectAtIndex:indexPath.section] valueForKey:@"field"];
            
            NSMutableArray *tags ;
            if(indexPath.section == kContPublicProfKeywordsCellIndex)tags = [selectedKeywordsArray mutableCopy] ;
            else if(indexPath.section == kContPublicProfQualificationsCellIndex)tags = [selectedQualificationsArray mutableCopy] ;
            else if(indexPath.section == kContPublicProfCertificationsCellIndex)tags = [selectedCertificationsArray mutableCopy] ;
           else if(indexPath.section == kContPublicProfSkillsCellIndex)tags = [selectedSkillsArray mutableCopy] ;
            else tags = [selectedPreferredStartupArray mutableCopy] ;
            
            if(tags.count >0)[cell.button setHidden:YES] ;
            else [cell.button setHidden:NO] ;
            
            cell.tagsScrollView.tagPlaceholder = @"" ;
            [cell.button setTitle:[NSString stringWithFormat:@"No %@s Added",[[profProfileArray objectAtIndex:indexPath.section] valueForKey:@"field"]] forState:UIControlStateNormal] ;
            cell.tagsScrollView.tags = [tags mutableCopy];
            cell.tagsScrollView.tagsDeleteButtonColor = [UIColor whiteColor];
            cell.tagsScrollView.tagsTextColor = [UIColor whiteColor] ;
            cell.tagsScrollView.mode = TLTagsControlModeList;
            
            // UIColor *blueBackgroundColor = [UIColor colorWithRed:75.0/255.0 green:186.0/255.0 blue:251.0/255.0 alpha:1];
            cell.tagsScrollView.tagsBackgroundColor = [UtilityClass orangeColor];
            
            [cell.tagsScrollView reloadTagSubviews];
            
            return cell ;
            
        }
        else{
            DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            [self setUpCell:cell atIndexPath:indexPath];
            
            return cell;
        }
    }
    else{
        if(indexPath.section == kEntPublicProfKeywordsCellIndex || indexPath.section == kEntPublicProfQualificationsCellIndex || indexPath.section == kEntPublicProfSkillsCellIndex){
            
            KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PROFESSIONAL_PROF_KEYWORDS_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [UtilityClass setButtonBorder:cell.button] ;
            cell.tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
            cell.tagsScrollView.backgroundColor = [UIColor clearColor] ;
            cell.tagsScrollView.tag = indexPath.row ;
            cell.button.tag = indexPath.row ;
            cell.plusBtn.tag = indexPath.row ;
            
            cell.titleLbl.text =  [[profProfileArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            
            NSMutableArray *tags ;
            if(indexPath.section == kEntPublicProfKeywordsCellIndex)tags = [selectedKeywordsArray mutableCopy] ;
            else if(indexPath.section == kEntPublicProfQualificationsCellIndex)tags = [selectedQualificationsArray mutableCopy] ;
            else tags = [selectedSkillsArray mutableCopy] ;
            
            if(tags.count >0)[cell.button setHidden:YES] ;
            else [cell.button setHidden:NO] ;
            
            cell.tagsScrollView.tagPlaceholder = @"" ;
            [cell.button setTitle:[NSString stringWithFormat:@"No %@s Added",[[profProfileArray objectAtIndex:indexPath.section] valueForKey:@"field"]] forState:UIControlStateNormal] ;
            cell.tagsScrollView.tags = [tags mutableCopy];
            cell.tagsScrollView.tagsDeleteButtonColor = [UIColor whiteColor];
            cell.tagsScrollView.tagsTextColor = [UIColor whiteColor] ;
            cell.tagsScrollView.mode = TLTagsControlModeList;
            
            // UIColor *blueBackgroundColor = [UIColor colorWithRed:75.0/255.0 green:186.0/255.0 blue:251.0/255.0 alpha:1];
            cell.tagsScrollView.tagsBackgroundColor = [UtilityClass orangeColor];
            
            [cell.tagsScrollView reloadTagSubviews];
            
            return cell ;
        }
        else{
            DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_DynamicCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            [self setUpCell:cell atIndexPath:indexPath];
            
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([UtilityClass GetUserType] == CONTRACTOR){
        if(indexPath.section == kContPublicProfKeywordsCellIndex || indexPath.section == kContPublicProfQualificationsCellIndex || indexPath.section == kContPublicProfCertificationsCellIndex || indexPath.section == kContPublicProfSkillsCellIndex || indexPath.section == kContPublicProfPreferredStartupCellIndex) return 70 ;
        else{
            static DynamicTableViewCell *cell = nil;
            static dispatch_once_t onceToken;
            
            dispatch_once(&onceToken, ^{
                cell = [_tblView dequeueReusableCellWithIdentifier:kCellIdentifier_DynamicCell];
            });
            
            [self setUpCell:cell atIndexPath:indexPath];
            
            return [self calculateHeightForConfiguredSizingCell:cell];
        }
    }
    else{
        if(indexPath.section == kEntPublicProfKeywordsCellIndex || indexPath.section == kEntPublicProfQualificationsCellIndex || indexPath.section == kEntPublicProfSkillsCellIndex) return 70 ;
        else{
            static DynamicTableViewCell *cell = nil;
            static dispatch_once_t onceToken;
            
            dispatch_once(&onceToken, ^{
                cell = [_tblView dequeueReusableCellWithIdentifier:kCellIdentifier_DynamicCell];
            });
            
            [self setUpCell:cell atIndexPath:indexPath];
            
            return [self calculateHeightForConfiguredSizingCell:cell];
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return profProfileArray.count ;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10 ;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (void)setUpCell:(DynamicTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.label.text = [NSString stringWithFormat:@"%@: %@",[[profProfileArray objectAtIndex:indexPath.section] valueForKey:@"field"],[[profProfileArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
    cell.layer.borderColor=[[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
    cell.layer.borderWidth=1.0;
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
