//
// Created by Agathe Battestini on 5/1/15.
// Copyright (c) 2015 Misberri. All rights reserved.
//

#import "MISSmartListItem.h"


@interface MISSmartListItem ()
@end

@implementation MISSmartListItem {

}

- (instancetype)initWithName:(NSString*)name withCurrentContext:(NSNumber*)contextId {
    self = [super init];
    if (self) {
        self.name = name;
        [self updateWithCurrentContext:contextId];
    }
    return self;
}

- (instancetype)initWithName:(NSString*)name {
    self = [self initWithName:name withCurrentContext:nil];
    if (self) {
    }
    return self;
}


+ (instancetype)newWithName:(NSString*)name {
    return [[MISSmartListItem alloc] initWithName:name];
}


#pragma mark - Context management

- (void)updateWithCurrentContext:(NSNumber*)contextId {
    if(!contextId) return;

    // total count across all contexts + 1 for the new one
    RACSequence * counts = [[self.weightedContexts rac_sequence]
             scanWithStart:@(0) reduce:^id(NSNumber* running, RACTuple *next) {
                 RACTuple *weight_count = next.second;
                 return @(running.integerValue + [weight_count.second integerValue]);
             }];
    NSInteger totalCount = [[counts.array lastObject] integerValue] + 1; // adding this one

    // update the list
    NSMutableDictionary *newWeightedContexts = [self.weightedContexts mutableCopy];
    if (!self.weightedContexts[contextId]) {
        newWeightedContexts[contextId] = RACTuplePack(@(0.0f), @(1));
    }
    for (NSNumber *key in newWeightedContexts.keyEnumerator) {
        RACTuple *value = newWeightedContexts[key];
        NSInteger count = [value.second integerValue];
        RACTuple *newTuple = RACTuplePack(@(count / (CGFloat)totalCount), @(count));
        newWeightedContexts[key] = newTuple;
    };

    // set the new weighted list of contexts
    self.weightedContexts = newWeightedContexts;
}

- (NSNumber *)weightForContext:(NSNumber*)contextId {
    RACTuple *value = self.weightedContexts[contextId];
    return value != nil ? value.first : @(0.0f);
}
@end