//
//  JobDetailViewController.m
//  CrowdBootstrap
//
//  Created by osx on 26/12/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "JobDetailViewController.h"
#import "CampaignDocumentTableViewCell.h"
#import "GraphicTableViewCell.h"
#import "KLCPopup.h"
#import "DynamicTableViewCell.h"
#import "KeywordsTableViewCell.h"
#import "DescriptionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FollowCampaignTableViewCell.h"
#import "CommitTableViewCell.h"
#import "PublicProfileViewController.h"

@interface JobDetailViewController ()

@end

@implementation JobDetailViewController

#pragma mark - LifeCycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetUISettings] ;
    [self popUpScrollViewSettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings {
    
    jobData = [[UtilityClass getJobDetails] mutableCopy];
    NSLog(@"Job Data: %@",jobData) ;
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = [NSString stringWithFormat:@"%@",[jobData valueForKey:kSearchJobAPI_Job_Title]] ;
    [self initializeSectionArray] ;
    [self getJobDetails] ;
}

-(void)initializeSectionArray {
    
    NSArray *fieldsArray = @[@"Posted By", @"Company Name", @"Industry Keywords", @"Job Title", @"Job Role", @"Job Type", @"Minimum Work NPS", @"Location", @"State", @"Travel", @"Start Date", @"End Date", @"Skills", @"Requirement", @"Job Search Keywords", @"Summary", @"Company Image",@"View Document",@"Play Audio",@"Play Video"] ;
    NSArray *parametersArray = @[kJobDetailAPI_PostedBy, kJobDetailAPI_CompanyName, kJobDetailAPI_IndustryKeywords,kJobDetailAPI_JobTitle, kJobDetailAPI_JobRole, kJobDetailAPI_JobType, kJobDetailAPI_MINWORK_NPS, kJobDetailAPI_Location, kJobDetailAPI_State, kJobDetailAPI_Travel, kJobDetailAPI_StartDate, kJobDetailAPI_EndDate, kJobDetailAPI_Skills, kJobDetailAPI_Requirement, kJobDetailAPI_PostingKeywords, kJobDetailAPI_Summary, kJobDetailAPI_CompanyImage, kJobDetailAPI_Document, kJobDetailAPI_Audio, kJobDetailAPI_Video] ;
    
    sectionsArray = [[NSMutableArray alloc] init] ;
    for (int i=0; i<fieldsArray.count ; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
        [dict setValue:[parametersArray objectAtIndex:i] forKey:@"key"] ;
        [dict setValue:@"" forKey:@"value"] ;
        [dict setValue:[fieldsArray objectAtIndex:i] forKey:@"field"] ;
        
        [sectionsArray addObject:dict] ;
    }
    
    arrayForBool = [[NSMutableArray alloc] init] ;
    for (int i = 0; i < [sectionsArray count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    
    selectedSkilsArray = [[NSMutableArray alloc] init] ;
    selectedIndustryKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedJobPostingKeywordsArray = [[NSMutableArray alloc] init] ;
    
    audioFile = [[NSString alloc] init] ;
    videoFile = [[NSString alloc] init] ;
    docuementFile = [[NSString alloc] init] ;
    
    [self.tblView reloadData] ;
}

-(void)popUpScrollViewSettings {
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 6.0;
    scrollView.contentSize = CGSizeMake(imgView.frame.size.width, imgView.frame.size.height);
    scrollView.delegate = self;
}

-(NSMutableArray*)resetTagsArrayWithData:(NSArray*)array {
    NSMutableArray *tagsArray = [[NSMutableArray alloc] init] ;
    for (NSDictionary *obj in array) {
        [tagsArray addObject:[obj valueForKey:@"name"]] ;
    }
    return tagsArray ;
}

-(void)navigateToScreenWithViewIdentifier:(NSString *)viewIdentifier{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:viewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

#pragma mark - API Methods
-(void)getJobDetails {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kJobDetailAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[jobData valueForKey:kJobDetailAPI_JobID]] forKey:kJobDetailAPI_JobID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap viewJobWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                if([responseDict valueForKey:kJobDetailAPI_JobDetail]) {
                    NSDictionary *dict = [responseDict valueForKey:kJobDetailAPI_JobDetail] ;
                    for ( int i = 0; i < sectionsArray.count ; i++ ) {
                        NSString *key = [[sectionsArray objectAtIndex:i] valueForKey:@"key"] ;
                        if(i != JOB_INDUSTRY_KEYWORDS_SECTION_INDEX && i != JOB_POSTING_KEYWORDS_SECTION_INDEX && i != JOB_SKILLS_SECTION_INDEX && i != JOB_DOCUMENT_SECTION_INDEX  && i != JOB_AUDIO_SECTION_INDEX && i != JOB_VIDEO_SECTION_INDEX){
                            if([dict valueForKey:key])
                                [[sectionsArray objectAtIndex:i] setValue:[dict valueForKey:key] forKey:@"value"] ;
                        }
                    }
                    
                    if([dict objectForKey:kJobDetailAPI_IndustryKeywords])
                        selectedIndustryKeywordsArray = [self resetTagsArrayWithData:[dict objectForKey:kJobDetailAPI_IndustryKeywords]] ;
                    
                    if([dict objectForKey:kJobDetailAPI_PostingKeywords])
                        selectedJobPostingKeywordsArray = [self resetTagsArrayWithData:[dict objectForKey:kJobDetailAPI_PostingKeywords]] ;
                    
                    if([dict objectForKey:kJobDetailAPI_Skills])
                        selectedSkilsArray = [self resetTagsArrayWithData:[dict objectForKey:kJobDetailAPI_Skills]] ;
                    
                    if([dict objectForKey:kJobDetailAPI_Document])
                        docuementFile = [dict objectForKey:kJobDetailAPI_Document] ;
                    
                    if([dict objectForKey:kJobDetailAPI_Audio])
                        audioFile = [dict objectForKey:kJobDetailAPI_Audio] ;
                    
                    if([dict objectForKey:kJobDetailAPI_Video])
                        videoFile = [dict objectForKey:kJobDetailAPI_Video] ;
                    
                    if([dict objectForKey:kJobDetailAPI_IsFollowed])
                        isFollowed = [[dict objectForKey:kJobDetailAPI_IsFollowed] intValue] ;
                    
                    // Refresh Dict
                    [jobData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kJobDetailAPI_CompanyName]] forKey:kJobDetailAPI_CompanyName] ;
                    [jobData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kJobDetailAPI_JobTitle]] forKey:kJobDetailAPI_JobTitle] ;
                    [jobData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kJobDetailAPI_JobRole]] forKey:kJobDetailAPI_JobRole] ;
                    [jobData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kJobDetailAPI_PostedBy]] forKey:kJobDetailAPI_PostedBy] ;
                    [jobData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kJobDetailAPI_PostedBy_UserID]] forKey:kJobDetailAPI_PostedBy_UserID] ;
                    [jobData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kJobDetailAPI_MINWORK_NPS]] forKey:kJobDetailAPI_MINWORK_NPS] ;
                    [jobData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kJobDetailAPI_Location]] forKey:kJobDetailAPI_Location] ;
                    [jobData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kJobDetailAPI_State]] forKey:kJobDetailAPI_State] ;
                    [jobData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kJobDetailAPI_Travel]] forKey:kJobDetailAPI_Travel] ;
                    [jobData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kJobDetailAPI_StartDate]] forKey:kJobDetailAPI_StartDate] ;
                    [jobData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kJobDetailAPI_EndDate]] forKey:kJobDetailAPI_EndDate] ;
                    [jobData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kJobDetailAPI_Requirement]] forKey:kJobDetailAPI_Requirement] ;
                    [jobData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kJobDetailAPI_Summary]] forKey:kJobDetailAPI_Summary] ;
                    
                    [UtilityClass setJobDetails:[jobData mutableCopy]] ;
                    
                    [_tblView reloadData] ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - IBAction Methods
- (IBAction)CloseData_ClickAction:(id)sender {
    [jobDataView dismissPresentingPopup] ;
}

- (IBAction)CloseImgPopupView_ClickAction:(id)sender {
    [imgPopupView dismissPresentingPopup] ;
}

- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)FollowButton_ClickAction:(UIButton*)button {
    
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFollowJobAPI_UserID] ;
        [dictParam setObject:[[[UtilityClass getJobDetails] mutableCopy] valueForKey:kFollowJobAPI_JobID] forKey:kFollowJobAPI_JobID] ;
        [dictParam setObject:(isFollowed == 0?@"true":@"false") forKey:kFollowJobAPI_Status] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        if (isFollowed == 0) {
            [ApiCrowdBootstrap followJobWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"responseDict %@", responseDict);
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                    if(isFollowed == 0)
                        isFollowed = 1 ;
                    else
                        isFollowed = 0 ;
                    
                    [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:JOB_FOLLOW_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationNone] ;
                }
                else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                    [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                
            } failure:^(NSError *error) {
                [UtilityClass displayAlertMessage:error.description] ;
                [UtilityClass hideHud] ;
            }] ;
        } else {
            [ApiCrowdBootstrap unfollowJobWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"responseDict %@", responseDict);
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                    if(isFollowed == 1)
                        isFollowed = 0 ;
                    else
                        isFollowed = 1 ;
                    
                    [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:JOB_FOLLOW_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationNone] ;
                }
                else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode )
                    [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                
            } failure:^(NSError *error) {
                [UtilityClass displayAlertMessage:error.description] ;
                [UtilityClass hideHud] ;
            }] ;
        }
    }
}

- (IBAction)postedByButton_ClickAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:[jobData valueForKey:kJobDetailAPI_PostedBy_UserID] forKey:kRecommendedContAPI_ContractorID] ;

    viewController.profileMode = [NSString stringWithFormat:@"%d",PROFILE_MODE_SEARCH] ;
    [UtilityClass setViewEntProfileMode:NO] ;
    [UtilityClass setUserType:CONTRACTOR] ;
    [UtilityClass setProfileMode:PROFILE_MODE_SEARCH] ;
    
    [UtilityClass setContractorDetails:[dict mutableCopy]] ;
    NSLog(@"getContractorDetails: %@",[UtilityClass getContractorDetails]) ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)applyButton_ClickAction:(id)sender {
    
    [UtilityClass setJobDetails:[jobData mutableCopy]] ;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kApplyJobIdentifier] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

#pragma mark - Graphic Tap Gesture
- (void)graphicTappedAction:(UITapGestureRecognizer *)gestureRecognizer {
    
    imgPopupView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width-5, 250);
    imgPopupView.backgroundColor = [UIColor clearColor];
    
    KLCPopupLayout layout = KLCPopupLayoutMake((KLCPopupHorizontalLayout)KLCPopupHorizontalLayoutCenter,
                                               (KLCPopupVerticalLayout)KLCPopupVerticalLayoutCenter);
    
    KLCPopup* popup = [KLCPopup popupWithContentView:imgPopupView
                                            showType:(KLCPopupShowType)KLCPopupShowTypeBounceIn
                                         dismissType:(KLCPopupDismissType)KLCPopupDismissTypeBounceOut
                                            maskType:(KLCPopupMaskType)KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:YES
                               dismissOnContentTouch:NO];
    
    [popup showWithLayout:layout];
}

#pragma mark - Table header gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i = 0; i < [sectionsArray count]; i++) {
            if (indexPath.section == i) {
                if (indexPath.section == JOB_DOCUMENT_SECTION_INDEX) {
                    if (![docuementFile isEqualToString:@""]) {
                        [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
                    }
                }
                else if (indexPath.section == JOB_AUDIO_SECTION_INDEX) {
                    if (![audioFile isEqualToString:@""]) {
                        [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
                    }
                }
                else if (indexPath.section == JOB_VIDEO_SECTION_INDEX) {
                    if (![videoFile isEqualToString:@""]) {
                        [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
                    }
                }
                else {
                    [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
                }
            }
        }
        [self.tblView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - ScrollView Delegate Methods
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imgView ;
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
    return YES ;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section <= JOB_POSTING_KEYWORDS_SECTION_INDEX || section == sectionsArray.count)
        return 1;
    else {
        if(section == JOB_SUMMARY_SECTION_INDEX || section == JOB_COMPANY_IMAGE_SECTION_INDEX) {
            if ([[arrayForBool objectAtIndex:section] boolValue])
                return 1;
            else return 0 ;
        }
        else if(section == JOB_DOCUMENT_SECTION_INDEX ){
            if ([[arrayForBool objectAtIndex:section] boolValue]) return 1;
            else  return 0 ;
        }
        else if(section == JOB_AUDIO_SECTION_INDEX){
            if ([[arrayForBool objectAtIndex:section] boolValue]) return 1;
            else  return 0 ;
        }
        else{
            if ([[arrayForBool objectAtIndex:section] boolValue]) return 1;
            else  return 0 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == sectionsArray.count) {
        CommitTableViewCell *cell = (CommitTableViewCell*)[tableView dequeueReusableCellWithIdentifier:SUBMIT_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        return cell ;
    }
    else if(indexPath.section == JOB_FOLLOW_SECTION_INDEX) {
        FollowCampaignTableViewCell *cell = (FollowCampaignTableViewCell*)[tableView dequeueReusableCellWithIdentifier:FOLLOW_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        [UtilityClass setViewBorder:cell.postedByBtn] ;
        //        cell.postedByBtn.titleLabel.text = [NSString stringWithFormat:@"%@ : %@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"],[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
        [cell.postedByBtn setTitle:[NSString stringWithFormat:@"%@ : %@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"],[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] forState:UIControlStateNormal] ;
        
        NSLog(@"Posted By: %@", cell.postedByBtn.titleLabel.text);
        if(isFollowed == 0) {
            [cell.followBtn setTitle:FOLLOW_TEXT forState:UIControlStateNormal] ;
            [cell.followBtn setBackgroundImage:[UIImage imageNamed:FOLLOW_BUTTON_ICON] forState:UIControlStateNormal] ;
        }
        else{
            [cell.followBtn setTitle:UNFOLLOW_TEXT forState:UIControlStateNormal] ;
            [cell.followBtn setBackgroundImage:[UIImage imageNamed:UNFOLLOW_BUTTON_ICON] forState:UIControlStateNormal] ;
        }
        
        return cell;
    }
    else if(indexPath.section == JOB_INDUSTRY_KEYWORDS_SECTION_INDEX || indexPath.section == JOB_POSTING_KEYWORDS_SECTION_INDEX || indexPath.section == JOB_SKILLS_SECTION_INDEX){
        KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KEYWORDS_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        [UtilityClass setButtonBorder:cell.button] ;
        cell.tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
        cell.tagsScrollView.backgroundColor = [UIColor clearColor] ;
        cell.tagsScrollView.tag = indexPath.row ;
        cell.button.tag = indexPath.row ;
        cell.plusBtn.tag = indexPath.row ;
        
        NSMutableArray *tags ;
        if(indexPath.section == JOB_INDUSTRY_KEYWORDS_SECTION_INDEX )
            tags = [selectedIndustryKeywordsArray mutableCopy] ;
        else if(indexPath.section == JOB_POSTING_KEYWORDS_SECTION_INDEX )
            tags = [selectedJobPostingKeywordsArray mutableCopy] ;
        else
            tags = [selectedSkilsArray mutableCopy] ;
        
        if(tags.count > 0)
            [cell.button setHidden:YES] ;
        else
            [cell.button setHidden:NO] ;
        cell.titleLbl.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] ;
        cell.tagsScrollView.tagPlaceholder = @"" ;
        [cell.button setTitle:[NSString stringWithFormat:@"No %@ Added",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] forState:UIControlStateNormal] ;
        cell.tagsScrollView.tags = [tags mutableCopy];
        cell.tagsScrollView.tagsDeleteButtonColor = [UIColor whiteColor];
        cell.tagsScrollView.tagsTextColor = [UIColor whiteColor] ;
        cell.tagsScrollView.mode = TLTagsControlModeList;
        
        cell.tagsScrollView.tagsBackgroundColor = [UtilityClass orangeColor];
        
        [cell.tagsScrollView reloadTagSubviews];
        
        return cell ;
    }
    else if(indexPath.section <= JOB_REQUIREMENT_SECTION_INDEX && indexPath.section != JOB_INDUSTRY_KEYWORDS_SECTION_INDEX && indexPath.section != JOB_POSTING_KEYWORDS_SECTION_INDEX && indexPath.section != JOB_SKILLS_SECTION_INDEX && indexPath.section != JOB_FOLLOW_SECTION_INDEX){
        DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LABEL_CELL_IDENTIFIER forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        [self setUpCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    else if(indexPath.section == JOB_SUMMARY_SECTION_INDEX) {
        DescriptionTableViewCell *cell = (DescriptionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:SUMMARY_CELL_IDENTIFIER] ;
        cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
        return cell ;
    }
    else if(indexPath.section == JOB_COMPANY_IMAGE_SECTION_INDEX) {
        GraphicTableViewCell *cell = (GraphicTableViewCell*)[tableView dequeueReusableCellWithIdentifier:IMAGES_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        NSString* imgUrl = [[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"imgUrl: %@",imgUrl) ;
        [cell.graphicImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:kCampainDetail_DefaultImage]] ;
        
        return cell ;
    }
    else{
        CampaignDocumentTableViewCell *cell = (CampaignDocumentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:PLAY_AUDIO_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        if(indexPath.section == JOB_DOCUMENT_SECTION_INDEX)
            cell.lbl.text = [NSString stringWithFormat:@"Document %ld",indexPath.row+1] ;
        else if(indexPath.section == JOB_AUDIO_SECTION_INDEX)
            cell.lbl.text = [NSString stringWithFormat:@"Audio %ld",indexPath.row+1] ;
        else
            cell.lbl.text = [NSString stringWithFormat:@"Video %ld",indexPath.row+1] ;
        
        return cell ;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionsArray.count+1 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == JOB_FOLLOW_SECTION_INDEX)
        return 45 ;
    else if(indexPath.section <= JOB_REQUIREMENT_SECTION_INDEX && indexPath.section != JOB_INDUSTRY_KEYWORDS_SECTION_INDEX && indexPath.section != JOB_POSTING_KEYWORDS_SECTION_INDEX && indexPath.section != JOB_SKILLS_SECTION_INDEX && indexPath.section != JOB_FOLLOW_SECTION_INDEX)
    {
        static DynamicTableViewCell *cell = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            cell = [self.tblView dequeueReusableCellWithIdentifier:LABEL_CELL_IDENTIFIER];
        });
        
        [self setUpCell:cell atIndexPath:indexPath];
        
        return [self calculateHeightForConfiguredSizingCell:cell];
    }
    else if(indexPath.section == JOB_SUMMARY_SECTION_INDEX || indexPath.section == JOB_COMPANY_IMAGE_SECTION_INDEX)
        return 100 ;
    else if(indexPath.section == JOB_INDUSTRY_KEYWORDS_SECTION_INDEX || indexPath.section == JOB_POSTING_KEYWORDS_SECTION_INDEX || indexPath.section == JOB_SKILLS_SECTION_INDEX || indexPath.section == sectionsArray.count)
        return 70 ;
    else if(indexPath.section == JOB_DOCUMENT_SECTION_INDEX || indexPath.section == JOB_AUDIO_SECTION_INDEX || indexPath.section == JOB_VIDEO_SECTION_INDEX )
        return 45 ;
    else
        return 45 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section <= JOB_POSTING_KEYWORDS_SECTION_INDEX || section == sectionsArray.count)return 0;
    else return 45 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,45)];
    sectionView.tag = section;
    
    // Background view
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, tableView.frame.size.width,35)];
    bgView.backgroundColor = [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1];
    
    // Title Label
    UILabel *viewLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.tblView.frame.size.width-20, 35)];
    viewLabel.backgroundColor = [UIColor clearColor];
    viewLabel.textColor = [UIColor colorWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1];
    viewLabel.font = [UIFont systemFontOfSize:15];
    viewLabel.text = [[sectionsArray objectAtIndex:section] valueForKey:@"field"];
    
    // Expand-Collapse icon
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.tblView.frame.size.width-34,viewLabel.frame.origin.y+viewLabel.frame.size.height/2-7 ,14, 14)];
    if ([[arrayForBool objectAtIndex:section] boolValue])
        imageView.image = [UIImage imageNamed:COLLAPSE_SECTION_IMAGE] ;
    else
        imageView.image = [UIImage imageNamed:EXPAND_SECTION_IMAGE] ;
    
    [sectionView addSubview:bgView] ;
    [sectionView addSubview:viewLabel];
    [sectionView addSubview:imageView];
    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    
    return  sectionView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5 ;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section >= JOB_DOCUMENT_SECTION_INDEX && indexPath.section < sectionsArray.count) {
        
        NSString *filePath ;
        if(indexPath.section == JOB_DOCUMENT_SECTION_INDEX) {
            filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,docuementFile] ;
            dataTitle.text = @"Document" ;
        }
        else if(indexPath.section == JOB_AUDIO_SECTION_INDEX) {
            filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,audioFile] ;
            dataTitle.text = @"Audio" ;
        }
        else {
            filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,videoFile] ;
            dataTitle.text = @"Video" ;
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:filePath]];
    }
}

# pragma mark - Cell Setup
- (void)setUpCell:(DynamicTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.label.text = [NSString stringWithFormat:@"%@: %@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"],[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
    
    cell.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
    cell.layer.borderWidth = 1.0;
}
@end
