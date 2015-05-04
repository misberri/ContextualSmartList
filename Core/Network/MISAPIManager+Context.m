//
// Created by Agathe Battestini on 5/1/15.
// Copyright (c) 2015 Misberri. All rights reserved.
//

#import "MISAPIManager+Context.h"
#import "AFHTTPRequestOperationManager+RACSupport.h"
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>


@implementation MISAPIManager (Context)

/**
* Sends the location to the server, get something back
* TODO: use Mantle if needed to make it easy to deserialize the object: https://github.com/Mantle/Mantle
*/
- (RACSignal *)rac_sendLocation:(CLLocation*)location {

    NSString *path = @"api/action";
    NSDictionary *params = @{
            @"lat": @(location.coordinate.latitude),
            @"lon": @(location.coordinate.longitude),
            // etc
    };

    RACSignal *signal = [[self.httpClient rac_POST:path parameters:params]
            map:^id(RACTuple *JSONAndHeaders) {
                RACTupleUnpack(id json, NSHTTPURLResponse*response) = JSONAndHeaders;
                // TODO do stuff here if necessary, like transforming the thing into a Mantle object
                return json;
            }];
    return [signal setNameWithFormat:@"-rac_sendLocation:"];
}

@end