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
    IBOutlet UIView                     *vwNewUsers ;


    // --- Variables ---
    NSInteger                                selectedSegment;
}
@property(nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end
