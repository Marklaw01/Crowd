//
//  StartupDetailViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 12/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "StartupDetailViewController.h"


@interface StartupDetailViewController ()

@end

@implementation StartupDetailViewController
@synthesize dictionaryIDs;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetUISettings] ;
    [self setSegmentControlSettings] ;
    if([UtilityClass getStartupWorkOrderType] == YES) {
        [self resetViewAccordingToSelectedSegment:TIMESHEET_SELECTED] ;
    }
    if([[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:@"isComeFromFeeds"]] isEqualToString:@"true"]) {
        [self resetViewAccordingToSelectedSegment:TEAM_SELECTED] ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings {
    
    [self resetStartupName] ;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kNotificationStartupOverview
     object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStartupNameNotification:)
                                                 name:kNotificationUpdateStartupName
                                               object:nil];
}

-(void)resetStartupName {
     self.title = [NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupsAPI_StartupName]] ;
}

-(void)setSegmentControlSettings {
    
    UIFont *font ;
    if([[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupsAPI_isEntrepreneur]] isEqualToString:@"true"]) {
        if(segmentedControl.numberOfSegments < NUMBER_OF_SEGMENTS_ENTREPRENEUR)[segmentedControl insertSegmentWithTitle:ROADMAP_DOC_TEXT atIndex:segmentedControl.numberOfSegments animated:NO] ;
       font = [UIFont boldSystemFontOfSize:7.0f];
    }
    else{
         if(segmentedControl.numberOfSegments > NUMBER_OF_SEGMENTS_CONTRACTOR)[segmentedControl removeSegmentAtIndex:segmentedControl.numberOfSegments-1 animated:NO] ;
        
         font = [UIFont boldSystemFontOfSize:11.0f];
    }
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segmentedControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
}

-(void)resetViewAccordingToSelectedSegment:(int)selectedSegment {
    // hide all views
    introView.hidden = YES ;
    teamView.hidden = YES ;
    timesheetView.hidden = YES ;
    docsView.hidden = YES ;
    startupDocsView.hidden = YES ;
    
    [introView endEditing:YES] ;
    [timesheetView endEditing:YES] ;
    [segmentedControl setSelectedSegmentIndex:selectedSegment] ;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kNotificationStartupDisableTextField
     object:self];
    
    switch (selectedSegment) {
            
        case INTRO_SELECTED:{
            introView.hidden = NO ;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotificationStartupOverview
             object:self];
            break;
        }
        case TEAM_SELECTED:{
            teamView.hidden = NO ;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotificationStartupTeam
             object:self];
            break;
        }
        case TIMESHEET_SELECTED:{
            timesheetView.hidden = NO ;
            if([[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupsAPI_isEntrepreneur]] isEqualToString:@"true"]) // Enterpreneur
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStartupWorkOrderEnt object:self];
            else // Contractor
                [[NSNotificationCenter defaultCenter]
                   postNotificationName:kNotificationStartupWorkOrderCont
                   object:dictionaryIDs];
           
            break;
        }
        case DOCS_SELECTED:{
            docsView.hidden = NO ;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotificationStartupDocs
             object:self];
            break;
        }
        case STARTUP_DOCS_SELECTED:{
            startupDocsView.hidden = NO ;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotificationStartupRoadmapDocs
             object:self];
            break;
        }
            
        default:
            break;
    }
    
}

#pragma mark - Notifcation Methods
- (void)updateStartupNameNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:kNotificationUpdateStartupName]){
        
        [self resetStartupName] ;
    }
}

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)SegmentControl_ValueChanged:(id)sender {
    [self resetViewAccordingToSelectedSegment:(int)segmentedControl.selectedSegmentIndex] ;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
