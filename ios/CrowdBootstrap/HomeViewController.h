//
//  HomeViewController.h
//  CrowdBootstrap
//
//  Created by Shikha on 22/05/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

enum VIEW_SELECTED{
    FEEDS_SELECTED,
    INFO_SELECTED
};


@interface HomeViewController : UIViewController
{
    IBOutlet UIBarButtonItem *menuBarBtn;
    IBOutlet UIBarButtonItem *notificationsBarBtn;

    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UIView *homeInfoView;
    IBOutlet UIView *feedsView;

}
@end
