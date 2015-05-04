//
// Created by Agathe Battestini on 5/1/15.
// Copyright (c) 2015 Misberri. All rights reserved.
//

#import "MISAPIManager.h"
#import <AFNetworking-RACExtensions/RACAFNetworking.h>

@implementation MISAPIManager {

}

/**
* See https://github.com/AFNetworking/AFNetworking and https://github.com/CodaFi/AFNetworking-RACExtensions
*/
- (instancetype)init {
    self = [super init];
    if (self) {
        self.apiUrl = [[NSURL alloc] initWithString:@"https://api.server.com"]; /// TODO set the right URL

        // client to send requests to the backend
        self.httpClient = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:self.apiUrl];
        self.httpClient.responseSerializer = [AFJSONResponseSerializer serializer];
        self.httpClient.requestSerializer = [AFJSONRequestSerializer serializer];

        // uses a signal to notify of reachability changes
        _statusSignal = [RACSubject subject];
        [self.httpClient.networkReachabilityStatusSignal subscribeNext:^(NSNumber *status) {
            AFNetworkReachabilityStatus networkStatus = (AFNetworkReachabilityStatus)[status intValue];
            switch (networkStatus) {
                case AFNetworkReachabilityStatusUnknown:
                case AFNetworkReachabilityStatusNotReachable:
                    [self.statusSignal sendNext:RACTuplePack(@0, @"Cannot Reach Host")];
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [self.statusSignal sendNext:RACTuplePack(@1, nil)];
                    break;
            }
        }];
    }

    return self;
}

@end