//
//  ResourcesViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 14/03/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResourcesViewController : UIViewController{
    IBOutlet UIBarButtonItem       *menuBarBtn;
    IBOutlet UITextView            *contentTextView;
    
}
-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content ;

@end
