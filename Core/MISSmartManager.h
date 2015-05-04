//
// Created by Agathe Battestini on 5/1/15.
// Copyright (c) 2015 Misberri. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MISSmartList;
@class CDVBackgroundGeoLocation;
@class MISAPIManager;


@interface MISSmartManager : NSObject

@property (nonatomic, strong, readonly) MISSmartList *smartList;

@property (nonatomic, strong, readonly) MISAPIManager *apiManager;

@property (nonatomic, strong, readonly) NSNumber* currentContextId;

@property (nonatomic, strong) RACSignal *smartListChangedSignal;



@property (nonatomic, assign) BOOL active;


+ (id)sharedInstance;

- (NSArray *)itemListForCurrentContext;
@end