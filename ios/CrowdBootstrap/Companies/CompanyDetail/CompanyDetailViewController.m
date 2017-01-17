//
//  CompanyDetailViewController.m
//  CrowdBootstrap
//
//  Created by Shikha Singla on 22/11/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "CampaignDocumentTableViewCell.h"
#import "GraphicTableViewCell.h"
#import "KLCPopup.h"
#import "DynamicTableViewCell.h"
#import "KeywordsTableViewCell.h"
#import "DescriptionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FollowCampaignTableViewCell.h"

@interface CompanyDetailViewController ()

@end

@implementation CompanyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetUISetiings] ;
    [self popUpScrollViewSettings] ;
}

- (void) viewDidAppear:(BOOL)animated {
    [self initializeSectionArray] ;
    [self getCompanyDetail] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISetiings{
    
    companyData = [[UtilityClass getCompanyDetails] mutableCopy];
    NSLog(@"Company Data: %@",companyData) ;
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = [NSString stringWithFormat:@"%@",[companyData valueForKey:kSearchCompanyAPI_Company_Name]] ;
    [self initializeSectionArray] ;
    [self getCompanyDetail] ;
}

-(void)initializeSectionArray {
    
    NSArray *fieldsArray = @[@"Name", @"Company Keyword", @"Summary", @"Company Image",@"View Document",@"Play Audio",@"Play Video"] ;
    NSArray *parametersArray = @[kCompanyDetailAPI_CompanyName,kCompanyDetailAPI_CompanyKeywords,kCompanyDetailAPI_Summary,kCompanyDetailAPI_CompanyImage,kCompanyDetailAPI_DocumentsList,kCompanyDetailAPI_AudiosList,kCompanyDetailAPI_VideosList] ;
    
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
    
    selectedCompanyKeywordsArray = [[NSMutableArray alloc] init] ;
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
-(void)getCompanyDetail {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCompanyDetailAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[companyData valueForKey:kCompanyDetailAPI_CompanyID]] forKey:kCompanyDetailAPI_CompanyID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        [ApiCrowdBootstrap viewCompanyWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                if([responseDict valueForKey:kCompanyDetailAPI_CompanyDetail]) {
                    NSArray *arr = [responseDict valueForKey:kCompanyDetailAPI_CompanyDetail] ;
                    NSDictionary *dict = [arr objectAtIndex:0] ;
                    for ( int i = 0; i < sectionsArray.count ; i++ ) {
                        NSString *key = [[sectionsArray objectAtIndex:i] valueForKey:@"key"] ;
                        if(i != COMPANY_KEYWORDS_SECTION_INDEX && i != COMPANY_DOCUMENTS_SECTION_INDEX  && i != COMPANY_AUIDIOS_SECTION_INDEX && i != COMPANY_VIDEOS_SECTION_INDEX){
                            if([dict valueForKey:key])
                                [[sectionsArray objectAtIndex:i] setValue:[dict valueForKey:key] forKey:@"value"] ;
                        }
                    }
                    
                    if([dict objectForKey:kCompanyDetailAPI_CompanyKeywords])
                        selectedCompanyKeywordsArray = [self resetTagsArrayWithData:[dict objectForKey:kCompanyDetailAPI_CompanyKeywords]] ;
                    
                    if([dict objectForKey:kCompanyDetailAPI_AudiosList])
                        audioFile = [dict objectForKey:kCompanyDetailAPI_AudiosList] ;
                    
                    if([dict objectForKey:kCompanyDetailAPI_VideosList])
                        videoFile = [dict objectForKey:kCompanyDetailAPI_VideosList] ;
                    
                    if([dict objectForKey:kCompanyDetailAPI_DocumentsList])
                        docuementFile = [dict objectForKey:kCompanyDetailAPI_DocumentsList] ;
                    
                    // Refresh Dict
                    [companyData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kCompanyDetailAPI_CompanyName]] forKey:kCompanyDetailAPI_CompanyName] ;
                    [companyData setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:kCompanyDetailAPI_Summary]] forKey:kCompanyDetailAPI_Summary] ;
                    
                    [UtilityClass setCompanyDetails:[companyData mutableCopy]] ;
                    
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
    [companyDataView dismissPresentingPopup] ;
}

- (IBAction)CloseImgPopupView_ClickAction:(id)sender {
    [imgPopupView dismissPresentingPopup] ;
}

- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
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
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
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

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section <= COMPANY_KEYWORDS_SECTION_INDEX) return 1;
    else {
        if(section == COMPANY_SUMMARY_SECTION_INDEX || section == COMPANY_IMAGES_SECTION_INDEX){
            if ([[arrayForBool objectAtIndex:section] boolValue]) return 1;
            else return 0 ;
        }
        else if(section == COMPANY_DOCUMENTS_SECTION_INDEX ) {
            if ([[arrayForBool objectAtIndex:section] boolValue]) return 1;
            else  return 0 ;
        }
        else if(section == COMPANY_AUIDIOS_SECTION_INDEX) {
            if ([[arrayForBool objectAtIndex:section] boolValue]) return 1;
            else  return 0 ;
        }
        else {
            if ([[arrayForBool objectAtIndex:section] boolValue]) return 1;
            else  return 0 ;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == COMPANY_NAME_SECTION_INDEX){
        FollowCampaignTableViewCell *cell = (FollowCampaignTableViewCell*)[tableView dequeueReusableCellWithIdentifier:FOLLOW_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        [UtilityClass setViewBorder:cell.lblView] ;
        cell.lbl.text = [NSString stringWithFormat:@"%@: %@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"],[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
        cell.followBtn.hidden = true;
        return cell;
    }
    else if(indexPath.section == COMPANY_KEYWORDS_SECTION_INDEX){
        KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KEYWORDS_CELL_IDENTIFIER] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        [UtilityClass setButtonBorder:cell.button] ;
        cell.tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
        cell.tagsScrollView.backgroundColor = [UIColor clearColor] ;
        cell.tagsScrollView.tag = indexPath.row ;
        cell.button.tag = indexPath.row ;
        cell.plusBtn.tag = indexPath.row ;
        
        NSMutableArray *tags = [selectedCompanyKeywordsArray mutableCopy] ;
        
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
    else if(indexPath.section < COMPANY_SUMMARY_SECTION_INDEX && indexPath.section != COMPANY_KEYWORDS_SECTION_INDEX && indexPath.section != COMPANY_NAME_SECTION_INDEX){
        DynamicTableViewCell *cell = [self.tblView dequeueReusableCellWithIdentifier:LABEL_CELL_IDENTIFIER forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        [self setUpCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    else if(indexPath.section == COMPANY_SUMMARY_SECTION_INDEX){
        DescriptionTableViewCell *cell = (DescriptionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:SUMMARY_CELL_IDENTIFIER] ;
        cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
        return cell ;
    }
    else if(indexPath.section == COMPANY_IMAGES_SECTION_INDEX){
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
        if(indexPath.section == COMPANY_DOCUMENTS_SECTION_INDEX) cell.lbl.text = [NSString stringWithFormat:@"Docuement %ld",indexPath.row+1] ;
        else if(indexPath.section == COMPANY_AUIDIOS_SECTION_INDEX) cell.lbl.text = [NSString stringWithFormat:@"Audio %ld",indexPath.row+1] ;
        else cell.lbl.text = [NSString stringWithFormat:@"Video %ld",indexPath.row+1] ;
        /*if(indexPath.section == CAMPAIGN_DOCUMENTS_SECTION_INDEX) cell.lbl.text = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[docuementsArray objectAtIndex:indexPath.row] valueForKey:@"file"]] ;
         else if(indexPath.section == CAMPAIGN_AUIDIOS_SECTION_INDEX) cell.lbl.text = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[audiosArray objectAtIndex:indexPath.row] valueForKey:@"file"]] ;
         else cell.lbl.text = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[videosArray objectAtIndex:indexPath.row] valueForKey:@"file"]] ;*/
        return cell ;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionsArray.count ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == COMPANY_NAME_SECTION_INDEX)
        return 45 ;
    else if(indexPath.section != COMPANY_KEYWORDS_SECTION_INDEX && indexPath.section != COMPANY_NAME_SECTION_INDEX)
    {
        static DynamicTableViewCell *cell = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            cell = [self.tblView dequeueReusableCellWithIdentifier:LABEL_CELL_IDENTIFIER];
        });
        
        [self setUpCell:cell atIndexPath:indexPath];

        return [self calculateHeightForConfiguredSizingCell:cell];
    }
    else if(indexPath.section == COMPANY_SUMMARY_SECTION_INDEX || indexPath.section == COMPANY_IMAGES_SECTION_INDEX)
        return 100 ;
    else if(indexPath.section == COMPANY_KEYWORDS_SECTION_INDEX || indexPath.section == sectionsArray.count)
        return 70 ;
    else if(indexPath.section == COMPANY_DOCUMENTS_SECTION_INDEX || indexPath.section == COMPANY_AUIDIOS_SECTION_INDEX || indexPath.section == COMPANY_VIDEOS_SECTION_INDEX )
        return 45 ;
    else
        return 45 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section < COMPANY_SUMMARY_SECTION_INDEX)
        return 0;
    else
        return 45 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,45)];
    sectionView.tag = section;
    
    // Background view
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, tableView.frame.size.width,35)];
    bgView.backgroundColor = [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1];
    
    // Title Label
    UILabel *viewLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.tblView.frame.size.width-20, 35)];
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section >= COMPANY_DOCUMENTS_SECTION_INDEX && indexPath.section < sectionsArray.count) {
        
        NSString *filePath ;
        if(indexPath.section == COMPANY_DOCUMENTS_SECTION_INDEX) {
            filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,docuementFile] ;
            dataTitle.text = @"Document" ;
        }
        else if(indexPath.section == COMPANY_AUIDIOS_SECTION_INDEX) {
            filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,audioFile] ;
            dataTitle.text = @"Audio" ;
        }
        else {
            filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,videoFile] ;
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
    cell.label.text = [NSString stringWithFormat:@"%@: %@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"],[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
    
    cell.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1]CGColor];
    cell.layer.borderWidth = 1.0;
}

@end
