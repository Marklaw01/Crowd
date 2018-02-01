//
//  LeanStartupRoadmapViewController.m
//  CrowdBootstrap
//
//  Created by Shikha Singla on 19/09/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "LeanStartupRoadmapViewController.h"
#import "Title1CollectionViewCell.h"
#import "Title3CollectionViewCell.h"
#import "Title2CollectionViewCell.h"
#import "Title4CollectionViewCell.h"
#import "Roadmap.h"

@interface LeanStartupRoadmapViewController ()
{
    Roadmap *roadmap;
    int index_up;
    int index_down;
}
@end

@implementation LeanStartupRoadmapViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Reset UI
    [self resetUISettings] ;
    
    // Initialization
    [self initialize];
    
    // Register Nib for Custom Cells
    [self registerNib];
    
    // Hit Api to get Startup Roadmaps
    [self getLeanStartupRoadMaps] ;
}

- (void) viewWillAppear:(BOOL)animated {
    // Add Notifications
    [self addObserver];
}

- (void) viewWillDisappear:(BOOL)animated {
    // Remove Notifications
    [self removeObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void) addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showRoadmapDescription:) name:kNotification_ShowRoadmapDescription
                                               object:nil];
}

- (void) removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) initialize {
    upwardArray = [[NSMutableArray alloc] init];
    downwardArray = [[NSMutableArray alloc] init];
    roadMapArray = [[NSMutableArray alloc] init];
    roadmap = [[Roadmap alloc] init];
    index_down = 0;
    index_up = 0;
    
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((webViewPopup.frame.size.width/2)-50, (webViewPopup.frame.size.height/2)-40, 40, 40)];
    [loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator setHidesWhenStopped:YES];
    [webViewPopup addSubview:loadingIndicator];
}

-(void)resetUISettings {
    self.title = @"Lean Startup Roadmap" ;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    
    btnLicense.titleLabel.text = [NSString stringWithFormat:@"License - Required Attribution: © %@ Crowd Bootstrap",yearString];
}

- (void) registerNib {
    [collectionViewRoadmap registerNib:[UINib nibWithNibName:@"Title1CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Title1Cell"];
    [collectionViewRoadmap registerNib:[UINib nibWithNibName:@"Title2CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Title2Cell"];
    [collectionViewRoadmap registerNib:[UINib nibWithNibName:@"Title3CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Title3Cell"];
    [collectionViewRoadmap registerNib:[UINib nibWithNibName:@"Title4CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Title4Cell"];
}

- (void) showRoadmapDescription: (NSNotification *) notification {
    Roadmap *roadmapObj = (Roadmap *)notification.object;
    roadmap = roadmapObj;
    
    // Set Title
    lblTitle.text = roadmapObj.title;
    
    // Clear Cache of WebView
    [webViewPopup loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    // Set description on Webview
    NSURL *url = [NSURL URLWithString:roadmapObj.desc];
    [webViewPopup loadRequest:[NSURLRequest requestWithURL:url]];
    
    vwPopup.hidden = false;
    btnSample.hidden = false;
    btnTemplate.hidden = false;
    constraintScrollDownLabel.constant = 103.0;
}

- (void)animatePopup {
    [UIView animateWithDuration:0.3/1.5 animations:^{
        vwPopup.hidden = false;
        vwPopup.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            vwPopup.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                vwPopup.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

#pragma mark - CollectionView Data Source and Delegate Methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return roadMapArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Title1CollectionViewCell *cell1 = (Title1CollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Title1Cell" forIndexPath:indexPath];
    Title2CollectionViewCell *cell2 = (Title2CollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Title2Cell" forIndexPath:indexPath];
    Title3CollectionViewCell *cell3 = (Title3CollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Title3Cell" forIndexPath:indexPath];
    Title4CollectionViewCell *cell4 = (Title4CollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Title4Cell" forIndexPath:indexPath];
    
    Roadmap *roadmapObj = [roadMapArray objectAtIndex:indexPath.row];
    
    if ((indexPath.row) % 2 == 0) { // Yellow
        if ([roadmapObj.direction  isEqual: @"up"]) { // Upward
            if ((roadmapObj.index % 2) == 0) {
                [cell2 setData:[roadMapArray objectAtIndex:indexPath.row]];
                return cell2;
            } else {
                [cell1 setData:[roadMapArray objectAtIndex:indexPath.row]];
                return cell1;
            }
        }
        else { // Downward
            [cell3 setData:[roadMapArray objectAtIndex:indexPath.row]];
            return cell3;
        }
    } else { // Green
        if ([roadmapObj.direction  isEqual: @"up"]) { // Upward
            [cell2 setData:[roadMapArray objectAtIndex:indexPath.row]];
            return cell2;
        } else { // Downward
            if ((roadmapObj.index % 2) == 0) {
                [cell4 setData:[roadMapArray objectAtIndex:indexPath.row]];
                return cell4;
            } else {
                [cell3 setData:[roadMapArray objectAtIndex:indexPath.row]];
                return cell3;
            }
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if IS_IPHONE_4_OR_LESS {
        return CGSizeMake(85, 134);
    } else if IS_IPHONE_5 {
        return CGSizeMake(85, 134);
    } else if IS_IPHONE_6 {
        return CGSizeMake(85, 160);
    }
    return CGSizeMake(85, 178);
}

#pragma mark - ScrollView Delegate
// Set Scrolling Direction
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float scrollViewWidth = scrollView.frame.size.width;
    float scrollContentSizeWidth = scrollView.contentSize.width;
    float scrollOffset = scrollView.contentOffset.x;
    
    if (scrollOffset == 0) { // Scrolling at Top
        imgViewArrowLeft.hidden = true;
        imgViewArrowRight.hidden = false;
        lblScroll.text = @"Scroll Right";
        
    } else if (scrollOffset + scrollViewWidth == scrollContentSizeWidth) { // Scrolling at End
        imgViewArrowLeft.hidden = false;
        imgViewArrowRight.hidden = true;
        lblScroll.text = @"Scroll Left";
        
    } else if (self.lastContentOffset > scrollOffset) { // Scrolling Left
        imgViewArrowLeft.hidden = false;
        imgViewArrowRight.hidden = false;
        lblScroll.text = @"Scroll";
        
    } else if (self.lastContentOffset < scrollOffset) { // Scrolling Right
        imgViewArrowLeft.hidden = false;
        imgViewArrowRight.hidden = false;
        lblScroll.text = @"Scroll";
    }
}

#pragma mark - WebView Delegate
// Set Webview Content Font
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [loadingIndicator startAnimating];

    int fontSize = 80;
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
    [webViewPopup stringByEvaluatingJavaScriptFromString:jsString];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //Check here if still webview is loding the content
    [loadingIndicator stopAnimating];
}

#pragma mark - API Methods
-(void)getLeanStartupRoadMaps {
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [ApiCrowdBootstrap getLeanStartupRoadmap:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                
                NSMutableArray *arrData = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:@"startup"]] ;
                
                for (int i = 0; i < arrData.count; i++) {
                    Roadmap *roadmapobj = [Roadmap new];
                    roadmapobj.titelId = [[arrData objectAtIndex:i] valueForKey:@"id"];
                    roadmapobj.title = [[arrData objectAtIndex:i] valueForKey:@"title"];
                    roadmapobj.desc = [[arrData objectAtIndex:i] valueForKey:@"description"];
                    roadmapobj.color = [[arrData objectAtIndex:i] valueForKey:@"color"];
                    roadmapobj.sampleLink = [[arrData objectAtIndex:i] valueForKey:@"sample_link"];
                    roadmapobj.templateLink = [[arrData objectAtIndex:i] valueForKey:@"template_link"];

                    if (i % 2 == 0) {
                        roadmapobj.direction = @"up";
                        index_up = index_up + 1;
                        roadmapobj.index = index_up;
                        [roadMapArray addObject:roadmapobj];
                    } else {
                        roadmapobj.direction = @"down";
                        index_down = index_down + 1;
                        roadmapobj.index = index_down;
                        [roadMapArray addObject:roadmapobj];
                    }
                }
                
                [collectionViewRoadmap reloadData];
                // Set Roadmap Image
                UIImage *roadImage = [UIImage new];
                
                if IS_IPHONE_4_OR_LESS {
                    roadImage = [self imageWithImage:[UIImage imageNamed:LEAN_STARTUP_ROADMAP_IMAGE] scaledToSize:CGSizeMake(1105, self.view.frame.size.width - 51)];
                } else if IS_IPHONE_5 {
                    roadImage = [self imageWithImage:[UIImage imageNamed:LEAN_STARTUP_ROADMAP_IMAGE] scaledToSize:CGSizeMake(1105, self.view.frame.size.width - 52)];
                } else if IS_IPHONE_6 {
                    roadImage = [self imageWithImage:[UIImage imageNamed:LEAN_STARTUP_ROADMAP_IMAGE] scaledToSize:CGSizeMake(1105, self.view.frame.size.width - 55)];
                } else {
                    roadImage = [self imageWithImage:[UIImage imageNamed:LEAN_STARTUP_ROADMAP_IMAGE] scaledToSize:CGSizeMake(1105, self.view.frame.size.width - 57)];
                }
                collectionViewRoadmap.backgroundColor = [UIColor colorWithPatternImage:roadImage];
            }
            else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - Scale Roadmap Image
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - IBAction Methods
- (IBAction)BackBtn_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)btnVentureCapitalClicked:(id)sender {
    
    [self animatePopup];
    
    // Set Title
    lblTitle.text = @"Venture Capital";
    [webViewPopup loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];

    // Set description
    NSURL *url = [NSURL URLWithString:VENTURE_CAPITAL_LINK];
    [webViewPopup loadRequest:[NSURLRequest requestWithURL:url]];
    
    btnSample.hidden = true;
    btnTemplate.hidden = true;
    constraintScrollDownLabel.constant = 20.0;
}

// Hide Pop-Up
- (IBAction)btnCloseClicked:(id)sender {
    vwPopup.hidden = true;
    
    // Set Roadmap Image
    UIImage *roadImage = [UIImage new];
    if IS_IPHONE_4_OR_LESS {
        roadImage = [self imageWithImage:[UIImage imageNamed:LEAN_STARTUP_ROADMAP_IMAGE] scaledToSize:CGSizeMake(1105, self.view.frame.size.width - 51)];
    } else if IS_IPHONE_5 {
        roadImage = [self imageWithImage:[UIImage imageNamed:LEAN_STARTUP_ROADMAP_IMAGE] scaledToSize:CGSizeMake(1105, self.view.frame.size.width - 52)];
    } else if IS_IPHONE_6 {
        roadImage = [self imageWithImage:[UIImage imageNamed:LEAN_STARTUP_ROADMAP_IMAGE] scaledToSize:CGSizeMake(1105, self.view.frame.size.width - 55)];
    } else {
        roadImage = [self imageWithImage:[UIImage imageNamed:LEAN_STARTUP_ROADMAP_IMAGE] scaledToSize:CGSizeMake(1105, self.view.frame.size.width - 57)];
    }
    collectionViewRoadmap.backgroundColor = [UIColor colorWithPatternImage:roadImage];
}

// Show PDF Sample
- (IBAction)btnSampleClicked:(id)sender {
    //    [webViewPopup loadData:[NSData dataWithContentsOfFile:roadmap.sampleLink] MIMEType:@"application/vnd.ms-powerpoint" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:roadmap.sampleLink]];
    NSDictionary *options = @{UIApplicationOpenURLOptionsSourceApplicationKey : @YES};
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[roadmap.sampleLink stringByReplacingOccurrencesOfString:@" " withString:@"%20"]] options:options completionHandler:nil];
}

// Show PDF Sample
- (IBAction)btnTemplateClicked:(id)sender {
    NSDictionary *options = @{UIApplicationOpenURLOptionsSourceApplicationKey : @YES};
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[roadmap.templateLink stringByReplacingOccurrencesOfString:@" " withString:@"%20"]] options:options completionHandler:nil];
}

- (IBAction)btnRoadmapTemplateClicked:(id)sender {
    [self animatePopup];
    
    // Set Title
    lblTitle.text = @"Roadmap Template";
    [webViewPopup loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    // Set description
    NSURL *url = [NSURL URLWithString:ROADMAP_TEMPLATE_LINK];
    [webViewPopup loadRequest:[NSURLRequest requestWithURL:url]];
    
    btnSample.hidden = true;
    btnTemplate.hidden = true;
    constraintScrollDownLabel.constant = 20.0;
}

- (IBAction)btnLicenseClicked:(id)sender {
    
    [self animatePopup];
    
    // Set Title
    lblTitle.text = @"License";

    [webViewPopup loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    // Set description
    NSURL *url = [NSURL URLWithString:LICENSE_LINK];
    [webViewPopup loadRequest:[NSURLRequest requestWithURL:url]];
    
    btnSample.hidden = true;
    btnTemplate.hidden = true;
    constraintScrollDownLabel.constant = 20.0;
}

@end
