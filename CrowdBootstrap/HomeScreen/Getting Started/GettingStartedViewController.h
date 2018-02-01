//
//  GettingStartedViewController.h
//  CrowdBootstrap
//
//  Created by osx on 05/01/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GettingStartedViewController : UIViewController
{
    // --- IBOutlets ---
    __weak IBOutlet UIBarButtonItem *menuBarBtn;
    __weak IBOutlet UIView *vwPopUp;
    __weak IBOutlet UITextView *txtViewDesc;
    __weak IBOutlet UIButton *btnEntrepreneur;
    __weak IBOutlet UIButton *btnExpert;
    __weak IBOutlet UIButton *btnRecruiter;
    __weak IBOutlet UIButton *btnOrganization;
    __weak IBOutlet UIButton *btnHome;
    __weak IBOutlet UIButton *btnVideo;
    
    __weak IBOutlet UISegmentedControl *segmentedControl;
    
    int index;

    __weak IBOutlet NSLayoutConstraint *constraintLogoTop;
}

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
