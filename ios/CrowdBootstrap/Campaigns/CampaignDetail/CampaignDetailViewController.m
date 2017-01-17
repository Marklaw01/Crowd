//
//  CampaignDetailViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 25/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "CampaignDetailViewController.h"
#import "CampaignDocumentTableViewCell.h"
#import "GraphicTableViewCell.h"
#import "KLCPopup.h"
#import "DynamicTableViewCell.h"
#import "KeywordsTableViewCell.h"
#import "DescriptionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FollowCampaignTableViewCell.h"
#import "CommitTableViewCell.h"

@interface CampaignDetailViewController ()

@end

@implementation CampaignDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self resetUISetiings] ;
    [self popUpScrollViewSettings] ;
}

-(void)viewDidAppear:(BOOL)animated{
    
    if([[[[UtilityClass getCampaignDetails] mutableCopy] valueForKey:kCampaignDetailAPI_IsCommitted]intValue] == 0){
        isCommitted = 0 ;
        CommitTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionsArray.count]] ;
        if(cell) [cell.commitBtn setTitle:COMMIT_TEXT forState:UIControlStateNormal] ;
    }
    else{
        isCommitted = 1 ;
        CommitTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionsArray.count]] ;
        if(cell) [cell.commitBtn setTitle:UNCOMMIT_TEXT forState:UIControlStateNormal] ;
    }
    
    
    [self initializeSectionArray] ;
    [self getCampaignDetail] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISetiings{
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    [formatter setGroupingSeparator:@","] ;
    [formatter setGroupingSize:3] ;
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    
    campaignData = [[UtilityClass getCampaignDetails] mutableCopy];
    NSLog(@"campaignData: %@",campaignData) ;
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = [NSString stringWithFormat:@"%@",[campaignData valueForKey:kCampaignsAPI_CampaignName]] ;
    [self initializeSectionArray] ;
    [self getCampaignDetail] ;
}

-(void)initializeSectionArray{
    
    NSArray *fieldsArray = @[@"Name",@"Startup Name",@"Target Market",@"Campaign Keyword",@"Due Date",@"Target Amount",@"Fund Raised So Far",@"Summary",@"Campaign Image",@"View Document",@"Play Audio",@"Play Video"] ;
    NSArray *parametersArray = @[kCampaignDetailAPI_CampaignName,kCampaignDetailAPI_StartupName,kCampaignDetailAPI_Keywords,kCampaignDetailAPI_CampaignKeywords,kCampaignDetailAPI_DueDate,kCampaignDetailAPI_TargetAmount,kCampaignDetailAPI_FundRaisedSoFar,kCampaignDetailAPI_Summary,kCampaignDetailAPI_CampaignImage,kCampaignDetailAPI_DocumentsList,kCampaignDetailAPI_AudiosList,kCampaignDetailAPI_VideosList] ;
    
    sectionsArray = [[NSMutableArray alloc] init] ;
    for (int i=0; i<fieldsArray.count ; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
        [dict setValue:[parametersArray objectAtIndex:i] forKey:@"key"] ;
        [dict setValue:@"" forKey:@"value"] ;
        [dict setValue:[fieldsArray objectAtIndex:i] forKey:@"field"] ;
        
        [sectionsArray addObject:dict] ;
    }
    
    arrayForBool = [[NSMutableArray alloc] init] ;
    for (int i=0; i<[sectionsArray count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    
    selectedKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedCampKeywordsArray = [[NSMutableArray alloc] init] ;
    audiosArray = [[NSMutableArray alloc] init] ;
    videosArray = [[NSMutableArray alloc] init] ;
    docuementsArray = [[NSMutableArray alloc] init] ;
    
    isFollowed  = 0 ;
    isCommitted = 0 ;
    
    [self.tblView reloadData] ;
}


-(void)popUpScrollViewSettings{
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 6.0;
    scrollView.contentSize=CGSizeMake(imgView.frame.size.width, imgView.frame.size.height);
    scrollView.delegate=self;
}

-(NSMutableArray*)resetTagsArrayWithData:(NSArray*)array{
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
-(void)getCampaignDetail{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCampaignDetailAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[campaignData valueForKey:kCampaignsAPI_CampaignID]] forKey:kCampaignDetailAPI_CampaignID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap getCampaignDetailwithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                if([responseDict valueForKey:kCampaignDetailAPI_CampaignDetail]){
                    NSDictionary *dict = [responseDict valueForKey:kCampaignDetailAPI_CampaignDetail] ;
                    for ( int i=0; i<sectionsArray.count ; i++ ) {
                        NSString *key = [[sectionsArray objectAtIndex:i] valueForKey:@"key"] ;
                        if(i != CAMPAIGN_TARGET_MARKET_SECTION_INDEX && i != CAMPAIGN_CAMP_KEYWORDS_SECTION_INDEX && i != CAMPAIGN_DOCUMENTS_SECTION_INDEX  && i != CAMPAIGN_AUIDIOS_SECTION_INDEX && i != CAMPAIGN_VIDEOS_SECTION_INDEX){
                            if([dict valueForKey:key])  [[sectionsArray objectAtIndex:i] setValue:[dict valueForKey:key] forKey:@"value"] ;
                        }
                    }
                    
                    if([dict objectForKey:kCampaignDetailAPI_Keywords])selectedKeywordsArray = [self resetTagsArrayWithData:[dict objectForKey:kCampaignDetailAPI_Keywords]] ;
                    
                    if([dict objectForKey:kCampaignDetailAPI_CampaignKeywords])selectedCampKeywordsArray = [self resetTagsArrayWithData:[dict objectForKey:kCampaignDetailAPI_CampaignKeywords]] ;
                    
                    if([dict objectForKey:kCampaignDetailAPI_AudiosList])audiosArray = [NSMutableArray arrayWithArray:(NSArray*)[dict objectForKey:kCampaignDetailAPI_AudiosList]] ;
                    
                    if([dict objectForKey:kCampaignDetailAPI_VideosList])videosArray = [NSMutableArray arrayWithArray:(NSArray*)[dict objectForKey:kCampaignDetailAPI_VideosList]] ;
                    
                    if([dict objectForKey:kCampaignDetailAPI_DocumentsList])docuementsArray = [NSMutableArray arrayWithArray:(NSArray*)[dict objectForKey:kCampaignDetailAPI_DocumentsList]] ;
                    
                    if([dict objectForKey:kCampaignDetailAPI_IsFollowed]) isFollowed = [[dict objectForKey:kCampaignDetailAPI_IsFollowed] intValue] ;
                    
                    if([dict objectForKey:kCampaignDetailAPI_IsCommitted]) isCommitted = [[dict objectForKey:kCampaignDetailAPI_IsCommitted] intValue] ;
                    
                    // Refresh Dict
                    [campaignData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kCampaignDetailAPI_CampaignName]] forKey:kCampaignsAPI_CampaignName] ;
                    [campaignData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kCampaignDetailAPI_Summary]] forKey:kCampaignsAPI_Description] ;
                    [campaignData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kCampaignDetailAPI_DueDate]] forKey:kCampaignsAPI_DueDate] ;
                    [campaignData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kCampaignDetailAPI_FundRaisedSoFar]] forKey:kCampaignsAPI_FundRaised] ;
                    [campaignData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kCampaignDetailAPI_StartupID]] forKey:kCampaignsAPI_StartupID] ;
                    [campaignData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kCampaignDetailAPI_StartupName]] forKey:kCampaignsAPI_StartupName] ;
                    [campaignData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kCampaignDetailAPI_TargetAmount]] forKey:kCampaignsAPI_TargetAmount] ;
                    
                    [UtilityClass setCampaignDetails:[campaignData mutableCopy]] ;
                    
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

-(void)uncommitCampaign {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kUncommitCampaignAPI_UserID] ;
        [dictParam setObject:[[[UtilityClass getCampaignDetails] mutableCopy] valueForKey:kCampaignDetailAPI_CampaignID] forKey:kUncommitCampaignAPI_CampaignID] ;
        
        [ApiCrowdBootstrap uncommitCampaignWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                // [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil] ;
                isCommitted = 0 ;
                CommitTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionsArray.count]] ;
                if(cell) [cell.commitBtn setTitle:COMMIT_TEXT forState:UIControlStateNormal] ;
                [self initializeSectionArray] ;
                [self getCampaignDetail] ;
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
    [campaignDataView dismissPresentingPopup] ;
}

- (IBAction)CloseImgPopupView_ClickAction:(id)sender {
    [imgPopupView dismissPresentingPopup] ;
}

- (IBAction)BottomButttons_ClickAction:(UIButton*)button {
    if([button tag] == VIEW_CONTRACTOR_SELECTED) {
        [self navigateToScreenWithViewIdentifier:kViewContractorIdentifier] ;
    }
    else {
        
        if(isCommitted == 0) {
            
            if([[UtilityClass getCampaignDetails] valueForKey:kCampaignsAPI_TargetAmount] ){
                NSString *targetAmount = [NSString stringWithFormat:@"%@",[[UtilityClass getCampaignDetails] valueForKey:kCampaignsAPI_TargetAmount] ] ;
                // Check for 0 Target Amount
                if([targetAmount isEqualToString:@""] || [targetAmount isEqualToString:@" "] ){
                    
                    [self presentViewController:[UtilityClass displayAlertMessage:kAlert_CommitError] animated:YES completion:nil] ;
                    return ;
                    
                }
                else if([targetAmount intValue] && [targetAmount intValue] == 0) {
                    [self presentViewController:[UtilityClass displayAlertMessage:kAlert_CommitError] animated:YES completion:nil] ;
                    return ;
                }
                
                else{
                    
                    // Check for remaining amount to commit -> Target amount - Fund raised so far
                    float targetAmount = 0 ;
                    float fundRaised = 0 ;
                    if([[[UtilityClass getCampaignDetails] valueForKey:kCampaignsAPI_TargetAmount] floatValue])targetAmount = [[[UtilityClass getCampaignDetails] valueForKey:kCampaignsAPI_TargetAmount] floatValue] ;
                    if([[[UtilityClass getCampaignDetails] valueForKey:kCampaignsAPI_FundRaised] floatValue])fundRaised = [[[UtilityClass getCampaignDetails] valueForKey:kCampaignsAPI_FundRaised] floatValue] ;
                    if(targetAmount-fundRaised > 0) [self navigateToScreenWithViewIdentifier:kCommitViewIdentifier] ;
                    else{
                         [self presentViewController:[UtilityClass displayAlertMessage:kAlert_TargetAmountAchieveCommit] animated:YES completion:nil] ;
                    }
                }
            }
        }
        else [self uncommitCampaign] ;
    }
}

- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)FollowButton_ClickAction:(UIButton*)button {
    
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFollowCampaignAPI_UserID] ;
        [dictParam setObject:[[[UtilityClass getCampaignDetails] mutableCopy] valueForKey:kCampaignDetailAPI_CampaignID] forKey:kFollowCampaignAPI_CampaignID] ;
        [dictParam setObject:(isFollowed == 0?@"true":@"false") forKey:kFollowCampaignAPI_Status] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap followUnfollowCampaignWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                // [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil] ;
                if(isFollowed == 0)isFollowed = 1 ;
                else isFollowed = 0 ;
                
                [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:CAMPAIGN_NAME_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationNone] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - Graphic Tap Gesture
- (void)graphicTappedAction:(UITapGestureRecognizer *)gestureRecognizer{
    
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
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[sectionsArray count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.tblView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

#pragma mark - ScrollView Delegate Methods
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imgView ;
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    return YES ;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section <= CAMPAIGN_FUND_RAISED_SECTION_INDEX || section == sectionsArray.count)return 1;
    else{
        if(section == CAMPAIGN_SUMMARY_SECTION_INDEX || section == CAMPAIGN_IMAGES_SECTION_INDEX){
            if ([[arrayForBool objectAtIndex:section] boolValue]) return 1;
            else return 0 ;
        }
        else if(section == CAMPAIGN_DOCUMENTS_SECTION_INDEX ){
            if ([[arrayForBool objectAtIndex:section] boolValue]) return docuementsArray.count;
            else  return 0 ;
        }
        else if(section == CAMPAIGN_AUIDIOS_SECTION_INDEX){
            if ([[arrayForBool objectAtIndex:section] boolValue]) return audiosArray.count;
            else  return 0 ;
        }
        else{
            if ([[arrayForBool objectAtIndex:section] boolValue]) return videosArray.count;
            else  return 0 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == sectionsArray.count){
        CommitTableViewCell *cell = (CommitTableViewCell*)[tableView dequeueReusableCellWithIdentifier:SUBMIT_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        if(isCommitted == 0) [cell.commitBtn setTitle:COMMIT_TEXT forState:UIControlStateNormal] ;
        else [cell.commitBtn setTitle:UNCOMMIT_TEXT forState:UIControlStateNormal] ;
        
        return cell ;
    }
    else if(indexPath.section == CAMPAIGN_NAME_SECTION_INDEX) {
        FollowCampaignTableViewCell *cell = (FollowCampaignTableViewCell*)[tableView dequeueReusableCellWithIdentifier:FOLLOW_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        [UtilityClass setViewBorder:cell.lblView] ;
        cell.lbl.text = [NSString stringWithFormat:@"%@: %@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"],[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
        
        if(isFollowed == 0){
            [cell.followBtn setTitle:FOLLOW_TEXT forState:UIControlStateNormal] ;
            [cell.followBtn setBackgroundImage:[UIImage imageNamed:FOLLOW_BUTTON_ICON] forState:UIControlStateNormal] ;
        }
        else{
            [cell.followBtn setTitle:UNFOLLOW_TEXT forState:UIControlStateNormal] ;
            [cell.followBtn setBackgroundImage:[UIImage imageNamed:UNFOLLOW_BUTTON_ICON] forState:UIControlStateNormal] ;
        }
        
        return cell;
    }
    else if(indexPath.section == CAMPAIGN_TARGET_MARKET_SECTION_INDEX || indexPath.section == CAMPAIGN_CAMP_KEYWORDS_SECTION_INDEX){
        KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KEYWORDS_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        [UtilityClass setButtonBorder:cell.button] ;
        cell.tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
        cell.tagsScrollView.backgroundColor = [UIColor clearColor] ;
        cell.tagsScrollView.tag = indexPath.row ;
        cell.button.tag = indexPath.row ;
        cell.plusBtn.tag = indexPath.row ;
        
        NSMutableArray *tags ;
        if(indexPath.section == CAMPAIGN_TARGET_MARKET_SECTION_INDEX ) tags = [selectedKeywordsArray mutableCopy] ;
        else tags = [selectedCampKeywordsArray mutableCopy] ;
        
        if(tags.count >0)[cell.button setHidden:YES] ;
        else [cell.button setHidden:NO] ;
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
    else if(indexPath.section <= CAMPAIGN_FUND_RAISED_SECTION_INDEX && indexPath.section != CAMPAIGN_TARGET_MARKET_SECTION_INDEX && indexPath.section != CAMPAIGN_CAMP_KEYWORDS_SECTION_INDEX && indexPath.section != CAMPAIGN_NAME_SECTION_INDEX){
        DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LABEL_CELL_IDENTIFIER forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        [self setUpCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    else if(indexPath.section == CAMPAIGN_SUMMARY_SECTION_INDEX) {
        DescriptionTableViewCell *cell = (DescriptionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:SUMMARY_CELL_IDENTIFIER] ;
        cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
        return cell ;
    }
    else if(indexPath.section == CAMPAIGN_IMAGES_SECTION_INDEX) {
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
        if(indexPath.section == CAMPAIGN_DOCUMENTS_SECTION_INDEX)
            cell.lbl.text = [NSString stringWithFormat:@"Docuement %ld",indexPath.row+1] ;
        else if(indexPath.section == CAMPAIGN_AUIDIOS_SECTION_INDEX)
            cell.lbl.text = [NSString stringWithFormat:@"Audio %ld",indexPath.row+1] ;
        else
            cell.lbl.text = [NSString stringWithFormat:@"Video %ld",indexPath.row+1] ;
        /*if(indexPath.section == CAMPAIGN_DOCUMENTS_SECTION_INDEX) cell.lbl.text = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[docuementsArray objectAtIndex:indexPath.row] valueForKey:@"file"]] ;
        else if(indexPath.section == CAMPAIGN_AUIDIOS_SECTION_INDEX) cell.lbl.text = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[audiosArray objectAtIndex:indexPath.row] valueForKey:@"file"]] ;
        else cell.lbl.text = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[videosArray objectAtIndex:indexPath.row] valueForKey:@"file"]] ;*/
        return cell ;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionsArray.count+1 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == CAMPAIGN_NAME_SECTION_INDEX)
        return 45 ;
    else if(indexPath.section <= CAMPAIGN_FUND_RAISED_SECTION_INDEX && indexPath.section != CAMPAIGN_TARGET_MARKET_SECTION_INDEX && indexPath.section != CAMPAIGN_CAMP_KEYWORDS_SECTION_INDEX && indexPath.section != CAMPAIGN_NAME_SECTION_INDEX)
    {
        static DynamicTableViewCell *cell = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            cell = [self.tblView dequeueReusableCellWithIdentifier:LABEL_CELL_IDENTIFIER];
        });
        
        [self setUpCell:cell atIndexPath:indexPath];
        
        return [self calculateHeightForConfiguredSizingCell:cell];
    }
    else if(indexPath.section == CAMPAIGN_SUMMARY_SECTION_INDEX || indexPath.section == CAMPAIGN_IMAGES_SECTION_INDEX)
        return 100 ;
    else if(indexPath.section == CAMPAIGN_TARGET_MARKET_SECTION_INDEX || indexPath.section == CAMPAIGN_CAMP_KEYWORDS_SECTION_INDEX || indexPath.section == sectionsArray.count)
        return 70 ;
    else if(indexPath.section == CAMPAIGN_DOCUMENTS_SECTION_INDEX || indexPath.section == CAMPAIGN_AUIDIOS_SECTION_INDEX || indexPath.section == CAMPAIGN_VIDEOS_SECTION_INDEX )
        return 45 ;
    else
        return 45 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section <= CAMPAIGN_FUND_RAISED_SECTION_INDEX || section == sectionsArray.count)return 0;
    else return 45 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,45)];
    sectionView.tag=section;
    
    // Background view
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, tableView.frame.size.width,35)];
    bgView.backgroundColor=[UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1];
    
    // Title Label
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.tblView.frame.size.width-20, 35)];
    viewLabel.backgroundColor=[UIColor clearColor];
    viewLabel.textColor = [UIColor colorWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1];
    viewLabel.font=[UIFont systemFontOfSize:15];
    viewLabel.text=[[sectionsArray objectAtIndex:section] valueForKey:@"field"];
    
    // Expand-Collapse icon
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.tblView.frame.size.width-34,viewLabel.frame.origin.y+viewLabel.frame.size.height/2-7 ,14, 14)];
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
    if(indexPath.section >= CAMPAIGN_DOCUMENTS_SECTION_INDEX && indexPath.section < sectionsArray.count){
        
        NSString *filePath ;
        if(indexPath.section == CAMPAIGN_DOCUMENTS_SECTION_INDEX) {
            filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[docuementsArray objectAtIndex:indexPath.row] valueForKey:@"file"]] ;
            dataTitle.text = @"Document" ;
        }
        else if(indexPath.section == CAMPAIGN_AUIDIOS_SECTION_INDEX) {
            filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[audiosArray objectAtIndex:indexPath.row] valueForKey:@"file"]] ;
             dataTitle.text = @"Audio" ;
        }
        else {
            filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[videosArray objectAtIndex:indexPath.row] valueForKey:@"file"]] ;
             dataTitle.text = @"Video" ;
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:filePath]];
        
       /* NSString* htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:htmlString baseURL:nil];
        
        campaignDataView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width-30, self.view.frame.size.height-20);
        campaignDataView.backgroundColor = [UtilityClass backgroundColor];
        campaignDataView.layer.cornerRadius = 12.0;
        
        KLCPopupLayout layout = KLCPopupLayoutMake((KLCPopupHorizontalLayout)KLCPopupHorizontalLayoutCenter,
                                                   (KLCPopupVerticalLayout)KLCPopupVerticalLayoutCenter);
        
        KLCPopup* popup = [KLCPopup popupWithContentView:campaignDataView
                                                showType:(KLCPopupShowType)KLCPopupShowTypeBounceInFromTop
                                             dismissType:(KLCPopupDismissType)KLCPopupDismissTypeBounceOutToBottom
                                                maskType:(KLCPopupMaskType)KLCPopupMaskTypeDimmed
                                dismissOnBackgroundTouch:YES
                                   dismissOnContentTouch:NO];
        
        [popup showWithLayout:layout];*/
    }
}

# pragma mark - Cell Setup
- (void)setUpCell:(DynamicTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == CAMPAIGN_TARGET_AMOUNT_SECTION_INDEX || indexPath.section == CAMPAIGN_FUND_RAISED_SECTION_INDEX){
        
        float floatValue = [[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"] floatValue] ;
        cell.label.text = [NSString stringWithFormat:@"%@: $%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"],[formatter stringFromNumber:[NSNumber numberWithDouble:floatValue]]] ;
    }
    else cell.label.text = [NSString stringWithFormat:@"%@: %@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"],[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
    
    cell.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
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
