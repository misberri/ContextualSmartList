//
// Created by Agathe Battestini on 5/1/15.
// Copyright (c) 2015 Misberri. All rights reserved.
//

#import "MISSmartManager.h"
#import "MISSmartList.h"
#import "MISAPIManager.h"
#import "MISAPIManager+Context.h"
#import <RCLocationManager/RCLocationManager.h>


static MISSmartManager *sharedManager = nil;

@interface MISSmartManager()<RCLocationManagerDelegate>

@property (nonatomic, strong, readwrite) MISSmartList *smartList;

@property (nonatomic, strong, readwrite) RCLocationManager *locationManager;

@property (nonatomic, strong, readwrite) MISAPIManager *apiManager;

@property (nonatomic, strong, readwrite) NSNumber* currentContextId;

@end

@implementation MISSmartManager

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _smartList = [[MISSmartList alloc] init];
        [self setupSignals];
    }

    return self;
}

- (void)setupSignals {
    @weakify(self);

    [[[RACObserve(self, locationManager)
            ignore:nil]
            take:1]
            subscribeNext:^(RCLocationManager *manager) {
                [manager requestRegionLocationAlways];
            }];

    RACSignal *signal = [[[RACObserve(self, active) distinctUntilChanged] publish] autoconnect];
    RACSignal *activatedSignal = [signal ignore:@0];
    RACSignal *deactivatedSignal = [signal ignore:@1];


    // manages location updates: location is used to get the current context Id in which the user currently is
    RACSignal *locationSignal = [self rac_signalForSelector:@selector
    (locationManager:didUpdateToLocation:fromLocation:)];
    self.locationManager.delegate = self; // set after getting the signal

    // update the remote context engine, and save the current context Id
    RAC(self, currentContextId) = [[[[locationSignal
            map:^id(RACTuple *locationUpdateTuple) {
                // take only the new location
                return locationUpdateTuple.second;
            }]
            flattenMap:^RACStream *(CLLocation *location) {
                return [[[MISSmartManager sharedInstance] apiManager] rac_sendLocation:location];
            }]
            catch:^RACSignal *(NSError *error) {
                // ignore errors
                return [RACSignal return:nil];
            }]
            filter:^BOOL(id value) {
                // TODO either set contextId to 0 or keep the previous one?
                return value != nil;
            }];

    // when the current context Id changes, we update the list
//    RACSignal *newContextSignal = [RACObserve(self, currentContextId) distinctUntilChanged];


    // trigger the location based on activation
    [[activatedSignal
            doNext:^(id x) {
                @strongify(self);
                [self.locationManager startUpdatingLocation];
            }]
            subscribeNext:^(id x) {
                DDLogVerbose(@"STARTED geolocation");
    }];

    [[deactivatedSignal
            doNext:^(id x) {
                @strongify(self);
                [self.locationManager stopUpdatingLocation];
            }]
            subscribeNext:^(id x) {
                DDLogVerbose(@"STOPPED geolocation");
            }];


    // TODO something better for the server status (availability)
    [self.apiManager.statusSignal subscribeNext:^(id x) {
        DDLogInfo(@"Server status %@", x);
    }];


    self.smartListChangedSignal = [RACSignal
            merge:@[RACObserve(self, currentContextId),
                    self.smartList.listChangedSignal]];

}

- (RCLocationManager *)locationManager {
    if (!_locationManager){
        _locationManager = [[RCLocationManager alloc] initWithUserDistanceFilter:kCLLocationAccuracyHundredMeters
                                                             userDesiredAccuracy:kCLLocationAccuracyBestForNavigation
                                                                         purpose:@"Our app is so smart it needs your "
                                                                                 "location"
                                                                        delegate:nil];

    }
    return _locationManager;
}

- (MISAPIManager *)apiManager {
    if (!_apiManager){
        _apiManager = [[MISAPIManager alloc] init];
    }
    return _apiManager;
}

- (NSArray*)itemListForCurrentContext {
    return [self.smartList orderedListForContext:self.currentContextId];
}

@end