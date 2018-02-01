//
//  MapViewController.h
//  CrowdBootstrap
//
//  Created by Shikha on 14/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    __weak IBOutlet MKMapView *mkMapView;

    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UISearchBar *searchBar;
    __weak IBOutlet UIButton *btnShow;
    __weak IBOutlet UIButton *btnHide;
    __weak IBOutlet UIButton *btnAvailability;
    __weak IBOutlet UIButton *btnSearch;

    
    // Variables
    NSMutableArray                         *connectionTypeArray ;
    NSString                               *selectedConnectionTypeID ;
    
    NSMutableArray                         *usersArray ;
    NSMutableArray                         *userStatusArray ;
    NSMutableArray                         *searchResults ;
    NSString                               *searchedString ;

    CLLocationManager                      *locationManager;
    float                                  latitude;
    float                                  longitude;
    
    NSString                               *availabilityStatus;
    NSString                               *visibilityStatus;
    NSString                               *arrType;
    BOOL                                   isSearch;
    NSString                               *userStatement;
}

@end
