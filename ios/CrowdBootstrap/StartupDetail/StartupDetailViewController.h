//
//  StartupDetailViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 12/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
enum VIEW_SELECTED{
    INTRO_SELECTED,
    TEAM_SELECTED,
    TIMESHEET_SELECTED,
    DOCS_SELECTED,
    STARTUP_DOCS_SELECTED
};

#define ROADMAP_DOC_TEXT                  @"Roadmap Docs"
#define NUMBER_OF_SEGMENTS_ENTREPRENEUR   5
#define NUMBER_OF_SEGMENTS_CONTRACTOR     4





@interface StartupDetailViewController : UIViewController
{
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UIView *introView;
    IBOutlet UIView *teamView;
    IBOutlet UIView *timesheetView;
    IBOutlet UIView *docsView;
    IBOutlet UIView *startupDocsView;
}
@property(nonatomic,strong) NSDictionary *dictionaryIDs;

- (IBAction)SegmentControl_ValueChanged:(id)sender ;

@end
