//
//  CDTestEntity.h
//  CoreDataManager
//
//  Created by hirokiumatani on 2015/11/09.
//  Copyright © 2015年 hirokiumatani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CDTestEntity : NSManagedObject

@property (nonatomic, strong) NSString *note_title;
@property (nonatomic, strong) NSString *note_desc;
@property (nonatomic, strong) NSString *note_startupid ;
@property (nonatomic, strong) NSString *note_date ;
@property (nonatomic, strong) NSNumber *id;
@end


