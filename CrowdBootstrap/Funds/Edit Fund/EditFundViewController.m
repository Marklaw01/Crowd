//
//  EditFundViewController.m
//  CrowdBootstrap
//
//  Created by osx on 25/01/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "EditFundViewController.h"

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

@interface EditFundViewController ()

@end

@implementation EditFundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetUISettings] ;
}

-(void) awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SetViewEditingNotification:) name:kNotificationSetFundViewEditing
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)SetViewEditingNotification:(NSNotification *)notification {
    if ([[notification name] isEqualToString:kNotificationSetFundViewEditing]) {
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
    
    fundData = [[UtilityClass getFundsDetails] mutableCopy];
    NSLog(@"Fund Data: %@",fundData) ;
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = [NSString stringWithFormat:@"%@",[fundData valueForKey:kFundDetailAPI_FundTitle]] ;
    [self getFundDetails] ;

    [self initializeSectionArray] ;
}

-(void)initializeSectionArray {
    
    NSArray *fieldsArray = @[@"Created By", @"Fund's Title", @"Fund's Description", @"Fund's Managers", @"Sponsors", @"Industry", @"Portfolio Companies", @"Investment Start Date", @"Investment End Date", @"Fund's Investment Closure Date", @"Keywords", @"Upload Image", @"View Document",@"Play Audio",@"Play Video"] ;
    NSArray *parametersArray = @[kFundDetailAPI_CreatedBy, kFundDetailAPI_FundTitle, kFundDetailAPI_Description, kFundDetailAPI_ManagerKeywords, kFundDetailAPI_SponsorKeywords, kFundDetailAPI_IndustryKeywords, kFundDetailAPI_PortfolioKeywords, kFundDetailAPI_StartDate, kFundDetailAPI_EndDate, kFundDetailAPI_CloseDate, kFundDetailAPI_FundKeywords, kFundDetailAPI_Image, kFundDetailAPI_Document, kFundDetailAPI_Audio, kFundDetailAPI_Video] ;
    
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
    managersKeywordsArray = [[NSMutableArray alloc] init] ;
    sponsorsKeywordsArray = [[NSMutableArray alloc] init] ;
    industryKeywordsArray = [[NSMutableArray alloc] init] ;
    portfolioKeywordsArray = [[NSMutableArray alloc] init] ;
    keywordsArray = [[NSMutableArray alloc] init] ;
    
    selectedManagersKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedSponsorsKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedIndustryKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedPortfolioKeywordsArray = [[NSMutableArray alloc] init] ;
    selectedKeywordsArray = [[NSMutableArray alloc] init] ;
    
    selectedManagersKeywordIds = [[NSMutableArray alloc] init] ;
    selectedSponsorsKeywordIds = [[NSMutableArray alloc] init] ;
    selectedIndustryKeywordIds = [[NSMutableArray alloc] init] ;
    selectedPortfolioKeywordIds = [[NSMutableArray alloc] init] ;
    selectedKeywordIds = [[NSMutableArray alloc] init] ;

    selectedManagersKeywordNames = [[NSMutableArray alloc] init] ;
    selectedSponsorsKeywordNames = [[NSMutableArray alloc] init] ;
    selectedIndustryKeywordNames = [[NSMutableArray alloc] init] ;
    selectedPortfolioKeywordNames = [[NSMutableArray alloc] init] ;
    selectedKeywordNames = [[NSMutableArray alloc] init] ;
    
    searchResultsForKeywords = [[NSMutableArray alloc] init];
    
    prevDueDate       = @"" ;
    
    selectedDatePickerType = -1 ;
    selectedKeywordType = -1;
    
    [datePickerView setMinimumDate:[NSDate date]] ;
    [datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    [self getFundKeywordsList];
    [self getFundIndustryKeywordsList];
    [self getFundManagerKeywordsList];
    [self getFundSponsorKeywordsList];
    [self getFundPortfolioKeywordsList];
    
    [self.tblView reloadData] ;
}

- (void)checkKeywordsListFound:(int)keywordType {
    switch (keywordType) {
        case 3:
        {
            if (managersKeywordsArray.count > 0)
                [self openTagsPopup] ;
            else
                [self presentViewController:[UtilityClass displayAlertMessage:kNoManagersListFoundMessage] animated:YES completion:nil];
        }
            break;
        case 4:
        {
            if (sponsorsKeywordsArray.count > 0)
                [self openTagsPopup] ;
            else
                [self presentViewController:[UtilityClass displayAlertMessage:kNoSponsorsListFoundMessage] animated:YES completion:nil];
        }
            break;
        case 5:
        {
            if (industryKeywordsArray.count > 0)
                [self openTagsPopup] ;
            else
                [self presentViewController:[UtilityClass displayAlertMessage:kNoIndustryListFoundMessage] animated:YES completion:nil];
        }
            break;
        case 6:
        {
            if (portfolioKeywordsArray.count > 0)
                [self openTagsPopup] ;
            else
                [self presentViewController:[UtilityClass displayAlertMessage:kNoPortfolioListFoundMessage] animated:YES completion:nil];
        }
            break;
        case 10:
        {
            if (keywordsArray.count > 0)
                [self openTagsPopup] ;
            else
                [self presentViewController:[UtilityClass displayAlertMessage:kNoKeywordsListFoundMessage] animated:YES completion:nil];
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
    
    if ([type isEqualToString:@"industry"]) {
        for (NSDictionary *dict in tagsArray) {
            NSString *value = [dict valueForKey:kFundAPI_Industry_ID] ;
            for (NSDictionary *obj in array) {
                NSString *selectedValue;
                if ([obj valueForKey:kFundAPI_Industry_ID])
                    selectedValue = [obj valueForKey:kFundAPI_Industry_ID] ;
                else
                    selectedValue = [obj valueForKey:kFundAPI_ID] ;

                if([selectedValue intValue] == [value intValue]) {
                    if(isFirstTag)
                        tagsStr = [dict valueForKey:kFundAPI_Industry_ID] ;
                    else
                        tagsStr = [NSString stringWithFormat:@"%@,%@",tagsStr,[dict valueForKey:kFundAPI_Industry_ID]] ;
                    isFirstTag = NO ;
                }
            }
        }
    } else if ([type isEqualToString:@"fundkeyword"]) {
        for (NSDictionary *dict in tagsArray) {
            NSString *value = [dict valueForKey:kFundAPI_KeywordID] ;
            for (NSDictionary *obj in array) {
                NSString *selectedValue;
                if ([obj valueForKey:kFundAPI_KeywordID])
                    selectedValue = [obj valueForKey:kFundAPI_KeywordID] ;
                else
                    selectedValue = [obj valueForKey:kFundAPI_ID] ;

                if([selectedValue intValue] == [value intValue]){
                    if(isFirstTag) tagsStr = [dict valueForKey:kFundAPI_KeywordID] ;
                    else tagsStr = [NSString stringWithFormat:@"%@,%@",tagsStr,[dict valueForKey:kFundAPI_KeywordID]] ;
                    isFirstTag = NO ;
                }
            }
        }
    } else if ([type isEqualToString:@"managers"]) {
        for (NSDictionary *dict in tagsArray) {
            NSString *value = [dict valueForKey:kFundAPI_Manager_ID] ;
            for (NSDictionary *obj in array) {
                NSString *selectedValue = [obj valueForKey:kFundAPI_Manager_ID] ;
                if([selectedValue intValue] == [value intValue]){
                    if(isFirstTag)
                        tagsStr = [dict valueForKey:kFundAPI_Manager_ID] ;
                    else
                        tagsStr = [NSString stringWithFormat:@"%@,%@",tagsStr,[dict valueForKey:kFundAPI_Manager_ID]] ;
                    isFirstTag = NO ;
                }
            }
        }
    }  else if ([type isEqualToString:@"sponsors"]) {
        for (NSDictionary *dict in tagsArray) {
            NSString *value = [dict valueForKey:kFundAPI_Sponsor_ID] ;
            for (NSDictionary *obj in array) {
                NSString *selectedValue = [obj valueForKey:kFundAPI_Sponsor_ID] ;
                if([selectedValue intValue] == [value intValue]){
                    if(isFirstTag) tagsStr = [dict valueForKey:kFundAPI_Sponsor_ID] ;
                    else tagsStr = [NSString stringWithFormat:@"%@,%@",tagsStr,[dict valueForKey:kFundAPI_Sponsor_ID]] ;
                    isFirstTag = NO ;
                }
            }
        }
    }  else if ([type isEqualToString:@"portfolio"]) {
        for (NSDictionary *dict in tagsArray) {
            NSString *value = [dict valueForKey:kFundAPI_Portfolio_ID] ;
            for (NSDictionary *obj in array) {
                NSString *selectedValue;
                if ([obj valueForKey:kFundAPI_Portfolio_ID])
                    selectedValue = [obj valueForKey:kFundAPI_Portfolio_ID] ;
                else
                    selectedValue = [obj valueForKey:kFundAPI_ID] ;

                if([selectedValue intValue] == [value intValue]) {
                    if(isFirstTag)
                        tagsStr = [dict valueForKey:kFundAPI_Portfolio_ID] ;
                    else
                        tagsStr = [NSString stringWithFormat:@"%@,%@",tagsStr,[dict valueForKey:kFundAPI_Portfolio_ID]] ;
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
            if(selectedKeywordType == FUND_INDUSTRY_KEYWORDS_SELECTED)
                dictKeyword = [industryKeywordsArray objectAtIndex:btn.tag];
            else if (selectedKeywordType == FUND_MANAGERS_KEYWORDS_SELECTED)
                dictKeyword = [managersKeywordsArray objectAtIndex:btn.tag];
            else if (selectedKeywordType == FUND_SPONSORS_KEYWORDS_SELECTED)
                dictKeyword = [sponsorsKeywordsArray objectAtIndex:btn.tag];
            else if (selectedKeywordType == FUND_PORTFOLIO_KEYWORDS_SELECTED)
                dictKeyword = [portfolioKeywordsArray objectAtIndex:btn.tag];
            else
                dictKeyword = [keywordsArray objectAtIndex:btn.tag];
        }
        [dictKeyword setValue:@"0" forKey:@"isSelected"] ;
    }
    else { // Uncheck
        [btn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = CHECK_IMAGE ;
        
        NSDictionary *dictKeyword = [[NSDictionary alloc] init];
        if (![searchBarKeywords.text isEqualToString:@""])
            dictKeyword = [searchResultsForKeywords objectAtIndex:btn.tag];
        else {
            if(selectedKeywordType == FUND_INDUSTRY_KEYWORDS_SELECTED)
                dictKeyword = [industryKeywordsArray objectAtIndex:btn.tag];
            else if (selectedKeywordType == FUND_MANAGERS_KEYWORDS_SELECTED)
                dictKeyword = [managersKeywordsArray objectAtIndex:btn.tag];
            else if (selectedKeywordType == FUND_SPONSORS_KEYWORDS_SELECTED)
                dictKeyword = [sponsorsKeywordsArray objectAtIndex:btn.tag];
            else if (selectedKeywordType == FUND_PORTFOLIO_KEYWORDS_SELECTED)
                dictKeyword = [portfolioKeywordsArray objectAtIndex:btn.tag];
            else
                dictKeyword = [keywordsArray objectAtIndex:btn.tag];
        }
        [dictKeyword setValue:@"1" forKey:@"isSelected"] ;

    }
}

- (IBAction)OK_ClickAction:(id)sender {
    [popupView removeFromSuperview];
    searchBarKeywords.text = @"";

    if(selectedKeywordType == FUND_INDUSTRY_KEYWORDS_SELECTED) {
        [selectedIndustryKeywordsArray removeAllObjects] ;
        [selectedIndustryKeywordNames removeAllObjects];
        [selectedIndustryKeywordIds removeAllObjects];
        
        for (NSMutableDictionary *obj in industryKeywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"]) {
                [selectedIndustryKeywordsArray addObject:obj] ;
                [selectedIndustryKeywordNames addObject:[obj valueForKey:kFundAPI_Industry_Name]] ;
                [selectedIndustryKeywordIds addObject:[obj valueForKey:kFundAPI_Industry_ID]] ;
            }
        }
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:FUND_INDUSTRY_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
    } else if(selectedKeywordType == FUND_MANAGERS_KEYWORDS_SELECTED) {
        [selectedManagersKeywordsArray removeAllObjects];
        [selectedManagersKeywordNames removeAllObjects];
        [selectedManagersKeywordIds removeAllObjects];
        
        for (NSMutableDictionary *obj in managersKeywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"]) {
                [selectedManagersKeywordsArray addObject:obj] ;
                [selectedManagersKeywordNames addObject:[obj valueForKey:kFundAPI_Manager_Name]] ;
                [selectedManagersKeywordIds addObject:[obj valueForKey:kFundAPI_Manager_ID]] ;
            }
        }
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:FUND_MANAGERS_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
    } else if(selectedKeywordType == FUND_SPONSORS_KEYWORDS_SELECTED) {
        [selectedSponsorsKeywordsArray removeAllObjects];
        [selectedSponsorsKeywordNames removeAllObjects];
        [selectedSponsorsKeywordIds removeAllObjects];
        
        for (NSMutableDictionary *obj in sponsorsKeywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"]) {
                [selectedSponsorsKeywordsArray addObject:obj] ;
                [selectedSponsorsKeywordNames addObject:[obj valueForKey:kFundAPI_Sponsor_CompanyName]] ;
                [selectedSponsorsKeywordIds addObject:[obj valueForKey:kFundAPI_Sponsor_ID]] ;
            }
        }
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:FUND_SPONSORS_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
    } else if(selectedKeywordType == FUND_PORTFOLIO_KEYWORDS_SELECTED) {
        [selectedPortfolioKeywordsArray removeAllObjects];
        [selectedPortfolioKeywordNames removeAllObjects];
        [selectedPortfolioKeywordIds removeAllObjects];
        
        for (NSMutableDictionary *obj in portfolioKeywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"]) {
                [selectedPortfolioKeywordsArray addObject:obj] ;
                [selectedPortfolioKeywordNames addObject:[obj valueForKey:kFundAPI_Portfolio_Name]] ;
                [selectedPortfolioKeywordIds addObject:[obj valueForKey:kFundAPI_Portfolio_ID]] ;
            }
        }
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:FUND_PORTFOLIO_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
    } else {
        [selectedKeywordsArray removeAllObjects] ;
        [selectedKeywordNames removeAllObjects];
        [selectedKeywordIds removeAllObjects];
        
        for (NSMutableDictionary *obj in keywordsArray) {
            NSString *isSelectedStr = [obj valueForKey:@"isSelected"] ;
            if([isSelectedStr isEqualToString:@"1"]) {
                [selectedKeywordsArray addObject:obj] ;
                [selectedKeywordNames addObject:[obj valueForKey:kFundAPI_KeywordName]] ;
                [selectedKeywordIds addObject:[obj valueForKey:kFundAPI_KeywordID]] ;
            }
        }
        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:FUND_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
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
    
    if(tagControlIndex == FUND_INDUSTRY_KEYWORDS_SELECTED) {
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedIndustryKeywordNames objectAtIndex:index]] ;
        for (int i=0; i<industryKeywordsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[industryKeywordsArray objectAtIndex:i] valueForKey:kFundAPI_Industry_Name]] ;
            if([keywordName isEqualToString:selectedName]){
                [[industryKeywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedIndustryKeywordsArray removeObjectAtIndex:index] ;
        [selectedIndustryKeywordNames removeObjectAtIndex:index];
        [selectedIndustryKeywordIds removeObjectAtIndex:index];

        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:FUND_INDUSTRY_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
    } else if(tagControlIndex == FUND_MANAGERS_KEYWORDS_SELECTED) {
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedManagersKeywordNames objectAtIndex:index]] ;
        for (int i=0; i<managersKeywordsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[managersKeywordsArray objectAtIndex:i] valueForKey:kFundAPI_Manager_Name]] ;
            if([keywordName isEqualToString:selectedName]){
                [[managersKeywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedManagersKeywordsArray removeObjectAtIndex:index] ;
        [selectedManagersKeywordNames removeObjectAtIndex:index];
        [selectedManagersKeywordIds removeObjectAtIndex:index];

        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:FUND_MANAGERS_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
    } else if(tagControlIndex == FUND_SPONSORS_KEYWORDS_SELECTED) {
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedSponsorsKeywordNames objectAtIndex:index]] ;
        for (int i=0; i<sponsorsKeywordsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[sponsorsKeywordsArray objectAtIndex:i] valueForKey:kFundAPI_Sponsor_CompanyName]] ;
            if([keywordName isEqualToString:selectedName]){
                [[sponsorsKeywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedSponsorsKeywordsArray removeObjectAtIndex:index] ;
        [selectedManagersKeywordNames removeObjectAtIndex:index];
        [selectedManagersKeywordIds removeObjectAtIndex:index];

        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:FUND_SPONSORS_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
    } else if(tagControlIndex == FUND_PORTFOLIO_KEYWORDS_SELECTED) {
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedPortfolioKeywordNames objectAtIndex:index]] ;
        for (int i=0; i<portfolioKeywordsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[portfolioKeywordsArray objectAtIndex:i] valueForKey:kFundAPI_Portfolio_Name]] ;
            if([keywordName isEqualToString:selectedName]){
                [[portfolioKeywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedPortfolioKeywordsArray removeObjectAtIndex:index] ;
        [selectedPortfolioKeywordNames removeObjectAtIndex:index];
        [selectedPortfolioKeywordIds removeObjectAtIndex:index];

        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:FUND_PORTFOLIO_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
    } else {
        NSString *selectedName = [NSString stringWithFormat:@"%@",[selectedKeywordNames objectAtIndex:index]] ;
        for (int i=0; i<keywordsArray.count; i++) {
            NSString *keywordName = [NSString stringWithFormat:@"%@",[[keywordsArray objectAtIndex:i] valueForKey:kFundAPI_KeywordName]] ;
            if([keywordName isEqualToString:selectedName]){
                [[keywordsArray objectAtIndex:i] setValue:@"0" forKey:@"isSelected"] ;
                break ;
            }
        }
        [selectedKeywordsArray removeObjectAtIndex:index] ;
        [selectedKeywordNames removeObjectAtIndex:index];
        [selectedKeywordIds removeObjectAtIndex:index];

        [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:FUND_KEYWORDS_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationAutomatic] ;
    }
}

-(void)navigateToScreenWithViewIdentifier:(NSString *)viewIdentifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:viewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [UtilityClass setComingFrom_Funds_AddEditScreen:YES];
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)CloseData_ClickAction:(id)sender {
    [fundDataView dismissPresentingPopup] ;
}

- (IBAction)followButton_ClickAction:(UIButton*)button {
    
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFundAPI_Fund_FollowedBy] ;
        [dictParam setObject:[[[UtilityClass getFundsDetails] mutableCopy] valueForKey:kFundAPI_ID] forKey:kFundDetailAPI_FundID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        if (isFollowed == 0) {
            [ApiCrowdBootstrap followFundWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"responseDict %@", responseDict);
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                    if(isFollowed == 0)
                        isFollowed = 1 ;
                    else
                        isFollowed = 0 ;
                    
                    [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:FUND_FOLLOW_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationNone] ;
                }
                else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                    [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                
            } failure:^(NSError *error) {
                [UtilityClass displayAlertMessage:error.description] ;
                [UtilityClass hideHud] ;
            }] ;
        } else {
            [ApiCrowdBootstrap unfollowFundWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"responseDict %@", responseDict);
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                    if(isFollowed == 1)
                        isFollowed = 0 ;
                    else
                        isFollowed = 1 ;
                    
                    [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:FUND_FOLLOW_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationNone] ;
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
    if ([sender tag] == FUND_START_DATE_SECTION_INDEX)
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:FUND_START_DATE_SECTION_INDEX]] ;
    else if ([sender tag] == FUND_END_DATE_SECTION_INDEX)
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:FUND_END_DATE_SECTION_INDEX]] ;
    else
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:FUND_CLOSE_DATE_SECTION_INDEX]] ;
    
    [datePickerView setDate:[dateFormatter dateFromString:cell.textFld.text] animated:YES] ;
    [cell.textFld becomeFirstResponder] ;
}

- (IBAction)likeButton_ClickAction:(UIButton*)button {
    
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[[[UtilityClass getFundsDetails] mutableCopy] valueForKey:kFundAPI_ID] forKey:kFundDetailAPI_FundID] ;
        
        if (isLiked == 0) {
            [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFundAPI_Fund_LikedBy] ;
            NSLog(@"dictParam: %@",dictParam) ;

            [ApiCrowdBootstrap likeFundWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"responseDict %@", responseDict);
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                    if(isLiked == 0)
                        isLiked = 1 ;
                    else
                        isLiked = 0 ;
                    
                    [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:FUND_FOLLOW_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationNone] ;
                }
                else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                    [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                
            } failure:^(NSError *error) {
                [UtilityClass displayAlertMessage:error.description] ;
                [UtilityClass hideHud] ;
            }] ;
        } else {
            [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kFundAPI_Fund_DislikedBy] ;
            NSLog(@"dictParam: %@",dictParam) ;

            [ApiCrowdBootstrap dislikeFundWithParameters:dictParam success:^(NSDictionary *responseDict) {
                [UtilityClass hideHud] ;
                NSLog(@"responseDict %@", responseDict);
                if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                    if(isLiked == 1)
                        isLiked = 0 ;
                    else
                        isLiked = 1 ;
                    
                    [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:FUND_FOLLOW_SECTION_INDEX]] withRowAnimation:UITableViewRowAnimationNone] ;
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
    
    if(![self validatetextFieldsWithSectionIndex:FUND_TITLE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:FUND_START_DATE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:FUND_END_DATE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:FUND_CLOSE_DATE_SECTION_INDEX]) return ;
    else if(![self validatetextFieldsWithSectionIndex:FUND_DESCRIPTION_SECTION_INDEX]) return ;
    
    else if(selectedIndustryKeywordsArray.count < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_IndustryKeywordRequired] animated:YES completion:nil] ;
        return ;
    }
    else if(selectedKeywordsArray.count < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_KeywordRequired] animated:YES completion:nil] ;
        return ;
    }
    else if(selectedPortfolioKeywordsArray.count < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_PortfolioKeywordRequired] animated:YES completion:nil] ;
        return ;
    }
    else if(selectedManagersKeywordsArray.count < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_ManagerKeywordRequired] animated:YES completion:nil] ;
        return ;
    }
    else if(selectedSponsorsKeywordsArray.count < 1) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_SponsorKeywordRequired] animated:YES completion:nil] ;
        return ;
    }
    else [self editFund] ;
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    GraphicTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:FUND_IMAGE_SECTION_INDEX]] ;
    
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
            
            //            videoNameLbl.text = @"Fund Video" ;
            //            videoDeleteBtn.hidden = NO ;
            
            /*AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
             NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
             AVAssetTrack *track = [tracks objectAtIndex:0];
             
             CGSize mediaSize = track.naturalSize;*/
            
            
            // NSLog(@"mediaSize: %@",mediaSize.) ;
        }
    }
}

#pragma mark - ToolBar Buttons Action
- (IBAction)DatePickerToolbarButtons_ClickAction:(id)sender {
    if([sender tag] == DONE_CLICKED) {
        if(selectedDatePickerType == FUND_START_DATE_SELECTED) {
            DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:FUND_START_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:FUND_START_DATE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
        else if(selectedDatePickerType == FUND_END_DATE_SELECTED) {
            DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:FUND_END_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:FUND_END_DATE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        } else {
            DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:FUND_CLOSE_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = [dateFormatter stringFromDate:datePickerView.date];
            [[sectionsArray objectAtIndex:FUND_CLOSE_DATE_SECTION_INDEX] setValue:cell.textFld.text forKey:@"value"] ;
        }
    }
    else {
        if(selectedDatePickerType == FUND_START_DATE_SELECTED) {
            DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:FUND_START_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate ;
        }
        else if(selectedDatePickerType == FUND_END_DATE_SELECTED) {
            DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:FUND_END_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate ;
        } else {
            DobTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:FUND_CLOSE_DATE_SECTION_INDEX]] ;
            [cell.textFld resignFirstResponder] ;
            cell.textFld.text = prevDueDate ;
        }
    }
}

#pragma mark - SearchBar Delegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //    if(searchText.length < 1 || [searchText isEqualToString:@" "])
    //        return ;
    [searchResultsForKeywords removeAllObjects] ;
    
    switch (selectedKeywordType) {
        case 3: // Manager Keywords
        {
            for(NSDictionary *keywordDict in managersKeywordsArray)
            {
                NSString *keywordName = [keywordDict objectForKey:@"name"];
                NSRange range = [keywordName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if(range.location != NSNotFound)
                    [searchResultsForKeywords addObject:keywordDict];
            }
            NSLog(@"Manager Results: %@",searchResultsForKeywords);
        }
            break;
        case 4: // Sponsor Keywords
        {
            for(NSDictionary *keywordDict in sponsorsKeywordsArray)
            {
                NSString *keywordName = [keywordDict objectForKey:@"company_name"];
                NSRange range = [keywordName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if(range.location != NSNotFound)
                    [searchResultsForKeywords addObject:keywordDict];
            }
            NSLog(@"Sponsor Results: %@",searchResultsForKeywords);
        }
            break;
        case 5: // Industry Keywords
        {
            for(NSDictionary *keywordDict in industryKeywordsArray)
            {
                NSString *keywordName = [keywordDict objectForKey:@"fund_industry_name"];
                NSRange range = [keywordName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if(range.location != NSNotFound)
                    [searchResultsForKeywords addObject:keywordDict];
            }
            NSLog(@"Industry Results: %@",searchResultsForKeywords);
        }
            break;
        case 6: // Portfolio Keywords
        {
            for(NSDictionary *keywordDict in portfolioKeywordsArray)
            {
                NSString *keywordName = [keywordDict objectForKey:@"startup_name"];
                NSRange range = [keywordName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if(range.location != NSNotFound)
                    [searchResultsForKeywords addObject:keywordDict];
            }
            NSLog(@"Portfolio Results: %@",searchResultsForKeywords);
        }
            break;
        case 10: // Fund's Keywords
        {
            for(NSDictionary *keywordDict in keywordsArray)
            {
                NSString *keywordName = [keywordDict objectForKey:@"fund_keyword_name"];
                NSRange range = [keywordName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if(range.location != NSNotFound)
                    [searchResultsForKeywords addObject:keywordDict];
            }
            NSLog(@"Fund's Keyword Results: %@",searchResultsForKeywords);
        }
            break;
            
        default:
            break;
    }
    [popupTblView reloadData] ;
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
    
    
    if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0)) {
        textField.userInteractionEnabled = true;
        if(textField.tag == FUND_START_DATE_SECTION_INDEX || textField.tag == FUND_END_DATE_SECTION_INDEX || textField.tag == FUND_CLOSE_DATE_SECTION_INDEX) {
            if(textField.tag == FUND_START_DATE_SECTION_INDEX)
                selectedDatePickerType = FUND_START_DATE_SELECTED;
            else if(textField.tag == FUND_END_DATE_SECTION_INDEX)
                selectedDatePickerType = FUND_END_DATE_SELECTED;
            else
                selectedDatePickerType = FUND_CLOSE_DATE_SELECTED;
        }
        else {
            _selectedItem = textField ;
        }
        return YES ;
    } else {
        textField.userInteractionEnabled = false;
        return NO;
    }
    
    /*
    if (selectedSegmentControl == 200) {
        if (selectedSegment == MYFUNDS_SELECTED) {
            textField.userInteractionEnabled = true;
            if(textField.tag == FUND_START_DATE_SECTION_INDEX || textField.tag == FUND_END_DATE_SECTION_INDEX || textField.tag == FUND_CLOSE_DATE_SECTION_INDEX) {
                if(textField.tag == FUND_START_DATE_SECTION_INDEX)
                    selectedDatePickerType = FUND_START_DATE_SELECTED;
                else if(textField.tag == FUND_END_DATE_SECTION_INDEX)
                    selectedDatePickerType = FUND_END_DATE_SELECTED;
                else
                    selectedDatePickerType = FUND_CLOSE_DATE_SELECTED;
            }
            else {
                _selectedItem = textField ;
            }
            return YES ;
        }
        else {
            textField.userInteractionEnabled = false;
            return NO;
        }
    } else {
        textField.userInteractionEnabled = false;
        return NO;
    }
     */
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _selectedItem = nil ;
    
    if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0)) {
        textField.userInteractionEnabled = true;
        if(textField.tag == FUND_START_DATE_SECTION_INDEX || textField.tag == FUND_END_DATE_SECTION_INDEX || textField.tag == FUND_CLOSE_DATE_SECTION_INDEX) {
            prevDueDate = textField.text ;
        }
    } else
        textField.userInteractionEnabled = false;
    
    /*
    if (selectedSegmentControl == 200) {
        if (selectedSegment == MYFUNDS_SELECTED) {
            textField.userInteractionEnabled = true;
            if(textField.tag == FUND_START_DATE_SECTION_INDEX || textField.tag == FUND_END_DATE_SECTION_INDEX || textField.tag == FUND_CLOSE_DATE_SECTION_INDEX) {
                prevDueDate = textField.text ;
            }
        }
        else
            textField.userInteractionEnabled = false;
    } else
        textField.userInteractionEnabled = false;
     */
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [[sectionsArray objectAtIndex:textField.tag] setValue:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"value"] ;
    return YES ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [[sectionsArray objectAtIndex:textView.tag] setValue:[textView.text stringByReplacingCharactersInRange:range withString:text] forKey:@"value"] ;
    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
    }
    
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _selectedItem = nil ;
    
    if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0)) {
        textView.userInteractionEnabled = true;
        if([textView.text isEqualToString:@"Fund's Description"] && textView.textColor == [UIColor lightGrayColor]){
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
    
    /*
    if (selectedSegmentControl == 200) {
        if (selectedSegment == MYFUNDS_SELECTED) {
            textView.userInteractionEnabled = true;
            if([textView.text isEqualToString:@"Fund Description"] && textView.textColor == [UIColor lightGrayColor]){
                textView.text = @"" ;
                textView.textColor = [UtilityClass textColor] ;
            }
                
            CGPoint pointInTable = [textView.superview convertPoint:textView.frame.origin toView:self.tblView];
            CGPoint contentOffset = self.tblView.contentOffset;
                
            contentOffset.y = (pointInTable.y - textView.inputAccessoryView.frame.size.height);
                
            [self.tblView setContentOffset:contentOffset animated:YES];
            return YES ;
        }
        else {
            textView.userInteractionEnabled = false;
            return NO ;
        }
    } else {
        textView.userInteractionEnabled = false;
        return NO ;
    }
     */
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder] ;
    _selectedItem = nil ;
    
    if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0)) {
        textView.userInteractionEnabled = true;
        if([textView.text isEqualToString:@""]) {
            textView.text = @"Fund's Description" ;
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
    
    /*
    if (selectedSegmentControl == 200) {
        if (selectedSegment == MYFUNDS_SELECTED) {
            textView.userInteractionEnabled = true;
            if([textView.text isEqualToString:@""]) {
                textView.text = @"Fund Description" ;
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
        }
        else {
            textView.userInteractionEnabled = false;
            return NO ;
        }
    } else {
        textView.userInteractionEnabled = false;
        return NO ;
    }
     */
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0))
        textView.userInteractionEnabled = true;
     else
        textView.userInteractionEnabled = false;

    /*
    if (selectedSegmentControl == 200) {
        if (selectedSegment == MYFUNDS_SELECTED)
            textView.userInteractionEnabled = true;
        else
            textView.userInteractionEnabled = false;
    } else
        textView.userInteractionEnabled = false;
     */
}

#pragma mark - Keyoboard Actions
- (void)keyboardDidShow:(NSNotification *)notification
{
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
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.tblView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - DatePicker Value Changed
- (void)datePickerChanged:(UIDatePicker *)datePicker {
    DobTableViewCell *cell;
    if (selectedDatePickerType == FUND_START_DATE_SELECTED) {
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:FUND_START_DATE_SECTION_INDEX]] ;
    } else if (selectedDatePickerType == FUND_END_DATE_SELECTED)
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:FUND_END_DATE_SECTION_INDEX]] ;
    else
        cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:FUND_CLOSE_DATE_SECTION_INDEX]] ;
    [cell.textFld setText:[dateFormatter stringFromDate:datePicker.date]];
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - API Methods
-(void)getFundKeywordsList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        [ApiCrowdBootstrap getFundKeywordsList:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"response : %@", responseDict);
                [keywordsArray removeAllObjects] ;
                if([responseDict objectForKey:kFundAPI_KeywordList]) {
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:kFundAPI_KeywordList] mutableCopy]) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:[dict mutableCopy]] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        [keywordsArray addObject:obj] ;
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

-(void)getFundIndustryKeywordsList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        [ApiCrowdBootstrap getFundIndustryKeywordsList:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"response : %@", responseDict);
                [industryKeywordsArray removeAllObjects] ;
                if([responseDict objectForKey:kFundAPI_Industry_List]) {
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:kFundAPI_Industry_List] mutableCopy]) {
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

-(void)getFundManagerKeywordsList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAddFundAPI_UserID] ;
        
        [ApiCrowdBootstrap getFundManagerKeywordsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"response : %@", responseDict);
                [managersKeywordsArray removeAllObjects] ;
                if([responseDict objectForKey:kFundAPI_Manager_List]) {
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:kFundAPI_Manager_List] mutableCopy]) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:[dict mutableCopy]] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        [managersKeywordsArray addObject:obj] ;
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

-(void)getFundSponsorKeywordsList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAddFundAPI_UserID] ;
        
        [ApiCrowdBootstrap getFundSponsorKeywordsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"response : %@", responseDict);
                [sponsorsKeywordsArray removeAllObjects] ;
                if([responseDict objectForKey:kFundAPI_Sponsor_List]) {
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:kFundAPI_Sponsor_List] mutableCopy]) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:[dict mutableCopy]] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        [sponsorsKeywordsArray addObject:obj] ;
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

-(void)getFundPortfolioKeywordsList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAddFundAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[fundData valueForKey:kFundAPI_ID]] forKey:kFundDetailAPI_FundID] ;
        NSLog(@"dictParam: %@",dictParam) ;

        [ApiCrowdBootstrap getEditFundPortfolioKeywordsListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                NSLog(@"response : %@", responseDict);
                [portfolioKeywordsArray removeAllObjects] ;
                if([responseDict objectForKey:kFundAPI_Portfolio_List]) {
                    for (NSDictionary *dict in (NSArray*)[[responseDict objectForKey:kFundAPI_Portfolio_List] mutableCopy]) {
                        NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:[dict mutableCopy]] ;
                        [obj setValue:@"0" forKey:@"isSelected"] ;
                        [portfolioKeywordsArray addObject:obj] ;
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

-(void)getFundDetails {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAddFundAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[fundData valueForKey:kFundAPI_ID]] forKey:kFundDetailAPI_FundID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap viewFundWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"respos %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                for ( int i = 0; i < sectionsArray.count ; i++ ) {
                        NSString *key = [[sectionsArray objectAtIndex:i] valueForKey:@"key"] ;
                        if(i != FUND_INDUSTRY_KEYWORDS_SECTION_INDEX && i != FUND_MANAGERS_KEYWORDS_SECTION_INDEX && i != FUND_SPONSORS_KEYWORDS_SECTION_INDEX && i != FUND_PORTFOLIO_KEYWORDS_SECTION_INDEX && i != FUND_KEYWORDS_SECTION_INDEX) {
                                if([responseDict valueForKey:key])
                                    [[sectionsArray objectAtIndex:i] setValue:[responseDict valueForKey:key] forKey:@"value"] ;
                        }
                    }
                
                // Keywords Array
                if([responseDict objectForKey:kFundDetailAPI_IndustryKeywords]) {
                    selectedIndustryKeywordsArray = [[responseDict objectForKey:kFundDetailAPI_IndustryKeywords] mutableCopy];
                    selectedIndustryKeywordNames = [self resetTagsArrayWithData:selectedIndustryKeywordsArray];
                    selectedIndustryKeywordIds = [self resetTagIdsArrayWithData:selectedIndustryKeywordsArray];
                }
                if([responseDict objectForKey:kFundDetailAPI_PortfolioKeywords]) {
                    selectedPortfolioKeywordsArray = [[responseDict objectForKey:kFundDetailAPI_PortfolioKeywords] mutableCopy] ;
                    selectedPortfolioKeywordNames = [self resetTagsArrayWithData:selectedPortfolioKeywordsArray];
                    selectedPortfolioKeywordIds = [self resetTagIdsArrayWithData:selectedPortfolioKeywordsArray];
                }
                if([responseDict objectForKey:kFundDetailAPI_ManagerKeywords]) {
                    selectedManagersKeywordsArray = [[responseDict objectForKey:kFundDetailAPI_ManagerKeywords] mutableCopy];
                    selectedManagersKeywordNames = [self resetTagsArrayWithData:selectedManagersKeywordsArray];
                    selectedManagersKeywordIds = [self resetTagIdsArrayWithData:selectedManagersKeywordsArray];
                }
                if([responseDict objectForKey:kFundDetailAPI_SponsorKeywords]) {
                    selectedSponsorsKeywordsArray = [[responseDict objectForKey:kFundDetailAPI_SponsorKeywords] mutableCopy];
                    selectedSponsorsKeywordNames = [self resetTagsArrayWithData:selectedSponsorsKeywordsArray];
                    selectedSponsorsKeywordIds = [self resetTagIdsArrayWithData:selectedSponsorsKeywordsArray];
                }
                if([responseDict objectForKey:kFundDetailAPI_FundKeywords]) {
                    selectedKeywordsArray = [[responseDict objectForKey:kFundDetailAPI_FundKeywords] mutableCopy];
                    selectedKeywordNames = [self resetTagsArrayWithData:selectedKeywordsArray];
                    selectedKeywordIds = [self resetTagIdsArrayWithData:selectedKeywordsArray];
                }
                
                // Document
                if([responseDict objectForKey:kFundDetailAPI_Document])
                    docuementFile = [[responseDict objectForKey:kFundDetailAPI_Document] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] ;
                
                // Audio
                if([responseDict objectForKey:kFundDetailAPI_Audio])
                    audioFile = [[responseDict objectForKey:kFundDetailAPI_Audio] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] ;
                
                // Video
                if([responseDict objectForKey:kFundDetailAPI_Video])
                    videoFile = [[responseDict objectForKey:kFundDetailAPI_Video] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                
                // Image
                if([responseDict objectForKey:kFundDetailAPI_Image]) {
                    NSString *strImage = [NSString stringWithFormat:@"%@%@",APIPortToBeUsed, [responseDict objectForKey:kFundDetailAPI_Image]];
                    NSURL *url = [NSURL URLWithString:[strImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    imgData = [NSData dataWithContentsOfURL:url];
                }
                
                // check if user liked
                isLiked = [[responseDict valueForKey:kFundDetailAPI_IsLiked] intValue];
                // check if user followed
                isFollowed = [[responseDict valueForKey:kFundDetailAPI_IsFollowed] intValue];

                // Refresh Dict
                [fundData setValue:[NSString stringWithFormat:@"%@",[responseDict valueForKey:kFundDetailAPI_FundTitle]] forKey:kFundDetailAPI_FundTitle] ;
                [fundData setValue:[NSString stringWithFormat:@"%@",[responseDict valueForKey:kFundDetailAPI_CreatedBy]] forKey:kFundDetailAPI_CreatedBy] ;
                [fundData setValue:[NSString stringWithFormat:@"%@",[responseDict valueForKey:kFundDetailAPI_CreatedBy_UserID]] forKey:kFundDetailAPI_CreatedBy_UserID] ;
                [fundData setValue:[NSString stringWithFormat:@"%@",[responseDict valueForKey:kFundDetailAPI_StartDate]] forKey:kFundDetailAPI_StartDate] ;
                [fundData setValue:[NSString stringWithFormat:@"%@",[responseDict valueForKey:kFundDetailAPI_EndDate]] forKey:kFundDetailAPI_EndDate] ;
                [fundData setValue:[NSString stringWithFormat:@"%@",[responseDict valueForKey:kFundDetailAPI_CloseDate]] forKey:kFundDetailAPI_CloseDate] ;
                [fundData setValue:[NSString stringWithFormat:@"%@",[responseDict valueForKey:kFundDetailAPI_Description]] forKey:kFundDetailAPI_Description] ;
                    
                [UtilityClass setFundsDetails:[fundData mutableCopy]] ;
                    
                [_tblView reloadData] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)editFund {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kAddFundAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%@",[fundData valueForKey:kFundAPI_ID]] forKey:kFundDetailAPI_FundID] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:FUND_TITLE_SECTION_INDEX] valueForKey:@"value"] forKey:kAddFundAPI_Fund_Title] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:FUND_DESCRIPTION_SECTION_INDEX] valueForKey:@"value"] forKey:kAddFundAPI_Description] ;
        
        [dictParam setObject:[[sectionsArray objectAtIndex:FUND_START_DATE_SECTION_INDEX] valueForKey:@"value"] forKey:kAddFundAPI_StarDate] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:FUND_END_DATE_SECTION_INDEX] valueForKey:@"value"] forKey:kAddFundAPI_EndDate] ;
        [dictParam setObject:[[sectionsArray objectAtIndex:FUND_CLOSE_DATE_SECTION_INDEX] valueForKey:@"value"] forKey:kAddFundAPI_CloseDate] ;
        
        [dictParam setObject:[self convertTagsArrayToStringforArray:selectedIndustryKeywordsArray withTagsArray:industryKeywordsArray tagType:@"industry"] forKey:kAddFundAPI_IndustryKeywords] ;
        [dictParam setObject:[self convertTagsArrayToStringforArray:selectedKeywordsArray withTagsArray:keywordsArray tagType:@"fundkeyword"] forKey:kAddFundAPI_Keywords] ;
        [dictParam setObject:[self convertTagsArrayToStringforArray:selectedManagersKeywordsArray withTagsArray:managersKeywordsArray tagType:@"managers"] forKey:kAddFundAPI_Managers] ;
        [dictParam setObject:[self convertTagsArrayToStringforArray:selectedSponsorsKeywordsArray withTagsArray:sponsorsKeywordsArray tagType:@"sponsors"] forKey:kAddFundAPI_Sponsors] ;
        [dictParam setObject:[self convertTagsArrayToStringforArray:selectedPortfolioKeywordsArray withTagsArray:portfolioKeywordsArray tagType:@"portfolio"] forKey:kAddFundAPI_PortfolioKeywords] ;
        
        [dictParam setObject:@"0" forKey:kEditFundAPI_Image_Del] ;
        [dictParam setObject:@"0" forKey:kEditFundAPI_Doc_Del] ;
        [dictParam setObject:@"0" forKey:kEditFundAPI_Audio_Del] ;
        [dictParam setObject:@"0" forKey:kEditFundAPI_Video_Del] ;

        if(imgData)
            [dictParam setObject:imgData forKey:kAddFundAPI_Fund_Image] ;
        else
            [dictParam setObject:@"" forKey:kAddFundAPI_Fund_Image] ;
        
        [dictParam setObject:@"" forKey:kAddFundAPI_Document] ;
        [dictParam setObject:@"" forKey:kAddFundAPI_Audio] ;
        [dictParam setObject:@"" forKey:kAddFundAPI_Video] ;

        NSLog(@"dictParam: %@",dictParam) ;
        CommitTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionsArray.count]] ;
        cell.progressLbl.hidden = NO ;
        cell.progressView.hidden = NO ;

        [ApiCrowdBootstrap editFundWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            cell.progressLbl.hidden = YES ;
            cell.progressView.hidden = YES ;

            NSLog(@"responseDict >>>>> %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                
                [UtilityClass showNotificationMessgae:kEditFund_SuccessMessage withResultType:@"0" withDuration:1] ;
                [UtilityClass setComingFrom_Funds_AddEditScreen:YES];

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
        }];
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == popupTblView) {
        if (![searchBarKeywords.text isEqualToString:@""])
            return searchResultsForKeywords.count ;
        else {
            if(selectedKeywordType == FUND_INDUSTRY_KEYWORDS_SELECTED)
                return industryKeywordsArray.count ;
            else if (selectedKeywordType == FUND_MANAGERS_KEYWORDS_SELECTED)
                return managersKeywordsArray.count ;
            else if (selectedKeywordType == FUND_PORTFOLIO_KEYWORDS_SELECTED)
                return portfolioKeywordsArray.count ;
            else if (selectedKeywordType == FUND_SPONSORS_KEYWORDS_SELECTED)
                return sponsorsKeywordsArray.count ;
            else
                return keywordsArray.count ;
        }
    } else {
        if(section <= FUND_KEYWORDS_SECTION_INDEX || section == sectionsArray.count)
            return 1;
        else {
            if(section == FUND_IMAGE_SECTION_INDEX) {
                if ([[arrayForBool objectAtIndex:section] boolValue])
                    return 1;
                else return 0 ;
            }
            else if(section == FUND_DOCUMENT_SECTION_INDEX ) {
                if ([[arrayForBool objectAtIndex:section] boolValue]) return 1;
                else  return 0 ;
            }
            else if(section == FUND_AUDIO_SECTION_INDEX) {
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

        if(selectedKeywordType == FUND_INDUSTRY_KEYWORDS_SELECTED) {
            if (![searchBarKeywords.text isEqualToString:@""])
                dictKeyword = [searchResultsForKeywords objectAtIndex:indexPath.row];
            else
                dictKeyword = [industryKeywordsArray objectAtIndex:indexPath.row];

            cell.companyNameLbl.text = [dictKeyword valueForKey:kFundAPI_Industry_Name] ;
            if ([selectedIndustryKeywordIds containsObject:[dictKeyword valueForKey:kFundAPI_Industry_ID]]) {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
                [dictKeyword setValue:@"1" forKey:@"isSelected"] ;
            } else {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
                [dictKeyword setValue:@"0" forKey:@"isSelected"] ;
            }
        }
        else if (selectedKeywordType == FUND_MANAGERS_KEYWORDS_SELECTED) {
            
            if (![searchBarKeywords.text isEqualToString:@""])
                dictKeyword = [searchResultsForKeywords objectAtIndex:indexPath.row];
            else
                dictKeyword = [managersKeywordsArray objectAtIndex:indexPath.row];

            cell.companyNameLbl.text = [dictKeyword valueForKey:kFundAPI_Manager_Name] ;
            
            if ([selectedManagersKeywordIds containsObject:[dictKeyword valueForKey:kFundAPI_Manager_ID]]) {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
                [dictKeyword setValue:@"1" forKey:@"isSelected"] ;
            } else {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
                [dictKeyword setValue:@"0" forKey:@"isSelected"] ;
            }
        }
        else if (selectedKeywordType == FUND_SPONSORS_KEYWORDS_SELECTED) {
            if (![searchBarKeywords.text isEqualToString:@""])
                dictKeyword = [searchResultsForKeywords objectAtIndex:indexPath.row];
            else
                dictKeyword = [sponsorsKeywordsArray objectAtIndex:indexPath.row];

            cell.companyNameLbl.text = [dictKeyword valueForKey:kFundAPI_Sponsor_CompanyName] ;

            if ([selectedSponsorsKeywordIds containsObject:[dictKeyword valueForKey:kFundAPI_Sponsor_ID]]) {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
                [dictKeyword setValue:@"1" forKey:@"isSelected"] ;
            } else {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
                [dictKeyword setValue:@"0" forKey:@"isSelected"] ;
            }
        }
        else if (selectedKeywordType == FUND_PORTFOLIO_KEYWORDS_SELECTED) {
            if (![searchBarKeywords.text isEqualToString:@""])
                dictKeyword = [searchResultsForKeywords objectAtIndex:indexPath.row];
            else
                dictKeyword = [portfolioKeywordsArray objectAtIndex:indexPath.row];

            cell.companyNameLbl.text = [dictKeyword valueForKey:kFundAPI_Portfolio_Name] ;

            if ([selectedPortfolioKeywordIds containsObject:[dictKeyword valueForKey:kFundAPI_Portfolio_ID]]) {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = CHECK_IMAGE ;
                [dictKeyword setValue:@"1" forKey:@"isSelected"] ;
            } else {
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
                [dictKeyword setValue:@"0" forKey:@"isSelected"] ;
            }
        }
        else
        {
            if (![searchBarKeywords.text isEqualToString:@""])
                dictKeyword = [searchResultsForKeywords objectAtIndex:indexPath.row];
            else
                dictKeyword = [keywordsArray objectAtIndex:indexPath.row];

            cell.companyNameLbl.text = [dictKeyword valueForKey:kFundAPI_KeywordName] ;

            if ([selectedKeywordIds containsObject:[dictKeyword valueForKey:kFundAPI_KeywordID]]) {
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
    } else {
        if(indexPath.section == sectionsArray.count) {
            CommitTableViewCell *cell = (CommitTableViewCell*)[tableView dequeueReusableCellWithIdentifier:SUBMIT_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            return cell ;
        }
        else if(indexPath.section == FUND_FOLLOW_SECTION_INDEX) {
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
                cell.constraintLikeBtnTrailing.constant = 0;
            } else {
                cell.followBtn.hidden = false;
                cell.constraintLikeBtnTrailing.constant = 80;
            }
            
            return cell;
        }
        else if (indexPath.section == FUND_INDUSTRY_KEYWORDS_SECTION_INDEX || indexPath.section == FUND_MANAGERS_KEYWORDS_SECTION_INDEX || indexPath.section == FUND_SPONSORS_KEYWORDS_SECTION_INDEX || indexPath.section == FUND_PORTFOLIO_KEYWORDS_SECTION_INDEX || indexPath.section == FUND_KEYWORDS_SECTION_INDEX) {
            
            KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KEYWORDS_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [UtilityClass setButtonBorder:cell.button] ;
            cell.tagsScrollView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1] CGColor];
            cell.tagsScrollView.backgroundColor = [UIColor clearColor] ;
            cell.tagsScrollView.tag = indexPath.section ;
            cell.button.tag = indexPath.section ;
            cell.plusBtn.tag = indexPath.section ;
            
            NSMutableArray *tags ;
            if(indexPath.section == FUND_INDUSTRY_KEYWORDS_SECTION_INDEX)
                tags = [selectedIndustryKeywordNames mutableCopy] ;
            else if(indexPath.section == FUND_MANAGERS_KEYWORDS_SECTION_INDEX)
                tags = [selectedManagersKeywordNames mutableCopy] ;
            else if(indexPath.section == FUND_SPONSORS_KEYWORDS_SECTION_INDEX)
                tags = [selectedSponsorsKeywordNames mutableCopy] ;
            else if(indexPath.section == FUND_PORTFOLIO_KEYWORDS_SECTION_INDEX)
                tags = [selectedPortfolioKeywordNames mutableCopy] ;
            else
                tags = [selectedKeywordNames mutableCopy] ;
            
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
                txtViewTapped.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
                [cell.tagsScrollView addGestureRecognizer:txtViewTapped];
            } else {
                cell.tagsScrollView.mode = TLTagsControlModeList;
                cell.plusBtn.hidden = true;
            }
            
            cell.tagsScrollView.tagsBackgroundColor = [UtilityClass orangeColor];
            [cell.tagsScrollView reloadTagSubviews];
            
            return cell ;
        }
        else if(indexPath.section == FUND_DESCRIPTION_SECTION_INDEX) {
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
        else if(indexPath.section == FUND_START_DATE_SECTION_INDEX || indexPath.section == FUND_END_DATE_SECTION_INDEX || indexPath.section == FUND_CLOSE_DATE_SECTION_INDEX) {
            
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
        else if(indexPath.section == FUND_IMAGE_SECTION_INDEX) {
            
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
            
        } else if (indexPath.section == FUND_DOCUMENT_SECTION_INDEX || indexPath.section == FUND_AUDIO_SECTION_INDEX || indexPath.section == FUND_VIDEO_SECTION_INDEX) {
            CampaignDocumentTableViewCell *cell = (CampaignDocumentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:PLAY_AUDIO_CELL_IDENTIFIER] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            if(indexPath.section == FUND_DOCUMENT_SECTION_INDEX)
                cell.lbl.text = [NSString stringWithFormat:@"Docuement %ld",indexPath.row+1] ;
            else if(indexPath.section == FUND_AUDIO_SECTION_INDEX)
                cell.lbl.text = [NSString stringWithFormat:@"Audio %ld",indexPath.row+1] ;
            else
                cell.lbl.text = [NSString stringWithFormat:@"Video %ld",indexPath.row+1] ;
            
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
    else {
        if ((selectedSegmentControl == 100 && selectedSegment == 1) || (selectedSegmentControl == 200 && selectedSegment == 0)) {
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
        if(indexPath.section >= FUND_DOCUMENT_SECTION_INDEX && indexPath.section < sectionsArray.count) {
            
            NSString *filePath ;
            if(indexPath.section == FUND_DOCUMENT_SECTION_INDEX) {
                filePath = [NSString stringWithFormat:@"%@/%@",APIPortToBeUsed,docuementFile] ;
                dataTitle.text = @"Document" ;
            }
            else if(indexPath.section == FUND_AUDIO_SECTION_INDEX) {
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
    else {
        if(indexPath.section == FUND_START_DATE_SECTION_INDEX || indexPath.section == FUND_END_DATE_SECTION_INDEX || indexPath.section == FUND_CLOSE_DATE_SECTION_INDEX) {
            return 65;
        }
        else if (indexPath.section == FUND_FOLLOW_SECTION_INDEX)
            return 40;
        else if(indexPath.section == FUND_DESCRIPTION_SECTION_INDEX)
            return 121 ;
        else if(indexPath.section == FUND_IMAGE_SECTION_INDEX) {
            if (selectedSegmentControl == 200) {
                if (selectedSegment == MYFUNDS_SELECTED)
                    return 155 ;
                else
                    return 115;
            } else
                return 115;
        }
        else if(indexPath.section == FUND_INDUSTRY_KEYWORDS_SECTION_INDEX || indexPath.section == FUND_MANAGERS_KEYWORDS_SECTION_INDEX || indexPath.section == FUND_SPONSORS_KEYWORDS_SECTION_INDEX || indexPath.section == FUND_PORTFOLIO_KEYWORDS_SECTION_INDEX || indexPath.section == FUND_KEYWORDS_SECTION_INDEX)
            return 70 ;
        else if(indexPath.section == sectionsArray.count)
            return 95;
        else if(indexPath.section == FUND_DOCUMENT_SECTION_INDEX || indexPath.section == FUND_AUDIO_SECTION_INDEX || indexPath.section == FUND_VIDEO_SECTION_INDEX )
            return 45 ;
        else
            return 75;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section <= FUND_KEYWORDS_SECTION_INDEX || section == sectionsArray.count)return 0;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedSegment == ARCHIVE_FUNDS_SELECTED || selectedSegment == DEACTIVATED_FUNDS_SELECTED)
        return false;
    else
        return true;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
