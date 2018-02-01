//
//  LeanStartupRoadmapViewController.h
//  CrowdBootstrap
//
//  Created by Shikha Singla on 19/09/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeanStartupRoadmapViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    // IBOutlets
    __weak IBOutlet UIView *vwScroll;
    __weak IBOutlet UIImageView *imgViewArrowLeft;
    __weak IBOutlet UIImageView *imgViewArrowRight;
    __weak IBOutlet UILabel *lblScroll;
    __weak IBOutlet UIButton *btnLicense;
    
    __weak IBOutlet UICollectionView             *collectionViewRoadmap ;

    // Pop-Up View
    __weak IBOutlet UIView *vwPopup;
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet UIButton *btnSample;
    __weak IBOutlet UIButton *btnTemplate;
    __weak IBOutlet UIWebView *webViewPopup;
    
    __weak IBOutlet NSLayoutConstraint *constraintScrollDownLabel;
    
    // Variables
    NSMutableArray                   *upwardArray ;
    NSMutableArray                   *roadMapArray ;
    NSMutableArray                   *downwardArray ;
    UIActivityIndicatorView          *loadingIndicator;
}

@property (nonatomic) CGFloat lastContentOffset;

// IBActions
- (IBAction)btnVentureCapitalClicked:(id)sender;
- (IBAction)btnCloseClicked:(id)sender;
- (IBAction)btnSampleClicked:(id)sender;
- (IBAction)btnTemplateClicked:(id)sender;
- (IBAction)btnRoadmapTemplateClicked:(id)sender;
- (IBAction)btnLicenseClicked:(id)sender;

@end
