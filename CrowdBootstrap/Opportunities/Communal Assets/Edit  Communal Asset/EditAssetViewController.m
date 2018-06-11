//
//  EditAssetViewController.m
//  CrowdBootstrap
//
//  Created by osx on 03/02/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "EditAssetViewController.h"

#import "KLCPopup.h"
#import "TextFieldTableViewCell.h"
#import "KeywordsTableViewCell.h"
#import "CommitTableViewCell.h"
#import "DescriptionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "PaymentsTableViewCell.h"
#import "FollowCampaignTableViewCell.h"
#import "GraphicTableViewCell.h"
#import "DobTableViewCell.h"
#import "CampaignDocumentTableViewCell.h"
#import "UserFundTableViewCell.h"
#import "PublicProfileViewController.h"

@interface EditAssetViewController ()

@end

@implementation EditAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetUISettings] ;
}

-(void) awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SetViewEditingNotification:) name:kNotificationSetCommunalAssetViewEditing
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)SetViewEditingNotification:(NSNotification *)notification {
    if ([[notification name] isEqualToString:kNotificationSetCommunalAssetViewEditing]) {
        NSDictionary *dict = notification.userInfo;
        
        NSString *segment = [NSString stringWithFormat:@"%@",[dict valueForKey:@"segment"]];
        NSString *segmentControl = [NSString stringWithFormat:@"%@",[dict valueForKey:@"segmentControl"]];
        
        selectedSegment = [segment integerValue];
        selectedSegmentControl = [segmentControl integerValue];
        NSLog(@"Selected Segment: %ld", (long)selectedSegment);
        NSLog(@"Selected Segment: %ld", (long)selectedSegmentControl);
    }
}

-(void)resetUISettings {
    
    communalAssetData = [[UtilityClass getCommunalAssetDetails] mutableCopy];
    NSLog(@"Communal Asset Data: %@",communalAssetData) ;
    
    /*
    if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0)) {
        constraintTblViewTop.constant = 50;
        btnSearchRecommUser.hidden = false;
    } else {
        constraintTblViewTop.constant = 10;
        btnSearchRecommUser.hidden = true;
    }
    */
    constraintTblViewTop.constant = 10;
    btnSearchRecommUser.hidden = true;

    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblViewUsers.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    viewPopUp.layer.borderWidth = 1.0;
    viewPopUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.title = [NSString stringWithFormat:@"%@",[communalAssetData valueForKey:kCommunalAssetAPI_Title]] ;
    [self getCommunalAssetDetails] ;
    
    [self initializeSectionArray] ;
}

-(void)initializeSectionArray {
    
    NSArray *fieldsArray = @[@"Created By", @"Communal Asset Title", @"Communal Asset Description", @"Communal Asset Start Date", @"Communal Asset End Date", @"Target Market", @"Communal Asset Keywords", @"Interest Keywords", @"Upload Image", @"View Document",@"Play Audio",@"Play Video"] ;
    NSArray *parametersArray = @[kCommunalAssetAPI_CreatedBy, kCommunalAssetAPI_Title, kCommunalAssetAPI_Description, kCommunalAssetAPI_StartDate, kCommunalAssetAPI_EndDate, kAddCommunalAssetAPI_Target_Market_Keywords, kAddCommunalAssetAPI_Keywords, kAddCommunalAssetAPI_IndustryKeywords, kCommunalAssetAPI_Image, kCommunalAssetAPI_Document, kCommunalAssetAPI_Audio, kCommunalAssetAPI_Video] ;
    
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
    targetMarketKeywordsArray = [[NSMutableArray alloc] init] ;
    industryKeywordsArray = [[NSMutableArray alloc] init] ;
    communalAssetKeywordsArray = [[NSMutableArray alloc] init] ;
    
    selectedTargetMarketKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedIndustryKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedCommunalAssetKeywordsArray = [[NSMutableArray alloc] init] ;
    
    selectedTargetMarketKeywordIds = [[NSMutableArray alloc] init] ;
    selectedIndustryKeywordIds = [[NSMutableArray alloc] init] ;
    selectedCommunalAssetKeywordIds = [[NSMutableArray alloc] init] ;
    
    selectedTargetMarketKeywordNames = [[NSMutableArray alloc] init] ;
    selectedIndustryKeywordNames = [[NSMutableArray alloc] init] ;
    selectedCommunalAssetKeywordNames = [[NSMutableArray alloc] init] ;
    
    usersArray = [[NSMutableArray alloc] init];
    searchResultsForRegisteredUsers = [[NSMutableArray alloc] init];
    searchResultsForKeywords = [[NSMutableArray alloc] init];
    
    prevDueDate       = @"" ;
    
    selectedDatePickerType = -1 ;
    selectedKeywordType = -1;
    
    [datePickerView setMinimumDate:[NSDate date]] ;
    [datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    [self getCommunalAssetKeywordsList];
    [self getCommunalAssetIndustryKeywordsList];
    [self getTargetMarketKeywordsList];
    
    [self.tblView reloadData] ;
}

- (void)checkKeywordsListFound:(int)keywordType {
    switch (keywordType) {
        case 5:
        {
            if (targetMarketKeywordsArray.count > 0)
                [self openTagsPopup] ;
            else
                [self presentViewController:[UtilityClass displayAlertMessage:kNoTargetMarketKeywordsFoundMessage] animated:YES completion:nil];
        }
            break;
        case 7:
        {
            if (industryKeywordsArray.count > 0)
                [self openTagsPopup] ;
            else
                [self presentViewController:[UtilityClass displayAlertMessage:kNoIndustryKeywordsFoundMessage] animated:YES completion:nil];
        }
            break;
        case 6:
        {
            if (communalAssetKeywordsArray.count > 0)
                [self openTagsPopup] ;
            else
                [self presentViewController:[UtilityClass displayAlertMessage:kNoCommunalAssetKeywordsFoundMessage] animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Tap gesture
- (void)txtViewTapped_Gesture:(UITapGestureRecognizer *)gestureRecognizer {
    selectedKeywordType = (int)[gestureRecognizer.view tag] ;
    if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0))
        [self checkKeywordsListFound:selectedKeywordType];
}

-(void)openTagsPopup {
    [self.view endEditing:YES] ;
    [popupTblView reloadData] ;
    [UtilityClass displayPopupWithContentView:popupView view:self.view] ;
}

-(NSMutableArray*)resetTagsArrayWithData:(NSArray*)array {
    NSMutableArray *tagsArray = [[NSMutableArray alloc] init] ;
    for (NSDictionary *obj in array) {
        [tagsArray addObject:[obj valueForKey:@"name"]] ;
    }
    return tagsArray ;
}

-(NSMutableArray*)resetTagIdsArrayWithData:(NSArray*)array {
    NSMutableArray *tagsArray = [[NSMutableArray alloc] init] ;
    for (NSDictionary *obj in array) {
        [tagsArray addObject:[obj valueForKey:@"id"]] ;
    }
    return tagsArray ;
}

-(NSString*)convertTagsArrayToStringforArray:(NSMutableArray*)array withTagsArray:(NSArray*)tagsArray tagType:(NSString *)type {
    NSString *tagsStr = @"" ;
    BOOL isFirstTag = YES ;
    
    if ([type isEqualToString:@"targetmarket"]) {
        for (NSDictionary *dict in tagsArray) {
            NSString *value = [dict valueForKey:kCommunalAssetAPI_Target_Market_ID] ;
            for (NSString *obj in array) {
                NSString *selectedValue;
                if ([obj valueForKey:kCommunalAssetAPI_Target_Market_ID])
                    selectedValue = [obj valueForKey:kCommunalAssetAPI_Target_Market_ID] ;
                else
                    selectedValue = [obj valueForKey:kCommunalAssetAPI_Target_Market_ID] ;
                
                if([selectedValue intValue] == [value intValue]){
                    if(isFirstTag)
                        tagsStr = [dict valueForKey:kCommunalAssetAPI_Target_Market_ID] ;
                    else tagsStr = [NSString stringWithFormat:@"%@,%@",tagsStr,[dict valueForKey:kCommunalAssetAPI_Target_Market_ID]] ;
                    isFirstTag = NO ;
                }
            }
        }
    } else if ([type isEqualToString:@"CommunalAssetkeyword"]) {
        for (NSDictionary *dict in tagsArray) {
            NSString *value = [dict valueForKey:kCommunalAssetAPI_KeywordID] ;
            for (NSString *obj in array) {
                NSString *selectedValue;
                if ([obj valueForKey:kCommunalAssetAPI_KeywordID])
                    selectedValue = [obj valueForKey:kCommunalAssetAPI_KeywordID] ;
                else
                    selectedValue = [obj valueForKey:kCommunalAssetAPI_KeywordID] ;
                
                if([selectedValue intValue] == [value intValue]){
                    if(isFirstTag) tagsStr = [dict valueForKey:kCommunalAssetAPI_KeywordID] ;
                    else tagsStr = [NSString stringWithFormat:@"%@,%@",tagsStr,[dict valueForKey:kCommunalAssetAPI_KeywordID]] ;
                    isFirstTag = NO ;
                }
            }
        }
    } else if ([type isEqualToString:@"industry"]) {
        for (NSDictionary *dict in tagsArray) {
            NSString *value = [dict valueForKey:kCommunalAssetAPI_Industry_ID] ;
            for (NSString *obj in array) {
                NSString *selectedValue;
                if ([obj valueForKey:kCommunalAssetAPI_Industry_ID])
                    selectedValue = [obj valueForKey:kCommunalAssetAPI_Industry_ID] ;
                else
                    selectedValue = [obj valueForKey:kCommunalAssetAPI_Industry_ID] ;
                
                if([selectedValue intValue] == [value intValue]){
                    if(isFirstTag) tagsStr = [dict valueForKey:kCommunalAssetAPI_Industry_ID] ;
                    else tagsStr = [NSString stringWithFormat:@"%@,%@",tagsStr,[dict valueForKey:kCommunalAssetAPI_Industry_ID]] ;
                    isFirstTag = NO ;
                }
            }
        }
    }
    return tagsStr ;
}

#pragma mark - Keywords Popup Buttons Action
- (IBAction)AddTag_ClickAction:(id)sender {
    selectedKeywordType = (int)[sender tag] ;
    if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0))
        [self checkKeywordsListFound:selectedKeywordType];
}

- (IBAction)CheckUncheck_ClickAction:(id)sender {
    UIButton *btn = (UIButton*)sender ;
    if([btn.accessibilityLabel isEqualToString:CHECK_IMAGE ]) { // Check
        [btn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = UNCHECK_IMAGE ;
        
        NSDictionary *dictKeyword = [[NSDictionary alloc] init];
        
        if (![searchBarKeywords.text isEqualToString:@""])
            dictKeyword = [searchResultsForKeywords objectAtIndex:btn.tag];
        else {
            if(selectedKeywordType == COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SELECTED)
                dictKeyword = [industryKeywordsArray objectAtIndex:btn.tag];
            else if (selectedKeywordType == COMMUNAL_ASSET_KEYWORDS_SELECTED)
                dictKeyword = [communalAssetKeywordsArray objectAtIndex:btn.tag];
            else
                dictKeyword = [targetMarketKeywordsArray objectAtIndex:btn.tag];
        }
        [dictKeyword setValue:@"0" forKey:@"isSelected"];
    }
    else{ // Uncheck
        [btn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = CHECK_IMAGE ;
        NSDictionary *dictKeyword = [[NSDictionary alloc] init];
        
        if (![searchBarKeywords.text isEqualToString:@""])
            dictKeyword = [searchResultsForKeywords objectAtIndex:btn.tag];
        else {
            if(selectedKeywordType == COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SELECTED)
                dictKeyword = [industryKeywordsArray objectAtIndex:btn.tag];
            else if (selectedKeywordType == COMMUNAL_ASSET_KEYWORDS_SELECTED)
                dictKeyword = [communalAssetKeywordsArray objectAtIndex:btn.tag];
            else
                dictKeyword = [targetMarketKeywordsArray objectAtIndex:btn.tag];
        }
        [dictKeyword setValue:@"1" forKey:@"isSelected"];
    }
}

- (IBAction)OK_ClickAction:(id)sender {
    [popupView removeFromSuperview];
    searchBarKeywords.text = @"";
    
    if(selectedKeywordType == COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SELECTED) {
        [selectedIndustryKeywordsArray removeAllObjects] ;
        [selectedIndustryKeywordNames removeAllObjects];
        [selectedIndustryKeywordIds removeAllObjects];
        
        for (NSMutableDictionary *obj in industryKeywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"]) {
                [selectedIndustryKeywordsArray addObject:obj] ;
                [selectedIndustryKeywordNames addObject:[obj valueForKey:kCommunalAssetAPI_Industry_Name]] ;
                [selectedIndustryKeywordIds addObject:[obj valueForKey:kCommunalAssetAPI_Industry_ID]] ;
            }
        }
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
    } else if(selectedKeywordType == COMMUNAL_ASSET_KEYWORDS_SELECTED) {
        [selectedCommunalAssetKeywordsArray removeAllObjects];
        [selectedCommunalAssetKeywordNames removeAllObjects];
        [selectedCommunalAssetKeywordIds removeAllObjects];
        
        for (NSMutableDictionary *obj in communalAssetKeywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"]) {
                [selectedCommunalAssetKeywordsArray addObject:obj] ;
                [selectedCommunalAssetKeywordNames addObject:[obj valueForKey:kCommunalAssetAPI_KeywordName]] ;
                [selectedCommunalAssetKeywordIds addObject:[obj valueForKey:kCommunalAssetAPI_KeywordID]] ;
            }
        }
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
    } else {
        [selectedTargetMarketKeywordsArray removeAllObjects] ;
        [selectedTargetMarketKeywordNames removeAllObjects];
        [selectedTargetMarketKeywordIds removeAllObjects];
        
        for (NSMutableDictionary *obj in targetMarketKeywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"]) {
                [selectedTargetMarketKeywordsArray addObject:obj] ;
                [selectedTargetMarketKeywordNames addObject:[obj valueForKey:kCommunalAssetAPI_Target_Market_Name]] ;
                [selectedTargetMarketKeywordIds addObject:[obj valueForKey:kCommunalAssetAPI_Target_Market_ID]] ;
            }
        }
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_TARGET_MARKET_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
    }
}

#pragma mark - Validation Methods
-(BOOL)validatetextFieldsWithSectionIndex:(int)section {
    
    NSString *value = [[sectionsArray objectAtIndex:section] valueForKey:@"value"] ;
    NSLog(@"value: %@",value) ;
    if(value.length < 1 ){
        [self presentViewController:[UtilityClass displayAlertMessage:[NSString stringWithFormat:@"%@%@",[[sectionsArray objectAtIndex:section] valueForKey:@"field"],kAlert_SignUp_BlankField]] animated:YES completion:nil];
        return NO ;
    }
    return YES ;
}

#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

-(void)tagsControl:(UIView *)tag withTagControlIndex:(NSInteger)tagControlIndex removedFromIndex:(NSInteger)index {
    NSLog(@"index: %ld control: %ld", (long)index,(long)tagControlIndex);
    [tag removeFromSuperview];
    
    if(tagControlIndex == COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SELECTED) {
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedIndustryKeywordNames objectAtIndex:index]] ;
        for (int i=0; i<industryKeywordsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[industryKeywordsArray objectAtIndex:i] valueForKey:kCommunalAssetAPI_Industry_Name]] ;
            if([keywordName isEqualToString:selectedName]){
                [[industryKeywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedIndustryKeywordsArray removeObjectAtIndex:index] ;
        [selectedIndustryKeywordNames removeObjectAtIndex:index];
        [selectedIndustryKeywordIds removeObjectAtIndex:index];
        
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
    } else if(tagControlIndex == COMMUNAL_ASSET_KEYWORDS_SELECTED) {
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedCommunalAssetKeywordNames objectAtIndex:index]] ;
        for (int i=0; i<communalAssetKeywordsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[communalAssetKeywordsArray objectAtIndex:i] valueForKey:kCommunalAssetAPI_KeywordName]] ;
            if([keywordName isEqualToString:selectedName]){
                [[communalAssetKeywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedCommunalAssetKeywordsArray removeObjectAtIndex:index] ;
        [selectedCommunalAssetKeywordNames removeObjectAtIndex:index];
        [selectedCommunalAssetKeywordIds removeObjectAtIndex:index];
        
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
    } else {
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedTargetMarketKeywordNames objectAtIndex:index]] ;
        for (int i=0; i<targetMarketKeywordsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[targetMarketKeywordsArray objectAtIndex:i] valueForKey:kCommunalAssetAPI_Target_Market_Name]] ;
            if([keywordName isEqualToString:selectedName]){
                [[targetMarketKeywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedTargetMarketKeywordsArray removeObjectAtIndex:index] ;
        [selectedTargetMarketKeywordNames removeObjectAtIndex:index];
        [selectedTargetMarketKeywordIds removeObjectAtIndex:index];
        
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_TARGET_MARKET_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
    }
}

-(void)navigateToScreenWithViewIdentifier:(NSString *)viewIdentifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:viewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [UtilityClass setComingFrom_CommunalAsset_AddEditScreen:YES];
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)CloseData_ClickAction:(id)sender {
    [communalAssetDataView dismissPresentingPopup] ;
}

- (IBAction)followButton_ClickAction:(UIButton*)button {
    
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_FollowedBy] ;
        [dictParam setObject:[[[UtilityClass getCommunalAssetDetails] mutableCopy] valueForKey:kCommunalAssetAPI_ID] forKey:kCommunalAssetAPI_AssetID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        if (isFollowed == 0) {
            [ApiCrowdBootstrap followCommunalAssetWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"responseDict %@", responseDict);
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                    if(isFollowed == 0)
                        isFollowed = 1 ;
                    else
                        isFollowed = 0 ;
                    
                    [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_FOLLOW_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationNone] ;
                }
                else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                    [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                
            } failure:^(NSError *error) {
                [UtilityClass displayAlertMessage:error.description] ;
                [UtilityClass hideHud] ;
            }] ;
        } else {
            [ApiCrowdBootstrap unfollowCommunalAssetWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"responseDict %@", responseDict);
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                    if(isFollowed == 1)
                        isFollowed = 0 ;
                    else
                        isFollowed = 1 ;
                    
                    [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_FOLLOW_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationNone] ;
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

- (IBAction)Calender_ClickAction:(id)sender {
    DobTableViewCell *cell;
    if ([sender tag] == COMMUNAL_ASSET_START_DATE_SECTION_INDEX)
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_START_DATE_SECTION_INDEX]] ;
    else
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_END_DATE_SECTION_INDEX]] ;
    
    [datePickerView setDate:[dateFormatter dateFromString:cell.textFld.text] animated:YES] ;
    [cell.textFld becomeFirstResponder] ;
}

- (IBAction)likeButton_ClickAction:(UIButton*)button {
    
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[[[UtilityClass getCommunalAssetDetails] mutableCopy] valueForKey:kCommunalAssetAPI_ID] forKey:kCommunalAssetAPI_AssetID] ;
        
        if (isLiked == 0) {
            [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_LikedBy] ;
            NSLog(@"dictParam: %@",dictParam) ;
            
            [ApiCrowdBootstrap likeCommunalAssetWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"responseDict %@", responseDict);
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                    if(isLiked == 0)
                        isLiked = 1 ;
                    else
                        isLiked = 0 ;
                    
                    [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_FOLLOW_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationNone] ;
                }
                else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                    [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                
            } failure:^(NSError *error) {
                [UtilityClass displayAlertMessage:error.description] ;
                [UtilityClass hideHud] ;
            }] ;
        } else {
            [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_DislikedBy] ;
            NSLog(@"dictParam: %@",dictParam) ;
            
            [ApiCrowdBootstrap dislikeCommunalAssetWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"responseDict %@", responseDict);
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                    if(isLiked == 1)
                        isLiked = 0 ;
                    else
                        isLiked = 1 ;
                    
                    [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_FOLLOW_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationNone] ;
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

- (IBAction)Browse_ClickAction:(id)sender {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Choose From Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController.view setTintColor:[UtilityClass blueColor]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil] ;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:([sender tag] == IMAGE_SELECTED?@"Upload Image":@"Upload Video") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([sender tag] == IMAGE_SELECTED)[self displayImagePickerWithType:NO withMediaType:YES] ;
        else [self displayImagePickerWithType:NO withMediaType:NO] ;
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:([sender tag] == IMAGE_SELECTED?@"Take Picture":@"Record Video") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([sender tag] == IMAGE_SELECTED)[self displayImagePickerWithType:YES withMediaType:YES] ;
        else [self displayImagePickerWithType:YES withMediaType:NO] ;
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)Submit_ClickAction:(id)sender {
    if ((selectedSegmentControl == 100 && selectedSegment == 0)) {
        [self commitCommunalAsset];
    } else {
        if(![self validatetextFieldsWithSectionIndex:COMMUNAL_ASSET_TITLE_SECTION_INDEX]) return ;
        else if(![self validatetextFieldsWithSectionIndex:COMMUNAL_ASSET_START_DATE_SECTION_INDEX]) return ;
        else if(![self validatetextFieldsWithSectionIndex:COMMUNAL_ASSET_END_DATE_SECTION_INDEX]) return ;
        else if(![self validatetextFieldsWithSectionIndex:COMMUNAL_ASSET_DESCRIPTION_SECTION_INDEX]) return ;
        
        else if(selectedIndustryKeywordsArray.count < 1) {
            [self presentViewController:[UtilityClass displayAlertMessage:kAlert_IndustryKeywordRequired] animated:YES completion:nil] ;
            return ;
        }
        else if(selectedCommunalAssetKeywordsArray.count < 1) {
            [self presentViewController:[UtilityClass displayAlertMessage:kAlert_KeywordRequired] animated:YES completion:nil] ;
            return ;
        }
        else if(selectedTargetMarketKeywordsArray.count < 1) {
            [self presentViewController:[UtilityClass displayAlertMessage:kAlert_PortfolioKeywordRequired] animated:YES completion:nil] ;
            return ;
        }
        else [self editCommunalAsset] ;
    }
}

- (IBAction)CommunalAssetCommitmentList_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    //    lblPeople.text = @"People Who Liked";
    //    imgVwPeople.image = [UIImage imageNamed:@"like_green"];
    
    if ([noOfcommit integerValue] > 0) {
        [self getCommunalAssetCommitmentList];
    }
}

- (IBAction)searchRecommendedUser_ClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    rowIndex = (int)[button tag];
    pageNo = 1;
    
    if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0)) {
        searchBarUsers.hidden = false;
        lblPeople.hidden = true;
        imgVwPeople.hidden = true;
    }
    
    [self getRecommendedUserList:@""];
}

- (IBAction)viewProfile_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [self.tblView setUserInteractionEnabled:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublicProfileViewController *viewController = (PublicProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:kPublicProfileIdentifier] ;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[usersArray objectAtIndex:[sender tag]] valueForKey:kCommunalAssetAPI_User_ID] forKey:kRecommendedContAPI_ContractorID] ;
    
    viewController.profileMode = [NSString stringWithFormat:@"%d",PROFILE_MODE_SEARCH] ;
    [UtilityClass setViewEntProfileMode:NO] ;
    [UtilityClass setUserType:CONTRACTOR] ;
    [UtilityClass setProfileMode:PROFILE_MODE_SEARCH] ;
    
    [UtilityClass setContractorDetails:[dict mutableCopy]] ;
    NSLog(@"getContractorDetails: %@",[UtilityClass getContractorDetails]) ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)ok_ClickAction:(id)sender {
    [viewPopUp setHidden:true];
    [self.tblView setUserInteractionEnabled:true];
}

#pragma mark - Image Picker Methods
-(void)displayImagePickerWithType:(BOOL)isCameraMode withMediaType:(BOOL)isImageSelected{
    [self dismissViewControllerAnimated:YES completion:nil] ;
    
    if (isCameraMode && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_NoCamera] animated:YES completion:nil] ;
        return ;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if(isCameraMode)
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    else
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if(isImageSelected)
        picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    else
        picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie,(NSString *)kUTTypeVideo, nil];
    
    [self.navigationController presentViewController:picker animated:YES completion:nil] ;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    GraphicTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_IMAGE_SECTION_INDEX]] ;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"info>> %@",info) ;
    if([info[UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]){
        chosenImage = info[UIImagePickerControllerEditedImage];
        cell.graphicImg.image = chosenImage;
        imgData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1);
    }
    else{
        
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
            NSString *moviePath = [videoUrl path];
            
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
            }
            videoData = [NSData dataWithContentsOfFile:moviePath] ;
        }
    }
}

#pragma mark - ToolBar Buttons Action
/*
 - (IBAction)DatePickerToolbarButtons_ClickAction:(id)sender {
 DobTableViewCell *startDatecell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_START_DATE_SECTION_INDEX]] ;
 DobTableViewCell *endDatecell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_END_DATE_SECTION_INDEX]] ;
 [startDatecell.textFld resignFirstResponder] ;
 [endDatecell.textFld resignFirstResponder] ;
 [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0:00"]];
 
 if([sender tag] == DONE_CLICKED) {
 if(selectedDatePickerType == COMMUNAL_ASSET_START_DATE_SELECTED) {
 NSDate *startDate = datePickerView.date; // start date
 NSDate *endDate = [dateFormatter dateFromString:endDatecell.textFld.text]; // end date
 
 if (endDate == nil) {
 startDatecell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
 [[sectionsArray objectAtIndex:COMMUNAL_ASSET_START_DATE_SECTION_INDEX] setValue:startDatecell.textFld.text forKey:@"value"] ;
 } else {
 NSComparisonResult result;
 
 result = [startDate compare:endDate]; // comparing two dates
 
 if(result == NSOrderedDescending) {
 NSLog(@"Start Date is greater");
 [self presentViewController:[UtilityClass displayAlertMessage:@"Start Date should not be greater than End Date"] animated:YES completion:nil];
 } else {
 startDatecell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
 [[sectionsArray objectAtIndex:COMMUNAL_ASSET_START_DATE_SECTION_INDEX] setValue:startDatecell.textFld.text forKey:@"value"] ;
 }
 }
 }
 else {
 NSDate *startDate = [dateFormatter dateFromString:startDatecell.textFld.text]; // start date
 NSDate *endDate = datePickerView.date; // end date
 
 if (startDate == nil) {
 [endDatecell.textFld setText:[dateFormatter stringFromDate:datePickerView.date]];
 [[sectionsArray objectAtIndex:COMMUNAL_ASSET_END_DATE_SECTION_INDEX] setValue:endDatecell.textFld.text forKey:@"value"] ;
 } else {
 NSComparisonResult result;
 
 result = [startDate compare:endDate]; // comparing two dates
 
 if(result == NSOrderedDescending) {
 NSLog(@"End Date is less");
 [self presentViewController:[UtilityClass displayAlertMessage:@"End Date should not be less than Start Date"] animated:YES completion:nil];
 }
 else {
 [endDatecell.textFld setText:[dateFormatter stringFromDate:datePickerView.date]];
 [[sectionsArray objectAtIndex:COMMUNAL_ASSET_END_DATE_SECTION_INDEX] setValue:endDatecell.textFld.text forKey:@"value"] ;
 }
 }
 }
 }
 else {
 if(selectedDatePickerType == COMMUNAL_ASSET_START_DATE_SELECTED)
 startDatecell.textFld.text = prevDueDate ;
 else
 endDatecell.textFld.text = prevDueDate ;
 }
 }
 */
- (IBAction)DatePickerToolbarButtons_ClickAction:(id)sender {
    DobTableViewCell *cell;
    
    if([sender tag] == DONE_CLICKED) {
        if(selectedDatePickerType == COMMUNAL_ASSET_START_DATE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_START_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:COMMUNAL_ASSET_START_DATE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
        else {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_END_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            
            [cell.textFld setText:[dateFormatter stringFromDate:datePickerView.date]];
            [[sectionsArray objectAtIndex:COMMUNAL_ASSET_END_DATE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
    }
    else {
        if(selectedDatePickerType == COMMUNAL_ASSET_START_DATE_SELECTED) {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_START_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate ;
        }
        else {
            cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_END_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate ;
        }
    }
}

#pragma mark - SearchBar Delegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //    if(searchText.length < 1 || [searchText isEqualToString:@" "])
    //        return ;
    
    if (searchBar.tag == 10) {
        [searchResultsForKeywords removeAllObjects] ;
        
        switch (selectedKeywordType) {
            case 5: // Target Keywords
            {
                for(NSDictionary *keywordDict in targetMarketKeywordsArray)
                {
                    NSString *keywordName = [keywordDict objectForKey:@"name"];
                    NSRange range = [keywordName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if(range.location != NSNotFound)
                        [searchResultsForKeywords addObject:keywordDict];
                }
                NSLog(@"Target Results: %@",searchResultsForKeywords);
            }
                break;
            case 6: // Communal Asset Keywords
            {
                for(NSDictionary *keywordDict in communalAssetKeywordsArray)
                {
                    NSString *keywordName = [keywordDict objectForKey:@"name"];
                    NSRange range = [keywordName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if(range.location != NSNotFound)
                        [searchResultsForKeywords addObject:keywordDict];
                }
                NSLog(@"Communal Asset Results: %@",searchResultsForKeywords);
            }
                break;
            case 7: // Industry Keywords
            {
                for(NSDictionary *keywordDict in industryKeywordsArray)
                {
                    NSString *keywordName = [keywordDict objectForKey:@"name"];
                    NSRange range = [keywordName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if(range.location != NSNotFound)
                        [searchResultsForKeywords addObject:keywordDict];
                }
                NSLog(@"Industry Results: %@",searchResultsForKeywords);
            }
                break;
                
            default:
                break;
        }
        [popupTblView reloadData] ;
    } else {
        pageNo = 1 ;
        totalItems = 0 ;
        [usersArray removeAllObjects] ;
        [searchResultsForRegisteredUsers removeAllObjects] ;
        [tblViewUsers reloadData] ;
        [self getRecommendedUserList:searchText] ;
    }
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
    return YES ;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    _selectedItem = nil ;
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    DobTableViewCell *startDatecell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_START_DATE_SECTION_INDEX]] ;
    
    if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0)) {
        textField.userInteractionEnabled = true;
        if(textField.tag == COMMUNAL_ASSET_START_DATE_SECTION_INDEX || textField.tag == COMMUNAL_ASSET_END_DATE_SECTION_INDEX) {
            if(textField.tag == COMMUNAL_ASSET_START_DATE_SECTION_INDEX) {
                selectedDatePickerType = COMMUNAL_ASSET_START_DATE_SELECTED;
            }
            else {
                selectedDatePickerType = COMMUNAL_ASSET_END_DATE_SELECTED;
                NSDate *startDate = [dateFormatter dateFromString:startDatecell.textFld.text]; // start date
                if(startDate == nil)
                    [self presentViewController:[UtilityClass displayAlertMessage:@"Please select the Start Date first."] animated:YES completion:nil];
                else
                    [datePickerView setMinimumDate:startDate] ;
            }
        }
        else {
            _selectedItem = textField ;
        }
        return YES ;
        
    } else {
        textField.userInteractionEnabled = false;
        return NO;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _selectedItem = nil ;
    if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0)) {
        textField.userInteractionEnabled = true;
        
        if(textField.tag == COMMUNAL_ASSET_START_DATE_SECTION_INDEX || textField.tag == COMMUNAL_ASSET_END_DATE_SECTION_INDEX) {
            if(textField.tag == COMMUNAL_ASSET_START_DATE_SECTION_INDEX) {
                DobTableViewCell *endDatecell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_END_DATE_SECTION_INDEX]] ;
                NSDate *endDate = [dateFormatter dateFromString:endDatecell.textFld.text]; // end date
                if(endDate != nil)
                    endDatecell.textFld.text = @"";
            }
            prevDueDate = textField.text ;
        }
    } else
        textField.userInteractionEnabled = false;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [[sectionsArray objectAtIndex:textField.tag] setValue:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"value"] ;
    return YES ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [[sectionsArray objectAtIndex:textView.tag] setValue:[textView.text stringByReplacingCharactersInRange:range withString:text] forKey:@"value"] ;
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _selectedItem = nil ;
    
    if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0)) {
        textView.userInteractionEnabled = true;
        if([textView.text isEqualToString:@"Communal Asset Description"] && textView.textColor == [UIColor lightGrayColor]) {
            textView.text = @"" ;
            textView.textColor = [UtilityClass textColor] ;
        }
        
        CGPoint pointInTable = [textView.superview convertPoint:textView.frame.origin toView:self.tblView];
        CGPoint contentOffset = self.tblView.contentOffset;
        
        contentOffset.y = (pointInTable.y - textView.inputAccessoryView.frame.size.height);
        
        [self.tblView setContentOffset:contentOffset animated:YES];
        return YES ;
    } else {
        textView.userInteractionEnabled = false;
        return NO ;
    }
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder] ;
    _selectedItem = nil ;
    
    if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0)) {
        textView.userInteractionEnabled = true;
        if([textView.text isEqualToString:@""]) {
            textView.text = @"Communal Asset Description" ;
            textView.textColor = [UIColor lightGrayColor] ;
        }
        
        if ([textView.superview.superview isKindOfClass:[UITableViewCell class]])
        {
            CGPoint buttonPosition = [textView convertPoint:CGPointZero
                                                     toView: self.tblView];
            NSIndexPath *indexPath = [self.tblView indexPathForRowAtPoint:buttonPosition];
            
            [self.tblView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
        }
        return YES ;
    } else {
        textView.userInteractionEnabled = false;
        return NO ;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [[sectionsArray objectAtIndex:textView.tag] setValue:[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"value"] ;
    
    if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0))
        textView.userInteractionEnabled = true;
    else
        textView.userInteractionEnabled = false;
}

#pragma mark - Keyoboard Actions
- (void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // If you are using Xcode 6 or iOS 7.0, you may need this line of code. There was a bug when you
    // rotated the device to landscape. It reported the keyboard as the wrong size as if it was still in portrait mode.
    //kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.tblView.contentInset = contentInsets;
    self.tblView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.selectedItem.frame.origin ) ) {
        if(![_selectedItem isKindOfClass:[UITableView class]])[self.tblView scrollRectToVisible:self.selectedItem.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    [self moveToOriginalFrame] ;
}

-(void)moveToOriginalFrame{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tblView.contentInset = contentInsets;
    self.tblView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Table header gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i = 0; i < [sectionsArray count]; i++) {
            if (indexPath.section == i) {
                if (indexPath.section == COMMUNAL_ASSET_DOCUMENT_SECTION_INDEX) {
                    if (![docuementFile isEqualToString:@""]) {
                        [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
                    }
                }
                else if (indexPath.section == COMMUNAL_ASSET_AUDIO_SECTION_INDEX) {
                    if (![audioFile isEqualToString:@""]) {
                        [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
                    }
                }
                else if (indexPath.section == COMMUNAL_ASSET_VIDEO_SECTION_INDEX) {
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

#pragma mark - DatePicker Value Changed
- (void)datePickerChanged:(UIDatePicker *)datePicker {
    
    DobTableViewCell *cell;
    if (selectedDatePickerType == COMMUNAL_ASSET_START_DATE_SELECTED)
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_START_DATE_SECTION_INDEX]] ;
    else
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:COMMUNAL_ASSET_END_DATE_SECTION_INDEX]] ;
    
    [cell.textFld setText:[dateFormatter stringFromDate:datePicker.date]];
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - API Methods
-(void)getCommunalAssetKeywordsList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        [ApiCrowdBootstrap getCommunalAssetKeywordsList:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"response : %@", responseDict);
                [communalAssetKeywordsArray removeAllObjects] ;
                if([responseDict objectForKey:kCommunalAssetAPI_KeywordList]) {
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:kCommunalAssetAPI_KeywordList] mutableCopy]) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:[dict mutableCopy]] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        [communalAssetKeywordsArray addObject:obj] ;
                    }
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode) {
                //                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getCommunalAssetIndustryKeywordsList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        [ApiCrowdBootstrap getCommunalAssetIndustryKeywordsList:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"response : %@", responseDict);
                [industryKeywordsArray removeAllObjects] ;
                if([responseDict objectForKey:kCommunalAssetAPI_Industry_List]) {
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:kCommunalAssetAPI_Industry_List] mutableCopy]) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:[dict mutableCopy]] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        [industryKeywordsArray addObject:obj] ;
                    }
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode) {
                //                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getTargetMarketKeywordsList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_UserID] ;
        
        [ApiCrowdBootstrap getCommunalAssetTargetMarketKeywordsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"response : %@", responseDict);
                [targetMarketKeywordsArray removeAllObjects] ;
                if([responseDict objectForKey:kCommunalAssetAPI_Target_Market_List]) {
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:kCommunalAssetAPI_Target_Market_List] mutableCopy]) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:[dict mutableCopy]] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        [targetMarketKeywordsArray addObject:obj] ;
                    }
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode) {
                //                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getCommunalAssetDetails {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[communalAssetData valueForKey:kCommunalAssetAPI_ID]] forKey:kCommunalAssetAPI_AssetID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap viewCommunalAssetWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                for ( int i = 0; i < sectionsArray.count ; i++ ) {
                    NSString *key = [[sectionsArray objectAtIndex:i] valueForKey:@"key"] ;
                    if(i != COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SECTION_INDEX && i != COMMUNAL_ASSET_TARGET_MARKET_KEYWORDS_SECTION_INDEX && i != COMMUNAL_ASSET_KEYWORDS_SECTION_INDEX) {
                        if([responseDict valueForKey:key])
                            [[sectionsArray objectAtIndex:i] setValue:[responseDict valueForKey:key] forKey:@"value"] ;
                    }
                }
                
                // Keywords Array
                if([responseDict objectForKey:kAddCommunalAssetAPI_IndustryKeywords]) {
                    selectedIndustryKeywordsArray = [[responseDict objectForKey:kAddCommunalAssetAPI_IndustryKeywords] mutableCopy];
                    selectedIndustryKeywordNames = [self resetTagsArrayWithData:selectedIndustryKeywordsArray];
                    selectedIndustryKeywordIds = [self resetTagIdsArrayWithData:selectedIndustryKeywordsArray];
                }
                if([responseDict objectForKey:kAddCommunalAssetAPI_Keywords]) {
                    selectedCommunalAssetKeywordsArray = [[responseDict objectForKey:kAddCommunalAssetAPI_Keywords] mutableCopy] ;
                    selectedCommunalAssetKeywordNames = [self resetTagsArrayWithData:selectedCommunalAssetKeywordsArray];
                    selectedCommunalAssetKeywordIds = [self resetTagIdsArrayWithData:selectedCommunalAssetKeywordsArray];
                }
                if([responseDict objectForKey:kAddCommunalAssetAPI_Target_Market_Keywords]) {
                    selectedTargetMarketKeywordsArray = [[responseDict objectForKey:kAddCommunalAssetAPI_Target_Market_Keywords] mutableCopy];
                    selectedTargetMarketKeywordNames = [self resetTagsArrayWithData:selectedTargetMarketKeywordsArray];
                    selectedTargetMarketKeywordIds = [self resetTagIdsArrayWithData:selectedTargetMarketKeywordsArray];
                }
                
                // Commits
                noOfcommit = [[responseDict valueForKey:kCommunalAssetAPI_NoOfCommits] stringValue];
                isCommited = [[responseDict valueForKey:kCommunalAssetAPI_IsCommited] intValue];
                isLiked = [[responseDict valueForKey:kCommunalAssetAPI_IsLiked] intValue];
                isFollowed = [[responseDict valueForKey:kCommunalAssetAPI_IsFollowed] intValue];
                
                // Document
                if([responseDict objectForKey:kCommunalAssetAPI_Document])
                    docuementFile = [[responseDict objectForKey:kCommunalAssetAPI_Document] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] ;
                
                // Audio
                if([responseDict objectForKey:kCommunalAssetAPI_Audio])
                    audioFile = [[responseDict objectForKey:kCommunalAssetAPI_Audio] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] ;
                
                // Video
                if([responseDict objectForKey:kCommunalAssetAPI_Video])
                    videoFile = [[responseDict objectForKey:kCommunalAssetAPI_Video] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                
                // Image
                if([responseDict objectForKey:kCommunalAssetAPI_Image]) {
                    NSString *strImage = [NSString stringWithFormat:@"%@%@",APIPortToBeUsed, [responseDict objectForKey:kCommunalAssetAPI_Image]];
                    NSURL *url = [NSURL URLWithString:[strImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    imgData = [NSData dataWithContentsOfURL:url];
                }
                
                // Refresh Dict
                [communalAssetData setValue:[NSString stringWithFormat:@"%@",[responseDict valueForKey:kCommunalAssetAPI_Title]] forKey:kCommunalAssetAPI_Title] ;
                [communalAssetData setValue:[NSString stringWithFormat:@"%@",[responseDict valueForKey:kCommunalAssetAPI_CreatedBy]] forKey:kCommunalAssetAPI_CreatedBy] ;
                [communalAssetData setValue:[NSString stringWithFormat:@"%@",[responseDict valueForKey:kCommunalAssetAPI_StartDate]] forKey:kCommunalAssetAPI_StartDate] ;
                [communalAssetData setValue:[NSString stringWithFormat:@"%@",[responseDict valueForKey:kCommunalAssetAPI_EndDate]] forKey:kCommunalAssetAPI_EndDate] ;
                [communalAssetData setValue:[NSString stringWithFormat:@"%@",[responseDict valueForKey:kCommunalAssetAPI_Description]] forKey:kCommunalAssetAPI_Description] ;
                
                [UtilityClass setCommunalAssetDetails:[communalAssetData mutableCopy]] ;
                
                [_tblView reloadData] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)commitCommunalAsset {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[communalAssetData valueForKey:kCommunalAssetAPI_ID]] forKey:kCommunalAssetAPI_AssetID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        if (isCommited == 0) {
            [ApiCrowdBootstrap commitCommunalAssetWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"responseDict %@", responseDict);
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                    if(isCommited == 0)
                        isCommited = 1 ;
                    else
                        isCommited = 0 ;
                    
                    noOfcommit = [[responseDict valueForKey:@"numOfCommits"] stringValue];
                    
                    [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:sectionsArray.count]] withRowAnimation:UITableViewRowAnimationNone];
                }
                else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                    [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                
            } failure:^(NSError *error) {
                [UtilityClass displayAlertMessage:error.description] ;
                [UtilityClass hideHud] ;
            }] ;
        } else {
            [ApiCrowdBootstrap uncommitCommunalAssetWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"responseDict %@", responseDict);
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                    if(isCommited == 0)
                        isCommited = 1 ;
                    else
                        isCommited = 0 ;
                    
                    noOfcommit = [[responseDict valueForKey:@"numOfCommits"] stringValue];
                    
                    [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:sectionsArray.count]] withRowAnimation:UITableViewRowAnimationNone];
                }
                else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                    [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                
            } failure:^(NSError *error) {
                [UtilityClass displayAlertMessage:error.description] ;
                [UtilityClass hideHud] ;
            }] ;
        }
    }
}

-(void)getCommunalAssetCommitmentList {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%@",[communalAssetData valueForKey:kCommunalAssetAPI_ID]] forKey:kCommunalAssetAPI_AssetID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kCommunalAssetAPI_PageNo] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getCommunalAssetCommitmentListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kCommunalAssetAPI_UserList]) {
                    totalItems = [[responseDict valueForKey:kCommunalAssetAPI_TotalItems] integerValue] ;
                    [usersArray removeAllObjects];
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_UserList]] ;
                    [tblViewUsers reloadData] ;
                    [viewPopUp setHidden:false];
                    [self.tblView setUserInteractionEnabled:false];
                    pageNo++ ;
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_UserList]] ;
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode )
            {
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            totalItems = usersArray.count;
            [tblViewUsers reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

- (void)getRecommendedUserList: (NSString *)searchedString {
    if([UtilityClass checkInternetConnection]) {
        
        if(pageNo == 1)
            [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:kCommunalAssetAPI_PageNo] ;
        [dictParam setObject:searchedString forKey:@"search"] ;
        [dictParam setObject:@"communal_asset" forKey:@"type"] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getRegisteredRoleListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                if([responseDict valueForKey:kCommunalAssetAPI_UserList]) {
                    
                    totalItems = [[responseDict valueForKey:kCommunalAssetAPI_TotalItems] integerValue] ;
                    
                    [usersArray removeAllObjects];
                    [searchResultsForRegisteredUsers removeAllObjects];
                    
                    if(![searchBarUsers.text isEqualToString:@""]){
                        searchResultsForRegisteredUsers = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCommunalAssetAPI_UserList]] ;
                    }
                    else {
                        [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_UserList]] ;
                    }
                    lblNoUserAvailable.hidden = true;
                    [tblViewUsers reloadData] ;
                    pageNo++ ;
                    
                    [viewPopUp setHidden:false];
                    [self.tblView setUserInteractionEnabled:false];
                    
                    NSArray *arr = [NSArray arrayWithArray:(NSArray*)[responseDict valueForKey:kCommunalAssetAPI_UserList]] ;
                    NSLog(@"totalItems: %ld count: %lu",(long)totalItems ,(unsigned long)arr.count) ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode )
            {
                
                if(![searchBarUsers.text isEqualToString:@""])
                    searchResultsForRegisteredUsers = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCommunalAssetAPI_UserList]] ;
                else
                    usersArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kCommunalAssetAPI_UserList]] ;
                
                lblNoUserAvailable.hidden = false;
                [tblViewUsers reloadData] ;
                [viewPopUp setHidden:false];
                [self.tblView setUserInteractionEnabled:false];
            }
        } failure:^(NSError *error) {
            totalItems = usersArray.count;
            [tblViewUsers reloadData] ;
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)editCommunalAsset {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kCommunalAssetAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[communalAssetData valueForKey:kCommunalAssetAPI_ID]] forKey:kCommunalAssetAPI_AssetID] ;
        
        [dictParam setObject:[[sectionsArray objectAtIndex:COMMUNAL_ASSET_TITLE_SECTION_INDEX] valueForKey:@"value"] forKey:kCommunalAssetAPI_Title] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:COMMUNAL_ASSET_DESCRIPTION_SECTION_INDEX] valueForKey:@"value"] forKey:kCommunalAssetAPI_Description] ;
        
        [dictParam setObject:[[sectionsArray objectAtIndex:COMMUNAL_ASSET_START_DATE_SECTION_INDEX] valueForKey:@"value"] forKey:kCommunalAssetAPI_StartDate] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:COMMUNAL_ASSET_END_DATE_SECTION_INDEX] valueForKey:@"value"] forKey:kCommunalAssetAPI_EndDate] ;
        
        [dictParam setObject:[self convertTagsArrayToStringforArray:selectedIndustryKeywordsArray withTagsArray:industryKeywordsArray tagType:@"industry"] forKey:kAddCommunalAssetAPI_IndustryKeywords] ;
        [dictParam setObject:[self convertTagsArrayToStringforArray:selectedCommunalAssetKeywordsArray withTagsArray:communalAssetKeywordsArray tagType:@"CommunalAssetkeyword"] forKey:kAddCommunalAssetAPI_Keywords] ;
        [dictParam setObject:[self convertTagsArrayToStringforArray:selectedTargetMarketKeywordsArray withTagsArray:targetMarketKeywordsArray tagType:@"targetmarket"] forKey:kAddCommunalAssetAPI_Target_Market_Keywords] ;
        
        if(imgData)
            [dictParam setObject:imgData forKey:kCommunalAssetAPI_Image] ;
        else
            [dictParam setObject:@"" forKey:kCommunalAssetAPI_Image] ;
        
        [dictParam setObject:@"" forKey:kCommunalAssetAPI_Document] ;
        [dictParam setObject:@"" forKey:kCommunalAssetAPI_Audio] ;
        [dictParam setObject:@"" forKey:kCommunalAssetAPI_Video] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        CommitTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionsArray.count]] ;
        
        cell.progressLbl.hidden = NO ;
        cell.progressView.hidden = NO ;
        
        [ApiCrowdBootstrap editCommunalAssetWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            cell.progressLbl.hidden = YES ;
            cell.progressView.hidden = YES ;
            
            NSLog(@"responseDict >>>>> %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                
                [UtilityClass showNotificationMessgae:kEditCommunalAsset_SuccessMessage withResultType:@"0" withDuration:1] ;
                [UtilityClass setComingFrom_CommunalAsset_AddEditScreen:YES];
                [self.navigationController popViewControllerAnimated:YES] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode )
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
            cell.progressLbl.hidden = YES ;
            cell.progressView.hidden = YES ;
            
        } progress:^(double progress) {
            // NSLog(@"progress %f",progress) ;
            cell.progressView.progress = progress ;
            int prog = (int)progress*100;
            cell.progressLbl.text = [NSString stringWithFormat:@"%d %@",prog,@"% Completed"] ;
        }] ;
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == popupTblView) {
        if (![searchBarKeywords.text isEqualToString:@""])
            return searchResultsForKeywords.count ;
        else {
            if(selectedKeywordType == COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SELECTED)
                return industryKeywordsArray.count ;
            else if (selectedKeywordType == COMMUNAL_ASSET_TARGET_MARKET_KEYWORDS_SELECTED)
                return targetMarketKeywordsArray.count ;
            else
                return communalAssetKeywordsArray.count ;
        }
    } else if (tableView == tblViewUsers) {
        if (![searchBarUsers.text isEqualToString:@""])
            return searchResultsForRegisteredUsers.count ;
        else
            return usersArray.count;
    }
    else {
        if(section <= COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SECTION_INDEX || section == sectionsArray.count)
            return 1;
        else {
            if(section == COMMUNAL_ASSET_IMAGE_SECTION_INDEX) {
                if ([[arrayForBool objectAtIndex:section] boolValue])
                    return 1;
                else return 0 ;
            }
            else if(section == COMMUNAL_ASSET_DOCUMENT_SECTION_INDEX ) {
                if ([[arrayForBool objectAtIndex:section] boolValue]) return 1;
                else  return 0 ;
            }
            else if(section == COMMUNAL_ASSET_AUDIO_SECTION_INDEX) {
                if ([[arrayForBool objectAtIndex:section] boolValue]) return 1;
                else  return 0 ;
            }
            else{
                if ([[arrayForBool objectAtIndex:section] boolValue]) return 1;
                else  return 0 ;
            }
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == popupTblView) {
        PaymentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keywordsCell"] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.checkboxBtn.tag = indexPath.row ;
        
        NSDictionary *dictKeyword = [[NSDictionary alloc] init];
        
        if(selectedKeywordType == COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SELECTED) {
            if (![searchBarKeywords.text isEqualToString:@""])
                dictKeyword = [searchResultsForKeywords objectAtIndex:indexPath.row];
            else
                dictKeyword = [industryKeywordsArray objectAtIndex:indexPath.row];
            
            cell.companyNameLbl.text = [dictKeyword valueForKey:kCommunalAssetAPI_Industry_Name] ;
            if ([selectedIndustryKeywordIds containsObject:[dictKeyword valueForKey:kCommunalAssetAPI_Industry_ID]]) {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
                [dictKeyword setValue:@"1" forKey:@"isSelected"] ;
            } else {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
                [dictKeyword setValue:@"0" forKey:@"isSelected"] ;
            }
        }
        else if (selectedKeywordType == COMMUNAL_ASSET_TARGET_MARKET_KEYWORDS_SELECTED) {
            if (![searchBarKeywords.text isEqualToString:@""])
                dictKeyword = [searchResultsForKeywords objectAtIndex:indexPath.row];
            else
                dictKeyword = [targetMarketKeywordsArray objectAtIndex:indexPath.row];
            
            cell.companyNameLbl.text = [dictKeyword valueForKey:kCommunalAssetAPI_Target_Market_Name] ;
            if ([selectedTargetMarketKeywordIds containsObject:[dictKeyword valueForKey:kCommunalAssetAPI_Target_Market_ID]]) {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
                [dictKeyword setValue:@"1" forKey:@"isSelected"] ;
            } else {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
                [dictKeyword setValue:@"0" forKey:@"isSelected"] ;
            }
        } else
        {
            if (![searchBarKeywords.text isEqualToString:@""])
                dictKeyword = [searchResultsForKeywords objectAtIndex:indexPath.row];
            else
                dictKeyword = [communalAssetKeywordsArray objectAtIndex:indexPath.row];
            
            cell.companyNameLbl.text = [dictKeyword valueForKey:kCommunalAssetAPI_KeywordName] ;
            
            if ([selectedCommunalAssetKeywordIds containsObject:[dictKeyword valueForKey:kCommunalAssetAPI_KeywordID]]) {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
                [dictKeyword setValue:@"1" forKey:@"isSelected"] ;
            } else {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
                [dictKeyword setValue:@"0" forKey:@"isSelected"] ;
            }
        }
        return cell ;
    } else if (tableView == tblViewUsers) {
        if (![searchBarUsers.text isEqualToString:@""]) {
            UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
            cell.lblName.text = [NSString stringWithFormat:@"%@",[[searchResultsForRegisteredUsers objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_User_Name]] ;
            cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[searchResultsForRegisteredUsers objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_User_Desc]];
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[searchResultsForRegisteredUsers objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            
            cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
            cell.imgView.clipsToBounds = YES;
            
            cell.btnViewProfile.tag = indexPath.row;
            return cell;
            
        } else {
            UserFundTableViewCell *cell = (UserFundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserProfile] ;
            cell.lblName.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_User_Name]] ;
            cell.lblDesc.text = [NSString stringWithFormat:@"%@",[[usersArray objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_User_Desc]];
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[usersArray objectAtIndex:indexPath.row] valueForKey:kCommunalAssetAPI_User_Image]]] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
            
            cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
            cell.imgView.clipsToBounds = YES;
            
            cell.btnViewProfile.tag = indexPath.row;
            
            return cell;
        }
    }
    else {
        if(indexPath.section == sectionsArray.count) {
            CommitTableViewCell *cell = (CommitTableViewCell*)[tableView dequeueReusableCellWithIdentifier:SUBMIT_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [cell.noOfCommitsBtn setTitle:[NSString stringWithFormat:@"%@ commitments", noOfcommit] forState:UIControlStateNormal] ;
            
            if ((selectedSegmentControl == 100 && selectedSegment == 0)) {
                if(isCommited == 0) {
                    [cell.commitBtn setTitle:APPLY_TEXT forState:UIControlStateNormal] ;
                    [cell.commitBtn setBackgroundColor:[UIColor colorWithRed:33.0/255.0 green:81.0/255.0 blue:135.0/255.0 alpha:1.0f]];
                }
                else{
                    [cell.commitBtn setTitle:UNAPPLY_TEXT forState:UIControlStateNormal] ;
                    [cell.commitBtn setBackgroundColor:[UIColor colorWithRed:5.0/255.0 green:106.0/255.0 blue:31.0/255.0 alpha:1.0f]];
                }
            } else {
                [cell.commitBtn setTitle:@"Submit" forState:UIControlStateNormal];
            }
            return cell ;
        }
        else if(indexPath.section == COMMUNAL_ASSET_FOLLOW_SECTION_INDEX) {
            FollowCampaignTableViewCell *cell = (FollowCampaignTableViewCell*)[tableView dequeueReusableCellWithIdentifier:FOLLOW_CELL_IDENTIFIER] ;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            [UtilityClass setViewBorder:cell.postedByBtn] ;
            
            [cell.postedByBtn setTitle:[NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] forState:UIControlStateNormal] ;
            
            NSLog(@"%@", cell.postedByBtn.titleLabel.text);
            if(isFollowed == 0) {
                [cell.followBtn setTitle:FOLLOW_TEXT forState:UIControlStateNormal] ;
                [cell.followBtn setBackgroundImage:[UIImage imageNamed:FOLLOW_BUTTON_ICON] forState:UIControlStateNormal] ;
            }
            else{
                [cell.followBtn setTitle:UNFOLLOW_TEXT forState:UIControlStateNormal] ;
                [cell.followBtn setBackgroundImage:[UIImage imageNamed:UNFOLLOW_BUTTON_ICON] forState:UIControlStateNormal] ;
            }
            
            if(isLiked == 0) {
                [cell.likeBtn setTitle:LIKE_TEXT forState:UIControlStateNormal] ;
                [cell.likeBtn setBackgroundImage:[UIImage imageNamed:FOLLOW_BUTTON_ICON] forState:UIControlStateNormal] ;
            }
            else{
                [cell.likeBtn setTitle:UNLIKE_TEXT forState:UIControlStateNormal] ;
                [cell.likeBtn setBackgroundImage:[UIImage imageNamed:UNFOLLOW_BUTTON_ICON] forState:UIControlStateNormal] ;
            }
            
            if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0) || (selectedSegmentControl == 200 && selectedSegment == 1) ||(selectedSegmentControl == 200 && selectedSegment == 2)) {
                cell.followBtn.hidden = true;
                cell.likeBtn.hidden = true;
                //                cell.constraintLikeBtnTrailing.constant = 0;
                cell.constraintPostedByBtnTrailing.constant = -200;
                
            } else {
                cell.followBtn.hidden = false;
                cell.likeBtn.hidden = false;
                //                cell.constraintLikeBtnTrailing.constant = 80;
                cell.constraintPostedByBtnTrailing.constant = 5;
            }
            return cell;
        }
        else if(indexPath.section == COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SECTION_INDEX || indexPath.section == COMMUNAL_ASSET_TARGET_MARKET_KEYWORDS_SECTION_INDEX || indexPath.section == COMMUNAL_ASSET_KEYWORDS_SECTION_INDEX) {
            KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KEYWORDS_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [UtilityClass setButtonBorder:cell.button] ;
            cell.tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1] CGColor];
            cell.tagsScrollView.backgroundColor = [UIColor clearColor] ;
            cell.tagsScrollView.tag = indexPath.section ;
            cell.button.tag = indexPath.section ;
            cell.plusBtn.tag = indexPath.section ;
            
            NSMutableArray *tags ;
            if(indexPath.section == COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SECTION_INDEX)
                tags = [selectedIndustryKeywordNames mutableCopy] ;
            else if(indexPath.section == COMMUNAL_ASSET_TARGET_MARKET_KEYWORDS_SECTION_INDEX)
                tags = [selectedTargetMarketKeywordNames mutableCopy] ;
            else
                tags = [selectedCommunalAssetKeywordNames mutableCopy] ;
            
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
            
            if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0)) {
                cell.tagsScrollView.mode = TLTagsControlModeEdit;
                [cell.tagsScrollView setTapDelegate:self];
                [cell.tagsScrollView setDeleteDelegate:self];
                
                UITapGestureRecognizer  *txtViewTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(txtViewTapped_Gesture:)];
                txtViewTapped.accessibilityValue = [NSString stringWithFormat:@"%ld",indexPath.section];
                [cell.tagsScrollView addGestureRecognizer:txtViewTapped];
                
            } else {
                cell.tagsScrollView.mode = TLTagsControlModeList;
                cell.plusBtn.hidden = true;
            }
            
            cell.tagsScrollView.tagsBackgroundColor = [UtilityClass orangeColor];
            [cell.tagsScrollView reloadTagSubviews];
            
            return cell ;
        }
        else if(indexPath.section == COMMUNAL_ASSET_DESCRIPTION_SECTION_INDEX) {
            DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DESCRIPTION_CELL_IDENTIFIER] ;
            
            cell.fieldNameLbl.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"];
            cell.descriptionTxtView.tag = indexPath.section ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            [UtilityClass setTextViewBorder:cell.descriptionTxtView] ;
            
            NSString *descText = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
            
            if(descText.length < 1 || [descText isEqualToString:@""]) {
                cell.descriptionTxtView.textColor = [UIColor lightGrayColor] ;
                cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] ;
            }
            else{
                cell.descriptionTxtView.textColor = [UtilityClass textColor] ;
                cell.descriptionTxtView.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
            }
            return cell ;
        }
        else if(indexPath.section == COMMUNAL_ASSET_START_DATE_SECTION_INDEX || indexPath.section == COMMUNAL_ASSET_END_DATE_SECTION_INDEX) {
            
            DobTableViewCell *cell = (DobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Startups] ;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [UtilityClass setTextFieldBorder:cell.textFld] ;
            [UtilityClass addMarginsOnTextField:cell.textFld] ;
            
            cell.fieldNameLbl.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"];
            cell.textFld.placeholder = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            cell.textFld.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"] ;
            cell.textFld.tag = indexPath.section ;
            cell.dropdownBtn.tag = indexPath.section ;
            cell.textFld.inputView = datePickerViewContainer ;
            
            return cell ;
        }
        else if(indexPath.section == COMMUNAL_ASSET_IMAGE_SECTION_INDEX) {
            
            GraphicTableViewCell *cell = (GraphicTableViewCell*)[tableView dequeueReusableCellWithIdentifier:IMAGES_CELL_IDENTIFIER] ;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            if (chosenImage != nil)
                cell.graphicImg.image = chosenImage;
            else {
                NSString *imgUrlStr = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]];
                NSURL *url = [NSURL URLWithString:[imgUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                [cell.graphicImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:kCampainDetail_DefaultImage]] ;
            }
            
            if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0))
                cell.browseBtn.hidden = false;
            else
                cell.browseBtn.hidden = true;
            
            return cell ;
        }
        else if (indexPath.section == COMMUNAL_ASSET_DOCUMENT_SECTION_INDEX || indexPath.section == COMMUNAL_ASSET_AUDIO_SECTION_INDEX || indexPath.section == COMMUNAL_ASSET_VIDEO_SECTION_INDEX) {
            CampaignDocumentTableViewCell *cell = (CampaignDocumentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:PLAY_AUDIO_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
//            if(indexPath.section == COMMUNAL_ASSET_DOCUMENT_SECTION_INDEX)
//                cell.lbl.text = [NSString stringWithFormat:@"Document %ld",indexPath.row+1] ;
//            else if(indexPath.section == COMMUNAL_ASSET_AUDIO_SECTION_INDEX)
//                cell.lbl.text = [NSString stringWithFormat:@"Audio %ld",indexPath.row+1] ;
//            else
//                cell.lbl.text = [NSString stringWithFormat:@"Video %ld",indexPath.row+1] ;
            
            if(indexPath.section == COMMUNAL_ASSET_DOCUMENT_SECTION_INDEX) {
                if (![docuementFile isEqualToString:@""])
                    cell.lbl.text = [NSString stringWithFormat:@"Document %ld",indexPath.row+1] ;
            }
            else if(indexPath.section == COMMUNAL_ASSET_AUDIO_SECTION_INDEX) {
                if (![audioFile isEqualToString:@""])
                    cell.lbl.text = [NSString stringWithFormat:@"Audio %ld",indexPath.row+1] ;
            }
            else {
                if (![videoFile isEqualToString:@""])
                    cell.lbl.text = [NSString stringWithFormat:@"Video %ld",indexPath.row+1] ;
            }
            
            return cell ;
        }
        else {
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TEXTFIELD__CELL_IDENTIFIER] ;
            
            [UtilityClass setTextFieldBorder:cell.textFld] ;
            [UtilityClass addMarginsOnTextField:cell.textFld] ;
            
            cell.fieldNameLbl.text = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"] ;
            cell.fieldNameLbl.hidden = false;
            
            cell.textFld.placeholder = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"field"]] ;
            cell.textFld.text = [NSString stringWithFormat:@"%@",[[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"value"]] ;
            
            cell.selectionStyle = UITableViewCellSeparatorStyleNone ;
            cell.textFld.tag = indexPath.section ;
            cell.textFld.delegate = self ;
            
            return cell ;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == popupTblView)
        return 1;
    else if (tableView == tblViewUsers)
        return 1;
    else {
        if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 100 && selectedSegment == 0) || (selectedSegmentControl == 200 && selectedSegment == 0)) {
            return sectionsArray.count+1 ;
        } else {
            return sectionsArray.count ;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == popupTblView) {
        PaymentsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
        [self CheckUncheck_ClickAction:cell.checkboxBtn] ;
    } else {
        if(indexPath.section >= COMMUNAL_ASSET_DOCUMENT_SECTION_INDEX && indexPath.section < sectionsArray.count) {
            
            NSString *filePath ;
            if(indexPath.section == COMMUNAL_ASSET_DOCUMENT_SECTION_INDEX) {
                filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,docuementFile] ;
                dataTitle.text = @"Document" ;
            }
            else if(indexPath.section == COMMUNAL_ASSET_AUDIO_SECTION_INDEX) {
                filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,audioFile] ;
                dataTitle.text = @"Audio" ;
            }
            else {
                filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,videoFile] ;
                dataTitle.text = @"Video" ;
            }
            
            NSDictionary *options = @{UIApplicationOpenURLOptionsSourceApplicationKey : @YES};
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:filePath] options:options completionHandler:nil];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == popupTblView)
        return 50 ;
    else if (tableView == tblViewUsers)
        return 60;
    else {
        if(indexPath.section == COMMUNAL_ASSET_START_DATE_SECTION_INDEX || indexPath.section == COMMUNAL_ASSET_END_DATE_SECTION_INDEX) {
            return 65;
        }
        else if (indexPath.section == COMMUNAL_ASSET_FOLLOW_SECTION_INDEX)
            return 40;
        else if(indexPath.section == COMMUNAL_ASSET_DESCRIPTION_SECTION_INDEX)
            return 121 ;
        else if(indexPath.section == COMMUNAL_ASSET_IMAGE_SECTION_INDEX)
            return 155 ;
        else if(indexPath.section == COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SECTION_INDEX || indexPath.section == COMMUNAL_ASSET_TARGET_MARKET_KEYWORDS_SECTION_INDEX || indexPath.section == COMMUNAL_ASSET_KEYWORDS_SECTION_INDEX)
            return 70 ;
        else if (indexPath.section == sectionsArray.count)
            return 105;
        else if(indexPath.section == COMMUNAL_ASSET_DOCUMENT_SECTION_INDEX || indexPath.section == COMMUNAL_ASSET_AUDIO_SECTION_INDEX || indexPath.section == COMMUNAL_ASSET_VIDEO_SECTION_INDEX )
            return 45 ;
        else
            return 75;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section <= COMMUNAL_ASSET_INDUSTRY_KEYWORDS_SECTION_INDEX || section == sectionsArray.count)return 0;
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

@end
