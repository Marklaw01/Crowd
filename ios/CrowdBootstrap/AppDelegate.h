//
//  AppDelegate.h
//  CrowdBootstrap
//
//  Created by OSX on 06/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"

/*const NSUInteger kQuickblox_ApplicationID               = 41172;
NSString *const kQuickblox_AuthKey                      = @"atp85LpFMSSk-My";
NSString *const kQuickblox_AuthSecret                   = @"xu5sSy6uPsf9BA5";
NSString *const kQuickblox_AccountKey                   = @"aNstpqyjBhYp2zTd4HFR";*/

#define kDefault_DeviceToken                @"9aa9f0dfdc2d494a3059067da9b29c350e0e7084a2e754ef2699e0714d72f75b"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow                *window;
@property (strong, nonatomic) NSString                *userType ;
@property (nonatomic,strong) CoreDataManager          *coreDataManager;
@property (nonatomic,strong) NSString                 *selectedTag ;
@property (nonatomic,strong) NSDictionary             *pushTagValueDict ;
@property (nonatomic,strong) NSString             *strNotificationCount ;

+ (AppDelegate *)appDelegate;


@end

