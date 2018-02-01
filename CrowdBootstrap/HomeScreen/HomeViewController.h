//
//  HomeViewController.h
//  CrowdBootstrap
//
//  Created by Shikha on 22/05/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

enum VIEW_SELECTED {
    HOME_INFO_SELECTED,
    NEWS_SELECTED,
    ALERTS_SELECTED,
    NETWORKING_OPTIONS_SELECTED
};
/*
 ** Home - Home Info
 ** News - Blog Posts
 ** Alerts - Feeds
 ** Networking Options
 */

@interface HomeViewController : UIViewController
{
    IBOutlet UIBarButtonItem *menuBarBtn;
    IBOutlet UIBarButtonItem *notificationsBarBtn;

    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UIView *homeInfoView;
    IBOutlet UIView *feedsView;
    IBOutlet UIView *newsView;
    IBOutlet UIView *networkingOptionsView;
    IBOutlet UIView *startView;
    
    int userId;
}
@property int selectedIndex;
@property BOOL isComingFromStart;
@end
