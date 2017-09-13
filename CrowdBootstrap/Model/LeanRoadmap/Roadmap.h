//
//  Roadmap.h
//  CrowdBootstrap
//
//  Created by Shikha Singla on 19/09/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Roadmap : NSObject

@property(nonatomic, assign) NSString *titelId;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) NSArray *color;
@property(nonatomic, strong) NSString *sampleLink;
@property(nonatomic, strong) NSString *templateLink;
@property(nonatomic, strong) NSString *direction;
@property(assign) int index;


@end
