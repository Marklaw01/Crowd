//
//  AddContactViewController.h
//  CrowdBootstrap
//
//  Created by Shikha on 08/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddContactViewController : UIViewController
{
    // --- IBOutlets ---
    IBOutlet UIView                     *vwSearchConnection ;
    IBOutlet UIView                     *vwAddNewUser ;
    __weak IBOutlet UISegmentedControl *segmentControl;

    // --- Variables ---
    NSInteger                                selectedSegment;
}
@end
