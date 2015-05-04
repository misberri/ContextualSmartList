//
// Created by Agathe Battestini on 5/1/15.
// Copyright (c) 2015 Misberri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface MISAPIManager : NSObject

@property (nonatomic, strong) NSURL *apiUrl;

@property (nonatomic, strong) AFHTTPRequestOperationManager *httpClient;

/// Subscribe to get the status of the client. Sends a RACTuple(BOOL ok_ko, NSString reachabilityErrorIfAny)
@property (nonatomic, strong) RACSubject *statusSignal;


@end