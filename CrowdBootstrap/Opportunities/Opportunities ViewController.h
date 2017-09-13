//
//  Opportunities ViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 15/06/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Opportunities_ViewController : UIViewController{
    IBOutlet UIBarButtonItem       *menuBarBtn;
    IBOutlet UITextView            *contentTextView;
    
}

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
