//
// Created by Agathe Battestini on 5/1/15.
// Copyright (c) 2015 Misberri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MISAPIManager.h"

@interface MISAPIManager (Context)

- (RACSignal *)rac_sendLocation:(CLLocation *)location;

@end