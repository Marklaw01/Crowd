//
//  MapViewController.m
//  CrowdBootstrap
//
//  Created by Shikha on 14/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "MapViewController.h"
#import "UIImageView+WebCache.h"
#import "JPSThumbnailAnnotation.h"
#import "CustomTableViewCell.h"

@interface MapViewController ()

@end

@implementation MapViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    latitude = locationManager.location.coordinate.latitude;
    longitude = locationManager.location.coordinate.longitude;
    
    searchBar.delegate = self;
    
    [self resetUISettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void) addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNotificationIconOnNavigationBar:)name:kNotificationIconOnNavigationBar
                                               object:nil];
}

-(void)setNotificationIconOnNavigationBar:(NSNotification *) notification {
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"notifications"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navigateToNotification_Click:)forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblNotificationCount = [[UILabel alloc]init];
    
    [UtilityClass setNotificationIconOnNavigationBar:button
                                lblNotificationCount:lblNotificationCount navItem:self.navigationItem];
}

- (void)resetUISettings {
    // Initialize Array
    connectionTypeArray = [[NSMutableArray alloc] init] ;
    usersArray = [[NSMutableArray alloc] init] ;
    userStatusArray = [[NSMutableArray alloc] initWithObjects:
                       @"Available",
                       @"DND",
                       @"Busy", nil];
    
    arrType = @"Availability";
    mkMapView.delegate = self;

    [self getBusinessConnectionTypeList];
    [self getUserListWithinMiles:@"" connectionId:@""];
}

-(void)addAllPins
{
    if(![searchBar.text isEqualToString:@""]) {
        for (int i=0; i<searchResults.count; i++) {
            NSDictionary *dict = [searchResults objectAtIndex:i];
            [self addPinWithTitle:dict];
        }
    }
    else {
        for (int i=0; i<usersArray.count; i++) {
            NSDictionary *dict = [usersArray objectAtIndex:i];
            [self addPinWithTitle:dict];
        }
    }
}

-(void)addPinWithTitle:(NSDictionary *)dictUser
{
    // setup the map pin with all data and add to map view
    JPSThumbnail *thumbnail = [[JPSThumbnail alloc] init];
    
    // Set User Name with Image
    NSString *annotationType = [dictUser valueForKey:@"type"];
    if ([annotationType isEqualToString:@"multiple"]) {
        thumbnail.title = [NSString stringWithFormat:@"%@ Users found", [dictUser valueForKey:@"count"]];
        thumbnail.image = [UIImage imageNamed:@"google_group.png"];
        thumbnail.imageUser = [UIImage imageNamed:@"group-icon.png"];
    }
    else {
        thumbnail.title = [dictUser valueForKey:kBusinessAPI_UserName];
        thumbnail.image = [UIImage imageNamed:@"map-pin.png"];
        NSString *strImage = [NSString stringWithFormat:@"%@%@", APIPortToBeUsed, [dictUser valueForKey:kBusinessAPI_UsrImage]];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strImage]];
        thumbnail.imageUser = [UIImage imageWithData:imageData];
    }
    
    // Set Coordinates
    double latitude = [[dictUser valueForKey:kBusinessAPI_Latitude] doubleValue];
    double longitude = [[dictUser valueForKey:kBusinessAPI_Longitude] doubleValue];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    thumbnail.coordinate = coordinate;
    
    // Set Visibility Status
    NSString *strStatus = [NSString stringWithFormat:@"%@",[dictUser valueForKey:kBusinessAPI_VisibilityStatus]];
    if ([strStatus isEqualToString:@"1"])
        thumbnail.subtitle = @"Available";
    else if ([strStatus isEqualToString:@"2"])
        thumbnail.subtitle = @"Do not disturb";
    else
        thumbnail.subtitle = @"Busy";

    // Set User Statement
    NSString *statement = [dictUser valueForKey:kBusinessAPI_UserStatement];
    thumbnail.statement = statement;
    
    thumbnail.disclosureBlock = ^{
        NSLog(@"selected marker");
        if ([annotationType isEqualToString:@"multiple"]) {
            
            // Redirect to New Connections Screen; after selecting connection go to business detail screen
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NetworkingOptions" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kBusinessConnectionListIdentifier] ;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendConnections object:@"ConnectionList" userInfo:dictUser];
            
            [self.navigationController pushViewController:viewController animated:true];

        } else {
            NSString *strCardId = [NSString stringWithFormat:@"%@",[dictUser valueForKey:kBusinessAPI_CardId]];
            if ([strCardId isEqualToString:@""]) {
                [self presentViewController:[UtilityClass displayAlertMessage:@"No Business Card Found!!"] animated:YES completion:nil];
            } else {
                // go to business detail screen
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NetworkingOptions" bundle:nil];
                UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kBusinessCardDetailIdentifier] ;

                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendCardInfo object:@"CardDetail" userInfo:dictUser];
            
                [self.navigationController pushViewController:viewController animated:true];
            }
        }
    };
    
    [mkMapView addAnnotation:[JPSThumbnailAnnotation annotationWithThumbnail:thumbnail]];
}

#pragma mark - Map View Delegate Methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)btnShowHide_Click:(id)sender {
    NSInteger status = [sender tag];
    [self setUserAvailabilityStatus:[NSString stringWithFormat:@"%ld",(long) status]];
}

- (IBAction)btnAvailability_Click:(id)sender {
    arrType = @"Availability";
    [btnAvailability setBackgroundColor:[UIColor colorWithRed:5.0/255.0 green:106.0/255.0 blue:31.0/255.0 alpha:1.0]];
    [btnSearch setBackgroundColor:[UIColor lightGrayColor]];

    [tblView reloadData];
}

- (IBAction)btnSearch_Click:(id)sender {
    arrType = @"Search";
    [tblView reloadData];
    [btnSearch setBackgroundColor:[UIColor colorWithRed:5.0/255.0 green:106.0/255.0 blue:31.0/255.0 alpha:1.0]];
    [btnAvailability setBackgroundColor:[UIColor lightGrayColor]];
}

- (IBAction)btnCell_Click:(id)sender {
    
    NSInteger index = [sender tag];
    
        if ([arrType isEqualToString:@"Availability"]) {
            NSString *status = [NSString stringWithFormat:@"%ld", (long)index+1];
            [self setUserVisibilityStatus:status];
        } else {
            selectedConnectionTypeID = [[connectionTypeArray objectAtIndex:index] valueForKey:@"id"];
            [self getUserListWithinMiles:@"" connectionId:selectedConnectionTypeID];
        }
    
}

//MARK: - UISearchbar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearch = true;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    isSearch = false;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    isSearch = false;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    isSearch = false;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0)
        isSearch = false;
    else
        isSearch = true;
    
    if (selectedConnectionTypeID != nil)
        [self getUserListWithinMiles:searchText connectionId:selectedConnectionTypeID];
    else
        [self getUserListWithinMiles:searchText connectionId:@""];
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([arrType isEqualToString:@"Availability"])
        return userStatusArray.count ;
    else
        return connectionTypeArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"] ;

    cell.tag = indexPath.row;
    cell.btnTitle.tag = indexPath.row;
    
    if ([arrType isEqualToString:@"Availability"]) {
        [cell.btnTitle setTitle:[NSString stringWithFormat:@"  %@", [userStatusArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
        if (indexPath.row+1 == [visibilityStatus intValue])
            [cell.btnTitle setImage:[UIImage imageNamed:@"radio_fill"] forState:UIControlStateNormal];
        else
            [cell.btnTitle setImage:[UIImage imageNamed:@"radio_blank"] forState:UIControlStateNormal];
    }
    else {
        [cell.btnTitle setTitle:[NSString stringWithFormat:@"  %@", [[connectionTypeArray objectAtIndex:indexPath.row] valueForKey:@"name"]] forState:UIControlStateNormal];
        if (selectedConnectionTypeID == nil) {
            [cell.btnTitle setImage:[UIImage imageNamed:@"radio_blank"] forState:UIControlStateNormal];
        } else {
            if([[[connectionTypeArray objectAtIndex:indexPath.row] objectForKey:@"id"] intValue] == [selectedConnectionTypeID intValue]) {
                [cell.btnTitle setImage:[UIImage imageNamed:@"radio_fill"] forState:UIControlStateNormal];
            } else {
                [cell.btnTitle setImage:[UIImage imageNamed:@"radio_blank"] forState:UIControlStateNormal];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([arrType isEqualToString:@"Availability"]) {
        NSString *status = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
        [self setUserVisibilityStatus:status];
    } else {
        selectedConnectionTypeID = [[connectionTypeArray objectAtIndex:indexPath.row] valueForKey:@"id"];
        [self getUserListWithinMiles:@"" connectionId:selectedConnectionTypeID];
    }
}

#pragma mark - API Methods

-(void)getBusinessConnectionTypeList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getBusinessConnectionTypeListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kBusinessAPI_ConnectionType]) {
                    [connectionTypeArray removeAllObjects];
                    
                    [connectionTypeArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBusinessAPI_ConnectionType]] ;
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                
                connectionTypeArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBusinessAPI_ConnectionType]] ;
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)setUserAvailabilityStatus:(NSString *)status {
    if([UtilityClass checkInternetConnection]) {
        //        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        float latitude = locationManager.location.coordinate.latitude;
        float longitude = locationManager.location.coordinate.longitude;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%f", latitude] forKey:kBusinessAPI_Latitude] ;
        [dictParam setObject:[NSString stringWithFormat:@"%f", longitude] forKey:kBusinessAPI_Longitude] ;
        [dictParam setObject:status forKey:kBusinessAPI_Status] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap setUserAvailabilityStatusWithParameters:dictParam success:^(NSDictionary *responseDict) {
            //            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                NSLog(@"Response: %@",responseDict) ;
                
                availabilityStatus = status;
                if ([availabilityStatus isEqualToString:@"1"]) {
                    [btnHide setBackgroundColor:[UIColor lightGrayColor]];
                    [btnShow setBackgroundColor:[UIColor colorWithRed:5.0/255.0 green:106.0/255.0 blue:31.0/255.0 alpha:1.0]];
                } else {
                    [btnShow setBackgroundColor:[UIColor lightGrayColor]];
                    [btnHide setBackgroundColor:[UIColor colorWithRed:5.0/255.0 green:106.0/255.0 blue:31.0/255.0 alpha:1.0]];
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            //            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)setUserVisibilityStatus:(NSString *)status {
    if([UtilityClass checkInternetConnection]) {
        //        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        [dictParam setObject:status forKey:kBusinessAPI_VisibilityStatus] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap setUserVisibilityStatusWithParameters:dictParam success:^(NSDictionary *responseDict) {
            //            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                NSLog(@"Response: %@",responseDict) ;
                visibilityStatus = status;
                [tblView reloadData];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            //            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getUserListWithinMiles:(NSString *)searchText connectionId: (NSString *)connectionId {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%f", latitude] forKey:kBusinessAPI_Latitude] ;
        [dictParam setObject:[NSString stringWithFormat:@"%f", longitude] forKey:kBusinessAPI_Longitude] ;
        [dictParam setObject:connectionId forKey:kBusinessAPI_ConnectionId] ;
        [dictParam setObject:searchText forKey:kBusinessAPI_SearchText] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getUserListWithinMilesWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"Response: %@",responseDict) ;
            
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                availabilityStatus = [responseDict valueForKey:kBusinessAPI_AvailabilityStatus];
                visibilityStatus = [responseDict valueForKey:kBusinessAPI_VisibilityStatus];
                
                [searchResults removeAllObjects];
                [usersArray removeAllObjects];
                
                if(![searchBar.text isEqualToString:@""]) {
                    searchResults = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBusinessAPI_UserList]] ;
                }
                else {
                    [usersArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBusinessAPI_UserList]] ;
                }
                
                if ([availabilityStatus isEqual:[NSNumber numberWithInt:1]]) {
                    [btnHide setBackgroundColor:[UIColor lightGrayColor]];
                    [btnShow setBackgroundColor:[UIColor colorWithRed:5.0/255.0 green:106.0/255.0 blue:31.0/255.0 alpha:1.0]];
                    
                } else {
                    [btnShow setBackgroundColor:[UIColor lightGrayColor]];
                    [btnHide setBackgroundColor:[UIColor colorWithRed:5.0/255.0 green:106.0/255.0 blue:31.0/255.0 alpha:1.0]];
                }
                
                [mkMapView removeAnnotations:mkMapView.annotations];
                [self addAllPins];
                [tblView reloadData];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode) {
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

-(void)getUserListWithSameLatLong {
    if([UtilityClass checkInternetConnection]) {
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        float latitude = locationManager.location.coordinate.latitude;
        float longitude = locationManager.location.coordinate.longitude;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        [dictParam setObject:[NSString stringWithFormat:@"%f", latitude] forKey:kBusinessAPI_Latitude] ;
        [dictParam setObject:[NSString stringWithFormat:@"%f", longitude] forKey:kBusinessAPI_Longitude] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getUserListWithSameLatLongWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode) {
                
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode)
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}
@end
